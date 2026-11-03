/// `LudyxBundleConfig` used to define config while initialize ludyx itself
sealed class LudyxBundleConfig {}

/// `LudyxBundleRemoteConfig` use when script source is from remote server
class LudyxBundleRemoteConfig({
  required final String baseUrl,
  final String authorization = '',
  required final String publicKey,
  required final String aesKey,
}) extends LudyxBundleConfig;

/// `LudyxBundleAssetConfig` use when script source is from bundle asset
class LudyxBundleAssetConfig({
  required final String bundlePath,
}) extends LudyxBundleConfig {}
