package com.accedia.thearm.helpers;

import android.os.AsyncTask;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Created by venelin.petrov on 1.11.2015 г..
 */
public class GetRequestTask extends AsyncTask<String, String, String> {

    @Override
    protected String doInBackground(String... params) {
        String urlString = params[0]; // URL to call

        String resultToDisplay = "";

        InputStream in = null;

        // HTTP Get
        try {

            URL url = new URL(urlString);

            HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();

            in = new BufferedInputStream(urlConnection.getInputStream());

            resultToDisplay = readStream(in);
        } catch (Exception e) {

            System.out.println(e.getMessage());

            return e.getMessage();

        }

        return resultToDisplay;
    }

    private String readStream(InputStream in) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(in));
        StringBuilder out = new StringBuilder();
        String line;
        try {
            while ((line = reader.readLine()) != null) {
                out.append(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        finally {
            reader.close();
        }

        return out.toString();
    }
}
