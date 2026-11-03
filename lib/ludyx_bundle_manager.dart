import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_ludyx/ludyx_bundle_config.dart';

/// `LudyxBundleManager` help to manage active scripts
class LudyxBundleManager {
  static final Map<String, String> _loadedScripts = {};
  static String? _activeVersion;

  /// any scripts loaded will be stored on `loadedScripts`
  static Map<String, String> get loadedScripts => Map.unmodifiable(_loadedScripts);

  static Future<bool> _syncFromAsset({
    required LudyxBundleAssetConfig config,
  }) async {
    final AssetManifest assetManifest = await AssetManifest.loadFromAssetBundle(
      rootBundle,
    );

    final List<String> luaFiles = assetManifest
        .listAssets()
        .where(
          (path) => path.startsWith(config.bundlePath) && path.endsWith('.lua'),
        )
        .toList();

    await Future.wait(
      luaFiles.map((path) async {
        String cleanPath = path.replaceFirst(config.bundlePath, '');
        if (cleanPath.startsWith('/')) {
          cleanPath = cleanPath.replaceFirst('/', '');
        }
        _loadedScripts[cleanPath] = await rootBundle.loadString(path);
      }),
    );

    return true;
  }

  static Future<bool> _syncFromRemote({
    required LudyxBundleRemoteConfig config,
  }) async {
    try {
      // 1. Fetch manifest
      final manifestUri = Uri.parse('${config.baseUrl}/manifest.json');
      final manifestRes = await http.get(manifestUri);

      if (manifestRes.statusCode != 200) {
        debugPrint(
          '[BundleManager] No manifest found (HTTP ${manifestRes.statusCode})',
        );
        return false;
      }

      final Map<String, dynamic> manifest = jsonDecode(manifestRes.body);
      final String version = manifest['version'];
      final String bundlePath = manifest['bundleUrl'];
      final String base64Signature = manifest['signature'];

      // Avoid re-downloading if already loaded in memory
      if (_activeVersion == version) {
        debugPrint('[BundleManager] Bundle $version is already up to date.');
        return true;
      }

      // 2. Download encrypted binary payload
      final bundleUri = Uri.parse('${config.baseUrl}$bundlePath');
      final bundleRes = await http.get(bundleUri);

      if (bundleRes.statusCode != 200) {
        throw Exception(
          'Failed to download bundle file: HTTP ${bundleRes.statusCode}',
        );
      }

      final Uint8List encryptedPayload = bundleRes.bodyBytes;

      // 3. Verify Ed25519 signature
      final ed25519 = Ed25519();
      final publicKey = SimplePublicKey(
        base64Decode(config.publicKey),
        type: KeyPairType.ed25519,
      );

      final signatureBytes = base64Decode(base64Signature);
      final isValid = await ed25519.verify(
        encryptedPayload,
        signature: Signature(signatureBytes, publicKey: publicKey),
      );

      if (!isValid) {
        throw StateError(
          'Signature check failed! Bundle was tampered with or corrupted.',
        );
      }
      debugPrint('[BundleManager] Signature verified successfully.');

      // 4. Decrypt AES-256-GCM payload
      // Payload structure: [12 bytes IV] + [16 bytes Tag] + [Ciphertext]
      final iv = encryptedPayload.sublist(0, 12);
      final authTag = encryptedPayload.sublist(12, 28);
      final cipherText = encryptedPayload.sublist(28);

      final aesGcm = AesGcm.with256bits();
      final secretKey = SecretKey(base64Decode(config.aesKey));

      final decryptedBytes = await aesGcm.decrypt(
        SecretBox(cipherText, nonce: iv, mac: Mac(authTag)),
        secretKey: secretKey,
      );

      // 5. Unpack Zip into RAM cache
      final archive = ZipDecoder().decodeBytes(decryptedBytes);
      _loadedScripts.clear();

      for (final file in archive) {
        if (file.isFile) {
          // Normalize path: e.g. "view/home.lua" or "main.lua"
          final pathKey = file.name.replaceAll('\\', '/');
          _loadedScripts[pathKey] = utf8.decode(file.content as List<int>);
        }
      }

      _activeVersion = version;
      debugPrint(
        '[BundleManager] Loaded ${_loadedScripts.length} scripts from bundle $version into memory.',
      );
      return true;
    } catch (e, st) {
      debugPrint('[BundleManager] Error syncing bundle: $e\n$st');
      return false;
    }
  }

  /// load scripts from given `LudyxBundleConfig`
  static Future<bool> syncAndLoad({required LudyxBundleConfig config}) async {
    return switch (config) {
      LudyxBundleRemoteConfig() => _syncFromRemote(config: config),
      LudyxBundleAssetConfig() => _syncFromAsset(config: config),
    };
  }

  /// used internally to resolve `require` import inside the script
  static String? load(String module) {
    final rpath = module.replaceAll('.', '/');
    String path = '$rpath.lua';
    if (!loadedScripts.containsKey(path)) {
      path = '$rpath/init.lua';
    }

    return loadedScripts[path];
  }

  /// used internally to load main entrypoint of the script
  static String loadMain(String path) {
    return _loadedScripts[path]!;
  }
}
