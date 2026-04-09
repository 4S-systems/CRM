package com.silkworm.automation;

import com.clients.db_access.ClientMgr;
import java.util.logging.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class InterLocalAutoUpdate implements Job {

    private static final Logger logger = Logger.getLogger(InterLocalAutoUpdate.class.getName());

    public InterLocalAutoUpdate() {
    }

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        logger.info("--------------------------- Starting International Local Client Auto Update ---------------------------");
        System.out.println("--------------------------- Starting International Local Client Auto Update ---------------------------");
        ClientMgr.getInstance().updateInterLocalClientsType();
    }
}
