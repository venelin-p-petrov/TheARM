package com.accedia.thearm.helpers;

import android.util.Pair;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

/**
 * Created by venelin.petrov on 1.11.2015 г..
 */
public class ApiHelper {

    private final static String URL_ENDPOINT = "{serviceaddress}/api/";

    public static void login(String username, String password, String token) {
        String url = URL_ENDPOINT + "login";

        List<Pair<String, String>> params = new ArrayList<Pair<String, String>>();
        params.add(new Pair<String, String>("username", username));
        params.add(new Pair<String, String>("password", password));
        params.add(new Pair<String, String>("token", token));

        try {
            String result = new GetRequestTask().execute(url).get();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
    }
}
