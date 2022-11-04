import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Globals {
  Globals._internal();
  static final Globals _globals = Globals._internal();
  factory Globals() {
    return _globals;
  }
  int currentIndex = 0;
  set index(int index) => currentIndex = index;
  int get getIndex => currentIndex;
}

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

String titleCase(str) {
  var splitStr = str.toLowerCase().split(' ');
  for (var i = 0; i < splitStr.length; i++) {
    // You do not need to check if i is larger than splitStr length, as your for does that for you
    // Assign it back to the array
    splitStr[i] =
        splitStr[i].charAt(0).toUpperCase() + splitStr[i].substring(1);
  }
  // Directly return the joined string
  return splitStr.join(' ');
}

String capitalizeAllWord(String value) {
  var result = value[0].toUpperCase();
  for (int i = 1; i < value.length; i++) {
    if (value[i - 1] == " ") {
      result = result + value[i].toUpperCase();
    } else {
      result = result + value[i];
    }
  }
  return result;
}

Future<bool?> checkSpotlightStatus(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? featuredCardSpotlightDone = prefs.getBool(key);
  return featuredCardSpotlightDone;
}

Future<void> setSpotlightStatusToComplete(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(key, true);
}
