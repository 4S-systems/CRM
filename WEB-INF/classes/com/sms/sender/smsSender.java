/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.sms.sender;
//import com.maintenance.common.SmsSender;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import com.nexmo.client.NexmoClient;
/**
 *
 * @author walid
 */
import com.nexmo.client.NexmoClientException;
import com.nexmo.client.sms.SmsSubmissionResponse;
import com.nexmo.client.sms.SmsSubmissionResponseMessage;
import com.nexmo.client.sms.messages.TextMessage;
public class smsSender {
    private static final smsSender SENDER = new smsSender();
    
    public static smsSender getInstance() {
        return SENDER;
    }
    
public boolean test(){
    NexmoClient client = new NexmoClient.Builder()
  .apiKey("4272abb1")
  .apiSecret("PvOVnxvM5cFqe8VX")
  .build();

String messageText = "Hello from swift crm";
TextMessage message = new TextMessage("Nexmo", "201226113053", messageText);

SmsSubmissionResponse response = null;
        try {
            response = client.getSmsClient().submitMessage(message);
        } catch (IOException ex) {
            Logger.getLogger(smsSender.class.getName()).log(Level.SEVERE, null, ex);
        } catch (NexmoClientException ex) {
            Logger.getLogger(smsSender.class.getName()).log(Level.SEVERE, null, ex);
        }

return true;
}

}
