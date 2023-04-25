
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:android_path_provider/android_path_provider.dart';

class StorageHelper {

  /* path */

  static Future<String> get _localPath async {
    final directory = await AndroidPathProvider.documentsPath;
    print(directory);
    return directory;
  }

  static Future<File> get _localFile async{
    final path = await _localPath;
    return File("$path/fullDataList.txt");
  }

  /* Read File */

  // static Future<String> readFromFile(String fileName) async {
  //   final file = await _getLocalFile(fileName);
  //   return file.readAsString();
  // }

  /* Write File */

  static Future<File> writeTextToFile(String data) async {
    final file = await _localFile;
    print("Escribiendo");
    return file.writeAsString("$data");
  }

  // static Future<File> writeBytesToFile(String fileName, Uint8List data) async {
  //   final file = await _getLocalFile(fileName);
  //   return file.writeAsBytes(data);
  // }
}