package com.accedia.thearm.helpers;

import android.net.Uri;
import android.util.Pair;

import com.accedia.thearm.models.Event;
import com.accedia.thearm.models.Resource;
import com.accedia.thearm.models.User;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ExecutionException;

import static com.accedia.thearm.helpers.RequestTask.RequestMethod.*;

/**
 * Created by venelin.petrov on 1.11.2015 г..
 */
public class ApiHelper {

    private final static String URL_ENDPOINT = "http://vm-hackathon-re.westeurope.cloudapp.azure.com:8080/api/";

    public static boolean login(String username, String password, String token) throws ExecutionException, InterruptedException, JSONException {
        String url = URL_ENDPOINT + "login";

        Uri.Builder builder = new Uri.Builder()
                .appendQueryParameter("username", username)
                .appendQueryParameter("password", password)
                .appendQueryParameter("token", token);

        String params = builder.build().getEncodedQuery();
        String result = new RequestTask(POST.value()).execute(url, params).get();

        JSONObject res = new JSONObject(result);
        boolean isSuccess = res.getString("status").equals("success");

        ObjectsHelper.getInstance().setCurrentUser(new User(res));

        return isSuccess;
    }

    public static boolean register(String username, String password, String token, String email) throws ExecutionException, InterruptedException, JSONException {

        String url = URL_ENDPOINT + "register";

        Uri.Builder builder = new Uri.Builder()
                .appendQueryParameter("username", username)
                .appendQueryParameter("password", password)
                .appendQueryParameter("token", token)
                .appendQueryParameter("email", email)
                .appendQueryParameter("os", "Android");

        String params = builder.build().getEncodedQuery();
        String result = new RequestTask(POST.value()).execute(url, params).get();

        JSONObject res = new JSONObject(result);
        boolean isSuccess = res.getString("status").equals("success");

        ObjectsHelper.getInstance().setCurrentUser(new User(res));

        return isSuccess;
    }

    public static List<Resource> getResources(int companyId) throws ExecutionException, InterruptedException, JSONException {

        String url = URL_ENDPOINT + companyId + "/resources";
        String result = new RequestTask(GET.value()).execute(url).get();

        ArrayList<Resource> resources = new ArrayList<Resource>();
        JSONArray resArr = new JSONArray(result);
        for (int i = 0; i < resArr.length(); i++){
            resources.add(new Resource(resArr.getJSONObject(i)));
        }

        ObjectsHelper.getInstance().setResources(resources);

        return resources;
    }

    public static Resource getResource(int companyId, int resourceId) throws ExecutionException, InterruptedException, JSONException {

        String url = URL_ENDPOINT + companyId + "/resources/" + resourceId;
        String result = new RequestTask(GET.value()).execute(url).get();

        Resource res = new Resource(new JSONObject(result));

        return res;
    }

    public static Event createEvent(int companyId, String description, int requiredUsers, Date startDate, Date endDate, int resourceId, int ownerId) throws ExecutionException, InterruptedException, JSONException, ParseException {

        String url = URL_ENDPOINT + companyId + "/events/create";

        JSONObject event = new JSONObject();
        try {
            event.put("description", description);
            event.put("minUsers", requiredUsers);
            event.put("maxUsers", requiredUsers);
            event.put("startTime", ObjectsHelper.jsonDateFormat.format(startDate));
            event.put("endTime", ObjectsHelper.jsonDateFormat.format(endDate));
            event.put("resourceId", resourceId);
            event.put("ownerId", ownerId);
        } catch(JSONException e){
            e.printStackTrace();
        }

        String result = new RequestTask(POST.value()).execute(url, event.toString()).get();

        //Event eventObj = new Event(new JSONObject(result));

        return null;//eventObj;
    }

    public static List<Event> getEvents(int companyId) throws ExecutionException, InterruptedException, JSONException, ParseException {

        String url = URL_ENDPOINT + companyId + "/events";
        String result = new RequestTask(GET.value()).execute(url).get();

        ArrayList<Event> events = new ArrayList<Event>();
        JSONArray evArr = new JSONArray(result);
        for (int i = 0; i < evArr.length(); i++) {
            events.add(new Event(evArr.getJSONObject(i)));
        }

        ObjectsHelper.getInstance().setEvents(events);

        return events;
    }

    public static Event getEvent(int companyId, int eventId) throws ExecutionException, InterruptedException, JSONException, ParseException {
        String url = URL_ENDPOINT + companyId + "/events/" + eventId;
        String result = new RequestTask(GET.value()).execute(url).get();

        Event event = new Event(new JSONObject(result));

        return event;
    }

    public static boolean joinEvent(String username, int companyId, int eventId) throws ExecutionException, InterruptedException, JSONException {

        String url = URL_ENDPOINT + companyId + "/events/join";
        Uri.Builder builder = new Uri.Builder()
                .appendQueryParameter("username", username)
                .appendQueryParameter("eventId", String.valueOf(eventId));

        String result = new RequestTask(POST.value()).execute(url).get();

        JSONObject res = new JSONObject(result);
        boolean isSuccess = res.getString("status").equals("success");

        return isSuccess;
    }

    public static boolean leaveEvent(String username, int companyId, int eventId) throws ExecutionException, InterruptedException, JSONException {
        String url = URL_ENDPOINT + companyId + "/events/leave";
        Uri.Builder builder = new Uri.Builder()
                .appendQueryParameter("username", username)
                .appendQueryParameter("eventId", String.valueOf(eventId));

        String result = new RequestTask(POST.value()).execute(url).get();

        JSONObject res = new JSONObject(result);
        boolean isSuccess = res.getString("status").equals("success");

        return isSuccess;
    }

    // TODO create delete event method

    public static String getCompanies() throws ExecutionException, InterruptedException {

        String url = URL_ENDPOINT + "companies";
        String result = new RequestTask(GET.value()).execute(url).get();
        return result;
    }
}
