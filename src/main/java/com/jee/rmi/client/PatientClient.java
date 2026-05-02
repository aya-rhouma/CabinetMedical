package com.jee.rmi.client;

import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

import com.jee.rmi.remote.CallbackClient;
import com.jee.rmi.remote.NotificationService;
import com.jee.rmi.remote.PatientServiceRemote;

public class PatientClient {

	public static void main(String[] args) throws Exception {
		String host = args.length > 0 ? args[0] : System.getProperty("cabinetmedical.rmi.host", "127.0.0.1");
		String rawPort = args.length > 1 ? args[1] : System.getProperty("cabinetmedical.rmi.port", "1099");
		int port = Integer.parseInt(rawPort);

		RemoteServicesLocator locator = new RemoteServicesLocator(new RmiClientConfig(host, port));
		System.out.println("Services RMI disponibles: " + locator.listAvailableServices());

		// Vérifie que tous les services sont bien accessibles côté client
		locator.authService();
		locator.patientService();
		locator.medecinService();
		locator.secretaireService();
		locator.adminService();
		NotificationService notificationService = locator.notificationService();
		PatientServiceRemote patientService = locator.patientService();

		System.out.println("Services RMI disponibles sur " + host + ":" + port);
		System.out.println("Spécialités: " + patientService.getAllSpecialites());

		if (args.length > 2 && "watch-notifications".equalsIgnoreCase(args[2])) {
			int patientId = args.length > 3 ? Integer.parseInt(args[3]) : 1;
			ConsoleCallbackClient callback = new ConsoleCallbackClient();
			notificationService.registerClient(patientId, callback);
			System.out.println("Callback enregistré pour le patient " + patientId);
			System.out.println("Notifications en attente: " + notificationService.consumePendingNotifications(patientId));
		}
	}

	private static class ConsoleCallbackClient extends UnicastRemoteObject implements CallbackClient {

		protected ConsoleCallbackClient() throws RemoteException {
			super();
		}

		@Override
		public void onNotification(String message) {
			System.out.println("Notification reçue: " + message);
		}
	}
}
