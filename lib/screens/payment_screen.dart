// lib/screens/payment_screen.dart
import 'package:barbershop_app/providers/booking_provider.dart';
import 'package:barbershop_app/screens/main_shell.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../utils/app_theme.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';
import '../widgets/common_widgets.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final ServiceModel service;
  final BarberModel barber;
  final TimeSlot timeSlot;
  final DateTime selectedDate;

  const PaymentScreen({
    super.key,
    required this.service,
    required this.barber,
    required this.timeSlot,
    required this.selectedDate,
  });

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  bool _isProcessing = false;
  bool _isSuccess = false;
  int _selectedPayment = 0;
  final _cardController = TextEditingController(text: '4242 4242 4242 4242');
  final _expiryController = TextEditingController(text: '12/28');
  final _cvvController = TextEditingController(text: '•••');
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 4));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));

     await ref.read(bookingServiceProvider).createBooking(
    barberId: widget.barber.id,
    serviceId: widget.service.id,
    date: widget.selectedDate,
    timeSlot: widget.timeSlot.time,
  );
  
    setState(() {
      _isProcessing = false;
      _isSuccess = true;
    });
    _confettiController.play();

    // Add to booking history
    final booking = BookingModel(
      id: 'bk_${DateTime.now().millisecondsSinceEpoch}',
      serviceId: widget.service.id,
      serviceName: widget.service.name,
      barberId: widget.barber.id,
      barberName: widget.barber.name,
      date: widget.selectedDate,
      timeSlot: widget.timeSlot.time,
      price: widget.service.price,
      status: BookingStatus.confirmed,
    );

    ref.read(bookingHistoryProvider.notifier).update((state) => [...state, booking]);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = ref.watch(languageProvider) == 'ar';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _isSuccess
          ? null
          : AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textPrimary, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                isArabic ? 'الدفع' : 'Secure Payment',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
      body: Stack(
        children: [
          _isSuccess
              ? _buildSuccessScreen(context, isArabic)
              : _buildPaymentForm(context, isArabic),

          // Confetti
          if (_isSuccess)
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                colors: const [
                  AppColors.gold,
                  AppColors.goldLight,
                  Colors.white,
                  AppColors.goldDark,
                ],
                numberOfParticles: 30,
                gravity: 0.3,
                emissionFrequency: 0.1,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentForm(BuildContext context, bool isArabic) {
    final total = widget.service.price;
    final paymentMethods = [
      {'icon': '💳', 'label': 'Credit Card'},
      {'icon': '📱', 'label': 'Apple Pay'},
      {'icon': '🔵', 'label': 'PayPal'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Booking Summary Card
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A1500), Color(0xFF1E1E1E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: AppColors.goldDark.withValues(alpha: 0.4)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.goldGlow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(widget.service.icon,
                            style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic
                                ? widget.service.nameAr
                                : widget.service.name,
                            style: GoogleFonts.raleway(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${widget.service.durationMinutes} min with ${isArabic ? widget.barber.nameAr : widget.barber.name}',
                            style: GoogleFonts.raleway(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.surfaceHighest),
                const SizedBox(height: 16),
                _summaryRow(
                  isArabic ? 'التاريخ' : 'Date',
                  DateFormat('EEE, MMM d').format(widget.selectedDate),
                ),
                const SizedBox(height: 8),
                _summaryRow(
                  isArabic ? 'الوقت' : 'Time',
                  widget.timeSlot.time,
                ),
                const SizedBox(height: 8),
                _summaryRow(
                  isArabic ? 'الحلاق' : 'Barber',
                  isArabic ? widget.barber.nameAr : widget.barber.name,
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.surfaceHighest),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isArabic ? 'الإجمالي' : 'Total',
                      style: GoogleFonts.raleway(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '£${total.toStringAsFixed(2)}',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),

          const SizedBox(height: 28),

          // Payment Method
          Text(
            isArabic ? 'طريقة الدفع' : 'Payment Method',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),

          Row(
            children: paymentMethods.asMap().entries.map((entry) {
              final i = entry.key;
              final method = entry.value;
              final isActive = i == _selectedPayment;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 2 ? 10 : 0),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedPayment = i),
                    child: AnimatedContainer(
                      duration: 200.ms,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.goldGlow
                            : AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isActive
                              ? AppColors.gold
                              : AppColors.surfaceHighest,
                          width: isActive ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(method['icon']!,
                              style: const TextStyle(fontSize: 20)),
                          const SizedBox(height: 4),
                          Text(
                            method['label']!,
                            style: GoogleFonts.raleway(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isActive
                                  ? AppColors.gold
                                  : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          if (_selectedPayment == 0) ...[
            const SizedBox(height: 24),
            // Card Preview
            Container(
              height: 160,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'NOIR BARBER',
                        style: GoogleFonts.raleway(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.gold,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        'VISA',
                        style: GoogleFonts.raleway(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '4242  4242  4242  4242',
                    style: GoogleFonts.raleway(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CARD HOLDER',
                            style: GoogleFonts.raleway(
                              fontSize: 9,
                              color: Colors.white54,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            'JOHN SMITH',
                            style: GoogleFonts.raleway(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EXPIRES',
                            style: GoogleFonts.raleway(
                              fontSize: 9,
                              color: Colors.white54,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            '12/28',
                            style: GoogleFonts.raleway(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.95, 0.95)),

            const SizedBox(height: 20),

            // Card Fields
            TextField(
              controller: _cardController,
              style: GoogleFonts.raleway(color: AppColors.textPrimary),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Card Number',
                prefixIcon: const Icon(Icons.credit_card,
                    color: AppColors.textMuted, size: 20),
                suffixIcon: const Icon(Icons.lock_rounded,
                    color: AppColors.gold, size: 18),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _expiryController,
                    style: GoogleFonts.raleway(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Expiry',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _cvvController,
                    style: GoogleFonts.raleway(color: AppColors.textPrimary),
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                    ),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 28),

          // SSL Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_rounded,
                  color: AppColors.success, size: 14),
              const SizedBox(width: 6),
              Text(
               '256-bit SSL Encrypted Secure Payment',
                style: GoogleFonts.raleway(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          GoldButton(
            label: _isProcessing
                ? ('Processing...')
                : ('Pay £${total.toStringAsFixed(2)}'),
            isLoading: _isProcessing,
            icon: _isProcessing ? null : Icons.lock_rounded,
            onTap: _processPayment,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.raleway(
            fontSize: 13,
            color: AppColors.textMuted,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.raleway(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessScreen(BuildContext context, bool isArabic) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success animation
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.goldGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.4),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.background,
                  size: 60,
                ),
              ).animate().scale(
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  ),
        
              const SizedBox(height: 32),
        
              Text(
                'Booking Confirmed! 🎉',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.2),
        
              const SizedBox(height: 12),
        
              Text(
                'Your appointment is confirmed. We\'ll send a reminder 1 hour before.',
                style: GoogleFonts.raleway(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ).animate(delay: 400.ms).fadeIn(),
        
              const SizedBox(height: 32),
        
              // Booking Details Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.surfaceHighest),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _confirmRow('📋', 'Service',
                        isArabic ? widget.service.nameAr : widget.service.name),
                    const Divider(color: AppColors.surfaceHighest, height: 20),
                    _confirmRow('👨‍🦱', 'Barber',
                        isArabic ? widget.barber.nameAr : widget.barber.name),
                    const Divider(color: AppColors.surfaceHighest, height: 20),
                    _confirmRow('📅','Date',
                        DateFormat('EEE, MMM d').format(widget.selectedDate)),
                    const Divider(color: AppColors.surfaceHighest, height: 20),
                    _confirmRow('🕐', 'Time',
                        widget.timeSlot.time),
                    const Divider(color: AppColors.surfaceHighest, height: 20),
                    _confirmRow(
                        '💷',
                        'Paid',
                        '£${widget.service.price.toStringAsFixed(2)}',
                        isGold: true),
                  ],
                ),
              ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.2),
        
             const SizedBox(height: 16),
        
              GoldButton(
                label:'Back to Home',
                icon: Icons.home_rounded,
                onTap: () {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) => const MainShell(),
    ),
    (route) => false,
  );
},
              ).animate(delay: 700.ms).fadeIn(),
        
              const SizedBox(height: 12),
        
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share_rounded, size: 18),
                label: Text('Share Confirmation'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.surfaceHighest),
                ),
              ).animate(delay: 800.ms).fadeIn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _confirmRow(String emoji, String label, String value,
      {bool isGold = false}) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.raleway(
            fontSize: 13,
            color: AppColors.textMuted,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.raleway(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isGold ? AppColors.gold : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
