// coverage:ignore-file

import 'package:bpub/meta.dart';
import 'package:http/http.dart' as http;

export 'package:http/http.dart' show Response;

/// {@template BHTTP}
///
/// Provides HTTP client functionality for making requests.
///
/// This is a simple wrapper around the [http] package to make it easier to
/// mock.
///
/// {@endtemplate}
class BHTTP {
  /// {@macro BHTTP}
  @internal
  const BHTTP();

  /// Sends an HTTP GET request with the given headers to the given URL.
  Future<http.Response> get(String url) {
    return http.get(Uri.parse(url));
  }
}
