import 'package:flutter/material.dart';

class NotesCard extends StatefulWidget {
  const NotesCard({super.key, required this.valor, required this.notas});
  final String valor;
  final List notas;

  @override
  State<NotesCard> createState() => _NotesCardState();
}

class _NotesCardState extends State<NotesCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 10,
      child: InkWell(
        onTap: _showNotes,
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
                          Icons.sticky_note_2_outlined,
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
                        "NOTAS",
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

  Future _showNotes() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notas'),
        content: Text(widget.notas.toString()),
        actions: [
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 218, 243, 255)),
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Ok')
          ),
        ],
      ),
    ).then((value) => false);
  }
}