package com.jee.rmi.server;

import java.rmi.NoSuchObjectException;
import java.rmi.NotBoundException;
import java.rmi.Remote;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;
import java.net.Inet4Address;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.Enumeration;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.jee.ejb.interfaces.AdminServiceLocal;
import com.jee.ejb.interfaces.AuthServiceLocal;
import com.jee.ejb.interfaces.MedecinServiceLocal;
import com.jee.ejb.interfaces.PatientServiceLocal;
import com.jee.ejb.interfaces.SecretaireServiceLocal;
import com.jee.rmi.remote.AdminServiceRemote;
import com.jee.rmi.remote.AuthServiceRemote;
import com.jee.rmi.remote.MedecinServiceRemote;
import com.jee.rmi.remote.NotificationService;
import com.jee.rmi.remote.PatientServiceRemote;
import com.jee.rmi.remote.SecretaireServiceRemote;

import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import jakarta.ejb.EJB;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;

@Singleton
@Startup
public class RmiBootstrap {

    private static final Logger LOGGER = Logger.getLogger(RmiBootstrap.class.getName());
    private static final String RMI_HOST_PROPERTY = "cabinetmedical.rmi.hostname";

    @EJB
    private AuthServiceLocal authService;

    @EJB
    private PatientServiceLocal patientService;

    @EJB
    private MedecinServiceLocal medecinService;

    @EJB
    private SecretaireServiceLocal secretaireService;

    @EJB
    private AdminServiceLocal adminService;

    private final NotificationService notificationService = NotificationServiceImpl.getInstance();
    private final Map<String, RemoteServiceBinding<? extends Remote>> boundServices = new LinkedHashMap<>();

    private Registry registry;

    @PostConstruct
    public void start() throws RemoteException {
        configureHostname();
        registry = getOrCreateRegistry(getRmiPort());
        bind(RmiServiceNames.AUTH, AuthServiceRemote.class, authService);
        bind(RmiServiceNames.PATIENT, PatientServiceRemote.class, patientService);
        bind(RmiServiceNames.MEDECIN, MedecinServiceRemote.class, medecinService);
        bind(RmiServiceNames.SECRETAIRE, SecretaireServiceRemote.class, secretaireService);
        bind(RmiServiceNames.ADMIN, AdminServiceRemote.class, adminService);
        bind(RmiServiceNames.NOTIFICATION, NotificationService.class, notificationService);
        LOGGER.info(() -> "Services RMI publiés sur le port " + getRmiPort());
    }

    @PreDestroy
    public void stop() {
        if (registry != null) {
            boundServices.keySet().forEach(name -> {
                try {
                    registry.unbind(name);
                } catch (NotBoundException | RemoteException e) {
                    LOGGER.log(Level.FINE, "Impossible de dépublier le service RMI " + name, e);
                }
            });
        }
        boundServices.values().forEach(binding -> {
            try {
                UnicastRemoteObject.unexportObject(binding.getExportedObject(), true);
            } catch (NoSuchObjectException e) {
                LOGGER.log(Level.FINE, "Impossible de désexporter un objet RMI", e);
            }
        });
        if (registry != null) {
            try {
                UnicastRemoteObject.unexportObject(registry, true);
            } catch (NoSuchObjectException e) {
                LOGGER.log(Level.FINE, "Impossible de désexporter le registre RMI", e);
            }
        }
    }

    private <T extends Remote> void bind(String name, Class<T> remoteType, Object delegate) throws RemoteException {
        RemoteServiceBinding<T> binding = RemoteServiceFactory.export(remoteType, delegate);
        registry.rebind(name, binding.getStub());
        boundServices.put(name, binding);
    }

    private Registry getOrCreateRegistry(int port) throws RemoteException {
        try {
            Registry existingRegistry = LocateRegistry.getRegistry(port);
            existingRegistry.list();
            return existingRegistry;
        } catch (RemoteException e) {
            return LocateRegistry.createRegistry(port);
        }
    }

    private void configureHostname() {
        String hostname = System.getProperty(RMI_HOST_PROPERTY);
        if (hostname == null || hostname.isBlank()) {
            hostname = detectServerAddress();
        }
        if (hostname != null && !hostname.isBlank()) {
            System.setProperty("java.rmi.server.hostname", hostname.trim());
            LOGGER.info("RMI hostname configuré sur " + hostname.trim());
        } else {
            LOGGER.warning("Hostname RMI non résolu automatiquement. "
                    + "Définissez -D" + RMI_HOST_PROPERTY + "=<ip_serveur> pour les clients distants.");
        }
    }

    private String detectServerAddress() {
        try {
            Enumeration<NetworkInterface> interfaces = NetworkInterface.getNetworkInterfaces();
            while (interfaces.hasMoreElements()) {
                NetworkInterface networkInterface = interfaces.nextElement();
                if (!networkInterface.isUp() || networkInterface.isLoopback() || networkInterface.isVirtual()) {
                    continue;
                }
                Enumeration<InetAddress> inetAddresses = networkInterface.getInetAddresses();
                while (inetAddresses.hasMoreElements()) {
                    InetAddress address = inetAddresses.nextElement();
                    if (address instanceof Inet4Address inet4Address && !inet4Address.isLoopbackAddress()) {
                        return inet4Address.getHostAddress();
                    }
                }
            }
        } catch (SocketException e) {
            LOGGER.log(Level.FINE, "Impossible de détecter l'adresse IP du serveur RMI", e);
        }
        return null;
    }

    private int getRmiPort() {
        String value = System.getProperty("cabinetmedical.rmi.port", "1099");
        return Integer.parseInt(value.trim());
    }
}