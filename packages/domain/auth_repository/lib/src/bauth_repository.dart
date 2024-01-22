import 'package:bauth_client/bauth_client.dart';
import 'package:bauth_repository/bauth_repository.dart';
import 'package:bpub/dartz.dart';

/// {@template BAuthRepository}
///
/// {@endtemplate}
class BAuthRepository {
  /// {@macro BAuthRepository}
  BAuthRepository({required this.authClient});

  /// The [BAuthClient] used to interact with the backend.
  final BAuthClient authClient;

  /// The currently logged in user.
  Stream<Option<BUser>> currentUser() async* {
    await for (final user in authClient.currentUser()) {
      yield user.fold(none, (user) => some(BUser.fromRawUser(user)));
    }
  }

  /// Sends a one-time-password for signup to the given email.
  Future<Option<BSignInException>> signUpWithOTP({
    required String email,
  }) async {
    final result = await authClient.signInWithOTP(email: email, isSignUp: true);

    return result.fold(
      none,
      (exception) => some(
        switch (exception) {
          BRawSignInException.unknown => BSignInException.unknown,
        },
      ),
    );
  }

  /// Sends a one-time-password for login to the given email.
  Future<Option<BSignInException>> logInWithOTP({required String email}) async {
    final result = await authClient.signInWithOTP(email: email);

    return result.fold(
      none,
      (exception) => some(
        switch (exception) {
          BRawSignInException.unknown => BSignInException.unknown,
        },
      ),
    );
  }

  /// Verifies the one-time-password signup token that was sent to the given
  /// email.
  Future<Option<BOTPVerificationException>> verifySignupOTP({
    required String email,
    required String token,
  }) async {
    final result = await authClient.verifyOTP(
      email: email,
      token: token,
      isSignUp: true,
    );

    return result.fold(
      none,
      (exception) => some(
        switch (exception) {
          BRawOTPVerificationException.invalidToken =>
            BOTPVerificationException.invalidToken,
          BRawOTPVerificationException.unknown =>
            BOTPVerificationException.unknown,
        },
      ),
    );
  }

  /// Verifies the one-time-password login token that was sent to the given
  /// email.
  Future<Option<BOTPVerificationException>> verifyLoginOTP({
    required String email,
    required String token,
  }) async {
    final result = await authClient.verifyOTP(email: email, token: token);

    return result.fold(
      none,
      (exception) => some(
        switch (exception) {
          BRawOTPVerificationException.invalidToken =>
            BOTPVerificationException.invalidToken,
          BRawOTPVerificationException.unknown =>
            BOTPVerificationException.unknown,
        },
      ),
    );
  }

  /// Signs out the current user, if there is a logged in user.
  Future<Option<BSignOutException>> signOut() async {
    final result = await authClient.signOut();

    return result.fold(
      none,
      (exception) => some(
        switch (exception) {
          BRawSignOutException.unknown => BSignOutException.unknown,
        },
      ),
    );
  }
}
