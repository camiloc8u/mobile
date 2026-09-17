import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../screens/routines_screen.dart';
import '../screens/fit_menu_screen.dart';
import '../screens/plans_screen.dart';
import '../screens/profile_screen.dart';

class QuickCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  const QuickCard({super.key, required this.icon, required this.title, this.isSelected = false});
  @override
  State<QuickCard> createState() => _QuickCardState();
}
class _QuickCardState extends State<QuickCard> {
  bool _hover = false;
  void _onEnter(PointerEvent _) => setState(() => _hover = true);
  void _onExit(PointerEvent _) => setState(() => _hover = false);
  @override
  Widget build(BuildContext context) {
    final selected = widget.isSelected;
    final bg = kCardBg;
    final green = kGreenColor;
    return Expanded(
      child: MouseRegion(
        onEnter: _onEnter,
        onExit: _onExit,
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            final t = widget.title.toLowerCase();
            if (t.contains('rutina') || t.contains('rutinas')) {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RoutinesScreen()));
            } else if (t.contains('men') || t.contains('nutric')) {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FitMenuScreen()));
            } else if (t.contains('plan') || t.contains('planes')) {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PlansScreen()));
            } else if (t.contains('mi') || t.contains('perfil') || t.contains('cuenta')) {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            transform: _hover ? Matrix4.diagonal3Values(1.01, 1.01, 1.0) : null,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: selected ? null : bg,
              gradient: selected
              ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [green.withAlpha(60), bg],
              )
              : null,
              borderRadius: BorderRadius.circular(12),
              border: selected ? Border.all(color: green) : null,
            ),
            child: Column(
              children: [
                Icon(widget.icon, color: selected ? green : Colors.white70, size: 20),
                const SizedBox(height: 6),
                Text(widget.title, style: TextStyle(fontSize: 11, color: selected ? Colors.white : Colors.grey, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
