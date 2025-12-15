# Plan d'Assurance Qualité Projet (PAQP)
## MyEmoHealth - Plateforme de Télésurveillance Émotionnelle

**Version** : 1.0  
**État** : Première version  
**Rédigé par** : Responsable Qualité (RQ)  
**Date de dernière mise à jour** : 15 décembre 2024  
**Diffusion** : Équipe Technique, Maîtrise d'œuvre, Maîtrise d'ouvrage

---

## Historique du document

| Date | Nature de la modification | Réalisé par | Version |
|------|---------------------------|-------------|---------|
| 01/12/2024 | Début de la rédaction de ce document | RQ | 0.1.0 |
| 10/12/2024 | Finalisation de l'ébauche du document | RQ | 0.2.0 |
| 15/12/2024 | Première version du document | RQ | 1.0 |

---

## Validation

| Personne | Date | Signature |
|----------|------|-----------|
| Responsable Qualité | | |
| Chef de projet | | |

---

## Sommaire

- [A) Objet de ce document](#a-objet-de-ce-document)
- [B) Organisation des ressources humaines](#b-organisation-des-ressources-humaines)
- [C) Qualité au niveau processus de développement](#c-qualité-au-niveau-processus-de-développement)
- [D) Documentation](#d-documentation)
- [E) Gestion des modifications](#e-gestion-des-modifications)
- [F) Méthodes, Outils et Règles](#f-méthodes-outils-et-règles)
- [G) Tests et Validation](#g-tests-et-validation)
- [H) Reproduction, Protection et livraison](#h-reproduction-protection-et-livraison)
- [I) Suivi de l'application du plan qualité](#i-suivi-de-lapplication-du-plan-qualité)
- [J) Conclusion](#j-conclusion)

---

## A) Objet de ce document

### I. Introduction

Le Plan d'Assurance Qualité Projet (PAQP) est un document décrivant comment mettre en œuvre les moyens permettant d'obtenir la qualité nécessaire à la bonne réalisation du projet MyEmoHealth. Il précise également les dispositions relatives à la conception et à la maîtrise de la qualité pour l'ensemble du cycle de vie du système.

### II. Cadre du PAQP

Le but de ce document est de définir la politique qualité pour le projet MyEmoHealth, une plateforme full-stack de télésurveillance émotionnelle. Le présent document décrit les méthodes à employer dans les différents cas de figure pouvant se présenter lors du développement, du déploiement et de la maintenance du système.

### III. Présentation du projet

**MyEmoHealth** est une plateforme complète conçue pour surveiller et améliorer le bien-être émotionnel des patients grâce à :
- L'analyse assistée par IA
- La communication directe médecin-patient
- Le suivi en temps réel de l'état émotionnel

**Composants du système** :
1. **Backend API** (Spring Boot) - Port 8082
2. **Portail Web Admin/Médecin** (Angular) - Port 4200
3. **Application Mobile Patient** (Flutter) - iOS/Android

### IV. Terminologie et abréviations

| Abréviation | Signification |
|-------------|---------------|
| API | Application Programming Interface |
| CdP | Chef de Projet |
| IA | Intelligence Artificielle |
| JWT | JSON Web Token |
| MOA | Maîtrise d'ouvrage |
| MOE | Maîtrise d'œuvre |
| PAQP | Plan d'Assurance Qualité Projet |
| QCM | Questionnaire à Choix Multiples |
| RQ | Responsable Qualité |
| WebSocket | Protocole de communication bidirectionnelle |

---

## B) Organisation des ressources humaines

### I. Rôle des différents intervenants

#### Chef de projet (CdP)
**Responsabilités** :
- Mise en place de l'équipe de projet et distribution des rôles
- Constitution du planning prévisionnel pour les tâches à effectuer
- Coordination de l'équipe du projet (Backend, Frontend Web, Mobile)
- Vérification du bon déroulement du projet
- Validation et présentation des résultats aux clients
- Gestion des risques et des dépendances entre composants

#### Responsable Backend
**Responsabilités** :
- Développement et maintenance de l'API Spring Boot
- Gestion de la base de données PostgreSQL
- Implémentation de la sécurité (JWT, authentification)
- Développement des services métier (tests, analyse vocale, chat)
- Documentation des endpoints API
- Tests unitaires et d'intégration backend

#### Responsable Frontend Web
**Responsabilités** :
- Développement du portail Angular pour médecins
- Implémentation du design (Glassmorphism, palette Turquoise/Teal)
- Intégration avec l'API backend
- Gestion des états et des données côté client
- Tests des composants Angular
- Optimisation des performances web

#### Responsable Mobile
**Responsabilités** :
- Développement de l'application Flutter
- Implémentation du design iOS-style avec animations
- Intégration des fonctionnalités (Voice AI, Chat temps réel)
- Tests sur iOS et Android
- Gestion des permissions et de la sécurité mobile
- Optimisation des performances mobiles

#### Responsable Qualité (RQ)
**Responsabilités** :
- Veiller à la bonne mise en place d'une démarche qualité
- Veiller à la qualité de tous les livrables intermédiaires
- Veiller à la qualité du livrable final pour le client
- Validation des tests et de la documentation
- Audits qualité réguliers
- Gestion des non-conformités

#### Responsable Communication/Documentation
**Responsabilités** :
- Rassembler les informations collectées par chacun
- Veiller à ce que les livrables intermédiaires soient faits et dans les temps
- Dialogue avec le client
- Diffusion des documents dans le groupe de projet
- Maintien de la documentation technique et utilisateur
- Gestion du repository Git

---

## C) Qualité au niveau processus de développement

### I. Modèle de développement retenu

**Méthodologie** : Développement Agile avec cycles itératifs

**Architecture** :
- **Architecture 3-tiers** : Frontend (Web + Mobile), Backend API, Base de données
- **Microservices** : Services modulaires (Auth, Tests, Voice Analysis, Chat)
- **API RESTful** : Communication standardisée entre composants

### II. Phases de développement

#### 1. Spécification et Analyse

**Objectifs** :
- Définir les besoins fonctionnels et non-fonctionnels
- Identifier les cas d'utilisation principaux
- Définir l'architecture technique

**Livrables** :
- Dossier de spécification fonctionnelle (DSF)
- Schéma d'architecture système
- Modèle de données (MCD/MLD)
- Spécifications des interfaces API

**Critères de qualité** :
- Complétude des spécifications
- Cohérence entre les composants
- Validation par le client

#### 2. Conception

**Objectifs** :
- Concevoir l'architecture détaillée de chaque composant
- Définir les interfaces entre modules
- Planifier les tests

**Livrables** :
- Dossier de conception technique (DCT)
- Diagrammes UML (classes, séquences, composants)
- Schéma de base de données
- Plan de tests (PUT)
- Documentation API (Swagger/OpenAPI)

**Critères de qualité** :
- Respect des principes SOLID
- Modularité et réutilisabilité
- Sécurité by design

#### 3. Développement

**Objectifs** :
- Implémenter les fonctionnalités selon les spécifications
- Respecter les standards de codage
- Documenter le code

**Livrables** :
- Code source versionné (Git)
- Tests unitaires
- Documentation technique

**Critères de qualité** :
- Couverture de tests > 70%
- Respect des conventions de nommage
- Code review obligatoire
- Absence de code dupliqué

#### 4. Tests et Validation

**Objectifs** :
- Valider le bon fonctionnement de chaque composant
- Tester l'intégration entre composants
- Valider les performances

**Livrables** :
- Rapports de tests unitaires
- Rapports de tests d'intégration
- Rapports de tests de performance
- Dossier de recette

**Critères de qualité** :
- Tous les tests passent
- Couverture de code satisfaisante
- Performances conformes aux exigences

---

## D) Documentation

### I. Règles de gestion et de structuration des documents

#### a) Identification des documents

Format de nommage des fichiers :
```
[Composant]_[Type]_[Nom]_v[Version].[Extension]
```

**Exemples** :
- `Backend_API_Documentation_v1.0.md`
- `Mobile_UserGuide_v2.1.pdf`
- `PAQP_MyEmoHealth_v1.0.md`

#### b) Présentation des documents

**Standards de documentation** :
- **Format** : Markdown (.md) pour la documentation technique
- **Police** : Verdana, taille 11 (pour PDF)
- **Structure obligatoire** :
  - Page de garde (titre, version, date, auteur)
  - Table des matières
  - Historique des versions
  - Contenu
  - Annexes si nécessaire

**En-tête de chaque document** :
- Titre du projet : MyEmoHealth
- Titre du document
- Numéro de version
- Date de dernière mise à jour

#### c) État d'un document

| État | Description |
|------|-------------|
| **Brouillon** | Document en cours d'élaboration |
| **Terminé** | Document terminé par l'auteur, prêt à être diffusé |
| **Vérifié** | Document approuvé par le responsable qualité |
| **Validé CP** | Document approuvé par le chef de projet |
| **Validé Client** | Document validé par le client/MOA |

#### d) Gestion des versions

Format de version : **vX.Y.Z**
- **X** : Version majeure (changements importants, breaking changes)
- **Y** : Version mineure (nouvelles fonctionnalités)
- **Z** : Patch (corrections de bugs)

### II. Liste des documents de gestion de projet

| Document | Responsable | Fréquence |
|----------|-------------|-----------|
| Plan d'Assurance Qualité Projet (PAQP) | RQ | Initial + MAJ si nécessaire |
| Planning prévisionnel | CdP | Hebdomadaire |
| Compte-rendu de réunion | CdP | Après chaque réunion |
| Rapport d'avancement | CdP | Hebdomadaire |
| Dossier de bilan | CdP | Fin de projet |
| Registre des risques | CdP | Continu |

### III. Liste des documents techniques

#### Backend (Spring Boot)

| Document | Description |
|----------|-------------|
| API_DOCUMENTATION.md | Documentation complète des endpoints REST |
| Architecture_Backend.md | Architecture et design patterns utilisés |
| Database_Schema.md | Schéma de base de données PostgreSQL |
| Security_Guide.md | Implémentation JWT et sécurité |
| Deployment_Guide.md | Guide de déploiement backend |

#### Frontend Web (Angular)

| Document | Description |
|----------|-------------|
| Component_Documentation.md | Documentation des composants Angular |
| Routing_Guide.md | Structure de navigation |
| State_Management.md | Gestion des états (services) |
| Style_Guide.md | Guide de style et design system |
| Build_Deploy.md | Instructions de build et déploiement |

#### Mobile (Flutter)

| Document | Description |
|----------|-------------|
| Flutter_Architecture.md | Architecture de l'app mobile |
| Widgets_Documentation.md | Documentation des widgets personnalisés |
| API_Integration.md | Intégration avec le backend |
| Platform_Specific.md | Spécificités iOS/Android |
| Release_Guide.md | Guide de publication (App Store/Play Store) |

#### Documentation utilisateur

| Document | Description |
|----------|-------------|
| Manuel_Utilisateur_Medecin.pdf | Guide pour les médecins (portail web) |
| Manuel_Utilisateur_Patient.pdf | Guide pour les patients (app mobile) |
| FAQ.md | Questions fréquentes |
| QUICK_START.md | Guide de démarrage rapide |

---

## E) Gestion des modifications

### I. Origine des modifications

Les modifications peuvent provenir de :
- **Corrections de bugs** : Erreurs détectées en développement ou production
- **Évolutions fonctionnelles** : Nouvelles demandes du client
- **Améliorations techniques** : Optimisations, refactoring
- **Mises à jour de sécurité** : Patches de sécurité
- **Retours utilisateurs** : Feedback des médecins et patients

### II. Procédure de mise en œuvre des modifications

#### Workflow de modification

1. **Identification** : Création d'une issue Git avec description détaillée
2. **Évaluation** : Analyse d'impact par l'équipe technique
3. **Priorisation** : Classification (Critique/Haute/Moyenne/Basse)
4. **Planification** : Assignation et estimation
5. **Développement** : Implémentation sur branche dédiée
6. **Revue de code** : Code review obligatoire
7. **Tests** : Tests unitaires et d'intégration
8. **Validation** : Validation par le RQ
9. **Déploiement** : Merge et déploiement
10. **Documentation** : Mise à jour de la documentation

#### Gestion des branches Git

```
main (production)
  ├── develop (intégration)
  │   ├── feature/nom-fonctionnalite
  │   ├── bugfix/nom-bug
  │   └── hotfix/nom-correctif-urgent
```

**Règles** :
- Pas de commit direct sur `main`
- Pull Request obligatoire avec review
- Tests automatisés doivent passer
- Squash commits avant merge

---

## F) Méthodes, Outils et Règles

### I. Méthodes et méthodologies retenues

#### Backend (Java/Spring Boot)

**Principes** :
- Architecture en couches (Controller, Service, Repository)
- Injection de dépendances (Spring IoC)
- Programmation orientée aspect (AOP) pour logging
- Gestion transactionnelle

**Patterns** :
- Repository Pattern
- Service Layer Pattern
- DTO (Data Transfer Object)
- Builder Pattern (Lombok)

#### Frontend Web (Angular)

**Principes** :
- Component-based architecture
- Reactive programming (RxJS)
- Lazy loading des modules
- State management via services

**Patterns** :
- Smart/Dumb components
- Observable pattern
- Dependency Injection

#### Mobile (Flutter)

**Principes** :
- Widget composition
- State management (setState, Provider)
- Responsive design
- Platform-specific adaptations

**Patterns** :
- BLoC (Business Logic Component)
- Repository Pattern
- Service Locator

### II. Outils logiciels

#### Développement

| Outil | Usage | Composant |
|-------|-------|-----------|
| IntelliJ IDEA / VS Code | IDE | Backend |
| VS Code | IDE | Frontend Web |
| Android Studio / VS Code | IDE | Mobile |
| Git | Contrôle de version | Tous |
| Maven | Build tool | Backend |
| npm | Package manager | Frontend Web |
| pub | Package manager | Mobile |

#### Base de données

| Outil | Usage |
|-------|-------|
| PostgreSQL | SGBD principal |
| pgAdmin | Administration BD |
| Flyway / Liquibase | Migration de schéma |

#### Tests

| Outil | Usage | Composant |
|-------|-------|-----------|
| JUnit 5 | Tests unitaires | Backend |
| Mockito | Mocking | Backend |
| Jasmine/Karma | Tests unitaires | Frontend Web |
| Flutter Test | Tests | Mobile |
| Postman | Tests API | Backend |

#### CI/CD

| Outil | Usage |
|-------|-------|
| GitHub Actions | CI/CD pipeline |
| Docker | Containerisation |
| Docker Compose | Orchestration locale |

#### Documentation

| Outil | Usage |
|-------|-------|
| Swagger/OpenAPI | Documentation API |
| Markdown | Documentation technique |
| Mermaid | Diagrammes |
| Draw.io | Schémas d'architecture |

#### Communication

| Outil | Usage |
|-------|-------|
| Slack / Teams | Communication équipe |
| Jira / GitHub Issues | Gestion de projet |
| Confluence / Wiki | Base de connaissances |

### III. Règles et normes devant être appliquées

#### Standards de code

**Java (Backend)** :
- Google Java Style Guide
- Checkstyle configuration
- SonarLint pour analyse statique
- Couverture de tests minimale : 70%

**TypeScript/Angular (Frontend Web)** :
- Angular Style Guide officiel
- ESLint configuration
- Prettier pour formatage
- Couverture de tests minimale : 60%

**Dart/Flutter (Mobile)** :
- Effective Dart guidelines
- Flutter Linter
- Couverture de tests minimale : 60%

#### Conventions de nommage

**Backend (Java)** :
```java
// Classes : PascalCase
public class UserService { }

// Méthodes : camelCase
public User findUserById(Long id) { }

// Constantes : UPPER_SNAKE_CASE
private static final String API_VERSION = "v1";

// Variables : camelCase
private String userName;
```

**Frontend Web (TypeScript)** :
```typescript
// Classes/Interfaces : PascalCase
export class PatientDetailComponent { }

// Méthodes/Variables : camelCase
getUserData(): Observable<User> { }

// Constantes : UPPER_SNAKE_CASE
const API_BASE_URL = 'http://localhost:8082';
```

**Mobile (Dart)** :
```dart
// Classes : PascalCase
class QcmRunnerScreen extends StatefulWidget { }

// Méthodes/Variables : camelCase
Future<void> submitTest() async { }

// Constantes : lowerCamelCase
const double defaultPadding = 16.0;
```

#### Sécurité

**Règles obligatoires** :
- Validation des entrées utilisateur
- Sanitization des données
- Utilisation de requêtes préparées (SQL injection)
- Chiffrement des mots de passe (BCrypt)
- HTTPS obligatoire en production
- Gestion sécurisée des tokens JWT
- CORS configuré correctement
- Rate limiting sur les endpoints sensibles

#### Performance

**Critères** :
- Temps de réponse API < 500ms (95th percentile)
- Temps de chargement page web < 3s
- Temps de démarrage app mobile < 2s
- Optimisation des requêtes SQL (index, N+1 queries)
- Lazy loading des ressources
- Compression des assets

---

## G) Tests et Validation

### I. Stratégie de tests

#### Pyramide des tests

```
        /\
       /  \  Tests E2E (10%)
      /____\
     /      \  Tests d'intégration (30%)
    /________\
   /          \  Tests unitaires (60%)
  /__________\
```

### II. Types de tests

#### Tests unitaires

**Backend** :
- Tests des services métier
- Tests des repositories
- Tests des utilitaires
- Mocking des dépendances

**Frontend Web** :
- Tests des composants
- Tests des services
- Tests des pipes
- Tests des guards

**Mobile** :
- Tests des widgets
- Tests de la logique métier
- Tests des services

#### Tests d'intégration

**Backend** :
- Tests des controllers avec MockMvc
- Tests d'intégration base de données
- Tests des endpoints API

**Frontend** :
- Tests d'intégration composants
- Tests de navigation
- Tests d'appels API

#### Tests end-to-end (E2E)

**Scénarios critiques** :
- Authentification médecin/patient
- Création et passage de test QCM
- Chat en temps réel
- Analyse vocale IA
- Consultation des résultats

**Outils** :
- Selenium / Cypress (Web)
- Flutter Driver (Mobile)

### III. Critères d'acceptation

**Fonctionnels** :
- Toutes les user stories sont implémentées
- Tous les cas d'utilisation fonctionnent
- Interface conforme aux maquettes

**Techniques** :
- Couverture de tests > 70% (backend), > 60% (frontend)
- Aucun bug critique ou bloquant
- Performance conforme aux exigences
- Sécurité validée (scan de vulnérabilités)

**Documentation** :
- Documentation API complète
- Manuels utilisateur finalisés
- Guide de déploiement à jour

---

## H) Reproduction, Protection et livraison

### I. Précautions à prendre

#### Protection du code source

- Repository Git privé
- Contrôle d'accès par rôle
- Branches protégées (main, develop)
- Signature des commits (GPG)
- Backup régulier du repository

#### Protection des données

- Chiffrement des données sensibles
- Anonymisation des données de test
- Conformité RGPD
- Logs sécurisés (pas de données sensibles)
- Gestion sécurisée des secrets (variables d'environnement)

#### Sauvegarde

- Backup quotidien de la base de données
- Backup du code source (Git + mirror)
- Backup de la documentation
- Plan de reprise d'activité (PRA)

### II. Modalités de livraison

#### Environnements

| Environnement | Usage | URL |
|---------------|-------|-----|
| **Développement** | Développement actif | localhost |
| **Recette** | Tests clients | recette.myemohealth.com |
| **Production** | Utilisateurs finaux | www.myemohealth.com |

#### Processus de livraison

**Backend** :
1. Build Maven : `mvn clean package`
2. Tests automatisés
3. Génération de l'artifact (JAR)
4. Déploiement Docker
5. Tests de fumée
6. Monitoring

**Frontend Web** :
1. Build Angular : `ng build --prod`
2. Optimisation des assets
3. Déploiement sur serveur web
4. Tests de fumée
5. Monitoring

**Mobile** :
1. Build Flutter : `flutter build apk/ios`
2. Tests sur devices réels
3. Soumission App Store / Play Store
4. Validation par les stores
5. Publication

#### Livrables

**Code** :
- Archive du code source (Git tag)
- Binaires compilés
- Scripts de déploiement
- Configuration (templates)

**Documentation** :
- Documentation technique
- Manuels utilisateur
- Guide d'installation
- Release notes

**Tests** :
- Rapports de tests
- Certificats de recette
- Plan de tests

---

## I) Suivi de l'application du plan qualité

### I. Principes

L'application du présent PAQP est primordiale pour obtenir un produit final de qualité. Il est donc important de s'assurer tout au long du projet que les règles spécifiées sont bien appliquées.

### II. Interventions du Responsable Qualité

Le RQ intervient à différents moments :

#### Revues de code

- Fréquence : Chaque Pull Request
- Critères : Respect des standards, tests, documentation
- Outils : GitHub PR reviews, SonarQube

#### Audits qualité

- Fréquence : Mensuelle
- Scope : Code, documentation, processus
- Livrables : Rapport d'audit avec actions correctives

#### Validation des livrables

- Revue des documents avant diffusion
- Validation des releases
- Vérification de la complétude

#### Métriques qualité

**Indicateurs suivis** :
- Couverture de tests
- Nombre de bugs (par sévérité)
- Dette technique (SonarQube)
- Temps de résolution des bugs
- Respect des délais
- Satisfaction client

**Tableaux de bord** :
- Dashboard SonarQube
- Rapports de tests automatisés
- Métriques Git (commits, PR, reviews)

### III. Procédure à suivre en cas de non-respect

#### Détection

- Revue de code
- Audit qualité
- Tests automatisés
- Feedback utilisateur

#### Actions correctives

1. **Identification** : Documenter la non-conformité
2. **Analyse** : Identifier la cause racine
3. **Plan d'action** : Définir les actions correctives
4. **Mise en œuvre** : Corriger le problème
5. **Vérification** : Valider la correction
6. **Prévention** : Mettre en place des mesures préventives

#### Escalade

- **Niveau 1** : Discussion avec le développeur
- **Niveau 2** : Alerte au chef de projet
- **Niveau 3** : Réunion d'équipe
- **Niveau 4** : Escalade à la direction

---

## J) Conclusion

Ce Plan d'Assurance Qualité Projet définit les dispositions que la Maîtrise d'Œuvre doit suivre pour le projet MyEmoHealth. L'objectif recherché est d'atteindre un niveau de qualité élevé tout en restant pragmatique et adapté à la nature du projet.

### Points clés

**Organisation** :
- Rôles et responsabilités clairement définis
- Communication fluide entre les équipes

**Processus** :
- Méthodologie agile adaptée au projet
- Cycles de développement itératifs
- Validation continue

**Outils** :
- Stack technique moderne et éprouvée
- Outils de qualité intégrés au workflow
- Automatisation maximale

**Documentation** :
- Standards de documentation clairs
- Documentation technique complète
- Manuels utilisateur détaillés

**Tests** :
- Stratégie de tests complète
- Couverture de tests satisfaisante
- Tests automatisés

**Qualité** :
- Suivi régulier par le RQ
- Métriques qualité mesurables
- Amélioration continue

### Engagement qualité

L'équipe MyEmoHealth s'engage à :
- Respecter les standards définis dans ce PAQP
- Maintenir une qualité élevée du code et de la documentation
- Assurer la sécurité et la confidentialité des données
- Livrer un produit conforme aux attentes du client
- Améliorer continuellement les processus et pratiques

---

**Document approuvé par** :

| Rôle | Nom | Signature | Date |
|------|-----|-----------|------|
| Responsable Qualité | | | |
| Chef de Projet | | | |
| Client/MOA | | | |

---

*Ce document est confidentiel et propriété du projet MyEmoHealth.*
