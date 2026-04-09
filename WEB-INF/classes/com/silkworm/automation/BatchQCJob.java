package com.silkworm.automation;

import com.clients.db_access.ClientComplaintsMgr;
import com.crm.common.ActionEvent;
import com.crm.common.CRMConstants;
import com.crm.db_access.AlertMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.UserMgr;
import com.silkworm.util.DateAndTimeControl;
import com.tracker.db_access.IssueMgr;
import com.tracker.db_access.IssueStatusMgr;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class BatchQCJob implements Job {

    private static final Logger LOGGER = Logger.getLogger(BatchQCJob.class);

    public BatchQCJob() {
    }

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        LOGGER.info(">>>>>>>>>>>>>>>>>>>>>>>> Batch QC Job ");
        ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
        IssueMgr issueMgr = IssueMgr.getInstance();
        IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
        UserMgr userMgr = UserMgr.getInstance();
        AlertMgr alertMgr = AlertMgr.getInstance();
        WebBusinessObject userWbo = userMgr.getOnSingleKey(CRMConstants.AMR_KASRAWY_ID);
        ArrayList<WebBusinessObject> complaintsList = clientComplaintsMgr.getAllQCNotCompletedComplaints();
        WebBusinessObject wbo;
        String issueStatus, issueId, businessId, ticketType, notes, comments, lastClientComplaintOfTypeRequestExtradition, createdBy;
        for(WebBusinessObject complaintWbo : complaintsList) {
            try {
                issueStatus = (String) complaintWbo.getAttribute("issueStatus");
                issueId = (String) complaintWbo.getAttribute("issueId");
                createdBy = (String) complaintWbo.getAttribute("createdBy");
                LOGGER.info(">>>>>>>>>>>>>>>>>>>>>>>> Batch QC Job issue id --> " + issueId + " , complaint id --> " + complaintWbo.getAttribute("id"));
                switch (issueStatus) {
                    case CRMConstants.ISSUE_STATUS_ACCEPTED:
                        LOGGER.info(">>>>>>>>>>>>>>>>>>>>>>>> Batch QC Job Accepted ");
                        wbo = new WebBusinessObject();
                        wbo.setAttribute("parentId", issueId);
                        wbo.setAttribute("businessObjectId", complaintWbo.getAttribute("id"));
                        wbo.setAttribute("statusCode", CRMConstants.CLIENT_COMPLAINT_STATUS_CLOSED);
                        wbo.setAttribute("objectType", CRMConstants.OBJECT_TYPE_CLIENT_COMPLAINT);
                        wbo.setAttribute("notes", "Accepted (Batch)");
                        wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                        wbo.setAttribute("issueTitle", "UL");
                        wbo.setAttribute("statusNote", "Accepted (Batch)");
                        wbo.setAttribute("cuseDescription", "UL");
                        wbo.setAttribute("actionTaken", "Finish Ticket");
                        wbo.setAttribute("preventionTaken", "UL");
                        
                        issueStatusMgr.changeStatus(wbo, userWbo, ActionEvent.getClientComplaintsActionEvent());
                        alertMgr.saveObjectAcceptTicket(issueId, createdBy);
                        break;
                    case CRMConstants.ISSUE_STATUS_ACCEPTED_WITH_OBSERVATION:
                        LOGGER.info(">>>>>>>>>>>>>>>>>>>>>>>> Batch QC Job Accepted with notes");
                        wbo = new WebBusinessObject();
                        wbo.setAttribute("parentId", issueId);
                        wbo.setAttribute("businessObjectId", complaintWbo.getAttribute("id"));
                        wbo.setAttribute("statusCode", CRMConstants.CLIENT_COMPLAINT_STATUS_FINISHED);
                        wbo.setAttribute("objectType", CRMConstants.OBJECT_TYPE_CLIENT_COMPLAINT);
                        wbo.setAttribute("notes", "Accepted with note (Batch)");
                        wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                        wbo.setAttribute("issueTitle", "UL");
                        wbo.setAttribute("statusNote", "Accepted with note (Batch)");
                        wbo.setAttribute("cuseDescription", "UL");
                        wbo.setAttribute("actionTaken", "Finish Ticket");
                        wbo.setAttribute("preventionTaken", "UL");
                        
                        issueStatusMgr.changeStatus(wbo, userWbo, ActionEvent.getClientComplaintsActionEvent());
                        businessId = issueMgr.getByKeyColumnValue(issueId, "key5");
                        comments = "مقبول بملاحظات";
                        ticketType = CRMConstants.CLIENT_COMPLAINT_TYPE_RE_REQUEST_EXTRADITION;
                        notes = "أعادة توجيه من  أدارة الجودة لأنه مقبول بملاحظات";
                        lastClientComplaintOfTypeRequestExtradition = clientComplaintsMgr.getLastTicketTypeOnIssue(issueId, CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_EXTRADITION);
                        wbo = clientComplaintsMgr.getCurrentSenderAndResponsible(lastClientComplaintOfTypeRequestExtradition);
                        if (wbo != null && wbo.getAttribute("senderId") != null) {
                            String lastSender = (String) wbo.getAttribute("senderId");
                            clientComplaintsMgr.createMailInBox(createdBy, lastSender, issueId, ticketType, businessId, comments, notes, notes);
                        }
                        alertMgr.saveObjectAcceptTicket(issueId, createdBy);
                        break;
                    case CRMConstants.ISSUE_STATUS_FINAL_REJECTION:
                        LOGGER.info(">>>>>>>>>>>>>>>>>>>>>>>> Batch QC Job Final rejection");
                        wbo = new WebBusinessObject();
                        wbo.setAttribute("parentId", issueId);
                        wbo.setAttribute("businessObjectId", complaintWbo.getAttribute("id"));
                        wbo.setAttribute("statusCode", CRMConstants.CLIENT_COMPLAINT_STATUS_CLOSED);
                        wbo.setAttribute("objectType", CRMConstants.OBJECT_TYPE_CLIENT_COMPLAINT);
                        wbo.setAttribute("notes", "Refused (Batch)");
                        wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                        wbo.setAttribute("issueTitle", "UL");
                        wbo.setAttribute("statusNote", "Refused (Batch)");
                        wbo.setAttribute("cuseDescription", "UL");
                        wbo.setAttribute("actionTaken", "Finish Ticket");
                        wbo.setAttribute("preventionTaken", "UL");
                        
                        issueStatusMgr.changeStatus(wbo, userWbo, ActionEvent.getClientComplaintsActionEvent());
                        businessId = issueMgr.getByKeyColumnValue(issueId, "key5");
                        comments = "مرفوض نهائيا";
                        ticketType = CRMConstants.CLIENT_COMPLAINT_TYPE_RE_REQUEST_EXTRADITION;
                        notes = "أعادة توجيه من  أدارة الجودة لأنه مرفوض نهائيا";
                        lastClientComplaintOfTypeRequestExtradition = clientComplaintsMgr.getLastTicketTypeOnIssue(issueId, CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_EXTRADITION);
                        wbo = clientComplaintsMgr.getCurrentSenderAndResponsible(lastClientComplaintOfTypeRequestExtradition);
                        if (wbo != null && wbo.getAttribute("senderId") != null) {
                            String lastSender = (String) wbo.getAttribute("senderId");
                            clientComplaintsMgr.createMailInBox(createdBy, lastSender, issueId, ticketType, businessId, comments, notes, notes);
                        }
                        alertMgr.saveObjectRejectTicket(issueId, createdBy);
                        break;
//                    case CRMConstants.ISSUE_STATUS_REJECTED:
//                        LOGGER.info(">>>>>>>>>>>>>>>>>>>>>>>> Batch QC Job Rejected");
//                        alertMgr.saveObjectRejectTicket(issueId, createdBy);
//                        break;
                }
            } catch (SQLException ex) {
                java.util.logging.Logger.getLogger(BatchQCJob.class.getName()).log(Level.SEVERE, null, ex);
            } catch (Exception ex) {
                java.util.logging.Logger.getLogger(BatchQCJob.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
}
