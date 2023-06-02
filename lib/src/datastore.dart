import 'dart:convert';

import 'package:http/http.dart' as http;
import 'entry_list.dart';
import 'http_request_exception.dart';
import 'universe.dart';
import 'urls.dart';

/// A class representing a datastore in a Universe.
class Datastore {
  /// The Universe this Datastore belongs to.
  final Universe universe;

  /// The name of this Datastore.
  final String datastoreName;

  /// The scope of this Datastore, Defaults to "global".
  final String scope;

  /// Whether to include all scopes when listing entries.
  final bool allScopes;

  /// Creates a new instance of the Datastore class.
  ///
  /// [universe] and [datastoreName] are required. [scope] defaults to "global"
  /// and [allScopes] defaults to false.
  Datastore({
    required this.universe,
    required this.datastoreName,
    this.scope = "global",
    this.allScopes = false,
  });

  /// Lists entries in this Datastore asynchronously.
  ///
  /// [prefix] filters entries by prefix. [limit] limits the number of entries
  /// returned (defaults to 1). [cursor] specifies the starting point for
  /// listing entries.
  Future<EntryList> listAsync({String? prefix, int? limit = 1, String? cursor}) async {
    int universeId = universe.universeId;
    String apiKey = universe.apiKey;

    // Construct the base URL with limit parameter
    String baseUrl =
        '$DATASTORE_API_BASE_ENDPOINT/$universeId/standard-datastores/datastore/entries?datastoreName=$datastoreName&limit=$limit';

    // Add prefix and cursor parameters if provided
    (allScopes) ? baseUrl += '&allScopes=$allScopes' : baseUrl += '&scope=$scope';
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
    final responseJson = json.decode(response.body) as Map<String, dynamic>;
    return EntryList.fromJson(responseJson);
  }

  /// Gets an entry from this Datastore asynchronously.
  ///
  /// [key] specifies the key of the entry to get.
  Future<Map<String, dynamic>> getAsync({required String key}) async {
    int universeId = universe.universeId;
    String apiKey = universe.apiKey;

    // Construct the base URL with limit parameter
    String baseUrl =
        '$DATASTORE_API_BASE_ENDPOINT/$universeId/standard-datastores/datastore/entries/entry?datastoreName=$datastoreName&entryKey=$key';

    // Parse the URL and send a GET request with the API key header
    final endpoint = Uri.parse(baseUrl);
    final response = await http.get(endpoint, headers: {'x-api-key': apiKey});

    // Throw an exception if the response status code is not 200
    if (response.statusCode != 200) {
      throw HttpRequestException(
          universeId: universeId, statusCode: response.statusCode, reasonPhrase: response.reasonPhrase);
    }

    // Decode the response body and create a DatastoreList object from it
    final responseJson = json.decode(response.body) as Map<String, dynamic>;
    return responseJson;
  }
}
