import 'dart:convert';

import 'package:http/http.dart' as http;
import 'urls.dart';

/// Defines a Universe object that requires a universeId and an apiKey for authentication of API calls.
class Universe {
  /// The universeId the datastore belongs to. Do not mistake it for place id.
  final int universeId;

  /// The key used to authenticate API calls made to the universe.
  final String apiKey;

  /// Constuctor for a universe object
  ///
  /// Requires a [universeId], not to be mistaken for place id,
  /// and an [apiKey], which is
  /// used to authenticate API calls.
  Universe({required this.universeId, required this.apiKey});

  /// Asynchronously lists data stores with optional filters.
  ///
  /// [prefix] (optional) filters data stores by prefix.
  /// [limit] (optional) limits the number of data stores returned. Default is 1.
  /// [cursor] (optional) specifies the pagination cursor for the next page of data stores.
  Future<DatastoreList> listDataStoresAsync({String? prefix, int? limit = 1, String? cursor}) async {
    // Construct the base URL with limit parameter
    String baseUrl = '$DATASTORE_API_BASE_ENDPOINT/$universeId/standard-datastores?limit=$limit';

    // Add prefix and cursor parameters if provided
    if (prefix != null) baseUrl += '&prefix=$prefix';
    if (cursor != null) baseUrl += '&cursor=$cursor';

    // Parse the URL and send a GET request with the API key header
    final endpoint = Uri.parse(baseUrl);
    final response = await http.get(endpoint, headers: {'x-api-key': apiKey});

    // Throw an exception if the response status code is not 200
    if (response.statusCode != 200) {
      throw HttpRequestException(
          universeId: universeId, statusCode: response.statusCode, reasonPhrase: response.reasonPhrase);
    }

    // Decode the response body and create a DatastoreList object from it
    final reponseJson = json.decode(response.body) as Map<String, dynamic>;
    return DatastoreList.fromJson(reponseJson);
  }
}

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

/// A list of data stores with a pagination cursor for the next page.
///
/// [datastores] specifies the list of data stores.
/// [nextPageCursor] specifies the pagination cursor for the next page of data stores.
class DatastoreList {
  final List<DatastoreDict> datastores;
  final String nextPageCursor;

  DatastoreList({required this.datastores, required this.nextPageCursor});

  /// Creates a DatastoreList object from a JSON map.
  factory DatastoreList.fromJson(Map<String, dynamic> json) {
    // Create a list of DatastoreDict objects from the JSON data
    final List<DatastoreDict> list = [];
    json['datastores'].forEach((element) => list.add(DatastoreDict.fromDict(element)));

    // Return a new DatastoreList object with the datastores and nextPageCursor
    return DatastoreList(datastores: list, nextPageCursor: json['nextPageCursor']);
  }
}

/// A data store with its name and creation time.
///
/// [name] specifies the name of the data store.
/// [createdTime] specifies the creation time of the data store.
class DatastoreDict {
  final String name;
  final String createdTime;

  DatastoreDict({required this.name, required this.createdTime});

  /// Creates a DatastoreDict object from a map.
  factory DatastoreDict.fromDict(Map<String, dynamic> map) {
    // Return a new DatastoreDict object with the name and createdTime from the map
    return DatastoreDict(name: map['name']!, createdTime: map['createdTime']!);
  }
}
