import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import '../models/cart_model.dart'; 
import '../theme/app_colors.dart';
import '../../services/pago_service.dart';
import '../../services/notification_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController fullNameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController idNumberCtrl = TextEditingController();
  String idType = 'CC';

  bool isProcessing = false;

  @override
  void dispose() {
    fullNameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    idNumberCtrl.dispose();
    super.dispose();
  }

  Future<void> _handlePaymentSubmit(CartModel cart) async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor completa todos los campos')));
      return;
    }
    
    setState(() => isProcessing = true);
    
    try {
      // 1. Recolectamos los datos del formulario (UI)
      final Map<String, String> datosCliente = {
        "fullName": fullNameCtrl.text.trim(),
        "phone": phoneCtrl.text.trim(),
        "email": emailCtrl.text.trim(),
        "idNumber": idNumberCtrl.text.trim(),
        "idType": idType,
      };

      // 2. MANDAMOS TODO A LA CARPETA DE APIs (Servicios)
      final urlDePago = await PagoService.procesarPago(cart, datosCliente);
      final prefs = await SharedPreferences.getInstance();
      final savedUser = prefs.getString('usuario');
      final userData = savedUser == null ? null : jsonDecode(savedUser) as Map<String, dynamic>;
      await NotificationService().createInAppNotification(
        title: 'Pago iniciado',
        message: 'Tu solicitud de pago fue creada. Completa el proceso en Mercado Pago.',
        userId: int.tryParse('${userData?['idusuario'] ?? ''}'),
        broadcast: false,
      );
      
      if (!mounted) return;

      // 3. Abrimos el navegador interno de la app (In-App Browser)
      if (urlDePago != null) {
        final Uri mercadoPagoUrl = Uri.parse(urlDePago);
        
        if (await canLaunchUrl(mercadoPagoUrl)) {
          await launchUrl(
            mercadoPagoUrl, 
            mode: LaunchMode.inAppBrowserView, // Se abre dentro de tu app como un modal deslizable
          );
        } else {
          throw 'No se pudo abrir el enlace de pago.';
        }
      }
    } catch (e) {
      if (!mounted) return;
      
      // Imprimimos el error exacto en la consola de la terminal
      print('🔥 ERROR EXACTO DE PAGO: $e'); 
      
      // Mostramos el error real en la pantalla para depurar fácilmente
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"), 
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 5),
        )
      );
    } finally {
      if (mounted) setState(() => isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.cardBg,
        title: RichText(
          text: const TextSpan(
            text: 'CHECKOUT ', 
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), 
            children: [TextSpan(text: 'PAGO', style: TextStyle(color: AppColors.greenColor))]
          )
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade800)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [Icon(Icons.person, color: AppColors.greenColor, size: 20), SizedBox(width: 8), Text('TU INFORMACIÓN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
                    const SizedBox(height: 16),
                    _buildTextField(fullNameCtrl, 'Nombre Completo', 'Ej. Camilo Morales'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 1, 
                          child: DropdownButtonFormField<String>(
                            initialValue: idType, 
                            dropdownColor: AppColors.cardBg, 
                            style: const TextStyle(color: Colors.white), 
                            decoration: _inputDecoration('Tipo ID'), 
                            items: const [DropdownMenuItem(value: 'CC', child: Text('CC')), DropdownMenuItem(value: 'CE', child: Text('CE'))], 
                            onChanged: (val) => setState(() => idType = val!)
                          )
                        ),
                        const SizedBox(width: 12),
                        Expanded(flex: 2, child: _buildTextField(idNumberCtrl, 'Número de Documento', 'Ej. 10000000', isNumber: true)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(emailCtrl, 'Correo Electrónico', 'correo@ejemplo.com', isEmail: true),
                    const SizedBox(height: 12),
                    _buildTextField(phoneCtrl, 'Teléfono / Celular', 'Ej. 3190000000', isNumber: true),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade800)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('RESUMEN DEL PEDIDO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...cart.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0), 
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                        children: [
                          Text('${item.title} x${item.qty}', style: const TextStyle(color: Colors.grey)), 
                          Text('\$${(item.price * item.qty)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                        ]
                      )
                    )),
                    const Divider(color: Colors.grey, height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                      children: [
                        const Text('Total a pagar', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), 
                        Text('\$${cart.total}', style: const TextStyle(color: AppColors.greenColor, fontSize: 18, fontWeight: FontWeight.bold))
                      ]
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity, 
                      height: 50, 
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.greenColor, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), 
                        onPressed: isProcessing ? null : () => _handlePaymentSubmit(cart), 
                        icon: isProcessing ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2)) : const Icon(Icons.shopping_cart), 
                        label: Text(isProcessing ? 'PROCESANDO...' : 'PAGAR \$${cart.total}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, {bool isNumber = false, bool isEmail = false}) {
    return TextFormField(
      controller: controller, 
      style: const TextStyle(color: Colors.white), 
      keyboardType: isNumber ? TextInputType.number : (isEmail ? TextInputType.emailAddress : TextInputType.text), 
      validator: (val) => val == null || val.isEmpty ? 'Requerido' : null, 
      decoration: _inputDecoration(label).copyWith(hintText: hint, hintStyle: const TextStyle(color: Colors.white24))
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label, 
      labelStyle: const TextStyle(color: Colors.grey, fontSize: 12), 
      filled: true, 
      fillColor: AppColors.fieldBg, 
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white10)), 
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white10)), 
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.greenColor))
    );
  }
}