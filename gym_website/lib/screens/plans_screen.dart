import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/auth_widgets.dart';

// ==========================================
// PANTALLA: PLANES
// Contenido replicando las capturas (Básico, Premium, Elite, Anual Elite)
// ==========================================
class PlansScreen extends StatelessWidget {
  const PlansScreen({super.key});
  Widget _planCard(BuildContext context, String title, String price, List<String> bullets, {bool highlighted = false, String? subtitle}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(153), blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 6),
                  Row(children: [Text(price, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kGreenColor)), const SizedBox(width: 6), Text(subtitle ?? '/mes', style: const TextStyle(color: Colors.grey))]),
              ]),
              ElevatedButton(
                onPressed: () => showLoginDialog(context),
                style: ElevatedButton.styleFrom(backgroundColor: kGreenColor, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text('ELEGIR'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...bullets.map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: kGreenColor,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          b,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
              )),
              if (highlighted) const SizedBox(height: 6),
            ],
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, title: const Text('PLANES', style: TextStyle(fontWeight: FontWeight.bold)), actions: [IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {})]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('PLANES Y PRECIOS', style: TextStyle(color: kGreenColor, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('ELIGE TU PLAN', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
            const SizedBox(height: 12),
            _planCard(context, 'BÁSICO', '\$60.000', ['Acceso al gimnasio 24/7', 'Área de pesas y cardio', 'Vestuarios y duchas', 'Wi-Fi gratuito', 'App móvil de seguimiento']),
            _planCard(context, 'PREMIUM', '\$80.000', ['Todo lo del plan Básico', 'Clases grupales ilimitadas', '1 sesión de entrenamiento personal/mes', 'Descuentos en nutrición', 'Invitaciones para amigos']),
            _planCard(context, 'ELITE', '\$100.000', ['Todo lo del plan Premium', '4 sesiones de entrenamiento personal/mes', 'Plan nutricional personalizado', 'Masajes deportivos mensuales', 'Parking privado', 'Toallas y amenities premium']),
            _planCard(context, 'ANUAL ELITE', '\$900.000', ['Todo lo del plan Elite', 'Ahorra \$300.000 al año', '12 meses por el precio de 9', 'Sesiones de entrenamiento ilimitadas', '2 meses de plan nutricional GRATIS', 'Evaluaciones físicas trimestrales'], subtitle: '/año'),
            const SizedBox(height: 24),
        ]),
      ),
    );
  }
}
