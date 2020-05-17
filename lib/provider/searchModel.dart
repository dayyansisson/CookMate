import 'package:flutter/material.dart';

class SearchModel extends ChangeNotifier {
  List<String> inputList;

  SearchModel() {
    inputList = [];
  }
  void updateList(List<String> list) {
    inputList = list;
    notifyListeners();
  }
  
}