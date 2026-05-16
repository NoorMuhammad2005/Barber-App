# ✂️ Noir Barber — Flutter Demo App

> A premium, business-ready barber shop mobile app demo built with Flutter + Supabase.
> Designed to impress international clients (UK, Saudi Arabia, UAE).

---

## 📱 Screenshots Overview

| Screen | Description |
|--------|-------------|
| **Auth** | Animated logo, sign in / sign up, Apple & Google SSO |
| **Home** | Hero banner carousel, quick actions, featured services, barber cards, stats, reviews |
| **Services** | Category filter chips, full service cards with price & duration |
| **Booking** | 3-step flow: Service → Date & Time (calendar + time slots) → Barber |
| **Payment** | Stripe-like UI, card preview, Apple Pay / PayPal toggles, success + confetti |
| **Barbers** | Full profile cards, rating, experience, availability badge |
| **Reviews** | Star breakdown chart, review cards with avatars |
| **Location** | Custom map painter, directions + WhatsApp + call + email + Instagram |
| **Profile** | Header stats, edit info, preferences, language toggle, booking history |
| **Admin** | Dashboard KPIs, revenue bar chart, today's bookings, service CRUD |

---

## 🚀 Getting Started

### 1. Prerequisites

```bash
flutter --version   # >= 3.0.0
dart --version      # >= 3.0.0
```

### 2. Clone & Install

```bash
git clone <your-repo-url>
cd barbershop_app
flutter pub get
```

### 3. Supabase Setup

1. Create a project at [supabase.com](https://supabase.com)
2. Run `supabase/schema.sql` in your SQL Editor
3. Enable Storage bucket called `avatars` (public)
4. Copy your **Project URL** and **anon key**

### 4. Environment Variables

```bash
# Run with env vars
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

Or create a `.env` and use `flutter_dotenv` — update `main.dart` accordingly.

### 5. Run

```bash
flutter run                 # debug
flutter run --release       # release
flutter build apk           # Android APK
flutter build ios           # iOS (requires Xcode)
```

---

## 🗂️ Folder Structure

```
barbershop_app/
├── lib/
│   ├── main.dart                     # App entry point + Supabase init
│   ├── models/
│   │   └── models.dart               # ServiceModel, BarberModel, BookingModel, etc.
│   ├── providers/
│   │   └── app_provider.dart         # Riverpod providers + demo seed data
│   ├── screens/
│   │   ├── auth_screen.dart          # Sign in / sign up
│   │   ├── main_shell.dart           # Bottom nav shell
│   │   ├── home_screen.dart          # Home with banner, quick actions
│   │   ├── services_screen.dart      # Service list + category filter
│   │   ├── booking_screen.dart       # 3-step booking flow
│   │   ├── payment_screen.dart       # Stripe-like payment + confirmation
│   │   ├── barbers_screen.dart       # Barber profile cards
│   │   ├── reviews_screen.dart       # Reviews + rating breakdown
│   │   ├── location_screen.dart      # Map, contact buttons
│   │   ├── profile_screen.dart       # User profile + booking history
│   │   └── admin_screen.dart         # Admin panel (dashboard, bookings, services)
│   ├── services/
│   │   └── supabase_service.dart     # All Supabase API calls
│   ├── utils/
│   │   └── app_theme.dart            # AppColors, AppTheme (dark + gold)
│   └── widgets/
│       └── common_widgets.dart       # GoldButton, ServiceCard, BarberCard, etc.
├── supabase/
│   └── schema.sql                    # Full PostgreSQL schema + RLS + seed data
├── assets/
│   ├── images/
│   └── icons/
└── pubspec.yaml
```

---

## 🎨 Design System

| Token | Value |
|-------|-------|
| Background | `#0A0A0A` |
| Surface | `#141414` |
| Surface Elevated | `#1E1E1E` |
| Gold | `#D4AF37` |
| Gold Light | `#E8C84A` |
| Gold Dark | `#AA8C2C` |
| Text Primary | `#F5F5F5` |
| Text Secondary | `#B0B0B0` |
| Success | `#2ECC71` |
| Error | `#E74C3C` |

**Fonts:** Cormorant Garamond (display) + Raleway (body)

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| UI | Flutter 3.x |
| State | Riverpod 2.x |
| Backend | Supabase (Auth, PostgreSQL, Realtime, Storage) |
| Animations | flutter_animate |
| Charts | fl_chart |
| Calendar | table_calendar |
| Confetti | confetti |
| Ratings | flutter_rating_bar |
| Deep links | url_launcher |
| Fonts | google_fonts |

---

## 🌍 Multi-language

Toggle between **English** and **Arabic** from the Profile screen or the language toggle. All strings, text directions, and layouts respond to RTL automatically via `Directionality` widgets.

---

## 💳 Payment (Demo)

The payment screen simulates a Stripe-like UI:
- Card number preview with animated card visual
- Apple Pay / PayPal alternative methods
- 2-second processing simulation
- Confetti explosion on success
- Booking confirmation card with QR-ready ID

To integrate real payments, connect [Stripe](https://pub.dev/packages/flutter_stripe) or use Supabase Edge Functions as a payment backend.

---

## 🔐 Supabase RLS Summary

| Table | Policy |
|-------|--------|
| `users` | Self read/write only |
| `bookings` | User sees own; admins see all |
| `reviews` | Public read; user writes own |
| `services` | Public read |
| `barbers` | Public read |
| `notifications` | User sees own |

---

## 📦 Building for Production

```bash
# Android
flutter build apk --release --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
flutter build appbundle --release ...

# iOS
flutter build ios --release ...
# then open Xcode and archive
```

---

## 🤝 Selling This App

This demo is designed to showcase to barbershop owners. Key selling points:

- ✅ Live booking with real-time updates
- ✅ Multi-language (English + Arabic)
- ✅ Admin panel to manage services and view bookings
- ✅ Payment-ready UI
- ✅ Premium dark + gold design
- ✅ Works on iOS and Android
- ✅ Supabase backend (scalable, free tier available)

---

*Built with ♥ using Flutter & Supabase*
