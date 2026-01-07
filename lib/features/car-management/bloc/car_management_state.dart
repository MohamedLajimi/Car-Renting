part of 'car_management_bloc.dart';

enum DataStatus { initial, loading, success, error }

sealed class CarManagementState extends Equatable {
  const CarManagementState();
  @override
  List<Object?> get props => [];
}

final class CarManagementInitial extends CarManagementState {}

final class CarListState extends CarManagementState {
  final DataStatus status;
  final List<CarModel> cars;
  final CarFilterParams? filters;
  final int totalCount;
  final bool hasNextPage;
  final bool isLoadingMore;
  final DocumentSnapshot? lastDocument;
  final String? errorMessage;

  const CarListState({
    this.status = DataStatus.initial,
    this.cars = const [],
    this.filters,
    this.totalCount = 0,
    this.hasNextPage = true,
    this.isLoadingMore=false,
    this.lastDocument,
    this.errorMessage,
  });

  bool get isLoading => status == DataStatus.loading;
  bool get isSuccess => status == DataStatus.success;
  bool get isError => status == DataStatus.error;
  bool get isEmpty => cars.isEmpty && status == DataStatus.success;

  CarListState copyWith({
    DataStatus? status,
    List<CarModel>? cars,
    CarFilterParams? filters,
    int? totalCount,
    bool? hasNextPage,
    bool? isLoadingMore,
    DocumentSnapshot? lastDocument,
    String? errorMessage,
  }) => CarListState(
    status: status ?? this.status,
    cars: cars ?? this.cars,
    filters: filters ?? this.filters,
    totalCount: totalCount ?? this.totalCount,
    hasNextPage: hasNextPage ?? this.hasNextPage,
    isLoadingMore: isLoadingMore??this.isLoadingMore,
    lastDocument: lastDocument ?? this.lastDocument,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [
    status,
    cars,
    filters,
    totalCount,
    hasNextPage,
    isLoadingMore,
    lastDocument,
    errorMessage,
  ];
}

final class CarDetailState extends CarManagementState {
  final DataStatus status;
  final CarModel? car;
  final String? errorMessage;

  const CarDetailState({
    this.status = DataStatus.initial,
    this.car,
    this.errorMessage,
  });

  bool get isLoading => status == DataStatus.loading;
  bool get isSuccess => status == DataStatus.success;
  bool get isError => status == DataStatus.error;

  CarDetailState copyWith({
    DataStatus? status,
    CarModel? car,
    String? errorMessage,
  }) => CarDetailState(
    status: status ?? this.status,
    car: car ?? this.car,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [status, car, errorMessage];
}

// ============= ACTION STATE =============
enum ActionType { create, update, delete }

enum ActionStatus { loading, success, error }

class CarManagementActionState extends CarManagementState {
  final ActionType type;
  final ActionStatus status;
  final String? message;

  const CarManagementActionState({
    required this.type,
    required this.status,
    this.message,
  });

  bool get isLoading => status == ActionStatus.loading;
  bool get isSuccess => status == ActionStatus.success;
  bool get isError => status == ActionStatus.error;

  @override
  List<Object?> get props => [type, status, message];
}
