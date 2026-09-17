import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../modelos/usuario.dart';
import '../colores/colores_app.dart';
import '../../services/usuario_service.dart';

class PestanaMiembros extends StatefulWidget {
  const PestanaMiembros({super.key});

  @override
  State<PestanaMiembros> createState() => _PestanaMiembrosState();
}

class _PestanaMiembrosState extends State<PestanaMiembros> {
  late Future<List<Usuario>> _futurosUsuarios;

  @override
  void initState() {
    super.initState();
    _actualizarLista();
  }

  void _actualizarLista() {
    setState(() {
      _futurosUsuarios = UsuarioService.obtenerUsuarios();
    });
  }

  void _mostrarFormularioUsuario({Usuario? usuario}) {
    final esEdicion = usuario != null;

    final ctrlNombre = TextEditingController(text: usuario?.nombre ?? '');
    final ctrlApellido = TextEditingController(text: usuario?.apellido ?? '');
    // Aseguramos que el documento se convierta a texto sin importar si viene como INT o String
    final ctrlDocumento = TextEditingController(text: usuario?.numDoc.toString() ?? '');
    final ctrlCorreo = TextEditingController(text: usuario?.correo ?? '');
    final ctrlContra = TextEditingController();

    // VALIDACIÓN SALVAVIDAS: Si el rol de la BD no coincide exacto, por defecto pone 'Cliente'
    String rolSeguro = 'Cliente';
    if (usuario != null && ['Cliente', 'Administrador', 'Entrenador'].contains(usuario.rol)) {
      rolSeguro = usuario.rol;
    } else if (usuario != null && usuario.rol.toLowerCase() == 'administrador') {
      rolSeguro = 'Administrador'; // Corrige minúsculas
    } else if (usuario != null && usuario.rol.toLowerCase() == 'entrenador') {
      rolSeguro = 'Entrenador'; // Corrige minúsculas
    }

    // VALIDACIÓN SALVAVIDAS para el Estado
    String estadoSeguro = 'Activo';
    if (usuario != null && ['Activo', 'Inactivo'].contains(usuario.estadoCuenta)) {
      estadoSeguro = usuario.estadoCuenta;
    } else if (usuario != null && usuario.estadoCuenta.toLowerCase() == 'inactivo') {
      estadoSeguro = 'Inactivo';
    }

    String rolSeleccionado = rolSeguro;
    String estadoSeleccionado = estadoSeguro;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
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
                    _crearCampoTexto(
                      ctrlNombre,
                      'Primer Nombre',
                      keyboardType: TextInputType.name,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]'))],
                    ),
                    _crearCampoTexto(
                      ctrlApellido,
                      'Primer Apellido',
                      keyboardType: TextInputType.name,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]'))],
                    ),
                    _crearCampoTexto(
                      ctrlDocumento,
                      'Número de Documento',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    _crearCampoTexto(
                      ctrlCorreo,
                      'Correo Electrónico',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    if (!esEdicion)
                      _crearCampoTexto(
                        ctrlContra,
                        'Contraseña',
                        ocultarTexto: true,
                      ),

                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: rolSeleccionado,
                      dropdownColor: ColoresApp.fondoTarjeta,
                      style: const TextStyle(color: Colors.white),
                      decoration: _decoracionInput('Rol'),
                      items: ['Cliente', 'Administrador', 'Entrenador'].map((rol) {
                        return DropdownMenuItem(value: rol, child: Text(rol));
                      }).toList(),
                      onChanged: (val) => setStateModal(() => rolSeleccionado = val!),
                    ),
                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      initialValue: estadoSeleccionado,
                      dropdownColor: ColoresApp.fondoTarjeta,
                      style: const TextStyle(color: Colors.white),
                      decoration: _decoracionInput('Estado'),
                      items: ['Activo', 'Inactivo'].map((estado) {
                        return DropdownMenuItem(value: estado, child: Text(estado));
                      }).toList(),
                      onChanged: (val) => setStateModal(() => estadoSeleccionado = val!),
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
                        await UsuarioService.actualizarUsuario(usuario.id, datos);
                      } else {
                        await UsuarioService.crearUsuario(datos);
                      }
                      _actualizarLista();
                      if (context.mounted) Navigator.pop(context);
                    } catch (e) {
                      print('Error al guardar usuario: $e');
                    }
                  },
                  child: const Text('Guardar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
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

  Widget _crearCampoTexto(
    TextEditingController controlador,
    String etiqueta, {
    bool ocultarTexto = false,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controlador,
        style: const TextStyle(color: Colors.white),
        obscureText: ocultarTexto,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
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
                // AQUÍ VEMOS EL ERROR REAL SI FALLA LA CARGA
                return Center(
                  child: Text(
                    'Error de conexión: ${snapshot.error}',
                    style: const TextStyle(color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ),
                );
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
                              Text(
                                '${usuario.nombre} ${usuario.apellido}',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(usuario.correo, style: const TextStyle(color: ColoresApp.textoGris, fontSize: 12)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              usuario.rol.toUpperCase(),
                              style: const TextStyle(color: ColoresApp.verdePrincipal, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              usuario.estadoCuenta,
                              style: TextStyle(
                                color: usuario.estadoCuenta.toLowerCase() == 'activo' ? Colors.white : Colors.red,
                                fontSize: 12,
                              ),
                            ),
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