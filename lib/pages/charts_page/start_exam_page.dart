import 'dart:async';
import 'dart:convert';

import 'package:ble_base/pages/charts_page/charts_page.dart';
import 'package:ble_base/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class StartExamPage extends StatefulWidget {
  const StartExamPage({super.key, required this.device});
  final BluetoothDevice device;

  @override
  State<StartExamPage> createState() => _StartExamPageState();
}

class _StartExamPageState extends State<StartExamPage> {
  final String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  final String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  final String TARGET_CHARACTERISTIC = "beb5482e-36e1-4688-b7f5-ea07361b26a8";
  bool isReady = false;
  Stream<List<int>>? stream;
  String selectedCut = "x";
  late BluetoothCharacteristic targetCharacteristic;

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

          if (characteristic.uuid.toString() == TARGET_CHARACTERISTIC) {
            targetCharacteristic = characteristic;
            print("TARGET: ${targetCharacteristic.uuid.toString()}");
          }
        }
      }
    }

    if (!isReady) {
      _Pop();
    }
  }

  writeData(String data) async {
    if(targetCharacteristic == null) return;

    List<int> bytes = utf8.encode(data);
    targetCharacteristic.write(bytes);
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
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Monitor EBC'),
        ),
        body: Container(
          child: !isReady
          ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Estableciendo conexión...",
                  style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w200),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          )
          : Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Seleccione el método de corte",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),

            /* ========== SELECTOR MODO DE CORTE ========== */
            Wrap(
              spacing: 5,
              children: [
                /* ========== BOTON CORTE MAX ========== */
                InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: (){
                    setState(() {
                      selectedCut = "1";
                    });
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      color: (selectedCut == "1")?Colors.blue :Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(25)
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                    child: Text(
                      "Max.",
                      style: TextStyle(color: (selectedCut == "1")?Colors.white :Colors.blue.shade300),
                    ),
                  ),
                ),
                /* ========== FIN BOTON CORTE MAX ========== */
          
                /* ========== BOTON CORTE C50 ========== */
                InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: (){
                    setState(() {
                      selectedCut = "2";
                    });
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      color: (selectedCut == "2")?Colors.blue :Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(25)
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                    child: Text(
                      "C50.",
                      style: TextStyle(color: (selectedCut == "2")?Colors.white :Colors.blue.shade300),
                    ),
                  ),
                ),
                /* ========== FIN BOTON CORTE C50 ========== */
              ],
            ),
            /* ========== FIN SELECTOR MODO DE CORTE ========== */
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  side: BorderSide(
                    color: (selectedCut != "x")?Colors.blue :Colors.transparent,
                  ),
                  elevation: (selectedCut != "x")?10 :0,
                ),
                onPressed: (selectedCut != "x")
                  ?(){ 
                    writeData(selectedCut);
                    // writeData("0");
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChartsPage(device: widget.device)));}
                  :null,
                child: const Text("INICIAR EXAMEN"),
              ),
            )
                  ],
                ),
          ),
        )
      ),
    );
  }
}