/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.notificationsender.websocket;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class AdminNotification
{
    private String msg;
    private String action;
    private List<String> users;
    
    public  AdminNotification(){}

    public String getMsg()
    {
        return msg;
    }

    public void setMsg(String msg)
    {
        this.msg = msg;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public List<String> getUsers()
    {
        return users;
    }
    
public List<Object> getUsersobjs()
    {
        List<Object> usersobjs=new ArrayList();
        for (Iterator<String> iterator = users.iterator(); iterator.hasNext();)
        {
            String next = iterator.next();
            usersobjs.add((String) next);
            
        }
        return usersobjs;
    }
    
    public void setUsers(List<String> users)
    {
        this.users = users;
    }
    
    
}