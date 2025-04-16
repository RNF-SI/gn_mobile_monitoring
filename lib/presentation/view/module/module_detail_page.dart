import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/module/module_detail_page_base.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ModuleDetailPage extends ConsumerStatefulWidget {
  final ModuleInfo moduleInfo;

  const ModuleDetailPage({super.key, required this.moduleInfo});

  @override
  ConsumerState<ModuleDetailPage> createState() => _ModuleDetailPageState();
}

class _ModuleDetailPageState extends ConsumerState<ModuleDetailPage> {
  final GlobalKey<ModuleDetailPageBaseState> _moduleDetailPageBaseStateKey =
      GlobalKey<ModuleDetailPageBaseState>();

  @override
  void initState() {
    super.initState();
    // Nous utilisons un callback après le build pour s'assurer que le widget est monté
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadModuleConfig();
    });
  }

  void _loadModuleConfig() {
    final moduleDetailPageBaseState =
        _moduleDetailPageBaseStateKey.currentState;
    if (moduleDetailPageBaseState != null) {
      // Injection du use case provenant du provider
      moduleDetailPageBaseState.getModuleWithConfigUseCase =
          ref.read(getModuleWithConfigUseCaseProvider);
      // Démarrer le chargement de la configuration
      moduleDetailPageBaseState.loadModuleWithConfig();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModuleDetailPageBase(
      key: _moduleDetailPageBaseStateKey,
      moduleInfo: widget.moduleInfo,
    );
  }
}
