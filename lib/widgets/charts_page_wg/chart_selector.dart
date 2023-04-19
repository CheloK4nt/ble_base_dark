import 'package:ble_base/providers/ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChartSelector extends StatefulWidget {
  const ChartSelector({super.key});

  @override
  State<ChartSelector> createState() => _ChartSelectorState();
}

class _ChartSelectorState extends State<ChartSelector> {
  @override
  Widget build(BuildContext context) {
    final currentUnity = context.watch<UIProvider>().selectedUnity;
    final uiProvider = context.read<UIProvider>();
    // ignore: no_leading_underscores_for_local_identifiers
    var _widgets = <Widget>[];

    Map<String, String> unitChart = {
      'Grafico mmHg'  : 'mmHg',
      'Grafico kpa' : 'kpa'
    };

    unitChart.forEach((name, unidad){
      _widgets.add(
        InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: (){
            setState(() {
              uiProvider.selectedUnity = name;
            });
          },
          child: BubbleTab(
            texto: unidad,
            selected: currentUnity == name,
          ),
        ),
      );
    });

    return Wrap(
      spacing: 8,
      children: _widgets,
    );
  }
}

class BubbleTab extends StatelessWidget {
  final bool selected;
  final String texto;
  const BubbleTab({
    super.key,
    required this.selected,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: (selected)?Colors.blue :Colors.blue.shade100,
        borderRadius: BorderRadius.circular(25)
      ),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      child: Text(
        texto,
        style: TextStyle(
          color: (selected)?Colors.white :Colors.blue.shade300,
        ),
      ),
    );
  }
}