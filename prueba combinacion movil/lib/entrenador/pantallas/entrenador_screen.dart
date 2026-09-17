import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Importamos el modelo y el servicio
import '../../Admin/modelos/clase.dart';
import '../../services/clase_service.dart';

// Importamos la pantalla de inicio para la redirección de Cerrar Sesión
import '../../inicio/screens/main_navigation_screen.dart';
import '../../inicio/screens/notifications_screen.dart';

// Importamos las vistas estructuradas
import '../vistas/inicio_vista.dart';
import '../vistas/clases_vista.dart';
import '../vistas/clientes_vista.dart';

const Color kGreenColor = Color(0xFFAEE000);
const Color kBgColor = Color(0xFF09090B);
const Color kCardBg = Color(0xFF18181B);

class EntrenadorScreen extends StatefulWidget {
  final Map<String, dynamic> usuario;

  const EntrenadorScreen({super.key, required this.usuario});

  @override
  State<EntrenadorScreen> createState() => _EntrenadorScreenState();
}

class _EntrenadorScreenState extends State<EntrenadorScreen> {
  int _currentIndex = 0;
  
  // ESTADOS Y DATOS (Ahora usamos el modelo Clase)
  List<Clase> _clases = [];
  bool _isLoadingClasses = true;
  String _classFilter = 'Todas';

  // Datos simulados (Puedes conectarlos a tu API MySQL luego)
  final List<Map<String, String>> _assignedClients = [
    {'name': 'Carlos Gómez', 'plan': 'Premium'},
    {'name': 'Laura Torres', 'plan': 'Básico'},
    {'name': 'Miguel Ángel', 'plan': 'VIP'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchClasses();
  }

  // USO DEL SERVICIO CENTRALIZADO
  Future<void> _fetchClasses() async {
    try {
      final clasesObtenidas = await ClaseService.obtenerClases();
      if (mounted) {
        setState(() {
          _clases = clasesObtenidas;
          _isLoadingClasses = false;
        });
      }
    } catch (e) {
      print('Error cargando clases de entrenador: $e');
      if (mounted) setState(() => _isLoadingClasses = false);
    }
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
        content: Text("Sesión de entrenador cerrada"),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _mostrarMensajeTemporal(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto), backgroundColor: kCardBg),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      // 0: Vista de Inicio
      InicioVista(
        usuario: widget.usuario,
        assignedClients: _assignedClients,
        classes: _clases,
        isLoadingClasses: _isLoadingClasses,
        onNavigate: (index) => setState(() => _currentIndex = index),
        onAddClass: () => _mostrarMensajeTemporal('Funcionalidad Crear Clase en desarrollo'),
        onClassTap: (c) => _mostrarMensajeTemporal('Abriendo detalles de ${c.nombre}'),
      ),
      // 1: Vista de Clases
      ClasesVista(
        classes: _clases,
        isLoadingClasses: _isLoadingClasses,
        classFilter: _classFilter,
        onFilterChanged: (val) => setState(() => _classFilter = val),
        onAddClass: () => _mostrarMensajeTemporal('Funcionalidad Crear Clase en desarrollo'),
        onClassTap: (c) => _mostrarMensajeTemporal('Abriendo detalles de ${c.nombre}'),
      ),
      // 2: Vista de Clientes
      ClientesVista(
        assignedClients: _assignedClients,
        onRequestClient: () => _mostrarMensajeTemporal('Solicitud enviada al Administrador'),
        onClientTap: (c) => _mostrarMensajeTemporal('Abriendo perfil de ${c['name']}'),
      ),
    ];

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kCardBg,
        elevation: 0,
        title: RichText(
          text: const TextSpan(
            text: 'PANEL ',
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold, 
              color: Colors.white,
              letterSpacing: 1.2,
            ),
            children: [
              TextSpan(
                text: 'ENTRENADOR',
                style: TextStyle(color: kGreenColor),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: kGreenColor),
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
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: kCardBg,
        selectedItemColor: kGreenColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Clases',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Alumnos',
          ),
        ],
      ),
    );
  }
}