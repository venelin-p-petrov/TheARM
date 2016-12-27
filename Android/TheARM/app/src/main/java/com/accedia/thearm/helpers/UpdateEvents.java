package com.accedia.thearm.helpers;

import com.accedia.thearm.adapters.EventListAdapter;
import com.accedia.thearm.models.Event;

import org.json.JSONException;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

/**
 * Created by ivan.kolev on 12/23/2016.
 */

public class UpdateEvents {

    private static final int ONE_MINUTE = 1000;
    public static List<Refreshable> items;
    private static UpdateEvents instance;

    private UpdateEvents(){
        items = new ArrayList<Refreshable>();
    }

    public void registerForUpdate(Refreshable item){
        items.add(item);
    }

    public void unregisterForUpdate(Refreshable item){
        items.remove(item);
    }

    public static UpdateEvents getInstance(){
        if(instance != null) {
            return instance;
        }
        instance = new UpdateEvents();
        return instance;
    }


    public void updateEvents() {
        final Runnable thread = new Runnable() {
            @Override
            public void run() {
                while(true) {
                    try {
                        Thread.sleep(5 * ONE_MINUTE);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }

                    try {
                        ApiHelper.getEvents(1);
                    } catch (ExecutionException e) {
                        e.printStackTrace();
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    } catch (JSONException e) {
                        e.printStackTrace();
                    } catch (ParseException e) {
                        e.printStackTrace();
                    }

                    ArrayList<Event> events = ObjectsHelper.getInstance().getEvents();

                    if(!EventListAdapter.equalLists(EventListAdapter.eventsInfo, events)) {
                        EventListAdapter.eventsInfo = EventListAdapter.initEventInfo(events);

                        for (Refreshable item : items) {
                            item.refresh();
                        }
                    }
                }
            }
        };
        Thread update = new Thread(thread);
        update.start();
    }
}
