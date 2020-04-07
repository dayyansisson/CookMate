import 'package:flutter/material.dart';

class TabNavigationModel extends ChangeNotifier {

  /* Constructor */
  TabNavigationModel({int tabCount = 1}) : _currentTab = 0, _tabCount = tabCount;

  /* Private Variables */
  int _tabCount;

  /* Exposed Members */
  int _currentTab;
  int get currentTab => _currentTab;
  set currentTab(int currentTab) {

    // Only modify if currentTab is different  and in range
    bool _checkIfTabIndexInRange(int tabIndex) => tabIndex >= 0 && tabIndex < _tabCount;
    if(currentTab != _currentTab && _checkIfTabIndexInRange(currentTab)) {
      _currentTab = currentTab;
      notifyListeners();
    }
  }
}