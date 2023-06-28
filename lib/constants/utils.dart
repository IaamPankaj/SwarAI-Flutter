

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white,
      fontSize: 14.0
  );
}

Future<void> setStringLocal(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<String?> getStringLocal(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<bool?> removeStringLocal(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.remove(key);
}

Future<bool> requestStoragePermission(BuildContext context) async {
  // Request storage permission from the user
  PermissionStatus status = await Permission.storage.request();

  // If the user grants permission, download the file
  if (status == PermissionStatus.granted) {
    return true;
  } else {
    // If the user denies permission, show an error message
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Storage permission denied')),
    // );
    showToast('Storage permission denied');
    return false;
  }
}
