package com.accedia.thearm;

import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.View;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.Button;
import android.widget.EditText;

import com.accedia.thearm.helpers.ApiHelper;

public class MainActivity extends AppCompatActivity {

    private Button buttonLogin;
    private EditText editUsername;
    private EditText editPassword;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        buttonLogin = (Button) findViewById(R.id.button_submit);
        editUsername = (EditText) findViewById(R.id.edit_username);
        editPassword = (EditText) findViewById(R.id.edit_password);

        buttonLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // TODO
                String username = editUsername.getText().toString();
                String password = editPassword.getText().toString();
                //Log.i("test", username);
                //ApiHelper.login()
                Intent intent = new Intent(MainActivity.this, ListsActivity.class);
                startActivity(intent);
            }
        });
    }


}
