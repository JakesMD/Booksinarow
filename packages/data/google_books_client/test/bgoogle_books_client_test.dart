import 'package:bgoogle_books_client/bgoogle_books_client.dart';
import 'package:bpub/dartz.dart';
import 'package:bpub_dev/flutter_test.dart';
import 'package:bpub_dev/mocktail.dart';
import 'package:bpub_dev/test_beautifier.dart';

class MockBHTTP extends Mock implements BHTTP {}

void main() {
  group('BGoogleBooksClient Tests', () {
    late MockBHTTP http;
    late BGoogleBooksClient client;

    setUp(() {
      http = MockBHTTP();
      client = BGoogleBooksClient(http: http);
    });

    test(
      requirement(
        Given: 'HTTP request fails',
        When: 'fetch book by ISBN',
        Then: 'returns unknown exception',
      ),
      procedure(() async {
        when(
          () => http.get(any()),
        ).thenAnswer((_) async => Response('', 400));

        final result = await client.fetchBookByISBN(1);

        expect(result, left(BGoogleBookFetchException.unknown));
      }),
    );

    test(
      requirement(
        Given: 'HTTP request has no data',
        When: 'fetch book by ISBN',
        Then: 'returns not found exception',
      ),
      procedure(() async {
        when(
          () => http.get(any()),
        ).thenAnswer((_) async => Response('{}', 200));

        final result = await client.fetchBookByISBN(1);

        expect(result, left(BGoogleBookFetchException.notFound));
      }),
    );

    test(
      requirement(
        Given: 'Google Books has no match',
        When: 'fetch book by ISBN',
        Then: 'returns not found exception',
      ),
      procedure(() async {
        when(
          () => http.get(any()),
        ).thenAnswer((_) async => Response('{}', 200));

        final result = await client.fetchBookByISBN(1);

        expect(result, left(BGoogleBookFetchException.notFound));
      }),
    );

    test(
      requirement(
        Given: 'Google Books has match but no fields',
        When: 'fetch book by ISBN',
        Then: 'returns minimal book',
      ),
      procedure(() async {
        when(
          () => http.get(any()),
        ).thenAnswer(
          (_) async => Response('{"items":[{}]}', 200),
        );

        final expected = right(const BGoogleBook(title: '', isbn: 1));

        final actual = await client.fetchBookByISBN(1);

        expect(actual, expected);
      }),
    );

    test(
      requirement(
        Given: 'Google Books has match with all fields',
        When: 'fetch book by ISBN',
        Then: 'returns filled book',
      ),
      procedure(() async {
        when(
          () => http.get(any()),
        ).thenAnswer(
          (_) async => Response(
            '''
              {"items": [{"volumeInfo": {
                  "title": "A",
                  "subtitle": "B",
                  "authors": ["C"],
                  "illustrators": ["D"],
                  "publisher": "E",
                  "publishedDate": "2024",
                  "categories": ["F"],
                  "description": "G",
                  "language": "H",
                  "pageCount": 1,
                  "imageLinks": {"medium": "I", "thumbnail": "J"}
              }}]}
            ''',
            200,
          ),
        );

        final expected = right(
          BGoogleBook(
            title: 'A',
            isbn: 1,
            subtitle: 'B',
            authors: ['C'],
            illustrators: ['D'],
            publisher: 'E',
            publishedDate: DateTime(2024),
            categories: ['F'],
            description: 'G',
            language: 'H',
            pageCount: 1,
            imageURL: 'I',
            thumbnailURL: 'J',
          ),
        );

        final actual = await client.fetchBookByISBN(1);

        expect(actual, expected);
      }),
    );
  });
}
