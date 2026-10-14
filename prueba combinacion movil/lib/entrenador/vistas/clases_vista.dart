import 'package:flutter/material.dart';
import '../colores_entrenador.dart';
import '../widgets/lista_clases_widget.dart';

class VistaClases extends StatefulWidget {
  final List<Map<String, String>> clases;
  final VoidCallback abrirDialogo;
  final Function(Map<String, String>) verDetalles;

  const VistaClases({super.key, required this.clases, required this.abrirDialogo, required this.verDetalles});

  @override
  State<VistaClases> createState() => _VistaClasesState();
}

class _VistaClasesState extends State<VistaClases> {
  String _classFilter = 'Todas';

  @override
  Widget build(BuildContext context) {
    final filteredClasses = _classFilter == 'Todas'
        ? widget.clases
        : widget.clases.where((c) => c['shift'] == _classFilter).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<String>(
                dropdownColor: ColoresEntrenador.tarjeta,
                value: _classFilter,
                style: const TextStyle(color: ColoresEntrenador.verde, fontWeight: FontWeight.bold),
                items: ['Todas', 'Mañana', 'Tarde'].map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text('Turno: $value'));
                }).toList(),
                onChanged: (val) => setState(() => _classFilter = val!),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: ColoresEntrenador.verde),
                onPressed: widget.abrirDialogo,
                icon: const Icon(Icons.add, color: Colors.black),
                label: const Text('Crear Clase', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 16),
          Expanded(child: SingleChildScrollView(child: ListaClasesWidget(clases: filteredClasses, onClassTap: widget.verDetalles))),
        ],
      ),
    );
  }
}