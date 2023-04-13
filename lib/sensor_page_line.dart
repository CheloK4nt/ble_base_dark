// ignore_for_file: non_constant_identifier_names, prefer_final_fields, unused_import

import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:oscilloscope/oscilloscope.dart';

import 'dart:developer' as logdev;

import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;

/* DECLARACIONES LINE CHART */
class MyData {
  final num xValue;
  final num yValue;

  MyData(this.xValue, this.yValue);
}

/* FIN DECLARACIONES */

class SensorPageLine extends StatefulWidget {
  const SensorPageLine({Key? key, required this.device}) : super(key: key);
  final BluetoothDevice device;

  @override
  // ignore: library_private_types_in_public_api
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPageLine> {
  final String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  final String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  bool isReady = false;
  Stream<List<int>>? stream;

  List<MyData> _dataList = List.empty(growable: true);
  List<MyData> _dataList2 = List.empty(growable: true);
  int z = 0;

  int _segundosTranscurridos = 0;
  int _minutosTranscurridos = 0;
  late Timer _timerSeg;
  late Timer _timerMin;

  @override
  void initState() {   
    super.initState();

/* DECLARACION TIMER */
    _timerSeg = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _segundosTranscurridos++;
        if (_segundosTranscurridos == 60) {
          _segundosTranscurridos = 0;
        }
      });
    });

    _timerMin = Timer.periodic(Duration(minutes: 1), (Timer timer) {
      setState(() {
        _minutosTranscurridos++;
      });
    });

    isReady = false;
    connectToDevice(); 
  }

/* TIMER DISPOSE */
  @override
  void dispose() {
    _timerSeg.cancel();
    super.dispose();
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
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 218, 243, 255)),
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No')
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 255, 75, 62)),
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
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
    
    var seriesList = [
      charts.Series<MyData, num>(
        id: 'mySeries',
        domainFn: (MyData data, _) => data.xValue,
        measureFn: (MyData data, _) => data.yValue,
        data: _dataList,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      )
    ];

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
              style: TextStyle(fontSize: 24, color: Colors.blue),
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

                if (_dataList.isEmpty){
                  _addData(0);
                }

                Future.delayed(Duration.zero,(){
                  setState(() {
                    _addData(double.tryParse(currentValue) ?? 0);
                  });
                });
                

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
                          /* =============== LINE CHART =============== */
                          child: charts.LineChart(
                            seriesList,
                            animate: false,
                            defaultRenderer: charts.LineRendererConfig(
                              includePoints: false,
                              includeArea: true,
                              areaOpacity: 0.35
                            ),
                            primaryMeasureAxis: const charts.NumericAxisSpec(
                              tickProviderSpec: charts.StaticNumericTickProviderSpec(
                                [
                                  charts.TickSpec(0, label: "0"),
                                  charts.TickSpec(5, label: "5"),
                                  charts.TickSpec(10, label: "10"),
                                  charts.TickSpec(15, label: "15"),
                                  charts.TickSpec(20, label: "20"),
                                  charts.TickSpec(25, label: "25"),
                                  charts.TickSpec(30, label: "30"),
                                  charts.TickSpec(35, label: "35"),
                                  charts.TickSpec(40, label: "40"),
                                  charts.TickSpec(45, label: "45"),
                                  charts.TickSpec(50, label: "50"),
                                ]
                              ),
                            ),
                            domainAxis: charts.NumericAxisSpec(

                              /* MENOS DE 1 MINUTO */
                              tickProviderSpec: (_minutosTranscurridos < 1)    
                              ? charts.StaticNumericTickProviderSpec(
                                [
                                  charts.TickSpec(_dataList.last.xValue, label: (_segundosTranscurridos < 10)
                                    ? "⏱ 00:0$_segundosTranscurridos"
                                    : "⏱ 00:$_segundosTranscurridos"
                                  ),
                                ]
                              )

                              /* MAS o IGUAL a 1 MINUTO */
                              : charts.StaticNumericTickProviderSpec(
                                [
                                  charts.TickSpec(_dataList.last.xValue, label: (_minutosTranscurridos < 10)
                                  ?(_segundosTranscurridos < 10)
                                    ? "⏱ 0$_minutosTranscurridos:0$_segundosTranscurridos"
                                    : "⏱ 0$_minutosTranscurridos:$_segundosTranscurridos"
                                  :(_segundosTranscurridos < 10)
                                    ? "⏱ $_minutosTranscurridos:0$_segundosTranscurridos"
                                    : "⏱ $_minutosTranscurridos:$_segundosTranscurridos"
                                  ),
                                ]
                              )

                            ),
                          ),
                          /* =============== END LINE CHART =============== */
                        ),
                      )
                    ],
                  )
                );
              } else {
                return const Text('Revise la transmisión de datos');
              }
            },
          ),
        )
      ),
    );
  }

  /* ==================== AGREGAR DATOS A LINE CHART ==================== */
  void _addData(valor) {
    if (_dataList.length < 300) {
      _dataList.add(MyData(_dataList.length, valor));
      
      // print("${_dataList.length}: $valor");

    } else {
      for (var element in _dataList.getRange(_dataList.length - 299, _dataList.length)) {
        _dataList2.add(MyData(_dataList2.length, element.yValue));
        // print("${element.xValue},${element.yValue}");
      }
      _dataList = _dataList2;
      _dataList.add(MyData(_dataList.length, valor));
      _dataList2 = [];
      
      // print("LISTA 1: ${_dataList.length}");
      
    }
  }
/* ==================== FIN AGREGAR DATOS A LINE CHART ==================== */

}
