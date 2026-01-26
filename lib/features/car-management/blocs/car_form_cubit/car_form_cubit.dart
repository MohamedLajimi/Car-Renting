import 'package:car_renting/core/enums/car_document_enum.dart';
import 'package:car_renting/core/enums/car_feature_enum.dart';
import 'package:car_renting/core/enums/car_status_enum.dart';
import 'package:car_renting/core/enums/currency_enum.dart';
import 'package:car_renting/core/enums/fuel_type_enum.dart';
import 'package:car_renting/core/enums/transmission_enum.dart';
import 'package:car_renting/features/car-management/models/car_document.dart';
import 'package:car_renting/features/car-management/models/car_location.dart';
import 'package:car_renting/features/car-management/models/car_model.dart';
import 'package:car_renting/features/car-management/models/car_params.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'car_form_state.dart';

class CarFormCubit extends Cubit<CarFormState> {
  CarFormCubit() : super(CarFormState(params: CarParams.empty()));

  void fillForm(CarModel car) => emit(
    state.copyWith(
      sectionIndex: 0,
      nextEnabled: true,
      params: CarParams(
        id: car.id,
        brand: car.brand,
        model: car.model,
        year: car.year,
        fuelType: car.fuelType,
        transmission: car.transmission,
        pricePerDay: car.pricePerDay,
        currency: car.currency,
        seats: car.seats,
        features: car.features,
        location: car.location,
        blockedDays: car.blockedDays,
        bookedDays: car.bookedDays,
        images: car.images,
        status: car.status,
        documents: car.documents,
      ),
    ),
  );

  void setSection(int index) {
    emit(state.copyWith(sectionIndex: index));
    _validate();
  }

  void updateBrand(String brand) {
    emit(state.copyWith(params: state.params.copyWith(brand: brand)));
    _validate();
  }

  void updateModel(String model) {
    emit(state.copyWith(params: state.params.copyWith(model: model)));
    _validate();
  }

  void updateYear(int year) {
    emit(state.copyWith(params: state.params.copyWith(year: year)));
    _validate();
  }

  void updateTransmission(Transmission transmission) {
    emit(
      state.copyWith(params: state.params.copyWith(transmission: transmission)),
    );
    _validate();
  }

  void updateFuelType(FuelType fuelType) {
    emit(state.copyWith(params: state.params.copyWith(fuelType: fuelType)));
    _validate();
  }

  void updatePricePerDay(double price) {
    emit(state.copyWith(params: state.params.copyWith(pricePerDay: price)));
    _validate();
  }

  void updateCurrency(Currency currency) {
    emit(state.copyWith(params: state.params.copyWith(currency: currency)));
    _validate();
  }

  void updateSeats(int seats) {
    emit(state.copyWith(params: state.params.copyWith(seats: seats)));
    _validate();
  }

  void updateFeatures(CarFeature feature) {
    final currentFeatures = List<CarFeature>.from(state.params.features);
    currentFeatures.contains(feature)
        ? currentFeatures.remove(feature)
        : currentFeatures.add(feature);
    emit(
      state.copyWith(params: state.params.copyWith(features: currentFeatures)),
    );
    _validate();
  }

  void updateLocation(CarLocation location) {
    emit(state.copyWith(params: state.params.copyWith(location: location)));
    _validate();
  }

  void updateBlockedDays(List<DateTime> dates) {
    final editableDates = dates
        .where((d) => !state.params.bookedDays.contains(d))
        .toList();
    emit(
      state.copyWith(params: state.params.copyWith(blockedDays: editableDates)),
    );
    _validate();
  }

  void updateImages(List<String> images) {
    emit(state.copyWith(params: state.params.copyWith(images: images)));
    _validate();
  }

  void updateDocument(CarDocumentType type, List<String> urls) {
    final currentDocs = List<CarDocument>.from(state.params.documents);
    currentDocs.removeWhere((d) => d.type == type);
    currentDocs.add(CarDocument(type: type, urls: urls));
    emit(state.copyWith(params: state.params.copyWith(documents: currentDocs)));
    _validate();
  }

  void toggleVisibility() {
    final currentStatus = state.params.status;

    if (currentStatus == CarStatus.verified) {
      emit(
        state.copyWith(params: state.params.copyWith(status: CarStatus.hidden)),
      );
    } else if (currentStatus == CarStatus.hidden) {
      emit(
        state.copyWith(
          params: state.params.copyWith(status: CarStatus.verified),
        ),
      );
    }
  }

  void _validate() {
    final p = state.params;
    bool nextEnabled = false;
    bool canSubmit = false;

    if (state.sectionIndex == 0) {
      nextEnabled =
          p.brand.isNotEmpty &&
          p.model.isNotEmpty &&
          p.pricePerDay > 0 &&
          p.seats > 0 &&
          p.year > 1990;
    }

    if (state.sectionIndex == 1) {
      final l = p.location;
      nextEnabled = l.address.isNotEmpty && l.lat != 0;
    }

    canSubmit = p.images.length >= 3 && p.documents.length == 5;

    emit(state.copyWith(nextEnabled: nextEnabled, canSubmit: canSubmit));
  }
}
