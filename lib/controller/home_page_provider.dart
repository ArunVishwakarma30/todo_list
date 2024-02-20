import 'package:flutter/material.dart';

class HomePageProvider extends ChangeNotifier {
  late Map<String, String> _selectedValues;

  HomePageProvider() {
    _selectedValues = {
      'Type': 'All',
      'Sort': 'Default',
    };
  }

  Map<String, String> get selectedValues => _selectedValues;

  void updateSelectedValue(String key, String value) {
    _selectedValues[key] = value;
    notifyListeners();
  }
}
