# CabinetMedical

Application web de gestion de cabinet medical realisee avec Jakarta EE, JSP/Servlets, EJB, JPA/Hibernate et MySQL. Le projet propose aussi un acces a distance via RMI pour verifier les services exposes cote serveur.

## Fonctionnalites

- Authentification et gestion des comptes.
- Portails dedies pour les roles `admin`, `medecin`, `secretaire` et `patient`.
- Gestion des rendez-vous.
- Gestion des dossiers patients, certificats et demandes de certificats.
- Gestion du personnel et du materiel.
- Services distants RMI pour l'acces client.

## Technologies

- Java 21
- Jakarta EE 10
- JSP / Servlets
- EJB
- CDI
- JPA avec Hibernate
- MySQL
- WildFly / JBoss
- Maven

## Architecture EJB et RMI

Le projet est organise autour de deux couches de services complementaires.

### Couche EJB

- Les regles metier principales sont implementees dans des beans `@Stateless`.
- Chaque domaine expose une interface locale `@Local` et une implementation EJB correspondante.
- Les couches web et les composants techniques utilisent ces interfaces pour acceder a la logique metier sans connaitre le detail d'implementation.
- La persistance est geree via `EntityManager` injecte avec `@PersistenceContext`, ce qui centralise les acces JPA/Hibernate.

En pratique, le flux est le suivant:

1. Une page JSP, un servlet ou un composant serveur declenche une action metier.
2. L'application invoque une interface locale EJB comme `AuthServiceLocal`.
3. Le bean `@Stateless` execute la logique, lit ou met a jour les entites JPA, puis retourne le resultat.

### Couche RMI

- Le point d'entree RMI est `com.jee.rmi.server.RmiBootstrap`.
- Ce composant est un `@Singleton @Startup`, donc il s'initialise automatiquement au demarrage du serveur.
- Au lancement, il recupere les services EJB locaux puis les expose dans le registre RMI sous des noms fixes.
- Le client distant ne parle pas directement aux entites ou a la base: il appelle des facades RMI qui deleguent ensuite vers les EJB.

Flux de bout en bout:

1. Le serveur WildFly demarre et instancie `RmiBootstrap`.
2. `RmiBootstrap` cree ou reutilise le registre RMI.
3. Les services locaux EJB sont exportes en objets distants.
4. Les stubs sont binds sous des noms comme `CabinetMedical/AuthService`.
5. Un client Java resout le service RMI puis appelle les methodes distantes.
6. L'implementation distante redirige vers le service EJB pour reutiliser la logique metier existante.

Cette organisation permet de garder une seule logique metier tout en offrant deux points d'acces: l'application web et les clients distants RMI.

## Prerequis

- JDK 21
- Maven 3.9+ ou le wrapper Maven inclus
- WildFly ou un serveur compatible Jakarta EE
- MySQL 8+

## Arborescence

- `src/main/java` : code source Java
- `src/main/resources/META-INF/persistence.xml` : configuration JPA
- `src/main/webapp` : JSP, CSS, JS et pages web
- `standalone.xml` : exemple de configuration WildFly avec datasource
- `MYSQL_JNDI_SETUP.md` : configuration MySQL/JNDI
- `RMI_CLIENT_ACCESS.md` : acces distant au client RMI

## Configuration base de donnees

Le projet utilise le JNDI suivant dans `persistence.xml`:

```xml
java:/jdbc/cabinetMedical
```

### 1. Creer la base MySQL

```sql
CREATE DATABASE cabinet_medical CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 2. Configurer le datasource

Verifier dans WildFly/JBoss que le datasource pointe vers la base MySQL avec le JNDI suivant:

- `java:/jdbc/cabinetMedical`

Le fichier `standalone.xml` du projet contient deja un exemple de configuration.

## Compilation

Avec le wrapper Maven:

```bash
./mvnw clean package
```

Sous Windows:

```bat
mvnw.cmd clean package
```

Pour une compilation rapide sans tests:

```bat
mvnw.cmd -q -DskipTests compile
```

## Execution

1. Configurer MySQL et le datasource WildFly.
2. Demarrer WildFly.
3. Deployer le fichier `target/CabinetMedical-1.0-SNAPSHOT.war`.
4. Ouvrir l'application dans le navigateur via l'URL fournie par le serveur, par exemple `http://localhost:8080/CabinetMedical-1.0-SNAPSHOT`.

## RMI

Le projet publie plusieurs services RMI au demarrage.

### Parametres utiles

- Port registre RMI par defaut: `1099`
- Override du port: `cabinetmedical.rmi.port`
- Override du host: `cabinetmedical.rmi.hostname`

Exemple de demarrage cote serveur:

```bash
-Dcabinetmedical.rmi.hostname=192.168.1.20
-Dcabinetmedical.rmi.port=1099
```

### Client d'exemple

Un client de test est disponible via `com.jee.rmi.client.PatientClient`.

Exemple:

```bash
java -Dcabinetmedical.rmi.host=192.168.1.20 -Dcabinetmedical.rmi.port=1099 com.jee.rmi.client.PatientClient
```

## Services exposes

- `CabinetMedical/AuthService`
- `CabinetMedical/PatientService`
- `CabinetMedical/MedecinService`
- `CabinetMedical/SecretaireService`
- `CabinetMedical/AdminService`
- `CabinetMedical/NotificationService`

## Pages principales

- `jsp/auth` : login, inscription, mot de passe oublie
- `jsp/admin` : dashboard, medecins, secretaires, materiels
- `jsp/medecin` : dashboard, patients, rendez-vous, dossier, certificats
- `jsp/patient` : dashboard, formulaire, liste, demandes de certificats
- `jsp/secretaire` : dashboard, patients, rendez-vous, fiche patient, materiels

## Notes

- La configuration MySQL detaillee est dans `MYSQL_JNDI_SETUP.md`.
- Les consignes RMI cote client sont dans `RMI_CLIENT_ACCESS.md`.