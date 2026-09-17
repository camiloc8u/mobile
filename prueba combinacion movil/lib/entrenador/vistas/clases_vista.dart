import 'package:flutter/material.dart';
import '../../Admin/modelos/clase.dart';
import '../widgets/entrenador_widgets.dart';

class ClasesVista extends StatelessWidget {
  final List<Clase> classes; // Ahora es una lista de objetos Clase
  final bool isLoadingClasses;
  final String classFilter;
  final ValueChanged<String> onFilterChanged;
  final VoidCallback onAddClass;
  final Function(Clase) onClassTap;

  const ClasesVista({
    super.key,
    required this.classes,
    required this.isLoadingClasses,
    required this.classFilter,
    required this.onFilterChanged,
    required this.onAddClass,
    required this.onClassTap,
  });

  @override
  Widget build(BuildContext context) {
    // Si tu modelo Clase no tiene 'turno', por ahora mostramos todas las clases.
    // Cuando lo agregues, puedes volver a habilitar este filtro.
    final filteredClasses = classes; 

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<String>(
                dropdownColor: cardColor,
                value: classFilter,
                style: const TextStyle(color: primaryGreen, fontWeight: FontWeight.bold),
                items: ['Todas', 'Mañana', 'Tarde'].map((String value) => DropdownMenuItem<String>(value: value, child: Text('Turno: $value'))).toList(),
                onChanged: (val) {
                  if (val != null) onFilterChanged(val);
                },
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
                onPressed: onAddClass, 
                icon: const Icon(Icons.add, color: Colors.black),
                label: const Text('Crear Clase', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: isLoadingClasses
                ? const Center(child: CircularProgressIndicator(color: primaryGreen))
                : filteredClasses.isEmpty
                    ? Center(child: Text("No hay clases para este filtro", style: TextStyle(color: Colors.grey[500])))
                    : EntrenadorWidgets.buildClassesList(filteredClasses, onClassTap),
          ),
        ],
      ),
    );
  }
}