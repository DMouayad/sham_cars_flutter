import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:sham_cars/api/rest_client.dart';
import 'package:sham_cars/utils/src/app_error.dart';
import 'package:http/http.dart';

/// Converts the given elements to strings and joins them with slashes, ensuring
/// there is no consecutive or leading/trailing slashes
String joinPath(List<dynamic> parts) => parts
    .expand(
      (part) =>
          part.toString().split("/").where((innerPart) => innerPart.isNotEmpty),
    )
    .join("/");

Completer<T> wrapInCompleter<T>(Future<T> future) {
  final completer = Completer<T>();
  future.then(completer.complete).catchError(completer.completeError);
  return completer;
}

extension StatusClasses on BaseResponse {
  /// True for 2xx status codes
  bool get isSuccess => statusCode < 300 && statusCode >= 200;
}

extension JsonDecodeBodyStreamed on Response {
  /// Calls [jsonDecode] on the request body
  Future<JsonObject> json() {
    return switch (statusCode) {
      HttpStatus.notFound || HttpStatus.noContent => Future.value({}),
      HttpStatus.tooManyRequests => Future.error(
        ApiError(appErr: AppError.rateLimitExceeded, extra: this),
      ),
      _ => _tryDecodingResponse(),
    };
  }

  Future<JsonObject> _tryDecodingResponse() {
    try {
      return Future.value(switch (jsonDecode(body)) {
        String str => JsonObject.from({"message": str}),
        JsonObject jsonObj => jsonObj,
        _ => {},
      });
    } catch (e) {
      return Future.error(AppError.decodingJsonFailed, StackTrace.current);
    }
  }
}
