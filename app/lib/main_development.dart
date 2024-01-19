import 'package:booksinarow/app/app.dart';
import 'package:booksinarow/bootstrap.dart';
import 'package:booksinarow/secrets.dart';
import 'package:bpub/supabase_flutter.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: BSecrets.developmentDatabaseURL,
    anonKey: BSecrets.developmentDatabaseAnonKey,
  );

  await bootstrap(() => const BApp());
}
