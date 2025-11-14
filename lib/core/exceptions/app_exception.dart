/// Base exception for the application
abstract class AppException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  AppException(this.message, [this.stackTrace]);

  @override
  String toString() => 'AppException: $message';
}

/// Exception for network-related errors
class NetworkException extends AppException {
  NetworkException(super.message, [super.stackTrace]);

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception for timeout errors
class TimeoutException extends AppException {
  TimeoutException(super.message, [super.stackTrace]);

  @override
  String toString() => 'TimeoutException: $message';
}

/// Exception for server/API errors
class ApiException extends AppException {
  final int? statusCode;

  ApiException(String message, {this.statusCode, StackTrace? stackTrace})
      : super(message, stackTrace);

  @override
  String toString() =>
      'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Generic unknown exception
class UnknownException extends AppException {
  UnknownException(super.message, [super.stackTrace]);

  @override
  String toString() => 'UnknownException: $message';
}
