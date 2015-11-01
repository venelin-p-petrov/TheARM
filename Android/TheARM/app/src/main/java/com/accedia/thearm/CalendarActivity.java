package com.accedia.thearm;

import android.content.Intent;
import android.os.Build;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.accessibility.CaptioningManager;
import android.widget.CalendarView;

import com.alamkanak.weekview.WeekView;
import com.alamkanak.weekview.WeekViewEvent;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class CalendarActivity extends AppCompatActivity {

    private WeekView weekView;

    @Override
    protected void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_calendar);

        weekView = (WeekView) findViewById(R.id.weekView);

        weekView.setFirstDayOfWeek(Calendar.MONDAY);
        weekView.setMonthChangeListener(new WeekView.MonthChangeListener() {
            @Override
            public List<WeekViewEvent> onMonthChange(int newYear, int newMonth) {
                Log.i("asdasd", "month changed");
                List<WeekViewEvent> events = new ArrayList<WeekViewEvent>();
                // TODO
                Calendar start = Calendar.getInstance();
                Calendar end = Calendar.getInstance();
                end.add(Calendar.HOUR, 2);
                WeekViewEvent evnt = new WeekViewEvent(1, "asdasdd asdasdd asdasdd asdasdd asdasdd asdasdd asdasdd asdasdd asdasdd ", start, end);
                int color = 0;
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    color = getResources().getColor(R.color.colorAccent, getTheme());
                } else {
                    color = getResources().getColor(R.color.colorAccent);
                }
                evnt.setColor(color);
                events.add(evnt);
                return events;
            }
        });

        weekView.setEmptyViewClickListener(new WeekView.EmptyViewClickListener() {
            @Override
            public void onEmptyViewClicked(Calendar time) {
                Log.i("asdasd", time.getTime().toString());
                //TODO
                Intent intent = new Intent(CalendarActivity.this, CreateEventActivity.class);
                intent.putExtra(CreateEventActivity.START_DATE, time);
                startActivity(intent);
            }
        });
    }
}
