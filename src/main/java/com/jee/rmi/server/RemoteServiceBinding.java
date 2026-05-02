package com.jee.rmi.server;

import java.rmi.Remote;

public final class RemoteServiceBinding<T extends Remote> {

    private final T stub;
    private final Remote exportedObject;

    public RemoteServiceBinding(T stub, Remote exportedObject) {
        this.stub = stub;
        this.exportedObject = exportedObject;
    }

    public T getStub() {
        return stub;
    }

    public Remote getExportedObject() {
        return exportedObject;
    }
}