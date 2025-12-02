import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_use_case.dart';
import 'package:uuid/uuid.dart';

class CreateSiteUseCaseImpl implements CreateSiteUseCase {
  final SitesDatabase _sitesDatabase;

  const CreateSiteUseCaseImpl(this._sitesDatabase);

  @override
  Future<int> execute(BaseSite site) async {
    // Générer un UUID si aucun n'est fourni
    final uuid = const Uuid();
    final siteWithUuid = site.uuidBaseSite == null 
        ? site.copyWith(uuidBaseSite: uuid.v4())
        : site;
    
    // Insérer le site dans la base de données et récupérer l'ID
    final siteId = await _sitesDatabase.insertSite(siteWithUuid);
    
    // Retourner l'ID du site créé
    return siteId;
  }
}

