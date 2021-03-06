package com.accedia.thearm.helpers;

import com.accedia.thearm.models.ARMModel;
import com.accedia.thearm.models.Event;
import com.accedia.thearm.models.Resource;
import com.accedia.thearm.models.Result;
import com.accedia.thearm.models.User;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ExecutionException;

import static com.accedia.thearm.helpers.RequestTask.RequestMethod.DELETE;
import static com.accedia.thearm.helpers.RequestTask.RequestMethod.GET;
import static com.accedia.thearm.helpers.RequestTask.RequestMethod.POST;

/**
 * Created by venelin.petrov on 1.11.2015 г..
 */
public class ApiHelper {

    private final static String URL_ENDPOINT = "https://thearm2.azure-mobile.net/api/";


    public static boolean login(String username, String password, String token) throws ExecutionException, InterruptedException, JSONException, ParseException {
        String url = URL_ENDPOINT + "login";

        JSONObject obj = new JSONObject();
        obj.put("username", username);
        obj.put("username", username);
        obj.put("password", password);
        obj.put("token", token);

        String result = new RequestTask(POST.value()).execute(url, obj.toString()).get();

        JSONObject res = new JSONObject(result);
        boolean isSuccess = res.getString("status").equals("success");

        ObjectsHelper.getInstance().setCurrentUser(new User(res));

        return isSuccess;
    }

    public static ARMModel register(String username, String password, String token, String email, String displayName)  {

        String url = URL_ENDPOINT + "register";
        try {
            JSONObject obj = new JSONObject();
            obj.put("username", username);

            obj.put("password", password);
            obj.put("token", token);
            obj.put("email", email);
            obj.put("displayName", displayName);
            obj.put("os", "Android");

            String result = new RequestTask( POST.value()).execute(url, obj.toString()).get();

            try {
                User user = new User(new JSONObject(result));
                ObjectsHelper.getInstance().setCurrentUser(user);
                return user;
            } catch (JSONException e) {
                Result resultObject =   new Result(new JSONObject(result));
                return resultObject;
            }

        } catch (JSONException e) {
            e.printStackTrace();
            return new Result(e.getMessage(), "failed");
        } catch (InterruptedException e) {
            e.printStackTrace();
            return new Result(e.getMessage(), "failed");
        } catch (ExecutionException e) {
            e.printStackTrace();
            return new Result(e.getMessage(), "failed");
        } catch (ParseException e) {
            e.printStackTrace();
            return new Result(e.getMessage(), "failed");
        }
    }

    public static List<Resource> getResources(int companyId) throws ExecutionException, InterruptedException, JSONException {

        String url = URL_ENDPOINT + companyId + "/resources";
        String result = new RequestTask(GET.value()).execute(url).get();

        ArrayList<Resource> resources = new ArrayList<>();
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

        return new Resource(new JSONObject(result));
    }

    public static ARMModel createEvent(String description, int minUsers, int maxUsers, Date startDate, Date endDate, int resourceId, int ownerId) throws ExecutionException, JSONException, InterruptedException, ParseException {

        String url = URL_ENDPOINT + "/events/create";

        JSONObject event = new JSONObject();
        event.put("companyId", ObjectsHelper.getInstance().getCurrentUser().getCompanyId());
        event.put("description", description);
        event.put("minUsers", minUsers);
        event.put("maxUsers", maxUsers);
        event.put("startTime", ObjectsHelper.jsonDateFormat.format(startDate));
        event.put("endTime", ObjectsHelper.jsonDateFormat.format(endDate));
        event.put("resourceId", resourceId);
        event.put("ownerId", ownerId);

        String result = new RequestTask(POST.value()).execute(url, event.toString()).get();
        ARMModel eventObj;
        try {
            eventObj = new Event(new JSONObject(result));
        } catch (JSONException e) {
            eventObj = new Result(new JSONObject(result));
        }
        return eventObj;
    }

    public static List<Event> getEvents(int companyId) throws ExecutionException, InterruptedException, JSONException, ParseException {

        String url = URL_ENDPOINT + companyId + "/events";
        String result = new RequestTask(GET.value()).execute(url).get();

        ArrayList<Event> events = new ArrayList<>();
        JSONArray evArr = new JSONArray(result);
        for (int i = 0; i < evArr.length(); i++) {
            events.add(new Event(evArr.getJSONObject(i)));
        }

        ObjectsHelper.getInstance().setEvents(events);

        return events;
    }

    public static Event getEvent(int eventId) throws ExecutionException, InterruptedException, JSONException, ParseException {
        String url = URL_ENDPOINT + "/events/" + eventId;
        String result = new RequestTask(GET.value()).execute(url).get();

        return new Event(new JSONObject(result));
    }

    public static Result joinEvent(int userId, int eventId) throws ExecutionException, InterruptedException, JSONException, ParseException {

        String url = URL_ENDPOINT + "/events/join";
        JSONObject obj = new JSONObject();
        obj.put("userId", String.valueOf(userId));
        obj.put("eventId", String.valueOf(eventId));

        String result = new RequestTask(POST.value()).execute(url, obj.toString() ).get();

        return new Result(new JSONObject(result));
    }

    public static Result leaveEvent(int userId, int eventId) throws ExecutionException, InterruptedException, JSONException, ParseException {
        String url = URL_ENDPOINT + "/events/leave";
        JSONObject obj = new JSONObject();
        obj.put("userId", String.valueOf(userId));
        obj.put("eventId", String.valueOf(eventId));

        String result = new RequestTask(POST.value()).execute(url, obj.toString()).get();

        return new Result(new JSONObject(result));
    }

    public static Result deleteEvent(int userId, int eventId) throws ExecutionException, InterruptedException, JSONException, ParseException {
        String url = URL_ENDPOINT + "events/" +eventId +"/delete/" + userId;

        String result = new RequestTask(DELETE.value()).execute(url,null).get();

        return new Result(new JSONObject(result));
    }

    public static String getCompanies() throws ExecutionException, InterruptedException {

        String url = URL_ENDPOINT + "companies";
        return new RequestTask(GET.value()).execute(url).get();
    }
}
