
import 'package:ble_base/pages/home_page/find_devices_screen.dart';
import 'package:ble_base/pages/home_page/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  int selectedIndex = 0;
  // ignore: non_constant_identifier_names
  DateTime pre_backpress = DateTime.now().subtract(const Duration(days: 1));

  @override
  Widget build(BuildContext context) {

    final screens = [const FindDevicesScreen(), const SettingsPage()];
    
    return WillPopScope(
      onWillPop: () async{
        final timegap = DateTime.now().difference(pre_backpress);
        final cantExit = timegap >= const Duration(seconds: 2);
        pre_backpress = DateTime.now();
        if(cantExit){
          //show snackbar
          const snack = SnackBar(content: Center(child: Text('Presiona "atrás" otra vez para salir.')),duration: Duration(seconds: 2),);
          ScaffoldMessenger.of(context).showSnackBar(snack);
          return false;
        }else{
          return true;
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: selectedIndex,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.white,
          unselectedItemColor: Theme.of(context).primaryColorLight,
          type: BottomNavigationBarType.shifting,
          currentIndex: selectedIndex,
          onTap: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_bluetooth_outlined),
              activeIcon: const Icon(Icons.bluetooth_searching),
              label: "Dispositivos",
              backgroundColor: Theme.of(context).primaryColor,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_outlined),
              activeIcon: const Icon(Icons.settings),
              label: "Configuraciones",
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ]
        ),
        floatingActionButton: (selectedIndex == 0)
        ? StreamBuilder<bool>(
          stream: FlutterBluePlus.instance.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data!) {
              return FloatingActionButton(
                onPressed: () => FlutterBluePlus.instance.stopScan(),
                backgroundColor: Colors.red,
                child: const Icon(Icons.stop),
              );
            } else {
              return FloatingActionButton(
                  child: const Icon(Icons.search),
                  onPressed: () => FlutterBluePlus.instance.startScan(timeout: const Duration(seconds: 4)
                )
              );
            }
          }
        )
        : null,
      ),
    );
  }
}