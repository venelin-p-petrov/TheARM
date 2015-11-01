package com.accedia.thearm;

import android.os.Build;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.TimePicker;

import java.util.Calendar;

public class CreateEventActivity extends AppCompatActivity {

    public static final String START_DATE = "com.accedia.thearm.START_DATE";

    private TimePicker startTimePicker;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_event);

        Calendar startTime = (Calendar) getIntent().getSerializableExtra(START_DATE);

        startTimePicker = (TimePicker) findViewById(R.id.dtp_from_date);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            startTimePicker.setHour(startTime.get(Calendar.HOUR));
            startTimePicker.setMinute(startTime.get(Calendar.MINUTE));
        } else {
            startTimePicker.setCurrentHour(startTime.get(Calendar.HOUR));
            startTimePicker.setCurrentMinute(startTime.get(Calendar.MINUTE));
        }
    }
}
