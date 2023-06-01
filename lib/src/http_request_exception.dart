/// An exception thrown when an HTTP request fails.
///
/// [universeId] specifies the id of the universe for which the request failed.
/// [statusCode] (optional) specifies the HTTP status code of the failed request.
class HttpRequestException implements Exception {
  final int universeId;
  final int? statusCode;
  final String? reasonPhrase;

  HttpRequestException({required this.universeId, this.statusCode, this.reasonPhrase});

  @override
  String toString() {
    // Construct and return an error message with the status code and universe id
    return 'Error: [$statusCode] $reasonPhrase. UniverseId: $universeId.';
  }
}
