import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components_profile/profile_tab.dart';
import '../../components_profile/routines_tab.dart';
import '../../components_profile/classes_tab.dart';
import '../../components_profile/progress_tab.dart';
import '../theme/app_colors.dart';
import 'main_navigation_screen.dart'; 
import 'notifications_screen.dart';

class ClientHomeScreen extends StatefulWidget {
  final Map<String, dynamic> usuario;

  const ClientHomeScreen({super.key, required this.usuario});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      ProfileTab(usuario: widget.usuario),
      const RoutinesTab(),
      const ClassesTab(),
      const ProgressTab(),
    ];
  }

  Future<void> _cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("usuario");
    await prefs.remove("token");

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      (Route<dynamic> route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Sesión cerrada correctamente"),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.cardBg,
        elevation: 0,
        title: const Text(
          'ÁREA DE CLIENTE',
          style: TextStyle(
            color: AppColors.greenColor, 
            fontWeight: FontWeight.bold, 
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: AppColors.greenColor),
            tooltip: 'Notificaciones',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: 'Cerrar Sesión',
            onPressed: _cerrarSesion,
          ),
        ],
      ),
      body: SafeArea(
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: AppColors.cardBg,
        selectedItemColor: AppColors.greenColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Rutinas'),
          BottomNavigationBarItem(icon: Icon(Icons.class_), label: 'Clases'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Progreso'),
        ],
      ),
    );
  }
}