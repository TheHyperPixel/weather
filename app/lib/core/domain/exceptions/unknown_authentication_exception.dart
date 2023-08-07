import 'package:app/core/domain/exceptions/base_exception.dart';

class UnknownAuthenticationException extends BaseException {
  const UnknownAuthenticationException(final dynamic originalException)
      : super(originalException: originalException);

  @override
  String toString() => this.originalException.toString();
}
