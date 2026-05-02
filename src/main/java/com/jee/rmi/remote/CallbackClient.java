package com.jee.rmi.remote;

import java.rmi.Remote;
import java.rmi.RemoteException;

@FunctionalInterface
public interface CallbackClient extends Remote {
    void onNotification(String message) throws RemoteException;
}
