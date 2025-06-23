import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: kDebugMode
        ? PrettyPrinter(
            methodCount: 2,
            errorMethodCount: 8,
            lineLength: 120,
            colors: true,
            printEmojis: true,
            dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
          )
        : SimplePrinter(),
  );

  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void auth(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i('🔐 AUTH: $message', error: error, stackTrace: stackTrace);
  }

  static void api(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i('🌐 API: $message', error: error, stackTrace: stackTrace);
  }

  static void performance(String message,
      [dynamic error, StackTrace? stackTrace]) {
    _logger.i('⚡ PERF: $message', error: error, stackTrace: stackTrace);
  }
}
