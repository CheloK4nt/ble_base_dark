import 'package:ble_base/widgets/settings_page_wg/open_app_settings.dart';
import 'package:flutter/material.dart';

import '../../widgets/settings_page_wg/dark_mode_sw.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: const Text('Configuraciones'),
        ),
        body: ListView(
          children: const [
            DarkModeSwitch(),
            Divider(thickness: 2,),
            OpenAppSettings(),
            Divider(thickness: 2,),
          ],
        ),
      )
    );
  }
}