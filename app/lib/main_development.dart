import 'dart:io';

import 'package:booksinarow/app/app.dart';
import 'package:booksinarow/bootstrap.dart';
import 'package:booksinarow/secrets.dart';
import 'package:bpub/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: !kIsWeb && Platform.isAndroid
        ? 'http://127.0.0.1:54321'
        : 'http://localhost:54321',
    anonKey: BSecrets.developmentDatabaseAnonKey,
  );

  await bootstrap(() => const BApp());
}
