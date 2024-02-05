import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class FileStorage {
  
  static Future<String> getExternalDocumentPath() async { 
    Directory directory = Directory(""); 
    if (Platform.isAndroid) { 
      directory = Directory("/storage/emulated/0/Download"); 
    } else { 
      directory = await getApplicationDocumentsDirectory(); 
    } 
  
    final exPath = directory.path; 
    await Directory("$exPath/PPI-DUNIA").create(recursive: true); 
    return exPath; 
  } 
  
  static Future<String> get localPath async { 

    final String directory = await getExternalDocumentPath(); 
    return directory; 
  } 

  static Future<String> getFileFromAsset(String filename) async {
    final path = await localPath; 
    debugPrint('Filename : $filename');
    OpenFilex.open('$path/PPI-DUNIA/$filename');
    return "$path/PPI-DUNIA/$filename"; 
  }

  static Future<bool> checkFileExist(String filename) async {
    final path = await localPath; 
    debugPrint('Filename : $filename');
    File file = File('$path/PPI-DUNIA/$filename');

    bool checkIsExist = await file.exists();
    if(checkIsExist) {
      OpenFilex.open('$path/PPI-DUNIA/$filename');
      return true;
    } 
    
    
    return false;
  }
  
  static Future<File> saveFile(Uint8List bytes, String filename) async { 
    final path = await localPath; 
    debugPrint('Filename : $filename');
    File file = File('$path/PPI-DUNIA/$filename');
    return file.writeAsBytes(bytes); 
  } 

}