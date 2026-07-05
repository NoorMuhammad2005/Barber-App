import 'package:barbershop_app/services/auth_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider((ref) => AuthService());