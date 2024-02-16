


  import 'package:virtuozy/data/mappers/prices_direction_mapper.dart';
import 'package:virtuozy/data/services/finance_service.dart';
import 'package:virtuozy/domain/entities/prices_direction_entity.dart';

import '../../di/locator.dart';

class FinanceUtil{

   final _service = locator.get<FinanceService>();


   Future<PricesDirectionEntity> getSubscriptionsByDirection({required String nameDirection}) async {
     final result = await _service.getSubscriptionsByDirection(nameDirection: nameDirection);
     return PricesDirectionMapper.fromApi(model: result);
   }

  }