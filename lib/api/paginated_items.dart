import 'package:sham_cars/api/rest_client.dart';
import 'package:sham_cars/utils/utils.dart';

class PaginatedItems<T> {
  final List<T> items;
  final int perPage;
  final String firstPageUrl;
  final String? lastPageUrl;
  final String? nextPageUrl;
  final String? prevPageUrl;
  final int? lastPage;
  final int? total;
  final int? from;
  final int? to;
  bool get hasNextPage => nextPageUrl != null;
  bool get hasPrevPage => prevPageUrl != null;

  const PaginatedItems({
    required this.items,
    required this.total,
    required this.perPage,
    required this.lastPage,
    required this.firstPageUrl,
    this.lastPageUrl,
    this.nextPageUrl,
    this.prevPageUrl,
    this.from,
    this.to,
  });
  factory PaginatedItems.empty() => const PaginatedItems(
    items: [],
    total: 0,
    perPage: 0,
    lastPage: 0,
    firstPageUrl: '',
    lastPageUrl: '',
    nextPageUrl: '',
    prevPageUrl: '',
    from: 0,
    to: 0,
  );

  static PaginatedItems<T> fromJson<T>(
    dynamic json,
    T Function(dynamic json) itemFromJson,
  ) {
    if (json case {
      "items": List items,
      "total": int? total,
      "perPage": int perPage,
      "firstPageUrl": String firstPageUrl,
      "lastPageUrl": String? lastPageUrl,
      "nextPageUrl": String? nextPageUrl,
      "prevPageUrl": String? prevPageUrl,
      "lastPage": int? lastPage,
      "from": int? from,
      "to": int? to,
    }) {
      return PaginatedItems(
        items: items.map(itemFromJson).whereType<T>().toList(),
        total: total,
        perPage: perPage,
        lastPage: lastPage,
        firstPageUrl: firstPageUrl,
        lastPageUrl: lastPageUrl,
        nextPageUrl: nextPageUrl,
        prevPageUrl: prevPageUrl,
        from: from,
        to: to,
      );
    }
    pLogger.e('Failed to parse json to PaginatedItems');
    return PaginatedItems.empty();
  }

  JsonObject toJson({required JsonObject Function(T item) itemToJson}) =>
      JsonObject.from({
        "items": items.map(itemToJson).toList(),
        "perPage": perPage,
        "total": total,
        "lastPage": lastPage,
        "firstPageUrl": firstPageUrl,
        "lastPageUrl": lastPageUrl,
        "nextPageUrl": nextPageUrl,
        "prevPageUrl": prevPageUrl,
        "from": from,
        "to": to,
      });
}
