import 'package:flutter/material.dart';

class AddNoteBTN extends StatefulWidget {
  const AddNoteBTN({super.key, required this.notas, required this.tiempo});
  final List notas;
  final String tiempo;

  @override
  State<AddNoteBTN> createState() => _AddNoteBTNState();
}

class _AddNoteBTNState extends State<AddNoteBTN> {

  final noteController = TextEditingController();
  
  setTiempo (){
    String tiempoNota = widget.tiempo;
    return tiempoNota;
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => addNoteDialog(),
      child: Text("Agregar Nota"),
    );
  }

  Future addNoteDialog() {
    String tiempoNota = setTiempo();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.note_alt_outlined),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Añadir Nota"),
            Text(tiempoNota),
          ],
        ),
        content: TextField(
          controller: noteController,
          expands: false,
          maxLines: 5,
          maxLength: 200,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Escriba su nota...",
          ),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 218, 243, 255)),
            ),
            onPressed: (){
              widget.notas.add("${tiempoNota}${noteController.text}");
              print(widget.notas);
              Navigator.of(context).pop(false);
              noteController.text = "";
              noteAddedSnack();
            },
            child: const Text("Ok")
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 255, 248, 180)),
            ),
            onPressed: (){
              Navigator.of(context).pop(false);
            },
            child: const Text("Cancelar", style: TextStyle(color: Colors.amber),)
          ),
        ],
      ),
    ).then((value) => false);
  }

  noteAddedSnack() {
    final snack = SnackBar(
      backgroundColor: Colors.blue.shade900,
      content: Center(child: Text('¡Nota agregada!')),duration: Duration(seconds: 2),);
    return ScaffoldMessenger.of(context).showSnackBar(snack);
  }
}