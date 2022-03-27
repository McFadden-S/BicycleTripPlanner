enum SearchType {
  current,
}

extension SearchTypeExtension on SearchType {

  /**
   * method returns a description depending on the enum SearchType specified
   * @return String description
   */
  String get description {
    switch (this) {
      case SearchType.current:
        return "My current location";
    }
  }
}
