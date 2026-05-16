// lib/utils/constants.dart

class AppConstants {
  // ── Business Info ────────────────────────────────────────────────────────
  static const String shopName = 'Noir Barber';
  static const String shopNameAr = 'نوار باربر';
  static const String shopPhone = '+44 20 7946 0958';
  static const String shopWhatsApp = '+442079460958';
  static const String shopEmail = 'hello@noirbarber.co.uk';
  static const String shopInstagram = 'noirbarber';
  static const String shopAddress = '42 Mayfair Street, London W1K 4HX';
  static const String shopAddressAr = '42 شارع ماي فير، لندن W1K 4HX';
  static const double shopLat = 51.5120;
  static const double shopLng = -0.1489;

  // ── Loyalty ──────────────────────────────────────────────────────────────
  static const int bronzeMax = 199;
  static const int silverMax = 499;
  // Gold = 500+

  // ── Booking ──────────────────────────────────────────────────────────────
  static const int cancellationWindowHours = 24; // hours before appointment
  static const int reminderLeadMinutes = 60; // send reminder 60 min before

  // ── Pagination ───────────────────────────────────────────────────────────
  static const int pageSize = 20;

  // ── Storage Keys ─────────────────────────────────────────────────────────
  static const String keyOnboardingDone = 'onboarding_done';
  static const String keyLanguage = 'language';
  static const String keyTheme = 'theme';
  static const String keyUserId = 'user_id';
  static const String keyFcmToken = 'fcm_token';

  // ── Animation Durations ───────────────────────────────────────────────────
  static const Duration shortAnim = Duration(milliseconds: 200);
  static const Duration medAnim = Duration(milliseconds: 350);
  static const Duration longAnim = Duration(milliseconds: 600);

  // ── Time Slots ────────────────────────────────────────────────────────────
  static const List<String> defaultSlots = [
    '09:00 AM', '10:00 AM', '11:00 AM', '12:00 PM',
    '01:00 PM', '02:00 PM', '03:00 PM', '04:00 PM',
    '05:00 PM', '06:00 PM',
  ];

  // ── Service Categories ────────────────────────────────────────────────────
  static const List<String> serviceCategories = [
    'All', 'Hair', 'Beard', 'Shave', 'Facial', 'Color',
  ];

  // ── Currencies ────────────────────────────────────────────────────────────
  static const Map<String, String> currencies = {
    'UK': '£',
    'SA': 'SAR',
    'AE': 'AED',
  };

  // ── Social Links ──────────────────────────────────────────────────────────
  static const String instagramUrl = 'https://instagram.com/noirbarber';
  static const String whatsappUrl = 'https://wa.me/442079460958';
  static const String googleMapsUrl =
      'https://maps.google.com/?q=Mayfair,London';
}

class AppStrings {
  // English
  static const Map<String, String> en = {
    'app_name': 'Noir Barber',
    'book_now': 'Book Now',
    'see_all': 'See All',
    'home': 'Home',
    'services': 'Services',
    'book': 'Book',
    'location': 'Location',
    'profile': 'Profile',
    'sign_in': 'Sign In',
    'sign_up': 'Sign Up',
    'email': 'Email Address',
    'password': 'Password',
    'forgot_password': 'Forgot password?',
    'continue_guest': 'Continue as Guest',
    'select_service': 'Select Service',
    'select_date_time': 'Date & Time',
    'select_barber': 'Barber',
    'next': 'Next',
    'confirm': 'Confirm Booking',
    'pay': 'Pay',
    'payment_success': 'Booking Confirmed! 🎉',
    'back_home': 'Back to Home',
    'our_barbers': 'Our Barbers',
    'our_reviews': 'What Clients Say',
    'location_contact': 'Location & Contact',
    'notifications': 'Notifications',
    'loyalty': 'Loyalty Rewards',
    'admin': 'Admin Panel',
    'search': 'Search',
  };

  // Arabic
  static const Map<String, String> ar = {
    'app_name': 'نوار باربر',
    'book_now': 'احجز الآن',
    'see_all': 'عرض الكل',
    'home': 'الرئيسية',
    'services': 'الخدمات',
    'book': 'حجز',
    'location': 'الموقع',
    'profile': 'حسابي',
    'sign_in': 'تسجيل الدخول',
    'sign_up': 'إنشاء حساب',
    'email': 'البريد الإلكتروني',
    'password': 'كلمة المرور',
    'forgot_password': 'نسيت كلمة المرور؟',
    'continue_guest': 'متابعة كضيف',
    'select_service': 'اختر الخدمة',
    'select_date_time': 'التاريخ والوقت',
    'select_barber': 'الحلاق',
    'next': 'التالي',
    'confirm': 'تأكيد الحجز',
    'pay': 'ادفع',
    'payment_success': 'تم الحجز بنجاح! 🎉',
    'back_home': 'العودة إلى الرئيسية',
    'our_barbers': 'حلاقونا',
    'our_reviews': 'ما يقوله العملاء',
    'location_contact': 'الموقع والتواصل',
    'notifications': 'الإشعارات',
    'loyalty': 'نقاط الولاء',
    'admin': 'لوحة التحكم',
    'search': 'بحث',
  };

  static String get(String key, String lang) {
    return (lang == 'ar' ? ar[key] : en[key]) ?? key;
  }
}
