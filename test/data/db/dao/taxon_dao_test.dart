import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';

void main() {
  late AppDatabase db;

  final taxon1 = Taxon(cdNom: 100, nomComplet: 'Parus major', lbNom: 'Parus major', nomVern: 'Mésange charbonnière');
  final taxon2 = Taxon(cdNom: 200, nomComplet: 'Cyanistes caeruleus', lbNom: 'Cyanistes caeruleus', nomVern: 'Mésange bleue');
  final taxon3 = Taxon(cdNom: 300, nomComplet: 'Erithacus rubecula', lbNom: 'Erithacus rubecula', nomVern: 'Rougegorge familier');

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('TaxonDao - isTaxonInList', () {
    test('retourne true si le taxon appartient à la liste', () async {
      // Arrange
      await db.taxonDao.insertTaxons([taxon1, taxon2]);
      await db.taxonDao.linkTaxonsToList(10, [100, 200]);

      // Act
      final result = await db.taxonDao.isTaxonInList(100, 10);

      // Assert
      expect(result, isTrue);
    });

    test('retourne false si le taxon n\'appartient pas à la liste', () async {
      // Arrange
      await db.taxonDao.insertTaxons([taxon1, taxon2]);
      await db.taxonDao.linkTaxonsToList(10, [100]);

      // Act
      final result = await db.taxonDao.isTaxonInList(200, 10);

      // Assert
      expect(result, isFalse);
    });

    test('retourne false si la liste n\'existe pas', () async {
      // Arrange
      await db.taxonDao.insertTaxons([taxon1]);
      await db.taxonDao.linkTaxonsToList(10, [100]);

      // Act
      final result = await db.taxonDao.isTaxonInList(100, 999);

      // Assert
      expect(result, isFalse);
    });

    test('retourne false si le taxon n\'existe pas', () async {
      // Act
      final result = await db.taxonDao.isTaxonInList(999, 10);

      // Assert
      expect(result, isFalse);
    });

    test('distingue correctement les différentes listes', () async {
      // Arrange
      await db.taxonDao.insertTaxons([taxon1, taxon2]);
      await db.taxonDao.linkTaxonsToList(10, [100]);
      await db.taxonDao.linkTaxonsToList(20, [200]);

      // Act & Assert
      expect(await db.taxonDao.isTaxonInList(100, 10), isTrue);
      expect(await db.taxonDao.isTaxonInList(100, 20), isFalse);
      expect(await db.taxonDao.isTaxonInList(200, 10), isFalse);
      expect(await db.taxonDao.isTaxonInList(200, 20), isTrue);
    });
  });

  group('TaxonDao - getSuggestionTaxons', () {
    test('retourne un nombre limité de taxons', () async {
      // Arrange - insérer 3 taxons dans la liste
      await db.taxonDao.insertTaxons([taxon1, taxon2, taxon3]);
      await db.taxonDao.linkTaxonsToList(10, [100, 200, 300]);

      // Act - demander seulement 2 suggestions
      final result = await db.taxonDao.getSuggestionTaxons(10, limit: 2);

      // Assert
      expect(result.length, 2);
    });

    test('retourne tous les taxons si la limite est supérieure au nombre total', () async {
      // Arrange
      await db.taxonDao.insertTaxons([taxon1, taxon2]);
      await db.taxonDao.linkTaxonsToList(10, [100, 200]);

      // Act
      final result = await db.taxonDao.getSuggestionTaxons(10, limit: 50);

      // Assert
      expect(result.length, 2);
    });

    test('retourne une liste vide si la liste n\'a pas de taxons', () async {
      // Act
      final result = await db.taxonDao.getSuggestionTaxons(999, limit: 10);

      // Assert
      expect(result, isEmpty);
    });

    test('respecte la limite par défaut de 10', () async {
      // Arrange - insérer 15 taxons
      final manyTaxons = List.generate(
        15,
        (i) => Taxon(cdNom: 1000 + i, nomComplet: 'Taxon $i', lbNom: 'Taxon$i'),
      );
      await db.taxonDao.insertTaxons(manyTaxons);
      await db.taxonDao.linkTaxonsToList(10, manyTaxons.map((t) => t.cdNom).toList());

      // Act - utiliser la limite par défaut
      final result = await db.taxonDao.getSuggestionTaxons(10);

      // Assert
      expect(result.length, 10);
    });

    test('ne retourne que les taxons de la liste demandée', () async {
      // Arrange
      await db.taxonDao.insertTaxons([taxon1, taxon2, taxon3]);
      await db.taxonDao.linkTaxonsToList(10, [100, 200]);
      await db.taxonDao.linkTaxonsToList(20, [300]);

      // Act
      final resultList10 = await db.taxonDao.getSuggestionTaxons(10, limit: 10);
      final resultList20 = await db.taxonDao.getSuggestionTaxons(20, limit: 10);

      // Assert
      expect(resultList10.length, 2);
      expect(resultList10.map((t) => t.cdNom).toSet(), {100, 200});
      expect(resultList20.length, 1);
      expect(resultList20.first.cdNom, 300);
    });

    test('retourne des objets Taxon complets avec tous les champs', () async {
      // Arrange
      await db.taxonDao.insertTaxons([taxon1]);
      await db.taxonDao.linkTaxonsToList(10, [100]);

      // Act
      final result = await db.taxonDao.getSuggestionTaxons(10, limit: 10);

      // Assert
      expect(result.length, 1);
      expect(result.first.cdNom, 100);
      expect(result.first.nomComplet, 'Parus major');
      expect(result.first.lbNom, 'Parus major');
      expect(result.first.nomVern, 'Mésange charbonnière');
    });
  });

  group('TaxonDao - insertTaxons batch', () {
    test('insère correctement un grand nombre de taxons en batch', () async {
      // Arrange - 1200 taxons pour tester le chunking par 500
      final manyTaxons = List.generate(
        1200,
        (i) => Taxon(cdNom: 5000 + i, nomComplet: 'Taxon batch $i', lbNom: 'TaxonBatch$i'),
      );

      // Act
      await db.taxonDao.insertTaxons(manyTaxons);

      // Assert
      final allCdNoms = await db.taxonDao.getAllTaxonCdNoms();
      expect(allCdNoms.length, 1200);
    });

    test('insertOrReplace fonctionne pour les taxons existants', () async {
      // Arrange - insérer un taxon
      await db.taxonDao.insertTaxons([taxon1]);

      // Act - insérer le même cd_nom avec un nom différent
      final updatedTaxon = Taxon(cdNom: 100, nomComplet: 'Parus major updated', lbNom: 'Parus major v2');
      await db.taxonDao.insertTaxons([updatedTaxon]);

      // Assert
      final result = await db.taxonDao.getTaxonByCdNom(100);
      expect(result, isNotNull);
      expect(result!.nomComplet, 'Parus major updated');
      expect(result.lbNom, 'Parus major v2');
    });
  });
}
