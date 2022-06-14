import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:convert';
//import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageUtility {
  static Image imageFromBase64String(String base64String) {
    return base64String.isNotEmpty
        ? Image.memory(base64Decode(base64String),)
        : Image.asset("asset/images/_MG_9521.jpg", semanticLabel:"Imagem padrão do aplicativo");
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static Future<XFile?> recuperaIMG(String source) async {
    try{
      final XFile? pickedFile = await  ImagePicker().pickImage(
        source: source == "Camera" ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 50,
      ) ;
      return  pickedFile;
    }
    catch (e) {
      print("ERRO ${e.toString()}");
    }

  }
}
