/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.notificationsender.websocket;



import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.ApplicationSessionRegistery;
import com.silkworm.db_access.PersistentSessionMgr;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.Map;
import java.util.Set;

import java.util.List;
 import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
import javax.websocket.EndpointConfig;
import javax.websocket.OnMessage;
import javax.websocket.server.ServerEndpoint;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

@ServerEndpoint(value="/notify", configurator=ChatServerEndPointConfigurator.class)

public class NotificationWebSocketServer 
{
  private final NotificationSessionHandler sessionHandler=new NotificationSessionHandler();
static final String  admin="administartor" ;

    /**
     * @OnOpen allows us to intercept the creation of a new session.
     * The session class allows us to send data to the user.
     * In the method onOpen, we'll let the user know that the handshake was 
     * successful.
     */
    @OnOpen
    public void onOpen(Session session,EndpointConfig config){
        userinfo user=(userinfo) config.getUserProperties().get(userinfo.class.getName());
        user.setSession(session);
        String username= user.getUsername();
        String sessiionid= user.getSessionid();
        sessionHandler.addUser(user);
        System.out.println(username+"with session ID = "+sessiionid+" has opened a connection"); 
        if(!admin.equals(username))
         newJoinUpdate(user);
        System.out.println(session.getId() + " has opened a connection"); 
        /*try {
            session.getBasicRemote().sendText("Connection Established");
        } catch (IOException ex) {
            ex.printStackTrace();
        }*/
    }
 
    
     /**
     * When a user sends a message to the server, this methdo will intercept the message
     * and allow us to react to it. For now the message is read as a String.
     */
    @OnMessage
    public void onMessage(String message, Session session){
        JSONParser parser = new JSONParser();
        try
        {
            System.out.println("Message from " + session.getId() + ": " + message);
            Object obj = parser.parse(message);
            JSONObject jsonObject = (JSONObject) obj;
            String msg=(String) jsonObject.get("msg");
            System.out.println("msg= "+(String) jsonObject.get("msg"));
            Logger.getLogger(NotificationWebSocketServer.class.getName()).log(Level.SEVERE, null, "msg= "+(String) jsonObject.get("msg"));
             String action =(String) jsonObject.get("action");
              switch (action) {
                    case "ONLINE_USERS":
                      sessionHandler.SendtoAdminOnlineUsersList();
                      break;
                    case "NOTIFY":
                        AdminNotification notification = new AdminNotification();
                        notification.setMsg((String) jsonObject.get("msg"));
                        notification.setAction((String) jsonObject.get("action"));
                       JSONArray jsonusers= (JSONArray)jsonObject.get("users");
                       
                       List<String> userslist = new ArrayList<String>();
                       for(int i=0;i<jsonusers.size();i++)
                       {
                            userslist.add((String) jsonusers.get(i));
                       }
                       notification.setUsers(userslist);
                       
                      System.out.println("msg= "+(String) jsonObject.get("msg")+" action = NOTIFY");
                      sessionHandler.addAdminNotification(notification);
                        break;
                    case "LOG_OUT":
                        System.out.println("case  log out");
                         if(ApplicationSessionRegistery.getInstance().getSession(msg)==null)
                         {
                             System.out.println("real log out");
                         }
                         else
                         {
                             System.out.println("fake log out");
                         }
                        break;
                    case "REDIRECT":
                        notification = new AdminNotification();
                        notification.setMsg((String) jsonObject.get("msg"));
                        notification.setAction((String) jsonObject.get("action"));
                        jsonusers = (JSONArray) jsonObject.get("users");
                        userslist = new ArrayList<>();
                        for (Object jsonUser : jsonusers) {
                            userslist.add((String) jsonUser);
                        }
                        notification.setUsers(userslist);
                        sessionHandler.addAdminNotification(notification);
                        break;
                    default:
                      break;
                      }
          
        }
        catch (ParseException ex)
        {
            Logger.getLogger(NotificationWebSocketServer.class.getName()).log(Level.SEVERE, null, ex);
        }
         catch (Exception ex) {
              Logger.getLogger(NotificationWebSocketServer.class.getName()).log(Level.SEVERE, null, ex);
            
        }
    }
 
    
     /**
     * The user closes the connection.
     * 
     * Note: you can't send messages to the client from this method
     */
    @OnClose
    public void onClose(Session session){
        sessionHandler.removeUser(session.getId());
        
    }

    @OnError
      public void onError(Throwable error) {
           System.out.println("An Error has Occurred  " +error.getMessage());
        Logger.getLogger(NotificationWebSocketServer.class.getName()).log(Level.SEVERE, null, error);
    }

      private void newJoinUpdate(userinfo user)
      {
          System.out.println("newJoinUpdate : "+user.username);
          sessionHandler.sendToAdminSession(user,true);
      }
      
      
}