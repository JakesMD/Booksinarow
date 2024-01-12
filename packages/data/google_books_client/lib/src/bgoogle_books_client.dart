// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:bgoogle_books_client/bgoogle_books_client.dart';
import 'package:bpub/dartz.dart';

/// {@template BGoogleBooksClient}
///
/// Client for making requests to the Google Books API.
///
/// {@endtemplate}
class BGoogleBooksClient {
  /// {@macro BGoogleBooksClient}
  const BGoogleBooksClient({this.http = const BHTTP()});

  /// The HTTP client to use for making requests.
  final BHTTP http;

  /// Fetches a Google Book by ISBN from the Google Books API.
  ///
  /// Throws a [BGoogleBookFetchException] on failure.
  Future<Either<BGoogleBookFetchException, BGoogleBook>> fetchBookByISBN(
    int isbn,
  ) async {
    final result = await http.get(
      'https://www.googleapis.com/books/v1/volumes?q=isbn:$isbn',
    );

    if (result.statusCode != 200) {
      return left(BGoogleBookFetchException.unknown);
    }

    final data = jsonDecode(result.body)['items']?[0] as Map<String, dynamic>?;

    if (data == null) return left(BGoogleBookFetchException.notFound);

    return right(BGoogleBook.fromJson(isbn, data));
  }
}
