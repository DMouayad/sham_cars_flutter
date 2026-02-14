import 'package:flutter/foundation.dart';

/// A global notifier to track internet connectivity status.
///
/// It is set to `false` in [RestClient] when a [SocketException] is caught,
/// indicating no internet access. It is set back to `true` on a successful
/// request.
///
/// The `MaterialApp.builder` in `app.dart` listens to this notifier to show
/// a [NoInternetBanner] when the value is `false`.
final internetAccessNotifier = ValueNotifier<bool>(true);
