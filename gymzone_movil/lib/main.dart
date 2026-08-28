import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/profile_tab.dart';
import 'widgets/routines_tab.dart';
import 'widgets/progress_tab.dart';
import 'widgets/classes_tab.dart';
import 'widgets/login_screen.dart';

// COLORES
const Color greenColor = Color(0xFFAEE000);
const Color backgroundColor = Color(0xFF0F090B);
const Color cardColor = Color(0xFF18181B);
const Color appBarColor = Color(0xFF121214);

void main() {
  runApp(const GymzoneApp());
}

class GymzoneApp extends StatelessWidget {
  const GymzoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gymzone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        primaryColor: greenColor,
        colorScheme: const ColorScheme.dark(
          primary: greenColor,
          surface: cardColor,
        ),
      ),
      home: const UserAreaScreen(),
    );
  }
}

class UserAreaScreen extends StatefulWidget {
  const UserAreaScreen({super.key});

  @override
  State<UserAreaScreen> createState() => _UserAreaScreenState();
}

class _UserAreaScreenState extends State<UserAreaScreen> {
  // Mapa para almacenar los datos del usuario logueado que vienen de MySQL
  Map<String, dynamic>? usuarioLogueado;

  @override
  void initState() {
    super.initState();
    _cargarUsuarioGuardado();
  }

  // Cargar si ya había una sesión previa en SharedPreferences
  Future<void> _cargarUsuarioGuardado() async {
    final prefs = await SharedPreferences.getInstance();
    final usuarioString = prefs.getString("usuario");
    if (usuarioString != null) {
      setState(() {
        usuarioLogueado = jsonDecode(usuarioString);
      });
    }
  }

  // Función para abrir el modal de Login
void _abrirModalLogin() {
    showDialog(
      context: context,
      builder: (context) => LoginModalFlutter(
        onLoginSuccess: (usuarioRecibido) {
          setState(() {
            usuarioLogueado = usuarioRecibido; // <--- ¡Listo!
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Extraer nombres reales de la BD o mostrar un texto por defecto si no ha iniciado sesión
    final String nombreCompleto = usuarioLogueado != null
        ? "${usuarioLogueado!['primer_nombre'] ?? ''} ${usuarioLogueado!['primer_apellido'] ?? ''}"
        : "Inicia sesión para continuar";

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
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
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {},
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
            // ¡Aquí está la clave! Tienes que enviarle la variable de sesión activa:
                ProfileTab(usuario: usuarioLogueado), 
                const RoutinesTab(),
                const ProgressTab(),
                const ClassesTab(),
          ],
        ),
        // BOTÓN FLOTANTE PARA PROBAR EL LOGIN
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _abrirModalLogin,
          backgroundColor: greenColor,
          icon: const Icon(Icons.login, color: Colors.black),
          label: Text(
            usuarioLogueado == null ? 'Iniciar Sesión' : 'Cambiar de Cuenta',
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// MODAL DE LOGIN ADAPTADO PARA FLUTTER
// ==========================================
class LoginModalFlutter extends StatefulWidget {
  final Function(Map<String, dynamic> usuario) onLoginSuccess;

  const LoginModalFlutter({super.key, required this.onLoginSuccess});

  @override
  State<LoginModalFlutter> createState() => _LoginModalFlutterState();
}

class _LoginModalFlutterState extends State<LoginModalFlutter> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _manejarLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final respuesta = await http.post(
        Uri.parse("http://localhost:3001/api/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "correo": _correoController.text.trim(),
          "password": _passwordController.text.trim(),
        }),
      );

      final data = jsonDecode(respuesta.body);

      if (data["exito"] == true) {
        final usuarioEncontrado = data["usuario"];
        final rol = usuarioEncontrado["rol"].toString();

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("usuario", jsonEncode(usuarioEncontrado));
        
        final token = "jwt-$rol-${DateTime.now().millisecondsSinceEpoch}";
        await prefs.setString("token", token);

        if (mounted) Navigator.pop(context);

        if (mounted) {
          _mostrarAlerta(titulo: "Inicio exitoso", esExito: true);
        }

        // Enviamos el objeto completo del usuario devuelto por la BD
        widget.onLoginSuccess(usuarioEncontrado);
      } else {
        if (mounted) {
          _mostrarAlerta(
            titulo: "Error",
            mensaje: data["mensaje"] ?? "Correo o contraseña incorrectos",
            esExito: false,
          );
        }
      }
    } catch (error) {
      print(error);
      if (mounted) {
        _mostrarAlerta(
          titulo: "Error de conexión",
          mensaje: "No es posible conectarse al servidor",
          esExito: false,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _mostrarAlerta({required String titulo, String? mensaje, required bool esExito}) {
    showDialog(
      context: context,
      barrierDismissible: esExito,
      builder: (context) {
        if (esExito) {
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          });
        }
        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: esExito ? greenColor : Colors.redAccent, width: 1),
          ),
          title: Text(
            titulo,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: mensaje != null
              ? Text(mensaje, style: const TextStyle(color: Colors.grey, fontSize: 13), textAlign: TextAlign.center)
              : const Icon(Icons.check_circle, color: greenColor, size: 48),
          actions: esExito
              ? []
              : [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Aceptar'),
                    ),
                  ),
                ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: greenColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 24),
                    const Text(
                      'Iniciar Sesión',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Correo', style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _correoController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration("Ingresa tu correo"),
                  validator: (value) => value!.isEmpty ? 'Ingresa tu correo' : null,
                ),
                const SizedBox(height: 16),
                const Text('Contraseña', style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: _inputDecoration("Ingresa tu contraseña"),
                  validator: (value) => value!.isEmpty ? 'Ingresa tu contraseña' : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greenColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _isLoading ? null : _manejarLogin,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                          )
                        : const Text('Iniciar Sesión', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white30),
      filled: true,
      fillColor: const Color(0xFF121214),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: greenColor, width: 1),
      ),
    );
  }
}