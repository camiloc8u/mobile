import 'package:flutter/material.dart';

class RoutinesTab extends StatefulWidget {
  const RoutinesTab({super.key});

  @override
  State<RoutinesTab> createState() => _RoutinesTabState();
}

class _RoutinesTabState extends State<RoutinesTab> {
  // Lista de rutinas de la semana con su estado interactivo
  final List<Map<String, dynamic>> _rutinas = [
    {'dia': 'Lunes', 'tipo': 'FUERZA - Tren Superior', 'completada': true},
    {'dia': 'Martes', 'tipo': 'HIIT - Quema de Grasa', 'completada': true},
    {'dia': 'Miércoles', 'tipo': 'FUNCIONAL - Movilidad', 'completada': false},
    {'dia': 'Jueves', 'tipo': 'FUERZA - Tren Inferior', 'completada': false},
    {'dia': 'Viernes', 'tipo': 'CARDIO - Resistencia', 'completada': false},
    {'dia': 'Sábado', 'tipo': 'CIRCUITO - Full Body', 'completada': false},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'RUTINA SEMANAL',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._rutinas.map((rutina) => _buildRoutineCard(rutina)),
        ],
      ),
    );
  }

  Widget _buildRoutineCard(Map<String, dynamic> rutina) {
    bool completada = rutina['completada'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: completada ? const Color(0xFFAEE000) : Colors.grey.shade800,
          width: completada ? 1.5 : 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icono y textos alineados a la izquierda
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.fitness_center,
                  color: completada ? const Color(0xFFAEE000) : Colors.grey,
                  size: 22,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rutina['dia'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        rutina['tipo'],
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Si está completada muestra el marcador verde y el botón cancelar rojo; si no, el botón verde de completar
          if (completada) ...[
            const Icon(
              Icons.bookmark,
              color: Color(0xFFAEE000),
              size: 20,
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 34,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.redAccent),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                onPressed: () {
                  setState(() {
                    rutina['completada'] = false;
                  });
                },
                child: const Text(
                  'CANCELAR',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ] else ...[
            SizedBox(
              height: 34,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAEE000),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                onPressed: () {
                  setState(() {
                    rutina['completada'] = true;
                  });
                },
                child: const Text(
                  'MARCAR COMPLETADO',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}