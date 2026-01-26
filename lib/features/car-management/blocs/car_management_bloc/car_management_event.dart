part of 'car_management_bloc.dart';

sealed class CarManagementEvent extends Equatable {
  const CarManagementEvent();

  @override
  List<Object?> get props => [];
}

class GetRenterCarsRequested extends CarManagementEvent {
  final CarFilterParams filters;
  final bool isRefresh;
  const GetRenterCarsRequested({
    this.filters = const CarFilterParams(),
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [filters, isRefresh];
}

class LoadMoreCarsRequested extends CarManagementEvent {}

class GetCarDetailsRequested extends CarManagementEvent {
  final String carId;
  const GetCarDetailsRequested(this.carId);

  @override
  List<Object?> get props => [carId];
}

class AddCarRequested extends CarManagementEvent {
  final CarParams params;
  const AddCarRequested({required this.params});

  @override
  List<Object?> get props => [params];
}

class UpdateCarRequested extends CarManagementEvent {
  final CarParams params;
  const UpdateCarRequested({required this.params});

  @override
  List<Object?> get props => [params];
}

class DeleteCarRequested extends CarManagementEvent {
  final String carId;
  const DeleteCarRequested(this.carId);

  @override
  List<Object?> get props => [carId];
}
