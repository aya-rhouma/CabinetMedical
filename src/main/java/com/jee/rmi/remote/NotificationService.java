package com.jee.rmi.remote;

import java.rmi.Remote;
import java.rmi.RemoteException;
import java.util.List;

public interface NotificationService extends Remote {
    void registerClient(int patientId, CallbackClient callbackClient) throws RemoteException;

    void unregisterClient(int patientId, CallbackClient callbackClient) throws RemoteException;

    void notifyPatient(int patientId, String message) throws RemoteException;

    List<String> consumePendingNotifications(int patientId) throws RemoteException;
}
