class UserProfileNotDeletedException implements Exception {
  final dynamic originalException;

  UserProfileNotDeletedException({required this.originalException});

  @override
  String toString() => this.originalException.toString();
}
