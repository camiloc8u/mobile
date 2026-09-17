import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/notification_service.dart';
import '../theme/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  final int? userId;

  const NotificationsScreen({super.key, this.userId});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  Future<List<AppNotification>> _notifications = Future.value(const <AppNotification>[]);
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUser = prefs.getString('usuario');
    final savedUserData = savedUser == null ? null : jsonDecode(savedUser) as Map<String, dynamic>;
    final userId = widget.userId ?? int.tryParse('${savedUserData?['idusuario'] ?? ''}');
    if (!mounted) return;
    _currentUserId = userId;
    setState(() {
      _notifications = NotificationService().getInAppNotifications(userId: userId);
    });
  }

  Future<void> _deleteNotification(AppNotification notification) async {
    final userId = _currentUserId;
    final notificationUserId = notification.userId ?? userId;
    if (notificationUserId == null) return;
    final deleted = await NotificationService().deleteInAppNotification(
      notificationId: notification.id,
      userId: notificationUserId,
    );
    if (!mounted) return;
    if (deleted) {
      _reload();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo borrar la notificación')),
      );
    }
  }

  void _reload() {
    _loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text('NOTIFICACIONES'),
        backgroundColor: AppColors.cardBg,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), tooltip: 'Actualizar', onPressed: () => setState(_reload)),
        ],
      ),
      body: FutureBuilder<List<AppNotification>>(
        future: _notifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final notifications = snapshot.data ?? const <AppNotification>[];
          if (notifications.isEmpty) {
            return const Center(child: Text('No tienes notificaciones todavía', style: TextStyle(color: Colors.grey)));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return ListTile(
                tileColor: AppColors.cardBg,
                leading: const Icon(Icons.notifications_active, color: AppColors.greenColor),
                title: Text(notification.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(notification.message),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(notification.relativeTime, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                      tooltip: 'Borrar notificación',
                      onPressed: () => _deleteNotification(notification),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}