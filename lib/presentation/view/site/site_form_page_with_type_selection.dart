import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/site/site_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/site_type_selector.dart';

/// Valeur sentinelle indiquant qu'aucun type de site n'est requis
const int _noTypeSelection = -1;

/// Page qui gère la sélection du type de site avant d'afficher le formulaire
class SiteFormPageWithTypeSelection extends StatefulWidget {
  final BaseSite? site; // En mode édition, site existant
  final ObjectConfig siteConfig;
  final CustomConfig? customConfig;
  final int? moduleId;
  final ModuleInfo? moduleInfo;
  final SiteGroup? siteGroup;

  const SiteFormPageWithTypeSelection({
    super.key,
    this.site,
    required this.siteConfig,
    this.customConfig,
    this.moduleId,
    this.moduleInfo,
    this.siteGroup,
  });

  @override
  State<SiteFormPageWithTypeSelection> createState() =>
      _SiteFormPageWithTypeSelectionState();
}

class _SiteFormPageWithTypeSelectionState
    extends State<SiteFormPageWithTypeSelection> {
  int? _selectedSiteTypeId;

  @override
  void initState() {
    super.initState();
    final typesSite = widget.moduleInfo?.module.complement?.configuration?.module?.typesSite;
    if (typesSite == null || typesSite.isEmpty) {
      // Pas de types_site configurés : afficher le formulaire directement sans sélection de type
      // (comportement identique à l'ancien SiteFormPage)
      _selectedSiteTypeId = _noTypeSelection;
    } else if (typesSite.length == 1) {
      // Si un seul type est disponible, le sélectionner automatiquement
      _selectedSiteTypeId = int.tryParse(typesSite.keys.first);
      // Fallback : si le parsing échoue, afficher le formulaire sans type
      _selectedSiteTypeId ??= _noTypeSelection;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si le type est déjà sélectionné (automatiquement ou manuellement), afficher le formulaire
    if (_selectedSiteTypeId != null) {
      return SiteFormPage(
        site: widget.site,
        siteConfig: widget.siteConfig,
        customConfig: widget.customConfig,
        moduleId: widget.moduleId,
        moduleInfo: widget.moduleInfo,
        siteGroup: widget.siteGroup,
        // Ne pas passer la valeur sentinelle _noTypeSelection comme vrai type
        selectedSiteTypeId: _selectedSiteTypeId == _noTypeSelection
            ? null
            : _selectedSiteTypeId,
      );
    }

    // Sinon, afficher le sélecteur de type
    if (widget.moduleInfo == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Nouveau site'),
        ),
        body: const Center(
          child: Text('Module info manquant'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.siteConfig.label ?? 'Nouveau site'),
      ),
      body: SiteTypeSelector(
        moduleInfo: widget.moduleInfo!,
        onSiteTypeSelected: (siteTypeId) {
          setState(() {
            _selectedSiteTypeId = siteTypeId;
          });
        },
      ),
    );
  }
}
