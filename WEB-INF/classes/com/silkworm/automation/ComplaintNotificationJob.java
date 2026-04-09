package com.silkworm.automation;

import com.clients.db_access.ClientComplaintsMgr;
import com.maintenance.common.SenderConfiurationMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.email.EmailUtility;
import java.util.ArrayList;
import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class ComplaintNotificationJob implements Job {

    private static final Logger LOGGER = Logger.getLogger(ComplaintNotificationJob.class);

    public ComplaintNotificationJob() {
    }

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        SenderConfiurationMgr configuration = SenderConfiurationMgr.getCurrentInstance();
        ArrayList<WebBusinessObject> complaintsList = ClientComplaintsMgr.getInstance().getRecentComplaints(Integer.parseInt(configuration.getComplaintNotificationInterval()));
        if (!complaintsList.isEmpty()) {
            try {
                for (WebBusinessObject complaintWbo : complaintsList) {
                    String emails = (String) complaintWbo.getAttribute("email");
                    String title = (String) complaintWbo.getAttribute("typeName");
                    StringBuilder body = new StringBuilder();
                    body.append("<b>اسم العميل :").append(complaintWbo.getAttribute("clientName")).append("</b><br />");
                    body.append("<b>المحمول :").append(complaintWbo.getAttribute("mobile")).append("</b><br />");
                    body.append("<b><font color='red'>");
                    body.append((String) complaintWbo.getAttribute("businessID")).append("</font><font color='blue'>").append("/");
                    body.append((String) complaintWbo.getAttribute("businessIDbyDate")).append("</font></b><br/>");
                    EmailUtility.sendMessageWithoutAttach(emails, title, body.toString());
                    LOGGER.info("[" + ComplaintNotificationJob.class + "] **************** Secucces Send to [" + emails + "] ****************");
                }
            } catch (Exception ex) {
                LOGGER.error("[" + ComplaintNotificationJob.class + "] SFail Send///////////////////, " + ex);
            }
        }
    }
}
