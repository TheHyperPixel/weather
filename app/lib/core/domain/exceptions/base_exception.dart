import 'package:equatable/equatable.dart';

class BaseException extends Equatable implements Exception {
  final dynamic originalException;

  const BaseException({this.originalException});

  @override
  String toString() => this.originalException.toString();

  @override
  List<Object?> get props => [];
}
