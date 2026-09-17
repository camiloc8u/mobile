import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import '../../Admin/pantallas/panel_principal.dart';
import 'client_home_screen.dart';
import '../../entrenador/pantallas/entrenador_screen.dart';
import '../../services/usuario_service.dart';
import '../../services/notification_service.dart';
import '../theme/app_colors.dart'; // Colores globales

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  void _mostrarDialogoLogin(BuildContext context) {
    final TextEditingController emailCtrl = TextEditingController();
    final TextEditingController passCtrl = TextEditingController();
    bool isLoading = false;
    String errorMessage = '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: AppColors.cardBg,
              title: const Text('Iniciar Sesión', style: TextStyle(color: AppColors.greenColor)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: emailCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('Correo'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passCtrl,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('Contraseña'),
                  ),
                  if (errorMessage.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(errorMessage, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.greenColor),
                  onPressed: isLoading
                      ? null
                      : () async {
                          setStateDialog(() {
                            isLoading = true;
                            errorMessage = '';
                          });

                          try {
                            final usuarioLogueado = await UsuarioService.login(emailCtrl.text.trim(), passCtrl.text);

                            if (!context.mounted) return;

                            if (usuarioLogueado != null) {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setString('usuario', jsonEncode(usuarioLogueado));
                              if (!context.mounted) return;

                              await NotificationService().createInAppNotification(
                                title: 'Inicio de sesión',
                                message: 'Has iniciado sesión correctamente en GymZone.',
                                userId: int.tryParse('${usuarioLogueado['idusuario'] ?? ''}'),
                              );
                              if (!context.mounted) return;
                              Navigator.pop(context);
                              String rol = usuarioLogueado['rol'];

                              if (rol == 'Administrador') {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PanelPrincipal()));
                              } else if (rol == 'Entrenador') {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EntrenadorScreen(usuario: usuarioLogueado)));
                              } else {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientHomeScreen(usuario: usuarioLogueado)));
                              }
                            } else {
                              setStateDialog(() {
                                errorMessage = 'Correo o contraseña incorrectos';
                                isLoading = false;
                              });
                            }
                          } catch (e) {
                            setStateDialog(() {
                              errorMessage = 'Error de conexión: $e';
                              isLoading = false;
                            });
                          }
                        },
                  child: isLoading
                      ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                      : const Text('Ingresar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _mostrarDialogoRegistro(BuildContext context) {
    final TextEditingController nombreCtrl = TextEditingController();
    final TextEditingController apellidoCtrl = TextEditingController();
    final TextEditingController docCtrl = TextEditingController();
    final TextEditingController emailCtrl = TextEditingController();
    final TextEditingController passCtrl = TextEditingController();

    bool isLoading = false;
    String errorMessage = '';
    String tipoDocumento = 'Cédula';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: AppColors.cardBg,
              title: const Text('Registrarse', style: TextStyle(color: AppColors.greenColor)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nombreCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Primer Nombre'),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]'))],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: apellidoCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Primer Apellido'),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]'))],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: tipoDocumento,
                      dropdownColor: AppColors.cardBg,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Tipo de Documento'),
                      items: ['Cédula', 'Cédula de Extranjería'].map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo))).toList(),
                      onChanged: (value) {
                        if (value != null) setStateDialog(() => tipoDocumento = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: docCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Número de Documento'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Correo Electrónico'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: passCtrl,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Contraseña'),
                    ),
                    if (errorMessage.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(errorMessage, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.greenColor),
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (nombreCtrl.text.isEmpty || apellidoCtrl.text.isEmpty || docCtrl.text.isEmpty || emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
                            setStateDialog(() => errorMessage = 'Por favor, llena todos los campos');
                            return;
                          }

                          setStateDialog(() {
                            isLoading = true;
                            errorMessage = '';
                          });

                          try {
                            final Map<String, dynamic> datosRegistro = {
                              'primer_nombre': nombreCtrl.text.trim(),
                              'primer_apellido': apellidoCtrl.text.trim(),
                              'tipo_doc': tipoDocumento,
                              'num_doc': docCtrl.text.trim(),
                              'correo': emailCtrl.text.trim(),
                              'password': passCtrl.text,
                              'rol': 'Cliente',
                              'estado_cuenta': 'Activo',
                            };

                            final usuarioRegistrado = await UsuarioService.registrarCliente(datosRegistro);
                            await NotificationService().createInAppNotification(
                              title: 'Cuenta creada',
                              message: 'Tu cuenta de GymZone fue creada correctamente.',
                              userId: int.tryParse('${usuarioRegistrado['idusuario'] ?? 0}'),
                              broadcast: false,
                            );

                            if (!context.mounted) return;

                            Navigator.pop(context);

                            Map<String, dynamic> nuevoUsuario = {
                              'primer_nombre': nombreCtrl.text.trim(),
                              'primer_apellido': apellidoCtrl.text.trim(),
                              'correo': emailCtrl.text.trim(),
                              'rol': 'Cliente',
                            };

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ClientHomeScreen(usuario: nuevoUsuario)),
                            );
                          } catch (e) {
                            setStateDialog(() {
                              errorMessage = 'Error de conexión';
                              isLoading = false;
                            });
                          }
                        },
                  child: isLoading
                      ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                      : const Text('Registrar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ✅ AQUÍ ESTABA EL ERROR: Se eliminó el 'const' de InputDecoration
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.greenColor)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('MI PERFIL', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_outline, size: 80, color: AppColors.greenColor),
              const SizedBox(height: 24),
              const Text(
                '¿Aún no eres miembro?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Únete a GYMZONE y comienza tu transformación hoy',
                style: TextStyle(color: Colors.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _mostrarDialogoLogin(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenColor,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('INICIAR SESIÓN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _mostrarDialogoRegistro(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.greenColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('REGISTRARSE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.greenColor)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}