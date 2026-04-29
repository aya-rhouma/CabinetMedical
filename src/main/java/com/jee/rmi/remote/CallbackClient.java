package com.jee.rmi.remote;

@FunctionalInterface
public interface CallbackClient {
    void onNotification(String message);
}
