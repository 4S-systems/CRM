/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.notificationsender.websocket;
 
import com.silkworm.common.SecurityUser;
import javax.servlet.http.HttpSession;
import javax.websocket.HandshakeResponse;
import javax.websocket.server.HandshakeRequest;
import javax.websocket.server.ServerEndpointConfig;
import javax.websocket.server.ServerEndpointConfig.Configurator;
 
/**
 * ChatServerEndPointConfigurator
 */
public class ChatServerEndPointConfigurator extends ServerEndpointConfig.Configurator {
 
    private static NotificationWebSocketServer chatServer = new NotificationWebSocketServer();
 
    @Override
    public <T> T getEndpointInstance(Class<T> endpointClass) throws InstantiationException {
        return (T)chatServer;
    }
    
     @Override
    public void modifyHandshake(ServerEndpointConfig config, 
                                HandshakeRequest request, 
                                HandshakeResponse response)
    {
        HttpSession httpSession = (HttpSession)request.getHttpSession();
        SecurityUser securityUser = (SecurityUser)   httpSession.getAttribute("securityUser");
        String userName = securityUser.getFullName();
        String sessionid2=httpSession.getId();
        userinfo user=new userinfo(userName,sessionid2);
        config.getUserProperties().put(userinfo.class.getName(),user);
        //config.getUserProperties().put(String.class.getName(),sessionid);
    }
}