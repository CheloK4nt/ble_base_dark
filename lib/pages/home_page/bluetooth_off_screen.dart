import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              "Monitor",
              style: TextStyle(
                fontSize: 70,
                fontWeight: FontWeight.w200,
              ),
            ),
            const Text(
              "EBC",
              style: TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              // 'El adaptador bluetooth está ${state.toString().substring(15)}.',
              (state.toString().substring(15) == "turningOn")
                ?"El adaptador BLUETOOTH se está encendiendo."
                :"El adaptador BLUETOOTH está apagado.",
              style: Theme.of(context)
                  .primaryTextTheme
                  .titleSmall
                  ?.copyWith(color: Colors.white),
            ),
            ElevatedButton(
              onPressed: Platform.isAndroid
                  ? () => FlutterBluePlus.instance.turnOn()
                  : null,
              child: const Text('Encender BT'),
            ),
          ],
        ),
      ),
    );
  }
}