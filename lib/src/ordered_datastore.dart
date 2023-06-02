import 'dart:convert';

import 'package:http/http.dart' as http;
import 'http_request_exception.dart';
import 'universe.dart';
import 'urls.dart';

/// A class representing a ordered datastore in a Universe.
class OrderedDatastore {
  /// The Universe this OrderedDatastore belongs to.
  final Universe universe;

  /// The name of this OrderedDatastore.
  final String orderedDatastoreName;

  /// The scope of this OrderedDatastore, Defaults to "global".
  final String scope;

  /// Creates a new instance of the OrderedDatastore class.
  ///
  /// [universe] and [orderedDatastoreName] are required. [scope] defaults to "global".
  OrderedDatastore({required this.universe, required this.orderedDatastoreName, this.scope = "global"});

  Future<Map<String, dynamic>> listAsync({int? maxPageSize = 10, String? pageToken, String? orderBy}) async {
    int universeId = universe.universeId;
    String apiKey = universe.apiKey;

    // Construct the base URL with maxPageSize parameter
    String baseUrl =
        '$ORDERED_DATASTORE_API_BASE_ENDPOINT/$universeId/orderedDataStores/$orderedDatastoreName/scopes/$scope/entries?max_page_size=$maxPageSize';

    // Add pageToken and orderBy parameters if provided
    if (pageToken != null) baseUrl += '&page_token=$pageToken';
    if (orderBy != null) baseUrl += '&order_by=$orderBy';

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
