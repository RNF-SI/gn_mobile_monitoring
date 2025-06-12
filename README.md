# GN Mobile Monitoring

Portage mobile du module monitoring de GeoNature pour la saisie de données protocolées sur smartphone.

## 📱 Description

GN Mobile Monitoring est un portage mobile du module monitoring de GeoNature. Il permet la saisie de données protocolées directement depuis un smartphone et leur envoi vers votre instance GeoNature.

## ✨ Fonctionnalités

- **Saisie terrain** : Interface optimisée pour smartphone
- **Synchronisation** : Envoi automatique des données vers GeoNature
- **Mode hors ligne** : Saisie sans connexion, synchronisation ultérieure
- **Protocoles multiples** : Support des protocoles configurés dans GeoNature
- **Formulaires dynamiques** : Adaptation automatique selon le protocole

## 🚀 Installation

### Application Android (Bêta)
Téléchargez la dernière version APK depuis les [Releases](../../releases).

### Depuis les sources
```bash
# Cloner le repository
git clone https://github.com/RNF-SI/gn_mobile_monitoring/
cd gn_mobile_monitoring

# Installer les dépendances
flutter pub get

# Générer le code
flutter pub run build_runner build --delete-conflicting-outputs

# Lancer l'application
flutter run
```

## ⚙️ Configuration

1. Lancez l'application
2. Saisissez l'URL de votre instance GeoNature
3. Connectez-vous avec vos identifiants GeoNature
4. Téléchargez les modules de monitoring souhaités

## 📋 Prérequis

- Android 5.0 minimum
- GeoNature 2.15.0 avec module monitoring 1.0.0 au minimum
- Compte utilisateur avec droits sur les modules

## 🛠️ Développement

L'application utilise Flutter et suit une architecture Clean Architecture.
- [Tâches](./TASKS.md)
- [Snippets](./SNIPPETS.md)
- [.cursorrules](./CURSORRULES.md)
- [Fichiers de Prompts](./PROMPTS.md)


## 🤝 Contribution

Les contributions sont bienvenues ! N'hésitez pas à ouvrir une issue ou proposer une PR.

## 🐛 Support

Pour tout problème ou question, [ouvrez une issue](https://github.com/RNF-SI/gn_mobile_monitoring/issues/new) sur ce repository.
