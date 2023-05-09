import 'package:ble_base/main.dart';
import 'package:ble_base/utils/storage_helper.dart';
import 'package:ble_base/widgets/export_page/cut_method_card.dart';
import 'package:ble_base/widgets/export_page/data_card.dart';
import 'package:ble_base/widgets/export_page/frec_resp_card.dart';
import 'package:ble_base/widgets/export_page/max_card.dart';
import 'package:ble_base/widgets/export_page/notes_card.dart';
import 'package:ble_base/widgets/export_page/time_card.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ExportPage extends StatefulWidget {
  const ExportPage({
    super.key,
    required this.fullDataList,
    required this.fullDataString,
    required this.corte,
    required this.tiempo,
    required this.totales,
    required this.maximo,
    required this.notas,
  });
  final List fullDataList;
  final String fullDataString;
  final String corte;
  final String tiempo;
  final String totales;
  final String maximo;
  final List notas;

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {

  bool creatingFile = false;
  String stringNotas = "";
  bool enableExport = true;
  // ignore: non_constant_identifier_names
  DateTime pre_backpress = DateTime.now().subtract(const Duration(days: 1));

  @override
  Widget build(BuildContext context) {
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
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Resumen Examen",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.075,
                  fontWeight: FontWeight.w200
                ),
              ),
              Icon(Icons.article, color: Colors.blue.shade900, size: 35,),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            DataCard(valor: widget.totales),
                            const FrecRespCard(valor: "99999"),
                          ],
                        ),
                      ),
              
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TimeCard(valor: widget.tiempo),
                            CutMethodCard(valor: widget.corte),
                          ],
                        ),
                      ),
              
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaxCard(valor: widget.maximo),
                            NotesCard(valor: widget.notas.length.toString(), notas: widget.notas,),
                          ],
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Divider(),
                      ),
              
                      (creatingFile == false)
                        ?ElevatedButton(
                          onPressed: (enableExport == true)? () async {
                            if (await Permission.manageExternalStorage.isGranted) {
                              setState(() {
                                creatingFile = true;
                              });
                              /* se exportan los datos */
                              StorageHelper.writeTextToFile(widget.fullDataString.toString()).then((value){
                                for (var note in widget.notas) {
                                  stringNotas = "$stringNotas${note.toString().substring(0,5)}";
                                  stringNotas = "$stringNotas,";
                                  stringNotas = "$stringNotas${note.toString().substring(5, note.toString().length)};\n";
                                }
                                StorageHelper.writeNotesToFile(stringNotas);

                                setState(() {
                                  creatingFile = false;
                                  enableExport = false;
                                });
                                final snack = SnackBar(
                                  backgroundColor: Colors.blue.shade900,
                                  content: const Center(child: Text('Datos exportados satisfactoriamente.')),duration: Duration(seconds: 2),);
                                return ScaffoldMessenger.of(context).showSnackBar(snack);
                              });
                            } else {
                              storagePermissionDialog();
                            }
                          }:null,
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
            ],
          ),
        ),
      ),
    );
  }

/* ========================================  ======================================== */
  Future<bool> storagePermissionDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.folder_outlined),
        title: const Text('Almacenamiento'),
        content: const Text('Debe conceder permiso en su dispositivo para almacenar archivos.'),
        actions: [
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 218, 243, 255)),
            ),
            onPressed: (){
              Permission.manageExternalStorage.request();
              Navigator.of(context).pop(false);
            },
            child: const Text("Ir a ajustes")
          ),
        ],
      ),
    ).then((value) => false);
  }
}

