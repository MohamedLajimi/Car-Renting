import 'package:car_renting/core/enums/car_document_enum.dart';
import 'package:equatable/equatable.dart';

class CarDocument extends Equatable {
  final CarDocumentType type;
  final List<String> urls;
  final DateTime? expiryDate;

  const CarDocument({required this.type, required this.urls, this.expiryDate});

  CarDocument copyWith({
    CarDocumentType? type,
    List<String>? urls,
    DateTime? expiryDate,
  }) => CarDocument(
    type: type ?? this.type,
    urls: urls ?? this.urls,
    expiryDate: expiryDate ?? this.expiryDate,
  );

  Map<String, dynamic> toMap() => {
    'type': type.name,
    'urls': urls,
    'expiryDate': expiryDate?.toIso8601String(),
  };

  factory CarDocument.fromMap(Map<String, dynamic> map) => CarDocument(
    type: CarDocumentType.fromMap(map['type']),
    urls: List<String>.from(map['urls'] ?? []),
    expiryDate: map['expiryDate'] != null
        ? DateTime.parse(map['expiryDate'])
        : null,
  );

  @override
  List<Object?> get props => [type, urls, expiryDate];
}
