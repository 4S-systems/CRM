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

public class CommentsReplyReport implements Job {

    public CommentsReplyReport() {

    }

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        SenderConfiurationMgr confiuration = SenderConfiurationMgr.getCurrentInstance();
        try {
            byte[] bytes = Tools.generateCommentsReplyReport();
            String emails = confiuration.getEmailsEscalation();
            String title ="Delayed Tasks Report";
            String body = confiuration.getBodyEscalation();
            EmailUtility.sendMessage(emails, title, body, metaDataMgr.getBackupDir() + getFileSeparator(), bytes);
          //  LOGGER.info("[" + AcknowledgeReport.class + "] **************** Secucces Send to [" + emails + "] ****************");
        } catch (Exception ex) {
        //    LOGGER.error("[" + AcknowledgeReport.class + "] SFail Send///////////////////, " + ex);
        }
    }
}
