package com.accedia.thearm.models;


import org.json.JSONException;
import org.json.JSONObject;

import java.text.ParseException;

/**
 * Created by mihailkarev on 9/7/16.
 */
public class Result implements ARMModel {

    private String message;
    private String status;

    public static final String SUCCESS = "success";


    public Result(JSONObject obj) throws JSONException, ParseException {

        this.message = obj.getString("message");
        this.status = obj.getString("status");


    }

    public String getMessage() {
        return message;
    }

    public String getStatus() {
        return status;
    }
}
