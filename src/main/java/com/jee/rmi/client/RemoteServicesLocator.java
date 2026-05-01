package com.jee.rmi.client;

import java.rmi.NotBoundException;
import java.rmi.Remote;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.util.Arrays;
import java.util.List;

import com.jee.rmi.remote.AdminServiceRemote;
import com.jee.rmi.remote.AuthServiceRemote;
import com.jee.rmi.remote.MedecinServiceRemote;
import com.jee.rmi.remote.NotificationService;
import com.jee.rmi.remote.PatientServiceRemote;
import com.jee.rmi.remote.SecretaireServiceRemote;
import com.jee.rmi.server.RmiServiceNames;

public class RemoteServicesLocator {

    private final Registry registry;

    public RemoteServicesLocator(RmiClientConfig config) throws RemoteException {
        this.registry = LocateRegistry.getRegistry(config.host(), config.registryPort());
    }

    public List<String> listAvailableServices() throws RemoteException {
        return Arrays.asList(registry.list());
    }

    public AuthServiceRemote authService() throws RemoteException {
        return lookup(RmiServiceNames.AUTH, AuthServiceRemote.class);
    }

    public PatientServiceRemote patientService() throws RemoteException {
        return lookup(RmiServiceNames.PATIENT, PatientServiceRemote.class);
    }

    public MedecinServiceRemote medecinService() throws RemoteException {
        return lookup(RmiServiceNames.MEDECIN, MedecinServiceRemote.class);
    }

    public SecretaireServiceRemote secretaireService() throws RemoteException {
        return lookup(RmiServiceNames.SECRETAIRE, SecretaireServiceRemote.class);
    }

    public AdminServiceRemote adminService() throws RemoteException {
        return lookup(RmiServiceNames.ADMIN, AdminServiceRemote.class);
    }

    public NotificationService notificationService() throws RemoteException {
        return lookup(RmiServiceNames.NOTIFICATION, NotificationService.class);
    }

    private <T extends Remote> T lookup(String serviceName, Class<T> remoteType) throws RemoteException {
        try {
            Remote remote = registry.lookup(serviceName);
            return remoteType.cast(remote);
        } catch (NotBoundException e) {
            throw new RemoteException("Service RMI introuvable: " + serviceName, e);
        } catch (ClassCastException e) {
            throw new RemoteException("Type de stub invalide pour " + serviceName, e);
        }
    }
}
