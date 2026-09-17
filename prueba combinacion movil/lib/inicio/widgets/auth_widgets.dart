import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../Admin/pantallas/panel_principal.dart';
import '../../entrenador/pantallas/entrenador_screen.dart';
import '../../services/api_config.dart';
import '../../services/notification_service.dart';
import '../../services/usuario_service.dart';
import '../screens/client_home_screen.dart';
import '../theme/app_colors.dart'; // Usamos los colores globales

const _authCardBg = Color(0xFF131A26);
const _authFieldBg = Color(0xFF05070A);
const _authLabelColor = Color(0xFF8FA6B8);

class _AuthCornerPainter extends CustomPainter {
  const _AuthCornerPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.greenColor;
    const corner = 22.0;
    canvas.drawPath(
      Path()
      ..moveTo(0, 0)
      ..lineTo(corner, 0)
      ..lineTo(0, corner)
      ..close(),
      paint,
    );
    canvas.drawPath(
      Path()
      ..moveTo(size.width, size.height)
      ..lineTo(size.width - corner, size.height)
      ..lineTo(size.width, size.height - corner)
      ..close(),
      paint,
    );
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Widget _authField(String label, String hint, {bool obscureText = false, TextInputType? keyboardType, TextEditingController? controller, Widget? trailing}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: _authLabelColor, fontSize: 12, letterSpacing: 0.8))),
          ?trailing,
        ],
      ),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF6B7684)),
          filled: true,
          fillColor: _authFieldBg,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.greenColor), borderRadius: BorderRadius.zero),
        ),
      ),
    ],
  );
}

Widget _authShell(BuildContext context, {VoidCallback? onBack, required List<Widget> children}) {
  return Dialog(
    backgroundColor: Colors.transparent,
    insetPadding: const EdgeInsets.all(24),
    child: CustomPaint(
      foregroundPainter: const _AuthCornerPainter(),
      child: Container(
        width: 380,
        decoration: BoxDecoration(
          color: _authCardBg,
          border: Border.all(color: AppColors.greenColor),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (onBack != null)
                  IconButton(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back, color: Colors.white70),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white70),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ...children,
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _authTitle(String text, {IconData? icon, bool centered = false}) {
  return Column(
    crossAxisAlignment: centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: centered ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          if (icon != null) ...[Icon(icon, color: AppColors.greenColor, size: 22), const SizedBox(width: 8)],
          Flexible(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w300, letterSpacing: 1))),
        ],
      ),
      const SizedBox(height: 8),
      Container(width: 64, height: 3, color: AppColors.greenColor),
    ],
  );
}

Widget _authPrimaryButton(String label, VoidCallback onPressed) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.greenColor,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: const RoundedRectangleBorder(),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 0.5)),
    ),
  );
}

Widget _authSecondaryButton(String label, VoidCallback onPressed) {
  return SizedBox(
    width: double.infinity,
    child: OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: const BorderSide(color: Color(0xFF3A4654)),
        shape: const RoundedRectangleBorder(),
      ),
      child: Text(label, style: const TextStyle(color: _authLabelColor, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
    ),
  );
}

