import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ppidunia/common/utils/color_resources.dart';

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

  static Future<String> getFileFromAsset(String filename , BuildContext context, bool isExistFile) async {
    final path = await localPath; 
    debugPrint('Filename : $filename');
    final snackBar = SnackBar(
      backgroundColor: isExistFile ? ColorResources.primary : ColorResources.success,
      duration: const Duration(seconds: 5),
      content: Text("${isExistFile ? 'File already exists in ' : 'File downloaded successfully, File saved to '} $path/PPI-DUNIA/$filename"),
      action: SnackBarAction(
        label: 'View',
        onPressed: () {
          OpenFile.open('$path/PPI-DUNIA/$filename');
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return "$path/PPI-DUNIA/$filename"; 
  }

  static Future<bool> checkFileExist(String filename) async {
    final path = await localPath; 
    debugPrint('Filename : $filename');
    File file = File('$path/PPI-DUNIA/$filename');

    bool checkIsExist = await file.exists();
    if(checkIsExist) {
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