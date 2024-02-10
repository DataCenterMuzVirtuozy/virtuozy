


 import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/domain/repository/user_repository.dart';

import '../utils/user_util.dart';

class UserRepositoryImpl extends UserRepository{

  final _util = locator.get<UserUtil>();

  @override
  Future<UserEntity> getUser() async {
    return await _util.getUser();
  }

}