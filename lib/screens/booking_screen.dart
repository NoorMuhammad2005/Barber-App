// lib/screens/booking_screen.dart
import 'package:barbershop_app/providers/booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils/app_theme.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';
import '../widgets/common_widgets.dart';
import 'payment_screen.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
 // final isArabic = ref.watch(languageProvider) == 'ar';
    final selectedService = ref.watch(selectedServiceProvider);
    final selectedBarber = ref.watch(selectedBarberProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedSlot = ref.watch(selectedTimeSlotProvider);

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
          'Book Appointment',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          // Step Indicator
          _buildStepIndicator(),

          const SizedBox(height: 24),

          Expanded(
            child: IndexedStack(
  index: _currentStep,
  children: [
    _buildStep1SelectService(),
    _buildStep3SelectBarber(),
    _buildStep2SelectDateTime(selectedDate),
  ],
)
          ),

          // Bottom Bar
          _buildBottomBar(
            context,
            selectedService,
            selectedBarber,
            selectedSlot,
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
  final steps = [
  'Service',
  'Barber',
  'Date & Time',
];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: steps.asMap().entries.map((entry) {
          final i = entry.key;
          final step = entry.value;
          final isActive = i == _currentStep;
          final isDone = i < _currentStep;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (i <= _currentStep) {
                            setState(() => _currentStep = i);
                          }
                        },
                        child: AnimatedContainer(
                          duration: 250.ms,
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            gradient: isActive || isDone
                                ? AppColors.goldGradient
                                : null,
                            color: isActive || isDone
                                ? null
                                : AppColors.surfaceElevated,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isActive
                                  ? AppColors.gold
                                  : isDone
                                      ? AppColors.gold
                                      : AppColors.surfaceHighest,
                            ),
                          ),
                          child: Center(
                            child: isDone
                                ? const Icon(Icons.check_rounded,
                                    color: AppColors.background, size: 18)
                                : Text(
                                    '${i + 1}',
                                    style: GoogleFonts.raleway(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: isActive
                                          ? AppColors.background
                                          : AppColors.textMuted,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        step,
                        style: GoogleFonts.raleway(
                          fontSize: 11,
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                          color: isActive ? AppColors.gold : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < steps.length - 1)
                  Container(
                    width: 40,
                    height: 1.5,
                    color: i < _currentStep
                        ? AppColors.gold
                        : AppColors.surfaceHighest,
                    margin: const EdgeInsets.only(bottom: 22),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStep1SelectService() {
    final services = ref.watch(servicesProvider);
    final selected = ref.watch(selectedServiceProvider);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const BouncingScrollPhysics(),
      itemCount: services.length,
      itemBuilder: (context, i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: ServiceCard(
            service: services[i],
            isSelected: selected?.id == services[i].id,
            // isArabic: isArabic,
            onTap: () {
              ref.read(selectedServiceProvider.notifier).state = services[i];
            },
          ),
        ).animate(delay: (i * 60).ms).fadeIn().slideY(begin: 0.1);
      },
    );
  }

  Widget _buildStep2SelectDateTime( DateTime selectedDate) {
    final slots = ref.watch(timeSlotsProvider);
final selectedBarber = ref.watch(selectedBarberProvider);
final selectedSlot = ref.watch(selectedTimeSlotProvider);

final bookedSlots = selectedBarber == null
    ? const AsyncValue<List<String>>.data([])
    : ref.watch(
        bookedSlotsProvider(
          (
            barberId: selectedBarber.id,
            date: selectedDate,
          ),
        ),
      );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Calendar
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.surfaceHighest),
            ),
            child: TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 60)),
              focusedDay: selectedDate,
              selectedDayPredicate: (day) => isSameDay(day, selectedDate),
            onDaySelected: (selected, focused) {
  ref.read(selectedDateProvider.notifier).state = selected;
},
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                selectedDecoration: const BoxDecoration(
                  gradient: AppColors.goldGradient,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: GoogleFonts.raleway(
                  color: AppColors.background,
                  fontWeight: FontWeight.w700,
                ),
                todayDecoration: BoxDecoration(
                  color: AppColors.goldGlow,
                  shape: BoxShape.circle,
                ),
                todayTextStyle: GoogleFonts.raleway(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w700,
                ),
                defaultTextStyle: GoogleFonts.raleway(
                  color: AppColors.textPrimary,
                ),
                weekendTextStyle: GoogleFonts.raleway(
                  color: AppColors.textSecondary,
                ),
                disabledTextStyle: GoogleFonts.raleway(
                  color: AppColors.textMuted,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: GoogleFonts.cormorantGaramond(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                leftChevronIcon: const Icon(Icons.chevron_left_rounded,
                    color: AppColors.textPrimary),
                rightChevronIcon: const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textPrimary),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: GoogleFonts.raleway(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
                weekendStyle: GoogleFonts.raleway(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Select Time',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.5,
            ),
            itemCount: slots.length,
            itemBuilder: (context, i) {
              final slot = slots[i];
              final booked = bookedSlots.when(
  data: (list) => list.contains(slot.time),
  loading: () => false,
  error: (_, __) => false,
);  
              final isSelected = selectedSlot?.time == slot.time;

              return GestureDetector(
               onTap: slot.isAvailable && !booked
                    ? () {
                        ref.read(selectedTimeSlotProvider.notifier).state =
                            slot;
                      }
                    : null,
                child: AnimatedContainer(
                  duration: 200.ms,
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColors.goldGradient : null,
                    color: isSelected
                        ? null
                        : slot.isAvailable && !booked
                            ? AppColors.surfaceElevated
                            : AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                  border: Border.all(
  color: isSelected
      ? AppColors.gold
      : (slot.isAvailable && !booked)
          ? AppColors.surfaceHighest
          : AppColors.surfaceHighest.withOpacity(0.3),
),
                  ),
                  child: Center(
                    child: Text(
                      slot.time,
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                        color: isSelected
    ? AppColors.background
    : booked
        ? AppColors.textMuted
        : AppColors.textPrimary,
                       decoration: booked
    ? TextDecoration.lineThrough
    : null,
                      ),
                    ),
                  ),
                ),
              ).animate(delay: (i * 40).ms).fadeIn().scale(begin: const Offset(0.9, 0.9));
            },
          ),

          const SizedBox(height: 16),

          // Legend
          Row(
            children: [
              _legendItem(AppColors.surfaceElevated, AppColors.surfaceHighest,
                  'Available'),
              const SizedBox(width: 16),
              _legendItem(AppColors.gold.withOpacity(0.1), AppColors.gold,
                'Selected'),
              const SizedBox(width: 16),
              _legendItem(AppColors.surface,
                  AppColors.surfaceHighest.withOpacity(0.3),
                'Booked'),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _legendItem(Color fill, Color border, String label) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: border),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.raleway(
            fontSize: 12,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildStep3SelectBarber() {
    final barbers = ref.watch(barbersProvider);
    final selectedBarber = ref.watch(selectedBarberProvider);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const BouncingScrollPhysics(),
      itemCount: barbers.length,
      itemBuilder: (context, i) {
        final barber = barbers[i];
        final isSelected = selectedBarber?.id == barber.id;

        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: GestureDetector(
            onTap: barber.isAvailable
                ? () {
                    ref.read(selectedBarberProvider.notifier).state = barber;
                  }
                : null,
            child: AnimatedContainer(
              duration: 250.ms,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.gold : AppColors.surfaceHighest,
                  width: isSelected ? 1.5 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.gold.withOpacity(0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [],
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.gold
                                : AppColors.surfaceHighest,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            barber.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.surfaceHighest,
                              child: const Icon(Icons.person,
                                  color: AppColors.textMuted, size: 32),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: barber.isAvailable
                                ? AppColors.success
                                : AppColors.error,
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: AppColors.surface, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                barber.name,
                                style: GoogleFonts.raleway(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: barber.isAvailable
                                      ? AppColors.textPrimary
                                      : AppColors.textMuted,
                                ),
                              ),
                            ),
                            if (!barber.isAvailable)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.error.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Unavailable',
                                  style: GoogleFonts.raleway(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          barber.specialty,
                          style: GoogleFonts.raleway(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: AppColors.gold, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '${barber.rating}',
                              style: GoogleFonts.raleway(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              ' (${barber.reviewCount})',
                              style: GoogleFonts.raleway(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: AppColors.textMuted,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${barber.experienceYears} ${'yrs'}',
                              style: GoogleFonts.raleway(
                                fontSize: 12,
                                color: AppColors.textGold,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        gradient: AppColors.goldGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_rounded,
                          color: AppColors.background, size: 16),
                    ),
                ],
              ),
            ),
          ),
        ).animate(delay: (i * 80).ms).fadeIn().slideX(begin: 0.1);
      },
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    ServiceModel? service,
    BarberModel? barber,
    TimeSlot? slot,
  ) {
    final canProceed = _canProceed(service, barber, slot);

    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.surfaceHighest)),
      ),
      child: Row(
      //  textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        children: [
          if (service != null)
            Expanded(
              child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '£${service.price.toStringAsFixed(0)} · ${service.durationMinutes} min',
                    style: GoogleFonts.raleway(
                      fontSize: 12,
                      color: AppColors.textGold,
                    ),
                  ),
                ],
              ),
            )
          else
            const Expanded(child: SizedBox()),

          const SizedBox(width: 16),

          GoldButton(
            label: _currentStep < 2
                ? ('Next')
                : ('Confirm'),
            width: _currentStep < 2 ? 120 : 160,
            onTap: canProceed
                ? () {
                    if (_currentStep < 2) {
                      setState(() => _currentStep++);
                    } else {
                      _confirmBooking(context,  service, barber, slot);
                    }
                  }
                : () {},
          ),
        ],
      ),
    );
  }

  bool _canProceed(ServiceModel? service, BarberModel? barber, TimeSlot? slot) {
    switch (_currentStep) {
  case 0:
    return service != null;

  case 1:
    return barber != null;

  case 2:
    return slot != null;

  default:
    return false;
}
  }

 Future<void> _confirmBooking(
  BuildContext context,
  ServiceModel? service,
  BarberModel? barber,
  TimeSlot? slot,
) async {
  if (service == null || barber == null || slot == null) return;

  try {
    await ref.read(bookingServiceProvider).createBooking(
      barberId: barber.id,
      serviceId: service.id,
      date: ref.read(selectedDateProvider),
      timeSlot: slot.time,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Booking Confirmed"),
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          service: service,
          barber: barber,
          timeSlot: slot,
          selectedDate: ref.read(selectedDateProvider),
        ),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
      ),
    );
  }
}
}
