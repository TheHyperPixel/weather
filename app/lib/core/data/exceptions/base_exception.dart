class BaseException implements Exception {
  final dynamic originalException;

  const BaseException({this.originalException});

  @override
  String toString() => this.originalException.toString();
}
