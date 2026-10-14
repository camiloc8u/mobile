import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// ✨ RUTA CORREGIDA: Ahora busca en la carpeta widgets ✨
import '../colores_entrenador.dart'; 
import '../widgets/lista_clases_widget.dart';

class VistaCalendario extends StatefulWidget {
  final List<Map<String, String>> clases;
  final Function(Map<String, String>) verDetalles;

  const VistaCalendario({super.key, required this.clases, required this.verDetalles});

  @override
  State<VistaCalendario> createState() => _VistaCalendarioState();
}

class _VistaCalendarioState extends State<VistaCalendario> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final selectedClasses = widget.clases.where((item) {
      final date = DateTime.tryParse(item['date'] ?? '');
      return date != null && isSameDay(date, _selectedDay);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: ColoresEntrenador.tarjeta,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TableCalendar(
                locale: 'es_ES',
                firstDay: DateTime(2026, 1, 1),
                lastDay: DateTime(2035, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                calendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.monday,
                eventLoader: (day) => widget.clases.where((item) {
                  final date = DateTime.tryParse(item['date'] ?? '');
                  return date != null && isSameDay(date, day);
                }).toList(),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: const CalendarStyle(
                  defaultTextStyle: TextStyle(color: Colors.white),
                  weekendTextStyle: TextStyle(color: Colors.white70),
                  selectedDecoration: BoxDecoration(color: ColoresEntrenador.verde, shape: BoxShape.circle),
                  todayDecoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                  markerDecoration: BoxDecoration(color: ColoresEntrenador.verde, shape: BoxShape.circle),
                ),
                headerStyle: const HeaderStyle(
                  titleTextStyle: TextStyle(color: Colors.white, fontSize: 16),
                  formatButtonVisible: false,
                  leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                  rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Clases del día', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(child: SingleChildScrollView(child: ListaClasesWidget(clases: selectedClasses, onClassTap: widget.verDetalles))),
        ],
      ),
    );
  }
}