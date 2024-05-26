import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:typed_data';

class Utility{

  static String base64String(Uint8List data){
    return base64Encode(data);
  }

  static Image imageFromBase64String(String base64String){
    return Image.memory(base64Decode(base64String),);
  }
}