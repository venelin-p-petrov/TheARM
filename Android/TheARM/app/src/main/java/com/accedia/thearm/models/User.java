package com.accedia.thearm.models;

/**
 * Created by venelin.petrov on 1.11.2015 г..
 */
public class User {
    private String email;
    private String username;
    private String password;
    private String os;
    private String displayName;
    private String notificationToken;


    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getOs() {
        return os;
    }

    public void setOs(String os) {
        this.os = os;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public String getToken() {
        return notificationToken;
    }

    public void setToken(String notificationToken) {
        this.notificationToken = notificationToken;
    }
}
