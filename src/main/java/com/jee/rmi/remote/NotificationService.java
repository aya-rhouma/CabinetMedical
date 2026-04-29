package com.jee.rmi.remote;

import java.util.List;

public interface NotificationService {
    void registerClient(int patientId, CallbackClient callbackClient);

    void unregisterClient(int patientId, CallbackClient callbackClient);

    void notifyPatient(int patientId, String message);

    List<String> consumePendingNotifications(int patientId);
}
