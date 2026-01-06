import 'package:car_renting/core/error/failure.dart';
import 'package:car_renting/core/utils/pagination_repsonse.dart';
import 'package:car_renting/features/car-management/models/car_params.dart';
import 'package:fpdart/fpdart.dart';

import '../models/car_model.dart';

abstract class ICarManagmentRepository {
  Future<Either<Failure, PaginationResponse<CarModel>>> getRenterCars({
    required String ownerId,
    required int skip,
    required int take,
  });

  Future<Either<Failure, CarModel>> getCarDetails(String carId);

  Future<Either<Failure, Unit>> addCar({
    required CarParams params
  });

  Future<Either<Failure, Unit>> updateCar({
    required CarParams params
  });

  Future<Either<Failure, Unit>> deleteCar(String carId);
}