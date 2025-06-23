import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:boilerplate_template/shared/storage/secure_storage/interfaces/i_secure_storage_service.dart';

class SecureStorageService implements ISecureStorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Future<void> setSecureString(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  @override
  Future<String?> getSecureString(String key) async {
    return await _secureStorage.read(key: key);
  }

  @override
  Future<void> removeSecureString(String key) async {
    await _secureStorage.delete(key: key);
  }
}
