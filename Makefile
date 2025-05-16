.PHONY: clean build run test format analyze generate_code help

# Default target
help:
	@echo "GN Mobile Monitoring - Commandes disponibles:"
	@echo "  make clean        - Nettoie le projet"
	@echo "  make build        - Compile l'application pour mobile"
	@echo "  make run          - Exécute l'application en mode debug"
	@echo "  make test         - Exécute tous les tests"
	@echo "  make format       - Formate le code"
	@echo "  make analyze      - Analyse le code"
	@echo "  make generate_code- Génère le code (freezed, drift, etc.)"
	@echo "  make apk          - Construit l'APK pour Android"
	@echo "  make aab          - Construit l'AAB pour Google Play Store"
	@echo "  make ios          - Construit l'application pour iOS"

# Nettoyer le projet
clean:
	flutter clean

# Construire l'application
build:
	flutter build

# Exécuter l'application
run:
	flutter run

# Exécuter les tests
test:
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