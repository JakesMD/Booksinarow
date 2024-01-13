/// Represents the different exceptions that can occur when fetching book data
/// from the Google Books API.
enum BGoogleBookFetchException {
  /// The book was not found in the Google Books API.
  notFound,

  /// The exact cause for the exception is unknown.
  unknown,
}
