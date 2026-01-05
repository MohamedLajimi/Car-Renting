import 'package:bloc_test/bloc_test.dart';
import 'package:car_renting/core/error/failure.dart';
import 'package:car_renting/features/auth/cubits/login_cubit/login_cubit.dart';
import 'package:car_renting/features/auth/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../repo/auth_repo_test.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late LoginCubit loginCubit;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginCubit = LoginCubit(authRepository: mockAuthRepository);
  });

  tearDown(() {
    loginCubit.close();
  });

  const tUser = UserModel(
    id: '1',
    email: 'test@test.com',
    fullName: 'Test User',
    role: UserRole.renter,
    phoneNumber: '12345678',
    isVerified: false,
  );

  group('LoginCubit', () {
    test('initial state should be LoginStatus.initial', () {
      expect(loginCubit.state.status, LoginStatus.initial);
    });

    blocTest<LoginCubit, LoginState>(
      'emits [loading, success] when login is successful',
      build: () {
        when(
          () => mockAuthRepository.loginWithEmailAndPassword(
            email: 'test@test.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async => const Right(tUser));
        return loginCubit;
      },
      act: (cubit) => cubit.loginWithEmailAndPassword(
        email: 'test@test.com',
        password: 'password123',
      ),
      expect: () => [
        const LoginState(status: LoginStatus.loading),
        const LoginState(status: LoginStatus.success, user: tUser),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [loading, error] with message when login fails',
      build: () {
        when(
          () => mockAuthRepository.loginWithEmailAndPassword(
            email: 'test@test.com',
            password: 'wrong',
          ),
        ).thenAnswer((_) async => const Left(Failure('Invalid credentials')));
        return loginCubit;
      },
      act: (cubit) => cubit.loginWithEmailAndPassword(
        email: 'test@test.com',
        password: 'wrong',
      ),
      expect: () => [
        const LoginState(status: LoginStatus.loading),
        const LoginState(
          status: LoginStatus.error,
          errorMessage: 'Invalid credentials',
        ),
      ],
    );
  });
}
