import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../modelos/usuario.dart';
import '../colores/colores_app.dart';

class PestanaMiembros extends StatefulWidget {
  const PestanaMiembros({super.key});

  @override
  State<PestanaMiembros> createState() => _PestanaMiembrosState();
}

class _PestanaMiembrosState extends State<PestanaMiembros> {
  late Future<List<Usuario>> _futurosUsuarios;
  
  final String urlApi = 'http://192.168.1.12:3001/api/usuarios';

  @override
  void initState() {
    super.initState();
    _actualizarLista();
  }

  void _actualizarLista() {
    setState(() {
      _futurosUsuarios = obtenerUsuarios();
    });
  }

  Future<List<Usuario>> obtenerUsuarios() async {
    final response = await http.get(Uri.parse(urlApi));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Usuario.fromJson(data)).toList();
    } else {
      throw Exception('Fallo al cargar los usuarios');
    }
  }

  Future<void> crearUsuario(Map<String, dynamic> datosUsuario) async {
    final response = await http.post(
      Uri.parse(urlApi),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(datosUsuario),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      _actualizarLista();
    } else {
      throw Exception('Error al crear usuario');
    }
  }

  Future<void> actualizarUsuario(int id, Map<String, dynamic> datosUsuario) async {
    final response = await http.put(
      Uri.parse('$urlApi/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(datosUsuario),
    );
    if (response.statusCode == 200) {
      _actualizarLista();
    } else {
      throw Exception('Error al actualizar usuario');
    }
  }

  void _mostrarFormularioUsuario({Usuario? usuario}) {
    final esEdicion = usuario != null;
    
    final ctrlNombre = TextEditingController(text: usuario?.nombre ?? '');
    final ctrlApellido = TextEditingController(text: usuario?.apellido ?? '');
    final ctrlDocumento = TextEditingController(text: usuario?.numDoc ?? '');
    final ctrlCorreo = TextEditingController(text: usuario?.correo ?? '');
    final ctrlContra = TextEditingController(); 
    
    String rolSeleccionado = usuario?.rol ?? 'Cliente';
    String estadoSeleccionado = usuario?.estadoCuenta ?? 'Activo';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColoresApp.fondoTarjeta,
          title: Text(
            esEdicion ? 'Editar Miembro' : 'Nuevo Miembro',
            style: const TextStyle(color: ColoresApp.verdePrincipal),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _crearCampoTexto(ctrlNombre, 'Primer Nombre'),
                _crearCampoTexto(ctrlApellido, 'Primer Apellido'),
                _crearCampoTexto(ctrlDocumento, 'Número de Documento'),
                _crearCampoTexto(ctrlCorreo, 'Correo Electrónico'),
                if (!esEdicion) _crearCampoTexto(ctrlContra, 'Contraseña', ocultarTexto: true),
                
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: rolSeleccionado,
                  dropdownColor: ColoresApp.fondoTarjeta,
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoracionInput('Rol'),
                  items: ['Cliente', 'Administrador', 'Entrenador'].map((rol) {
                    return DropdownMenuItem(value: rol, child: Text(rol));
                  }).toList(),
                  onChanged: (val) => rolSeleccionado = val!,
                ),
                const SizedBox(height: 10),
                
                DropdownButtonFormField<String>(
                  value: estadoSeleccionado,
                  dropdownColor: ColoresApp.fondoTarjeta,
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoracionInput('Estado'),
                  items: ['Activo', 'Inactivo'].map((estado) {
                    return DropdownMenuItem(value: estado, child: Text(estado));
                  }).toList(),
                  onChanged: (val) => estadoSeleccionado = val!,
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
              style: ElevatedButton.styleFrom(backgroundColor: ColoresApp.verdePrincipal),
              onPressed: () async {
                final Map<String, dynamic> datos = {
                  'primer_nombre': ctrlNombre.text,
                  'primer_apellido': ctrlApellido.text,
                  'num_doc': ctrlDocumento.text,
                  'correo': ctrlCorreo.text,
                  'rol': rolSeleccionado,
                  'estado_cuenta': estadoSeleccionado,
                };
                
                if (!esEdicion && ctrlContra.text.isNotEmpty) {
                  datos['password'] = ctrlContra.text;
                }

                try {
                  if (esEdicion) {
                    await actualizarUsuario(usuario!.id, datos);
                  } else {
                    await crearUsuario(datos);
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

  InputDecoration _decoracionInput(String etiqueta) {
    return InputDecoration(
      labelText: etiqueta,
      labelStyle: const TextStyle(color: Colors.grey),
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: ColoresApp.verdePrincipal)),
    );
  }

  Widget _crearCampoTexto(TextEditingController controlador, String etiqueta, {bool ocultarTexto = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controlador,
        style: const TextStyle(color: Colors.white),
        obscureText: ocultarTexto,
        decoration: _decoracionInput(etiqueta),
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
                backgroundColor: ColoresApp.verdePrincipal,
                foregroundColor: Colors.black,
              ),
              icon: const Icon(Icons.add),
              label: const Text('NUEVO', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () => _mostrarFormularioUsuario(),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        Expanded(
          child: FutureBuilder<List<Usuario>>(
            future: _futurosUsuarios,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: ColoresApp.verdePrincipal));
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.redAccent)));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No hay miembros registrados', style: TextStyle(color: ColoresApp.textoGris)));
              }

              final usuarios = snapshot.data!;
              return ListView.builder(
                itemCount: usuarios.length,
                itemBuilder: (context, index) {
                  final usuario = usuarios[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColoresApp.fondoItem,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${usuario.nombre} ${usuario.apellido}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text(usuario.correo, style: const TextStyle(color: ColoresApp.textoGris, fontSize: 12)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(usuario.rol.toUpperCase(), style: const TextStyle(color: ColoresApp.verdePrincipal, fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(usuario.estadoCuenta, style: TextStyle(color: usuario.estadoCuenta == 'Activo' ? Colors.white : Colors.red, fontSize: 12)),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: ColoresApp.textoGris),
                          onPressed: () => _mostrarFormularioUsuario(usuario: usuario),
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