package com.accedia.thearm.helpers;

import com.accedia.thearm.models.Event;
import com.accedia.thearm.models.Resource;
import com.accedia.thearm.models.User;

import java.util.ArrayList;

/**
 * Created by venelin.petrov on 8.2.2016 г..
 */
public class ObjectsHelper {

    private static ObjectsHelper instance;

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
        this.resources = resources;
    }


    private ArrayList<Event> events;

    public ArrayList<Event> getEvents() {
        return events;
    }

    public void setEvents(ArrayList<Event> events) {
        this.events = events;
    }
}
