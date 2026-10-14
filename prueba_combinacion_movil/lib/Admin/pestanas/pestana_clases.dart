import 'package:flutter/material.dart';
import '../modelos/clase.dart';
import '../colores/colores_app.dart';
import '../../services/clase_service.dart';

class PestanaClases extends StatefulWidget {
  const PestanaClases({super.key});

  @override
  State<PestanaClases> createState() => _PestanaClasesState();
}

class _PestanaClasesState extends State<PestanaClases> {
  late Future<List<Clase>> _futurasClases;

  @override
  void initState() {
    super.initState();
    _actualizarLista();
  }

  void _actualizarLista() {
    setState(() {
      _futurasClases = ClaseService.obtenerClases();
    });
  }

  void _mostrarFormularioClase({Clase? clase}) {
    final esEdicion = clase != null;
    
    final ctrlNombre = TextEditingController(text: clase?.nombre ?? '');
    final ctrlHorario = TextEditingController(text: clase?.horario ?? '');
    final ctrlEntrenador = TextEditingController(text: clase?.entrenador ?? '');
    final ctrlCupo = TextEditingController(text: clase?.cupo ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColoresApp.fondoTarjeta,
          title: Text(
            esEdicion ? 'Editar Clase' : 'Nueva Clase',
            style: const TextStyle(color: ColoresApp.verdePrincipal),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _crearCampoTexto(ctrlNombre, 'Nombre de la clase (Ej. Yoga)'),
                _crearCampoTexto(ctrlHorario, 'Horario (Ej. Lunes 8:00 AM)'),
                _crearCampoTexto(ctrlEntrenador, 'Entrenador'),
                _crearCampoTexto(ctrlCupo, 'Cupo máximo (Ej. 20)'),
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
                  'nombre': ctrlNombre.text,
                  'horario': ctrlHorario.text,
                  'entrenador': ctrlEntrenador.text,
                  'cupo': ctrlCupo.text,
                };

                try {
                  if (esEdicion) {
                    await ClaseService.actualizarClase(clase.id, datos);
                  } else {
                    await ClaseService.crearClase(datos);
                  }
                  _actualizarLista();
                  if (context.mounted) Navigator.pop(context);
                } catch (e) {
                  print(e);
                }
              },
              child: const Text('Guardar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _confirmarEliminacion(String id, String nombreClase) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColoresApp.fondoTarjeta,
          title: const Text('Confirmar Eliminación', style: TextStyle(color: Colors.redAccent)),
          content: Text(
            '¿Estás seguro de que deseas eliminar la clase "$nombreClase"?',
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () async {
                try {
                  await ClaseService.eliminarClase(id);
                  _actualizarLista();
                  if (context.mounted) Navigator.pop(context);
                } catch(e) {
                  print(e);
                }
              },
              child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
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

  Widget _crearCampoTexto(TextEditingController controlador, String etiqueta) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controlador,
        style: const TextStyle(color: Colors.white),
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
              'Gestión de Clases',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColoresApp.verdePrincipal,
                foregroundColor: Colors.black,
              ),
              icon: const Icon(Icons.add),
              label: const Text('NUEVA', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () => _mostrarFormularioClase(),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        Expanded(
          child: FutureBuilder<List<Clase>>(
            future: _futurasClases,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: ColoresApp.verdePrincipal));
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.redAccent)));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No hay clases registradas', style: TextStyle(color: ColoresApp.textoGris)));
              }

              final clases = snapshot.data!;
              return ListView.builder(
                itemCount: clases.length,
                itemBuilder: (context, index) {
                  final clase = clases[index];
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
                              Text(clase.nombre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, color: ColoresApp.textoGris, size: 14),
                                  const SizedBox(width: 4),
                                  Text(clase.horario, style: const TextStyle(color: ColoresApp.textoGris, fontSize: 12)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.person, color: ColoresApp.textoGris, size: 14),
                                  const SizedBox(width: 4),
                                  Text('Entrenador: ${clase.entrenador}', style: const TextStyle(color: ColoresApp.textoGris, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('CUPO', style: TextStyle(color: ColoresApp.textoGris, fontSize: 10, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(clase.cupo, style: const TextStyle(color: ColoresApp.verdePrincipal, fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: ColoresApp.textoGris),
                              onPressed: () => _mostrarFormularioClase(clase: clase),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () => _confirmarEliminacion(clase.id, clase.nombre),
                            ),
                          ],
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