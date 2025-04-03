import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_module_taxons_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/state/taxon_download_status.dart';

final taxonServiceProvider =
    StateNotifierProvider<TaxonService, TaxonDownloadStatus>(
  (ref) => TaxonService(
    ref.watch(getModuleTaxonsUseCaseProvider),
  ),
);

class TaxonService extends StateNotifier<TaxonDownloadStatus> {
  final GetModuleTaxonsUseCase _getModuleTaxonsUseCase;

  TaxonService(this._getModuleTaxonsUseCase)
      : super(const TaxonDownloadStatus.initial());

  Future<List<Taxon>> getModuleTaxons(int moduleId) async {
    try {
      final taxons = await _getModuleTaxonsUseCase.execute(moduleId);
      return taxons;
    } catch (e) {
      return [];
    }
  }

  Future<String?> getTaxonDisplayName(Taxon taxon, String displayMode) async {
    switch (displayMode) {
      case 'nom_vern,lb_nom':
        return taxon.nomVern?.isNotEmpty == true
            ? '${taxon.nomVern} (${taxon.lbNom})'
            : taxon.lbNom;
      case 'lb_nom':
        return taxon.lbNom;
      case 'nom_complet':
        return taxon.nomComplet;
      default:
        return taxon.nomComplet;
    }
  }
}
