import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchQuery extends Notifier<String> {
  @override
  String build() => ""; // начальное значение

  void set(String value) => state = value;
  void clear() => state = "";
}

final searchQueryProvider =
    NotifierProvider<SearchQuery, String>(SearchQuery.new);