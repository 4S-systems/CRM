package com.silkworm.automation;

import com.clients.db_access.AppointmentMgr;
import com.clients.db_access.CallingPlanDetailsMgr;
import com.clients.db_access.CallingPlanMgr;
import com.crm.common.CRMConstants;
import com.silkworm.business_objects.WebBusinessObject;
import com.tracker.db_access.IssueStatusMgr;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.logging.Level;
import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class CallingPlanAutomation implements Job {

    private final Logger logger;
    private final CallingPlanMgr callingPlanMgr;
    private final CallingPlanDetailsMgr callingPlanDetailsMgr;

    public CallingPlanAutomation() {
        logger = Logger.getLogger(CallingPlanAutomation.class);
        callingPlanMgr = CallingPlanMgr.getInstance();
        callingPlanDetailsMgr = CallingPlanDetailsMgr.getInstance();
    }

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        try {
            logger.info("--------------------------- Starting Automation Calling Plan ---------------------------");
            List<WebBusinessObject> plans = callingPlanMgr.getOnArbitraryKeyOracle(CRMConstants.CALLING_PLAN_STATUS_PLANNED, "key2");
            AppointmentMgr appointmentMgr = AppointmentMgr.getInstance();
            IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            for (WebBusinessObject planWbo : plans) {
                int frequencyRateVal = Integer.parseInt((String) planWbo.getAttribute("frequencyRate"));
                int frequencyTypeVal = Integer.parseInt((String) planWbo.getAttribute("frequencyType"));
                int type = Calendar.WEEK_OF_YEAR;
                if (frequencyTypeVal == 2) {
                    type = Calendar.MONTH;
                }
                Timestamp fromDateTime = (Timestamp.valueOf((String) planWbo.getAttribute("fromDate")));
                Timestamp toDateTime = (Timestamp.valueOf((String) planWbo.getAttribute("toDate")));
                Calendar c = Calendar.getInstance();
                c.setTimeInMillis(fromDateTime.getTime());
                List<WebBusinessObject> plansDetails = callingPlanDetailsMgr.getOnArbitraryKeyOracle((String) planWbo.getAttribute("id"), "key1");
                while (toDateTime.after(fromDateTime)) {
                    for (WebBusinessObject planDetailWbo : plansDetails) {
                        appointmentMgr.saveAppointment((String) planWbo.getAttribute("createdBy"), (String) planDetailWbo.getAttribute("clientID"),
                                "FOLLOW UP", fromDateTime, "DIRECT-FOLLOW-UP", "call", null, null, null, (String) planWbo.getAttribute("option1"),
                                CRMConstants.APPOINTMENT_STATUS_OPEN, null, (String) planWbo.getAttribute("id"),(String) planWbo.getAttribute("privacy"), 0, null, null, "UL", null);
                    }
                    c.add(type, frequencyRateVal);
                    fromDateTime.setTime(c.getTimeInMillis());//delete from manifest_status where MANIFEST_ID not in (select SHIPPING_REQUEST.ID from SHIPPING_REQUEST)
                }
                if (callingPlanMgr.updateCallingPlanStatus((String) planWbo.getAttribute("id"), CRMConstants.CALLING_PLAN_STATUS_EXECUTED)) {
                    issueStatusMgr.changeStatus(CRMConstants.CALLING_PLAN_STATUS_EXECUTED, (String) planWbo.getAttribute("id"), "calling plan",
                            sdf.format(fromDateTime), "0", (String) planWbo.getAttribute("createdBy"), "UL", "UL", "UL", "UL", "UL", null);
                }
            }
            logger.info(">>>>>>>>>>>>>>>>>>>> End of Automation Calling Plan");
        } catch (Exception ex) {
            java.util.logging.Logger.getLogger(CallingPlanAutomation.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
