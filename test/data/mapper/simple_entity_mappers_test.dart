import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/entity/taxon_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/nomenclature_type_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/taxon_list_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/visit_complement_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/cor_site_module_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/cor_sites_group_module_entity.dart';
import 'package:gn_mobile_monitoring/data/mapper/taxon_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/nomenclature_type_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/taxon_list_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/visit_complement_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/cor_site_module_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/cor_sites_group_module_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature_type.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon_list.dart';
import 'package:gn_mobile_monitoring/domain/model/visit_complement.dart';

void main() {
  group('TaxonEntityMapper', () {
    final entity = TaxonEntity(
      cdNom: 12345,
      cdRef: 12340,
      idStatut: 'P',
      idHabitat: 3,
      idRang: 'ES',
      regne: 'Animalia',
      phylum: 'Chordata',
      classe: 'Aves',
      ordre: 'Passeriformes',
      famille: 'Paridae',
      sousFamille: 'Parinae',
      tribu: 'Parini',
      cdTaxsup: 12300,
      cdSup: 12200,
      lbNom: 'Parus major',
      lbAuteur: 'Linnaeus, 1758',
      nomComplet: 'Parus major Linnaeus, 1758',
      nomCompletHtml: '<i>Parus major</i> Linnaeus, 1758',
      nomVern: 'Mesange charbonniere',
      nomValide: 'Parus major Linnaeus, 1758',
      nomVernEng: 'Great Tit',
      group1Inpn: 'Oiseaux',
      group2Inpn: 'Oiseaux',
      group3Inpn: 'Passereaux',
      url: 'https://inpn.mnhn.fr/espece/cd_nom/12345',
    );

    test('toDomain maps all fields correctly', () {
      final domain = entity.toDomain();

      expect(domain.cdNom, 12345);
      expect(domain.cdRef, 12340);
      expect(domain.idStatut, 'P');
      expect(domain.idHabitat, 3);
      expect(domain.idRang, 'ES');
      expect(domain.regne, 'Animalia');
      expect(domain.phylum, 'Chordata');
      expect(domain.classe, 'Aves');
      expect(domain.ordre, 'Passeriformes');
      expect(domain.famille, 'Paridae');
      expect(domain.sousFamille, 'Parinae');
      expect(domain.tribu, 'Parini');
      expect(domain.cdTaxsup, 12300);
      expect(domain.cdSup, 12200);
      expect(domain.lbNom, 'Parus major');
      expect(domain.lbAuteur, 'Linnaeus, 1758');
      expect(domain.nomComplet, 'Parus major Linnaeus, 1758');
      expect(domain.nomCompletHtml, '<i>Parus major</i> Linnaeus, 1758');
      expect(domain.nomVern, 'Mesange charbonniere');
      expect(domain.nomValide, 'Parus major Linnaeus, 1758');
      expect(domain.nomVernEng, 'Great Tit');
      expect(domain.group1Inpn, 'Oiseaux');
      expect(domain.group2Inpn, 'Oiseaux');
      expect(domain.group3Inpn, 'Passereaux');
      expect(domain.url, 'https://inpn.mnhn.fr/espece/cd_nom/12345');
    });

    test('toEntity maps all fields correctly', () {
      const domain = Taxon(
        cdNom: 99999,
        cdRef: 99990,
        nomComplet: 'Test taxon',
        regne: 'Plantae',
        famille: 'Rosaceae',
      );

      final result = domain.toEntity();

      expect(result.cdNom, 99999);
      expect(result.cdRef, 99990);
      expect(result.nomComplet, 'Test taxon');
      expect(result.regne, 'Plantae');
      expect(result.famille, 'Rosaceae');
    });

    test('roundtrip preserves all fields', () {
      final roundtripped = entity.toDomain().toEntity();

      expect(roundtripped.cdNom, entity.cdNom);
      expect(roundtripped.cdRef, entity.cdRef);
      expect(roundtripped.idStatut, entity.idStatut);
      expect(roundtripped.nomComplet, entity.nomComplet);
      expect(roundtripped.famille, entity.famille);
      expect(roundtripped.group3Inpn, entity.group3Inpn);
    });

    test('toDomain handles null optional fields', () {
      final minimalEntity = TaxonEntity(
        cdNom: 1,
        nomComplet: 'Minimal',
      );

      final domain = minimalEntity.toDomain();

      expect(domain.cdNom, 1);
      expect(domain.nomComplet, 'Minimal');
      expect(domain.cdRef, isNull);
      expect(domain.famille, isNull);
      expect(domain.nomVern, isNull);
      expect(domain.url, isNull);
    });
  });

  group('NomenclatureTypeEntityMapper', () {
    final now = DateTime(2024, 1, 15, 10, 30);
    final entity = NomenclatureTypeEntity(
      idType: 100,
      mnemonique: 'TYP_GRP',
      labelDefault: 'Type de groupe',
      definitionDefault: 'Definition du type',
      labelFr: 'Type de groupe FR',
      definitionFr: 'Definition FR',
      labelEn: 'Group type EN',
      definitionEn: 'Definition EN',
      labelEs: 'Tipo de grupo ES',
      definitionEs: 'Definicion ES',
      labelDe: 'Gruppentyp DE',
      definitionDe: 'Definition DE',
      labelIt: 'Tipo di gruppo IT',
      definitionIt: 'Definizione IT',
      source: 'SINP',
      statut: 'Validé',
      metaCreateDate: now,
      metaUpdateDate: now,
    );

    test('toDomain maps all fields correctly', () {
      final domain = entity.toDomain();

      expect(domain.idType, 100);
      expect(domain.mnemonique, 'TYP_GRP');
      expect(domain.labelDefault, 'Type de groupe');
      expect(domain.definitionDefault, 'Definition du type');
      expect(domain.labelFr, 'Type de groupe FR');
      expect(domain.definitionFr, 'Definition FR');
      expect(domain.labelEn, 'Group type EN');
      expect(domain.definitionEn, 'Definition EN');
      expect(domain.labelEs, 'Tipo de grupo ES');
      expect(domain.definitionEs, 'Definicion ES');
      expect(domain.labelDe, 'Gruppentyp DE');
      expect(domain.definitionDe, 'Definition DE');
      expect(domain.labelIt, 'Tipo di gruppo IT');
      expect(domain.definitionIt, 'Definizione IT');
      expect(domain.source, 'SINP');
      expect(domain.statut, 'Validé');
      expect(domain.metaCreateDate, now);
      expect(domain.metaUpdateDate, now);
    });

    test('toEntity maps all fields correctly', () {
      final domain = entity.toDomain();
      final result = domain.toEntity();

      expect(result.idType, entity.idType);
      expect(result.mnemonique, entity.mnemonique);
      expect(result.labelDefault, entity.labelDefault);
      expect(result.source, entity.source);
    });

    test('roundtrip preserves all fields', () {
      final roundtripped = entity.toDomain().toEntity();

      expect(roundtripped.idType, entity.idType);
      expect(roundtripped.mnemonique, entity.mnemonique);
      expect(roundtripped.labelFr, entity.labelFr);
      expect(roundtripped.metaCreateDate, entity.metaCreateDate);
    });

    test('toDomain handles null optional fields', () {
      final minimalEntity = NomenclatureTypeEntity(idType: 1);

      final domain = minimalEntity.toDomain();

      expect(domain.idType, 1);
      expect(domain.mnemonique, isNull);
      expect(domain.labelDefault, isNull);
      expect(domain.metaCreateDate, isNull);
    });
  });

  group('TaxonListEntityMapper', () {
    final entity = TaxonListEntity(
      idListe: 42,
      codeListe: 'LST_OISEAUX',
      nomListe: 'Liste des oiseaux',
      descListe: 'Liste taxonomique des oiseaux de France',
      regne: 'Animalia',
      group2Inpn: 'Oiseaux',
    );

    test('toDomain maps all fields correctly', () {
      final domain = entity.toDomain();

      expect(domain.idListe, 42);
      expect(domain.codeListe, 'LST_OISEAUX');
      expect(domain.nomListe, 'Liste des oiseaux');
      expect(domain.descListe, 'Liste taxonomique des oiseaux de France');
      expect(domain.regne, 'Animalia');
      expect(domain.group2Inpn, 'Oiseaux');
    });

    test('toEntity maps all fields correctly', () {
      const domain = TaxonList(
        idListe: 10,
        codeListe: 'TEST',
        nomListe: 'Test list',
        descListe: 'Description',
        regne: 'Plantae',
        group2Inpn: 'Plantes',
      );

      final result = domain.toEntity();

      expect(result.idListe, 10);
      expect(result.codeListe, 'TEST');
      expect(result.nomListe, 'Test list');
    });

    test('roundtrip preserves all fields', () {
      final roundtripped = entity.toDomain().toEntity();

      expect(roundtripped.idListe, entity.idListe);
      expect(roundtripped.codeListe, entity.codeListe);
      expect(roundtripped.nomListe, entity.nomListe);
      expect(roundtripped.descListe, entity.descListe);
    });

    test('toDomain handles null optional fields', () {
      final minimalEntity = TaxonListEntity(
        idListe: 1,
        nomListe: 'Minimal',
      );

      final domain = minimalEntity.toDomain();

      expect(domain.idListe, 1);
      expect(domain.nomListe, 'Minimal');
      expect(domain.codeListe, isNull);
      expect(domain.descListe, isNull);
      expect(domain.regne, isNull);
    });
  });

  group('VisitComplementEntityMapper', () {
    test('toDomain maps all fields correctly', () {
      final entity = VisitComplementEntity(
        idBaseVisit: 10,
        data: '{"key": "value"}',
      );

      final domain = entity.toDomain();

      expect(domain.idBaseVisit, 10);
      expect(domain.data, '{"key": "value"}');
    });

    test('toEntity maps all fields correctly', () {
      const domain = VisitComplement(
        idBaseVisit: 20,
        data: '{"test": true}',
      );

      final result = domain.toEntity();

      expect(result.idBaseVisit, 20);
      expect(result.data, '{"test": true}');
    });

    test('roundtrip preserves all fields', () {
      final entity = VisitComplementEntity(
        idBaseVisit: 5,
        data: '{"complex": {"nested": 1}}',
      );

      final roundtripped = entity.toDomain().toEntity();

      expect(roundtripped.idBaseVisit, entity.idBaseVisit);
      expect(roundtripped.data, entity.data);
    });

    test('handles null data', () {
      final entity = VisitComplementEntity(idBaseVisit: 1);

      final domain = entity.toDomain();

      expect(domain.idBaseVisit, 1);
      expect(domain.data, isNull);
    });
  });

  group('CorSiteModuleEntityMapper', () {
    test('toDomain maps all fields correctly', () {
      final entity = CorSiteModuleEntity(
        idModule: 5,
        idBaseSite: 100,
      );

      final domain = entity.toDomain();

      expect(domain.idModule, 5);
      expect(domain.idBaseSite, 100);
    });

    test('toEntity maps all fields correctly', () {
      const domain = CorSiteModule(
        idModule: 8,
        idBaseSite: 200,
      );

      final result = domain.toEntity();

      expect(result.idModule, 8);
      expect(result.idBaseSite, 200);
    });

    test('roundtrip preserves all fields', () {
      final entity = CorSiteModuleEntity(
        idModule: 3,
        idBaseSite: 50,
      );

      final roundtripped = entity.toDomain().toEntity();

      expect(roundtripped.idModule, entity.idModule);
      expect(roundtripped.idBaseSite, entity.idBaseSite);
    });
  });

  group('CorSitesGroupModuleEntityMapper', () {
    test('toDomain maps all fields correctly', () {
      final entity = CorSitesGroupModuleEntity(
        idSitesGroup: 15,
        idModule: 7,
      );

      final domain = entity.toDomain();

      expect(domain.idSitesGroup, 15);
      expect(domain.idModule, 7);
    });

    test('toEntity maps all fields correctly', () {
      const domain = CorSitesGroupModule(
        idSitesGroup: 25,
        idModule: 12,
      );

      final result = domain.toEntity();

      expect(result.idSitesGroup, 25);
      expect(result.idModule, 12);
    });

    test('roundtrip preserves all fields', () {
      final entity = CorSitesGroupModuleEntity(
        idSitesGroup: 9,
        idModule: 4,
      );

      final roundtripped = entity.toDomain().toEntity();

      expect(roundtripped.idSitesGroup, entity.idSitesGroup);
      expect(roundtripped.idModule, entity.idModule);
    });
  });
}
