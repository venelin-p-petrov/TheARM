package com.accedia.thearm;


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

import com.accedia.thearm.adapters.ParticipientsAdapter;
import com.accedia.thearm.adapters.ResourceListAdapter;
import com.accedia.thearm.helpers.ApiHelper;
import com.accedia.thearm.helpers.ObjectsHelper;
import com.accedia.thearm.models.Event;
import com.accedia.thearm.models.Resource;
import com.accedia.thearm.models.Result;
import com.nostra13.universalimageloader.core.ImageLoader;

import org.json.JSONException;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.concurrent.ExecutionException;

public class ViewEventActivity extends AppCompatActivity {

    public static final String EXTRA_EVENT_ID = "com.accedia.thearm.ViewEventActivity.EXTRA_EVENT_ID";

    private TextView txtEventName;
    private Button btnEventJoin;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_view_event);

        final int eventId = getIntent().getIntExtra(EXTRA_EVENT_ID, 0);
        final Event event = ObjectsHelper.getInstance().getEventById(eventId);
        final int userID  = ObjectsHelper.getInstance().getCurrentUser().getUserId();

        txtEventName = (TextView) findViewById(R.id.text_event_name);

        TextView textOwner = (TextView) findViewById(R.id.text_event_owner);
        TextView textStartDate = (TextView) findViewById(R.id.text_start_time);
        TextView textEndDate = (TextView) findViewById(R.id.text_end_time);

        btnEventJoin = (Button) findViewById(R.id.button_event_join);
        ImageView imageView = (ImageView) findViewById(R.id.resource_image);

        ImageLoader imageLoader = ImageLoader.getInstance();
        Resource resource = ObjectsHelper.getInstance().getResourceById(event.getResourceId());
        imageView.setImageResource(R.drawable.resourcesactive);
        imageLoader.displayImage(resource.getImageUrl(), imageView);

        textOwner.setText(event.getOwner().getDisplayName());

        SimpleDateFormat dateFormatter = new SimpleDateFormat("dd.MM.yyyy HH:mm");

        textStartDate.setText(dateFormatter.format(event.getStartTime()));
        textEndDate.setText(dateFormatter.format(event.getEndTime()));

        txtEventName.setText(event.getDescription());

        ListView listResources = (ListView) findViewById(R.id.participients_list_view);
        BaseAdapter adapter = new ParticipientsAdapter(this, event.getUsers());
        listResources.setAdapter(adapter);

        if (userID == event.getOwner().getUserId()) {
            btnEventJoin.setText("DELETE");
        }

        btnEventJoin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                btnEventJoin.setEnabled(false);
                Result result = null;
                if (event.getOwner().getUserId() != userID){
                    try {
                        result = ApiHelper.joinEvent(userID, eventId);
                    } catch (ExecutionException e) {
                        e.printStackTrace();
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    } catch (JSONException e) {
                        e.printStackTrace();
                    } catch (ParseException e) {
                        e.printStackTrace();
                    } finally {
                        btnEventJoin.setEnabled(true);
                    }
                } else {
                    try {
                        result = ApiHelper.deleteEvent(userID, eventId);
                    } catch (ExecutionException e) {
                        e.printStackTrace();
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    } catch (JSONException e) {
                        e.printStackTrace();
                    } catch (ParseException e) {
                        e.printStackTrace();
                    } finally {
                        btnEventJoin.setEnabled(true);
                    }
                }
                if (result == null || !Result.SUCCESS.equals(result.getStatus())) {
                    showAlertDialog(result);
                }
            }
        });
    }


    private void showAlertDialog(Result result) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(
                this);

        // set title
        alertDialogBuilder.setTitle("Problem");

        // set dialog message
        String message = "Please, try again later.";
        if (result != null){
            message = result.getMessage();
        }
        alertDialogBuilder
                .setMessage(message)
                .setCancelable(false)
                .setNegativeButton("OK",new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog,int id) {
                        dialog.cancel();
                    }
                });

        // create alert dialog
        AlertDialog alertDialog = alertDialogBuilder.create();

        // show it
        alertDialog.show();
    }

}
