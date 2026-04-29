package com.jee.rmi.server;

import com.jee.rmi.remote.CallbackClient;
import com.jee.rmi.remote.NotificationService;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

public class NotificationServiceImpl implements NotificationService {

    private static final NotificationServiceImpl INSTANCE = new NotificationServiceImpl();

    private final Map<Integer, List<CallbackClient>> callbacksByPatient = new ConcurrentHashMap<>();
    private final Map<Integer, List<String>> pendingNotificationsByPatient = new ConcurrentHashMap<>();

    private NotificationServiceImpl() {
    }

    public static NotificationServiceImpl getInstance() {
        return INSTANCE;
    }

    @Override
    public void registerClient(int patientId, CallbackClient callbackClient) {
        callbacksByPatient
                .computeIfAbsent(patientId, ignored -> new CopyOnWriteArrayList<>())
                .add(callbackClient);
    }

    @Override
    public void unregisterClient(int patientId, CallbackClient callbackClient) {
        List<CallbackClient> callbacks = callbacksByPatient.get(patientId);
        if (callbacks != null) {
            callbacks.remove(callbackClient);
        }
    }

    @Override
    public void notifyPatient(int patientId, String message) {
        pendingNotificationsByPatient
                .computeIfAbsent(patientId, ignored -> new CopyOnWriteArrayList<>())
                .add(message);

        List<CallbackClient> callbacks = callbacksByPatient.getOrDefault(patientId, Collections.emptyList());
        for (CallbackClient callback : callbacks) {
            callback.onNotification(message);
        }
    }

    @Override
    public List<String> consumePendingNotifications(int patientId) {
        List<String> pending = pendingNotificationsByPatient.getOrDefault(patientId, Collections.emptyList());
        if (pending.isEmpty()) {
            return Collections.emptyList();
        }
        List<String> copy = new ArrayList<>(pending);
        pending.clear();
        return copy;
    }
}
