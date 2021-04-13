import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = FlutterSecureStorage();

  Future write(String key, String value) async {
    var writeData = await _storage.write(key: key, value: value);
    return writeData;
  }

  Future read(String key) async {
    var readData = await _storage.read(key: key);
    return readData;
  }

  Future delete(String key) async {
    var deleteData = await _storage.delete(key: key);
    return deleteData;
  }

  Future readAll() async {
    var readAllData = await _storage.readAll();
    return readAllData;
  }

  Future deleteAll() async {
    var deleteAllData = await _storage.deleteAll();
    return deleteAllData;
  }
}
