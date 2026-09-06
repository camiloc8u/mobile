import 'package:flutter/material.dart';
import '../colores/colores_app.dart';
import '../pestanas/pestana_resumen.dart';
import '../pestanas/pestana_miembros.dart';
import '../pestanas/pestana_clases.dart';
import '../pestanas/pestana_finanzas.dart';

class PanelPrincipal extends StatelessWidget {
  const PanelPrincipal({super.key});

  // Método para mostrar el cuadro de diálogo de confirmación
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
                // Aquí va la lógica real de cerrar sesión (limpiar tokens, etc.)
                // Por ahora cerramos el modal y retrocedemos
                Navigator.pop(context); 
                
                // Si tienes una pantalla de Login, usarías algo como esto para ir a ella:
                // Navigator.pushAndRemoveUntil(
                //   context, 
                //   MaterialPageRoute(builder: (context) => const PantallaLogin()), 
                //   (Route<dynamic> route) => false
                // );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sesión cerrada correctamente'),
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
                // 1. CABECERA CON LA CORRECCIÓN DE OVERFLOW
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // El widget Expanded soluciona el error de las líneas amarillas
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
                    
                    const SizedBox(width: 10), // Pequeño espacio entre el texto y el botón

                    // --- BOTÓN DE CERRAR SESIÓN ---
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

                // 2. MENÚ DE PESTAÑAS
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

                // 3. CONTENIDO (VISTAS)
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