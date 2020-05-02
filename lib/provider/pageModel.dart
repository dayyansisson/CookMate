import 'package:flutter/material.dart';

class PageModel extends ChangeNotifier {
  int nextPage;
  bool onHome;
  bool onSearch;
  bool onCatalog;
  bool onBag;

  PageModel() {
    onHome = true;
    onSearch = false;
    onCatalog = false;
    onBag = false;
    nextPage = 0;
  }
  void switchPage(int page, bool home, bool search, bool catalog, bool bag) {
    nextPage = page;
    onHome = home;
    onSearch = search;
    onCatalog = catalog;
    onBag = bag;
    notifyListeners();
  }
}