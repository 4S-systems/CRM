package com.silkworm.automation;

import com.maintenance.common.SenderConfiurationMgr;
import com.maintenance.common.Tools;
import static com.maintenance.common.Tools.getFileSeparator;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.email.EmailUtility;
import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class ClientsReport implements Job {
    public ClientsReport(){
        
    } 
    
    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        SenderConfiurationMgr confiuration = SenderConfiurationMgr.getCurrentInstance();
        try {
            byte[] bytes = Tools.generateAbstractClientsReport();
            String emails = confiuration.getEmailsEscalation();
            String title ="Abstract Clients Report";
            String body = confiuration.getBodyEscalation();
            EmailUtility.sendMessage(emails, title, body, metaDataMgr.getBackupDir() + getFileSeparator(), bytes);
            Logger.getLogger(ClientsReport.class.getName()).info("[" + ClientsReport.class + "] **************** Secucces Send to [" + emails + "] ****************");
        } catch (Exception ex) {
            Logger.getLogger(ClientsReport.class.getName()).error("[" + ClientsReport.class + "] SFail Send///////////////////, " + ex);
        }
    }
}
