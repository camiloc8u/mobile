import 'package:flutter/material.dart';

import 'screens/main_navigation_screen.dart';

class GymZoneApp extends StatelessWidget {
  const GymZoneApp({super.key});
  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF90EE00); // Verde neón de Figma
    return MaterialApp(
      title: 'GymZone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF09090B),
        primaryColor: primaryGreen,
        colorScheme: const ColorScheme.dark(
          primary: primaryGreen,
          surface: Color(0xFF18181B),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}
