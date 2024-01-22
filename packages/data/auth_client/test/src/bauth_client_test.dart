import 'dart:async';

import 'package:bauth_client/bauth_client.dart';
import 'package:bpub/dartz.dart';
import 'package:bpub/supabase.dart';
import 'package:bpub_dev/flutter_test.dart';
import 'package:bpub_dev/mocktail.dart';
import 'package:bpub_dev/test_beautifier.dart';

class FakeSession extends Fake implements Session {
  // This indirectly tests the BRawUser.fromSupabaseUser() method.
  @override
  User get user => const User(
        id: 'id',
        email: 'email',
        appMetadata: {},
        userMetadata: {},
        aud: '',
        createdAt: '',
      );
}

class FakeUser extends Fake implements User {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

void main() {
  group('BAuthClient Tests', () {
    late MockGoTrueClient goTrueClient;
    late BAuthClient client;

    setUp(() {
      goTrueClient = MockGoTrueClient();
      client = BAuthClient(authClient: goTrueClient);
    });

    group('currentUser', () {
      late StreamController<AuthState> controller;

      setUp(() {
        controller = StreamController();

        when(() => goTrueClient.onAuthStateChange)
            .thenAnswer((_) => controller.stream);
      });

      test(
        requirement(
          When: 'user signs out',
          Then: 'returns none',
        ),
        procedure(() async {
          var result = some(const BRawUser(id: '', email: ''));
          client.currentUser().listen((event) => result = event);

          controller.add(AuthState(AuthChangeEvent.signedOut, null));
          await Future.delayed(Duration.zero);

          expect(result, none());
        }),
      );

      test(
        requirement(
          When: 'user is deleted',
          Then: 'returns none',
        ),
        procedure(() async {
          var result = none<BRawUser>();
          client.currentUser().listen((event) => result = event);

          controller.add(AuthState(AuthChangeEvent.userDeleted, null));
          await Future.delayed(Duration.zero);

          expect(result, none());
        }),
      );

      test(
        requirement(
          When: 'user signs in',
          Then: 'returns user',
        ),
        procedure(() async {
          var result = none<BRawUser>();
          client.currentUser().listen((event) => result = event);

          controller.add(AuthState(AuthChangeEvent.signedIn, FakeSession()));
          await Future.delayed(Duration.zero);

          expect(result, some(const BRawUser(id: 'id', email: 'email')));
        }),
      );

      test(
        requirement(
          When: 'current user fails',
          Then: 'returns none',
        ),
        procedure(() async {
          var result = none<BRawUser>();
          client.currentUser().listen((event) => result = event);

          controller.addError(Exception());
          await Future.delayed(Duration.zero);

          expect(result, none());
        }),
      );

      tearDown(() => controller.close());
    });

    group('signInWithOTP', () {
      test(
        requirement(
          When: 'login with OTP succeeds',
          Then: 'returns none',
        ),
        procedure(() async {
          when(
            () => goTrueClient.signInWithOtp(
              email: '',
              shouldCreateUser: false,
            ),
          ).thenAnswer((_) async => AuthResponse(user: FakeUser()));

          final result = await client.signInWithOTP(email: '');

          expect(result, none());
        }),
      );

      test(
        requirement(
          When: 'sign up with OTP succeeds',
          Then: 'returns none',
        ),
        procedure(() async {
          when(
            () => goTrueClient.signInWithOtp(
              email: '',
              shouldCreateUser: true,
            ),
          ).thenAnswer((_) async => AuthResponse(user: FakeUser()));

          final result = await client.signInWithOTP(email: '', isSignUp: true);

          expect(result, none());
        }),
      );

      test(
        requirement(
          When: 'sign in with OTP fails',
          Then: 'returns unknown sign in exception',
        ),
        procedure(() async {
          when(
            () => goTrueClient.signInWithOtp(
              email: '',
              shouldCreateUser: true,
            ),
          ).thenThrow(Exception());

          final result = await client.signInWithOTP(email: '', isSignUp: true);

          expect(result, some(BRawSignInException.unknown));
        }),
      );
    });

    group('verifyOTP', () {
      test(
        requirement(
          Given: 'valid token',
          When: 'verify OTP for signup succeeds',
          Then: 'returns none',
        ),
        procedure(() async {
          when(
            () => goTrueClient.verifyOTP(
              email: '',
              token: '',
              type: OtpType.signup,
            ),
          ).thenAnswer((_) async => AuthResponse(user: FakeUser()));

          final result = await client.verifyOTP(
            email: '',
            token: '',
            isSignUp: true,
          );

          expect(result, none());
        }),
      );

      test(
        requirement(
          Given: 'valid token',
          When: 'verify OTP for login succeeds',
          Then: 'returns none',
        ),
        procedure(() async {
          when(
            () => goTrueClient.verifyOTP(
              email: '',
              token: '',
              type: OtpType.email,
            ),
          ).thenAnswer((_) async => AuthResponse(user: FakeUser()));

          final result = await client.verifyOTP(email: '', token: '');

          expect(result, none());
        }),
      );

      test(
        requirement(
          Given: 'invalid token',
          When: 'verify OTP',
          Then: 'returns invalid token exception',
        ),
        procedure(() async {
          when(
            () => goTrueClient.verifyOTP(
              email: '',
              token: '',
              type: OtpType.email,
            ),
          ).thenThrow(const AuthException(''));

          final result = await client.verifyOTP(email: '', token: '');

          expect(result, some(BRawOTPVerificationException.invalidToken));
        }),
      );

      test(
        requirement(
          When: 'verify OTP fails',
          Then: 'returns invalid token exception',
        ),
        procedure(() async {
          when(
            () => goTrueClient.verifyOTP(
              email: '',
              token: '',
              type: OtpType.email,
            ),
          ).thenThrow(Exception());

          final result = await client.verifyOTP(email: '', token: '');

          expect(result, some(BRawOTPVerificationException.unknown));
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
          when(() => goTrueClient.signOut()).thenAnswer((_) async {});

          final result = await client.signOut();

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
          when(() => goTrueClient.signOut()).thenThrow('');

          final result = await client.signOut();

          expect(result, some(BRawSignOutException.unknown));
        }),
      );
    });
  });
}
