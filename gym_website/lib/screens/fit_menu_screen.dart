import 'package:flutter/material.dart';

import '../models/cart_model.dart';
import '../theme/app_colors.dart';
import 'cart_screen.dart';

// ==========================================
// PANTALLA 2: MENÚ FIT (NUTRITION)
// ==========================================
class FitMenuScreen extends StatelessWidget {
  const FitMenuScreen({super.key});
  static const greenColor = kGreenColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.fitness_center, color: greenColor, size: 20),
            SizedBox(width: 8),
            Text('MENÚ FIT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
          ],
        ),
        actions: [
          AnimatedBuilder(
            animation: cart,
            builder: (context, _) {
              return IconButton(
                icon: Stack(
                  clipBehavior: Clip.none,
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
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('MENÚ SALUDABLE', style: TextStyle(color: greenColor, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 2),
            Row(
              children: const [
                Text('NUTRICIÓN ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                Text('FITNESS', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: greenColor)),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionHeader('Shakes de Proteína'),
            _buildMenuItem(
              context,
              title: 'CLÁSICO',
              subtitle: 'Elige tu sabor ideal',
              description: 'Batido en agua con 18 gr de proteína, vitaminas y minerales. Bajo en calorías y diseñado para complementar tu dieta diaria sin sacrificar sabor.',
              details: 'Caffe Latte - Chocoavellana - Cookies and Cream',
              price: '\$7.500 COP',
              imageUrl: 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?auto=format&fit=crop&q=80',
            ),
            _buildMenuItem(
              context,
              title: 'ESPECIAL',
              subtitle: 'Elige tu sabor ideal',
              description: 'Batido en agua con 27 gr de proteína. Incluye dos toppings, variedad de sabores y crema opcional para una experiencia más indulgente.',
              details: 'Nevado de Café - Explosión de Chocolate',
              price: '\$9.000 COP',
              imageUrl: 'https://images.unsplash.com/photo-1577805947697-89e18249d767?auto=format&fit=crop&q=80',
            ),
            const SizedBox(height: 16),
            _buildSectionHeader('Bebidas Frías'),
            _buildMenuItem(
              context,
              title: 'ICE DRINK',
              subtitle: 'Frutos Rojos',
              description: 'Bebida sin azúcar, baja en calorías con una base de colágeno hidrolizado, ideal para recuperación y salud de la piel.',
              price: '\$9.000 COP',
              imageUrl: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&q=80',
            ),
            _buildMenuItem(
              context,
              title: 'GOLDEN CÚRCUMA',
              description: 'Bebida antiinflamatoria y refrescante a base de cúrcuma, con toques tropicales de piña y jengibre para mejorar la digestión.',
              price: '\$9.000 COP',
              imageUrl: 'https://images.unsplash.com/photo-1621263764928-df1444c5e859?auto=format&fit=crop&q=80',
            ),
            const SizedBox(height: 16),
            _buildSectionHeader('Tu Mejor Elección'),
            _buildMenuItem(
              context,
              title: 'WAFFLES DE PROTEÍNA',
              description: 'Nuestra receta de waffle está elaborada con harina de avena y proteína vegetal, baja en azúcares y rica en fibra. Perfecto como snack post-entrenamiento o merienda saludable.',
              details: 'Chocolate - Vainilla - Banana',
              price: '\$8.000 COP',
              imageUrl: 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?auto=format&fit=crop&q=80',
            ),
            _buildMenuItem(
              context,
              title: 'BROWNIE FIT',
              description: 'Delicioso brownie de chocolate bajo en azúcar y alto en proteína. Un postre nutritivo y satisfactorio que acompaña tus objetivos de entrenamiento.',
              price: '\$7.000 COP',
              imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&q=80',
            ),
            _buildMenuItem(
              context,
              title: 'PAN PROTEICO',
              description: 'Pan artesanal con chips de chocolate, alto en proteína y bajo en carbohidratos. Ideal para acompañar tu desayuno o merienda con un aporte extra de proteínas.',
              price: '\$7.500 COP',
              imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&q=80',
            ),
            const SizedBox(height: 16),
            _buildSectionHeader('Bowl Proteico'),
            _buildMenuItem(
              context,
              title: 'BOWL PROTEICO',
              description: 'Rico batido a base de fresas, arándanos, banano, coco y granola.',
              price: '\$10.000 COP',
              imageUrl: 'https://images.unsplash.com/photo-1590301157890-4810ed352733?auto=format&fit=crop&q=80',
            ),
            const SizedBox(height: 12),
            // Bebidas Calientes
            _buildSectionHeader('Bebidas Calientes'),
            _buildMenuItem(
              context,
              title: 'TÉ',
              subtitle: 'Variedades',
              description: 'Bebida a base de té negro, té verde y hierbas naturales. Antioxidante y digestiva.',
              details: 'Digestivo Te - Energy Te - Menta Relax',
              price: '\$7.500 COP',
              // Cambié la imagen por una alternativa fiable
              imageUrl: 'https://images.unsplash.com/photo-1511920170033-f8396924c348?auto=format&fit=crop&q=80',
            ),
            _buildMenuItem(
              context,
              title: 'LATTE',
              subtitle: 'Calientes',
              description: 'Bebida nutricional caliente sin lactosa, a base de proteína vegetal.',
              details: 'Chai Latte - Cacao Latte - Cafe Latte',
              price: '\$7.500 COP',
              imageUrl: 'https://images.unsplash.com/photo-1511920170033-f8396924c348?auto=format&fit=crop&q=80',
            ),
            const SizedBox(height: 12),
            // Combos
            _buildSectionHeader('Combos'),
            _buildMenuItem(
              context,
              title: 'SHAKE O ICE DRINK + WAFFLE',
              description: 'Combina tu bebida favorita con un delicioso waffle',
              price: '\$17.000 COP',
              imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&q=80',
            ),
            _buildMenuItem(
              context,
              title: 'BEBIDA CALIENTE + WAFFLE',
              description: 'El combo perfecto para empezar el día',
              price: '\$17.000 COP',
              imageUrl: 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?auto=format&fit=crop&q=80',
            ),
            const SizedBox(height: 12),
            // Planes
            _buildSectionHeader('Planes: Tu Mejor Versión'),
            _buildMenuItem(
              context,
              title: 'PERDIDA DE PESO',
              subtitle: 'Básico',
              description: 'Batido de 18 gr de proteína + bebida antioxidante con Aloe Vera',
              price: '\$9.000 COP',
              imageUrl: 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?auto=format&fit=crop&q=80',
            ),
            _buildMenuItem(
              context,
              title: 'PERDIDA DE PESO',
              subtitle: 'Avanzado',
              description: 'Batido de 18 gr de proteína + bebida detox',
              price: '\$10.500 COP',
              imageUrl: 'https://images.unsplash.com/photo-1577805947697-89e18249d767?auto=format&fit=crop&q=80',
            ),
            _buildMenuItem(
              context,
              title: 'AUMENTO DE MASA MUSCULAR',
              subtitle: 'Básico',
              description: 'Batido de 18 gr de proteína especialmente formulado para ganancia muscular',
              price: '\$7.500 COP',
              imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&q=80',
            ),
            _buildMenuItem(
              context,
              title: 'AUMENTO DE MASA MUSCULAR',
              subtitle: 'Avanzado',
              description: 'Batido de 27 gr de proteína para ganancia muscular acelerada con creatina opcional',
              price: '\$8.500 COP',
              imageUrl: 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?auto=format&fit=crop&q=80',
            ),
            _buildMenuItem(
              context,
              title: 'RECUPERADOR MUSCULAR',
              description: 'Ayuda a la recuperación post-entrenamiento',
              price: '\$10.000 COP',
              imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&q=80',
            ),
            _buildMenuItem(
              context,
              title: 'BOTELLA DETOX',
              description: 'Limpia tu organismo naturalmente',
              price: '\$9.000 COP',
              imageUrl: 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?auto=format&fit=crop&q=80',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  static Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: greenColor,
          fontStyle: FontStyle.italic,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  static Widget _buildMenuItem(BuildContext context, {
      required String title,
      String? subtitle,
      required String description,
      String? details,
      required String price,
      required String imageUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(128), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 86,
              height: 86,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(width: 86, height: 86, color: Colors.white10, child: const Icon(Icons.broken_image, color: Colors.white24, size: 28)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
                const SizedBox(height: 6),
                Text(description, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                if (details != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    details.split(RegExp(r'\s*-\s*')).map((s) => s.trim()).where((s) => s.isNotEmpty).join(' · '),
                    style: const TextStyle(color: Color(0xFF8FB6D8), fontSize: 11.5),
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999)),
                      child: Text(price, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    Builder(builder: (ctx) {
                        return ElevatedButton.icon(
                          onPressed: () {
                            final parsed = int.tryParse(price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                            final id = '${title.replaceAll(' ', '_')}_$parsed';
                            cart.add(CartItem(id: id, title: title, subtitle: subtitle ?? '', price: parsed, imageUrl: imageUrl));
                            ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Añadido: $title')));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: FitMenuScreen.greenColor,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.shopping_cart, size: 16, color: Colors.black),
                          label: const Text('Agregar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black)),
                        );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}