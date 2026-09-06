import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileTab extends StatefulWidget {
  final Map<String, dynamic>? usuario;

  const ProfileTab({super.key, this.usuario});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String nombre = 'Cargando...';
  String email = '';
  String telefono = 'No registrado';
  String planActual = 'PREMIUM';

  late TextEditingController _nombreController;
  late TextEditingController _emailController;
  late TextEditingController _telefonoController;
  String _planSeleccionado = 'PREMIUM';

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController();
    _emailController = TextEditingController();
    _telefonoController = TextEditingController();
    _sincronizarDatos();
  }

  @override
  void didUpdateWidget(covariant ProfileTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.usuario != oldWidget.usuario) {
      _sincronizarDatos();
    }
  }

  void _sincronizarDatos() {
    if (widget.usuario != null) {
      setState(() {
        String pNombre = widget.usuario!['primer_nombre'] ?? '';
        String sNombre = widget.usuario!['segundo_nombre'] ?? '';
        String pApellido = widget.usuario!['primer_apellido'] ?? '';
        String sApellido = widget.usuario!['segundo_apellido'] ?? '';
        
        nombre = '$pNombre $sNombre $pApellido $sApellido'
            .replaceAll(RegExp(r'\s+'), ' ')
            .trim();
            
        email = widget.usuario!['correo'] ?? '';
        telefono = widget.usuario!['telefono'] ?? 'No registrado';
        planActual = widget.usuario!['planActual'] ?? widget.usuario!['plan_actual'] ?? 'PREMIUM';
        _planSeleccionado = planActual;
      });
    } else {
      setState(() {
        nombre = 'Inicia sesión para continuar';
        email = '';
        telefono = 'No registrado';
      });
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  Future<void> _actualizarPerfilBackend(String nuevoNombre, String nuevoEmail, String nuevoTelefono, String nuevoPlan) async {
    final int? userId = widget.usuario?['idusuario'] ?? widget.usuario?['id'];
    if (userId == null) return;

    try {
      final response = await http.put(
        Uri.parse('http://localhost:3001/api/usuario/$userId'), 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nuevoNombre,
          'email': nuevoEmail,
          'telefono': nuevoTelefono,
          'plan_actual': nuevoPlan, // <--- Enviado a MySQL
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          nombre = nuevoNombre;
          email = nuevoEmail;
          telefono = nuevoTelefono;
          planActual = nuevoPlan;
        });
        _mostrarMensaje('¡Perfil y membresía actualizados en MySQL!');
      } else {
        _mostrarMensaje('Error al actualizar en el servidor');
      }
    } catch (e) {
      setState(() {
        nombre = nuevoNombre;
        email = nuevoEmail;
        telefono = nuevoTelefono;
        planActual = nuevoPlan;
      });
      _mostrarMensaje('Actualizado localmente (Revisa conexión con backend)');
    }
  }

  void _mostrarMensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto), backgroundColor: const Color(0xFF18181B)),
    );
  }

  void _mostrarModalEditarPerfil() {
    _nombreController.text = nombre;
    _emailController.text = email;
    _telefonoController.text = telefono;
    _planSeleccionado = planActual;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              backgroundColor: const Color(0xFF18181B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFAEE000), width: 1),
              ),
              title: const Text('EDITAR PERFIL Y MEMBRESÍA', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('NOMBRE COMPLETO', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    const SizedBox(height: 6),
                    TextField(controller: _nombreController, style: const TextStyle(color: Colors.white, fontSize: 14), decoration: _inputDecoration()),
                    const SizedBox(height: 12),
                    const Text('EMAIL', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    const SizedBox(height: 6),
                    TextField(controller: _emailController, style: const TextStyle(color: Colors.white, fontSize: 14), decoration: _inputDecoration()),
                    const SizedBox(height: 12),
                    const Text('TELÉFONO', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    const SizedBox(height: 6),
                    TextField(controller: _telefonoController, style: const TextStyle(color: Colors.white, fontSize: 14), decoration: _inputDecoration()),
                    const SizedBox(height: 12),
                    const Text('PLAN DE MEMBRESÍA', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: ['PREMIUM', 'BASICO', 'VIP'].contains(_planSeleccionado) ? _planSeleccionado : 'PREMIUM',
                      dropdownColor: const Color(0xFF18181B),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: _inputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'PREMIUM', child: Text('PREMIUM (80,000)')),
                        DropdownMenuItem(value: 'BASICO', child: Text('BASICO (50,000)')),
                        DropdownMenuItem(value: 'VIP', child: Text('VIP (120,000)')),
                      ],
                      onChanged: (value) {
                        setStateModal(() {
                          _planSeleccionado = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFAEE000), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 12)),
                      onPressed: () {
                        Navigator.pop(context);
                        _actualizarPerfilBackend(
                          _nombreController.text,
                          _emailController.text,
                          _telefonoController.text,
                          _planSeleccionado,
                        );
                      },
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('GUARDAR EN MYSQL', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.grey), padding: const EdgeInsets.symmetric(vertical: 12)),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('CANCELAR', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF121214),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFAEE000))),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.usuario == null) {
      return const Center(
        child: Text(
          'Inicia sesión para ver tu perfil',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    double precioPlan = 80000;
    if (planActual == 'BASICO') precioPlan = 50000;
    if (planActual == 'VIP') precioPlan = 120000;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. TARJETA DE INFORMACIÓN DE PERFIL
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFF18181B), borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(border: Border.all(color: const Color(0xFFAEE000)), borderRadius: BorderRadius.circular(4)),
                      child: const Icon(Icons.person, color: Color(0xFFAEE000), size: 32),
                    ),
                    const SizedBox(height: 12),
                    Text(nombre, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 2),
                    Text(email, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const Divider(color: Colors.grey, height: 24),
                    _buildInfoRow('Teléfono:', telefono),
                    _buildInfoRow('Miembro desde:', 'Enero 2024'),
                    _buildInfoRow('Plan actual:', planActual, isHighlight: true),
                    _buildInfoRow('Próximo pago:', '15 Enero 2025'),
                    _buildInfoRow('Sesiones restantes:', '3'),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFAEE000)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _mostrarModalEditarPerfil,
                        child: const Text('EDITAR PERFIL Y MEMBRESÍA', style: TextStyle(color: Color(0xFFAEE000))),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 2. SECCIÓN DE MEMBRESÍA DINÁMICA
              const Text(
                'MEMBRESÍA',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF18181B),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFAEE000), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PLAN $planActual', style: const TextStyle(color: Color(0xFFAEE000), fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('\$${precioPlan.toInt()}/mes', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildBenefitRow('Acceso total a los beneficios del plan'),
                    _buildBenefitRow('Acceso a todas las sedes y máquinas'),
                    _buildBenefitRow('Clases grupales ilimitadas'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(color: isHighlight ? const Color(0xFFAEE000) : Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.check, color: Color(0xFFAEE000), size: 16),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}