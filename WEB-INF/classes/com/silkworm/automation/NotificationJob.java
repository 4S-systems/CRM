package com.silkworm.automation;

import com.clients.db_access.ClientComplaintsSLAMgr;
import com.crm.db_access.AlertMgr;
import com.maintenance.common.SenderConfiurationMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.email.EmailUtility;
import java.util.ArrayList;
import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class NotificationJob implements Job {

    private static final Logger LOGGER = Logger.getLogger(NotificationJob.class);

    public NotificationJob() {
    }

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        SenderConfiurationMgr confiuration = SenderConfiurationMgr.getCurrentInstance();
        ArrayList<WebBusinessObject> complaintsList = ClientComplaintsSLAMgr.getInstance().getDelayedComplaintsSLA();
        AlertMgr alertMgr = AlertMgr.getInstance();
        if (!complaintsList.isEmpty()) {
            try {
                String emails = confiuration.getNotificationEmails();
                String title = confiuration.getNotificationEmailTitle();
                StringBuilder body = new StringBuilder(confiuration.getNotificationEmailBody());
                body.append("<br/>");
                for (WebBusinessObject complaintWbo : complaintsList) {
                    body.append("<b><font color='red'>");
                    body.append((String) complaintWbo.getAttribute("businessID")).append("</font><font color='blue'>").append("/");
                    body.append((String) complaintWbo.getAttribute("businessIDbyDate")).append("</font></b><br/>");
                    alertMgr.saveObject((String) complaintWbo.getAttribute("clientComplaintID"), "9", "1"); // 9 is alert type id for (warning) // 1 is admin id
                }
                EmailUtility.sendMessageWithoutAttach(emails, title, body.toString());
                LOGGER.info("[" + NotificationJob.class + "] **************** Secucces Send to [" + emails + "] ****************");
            } catch (Exception ex) {
                LOGGER.error("[" + NotificationJob.class + "] SFail Send///////////////////, " + ex);
            }
        }
    }
}
