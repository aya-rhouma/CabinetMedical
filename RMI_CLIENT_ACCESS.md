# RMI - acces client distant

Pour qu'un PC client accede a tous les services RMI et utilise les JSP:

## 1) Cote serveur (WildFly)

Demarrer le serveur avec une IP joignable depuis le reseau:

```bash
-Dcabinetmedical.rmi.hostname=192.168.1.20
-Dcabinetmedical.rmi.port=1099
-Dcabinetmedical.rmi.objectPort=1100
```

Notes:
- `cabinetmedical.rmi.hostname` est l'IP du serveur visible par le PC client.
- `cabinetmedical.rmi.port` est le port du registre RMI.
- `cabinetmedical.rmi.objectPort` est le port des objets distants (fixe pour eviter les ports aleatoires).

## 2) Firewall / reseau

Ouvrir au minimum:
- `1099/tcp` (registre RMI)
- `1100/tcp` (objets RMI)
- port HTTP de WildFly (ex: `8080/tcp`) pour les JSP.

## 3) Cote client Java

Utiliser `RemoteServicesLocator`:

- `com.jee.rmi.client.RemoteServicesLocator`
- `com.jee.rmi.client.RmiClientConfig`

ou lancer l'exemple:

```bash
java -Dcabinetmedical.rmi.host=192.168.1.20 -Dcabinetmedical.rmi.port=1099 com.jee.rmi.client.PatientClient
```

Le client verifie l'accessibilite de:
- AuthService
- PatientService
- MedecinService
- SecretaireService
- AdminService
- NotificationService
