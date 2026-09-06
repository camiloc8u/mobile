import 'package:flutter/material.dart';
import 'pantallas/panel_principal.dart';

void main() {
  runApp(const MiGimnasioApp());
}

class MiGimnasioApp extends StatelessWidget {
  const MiGimnasioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Gymzone',
      home: PanelPrincipal(), // Llamamos al archivo panel_principal.dart
    );
  }
}