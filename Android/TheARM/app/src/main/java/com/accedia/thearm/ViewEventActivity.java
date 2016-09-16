package com.accedia.thearm;


import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.os.Bundle;

import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.BaseAdapter;
import android.widget.Button;

import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.accedia.thearm.adapters.ParticipantsAdapter;
import com.accedia.thearm.helpers.ApiHelper;
import com.accedia.thearm.helpers.ObjectsHelper;
import com.accedia.thearm.helpers.WaitingDialog;
import com.accedia.thearm.models.Event;
import com.accedia.thearm.models.Resource;
import com.accedia.thearm.models.Result;
import com.accedia.thearm.models.User;
import com.nostra13.universalimageloader.core.ImageLoader;

import org.json.JSONException;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.concurrent.ExecutionException;

public class ViewEventActivity extends AppCompatActivity {

    public static final String EXTRA_EVENT_ID = "com.accedia.thearm.ViewEventActivity.EXTRA_EVENT_ID";

    private TextView txtEventName;
    private Button btnEventJoin;
    private ProgressDialog dialog;
    private Result result;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_view_event);

        final int eventId = getIntent().getIntExtra(EXTRA_EVENT_ID, 0);
        final Event event = ObjectsHelper.getInstance().getEventById(eventId);
        final int userID  = ObjectsHelper.getInstance().getCurrentUser().getUserId();

        txtEventName = (TextView) findViewById(R.id.text_event_name);

        dialog = WaitingDialog.setupProgressDialog(ViewEventActivity.this);

        TextView textOwner = (TextView) findViewById(R.id.text_event_owner);
        TextView textStartDate = (TextView) findViewById(R.id.text_start_time);
        TextView textEndDate = (TextView) findViewById(R.id.text_end_time);
        TextView textParticipants = (TextView) findViewById(R.id.text_participants);

        btnEventJoin = (Button) findViewById(R.id.button_event_join);
        ImageView imageView = (ImageView) findViewById(R.id.resource_image);

        ImageLoader imageLoader = ImageLoader.getInstance();
        Resource resource = ObjectsHelper.getInstance().getResourceById(event.getResourceId());
        imageView.setImageResource(R.drawable.resourcesactive);
        imageLoader.displayImage(resource.getImageUrl(), imageView);

        textOwner.setText(event.getOwner().getDisplayName());
        textParticipants.setText(event.getUsers().size() + "/" + event.getMaxUsers());

        SimpleDateFormat dateFormatter = new SimpleDateFormat("dd.MM.yyyy HH:mm");

        textStartDate.setText(dateFormatter.format(event.getStartTime()));
        textEndDate.setText(dateFormatter.format(event.getEndTime()));

        txtEventName.setText(event.getDescription());

        ListView listResources = (ListView) findViewById(R.id.participients_list_view);
        BaseAdapter adapter = new ParticipantsAdapter(this, event.getUsers());
        listResources.setAdapter(adapter);

        if (userID == event.getOwner().getUserId()) {
            btnEventJoin.setText("DELETE");
        } else if (isUserParticipant(userID, event)) {
            btnEventJoin.setText("LEAVE");
        }

        btnEventJoin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                btnEventJoin.setEnabled(false);
                dialog.show();
                Thread mThread = new Thread() {
                    @Override
                    public void run() {
//                        Result result = null;
                        try {
                            if (event.getOwner().getUserId() == userID) {
                                result = ApiHelper.deleteEvent(userID, eventId);
                            } else if (isUserParticipant(userID, event)) {
                                result = ApiHelper.leaveEvent(userID, eventId);
                            } else {
                                result = ApiHelper.joinEvent(userID, eventId);
                            }
                        } catch (ExecutionException e) {
                            e.printStackTrace();
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        } catch (JSONException e) {
                            e.printStackTrace();
                        } catch (ParseException e) {
                            e.printStackTrace();
                        } finally {
                            runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    dialog.dismiss();
                                }
                            });

                        }
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                if (result == null || !Result.SUCCESS.equals(result.getStatus())) {
                                    showAlertDialog(result);
                                } else {
                                    showAlertForSuccessfulOperation(result.getMessage());
                                }
                            }
                        });

                    }
                };
                mThread.run();
            }
        });
    }

    private void showAlertForSuccessfulOperation(String message) {
        generateAlert("",message,new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog,int id) {
                dialog.cancel();
                finish();
            }
        });
    }


    private void generateAlert(String title, String message, DialogInterface.OnClickListener listener) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(
                this);

        alertDialogBuilder.setTitle(title);

        alertDialogBuilder
                .setMessage(message)
                .setCancelable(false)
                .setNegativeButton("OK",listener);

        // create alert dialog
        AlertDialog alertDialog = alertDialogBuilder.create();

        // show it
        alertDialog.show();
    }

    private boolean isUserParticipant(int userID, Event event) {
        for (User user: event.getUsers()) {
            if (userID == user.getUserId()){
                return true;
            }
        }
        return false;
    }

    private void showAlertDialog(Result result) {
        String message = "Please, try again later.";
        if (result != null){
            message = result.getMessage();
        }
        generateAlert("Problem",message,new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog,int id) {
                dialog.cancel();
                btnEventJoin.setEnabled(true);
            }
        });
    }

}
