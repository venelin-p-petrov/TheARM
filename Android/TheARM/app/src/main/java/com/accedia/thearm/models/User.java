package com.accedia.thearm.models;

import org.json.JSONException;
import org.json.JSONObject;

import java.text.ParseException;

/**
 * Created by venelin.petrov on 1.11.2015 г..
 */
public class User implements ARMModel {
    private String email;
    private int userId;
    private String username;
    private String displayName;
    private String notificationToken;
    private int companyId;

    public User(JSONObject obj) throws JSONException, ParseException {
        this.email = obj.getString("email");
        this.userId = obj.getInt("userId");
        this.displayName = obj.getString("displayName");
        this.username = obj.getString("username");
        this.notificationToken = obj.getString("token");
        this.companyId = obj.optInt("companyId", 0);
    }

    public User(String username, String displayName, int userId) {
        this.userId = userId;
        this.displayName = displayName;
        this.username = username;
    }

    public int getCompanyId() {
        return companyId;
    }

    public int getUserId() {
        return userId;
    }

    public String getUsername() { return username; }

    public String getDisplayName() { return displayName; }

}
