/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.silkworm.automation;


/* 
 * Copyright 2005 - 2009 Terracotta, Inc. 
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not 
 * use this file except in compliance with the License. You may obtain a copy 
 * of the License at 
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0 
 *   
 * Unless required by applicable law or agreed to in writing, software 
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT 
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the 
 * License for the specific language governing permissions and limitations 
 * under the License.
 * 
 */
import com.maintenance.common.SenderConfiurationMgr;
import com.maintenance.common.Tools;
import static com.maintenance.common.Tools.getFileSeparator;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.email.EmailUtility;
import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

/**
 * <p>
 * This is just a simple job that says "Hello" to the world.
 * </p>
 *
 * @author Bill Kratzer
 */
public class AcknowledgeReport implements Job {

    private static final Logger LOGGER = Logger.getLogger(AcknowledgeReport.class);

    /**
     * <p>
     * Empty constructor for job initialization
     * </p>
     * <p>
     * Quartz requires a public empty constructor so that the scheduler can
     * instantiate the class whenever it needs.
     * </p>
     */
    public AcknowledgeReport() {
    }

    /**
     * <p>
     * Called by the <code>{@link org.quartz.Scheduler}</code> when a
     * <code>{@link org.quartz.Trigger}</code> fires that is associated with the
     * <code>Job</code>.
     * </p>
     *
     * @param context
     * @throws JobExecutionException if there is an exception while executing
     * the job.
     */
    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        SenderConfiurationMgr confiuration = SenderConfiurationMgr.getCurrentInstance();
        try {
            byte[] bytes = Tools.generateNotAcknowledgeReport(confiuration.getDelayEscalation());
            String emails = confiuration.getEmailsEscalation();
            String title = confiuration.getTitleEscalation();
            String body = confiuration.getBodyEscalation();
            EmailUtility.sendMessage(emails, title, body, metaDataMgr.getBackupDir() + getFileSeparator(), bytes);
            LOGGER.info("[" + AcknowledgeReport.class + "] **************** Secucces Send to [" + emails + "] ****************");
        } catch (Exception ex) {
            LOGGER.error("[" + AcknowledgeReport.class + "] SFail Send///////////////////, " + ex);
        }
    }
}
