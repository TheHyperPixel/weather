import 'package:app/core/domain/exceptions/base_exception.dart';

class ApiClientException extends BaseException {
  const ApiClientException({super.originalException});
}
