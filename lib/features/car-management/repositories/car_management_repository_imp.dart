import 'package:car_renting/core/error/car_management_exception_handler.dart';
import 'package:car_renting/core/error/failure.dart';
import 'package:car_renting/core/error/safe_call.dart';
import 'package:car_renting/core/utils/pagination_repsonse.dart';
import 'package:car_renting/features/car-management/models/car_filter_params.dart';
import 'package:car_renting/features/car-management/models/car_model.dart';
import 'package:car_renting/features/car-management/models/car_params.dart';
import 'package:car_renting/features/car-management/repositories/i_car_management_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

class CarManagementRepositoryImp implements ICarManagmentRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CarManagementRepositoryImp({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  @override
  Future<Either<Failure, PaginationResponse<CarModel>>> getRenterCars({
    required int skip,
    required int take,
    CarFilterParams? params,
    dynamic lastDoc,
  }) async {
    return await SafeCall.execute(
      onException: CarExceptionHandler.handleException,
      action: () async {
        final userId = _getAuthenticatedUserId();

        Query query = _firestore
            .collection('cars')
            .where('ownerId', isEqualTo: userId);
        if (params != null) {
          query = params.applyToQuery(query);
        }

        if (params?.hasPriceFilter ?? false) {
          query = query.orderBy('pricePerDay');
        } else {
          query = query.orderBy('createdAt', descending: true);
        }

        if (lastDoc != null) {
          query = query.startAfterDocument(lastDoc);
        } else if (skip > 0) {
          final skipSnapshot = await query.limit(skip).get();
          if (skipSnapshot.docs.isNotEmpty) {
            query = query.startAfterDocument(skipSnapshot.docs.last);
          }
        }

        final snapshot = await query.limit(take).get();
        final countSnapshot = await query.count().get();

        return PaginationResponse<CarModel>(
          items: snapshot.docs
              .map(
                (d) => CarModel.fromMap(d.data() as Map<String, dynamic>, d.id),
              )
              .toList(),
          totalCount: countSnapshot.count ?? 0,
          hasNextPage: snapshot.docs.length == take,
          lastDoc: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
        );
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> addCar({required CarParams params}) async {
    return await SafeCall.execute(
      onException: CarExceptionHandler.handleException,
      action: () async {
        final userId = _getAuthenticatedUserId();

        final carData = params.toMap(userId);

        carData['searchKeywords'] = _generateKeywords(
          params.brand,
          params.model,
        );
        carData['createdAt'] = FieldValue.serverTimestamp();

        await _firestore.collection('cars').add(carData);
        return unit;
      },
    );
  }

  @override
  Future<Either<Failure, CarModel>> getCarDetails(String carId) async {
    return await SafeCall.execute(
      onException: CarExceptionHandler.handleException,
      action: () async {
        final doc = await _firestore.collection('cars').doc(carId).get();

        if (!doc.exists) {
          throw FirebaseException(code: 'not-found', plugin: 'firestore');
        }

        return CarModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> updateCar({required CarParams params}) async {
    return await SafeCall.execute(
      onException: CarExceptionHandler.handleException,
      action: () async {
        final userId = _getAuthenticatedUserId();

        final carData = params.toMap(userId);

        carData['searchKeywords'] = _generateKeywords(
          params.brand,
          params.model,
        );

        carData['updatedAt'] = FieldValue.serverTimestamp();
        carData.remove('createdAt');

        await _firestore.collection('cars').doc(params.id).update(carData);

        return unit;
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> deleteCar(String carId) async {
    return await SafeCall.execute(
      onException: CarExceptionHandler.handleException,
      action: () async {
        await _firestore.collection('cars').doc(carId).delete();
        return unit;
      },
    );
  }

  //Private Helpers

  String _getAuthenticatedUserId() {
    final String? userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw FirebaseException(code: 'permission-denied', plugin: 'auth');
    }
    return userId;
  }

  List<String> _generateKeywords(String brand, String model) {
    final String fullText = '${brand.toLowerCase()} ${model.toLowerCase()}';
    final Set<String> keywords = {};

    final List<String> words = fullText.split(' ');

    for (var word in words) {
      String cumulative = '';
      for (int i = 0; i < word.length; i++) {
        cumulative += word[i];
        keywords.add(cumulative);
      }
    }

    return keywords.toList();
  }
}
