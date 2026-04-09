/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.silkworm.automation;

import com.maintenance.common.SenderConfiurationMgr;
import com.maintenance.common.SmsSender;
import com.silkworm.email.EmailUtility;
import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.quartz.SchedulerException;
import org.quartz.TriggerKey;

/**
 *
 * @author walid
 */
public class ClientEmailSmsAutomation implements Job {

    private final static Logger logger = Logger.getLogger(ClientEmailSmsAutomation.class);
    private final SenderConfiurationMgr confiuration;
    private String mobile;
    private String email;

    public ClientEmailSmsAutomation() {
        this.confiuration = SenderConfiurationMgr.getCurrentInstance();
    }

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        JobDataMap data = context.getJobDetail().getJobDataMap();
        mobile = data.getString("mobile");
        email = data.getString("email");

        String title = confiuration.getTitleNewClient();
        String content = confiuration.getBodyNewClient();
        String message = confiuration.getSmsClientMessage();

        try {
            logger.info("Trying Send Email: to= " + email + ", title= " + title + ", content= " + content);
            if (EmailUtility.sendMessage(email, title, content)) {
                logger.info("Success Send Email: to= " + email + ", title= " + title + ", content= " + content);
            } else {
                logger.error("Fail Send Email: to= " + email + ", title= " + title + ", content= " + content);
            }
        } catch (Exception ex) {
            logger.error("Fail Send Email: to= " + email + ", title= " + title + ", content= " + content + ", error= " + ex);
        }

        try {
            logger.info("Trying Send SMS: to= " + mobile + ", content= " + content);
            if (SmsSender.getInstance().send(mobile, message)) {
                logger.info("End Trying Send SMS: to= " + mobile + ", content= " + content);
            } else {
                logger.error("Fail Send SMS: to= " + mobile + ", content= " + content);
            }
        } catch (Exception ex) {
            logger.error("Fail Send SMS: to= " + mobile + ", content= " + content + ", error= " + ex);
        }

        try {
            context.getScheduler().unscheduleJob(new TriggerKey("CustomSchedulerSingleTrigger", "CustomSchedulerSingleGroup"));
            logger.info("unscheduleJob " + context.getScheduler());
        } catch (SchedulerException ex) {
            logger.error("Error when shutdown " + context.getScheduler() + ", error= " + ex);
        }
    }
}
