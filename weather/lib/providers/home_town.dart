import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeTownProvider with ChangeNotifier {
  String homeTown = '';

  HomeTownProvider() {
    _init();
  }

  Future<void> getHomeTown() async {
    homeTown = await _getHomeTown();
    notifyListeners();
  }

  Future<void> setHomeTown(String town) async {
    homeTown = town;
    await _saveHomeTown(town);
    notifyListeners();
  }

  Future<String> _getHomeTown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('homeTown') ?? '';
  }

  _init() {
    getHomeTown();
  }

  Future<void> _saveHomeTown(String town) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('homeTown', town);
  }
}
