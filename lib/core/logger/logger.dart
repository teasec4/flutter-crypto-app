abstract interface class Logger {
  void debug(String message);
  void info(String message);
  void warning(String message);
  void error(String message, [StackTrace? stackTrace]);
}

// ignore: avoid_print
class ConsoleLogger implements Logger {
  @override
  void debug(String message) {
    // ignore: avoid_print
    print('🐛 DEBUG: $message');
  }

  @override
  void info(String message) {
    // ignore: avoid_print
    print('ℹ️ INFO: $message');
  }

  @override
  void warning(String message) {
    // ignore: avoid_print
    print('⚠️ WARNING: $message');
  }

  @override
  void error(String message, [StackTrace? stackTrace]) {
    // ignore: avoid_print
    print('❌ ERROR: $message');
    if (stackTrace != null) {
      // ignore: avoid_print
      print('Stack trace: $stackTrace');
    }
  }
}
