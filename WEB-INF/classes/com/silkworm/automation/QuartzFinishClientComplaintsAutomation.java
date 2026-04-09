package com.silkworm.automation;

import com.crm.common.CRMConstants;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.db_access.QuartzFinishSchedulerMgr;
import com.tracker.db_access.ProjectMgr;
import java.util.List;
import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class QuartzFinishClientComplaintsAutomation implements Job {

    private static final ProjectMgr projectMgr = ProjectMgr.getInstance();
    private static final Logger logger = Logger.getLogger(QuartzFinishClientComplaintsAutomation.class);
    private final QuartzFinishSchedulerMgr finishSchedulerMgr;

    public QuartzFinishClientComplaintsAutomation() {
        finishSchedulerMgr = QuartzFinishSchedulerMgr.getInstance();
    }

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        List<WebBusinessObject> schedules = finishSchedulerMgr.getAllDepartments();
        logger.info("--------------------------- Starting Automation Department ---------------------------");

        CustomScheduler scheduler;
        boolean running;
        logger.info(">>>>>>>>>>>>>>>>>>>>>>>> Automation Department " + schedules.size());
        for (WebBusinessObject schedule : schedules) {
            try {
                running = (schedule.getAttribute("running") != null && schedule.getAttribute("running").toString().equalsIgnoreCase(CRMConstants.QUARTZ_ACTION_STATUS_RUNNING));
                if (!finishSchedulerMgr.isSchedulerExist((String) schedule.getAttribute("id")) && running) {
                    scheduler = generateScheduler(schedule);
                    if (scheduler != null) {
                        finishSchedulerMgr.addScheduler(scheduler);
                    }
                }
            } catch (Exception ex) {
                logger.error(ex);
            }
        }
    }

    public static CustomScheduler generateScheduler(WebBusinessObject quartzInfo) {
        CustomScheduler scheduler = null;
        String id, objectId, objectCode;
        int interval;
        String[] keys = new String[]{"departmentCode", "interval"};
        Object[] values;
        try {
            if (quartzInfo.getAttribute("interval") != null) {
                id = (String) quartzInfo.getAttribute("id");
                objectId = (String) quartzInfo.getAttribute("objectId");
                objectCode = projectMgr.getProjectCode(objectId);
                interval = Integer.parseInt((String) quartzInfo.getAttribute("interval"));

                if ((objectCode != null) && (interval > 0)) {
                    values = new Object[]{objectCode, interval};

                    scheduler = CustomScheduler.getInstance(id, DepartmentFinishClientComplaintsAutomation.class, interval * 60 * 60);
                    scheduler.init(keys, values);
                    scheduler.getScheduler().start();
                }
            }
        } catch (NumberFormatException ex) {
            logger.error(ex);
        } catch (Exception ex) {
            logger.error(ex);
        }

        return scheduler;
    }
}
