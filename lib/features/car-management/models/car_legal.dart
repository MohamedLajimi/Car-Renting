import 'package:car_renting/core/enums/car_document_enum.dart';
import 'package:car_renting/core/enums/car_status_enum.dart';
import 'package:car_renting/features/car-management/models/car_document.dart';
import 'package:equatable/equatable.dart';

class CarLegal extends Equatable {
  final List<CarDocument> documents;
  final CarStatus status;
  final String? rejectionReason;
  final DateTime? lastVerifiedAt;

  const CarLegal({
    this.documents = const [],
    this.status = CarStatus.pending,
    this.rejectionReason,
    this.lastVerifiedAt,
  });

  CarLegal copyWith({
    List<CarDocument>? documents,
    CarStatus? status,
    String? rejectionReason,
    DateTime? lastVerifiedAt,
  }) => CarLegal(
    documents: documents ?? this.documents,
    status: status ?? this.status,
    rejectionReason: rejectionReason ?? this.rejectionReason,
    lastVerifiedAt: lastVerifiedAt ?? this.lastVerifiedAt,
  );

  CarDocument? getDoc(CarDocumentType type) =>
      documents.where((d) => d.type == type).firstOrNull;

  Map<String, dynamic> toMap() => {
    'documents': documents.map((d) => d.toMap()).toList(),
    'status': status.name,
    'rejectionReason': rejectionReason,
    'lastVerifiedAt': lastVerifiedAt?.toIso8601String(),
  };

  factory CarLegal.fromMap(Map<String, dynamic> map) => CarLegal(
    documents: (map['documents'] as List? ?? [])
        .map((d) => CarDocument.fromMap(d))
        .toList(),
    status: CarStatus.values.byName(map['status'] ?? 'pending'),
    rejectionReason: map['rejectionReason'],
    lastVerifiedAt: map['lastVerifiedAt'] != null
        ? DateTime.parse(map['lastVerifiedAt'])
        : null,
  );

  @override
  List<Object?> get props => [documents, status, rejectionReason];
}
