// lib/screens/admin_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/app_theme.dart';
import '../providers/app_provider.dart';
import '../widgets/common_widgets.dart';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = ref.watch(languageProvider) == 'ar';
    final services = ref.watch(servicesProvider);
    final bookings = ref.watch(bookingHistoryProvider);

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
        title: Column(
          children: [
            Text(
              isArabic ? 'لوحة التحكم' : 'Admin Panel',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              isArabic ? 'معاينة تجريبية' : 'Demo Preview',
              style: GoogleFonts.raleway(
                fontSize: 11,
                color: AppColors.gold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.goldGlow,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.gold.withOpacity(0.3)),
            ),
            child: Text(
              isArabic ? 'تجريبي' : 'DEMO',
              style: GoogleFonts.raleway(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.gold,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
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
              isScrollable: true,
              labelStyle: GoogleFonts.raleway(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              tabs: [
                Tab(text: isArabic ? 'الإحصائيات' : 'Dashboard'),
                Tab(text: isArabic ? 'الحجوزات' : 'Bookings'),
                Tab(text: isArabic ? 'الخدمات' : 'Services'),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _buildDashboard(isArabic),
                _buildBookingsTab(isArabic, bookings),
                _buildServicesTab(isArabic, services),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(bool isArabic) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPI Cards
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _kpiCard('£4,280', isArabic ? 'هذا الشهر' : 'This Month',
                  Icons.payments_rounded, AppColors.gold, '+18%'),
              _kpiCard('127', isArabic ? 'حجوزات' : 'Bookings',
                  Icons.calendar_today_rounded, AppColors.info, '+23%'),
              _kpiCard('4.9', isArabic ? 'متوسط التقييم' : 'Avg Rating',
                  Icons.star_rounded, AppColors.warning, '+0.2'),
              _kpiCard('42', isArabic ? 'عملاء جدد' : 'New Clients',
                  Icons.people_rounded, AppColors.success, '+12%'),
            ],
          ).animate().fadeIn().slideY(begin: 0.1),

          const SizedBox(height: 24),

          // Revenue Chart
          Text(
            isArabic ? 'الإيرادات الأسبوعية' : 'Weekly Revenue',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ).animate(delay: 100.ms).fadeIn(),

          const SizedBox(height: 16),

          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.surfaceHighest),
            ),
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 600,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, meta) {
                        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        return Text(
                          days[val.toInt()],
                          style: GoogleFonts.raleway(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (val) => FlLine(
                    color: AppColors.surfaceHighest,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _bar(0, 320),
                  _bar(1, 480),
                  _bar(2, 390),
                  _bar(3, 560),
                  _bar(4, 440),
                  _bar(5, 520),
                  _bar(6, 180),
                ],
              ),
            ),
          ).animate(delay: 150.ms).fadeIn(),

          const SizedBox(height: 24),

          // Top Services
          Text(
            isArabic ? 'الخدمات الأكثر طلبًا' : 'Top Services',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ).animate(delay: 200.ms).fadeIn(),

          const SizedBox(height: 16),

          ...([
            ('Classic Haircut', 38, AppColors.gold),
            ('Hot Towel Shave', 24, AppColors.info),
            ('Beard Trim', 22, AppColors.success),
            ('Hair Styling', 16, AppColors.warning),
          ].asMap().entries.map((entry) {
            final i = entry.key;
            final data = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _topServiceRow(data.$1, data.$2, data.$3),
            ).animate(delay: (250 + i * 60).ms).fadeIn().slideX(begin: -0.1);
          })),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  BarChartGroupData _bar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: AppColors.goldGradient,
          width: 20,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }

  Widget _kpiCard(String value, String label, IconData icon, Color color,
      String change) {
    final isPositive = change.startsWith('+');
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.surfaceHighest),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (isPositive ? AppColors.success : AppColors.error)
                      .withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  change,
                  style: GoogleFonts.raleway(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isPositive ? AppColors.success : AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
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
      ),
    );
  }

  Widget _topServiceRow(String name, int pct, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: GoogleFonts.raleway(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '$pct%',
              style: GoogleFonts.raleway(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct / 100,
            backgroundColor: AppColors.surfaceHighest,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildBookingsTab(bool isArabic, List<dynamic> bookings) {
    final demoBookings = [
      {'name': 'James M.', 'service': 'Classic Haircut', 'time': '10:00 AM', 'barber': 'James H.', 'status': 'confirmed'},
      {'name': 'Ahmed K.', 'service': 'Beard Trim', 'time': '11:00 AM', 'barber': 'Khalid R.', 'status': 'confirmed'},
      {'name': 'Thomas R.', 'service': 'Hot Towel Shave', 'time': '12:00 PM', 'barber': 'Marcus W.', 'status': 'pending'},
      {'name': 'Oliver B.', 'service': 'Hair Styling', 'time': '02:00 PM', 'barber': 'Daniel S.', 'status': 'completed'},
      {'name': 'Mohammed Q.', 'service': 'Luxury Facial', 'time': '03:30 PM', 'barber': 'James H.', 'status': 'cancelled'},
    ];

    return Column(
      children: [
        // Today header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              const Icon(Icons.today_rounded, color: AppColors.gold, size: 18),
              const SizedBox(width: 8),
              Text(
                isArabic ? 'اليوم — ${demoBookings.length} مواعيد' : 'Today — ${demoBookings.length} appointments',
                style: GoogleFonts.raleway(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  isArabic ? 'تصدير' : 'Export',
                  style: GoogleFonts.raleway(
                    fontSize: 13,
                    color: AppColors.gold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            itemCount: demoBookings.length,
            itemBuilder: (context, i) {
              final b = demoBookings[i];
              final statusColor = b['status'] == 'confirmed'
                  ? AppColors.info
                  : b['status'] == 'completed'
                      ? AppColors.success
                      : b['status'] == 'cancelled'
                          ? AppColors.error
                          : AppColors.warning;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.surfaceHighest),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            b['time']!.split(' ')[0],
                            style: GoogleFonts.raleway(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              b['name']!,
                              style: GoogleFonts.raleway(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '${b['service']} • ${b['barber']}',
                              style: GoogleFonts.raleway(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert_rounded,
                            color: AppColors.textMuted, size: 20),
                        color: AppColors.surfaceElevated,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            child: Text(isArabic ? 'تأكيد' : 'Confirm',
                                style: GoogleFonts.raleway(
                                    color: AppColors.success)),
                          ),
                          PopupMenuItem(
                            child: Text(isArabic ? 'إلغاء' : 'Cancel',
                                style: GoogleFonts.raleway(
                                    color: AppColors.error)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ).animate(delay: (i * 60).ms).fadeIn().slideY(begin: 0.1);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServicesTab(bool isArabic, List<dynamic> services) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: GoldButton(
            label: isArabic ? '+ إضافة خدمة' : '+ Add Service',
            height: 48,
            onTap: () => _showAddServiceSheet(context, isArabic),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            itemCount: services.length,
            itemBuilder: (context, i) {
              final svc = services[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.surfaceHighest),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.goldGlow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(svc.icon,
                              style: const TextStyle(fontSize: 22)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isArabic ? svc.nameAr : svc.name,
                              style: GoogleFonts.raleway(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '£${svc.price} · ${svc.durationMinutes} min',
                              style: GoogleFonts.raleway(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_rounded,
                                color: AppColors.textSecondary, size: 18),
                            onPressed: () =>
                                _showEditServiceSheet(context, isArabic, svc),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded,
                                color: AppColors.error, size: 18),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ).animate(delay: (i * 60).ms).fadeIn();
            },
          ),
        ),
      ],
    );
  }

  void _showAddServiceSheet(BuildContext context, bool isArabic) {
    _showServiceSheet(context, isArabic, null);
  }

  void _showEditServiceSheet(BuildContext context, bool isArabic, dynamic svc) {
    _showServiceSheet(context, isArabic, svc);
  }

  void _showServiceSheet(BuildContext context, bool isArabic, dynamic svc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, controller) => SingleChildScrollView(
          controller: controller,
          padding: EdgeInsets.fromLTRB(
              24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHighest,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                svc == null
                    ? (isArabic ? 'إضافة خدمة' : 'Add Service')
                    : (isArabic ? 'تعديل الخدمة' : 'Edit Service'),
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: TextEditingController(
                    text: svc != null ? (isArabic ? svc.nameAr : svc.name) : ''),
                style: GoogleFonts.raleway(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: isArabic ? 'اسم الخدمة' : 'Service Name',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(
                          text: svc != null ? '£${svc.price}' : ''),
                      style: GoogleFonts.raleway(color: AppColors.textPrimary),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: isArabic ? 'السعر' : 'Price (£)',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(
                          text: svc != null ? '${svc.durationMinutes}' : ''),
                      style: GoogleFonts.raleway(color: AppColors.textPrimary),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: isArabic ? 'المدة (دقيقة)' : 'Duration (min)',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: TextEditingController(
                    text: svc != null
                        ? (isArabic ? svc.descriptionAr : svc.description)
                        : ''),
                style: GoogleFonts.raleway(color: AppColors.textPrimary),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: isArabic ? 'الوصف' : 'Description',
                ),
              ),
              const SizedBox(height: 24),
              GoldButton(
                label: svc == null
                    ? (isArabic ? 'إضافة' : 'Add Service')
                    : (isArabic ? 'حفظ' : 'Save Changes'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
