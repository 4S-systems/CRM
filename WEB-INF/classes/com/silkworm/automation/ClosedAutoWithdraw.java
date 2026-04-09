package com.silkworm.automation;

import com.clients.db_access.ClientComplaintsMgr;
import com.clients.db_access.ClientMgr;
import com.crm.common.CRMConstants;
import com.maintenance.db_access.DistributionListMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.tracker.db_access.IssueMgr;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class ClosedAutoWithdraw implements Job {

    private static final Logger logger = Logger.getLogger(ClosedAutoWithdraw.class.getName());

    public ClosedAutoWithdraw() {
    }

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        logger.info("--------------------------- Starting Closed Auto Withdraw ---------------------------");
        System.out.println("--------------------------- Starting Closed Auto Withdraw ---------------------------");
        IssueMgr issueMgr = IssueMgr.getInstance();
        ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
        ClientMgr clientMgr = ClientMgr.getInstance();
        ArrayList<WebBusinessObject> complaintsList = clientComplaintsMgr.getComplaintsWithRate(CRMConstants.CLIENT_RATE_CLOSED_ID);
        complaintsList.addAll(clientComplaintsMgr.getComplaintsWithRate(CRMConstants.CLIENT_RATE_NOT_INTERESTED_ID));
        complaintsList.addAll(clientComplaintsMgr.getComplaintsWithRate(CRMConstants.CLIENT_RATE_OUT_OF_SEGMENT_ID));
        String clientID, issueID;
        WebBusinessObject loggerWbo = new WebBusinessObject(), issueWbo, clientWbo;
        for (WebBusinessObject complaintWbo : complaintsList) {
            try {
                clientID = (String) complaintWbo.getAttribute("clientID");
                issueID = (String) complaintWbo.getAttribute("issueId");
                issueWbo = issueMgr.getOnSingleKey(issueID);
                if (issueWbo != null) {
                    clientID = (String) issueWbo.getAttribute("clientId");
                    clientWbo = clientMgr.getOnSingleKey(clientID);
                } else {
                    clientWbo = null;
                }
                loggerWbo.setAttribute("objectXml", complaintWbo.getObjectAsXML());
                loggerWbo.setAttribute("realObjectId", clientID == null ? "---" : clientID);
                loggerWbo.setAttribute("userId", "-1"); // auto user id
                loggerWbo.setAttribute("objectName", clientWbo != null ? clientWbo.getAttribute("clientNO") : "---");
                loggerWbo.setAttribute("loggerMessage", "Withdraw Client");
                loggerWbo.setAttribute("eventName", "Withdraw");
                loggerWbo.setAttribute("objectTypeId", "1");
                loggerWbo.setAttribute("eventTypeId", "5");
                loggerWbo.setAttribute("ipForClient", "localhost");
                ArrayList<WebBusinessObject> distributionList = new ArrayList<>(DistributionListMgr.getInstance().getDistributionListByIssueID(issueID));
                if (issueMgr.addWithdrawInfo("-1", distributionList, clientWbo, loggerWbo)
                        && issueMgr.deleteAllIssueData(issueID)) {
                    logger.info("--------------------------- Closed Auto Withdraw ok ---------------------------");
                } else {
                    logger.info("--------------------------- Closed Auto Withdraw fail ---------------------------");
                }
            } catch (SQLException ex) {
                Logger.getLogger(ClosedAutoWithdraw.class.getName()).log(Level.SEVERE, null, ex);
            } catch (Exception ex) {
                Logger.getLogger(ClosedAutoWithdraw.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
}
