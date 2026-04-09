package com.silkworm.automation;

import com.clients.db_access.ClientComplaintsMgr;
import com.clients.db_access.QualityPlanMgr;
import com.crm.common.CRMConstants;
import com.silkworm.business_objects.WebBusinessObject;
import com.tracker.db_access.IssueMgr;
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

public class QualityPlanAutomation implements Job {

    private final Logger logger;
    private final QualityPlanMgr qualityPlanMgr;
    private final IssueMgr issueMgr;
    private final ClientComplaintsMgr clientComplaintsMgr;

    public QualityPlanAutomation() {
        logger = Logger.getLogger(QualityPlanAutomation.class);
        qualityPlanMgr = QualityPlanMgr.getInstance();
        issueMgr = IssueMgr.getInstance();
        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
    }

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        try {
            logger.info("--------------------------- Starting Automation Quality Plan ---------------------------");
            List<WebBusinessObject> plans = qualityPlanMgr.getOnArbitraryKeyOracle(CRMConstants.QUALITY_PLAN_STATUS_PLANNED, "key2");
            IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            for (WebBusinessObject planWbo : plans) {
                String userID = (String) planWbo.getAttribute("createdBy");
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
                WebBusinessObject wboTemp = new WebBusinessObject();
                wboTemp.setAttribute("notes", planWbo.getAttribute("title"));
                wboTemp.setAttribute("userId", userID);
                wboTemp.setAttribute("clientId", "2"); // for client 'Owners Association'
                while (toDateTime.after(fromDateTime)) {
                    wboTemp.setAttribute("entryDate", fromDateTime);
                    String issueId = issueMgr.saveAutoData(wboTemp);
                    WebBusinessObject issue = issueMgr.getOnSingleKey(issueId);
                    clientComplaintsMgr.createFutureMailInBox(userID, CRMConstants.QUALITY_MANAGER_ID, issueId, "22", (String) issue.getAttribute("businessID"), (String) planWbo.getAttribute("title"), (String) planWbo.getAttribute("requestedTitle"), new java.sql.Date(fromDateTime.getTime()));
                    c.add(type, frequencyRateVal);
                    fromDateTime.setTime(c.getTimeInMillis());
                }
                if (qualityPlanMgr.updateQualityPlanStatus((String) planWbo.getAttribute("id"), CRMConstants.QUALITY_PLAN_STATUS_EXECUTED)) {
                    issueStatusMgr.changeStatus(CRMConstants.QUALITY_PLAN_STATUS_EXECUTED, (String) planWbo.getAttribute("id"), "quality plan",
                            sdf.format(fromDateTime), "0", (String) planWbo.getAttribute("createdBy"), "UL", "UL", "UL", "UL", "UL", null);
                }
            }
            logger.info(">>>>>>>>>>>>>>>>>>>> End of Automation Quality Plan");
        } catch (Exception ex) {
            java.util.logging.Logger.getLogger(QualityPlanAutomation.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
