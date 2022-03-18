enum SearchType {
  current,
}

extension SearchTypeExtension on SearchType {
  String get description {
    switch (this) {
      case SearchType.current:
        return "My current location";
    }
  }
}
