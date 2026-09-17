import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Admin/modelos/clase.dart'; // <-- A mayúscula
import 'api_config.dart'; // <-- Busca en la misma carpeta

class ClaseService {
  static Future<List<Clase>> obtenerClases() async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrlMock}/clases'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Clase.fromJson(data)).toList();
    } else {
      throw Exception('Fallo al cargar las clases');
    }
  }

  static Future<void> crearClase(Map<String, dynamic> datosClase) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrlMock}/clases'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(datosClase),
    );
    if (response.statusCode != 201) throw Exception('Error al crear la clase');
  }

  static Future<void> actualizarClase(String id, Map<String, dynamic> datosClase) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrlMock}/clases/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(datosClase),
    );
    if (response.statusCode != 200) throw Exception('Error al actualizar la clase');
  }

  static Future<void> eliminarClase(String id) async {
    final response = await http.delete(Uri.parse('${ApiConfig.baseUrlMock}/clases/$id'));
    if (response.statusCode != 200) throw Exception('Error al eliminar la clase');
  }
}