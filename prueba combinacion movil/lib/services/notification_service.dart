import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class AppNotification {
  final int id;
  final int? userId;
  final String title;
  final String message;
  final DateTime createdAt;

  const AppNotification({this.userId, required this.id, required this.title, required this.message, required this.createdAt});

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final rawMessage = (json['mensaje'] ?? '') as String;
    final titleMatch = RegExp(r'^\[([^\]]+)\]\s*(.*)$').firstMatch(rawMessage);
    final rawId = json['id_notificacion'] ?? json['id'] ?? 0;
    final rawUserId = json['usuario_id'];
    return AppNotification(
      userId: rawUserId == null ? null : int.tryParse('$rawUserId'),
      id: int.tryParse('$rawId') ?? 0,
      title: (json['titulo'] ?? titleMatch?.group(1) ?? 'GymZone') as String,
      message: titleMatch?.group(2) ?? rawMessage,
      createdAt: DateTime.tryParse('${json['fecha_envio'] ?? json['fecha'] ?? json['created_at'] ?? ''}') ?? DateTime.now(),
    );
  }

  String get relativeTime {
    final difference = DateTime.now().difference(createdAt);
    if (difference.inMinutes < 1) return 'hace un momento';
    if (difference.inHours < 1) return 'hace ${difference.inMinutes} min';
    if (difference.inDays < 1) return 'hace ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
    if (difference.inDays < 7) return 'hace ${difference.inDays} ${difference.inDays == 1 ? 'día' : 'días'}';
    final weeks = difference.inDays ~/ 7;
    if (difference.inDays < 30) return 'hace $weeks ${weeks == 1 ? 'semana' : 'semanas'}';
    final months = difference.inDays ~/ 30;
    if (difference.inDays < 365) return 'hace $months ${months == 1 ? 'mes' : 'meses'}';
    final years = difference.inDays ~/ 365;
    return 'hace $years ${years == 1 ? 'año' : 'años'}';
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<AppNotification> _localInbox = [];

  Future<bool> createInAppNotification({
    required String title,
    required String message,
    int? userId,
    bool broadcast = false,
  }) async {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      message: message,
      createdAt: DateTime.now(),
    );
    if (userId != null) _localInbox.insert(0, notification);

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrlNode}/notificaciones'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuario_id': broadcast ? null : userId,
          'broadcast': broadcast,
          'titulo': title,
          'mensaje': message,
        }),
      );
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  Future<List<AppNotification>> getInAppNotifications({int? userId}) async {
    if (userId == null) return const <AppNotification>[];
    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrlNode}/notificaciones/$userId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((item) => AppNotification.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (_) {
      // Se muestra la bandeja local como respaldo para app y web.
    }
    return const <AppNotification>[];
  }

  Future<bool> deleteInAppNotification({required int notificationId, required int userId}) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrlNode}/notificaciones/$userId/$notificationId'),
      );
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (_) {
      return false;
    }
  }

}