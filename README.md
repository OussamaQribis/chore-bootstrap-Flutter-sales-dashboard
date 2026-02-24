# Sales Dashboard (Flutter) — Tableau de bord des ventes

## 🇫🇷 Présentation (FR)
Application Flutter multi-plateforme (Android / iOS) qui affiche :
- Les produits
- Les plus vendus / moins vendus
- Selon une période (DateRange) définie par l'utilisateur
- Avec une base **de données locale (mock)** aujourd'hui, prête à basculer vers une **API** plus tard

### ✨ Fonctionnalités
- Filtre par période (DateRange Picker)
- Top / Flop produits
- Vue “Comparaison” (barres/progression)
- Internationalisation **dynamique** (AR/FR) avec support RTL

### 🧱 Architecture
Le projet est structuré pour permettre de remplacer facilement la source de données :
- `SalesRepository` (contrat)
- `LocalSalesRepository` (mock data, actuel)
- `ApiSalesRepository` (prévu, plus tard)

### 📁 Structure du dossier (résumé)
- `lib/app/` : point d’entrée UI (MaterialApp, locale, delegates)
- `lib/core/localization/` : i18n (langues + traductions + contrôleur)
- `lib/features/sales/`
  - `domain/` : models + repository contract
  - `data/` : local/api repositories
  - `presentation/` : pages + controller

### 🚀 Démarrage
```bash
flutter pub get
flutter run
