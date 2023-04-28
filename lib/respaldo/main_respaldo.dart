// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:ble_base/pages/home_page/bluetooth_off_screen.dart';
import 'package:ble_base/pages/home_page/home_page.dart';
import 'package:ble_base/providers/shared_pref.dart';
import 'package:ble_base/providers/theme_provider.dart';
import 'package:ble_base/providers/ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = UserPrefs();
  await prefs.initPrefs();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp( 
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UIProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider(prefs.darkMode)),
        ],
        child: const MonitorEBCApp()
      )
    );
  });
}

class MonitorEBCApp extends StatelessWidget {
  const MonitorEBCApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, value, child) {
        return MaterialApp(
          theme: value.getTheme(),
          debugShowCheckedModeBanner: false,
          // home: SettingsPage(),
          home: StreamBuilder<BluetoothState>(
            stream: FlutterBluePlus.instance.state,
            initialData: BluetoothState.unknown,
            builder: (c, snapshot) {
              final state = snapshot.data;
              if (state == BluetoothState.on) {
                return const HomePage(); /* Si bluetooth esta prendido */
              }
              return BluetoothOffScreen(state: state); /* Si bluetooth está apagado */
            }
          ),
        );
      }
    );
  }
}