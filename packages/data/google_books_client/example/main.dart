// ignore_for_file: avoid_print

import 'dart:io';

import 'package:bgoogle_books_client/bgoogle_books_client.dart';

/// Run in terminal with `dart run example/main.dart`
///
/// Enter an ISBN and press enter to fetch the book.
void main() async {
  const client = BGoogleBooksClient();

  while (true) {
    stdout.write('\nEnter an ISBN: ');
    final input = stdin.readLineSync();
    if (input == null || int.tryParse(input) == null) continue;

    final book = await client.fetchBookByISBN(int.parse(input));

    book.fold(
      (exception) => switch (exception) {
        BGoogleBookFetchException.notFound => print('Book not found.'),
        BGoogleBookFetchException.unknown =>
          print('An unknown error occurred.'),
      },
      print,
    );
  }
}
