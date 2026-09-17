import 'package:flutter/material.dart';
import '../Admin/modelos/clase.dart'; 
import '../services/clase_service.dart'; 

class ClassesTab extends StatefulWidget {
  const ClassesTab({super.key});

  @override
  State<ClassesTab> createState() => _ClassesTabState();
}

class _ClassesTabState extends State<ClassesTab> {
  List<Clase> _clasesDisponibles = [];
  bool _isLoadingClasses = true;

  final List<Map<String, String>> _clasesReservadas = [
    {'nombre': 'Spinning', 'horario': 'Mañana • 7:00 AM', 'entrenador': 'Ana López'},
    {'nombre': 'CrossFit', 'horario': 'Mañana • 6:00 PM', 'entrenador': 'Juan Pérez'},
  ];

  @override
  void initState() {
    super.initState();
    _obtenerClasesDisponibles();
  }

  Future<void> _obtenerClasesDisponibles() async {
    setState(() => _isLoadingClasses = true);
    try {
      final clases = await ClaseService.obtenerClases();
      if (!mounted) return;
      setState(() {
        _clasesDisponibles = clases;
        _isLoadingClasses = false;
      });
    } catch (e) {
      print('Error al obtener clases: $e');
      if (!mounted) return;
      setState(() => _isLoadingClasses = false);
    }
  }

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
            child: _isLoadingClasses 
              ? const Center(child: CircularProgressIndicator(color: Color(0xFFAEE000)))
              : _clasesDisponibles.isEmpty
                ? const Center(child: Text('No hay clases disponibles', style: TextStyle(color: Colors.grey)))
                : ListView.builder(
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
                            Text(clase.nombre, style: const TextStyle(color: Color(0xFFAEE000), fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text(clase.horario, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                            const SizedBox(height: 2),
                            Text('Entrenador: ${clase.entrenador} | Plazas: ${clase.cupo}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
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
                                      'nombre': clase.nombre,
                                      'horario': clase.horario,
                                      'entrenador': clase.entrenador,
                                    });
                                  });
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('¡Clase de ${clase.nombre} reservada!'), backgroundColor: Colors.black87),
                                  );
                                },
                                child: Text('RESERVAR ${clase.nombre}', style: const TextStyle(color: Color(0xFFAEE000), fontSize: 11)),
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
                                    Text('${clase['horario']} • ${clase['entrenador']}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
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