import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/sites_group_module.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_group_use_case.dart';
import 'package:uuid/uuid.dart';

class CreateSiteGroupUseCaseImpl implements CreateSiteGroupUseCase {
  final SitesDatabase _sitesDatabase;

  const CreateSiteGroupUseCaseImpl(this._sitesDatabase);

  @override
  Future<int> execute(SiteGroup siteGroup) async {
    // Générer un UUID si aucun n'est fourni
    final uuid = const Uuid();
    final siteGroupWithUuid = siteGroup.uuidSitesGroup == null 
        ? siteGroup.copyWith(uuidSitesGroup: uuid.v4())
        : siteGroup;
    
    // Insérer le siteGroup dans la base de données et récupérer l'ID
    final siteGroupId = await _sitesDatabase.insertSiteGroup(siteGroupWithUuid);
    
    // Retourner l'ID du siteGroup créé
    return siteGroupId;
  }
}

