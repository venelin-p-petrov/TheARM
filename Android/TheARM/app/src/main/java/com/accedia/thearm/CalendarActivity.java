package com.accedia.thearm;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.accedia.thearm.helpers.ObjectsHelper;
import com.accedia.thearm.models.Event;
import com.accedia.thearm.models.Resource;
import com.alamkanak.weekview.MonthLoader;
import com.alamkanak.weekview.WeekView;
import com.alamkanak.weekview.WeekViewEvent;
import com.nostra13.universalimageloader.core.ImageLoader;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class CalendarActivity extends AppCompatActivity {

    private WeekView weekView;
    private int resourceId;
    public static final String EXTRA_RESOURCE_ID = "com.accedia.thearm.ViewEventActivity.EXTRA_EVENT_ID";

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
                List<WeekViewEvent> events = generateEvents();
                return events;
            }
        });

        weekView.setEmptyViewClickListener(new WeekView.EmptyViewClickListener() {
            @Override
            public void onEmptyViewClicked(Calendar time) {

                Intent intent = new Intent(CalendarActivity.this, CreateEventActivity.class);
                intent.putExtra(CreateEventActivity.START_DATE, time);
                intent.putExtra(CreateEventActivity.EXTRA_RESOURCE_ID, resourceId);
                startActivity(intent);
            }
        });
        weekView.goToDate(Calendar.getInstance());
        weekView.goToHour(Calendar.getInstance().get(Calendar.HOUR_OF_DAY));
    }

    private List<WeekViewEvent> generateEvents() {

        List<WeekViewEvent> weekViewEvents = new ArrayList<WeekViewEvent>();

        List<Event> events = getEventsForResource(resourceId);
        for (Event event: events) {
            WeekViewEvent weekViewEvent = generateWeekViewEveent(event);
            weekViewEvents.add(weekViewEvent);
        }
        return  weekViewEvents;
    }

    private WeekViewEvent generateWeekViewEveent(Event event) {
        Calendar start = Calendar.getInstance();
        Calendar end = Calendar.getInstance();
        start.setTime(event.getStartTime());
        end.setTime(event.getEndTime());

        new WeekViewEvent();
        WeekViewEvent evnt = new WeekViewEvent(event.getEventId(), event.getDescription(), start, end);
        int color = 0;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            color = getResources().getColor(R.color.colorAccent, getTheme());
        } else {
            color = getResources().getColor(R.color.colorAccent);
        }
        evnt.setColor(color);
        return evnt;
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
}
