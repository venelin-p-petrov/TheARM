package com.accedia.thearm.models;

import com.accedia.thearm.helpers.ObjectsHelper;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by Home on 1.11.2015 г..
 */
public class Event implements ARMModel {
    private int eventId;
    private String description;
    private Integer minUsers;
    private Integer maxUsers;
    private Date startTime;
    private Date endTime;
    private int resourceId;
    private int ownerId;
    private List<Rule> rules;
    private List<User> users;
    private User owner;

    public Event(JSONObject obj) throws JSONException, ParseException {
        SimpleDateFormat format = ObjectsHelper.jsonDateFormat;

        this.eventId = obj.getInt("eventId");
        this.description = obj.getString("description");
        this.minUsers = obj.getInt("minUsers");
        this.maxUsers = obj.getInt("maxUsers");
        this.startTime = format.parse(obj.getString("startTime"));
        this.endTime = format.parse(obj.getString("endTime"));
        this.resourceId = obj.getInt("resource_resourceId");
        this.ownerId = obj.getInt("owner_userId");

        this.owner = new User(obj.getJSONObject("owner"));

        this.users = new ArrayList<User>();
        JSONArray userArr = obj.optJSONArray("users");
        if (userArr != null) {
            for (int i = 0; i < userArr.length(); i++) {
                this.users.add(new User(userArr.getJSONObject(i)));
            }
        }
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getStartTime() {
        return startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public int getEventId() {
        return eventId;
    }

    public User getOwner() {
        return owner;
    }
    public int getResourceId() {
        return resourceId;
    }
    public List<User> getUsers() {
        return users;
    }


    public Integer getMinUsers() {
        return minUsers;
    }

    public Integer getMaxUsers() {
        return maxUsers;
    }

    public void setMaxUsers(Integer maxUsers) {
        this.maxUsers = maxUsers;
    }
}
