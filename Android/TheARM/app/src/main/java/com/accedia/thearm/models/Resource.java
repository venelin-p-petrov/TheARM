package com.accedia.thearm.models;

import android.graphics.Bitmap;
import java.util.List;

/**
 * Created by Home on 1.11.2015 г..
 */
public class Resource {
    private Bitmap image;
    private String name;
    private List<Rule> rules;
    private List<Event> events;

    public Bitmap getImage() {
        return image;
    }

    public void setImage(Bitmap image) {
        this.image = image;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<Rule> getRules() {
        return rules;
    }

    public void setRules(List<Rule> rules) {
        this.rules = rules;
    }

    public List<Event> getEvents() {
        return events;
    }

    public void setEvents(List<Event> events) {
        this.events = events;
    }
}
