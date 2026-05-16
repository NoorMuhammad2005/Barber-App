// lib/utils/helpers.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'app_theme.dart';

// ─── Date & Time ────────────────────────────────────────────────────────────

String formatDate(DateTime date, {String locale = 'en'}) {
  if (locale == 'ar') {
    const arMonths = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return '${date.day} ${arMonths[date.month - 1]} ${date.year}';
  }
  return DateFormat('EEE, MMM d, yyyy').format(date);
}

String formatDateShort(DateTime date, {String locale = 'en'}) {
  if (locale == 'ar') {
    const arMonths = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return '${date.day} ${arMonths[date.month - 1]}';
  }
  return DateFormat('MMM d').format(date);
}

String timeAgo(DateTime date) {
  final diff = DateTime.now().difference(date);
  if (diff.inDays > 30) return '${diff.inDays ~/ 30} months ago';
  if (diff.inDays > 0) return '${diff.inDays}d ago';
  if (diff.inHours > 0) return '${diff.inHours}h ago';
  if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
  return 'Just now';
}

String formatPrice(double price, {String currency = '£'}) {
  return '$currency${price.toStringAsFixed(2)}';
}

// ─── Validators ───────────────────────────────────────────────────────────

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) return 'Email is required';
  final re = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!re.hasMatch(value)) return 'Enter a valid email';
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'Password is required';
  if (value.length < 6) return 'Password must be at least 6 characters';
  return null;
}

String? validateName(String? value) {
  if (value == null || value.trim().isEmpty) return 'Name is required';
  if (value.trim().length < 2) return 'Name is too short';
  return null;
}

String? validatePhone(String? value) {
  if (value == null || value.isEmpty) return 'Phone is required';
  final re = RegExp(r'^\+?[\d\s\-]{7,15}$');
  if (!re.hasMatch(value)) return 'Enter a valid phone number';
  return null;
}

// ─── UI Helpers ───────────────────────────────────────────────────────────

void showGoldSnackBar(BuildContext context, String message,
    {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: isError ? AppColors.error : AppColors.surfaceElevated,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isError
              ? AppColors.error.withOpacity(0.4)
              : AppColors.gold.withOpacity(0.4),
        ),
      ),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    ),
  );
}

Future<bool?> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  bool isDestructive = false,
}) {
  return showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppColors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.surfaceHighest),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
          height: 1.5,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            cancelLabel,
            style: const TextStyle(color: AppColors.textMuted),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            confirmLabel,
            style: TextStyle(
              color: isDestructive ? AppColors.error : AppColors.gold,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}

// ─── Extensions ───────────────────────────────────────────────────────────

extension StringExt on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  String truncate(int maxLen) =>
      length > maxLen ? '${substring(0, maxLen)}...' : this;

  bool get isValidEmail =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
}

extension DateTimeExt on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  bool get isPast => isBefore(DateTime.now());

  DateTime get startOfDay => DateTime(year, month, day);

  DateTime get endOfDay =>
      DateTime(year, month, day, 23, 59, 59);
}

extension DoubleExt on double {
  String get asCurrency => '£${toStringAsFixed(2)}';
  String get asPts => '${toInt()} pts';
}
