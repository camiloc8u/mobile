import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Importamos todas tus pestañas
import 'profile_tab.dart';
import 'routines_tab.dart';
import 'progress_tab.dart';
import 'classes_tab.dart';

// IMPORTANTE: Asegúrate de que esta ruta apunte a la pantalla que usas como inicio absoluto
import '../../inicio/screens/main_navigation_screen.dart';
import '../../inicio/screens/notifications_screen.dart';

// COLORES
const Color greenColor = Color(0xFFAEE000);
const Color backgroundColor = Color(0xFF0F090B);
const Color cardColor = Color(0xFF18181B);
const Color appBarColor = Color(0xFF121214);

class UserAreaScreen extends StatefulWidget {
  // Recibimos al usuario directamente desde la pantalla de Login
  final Map<String, dynamic>? usuario;

  const UserAreaScreen({super.key, this.usuario});

  @override
  State<UserAreaScreen> createState() => _UserAreaScreenState();
}

class _UserAreaScreenState extends State<UserAreaScreen> {
  
  // Función para cerrar sesión, borrar SharedPreferences y volver al inicio
  Future<void> _cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("usuario");
    await prefs.remove("token");

    if (!mounted) return;

    // pushAndRemoveUntil borra el historial para que no puedan volver atrás sin clave
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      (Route<dynamic> route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Sesión cerrada correctamente"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Extraemos el nombre del usuario que pasamos por parámetro
    final String nombreCompleto = widget.usuario != null
        ? "${widget.usuario!['primer_nombre'] ?? ''} ${widget.usuario!['primer_apellido'] ?? ''}"
        : "Usuario";

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      text: 'ÁREA DE ',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      children: [
                        TextSpan(
                          text: 'USUARIO',
                          style: TextStyle(color: greenColor),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Bienvenido, $nombreCompleto',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none, color: greenColor),
                tooltip: 'Notificaciones',
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
              ),
              // --- BOTÓN DE CERRAR SESIÓN ---
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                tooltip: "Cerrar Sesión",
                onPressed: _cerrarSesion,
              ),
            ],
          ),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: greenColor,
            unselectedLabelColor: Colors.white,
            indicatorColor: greenColor,
            tabs: [
              Tab(text: 'MI PERFIL'),
              Tab(text: 'MIS RUTINAS'),
              Tab(text: 'MI PROGRESO'),
              Tab(text: 'MIS CLASES'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ProfileTab(usuario: widget.usuario), 
            const RoutinesTab(),
            const ProgressTab(),
            const ClassesTab(),
          ],
        ),
      ),
    );
  }
}