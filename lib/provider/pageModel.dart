import 'package:flutter/material.dart';

class PageModel extends ChangeNotifier {

  int _nextPage;
  int get nextPage => _nextPage;
  set nextPage(int newValue) {
    if(newValue == _nextPage) {
      return;
    }
    _nextPage = newValue;
    notifyListeners();
  }

  PageModel() : _nextPage = 0;
}