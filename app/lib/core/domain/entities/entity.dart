import 'package:equatable/equatable.dart';

abstract class Entity implements Equatable {
  final String uuid;

  Entity({
    required this.uuid,
  });

  @override
  List<Object?> get props => [this.uuid];

  @override
  bool? get stringify => false;
}
