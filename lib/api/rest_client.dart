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
typedef Cache = Map<String, Completer<JsonObject>>;

class RestClient {
  final http.Client httpClient;

  static RestClient? _instance;

  const RestClient(this.httpClient);

  static RestClient get instance => _instance!;

  static RestClient init(http.Client httpClient) {
    return _instance ??= RestClient(httpClient);
  }

  Future<JsonObject> request(
    HttpMethod method,
    dynamic pathOrParts, {
    Map<String, dynamic> body = const {},
    String? accessToken,
  }) async {
    final path = pathOrParts is List
        ? joinPath(pathOrParts)
        : pathOrParts.toString();

    final uri = Uri.parse("${ApiConfig.baseUrl}$path");

    final request = http.Request(method.name, uri);

    request.headers.addAll(_headers);

    if (accessToken != null) {
      request.headers.addAll({
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      });
    }
    request.body = jsonEncode(body);
    log("$method $uri", name: 'Request Logger');

    final response = await httpClient
        .send(request)
        .then(http.Response.fromStream);

    final responseBody = await response.json();

    if (responseBody['error'] case JsonObject error
        when error['errCode'] is String) {
      if (AppError.fromApiErrCode(error['errCode'])
          case AppError appException) {
        throw ApiError(appErr: appException, extra: response);
      }
    }

    if (response.isSuccess) {
      final data = responseBody['data'];
      return data ?? {};
    }
    _logUnknownApiErr(response);
    throw AppError.fromHttpResponse(response.statusCode);
  }

  void _logUnknownApiErr(http.Response response) {
    if (response.statusCode == HttpStatus.badRequest) {
      pLogger.i('Bad Request: ${jsonDecode(response.body)}');
    } else {
      pLogger.i(
        'Response with Failure StatusCode ${response.statusCode}: ${response.body}',
      );
    }
  }

  Map<String, String> get _headers {
    return {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
    };
  }

  static R runCached<R>(R Function() body) {
    final Cache cache = Zone.current[#_restClientCache] ?? {};
    return runZoned(body, zoneValues: {#_restClientCache: cache});
  }

  Future<JsonObject> _runCached(
    String endpoint,
    Future<JsonObject> Function() body,
  ) async {
    final Cache? cache = Zone.current[#_restClientCache];

    if (cache == null) return await body();

    if (cache.containsKey(endpoint)) {
      final message = cache[endpoint]!.isCompleted
          ? "cache hit"
          : "cache hit (already running)";
      log("$message: $endpoint");

      return await cache[endpoint]!.future;
    }

    return await (cache[endpoint] = wrapInCompleter(body())).future;
  }
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
