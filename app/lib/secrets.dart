import 'package:envied/envied.dart';

part 'secrets.g.dart';

/// The secrets for the application.
@Envied(path: '../.env', useConstantCase: true, obfuscate: true)
final class BSecrets {
  /// The key for the local development Supabase database.
  @EnviedField()
  static final String developmentDatabaseAnonKey =
      _BSecrets.developmentDatabaseAnonKey;

  /// The key for the staging Supabase database.
  @EnviedField()
  static final String stagingDatabaseAnonKey = _BSecrets.stagingDatabaseAnonKey;

  /// The key for the production Supabase database.
  @EnviedField()
  static final String productionDatabaseAnonKey =
      _BSecrets.productionDatabaseAnonKey;

  /// The URL of the staging Supabase database.
  @EnviedField()
  static final String stagingDatabaseUrl = _BSecrets.stagingDatabaseUrl;

  /// The URL of the production Supabase database.
  @EnviedField()
  static final String productionDatabaseUrl = _BSecrets.productionDatabaseUrl;
}
