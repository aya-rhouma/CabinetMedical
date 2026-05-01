package com.jee.rmi.server;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.rmi.Remote;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

public final class RemoteServiceFactory {

    private static final String RMI_OBJECT_PORT_PROPERTY = "cabinetmedical.rmi.objectPort";
    private static final int DEFAULT_RMI_OBJECT_PORT = 1100;

    private RemoteServiceFactory() {
    }

    public static <T extends Remote> RemoteServiceBinding<T> export(Class<T> remoteInterface, Object delegate) throws RemoteException {
        InvocationHandler handler = (proxy, method, args) -> invoke(delegate, method, args);
        Remote exportedObject = (Remote) Proxy.newProxyInstance(
                remoteInterface.getClassLoader(),
                new Class<?>[]{remoteInterface},
                handler
        );
        @SuppressWarnings("unchecked")
        T stub = (T) UnicastRemoteObject.exportObject(exportedObject, getObjectPort());
        return new RemoteServiceBinding<>(stub, exportedObject);
    }

    private static int getObjectPort() {
        String rawPort = System.getProperty(RMI_OBJECT_PORT_PROPERTY, String.valueOf(DEFAULT_RMI_OBJECT_PORT));
        try {
            return Integer.parseInt(rawPort.trim());
        } catch (NumberFormatException e) {
            return DEFAULT_RMI_OBJECT_PORT;
        }
    }

    private static Object invoke(Object delegate, Method method, Object[] args) throws Throwable {
        try {
            Method target = delegate.getClass().getMethod(method.getName(), method.getParameterTypes());
            target.setAccessible(true);
            return target.invoke(delegate, args);
        } catch (InvocationTargetException e) {
            Throwable cause = e.getCause();
            if (cause instanceof RuntimeException runtimeException) {
                throw runtimeException;
            }
            if (cause instanceof Error error) {
                throw error;
            }
            if (cause instanceof RemoteException remoteException) {
                throw remoteException;
            }
            throw new RemoteException("Erreur distante pendant l'appel de " + method.getName(), cause);
        } catch (NoSuchMethodException e) {
            throw new RemoteException("Méthode distante introuvable: " + method.getName(), e);
        } catch (IllegalAccessException e) {
            throw new RemoteException("Accès interdit à la méthode distante: " + method.getName(), e);
        }
    }
}