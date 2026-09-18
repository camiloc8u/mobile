import 'package:flutter/material.dart';
import '../../Admin/modelos/clase.dart';
import '../widgets/entrenador_widgets.dart';

class InicioVista extends StatelessWidget {
  final Map<String, dynamic>? usuario;
  final List<Map<String, String>> assignedClients;
  final List<Clase> classes; // Ahora es una lista de objetos Clase
  final bool isLoadingClasses;
  final Function(int) onNavigate;
  final VoidCallback onAddClass;
  final Function(Clase) onClassTap;

  const InicioVista({
    super.key,
    this.usuario,
    required this.assignedClients,
    required this.classes,
    required this.isLoadingClasses,
    required this.onNavigate,
    required this.onAddClass,
    required this.onClassTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('¡Hola, ${usuario?['primer_nombre'] ?? 'Entrenador'}!', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('Resumen general de tu agenda', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          const SizedBox(height: 20),

          Row(
            children: [
              EntrenadorWidgets.buildStatCard('Asignados', '${assignedClients.length}', Icons.group, primaryGreen, () => onNavigate(2)),
              const SizedBox(width: 12),
              EntrenadorWidgets.buildStatCard('Mis Clases', '${classes.length}', Icons.fitness_center, primaryGreen, () => onNavigate(1)),
              const SizedBox(width: 12),
              EntrenadorWidgets.buildStatCard('Horas', '118h', Icons.timer, primaryGreen, () {}),
            ],
          ),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Clases Activas', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.add_circle, color: primaryGreen, size: 28), onPressed: onAddClass),
            ],
          ),
          const SizedBox(height: 8),
          
          isLoadingClasses 
            ? const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(color: primaryGreen)))
            : classes.isEmpty 
                ? Center(child: Text("No hay clases programadas", style: TextStyle(color: Colors.grey[500])))
                : EntrenadorWidgets.buildClassesList(classes.take(3).toList(), onClassTap),
        ],
      ),
    );
  }
}