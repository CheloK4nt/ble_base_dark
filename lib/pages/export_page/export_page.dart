import 'package:ble_base/main.dart';
import 'package:ble_base/utils/storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:android_path_provider/android_path_provider.dart';

class ExportPage extends StatefulWidget {
  const ExportPage({super.key, required this.fullDataList});
  final List fullDataList;

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {

  bool creatingFile = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("${widget.fullDataList.length}"),
              (creatingFile == false)
                ?ElevatedButton(
                  onPressed: (){
                    setState(() {
                      creatingFile = true;
                    });
                    StorageHelper.writeTextToFile(widget.fullDataList.toString()).then((value){
                      setState(() {
                        creatingFile = false;
                      });
                      const snack = SnackBar(content: Center(child: Text('Datos exportados satisfactoriamente.')),duration: Duration(seconds: 2),);
                      return ScaffoldMessenger.of(context).showSnackBar(snack);
                    });
                  },
                  child: const Text("Exportar datos")
                )
                :const CircularProgressIndicator(),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const MonitorEBCApp()), (Route route) => false),
                child: const Icon(Icons.home)
              ),
            ],
          )
        ),
      ),
    );
  }
}