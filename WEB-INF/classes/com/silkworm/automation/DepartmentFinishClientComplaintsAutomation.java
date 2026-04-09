package com.silkworm.automation;

import com.clients.db_access.ClientComplaintsMgr;
import com.crm.common.CRMConstants;
import com.maintenance.db_access.IssueByComplaintUniqueMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.tracker.db_access.IssueStatusMgr;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class DepartmentFinishClientComplaintsAutomation implements Job {

    private final Logger logger;
    private final IssueByComplaintUniqueMgr issueByComplaintUniqueMgr;
    private final ClientComplaintsMgr clientComplaintsMgr;
    private final IssueStatusMgr statusMgr;
    private final SimpleDateFormat formatter;
    private String departmentCode;
    private Integer finishInterval;

    public DepartmentFinishClientComplaintsAutomation() {
        logger = Logger.getLogger(DepartmentFinishClientComplaintsAutomation.class);
        issueByComplaintUniqueMgr = IssueByComplaintUniqueMgr.getInstance();
        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
        statusMgr = IssueStatusMgr.getInstance();
        formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    }

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        JobDataMap data = context.getJobDetail().getJobDataMap();
        departmentCode = data.getString("departmentCode");
        finishInterval = data.getInt("interval");
        logger.info("--------------------------- Starting Automation Finishing For Department " + departmentCode + ", Finishing Interval: " + finishInterval + " ---------------------------");
        List<String> ids = issueByComplaintUniqueMgr.getClientComplaintsToBeFinished(departmentCode, finishInterval * 60 * 60);

        WebBusinessObject wbo;
        Calendar calendar = Calendar.getInstance();
        logger.info(">>>>>>>>>>>>>>>>>>>>>>>> Finishing Client Complaints " + ids.size());
        for (String id : ids) {

            wbo = new WebBusinessObject();
            wbo.setAttribute("statusCode", CRMConstants.CLIENT_COMPLAINT_STATUS_FINISHED);
            wbo.setAttribute("date", formatter.format(calendar.getTime()));
            wbo.setAttribute("businessObjectId", id);
            wbo.setAttribute("statusNote", "Automatically Finshed");
            wbo.setAttribute("objectType", CRMConstants.OBJECT_TYPE_CLIENT_COMPLAINT);
            wbo.setAttribute("parentId", "UL");
            wbo.setAttribute("issueTitle", "Automatically Finshed");
            wbo.setAttribute("cuseDescription", "Automatically Finshed");
            wbo.setAttribute("actionTaken", "Automatically Finshed");
            wbo.setAttribute("preventionTaken", "UL");
            try {
                statusMgr.changeStatus(wbo);
                clientComplaintsMgr.updateCurrentStatus(id, CRMConstants.CLIENT_COMPLAINT_STATUS_FINISHED);
            } catch (SQLException ex) {
                logger.error(ex);
            }
            logger.info(">>>>>>>>>>>>>>>>>>>> End of Finish Client Complaints: " + id);
        }
    }
}
