// ignore_for_file: avoid_dynamic_calls

import 'package:bpub/equatable.dart';
import 'package:bpub/meta.dart';

/// {@template BGoogleBook}
///
/// Represents a search result from the Google Books API.
///
/// {@endtemplate}
class BGoogleBook with EquatableMixin {
  /// {@macro BGoogleBook}
  const BGoogleBook({
    required this.title,
    this.isbn,
    this.subtitle,
    this.authors = const [],
    this.illustrators = const [],
    this.publisher,
    this.publishedDate,
    this.categories = const [],
    this.description,
    this.language,
    this.pageCount,
    this.imageURL,
    this.thumbnailURL,
  });

  /// Creates a [BGoogleBook] from a JSON map.
  ///
  /// {@macro BGoogleBook}
  @internal
  factory BGoogleBook.fromJson(int isbn, Map<String, dynamic> json) {
    final publishedDate = json['volumeInfo']?['publishedDate'] as String? ?? '';

    return BGoogleBook(
      isbn: isbn,
      title: (json['volumeInfo']?['title'] ?? '') as String,
      subtitle: json['volumeInfo']?['subtitle'] as String?,
      authors: List<String>.from(
        json['volumeInfo']?['authors'] as List? ?? [],
      ),
      illustrators: List<String>.from(
        json['volumeInfo']?['illustrators'] as List? ?? [],
      ),
      publisher: json['volumeInfo']?['publisher'] as String?,
      publishedDate:
          publishedDate.length == 4 && int.tryParse(publishedDate) != null
              ? DateTime(int.parse(publishedDate))
              : DateTime.tryParse(publishedDate),
      categories: List<String>.from(
        json['volumeInfo']?['categories'] as List? ?? [],
      ),
      description: json['volumeInfo']?['description'] as String?,
      language: json['volumeInfo']?['language'] as String?,
      pageCount: json['volumeInfo']?['pageCount'] as int?,
      thumbnailURL: (json['volumeInfo']?['imageLinks']?['thumbnail'] ??
          json['volumeInfo']?['imageLinks']?['smallThumbnail'] ??
          json['volumeInfo']?['imageLinks']?['small'] ??
          json['volumeInfo']?['imageLinks']?['medium'] ??
          json['volumeInfo']?['imageLinks']?['large'] ??
          json['volumeInfo']?['imageLinks']?['extraLarge']) as String?,
      imageURL: (json['volumeInfo']?['imageLinks']?['medium'] ??
          json['volumeInfo']?['imageLinks']?['small'] ??
          json['volumeInfo']?['imageLinks']?['large'] ??
          json['volumeInfo']?['imageLinks']?['extraLarge'] ??
          json['volumeInfo']?['imageLinks']?['thumbnail'] ??
          json['volumeInfo']?['imageLinks']?['smallThumbnail']) as String?,
    );
  }

  /// The ISBN of the book.
  final int? isbn;

  /// The title of the book.
  final String title;

  /// The subtitle of the book.
  final String? subtitle;

  /// The authors of the book.
  final List<String> authors;

  /// The illustrators of the book.
  final List<String> illustrators;

  /// The publisher of the book.
  final String? publisher;

  /// The date the book was published.
  final DateTime? publishedDate;

  /// The categories the book belongs to.
  final List<String> categories;

  /// A description of the book.
  ///
  /// Often this is the blurb at the back.
  final String? description;

  /// The language of the book.
  final String? language;

  /// The number of pages in the book.
  final int? pageCount;

  /// The URL to the thumbnail of the book.
  final String? thumbnailURL;

  /// The URL to the image of the book.
  final String? imageURL;

  @override
  List<Object?> get props => [
        isbn,
        title,
        subtitle,
        authors,
        illustrators,
        publisher,
        publishedDate,
        categories,
        description,
        language,
        pageCount,
        thumbnailURL,
        imageURL,
      ];

  // coverage:ignore-start
  @override
  String toString() {
    return '''
BGoogleBook(
  isbn: $isbn,
  title: $title,
  subtitle: $subtitle,
  authors: $authors,
  illustrators: $illustrators,
  publisher: $publisher,
  publishedDate: $publishedDate,
  categories: $categories,
  description: $description,
  language: $language,
  pageCount: $pageCount,
  thumbnailURL: $thumbnailURL,
  imageURL: $imageURL,
)
    ''';
  }
  // coverage:ignore-end
}
