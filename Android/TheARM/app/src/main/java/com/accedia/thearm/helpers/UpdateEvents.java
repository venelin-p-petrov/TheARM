package com.accedia.thearm.helpers;

import com.accedia.thearm.adapters.EventListAdapter;

import org.json.JSONException;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

/**
 * Created by ivan.kolev on 12/23/2016.
 */

public class UpdateEvents {

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
                        Thread.sleep(5000);
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
                    if(!EventListAdapter.equalLists(EventListAdapter.eventsInfo, ObjectsHelper.getInstance().getEvents())) {
                        EventListAdapter.eventsInfo = EventListAdapter.initEventInfo(ObjectsHelper.getInstance().getEvents());

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
