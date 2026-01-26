import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum Transmission {
  manual,
  automatic;

  static Transmission fromMap(String? name) {
    if (name == null) return Transmission.manual;

    final cleanName = name.trim().toLowerCase();

    return Transmission.values.firstWhere(
      (e) => e.name == cleanName,
      orElse: () => Transmission.manual,
    );
  }

  String get displayName => 'transmission.$name'.tr();

  IconData get icon => switch (this) {
    Transmission.automatic => Icons.auto_mode,
    Transmission.manual => Icons.settings_input_component,
  };
}
