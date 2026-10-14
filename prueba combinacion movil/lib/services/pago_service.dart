import 'dart:convert';
import 'package:http/http.dart' as http;
import '../inicio/models/cart_model.dart';
import 'api_config.dart';

class PagoService {
  
  static Future<String?> procesarPago(CartModel cart, Map<String, String> customerData) async {
    
    final List<Map<String, dynamic>> itemsApi = cart.items.map((item) => {
      "id": item.id,
      "title": item.title,
      "unit_price": item.price.toInt(),
      "quantity": item.qty.toInt(),
      "currency_id": "COP"
    }).toList();

    final Map<String, dynamic> payload = {
      "items": itemsApi,
      "payer": customerData
    };


    print('📦 PAYLOAD ENVIADO A EXPRESS: ${jsonEncode(payload)}');

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrlNode}/create-preference'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

   
    print('📥 RESPUESTA DE EXPRESS [Status ${response.statusCode}]: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["urlDePago"]; 
    } else {
      throw Exception('Backend respondió con status ${response.statusCode}: ${response.body}');
    }
  }
}