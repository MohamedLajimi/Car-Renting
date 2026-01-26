import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum FuelType {
  petrol,
  diesel,
  electric,
  hybrid;

  static FuelType fromMap(String? name) {
    if (name == null) return FuelType.petrol;

    final cleanName = name.trim().toLowerCase();

    return FuelType.values.firstWhere(
      (e) => e.name == cleanName,
      orElse: () => FuelType.petrol,
    );
  }

  String get displayName => 'fuel_type.$name'.tr();

  IconData get icon => switch (this) {
    FuelType.petrol => Icons.local_gas_station,
    FuelType.diesel => Icons.ev_station,
    FuelType.electric => Icons.electric_bolt,
    FuelType.hybrid => Icons.electric_car,
  };
}
