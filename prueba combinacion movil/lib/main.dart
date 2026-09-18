import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'inicio/app.dart'; 
import 'inicio/models/cart_model.dart'; // Importamos tu modelo

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };
  
  runZonedGuarded<Future<void>>(() async {
      WidgetsFlutterBinding.ensureInitialized();
      
      ErrorWidget.builder = (FlutterErrorDetails details) {
        return Material(
          color: const Color(0xFF09090B),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Se produjo un error:\n${details.exceptionAsString()}',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      };
      
      // Inyectamos el Provider en la raíz de la app
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => CartModel()),
          ],
          child: const GymZoneApp(),
        ),
      ); 
      
    }, (error, stack) {
      print('Unhandled zone error: $error');
  });
}