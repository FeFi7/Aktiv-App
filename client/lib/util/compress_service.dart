import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';
import 'package:pdf_compressor/pdf_compressor.dart';
import 'package:path/path.dart' as path;

Future<File> compressImage(File file) async {
  var newFileName = "compressed_" + path.basename(file.path);

  var dir = path.dirname(file.path);
  var newPath = path.join(dir, newFileName);

  var result = await FlutterImageCompress.compressAndGetFile(file.path, newPath,
      quality: 50);

  print("Before Image compressing: " + file.lengthSync().toString());
  print(file.path);
  print("After Image compressing: " + result.lengthSync().toString());
  print(result.path);

  return result;
}

Future<File> compressPDF(File file) async {
  var newFileName = "compressed_" + path.basename(file.path);

  var dir = path.dirname(file.path);
  var newPath = path.join(dir, newFileName);

  await PdfCompressor.compressPdfFile(file.path, newPath, CompressQuality.HIGH);

  print("Before PDF compressing: " + file.lengthSync().toString());
  print(file.path);
  print("After PDF compressing: " + file.lengthSync().toString());
  print(newPath);

  return File(newPath);
}
