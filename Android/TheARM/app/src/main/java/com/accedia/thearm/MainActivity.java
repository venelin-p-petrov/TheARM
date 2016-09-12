package com.accedia.thearm;

import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.accedia.thearm.helpers.ApiHelper;
import com.accedia.thearm.helpers.ObjectsHelper;
import com.accedia.thearm.services.RegistrationIntentService;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;

import org.json.JSONException;

import java.util.concurrent.ExecutionException;

public class MainActivity extends AppCompatActivity {

    private static final int PLAY_SERVICES_RESOLUTION_REQUEST = 9000;
    public static final String SENT_TOKEN_TO_SERVER = "sentTokenToServer";
    public static final String REGISTRATION_COMPLETE = "registrationComplete";

    private Button buttonLogin;
    private Button buttonRegister;
    private EditText editUsername;
    private EditText editPassword;
    private ProgressDialog dialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        setupProgressDialog();

        buttonLogin = (Button) findViewById(R.id.button_login);
        buttonRegister = (Button) findViewById(R.id.button_register);
        editUsername = (EditText) findViewById(R.id.edit_username);
        editPassword = (EditText) findViewById(R.id.edit_password);

        buttonLogin.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                final String username = editUsername.getText().toString();
                final String password = editPassword.getText().toString();

                if (username == null || username.isEmpty()) {
                    showToastWithError("Please enter username");
                    return;
                } else {
                    dialog.show();
                    buttonLogin.setEnabled(false);
                }
                Thread loginThread = new Thread() {

                    @Override
                    public void run() {

                        try {
                            if (ApiHelper.login(username, password, "")) {
                                runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        ObjectsHelper.getInstance().storeUser(ObjectsHelper.getInstance().getCurrentUser(), getApplicationContext());
                                        Intent intent = new Intent(MainActivity.this, ListsActivity.class);
                                        startActivity(intent);
                                    }
                                });

                            } else {
                                showToastWithError("Login failed.");
                            }
                        } catch (ExecutionException e) {
                            e.printStackTrace();
                            showToastWithError("Login failed.");
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                            showToastWithError("Login failed.");
                        } catch (JSONException e) {
                            e.printStackTrace();
                            showToastWithError("Login failed.");
                        } finally {
                            runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    dialog.hide();
                                    buttonLogin.setEnabled(true);
                                }
                            });

                        }
                    }
                };
                loginThread.start();

            }
        });


        buttonRegister.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(MainActivity.this, RegisterActivity.class);
                startActivity(intent);
            }
        });

        if (checkPlayServices()) {
            // Start IntentService to register this application with GCM.
            Intent intent = new Intent(this, RegistrationIntentService.class);
            startService(intent);
        }
    }

    private void showToastWithError(final String errorMessage){
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(MainActivity.this, errorMessage, Toast.LENGTH_SHORT).show();
            }
        });
    }

    private void setupProgressDialog() {
        dialog = new ProgressDialog(MainActivity.this);
        dialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
        dialog.setMessage("Loading. Please wait...");
        dialog.setIndeterminate(true);
        dialog.setCanceledOnTouchOutside(false);
    }


    /**
     * Check the device to make sure it has the Google Play Services APK. If
     * it doesn't, display a dialog that allows users to download the APK from
     * the Google Play Store or enable it in the device's system settings.
     */
    private boolean checkPlayServices() {
        GoogleApiAvailability apiAvailability = GoogleApiAvailability.getInstance();
        int resultCode = apiAvailability.isGooglePlayServicesAvailable(this);
        if (resultCode != ConnectionResult.SUCCESS) {
            if (apiAvailability.isUserResolvableError(resultCode)) {
                apiAvailability.getErrorDialog(this, resultCode, PLAY_SERVICES_RESOLUTION_REQUEST)
                        .show();
            } else {
                finish();
            }
            return false;
        }
        return true;
    }
}
