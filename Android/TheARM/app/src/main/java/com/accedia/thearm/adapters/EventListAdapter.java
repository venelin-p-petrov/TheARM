package com.accedia.thearm.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.accedia.thearm.ListsActivity;
import com.accedia.thearm.R;
import com.accedia.thearm.helpers.ApiHelper;
import com.accedia.thearm.helpers.ObjectsHelper;
import com.accedia.thearm.models.Event;
import com.accedia.thearm.models.Resource;
import com.nostra13.universalimageloader.core.ImageLoader;

import org.json.JSONException;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

/**
 * Created by venelin.petrov on 1.11.2015 г..
 */
public class EventListAdapter extends BaseAdapter implements ListAdapter {

    private Context context;
    private List<Event> items = new ArrayList<Event>();
    private static int flag = ObjectsHelper.getInstance().getEvents().size();

    public EventListAdapter(Context context, List<Event> items) {
        if(items == null) {
            items = new ArrayList<Event>();
        }
        this.context = context;
        this.items = items;
    }


    @Override
    public int getCount() {
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

    public void updateEvents(final ListView listEvents) {
        final Runnable thread = new Runnable() {
            @Override
            public void run() {
                while(true) {
                    try {
                        Thread.sleep(10000);
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
                    if(flag != ObjectsHelper.getInstance().getEvents().size()) {
                        final EventListAdapter adapter = (EventListAdapter) listEvents.getAdapter();
                        flag = ObjectsHelper.getInstance().getEvents().size();
                        ((ListsActivity) context).runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                ((BaseAdapter) adapter).notifyDataSetChanged();
                            }
                        });
                    }
                }
            }
        };
        Thread update = new Thread(thread);
        update.start();
    }
}
