package com.accedia.thearm.models;

import android.graphics.Bitmap;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Home on 1.11.2015 г..
 */
public class Resource {
    private int resourceId;
    private String imageName;
    private String name;
    private int companyId;
    private ArrayList<Rule> rules;

    public Resource(JSONObject obj) throws JSONException {
        this.resourceId = obj.getInt("resourceId");
        this.imageName = obj.getString("image");
        this.name = obj.getString("name");
        this.companyId = obj.getInt("company_companyId");
        // TODO save rules
        //this.rules = new ArrayList<Rule>();
    }
}
