import 'package:flutter/material.dart';

class DataCard extends StatefulWidget {
  const DataCard({super.key, required this.valor});
  final String valor;

  @override
  State<DataCard> createState() => _DataCardState();
}

class _DataCardState extends State<DataCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 10,
      child: InkWell(
        onTap: () => {},
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.43,
          height: MediaQuery.of(context).size.height * 0.15,
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(alignment: AlignmentDirectional.center, children: [
                      Center(
                        child: Icon(
                          Icons.bar_chart,
                        shadows: const <Shadow>[
                          Shadow(color: Colors.white, blurRadius: 3.0)
                        ],
                        size: 100,
                        color: Colors.blue.shade50,
                      )),
      
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          widget.valor,
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: MediaQuery.of(context).size.width * 0.1,
                            fontWeight: FontWeight.bold,
                            shadows: const <Shadow>[
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 3.0,
                                color: Colors.black
                              ),
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 8.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ],
                ),
      
                Expanded(
                  child: Container(
                    color: Colors.blue.shade800,
                    child: Center(
                      child: Text(
                        "DATOS TOTALES",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
