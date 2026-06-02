class AppException implements Exception {
  final String message;
  final String? code;
  const AppException(this.message, {this.code});
  @override
  String toString() => 'AppException: $message (code: $code)';
}
class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error occurred'])
      : super(code: 'network_error');
}
class AuthException extends AppException {
  const AuthException([super.message = 'Authentication failed'])
      : super(code: 'auth_error');
}
class LimitExceededException extends AppException {
  const LimitExceededException([super.message = 'Daily limit exceeded'])
      : super(code: 'limit_exceeded');
}
class TranslationException extends AppException {
  const TranslationException([super.message = 'Translation failed'])
      : super(code: 'translation_error');
}
class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found'])
      : super(code: 'not_found');
}
