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

public class ClientByEmployeeReport implements Job {

    public ClientByEmployeeReport() {
    }

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        SenderConfiurationMgr confiuration = SenderConfiurationMgr.getCurrentInstance();

        try {
            String group = confiuration.getClientEmpGroup();
            String daysNo = confiuration.getClientEmpDaysNo();

            java.util.Date todayDate = new java.util.Date();
            Calendar cal =Calendar.getInstance();
            cal.setTime(todayDate);
            cal.add(Calendar.DATE, -new Integer(daysNo));
            java.util.Date tempDate = cal.getTime();
            java.sql.Date bDate = new java.sql.Date(tempDate.getTime());
            
//            DateParser dateParser = new DateParser();
//            java.sql.Date bDate = new java.sql.Date(dateParser.formatSqlDate(beginDate).getTime());
//            Calendar cal =Calendar.getInstance();
//            cal.setTime(bDate);
            
            java.util.Date eUtilDate = new java.util.Date();
            java.sql.Date eDate = new java.sql.Date(eUtilDate.getTime());
            
            byte[] bytes = Tools.generateClientsByEmployeeReport(group, bDate, eDate);
            String emails = confiuration.getEmailsEscalation();
            String title = "Clients by Employee Report";
            String body = confiuration.getBodyEscalation();
            EmailUtility.sendMessage(emails, title, body, metaDataMgr.getBackupDir() + getFileSeparator(), bytes);
        } catch (Exception ex) {
            System.out.println("ClientsByEmployeeReport Exception = " + ex.getMessage());        }
    }
}
