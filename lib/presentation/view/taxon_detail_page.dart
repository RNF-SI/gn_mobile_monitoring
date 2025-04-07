import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';

class TaxonDetailPage extends StatelessWidget {
  final Taxon taxon;

  const TaxonDetailPage({super.key, required this.taxon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(taxon.lbNom ?? 'Détails du taxon'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Informations taxonomiques',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildInfoRow('Nom scientifique', taxon.lbNom ?? 'Non spécifié', true),
                    if (taxon.nomVern != null && taxon.nomVern!.isNotEmpty)
                      _buildInfoRow('Nom vernaculaire', taxon.nomVern!, false),
                    _buildInfoRow('CD_NOM', taxon.cdNom.toString(), false),
                    if (taxon.regne != null && taxon.regne!.isNotEmpty)
                      _buildInfoRow('Règne', taxon.regne!, false),
                    if (taxon.phylum != null && taxon.phylum!.isNotEmpty)
                      _buildInfoRow('Phylum', taxon.phylum!, false),
                    if (taxon.classe != null && taxon.classe!.isNotEmpty)
                      _buildInfoRow('Classe', taxon.classe!, false),
                    if (taxon.ordre != null && taxon.ordre!.isNotEmpty)
                      _buildInfoRow('Ordre', taxon.ordre!, false),
                    if (taxon.famille != null && taxon.famille!.isNotEmpty)
                      _buildInfoRow('Famille', taxon.famille!, false),
                    if (taxon.group1Inpn != null && taxon.group1Inpn!.isNotEmpty)
                      _buildInfoRow('Groupe INPN', taxon.group1Inpn!, false),
                    if (taxon.group2Inpn != null && taxon.group2Inpn!.isNotEmpty)
                      _buildInfoRow('Sous-groupe INPN', taxon.group2Inpn!, false),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // La section des informations complémentaires est supprimée car
            // les champs validable, statusSource et habitat n'existent pas dans le modèle Taxon
            
            // Afficher l'ID de statut et d'habitat s'ils sont disponibles
            if (taxon.idStatut != null || taxon.idHabitat != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Informations complémentaires',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      if (taxon.idStatut != null)
                        _buildInfoRow('ID Statut', taxon.idStatut!, false),
                      if (taxon.idHabitat != null)
                        _buildInfoRow('ID Habitat', taxon.idHabitat.toString(), false),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isItalic) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: isItalic ? const TextStyle(fontStyle: FontStyle.italic) : null,
            ),
          ),
        ],
      ),
    );
  }
}