package com.accedia.thearm.models;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by ivan.kolev on 12/22/2016.
 */

public class EventInfo {
    private int id;
    private ArrayList<User> users;

    public EventInfo(int id, List<User> users) {
        this.id = id;
        this.users = new ArrayList<User>();
        for (User user : users) {
            this.users.add(user);
        }
    }

    public int getId() {
        return id;
    }

    public ArrayList<User> getUsers() {
        return users;
    }
}
