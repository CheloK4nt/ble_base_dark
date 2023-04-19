import 'package:flutter/material.dart';

class UIProvider extends ChangeNotifier {
  String _selectedUnity = 'Grafico mmHg';

  String get selectedUnity => _selectedUnity;

  set selectedUnity(String s){
    _selectedUnity = s;
    notifyListeners();
  }
}