import 'package:booksinarow/app/app.dart';
import 'package:booksinarow/bootstrap.dart';
import 'package:booksinarow/secrets.dart';
import 'package:bpub/supabase_flutter.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: BSecrets.stagingDatabaseUrl,
    anonKey: BSecrets.stagingDatabaseAnonKey,
  );

  await bootstrap(() => const BApp());
}
