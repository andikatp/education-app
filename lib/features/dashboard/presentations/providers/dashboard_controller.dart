import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher/core/common/app/providers/tab_navigator.dart';
import 'package:teacher/core/common/page/presistent_page.dart';

class DashboardController extends ChangeNotifier {
  List<int> _historyIndex = [0];

  final List<Widget> _screens = [
    ChangeNotifierProvider(
      create: (context) => TabNavigator(
        TabItem(child: const Placeholder()),
      ),
      child: const PersistentPage(),
    ),
  ];

  List<Widget> get screens => _screens;

  int _currentIndex = 3;

  int get currentIndex => _currentIndex;

  void changeIndex(int newIndex) {
    if (_currentIndex == newIndex) return;
    _currentIndex = newIndex;
    _historyIndex.add(newIndex);
    notifyListeners();
  }

  void goBack() {
    if(_historyIndex.length ==1 ) return;
    _historyIndex.removeLast();
    _currentIndex = _historyIndex.last;
    notifyListeners();
  }

  void resetIndex() {
    _historyIndex = [0];
    _currentIndex = 0;
    notifyListeners();
  }
}
