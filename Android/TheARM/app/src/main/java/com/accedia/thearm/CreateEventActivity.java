package com.accedia.thearm;

import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.os.Build;
import android.os.Bundle;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.TimePicker;

import com.accedia.thearm.helpers.ApiHelper;
import com.accedia.thearm.helpers.ObjectsHelper;
import com.accedia.thearm.helpers.WaitingDialog;
import com.accedia.thearm.models.ARMModel;
import com.accedia.thearm.models.Event;
import com.accedia.thearm.models.Resource;
import com.accedia.thearm.models.Result;
import com.nostra13.universalimageloader.core.ImageLoader;

import org.json.JSONException;

import java.text.ParseException;
import java.util.Calendar;
import java.util.concurrent.ExecutionException;

public class CreateEventActivity extends AppCompatActivity {

    public static final String START_DATE = "com.accedia.thearm.START_DATE";
    public static final String EXTRA_RESOURCE_ID = "EXTRA_RESOURCE_ID";

    private TimePicker startTimePicker;
    private Button createEventButton;
    private EditText eventDescriptionEditText;
    private Resource resource;
    private TextView startTimeTextView;
    private ProgressDialog dialog ;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_event);

        final int resourceId = getIntent().getIntExtra(EXTRA_RESOURCE_ID,0);
        resource = ObjectsHelper.getInstance().getResourceById(resourceId);

        Calendar startTime = (Calendar) getIntent().getSerializableExtra(START_DATE);
        Calendar endTime = Calendar.getInstance();

        if (startTime == null) {
            startTime = Calendar.getInstance();
        }


        startTimeTextView = (TextView) findViewById(R.id.text_start_time);
        int hours = startTime.get(Calendar.HOUR_OF_DAY);
        int minutes = startTime.get(Calendar.MINUTE);
        startTimeTextView.setText( (hours<10? "0" : "")  + hours  + ":" + (minutes<10? "0" : "")  + minutes );


        startTimePicker = (TimePicker) findViewById(R.id.dtp_from_date);
        createEventButton = (Button) findViewById(R.id.create_event_button);
        eventDescriptionEditText = (EditText) findViewById(R.id.event_description);

        dialog = WaitingDialog.setupProgressDialog(CreateEventActivity.this);
        setupTopImage();

        TextView textResourceName = (TextView) findViewById(R.id.text_resource_name);
        textResourceName.setText("Create " + resource.getName() + " Event");

        addListenerOnStartTime();
        addCloseStartTimeListeners();
        addCloseTextListeners();

        defineMinUserSpinner();
        defineDurationSpinner();

        startTimePicker.setIs24HourView(true);
        startTimePicker.setOnTimeChangedListener(new TimePicker.OnTimeChangedListener() {

            @Override
            public void onTimeChanged(TimePicker view, int hourOfDay, int minute) {
                Calendar calendar = Calendar.getInstance();
                int currentHour = calendar.get(Calendar.HOUR_OF_DAY);
                int currentMinute = calendar.get(Calendar.MINUTE);
                if (hourOfDay < currentHour || (hourOfDay == currentHour && minute < currentMinute)) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        view.setHour(currentHour);
                        view.setMinute(currentMinute);
                    } else {
                        view.setCurrentMinute(currentMinute);
                        view.setCurrentHour(currentHour);
                    }

                    startTimeTextView.setText((currentHour <10 ? "0": "") + currentHour + ":" + (currentMinute <10 ? "0": "") + currentMinute );
                } else {
                    startTimeTextView.setText((hourOfDay <10 ? "0": "") + hourOfDay + ":" + (minute <10 ? "0": "") + minute );
                }

            }
        });

        final Calendar finalStartTime = startTime;
        final Calendar finalEndTime = endTime;

        createEventButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                createEventButton.setEnabled(false);
                dialog.show();

                Thread mThread = new Thread() {
                    @Override
                    public void run() {

                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                            finalStartTime.set(Calendar.HOUR_OF_DAY, startTimePicker.getHour());
                            finalStartTime.set(Calendar.MINUTE, startTimePicker.getMinute());

                        } else {
                            finalStartTime.set(Calendar.HOUR_OF_DAY, startTimePicker.getCurrentHour());
                            finalStartTime.set(Calendar.MINUTE, startTimePicker.getCurrentMinute());
                        }
                        Spinner durationSpinner = (Spinner) findViewById(R.id.duration_spinner);

                        String minutesString = durationSpinner.getSelectedItem().toString();
                        minutesString = minutesString.replaceAll(" minutes", "");
                        int duration = Integer.valueOf(minutesString);
                        finalEndTime.setTime(finalStartTime.getTime());
                        finalEndTime.add(Calendar.MINUTE, duration);

                        Spinner userSpinner = (Spinner) findViewById(R.id.people_spinner);
                        int numberOfUsers = Integer.valueOf(userSpinner.getSelectedItem().toString());

                        try {
                            final ARMModel eventCreate = ApiHelper.createEvent(eventDescriptionEditText.getText().toString(),
                                    numberOfUsers,
                                    numberOfUsers,
                                    finalStartTime.getTime(),
                                    finalEndTime.getTime(),
                                    resource.getResourceId(),
                                    ObjectsHelper.getInstance().getCurrentUser().getUserId() // owner id
                            );

                            if (eventCreate.getClass().equals(Event.class)) {

                                runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        dialog.dismiss();
                                        finish();
                                    }
                                });

                            } else {

                                runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        dialog.dismiss();
                                        showAlertDialog((Result) eventCreate);
                                    }
                                });

                            }
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
                };
                mThread.start();



            }
        });
    }

    private void addCloseTextListeners() {
        addCloseKeyboardListener(findViewById(R.id.resource_image_create));
        addCloseKeyboardListener(findViewById(R.id.start_time_vertical_layout));
        addCloseKeyboardListener(findViewById(R.id.end_time_vertical_layout));
        addCloseKeyboardListener(findViewById(R.id.scrollView));
        addCloseKeyboardListener(createEventButton);
        addCloseKeyboardListener(findViewById(R.id.end_time_vertical_layout));
        addCloseKeyboardListener(findViewById(R.id.number_of_players_hor));
    }

    private void addCloseKeyboardListener(View view) {
        view.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                InputMethodManager inputManager = (InputMethodManager)
                        getSystemService(CreateEventActivity.this.INPUT_METHOD_SERVICE);

                inputManager.hideSoftInputFromWindow(getCurrentFocus().getWindowToken(),
                        InputMethodManager.HIDE_NOT_ALWAYS);
            }
        });
    }

    private void addCloseStartTimeListeners() {
        addCloseKeyboardListener(findViewById(R.id.resource_image_create));
        addCloseTimePickerOnView(findViewById(R.id.scrollView));
        addCloseTimePickerOnView(createEventButton);
        addCloseTimePickerOnView(eventDescriptionEditText);
        addCloseTimePickerOnView(findViewById(R.id.end_time_vertical_layout));
        addCloseTimePickerOnView(findViewById(R.id.number_of_players_hor));

    }

    private void showAlertDialog(Result result) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(
                this);

        // set title
        alertDialogBuilder.setTitle("Problem");

        // set dialog message
        alertDialogBuilder
                .setMessage(result.getMessage())
                .setCancelable(false)
                .setNegativeButton("OK",new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog,int id) {
                        dialog.cancel();
                        createEventButton.setEnabled(true);
                    }
                });

        // create alert dialog
        AlertDialog alertDialog = alertDialogBuilder.create();

        // show it
        alertDialog.show();
    }


    private void setupTopImage() {
        ImageLoader imageLoader = ImageLoader.getInstance();
        ImageView imageView =  (ImageView) findViewById(R.id.resource_image_create);
        imageLoader.displayImage(resource.getImageUrl(), imageView);
        addCloseTimePickerOnView(imageView);
    }

    private void defineDurationSpinner() {

        int countOfDurations = (resource.getMaxTime() - resource.getMinTime())/5 + 1;

        String[] durationsArr = new String[countOfDurations];

        for (int duration = resource.getMinTime(),i=0; i< countOfDurations; i++) {
            durationsArr[i] = ""+ (int)(duration + 5*i) +" minutes";
        }

        Spinner spinner = (Spinner) findViewById(R.id.duration_spinner);
        ArrayAdapter<CharSequence> adapter = new ArrayAdapter<CharSequence>(this,  android.R.layout.simple_spinner_item, durationsArr);

        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(adapter);
//        addCloseTimePickerOnView(spinner);
    }

    private void defineMinUserSpinner() {

        String[] usersCountArr = new String[resource.getMaxUsers() - resource.getMinUsers() + 1];

        for (int number = resource.getMinUsers(),i=0; number <= resource.getMaxUsers(); i++, number++) {
            usersCountArr[i] = ""+ number;
        }

        Spinner spinner = (Spinner) findViewById(R.id.people_spinner);
        ArrayAdapter<CharSequence> adapter = new ArrayAdapter<CharSequence>(this,  android.R.layout.simple_spinner_item, usersCountArr);

        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(adapter);
//        addCloseTimePickerOnView(spinner);
    }

    private void addListenerOnStartTime() {
        View startDateView = (View) findViewById(R.id.start_time_layout);
        startDateView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startTimePicker.setVisibility(View.VISIBLE);

            }
        });
    }

    private void addCloseTimePickerOnView(View view) {
        view.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startTimePicker.setVisibility(View.GONE);
            }
        });
    }
}
