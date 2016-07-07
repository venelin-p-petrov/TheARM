package com.accedia.thearm;

import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.accedia.thearm.helpers.ApiHelper;
import com.accedia.thearm.helpers.ObjectsHelper;
import com.accedia.thearm.models.Event;

public class ViewEventActivity extends AppCompatActivity {

    public static final String EXTRA_EVENT_ID = "com.accedia.thearm.ViewEventActivity.EXTRA_EVENT_ID";

    private TextView txtEventName;
    private Button btnEventJoin;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_view_event);

        final int eventId = getIntent().getIntExtra(EXTRA_EVENT_ID, 0);
        Event evn = ObjectsHelper.getInstance().getEventById(eventId);

        txtEventName = (TextView) findViewById(R.id.text_event_name);
        btnEventJoin = (Button) findViewById(R.id.button_event_join);

        txtEventName.setText(evn.getDescription());

        btnEventJoin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // TODO
//                ApiHelper.joinEvent(ObjectsHelper.getInstance().getCurrentUser().getUserId(),
//                        1,
//                        eventId);
            }
        });
    }

}
