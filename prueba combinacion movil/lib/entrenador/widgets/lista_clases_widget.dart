import 'package:flutter/material.dart';
import '../colores_entrenador.dart';

class ListaClasesWidget extends StatelessWidget {
  final List<Map<String, String>> clases;
  final Function(Map<String, String>) onClassTap;

  const ListaClasesWidget({super.key, required this.clases, required this.onClassTap});

  @override
  Widget build(BuildContext context) {
    if (clases.isEmpty) {
      return const Center(child: Text('No hay clases programadas', style: TextStyle(color: Colors.grey)));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: clases.length,
      itemBuilder: (context, index) {
        final cls = clases[index];
        return Card(
          color: ColoresEntrenador.tarjeta,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(cls['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text('${cls['time']} - ${cls['room']} \nCupo: ${cls['capacity']}', style: const TextStyle(color: Colors.grey)),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: ColoresEntrenador.verde, size: 16),
            onTap: () => onClassTap(cls),
          ),
        );
      },
    );
  }
}