Widget _authFooter(String text, String link, VoidCallback onTap) {
  return Center(
    child: Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(text, style: const TextStyle(color: _authLabelColor, fontSize: 13)),
        GestureDetector(
          onTap: onTap,
          child: Text(link, style: const TextStyle(color: AppColors.greenColor, fontSize: 13, fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}

Future<void> showLoginDialog(BuildContext context) async {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      bool isLoading = false;
      String errorMessage = '';

      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return _authShell(
            dialogContext,
            children: [
              _authTitle('INICIAR SESIÓN'),
              const SizedBox(height: 20),
              _authField('EMAIL', 'tu@email.com', keyboardType: TextInputType.emailAddress, controller: emailCtrl),
              const SizedBox(height: 16),
              _authField(
                'CONTRASEÑA',
                '••••••••',
                obscureText: true,
                controller: passCtrl,
                trailing: GestureDetector(
                  onTap: () {
                    Navigator.of(dialogContext).pop();
                    showForgotPasswordDialog(context);
                  },
                  child: const Text('¿OLVIDASTE TU CONTRASEÑA?', style: TextStyle(color: AppColors.greenColor, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
              if (errorMessage.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(errorMessage, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
              ],
              const SizedBox(height: 20),
              _authPrimaryButton(
                'INICIAR SESIÓN',
                isLoading
                    ? () {}
                    : () async {
                        final email = emailCtrl.text.trim();
                        final password = passCtrl.text;

                        if (email.isEmpty || password.isEmpty) {
                          setStateDialog(() => errorMessage = 'Ingresa correo y contraseña');
                          return;
                        }

                        setStateDialog(() {
                          isLoading = true;
                          errorMessage = '';
                        });

                        try {
                          final ping = await http.get(Uri.parse('${ApiConfig.baseUrlNode}/usuarios')).timeout(const Duration(seconds: 8));
                          if (ping.statusCode < 200 || ping.statusCode >= 400) {
                            throw Exception('API no disponible');
                          }

                          final usuarioLogueado = await UsuarioService.login(email, password);

                          if (!Navigator.of(dialogContext).context.mounted) return;

                          if (usuarioLogueado != null) {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString('usuario', jsonEncode(usuarioLogueado));

                            await NotificationService().createInAppNotification(
                              title: 'Inicio de sesión',
                              message: 'Has iniciado sesión correctamente en GymZone.',
                              userId: int.tryParse('${usuarioLogueado['idusuario'] ?? 0}'),
                              broadcast: false,
                            );

                            if (!context.mounted) return;

                            Navigator.of(context).pop();

                            final rol = usuarioLogueado['rol']?.toString() ?? '';
                            if (rol == 'Administrador') {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PanelPrincipal()));
                            } else if (rol == 'Entrenador') {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => EntrenadorScreen(usuario: usuarioLogueado)));
                            } else {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ClientHomeScreen(usuario: usuarioLogueado)));
                            }
                          } else {
                            setStateDialog(() {
                              errorMessage = 'Correo o contraseña incorrectos';
                              isLoading = false;
                            });
                          }
                        } catch (e) {
                          setStateDialog(() {
                            errorMessage = 'Error de conexión con el servidor. Verifica que MySQL y la API estén activos.';
                            isLoading = false;
                          });
                        }
                      },
              ),
              const SizedBox(height: 16),
              _authFooter('¿No tienes cuenta? ', 'Regístrate aquí', () {
                  Navigator.of(dialogContext).pop();
                  showRegisterDialog(context);
              }),
            ],
          );
        },
      );
    },
  );
}

