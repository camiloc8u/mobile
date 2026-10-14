import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 1. Importamos tus servicios correctamente (subiendo 2 carpetas)
import '../../services/usuario_service.dart';

// 2. Importamos el modelo directo de tu carpeta Admin/modelos
import '../modelos/usuario.dart';

// 3. ✨ EL SECRETO REVELADO POR TU FOTO: Importamos los colores desde tu carpeta 'inicio' ✨
import '../../inicio/theme/app_colors.dart';

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
    final ctrlDocumento = TextEditingController(text: usuario?.numDoc ?? '');
    final ctrlCorreo = TextEditingController(text: usuario?.correo ?? '');
    final ctrlContra = TextEditingController();

    String rolSeguro = 'Cliente';
    if (usuario != null && ['Cliente', 'Administrador', 'Entrenador'].contains(usuario.rol)) {
      rolSeguro = usuario.rol;
    } else if (usuario != null && usuario.rol.toLowerCase() == 'administrador') {
      rolSeguro = 'Administrador'; 
    } else if (usuario != null && usuario.rol.toLowerCase() == 'entrenador') {
      rolSeguro = 'Entrenador'; 
    }

    String estadoSeguro = 'Activo';
    if (usuario != null) {
      if (['Activo', 'Inactivo'].contains(usuario.estadoCuenta)) {
        estadoSeguro = usuario.estadoCuenta;
      } else if (usuario.estadoCuenta.toLowerCase() == 'inactivo') {
        estadoSeguro = 'Inactivo';
      }
    }

    String rolSeleccionado = rolSeguro;
    String estadoSeleccionado = estadoSeguro;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              backgroundColor: AppColors.cardBg, // Usando tus colores reales
              title: Text(
                esEdicion ? 'Editar Miembro' : 'Nuevo Miembro',
                style: const TextStyle(color: AppColors.greenColor),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _crearCampoTexto(ctrlNombre, 'Primer Nombre', keyboardType: TextInputType.name, inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]'))]),
                    _crearCampoTexto(ctrlApellido, 'Primer Apellido', keyboardType: TextInputType.name, inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]'))]),
                    _crearCampoTexto(ctrlDocumento, 'Número de Documento', keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
                    _crearCampoTexto(ctrlCorreo, 'Correo Electrónico', keyboardType: TextInputType.emailAddress),
                    if (!esEdicion) _crearCampoTexto(ctrlContra, 'Contraseña', ocultarTexto: true),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: rolSeleccionado,
                      dropdownColor: AppColors.cardBg,
                      style: const TextStyle(color: Colors.white),
                      decoration: _decoracionInput('Rol'),
                      items: ['Cliente', 'Administrador', 'Entrenador'].map((rol) => DropdownMenuItem(value: rol, child: Text(rol))).toList(),
                      onChanged: (val) => setStateModal(() => rolSeleccionado = val!),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: estadoSeleccionado,
                      dropdownColor: AppColors.cardBg,
                      style: const TextStyle(color: Colors.white),
                      decoration: _decoracionInput('Estado'),
                      items: ['Activo', 'Inactivo'].map((estado) => DropdownMenuItem(value: estado, child: Text(estado))).toList(),
                      onChanged: (val) => setStateModal(() => estadoSeleccionado = val!),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar', style: TextStyle(color: Colors.grey))),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.greenColor),
                  onPressed: () async {
                    final Map<String, dynamic> datos = {
                      'primer_nombre': ctrlNombre.text,
                      'primer_apellido': ctrlApellido.text,
                      'num_doc': ctrlDocumento.text,
                      'correo': ctrlCorreo.text,
                      'rol': rolSeleccionado,
                      'estado_cuenta': estadoSeleccionado,
                    };

                    if (!esEdicion && ctrlContra.text.isNotEmpty) datos['password'] = ctrlContra.text;

                    try {
                      if (esEdicion) {
                        await UsuarioService.actualizarUsuario(usuario!.id, datos);
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
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.greenColor)),
    );
  }

  Widget _crearCampoTexto(TextEditingController controlador, String etiqueta, {bool ocultarTexto = false, List<TextInputFormatter>? inputFormatters, TextInputType? keyboardType}) {
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

  Widget _construirListaUsuarios(List<Usuario> usuarios) {
    if (usuarios.isEmpty) {
      return const Center(child: Text('No hay miembros en esta categoría', style: TextStyle(color: Colors.grey)));
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16),
      itemCount: usuarios.length,
      itemBuilder: (context, index) {
        final usuario = usuarios[index];
        final bool esActivo = usuario.estadoCuenta.toLowerCase() == 'activo';
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.fieldBg, // Usando tu color de campos
            borderRadius: BorderRadius.circular(8),
            border: esActivo ? null : Border.all(color: Colors.redAccent.withAlpha(50)),
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
                      style: TextStyle(
                        color: esActivo ? Colors.white : Colors.grey, 
                        fontWeight: FontWeight.bold, 
                        fontSize: 16
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(usuario.correo, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    usuario.rol.toUpperCase(),
                    style: const TextStyle(color: AppColors.greenColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: esActivo ? AppColors.greenColor.withAlpha(30) : Colors.redAccent.withAlpha(30),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      usuario.estadoCuenta.toUpperCase(),
                      style: TextStyle(
                        color: esActivo ? AppColors.greenColor : Colors.redAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.grey),
                onPressed: () => _mostrarFormularioUsuario(usuario: usuario),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Gestión de Miembros', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.greenColor, foregroundColor: Colors.black),
              icon: const Icon(Icons.add),
              label: const Text('NUEVO', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () => _mostrarFormularioUsuario(),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: DefaultTabController(
            length: 2, 
            child: Column(
              children: [
                const TabBar(
                  indicatorColor: AppColors.greenColor,
                  labelColor: AppColors.greenColor,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: 'ACTIVOS'),
                    Tab(text: 'INACTIVOS'),
                  ],
                ),
                Expanded(
                  child: FutureBuilder<List<Usuario>>(
                    future: _futurosUsuarios,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: AppColors.greenColor));
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.redAccent)));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No hay miembros registrados', style: TextStyle(color: Colors.grey)));
                      }

                      final todosLosUsuarios = snapshot.data!;
                      
                      final usuariosActivos = todosLosUsuarios.where((u) => u.estadoCuenta.toLowerCase() == 'activo').toList();
                      final usuariosInactivos = todosLosUsuarios.where((u) => u.estadoCuenta.toLowerCase() == 'inactivo').toList();

                      return TabBarView(
                        children: [
                          _construirListaUsuarios(usuariosActivos),
                          _construirListaUsuarios(usuariosInactivos),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}