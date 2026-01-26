import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

enum CarDocumentType {
  registration,
  insurance,
  technicalInspection,
  identityCard,
  drivingLicense;

  static CarDocumentType fromMap(String? name) {
    if (name == null) return CarDocumentType.registration;

    final cleanName = name.trim().toLowerCase();

    return CarDocumentType.values.firstWhere(
      (e) => e.name == cleanName,
      orElse: () => CarDocumentType.registration,
    );
  }

  String get displayName => 'car_management.docs.$name'.tr();

  String get hint => 'car_management.docs.${name}_hint'.tr();

  IconData get icon {
    return switch (this) {
      CarDocumentType.registration => CupertinoIcons.doc_text,
      CarDocumentType.insurance => CupertinoIcons.shield_fill,
      CarDocumentType.technicalInspection => CupertinoIcons.wrench,
      CarDocumentType.identityCard => CupertinoIcons.person,
      CarDocumentType.drivingLicense => CupertinoIcons.creditcard,
    };
  }
}
