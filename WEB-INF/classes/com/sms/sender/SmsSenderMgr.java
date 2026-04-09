/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.sms.sender;

import com.nexmo.client.NexmoClient;
import com.nexmo.client.NexmoClientException;
import com.nexmo.client.sms.SmsSubmissionResponse;
import com.nexmo.client.sms.messages.TextMessage;
import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.SqlMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.persistence.relational.RDBGateWay;
import com.tracker.db_access.IssueStatusMgr;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author walid
 */
public class SmsSenderMgr  extends RDBGateWay {
     private static SmsSenderMgr smsSenderMgr = new SmsSenderMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
   private static MetaDataMgr mdgr=MetaDataMgr.getInstance();
   private static String apiKey;
   private static String apiSecret;
    public static SmsSenderMgr getInstance() {
        logger.info("Getting SmsSenderMgr Instance ....");
        apiKey=mdgr.getApiKey();
        apiSecret=mdgr.getApiSecret();
        return smsSenderMgr;
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
public boolean test(){
    
    
    NexmoClient client = new NexmoClient.Builder()
  .apiKey(apiKey)
  .apiSecret(apiSecret)
  .build();

String messageText = "Hello from Nexmo";
TextMessage message = new TextMessage("Nexmo", "201140262154", messageText);

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

public boolean send(String num,String msg){
    
    
    NexmoClient client = new NexmoClient.Builder()
  .apiKey(apiKey)
  .apiSecret(apiSecret)
  .build();
String api=apiKey;
String se=apiSecret;
String messageText = "Hello from Nexmo";
TextMessage message = new TextMessage("Nexmo", "2"+num,msg+"\uD83E\uDD18", true);
//+"\uD83E\uDD18" for en
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


    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
       /* if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("issue_state.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }*/
    }


    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
}
