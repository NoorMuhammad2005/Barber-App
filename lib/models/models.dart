// lib/models/models.dart

class ServiceModel {
  final String id;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final double price;
  final int durationMinutes;
  final String icon;
  final String category;
  final bool isPopular;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.price,
    required this.durationMinutes,
    required this.icon,
    required this.category,
    this.isPopular = false,
  });
}

class BarberModel {
  final String id;
  final String name;
  final String nameAr;
  final String specialty;
  final String specialtyAr;
  final double rating;
  final int reviewCount;
  final int experienceYears;
  final String imageUrl;
  final List<String> services;
  final bool isAvailable;
  final String bio;

  const BarberModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.specialty,
    required this.specialtyAr,
    required this.rating,
    required this.reviewCount,
    required this.experienceYears,
    required this.imageUrl,
    required this.services,
    this.isAvailable = true,
    required this.bio,
  });
}

class ReviewModel {
  final String id;
  final String userName;
  final String userAvatar;
  final double rating;
  final String comment;
  final String commentAr;
  final DateTime date;
  final String? serviceUsed;

  const ReviewModel({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.commentAr,
    required this.date,
    this.serviceUsed,
  });
}

class TimeSlot {
  final String time;
  final bool isAvailable;
  final bool isSelected;

  const TimeSlot({
    required this.time,
    this.isAvailable = true,
    this.isSelected = false,
  });

  TimeSlot copyWith({bool? isAvailable, bool? isSelected}) {
    return TimeSlot(
      time: time,
      isAvailable: isAvailable ?? this.isAvailable,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class BookingModel {
  final String id;
  final String serviceId;
  final String serviceName;
  final String barberId;
  final String barberName;
  final DateTime date;
  final String timeSlot;
  final double price;
  final BookingStatus status;
  final String? notes;

  const BookingModel({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.barberId,
    required this.barberName,
    required this.date,
    required this.timeSlot,
    required this.price,
    required this.status,
    this.notes,
  });
}

enum BookingStatus { pending, confirmed, completed, cancelled }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;
  final List<BookingModel> bookingHistory;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
    this.bookingHistory = const [],
  });
}
