import 'package:bauth_client/bauth_client.dart';
import 'package:bpub/equatable.dart';
import 'package:bpub/meta.dart';

/// {@template BUser}
///
/// Represents a user currently signed in.
///
/// {@endtemplate}
class BUser with EquatableMixin {
  /// {@macro BUser}
  const BUser({required this.id, required this.email});

  /// {@macro BUser}
  ///
  /// Creates a [BUser] from a [BRawUser].
  @internal
  BUser.fromRawUser(BRawUser user)
      : id = user.id,
        email = user.email;

  /// The user's unique identifier.
  final String id;

  /// The user's email address.
  final String email;

  @override
  List<Object?> get props => [id, email];
}
