import 'package:flutter/material.dart';

class TituloExportPage extends StatelessWidget {
  const TituloExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 10,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Resumen Exámen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w200
                  ),
                ),
                Icon(
                  Icons.article,
                  size: 35,
                  color: Colors.blue.shade900,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
