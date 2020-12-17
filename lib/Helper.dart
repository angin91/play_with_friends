import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';

class Helper {

  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  Future<String> getJson(url) {
    return rootBundle.loadString(url);
  }

}