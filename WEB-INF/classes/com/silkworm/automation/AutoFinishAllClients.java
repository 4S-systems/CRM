/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.silkworm.automation;

import com.clients.db_access.ClientComplaintsMgr;
import com.clients.db_access.ClientComplaintsTimeLineMgr;
import com.crm.common.ActionEvent;
import com.crm.common.CRMConstants;
import com.maintenance.common.ClosureConfigMgr;
import com.maintenance.common.Tools;
import com.maintenance.db_access.TradeMgr;
import com.maintenance.db_access.UserCompanyProjectsMgr;
import com.routing.servlets.ComplaintEmployeeServlet;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.common.UserMgr;
import com.silkworm.email.EmailUtility;
import com.tracker.db_access.IssueMgr;
import com.tracker.db_access.IssueProjectMgr;
import com.tracker.db_access.IssueStatusMgr;
import com.tracker.db_access.ProjectMgr;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.logging.Level;
import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import java.util.Iterator;
import java.util.List;

/**
 *
 * @author haytham
 */
public class AutoFinishAllClients implements Job {

    private final Logger logger;
    private final ClientComplaintsTimeLineMgr timeLineMgr;
    private final ClientComplaintsMgr clientComplaintsMgr;
    private final IssueStatusMgr statusMgr;
    private final SimpleDateFormat formatter;

