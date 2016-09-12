package com.accedia.thearm.helpers;

import android.content.Context;
import android.content.SharedPreferences;
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

    private static final String USERNAME_KEY = "usernameKey";
    private static final String DISPLAY_NAME_KEY = "displayNameKey";
    private static final String USER_ID_KEY = "userIDKey";

    private static ObjectsHelper instance;
    public static SimpleDateFormat jsonDateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");

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

    public void storeUser(User user, Context context) {
        SharedPreferences preferences = context.getSharedPreferences("MyPreferences", Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = preferences.edit();
        editor.putString(USERNAME_KEY, user.getUsername());
        editor.putString(DISPLAY_NAME_KEY, user.getDisplayName());
        editor.putInt(USER_ID_KEY, user.getUserId());
        editor.apply();
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

    public Event getEventById(int id){
        if (id == 0){
            return null;
        }

        for (int i = 0; i < events.size(); i++) {
            if (events.get(i).getEventId() == id){
                return events.get(i);
            }
        }

        return null;
    }

    public Resource getResourceById(int id){
        if (id == 0 || resources == null){
            return null;
        }

        for (Resource resource: resources){
            if (resource.getResourceId() == id){
                return resource;
            }
        }
        return null;
    }

    public boolean isUserCached(Context context) {

        SharedPreferences preferences = context.getSharedPreferences("MyPreferences", Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = preferences.edit();
        String username = preferences.getString(USERNAME_KEY, null);
        if (username == null || username.isEmpty()){
            return  false;
        }
        return true;
    }

    public boolean generateCurrentUser(Context context) {

        SharedPreferences preferences = context.getSharedPreferences("MyPreferences", Context.MODE_PRIVATE);

        String username = preferences.getString(USERNAME_KEY, null);
        String displayName = preferences.getString(DISPLAY_NAME_KEY, null);
        int userId = preferences.getInt(USER_ID_KEY, 0);

        this.currentUser  = new User(username,displayName,userId);
        return true;
    }

    public void logoutCurrentUser(Context context) {
        SharedPreferences preferences = context.getSharedPreferences("MyPreferences", Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = preferences.edit();
        editor.remove(USERNAME_KEY);
        editor.remove(DISPLAY_NAME_KEY);
        editor.remove(USER_ID_KEY);
        editor.apply();
    }
}
