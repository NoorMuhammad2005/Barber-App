// lib/screens/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';
import '../providers/app_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = ref.watch(languageProvider) == 'ar';

    final notifications = [
      _NotifItem(
        icon: '✅',
        color: AppColors.success,
        title: isArabic ? 'تأكيد الحجز' : 'Booking Confirmed',
        body: isArabic
            ? 'تم تأكيد حجزك — قصة شعر مع جيمس هاريسون الأربعاء 3:00 م'
            : 'Your Classic Haircut with James Harrison is confirmed for Wed at 3:00 PM.',
        time: '2 min ago',
        isUnread: true,
      ),
      _NotifItem(
        icon: '⏰',
        color: AppColors.warning,
        title: isArabic ? 'تذكير موعد' : 'Appointment Reminder',
        body: isArabic
            ? 'موعدك مع ماركوس وليامز بعد ساعة — تشذيب اللحية الساعة 11 ص'
            : 'Your Beard Trim with Marcus Williams is in 1 hour at 11:00 AM.',
        time: '1 hr ago',
        isUnread: true,
      ),
      _NotifItem(
        icon: '🎉',
        color: AppColors.gold,
        title: isArabic ? 'عرض خاص' : 'Special Offer',
        body: isArabic
            ? 'احصل على خصم 20% على أول حجز لك — العرض ينتهي الجمعة!'
            : 'Get 20% off your first booking this week — offer ends Friday!',
        time: 'Yesterday',
        isUnread: false,
      ),
      _NotifItem(
        icon: '💳',
        color: AppColors.success,
        title: isArabic ? 'تم الدفع' : 'Payment Successful',
        body: isArabic
            ? 'تم دفع £25 بنجاح عن قصة شعر كلاسيكية'
            : '£25.00 paid successfully for Classic Haircut.',
        time: '2 days ago',
        isUnread: false,
      ),
      _NotifItem(
        icon: '⭐',
        color: AppColors.warning,
        title: isArabic ? 'قيّم تجربتك' : 'Rate Your Experience',
        body: isArabic
            ? 'كيف كانت تجربتك مع جيمس هاريسون؟ شاركنا رأيك'
            : 'How was your experience with James Harrison? Share your feedback.',
        time: '3 days ago',
        isUnread: false,
      ),
      _NotifItem(
        icon: '📅',
        color: AppColors.info,
        title: isArabic ? 'تذكير الغد' : 'Tomorrow\'s Appointment',
        body: isArabic
            ? 'تذكير: حجزك غداً مع خالد الراشد الساعة 2:00 م — حلاقة بالمنشفة الساخنة'
            : 'Reminder: Hot Towel Shave with Khalid Al-Rashid tomorrow at 2:00 PM.',
        time: '5 days ago',
        isUnread: false,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isArabic ? 'الإشعارات' : 'Notifications',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              isArabic ? 'قراءة الكل' : 'Mark all read',
              style: GoogleFonts.raleway(
                fontSize: 12,
                color: AppColors.gold,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmpty(isArabic)
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              physics: const BouncingScrollPhysics(),
              itemCount: notifications.length,
              itemBuilder: (_, i) {
                final n = notifications[i];
                return _buildNotifTile(context, n, i)
                    .animate(delay: (i * 60).ms)
                    .fadeIn()
                    .slideX(begin: 0.1, curve: Curves.easeOut);
              },
            ),
    );
  }

  Widget _buildNotifTile(
      BuildContext context, _NotifItem n, int index) {
    return Dismissible(
      key: Key('notif_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline_rounded,
            color: AppColors.error),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: n.isUnread
              ? AppColors.surfaceElevated
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: n.isUnread
                ? AppColors.gold.withOpacity(0.2)
                : AppColors.surfaceHighest,
          ),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: n.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(n.icon, style: const TextStyle(fontSize: 22)),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  n.title,
                  style: GoogleFonts.raleway(
                    fontSize: 14,
                    fontWeight: n.isUnread
                        ? FontWeight.w700
                        : FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (n.isUnread)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.gold,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                n.body,
                style: GoogleFonts.raleway(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                n.time,
                style: GoogleFonts.raleway(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(bool isArabic) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔔', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text(
            isArabic ? 'لا توجد إشعارات' : 'No Notifications',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 24,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic
                ? 'ستظهر هنا إشعارات حجوزاتك وعروضك'
                : 'Your booking updates and offers will appear here.',
            style: GoogleFonts.raleway(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _NotifItem {
  final String icon;
  final Color color;
  final String title;
  final String body;
  final String time;
  final bool isUnread;

  const _NotifItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    required this.time,
    required this.isUnread,
  });
}
