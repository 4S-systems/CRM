package com.notificationsender.websocket;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
//import javax.enterprise.context.ApplicationScoped;

import javax.websocket.Session;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
/**
 *
 * @author asteriskpbx
 */

//@ApplicationScoped
public class NotificationSessionHandler
{

    public NotificationSessionHandler()
    {
    }
    
    //private int deviceId = 0;
     //private final Set<Session> sessions = new HashSet<>();
     //private final HashMap<String, Session> sessionsMap = new HashMap<String, Session>();
    private final  HashMap<String, userinfo> usersMap = new HashMap();
    private final Set<AdminNotification> notifications = new HashSet<>();
    
    public void addUser(userinfo user) {
        String username=user.getUsername();
        usersMap.put(username, user);
     
    }

  public void removeUser(String sessionid) {
        for(userinfo userinfo : usersMap.values())
        {
            if(userinfo.getSession().getId().equalsIgnoreCase(sessionid))
            {
                String username=userinfo.getUsername();
                System.out.println("removeUser : "+sessionid+" logout");
               // usersMap.remove(username, userinfo); //removing session id and username from hashmap
               usersMap.remove(username);
                if(!NotificationWebSocketServer.admin.equalsIgnoreCase(username))      
                  sendToAdminSession(userinfo,false);
                break;
            }
        }
        
    

  }
  
   //retrieving the session of user
  private Session getSessionOfUser(String username) {
   userinfo user=usersMap.get(username);
   if(user!=null) return user.getSession();
  return null;
  
  }
    
    public List<AdminNotification> getAdminNotifications() {
        return new ArrayList<>(notifications);
    }

    public void addAdminNotification(AdminNotification notification) {
        notifications.add(notification);
       // deviceId++;
        String addMessage = createAdminNotification(notification);
        sendToSessions(addMessage, notification.getUsers());
    }
 
    private String createAdminNotification(AdminNotification notification) {
        JSONObject addMessage = new JSONObject();
          addMessage.put("msg", notification.getMsg());
          addMessage.put("action", notification.getAction());
       // addMessage.put("users",  notification.getUsersobjs());
         if(notification.getAction().equalsIgnoreCase("ONLINE_USERS"))
          {
          JSONArray jsArray = new JSONArray();
              for (int i = 0; i < notification.getUsers().size(); i++) {
                 JSONObject obj=new JSONObject();
                 String name= notification.getUsers().get(i);
                  obj.put("name",name);
                 jsArray.add(obj);
              }
          //jsArray.addAll(notification.getUsers());
          
          addMessage.put("users", jsArray);
          }
          addMessage.toJSONString();
     return addMessage.toJSONString();
    }

    private void sendToSessions(String message, List<String> users) {
    /*  for(userinfo user : usersMap.values())
        {
            if(!user.getUsername().equalsIgnoreCase(NotificationWebSocketServer.admin))
            sendToSession(user.getSession(), message);
        }*/
      for(String curruser : users)
      {
          userinfo user=usersMap.get(curruser);
          if(user!=null)
          sendToSession(user.getSession(),message);
      }
      
    }

    public void sendToAdminSession(userinfo user,boolean status) //status == true login /// false == logout
    {
        Session adminsession=getSessionOfUser(NotificationWebSocketServer.admin);
        if(adminsession!=null)
        {
            System.out.println("sendToAdminSession : "+user.username+" , "+status);
        AdminNotification toadminnotify=new AdminNotification();
        toadminnotify.setMsg(user.username);
        if(status)
        toadminnotify.setAction("LOG_IN");
        else
            toadminnotify.setAction("LOG_OUT");
        String toadminMessage = createAdminNotification(toadminnotify);
        sendToSession(adminsession, toadminMessage);
    }
    }
    private void sendToSession(Session session, String message) {
     try {
            session.getBasicRemote().sendText(message);
        } catch (IOException ex) {
            //sessions.remove(session);
            Logger.getLogger(NotificationSessionHandler.class.getName()).log(Level.SEVERE, "sendToSession", ex);
        }
    }
    
    public void SendtoAdminOnlineUsersList()
    {
        List<String> onlineusers=new ArrayList();
        int index=0;
        System.out.println("SendtoAdminOnlineUsersList : "+usersMap.size());
        for (Map.Entry<String, userinfo> entry : usersMap.entrySet()) {
            String key = entry.getKey();
            if(!key.equalsIgnoreCase(NotificationWebSocketServer.admin))
            {
             onlineusers.add(key);
                System.out.println("user name= "+key);
            }
            index++;
        }
        AdminNotification onlineusernotify=new AdminNotification();
        onlineusernotify.setAction("ONLINE_USERS");
        onlineusernotify.setMsg("");
        onlineusernotify.setUsers(onlineusers);
        String toadmin=createAdminNotification(onlineusernotify);
        sendToSession(usersMap.get(NotificationWebSocketServer.admin).getSession(), toadmin);
    }
    
}