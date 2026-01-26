import 'package:car_renting/core/enums/car_feature_enum.dart';
import 'package:car_renting/core/enums/car_status_enum.dart';
import 'package:car_renting/core/enums/currency_enum.dart';
import 'package:car_renting/core/enums/fuel_type_enum.dart';
import 'package:car_renting/core/enums/transmission_enum.dart';
import 'package:car_renting/features/car-management/models/car_document.dart';
import 'package:car_renting/features/car-management/models/car_location.dart';
import 'package:car_renting/features/car-management/models/car_model.dart';
import 'package:equatable/equatable.dart';

class CarParams extends Equatable {
  final String? id;
  final CarStatus status;
  final String brand;
  final String model;
  final int year;
  final FuelType fuelType;
  final Transmission transmission;
  final double pricePerDay;
  final Currency currency;
  final int seats;
  final List<CarFeature> features;
  final CarLocation location;
  final List<String> images;
  final List<CarDocument> documents;
  final List<DateTime> blockedDays;
  final List<DateTime> bookedDays;

  const CarParams({
    this.id,
    this.status = CarStatus.pending,
    required this.brand,
    required this.model,
    required this.year,
    required this.fuelType,
    required this.transmission,
    required this.pricePerDay,
    required this.currency,
    required this.seats,
    required this.features,
    required this.location,
    required this.images,
    required this.documents,
    this.blockedDays = const [],
    this.bookedDays = const [],
  });

  CarParams copyWith({
    String? id,
    CarStatus? status,
    String? brand,
    String? model,
    int? year,
    FuelType? fuelType,
    Transmission? transmission,
    double? pricePerDay,
    Currency? currency,
    int? seats,
    List<CarFeature>? features,
    CarLocation? location,
    List<String>? images,
    List<CarDocument>? documents,
    List<DateTime>? blockedDays,
  }) {
    return CarParams(
      id: id ?? this.id,
      status: status ?? this.status,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      fuelType: fuelType ?? this.fuelType,
      transmission: transmission ?? this.transmission,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      currency: currency ?? this.currency,
      seats: seats ?? this.seats,
      features: features ?? this.features,
      location: location ?? this.location,
      images: images ?? this.images,
      documents: documents ?? this.documents,
      blockedDays: blockedDays ?? this.blockedDays,
      bookedDays: bookedDays,
    );
  }

  factory CarParams.empty() {
    return const CarParams(
      brand: '',
      model: '',
      year: 2020,
      fuelType: FuelType.petrol,
      transmission: Transmission.manual,
      pricePerDay: 0.0,
      currency: Currency.tnd,
      seats: 4,
      features: [],
      location: CarLocation(address: '', city: '', lat: 0.0, lng: 0.0),
      images: [],
      documents: [],
      status: CarStatus.pending,
      blockedDays: [],
    );
  }

  CarModel toModel(String ownerId, {double rate = 0.0}) {
    return CarModel(
      id: id ?? '',
      ownerId: ownerId,
      brand: brand,
      model: model,
      year: year,
      fuelType: fuelType,
      transmission: transmission,
      pricePerDay: pricePerDay,
      currency: currency,
      images: images,
      seats: seats,
      features: features,
      location: location,
      blockedDays: blockedDays,
      bookedDays: bookedDays,
      status: status,
      rate: rate,
      documents: documents,
    );
  }

  Map<String, dynamic> toMap(String ownerId) {
    return {
      'ownerId': ownerId,
      'brand': brand,
      'model': model,
      'year': year,
      'fuelType': fuelType.name,
      'transmission': transmission.name,
      'pricePerDay': pricePerDay,
      'currency': currency.name,
      'seats': seats,
      'features': features.map((e) => e.name).toList(),
      'location': location.toMap(),
      'images': images,
      'documentUrls': documents.map((e) => e.toMap()).toList(),
      'status': status.name,
      'rate': 0.0,
      'blockedDays': blockedDays.map((date) => date.toIso8601String()).toList(),
      'bookedDays': bookedDays.map((date) => date.toIso8601String()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    brand,
    model,
    year,
    fuelType,
    transmission,
    pricePerDay,
    currency,
    seats,
    features,
    location,
    images,
    documents,
    status,
    blockedDays,
  ];
}
