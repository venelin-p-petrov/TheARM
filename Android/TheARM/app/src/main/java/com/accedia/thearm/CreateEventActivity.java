package com.accedia.thearm;

import android.os.Build;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TimePicker;

import com.accedia.thearm.helpers.ApiHelper;
import com.accedia.thearm.helpers.ObjectsHelper;

import org.json.JSONException;

import java.text.ParseException;
import java.util.Calendar;
import java.util.concurrent.ExecutionException;

public class CreateEventActivity extends AppCompatActivity {

    public static final String START_DATE = "com.accedia.thearm.START_DATE";

    private TimePicker startTimePicker;
    private TimePicker endTimePicker;
    private Button createEventButton;
    private EditText eventDescriptionEditText;
    private EditText eventMinUsers;
    private EditText eventMaxUsers;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_event);

        Calendar startTime = (Calendar) getIntent().getSerializableExtra(START_DATE);
        Calendar endTime = Calendar.getInstance();

        if (startTime == null) {
            startTime = Calendar.getInstance();
        }

        startTimePicker = (TimePicker) findViewById(R.id.dtp_from_date);
        endTimePicker = (TimePicker) findViewById(R.id.dtp_to_date);
        createEventButton = (Button) findViewById(R.id.create_event_button);
        eventDescriptionEditText = (EditText) findViewById(R.id.event_description);
        eventMinUsers = (EditText) findViewById(R.id.event_min_users);
        eventMaxUsers = (EditText) findViewById(R.id.event_max_users);

        startTimePicker.setIs24HourView(true);
        endTimePicker.setIs24HourView(true);

        // TODO
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
//            startTimePicker.setHour(startTime.get(Calendar.HOUR));
//            startTimePicker.setMinute(startTime.get(Calendar.MINUTE));
//        } else {
//            startTimePicker.setCurrentHour(startTime.get(Calendar.HOUR));
//            startTimePicker.setCurrentMinute(startTime.get(Calendar.MINUTE));
//        }

        final Calendar finalStartTime = startTime;
        final Calendar finalEndTime = endTime;

        createEventButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    finalStartTime.set(Calendar.HOUR_OF_DAY, startTimePicker.getHour());
                    finalStartTime.set(Calendar.MINUTE, startTimePicker.getMinute());

                    finalEndTime.set(Calendar.HOUR_OF_DAY, endTimePicker.getHour());
                    finalEndTime.set(Calendar.MINUTE, endTimePicker.getMinute());
                } else {
                    finalStartTime.set(Calendar.HOUR_OF_DAY, startTimePicker.getCurrentHour());
                    finalStartTime.set(Calendar.MINUTE, startTimePicker.getCurrentMinute());

                    finalEndTime.set(Calendar.HOUR_OF_DAY, endTimePicker.getCurrentHour());
                    finalEndTime.set(Calendar.MINUTE, endTimePicker.getCurrentMinute());
                }

                try {
                    ApiHelper.createEvent(eventDescriptionEditText.getText().toString(),
                            Integer.parseInt(eventMinUsers.getText().toString()),
                            Integer.parseInt(eventMaxUsers.getText().toString()),
                            finalStartTime.getTime(),
                            finalEndTime.getTime(),
                            1,//resource id
                            ObjectsHelper.getInstance().getCurrentUser().getUserId() // owner id
                            );

                    finish();
                } catch (ExecutionException e) {
                    e.printStackTrace();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                } catch (JSONException e) {
                    e.printStackTrace();
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }
        });
    }
}
