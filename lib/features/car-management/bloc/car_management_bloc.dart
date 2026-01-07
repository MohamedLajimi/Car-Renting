import 'package:car_renting/features/car-management/models/car_filter_params.dart';
import 'package:car_renting/features/car-management/models/car_model.dart';
import 'package:car_renting/features/car-management/models/car_params.dart';
import 'package:car_renting/features/car-management/repositories/i_car_management_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'car_management_event.dart';
part 'car_management_state.dart';

class CarManagementBloc extends Bloc<CarManagementEvent, CarManagementState> {
  final ICarManagmentRepository _repository;

  CarManagementBloc({required ICarManagmentRepository repository})
    : _repository = repository,
      super(CarManagementInitial()) {
    on<GetRenterCarsRequested>(_onGetRenterCarsRequested);
    on<LoadMoreCarsRequested>(_onLoadMoreCarsRequested);
    on<GetCarDetailsRequested>(_onGetCarDetailsRequested);
    on<AddCarRequested>(_onAddCarRequested);
    on<UpdateCarRequested>(_onUpdateCarRequested);
    on<DeleteCarRequested>(_onDeleteCarRequested);
  }
  Future<void> _onGetRenterCarsRequested(
    GetRenterCarsRequested event,
    Emitter<CarManagementState> emit,
  ) async {
    if (!event.isRefresh) {
      emit(CarListState(status: DataStatus.loading, filters: event.filters));
    }

    final result = await _repository.getRenterCars(
      skip: 0,
      take: 10,
      params: event.filters,
      lastDoc: null,
    );

    result.fold(
      (error) => emit(
        CarListState(
          errorMessage: error.message,
          status: DataStatus.error,
          filters: event.filters,
        ),
      ),
      (data) => emit(
        CarListState(
          status: DataStatus.success,
          cars: data.items,
          errorMessage: null,
          filters: event.filters,
          hasNextPage: data.hasNextPage,
          lastDocument: data.lastDoc,
          totalCount: data.totalCount,
        ),
      ),
    );
  }

  Future<void> _onLoadMoreCarsRequested(
    LoadMoreCarsRequested event,
    Emitter<CarManagementState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CarListState) return;
    if (!currentState.hasNextPage || currentState.isLoading) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final result = await _repository.getRenterCars(
      skip: 0,
      take: 10,
      params: currentState.filters,
      lastDoc: currentState.lastDocument,
    );

    result.fold(
      (error) => emit(
        currentState.copyWith(
          isLoadingMore: false,
          errorMessage: error.message,
        ),
      ),
      (data) => emit(
        currentState.copyWith(
          cars: [...currentState.cars, ...data.items],
          totalCount: data.totalCount,
          hasNextPage: data.hasNextPage,
          lastDocument: data.lastDoc,
          isLoadingMore: false,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> _onGetCarDetailsRequested(
    GetCarDetailsRequested event,
    Emitter<CarManagementState> emit,
  ) async {
    emit(CarDetailState(errorMessage: null, status: DataStatus.loading));

    final result = await _repository.getCarDetails(event.carId);

    result.fold(
      (error) => emit(CarDetailState(errorMessage: error.message)),
      (data) => emit(
        CarDetailState(
          car: data,
          errorMessage: null,
          status: DataStatus.success,
        ),
      ),
    );
  }

  Future<void> _onAddCarRequested(
    AddCarRequested event,
    Emitter<CarManagementState> emit,
  ) async {
    emit(
      const CarManagementActionState(
        type: ActionType.create,
        status: ActionStatus.loading,
      ),
    );

    final result = await _repository.addCar(params: event.params);

    result.fold(
      (error) => emit(
        CarManagementActionState(
          type: ActionType.create,
          status: ActionStatus.error,
          message: error.message,
        ),
      ),
      (_) {
        emit(
          CarManagementActionState(
            type: ActionType.create,
            status: ActionStatus.success,
            message: 'car_added',
          ),
        );
        add(const GetRenterCarsRequested());
      },
    );
  }

  Future<void> _onUpdateCarRequested(
    UpdateCarRequested event,
    Emitter<CarManagementState> emit,
  ) async {
    emit(
      const CarManagementActionState(
        type: ActionType.create,
        status: ActionStatus.loading,
      ),
    );

    final result = await _repository.updateCar(params: event.params);

    result.fold(
      (error) => emit(
        CarManagementActionState(
          type: ActionType.update,
          status: ActionStatus.error,
          message: error.message,
        ),
      ),
      (_) {
        emit(
          CarManagementActionState(
            type: ActionType.update,
            status: ActionStatus.success,
            message: 'car_updated',
          ),
        );
        if (event.params.id != null) {
          add(GetCarDetailsRequested(event.params.id!));
        }

        add(const GetRenterCarsRequested());
      },
    );
  }

  Future<void> _onDeleteCarRequested(
    DeleteCarRequested event,
    Emitter<CarManagementState> emit,
  ) async {
    emit(
      const CarManagementActionState(
        type: ActionType.create,
        status: ActionStatus.loading,
      ),
    );

    final result = await _repository.deleteCar(event.carId);

    result.fold(
      (error) => emit(
        CarManagementActionState(
          type: ActionType.delete,
          status: ActionStatus.error,
          message: error.message,
        ),
      ),
      (_) {
        emit(
          CarManagementActionState(
            type: ActionType.delete,
            status: ActionStatus.success,
            message: 'car_deleted',
          ),
        );
        add(const GetRenterCarsRequested());
      },
    );
  }
}
