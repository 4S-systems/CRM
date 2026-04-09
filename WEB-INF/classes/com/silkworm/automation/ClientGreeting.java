package com.silkworm.automation;

import com.maintenance.common.DateParser;
import com.maintenance.common.SenderConfiurationMgr;
import com.maintenance.common.Tools;
import static com.maintenance.common.Tools.getFileSeparator;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.email.EmailUtility;
import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import java.util.Calendar;

public class ClientGreeting implements Job {

    public ClientGreeting() {
    }

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        SenderConfiurationMgr confiuration = SenderConfiurationMgr.getCurrentInstance();

        try {
            String emails = confiuration.getEmailsEscalation();
            String title = "Greeting Birthday";
            String body = confiuration.getBodyEscalation();
            EmailUtility.sendMessageWithImage(emails, title, body);
        } catch (Exception ex) {
            System.out.println("Email Greeting Exception = " + ex.getMessage());        }
    }
}
