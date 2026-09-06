import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gym Admin Dashboard',
      home: AdminDashboardScreen(),
    );
  }
}

//PANTALLA PRINCIPAL
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  static const Color primaryGreen = Color(0xFF90EE00);
  static const Color bgColor = Color(0xFF000000);
  static const Color cardBg = Color(0xFF18181B);
  static const Color itemBg = Color(0xFF0E0E10);
  static const Color textGrey = Color(0xFFA1A1AA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: DefaultTabController(
          length: 4,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                            children: [
                              TextSpan(
                                text: 'PANEL DE ',
                                style: TextStyle(color: Color(0xFF3F3F46)),
                              ),
                              TextSpan(
                                text: 'ADMINISTRACIÓN',
                                style: TextStyle(color: primaryGreen),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Gestión del gimnasio GYMZONE',
                          style: TextStyle(color: textGrey, fontSize: 14),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 28),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),

                // 2. TABS
                const TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: primaryGreen,
                  indicatorWeight: 3,
                  labelColor: primaryGreen,
                  unselectedLabelColor: textGrey,
                  dividerColor: Color(0xFF27272A),
                  tabs: [
                    Tab(text: 'RESUMEN'),
                    Tab(text: 'MIEMBROS'),
                    Tab(text: 'CLASES'),
                    Tab(text: 'FINANZAS'),
                  ],
                ),
                
                const SizedBox(height: 20),

                //CONTENIDO DE LAS PESTAÑAS
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildResumenTab(context),
                      const MembersTab(), // <--- Pestaña conectada al backend
                      const Center(child: Text('Vista de Clases', style: TextStyle(color: Colors.white))),
                      const Center(child: Text('Vista de Finanzas', style: TextStyle(color: Colors.white))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // "RESUMEN"
  Widget _buildResumenTab(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tarjetas KPI Superiores
          if (isMobile) ...[
            _buildKpiCard(Icons.people_alt_outlined, 'Miembros Activos', '324'),
            const SizedBox(height: 12),
            _buildKpiCard(Icons.attach_money, 'Ingresos del Mes', '\$28.5M'),
            const SizedBox(height: 12),
            _buildKpiCard(Icons.calendar_today_outlined, 'Clases Programadas', '48'),
          ] else ...[
            Row(
              children: [
                Expanded(child: _buildKpiCard(Icons.people_alt_outlined, 'Miembros Activos', '324')),
                const SizedBox(width: 16),
                Expanded(child: _buildKpiCard(Icons.attach_money, 'Ingresos del Mes', '\$28.5M')),
                const SizedBox(width: 16),
                Expanded(child: _buildKpiCard(Icons.calendar_today_outlined, 'Clases Programadas', '48')),
              ],
            ),
          ],
          
          const SizedBox(height: 24),

          // Secciones Inferiores
          if (isMobile) ...[
            _buildMembersCard(),
            const SizedBox(height: 16),
            _buildClassesCard(),
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildMembersCard()),
                const SizedBox(width: 16),
                Expanded(child: _buildClassesCard()),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMembersCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NUEVOS MIEMBROS',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildMemberTile('Saray Castiblanco', 'PREMIUM', 'Ene 2024'),
          _buildMemberTile('Carlos Martínez', 'PREMIUM', 'Ene 2025'),
          _buildMemberTile('Ana López', 'ELITE', 'Feb 2025', isLast: true),
        ],
      ),
    );
  }

  Widget _buildClassesCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CLASES POPULARES',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildClassTile('Spinning', 'Lunes • 7:00 AM', '18/20'),
          _buildClassTile('CrossFit', 'Lunes • 6:00 PM', '15/15'),
          _buildClassTile('Yoga', 'Martes • 9:00 AM', '12/25', isLast: true),
        ],
      ),
    );
  }

  // --- WIDGETS REUTILIZABLES ---
  Widget _buildKpiCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryGreen, size: 28),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: textGrey, fontSize: 13)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberTile(String name, String plan, String date, {bool isLast = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: itemBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text(plan, style: const TextStyle(color: textGrey, fontSize: 11, letterSpacing: 0.5)),
            ],
          ),
          Text(date, style: const TextStyle(color: primaryGreen, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildClassTile(String name, String schedule, String capacity, {bool isLast = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: itemBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text(schedule, style: const TextStyle(color: textGrey, fontSize: 11)),
            ],
          ),
          Text(capacity, style: const TextStyle(color: primaryGreen, fontSize: 13)),
        ],
      ),
    );
  }
}

// --- MODELO DE DATOS ACTUALIZADO ---
class Usuario {
  final int id;
  final String nombre;
  final String apellido;
  final String numDoc;
  final String rol;
  final String estadoCuenta;
  final String correo;

  Usuario({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.numDoc,
    required this.rol,
    required this.estadoCuenta,
    required this.correo,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['idusuario'] ?? 0,
      nombre: json['primer_nombre'] ?? '',
      apellido: json['primer_apellido'] ?? '',
      numDoc: json['num_doc'] ?? '',
      rol: json['rol'] ?? 'Cliente',
      estadoCuenta: json['estado_cuenta'] ?? 'Activo',
      correo: json['correo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'primer_nombre': nombre,
      'primer_apellido': apellido,
      'num_doc': numDoc,
      'rol': rol,
      'estado_cuenta': estadoCuenta,
      'correo': correo,
    };
  }
}

// --- PESTAÑA DE MIEMBROS ---
class MembersTab extends StatefulWidget {
  const MembersTab({super.key});

