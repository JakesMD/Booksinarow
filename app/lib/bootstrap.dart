import 'dart:async';
import 'dart:developer';

import 'package:bpub/bloc.dart';
import 'package:flutter/widgets.dart';

/// {@template BAppBlocObserver}
///
/// A [BlocObserver] that logs all bloc events.
///
/// {@endtemplate}
class BAppBlocObserver extends BlocObserver {
  /// {@macro BAppBlocObserver}
  const BAppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

/// Bootstraps the application.
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const BAppBlocObserver();

  // Add cross-flavor configuration here

  runApp(await builder());
}
