# Configuration MySQL via JNDI

Le projet est configure pour utiliser ce JNDI:

`java:/jdbc/cabinetMedical`

## 1) Verifier la persistence unit

Le fichier `src/main/resources/META-INF/persistence.xml` utilise deja:

`<jta-data-source>java:/jdbc/cabinetMedical</jta-data-source>`

## 2) Creer la base MySQL

Exemple:

```sql
CREATE DATABASE cabinet_medical CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

## 3) Configurer le datasource WildFly/JBoss

Le fichier `standalone.xml` de ce projet contient deja un datasource:

- JNDI: `java:/jdbc/cabinetMedical`
- URL: `jdbc:mysql://127.0.0.1:3307/cabinet_medical?useSSL=false&serverTimezone=UTC`
- Driver: `com.mysql.cj.jdbc.Driver`

Adaptez si besoin:

- port MySQL (souvent `3306`)
- user/password
- nom de la base

## 4) Driver MySQL

Le projet inclut maintenant la dependance Maven runtime:

- `com.mysql:mysql-connector-j`

Si vous utilisez un module WildFly (`module="com.mysql"`), verifiez aussi que le module MySQL est bien installe sur le serveur.

## 5) Redemarrer le serveur

Apres modification de `standalone.xml`, redemarrez WildFly pour prendre en compte le datasource.

