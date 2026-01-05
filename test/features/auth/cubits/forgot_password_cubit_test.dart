import 'package:bloc_test/bloc_test.dart';
import 'package:car_renting/core/error/failure.dart';
import 'package:car_renting/features/auth/cubits/forgot_password_cubit/forgot_password_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/auth_mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late ForgotPasswordCubit forgotPasswordCubit;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    forgotPasswordCubit = ForgotPasswordCubit(authRepository: mockAuthRepository);
  });

  tearDown(() {
    forgotPasswordCubit.close();
  });

  group('ForgotPasswordCubit', () {
    const tEmail = 'test@example.com';

    test('initial state resendCountdown should be 0', () {
      expect(forgotPasswordCubit.state.resendCountdown, 0);
    });

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'emits [loading, success] and starts timer when email exists',
      build: () {
        when(() => mockAuthRepository.forgotPassword(email: tEmail))
            .thenAnswer((_) async => const Right(unit));
        return forgotPasswordCubit;
      },
      act: (cubit) => cubit.sendResetLink(tEmail),
      expect: () => [
        const ForgotPasswordState(status: ForgotPasswordStatus.loading),
        const ForgotPasswordState(
          status: ForgotPasswordStatus.success,
          resendCountdown: 60,
        ),
      ],
    );

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'emits [loading, error] when repository returns a failure',
      build: () {
        when(() => mockAuthRepository.forgotPassword(email: tEmail))
            .thenAnswer((_) async => const Left(Failure('User not found')));
        return forgotPasswordCubit;
      },
      act: (cubit) => cubit.sendResetLink(tEmail),
      expect: () => [
        const ForgotPasswordState(status: ForgotPasswordStatus.loading),
        const ForgotPasswordState(
          status: ForgotPasswordStatus.error,
          errorMessage: 'User not found',
        ),
      ],
    );

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'emits [isResending: true, isResending: false] when resending from success state',
      seed: () => const ForgotPasswordState(status: ForgotPasswordStatus.success),
      build: () {
        when(() => mockAuthRepository.forgotPassword(email: tEmail))
            .thenAnswer((_) async => const Right(unit));
        return forgotPasswordCubit;
      },
      act: (cubit) => cubit.sendResetLink(tEmail),
      expect: () => [
        const ForgotPasswordState(status: ForgotPasswordStatus.success, isResending: true),
        const ForgotPasswordState(status: ForgotPasswordStatus.success, isResending: false, resendCountdown: 60),
      ],
    );
  });
}