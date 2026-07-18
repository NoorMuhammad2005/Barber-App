// lib/screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../widgets/common_widgets.dart';
import 'booking_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _ctrl = TextEditingController();
  String _query = '';
  String _filter = 'All'; // All | Services | Barbers

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = ref.watch(languageProvider) == 'ar';
    final services = ref.watch(servicesProvider);
    final barbers = ref.watch(barbersProvider);

    final filteredServices = services.where((s) {
      if (_filter == 'Barbers') return false;
      final name = (isArabic ? s.nameAr : s.name).toLowerCase();
      return _query.isEmpty || name.contains(_query.toLowerCase());
    }).toList();

    final filteredBarbers = barbers.where((b) {
      if (_filter == 'Services') return false;
      final name = (isArabic ? b.nameAr : b.name).toLowerCase();
      return _query.isEmpty || name.contains(_query.toLowerCase());
    }).toList();

    final hasResults =
        filteredServices.isNotEmpty || filteredBarbers.isNotEmpty;

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
        title: TextField(
          controller: _ctrl,
          autofocus: true,
          onChanged: (v) => setState(() => _query = v),
          style: GoogleFonts.raleway(
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText:
                isArabic ? 'ابحث عن خدمة أو حلاق...' : 'Search services, barbers...',
            hintStyle: GoogleFonts.raleway(
              color: AppColors.textMuted,
              fontSize: 15,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            contentPadding: EdgeInsets.zero,
            prefixIcon: const Icon(Icons.search_rounded,
                color: AppColors.textMuted, size: 22),
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded,
                        color: AppColors.textMuted, size: 20),
                    onPressed: () {
                      _ctrl.clear();
                      setState(() => _query = '');
                    },
                  )
                : null,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: ['All', 'Services', 'Barbers'].map((f) {
                final isActive = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 7),
                      decoration: BoxDecoration(
                        gradient:
                            isActive ? AppColors.goldGradient : null,
                        color: isActive ? null : AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isActive
                              ? Colors.transparent
                              : AppColors.surfaceHighest,
                        ),
                      ),
                      child: Text(
                        f,
                        style: GoogleFonts.raleway(
                          fontSize: 13,
                          fontWeight: isActive
                              ? FontWeight.w800
                              : FontWeight.w500,
                          color: isActive
                              ? AppColors.background
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const Divider(color: AppColors.surfaceHighest, height: 1),

          Expanded(
            child: _query.isEmpty && _filter == 'All'
                ? _buildRecentSearches(isArabic)
                : !hasResults
                    ? _buildNoResults(isArabic)
                    : ListView(
                        padding: const EdgeInsets.all(16),
                        physics: const BouncingScrollPhysics(),
                        children: [
                          if (filteredServices.isNotEmpty) ...[
                            _sectionLabel(
                                isArabic ? 'الخدمات' : 'Services'),
                            const SizedBox(height: 8),
                            ...filteredServices.asMap().entries.map((e) =>
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: ServiceCard(
                                    service: e.value,
                                    isArabic: isArabic,
                                    isCompact: true,
                                    onTap: () {
                                      ref
                                          .read(selectedServiceProvider
                                              .notifier)
                                          .state = e.value;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const BookingScreen()),
                                      );
                                    },
                                  ),
                                ).animate(delay: (e.key * 60).ms).fadeIn()),
                          ],
                          if (filteredBarbers.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            _sectionLabel(
                                isArabic ? 'الحلاقون' : 'Barbers'),
                            const SizedBox(height: 8),
                            ...filteredBarbers.asMap().entries.map((e) =>
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: BarberCard(
                                    barber: e.value,
                                    isArabic: isArabic,
                                    onTap: () {
                                      ref
                                          .read(selectedBarberProvider
                                              .notifier)
                                          .state = e.value;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const BookingScreen()),
                                      );
                                    },
                                  ),
                                ).animate(delay: (e.key * 60).ms).fadeIn()),
                          ],
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches(bool isArabic) {
    final recents = isArabic
        ? ['قصة شعر', 'تشذيب اللحية', 'جيمس هاريسون', 'خالد الراشد']
        : ['Classic Haircut', 'Beard Trim', 'James Harrison', 'Hot Towel'];

    final popular = isArabic
        ? ['قصة كلاسيكية', 'حلاقة بالمنشفة', 'عناية بالوجه', 'تصفيف الشعر']
        : ['Classic Cut', 'Hot Towel Shave', 'Luxury Facial', 'Hair Styling'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(isArabic ? 'عمليات البحث الأخيرة' : 'Recent Searches'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: recents
                .map(
                  (r) => GestureDetector(
                    onTap: () => setState(() {
                      _query = r;
                      _ctrl.text = r;
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: AppColors.surfaceHighest),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.history_rounded,
                              size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 6),
                          Text(
                            r,
                            style: GoogleFonts.raleway(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          _sectionLabel(isArabic ? 'الأكثر طلبًا' : 'Popular Now'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: popular
                .map(
                  (p) => GestureDetector(
                    onTap: () => setState(() {
                      _query = p;
                      _ctrl.text = p;
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.goldGlow,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.trending_up_rounded,
                              size: 14, color: AppColors.gold),
                          const SizedBox(width: 6),
                          Text(
                            p,
                            style: GoogleFonts.raleway(
                              fontSize: 13,
                              color: AppColors.textGold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults(bool isArabic) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔍', style: TextStyle(fontSize: 52)),
          const SizedBox(height: 16),
          Text(
            isArabic ? 'لا توجد نتائج' : 'No Results Found',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 22,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic
                ? 'جرب كلمة بحث مختلفة'
                : 'Try a different search term.',
            style: GoogleFonts.raleway(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) => Text(
        label,
        style: GoogleFonts.raleway(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
          letterSpacing: 1,
        ),
      );
}
