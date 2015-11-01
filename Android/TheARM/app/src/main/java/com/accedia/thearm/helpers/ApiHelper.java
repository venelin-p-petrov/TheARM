package com.accedia.thearm.helpers;

import android.net.Uri;
import android.util.Pair;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ExecutionException;

import static com.accedia.thearm.helpers.RequestTask.RequestMethod.*;

/**
 * Created by venelin.petrov on 1.11.2015 г..
 */
public class ApiHelper {

    private final static String URL_ENDPOINT = "http://vm-hackathon2.westeurope.cloudapp.azure.com:8080/api/";

    public static String login(String username, String password, String token) throws ExecutionException, InterruptedException {
        String url = URL_ENDPOINT + "login";

//        List<Pair<String, String>> params = new ArrayList<Pair<String, String>>();
//        params.add(new Pair<String, String>("username", username));
//        params.add(new Pair<String, String>("password", password));
//        params.add(new Pair<String, String>("token", token));

        Uri.Builder builder = new Uri.Builder()
                .appendQueryParameter("username", username)
                .appendQueryParameter("password", password)
                .appendQueryParameter("token", token);

        String params = builder.build().getEncodedQuery();
        String result = new RequestTask(POST.value()).execute(url, params).get();
        return result;
    }

    public static String register(String username, String password, String display_name, String token) throws ExecutionException, InterruptedException {

        String url = URL_ENDPOINT + "register";

        Uri.Builder builder = new Uri.Builder()
                .appendQueryParameter("username", username)
                .appendQueryParameter("password", password)
                .appendQueryParameter("display_name", password)
                .appendQueryParameter("token", token);

        String params = builder.build().getEncodedQuery();
        String result = new RequestTask(POST.value()).execute(url, params).get();
        return result;
    }

    public static String getCompanies() throws ExecutionException, InterruptedException {

        String url = URL_ENDPOINT + "companies";
        String result = new RequestTask(GET.value()).execute(url).get();
        return result;
    }

    public static String getResources(String companyId) throws ExecutionException, InterruptedException {

        String url = URL_ENDPOINT + companyId + "/resources";
        String result = new RequestTask(GET.value()).execute(url).get();
        return result;
    }

    public static String getResource(String companyId, String resourceId) throws ExecutionException, InterruptedException {

        String url = URL_ENDPOINT + companyId + "/resources/" + resourceId;
        String result = new RequestTask(GET.value()).execute(url).get();
        return result;
    }

    public static String getEvents(String companyId) throws ExecutionException, InterruptedException {

        String url = URL_ENDPOINT + companyId + "/events";
        String result = new RequestTask(GET.value()).execute(url).get();
        return result;
    }

    public static String createEvent(String companyId, String description, int requiredUsers, Date startDate, Date endDate ) throws ExecutionException, InterruptedException {

        String url = URL_ENDPOINT + companyId + "/events";

        JSONObject event = new JSONObject();
        try {
            event.put("description", description);
            event.put("minUsers", requiredUsers);
            event.put("maxUsers", requiredUsers);
        } catch(JSONException e){
            e.printStackTrace();
        }

        Uri.Builder builder = new Uri.Builder()
                .appendQueryParameter("event", event.toString());
        String result = new RequestTask(POST.value()).execute(url).get();
        return result;
    }

    public static String assignEvent(String username, String companyId, String eventId) throws ExecutionException, InterruptedException {

        String url = URL_ENDPOINT + companyId + "/events/join";
        Uri.Builder builder = new Uri.Builder()
                .appendQueryParameter("username", username)
                .appendQueryParameter("eventId", eventId);

        String result = new RequestTask(POST.value()).execute(url).get();
        return result;
    }
}