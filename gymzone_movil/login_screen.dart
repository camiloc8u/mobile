import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginModalFlutter extends StatefulWidget {
  // Ahora devuelve el rol Y el mapa completo del usuario
  final Function(String rol, Map<String, dynamic> usuario) onLoginSuccess;

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

        // Guardar en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("usuario", jsonEncode(usuarioEncontrado));
        
        final token = "jwt-$rol-${DateTime.now().millisecondsSinceEpoch}";
        await prefs.setString("token", token);

        // Cerrar modal
        if (mounted) Navigator.pop(context);

        // Mostrar alerta de éxito
        if (mounted) {
          _mostrarAlerta(
            titulo: "Inicio exitoso",
            esExito: true,
          );
        }

        // ¡AQUÍ ESTÁ LA CLAVE! Devolvemos el rol y el usuario real al main.dart
        widget.onLoginSuccess(rol, usuarioEncontrado);
        
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
          backgroundColor: const Color(0xFF18181B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: esExito ? const Color(0xFFAEE000) : Colors.redAccent, width: 1),
          ),
          title: Text(
            titulo,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: mensaje != null
              ? Text(mensaje, style: const TextStyle(color: Colors.grey, fontSize: 13), textAlign: TextAlign.center)
              : const Icon(Icons.check_circle, color: Color(0xFFAEE000), size: 48),
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
      backgroundColor: const Color(0xFF18181B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFAEE000), width: 1),
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
                      backgroundColor: const Color(0xFFAEE000),
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
        borderSide: BorderSide(color: Color(0xFFAEE000), width: 1),
      ),
    );
  }
}