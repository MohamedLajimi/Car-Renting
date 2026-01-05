import 'package:bloc_test/bloc_test.dart';
import 'package:car_renting/core/error/failure.dart';
import 'package:car_renting/features/auth/cubits/signup_cubit/signup_cubit.dart';
import 'package:car_renting/features/auth/models/signup_params.dart';
import 'package:car_renting/features/auth/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/auth_mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late SignupCubit signupCubit;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signupCubit = SignupCubit(authRepository: mockAuthRepository);
  });

  tearDown(() {
    signupCubit.close();
  });

  const tUser = UserModel(
    id: '1',
    email: 'test@test.com',
    fullName: 'Tester',
    role: UserRole.renter,
    phoneNumber: '12345678',
  );
  const tParams = SignUpParams(
    email: 'test@test.com',
    password: 'password123',
    fullName: 'Tester',
    phoneNumber: '1234568',
    role: UserRole.renter,
  );

  group('SignupCubit UI Updates', () {
    test('initial state should be correct', () {
      expect(signupCubit.state.status, SignupStatus.initial);
      expect(signupCubit.state.visiblePassword, false);
    });

    blocTest<SignupCubit, SignupState>(
      'emits visiblePassword as true when updatePasswordVisibility is called',
      build: () => signupCubit,
      act: (cubit) => cubit.updatePasswordVisibility(true),
      expect: () => [const SignupState(visiblePassword: true)],
    );

    blocTest<SignupCubit, SignupState>(
      'emits correct UserRole when updateRole is called',
      build: () => signupCubit,
      act: (cubit) => cubit.updateRole(UserRole.renter),
      expect: () => [const SignupState(role: UserRole.renter)],
    );
  });

  group('signupWithEmailAndPassword', () {
    blocTest<SignupCubit, SignupState>(
      'emits [loading, success] with withGoogle: false on successful signup',
      build: () {
        when(
          () => mockAuthRepository.signupWithEmailAndPassword(params: tParams),
        ).thenAnswer((_) async => const Right(tUser));
        return signupCubit;
      },
      act: (cubit) => cubit.signupWithEmailAndPassword(tParams),
      expect: () => [
        const SignupState(status: SignupStatus.loading),
        const SignupState(
          status: SignupStatus.success,
          user: tUser,
          withGoogle: false,
        ),
      ],
    );

    blocTest<SignupCubit, SignupState>(
      'emits [loading, error] when signup fails',
      build: () {
        when(
          () => mockAuthRepository.signupWithEmailAndPassword(params: tParams),
        ).thenAnswer((_) async => const Left(Failure('Email already in use')));
        return signupCubit;
      },
      act: (cubit) => cubit.signupWithEmailAndPassword(tParams),
      expect: () => [
        const SignupState(status: SignupStatus.loading),
        const SignupState(
          status: SignupStatus.error,
          errorMessage: 'Email already in use',
        ),
      ],
    );
  });

  group('signupWithGoogle', () {
    blocTest<SignupCubit, SignupState>(
      'emits [loading, success] with withGoogle: true on successful Google signup',
      build: () {
        when(
          () => mockAuthRepository.signupWithGoogle(),
        ).thenAnswer((_) async => const Right(tUser));
        return signupCubit;
      },
      act: (cubit) => cubit.signupWithGoogle(),
      expect: () => [
        const SignupState(status: SignupStatus.loading),
        const SignupState(
          status: SignupStatus.success,
          user: tUser,
          withGoogle: true,
        ),
      ],
    );
  });
}
