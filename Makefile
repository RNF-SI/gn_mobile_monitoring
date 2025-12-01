.PHONY: clean build run test test-unit test-integration test-all format analyze generate_code help

# Default target
help:
	@echo "GN Mobile Monitoring - Commandes disponibles:"
	@echo "  make clean             - Nettoie le projet"
	@echo "  make build             - Compile l'application pour mobile"
	@echo "  make run               - Exécute l'application en mode debug"
	@echo "  make test              - Exécute tous les tests unitaires"
	@echo "  make test-unit         - Exécute les tests unitaires uniquement"
	@echo "  make test-integration  - Exécute les tests d'intégration uniquement"
	@echo "  make test-all          - Exécute tous les tests (unit + integration)"
	@echo "  make format            - Formate le code"
	@echo "  make analyze           - Analyse le code"
	@echo "  make generate_code     - Génère le code (freezed, drift, etc.)"
	@echo "  make apk               - Construit l'APK pour Android"
	@echo "  make aab               - Construit l'AAB pour Google Play Store"
	@echo "  make ios               - Construit l'application pour iOS"

# Nettoyer le projet
clean:
	flutter clean

# Construire l'application
build:
	flutter build

# Exécuter l'application
run:
	flutter run

# Exécuter les tests unitaires (par défaut)
test:
	flutter test --exclude-tags=integration

# Exécuter les tests unitaires uniquement
test-unit:
	flutter test --exclude-tags=integration

# Exécuter les tests d'intégration réels (recommandé)
test-integration:
	@echo "🧪 Exécution des tests d'intégration avec vraies requêtes HTTP..."
	@if [ ! -f .env.test ]; then \
		echo "❌ Fichier .env.test non trouvé!"; \
		echo "Copiez .env.test.example vers .env.test et configurez les credentials"; \
		exit 1; \
	fi
	./run_integration_tests.sh

# Exécuter les tests d'intégration Flutter (avec limitations HTTP)
test-integration-flutter:
	@echo "🧪 Exécution des tests d'intégration Flutter (limitées par TestWidgetsFlutterBinding)..."
	@if [ ! -f .env.test ]; then \
		echo "❌ Fichier .env.test non trouvé!"; \
		echo "Copiez .env.test.example vers .env.test et configurez les credentials"; \
		exit 1; \
	fi
	flutter test test/integration/ --tags=integration

# Test manuel rapide de la configuration
test-integration-manual:
	@echo "🔧 Test manuel de la configuration d'intégration..."
	@if [ ! -f .env.test ]; then \
		echo "❌ Fichier .env.test non trouvé!"; \
		echo "Copiez .env.test.example vers .env.test et configurez les credentials"; \
		exit 1; \
	fi
	./test_integration_manual.sh

# Exécuter tous les tests (unitaires + intégration)
test-all:
	@echo "🧪 Exécution de tous les tests..."
	flutter test

# Formater le code
format:
	flutter format lib/

# Analyser le code
analyze:
	flutter analyze

# Générer le code
generate_code:
	flutter pub run build_runner build --delete-conflicting-outputs

# Construire l'APK pour Android
apk:
	flutter build apk --release

# Construire l'AAB pour Google Play Store
aab:
	flutter build appbundle --release

# Construire l'application pour iOS
ios:
	flutter build ios --release --no-codesign