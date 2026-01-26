import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum CarStatus {
  pending,
  verified,
  rejected,
  hidden,
  suspended;

  static CarStatus fromMap(String? name) {
    if (name == null) return CarStatus.pending;

    final cleanName = name.trim().toLowerCase();

    return CarStatus.values.firstWhere(
      (e) => e.name == cleanName,
      orElse: () => CarStatus.pending,
    );
  }

  String get displayName => 'car_status.$name'.tr();

  IconData get icon {
    return switch (this) {
      CarStatus.pending => CupertinoIcons.time,
      CarStatus.verified => CupertinoIcons.checkmark_seal_fill,
      CarStatus.rejected => CupertinoIcons.xmark_circle_fill,
      CarStatus.hidden => CupertinoIcons.eye_slash,
      CarStatus.suspended => CupertinoIcons.slash_circle,
    };
  }

  Color get color {
    return switch (this) {
      CarStatus.pending => Colors.orange,
      CarStatus.verified => Colors.green,
      CarStatus.rejected => Colors.red,
      CarStatus.hidden => Colors.grey,
      CarStatus.suspended => Colors.black,
    };
  }
}
