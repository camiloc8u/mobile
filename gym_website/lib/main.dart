import 'dart:async';

import 'package:flutter/material.dart';

import 'app.dart';

export 'app.dart' show GymZoneApp;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Enviar errores Flutter a la consola
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };
  // Ejecutar la app dentro de una zona para capturar errores no manejados
  runZonedGuarded<Future<void>>(() async {
      // Mostrar errores fatales en pantalla para evitar pantalla en blanco
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
      runApp(const GymZoneApp());
    }, (error, stack) {
      // Esto aparecerá en la salida del terminal y en la consola del host
      // cuando el usuario ejecute `flutter run` o abra DevTools.
      // Mantener simple: imprimimos la excepción y la traza.
      // El ErrorWidget.builder también mostrará un mensaje en pantalla.
      // ignore: avoid_print
      print('Unhandled zone error:');
      // ignore: avoid_print hola
      print(error);
      // ignore: avoid_print
      print(stack);
  });
}