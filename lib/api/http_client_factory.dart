import 'dart:io';

import 'package:cronet_http/cronet_http.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as io_client;

const _maxCacheSize = 2 * 1024 * 1024;

http.Client httpClient() {
  if (Platform.isAndroid) {
    final engine = CronetEngine.build(
      cacheMode: CacheMode.memory,
      enablePublicKeyPinningBypassForLocalTrustAnchors: true,
      cacheMaxSize: _maxCacheSize,
      userAgent: 'Hguide Agent',
    );
    return CronetClient.fromCronetEngine(engine);
  }

  return io_client.IOClient(HttpClient()..userAgent = 'Hguide Agent');
}
