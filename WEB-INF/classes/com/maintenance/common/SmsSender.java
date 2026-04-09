/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.maintenance.common;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.text.MessageFormat;

/**
 *
 * @author walid
 */
public class SmsSender {

    private static final SenderConfiurationMgr confiuration = SenderConfiurationMgr.getCurrentInstance();
    private static final SmsSender SENDER = new SmsSender(confiuration.getSmsUserName(), confiuration.getSmsPassword());

    private final String url = "http://smsmisr.com/api/send.aspx?username={0}&password={1}&language=3&sender={2}&mobile={3}&message={4}";
    private String username;
    private String password;

    private SmsSender(String username, String password) {
        try {
            this.username = URLEncoder.encode(username, "UTF-8");
            this.password = URLEncoder.encode(password, "UTF-8");
        } catch (UnsupportedEncodingException ex) {
            System.err.println(ex);
        }
    }

    public static SmsSender getInstance() {
        return SENDER;
    }

    public boolean send(String recipient, String message) {
        return send(confiuration.getSmsSender(), recipient, message);
    }

    public boolean send(String sender, String recipient, String message) {
        HttpURLConnection connection = null;
        try {
            sender = URLEncoder.encode(sender, "UTF-8");
            recipient = URLEncoder.encode(recipient, "UTF-8");
            message = URLEncoder.encode(message, "UTF-8");

            MessageFormat format = new MessageFormat(url);
            URL u = new URL(format.format(new Object[]{username, password, sender, recipient, message}));
            connection = (HttpURLConnection) u.openConnection();
            connection.setDoOutput(true);
            connection.setDoInput(true);

            System.out.println("connection :" + connection);
            String response = connection.getResponseMessage();
            System.out.println("Response :" + response);
            System.out.println("Response Code :" + connection.getResponseCode());
            BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }
            return true;
        } catch (UnsupportedEncodingException ex) {
            System.err.println(ex);
        } catch (MalformedURLException ex) {
            System.err.println(ex);
        } catch (IOException ex) {
            System.err.println(ex);
        } finally {
            if (connection != null) {
                connection.disconnect();
             }
        }

        return false;
    }

    public static void main(String... args) {
        SmsSender sender = new SmsSender("metawee", "123");
        System.out.println("Status: " + sender.send("01100098050", "01275117024", "In the name of allah"));
    }
}
