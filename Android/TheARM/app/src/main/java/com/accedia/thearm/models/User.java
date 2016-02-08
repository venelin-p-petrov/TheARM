package com.accedia.thearm.models;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by venelin.petrov on 1.11.2015 г..
 */
public class User {
    private String email;
    private int userId;
    private String username;
    private String displayName;
    private String notificationToken;
    private int companyId;

    public User(JSONObject obj) throws JSONException {
        this.email = obj.getString("email");
        this.userId = obj.getInt("userId");
        this.displayName = obj.getString("displayName");
        this.notificationToken = obj.getString("token");
        this.companyId = obj.optInt("companyId", 0);
    }
}
