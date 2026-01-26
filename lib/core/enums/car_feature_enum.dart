import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum CarFeature {
  ac,
  bluetooth,
  infotainment,
  gps,
  backupCamera,
  sunroof,
  cruiseControl,
  typeC,
  heatedSeats,
  keyless;

  static CarFeature fromMap(String? name) {
    if (name == null) return CarFeature.ac;

    final cleanName = name.trim().toLowerCase();

    return CarFeature.values.firstWhere(
      (e) => e.name == cleanName,
      orElse: () => CarFeature.ac,
    );
  }

  String get displayName => 'car_features.$name'.tr();

  IconData get icon => switch (this) {
    CarFeature.ac => Icons.ac_unit,
    CarFeature.bluetooth => Icons.bluetooth,
    CarFeature.gps => Icons.location_on,
    CarFeature.sunroof => Icons.wb_sunny_outlined,
    CarFeature.backupCamera => Icons.videocam,
    _ => Icons.star_border,
  };
}
