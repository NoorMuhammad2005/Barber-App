// lib/screens/admin_screen.dart
import 'package:barbershop_app/models/models.dart';
import 'package:barbershop_app/providers/booking_provider.dart';
import 'package:barbershop_app/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
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

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  final _iconController = TextEditingController();
  final _categoryController = TextEditingController();

  final _barberNameController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _experienceController = TextEditingController();
  final _ratingController = TextEditingController();
  final _imageController = TextEditingController();
  final _bioController = TextEditingController();

  String _bookingSearch = "";
  String _bookingFilter = "All";

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();

    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _iconController.dispose();
    _categoryController.dispose();

    super.dispose();
  }

  void _showBookingStatusSheet(Map<String, dynamic> booking) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Update Booking",
                  style: GoogleFonts.raleway(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                  ),
                  title: const Text("Confirmed"),
                  onTap: () async {
                    Navigator.pop(context);

                    await ref.read(bookingServiceProvider).updateBookingStatus(
                          bookingId: booking['id'],
                          status: "confirmed",
                        );

                    ref.invalidate(allBookingsProvider);
                    ref.invalidate(dashboardProvider);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.done_all,
                    color: Colors.green,
                  ),
                  title: const Text("Completed"),
                  onTap: () async {
                    Navigator.pop(context);

                    await ref.read(bookingServiceProvider).updateBookingStatus(
                          bookingId: booking['id'],
                          status: "completed",
                        );

                    ref.invalidate(allBookingsProvider);
                    ref.invalidate(dashboardProvider);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                  title: const Text("Cancelled"),
                  onTap: () async {
                    Navigator.pop(context);

                    await ref.read(bookingServiceProvider).updateBookingStatus(
                          bookingId: booking['id'],
                          status: "cancelled",
                        );

                    ref.invalidate(allBookingsProvider);
                    ref.invalidate(dashboardProvider);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBookingDetails(Map<String, dynamic> booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Booking Details",
                  style: GoogleFonts.raleway(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 25),
                _detailRow("Customer", booking['customer_name']),
                _detailRow("Phone", booking['customer_phone']),
                _detailRow("Email", booking['customer_email']),
                _detailRow("Barber", booking['barbers']?['name'] ?? "-"),
                _detailRow("Service", booking['services']?['name'] ?? "-"),
                _detailRow("Date", booking['booking_date']),
                _detailRow("Time", booking['time_slot']),
                _detailRow("Price", booking['total_price']),
                _detailRow("Status", booking['status']),
                const SizedBox(height: 25),
                GoldButton(
                  label: "Update Status",
                  onTap: () {
                    Navigator.pop(context);
                    _showBookingStatusSheet(booking);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              "$title:",
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? "-",
              style: GoogleFonts.raleway(
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddBarberSheet(BuildContext context) {
    _showBarberSheet(context, null);
  }

  void _showEditBarberSheet(BuildContext context, BarberModel? barber) {
    _showBarberSheet(context, barber);
  }

  void _showBarberSheet(BuildContext context, BarberModel? barber) {
    if (barber == null) {
      _barberNameController.clear();
      _specialtyController.clear();
      _experienceController.clear();
      _ratingController.clear();
      _imageController.clear();
      _bioController.clear();
    } else {
      _barberNameController.text = barber.name;
      _specialtyController.text = barber.specialty;
      _experienceController.text = barber.experienceYears.toString();
      _ratingController.text = barber.rating.toString();
      _imageController.text = barber.imageUrl;
      _bioController.text = barber.bio;
    }

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
                    24,
                    24,
                    24,
                    MediaQuery.of(context).viewInsets.bottom + 24,
                  ),
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
                          barber == null ? "Add Barber" : "Edit Barber",
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _barberNameController,
                          decoration: const InputDecoration(
                            labelText: "Barber Name",
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _specialtyController,
                          decoration: const InputDecoration(
                            labelText: "Specialty",
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _experienceController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Experience",
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _ratingController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Rating",
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _imageController,
                          decoration: const InputDecoration(
                            labelText: "Image URL",
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _bioController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: "Bio",
                          ),
                        ),
                        const SizedBox(height: 24),
                        GoldButton(
                          label: barber == null ? "Add Barber" : "Save Changes",
                          onTap: () async {
                            final client = Supabase.instance.client;
                            final uuid = const Uuid();

                            try {
                              if (barber == null) {
                                // ADD BARBER
                                final response =
                                    await client.from('barbers').insert({
                                  'id': uuid.v4(),
                                  'name': _barberNameController.text.trim(),
                                  'specialty': _specialtyController.text.trim(),
                                  'experience_years': int.tryParse(
                                          _experienceController.text) ??
                                      0,
                                  'rating':
                                      double.tryParse(_ratingController.text) ??
                                          0,
                                  'image_url': _imageController.text.trim(),
                                  'bio': _bioController.text.trim(),
                                  'is_active': true,
                                }).select();

                                print("BARBER ADDED: $response");
                              } else {
                                // EDIT BARBER
                                final response = await client
                                    .from('barbers')
                                    .update({
                                      'name': _barberNameController.text.trim(),
                                      'specialty':
                                          _specialtyController.text.trim(),
                                      'experience_years': int.tryParse(
                                              _experienceController.text) ??
                                          0,
                                      'rating': double.tryParse(
                                              _ratingController.text) ??
                                          0,
                                      'image_url': _imageController.text.trim(),
                                      'bio': _bioController.text.trim(),
                                    })
                                    .eq('id', barber.id)
                                    .select();

                                print("BARBER UPDATED: $response");
                              }

                              ref.invalidate(barbersProvider);

                              if (context.mounted) {
                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      barber == null
                                          ? "Barber Added Successfully"
                                          : "Barber Updated Successfully",
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              print("BARBER ERROR: $e");
                            }
                          },
                        ),
                      ]),
                )));
  }

  @override
  Widget build(BuildContext context) {
    final services = ref.watch(servicesProvider);
    final barbers = ref.watch(barbersProvider);
    final bookings = ref.watch(allBookingsProvider);

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Admin Dashboard",
              style: GoogleFonts.cormorantGaramond(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              "Manage your barber business",
              style: GoogleFonts.raleway(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.gold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Stack(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.textPrimary,
                    size: 28,
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
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
              tabs: const [
                Tab(text: 'Dashboard'),
                Tab(text: 'Bookings'),
                Tab(text: 'Services'),
                Tab(text: 'Barbers'),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _buildDashboard(),
                _buildBookingsTab(bookings),
                services.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (e, _) => Center(
                    child: Text(e.toString()),
                  ),
                  data: (serviceList) {
                    return _buildServicesTab(serviceList);
                  },
                ),
                barbers.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (e, _) => Center(
                    child: Text(e.toString()),
                  ),
                  data: (barberList) {
                    return _buildBarbersTab(barberList);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    final dashboard = ref.watch(dashboardProvider);
    final user = ref.watch(profileProvider);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff2B2B2B),
                  Color(0xff171717),
                ],
              ),
              border: Border.all(
                color: AppColors.gold.withOpacity(.25),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withOpacity(.08),
                  blurRadius: 25,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_rounded,
                    color: Colors.black,
                    size: 34,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Back",
                        style: GoogleFonts.raleway(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        user?.name ?? "Admin",
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Manage your barber shop with ease.",
                        style: GoogleFonts.raleway(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: -.2),

          const SizedBox(height: 24),
          //     KPI Cards
          dashboard.when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (e, _) => Center(
              child: Text(e.toString()),
            ),
            data: (data) {
              return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  _kpiCard(
                    "£${data['revenue']}",
                    "Revenue",
                    Icons.payments_rounded,
                    AppColors.gold,
                    "+0%",
                  ),
                  _kpiCard(
                    "${data['totalBookings']}",
                    "Bookings",
                    Icons.calendar_today_rounded,
                    AppColors.info,
                    "+0%",
                  ),
                  _kpiCard(
                    "${data['completed']}",
                    "Completed",
                    Icons.check_circle,
                    AppColors.success,
                    "+0%",
                  ),
                  _kpiCard(
                    "${data['pending']}",
                    "Pending",
                    Icons.schedule,
                    AppColors.warning,
                    "+0%",
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          dashboard.when(
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
            data: (data) {
              return Row(
                children: [
                  Expanded(
                    child: _miniStatCard(
                      "Today's Bookings",
                      "${data["todayBookings"]}",
                      Icons.calendar_today_rounded,
                      AppColors.info,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _miniStatCard(
                      "Pending",
                      "${data["pendingBookings"]}",
                      Icons.schedule_rounded,
                      AppColors.warning,
                    ),
                  ),
                ],
              );
            },
          ),
          // Revenue Chart
          Text(
            'Weekly Revenue',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ).animate(delay: 100.ms).fadeIn(),

          const SizedBox(height: 16),

          dashboard.when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (_, __) => const SizedBox(),
            data: (data) {
              print(data["weeklyRevenue"]);
              print(data["weeklyRevenue"].runtimeType);

              final revenue = List<double>.from(data["weeklyRevenue"]);
              return Container(
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.surfaceHighest,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(
                  16,
                  20,
                  16,
                  12,
                ),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: revenue.isEmpty
                        ? 100
                        : revenue.reduce((a, b) => a > b ? a : b) + 20,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

                            return Text(
                              days[value.toInt()],
                              style: GoogleFonts.raleway(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) => const FlLine(
                        color: AppColors.surfaceHighest,
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(
                      revenue.length,
                      (index) => _bar(index, revenue[index]),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          //         // Top Services
          Text(
            'Top Services',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 16),

          dashboard.when(
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const SizedBox(),
            data: (data) {
              final services = Map<String, int>.from(data["topServices"]);

              final sorted = services.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value));

              final colors = [
                AppColors.gold,
                AppColors.info,
                AppColors.success,
                AppColors.warning,
              ];

              if (sorted.isEmpty) {
                return const Center(
                  child: Text("No completed bookings yet"),
                );
              }

              return Column(
                children: List.generate(
                  sorted.length > 4 ? 4 : sorted.length,
                  (i) {
                    final item = sorted[i];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _topServiceRow(
                        item.key,
                        item.value,
                        colors[i % colors.length],
                      ),
                    ).animate().fadeIn().slideX(begin: -.1);
                  },
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          Text(
            'Recent Bookings',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 16),

          dashboard.when(
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const SizedBox(),
            data: (data) {
              final bookings =
                  List<Map<String, dynamic>>.from(data["recentBookings"]);

              if (bookings.isEmpty) {
                return const Center(
                  child: Text("No bookings found"),
                );
              }

              return Column(
                children: bookings.map((b) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _recentBookingCard(b),
                  );
                }).toList(),
              );
            },
          ),

          //         const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _recentBookingCard(Map<String, dynamic> booking) {
    Color statusColor = AppColors.warning;

    switch (booking["status"]) {
      case "completed":
        statusColor = AppColors.success;
        break;

      case "confirmed":
        statusColor = AppColors.info;
        break;

      case "cancelled":
        statusColor = AppColors.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.surfaceHighest,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: statusColor.withValues(alpha: .15),
            child: Icon(
              Icons.person,
              color: statusColor,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking["customer_name"] ?? "-",
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${booking["services"]?["name"] ?? "-"} • ${booking["barbers"]?["name"] ?? "-"}",
                  style: GoogleFonts.raleway(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                booking["time_slot"] ?? "",
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  booking["status"].toString().toUpperCase(),
                  style: GoogleFonts.raleway(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
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

  Widget _kpiCard(
    String value,
    String label,
    IconData icon,
    Color color,
    String change,
  ) {
    final isPositive = change.startsWith('+');

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff242424),
            Color(0xff171717),
          ],
        ),
        border: Border.all(
          color: AppColors.surfaceHighest,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color:
                      (isPositive ? Colors.green : Colors.red).withOpacity(.15),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      size: 14,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      change,
                      style: GoogleFonts.raleway(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.raleway(
              fontSize: 13,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _topServiceRow(
    String name,
    int pct,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.surfaceHighest,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withOpacity(.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.content_cut_rounded,
                  color: color,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.raleway(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "$pct Bookings",
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "$pct%",
                style: GoogleFonts.raleway(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: LinearProgressIndicator(
              value: pct / 100,
              minHeight: 8,
              backgroundColor: AppColors.surfaceHighest,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsTab(
    AsyncValue<List<Map<String, dynamic>>> bookings,
  ) {
    return bookings.when(
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
        error: (e, _) => Center(
              child: Text(e.toString()),
            ),
        data: (bookingList) {
          final filteredBookings = bookingList.where((b) {
            final customer =
                (b['customer_name'] ?? '').toString().toLowerCase();

            final matchesSearch = customer.contains(
              _bookingSearch.toLowerCase(),
            );

            final matchesStatus =
                _bookingFilter == "All" || b['status'] == _bookingFilter;

            return matchesSearch && matchesStatus;
          }).toList();
          return Column(
            children: [
              // Today header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search customer...",
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: AppColors.surfaceElevated,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _bookingSearch = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: _bookingFilter,
                      dropdownColor: AppColors.surfaceElevated,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(
                          value: "All",
                          child: Text("All"),
                        ),
                        DropdownMenuItem(
                          value: "pending",
                          child: Text("Pending"),
                        ),
                        DropdownMenuItem(
                          value: "confirmed",
                          child: Text("Confirmed"),
                        ),
                        DropdownMenuItem(
                          value: "completed",
                          child: Text("Completed"),
                        ),
                        DropdownMenuItem(
                          value: "cancelled",
                          child: Text("Cancelled"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _bookingFilter = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    const Icon(Icons.today_rounded,
                        color: AppColors.gold, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Today — ${bookingList.length} appointments',
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
                        'Export',
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
                  itemCount: filteredBookings.length,
                  itemBuilder: (context, i) {
                    final b = filteredBookings[i];
                    final statusColor = b['status'] == 'confirmed'
                        ? AppColors.info
                        : b['status'] == 'completed'
                            ? AppColors.success
                            : b['status'] == 'cancelled'
                                ? AppColors.error
                                : AppColors.warning;

                    return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            _showBookingDetails(b);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.surfaceElevated,
                              borderRadius: BorderRadius.circular(16),
                              border:
                                  Border.all(color: AppColors.surfaceHighest),
                            ),
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: statusColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      b['time_slot'],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        b['customer_name']!,
                                        style: GoogleFonts.raleway(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        '${b['services']?['name'] ?? ''} • ${b['barbers']?['name'] ?? ''}',
                                        style: GoogleFonts.raleway(
                                          fontSize: 12,
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            statusColor.withValues(alpha: .15),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        b['status'].toString().toUpperCase(),
                                        style: GoogleFonts.raleway(
                                          color: statusColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit_calendar,
                                        color: Colors.amber,
                                      ),
                                      onPressed: () async {
                                        _showBookingStatusSheet(b);
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                            .animate(delay: (i * 60).ms)
                            .fadeIn()
                            .slideY(begin: 0.1));
                  },
                ),
              ),
            ],
          );
        });
  }

  Widget _buildServicesTab(List<dynamic> services) {
    final serviceList = services
        .map((e) => ServiceModel.fromMap(e as Map<String, dynamic>))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: GoldButton(
            label: '+ Add Service',
            height: 48,
            onTap: () => _showAddServiceSheet(context),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            itemCount: serviceList.length,
            itemBuilder: (context, i) {
              final svc = serviceList[i];
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
                              svc.name,
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
//                           Switch(
//   value: svc.isActive,
//   activeColor: AppColors.gold,
//   onChanged: (value) async {
//     try {
//       await Supabase.instance.client
//           .from('services')
//           .update({
//             'is_active': value,
//           })
//           .eq('id', svc.id);

//       ref.invalidate(servicesProvider);

//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               value
//                   ? "Service Activated"
//                   : "Service Deactivated",
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       print(e);
//     }
//   },
// ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.amber),
                            onPressed: () {
                              _showEditServiceSheet(context, svc);
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: AppColors.error,
                              size: 18,
                            ),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Delete Service"),
                                  content: Text(
                                    "Are you sure you want to delete '${svc.name}'?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              // if (confirm == true) {
                              //   await Supabase.instance.client
                              //       .from('services')
                              //       .delete()
                              //       .eq('id', svc.id);

                              //   ref.invalidate(servicesProvider);

                              //   if (context.mounted) {
                              //     ScaffoldMessenger.of(context).showSnackBar(
                              //       const SnackBar(
                              //         content:
                              //             Text("Service Deleted Successfully"),
                              //       ),
                              //     );
                              //   }
                              // }

                              if (confirm == true) {
                                try {
                                  print("Deleting Service...");
                                  print("ID: ${svc.id}");
                                  print("Name: ${svc.name}");

                                  final response = await Supabase
                                      .instance.client
                                      .from('services')
                                      .delete()
                                      .eq('id', svc.id)
                                      .select();

                                  print("DELETE RESPONSE: $response");

                                  ref.invalidate(servicesProvider);

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Service Deleted Successfully"),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  print("DELETE ERROR: $e");

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                  }
                                }
                              }
                            },
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

  Widget _buildBarbersTab(List<dynamic> barbers) {
    final barberList = barbers
        .map((e) => BarberModel.fromMap(e as Map<String, dynamic>))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: GoldButton(
            label: '+ Add Barber',
            height: 48,
            onTap: () => _showAddBarberSheet(context),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            itemCount: barberList.length,
            itemBuilder: (context, i) {
              final barber = barberList[i];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.surfaceHighest,
                    ),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: barber.imageUrl.isNotEmpty
                            ? NetworkImage(barber.imageUrl)
                            : null,
                        child: barber.imageUrl.isEmpty
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              barber.name,
                              style: GoogleFonts.raleway(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              barber.specialty,
                              style: GoogleFonts.raleway(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  barber.rating.toString(),
                                  style: GoogleFonts.raleway(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  "${barber.experienceYears} Years",
                                  style: GoogleFonts.raleway(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.amber,
                            ),
                            onPressed: () {
                              _showEditBarberSheet(context, barber);
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Delete Barber"),
                                  content: Text(
                                    "Are you sure you want to delete '${barber.name}'?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                try {
                                  final response = await Supabase
                                      .instance.client
                                      .from('barbers')
                                      .delete()
                                      .eq('id', barber.id)
                                      .select();

                                  print("DELETE BARBER: $response");

                                  ref.invalidate(barbersProvider);

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Barber Deleted Successfully"),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  print("DELETE BARBER ERROR: $e");
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAddServiceSheet(BuildContext context) {
    _showServiceSheet(context, null);
  }

  void _showEditServiceSheet(BuildContext context, dynamic svc) {
    _showServiceSheet(context, svc);
  }

  void _showServiceSheet(BuildContext context, dynamic svc) {
    if (svc == null) {
      _nameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      _durationController.clear();
      _iconController.clear();
      _categoryController.clear();
    } else {
      _nameController.text = svc.name;
      _descriptionController.text = svc.description;
      _priceController.text = svc.price.toString();
      _durationController.text = svc.durationMinutes.toString();
      _iconController.text = svc.icon;
      _categoryController.text = svc.category;
    }
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
                svc == null ? ('Add Service') : ('Edit Service'),
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                style: GoogleFonts.raleway(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Service Name',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _priceController,
                      style: GoogleFonts.raleway(color: AppColors.textPrimary),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price (£)',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _durationController,
                      style: GoogleFonts.raleway(color: AppColors.textPrimary),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Duration (min)',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descriptionController,
                style: GoogleFonts.raleway(color: AppColors.textPrimary),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _iconController,
                decoration: const InputDecoration(
                  labelText: "Icon (✂️)",
                ),
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 12),
              TextField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: "Category",
                ),
              ),
              const SizedBox(height: 24),
              GoldButton(
                label: svc == null ? 'Add Service' : 'Save Changes',
                onTap: () async {
                  final client = Supabase.instance.client;

                  if (svc == null) {
                    // ADD
                    await client.from('services').insert({
                      'name': _nameController.text.trim(),
                      'description': _descriptionController.text.trim(),
                      'price': double.tryParse(_priceController.text) ?? 0,
                      'duration_minutes':
                          int.tryParse(_durationController.text) ?? 0,
                      'icon': _iconController.text.trim(),
                      'category': _categoryController.text.trim(),
                      'is_active': true,
                      'is_popular': false,
                    });
                  } else {
                    // EDIT
                    await client.from('services').update({
                      'name': _nameController.text.trim(),
                      'description': _descriptionController.text.trim(),
                      'price': double.tryParse(_priceController.text) ?? 0,
                      'duration_minutes':
                          int.tryParse(_durationController.text) ?? 0,
                      'icon': _iconController.text.trim(),
                      'category': _categoryController.text.trim(),
                    }).eq('id', svc.id);
                  }

                  ref.invalidate(servicesProvider);

                  if (context.mounted) {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          svc == null
                              ? "Service Added Successfully"
                              : "Service Updated Successfully",
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteService(String id) async {
    final client = Supabase.instance.client;

    try {
      await client.from('services').delete().eq('id', id);

      ref.invalidate(servicesProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Service Deleted Successfully"),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Widget _miniStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.surfaceHighest,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
