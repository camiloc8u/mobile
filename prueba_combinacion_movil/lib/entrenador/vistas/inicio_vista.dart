import 'package:flutter/material.dart';
import '../colores_entrenador.dart';
import '../widgets/lista_clases_widget.dart';

class VistaInicio extends StatelessWidget {
  final List<Map<String, String>> clases;
  final int totalClientes;
  final Function(int) cambiarPestana;
  final VoidCallback abrirDialogo;
  final Function(Map<String, String>) verDetalles;

  const VistaInicio({super.key, required this.clases, required this.totalClientes, required this.cambiarPestana, required this.abrirDialogo, required this.verDetalles});

  Widget _buildStatCard(String title, String value, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(color: ColoresEntrenador.tarjeta, borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Icon(icon, color: ColoresEntrenador.verde, size: 28),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('¡Hola, Entrenador!', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('Resumen general de tu agenda', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStatCard('Asignados', '$totalClientes', Icons.group, () => cambiarPestana(3)),
              const SizedBox(width: 12),
              _buildStatCard('Mis Clases', '${clases.length}', Icons.fitness_center, () => cambiarPestana(1)),
              const SizedBox(width: 12),
              _buildStatCard('Horas', '118h', Icons.timer, () {}),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Clases Activas', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.add_circle, color: ColoresEntrenador.verde, size: 28), onPressed: abrirDialogo),
            ],
          ),
          const SizedBox(height: 8),
          ListaClasesWidget(clases: clases.take(2).toList(), onClassTap: verDetalles),
        ],
      ),
    );
  }
}