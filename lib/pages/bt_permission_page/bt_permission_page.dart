import 'package:ble_base/pages/home_page/bluetooth_off_screen.dart';
import 'package:ble_base/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BTPermissionPage extends StatefulWidget {
  const BTPermissionPage({super.key});
  @override
  State<BTPermissionPage> createState() => _BTPermissionPageState();

}

class _BTPermissionPageState extends State<BTPermissionPage> {

  bool btPermission = false;

  @override
  Widget build(BuildContext context) {
    getBtPermission();
    // Permission.bluetoothConnect.request();

    if (btPermission == true) {
      return StreamBuilder<BluetoothState>(
        stream: FlutterBluePlus.instance.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.on) {
            return const HomePage(); /* Si bluetooth esta prendido */
          }
          return BluetoothOffScreen(state: state); /* Si bluetooth está apagado */
        }
      );
    } else {
      return Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text("Debe conceder permisos de DISPOSITIVOS CERCANOS para poder acceder a las funciones"),
            ),
            ElevatedButton(
              onPressed: () => openAppSettings(),
              child: const Text("Ir a ajustes")
              )
            ],
        )),
      );
    }
  }

  void getBtPermission() async {
    if (await Permission.bluetoothConnect.isGranted) {
      setState(() {
        btPermission = true;
      });
    } else {
      setState(() {
        btPermission = false;
      });
    }
  }
}
