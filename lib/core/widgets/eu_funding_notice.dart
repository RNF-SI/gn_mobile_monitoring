import 'package:flutter/material.dart';

/// Textes de l'encart de financement européen.
///
/// Libellés imposés par le guide de communication LIFE BIODIV'FRANCE :
/// ils doivent être reproduits mot pour mot (apostrophes typographiques
/// comprises). Ne pas reformuler.
class EuFundingTexts {
  EuFundingTexts._();

  /// Bloc marque officiel (UE + LIFE + BIODIV'FRANCE), à utiliser tel quel :
  /// ni recadrage, ni recoloration, ni séparation des logos.
  static const String logoAsset = 'assets/logos/bloc_marque_ue_life_biodiv.jpg';

  static const String logoSemanticLabel =
      'Cofinancé par l’Union européenne — programme LIFE — BIODIV’FRANCE';

  /// Mention obligatoire.
  static const String mandatoryNotice =
      'Cofinancé par l’Union européenne. Les points de vue et les opinions '
      'exprimés sont toutefois ceux des auteurs et ne reflètent pas '
      'nécessairement ceux de l’Union européenne ou de CINEA. Ni l’Union '
      'européenne ni l’autorité chargée de l’octroi de la subvention ne '
      'peuvent en être tenues pour responsables.';

  /// Mention facultative — première ligne.
  static const String projectTitle =
      'Réalisé dans le cadre du projet LIFE BIODIV’FRANCE';

  /// Mention facultative — paragraphe.
  static const String projectDescription =
      'Coordonné par l’Office Français de la Biodiversité, ce projet rassemble '
      'un consortium de 31 participants. Il accompagne la mise en œuvre de la '
      'stratégie nationale pour la biodiversité en travaillant sur 5 cibles : '
      'les territoires, aires protégées, filières, citoyens et acteurs de la '
      'formation.';
}

/// Encart « financement UE » : bloc marque officiel + mention obligatoire +
/// mention facultative, dans un cadre clairement délimité.
///
/// Fond blanc et texte foncé quel que soit le fond de l'écran parent
/// (contraste WCAG AA). Le texte ne descend jamais sous 12 sp (le guide
/// impose l'équivalent de 8 pt, soit ≥ 11 sp à l'écran). Sur écran étroit
/// le logo est au-dessus du texte ; à partir de [wideBreakpoint] il passe à
/// gauche.
class EuFundingNotice extends StatelessWidget {
  const EuFundingNotice({super.key});

  static const double wideBreakpoint = 600;
  static const double _fontSize = 12;
  static const Color _textColor = Color(0xFF212121);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('eu-funding-notice'),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBDBDBD)),
      ),
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final logo = Image.asset(
            EuFundingTexts.logoAsset,
            fit: BoxFit.contain,
            semanticLabel: EuFundingTexts.logoSemanticLabel,
          );
          final texts = _buildTexts();

          if (constraints.maxWidth >= wideBreakpoint) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: logo),
                const SizedBox(width: 20),
                Expanded(flex: 3, child: texts),
              ],
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: logo,
              ),
              const SizedBox(height: 12),
              texts,
            ],
          );
        },
      ),
    );
  }

  Widget _buildTexts() {
    const baseStyle = TextStyle(
      fontSize: _fontSize,
      height: 1.4,
      color: _textColor,
    );
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(EuFundingTexts.mandatoryNotice, style: baseStyle),
        Divider(height: 20, color: Color(0xFFBDBDBD)),
        Text(
          EuFundingTexts.projectTitle,
          style: TextStyle(
            fontSize: _fontSize,
            height: 1.4,
            color: _textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(EuFundingTexts.projectDescription, style: baseStyle),
      ],
    );
  }
}
