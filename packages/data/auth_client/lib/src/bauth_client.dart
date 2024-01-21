import 'dart:developer';

import 'package:bauth_client/bauth_client.dart';
import 'package:bpub/dartz.dart';
import 'package:bpub/supabase.dart';

/// {@template BAuthClient}
///
/// A client for interacting with the Supabase auth API.
///
/// {@endtemplate}
class BAuthClient {
  /// {@macro BAuthClient}
  const BAuthClient({required this.authClient});

  /// The API client to interact with Supabase auth.
  final GoTrueClient authClient;

  /// The currently logged in user.
  Stream<Option<BRawUser>> currentUser() async* {
    try {
      await for (final authState in authClient.onAuthStateChange) {
        if (authState.event == AuthChangeEvent.signedIn ||
            authState.event == AuthChangeEvent.signedOut ||
            authState.event == AuthChangeEvent.userDeleted) {
          if (authState.session != null) {
            yield some(BRawUser.fromSupabaseUser(authState.session!.user));
          } else {
            yield none();
          }
        }
      }
    } catch (exception) {
      log(exception.toString(), error: exception, name: 'BAuthClient');
      yield none();
    }
  }

  /// Sends a one-time-password to the given `email`.
  ///
  /// If `isSignUp` is true, a new user will be created.
  Future<Option<BRawSignInException>> signInWithOTP({
    required String email,
    bool isSignUp = false,
  }) async {
    try {
      await authClient.signInWithOtp(
        email: email,
        shouldCreateUser: isSignUp,
      );
      return none();
    } catch (exception) {
      log(exception.toString(), error: exception, name: 'BAuthClient');
      return some(BRawSignInException.unknown);
    }
  }

  /// Verifies the one-time-password `token` that was sent to a user's `email`.
  ///
  /// Set `isSignUp` to true, if the user is signing up.
  Future<Option<BRawOTPVerificationException>> verifyOTP({
    required String email,
    required String token,
    bool isSignUp = false,
  }) async {
    try {
      final result = await authClient.verifyOTP(
        email: email,
        type: isSignUp ? OtpType.signup : OtpType.email,
        token: token,
      );
      if (result.user != null) return none();
    } on AuthException catch (exception) {
      log(exception.toString(), error: exception, name: 'BAuthClient');
      return some(BRawOTPVerificationException.invalidToken);
    } catch (exception) {
      log(exception.toString(), error: exception, name: 'BAuthClient');
    }
    return some(BRawOTPVerificationException.unknown);
  }

  /// Signs out the current user, if there is a logged in user.
  Future<Option<BRawSignOutException>> signOut() async {
    try {
      await authClient.signOut();
      return none();
    } catch (exception) {
      log(exception.toString(), error: exception, name: 'BAuthClient');
      return some(BRawSignOutException.unknown);
    }
  }
}
