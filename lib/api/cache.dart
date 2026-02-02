class ResponseCache {
  final Map<String, _CacheEntry> _cache = {};
  final Duration defaultTtl;

  ResponseCache({this.defaultTtl = const Duration(minutes: 5)});

  T? get<T>(String key) {
    final entry = _cache[key];
    if (entry == null) return null;
    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }
    return entry.data as T;
  }

  void set<T>(String key, T data, {Duration? ttl}) {
    _cache[key] = _CacheEntry(
      data: data,
      expiresAt: DateTime.now().add(ttl ?? defaultTtl),
    );
  }

  void invalidate(String key) => _cache.remove(key);

  void invalidatePrefix(String prefix) {
    _cache.removeWhere((key, _) => key.startsWith(prefix));
  }

  void clear() => _cache.clear();
}

class _CacheEntry {
  final dynamic data;
  final DateTime expiresAt;

  _CacheEntry({required this.data, required this.expiresAt});

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
