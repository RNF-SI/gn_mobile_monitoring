import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/domain/model/individual.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/individual_detail_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';

class IndividualDetailPage extends ConsumerStatefulWidget {
  final Individual individual;
  final ModuleInfo moduleInfo;

  const IndividualDetailPage({
    Key? key,
    required this.individual,
    required this.moduleInfo,
  }) : super(key: key);

  @override
  ConsumerState<IndividualDetailPage> createState() => _IndividualDetailPageState();
}

class _IndividualDetailPageState extends ConsumerState<IndividualDetailPage> {
  @override
  void initState() {
    super.initState();
    // Refresh data when page is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(individualDetailViewModelProvider(widget.individual).notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final individualsState = ref.watch(individualDetailViewModelProvider(widget.individual));

    // Récupérer la configuration pour personnaliser les libellés
    final module = widget.moduleInfo.module;

    // Configuration des groupes de individuals pour les libellés
    final individualConfig = module.complement?.configuration?.individual;
    Map<String, dynamic> parsedGroupConfig = {};

    // if (individualConfig != null) {
    //   parsedGroupConfig = FormConfigParser.generateUnifiedSchema(
    //       individualConfig);
    // }

    final String groupNameLabel =
        parsedGroupConfig.containsKey('individual_name')
            ? parsedGroupConfig['individual_name']['attribut_label'] ??
                'Nom de l''individu'
            : 'Nom de l''individu';

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.moduleInfo.module.complement?.configuration?.individual?.label ?? 'Individu'}: ${widget.individual.individualName ?? 'Détail de l''individu'}'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fil d'Ariane pour la navigation
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: BreadcrumbNavigation(
                  items: [
                    BreadcrumbItem(
                      label: 'Module',
                      value: widget.moduleInfo.module.moduleLabel ?? 'Module',
                      onTap: () {
                        Navigator.of(context)
                            .pop(); // Retour à la page précédente
                      },
                    ),
                    BreadcrumbItem(
                      label: widget.moduleInfo.module.complement?.configuration
                              ?.individual?.label ??
                          'Individu',
                      value: widget.individual.individualName ??
                          'Individu',
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Group Properties Card
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        widget.moduleInfo.module.complement?.configuration?.individual
                                ?.label ??
                            'Propriétés de l''individu',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildPropertyRow(
                        groupNameLabel, widget.individual.individualName ?? '')
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // Widget _buildSitesTable(
  //   List<BaseSite> individuals,
  //   BuildContext context,
  //   String baseSiteNameLabel,
  //   String baseSiteCodeLabel,
  // ) {
  //   if (individuals.isEmpty) {
  //     return const Center(
  //       child: Text('Aucun individual associé à ce groupe'),
  //     );
  //   }

  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: SingleChildScrollView(
  //       child: Table(
  //         columnWidths: const {
  //           0: FixedColumnWidth(80), // Action column
  //           1: FlexColumnWidth(80), // Name column
  //           2: FixedColumnWidth(100), // Code column
  //           3: FixedColumnWidth(120), // Description column
  //         },
  //         children: [
  //           TableRow(
  //             children: [
  //               const Padding(
  //                 padding:
  //                     EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
  //                 child: Text('Action',
  //                     style: TextStyle(fontWeight: FontWeight.bold)),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(vertical: 8.0),
  //                 child: Text(baseSiteNameLabel,
  //                     style: const TextStyle(fontWeight: FontWeight.bold)),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(vertical: 8.0),
  //                 child: Text(baseSiteCodeLabel,
  //                     style: const TextStyle(fontWeight: FontWeight.bold)),
  //               ),
  //               const Padding(
  //                 padding: EdgeInsets.symmetric(vertical: 8.0),
  //                 child: Text('Description',
  //                     style: TextStyle(fontWeight: FontWeight.bold)),
  //               ),
  //             ],
  //           ),
  //           ...individuals.map((individual) => TableRow(
  //                 children: [
  //                   Container(
  //                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //                     height: 48,
  //                     alignment: Alignment.center,
  //                     child: IconButton(
  //                       icon: const Icon(Icons.visibility, size: 20),
  //                       onPressed: () {
  //                         Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                             builder: (context) => SiteDetailPage(
  //                               individual: individual,
  //                               moduleInfo: widget.moduleInfo,
  //                               fromIndividual:
  //                                   widget.individual, // Passer le groupe de individuals avec le nom correct du paramètre
  //                             ),
  //                           ),
  //                         );
  //                       },
  //                       padding: EdgeInsets.zero,
  //                       constraints: const BoxConstraints(
  //                         minWidth: 36,
  //                         minHeight: 36,
  //                       ),
  //                       tooltip: 'Voir les détails',
  //                     ),
  //                   ),
  //                   Container(
  //                     height: 48,
  //                     alignment: Alignment.centerLeft,
  //                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //                     child: Text(individual.baseSiteName ?? ''),
  //                   ),
  //                   Container(
  //                     height: 48,
  //                     alignment: Alignment.centerLeft,
  //                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //                     child: Text(individual.baseSiteCode ?? ''),
  //                   ),
  //                   Container(
  //                     height: 48,
  //                     alignment: Alignment.centerLeft,
  //                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //                     child: Text(
  //                       individual.baseSiteDescription != null &&
  //                               individual.baseSiteDescription!.isNotEmpty
  //                           ? individual.baseSiteDescription!.length > 25
  //                               ? '${individual.baseSiteDescription!.substring(0, 22)}...'
  //                               : individual.baseSiteDescription!
  //                           : '-',
  //                       overflow: TextOverflow.ellipsis,
  //                     ),
  //                   ),
  //                 ],
  //               )),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
