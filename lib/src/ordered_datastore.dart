import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:opencloud_api_wrapper/src/datastore.dart';
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

  Future<String> listAsync({int? maxPageSize = 10, String? pageToken, String? orderBy}) async {
    int universeId = universe.universeId;
    String apiKey = universe.apiKey;

    String baseUrl = '$ORDERED_DATASTORE_API_BASE_ENDPOINT';

    return baseUrl;
  }
}
