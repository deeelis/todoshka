import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(),
  );

  static void debug(String message) {
    if (!_logger.isClosed()) {
      _logger.d(message);
    }
  }

  static void info(String message) {
    if (!_logger.isClosed()) {
      _logger.i(message);
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (!_logger.isClosed()) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }

  static void disable() {
    if (!_logger.isClosed()) {
      _logger.close();
    }
  }
}
