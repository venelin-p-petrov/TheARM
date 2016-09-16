package com.accedia.thearm.helpers;

import android.app.ProgressDialog;
import android.content.Context;

import com.accedia.thearm.MainActivity;

/**
 * Created by mihailkarev on 9/14/16.
 */
public class WaitingDialog {

    public static ProgressDialog setupProgressDialog(Context context) {
        ProgressDialog dialog = new ProgressDialog(context);
        dialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
        dialog.setMessage("Loading. Please wait...");
        dialog.setIndeterminate(true);
        dialog.setCanceledOnTouchOutside(false);
        return dialog;
    }

}
