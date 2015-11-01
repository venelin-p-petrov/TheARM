package com.accedia.thearm.helpers;

import android.net.Uri;
import android.util.Pair;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

import static com.accedia.thearm.helpers.RequestTask.RequestMethod.*;

/**
 * Created by venelin.petrov on 1.11.2015 г..
 */
public class ApiHelper {

    private final static String URL_ENDPOINT = "http://vm-hackathon2.westeurope.cloudapp.azure.com:8080/api/";

    public static boolean login(String username, String password, String token) throws ExecutionException, InterruptedException {
        String url = URL_ENDPOINT + "login";

        Uri.Builder builder = new Uri.Builder()
            .appendQueryParameter("username", username)
            .appendQueryParameter("password", password)
            .appendQueryParameter("token", token);

        String params = builder.build().getEncodedQuery();
        String result = new RequestTask(POST.value()).execute(url, params).get();
        if (!"ok".equals(result)){
            return false;
        }
        return true;
    }

    public static boolean register(String username, String password, String display_name, String token) throws ExecutionException, InterruptedException {

        String url = URL_ENDPOINT + "register";

        Uri.Builder builder = new Uri.Builder()
                .appendQueryParameter("username", username)
                .appendQueryParameter("password", password)
                .appendQueryParameter("display_name", password)
                .appendQueryParameter("token", token);

        String params = builder.build().getEncodedQuery();
        String result = new RequestTask(POST.value()).execute(url, params).get();
        if (!"ok".equals(result)){
            return false;
        }
        return true;
    }

    public static String getCompanies() throws ExecutionException, InterruptedException {

        String url = URL_ENDPOINT + "companies";
        String result = new RequestTask(GET.value()).execute(url).get();
        return result;
    }

    public static String getCompanyResources(String companyId) throws ExecutionException, InterruptedException {

        String url = URL_ENDPOINT + companyId + "/resources";
        String result = new RequestTask(GET.value()).execute(url).get();
        return result;
    }

    public static String getCompanyResources(String companyId, String resourceId) throws ExecutionException, InterruptedException {

        String url = URL_ENDPOINT + companyId + "/resources/" + resourceId;
        String result = new RequestTask(GET.value()).execute(url).get();
        return result;
    }
}
