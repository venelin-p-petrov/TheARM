package com.accedia.thearm.helpers;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.support.v4.app.NotificationCompat;

import com.accedia.thearm.ListsActivity;
import com.accedia.thearm.R;

/**
 * Created by ivan.kolev on 12/27/2016.
 */

public class AlertReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {

        createNotification(context, "TheARM", "It's time for " + intent.getStringExtra("eventDesc"), "TheARM");
    }

    public void createNotification(Context context, String msg, String msgText, String msgAlert) {

        PendingIntent notificIntent = PendingIntent.getActivity(context, 0,
                new Intent(context, ListsActivity.class), 0);

        NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(context)
                .setSmallIcon(R.drawable.armlogo)
                .setContentTitle(msg)
                .setTicker(msgAlert)
                .setContentTitle(msgText);

        mBuilder.setContentIntent(notificIntent);

        mBuilder.setDefaults(NotificationCompat.DEFAULT_SOUND);

        mBuilder.setAutoCancel(true);

        NotificationManager mNotificationManager =
                (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

        mNotificationManager.notify(1, mBuilder.build());
    }
}
