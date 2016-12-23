package com.accedia.thearm;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.accedia.thearm.helpers.ApiHelper;
import com.accedia.thearm.models.ARMModel;
import com.accedia.thearm.models.Result;
import com.accedia.thearm.models.User;

public class RegisterActivity extends AppCompatActivity {

    private Button buttonRegister;
    private EditText editUsername;
    private EditText editEmail;
    private EditText editPassword;
    private EditText editDisplayName;
    private EditText editConfirmPassword;
    private ProgressDialog dialog;

    private static final String EMAIL_REGEX = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\])|(([a-zA-Z\\-0-9]+\\.)+[a-zA-Z]{2,}))$";

    public void hideSoftKeyboard(View view) {
//        View view = this.getCurrentFocus();
        if (view != null) {
            InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
            imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);

        setupProgressDialog();

        buttonRegister = (Button) findViewById(R.id.button_register);
        Button buttonLogin = (Button) findViewById(R.id.button_login);
        editUsername = (EditText) findViewById(R.id.edit_register_username);
        editEmail = (EditText) findViewById(R.id.edit_register_email);
        editPassword = (EditText) findViewById(R.id.edit_register_password);
        editDisplayName = (EditText) findViewById(R.id.edit_register_display_name);
        editConfirmPassword  = (EditText) findViewById(R.id.edit_confirm_password);

        buttonRegister.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (checkTexts()) {
                    dialog.show();
                    buttonRegister.setEnabled(false);
                    Thread mThread = new Thread() {
                        String username = editUsername.getText().toString();
                        String email = editEmail.getText().toString();
                        String password = editPassword.getText().toString();
                        String displayName = editDisplayName.getText().toString();
                        @Override
                        public void run() {

                            final ARMModel response = ApiHelper.register(username, password, "", email, displayName);
                            runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    if (response.getClass().equals(User.class)) {

                                        dialog.hide();
                                        Toast.makeText(RegisterActivity.this.getApplicationContext(), "Register successful.", Toast.LENGTH_SHORT).show();
                                        finish();

                                    } else {
                                        dialog.hide();
                                        generateAlert("Problem", ((Result) response).getMessage(), new DialogInterface.OnClickListener() {
                                            @Override
                                            public void onClick(DialogInterface dialog, int which) {
                                                dialog.cancel();
                                            }
                                        });
                                        buttonRegister.setEnabled(true);
                                    }
                                }
                            });
                        }
                    };
                    mThread.start();
                }
            }
        });
        buttonLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

    }

    private void showToastWithError(final String errorMessage) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(RegisterActivity.this, errorMessage, Toast.LENGTH_SHORT).show();
            }
        });
    }

    private void setupProgressDialog() {
        dialog = new ProgressDialog(RegisterActivity.this);
        dialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
        dialog.setMessage("Loading. Please wait...");
        dialog.setIndeterminate(true);
        dialog.setCanceledOnTouchOutside(false);
    }


    private boolean checkTexts(){
        String username = editUsername.getText().toString();
        String email = editEmail.getText().toString();
        String password = editPassword.getText().toString();
        String displayName = editDisplayName.getText().toString();
        String confirmPassword = editConfirmPassword.getText().toString();
        return RegisterActivity.this.checkTexts(username, email, password, confirmPassword, displayName);
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

    /**
     *  This method validate all edit text are correctly fulfilled.
     */
    //TODO: change validation method for email.
    private boolean checkTexts(String username, String email, String password, String confirmPassword, String displayName) {
        boolean isValid = true;
        if (email == null || email.length() < 5 || !email.matches(EMAIL_REGEX)){
            isValid = false;
            Toast.makeText(RegisterActivity.this.getApplicationContext(), "Please add valid email address.", Toast.LENGTH_SHORT).show();
        } else if (password == null || password.length() < 6) {
            isValid = false;
            Toast.makeText(RegisterActivity.this.getApplicationContext(), "Please add password with at least 6 symbols.", Toast.LENGTH_SHORT).show();
        } else if (confirmPassword == null || !confirmPassword.equals(password)) {
            isValid = false;
            Toast.makeText(RegisterActivity.this.getApplicationContext(), "Please add matching passwords", Toast.LENGTH_SHORT).show();
        } else if (username == null  || username.length() < 5) {
            isValid = false;
            Toast.makeText(RegisterActivity.this.getApplicationContext(), "Please add username with at least 5 symbols.", Toast.LENGTH_SHORT).show();
        } else if (displayName == null  || displayName.length() < 5) {
            isValid = false;
            Toast.makeText(RegisterActivity.this.getApplicationContext(), "Please add display name with at least 5 symbols.", Toast.LENGTH_SHORT).show();
        }

        return  isValid;
    }
}
