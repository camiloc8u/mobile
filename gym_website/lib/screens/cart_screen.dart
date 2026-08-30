import 'package:flutter/material.dart';

import '../models/cart_model.dart';
import '../theme/app_colors.dart';
import '../widgets/auth_widgets.dart';

// Pantalla de Carrito + Checkout PSE
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('CARRITO', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: AnimatedBuilder(
        animation: cart,
        builder: (context, _) {
          final items = cart.items;
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Tu carrito está vacío', style: TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text('Agrega productos para comenzar', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final it = items[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: kCardBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              it.imageUrl,
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, st) => Container(
                                width: 72,
                                height: 72,
                                color: Colors.white10,
                                child: const Icon(Icons.image_not_supported, color: Colors.white24),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(it.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                                const SizedBox(height: 4),
                                Text(it.subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('\$${(it.price * it.qty).toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}', style: const TextStyle(fontWeight: FontWeight.bold, color: kGreenColor, fontSize: 13)),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove, size: 16, color: kGreenColor),
                                      onPressed: () => cart.changeQty(it.id, -1),
                                      padding: const EdgeInsets.all(4),
                                      constraints: const BoxConstraints(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                      child: Text('${it.qty}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add, size: 16, color: kGreenColor),
                                      onPressed: () => cart.changeQty(it.id, 1),
                                      padding: const EdgeInsets.all(4),
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kCardBg,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        Text('\$${cart.total.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Envío', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        const Text('Gratis', style: TextStyle(color: kGreenColor, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: Colors.white12),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        Text('\$${cart.total.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kGreenColor)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await showLoginDialog(context);
                          if (context.mounted) showCheckoutPSE(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kGreenColor,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('PROCEDER AL PAGO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => cart.clear(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Vaciar Carrito', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
// Panel deslizante de carrito (coincide con el diseño: panel lateral con
// encabezado "CARRITO (n)", ícono de basura por ítem, stepper de cantidad
// y resumen con botón "PROCEDER AL PAGO").
Future<void> showCartPanel(BuildContext context) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Carrito',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (dialogContext, anim1, anim2) {
      return Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: const Color(0xFF0E0E10),
          child: SizedBox(
            width: 400,
            height: double.infinity,
            child: SafeArea(child: _CartPanel()),
          ),
        ),
      );
    },
    transitionBuilder: (dialogContext, anim1, anim2, child) {
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic)),
        child: child,
      );
    },
  );
}
class _CartPanel extends StatelessWidget {
  const _CartPanel();
  String _fmt(int n) => n.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: cart,
      builder: (context, _) {
        final items = cart.items;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
              child: Row(
                children: [
                  const Icon(Icons.shopping_cart_outlined, color: kGreenColor, size: 20),
                  const SizedBox(width: 8),
                  Text('CARRITO (${cart.count})', style: const TextStyle(color: kGreenColor, fontWeight: FontWeight.bold, fontSize: 16)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white12, height: 1),
            Expanded(
              child: items.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.shopping_cart_outlined, size: 56, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('Tu carrito está vacío', style: TextStyle(color: Colors.white, fontSize: 15)),
                    SizedBox(height: 6),
                    Text('Agrega productos para comenzar', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final it = items[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            it.imageUrl,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(width: 56, height: 56, color: Colors.white10, child: const Icon(Icons.image_not_supported, color: Colors.white24, size: 20)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text(it.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                                  InkWell(
                                    onTap: () => cart.remove(it.id),
                                    child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                                  ),
                                ],
                              ),
                              if (it.subtitle.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(it.subtitle, style: const TextStyle(color: kGreenColor, fontSize: 11)),
                              ],
                              const SizedBox(height: 2),
                              Text('\$${_fmt(it.price)} COP', style: const TextStyle(color: kGreenColor, fontSize: 12, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove, size: 14, color: Colors.white),
                                          onPressed: () => cart.changeQty(it.id, -1),
                                          padding: const EdgeInsets.all(6),
                                          constraints: const BoxConstraints(),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 6),
                                          child: Text('${it.qty}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add, size: 14, color: Colors.white),
                                          onPressed: () => cart.changeQty(it.id, 1),
                                          padding: const EdgeInsets.all(6),
                                          constraints: const BoxConstraints(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Text('\$${_fmt(it.price * it.qty)} COP', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (items.isNotEmpty)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white12)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      Text('\$${_fmt(cart.total)} COP', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text('\$${_fmt(cart.total)} COP', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kGreenColor)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await showLoginDialog(context);
                        if (context.mounted) showCheckoutPSE(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kGreenColor,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      icon: const Icon(Icons.shopping_cart_checkout, size: 18),
                      label: const Text('PROCEDER AL PAGO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
Future<void> showCheckoutPSE(BuildContext context) async {
  final banks = [
    'Bancolombia',
    'Banco de Bogotá',
    'Davivienda',
    'BBVA Colombia',
    'Banco Popular',
    'Banco de Occidente',
    'Banco Agrario',
    'Banco Caja Social',
    'Scotiabank Colpatria',
    'Itaú',
    'Bancoomeva',
    'Banco AV Villas',
  ];
  String? selected = banks.first;
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF0E0E10),
      title: const Text('PSE - Selecciona tu banco'),
      content: StatefulBuilder(builder: (context, setState) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
              DropdownButton<String>(value: selected, dropdownColor: const Color(0xFF0E0E10), items: banks.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(), onChanged: (v) => setState(() => selected = v)),
              const SizedBox(height: 12),
              Text('Total: \$${cart.total} COP', style: const TextStyle(fontWeight: FontWeight.bold)),
          ]);
      }),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('CANCELAR')),
        ElevatedButton(onPressed: () { Navigator.of(context).pop(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Redirigiendo a PSE - Banco: $selected'))); }, child: const Text('CONFIRMAR')),
      ],
    ),
  );
}
