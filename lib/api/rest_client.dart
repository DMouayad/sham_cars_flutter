import "dart:async";
import "dart:convert";
import "dart:developer";
import "dart:io";

import "package:sham_cars/api/config.dart";
import "package:sham_cars/utils/utils.dart";
import "package:http/http.dart" as http;
import "package:sham_cars/utils/src/http_utils.dart";
import "../utils/src/app_error.dart";

typedef JsonObject = Map<String, dynamic>;
typedef Cache = Map<String, Completer<dynamic>>;

class RestClient {
  final http.Client httpClient;

  const RestClient(this.httpClient);

  /// Run multiple requests with deduplication.
  /// If the same endpoint is requested multiple times within the body,
  /// only one HTTP request is made.
  static Future<R> runCached<R>(Future<R> Function() body) {
    final Cache cache = Zone.current[#_restClientCache] ?? {};
    return runZoned(body, zoneValues: {#_restClientCache: cache});
  }

  Future<JsonObject> request(
    HttpMethod method,
    dynamic pathOrParts, {
    Map<String, dynamic> body = const {},
    Map<String, String> query = const {},
    String? accessToken,
  }) async {
    final path = _buildPath(pathOrParts, query);
    final cacheKey = '${method.name}:$path';

    return await _runCached(cacheKey, () async {
      final uri = Uri.parse("${ApiConfig.baseUrl}$path");
      final request = http.Request(method.name, uri);

      request.headers.addAll(_headers);
      if (accessToken != null) {
        request.headers[HttpHeaders.authorizationHeader] =
            'Bearer $accessToken';
      }
      if (body.isNotEmpty) {
        request.body = jsonEncode(body);
      }

      log("$method $uri", name: 'Request');

      final response = await httpClient
          .send(request)
          .then(http.Response.fromStream);
      return _handleResponse(response);
    });
  }

  Future<List<JsonObject>> requestList(
    HttpMethod method,
    dynamic pathOrParts, {
    Map<String, String> query = const {},
    String? accessToken,
  }) async {
    final path = _buildPath(pathOrParts, query);
    final cacheKey = '${method.name}:$path';

    return await _runCached(cacheKey, () async {
      final uri = Uri.parse("${ApiConfig.baseUrl}$path");
      final request = http.Request(method.name, uri);

      request.headers.addAll(_headers);
      if (accessToken != null) {
        request.headers[HttpHeaders.authorizationHeader] =
            'Bearer $accessToken';
      }

      log("$method $uri", name: 'Request');

      final response = await httpClient
          .send(request)
          .then(http.Response.fromStream);
      final responseBody = await response.json();

      _checkForErrors(responseBody, response);

      if (response.isSuccess) {
        return List<JsonObject>.from(responseBody['data'] ?? []);
      }
      throw AppError.fromHttpResponse(response.statusCode);
    });
  }

  // Private helpers

  String _buildPath(dynamic pathOrParts, Map<String, String> query) {
    final path = pathOrParts is List
        ? joinPath(pathOrParts)
        : pathOrParts.toString();

    if (query.isEmpty) return path;

    final queryString = query.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
    return '$path?$queryString';
  }

  Future<JsonObject> _handleResponse(http.Response response) async {
    final responseBody = await response.json();

    _checkForErrors(responseBody, response);

    if (response.isSuccess) {
      final data = responseBody['data'];
      return data is JsonObject ? data : {};
    }

    _logUnknownApiErr(response);
    throw AppError.fromHttpResponse(response.statusCode);
  }

  void _checkForErrors(JsonObject responseBody, http.Response response) {
    if (responseBody['error'] case JsonObject error
        when error['errCode'] is String) {
      throw ApiError(
        appErr: AppError.fromApiErrCode(error['errCode']),
        extra: response,
        statusCode: response.statusCode,
      );
    }

    if (responseBody case {'message': final String message, 'success': false}) {
      throw ApiError(message: message, statusCode: response.statusCode);
    }
  }

  Future<T> _runCached<T>(String cacheKey, Future<T> Function() request) async {
    final Cache? cache = Zone.current[#_restClientCache];

    // No cache zone active, just run the request
    if (cache == null) return await request();

    // Check if request is already cached/in-flight
    if (cache.containsKey(cacheKey)) {
      final completer = cache[cacheKey]!;
      final status = completer.isCompleted ? "hit" : "in-flight";
      log("cache $status: $cacheKey", name: 'Request');
      return await completer.future as T;
    }

    // First request for this key - cache it
    final completer = Completer<T>();
    cache[cacheKey] = completer;

    try {
      final result = await request();
      completer.complete(result);
      return result;
    } catch (e) {
      completer.completeError(e);
      rethrow;
    }
  }

  void _logUnknownApiErr(http.Response response) {
    if (response.statusCode == HttpStatus.badRequest) {
      pLogger.i('Bad Request: ${jsonDecode(response.body)}');
    } else {
      pLogger.i('Failure ${response.statusCode}: ${response.body}');
    }
  }

  Map<String, String> get _headers => {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.acceptHeader: "application/json",
  };
}

enum HttpMethod {
  get('GET'),
  post('POST'),
  delete('DELETE'),
  patch('PATCH'),
  put('PUT');

  final String name;
  const HttpMethod(this.name);
}
