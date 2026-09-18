import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/notifications_screen.dart';

class AuthNotificationButton extends StatelessWidget {
  final Color color;

  const AuthNotificationButton({super.key, this.color = Colors.white});

  Future<bool> _hasSession() async {
    final prefs = await SharedPreferences.getInstance();
    final rawUser = prefs.getString('usuario');
    if (rawUser == null || rawUser.isEmpty) return false;
    try {
      final user = jsonDecode(rawUser) as Map<String, dynamic>;
      return int.tryParse('${user['idusuario'] ?? ''}') != null;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasSession(),
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox.shrink();
        return IconButton(
          icon: Icon(Icons.notifications_none, color: color),
          tooltip: 'Notificaciones',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
          ),
        );
      },
    );
  }
}