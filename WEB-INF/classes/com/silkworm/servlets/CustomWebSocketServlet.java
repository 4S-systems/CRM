/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.silkworm.servlets;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
//import org.apache.catalina.websocket.MessageInbound;
//import org.apache.catalina.websocket.StreamInbound;
//import org.apache.catalina.websocket.WebSocketServlet;
//import org.apache.catalina.websocket.WsOutbound;

/**
 *
 * @author walid
 */
public class CustomWebSocketServlet /*extends WebSocketServlet*/ {

    private static final long serialVersionUID = 1L;
//    private static final List<CustomMessageInbound> messages = new ArrayList<CustomMessageInbound>();

//    @Override
//    protected StreamInbound createWebSocketInbound(String string, HttpServletRequest request) {
//        return new CustomMessageInbound();
//    }
//
//    private class CustomMessageInbound extends MessageInbound {
//
//        private WsOutbound out;
//
//        @Override
//        protected void onOpen(WsOutbound out) {
//        System.out.println("/////////////////////getOutboundCharBufferSize(): " + getOutboundCharBufferSize());
//            System.out.println("Open Client: " + out);
//            this.out = out;
//            messages.add(this);
//        }
//
//        @Override
//        protected void onClose(int status) {
//            System.out.println("Close Client: " + out);
//            messages.remove(this);
//        }
//
//        @Override
//        protected void onBinaryMessage(ByteBuffer bb) throws IOException {
//
//        }
//
//        @Override
//        protected void onTextMessage(CharBuffer buffer) throws IOException {
//            System.out.println("Accept Message : " + buffer);
//            CharBuffer wrap;
//            for (CustomMessageInbound message : messages) {
//                System.out.println("Send Message : " + buffer + ", To: " + message.getOut());
//                wrap = CharBuffer.wrap(buffer);
//                message.out.writeTextMessage(wrap);
//                message.out.flush();
//            }
//        }
//
//        public WsOutbound getOut() {
//            return out;
//        }
//    }
}
