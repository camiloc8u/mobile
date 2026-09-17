import 'package:flutter/material.dart';
import '../../Admin/modelos/clase.dart'; // Importamos el modelo

const Color primaryGreen = Color(0xFFAEE000); 
const Color cardColor = Color(0xFF1E1E1E);

class EntrenadorWidgets {
  
  static Widget buildStatCard(String title, String value, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 12),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(title, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  // Ahora recibe List<Clase> en lugar de List<Map>
  static Widget buildClassesList(List<Clase> list, Function(Clase) onTapClass) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final clase = list[index];
        return Card(
          color: cardColor,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(Icons.fitness_center, color: primaryGreen),
            ),
            // Usamos las propiedades del objeto Clase (clase.nombre) en lugar de mapa (clase['nombre'])
            title: Text(clase.nombre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            subtitle: Text('Hora: ${clase.horario} | Sala General', style: TextStyle(color: Colors.grey[400])),
            trailing: Text(clase.cupo, style: const TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
            onTap: () => onTapClass(clase),
          ),
        );
      },
    );
  }

  static Widget buildClientsList(List<Map<String, String>> list, Function(Map<String, String>) onTapClient) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final client = list[index];
        return Card(
          color: cardColor,
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[900],
              child: Text(client['name']![0], style: const TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
            ),
            title: Text(client['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            subtitle: Text('Plan: ${client['plan']}', style: TextStyle(color: Colors.grey[400])),
            onTap: () => onTapClient(client),
          ),
        );
      },
    );
  }
}