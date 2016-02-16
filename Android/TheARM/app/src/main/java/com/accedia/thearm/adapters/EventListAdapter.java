package com.accedia.thearm.adapters;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListAdapter;
import android.widget.TextView;

import com.accedia.thearm.R;
import com.accedia.thearm.models.Event;
import com.accedia.thearm.models.Resource;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by venelin.petrov on 1.11.2015 г..
 */
public class EventListAdapter extends BaseAdapter implements ListAdapter {

    private Context context;
    private List<Event> items = new ArrayList<Event>();

    public EventListAdapter(Context context, List<Event> items) {
        this.context = context;
        this.items = items;
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

        Event eventItem = (Event)getItem(position);

        if (eventItem != null){
            TextView textDescription = (TextView) convertView.findViewById(R.id.list_item_event_description);
            TextView textStart = (TextView) convertView.findViewById(R.id.list_item_event_start);

            if (textDescription != null) {
                textDescription.setText(eventItem.getDescription());
            }

            if (textStart != null) {
//                textStart.setText(eventItem.getDate().toString());
            }
        }

        return convertView;
    }
}
