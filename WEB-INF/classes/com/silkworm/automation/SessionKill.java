package com.silkworm.automation;

import com.DatabaseController.db_access.DatabaseControllerMgr;
import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class SessionKill implements Job {

    private static final Logger logger = Logger.getLogger(SessionKill.class);

    public SessionKill() {
    }

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        logger.info("--------------------------- Starting Sessions Kill ---------------------------");
        System.out.println("--------------------------- Starting Sessions Kill ---------------------------");
        DatabaseControllerMgr databaseControllerMgr = DatabaseControllerMgr.getInstance();
        databaseControllerMgr.killInactiveSessions();
        logger.info("--------------------------- Ending Sessions Kill ---------------------------");
        System.out.println("--------------------------- Ending Sessions Kill ---------------------------");
    }
}
