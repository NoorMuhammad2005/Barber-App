// lib/screens/profile_screen.dart
import 'package:barbershop_app/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/app_theme.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';
import '../widgets/common_widgets.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = ref.watch(languageProvider) == 'ar';
    final bookings = ref.watch(bookingHistoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverToBoxAdapter(child: _buildHeader(isArabic)),
        ],
        body: Column(
          children: [
            // Tab Bar
            Container(
              color: AppColors.surface,
              child: TabBar(
                controller: _tabs,
                indicatorColor: AppColors.gold,
                indicatorWeight: 2,
                labelColor: AppColors.gold,
                unselectedLabelColor: AppColors.textMuted,
                labelStyle: GoogleFonts.raleway(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
                tabs: [
                  Tab(text: isArabic ? 'الملف الشخصي' : 'Profile'),
                  Tab(text: isArabic ? 'الحجوزات' : 'Bookings'),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: [
                  _buildProfileTab(isArabic),
                  _buildBookingsTab(isArabic, bookings),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isArabic) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 20, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1500), Color(0xFF141414)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.goldGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withOpacity(0.4),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('👤', style: TextStyle(fontSize: 40)),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.background, width: 2),
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    color: AppColors.gold,
                    size: 16,
                  ),
                ),
              ),
            ],
          ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),

          const SizedBox(height: 16),

          Text(
            isArabic ? 'جون سميث' : 'John Smith',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ).animate(delay: 100.ms).fadeIn(),

          Text(
            isArabic ? 'عضو مميز' : 'Premium Member',
            style: GoogleFonts.raleway(
              fontSize: 13,
              color: AppColors.textGold,
              fontWeight: FontWeight.w600,
            ),
          ).animate(delay: 150.ms).fadeIn(),

          const SizedBox(height: 20),

          // Member stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _headerStat('8', isArabic ? 'زيارة' : 'Visits', '💈'),
              Container(width: 1, height: 36, color: AppColors.surfaceHighest),
              _headerStat('4.9', isArabic ? 'تقييمي' : 'My Rating', '⭐'),
              Container(width: 1, height: 36, color: AppColors.surfaceHighest),
              _headerStat('£240', isArabic ? 'أنفقت' : 'Spent', '💷'),
            ],
          ).animate(delay: 200.ms).fadeIn(),
        ],
      ),
    );
  }

  Widget _headerStat(String val, String label, String emoji) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 4),
        Text(
          val,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.gold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.raleway(
            fontSize: 11,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileTab(bool isArabic) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(isArabic ? 'المعلومات الشخصية' : 'Personal Info'),
          const SizedBox(height: 12),
          _infoTile(
            Icons.person_rounded,
            isArabic ? 'الاسم الكامل' : 'Full Name',
            isArabic ? 'جون سميث' : 'John Smith',
          ),
          _infoTile(
            Icons.phone_rounded,
            isArabic ? 'الهاتف' : 'Phone',
            '+44 7700 900123',
          ),
          _infoTile(
            Icons.mail_rounded,
            isArabic ? 'البريد الإلكتروني' : 'Email',
            'john.smith@email.com',
          ),
          _infoTile(
            Icons.location_on_rounded,
            isArabic ? 'الموقع' : 'Location',
            'London, UK',
          ),
          const SizedBox(height: 28),
          _sectionTitle(isArabic ? 'التفضيلات' : 'Preferences'),
          const SizedBox(height: 12),
          _toggleTile(
            Icons.notifications_rounded,
            isArabic ? 'الإشعارات' : 'Notifications',
            true,
          ),
          _toggleTile(
            Icons.calendar_today_rounded,
            isArabic ? 'تذكير الحجز' : 'Booking Reminders',
            true,
          ),
          _toggleTile(
            Icons.local_offer_rounded,
            isArabic ? 'العروض الترويجية' : 'Promotions',
            false,
          ),
          const SizedBox(height: 28),
          _sectionTitle(isArabic ? 'اللغة' : 'Language'),
          const SizedBox(height: 12),
          _languageSwitcher(isArabic),
          const SizedBox(height: 28),
          _sectionTitle(isArabic ? 'الحساب' : 'Account'),
          const SizedBox(height: 12),
          _actionTile(
              Icons.shield_rounded,
              isArabic ? 'الأمان والخصوصية' : 'Security & Privacy',
              AppColors.info),
          _actionTile(
              Icons.help_outline_rounded,
              isArabic ? 'مساعدة ودعم' : 'Help & Support',
              AppColors.textSecondary),
          _actionTile(Icons.star_rounded,
              isArabic ? 'تقييم التطبيق' : 'Rate the App', AppColors.gold),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: Text(isArabic ? 'تسجيل الخروج' : 'Sign Out'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              foregroundColor: AppColors.error,
              side: BorderSide(color: AppColors.error.withOpacity(0.3)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildBookingsTab(bool isArabic, List<BookingModel> bookings) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📅', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            Text(
              isArabic ? 'لا توجد حجوزات بعد' : 'No bookings yet',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 24,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      itemCount: bookings.length,
      itemBuilder: (context, i) {
        final booking = bookings[i];
        final isUpcoming = booking.date.isAfter(DateTime.now());

        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isUpcoming
                    ? AppColors.gold.withOpacity(0.3)
                    : AppColors.surfaceHighest,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _statusColor(booking.status).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _statusLabel(booking.status, isArabic),
                        style: GoogleFonts.raleway(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _statusColor(booking.status),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat('MMM d, y').format(booking.date),
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  booking.serviceName,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.person_rounded,
                        size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 6),
                    Text(
                      booking.barberName,
                      style: GoogleFonts.raleway(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time_rounded,
                        size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 6),
                    Text(
                      booking.timeSlot,
                      style: GoogleFonts.raleway(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '£${booking.price.toStringAsFixed(2)}',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gold,
                      ),
                    ),
                    if (booking.status == BookingStatus.completed)
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.star_outline_rounded,
                            size: 16, color: AppColors.gold),
                        label: Text(
                          isArabic ? 'تقييم' : 'Review',
                          style: GoogleFonts.raleway(
                            fontSize: 13,
                            color: AppColors.gold,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    if (isUpcoming)
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.cancel_outlined,
                            size: 16, color: AppColors.error),
                        label: Text(
                          isArabic ? 'إلغاء' : 'Cancel',
                          style: GoogleFonts.raleway(
                            fontSize: 13,
                            color: AppColors.error,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ).animate(delay: (i * 80).ms).fadeIn().slideY(begin: 0.1);
      },
    );
  }

  Color _statusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return AppColors.info;
      case BookingStatus.completed:
        return AppColors.success;
      case BookingStatus.cancelled:
        return AppColors.error;
      case BookingStatus.pending:
        return AppColors.warning;
    }
  }

  String _statusLabel(BookingStatus status, bool isArabic) {
    switch (status) {
      case BookingStatus.confirmed:
        return isArabic ? 'مؤكد' : 'Confirmed';
      case BookingStatus.completed:
        return isArabic ? 'مكتمل' : 'Completed';
      case BookingStatus.cancelled:
        return isArabic ? 'ملغي' : 'Cancelled';
      case BookingStatus.pending:
        return isArabic ? 'قيد الانتظار' : 'Pending';
    }
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.cormorantGaramond(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceHighest),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: AppColors.gold, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.raleway(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.raleway(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.edit_outlined, color: AppColors.textMuted, size: 18),
        ],
      ),
    );
  }

  Widget _toggleTile(IconData icon, String label, bool value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceHighest),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.raleway(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: (_) {},
            activeColor: AppColors.gold,
            inactiveTrackColor: AppColors.surfaceHighest,
          ),
        ],
      ),
    );
  }

  Widget _languageSwitcher(bool isArabic) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceHighest),
      ),
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          _langOption('EN', 'English', !isArabic),
          const SizedBox(width: 6),
          _langOption('AR', 'العربية', isArabic),
        ],
      ),
    );
  }

  Widget _langOption(String code, String label, bool isActive) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(languageProvider.notifier).state = code.toLowerCase();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isActive ? AppColors.goldGradient : null,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                code,
                style: GoogleFonts.raleway(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isActive ? AppColors.background : AppColors.textMuted,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.raleway(
                  fontSize: 11,
                  color: isActive
                      ? AppColors.background.withOpacity(0.7)
                      : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionTile(IconData icon, String label, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceHighest),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 22),
        title: Text(
          label,
          style: GoogleFonts.raleway(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded,
            color: AppColors.textMuted, size: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        onTap: () async {
          await Supabase.instance.client.auth.signOut();

          if (context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => AuthScreen(),
              ),
              (route) => false,
            );
          }
        },
      ),
    );
  }
}
