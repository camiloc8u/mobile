import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/auth_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoggedIn = false;
  String userName = 'Juan Pérez';
  String userEmail = 'juan@example.com';
  String userPhone = '+57 300 1234567';
  String userPlan = 'Plan Elite';
  @override
  Widget build(BuildContext context) {
    const greenColor = kGreenColor;
    const cardBg = kCardBg;
    if (!isLoggedIn) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('MI PERFIL', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_outline, size: 80, color: greenColor),
                const SizedBox(height: 24),
                const Text(
                  '¿Aún no eres miembro?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Únete a GYMZONE y comienza tu transformación hoy',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => showLoginDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greenColor,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('INICIAR SESIÓN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => showRegisterDialog(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: greenColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('REGISTRARSE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: greenColor)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('MI PERFIL', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => setState(() => isLoggedIn = false),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER CON DATOS DEL USUARIO
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: greenColor.withAlpha(128)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: greenColor.withAlpha(50),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(Icons.person, size: 40, color: greenColor),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userPlan,
                          style: const TextStyle(fontSize: 12, color: greenColor, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: greenColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Activo',
                            style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // INFORMACIÓN PERSONAL
            const Text('INFORMACIÓN PERSONAL', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 12),
            _buildInfoTile('Email', userEmail, Icons.email_outlined),
            _buildInfoTile('Teléfono', userPhone, Icons.phone_outlined),
            _buildInfoTile('Ubicación', 'Bogotá, Colombia', Icons.location_on_outlined),
            const SizedBox(height: 24),
            // MI PLAN
            const Text('MI PLAN', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: greenColor.withAlpha(128)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Plan Elite', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: greenColor)),
                          const SizedBox(height: 4),
                          const Text('\$100.000/mes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                          const SizedBox(height: 8),
                          const Text('Renovación: 15 Septiembre 2025', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () => showLoginDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenColor,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        child: const Text('CAMBIAR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // HISTORIAL DE ACTIVIDAD
            const Text('ACTIVIDAD RECIENTE', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 12),
            _buildActivityTile('Última visita', 'Hoy a las 6:30 PM', Icons.fitness_center),
            _buildActivityTile('Última compra', 'Ayer - Shake Proteico', Icons.shopping_bag_outlined),
            _buildActivityTile('Clases tomadas', '12 este mes', Icons.school_outlined),
            const SizedBox(height: 24),
            // PREFERENCIAS Y CONFIGURACIÓN
            const Text('CONFIGURACIÓN', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Notificaciones', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
              onTap: () {},
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Privacidad', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
              onTap: () {},
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Ayuda y Soporte', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
              onTap: () {},
            ),
            const SizedBox(height: 24),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => showLoginDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greenColor,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('INICIAR SESIÓN / REGISTRARSE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 0.5)),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF90EE00), size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildActivityTile(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF90EE00), size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
