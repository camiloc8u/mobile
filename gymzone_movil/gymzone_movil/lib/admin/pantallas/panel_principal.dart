import 'package:flutter/material.dart';
import '../colores/colores_app.dart';
import '../pestanas/pestana_resumen.dart';
import '../pestanas/pestana_miembros.dart';
import '../pestanas/pestana_clases.dart';
import '../pestanas/pestana_finanzas.dart';

// importar para regresar
import '../../inicio/app.dart';

class PanelPrincipal extends StatelessWidget {
  const PanelPrincipal({super.key});

  //cuadro cerrar sesion
  void _confirmarCierreSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColoresApp.fondoTarjeta,
          title: const Text(
            'Cerrar Sesión',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            '¿Estás seguro de que deseas salir del panel de administración?',
            style: TextStyle(color: ColoresApp.textoGris),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cierra el modal
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                
                Navigator.pop(context); 
                
                // redirigir a inicio
                Navigator.pushAndRemoveUntil(
                  context, 
                  MaterialPageRoute(builder: (context) => const GymZoneApp()), 
                  (Route<dynamic> route) => false
                );

                // mensaje cerrar sesion
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sesión de administrador cerrada'),
                    backgroundColor: ColoresApp.verdePrincipal,
                  ),
                );
              },
              child: const Text('Salir', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      body: SafeArea(
        child: DefaultTabController(
          length: 4,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // overflow
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // error lineas amarillas
                    Expanded(
                      child: Column(
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
                                  style: TextStyle(color: ColoresApp.verdePrincipal),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Gestión del gimnasio GYMZONE',
                            style: TextStyle(color: ColoresApp.textoGris, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 10), 

                    // cerrar sesion
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColoresApp.fondoTarjeta,
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent, width: 1),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      icon: const Icon(Icons.logout, size: 20),
                      label: const Text('Salir'),
                      onPressed: () => _confirmarCierreSesion(context),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),

                // menu
                const TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: ColoresApp.verdePrincipal,
                  indicatorWeight: 3,
                  labelColor: ColoresApp.verdePrincipal,
                  unselectedLabelColor: ColoresApp.textoGris,
                  dividerColor: Color(0xFF27272A),
                  tabs: [
                    Tab(text: 'RESUMEN'),
                    Tab(text: 'MIEMBROS'),
                    Tab(text: 'CLASES'),
                    Tab(text: 'FINANZAS'),
                  ],
                ),
                
                const SizedBox(height: 20),

                // vistas
                const Expanded(
                  child: TabBarView(
                    children: [
                      PestanaResumen(),
                      PestanaMiembros(),
                      PestanaClases(),
                      PestanaFinanzas(),
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
}