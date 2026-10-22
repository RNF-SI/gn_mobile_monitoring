import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../e2e_test_app_real.dart';
import 'real_auth_e2e_test.dart' as auth;
import 'real_download_fidelity_e2e_test.dart' as download_fidelity;
import 'real_many_taxa_e2e_test.dart' as many_taxa;
import 'real_module_browsing_e2e_test.dart' as module_browsing;
import 'real_module_not_configured_e2e_test.dart' as module_not_configured;
import 'real_multi_module_stress_e2e_test.dart' as multi_module_stress;
import 'real_observation_workflow_e2e_test.dart' as observation_workflow;
import 'real_protocol_roundtrip_e2e_test.dart' as protocol_roundtrip;
import 'real_site_group_e2e_test.dart' as site_group;
import 'real_site_group_module_filtering_e2e_test.dart' as site_group_module_filtering;
import 'real_site_management_e2e_test.dart' as site_management;
import 'real_site_roundtrip_e2e_test.dart' as site_roundtrip;
import 'real_sync_download_e2e_test.dart' as sync_download;
import 'real_sync_upload_e2e_test.dart' as sync_upload;
import 'real_upload_roundtrip_e2e_test.dart' as upload_roundtrip;
import 'real_visit_workflow_e2e_test.dart' as visit_workflow;

/// Tous les scénarios réels dans un seul binaire : la CI (e2e_real_tests.yml)
/// ne compile l'app qu'une fois par module. En local, chaque fichier se lance
/// aussi seul (run_real_e2e_tests.sh).
///
/// Le module testé est le premier de TEST_MODULE_CODES ; le scénario
/// multi-modules ne tourne que si la liste en contient plusieurs.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final multiModule = RealE2EConfig.load().moduleCodes.length > 1;

  group('auth', auth.main);
  group('download_fidelity', download_fidelity.main);
  group('many_taxa', many_taxa.main);
  group('module_browsing', module_browsing.main);
  group('module_not_configured', module_not_configured.main);
  if (multiModule) group('multi_module_stress', multi_module_stress.main);
  group('observation_workflow', observation_workflow.main);
  group('protocol_roundtrip', protocol_roundtrip.main);
  group('site_group', site_group.main);
  group('site_group_module_filtering', site_group_module_filtering.main);
  group('site_management', site_management.main);
  group('site_roundtrip', site_roundtrip.main);
  group('sync_download', sync_download.main);
  group('sync_upload', sync_upload.main);
  group('upload_roundtrip', upload_roundtrip.main);
  group('visit_workflow', visit_workflow.main);
}
