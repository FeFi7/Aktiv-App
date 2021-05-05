import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  // Erstelle storage
  final _storage = FlutterSecureStorage();

  // Schreibe neue Value
  Future write(String key, String value) async {
    var writeData = await _storage.write(key: key, value: value);
    return writeData;
  }

  // Lese Value
  Future read(String key) async {
    var readData = await _storage.read(key: key);
    return readData;
  }

  // Lösche Value
  Future delete(String key) async {
    var deleteData = await _storage.delete(key: key);
    return deleteData;
  }

  // Lese alle Values
  Future readAll() async {
    var readAllData = await _storage.readAll();
    return readAllData;
  }

  // Lösche alle Values
  Future deleteAll() async {
    var deleteAllData = await _storage.deleteAll();
    return deleteAllData;
  }
}
