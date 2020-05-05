import 'package:flutter/material.dart';

class TabNavigationModel extends ChangeNotifier {

  /* Constructor */
  TabNavigationModel({int tabCount = 1, bool expandSheet = false}) : 
    _currentTab = 0, 
    _previousTab = -1, 
    _tabCount = tabCount,
    _expandSheet = expandSheet;

  /* Private Variables */
  int _tabCount;

  /* Exposed Members */
  bool _expandSheet;
  bool get expandSheet => _expandSheet;
  set expandSheet(bool expand) {
    // Only modify if expand is different
    if(expand != _expandSheet) {
      _expandSheet = expand;
      notifyListeners();
    }
  }

  int _currentTab;
  int _previousTab;
  int get currentTab => _currentTab;
  int get previousTab => _previousTab;
  set currentTab(int nextTab) {

    // Only modify if nextTab is different  and in range
    bool _checkIfTabIndexInRange(int tabIndex) => tabIndex >= 0 && tabIndex < _tabCount;
    if(nextTab != _currentTab && _checkIfTabIndexInRange(nextTab)) {
      _previousTab = _currentTab;
      _currentTab = nextTab;
      notifyListeners();
    }
  }
}