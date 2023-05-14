import 'package:flutter/foundation.dart';

/// logPrinter - makeshift logger
/// 
/// log - data to log
/// trace - optional log origin / 'stacktrace'
void logPrinter(dynamic log, {dynamic? trace}) {
  if (kDebugMode) {
    print('--------------------------');
    if (trace != null) print(trace);
    print(log);
    print('--------------------------');
  }
}
