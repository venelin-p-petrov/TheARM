package com.accedia.thearm.adapters;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListAdapter;
import android.widget.TextView;

import com.accedia.thearm.R;
import com.accedia.thearm.helpers.ObjectsHelper;
import com.accedia.thearm.models.Event;
import com.accedia.thearm.models.EventInfo;
import com.accedia.thearm.models.Resource;
import com.accedia.thearm.models.User;
import com.nostra13.universalimageloader.core.ImageLoader;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by venelin.petrov on 1.11.2015 г..
 */
public class EventListAdapter extends BaseAdapter implements ListAdapter {

    private Context context;
    private List<Event> items = new ArrayList<Event>();
    public static ArrayList<EventInfo> eventsInfo = initEventInfo(ObjectsHelper.getInstance().getEvents());

    public static ArrayList<EventInfo> initEventInfo(ArrayList<Event> events) {
        ArrayList<EventInfo> eventsInfo = new ArrayList<EventInfo>();

        if(events != null) {
            for (Event event : events) {
                EventInfo eventInformation = new EventInfo(event.getEventId(), event.getUsers());
                eventsInfo.add(eventInformation);
            }
        }
        return eventsInfo;
    }

    public EventListAdapter(Context context, List<Event> items) {
        if(items == null) {
            items = new ArrayList<Event>();
        }
        this.context = context;
        this.items = items;
    }

    public static boolean equalLists(ArrayList<EventInfo> one, ArrayList<Event> two){
        if (one == null && two == null){
            return true;
        }

        if((one == null && two != null)
                || one != null && two == null
                || one.size() != two.size()){
            return false;
        }

        for(EventInfo eventInfo : one) {
            boolean foundEvent = false;
            for(Event event : two) {
                if(eventInfo.getId()  == event.getEventId() && eventInfo.getUsers().size() == event.getUsers().size()) {
                    for (User user : eventInfo.getUsers()) {
                        for (User user1 : event.getUsers()) {
                            if(user.getUserId() == user1.getUserId()){
                                foundEvent = true;
                            }
                        }
                    }
                }
            }
            if(!foundEvent){
                return false;
            }
        }
        return true;
    }

    @Override
    public int getCount() {
        Log.w("DEBUG", "get event count adapter");
        return this.items.size();
    }

    @Override
    public Object getItem(int position) {
        return this.items.get(position);
    }

    @Override
    public long getItemId(int position) {
        return this.items.get(position).hashCode();
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        if (convertView == null) {
            convertView = inflater.inflate(R.layout.list_item_event, parent, false);
        }

        Event eventItem = (Event) getItem(position);

        if (eventItem != null) {
            ImageLoader imageLoader = ImageLoader.getInstance();
            TextView textDescription = (TextView) convertView.findViewById(R.id.list_item_event_description);
            TextView textStart = (TextView) convertView.findViewById(R.id.list_item_event_start);
            TextView textOwner = (TextView) convertView.findViewById(R.id.list_item_event_owner);
            TextView textPlayersCount = (TextView) convertView.findViewById(R.id.players_count);
            final ImageView imageView = (ImageView) convertView.findViewById(R.id.eventImage);


            if (textDescription != null) {
                textDescription.setText(eventItem.getDescription());
            }

            if (textStart != null) {
                SimpleDateFormat dateFormatter = new SimpleDateFormat("HH:mm");
                String time = "Time: " +  dateFormatter.format(eventItem.getStartTime()) + " - " +  dateFormatter.format(eventItem.getEndTime());
                textStart.setText(time);
            }

            if (textOwner != null) {
                textOwner.setText(eventItem.getOwner().getDisplayName());
            }
            if (imageView != null) {
                Resource resource = ObjectsHelper.getInstance().getResourceById(eventItem.getResourceId());
                imageView.setImageResource(R.drawable.resourcesactive);
                imageLoader.displayImage(resource.getImageUrl(), imageView);
            }

            textPlayersCount.setText(eventItem.getUsers().size() + "/" + eventItem.getMaxUsers());

        }

        return convertView;
    }
}
