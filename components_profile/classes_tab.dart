import 'package:flutter/material.dart';

class ClassesTab extends StatefulWidget {
  const ClassesTab({super.key});

  @override
  State<ClassesTab> createState() => _ClassesTabState();
}

class _ClassesTabState extends State<ClassesTab> {
  // Clases que el usuario ya tiene reservadas
  final List<Map<String, String>> _clasesReservadas = [
    {'nombre': 'Spinning', 'horario': 'Mañana • 7:00 AM', 'instructor': 'Ana López'},
    {'nombre': 'CrossFit', 'horario': 'Mañana • 6:00 PM', 'instructor': 'Juan Pérez'},
    {'nombre': 'Yoga', 'horario': 'Sábado • 9:00 AM', 'instructor': 'María González'},
  ];

  // Parrilla de clases disponibles para reservar
  final List<Map<String, dynamic>> _clasesDisponibles = [
    {'nombre': 'Spinning', 'horario': 'Lunes a Viernes - 6:00 AM, 7:00 AM, 6:00 PM', 'instructor': 'Ana López', 'plazas': 15},
    {'nombre': 'CrossFit', 'horario': 'Lunes, Miércoles, Viernes - 6:00 PM', 'instructor': 'Juan Pérez', 'plazas': 12},
    {'nombre': 'Yoga', 'horario': 'Martes, Jueves, Sábado - 9:00 AM', 'instructor': 'María González', 'plazas': 20},
    {'nombre': 'HIIT', 'horario': 'Lunes a Viernes - 5:30 AM, 6:30 PM', 'instructor': 'Carlos Ramírez', 'plazas': 15},
    {'nombre': 'Zumba', 'horario': 'Martes, Jueves - 7:00 PM', 'instructor': 'Laura Torres', 'plazas': 25},
    {'nombre': 'Pilates', 'horario': 'Lunes, Miércoles, Viernes - 10:00 AM', 'instructor': 'Patricia Díaz', 'plazas': 15},
  ];

  void _cancelarReserva(int index) {
    setState(() {
      _clasesReservadas.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Clase cancelada con éxito'), backgroundColor: Colors.black87),
    );
  }

  void _mostrarModalReservarNueva() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF18181B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFAEE000), width: 1),
          ),
          title: const Text('RESERVAR NUEVA CLASE', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _clasesDisponibles.length,
              itemBuilder: (context, index) {
                final clase = _clasesDisponibles[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF121214),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade800),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(clase['nombre'], style: const TextStyle(color: Color(0xFFAEE000), fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(clase['horario'], style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      const SizedBox(height: 2),
                      Text('Instructor: ${clase['instructor']} | Plazas: ${clase['plazas']}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFAEE000)),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                          ),
                          onPressed: () {
                            setState(() {
                              _clasesReservadas.add({
                                'nombre': clase['nombre'],
                                'horario': 'Próximamente',
                                'instructor': clase['instructor'],
                              });
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('¡Clase de ${clase['nombre']} reservada!'), backgroundColor: Colors.black87),
                            );
                          },
                          child: Text('RESERVAR ${clase['nombre']}', style: const TextStyle(color: Color(0xFFAEE000), fontSize: 11)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.grey), padding: const EdgeInsets.symmetric(vertical: 10)),
                onPressed: () => Navigator.pop(context),
                child: const Text('CERRAR', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'CLASES RESERVADAS',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _clasesReservadas.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: Center(
                    child: Text('No tienes clases reservadas actualmente.', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _clasesReservadas.length,
                  itemBuilder: (context, index) {
                    final clase = _clasesReservadas[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF18181B),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade800),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, color: Color(0xFFAEE000), size: 22),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(clase['nombre']!, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 2),
                                    Text('${clase['horario']} • ${clase['instructor']}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.redAccent),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                              onPressed: () => _cancelarReserva(index),
                              child: const Text('CANCELAR', style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFAEE000)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _mostrarModalReservarNueva,
              child: const Text('RESERVAR NUEVA CLASE', style: TextStyle(color: Color(0xFFAEE000), fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}