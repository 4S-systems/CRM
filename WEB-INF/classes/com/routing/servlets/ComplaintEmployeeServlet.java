package com.routing.servlets;

import com.clients.db_access.ClientComplaintsMgr;
import com.clients.db_access.ClientMgr;
import com.clients.db_access.ClientProductMgr;
import com.clients.db_access.ReservationMgr;
import com.crm.common.ActionEvent;
import com.crm.common.CRMConstants;
import com.maintenance.common.ClosureConfigMgr;
import com.maintenance.common.Tools;
import com.maintenance.db_access.IssueByComplaintMgr;
import com.maintenance.db_access.TradeMgr;
import com.maintenance.db_access.UserCompanyProjectsMgr;
import com.routing.MailGroupMgr;
import com.routing.db_access.ComplaintEmployeeMgr;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.http.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.common.SecurityUser;
import com.silkworm.common.UserMgr;
import com.silkworm.db_access.PersistentSessionMgr;
import com.silkworm.email.EmailUtility;
import com.silkworm.logger.db_access.LoggerMgr;
import com.silkworm.pagination.FilterCondition;
import com.silkworm.pagination.Operations;
import com.silkworm.servlets.*;
import com.silkworm.util.DateAndTimeControl;
import com.tracker.db_access.IssueMgr;
import com.tracker.db_access.IssueProjectMgr;
import com.tracker.db_access.IssueStatusMgr;
import com.tracker.db_access.ProjectMgr;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Vector;

public class ComplaintEmployeeServlet extends swBaseServlet {

