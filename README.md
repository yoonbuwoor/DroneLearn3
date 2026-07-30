# DroneAtlas Academy

**DroneAtlas Academy** est une application Flutter pédagogique, interactive et entièrement simulée pour apprendre les drones et la photogrammétrie, depuis les notions de base jusqu’à la rédaction du rapport final.

> Aucun jeu d’images drone réel n’est demandé. L’apprentissage repose sur des fragments intégrés, des terrains fictifs, des plans de vol simulés et des résultats pédagogiques préchargés.

## Ce que contient l’application

- **8 modules et 24 leçons** : drone, photographie, photogrammétrie, planification, terrain, traitement, SIG, qualité et rapport ;
- **6 domaines d’application** : cartographie, agriculture, BTP, mines, littoral et patrimoine ;
- **4 laboratoires interactifs** : plan de vol, caméra, fragments d’images et chaîne de traitement ;
- **3 missions complètes évaluées** avec décisions, retours pédagogiques et scores ;
- **assistant DroneAtlas hors ligne** avec réponses guidées ;
- **quiz général**, validations de cours, glossaire, XP et badges ;
- **rédacteur de rapport** avec structure, conseils et aperçu ;
- interface responsive Android, Web et ordinateur, avec thème clair/sombre ;
- génération automatisée d’un **APK**, d’un **AAB** et d’une version **GitHub Pages** ;
- **mises à jour de cours sans réinstaller l’APK** ;
- **notifications Android** pour les nouveautés et rappels d’apprentissage ;
- fonctionnement sans compte, sans Firebase et sans base de données distante.

## Parcours pédagogique

```text
Bases du drone
   ↓
Photographie aérienne
   ↓
Principes photogrammétriques
   ↓
Planification de mission
   ↓
Acquisition terrain simulée
   ↓
Contrôle de fragments
   ↓
Traitement photogrammétrique simulé
   ↓
Contrôle qualité et SIG
   ↓
Rédaction du rapport
```

## Simulateurs intégrés

### Plan de vol

L’utilisateur modifie l’altitude, la surface, le recouvrement longitudinal et latéral. L’application recalcule automatiquement :

- le GSD pédagogique ;
- le nombre estimé d’images ;
- la durée du vol ;
- le nombre de batteries ;
- une note de qualité du plan ;
- les risques et recommandations.

### Laboratoire caméra

Les réglages de vitesse d’obturation, luminosité et inclinaison modifient visuellement un fragment aérien. L’utilisateur apprend à reconnaître une image nette, floue, surexposée, sous-exposée ou trop oblique.

### Diagnostic de fragments

L’utilisateur inspecte plusieurs fragments et classe leurs défauts : flou, eau, ombre, faible texture, surexposition ou qualité correcte.

### Chaîne de traitement

Une animation explique les étapes : lecture des images, détection des caractéristiques, appariement, nuage clairsemé, densification, maillage, orthophoto et produits finaux.

## Structure du projet

```text
lib/
├── config/            # URL et cadence du catalogue distant
├── controllers/       # progression, mises à jour et préférences
├── core/              # thème et identité visuelle
├── data/              # cours intégrés, domaines, quiz et missions
├── models/            # modèles pédagogiques et cours distants
├── screens/           # écrans, centre de mises à jour et cours
├── services/          # téléchargement, cache, notifications, arrière-plan
└── widgets/           # composants, assistant et schémas dessinés
content/               # manifest et cours publiés sans nouvel APK
assets/
├── images/            # fragments et visuels pédagogiques
└── icon/              # icône DroneAtlas
.github/workflows/     # compilation Android et déploiement Web
tool/                  # configuration Android/Web
```

## Lancer le projet localement

Prérequis : Flutter stable, Android Studio ou un navigateur compatible.

```bash
git clone <URL_DU_DEPOT>
cd DroneAtlas_Academy
flutter create --platforms=android,web --org com.novateur221 --project-name droneatlas .
python3 tool/configure_android.py
python3 tool/configure_web.py
flutter pub get
flutter run
```

Sur Windows, vous pouvez aussi lancer :

```text
build_android.bat
```

## Générer l’APK

```bash
flutter build apk --release
```

Fichier produit :

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Générer l’AAB pour Google Play

```bash
flutter build appbundle --release
```

Fichier produit :

```text
build/app/outputs/bundle/release/app-release.aab
```

La configuration actuelle utilise la signature de débogage pour permettre une compilation immédiate. Avant une publication officielle sur Google Play, remplacez-la par votre propre clé de signature.

## Déployer avec GitHub

Deux workflows sont fournis :

- **Build DroneAtlas Android** : vérifie le projet, lance les tests puis produit l’APK et l’AAB ;
- **Deploy DroneAtlas Web** : produit la PWA et la publie avec GitHub Pages ;
- **Validate DroneAtlas Content** : bloque un cours JSON incomplet ou incohérent.

Consultez [DEPLOIEMENT_GITHUB.md](DEPLOIEMENT_GITHUB.md) pour le guide pas à pas.

## Mettre les cours à jour sans nouvel APK

Les leçons essentielles restent dans `lib/data/academy_data.dart`. Les nouveautés publiées après installation sont dans :

```text
content/manifest.json
content/courses/
```

L’application compare la version distante, notifie l’utilisateur, télécharge les cours et les conserve localement. Voir [MISES_A_JOUR_COURS.md](MISES_A_JOUR_COURS.md).

## Identité

Projet **DroneAtlas** — une initiative **Novateur221**.

© 2026 Novateur221. Tous droits réservés sur l’identité et les contenus du projet.
