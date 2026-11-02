sealed class LudyxBundleConfig();

class LudyxBundleRemoteConfig({
  required final String baseUrl,
  final String authorization = '',
  required final String publicKey,
  required final String aesKey,
}) extends LudyxBundleConfig;

class LudyxBundleAssetConfig({
  required final String bundlePath,
}) extends LudyxBundleConfig;