    /**
     * <p>
     * Empty constructor for job initialization
     * </p>
     * <p>
     * Quartz requires a public empty constructor so that the scheduler can
     * instantiate the class whenever it needs.
     * </p>
     */
    public AutoFinishAllClients() {
        logger = Logger.getLogger(DepartmentClosedClinetComplaintsAutomation.class);
        timeLineMgr = ClientComplaintsTimeLineMgr.getInstance();
        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
        statusMgr = IssueStatusMgr.getInstance();
        formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
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
        
        
     //  case 17 
        WebBusinessObject clientComplaintWBO = new WebBusinessObject();
        WebBusinessObject forChangeStatusWBO =  new WebBusinessObject();
        
       String    notes = "auto closed by system";
       String    statusCode = "6";
        String   object_type = "client_complaint";
        
        
        String currentStatus = "";
               
       clientComplaintsMgr.cashData();
        List<WebBusinessObject> clientList = new ArrayList<>(clientComplaintsMgr.getCashedTable());
        int i = 0;
        Iterator<WebBusinessObject> iterator = clientList.iterator();
		for(i=0;i<clientList.size();i++) {
			clientComplaintWBO = (WebBusinessObject) clientList.get(i);
                        currentStatus = (String) clientComplaintWBO.getAttribute("currentStatus");
                        
           if( !currentStatus.equals("6") && !currentStatus.equals("7")){
                         
               forChangeStatusWBO.setAttribute("parentId", clientComplaintWBO.getAttribute("issueId"));
               forChangeStatusWBO.setAttribute("businessObjectId", clientComplaintWBO.getAttribute("id"));
               forChangeStatusWBO.setAttribute("statusCode", statusCode);
               forChangeStatusWBO.setAttribute("objectType", object_type);
               forChangeStatusWBO.setAttribute("notes", notes);
//                forChangeStatusWBO.setAttribute("date", endDate);
//                forChangeStatusWBO.setAttribute("issueTitle", "UL");
               forChangeStatusWBO.setAttribute("statusNote", notes);
              forChangeStatusWBO.setAttribute("cuseDescription", "UL");
               forChangeStatusWBO.setAttribute("actionTaken", notes);
               forChangeStatusWBO.setAttribute("preventionTaken", "UL");  
                System.out.println(currentStatus);
                try{
               statusMgr.changeStatus(forChangeStatusWBO);
                clientComplaintWBO.printSelf();
                }
                catch (SQLException sqlex){
                    
                    
                }
           }   
        }
              //          clientComplaintWBO.printSelf();
//                        
//                        
//                        statusMgr.
//                        
//                        
//                        i++;
		
//     
//                // for re-finish accepted request for contacting
//                IssueMgr issueMgr  = IssueMgr.getInstance();
//                WebBusinessObject issueWbo = issueMgr.getOnSingleKey(issueId);
//                if (issueWbo != null && "comment_hierarchy".equals(issueWbo.getAttribute("issueType"))) {
//                    complaintWbo = clientComplaintsMgr.getOnSingleKey(clientComplaintId);
//                    if(complaintWbo != null && "7".equals(complaintWbo.getAttribute("currentStatus"))) {
//                        if("34".equals(issueWbo.getAttribute("currentStatus"))) {
//                            try {
//                                issueMgr.updateCurrentStatus(issueId, "36");
//                            } catch (SQLException ex) {
//                                java.util.logging.Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
//                            }
//                        }
//                    }
//                }
//                // end
//                
//                notes = (String) request.getParameter("notes");
//                statusCode = "6";
//                object_type = "client_complaint";
//                endDate = (String) request.getParameter("endDate");
//                wbo = new WebBusinessObject();
//                wbo.setAttribute("parentId", issueId);
//                wbo.setAttribute("businessObjectId", clientComplaintId);
//                wbo.setAttribute("statusCode", statusCode);
//                wbo.setAttribute("objectType", object_type);
//                wbo.setAttribute("notes", notes);
//                wbo.setAttribute("date", endDate);
//                wbo.setAttribute("issueTitle", "UL");
//                wbo.setAttribute("statusNote", notes);
//                wbo.setAttribute("cuseDescription", "UL");
//                wbo.setAttribute("actionTaken", request.getParameter("actionTaken"));
//                wbo.setAttribute("preventionTaken", "UL");
//
//                try {
//                    if (issueStatusMgr.changeStatus(wbo, persistentUser, ActionEvent.getClientComplaintsActionEvent())) {
//                        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
//                        WebBusinessObject clientComplaintsWbo = clientComplaintsMgr.getOnSingleKey(clientComplaintId);
//                        if (loggedUser != null && clientComplaintsWbo != null && clientComplaintsWbo.getAttribute("createdBy") != null) {
//                            WebBusinessObject sourceUserWbo = userMgr.getOnSingleKey((String) clientComplaintsWbo.getAttribute("createdBy"));
//                            WebBusinessObject closeUserWbo = userMgr.getOnSingleKey((String) loggedUser.getAttribute("userId"));
//                            if (metaDataMgr.getSendMail() != null && metaDataMgr.getSendMail().equals("1")
//                                    && sourceUserWbo != null && sourceUserWbo.getAttribute("email") != null
//                                    && closeUserWbo != null && closeUserWbo.getAttribute("fullName") != null) {
//                                String toEmail = (String) sourceUserWbo.getAttribute("email");
//                                String subject = "تم إنهاء الطلب " + clientComplaintsWbo.getAttribute("businessCompID") + " بواسطة " + closeUserWbo.getAttribute("fullName");
//                                try {
//                                    EmailUtility.sendMessage(toEmail, subject, notes);
//                                } catch (Exception ex) {
//                                    java.util.logging.Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
//                                }
//                            }
//                        }
//                        wbo.setAttribute("status", "ok");
//                        changeProductStatus(request.getParameter("actionTaken"), clientComplaintId, issueId, request);
//                    } else {
//                        wbo.setAttribute("status", "error");
//                    }
//                } catch (SQLException ex) {
//                    java.util.logging.Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
//                }
//      
        
        
        
//        JobDataMap data = context.getJobDetail().getJobDataMap();
//        IssueMgr issueMgr = IssueMgr.getInstance();
//        UserMgr userMgr = UserMgr.getInstance();
//        ProjectMgr projectMgr = ProjectMgr.getInstance();
//        ClosureConfigMgr closureConfigMgr = ClosureConfigMgr.getInstance();
//        departmentCode = data.getString("departmentCode");
//        closureInterval = data.getInt("closureInterval");
//        logger.info("--------------------------- Starting Automation Closed For Department " + departmentCode + ", Closure Interval: " + closureInterval + " ---------------------------");
//        List<String> ids = timeLineMgr.getClinetComplaintsIdsToClosed(departmentCode, closureInterval * 60 * 60);
//
//        WebBusinessObject wbo;
//        Calendar calendar = Calendar.getInstance();
//        logger.info(">>>>>>>>>>>>>>>>>>>>>>>> Closed Client Complaints " + ids.size());
//        WebBusinessObject issueWbo, managerWbo, clientComplaintWbo;
//        String actionID = data.getString("actionID") != null ? data.getString("actionID") : "7"; // to financial department action
//        WebBusinessObject actionWbo = closureConfigMgr.getOnSingleKey(actionID);
//        for (String id : ids) {
//
//            wbo = new WebBusinessObject();
//            wbo.setAttribute("statusCode", CRMConstants.CLIENT_COMPLAINT_STATUS_CLOSED);
//            wbo.setAttribute("date", formatter.format(calendar.getTime()));
//            wbo.setAttribute("businessObjectId", id);
//            wbo.setAttribute("statusNote", "Automatically Closed");
//            wbo.setAttribute("objectType", CRMConstants.OBJECT_TYPE_CLIENT_COMPLAINT);
//            wbo.setAttribute("parentId", "UL");
//            wbo.setAttribute("issueTitle", "Automatically Closed");
//            wbo.setAttribute("cuseDescription", "Automatically Closed");
//            wbo.setAttribute("actionTaken", "Automatically Closed");
//            wbo.setAttribute("preventionTaken", "UL");
//            clientComplaintWbo = clientComplaintsMgr.getOnSingleKey(id);
//            if (clientComplaintWbo != null && clientComplaintWbo.getAttribute("issueId") != null) {
//                issueWbo = issueMgr.getOnSingleKey((String) clientComplaintWbo.getAttribute("issueId"));
//                String type = data.getString("type") != null ? data.getString("type") : "Extracting";
//                if (issueWbo != null && issueWbo.getAttribute("issueTitle") != null && issueWbo.getAttribute("issueTitle").equals(type)) {
//                    String managerID = projectMgr.getManagerByDepartment((String) actionWbo.getAttribute("dept_id"));
//                    managerWbo = UserMgr.getInstance().getOnSingleKey(projectMgr.getManagerOfFinancesDepartment());//To be used if there is no assigned finance manager
//                    try {
//                        // To get assigned finance manager to issue's project
//                        IssueProjectMgr issueProjectMgr = IssueProjectMgr.getInstance();
//                        WebBusinessObject issueProject = issueProjectMgr.getOnSingleKey("key1", (String) clientComplaintWbo.getAttribute("issueId"));
//                        if (issueProject != null) {
//                            UserCompanyProjectsMgr companyProjectsMgr = UserCompanyProjectsMgr.getInstance();
//                            TradeMgr tradeMgr = TradeMgr.getInstance();
//                            ArrayList<WebBusinessObject> tradesList = new ArrayList<>(tradeMgr.getOnArbitraryKey("finance", "key2")); //Code for finance
//                            if (!tradesList.isEmpty()) {
//                                String tradeID = (String) tradesList.get(0).getAttribute("tradeId");
//                                ArrayList<WebBusinessObject> companyProjectsList = new ArrayList<>(companyProjectsMgr.getOnArbitraryDoubleKeyOracle(tradeID, "key4", (String) issueProject.getAttribute("projectID"), "key2"));
//                                if (!companyProjectsList.isEmpty()) {
//                                    managerWbo = UserMgr.getInstance().getOnSingleKey((String) companyProjectsList.get(0).getAttribute("userId"));
//                                }
//                            }
//                        }
//                    } catch (SQLException se) {
//                    } catch (Exception ex) {
//                    }
//                    if (managerWbo == null) {
//                        managerWbo = userMgr.getOnSingleKey(managerID);
//                    }
//                    try {
//                        clientComplaintsMgr.tellManager(managerWbo, (String) clientComplaintWbo.getAttribute("issueId"), (String) actionWbo.getAttribute("id"),
//                                (String) actionWbo.getAttribute("comment"), (String) actionWbo.getAttribute("comment"), null);
//                    } catch (NoUserInSessionException | SQLException ex) {
//                        java.util.logging.Logger.getLogger(DepartmentClosedClinetComplaintsAutomation.class.getName()).log(Level.SEVERE, null, ex);
//                    }
//                }
//            }
//

    
        }
    }

