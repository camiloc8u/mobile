import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/auth_widgets.dart';

// ==========================================
// PANTALLA: RUTINAS (diseño inicial)
// ==========================================
class _RoutineInfo {
  final String title;
  final String subtitle;
  final String duration;
  final String level;
  final IconData icon;
  final List<String> bullets;
  const _RoutineInfo(this.title, this.subtitle, this.duration, this.level, this.icon, this.bullets);
}
class RoutinesScreen extends StatelessWidget {
  const RoutinesScreen({super.key});
  static const _routines = [
    _RoutineInfo('FUERZA', 'Construcción muscular y potencia', '45-60 min', 'Todos los niveles', Icons.fitness_center,
      ['Pesas libres y máquinas', 'Series progresivas', 'Enfoque en técnica', 'Ganancia de fuerza real']),
    _RoutineInfo('HIIT', 'Alta intensidad para quemar grasa', '30-40 min', 'Intermedio - Avanzado', Icons.flash_on,
      ['Intervalos de alta intensidad', 'Quema calórica elevada', 'Sesiones cortas y efectivas', 'Mejora la resistencia']),
    _RoutineInfo('FUNCIONAL', 'Movimientos naturales del cuerpo', '45 min', 'Todos los niveles', Icons.directions_run,
      ['Kettlebells y TRX', 'Mejora de movilidad', 'Prevención de lesiones', 'Trabajo de core']),
    _RoutineInfo('CROSSFIT', 'Entrenamiento de élite', '60 min', 'Avanzado', Icons.show_chart,
      ['Comunidad competitiva', 'Fuerza y resistencia', 'Variedad constante', 'Retos diarios (WOD)']),
    _RoutineInfo('CARDIO', 'Resistencia y salud cardiovascular', '30-45 min', 'Todos los niveles', Icons.favorite,
      ['Cinta, bici y remo', 'Clases de spinning', 'Quema de calorías', 'Mejora de resistencia']),
    _RoutineInfo('CIRCUITO', 'Combinación perfecta de todo', '45 min', 'Intermedio', Icons.timer,
      ['Estaciones rotativas', 'Cardio + Fuerza', 'Trabajo en grupo', 'Resultados rápidos']),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('RUTINAS', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: kGreenColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('ENTRENA CON PROPÓSITO', style: TextStyle(color: kGreenColor, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5)),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text.rich(
                TextSpan(
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                  children: [
                    const TextSpan(text: 'NUESTRAS ', style: TextStyle(color: Colors.white)),
                    TextSpan(text: 'RUTINAS', style: TextStyle(color: kGreenColor)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 28, height: 2, color: kGreenColor),
                  const SizedBox(width: 8),
                  const Text('PROGRAMAS DISEÑADOS PARA RESULTADOS', style: TextStyle(color: kGreenColor, fontSize: 11, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Container(width: 28, height: 2, color: kGreenColor),
                ],
              ),
            ),
            const SizedBox(height: 20),
            for (int i = 0; i < _routines.length; i += 2)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _buildRoutineCard(_routines[i])),
                    const SizedBox(width: 12),
                    if (i + 1 < _routines.length)
                    Expanded(child: _buildRoutineCard(_routines[i + 1]))
                    else
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: kCardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  const Text(
                    '¿No sabes por dónde empezar? Nuestros coaches diseñarán el plan perfecto para ti',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => showLoginDialog(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: kGreenColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      child: const Text('COMIENZA HOY', style: TextStyle(color: kGreenColor, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  Widget _buildRoutineCard(_RoutineInfo r) {
    final card = Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(border: Border.all(color: const Color(0xFF90EE00)), borderRadius: BorderRadius.circular(8), color: Colors.transparent),
            child: Icon(r.icon, color: const Color(0xFF90EE00), size: 20),
          ),
          const SizedBox(height: 10),
          Text(r.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(r.subtitle, style: const TextStyle(color: kGreenColor, fontSize: 11.5)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('DURACIÓN', style: TextStyle(color: Color(0xFF90EE00), fontSize: 10, fontWeight: FontWeight.bold)),
                    Text(r.duration, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('NIVEL', style: TextStyle(color: Color(0xFF90EE00), fontSize: 10, fontWeight: FontWeight.bold)),
                    Text(r.level, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: Colors.white12),
          const SizedBox(height: 6),
          ...r.bullets.map((b) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Transform.rotate(
                      angle: 0.785398,
                      child: Container(width: 6, height: 6, color: const Color(0xFF90EE00)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(b, style: const TextStyle(color: Colors.white70, fontSize: 11.5))),
                ],
              ),
          )),
        ],
      ),
    );
    return _HoverCard(child: card);
  }
}
// Small reusable hover card for routines and other lists
class _HoverCard extends StatefulWidget {
  final Widget child;
  const _HoverCard({required this.child});
  @override
  State<_HoverCard> createState() => _HoverCardState();
}
class _HoverCardState extends State<_HoverCard> {
  bool _hover = false;
  void _onEnter(PointerEvent _) => setState(() => _hover = true);
  void _onExit(PointerEvent _) => setState(() => _hover = false);
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: const Color(0xFF18181B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
          boxShadow: _hover ? [BoxShadow(color: Color(0xFF90EE00).withAlpha(20), blurRadius: 12, offset: const Offset(0, 6))] : null,
        ),
        child: widget.child,
      ),
    );
  }
}
