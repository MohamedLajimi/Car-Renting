import 'package:equatable/equatable.dart';

enum UserRole { 
  owner, 
  renter;

  String get displayName => name[0].toUpperCase() + name.substring(1);
}

class UserModel extends Equatable {
  final String id;
  final UserRole role;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? avatarUrl;
  final String? licenceUrl;
  final bool isVerified;
  final double rate;
  final int reviewCount;

  const UserModel({
    required this.id,
    required this.role,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.avatarUrl,
    this.licenceUrl,
    this.isVerified = false,
    this.rate = 0.0,
    this.reviewCount = 0,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      id: documentId,
      role: UserRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => UserRole.renter,
      ),
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      avatarUrl: map['avatarUrl'],
      licenceUrl: map['licenceUrl'],
      isVerified: map['isVerified'] ?? false,
      rate: (map['rate'] ?? 0.0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'role': role.name,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'licenceUrl': licenceUrl,
      'isVerified': isVerified,
      'rate': rate,
      'reviewCount': reviewCount,
    };
  }

  UserModel copyWith({
    UserRole? role,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? avatarUrl,
    String? licenceUrl,
    bool? isVerified,
    double? rate,
    int? reviewCount,
  }) {
    return UserModel(
      id: id,
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      licenceUrl: licenceUrl ?? this.licenceUrl,
      isVerified: isVerified ?? this.isVerified,
      rate: rate ?? this.rate,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }

  @override
  List<Object?> get props => [
        id, role, fullName, email, phoneNumber, 
        avatarUrl, licenceUrl, isVerified, rate, reviewCount
      ];
}