import 'package:gn_mobile_monitoring/domain/model/base_site.dart';

abstract class GetSitesUseCase {
  Future<List<BaseSite>> execute();
}