  @override
  State<MembersTab> createState() => _MembersTabState();
}

class _MembersTabState extends State<MembersTab> {
  late Future<List<Usuario>> _futureUsuarios;
  
  // URL DE LA API. Si estás en emulador de Android, cambia 127.0.0.1 por 10.0.2.2
final String apiUrl = 'http://192.168.1.12:3001/api/usuarios';

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() {
    setState(() {
      _futureUsuarios = fetchUsuarios();
    });
  }

  // GET

  
  Future<List<Usuario>> fetchUsuarios() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Usuario.fromJson(data)).toList();
    } else {
      throw Exception('Fallo al cargar los usuarios');
    }
  }

  // POST
  Future<void> createUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      _refreshList();
    } else {
      throw Exception('Error al crear usuario');
    }
  }

  // PUT
  Future<void> updateUser(int id, Map<String, dynamic> userData) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );
    if (response.statusCode == 200) {
      _refreshList();
    } else {
      throw Exception('Error al actualizar usuario');
    }
  }

  // --- MODAL / FORMULARIO ---
  void _showUserFormDialog({Usuario? user}) {
    final isEdit = user != null;
    
    final nombreCtrl = TextEditingController(text: user?.nombre ?? '');
    final apellidoCtrl = TextEditingController(text: user?.apellido ?? '');
    final docCtrl = TextEditingController(text: user?.numDoc ?? '');
    final correoCtrl = TextEditingController(text: user?.correo ?? '');
    final passCtrl = TextEditingController(); 
    
    String selectedRol = user?.rol ?? 'Cliente';
    String selectedEstado = user?.estadoCuenta ?? 'Activo';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AdminDashboardScreen.cardBg,
          title: Text(
            isEdit ? 'Editar Miembro' : 'Nuevo Miembro',
            style: const TextStyle(color: AdminDashboardScreen.primaryGreen),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nombreCtrl, 'Primer Nombre'),
                _buildTextField(apellidoCtrl, 'Primer Apellido'),
                _buildTextField(docCtrl, 'Número de Documento'),
                _buildTextField(correoCtrl, 'Correo Electrónico'),
                if (!isEdit) _buildTextField(passCtrl, 'Contraseña', obscureText: true),
                
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedRol,
                  dropdownColor: AdminDashboardScreen.cardBg,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Rol'),
                  items: ['Cliente', 'Administrador', 'Entrenador'].map((rol) {
                    return DropdownMenuItem(value: rol, child: Text(rol));
                  }).toList(),
                  onChanged: (val) => selectedRol = val!,
                ),
                const SizedBox(height: 10),
                
                DropdownButtonFormField<String>(
                  value: selectedEstado,
                  dropdownColor: AdminDashboardScreen.cardBg,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Estado'),
                  items: ['Activo', 'Inactivo'].map((estado) {
                    return DropdownMenuItem(value: estado, child: Text(estado));
                  }).toList(),
                  onChanged: (val) => selectedEstado = val!,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AdminDashboardScreen.primaryGreen),
              onPressed: () async {
                final Map<String, dynamic> data = {
                  'primer_nombre': nombreCtrl.text,
                  'primer_apellido': apellidoCtrl.text,
                  'num_doc': docCtrl.text,
                  'correo': correoCtrl.text,
                  'rol': selectedRol,
                  'estado_cuenta': selectedEstado,
                };
                
                if (!isEdit && passCtrl.text.isNotEmpty) {
                  data['password'] = passCtrl.text;
                }

                try {
                  if (isEdit) {
                    await updateUser(user!.id, data);
                  } else {
                    await createUser(data);
                  }
                  if (context.mounted) Navigator.pop(context);
                } catch (e) {
                  print(e);
                }
              },
              child: const Text(
                'Guardar', 
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
              ),
            ),
          ],
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AdminDashboardScreen.primaryGreen)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        obscureText: obscureText,
        decoration: _inputDecoration(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Gestión de Miembros',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AdminDashboardScreen.primaryGreen,
                foregroundColor: Colors.black,
              ),
              icon: const Icon(Icons.add),
              label: const Text('NUEVO', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () => _showUserFormDialog(),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        Expanded(
          child: FutureBuilder<List<Usuario>>(
            future: _futureUsuarios,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: AdminDashboardScreen.primaryGreen));
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.redAccent)));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No hay miembros registrados', style: TextStyle(color: AdminDashboardScreen.textGrey)));
              }

              final usuarios = snapshot.data!;
              return ListView.builder(
                itemCount: usuarios.length,
                itemBuilder: (context, index) {
                  final user = usuarios[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AdminDashboardScreen.itemBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${user.nombre} ${user.apellido}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text(user.correo, style: const TextStyle(color: AdminDashboardScreen.textGrey, fontSize: 12)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(user.rol.toUpperCase(), style: const TextStyle(color: AdminDashboardScreen.primaryGreen, fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(user.estadoCuenta, style: TextStyle(color: user.estadoCuenta == 'Activo' ? Colors.white : Colors.red, fontSize: 12)),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: AdminDashboardScreen.textGrey),
                          onPressed: () => _showUserFormDialog(user: user),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}