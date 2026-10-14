import 'package:flutter/material.dart';

// Importamos tu servicio
import '../../services/clase_service.dart'; 
import '../colores_entrenador.dart'; 
import '../vistas/inicio_vista.dart';
import '../vistas/clases_vista.dart';
import '../vistas/vista_calendario.dart';
import '../vistas/clientes_vista.dart';

class TrainerDashboardScreen extends StatefulWidget {
  final Map<String, dynamic>? usuario;
  const TrainerDashboardScreen({super.key, this.usuario});

  @override
  State<TrainerDashboardScreen> createState() => _TrainerDashboardScreenState();
}

class _TrainerDashboardScreenState extends State<TrainerDashboardScreen> {
  int _selectedIndex = 0;
  bool _isLoading = false;

  // Lista que alimenta las vistas (arranca vacía)
  List<Map<String, String>> _classes = [];

  final List<Map<String, String>> _assignedClients = [
    {'name': 'Carlos Mendoza', 'plan': 'Hipertrofia', 'status': 'Asignado por Admin', 'phone': '3001234567', 'assignedDate': '01/09/2026'},
    {'name': 'Ana María Gómez', 'plan': 'Pérdida de Peso', 'status': 'Asignado por Admin', 'phone': '3109876543', 'assignedDate': '15/08/2026'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchClases(); // Llama a la API al abrir la pantalla
  }

  // --- LLAMADAS AL SERVICIO DE LA API ---

  Future<void> _fetchClases() async {
    setState(() => _isLoading = true);
    try {
      final clasesObtenidas = await ClaseService.obtenerClases();
      
      setState(() {
        _classes = clasesObtenidas.map((c) => {
          'id': c.id,
          'name': c.nombre, 
          'time': c.horario, 
          'capacity': c.cupo, 
          // Datos por defecto mientras los agregas a tu modelo y a MockAPI
          'shift': 'Mañana', 
          'room': 'Zona General',
          'date': DateTime.now().toIso8601String().split('T')[0],
        }).toList();
      });
    } catch (e) {
      debugPrint('Error al cargar las clases: $e'); 
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al conectar con el servidor'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _crearClaseApi(Map<String, dynamic> nuevaClase) async {
    setState(() => _isLoading = true);
    try {
      await ClaseService.crearClase(nuevaClase);
      await _fetchClases(); // Recarga la lista para mostrar la nueva clase
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Clase publicada correctamente'), backgroundColor: ColoresEntrenador.verde),
        );
      }
    } catch (e) {
      debugPrint('Error al crear: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar la clase'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  Future<void> _eliminarClaseApi(String id) async {
    setState(() => _isLoading = true);
    try {
      await ClaseService.eliminarClase(id);
      await _fetchClases(); // Actualiza la pantalla
    } catch (e) {
      debugPrint('Error al eliminar: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo eliminar la clase'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  // --- LÓGICA DE VENTANAS EMERGENTES (DIALOGS) ---

  void _openAddClassDialog() {
    final nameController = TextEditingController();
    final timeController = TextEditingController();
    final capacityController = TextEditingController();
    String selectedShift = 'Mañana';
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            backgroundColor: ColoresEntrenador.tarjeta,
            title: const Text('Nueva Clase', style: TextStyle(color: Colors.white)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_month, color: ColoresEntrenador.verde),
                    title: const Text('Día de la clase', style: TextStyle(color: Colors.white)),
                    subtitle: Text('${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}', style: const TextStyle(color: Colors.grey)),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2035),
                      );
                      if (picked != null) setDialogState(() => selectedDate = picked);
                    },
                  ),
                  TextField(controller: nameController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Actividad (Ej: Pierna)', labelStyle: TextStyle(color: Colors.grey))),
                  TextField(controller: timeController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Horario (Ej: 07:00 AM)', labelStyle: TextStyle(color: Colors.grey))),
                  TextField(controller: capacityController, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Cupo Máximo', labelStyle: TextStyle(color: Colors.grey))),
                  const SizedBox(height: 12),
                  DropdownButton<String>(
                    dropdownColor: ColoresEntrenador.tarjeta,
                    value: selectedShift,
                    isExpanded: true,
                    style: const TextStyle(color: ColoresEntrenador.verde, fontWeight: FontWeight.bold),
                    items: ['Mañana', 'Tarde', 'Noche'].map((v) => DropdownMenuItem(value: v, child: Text('Turno $v'))).toList(),
                    onChanged: (val) => setDialogState(() => selectedShift = val!),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar', style: TextStyle(color: Colors.grey))),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: ColoresEntrenador.verde),
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    Navigator.pop(context);
                    
                    // Aseguramos que los nombres coincidan con los de tu modelo "Clase"
                    final nuevaClase = {
                      'nombre': nameController.text,
                      'horario': timeController.text.isEmpty ? '08:00 AM' : timeController.text,
                      'entrenador': widget.usuario?['primer_nombre'] ?? 'Entrenador Asignado',
                      'cupo': capacityController.text.isEmpty ? '10' : capacityController.text,
                      // Estos los enviamos por si luego actualizas tu modelo y MockAPI
                      'sala': 'Sala Principal',
                      'turno': selectedShift,
                      'fecha': selectedDate.toIso8601String().split('T')[0],
                    };

                    _crearClaseApi(nuevaClase);
                  }
                },
                child: const Text('Guardar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showClassDetails(Map<String, String> item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColoresEntrenador.tarjeta,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(item['name']!, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Turno: ${item['shift']} | Hora: ${item['time']}', style: const TextStyle(color: Colors.grey)),
            Text('Cupos: ${item['capacity']}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                Navigator.pop(context);
                if (item['id'] != null && item['id']!.isNotEmpty) {
                  _eliminarClaseApi(item['id']!);
                }
              },
              child: const Text('Eliminar Clase', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _requestClientFromAdmin() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Solicitud enviada al Administrador')));
  }

  void _showClientDetails(Map<String, String> client) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColoresEntrenador.tarjeta,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(client['name']!, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Teléfono: ${client['phone']}', style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      VistaInicio(clases: _classes, totalClientes: _assignedClients.length, cambiarPestana: (idx) => setState(() => _selectedIndex = idx), abrirDialogo: _openAddClassDialog, verDetalles: _showClassDetails),
      VistaClases(clases: _classes, abrirDialogo: _openAddClassDialog, verDetalles: _showClassDetails),
      VistaCalendario(clases: _classes, verDetalles: _showClassDetails),
      VistaClientes(clientes: _assignedClients, solicitarCliente: _requestClientFromAdmin, verDetallesCliente: _showClientDetails),
    ];

    return Scaffold(
      backgroundColor: ColoresEntrenador.fondo,
      appBar: AppBar(
        backgroundColor: ColoresEntrenador.fondo,
        title: const Text('Panel de Entrenador', style: TextStyle(color: ColoresEntrenador.verde)),
        actions: [
          if (_isLoading) const Padding(padding: EdgeInsets.all(16.0), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: ColoresEntrenador.verde, strokeWidth: 2))),
          IconButton(icon: const Icon(Icons.logout, color: Colors.white), onPressed: () => Navigator.pop(context))
        ],
      ),
      body: _isLoading && _classes.isEmpty 
          ? const Center(child: CircularProgressIndicator(color: ColoresEntrenador.verde))
          : pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColoresEntrenador.tarjeta,
        selectedItemColor: ColoresEntrenador.verde,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Clases'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Clientes'),
        ],
      ),
    );
  }
}