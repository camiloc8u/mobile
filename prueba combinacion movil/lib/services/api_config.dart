import 'package:flutter/foundation.dart';

class ApiConfig {
  // Chrome usa localhost; un teléfono necesita la IP local del equipo.
  static String get baseUrlNode => kIsWeb
      ? 'http://localhost:3001/api'
      : 'http://192.168.1.4:3001/api';
  
  // URL de tu MockAPI para las clases
  static const String baseUrlMock = 'https://69dc3d4084f912a264037cde.mockapi.io';
}