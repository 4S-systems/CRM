/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.notificationsender.websocket;

import javax.websocket.Session;

/**
 *
 * @author Safaa
 */
public class userinfo {
    String username;
    Session session;
    String sessionid;

    public userinfo(String username, String sessionid) {
        this.username = username;
        this.sessionid = sessionid;
    }

    public userinfo(String username, Session session, String sessionid) {
        this.username = username;
        this.session = session;
        this.sessionid = sessionid;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public Session getSession() {
        return session;
    }

    public void setSession(Session session) {
        this.session = session;
    }

    public String getSessionid() {
        return sessionid;
    }

    public void setSessionid(String sessionid) {
        this.sessionid = sessionid;
    }
    
    
    
}