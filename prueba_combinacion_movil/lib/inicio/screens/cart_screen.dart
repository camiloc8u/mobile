import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../theme/app_colors.dart';
import 'CheckoutScreen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchamos el carrito a través del Provider
    final cart = context.watch<CartModel>();

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.cardBg,
        title: const Text('Mi Carrito', style: TextStyle(color: Colors.white)),
      ),
      body: cart.items.isEmpty
          ? const Center(child: Text('El carrito está vacío', style: TextStyle(color: Colors.grey)))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return ListTile(
                        title: Text(item.title, style: const TextStyle(color: Colors.white)),
                        subtitle: Text('\$${item.price} COP', style: const TextStyle(color: AppColors.greenColor)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.redAccent),
                              onPressed: () => context.read<CartModel>().changeQty(item.id, -1),
                            ),
                            Text('${item.qty}', style: const TextStyle(color: Colors.white)),
                            IconButton(
                              icon: const Icon(Icons.add, color: AppColors.greenColor),
                              onPressed: () => context.read<CartModel>().changeQty(item.id, 1),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: AppColors.cardBg,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:', style: TextStyle(color: Colors.white, fontSize: 18)),
                          Text('\$${cart.total}', style: const TextStyle(color: AppColors.greenColor, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.greenColor,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckoutScreen()));
                          },
                          child: const Text('IR A PAGAR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}