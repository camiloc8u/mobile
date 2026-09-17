import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Admin/modelos/usuario.dart';
import 'api_config.dart';

class UsuarioService {
  static Future<List<Usuario>> obtenerUsuarios() async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrlNode}/usuarios'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Usuario.fromJson(data)).toList();
    } else {
      throw Exception('Fallo al cargar los usuarios');
    }
  }

  static Future<void> crearUsuario(Map<String, dynamic> datosUsuario) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrlNode}/usuarios'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(datosUsuario),
    );
    if (response.statusCode != 200 && response.statusCode != 201) throw Exception('Error al crear usuario');
  }

  static Future<void> actualizarUsuario(int id, Map<String, dynamic> datosUsuario) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrlNode}/usuarios/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(datosUsuario),
    );
    if (response.statusCode != 200) throw Exception('Error al actualizar usuario');
  }

  // ✅ ESTE ES EL MÉTODO QUE CONECTA CON EL BACKEND DE ARRIBA
  static Future<void> actualizarPerfilCliente(int id, Map<String, dynamic> datos) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrlNode}/usuario/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(datos),
    );
    if (response.statusCode != 200) throw Exception('Error al actualizar en el servidor');
  }

  static Future<Map<String, dynamic>?> login(String correo, String password) async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrlNode}/usuarios'));
    if (response.statusCode == 200) {
      final usuarios = json.decode(response.body) as List<dynamic>;
      for (final usuario in usuarios) {
        final datos = usuario as Map<String, dynamic>;
        if ('${datos['correo'] ?? ''}'.trim().toLowerCase() == correo.trim().toLowerCase() &&
            '${datos['password'] ?? ''}' == password) {
          return datos;
        }
      }
      return null;
    } else {
      throw Exception('La API respondió con estado ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> registrarCliente(Map<String, dynamic> datosRegistro) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrlNode}/usuarios'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(datosRegistro),
    );
    if (response.statusCode != 200 && response.statusCode != 201) throw Exception('Error al registrar');
    return json.decode(response.body) as Map<String, dynamic>;
  }
}