abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'No internet connection'])
      : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure([String message = 'Authentication failed'])
      : super(message);
}

class LimitFailure extends Failure {
  const LimitFailure([String message = 'Daily AI limit reached'])
      : super(message);
}

class TranslationFailure extends Failure {
  const TranslationFailure([String message = 'Translation failed'])
      : super(message);
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error'])
      : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error'])
      : super(message);
}
