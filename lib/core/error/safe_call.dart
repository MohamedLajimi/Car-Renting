import 'package:car_renting/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

typedef FailureHandler = Failure Function(dynamic e);

class SafeCall {
  static Future<Either<Failure, T>> execute<T>({
    required Future<T> Function() action,
    required FailureHandler onException,
  }) async {
    try {
      final result = await action();
      return right(result);
    } catch (e) {
      return left(onException(e));
    }
  }
}