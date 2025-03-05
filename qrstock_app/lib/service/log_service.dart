import 'package:logger/logger.dart';

class LogService {
  static final Logger _logger = Logger();

  static void info(String message) {
    _logger.i(message);
  }

  static void error(String message) {
    _logger.e(message);
  }
}
