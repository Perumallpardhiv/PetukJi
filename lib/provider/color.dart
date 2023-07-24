import 'package:flutter/material.dart';

class colorProvider extends ChangeNotifier {
  Color color = Colors.orange;

  updateColor(String country) {
    color = country == "India"
        ? Colors.orange
        : country == "Pakistan"
            ? Colors.green
            : Colors.amber;
    notifyListeners();
  }
}
