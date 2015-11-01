package com.accedia.thearm.helpers;

import android.os.AsyncTask;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;

import java.net.MalformedURLException;
import java.net.URL;
import static java.nio.charset.StandardCharsets.UTF_8;


/**
 * Created by daniel.velev on 11/1/2015.
 */
public class RequestTask extends AsyncTask<String, String, String> {

    private String method;

    enum RequestMethod{
        GET, POST, DELETE;

        public String value(){
            return this.toString();
        }
    }

    RequestTask(String method) {
        this.method = method;
    }

    private HttpURLConnection openConnection(String... params) throws IOException {

        HttpURLConnection urlConnection = null;

        URL url = new URL(params[0]);
        urlConnection = (HttpURLConnection) url.openConnection();
        urlConnection.setRequestMethod(this.method);

        if(RequestMethod.POST.toString().equals(this.method)){
            urlConnection.setDoOutput(true);
        }

        if(params.length > 1) {
            OutputStream os = urlConnection.getOutputStream();
            BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(os, UTF_8.name()));
            writer.write(params[1]);
            writer.flush();
            writer.close();
            os.close();

            urlConnection.connect();
        }

        return urlConnection;
    }

    @Override
    protected String doInBackground(String... params) {

        BufferedInputStream bis = null;
        StringBuilder result = new StringBuilder();

        try {
            HttpURLConnection urlConnection = openConnection(params);

            int responseCode = urlConnection.getResponseCode();
            if ( responseCode == HttpURLConnection.HTTP_OK )
            {
                bis = new java.io.BufferedInputStream(urlConnection.getInputStream());
                BufferedReader reader = new BufferedReader(new InputStreamReader(bis, UTF_8.name()));
                String line = null;

                while ((line = reader.readLine()) != null) {
                    result.append(line);
                }

            } else {
                result
                    .append(urlConnection.getResponseCode())
                    .append(" : ")
                    .append(urlConnection.getResponseMessage());
            }

        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if(bis != null){
                try {
                    bis.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        return result.toString();
    }

}