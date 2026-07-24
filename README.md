# 📊 Restaurant Market Analysis & Data Pipeline

## 🎯 Objectif du projet
Ce projet analyse un ensemble de données sur la restauration pour identifier des opportunités de marché stratégiques (Gap Analysis). Il s'appuie sur la construction d'un pipeline de données complet, structuré selon une **Architecture Medallion** (Bronze, Silver, Gold), transformant des données brutes en indicateurs décisionnels prêts à être visualisés.

> **📂 Source des données :** Le jeu de données initial utilisé pour cette analyse est fourni par [Maven Analytics](https://mavenanalytics.io/data-playground/restaurant-ratings).

## 🛠️ Stack Technique
*   **Langage :** SQL (MariaDB / MySQL)
*   **Architecture :** Medallion (Bronze / Silver / Gold)
*   **Business Intelligence :** Apache Superset (en cours de création)

## 🏗️ Architecture des Données

1.  **Couche Bronze (Données Brutes) :**
    *   Intégration des données initiales.
    *   Standardisation des noms de colonnes et commentaires documentaires.
2.  **Couche Silver (Données Nettoyées & Profilées) :**
    *   Nettoyage et typage strict (gestion des NULLs via `COALESCE()`, conversions via `CAST()`).
    *   Analyse exploratoire et profilage des variables clés (fumeurs, accessibilité, budget).
3.  **Couche Gold (Data Marts) :**
    *   Dénormalisation des données pour optimiser les performances de requêtage de l'outil BI.
    *   Création de vues orientées métier (`dm_restaurant_performance`, `dm_consumer_behavior`, `dm_market_opportunities`).

## 💡 Découvertes Clés & Insights Métier

### 1. Biais de Sélection & Profilage (Le Persona)
L'analyse de la clientèle a révélé un biais de sélection massif dans l'échantillon. La base de données ne représente pas la population générale, mais un **Persona hautement spécifique** :
*   **82%** d'étudiants (21-28 ans).
*   Majoritairement célibataires, non-fumeurs et dépendants des transports en commun.
*   Ultra-localisés à San Luis Potosi.

### 2. Analyse des Opportunités (Gap Analysis)
La mise en relation de l'offre (restaurants) et de la demande (notes et volumes) a mis en évidence deux dynamiques de marché :
*   **L'Océan Rouge (À éviter) :** Les restaurants mexicains et les bars traditionnels saturent le marché avec des taux d'excellence moyens (~41%), diluant la rentabilité.
*   **Le Gap (Opportunité) :** Les concepts "Coffee Shops" et les espaces "Family/International" bénéficient des taux d'excellence les plus élevés (jusqu'à 64%) mais souffrent d'un manque d'offre criant. 

### 3. Recommandation d'Investissement
Le projet de restauration idéal basé sur les données : 
> Un café ou espace de petite restauration internationale, situé à San Luis Potosi près des axes de transports ou campus, 100% non-fumeur, avec une tarification étudiante et un aménagement favorisant les sessions de travail prolongées.

## 🚀 Comment utiliser ce dépôt
Les scripts SQL sont exécutables séquentiellement :
1. Exécutez les scripts du dossier `sql/01_bronze/` pour initialiser le schéma.
2. Appliquez les transformations métier via `sql/02_silver/`.
3. Générez les vues analytiques avec `sql/03_gold/`.
4. Connectez votre instance Apache Superset aux vues `gold_dm_*` pour la création des tableaux de bord.
