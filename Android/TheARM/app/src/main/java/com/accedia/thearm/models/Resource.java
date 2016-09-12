package com.accedia.thearm.models;

import android.graphics.Bitmap;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Home on 1.11.2015 г..
 */
public class Resource implements ARMModel{
    private int resourceId;
    private String imageUrl;
    private String name;
    private int companyId;
    private int maxTime;
    private int maxUsers;
    private int minTime;
    private int minUsers;

    public Resource(JSONObject obj) throws JSONException {
        this.resourceId = obj.getInt("resourceId");
        this.imageUrl = obj.getString("image");
        this.name = obj.getString("name");
        this.companyId = obj.getInt("companyId");
        this.maxTime = obj.getInt("maxTime");
        this.maxUsers = obj.getInt("maxUsers");
        this.minTime = obj.getInt("minTime");
        this.minUsers = obj.getInt("minUsers");
    }

    public String getName() {
        return name;
    }

    public String getImageUrl() { return imageUrl; }

    public int getResourceId() { return  resourceId; }

    public int getMinUsers() {
        return minUsers;
    }

    public int getMinTime() {
        return minTime;
    }

    public int getMaxUsers() {
        return maxUsers;
    }

    public int getMaxTime() {
        return maxTime;
    }
}
