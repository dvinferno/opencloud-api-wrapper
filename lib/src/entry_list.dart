class EntryList {
  final List<Entry> entries;
  final String nextPageCursor;

  EntryList({required this.entries, required this.nextPageCursor});

  factory EntryList.fromJson(Map<String, dynamic> json) {
    final List<Entry> list = [];
    json['keys'].forEach((element) => list.add(Entry(key: element['key'], scope: element['scope'])));

    return EntryList(entries: list, nextPageCursor: json['nextPageCursor']);
  }

  @override
  String toString() {
    return {"entries": entries.toString(), "cursor": nextPageCursor}.toString();
  }
}

class Entry {
  final String key;
  String? scope;
  int? value;
  String? path;

  // Constructor with named parameters
  Entry({required this.key, this.scope});

  // Named constructor for ordered datastore
  Entry.orderedDatastore({required this.key, this.value, this.path});

  // Override toString method to return a string representation of the object
  @override
  String toString() {
    return {
      "key": key,
      if (value != null) 'value': value,
      if (path != null) 'path': path,
      if (scope != null) 'scope': scope
    }.toString();
  }
}