Future<void> showRegisterDialog(BuildContext context) async {
  final nombreCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      bool isLoading = false;
      String errorMessage = '';

      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return _authShell(
            dialogContext,
            children: [
              _authTitle('REGÍSTRATE'),
              const SizedBox(height: 20),
              _authField('NOMBRE COMPLETO', 'Tu nombre', controller: nombreCtrl),
              const SizedBox(height: 16),
              _authField('EMAIL', 'tu@email.com', keyboardType: TextInputType.emailAddress, controller: emailCtrl),
              const SizedBox(height: 16),
              _authField('CONTRASEÑA', '••••••••', obscureText: true, controller: passCtrl),
              const SizedBox(height: 16),
              _authField('TELÉFONO', '+57 123 456 789', keyboardType: TextInputType.phone, controller: phoneCtrl),
              if (errorMessage.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(errorMessage, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
              ],
              const SizedBox(height: 20),
              _authPrimaryButton(
                'CREAR CUENTA',
                isLoading
                    ? () {}
                    : () async {
                        final nombre = nombreCtrl.text.trim();
                        final email = emailCtrl.text.trim();
                        final password = passCtrl.text;

                        if (nombre.isEmpty || email.isEmpty || password.isEmpty) {
                          setStateDialog(() => errorMessage = 'Completa nombre, email y contraseña');
                          return;
                        }

                        setStateDialog(() {
                          isLoading = true;
                          errorMessage = '';
                        });

                        try {
                          final usuarioRegistrado = await UsuarioService.registrarCliente({
                            'primer_nombre': nombre,
                            'primer_apellido': '',
                            'tipo_doc': 'Cédula',
                            'num_doc': phoneCtrl.text.trim().replaceAll(RegExp(r'\D'), ''),
                            'correo': email,
                            'password': password,
                            'rol': 'Cliente',
                            'estado_cuenta': 'Activo',
                          });

                          await NotificationService().createInAppNotification(
                            title: 'Nuevo registro',
                            message: 'Tu cuenta se registró correctamente en GymZone.',
                            userId: int.tryParse('${usuarioRegistrado['idusuario'] ?? 0}'),
                            broadcast: false,
                          );

                          if (!context.mounted) return;

                          Navigator.of(context).pop();
                          showLoginDialog(context);
                          ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                            const SnackBar(content: Text('Cuenta creada. Ahora puedes iniciar sesión.'), backgroundColor: AppColors.greenColor),
                          );
                        } catch (e) {
                          setStateDialog(() {
                            errorMessage = 'No se pudo registrar en el servidor';
                            isLoading = false;
                          });
                        }
                      },
              ),
              const SizedBox(height: 16),
              _authFooter('¿Ya tienes cuenta? ', 'Inicia sesión', () {
                  Navigator.of(dialogContext).pop();
                  showLoginDialog(context);
              }),
            ],
          );
        },
      );
    },
  );
}

Future<void> showForgotPasswordDialog(BuildContext context) async {
  final emailCtrl = TextEditingController();
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => _authShell(
      dialogContext,
      onBack: () {
        Navigator.of(dialogContext).pop();
        showLoginDialog(context);
      },
      children: [
        _authTitle('RECUPERAR CONTRASEÑA', icon: Icons.mail_outline),
        const SizedBox(height: 16),
        const Text(
          'Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña.',
          style: TextStyle(color: _authLabelColor, fontSize: 13, height: 1.4),
        ),
        const SizedBox(height: 20),
        _authField('CORREO ELECTRÓNICO', 'tu@email.com', keyboardType: TextInputType.emailAddress, controller: emailCtrl),
        const SizedBox(height: 20),
        _authPrimaryButton('ENVIAR ENLACE', () {
            final email = emailCtrl.text.trim();
            Navigator.of(dialogContext).pop();
            showRecoveryEmailSentDialog(context, email);
        }),
        const SizedBox(height: 12),
        _authSecondaryButton('VOLVER AL LOGIN', () {
            Navigator.of(dialogContext).pop();
            showLoginDialog(context);
        }),
      ],
    ),
  );
}

Future<void> showRecoveryEmailSentDialog(BuildContext context, String email) async {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => _authShell(
      dialogContext,
      onBack: () {
        Navigator.of(dialogContext).pop();
        showForgotPasswordDialog(context);
      },
      children: [
        Center(
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.greenColor.withAlpha(30),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.greenColor, width: 2),
            ),
            child: const Icon(Icons.check_circle_outline, color: AppColors.greenColor, size: 34),
          ),
        ),
        const SizedBox(height: 20),
        Center(child: _authTitle('¡CORREO ENVIADO!', centered: true)),
        const SizedBox(height: 20),
        const Center(
          child: Text('Enviamos un enlace de recuperación a:', style: TextStyle(color: _authLabelColor, fontSize: 13)),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            email.isEmpty ? 'tu@email.com' : email,
            style: const TextStyle(color: AppColors.greenColor, fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'Revisa tu bandeja de entrada y carpeta de spam.',
            style: TextStyle(color: Color(0xFF6B7684), fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        _authPrimaryButton('VOLVER AL LOGIN', () {
            Navigator.of(dialogContext).pop();
            showLoginDialog(context);
        }),
      ],
    ),
  );
}