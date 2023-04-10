// ignore_for_file: non_constant_identifier_names, prefer_final_fields, unused_import

import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:oscilloscope/oscilloscope.dart';

import 'dart:developer' as logdev;

import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;

class SensorPageOsci extends StatefulWidget {
  const SensorPageOsci({Key? key, required this.device}) : super(key: key);
  final BluetoothDevice device;

  @override
  // ignore: library_private_types_in_public_api
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPageOsci> {
  final String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  final String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  double ultimo = 99;
  bool isReady = false;
  Stream<List<int>>? stream;

  List<double> traceDust = List.empty(growable: true);
  List<double> traceDust2 = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    isReady = false;
    connectToDevice();
  }

  connectToDevice() async {
    // ignore: unnecessary_null_comparison
    if (widget.device == null) {
      _Pop();
      return;
    }

    Timer(const Duration(seconds: 15), () {
      if (!isReady) {
        disconnectFromDevice();
        _Pop();
      }
    });

    await widget.device.connect();
    discoverServices();
  }

  disconnectFromDevice() {
    // ignore: unnecessary_null_comparison
    if (widget.device == null) {
      _Pop();
      return;
    }

    widget.device.disconnect();
  }

  discoverServices() async {
    // ignore: unnecessary_null_comparison
    if (widget.device == null) {
      _Pop();
      return;
    }

    List<BluetoothService> services = await widget.device.discoverServices();
    for (var service in services) {
      if (service.uuid.toString() == SERVICE_UUID) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            stream = characteristic.value;

            setState(() {
              isReady = true;
            });
          }
        }
      }
    }

    if (!isReady) {
      _Pop();
    }
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Estás seguro?'),
        content: const Text('¿Quieres desconectar el dispositivo y volver atrás?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No')
          ),
          TextButton(
            onPressed: () {
              disconnectFromDevice();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Si')
          ),
        ],
      ),
    ).then((value) => false);
  }

  _Pop() {
    Navigator.of(context).pop(true);
  }

  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  @override
  Widget build(BuildContext context) {

    Oscilloscope oscilloscope = Oscilloscope(
      showYAxis: true,
      // margin: const EdgeInsets.all(0),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      traceColor: Colors.tealAccent,
      yAxisMax: 55.0,
      yAxisMin: 0.0,
      dataSet: traceDust,
    );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Monitor EBC'),
        ),
        body: Container(
          child: !isReady
          ? const Center(
            child: Text(
              "Esperando...",
              style: TextStyle(fontSize: 24, color: Colors.tealAccent),
            ),
          )
          : StreamBuilder<List<int>>(
            stream: stream,
            builder: (BuildContext context,
                AsyncSnapshot<List<int>> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
          
              if (snapshot.connectionState == ConnectionState.active) {
                /* RECEPCION DE DATOS  */
                var currentValue = _dataParser(snapshot.data!);
                traceDust.add(double.tryParse(currentValue) ?? 0);
          
                print('ULTIMO: ${traceDust.last}');
                print('REAL: $currentValue');
          
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Valor Actual:', style: TextStyle(fontSize: 14)),
                            Text('$currentValue mmHg', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24))
                          ]
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: oscilloscope
                        ),
                      )
                    ],
                  )
                );
              } else {
                return const Text('Revise la transmisión');
              }
            },
          ),
        )
      ),
    );
  }
}
