/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.silkworm.automation;

import com.crm.common.CRMConstants;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.db_access.QuartzSchedulerConfigurationMgr;
import com.tracker.db_access.ProjectMgr;
import java.util.List;
import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

/**
 *
 * @author haytham
 */
public class QuartzClosedClinetComplaintsAutomation implements Job {

    private static final ProjectMgr projectMgr = ProjectMgr.getInstance();
    private static final Logger logger = Logger.getLogger(QuartzClosedClinetComplaintsAutomation.class);
    private final QuartzSchedulerConfigurationMgr schedulerMgr;

    /**
     * <p>
     * Empty constructor for job initialization
     * </p>
     * <p>
     * Quartz requires a public empty constructor so that the scheduler can
     * instantiate the class whenever it needs.
     * </p>
     */
    public QuartzClosedClinetComplaintsAutomation() {
        schedulerMgr = QuartzSchedulerConfigurationMgr.getInstance();
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
        List<WebBusinessObject> schedules = schedulerMgr.getAllDepartments();
        logger.info("--------------------------- Starting Automation Department ---------------------------");

        CustomScheduler scheduler;
        boolean running;
        logger.info(">>>>>>>>>>>>>>>>>>>>>>>> Automation Department " + schedules.size());
        for (WebBusinessObject schedule : schedules) {
            try {
                running = (schedule.getAttribute("running") != null && schedule.getAttribute("running").toString().equalsIgnoreCase(CRMConstants.QUARTZ_ACTION_STATUS_RUNNING));
                if (!schedulerMgr.isSchedulerExist((String) schedule.getAttribute("id")) && running) {
                    scheduler = generateScheduler(schedule);
                    if (scheduler != null) {
                        schedulerMgr.addScheduler(scheduler);
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
                    values = new Object[]{objectCode, new Integer(interval)};

                    scheduler = CustomScheduler.getInstance(id, DepartmentClosedClinetComplaintsAutomation.class, interval * 60 * 60);
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
