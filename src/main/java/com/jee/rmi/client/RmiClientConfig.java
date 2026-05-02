package com.jee.rmi.client;

public record RmiClientConfig(String host, int registryPort) {

    private static final String HOST_PROPERTY = "cabinetmedical.rmi.host";
    private static final String PORT_PROPERTY = "cabinetmedical.rmi.port";
    private static final String DEFAULT_HOST = "127.0.0.1";
    private static final int DEFAULT_PORT = 1099;

    public static RmiClientConfig fromSystemProperties() {
        String host = System.getProperty(HOST_PROPERTY, DEFAULT_HOST).trim();
        String rawPort = System.getProperty(PORT_PROPERTY, String.valueOf(DEFAULT_PORT)).trim();
        try {
            return new RmiClientConfig(host, Integer.parseInt(rawPort));
        } catch (NumberFormatException e) {
            return new RmiClientConfig(host, DEFAULT_PORT);
        }
    }
}
