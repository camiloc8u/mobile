import 'package:flutter/material.dart';

import '../models/cart_model.dart';
import '../theme/app_colors.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/quick_card.dart';
import 'cart_screen.dart';

// ==========================================
// PANTALLA 1: INICIO (HOME)
// ==========================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const greenColor = kGreenColor;
  static const cardBg = kCardBg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.fitness_center, color: greenColor, size: 22),
            SizedBox(width: 8),
            Text.rich(
              TextSpan(
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 1.2),
                children: [
                  TextSpan(text: 'GYM', style: TextStyle(color: Colors.white)),
                  TextSpan(text: 'ZONE', style: TextStyle(color: greenColor)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          AnimatedBuilder(
            animation: cart,
            builder: (context, _) {
              return IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                    if (cart.count > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Center(
                          child: Text(
                            '${cart.count}',
                            style: const TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () => showCartPanel(context),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HERO BANNER
            Container(
              height: 180,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&q=80'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'BIENVENIDO A',
                        style: TextStyle(color: greenColor, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text.rich(
                        TextSpan(
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                          children: [
                            TextSpan(text: 'GYM', style: TextStyle(color: Colors.white)),
                            TextSpan(text: 'ZONE', style: TextStyle(color: greenColor)),
                          ],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Transversal 94 80a 29, Bogotá',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: ElevatedButton(
                      onPressed: () => showLoginDialog(context),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(greenColor),
                        foregroundColor: WidgetStateProperty.all(Colors.black),
                        elevation: WidgetStateProperty.all(2),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        side: WidgetStateProperty.all(BorderSide.none),
                        overlayColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.hovered) ? Colors.white12 : null),
                      ),
                      child: const Text('ÚNETE', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('ACCESO RÁPIDO', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 12),
            // BOTONES ACCESO RÁPIDO
            Row(
              children: [
                QuickCard(icon: Icons.fitness_center, title: 'Rutinas', isSelected: true),
                const SizedBox(width: 12),
                QuickCard(icon: Icons.restaurant, title: 'Menú'),
                const SizedBox(width: 12),
                QuickCard(icon: Icons.credit_card, title: 'Planes'),
                const SizedBox(width: 12),
                QuickCard(icon: Icons.person, title: 'Mi Cuenta'),
              ],
            ),
            const SizedBox(height: 24),
            // CLASES DE HOY
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('CLASES DE HOY', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: const [
                      Text('Ver más ', style: TextStyle(color: greenColor, fontSize: 12)),
                      Icon(Icons.arrow_forward_ios, color: greenColor, size: 10),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildClassTile('Spinning', 'Ana López', '7:00 AM', '3 cupos'),
            _buildClassTile('CrossFit', 'Juan Pérez', '6:00 PM', '5 cupos'),
            _buildClassTile('Yoga', 'M. González', '9:00 AM', '12 cupos'),
            const SizedBox(height: 24),
            // NUESTROS SERVICIOS
            const Text('NUESTROS SERVICIOS', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.6,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: const [
                _ServiceCard(icon: Icons.fitness_center, title: 'Fuerza', subtitle: 'Pesas & máquinas'),
                _ServiceCard(icon: Icons.favorite, title: 'Cardio', subtitle: 'Spinning & HIIT'),
                _ServiceCard(icon: Icons.groups, title: 'Clases', subtitle: 'Yoga, Zumba y otras clases'),
                _ServiceCard(icon: Icons.bolt, title: 'Personal', subtitle: 'Entrenador 1:1'),
              ],
            ),
            const SizedBox(height: 20),
            // PLAN ELITE
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [greenColor.withAlpha(45), cardBg],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: greenColor.withAlpha(128)),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(128), blurRadius: 8, offset: Offset(0, 4))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('PLAN ELITE', style: TextStyle(color: greenColor, fontWeight: FontWeight.bold, fontSize: 12)),
                      SizedBox(height: 4),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: '\$100.000', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                            TextSpan(text: '/mes', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text('Acceso total + entrenador personal', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => showLoginDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greenColor,
                      foregroundColor: Colors.black,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    child: const Text('VER PLANES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  static Widget _buildClassTile(String name, String trainer, String time, String spots) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: greenColor.withAlpha(38),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: greenColor.withAlpha(90)),
            ),
            child: const Icon(Icons.play_arrow, color: greenColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(trainer, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(time, style: const TextStyle(color: greenColor, fontWeight: FontWeight.bold, fontSize: 12)),
              Text(spots, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}
class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _ServiceCard({required this.icon, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(128), blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF90EE00).withAlpha(38),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF90EE00).withAlpha(90)),
            ),
            child: Icon(icon, color: const Color(0xFF90EE00), size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11), overflow: TextOverflow.ellipsis),
              ],
            ),
          )
        ],
      ),
    );
  }
}
