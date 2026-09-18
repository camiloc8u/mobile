import 'package:flutter/material.dart';
import '../colores/colores_app.dart';
import '../modelos/clase.dart';
import '../../services/clase_service.dart';
import '../../services/usuario_service.dart';

class PestanaResumen extends StatefulWidget {
  const PestanaResumen({super.key});

  @override
  State<PestanaResumen> createState() => _PestanaResumenState();
}

class _PestanaResumenState extends State<PestanaResumen> {
  int totalMiembros = 0;
  int totalClases = 0;
  List<Clase> clasesAleatorias = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosKpi();
  }

  Future<void> _cargarDatosKpi() async {
    try {
      final usuarios = await UsuarioService.obtenerUsuarios();
      totalMiembros = usuarios.length;

      final clases = await ClaseService.obtenerClases();
      totalClases = clases.length;
      
      clases.shuffle();
      clasesAleatorias = clases.take(3).toList();
      
    } catch (e) {
      print('Error al cargar datos del resumen: $e');
    }

    if (mounted) {
      setState(() {
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final esMovil = MediaQuery.of(context).size.width < 700;

    if (cargando) {
      return const Center(
        child: CircularProgressIndicator(color: ColoresApp.verdePrincipal),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _crearTarjetaKpi(Icons.people_alt_outlined, 'Miembros Activos', totalMiembros.toString()),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _crearTarjetaKpi(Icons.calendar_today_outlined, 'Clases Programadas', totalClases.toString()),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _crearTarjetaIngresos(),
          const SizedBox(height: 24),
          if (esMovil) ...[
            _crearTarjetaMiembrosNuevos(),
            const SizedBox(height: 16),
            _crearTarjetaClasesPopulares(),
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _crearTarjetaMiembrosNuevos()),
                const SizedBox(width: 16),
                Expanded(child: _crearTarjetaClasesPopulares()),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _crearTarjetaIngresos() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: ColoresApp.verdePrincipal.withValues(alpha: 0.05),
        border: Border.all(color: ColoresApp.verdePrincipal.withValues(alpha: 0.3), width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: ColoresApp.verdePrincipal.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: const Icon(Icons.attach_money, color: ColoresApp.verdePrincipal, size: 40),
          ),
          const SizedBox(height: 16),
          const Text('INGRESOS DEL MES', style: TextStyle(color: ColoresApp.textoGris, fontSize: 16, letterSpacing: 1.5, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const Text('\$28.5M', style: TextStyle(color: ColoresApp.verdePrincipal, fontSize: 52, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 15.0, color: ColoresApp.verdePrincipal, offset: Offset(0, 0))])),
        ],
      ),
    );
  }

  Widget _crearTarjetaKpi(IconData icono, String titulo, String valor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: ColoresApp.fondoTarjeta, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: ColoresApp.verdePrincipal, size: 28),
          const SizedBox(height: 12),
          Text(titulo, style: const TextStyle(color: ColoresApp.textoGris, fontSize: 13)),
          const SizedBox(height: 4),
          Text(valor, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _crearTarjetaMiembrosNuevos() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: ColoresApp.fondoTarjeta, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('NUEVOS MIEMBROS', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _crearFilaMiembro('Saray Castiblanco', 'PREMIUM', 'Ene 2024'),
          _crearFilaMiembro('Carlos Martínez', 'PREMIUM', 'Ene 2025'),
          _crearFilaMiembro('Ana López', 'ELITE', 'Feb 2025', esUltimo: true),
        ],
      ),
    );
  }

  Widget _crearTarjetaClasesPopulares() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: ColoresApp.fondoTarjeta, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('CLASES POPULARES', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (clasesAleatorias.isEmpty)
            const Text('Aún no hay clases registradas', style: TextStyle(color: ColoresApp.textoGris))
          else
            ...clasesAleatorias.asMap().entries.map((entrada) {
              int indice = entrada.key;
              Clase clase = entrada.value;
              bool esUltimo = indice == clasesAleatorias.length - 1;
              return _crearFilaClase(clase.nombre, clase.horario, 'Cupo: ${clase.cupo}', esUltimo: esUltimo);
            }),
        ],
      ),
    );
  }

  Widget _crearFilaMiembro(String nombre, String plan, String fecha, {bool esUltimo = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: esUltimo ? 0 : 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: ColoresApp.fondoItem, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nombre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text(plan, style: const TextStyle(color: ColoresApp.textoGris, fontSize: 11, letterSpacing: 0.5)),
            ],
          ),
          Text(fecha, style: const TextStyle(color: ColoresApp.verdePrincipal, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _crearFilaClase(String nombre, String horario, String cupo, {bool esUltimo = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: esUltimo ? 0 : 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: ColoresApp.fondoItem, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nombre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text(horario, style: const TextStyle(color: ColoresApp.textoGris, fontSize: 11)),
            ],
          ),
          Text(cupo, style: const TextStyle(color: ColoresApp.verdePrincipal, fontSize: 13)),
        ],
      ),
    );
  }
}