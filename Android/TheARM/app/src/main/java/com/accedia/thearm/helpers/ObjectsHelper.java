package com.accedia.thearm.helpers;

import android.util.Log;

import com.accedia.thearm.models.Event;
import com.accedia.thearm.models.Resource;
import com.accedia.thearm.models.User;

import java.text.SimpleDateFormat;
import java.util.ArrayList;

/**
 * Created by venelin.petrov on 8.2.2016 г..
 */
public class ObjectsHelper {

    private static ObjectsHelper instance;
    public static SimpleDateFormat jsonDateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

    private ObjectsHelper(){
    }

    // TODO implement better (thread-safe) Singleton
    public static ObjectsHelper getInstance(){
        if (instance == null){
            instance = new ObjectsHelper();
        }
        return instance;
    }


    private User currentUser;

    public User getCurrentUser() {
        return currentUser;
    }

    public void setCurrentUser(User currentUser) {
        this.currentUser = currentUser;
    }


    private ArrayList<Resource> resources;

    public ArrayList<Resource> getResources() {
        return resources;
    }

    public void setResources(ArrayList<Resource> resources) {
        if (this.resources == null) {
            this.resources = new ArrayList<Resource>();
        }

        this.resources.clear();
        this.resources.addAll(resources);
    }


    private ArrayList<Event> events;

    public ArrayList<Event> getEvents() {
        return events;
    }

    public void setEvents(ArrayList<Event> events) {
        if (this.events == null) {
            this.events = new ArrayList<Event>();
        }

        this.events.clear();
        this.events.addAll(events);
        Log.w("DEBUG", "set events");
    }
}
