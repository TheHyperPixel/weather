class UserStoragePermissionException implements Exception {
  final dynamic originalException;

  UserStoragePermissionException({this.originalException});

  @override
  String toString() => this.originalException.toString();
}
