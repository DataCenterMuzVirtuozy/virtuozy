


 import 'package:virtuozy/data/mappers/user_mapper.dart';
import 'package:virtuozy/data/services/user_service.dart';
import 'package:virtuozy/di/locator.dart';

import '../../domain/entities/user_entity.dart';

class UserUtil{

    final _service = locator.get<UserService>();


    Future<UserEntity> getUser() async {
       final model = await _service.getUser();
       return UserMapper.fromApi(userModel: model);
    }

 }