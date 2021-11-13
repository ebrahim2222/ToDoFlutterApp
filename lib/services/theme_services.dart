import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices{

  final GetStorage _getStorage = GetStorage();
  final _key = "darkMode";

  void saveTheme(bool value){
    _getStorage.write(_key, value);
  }

  bool loadTheme() => _getStorage.read(_key)??false;

  ThemeMode get themeMode => loadTheme() ? ThemeMode.dark : ThemeMode.light ;

  void switchTheme(){
     Get.changeThemeMode(loadTheme() ? ThemeMode.dark : ThemeMode.light);
     saveTheme(!loadTheme());

  }

}