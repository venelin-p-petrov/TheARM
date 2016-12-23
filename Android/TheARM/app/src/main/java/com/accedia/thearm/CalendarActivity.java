package com.accedia.thearm;

import android.content.Intent;
import android.graphics.RectF;
import android.os.Build;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.widget.ImageView;
import android.widget.TextView;

import com.accedia.thearm.adapters.ResourceListAdapter;
import com.accedia.thearm.helpers.ApiHelper;
import com.accedia.thearm.helpers.ObjectsHelper;
import com.accedia.thearm.helpers.Refreshable;
import com.accedia.thearm.helpers.UpdateEvents;
import com.accedia.thearm.models.Event;
import com.accedia.thearm.models.Resource;
import com.alamkanak.weekview.MonthLoader;
import com.alamkanak.weekview.WeekView;
import com.alamkanak.weekview.WeekViewEvent;
import com.nostra13.universalimageloader.core.ImageLoader;

import org.json.JSONException;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.concurrent.ExecutionException;

public class CalendarActivity extends AppCompatActivity implements Refreshable {

    private int resourceId;
    public static final String EXTRA_RESOURCE_ID = "com.accedia.thearm.ViewEventActivity.EXTRA_EVENT_ID";
    private WeekView weekView;
    private ResourceListAdapter resourceListAdapter;

    @Override
    protected void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_calendar);

        resourceId = getIntent().getIntExtra(EXTRA_RESOURCE_ID, 0);

        Resource resource = ObjectsHelper.getInstance().getResourceById(resourceId);

        ImageView imageView = (ImageView) findViewById(R.id.resource_image);
        ImageLoader imageLoader = ImageLoader.getInstance();
        imageLoader.displayImage(resource.getImageUrl(), imageView);

        TextView textResourceName = (TextView) findViewById(R.id.textResourceName);
        textResourceName.setText(resource.getName());

        weekView = (WeekView) findViewById(R.id.weekView);

        weekView.setFirstDayOfWeek(Calendar.MONDAY);
        weekView.setMonthChangeListener(new MonthLoader.MonthChangeListener() {
            @Override
            public List<WeekViewEvent> onMonthChange(int newYear, int newMonth) {
                Log.i("asdasd", "month changed");
                return generateEvents();
            }
        });

        weekView.setEmptyViewClickListener(new WeekView.EmptyViewClickListener() {
            @Override
            public void onEmptyViewClicked(Calendar time) {
                if (time.after(Calendar.getInstance())) {
                    Intent intent = new Intent(CalendarActivity.this, CreateEventActivity.class);
                    intent.putExtra(CreateEventActivity.START_DATE, time);
                    intent.putExtra(CreateEventActivity.EXTRA_RESOURCE_ID, resourceId);
                    startActivity(intent);
                }
            }
        });
        weekView.goToDate(Calendar.getInstance());
        weekView.goToHour(Calendar.getInstance().get(Calendar.HOUR_OF_DAY));

        weekView.setOnEventClickListener(new WeekView.EventClickListener() {
            @Override
            public void onEventClick(WeekViewEvent event, RectF eventRect) {
                int id = (int)event.getId();
                Intent intent = new Intent(CalendarActivity.this, ViewEventActivity.class);
                intent.putExtra(ViewEventActivity.EXTRA_EVENT_ID, id);
                startActivity(intent);
            }
        });
        resourceListAdapter = new ResourceListAdapter(this, ObjectsHelper.getInstance().getResources());
        UpdateEvents.getInstance().registerForUpdate(this);

    }

    private List<WeekViewEvent> generateEvents() {

        List<WeekViewEvent> weekViewEvents = new ArrayList<>();

        List<Event> events = getEventsForResource(resourceId);
        for (Event event: events) {
            WeekViewEvent weekViewEvent = generateWeekViewEvent(event);
            weekViewEvents.add(weekViewEvent);
        }
        return  weekViewEvents;
    }

    private WeekViewEvent generateWeekViewEvent(Event event) {
        Calendar start = Calendar.getInstance();
        Calendar end = Calendar.getInstance();
        start.setTime(event.getStartTime());
        end.setTime(event.getEndTime());

        WeekViewEvent weekEvent = new WeekViewEvent(event.getEventId(), event.getDescription(), start, end);
        weekEvent.setId(event.getEventId());
        int color;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            color = getResources().getColor(R.color.colorAccent, getTheme());
        } else {
            color = getResources().getColor(R.color.colorAccent);
        }
        weekEvent.setColor(color);
        return weekEvent;
    }

    private List<Event> getEventsForResource(int resourceId) {
        ArrayList<Event> allEvents = ObjectsHelper.getInstance().getEvents();
        ArrayList<Event> events = new ArrayList<>();

        for (Event event: allEvents){
            if (event.getResourceId() ==  resourceId){
                events.add(event);
            }
        }
        return events;
    }

    @Override
    protected void onResume() {
        super.onResume();
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

        weekView.notifyDatasetChanged();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        UpdateEvents.getInstance().unregisterForUpdate(this);
    }

    @Override
    public void refresh() {
        ((CalendarActivity) weekView.getContext()).runOnUiThread(new Runnable() {
            @Override
            public void run() {
                weekView.notifyDatasetChanged();
            }
        });
    }
}