    ProjectMgr projectMgr = ProjectMgr.getInstance();
    WebBusinessObject userObj = null;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws javax.servlet.ServletException
     * @throws java.io.IOException
     */
    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String loggegUserId = (String) loggedUser.getAttribute("userId");
        String remoteAccess = session.getId();
        WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);
        userObj = (WebBusinessObject) session.getAttribute("loggedUser");
        ComplaintEmployeeMgr complaintEmployeeMgr = ComplaintEmployeeMgr.getInstance();
        UserMgr userMgr = UserMgr.getInstance();
        MailGroupMgr mailGroupMgr = MailGroupMgr.getInstance();

        operation = getOpCode((String) request.getParameter("op"));

        switch (operation) {

            case 1:
                servedPage = "docs/routing/attach_employees_to_complaint.jsp";
                ArrayList complaintList = projectMgr.getSubProjectsByCode("cmp");
                request.setAttribute("complaintList", complaintList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 2:
                servedPage = "/docs/routing/unattached_employee_list.jsp";
                com.silkworm.pagination.Filter filter = new com.silkworm.pagination.Filter();
                String selectionType = request.getParameter("selectionType");
                filter = Tools.getPaginationInfo(request, response);
                String complaintId = request.getParameter("complaintId");
                ArrayList<WebBusinessObject> usersList = new ArrayList<WebBusinessObject>(0);

                String fieldName = request.getParameter("fieldName");
                String fieldValue = request.getParameter("fieldValue");

                ArrayList<FilterCondition> conditions = new ArrayList<FilterCondition>();
                conditions.addAll(filter.getConditions());

                // add conditions
                if (fieldValue != null && !fieldValue.equals("")) {
                    fieldValue = Tools.getRealChar((String) fieldValue);
                    conditions.add(new FilterCondition("ce.complaint_id", complaintId, Operations.NOT_EQUAL));
                    conditions.add(new FilterCondition("USER_NAME", fieldValue, Operations.LIKE));
                    filter.setConditions(conditions);
                    try {
                        usersList = (ArrayList) userMgr.paginationEntity(filter, " LEFT OUTER JOIN complaint_employee ce ON user_id = ce.employee_id ");
                    } catch (Exception ex) {
                        Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                } else {

                    //conditions.add(new FilterCondition("ce.id", "", Operations.IS_NULL));
//                    conditions.add(new FilterCondition("ce.complaint_id", complaintId, Operations.NOT_EQUAL));
                    filter.setConditions(conditions);
                    try {
                        usersList = (ArrayList) userMgr.paginationEntityByOR(filter, " LEFT OUTER JOIN complaint_employee ce ON user_id = ce.employee_id ");
                    } catch (Exception ex) {
                        Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                }

                if (selectionType == null) {
                    selectionType = "single";
                }

                String formName = (String) request.getParameter("formName");

                if (formName == null) {
                    formName = "";
                }

                request.setAttribute("complaintId", complaintId);
                request.setAttribute("field_value", fieldValue);
                request.setAttribute("selectionType", selectionType);
                request.setAttribute("filter", filter);
                request.setAttribute("formName", formName);
                request.setAttribute("usersList", usersList);
                this.forward(servedPage, request, response);
                break;

            case 3:
                WebBusinessObject wbo = new WebBusinessObject();
                PrintWriter out = response.getWriter();
                complaintId = request.getParameter("complaintId");
                String empId = request.getParameter("empId");
                String comments = request.getParameter("comments");
                String responsible = request.getParameter("responsible");
                String clientCompId = request.getParameter("clientCompId");
                String complaintComment = request.getParameter("complaintComment");
                String compSubject = request.getParameter("compSubject");
                ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
//                WebBusinessObject clientCompWbo = new WebBusinessObject();
                wbo = (WebBusinessObject) clientComplaintsMgr.getOnSingleKey(clientCompId);

                wbo.setAttribute("complaintId", complaintId);
                wbo.setAttribute("clientCompId", clientCompId);
                wbo.setAttribute("employeeId", empId);
                wbo.setAttribute("notes", comments);
                wbo.setAttribute("responsiblity", responsible);
                wbo.setAttribute("complaintComment", complaintComment);
                wbo.setAttribute("compSubject", compSubject);

//                IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
//                issueStatusMgr.getPublicCurrentStatus();
                try {
                    if (clientComplaintsMgr.saveForwardComplaint(wbo, request, persistentUser)) {
                        wbo.setAttribute("status", "Ok");
                    } else {
                        wbo.setAttribute("status", "No");
                    }
                } catch (NoUserInSessionException ex) {
                    Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (SQLException ex) {
                    Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 4:
                servedPage = "/docs/routing/new_mail_group.jsp";
                ArrayList resp = complaintEmployeeMgr.getResponsibles();
                Vector compEmps = new Vector();
                wbo = new WebBusinessObject();
                userObj = new WebBusinessObject();
                for (int i = 0; i < resp.size(); i++) {
                    wbo = (WebBusinessObject) resp.get(i);
                    userObj = userMgr.getOnSingleKey(wbo.getAttribute("employeeId").toString());
                    wbo.setAttribute("empName", userObj.getAttribute("userName"));
                    compEmps.add(wbo);
                }
                request.setAttribute("compEmps", compEmps);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 5:
                servedPage = "/docs/routing/new_mail_group.jsp";
                wbo = new WebBusinessObject();
                wbo.setAttribute("name", request.getParameter("name"));
                wbo.setAttribute("code", request.getParameter("code"));
                if (request.getParameter("private") == null) {
                    wbo.setAttribute("private", "No");
                } else if (request.getParameter("private").equals("Yes")) {
                    wbo.setAttribute("private", request.getParameter("private"));
                }

//                wbo.setAttribute("compEmps",request.getParameter("compEmps"));
                try {

                    if (mailGroupMgr.saveMailGroup(wbo, session)) {
                        request.setAttribute("status", "ok");
                    } else {
                        request.setAttribute("status", "error");
                    }
                } catch (NoUserInSessionException ex) {
                    Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 6:
                servedPage = "/docs/routing/unattached_cmp_emp_list.jsp";
                filter = new com.silkworm.pagination.Filter();
                selectionType = request.getParameter("selectionType");
                filter = Tools.getPaginationInfo(request, response);

                fieldName = request.getParameter("fieldName");
                fieldValue = request.getParameter("fieldValue");

                conditions = new ArrayList<FilterCondition>();
                conditions.addAll(filter.getConditions());
//                conditions.add(new FilterCondition("CM.RESPONSIBLITY", "", Operations.IS_NOT_NULL));
                if (fieldValue != null && !fieldValue.equals("")) {
                    fieldValue = Tools.getRealChar((String) fieldValue);
                    conditions.add(new FilterCondition("FULL_NAME", fieldValue, Operations.LIKE));
                    filter.setConditions(conditions);
                } else {
                    conditions.add(new FilterCondition("FULL_NAME", "", Operations.LIKE));
                    filter.setConditions(conditions);
                }

                usersList = new ArrayList<WebBusinessObject>(0);
                userMgr = userMgr.getInstance();
//                Vector resps = new Vector();
                // grab usersList list
                try {
                    //, " LEFT JOIN COMPLAINT_EMPLOYEE CM ON USER_ID = CM.EMPLOYEE_ID "
                    usersList = (ArrayList) userMgr.paginationEntity(filter);
                } catch (Exception e) {
                    System.out.println(e);
                }

                if (selectionType == null) {
                    selectionType = "single";
                }

                formName = (String) request.getParameter("formName");

                if (formName == null) {
                    formName = "";
                }

                request.setAttribute("selectionType", selectionType);
                request.setAttribute("filter", filter);
                request.setAttribute("formName", formName);
                request.setAttribute("compEmps", usersList);
                this.forward(servedPage, request, response);
                break;

            case 7:
                wbo = new WebBusinessObject();
                out = response.getWriter();
                String mailGroupId = session.getAttribute("mailGroupId").toString();
                empId = request.getParameter("userId");

                wbo.setAttribute("employeeId", empId);
                wbo.setAttribute("mailGroupId", mailGroupId);
                try {
                    if (complaintEmployeeMgr.updateComplaintEmployee(wbo, session)) {
                        wbo.setAttribute("status", "Ok");

                    } else {
                        wbo.setAttribute("status", "No");
                    }
                } catch (NoUserInSessionException ex) {
                    Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 8:
                servedPage = "/docs/routing/unattached_res_emp_list.jsp";
                filter = new com.silkworm.pagination.Filter();
                selectionType = request.getParameter("selectionType");
                filter = Tools.getPaginationInfo(request, response);

                fieldName = request.getParameter("fieldName");
                fieldValue = request.getParameter("fieldValue");

                conditions = new ArrayList<FilterCondition>();
                conditions.addAll(filter.getConditions());
                conditions.add(new FilterCondition("CM.RESPONSIBLITY", "", Operations.IS_NOT_NULL));

//                conditions.add(new FilterCondition("USER_NAME", "", Operations.LIKE));
                filter.setConditions(conditions);

                WebBusinessObject complaintWbo = new WebBusinessObject();
                usersList = new ArrayList<WebBusinessObject>(0);
                userMgr = userMgr.getInstance();
                Vector resps = new Vector();
                ArrayList objects = new ArrayList();
                // grab usersList list
                try {
                    usersList = (ArrayList) userMgr.paginationEntity(filter, " LEFT JOIN COMPLAINT_EMPLOYEE CM ON USER_ID = CM.EMPLOYEE_ID ");
                    for (int i = 0; i < usersList.size(); i++) {
                        userObj = usersList.get(i);
                        try {
                            resps = complaintEmployeeMgr.getOnArbitraryKey(userObj.getAttribute("userId").toString(), "key2");
                            for (int j = 0; j < resps.size(); j++) {
                                wbo = (WebBusinessObject) resps.get(j);
                                userObj.setAttribute("responsiblity", wbo.getAttribute("responsiblity"));
                                complaintWbo = projectMgr.getOnSingleKey(wbo.getAttribute("complaintId").toString());
                                userObj.setAttribute("complaintName", complaintWbo.getAttribute("projectName"));
                                objects.add(userObj);
                            }
                        } catch (SQLException ex) {
                            Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                } catch (Exception e) {
                    System.out.println(e);
                }

                if (selectionType == null) {
                    selectionType = "single";
                }

                formName = (String) request.getParameter("formName");

                if (formName == null) {
                    formName = "";
                }

                request.setAttribute("selectionType", selectionType);
                request.setAttribute("filter", filter);
                request.setAttribute("formName", formName);
                request.setAttribute("compEmps", objects);
                this.forward(servedPage, request, response);
                break;

            case 9:
                mailGroupMgr = MailGroupMgr.getInstance();
                Vector mailGroups = mailGroupMgr.getCashedTable();
                servedPage = "/docs/routing/mail_group_list.jsp";
                request.setAttribute("data", mailGroups);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 10:
                servedPage = "/docs/routing/view_mail_group.jsp";
                mailGroupId = request.getParameter("id");
                mailGroupMgr = MailGroupMgr.getInstance();
                wbo = mailGroupMgr.getOnSingleKey(mailGroupId);
                request.setAttribute("mailGroupWbo", wbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 11:
                complaintEmployeeMgr = ComplaintEmployeeMgr.getInstance();
                mailGroupId = request.getParameter("id");
                Vector mailGroupMembers = new Vector();
                Vector members = new Vector();

                try {
                    mailGroupMembers = complaintEmployeeMgr.getOnArbitraryKey(mailGroupId, "key3");
                    for (int i = 0; i < mailGroupMembers.size(); i++) {
                        complaintWbo = (WebBusinessObject) mailGroupMembers.get(i);
                        userObj = userMgr.getOnSingleKey(complaintWbo.getAttribute("employeeId").toString());
                        complaintWbo.setAttribute("memberName", userObj.getAttribute("fullName"));
                        wbo = projectMgr.getOnSingleKey(complaintWbo.getAttribute("complaintId").toString());
                        complaintWbo.setAttribute("projectName", wbo.getAttribute("projectName"));
                        members.add(complaintWbo);
                    }
                } catch (SQLException ex) {
                    Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                servedPage = "/docs/routing/mail_group_members_list.jsp";
                request.setAttribute("data", members);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 12:
                servedPage = "/docs/routing/unattached_employee_list.jsp";
                filter = new com.silkworm.pagination.Filter();
                selectionType = request.getParameter("selectionType");
                filter = Tools.getPaginationInfo(request, response);
//                complaintId = request.getParameter("complaintId");
                usersList = new ArrayList<WebBusinessObject>(0);

                fieldName = request.getParameter("fieldName");
                if (fieldName != null) {
                    if (!fieldName.equalsIgnoreCase("user_name")) {
                        fieldName = "user_name";
                    }
                }
                fieldValue = request.getParameter("fieldValue");

                conditions = new ArrayList<FilterCondition>();
                // conditions.addAll(filter.getConditions());

                // add conditions
                if (fieldValue != null && !fieldValue.equals("")) {
                    fieldValue = Tools.getRealChar((String) fieldValue);
                    conditions.add(new FilterCondition("USER_NAME", fieldValue, Operations.LIKE));
                }
                conditions.add(new FilterCondition("user_type", "1", Operations.NOT_EQUAL));
                filter.setConditions(conditions);
                try {
                    usersList = (ArrayList) userMgr.paginationEntity(filter, "");
                } catch (Exception ex) {
                    Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                if (selectionType == null) {
                    selectionType = "single";
                }

                formName = (String) request.getParameter("formName");

                if (formName == null) {
                    formName = "";
                }

//                request.setAttribute("complaintId", complaintId);
                request.setAttribute("field_value", fieldValue);
                request.setAttribute("selectionType", selectionType);
                request.setAttribute("filter", filter);
                request.setAttribute("formName", formName);
                request.setAttribute("usersList", usersList);
                this.forward(servedPage, request, response);
                break;
            case 13:

                IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
                HttpSession s = request.getSession();
                String issueId = request.getParameter("issueId");
                String clientComplaintId = request.getParameter("compId");
                String notes = (String) request.getParameter("notes");
                String endDate = (String) request.getParameter("endDate");
                String statusCode = "7";
                String object_type = "client_complaint";

                wbo = new WebBusinessObject();
                wbo.setAttribute("parentId", issueId);
                wbo.setAttribute("businessObjectId", clientComplaintId);
                wbo.setAttribute("statusCode", statusCode);
                wbo.setAttribute("objectType", object_type);
                wbo.setAttribute("notes", notes);
                wbo.setAttribute("date", endDate);
                wbo.setAttribute("issueTitle", "UL");
                wbo.setAttribute("statusNote", notes);
                wbo.setAttribute("cuseDescription", "UL");
                wbo.setAttribute("actionTaken", request.getParameter("actionTaken"));
                wbo.setAttribute("preventionTaken", "UL");

                try {
                    if (issueStatusMgr.changeStatus(wbo, persistentUser, ActionEvent.getClientComplaintsActionEvent())) {

                        // try create new complaints
                        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                        
                        WebBusinessObject complaint = clientComplaintsMgr.getOnSingleKey(clientComplaintId);
                        String ticketType = (String) complaint.getAttribute("ticketType");
                        boolean isCreated = false;
                        if (ticketType != null) {
                            if (ticketType.equalsIgnoreCase(CRMConstants.CLIENT_COMPLAINT_TYPE_EXTRACT)) {
                                WebBusinessObject managerOfFinances = UserMgr.getInstance().getOnSingleKey(projectMgr.getManagerOfFinancesDepartment());//To be used if there is no assigned finance manager
                                // To get assigned finance manager to issue's project
                                IssueProjectMgr issueProjectMgr = IssueProjectMgr.getInstance();
                                WebBusinessObject issueProject = issueProjectMgr.getOnSingleKey("key1", issueId);
                                if(issueProject != null) {
                                    UserCompanyProjectsMgr companyProjectsMgr = UserCompanyProjectsMgr.getInstance();
                                    TradeMgr tradeMgr = TradeMgr.getInstance();
                                    ArrayList<WebBusinessObject> tradesList = new ArrayList<>(tradeMgr.getOnArbitraryKey("finance", "key2")); //Code for finance
                                    if (!tradesList.isEmpty()) {
                                        String tradeID = (String) tradesList.get(0).getAttribute("tradeId");
                                        ArrayList<WebBusinessObject> companyProjectsList = new ArrayList<>(companyProjectsMgr.getOnArbitraryDoubleKeyOracle(tradeID, "key4", (String) issueProject.getAttribute("projectID"), "key2"));
                                        if(!companyProjectsList.isEmpty()) {
                                            managerOfFinances = UserMgr.getInstance().getOnSingleKey((String) companyProjectsList.get(0).getAttribute("userId"));
                                        }
                                    }
                                }
                                try {
                                    if (managerOfFinances != null) {
                                        clientComplaintsMgr.tellManager(managerOfFinances, issueId, CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_FINANCIAL, request.getParameter("subject"), request.getParameter("comment"), persistentUser);
                                        isCreated = true;
                                    }
                                } catch (NoUserInSessionException | SQLException ex) {
                                    logger.error(ex);
                                }
                            }
                        }
                        
                        
                        ClosureConfigMgr closureConfigMgr = ClosureConfigMgr.getInstance();
                        WebBusinessObject actionWbo = closureConfigMgr.getOnSingleKey(request.getParameter("actionTaken"));
                        if(actionWbo != null) {
                            String managerID = projectMgr.getManagerByDepartment((String) actionWbo.getAttribute("dept_id"));
                            if(managerID != null && !isCreated) {
                                WebBusinessObject managerWbo = userMgr.getOnSingleKey(managerID);
                                clientComplaintsMgr.tellManager(managerWbo, issueId, (String) actionWbo.getAttribute("id"),
                                        (String) actionWbo.getAttribute("comment"), (String) actionWbo.getAttribute("comment"), persistentUser);
                            }
                        }
//                            if (ticketType.toString().equalsIgnoreCase(CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_EXTRADITION)) {
//                                WebBusinessObject managerOfQualityManagement = UserMgr.getInstance().getOnSingleKey(projectMgr.getManagerOfQualityManagementDepartment());
//                                boolean isIssueAccepted = issueStatusMgr.isStatusExist(issueId, CRMConstants.OBJECT_TYPE_ISSUE, CRMConstants.ISSUE_STATUS_ACCEPTED);
//                                try {
//                                    if (isIssueAccepted && managerOfQualityManagement != null) {
//                                        clientComplaintsMgr.tellManager(managerOfQualityManagement, issueId, CRMConstants.CLIENT_COMPLAINT_TYPE_DELIVERY_OF_QUALITY, request.getParameter("qualitySubject"), request.getParameter("qualityComment"), persistentUser);
//                                    }
//                                } catch (NoUserInSessionException ex) {
//                                    logger.error(ex);
//                                } catch (SQLException ex) {
//                                    logger.error(ex);
//                                }
//                            }
//                        }
                        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
                        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                        WebBusinessObject clientComplaintsWbo = clientComplaintsMgr.getOnSingleKey(clientComplaintId);
                        if (loggedUser != null && clientComplaintsWbo != null && clientComplaintsWbo.getAttribute("createdBy") != null) {
                            WebBusinessObject sourceUserWbo = userMgr.getOnSingleKey((String) clientComplaintsWbo.getAttribute("createdBy"));
                            WebBusinessObject finishUserWbo = userMgr.getOnSingleKey((String) loggedUser.getAttribute("userId"));
                            if (metaDataMgr.getSendMail() != null && metaDataMgr.getSendMail().equals("1")
                                    && sourceUserWbo != null && sourceUserWbo.getAttribute("email") != null
                                    && finishUserWbo != null && finishUserWbo.getAttribute("fullName") != null) {
                                String toEmail = (String) sourceUserWbo.getAttribute("email");
                                String subject = "تم أغلاق الطلب " + clientComplaintsWbo.getAttribute("businessCompID") + " بواسطة " + finishUserWbo.getAttribute("fullName");
                                try {
                                    EmailUtility.sendMessage(toEmail, subject, notes);
                                } catch (Exception ex) {
                                    Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                                }
                            }
                        }
//                        if (MetaDataMgr.getInstance().getSendMail() != null && MetaDataMgr.getInstance().getSendMail().equalsIgnoreCase("1")) {
//                            // generate ticket report and send its by email
//                            Tools.createClientComplaintWithCommentsPdfReport(response, request, true);
//                        }
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "error");
                    }
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 14:
                out = response.getWriter();
                issueStatusMgr = IssueStatusMgr.getInstance();
                String selectedId = request.getParameter("selectedId");
                notes = "cancel selected complaint";
                String[] ids = selectedId.split("/");
                WebBusinessObject result = new WebBusinessObject();

                issueStatusMgr = IssueStatusMgr.getInstance();
                s = request.getSession();

                notes = (String) request.getParameter("note");
                endDate = (String) request.getParameter("endDate");
                statusCode = "7";
                object_type = "client_complaint";
                for (int i = 0; i < ids.length; i++) {
                    String value = ids[i];
                    String[] xx = value.split(",");
                    try {
                        clientComplaintId = xx[0];
                        issueId = xx[1];
                        wbo = new WebBusinessObject();
                        wbo.setAttribute("parentId", issueId);
                        wbo.setAttribute("businessObjectId", clientComplaintId);
                        wbo.setAttribute("statusCode", statusCode);
                        wbo.setAttribute("objectType", object_type);
                        wbo.setAttribute("notes", notes);
                        wbo.setAttribute("date", endDate);
                        wbo.setAttribute("issueTitle", "UL");
                        wbo.setAttribute("statusNote", "UL");
                        wbo.setAttribute("cuseDescription", "UL");
                        wbo.setAttribute("actionTaken", "UL");
                        wbo.setAttribute("preventionTaken", "UL");
                        if (issueStatusMgr.changeStatus(wbo, persistentUser, ActionEvent.getClientComplaintsActionEvent())) {
                            result.setAttribute("status", "ok");
                        } else {
                            result.setAttribute("status", "error");
                            break;
                        }
                    } catch (Exception ex) {
                        result.setAttribute("status", "error");
                        Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                        break;
                    }
                }

                out.write(Tools.getJSONObjectAsString(result));
                break;
            case 15:
                servedPage = "/docs/routing/unattached_employee_list2.jsp";
                filter = new com.silkworm.pagination.Filter();
                selectionType = request.getParameter("selectionType");
                filter = Tools.getPaginationInfo(request, response);
                String clientId;
                complaintId = request.getParameter("complaintId");
                issueId = request.getParameter("issueId");
                clientId = request.getParameter("clientId");
                usersList = new ArrayList<WebBusinessObject>(0);

                fieldName = request.getParameter("fieldName");
                fieldValue = request.getParameter("fieldValue");

                conditions = new ArrayList<FilterCondition>();
                conditions.addAll(filter.getConditions());

                // add conditions
                if (fieldValue != null && !fieldValue.equals("")) {
                    fieldValue = Tools.getRealChar((String) fieldValue);
                    conditions.add(new FilterCondition("ce.complaint_id", complaintId, Operations.NOT_EQUAL));
                    conditions.add(new FilterCondition("USER_NAME", fieldValue, Operations.LIKE));
                    filter.setConditions(conditions);
                    try {
                        usersList = (ArrayList) userMgr.paginationEntity(filter, " LEFT OUTER JOIN complaint_employee ce ON user_id = ce.employee_id ");
                    } catch (Exception ex) {
                        Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                } else {

                    //conditions.add(new FilterCondition("ce.id", "", Operations.IS_NULL));
//                    conditions.add(new FilterCondition("ce.complaint_id", complaintId, Operations.NOT_EQUAL));
                    filter.setConditions(conditions);
                    try {
                        usersList = (ArrayList) userMgr.paginationEntityByOR(filter, " LEFT OUTER JOIN complaint_employee ce ON user_id = ce.employee_id ");
                    } catch (Exception ex) {
                        Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                }

                if (selectionType == null) {
                    selectionType = "single";
                }

                formName = (String) request.getParameter("formName");

                if (formName == null) {
                    formName = "";
                }

                request.setAttribute("complaintId", complaintId);
                request.setAttribute("issueId", issueId);
                request.setAttribute("clientId", clientId);
                request.setAttribute("field_value", fieldValue);
                request.setAttribute("selectionType", selectionType);
                request.setAttribute("filter", filter);
                request.setAttribute("formName", formName);
                request.setAttribute("usersList", usersList);
                this.forward(servedPage, request, response);
                break;
            case 16:
                wbo = new WebBusinessObject();
                out = response.getWriter();

                empId = request.getParameter("empId");

                clientCompId = request.getParameter("complaintId");

                ClientComplaintsMgr clientComplaintsMgr2 = ClientComplaintsMgr.getInstance();
                wbo = (WebBusinessObject) clientComplaintsMgr2.getOnSingleKey(clientCompId);
                wbo.setAttribute("clientCompId", clientCompId);
                wbo.setAttribute("employeeId", empId);
                wbo.setAttribute("complaintComment", "عميل جديد");
                wbo.setAttribute("compSubject", "عميل جديد");
                String responsability = "1";
                try {
                    if (clientComplaintsMgr2.distibutionResponsibility(empId, responsability, wbo, request, persistentUser)) {
                        wbo.setAttribute("status", "Ok");
                    } else {
                        wbo.setAttribute("status", "No");
                    }
                } catch (NoUserInSessionException ex) {
                    Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (SQLException ex) {
                    Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

//                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 17:

//                servedPage = "/docs/call_center/viewComp.jsp";
                issueStatusMgr = IssueStatusMgr.getInstance();
                s = request.getSession();
                issueId = request.getParameter("issueId");
                clientComplaintId = request.getParameter("compId");
                clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                // for re-finish accepted request for contacting
                IssueMgr issueMgr  = IssueMgr.getInstance();
                WebBusinessObject issueWbo = issueMgr.getOnSingleKey(issueId);
                if (issueWbo != null && "comment_hierarchy".equals(issueWbo.getAttribute("issueType"))) {
                    complaintWbo = clientComplaintsMgr.getOnSingleKey(clientComplaintId);
                    if(complaintWbo != null && "7".equals(complaintWbo.getAttribute("currentStatus"))) {
                        if("34".equals(issueWbo.getAttribute("currentStatus"))) {
                            try {
                                issueMgr.updateCurrentStatus(issueId, "36");
                            } catch (SQLException ex) {
                                Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                            }
                        }
                    }
                }
                // end
                
                notes = (String) request.getParameter("notes");
                statusCode = "6";
                object_type = "client_complaint";
                endDate = (String) request.getParameter("endDate");
                wbo = new WebBusinessObject();
                wbo.setAttribute("parentId", issueId);
                wbo.setAttribute("businessObjectId", clientComplaintId);
                wbo.setAttribute("statusCode", statusCode);
                wbo.setAttribute("objectType", object_type);
                wbo.setAttribute("notes", notes);
                wbo.setAttribute("date", endDate);
                wbo.setAttribute("issueTitle", "UL");
                wbo.setAttribute("statusNote", notes);
                wbo.setAttribute("cuseDescription", "UL");
                wbo.setAttribute("actionTaken", request.getParameter("actionTaken"));
                wbo.setAttribute("preventionTaken", "UL");

                try {
                    if (issueStatusMgr.changeStatus(wbo, persistentUser, ActionEvent.getClientComplaintsActionEvent())) {
                        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
                        WebBusinessObject clientComplaintsWbo = clientComplaintsMgr.getOnSingleKey(clientComplaintId);
                        if (loggedUser != null && clientComplaintsWbo != null && clientComplaintsWbo.getAttribute("createdBy") != null) {
                            WebBusinessObject sourceUserWbo = userMgr.getOnSingleKey((String) clientComplaintsWbo.getAttribute("createdBy"));
                            WebBusinessObject closeUserWbo = userMgr.getOnSingleKey((String) loggedUser.getAttribute("userId"));
                            if (metaDataMgr.getSendMail() != null && metaDataMgr.getSendMail().equals("1")
                                    && sourceUserWbo != null && sourceUserWbo.getAttribute("email") != null
                                    && closeUserWbo != null && closeUserWbo.getAttribute("fullName") != null) {
                                String toEmail = (String) sourceUserWbo.getAttribute("email");
                                String subject = "تم إنهاء الطلب " + clientComplaintsWbo.getAttribute("businessCompID") + " بواسطة " + closeUserWbo.getAttribute("fullName");
                                try {
                                    EmailUtility.sendMessage(toEmail, subject, notes);
                                } catch (Exception ex) {
                                    Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                                }
                            }
                        }
                        wbo.setAttribute("status", "ok");
                        changeProductStatus(request.getParameter("actionTaken"), clientComplaintId, issueId, request);
                    } else {
                        wbo.setAttribute("status", "error");
                    }
                } catch (SQLException ex) {
                    Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));

                break;
            case 18:
                out = response.getWriter();
                issueStatusMgr = IssueStatusMgr.getInstance();
                selectedId = request.getParameter("selectedId");
                notes = "delete complaint for assistant";
                ids = selectedId.split(",");
                clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                result = new WebBusinessObject();

                for (int i = 0; i < ids.length; i++) {
                    wbo = clientComplaintsMgr.getOnSingleKey(ids[i]);
                    try {
                        if (issueStatusMgr.deleteComp(ids[i])) {
                            result.setAttribute("status", "ok");
                        } else {
                            result.setAttribute("status", "error");
                        }
                    } catch (Exception ex) {
                        Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }

                out.write(Tools.getJSONObjectAsString(result));
                break;
            case 19:
                out = response.getWriter();
                issueStatusMgr = IssueStatusMgr.getInstance();
                selectedId = request.getParameter("selectedId");
                notes = "close selected complaint";
//                String ids2[] = new String[0];
                ids = selectedId.split(",");
//                if (selectedId.contains("undefined")) {
//                    int len = ids.length - 1;
//                    ids2 = new String[len];
//                    System.arraycopy(ids, 1, ids2, 0, len);
//                } else {

//                ids2 = ids;
//                }
                clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                result = new WebBusinessObject();

                for (int i = 0; i < ids.length; i++) {
                    wbo = clientComplaintsMgr.getOnSingleKey(ids[i]);
                    try {
                        if (issueStatusMgr.closeSelectedComp(ids[i])) {
                            result.setAttribute("status", "ok");
                        } else {
//                            result.setAttribute("status", "error");
                        }
                    } catch (Exception ex) {
                        Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }

                out.write(Tools.getJSONObjectAsString(result));
                break;
            case 20:
                out = response.getWriter();
                issueStatusMgr = IssueStatusMgr.getInstance();
                selectedId = request.getParameter("selectedId");
                notes = "close selected complaint";
                ids = selectedId.split("/");
                clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                result = new WebBusinessObject();

                issueStatusMgr = IssueStatusMgr.getInstance();
                s = request.getSession();

                notes = (String) request.getParameter("note");
                statusCode = "7";
                object_type = "client_complaint";
                for (int i = 0; i < ids.length; i++) {
                    String value = ids[i];
                    String[] xx = value.split(",");
                    try {
                        clientComplaintId = xx[0];
                        issueId = xx[1];

                        wbo = new WebBusinessObject();
                        wbo.setAttribute("parentId", issueId);
                        wbo.setAttribute("businessObjectId", clientComplaintId);
                        wbo.setAttribute("statusCode", statusCode);
                        wbo.setAttribute("objectType", object_type);
                        wbo.setAttribute("notes", notes);
                        wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                        wbo.setAttribute("issueTitle", "UL");
                        wbo.setAttribute("statusNote", "UL");
                        wbo.setAttribute("cuseDescription", "UL");
                        wbo.setAttribute("actionTaken", "UL");
                        wbo.setAttribute("preventionTaken", "UL");

                        if (issueStatusMgr.changeStatus(wbo, persistentUser, ActionEvent.getClientComplaintsActionEvent())) {
                            result.setAttribute("status", "ok");
                        } else {
                            result.setAttribute("status", "error");
                            break;
                        }
                    } catch (Exception ex) {
                        result.setAttribute("status", "error");
                        Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                        break;
                    }
                }

                out.write(Tools.getJSONObjectAsString(result));
                break;
            case 21:
                servedPage = "/docs/routing/unattached_employee_list2.jsp";
                filter = new com.silkworm.pagination.Filter();
                selectionType = request.getParameter("selectionType");
                filter = Tools.getPaginationInfo(request, response);
                complaintId = request.getParameter("complaintId");
                usersList = new ArrayList<WebBusinessObject>(0);

                fieldName = request.getParameter("fieldName");
                fieldValue = request.getParameter("fieldValue");

                conditions = new ArrayList<FilterCondition>();
                conditions.addAll(filter.getConditions());

                // add conditions
                if (fieldValue != null && !fieldValue.equals("")) {
                    fieldValue = Tools.getRealChar((String) fieldValue);
                    conditions.add(new FilterCondition("ce.complaint_id", complaintId, Operations.NOT_EQUAL));
                    conditions.add(new FilterCondition("USER_NAME", fieldValue, Operations.LIKE));
                    filter.setConditions(conditions);
                    try {
                        usersList = (ArrayList) userMgr.paginationEntity(filter, " LEFT OUTER JOIN complaint_employee ce ON user_id = ce.employee_id ");
                    } catch (Exception ex) {
                        Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                } else {

                    //conditions.add(new FilterCondition("ce.id", "", Operations.IS_NULL));
//                    conditions.add(new FilterCondition("ce.complaint_id", complaintId, Operations.NOT_EQUAL));
                    filter.setConditions(conditions);
                    try {
                        usersList = (ArrayList) userMgr.paginationEntityByOR(filter, " LEFT OUTER JOIN complaint_employee ce ON user_id = ce.employee_id ");
                    } catch (Exception ex) {
                        Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                }

                if (selectionType == null) {
                    selectionType = "single";
                }

                formName = (String) request.getParameter("formName");

                if (formName == null) {
                    formName = "";
                }

                request.setAttribute("complaintId", complaintId);
                request.setAttribute("field_value", fieldValue);
                request.setAttribute("selectionType", selectionType);
                request.setAttribute("filter", filter);
                request.setAttribute("formName", formName);
                request.setAttribute("usersList", usersList);
                this.forward(servedPage, request, response);
                break;
            case 22:
                wbo = new WebBusinessObject();
                out = response.getWriter();
//                complaintId = request.getParameter("complaintId");
                empId = request.getParameter("empId");
                comments = request.getParameter("comments");
                responsible = request.getParameter("responsible");
//                clientCompId = request.getParameter("clientCompId");
//                complaintComment = request.getParameter("complaintComment");
//                compSubject = request.getParameter("compSubject");
                selectedId = request.getParameter("selectedId");
                clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();

                ids = selectedId.split("/");
                Vector<WebBusinessObject> clientCompVector = new Vector();
                result = new WebBusinessObject();
                WebBusinessObject wbo2 = new WebBusinessObject();
                for (int i = 0; i < ids.length; i++) {
                    String value = ids[i];
                    String[] xx = value.split(",");

                    clientComplaintId = xx[0];
                    issueId = xx[1];
                    wbo = new WebBusinessObject();
                    clientCompVector = new Vector();
                    wbo2 = new WebBusinessObject();
                    try {
                        clientCompVector = issueByComplaintMgr.getOnArbitraryKey(clientComplaintId, "key5");
                        wbo2 = clientCompVector.get(0);
                    } catch (SQLException ex) {
                        Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (Exception ex) {
                        Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    wbo = (WebBusinessObject) clientComplaintsMgr.getOnSingleKey(clientComplaintId);
//
//                wbo.setAttribute("complaintId", complaintId);
                    wbo.setAttribute("clientCompId", clientComplaintId);
                    wbo.setAttribute("employeeId", empId);
                    wbo.setAttribute("notes", comments);
                    wbo.setAttribute("responsiblity", responsible);
                    if (wbo2 != null) {
                        complaintComment = (String) wbo2.getAttribute("comments");
                        wbo.setAttribute("complaintComment", complaintComment);

                        compSubject = (String) wbo2.getAttribute("compSubject");
                        wbo.setAttribute("compSubject", compSubject);
                    }
//                IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
//                issueStatusMgr.getPublicCurrentStatus();
                    try {
                        if (clientComplaintsMgr.saveForwardComplaint(wbo, request, persistentUser)) {
                            wbo.setAttribute("status", "Ok");
                        } else {
                            wbo.setAttribute("status", "No");
                            break;
                        }
                    } catch (NoUserInSessionException ex) {
                        Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (SQLException ex) {
                        Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 23:
                out = response.getWriter();
                issueStatusMgr = IssueStatusMgr.getInstance();
                selectedId = request.getParameter("selectedId");
                notes = "cancel selected complaint";
                ids = selectedId.split("/");
                clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                result = new WebBusinessObject();

                issueStatusMgr = IssueStatusMgr.getInstance();
                s = request.getSession();

                notes = (String) request.getParameter("note");
                statusCode = "5";//REJECTED 
                object_type = "client_complaint";
                for (int i = 0; i < ids.length; i++) {
                    String value = ids[i];
                    String[] xx = value.split(",");
                    try {
                        clientComplaintId = xx[0];
                        issueId = xx[1];
                        wbo = new WebBusinessObject();
                        wbo.setAttribute("parentId", issueId);
                        wbo.setAttribute("businessObjectId", clientComplaintId);
                        wbo.setAttribute("statusCode", statusCode);
                        wbo.setAttribute("objectType", object_type);
                        wbo.setAttribute("notes", notes);
                        wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                        wbo.setAttribute("issueTitle", "UL");
                        wbo.setAttribute("statusNote", "UL");
                        wbo.setAttribute("cuseDescription", "UL");
                        wbo.setAttribute("actionTaken", "UL");
                        wbo.setAttribute("preventionTaken", "UL");

                        if (issueStatusMgr.changeStatus(wbo, persistentUser, ActionEvent.getClientComplaintsActionEvent())) {
                            result.setAttribute("status", "ok");
                        } else {
                            result.setAttribute("status", "error");
                            break;
                        }
                    } catch (Exception ex) {
                        result.setAttribute("status", "error");
                        Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                        break;
                    }
                }

                out.write(Tools.getJSONObjectAsString(result));
                break;
            case 24:
                out = response.getWriter();
                issueStatusMgr = IssueStatusMgr.getInstance();
                selectedId = request.getParameter("selectedId");
                notes = "close selected complaint";
                ids = selectedId.split("/");
                clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                result = new WebBusinessObject();

                issueStatusMgr = IssueStatusMgr.getInstance();
                s = request.getSession();

                notes = (String) request.getParameter("note");
                statusCode = "6";//CANCELED
                object_type = "client_complaint";
                for (int i = 0; i < ids.length; i++) {
                    String value = ids[i];
                    String[] xx = value.split(",");
                    try {
                        clientComplaintId = xx[0];
                        issueId = xx[1];
                        wbo = new WebBusinessObject();
                        wbo.setAttribute("parentId", issueId);
                        wbo.setAttribute("businessObjectId", clientComplaintId);
                        wbo.setAttribute("statusCode", statusCode);
                        wbo.setAttribute("objectType", object_type);
                        wbo.setAttribute("notes", notes);
                        wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                        wbo.setAttribute("issueTitle", "UL");
                        wbo.setAttribute("statusNote", "UL");
                        wbo.setAttribute("cuseDescription", "UL");
                        wbo.setAttribute("actionTaken", "UL");
                        wbo.setAttribute("preventionTaken", "UL");

                        if (issueStatusMgr.changeStatus(wbo, persistentUser, ActionEvent.getClientComplaintsActionEvent())) {
                            result.setAttribute("status", "ok");
                        } else {
                            result.setAttribute("status", "error");
                            break;
                        }
                    } catch (Exception ex) {
                        result.setAttribute("status", "error");
                        Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                        break;
                    }
                }

                out.write(Tools.getJSONObjectAsString(result));
                break;
            case 25:

                servedPage = "/docs/call_center/viewComp.jsp";
                issueStatusMgr = IssueStatusMgr.getInstance();
                s = request.getSession();
                issueId = request.getParameter("issueId");
                clientComplaintId = request.getParameter("compId");
                notes = (String) request.getParameter("employee open this ticket");
                statusCode = "3";
                object_type = "client_complaint";
                wbo = new WebBusinessObject();
                wbo.setAttribute("parentId", issueId);
                wbo.setAttribute("businessObjectId", clientComplaintId);
                wbo.setAttribute("statusCode", statusCode);
                wbo.setAttribute("objectType", object_type);
                wbo.setAttribute("notes", notes);
                wbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                wbo.setAttribute("issueTitle", "UL");
                wbo.setAttribute("statusNote", "UL");
                wbo.setAttribute("cuseDescription", "UL");
                wbo.setAttribute("actionTaken", "UL");
                wbo.setAttribute("preventionTaken", "UL");
                try {
                    if (issueStatusMgr.changeStatus(wbo, persistentUser, ActionEvent.getClientComplaintsActionEvent())) {
                        request.setAttribute("status", "ok");
                    } else {
                        request.setAttribute("status", "error");
                    }
                } catch (Exception ex) {
                    Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
//                this.forwardToServedPage(request, response);
                break;
            case 26:
                out = response.getWriter();
                issueStatusMgr = IssueStatusMgr.getInstance();
                issueId = request.getParameter("issueId");
                clientComplaintId = request.getParameter("compId");
                issueStatusMgr = IssueStatusMgr.getInstance();
                String cMode = (String) request.getSession().getAttribute("currentMode");
                String stat = cMode;

                //status type 2
                boolean isAcknowledge = false;
                boolean isFinish = false;
                boolean isClosed = false;
                boolean isAssigned = false;
                boolean isRequest = false;
                boolean isRejected = false;

                String x;
                String ticketAge = "";
                // number refer to status type
                String begin2Date = null,
                 end2Date = null,
                 begin3Date = null,
                 end3Date = null,
                 begin4Date = null,
                 end4Date = null,
                 begin5Date = null,
                 end5Date = null,
                 begin6Date = null,
                 end6Date = null,
                 begin7Date = null,
                 end7Date = null,
                 requestDate = "",
                 assignDate = "",
                 acknowledgeDate = "",
                 finishDate = "",
                 closeDate = "",
                 openDate = "",
                 rejectedDate = "",
                 period = "";
                wbo = new WebBusinessObject();
                Vector issueDetails = new Vector();
                try {
                    issueDetails = issueStatusMgr.getOnArbitraryKey(clientComplaintId, "key1");
                    clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                    wbo = new WebBusinessObject();

                } catch (SQLException ex) {
                    Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                if (issueDetails != null & !issueDetails.isEmpty()) {
                    for (int i = 0; i < issueDetails.size(); i++) {
                        wbo = new WebBusinessObject();
                        wbo = (WebBusinessObject) issueDetails.get(i);
                        statusCode = (String) wbo.getAttribute("statusName");
                        if (statusCode.equals("2")) {
                            wbo = new WebBusinessObject();
                            wbo = issueStatusMgr.getCompByStatusCode(clientComplaintId, statusCode);
                            if (wbo != null) {
                                isRequest = true;
                                begin2Date = (String) wbo.getAttribute("beginDate");
                                requestDate = begin2Date;
                                end2Date = (String) wbo.getAttribute("endDate");

                            }
                        } else if (statusCode.equals("3")) {
                            wbo = new WebBusinessObject();

                            wbo = issueStatusMgr.getCompByStatusCode(clientComplaintId, statusCode);
                            if (wbo != null) {
                                isAcknowledge = true;
                                begin3Date = (String) wbo.getAttribute("beginDate");
                                end3Date = (String) wbo.getAttribute("endDate");
                                openDate = begin3Date;

                            }
                        } else if (statusCode.equals("4")) {
                            wbo = new WebBusinessObject();
                            wbo = issueStatusMgr.getCompByStatusCode(clientComplaintId, statusCode);
                            if (wbo != null) {
                                isAssigned = true;
                                begin4Date = (String) wbo.getAttribute("beginDate");

                                assignDate = begin4Date;
                                end4Date = (String) wbo.getAttribute("endDate");

                            }
                        } else if (statusCode.equals("6")) {
                            wbo = new WebBusinessObject();

                            wbo = issueStatusMgr.getCompByStatusCode(clientComplaintId, statusCode);
                            if (wbo != null) {

                                begin6Date = (String) wbo.getAttribute("beginDate");
                                end6Date = (String) wbo.getAttribute("endDate");

                                if (begin6Date != null & end6Date != null) {
                                    isFinish = true;

                                    finishDate = end6Date;
                                }
                            }
                        } else if (statusCode.equals("7")) {
                            wbo = new WebBusinessObject();
                            wbo = issueStatusMgr.getCompByStatusCode(clientComplaintId, statusCode);
                            if (wbo != null) {

                                begin7Date = (String) wbo.getAttribute("beginDate");
                                end7Date = (String) wbo.getAttribute("endDate");
                                if (begin7Date != null & end7Date != null) {
                                    isClosed = true;

                                    closeDate = end7Date;
                                }
                            }
                        } else if (statusCode.equals("5")) {
                            wbo = new WebBusinessObject();
                            wbo = issueStatusMgr.getCompByStatusCode(clientComplaintId, statusCode);
                            if (wbo != null) {

                                begin5Date = (String) wbo.getAttribute("beginDate");
                                end5Date = (String) wbo.getAttribute("endDate");
                                if (begin5Date != null & end5Date != null) {
                                    isRejected = true;

                                    rejectedDate = end5Date;
                                }
                            }
                        }
                    }
                }

                String closedPeriod = "",
                 finishPeriod = "",
                 openPeriod = "",
                 assignPeriod = "",
                 rejectedPeriod = "",
                 totalTime = "";
                boolean isFound = false;
                ///////////// calculate closed period
                if (isRequest & isClosed & !isAssigned & isFinish) {
                    closedPeriod = DateAndTimeControl.getDelayTime2(finishDate, closeDate, "En");

                } else if (isRequest & isClosed & isAssigned & isFinish & !isAcknowledge) {
                    closedPeriod = DateAndTimeControl.getDelayTime2(finishDate, closeDate, "En");
                } else if (isRequest & isClosed & isAssigned & isFinish & isAcknowledge) {
                    closedPeriod = DateAndTimeControl.getDelayTime2(finishDate, closeDate, "En");
                }
//                else if (isClosed & !isFinish) {
//                    closedPeriod = DateAndTimeControl.getDelayTime2(requestDate, closeDate, "En");
//                }

                ///////////////// calculate finish period
                if (isRequest & isFinish & !isAssigned) {
                    finishPeriod = DateAndTimeControl.getDelayTime2(begin2Date, end6Date, "En");
                } else if (isRequest & isAssigned & isAcknowledge & isFinish) {
                    finishPeriod = DateAndTimeControl.getDelayTime2(begin3Date, end6Date, "En");
                }

                ///////////////// calculate rejected period
                if (isRequest & isRejected & !isAssigned) {
                    rejectedPeriod = DateAndTimeControl.getDelayTime2(begin2Date, end5Date, "En");
                } else if (isRequest & isAssigned & isRejected & !isAcknowledge) {
                    rejectedPeriod = DateAndTimeControl.getDelayTime2(begin2Date, end4Date, "En");
                } else if (isRequest & isAssigned & isRejected & isAcknowledge) {
                    rejectedPeriod = DateAndTimeControl.getDelayTime2(openDate, end5Date, "En");
                } else if (isRequest & isAssigned & isRejected & isAcknowledge & isFinish) {
                    rejectedPeriod = DateAndTimeControl.getDelayTime2(begin6Date, end5Date, "En");
                }

                if (isAssigned & isAcknowledge) {
                    openPeriod = DateAndTimeControl.getDelayTime2(begin4Date, begin3Date, "En");
                }
                if (isAssigned) {
                    assignPeriod = DateAndTimeControl.getDelayTime2(begin2Date, begin4Date, "En");
                }

                if (isRequest & isAssigned & !isAcknowledge & !isClosed & !isFinish) {
                    totalTime = DateAndTimeControl.getDelayTime2(requestDate, begin4Date, "En");
                    isFound = true;
                } else if (isRequest & isAssigned & isAcknowledge & !isClosed & !isFinish) {
                    totalTime = DateAndTimeControl.getDelayTime2(requestDate, begin3Date, "En");
                    isFound = true;
                } else if (isRequest & isAssigned & isAcknowledge & isClosed & !isFinish) {
                    totalTime = DateAndTimeControl.getDelayTime2(requestDate, closeDate, "En");
                    isFound = true;
                } else if (isRequest & isAssigned & isAcknowledge & isClosed & isFinish) {
                    totalTime = DateAndTimeControl.getDelayTime2(requestDate, closeDate, "En");
                    isFound = true;
                } else if (isRequest & isAssigned & isAcknowledge & !isClosed & isFinish) {
                    totalTime = DateAndTimeControl.getDelayTime2(requestDate, finishDate, "En");
                    isFound = true;
                } else if (isRequest & isAssigned & isAcknowledge & !isClosed & !isFinish) {
                    totalTime = DateAndTimeControl.getDelayTime2(assignDate, openDate, "En");
                    isFound = true;
                } else if (isRequest & !isAssigned & !isAcknowledge & !isClosed & isFinish) {
                    totalTime = DateAndTimeControl.getDelayTime2(requestDate, finishDate, "En");
                    isFound = true;
                } else if (isRequest & !isAssigned & isClosed & isFinish) {
                    totalTime = DateAndTimeControl.getDelayTime2(requestDate, closeDate, "En");
                    isFound = true;
                }
                wbo = new WebBusinessObject();
                wbo.setAttribute("requestDate", requestDate);
                wbo.setAttribute("assignDate", assignDate);
                wbo.setAttribute("finishDate", finishDate);
                wbo.setAttribute("closeDate", closeDate);
                wbo.setAttribute("closedPeriod", closedPeriod);
                wbo.setAttribute("finishPeriod", finishPeriod);
                wbo.setAttribute("openPeriod", openPeriod);
                wbo.setAttribute("assignPeriod", assignPeriod);
                wbo.setAttribute("rejectedDate", rejectedDate);
                wbo.setAttribute("rejectedPeriod", rejectedPeriod);
                wbo.setAttribute("openDate", openDate);
                wbo.setAttribute("period", period);
                wbo.setAttribute("totalTime", totalTime);
                wbo.setAttribute("isFinish", isFinish);
                wbo.setAttribute("isClosed", isClosed);
                wbo.setAttribute("isAssigned", isAssigned);
                wbo.setAttribute("isAcknowledge", isAcknowledge);
                wbo.setAttribute("isRejected", isRejected);
                wbo.setAttribute("isFound", isFound);
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 27:
                issueStatusMgr = IssueStatusMgr.getInstance();
                s = request.getSession();
                issueId = request.getParameter("issueId");
                clientComplaintId = request.getParameter("compId");
                notes = (String) request.getParameter("notes");
                endDate = (String) request.getParameter("endDate");
                statusCode = "5";
                object_type = "client_complaint";
                wbo = new WebBusinessObject();
                wbo.setAttribute("parentId", issueId);
                wbo.setAttribute("businessObjectId", clientComplaintId);
                wbo.setAttribute("statusCode", statusCode);
                wbo.setAttribute("objectType", object_type);
                wbo.setAttribute("notes", notes);
                wbo.setAttribute("date", endDate);
                wbo.setAttribute("issueTitle", "UL");
                wbo.setAttribute("statusNote", "UL");
                wbo.setAttribute("cuseDescription", "UL");
                wbo.setAttribute("actionTaken", "UL");
                wbo.setAttribute("preventionTaken", "UL");
                try {
                    if (issueStatusMgr.changeStatus(wbo, persistentUser, ActionEvent.getClientComplaintsActionEvent())) {
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "error");
                    }
                } catch (SQLException ex) {
                    Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 28:
                servedPage = "/docs/client/redirect_tickets.jsp";
                List<WebBusinessObject> issues = new ArrayList<WebBusinessObject>();
                String[] key = new String[2];
                String[] value = new String[2];
                key[0] = "key3";
                key[1] = "key8";
                value[0] = loggegUserId;
                value[1] = "2";
                String respiant = "1";
                int within = 24;
                if (request.getParameter("within") != null) {
                    within = new Integer(request.getParameter("within"));
                }
                try {
                    issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                    issues = new ArrayList<WebBusinessObject>(issueByComplaintMgr.getComplaintsWithoutDate(2, value, key, "key7", respiant, within, null , null));
                } catch (Exception ex) {
                    logger.error(ex);
                }
                List<WebBusinessObject> users = userMgr.getEmployeesByManager((String) persistentUser.getAttribute("userId"));

                request.setAttribute("issues", issues);
                request.setAttribute("users", users);
                request.setAttribute("page", servedPage);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 29:
                clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                int selected;
                String[] complaintsSelected = request.getParameterValues("complaintSelected");
                String[] clientComplaintIds = request.getParameterValues("complaintId");
                String[] complaintsComment = request.getParameterValues("complaintComment");
                String[] complaintSubject = request.getParameterValues("complaintSubject");
                String employeeId = request.getParameter("employeeId");
                responsible = "1";

                for (String complaintSelected : complaintsSelected) {
                    try {
                        selected = Integer.parseInt(complaintSelected);
                        wbo = (WebBusinessObject) clientComplaintsMgr.getOnSingleKey(clientComplaintIds[selected]);
                        wbo.setAttribute("complaintId", clientComplaintIds[selected]);
                        wbo.setAttribute("clientCompId", clientComplaintIds[selected]);
                        wbo.setAttribute("employeeId", employeeId);
                        wbo.setAttribute("notes", complaintsComment[selected]);
                        wbo.setAttribute("responsiblity", responsible);
                        wbo.setAttribute("complaintComment", complaintsComment[selected]);
                        wbo.setAttribute("compSubject", complaintSubject[selected]);
                        if (clientComplaintsMgr.saveForwardComplaint(wbo, request, persistentUser)) {
                            request.setAttribute("status", "Ok");
                        } else {
                            request.setAttribute("status", "No");
                            break;
                        }
                    } catch (NoUserInSessionException ex) {
                        request.setAttribute("status", "No");
                        logger.error(ex);
                        break;
                    } catch (SQLException ex) {
                        request.setAttribute("status", "No");
                        logger.error(ex);
                        break;
                    } catch (NumberFormatException ex) {
                        request.setAttribute("status", "No");
                        logger.error(ex);
                        break;
                    }
                }
                this.forward("/ComplaintEmployeeServlet?op=inbox", request, response);
                break;
            case 30:
                servedPage = "/docs/routing/employee_manager_list.jsp";
                filter = new com.silkworm.pagination.Filter();
                selectionType = request.getParameter("selectionType");
                filter = Tools.getPaginationInfo(request, response);
                usersList = new ArrayList<WebBusinessObject>(0);

                fieldValue = request.getParameter("fieldValue");
                String managerID = request.getParameter("managerID");

                conditions = new ArrayList<FilterCondition>();

                // add conditions
                if (fieldValue != null && !fieldValue.equals("")) {
                    fieldValue = Tools.getRealChar((String) fieldValue);
                    conditions.add(new FilterCondition("USER_NAME", fieldValue, Operations.LIKE));
                }
                conditions.add(new FilterCondition("user_type", "1", Operations.NOT_EQUAL));
                filter.setConditions(conditions);
                try {
                    usersList = (ArrayList) userMgr.paginationEntity(filter, " join EMP_MGR e on USERS.USER_ID = e.EMP_ID and e.MGR_ID = '" + managerID + "'");
                } catch (Exception ex) {
                    Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                if (selectionType == null) {
                    selectionType = "single";
                }

                formName = (String) request.getParameter("formName");

                if (formName == null) {
                    formName = "";
                }
                request.setAttribute("field_value", fieldValue);
                request.setAttribute("selectionType", selectionType);
                request.setAttribute("filter", filter);
                request.setAttribute("formName", formName);
                request.setAttribute("managerID", managerID);
                request.setAttribute("usersList", usersList);
                this.forward(servedPage, request, response);
                break;
            case 31:
                issueStatusMgr = IssueStatusMgr.getInstance();
                
                ids = request.getParameter("ids").split(",");
                
                String[] issueIDs = new String[ids.length];
                if(request.getParameter("issueIDs") == null){
                    
                    for(int index=0; index<ids.length; index++){
                        ClientMgr clientMgr = ClientMgr.getInstance();
                        wbo = clientMgr.getIssueStatusID(ids[index]);
                        issueIDs[index] = wbo.getAttribute("issueStatusID").toString();
                    }
                } else {
                    issueIDs = request.getParameter("issueIDs").split(",");
                }
                
                wbo = new WebBusinessObject();
                wbo.setAttribute("status", "error");                
                notes = request.getParameter("note");
                endDate = request.getParameter("endDate");
                for (int i = 0; i < ids.length; i++) {
                    issueId = issueIDs[i];
                    clientComplaintId = ids[i];
                    clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                    statusCode = "6";
                    object_type = "client_complaint";
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("parentId", issueId);
                    wbo.setAttribute("businessObjectId", clientComplaintId);
                    wbo.setAttribute("statusCode", statusCode);
                    wbo.setAttribute("objectType", object_type);
                    wbo.setAttribute("notes", notes);
                    wbo.setAttribute("date", endDate);
                    wbo.setAttribute("issueTitle", "UL");
                    wbo.setAttribute("statusNote", notes);
                    wbo.setAttribute("cuseDescription", "UL");
                    wbo.setAttribute("actionTaken", request.getParameter("actionTaken"));
                    wbo.setAttribute("preventionTaken", "UL");
                    try {
                        if (issueStatusMgr.changeStatus(wbo, persistentUser, ActionEvent.getClientComplaintsActionEvent())) {
                            MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
                            WebBusinessObject clientComplaintsWbo = clientComplaintsMgr.getOnSingleKey(clientComplaintId);
                            if (loggedUser != null && clientComplaintsWbo != null && clientComplaintsWbo.getAttribute("createdBy") != null) {
                                WebBusinessObject sourceUserWbo = userMgr.getOnSingleKey((String) clientComplaintsWbo.getAttribute("createdBy"));
                                WebBusinessObject closeUserWbo = userMgr.getOnSingleKey((String) loggedUser.getAttribute("userId"));
                                if (metaDataMgr.getSendMail() != null && metaDataMgr.getSendMail().equals("1")
                                        && sourceUserWbo != null && sourceUserWbo.getAttribute("email") != null
                                        && closeUserWbo != null && closeUserWbo.getAttribute("fullName") != null) {
                                    String toEmail = (String) sourceUserWbo.getAttribute("email");
                                    String subject = "تم إنهاء الطلب " + clientComplaintsWbo.getAttribute("businessCompID") + " بواسطة " + closeUserWbo.getAttribute("fullName");
                                    try {
                                        EmailUtility.sendMessage(toEmail, subject, notes);
                                    } catch (Exception ex) {
                                        Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                                    }
                                }
                            }
                            wbo.setAttribute("status", "ok");
                            changeProductStatus(request.getParameter("actionTaken"), clientComplaintId, issueId, request);
                        } else {
                            wbo.setAttribute("status", "error");
                        }
                    } catch (SQLException ex) {
                        Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 32:
                issueStatusMgr = IssueStatusMgr.getInstance();
                ids = request.getParameter("ids").split(",");
                issueIDs = request.getParameter("issueIDs").split(",");
                wbo = new WebBusinessObject();
                wbo.setAttribute("status", "error");                
                notes = request.getParameter("note");
                endDate = request.getParameter("endDate");
                for (int i = 0; i < ids.length; i++) {
                    issueId = issueIDs[i];
                    clientComplaintId = ids[i];
                    statusCode = "7";
                    object_type = "client_complaint";
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("parentId", issueId);
                    wbo.setAttribute("businessObjectId", clientComplaintId);
                    wbo.setAttribute("statusCode", statusCode);
                    wbo.setAttribute("objectType", object_type);
                    wbo.setAttribute("notes", notes);
                    wbo.setAttribute("date", endDate);
                    wbo.setAttribute("issueTitle", "UL");
                    wbo.setAttribute("statusNote", notes);
                    wbo.setAttribute("cuseDescription", "UL");
                    wbo.setAttribute("actionTaken", request.getParameter("actionTaken"));
                    wbo.setAttribute("preventionTaken", "UL");
                    try {
                        if (issueStatusMgr.changeStatus(wbo, persistentUser, ActionEvent.getClientComplaintsActionEvent())) {
                            // try create new complaints
                            clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                            WebBusinessObject complaint = clientComplaintsMgr.getOnSingleKey(clientComplaintId);
                            String ticketType = (String) complaint.getAttribute("ticketType");
                            boolean isCreated = false;
                            if (ticketType != null) {
                                if (ticketType.equalsIgnoreCase(CRMConstants.CLIENT_COMPLAINT_TYPE_EXTRACT)) {
                                    WebBusinessObject managerOfFinances = UserMgr.getInstance().getOnSingleKey(projectMgr.getManagerOfFinancesDepartment());//To be used if there is no assigned finance manager
                                    // To get assigned finance manager to issue's project
                                    IssueProjectMgr issueProjectMgr = IssueProjectMgr.getInstance();
                                    WebBusinessObject issueProject = issueProjectMgr.getOnSingleKey("key1", issueId);
                                    if (issueProject != null) {
                                        UserCompanyProjectsMgr companyProjectsMgr = UserCompanyProjectsMgr.getInstance();
                                        TradeMgr tradeMgr = TradeMgr.getInstance();
                                        ArrayList<WebBusinessObject> tradesList = new ArrayList<>(tradeMgr.getOnArbitraryKey("finance", "key2")); //Code for finance
                                        if (!tradesList.isEmpty()) {
                                            String tradeID = (String) tradesList.get(0).getAttribute("tradeId");
                                            ArrayList<WebBusinessObject> companyProjectsList = new ArrayList<>(companyProjectsMgr.getOnArbitraryDoubleKeyOracle(tradeID, "key4", (String) issueProject.getAttribute("projectID"), "key2"));
                                            if (!companyProjectsList.isEmpty()) {
                                                managerOfFinances = UserMgr.getInstance().getOnSingleKey((String) companyProjectsList.get(0).getAttribute("userId"));
                                            }
                                        }
                                    }
                                    try {
                                        if (managerOfFinances != null) {
                                            clientComplaintsMgr.tellManager(managerOfFinances, issueId, CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_FINANCIAL, request.getParameter("subject"), request.getParameter("comment"), persistentUser);
                                            isCreated = true;
                                        }
                                    } catch (NoUserInSessionException | SQLException ex) {
                                        logger.error(ex);
                                    }
                                }
                            }

                            ClosureConfigMgr closureConfigMgr = ClosureConfigMgr.getInstance();
                            WebBusinessObject actionWbo = closureConfigMgr.getOnSingleKey(request.getParameter("actionTaken"));
                            if (actionWbo != null) {
                                managerID = projectMgr.getManagerByDepartment((String) actionWbo.getAttribute("dept_id"));
                                if (managerID != null && !isCreated) {
                                    WebBusinessObject managerWbo = userMgr.getOnSingleKey(managerID);
                                    clientComplaintsMgr.tellManager(managerWbo, issueId, (String) actionWbo.getAttribute("id"),
                                            (String) actionWbo.getAttribute("comment"), (String) actionWbo.getAttribute("comment"), persistentUser);
                                }
                            }
                            MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
                            clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                            WebBusinessObject clientComplaintsWbo = clientComplaintsMgr.getOnSingleKey(clientComplaintId);
                            if (loggedUser != null && clientComplaintsWbo != null && clientComplaintsWbo.getAttribute("createdBy") != null) {
                                WebBusinessObject sourceUserWbo = userMgr.getOnSingleKey((String) clientComplaintsWbo.getAttribute("createdBy"));
                                WebBusinessObject finishUserWbo = userMgr.getOnSingleKey((String) loggedUser.getAttribute("userId"));
                                if (metaDataMgr.getSendMail() != null && metaDataMgr.getSendMail().equals("1")
                                        && sourceUserWbo != null && sourceUserWbo.getAttribute("email") != null
                                        && finishUserWbo != null && finishUserWbo.getAttribute("fullName") != null) {
                                    String toEmail = (String) sourceUserWbo.getAttribute("email");
                                    String subject = "تم أغلاق الطلب " + clientComplaintsWbo.getAttribute("businessCompID") + " بواسطة " + finishUserWbo.getAttribute("fullName");
                                    try {
                                        EmailUtility.sendMessage(toEmail, subject, notes);
                                    } catch (Exception ex) {
                                        Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                                    }
                                }
                            }
                            wbo.setAttribute("status", "ok");
                        } else {
                            wbo.setAttribute("status", "error");
                        }
                    } catch (SQLException ex) {
                        logger.error(ex);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                }
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            default:
                this.forwardToServedPage(request, response);

        }

    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws javax.servlet.ServletException
     * @throws java.io.IOException
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws javax.servlet.ServletException
     * @throws java.io.IOException
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return
     */
    @Override
    public String getServletInfo() {
        return "Plan Servlet";
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("getComplaintEmployeeForm")) {
            return 1;
        }

        if (opName.equalsIgnoreCase("listUnattachedEmployees")) {
            return 2;
        }

        if (opName.equalsIgnoreCase("saveComplaintEmployee")) {
            return 3;
        }

        if (opName.equalsIgnoreCase("attachGroupToComEmployee")) {
            return 4;
        }

        if (opName.equalsIgnoreCase("saveMailGroup")) {
            return 5;
        }
        if (opName.equalsIgnoreCase("listComEmps")) {
            return 6;
        }
        if (opName.equalsIgnoreCase("updateComplaintEmployee")) {
            return 7;
        }
        if (opName.equalsIgnoreCase("listResEmps")) {
            return 8;
        }
        if (opName.equalsIgnoreCase("listMailGroups")) {
            return 9;
        }
        if (opName.equalsIgnoreCase("viewMailGroup")) {
            return 10;
        }
        if (opName.equalsIgnoreCase("membersOfMailGroup")) {
            return 11;
        }
        if (opName.equalsIgnoreCase("getEmpByGroup")) {
            return 12;
        }
        if (opName.equalsIgnoreCase("closeComp")) {
            return 13;
        }
        if (opName.equalsIgnoreCase("closeMultiComp")) {
            return 14;
        }
        if (opName.equalsIgnoreCase("getEmpsByGroup")) {
            return 15;
        }
        if (opName.equalsIgnoreCase("saveComplaintEmployee2")) {
            return 16;
        }
        if (opName.equalsIgnoreCase("finishComp")) {
            return 17;
        }
        if (opName.equalsIgnoreCase("cancelComp")) {
            return 18;
        }
        if (opName.equalsIgnoreCase("removeSelectedComp")) {
            return 19;
        }
        if (opName.equalsIgnoreCase("closeSelectedComp")) {
            return 20;
        }
        if (opName.equalsIgnoreCase("getEmpByGroup2")) {
            return 21;
        }
        if (opName.equalsIgnoreCase("saveComplaintEmp")) {
            return 22;
        }
        if (opName.equalsIgnoreCase("cancelComplaint")) {
            return 23;
        }
        if (opName.equalsIgnoreCase("finishSelectedComp")) {
            return 24;
        }
        if (opName.equalsIgnoreCase("acknowledgedComp")) {
            return 25;
        }
        if (opName.equalsIgnoreCase("compReport")) {
            return 26;
        }
        if (opName.equalsIgnoreCase("rejectedComplaint")) {
            return 27;
        }
        if (opName.equalsIgnoreCase("inbox")) {
            return 28;
        }
        if (opName.equalsIgnoreCase("redirectSomeInbox")) {
            return 29;
        }
        if (opName.equalsIgnoreCase("usersUnderManager")) {
            return 30;
        }
        if (opName.equalsIgnoreCase("finishMultiComplaintsAjax")) {
            return 31;
        }
        if (opName.equalsIgnoreCase("closeMultiComplaintsAjax")) {
            return 32;
        }
        return 0;
    }

    private boolean changeProductStatus(String actionTaken, String clientComplaintId, String issueId, HttpServletRequest request) {
        WebBusinessObject loggedUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");
        if (actionTaken != null && !actionTaken.isEmpty()) {
            WebBusinessObject actionWbo = projectMgr.getOnSingleKey(actionTaken);
            if (actionWbo != null && actionWbo.getAttribute("eqNO") != null) {
                IssueMgr issueMgr = IssueMgr.getInstance();
                ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
                ClientMgr clientMgr = ClientMgr.getInstance();
                ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                LoggerMgr loggerMgr = LoggerMgr.getInstance();
                IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                WebBusinessObject clientComplaintWbo = clientComplaintsMgr.getOnSingleKey(clientComplaintId);
                if (clientComplaintWbo != null && clientComplaintWbo.getAttribute("ticketType") != null
                        && ((String) clientComplaintWbo.getAttribute("ticketType")).equalsIgnoreCase("8")) {
                    WebBusinessObject issueWbo = issueMgr.getOnSingleKey(issueId);
                    try {
                        if (issueWbo != null && issueWbo.getAttribute("clientId") != null) {
                            ArrayList<WebBusinessObject> productList = new ArrayList<WebBusinessObject>(clientProductMgr.getOnArbitraryDoubleKeyOracle((String) issueWbo.getAttribute("clientId"), "key1", "reserved", "key4"));
                            ReservationMgr reservationMgr = ReservationMgr.getInstance();
                            if (((String) actionWbo.getAttribute("eqNO")).equalsIgnoreCase("paid")) { // change apartment status to sold
                                if (productList.size() > 0) {
                                    clientProductMgr.updateProductStatus((String) productList.get(0).getAttribute("id"), "purche");
                                    issueStatusMgr.changeStatus("10", (String) productList.get(0).getAttribute("projectId"), "Housing_Units",
                                            sdf.format(new Date()), "0", (String) loggedUser.getAttribute("id"), "UL", "UL", "UL", "UL", "UL", null);
                                    ArrayList<WebBusinessObject> reservationList = new ArrayList<WebBusinessObject>(reservationMgr.getOnArbitraryDoubleKeyOracle((String) productList.get(0).getAttribute("projectId"),
                                            "key2", (String) productList.get(0).getAttribute("clientId"), "key1"));
                                    if (reservationList.size() > 0) {
                                        reservationMgr.updateStatus("31", (String) reservationList.get(0).getAttribute("id"));
                                        issueStatusMgr.changeStatus("31", (String) reservationList.get(0).getAttribute("id"), "RESERVATION",
                                                sdf.format(new Date()), "0", (String) loggedUser.getAttribute("id"), "UL", "UL", "UL", "UL", "UL", null);
                                    }
                                    return true;
                                }
                            } else if (((String) actionWbo.getAttribute("eqNO")).equalsIgnoreCase("not-paid")) { // change apartment status to available
                                if (productList.size() > 0) {
                                    WebBusinessObject loggerWbo = new WebBusinessObject();
                                    WebBusinessObject objectXml = clientMgr.getOnSingleKey((String) issueWbo.getAttribute("clientId"));
                                    loggerWbo.setAttribute("objectXml", objectXml.getObjectAsXML());
                                    loggerWbo.setAttribute("realObjectId", objectXml.getAttribute("id"));
                                    loggerWbo.setAttribute("userId", securityUser.getUserId());
                                    loggerWbo.setAttribute("objectName", objectXml.getAttribute("name"));
                                    loggerWbo.setAttribute("loggerMessage", "Reservation Canceled Manually");
                                    loggerWbo.setAttribute("eventName", "Delete");
                                    loggerWbo.setAttribute("objectTypeId", "3");
                                    loggerWbo.setAttribute("eventTypeId", "1");
                                    loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                                    loggerMgr.saveObject(loggerWbo);
                                    clientProductMgr.deleteOnSingleKey((String) productList.get(0).getAttribute("id"));
                                    issueStatusMgr.changeStatus("8", (String) productList.get(0).getAttribute("projectId"), "Housing_Units",
                                            sdf.format(new Date()), "0", (String) loggedUser.getAttribute("id"), "UL", "UL", "UL", "UL", "UL", null);
                                    ArrayList<WebBusinessObject> reservationList = new ArrayList<WebBusinessObject>(reservationMgr.getOnArbitraryDoubleKeyOracle((String) productList.get(0).getAttribute("projectId"),
                                            "key2", (String) productList.get(0).getAttribute("clientId"), "key1"));
                                    if (reservationList.size() > 0) {
                                        reservationMgr.updateStatus("32", (String) reservationList.get(0).getAttribute("id"));
                                        issueStatusMgr.changeStatus("32", (String) reservationList.get(0).getAttribute("id"), "RESERVATION",
                                                sdf.format(new Date()), "0", (String) loggedUser.getAttribute("id"), "UL", "UL", "UL", "UL", "UL", null);
                                    }
                                    return true;
                                }
                            }
                        }
                    } catch (Exception ex) {
                        Logger.getLogger(ComplaintEmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            }
        }
        return false;
    }
}
