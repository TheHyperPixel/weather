import 'package:app/core/domain/entities/entity/entity.dart';

class UserAuth extends Entity {
  final String email;
  final String telephone;
  UserAuth({
    required String uuid,
    this.email = '',
    this.telephone = '',
  }) : super(uuid: uuid);
}
