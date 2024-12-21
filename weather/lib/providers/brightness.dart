import 'package:flutter/material.dart';

class BrightnessProvider with ChangeNotifier {
  Brightness _brightness = Brightness.light;

  Brightness get brightness => _brightness;

  void toggleBrightness() {
    _brightness =
        _brightness == Brightness.light ? Brightness.dark : Brightness.light;
    notifyListeners();
  }
}
