import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../models/task_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz_data.initializeTimeZones(); // Inisialisasi zona waktu

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(android: androidSettings);

    await _flutterLocalNotificationsPlugin.initialize(settings);
  }

  Future<void> scheduleNotification(TaskModel task) async {
    if (task.deadline == null) return;

    final id = task.title.hashCode;
    final androidDetails = AndroidNotificationDetails(
      'todo_channel',
      'To-do Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    // Konversi ke TZDateTime
    final tzTime = tz.TZDateTime.from(task.deadline!.subtract(const Duration(hours: 1)), tz.local);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Reminder: ${task.title}',
      'Deadline is near!',
      tzTime,
      NotificationDetails(android: androidDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }
}