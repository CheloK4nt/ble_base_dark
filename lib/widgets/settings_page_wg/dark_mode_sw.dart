import 'package:ble_base/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/shared_pref.dart';

class DarkModeSwitch extends StatefulWidget {
  const DarkModeSwitch({super.key});

  @override
  State<DarkModeSwitch> createState() => _DarkModeSwitchState();
}

class _DarkModeSwitchState extends State<DarkModeSwitch> {
  bool _darkMode = false;
  final prefs = UserPrefs();

  @override
  void initState() {
    super.initState();
    _darkMode = prefs.darkMode;
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: _darkMode,
      title: const Text(
        'Modo oscuro',
        style: TextStyle(
          fontSize: 14
        ),
      ),
      subtitle: const Text(
        'El modo oscuro no fuerza tanto tu visión por la noche y reduce el consumo de batería.',
      ),
      onChanged: (value){
        setState(() {
          _darkMode = value;
          prefs.darkMode = value;
          context.read<ThemeProvider>().swapTheme();
        });
      },
    );
  }
}