abstract class ISecureStorageService {
  Future<void> setSecureString(String key, String value);
  Future<String?> getSecureString(String key);
  Future<void> removeSecureString(String key);
}
