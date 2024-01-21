import 'package:bpub/equatable.dart';
import 'package:bpub/meta.dart';
import 'package:bpub/supabase.dart';

/// {@template BRawUser}
///
/// A raw representation of a user straight from the Supabase auth API.
///
/// {@endtemplate}
class BRawUser with EquatableMixin {
  /// {@macro BRawUser}
  const BRawUser({required this.id, required this.email});

  /// {@macro BRawUser}
  ///
  /// Creates a [BRawUser] from a Supabase [User].
  @internal
  BRawUser.fromSupabaseUser(User user)
      : id = user.id,
        email = user.email ?? '';

  /// The user's unique identifier.
  final String id;

  /// The user's email address.
  final String email;

  @override
  List<Object?> get props => [id, email];
}
