import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_ludyx/ludyx_bundle_config.dart';
import 'package:lua_dardo_plus/lua.dart';

class LudyxBundleManager {
  static final Map<String, String> _loadedScripts = {};
  static String? _activeVersion;

  static Map<String, String> get loadedScripts => _loadedScripts;
  static String? get activeVersion => _activeVersion;

  static Future<bool> syncAndLoad({
    required LudyxBundleConfig config,
    String channel = 'production',
  }) async {
    try {
      // 1. Fetch manifest
      final manifestUri = Uri.parse(
        '${config.baseUrl}/manifest.json?channel=$channel',
      );
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

  void setupLuaModuleSearcher(LuaState ls) {
    ls.getGlobal('package');
    ls.getField(-1, 'searchers');
    final int searchersTableIndex = ls.getTop();

    // Push custom searcher function
    ls.pushDartFunction((LuaState state) {
      final String moduleName = state.toStr(1)!;
      final String pathKey = '${moduleName.replaceAll('.', '/')}.lua';

      // 1. Check in-memory bundle first
      final memoryCode = LudyxBundleManager.loadedScripts[pathKey];
      if (memoryCode != null) {
        state.loadString(memoryCode);
        return 1; // Pushes loaded chunk
      }

      // 2. Return lookup failure message for standard package loader chain
      state.pushString("\n\tno dynamic bundle file '$pathKey'");
      return 1;
    });

    // Prepend searcher at index 2 (just after package.preload)
    final int len = ls.rawLen(searchersTableIndex);
    for (int i = len; i >= 2; i--) {
      ls.rawGetI(searchersTableIndex, i);
      ls.rawSetI(searchersTableIndex, i + 1);
    }
    ls.rawSetI(searchersTableIndex, 2);

    ls.pop(2); // Pop 'package' and 'searchers'
  }

  static String? load(String module) {
    final rpath = module.replaceAll('.', '/');
    String path = '$rpath.lua';
    if (!loadedScripts.containsKey(path)) {
      path = '$rpath/init.lua';
    }

    return loadedScripts[path];
  }

  static String loadMain([String? path]) {
    return _loadedScripts[path ?? 'main.lua']!;
  }
}
