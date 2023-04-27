import 'package:ble_base/main.dart';
import 'package:ble_base/utils/storage_helper.dart';
import 'package:ble_base/widgets/export_page/data_card.dart';
import 'package:flutter/material.dart';

import '../../widgets/export_page/titulo_export_page.dart';

class ExportPage extends StatefulWidget {
  const ExportPage({
    super.key,
    required this.fullDataList,
    required this.corte,
    required this.tiempo,
    required this.totales,
  });
  final List fullDataList;
  final String corte;
  final String tiempo;
  final String totales;

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {

  bool creatingFile = false;
  DateTime pre_backpress = DateTime.now();

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
                            DataCard(subtitulo: "DATOS TOTALES", valor: widget.totales, icono: Icons.bar_chart),
                            const DataCard(subtitulo: "FREC. RESPIRATORIA", valor: "99999", icono: Icons.auto_graph),
                          ],
                        ),
                      ),
              
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            DataCard(subtitulo: "DURACIÓN TOTAL", valor: widget.tiempo, icono: Icons.access_alarm),
                            DataCard(subtitulo: "MÉTODO DE CORTE", valor: widget.corte, icono: Icons.blur_off),
                          ],
                        ),
                      ),
              
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            DataCard(subtitulo: "VALOR MÁXIMO", valor: "1", icono: Icons.trending_up),
                            DataCard(subtitulo: "EXTRA 2", valor: "2", icono: Icons.abc_outlined),
                          ],
                        ),
                      ),
              
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
            ],
          ),
        ),
      ),
    );
  }
}