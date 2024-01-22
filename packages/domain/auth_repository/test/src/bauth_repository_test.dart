import 'dart:async';

import 'package:bauth_client/bauth_client.dart';
import 'package:bauth_repository/bauth_repository.dart';
import 'package:bpub/dartz.dart';
import 'package:bpub_dev/flutter_test.dart';
import 'package:bpub_dev/mocktail.dart';
import 'package:bpub_dev/test_beautifier.dart';

class MockBAuthClient extends Mock implements BAuthClient {}

void main() {
  group('BAuthRepository Tests', () {
    late MockBAuthClient authClient;
    late BAuthRepository repo;

    setUp(() {
      authClient = MockBAuthClient();
      repo = BAuthRepository(authClient: authClient);
    });

    group('currentUser', () {
      late StreamController<Option<BRawUser>> controller;

      setUp(() {
        controller = StreamController();

        when(() => authClient.currentUser())
            .thenAnswer((_) => controller.stream);
      });

      test(
        requirement(
          When: 'user signs in',
          Then: 'returns user',
        ),
        procedure(() async {
          var result = none<BUser>();
          repo.currentUser().listen((event) => result = event);

          controller.add(some(const BRawUser(id: 'id', email: 'email')));
          await Future.delayed(Duration.zero);

          expect(result, some(const BUser(id: 'id', email: 'email')));
        }),
      );

      test(
        requirement(
          When: 'user signs out',
          Then: 'returns user',
        ),
        procedure(() async {
          var result = none<BUser>();
          repo.currentUser().listen((event) => result = event);

          controller.add(none());
          await Future.delayed(Duration.zero);

          expect(result, none());
        }),
      );
    });

    group('signUpWithOTP', () {
      test(
        requirement(
          When: 'signup with OTP succeeds',
          Then: 'returns none',
        ),
        procedure(() async {
          when(
            () => authClient.signInWithOTP(email: '', isSignUp: true),
          ).thenAnswer((_) async => none());

          final result = await repo.signUpWithOTP(email: '');

          expect(result, none());
        }),
      );

      test(
        requirement(
          When: 'signup with OTP fails',
          Then: 'returns unknown signup exception',
        ),
        procedure(() async {
          when(
            () => authClient.signInWithOTP(email: '', isSignUp: true),
          ).thenAnswer((_) async => some(BRawSignInException.unknown));

          final result = await repo.signUpWithOTP(email: '');

          expect(result, some(BSignInException.unknown));
        }),
      );
    });

    group('logInWithOTP', () {
      test(
        requirement(
          When: 'login with OTP succeeds',
          Then: 'returns none',
        ),
        procedure(() async {
          when(
            () => authClient.signInWithOTP(email: ''),
          ).thenAnswer((_) async => none());

          final result = await repo.logInWithOTP(email: '');

          expect(result, none());
        }),
      );

      test(
        requirement(
          When: 'login with OTP fails',
          Then: 'returns unknown sign in exception',
        ),
        procedure(() async {
          when(() => authClient.signInWithOTP(email: ''))
              .thenAnswer((_) async => some(BRawSignInException.unknown));

          final result = await repo.logInWithOTP(email: '');

          expect(result, some(BSignInException.unknown));
        }),
      );
    });

    group('verifySignupOTP', () {
      test(
        requirement(
          Given: 'valid token',
          When: 'verify signup OTP succeeds',
          Then: 'returns none',
        ),
        procedure(() async {
          when(
            () => authClient.verifyOTP(email: '', token: '', isSignUp: true),
          ).thenAnswer((_) async => none());

          final result = await repo.verifySignupOTP(email: '', token: '');

          expect(result, none());
        }),
      );

      test(
        requirement(
          Given: 'invalid token',
          When: 'verify signup OTP',
          Then: 'returns invalid token exception',
        ),
        procedure(() async {
          when(
            () => authClient.verifyOTP(email: '', token: '', isSignUp: true),
          ).thenAnswer(
            (_) async => some(BRawOTPVerificationException.invalidToken),
          );

          final result = await repo.verifySignupOTP(email: '', token: '');

          expect(result, some(BOTPVerificationException.invalidToken));
        }),
      );

      test(
        requirement(
          When: 'verify signup OTP fails',
          Then: 'returns invalid token exception',
        ),
        procedure(() async {
          when(
            () => authClient.verifyOTP(email: '', token: '', isSignUp: true),
          ).thenAnswer(
            (_) async => some(BRawOTPVerificationException.unknown),
          );

          final result = await repo.verifySignupOTP(email: '', token: '');

          expect(result, some(BOTPVerificationException.unknown));
        }),
      );
    });

    group('verifyLoginOTP', () {
      test(
        requirement(
          Given: 'valid token',
          When: 'verify login OTP succeeds',
          Then: 'returns none',
        ),
        procedure(() async {
          when(
            () => authClient.verifyOTP(email: '', token: ''),
          ).thenAnswer((_) async => none());

          final result = await repo.verifyLoginOTP(email: '', token: '');

          expect(result, none());
        }),
      );

      test(
        requirement(
          Given: 'invalid token',
          When: 'verify login OTP',
          Then: 'returns invalid token exception',
        ),
        procedure(() async {
          when(
            () => authClient.verifyOTP(email: '', token: ''),
          ).thenAnswer(
            (_) async => some(BRawOTPVerificationException.invalidToken),
          );

          final result = await repo.verifyLoginOTP(email: '', token: '');

          expect(result, some(BOTPVerificationException.invalidToken));
        }),
      );

      test(
        requirement(
          When: 'verify login OTP fails',
          Then: 'returns invalid token exception',
        ),
        procedure(() async {
          when(
            () => authClient.verifyOTP(email: '', token: ''),
          ).thenAnswer(
            (_) async => some(BRawOTPVerificationException.unknown),
          );

          final result = await repo.verifyLoginOTP(email: '', token: '');

          expect(result, some(BOTPVerificationException.unknown));
        }),
      );
    });

    group('signOut', () {
      test(
        requirement(
          Given: 'The user is signed in',
          When: 'sign out succeeds',
          Then: 'returns none',
        ),
        procedure(() async {
          when(() => authClient.signOut()).thenAnswer((_) async => none());

          final result = await repo.signOut();

          expect(result, none());
        }),
      );

      test(
        requirement(
          Given: 'The user is signed in',
          When: 'sign out fails',
          Then: 'returns none',
        ),
        procedure(() async {
          when(() => authClient.signOut()).thenAnswer(
            (_) async => some(BRawSignOutException.unknown),
          );

          final result = await repo.signOut();

          expect(result, some(BSignOutException.unknown));
        }),
      );
    });
  });
}
