// lib/services/notification_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz_data.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: _onTap,
    );
  }

  static void _onTap(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
  }

  /// Request permission (iOS / Android 13+)
  static Future<bool> requestPermission() async {
    final ios = await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    return ios ?? true;
  }

  // ─── Immediate Notifications ───────────────────────────────────────────────

  static Future<void> showBookingConfirmation({
    required String serviceName,
    required String barberName,
    required String timeSlot,
    required DateTime date,
  }) async {
    await _plugin.show(
      1,
      '✅ Booking Confirmed!',
      '$serviceName with $barberName on ${_formatDate(date)} at $timeSlot',
      _details(
        channelId: 'bookings',
        channelName: 'Booking Updates',
        color: const Color(0xFFD4AF37),
      ),
      payload: 'booking_confirmed',
    );
  }

  static Future<void> showPaymentSuccess({
    required String serviceName,
    required double amount,
  }) async {
    await _plugin.show(
      2,
      '💳 Payment Successful',
      '£${amount.toStringAsFixed(2)} paid for $serviceName',
      _details(
        channelId: 'payments',
        channelName: 'Payment Notifications',
        color: const Color(0xFF2ECC71),
      ),
      payload: 'payment_success',
    );
  }

  static Future<void> showPromotion({
    required String title,
    required String body,
  }) async {
    await _plugin.show(
      3,
      title,
      body,
      _details(
        channelId: 'promotions',
        channelName: 'Promotions & Offers',
        color: const Color(0xFFD4AF37),
      ),
      payload: 'promotion',
    );
  }

  // ─── Scheduled Notifications ───────────────────────────────────────────────

  /// Schedule a reminder 1 hour before the appointment.
  static Future<void> scheduleAppointmentReminder({
    required int id,
    required String serviceName,
    required String barberName,
    required DateTime appointmentTime,
  }) async {
    final reminderTime = appointmentTime.subtract(const Duration(hours: 1));
    if (reminderTime.isBefore(DateTime.now())) return;

    await _plugin.zonedSchedule(
      id,
      '⏰ Appointment in 1 Hour',
      '$serviceName with $barberName at ${_formatTime(appointmentTime)}',
      tz.TZDateTime.from(reminderTime, tz.local),
      _details(
        channelId: 'reminders',
        channelName: 'Appointment Reminders',
        color: const Color(0xFFD4AF37),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'reminder_$id',
    );
  }

  /// Schedule a day-before reminder.
  static Future<void> scheduleDayBeforeReminder({
    required int id,
    required String serviceName,
    required String barberName,
    required DateTime appointmentTime,
  }) async {
    final reminderTime =
        appointmentTime.subtract(const Duration(hours: 24));
    if (reminderTime.isBefore(DateTime.now())) return;

    await _plugin.zonedSchedule(
      id + 1000,
      '📅 Appointment Tomorrow',
      '$serviceName with $barberName at ${_formatTime(appointmentTime)}',
      tz.TZDateTime.from(reminderTime, tz.local),
      _details(
        channelId: 'reminders',
        channelName: 'Appointment Reminders',
        color: const Color(0xFFD4AF37),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'day_reminder_$id',
    );
  }

  /// Cancel a specific notification.
  static Future<void> cancel(int id) => _plugin.cancel(id);

  /// Cancel all notifications.
  static Future<void> cancelAll() => _plugin.cancelAll();

  // ─── Helpers ───────────────────────────────────────────────────────────────

  static NotificationDetails _details({
    required String channelId,
    required String channelName,
    required Color color,
  }) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        importance: Importance.high,
        priority: Priority.high,
        color: color,
        enableLights: true,
        ledColor: color,
        ledOnMs: 500,
        ledOffMs: 500,
        styleInformation: const DefaultStyleInformation(true, true),
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  static String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  static String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
