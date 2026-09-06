import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../colores/colores_app.dart';
import '../modelos/clase.dart'; // IMPORTANTE: Importamos el modelo de Clase

class PestanaResumen extends StatefulWidget {
  const PestanaResumen({super.key});

  @override
  State<PestanaResumen> createState() => _PestanaResumenState();
}

class _PestanaResumenState extends State<PestanaResumen> {
  int totalMiembros = 0;
  int totalClases = 0;
  List<Clase> clasesAleatorias = []; // Lista para guardar las 3 clases
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosKpi();
  }

  Future<void> _cargarDatosKpi() async {
    try {
      // 1. Obtener cantidad real de Miembros
      final resMiembros = await http.get(Uri.parse('http://192.168.1.12:3001/api/usuarios'));
      if (resMiembros.statusCode == 200) {
        final List datosMiembros = json.decode(resMiembros.body);
        totalMiembros = datosMiembros.length;
      }

      // 2. Obtener Clases y seleccionar 3 al azar
      final resClases = await http.get(Uri.parse('https://69dc3d4084f912a264037cde.mockapi.io/clases'));
      if (resClases.statusCode == 200) {
        final List datosClases = json.decode(resClases.body);
        
        // Convertimos el JSON a una lista de objetos Clase
        List<Clase> listaClases = datosClases.map((data) => Clase.fromJson(data)).toList();
        
        totalClases = listaClases.length;

        // Desordenamos la lista de forma aleatoria
        listaClases.shuffle();

        // Tomamos máximo 3 clases (si hay menos de 3, tomará las que haya)
        clasesAleatorias = listaClases.take(3).toList();
      }
    } catch (e) {
      print('Error al cargar datos del resumen: $e');
    }

    // Actualizar la pantalla cuando termine de cargar
    if (mounted) {
      setState(() {
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final esMovil = MediaQuery.of(context).size.width < 700;

    // Mostrar un indicador de carga mientras busca los datos
    if (cargando) {
      return const Center(
        child: CircularProgressIndicator(color: ColoresApp.verdePrincipal),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- PRIMERA FILA: Miembros y Clases Juntos ---
          Row(
            children: [
              Expanded(
                child: _crearTarjetaKpi(
                  Icons.people_alt_outlined, 
                  'Miembros Activos', 
                  totalMiembros.toString()
                )
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _crearTarjetaKpi(
                  Icons.calendar_today_outlined, 
                  'Clases Programadas', 
                  totalClases.toString()
                )
              ),
            ],
          ),
          
          const SizedBox(height: 16),

          // --- SEGUNDA FILA: Ingresos (Grande y llamativo) ---
          _crearTarjetaIngresos(),
          
          const SizedBox(height: 24),

          // --- TERCERA FILA: Listas de información inferior ---
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

  // --- WIDGET: TARJETA DE INGRESOS ---
  Widget _crearTarjetaIngresos() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: ColoresApp.verdePrincipal.withOpacity(0.05),
        border: Border.all(color: ColoresApp.verdePrincipal.withOpacity(0.3), width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColoresApp.verdePrincipal.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.attach_money, color: ColoresApp.verdePrincipal, size: 40),
          ),
          const SizedBox(height: 16),
          const Text(
            'INGRESOS DEL MES',
            style: TextStyle(color: ColoresApp.textoGris, fontSize: 16, letterSpacing: 1.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            '\$28.5M',
            style: TextStyle(
              color: ColoresApp.verdePrincipal, 
              fontSize: 52, 
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 15.0,
                  color: ColoresApp.verdePrincipal, 
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET: TARJETAS KPI NORMALES ---
  Widget _crearTarjetaKpi(IconData icono, String titulo, String valor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColoresApp.fondoTarjeta,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: ColoresApp.verdePrincipal, size: 28),
          const SizedBox(height: 12),
          Text(titulo, style: const TextStyle(color: ColoresApp.textoGris, fontSize: 13)),
          const SizedBox(height: 4),
          Text(
            valor,
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // --- WIDGET: LISTA MIEMBROS NUEVOS ---
  Widget _crearTarjetaMiembrosNuevos() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ColoresApp.fondoTarjeta,
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
          _crearFilaMiembro('Saray Castiblanco', 'PREMIUM', 'Ene 2024'),
          _crearFilaMiembro('Carlos Martínez', 'PREMIUM', 'Ene 2025'),
          _crearFilaMiembro('Ana López', 'ELITE', 'Feb 2025', esUltimo: true),
        ],
      ),
    );
  }

  // --- WIDGET: LISTA CLASES POPULARES (CON DATOS DE LA API) ---
  Widget _crearTarjetaClasesPopulares() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ColoresApp.fondoTarjeta,
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
          // Si no hay clases registradas en la API
          if (clasesAleatorias.isEmpty)
            const Text(
              'Aún no hay clases registradas',
              style: TextStyle(color: ColoresApp.textoGris),
            )
          else
            // Recorremos las 3 clases aleatorias que guardamos
            ...clasesAleatorias.asMap().entries.map((entrada) {
              int indice = entrada.key;
              Clase clase = entrada.value;
              
              // Para no poner margen inferior al último elemento
              bool esUltimo = indice == clasesAleatorias.length - 1;

              return _crearFilaClase(
                clase.nombre, 
                clase.horario, 
                'Cupo: ${clase.cupo}', 
                esUltimo: esUltimo
              );
            }),
        ],
      ),
    );
  }

  Widget _crearFilaMiembro(String nombre, String plan, String fecha, {bool esUltimo = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: esUltimo ? 0 : 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColoresApp.fondoItem,
        borderRadius: BorderRadius.circular(8),
      ),
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
      decoration: BoxDecoration(
        color: ColoresApp.fondoItem,
        borderRadius: BorderRadius.circular(8),
      ),
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