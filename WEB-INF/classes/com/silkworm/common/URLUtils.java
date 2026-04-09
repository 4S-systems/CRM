package com.silkworm.common;

import java.net.HttpURLConnection;
import java.net.URL;

public class URLUtils {
    public static String getTrueUrl(String url) {
        if(exists(url)) {
            return url;
        }

        return com.ApplicationConfiguration.db_access.ApplicationUrlMgr.PAGE_URL_ERROR;
    }

    public static boolean exists(String url) {
        try {
            HttpURLConnection.setFollowRedirects(false);
            // note : you may also need
            //HttpURLConnection.setInstanceFollowRedirects(false)

            HttpURLConnection connection = (HttpURLConnection) new URL(url).openConnection();
            connection.setRequestMethod("HEAD");

            return (connection.getResponseCode() == HttpURLConnection.HTTP_OK);
        } catch(Exception exception) {
            System.out.println(exception.getMessage());
        }

        return false;
    }
}
