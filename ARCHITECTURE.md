# Architecture fonctionnelle de DroneAtlas

## Principe

DroneAtlas associe une académie Flutter locale à un catalogue de contenus statiques hébergé dans le même dépôt GitHub. Aucun compte, aucune communauté, aucun serveur applicatif et aucune base de données distante ne sont nécessaires.

## Couches

### Présentation

Les écrans Flutter sont responsives : navigation mobile, mise en page tablette/ordinateur, centre de mises à jour, lecteur de cours et paramètres de notifications.

### État et stockage local

`AppController` maintient la progression de session, les paramètres des simulateurs, l’état du catalogue et les préférences. `SharedPreferencesAsync` conserve les cours téléchargés, la version installée, la date de vérification et les réglages de notifications.

### Contenu embarqué

`lib/data/academy_data.dart` fournit le socle qui fonctionne dès la première installation et hors connexion.

### Contenu évolutif

`content/manifest.json` annonce la version et les fichiers présents dans `content/courses/`. `ContentUpdateService` télécharge le JSON, valide sa structure applicative puis le met en cache. Une mise à jour de cours ne déclenche pas la compilation de l’APK.

### Notifications et arrière-plan

`flutter_local_notifications` affiche les nouveautés, confirmations et rappels. `workmanager` vérifie périodiquement le manifest lorsque le réseau est disponible. Android reste libre de décaler l’exécution selon la batterie et l’état du téléphone.

### Simulation

Les calculs sont pédagogiques et immédiats. Ils ne remplacent pas un logiciel de planification certifié ni un moteur photogrammétrique réel.

## Flux

```text
Commit d’un cours dans content/
          ↓
Validation JSON par GitHub Actions
          ↓
Lecture périodique du manifest par l’application
          ↓
Notification locale « Nouveau contenu »
          ↓
Téléchargement et cache sur le téléphone
          ↓
Consultation hors connexion
```

## Sécurité éditoriale

Le script `tool/validate_content.py` vérifie les identifiants, versions, chemins, pages, objectifs et quiz avant publication. Le catalogue utilise uniquement des chemins relatifs sous `content/`.
