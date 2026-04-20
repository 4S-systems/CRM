/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.clients.servlets;

import com.clients.db_access.AppointmentMgr;
import com.clients.db_access.AppointmentNotificationMgr;
import com.clients.db_access.ClientComplaintsMgr;
import com.clients.db_access.ClientMgr;
import com.clients.db_access.ClientProductMgr;
import com.clients.db_access.ClientRatingMgr;
import com.crm.common.ActionEvent;
import com.crm.common.CRMConstants;
import com.crm.common.CalendarUtils;
import com.crm.common.PDFTools;
import com.crm.servlets.CalendarServlet;
import com.crm.servlets.CommentsServlet;

import com.maintenance.common.AutomationConfigurationMgr;
import com.maintenance.common.DateParser;
import com.maintenance.common.Tools;
import com.maintenance.common.UserDepartmentConfigMgr;
import com.maintenance.common.UserGroupConfigMgr;
import com.maintenance.db_access.IssueByComplaintUniqueMgr;
import com.planning.db_access.PaymentPlanMgr;
import com.planning.db_access.SeasonMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.GroupMgr;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.common.SecurityUser;
import com.silkworm.common.UserMgr;
import com.silkworm.db_access.PersistentSessionMgr;
import com.silkworm.logger.db_access.LoggerMgr;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import com.silkworm.util.DateAndTimeControl;
import com.tracker.db_access.CampaignMgr;
import static com.tracker.db_access.CampaignMgr.campaignMgr;
import com.tracker.db_access.CampaignProjectMgr;
import com.tracker.db_access.IssueStatusMgr;
import com.tracker.db_access.ProjectMgr;
import com.tracker.servlets.ProjectServlet;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.json.simple.JSONValue;

/**
 *
 * @author yasser ibrahim
 */
public class AppointmentServlet extends TrackerBaseServlet {

    private AppointmentMgr appointmentMgr;
    private AppointmentNotificationMgr notificationMgr;
    private ClientComplaintsMgr complaintsMgr;
    private IssueStatusMgr statusMgr;
    private MetaDataMgr metaDataMgr;
    private PrintWriter writer;
    private List<WebBusinessObject> appointments;
    private String appointmentId;
    private String clientComplaintId;
    private String employeeId;
    private String callResult;

    private List<WebBusinessObject> list;
    private List<Integer> years;
    private List<CalendarUtils.Month> months;
    private List<CalendarUtils.Day> days;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            super.processRequest(request, response);
            HttpSession session = request.getSession();
            WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
            String loggegUserId = (String) loggedUser.getAttribute("userId");
            String remoteAccess = session.getId();
            WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);
            SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
            this.appointmentMgr = AppointmentMgr.getInstance();
            this.notificationMgr = AppointmentNotificationMgr.getInstance();
            this.complaintsMgr = ClientComplaintsMgr.getInstance();
            this.statusMgr = IssueStatusMgr.getInstance();
            this.metaDataMgr = MetaDataMgr.getInstance();
            WebBusinessObject wbo = new WebBusinessObject();
            String issueId;
            String userId, clientId, date;
            switch (operation) {
                case 1:
                    appointments = notificationMgr.getAppointment(loggegUserId, (int) AutomationConfigurationMgr.getCurrentInstance().getAppointmentRemainingTime());
                    out = response.getWriter();
                    out.write(Tools.getJSONArrayAsString(appointments));
                    break;

                case 2:
                    userId = (String) request.getParameter("userId");
                    date = (String) request.getParameter("date");
                    String number = appointmentMgr.getCountAppointmentsDates(userId, date);
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("number", number);
                    out = response.getWriter();
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;

                case 3:
                    servedPage = "/appointments.jsp";
                    date = (String) request.getParameter("date");
                    appointments = new ArrayList<WebBusinessObject>();
                    try {
                        appointments = notificationMgr.getAppointmentForByDate(loggegUserId, date);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                    request.setAttribute("page", servedPage);
                    request.setAttribute("appointments", appointments);
                    request.setAttribute("AppDate", date);
                    this.forward(servedPage, request, response);
                    break;

                case 4: //showClientAppointment
                    servedPage = "/appointments.jsp";
                    clientId = (String) request.getParameter("clientId");

                    appointments = new ArrayList<WebBusinessObject>();
                    try {
                        appointments = notificationMgr.getClientAppointment(clientId);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                    request.setAttribute("page", servedPage);
                    request.setAttribute("appointments", appointments);
                    this.forward(servedPage, request, response);
                    break;

                case 5: //updateAppointment
                    out = response.getWriter();
                    try {
                        if (appointmentMgr.updateAppointment(request, session)) {
                            wbo.setAttribute("status", "ok");
                        } else {
                            wbo.setAttribute("status", "no");
                        }
                    } catch (SQLException ex) {
                        logger.error(ex);
                    } catch (ParseException ex) {
                        Logger.getLogger(AppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;

                case 6:
                    out = response.getWriter();
                    appointmentId = request.getParameter("appointmentId");
                    try {
                        if (appointmentMgr.deteleAppointment(appointmentId)) {
                            wbo.setAttribute("status", "ok");
                        } else {
                            wbo.setAttribute("status", "no");
                        }
                    } catch (SQLException ex) {
                        logger.error(ex);
                    }

                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                case 7:
                    servedPage = "/appointments.jsp";
                    date = (String) request.getParameter("date");
                    clientId = (String) request.getParameter("clientId");
                    String type = (String) request.getParameter("type");
                    appointments = new ArrayList<WebBusinessObject>();
                    try {
                        if (type.equals("done")) {
                            appointments = notificationMgr.doneAppointment(loggegUserId, clientId, date);
                        } else if (type.equals("pending")) {
                            appointments = notificationMgr.pendingAppointment(loggegUserId, clientId, date);
                        }
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                    request.setAttribute("page", servedPage);
                    request.setAttribute("appointments", appointments);
                    request.setAttribute("AppDate", date);
                    this.forward(servedPage, request, response);
                    break;

                case 8:
                    appointmentId = request.getParameter("appointmentId");
                    issueId = request.getParameter("issueId");
                    clientComplaintId = request.getParameter("clientComplaintId");
                    employeeId = request.getParameter("employeeId");
                    String ticketType = request.getParameter("ticketType");
                    String businessId = issueMgr.getByKeyColumnValue(issueId, "key5");
                    String comment = request.getParameter("comment");
                    String subject = request.getParameter("subject");
                    String notes = request.getParameter("notes");

                    wbo = new WebBusinessObject();
                    try {
                        if (issueId != null && clientComplaintId != null) {
                            String newClientComplaintId = complaintsMgr.createMailInBox(loggegUserId, employeeId, issueId, ticketType, businessId, comment, subject, notes);
                            if (newClientComplaintId != null) {
                                WebBusinessObject issueStatusWbo = new WebBusinessObject();
                                issueStatusWbo.setAttribute("parentId", issueId);
                                issueStatusWbo.setAttribute("businessObjectId", clientComplaintId);
                                issueStatusWbo.setAttribute("statusCode", CRMConstants.CLIENT_COMPLAINT_STATUS_FINISHED);
                                issueStatusWbo.setAttribute("objectType", CRMConstants.OBJECT_TYPE_CLIENT_COMPLAINT);
                                issueStatusWbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                                issueStatusWbo.setAttribute("issueTitle", "UL");
                                issueStatusWbo.setAttribute("statusNote", notes);
                                issueStatusWbo.setAttribute("cuseDescription", "UL");
                                issueStatusWbo.setAttribute("actionTaken", "UL");
                                issueStatusWbo.setAttribute("preventionTaken", "UL");

                                boolean done = statusMgr.changeStatus(issueStatusWbo, persistentUser, ActionEvent.getClientComplaintsActionEvent());
//                            done = done && appointmentMgr.updateAppointmentFor(appointmentId, employeeId, loggegUserId);
                                done = done && appointmentMgr.doneAppointment(appointmentId);

                                if (done) {
                                    wbo.setAttribute("status", "ok");
                                } else {
                                    wbo.setAttribute("status", "no");
                                }
                            } else {
                                wbo.setAttribute("status", "no");
                            }
                        } else {
                            wbo.setAttribute("status", "no-issue");
                        }
                    } catch (SQLException ex) {
                        wbo.setAttribute("status", "no");
                    }

                    writer = response.getWriter();
                    writer.write(Tools.getJSONObjectAsString(wbo));
                    writer.flush();
                    break;

                case 9:
                    appointmentId = request.getParameter("appointmentId");
                    issueId = request.getParameter("issueId");
                    clientComplaintId = request.getParameter("clientComplaintId");
                    callResult = request.getParameter("callResult");

                    wbo = new WebBusinessObject();
                    try {
                        if (issueId != null && clientComplaintId != null) {
                            WebBusinessObject issueStatusWbo = new WebBusinessObject();
                            issueStatusWbo.setAttribute("parentId", issueId);
                            issueStatusWbo.setAttribute("businessObjectId", clientComplaintId);
                            issueStatusWbo.setAttribute("statusCode", CRMConstants.CLIENT_COMPLAINT_STATUS_FINISHED);
                            issueStatusWbo.setAttribute("objectType", CRMConstants.OBJECT_TYPE_CLIENT_COMPLAINT);
                            issueStatusWbo.setAttribute("date", DateAndTimeControl.getOracleDateTimeNowAsString());
                            issueStatusWbo.setAttribute("issueTitle", "UL");
                            issueStatusWbo.setAttribute("statusNote", "UL");
                            issueStatusWbo.setAttribute("cuseDescription", "UL");
                            issueStatusWbo.setAttribute("actionTaken", "UL");
                            issueStatusWbo.setAttribute("preventionTaken", "UL");

                            boolean done = statusMgr.changeStatus(issueStatusWbo, persistentUser, ActionEvent.getClientComplaintsActionEvent());
                            done = done && appointmentMgr.updateAppointmentNoteAndStatus(appointmentId, callResult);

                            if (done) {
                                wbo.setAttribute("status", "ok");
                            } else {
                                wbo.setAttribute("status", "no");
                            }
                        } else {
                            wbo.setAttribute("status", "no-issue");
                        }
                    } catch (SQLException ex) {
                        wbo.setAttribute("status", "no");
                    }

                    writer = response.getWriter();
                    writer.write(Tools.getJSONObjectAsString(wbo));
                    writer.flush();
                    break;

                case 10:
                    comment = request.getParameter("comment");
                    appointmentId = request.getParameter("appointmentID");
                    String branch = request.getParameter("branch");
                    String duration = request.getParameter("duration");
                    appointmentMgr = AppointmentMgr.getInstance();
                    boolean updated = false;
                    try {
                        updated = appointmentMgr.updateAppointmentComment(appointmentId, comment, branch, duration);
                    } catch (SQLException ex) {
                        Logger.getLogger(AppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    response.getWriter().write(String.valueOf(updated));
                    break;

                case 11:
                    servedPage = "/docs/calendar/client_appointments.jsp";
                    clientId = request.getParameter("clientId");
                    String clientName = request.getParameter("clientName");
                    date = request.getParameter("date");
                    appointments = notificationMgr.getClientAppointmentByDate(clientId, date);
                    List<WebBusinessObject> userProjects = new ArrayList();
                    try {
                        userProjects = new ArrayList<WebBusinessObject>(ProjectMgr.getInstance().getOnArbitraryKeyOracle("1365240752318", "key2"));
                    } catch (Exception ex) {
                        Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    request.setAttribute("userProjects", userProjects);
                    request.setAttribute("appointments", appointments);
                    request.setAttribute("clientId", clientId);
                    request.setAttribute("clientName", clientName);
                    this.forward(servedPage, request, response);
                    break;
                case 12:
                    servedPage = "/docs/calendar/user_owner_appointments.jsp";
                    userId = request.getParameter("userId");
                    date = request.getParameter("date");
                    appointments = notificationMgr.getUserOwnedAppointmentsByDate(userId, date);
                    request.setAttribute("userId", userId);
                    request.setAttribute("date", date);
                    request.setAttribute("appointments", appointments);
                    this.forward(servedPage, request, response);
                    break;
                case 13:
                    servedPage = "/docs/calendar/job_order_list.jsp";
                    String beginDate = request.getParameter("beginDate");
                    String endDate = request.getParameter("endDate");
                    String clientID = request.getParameter("clientID");
                    // String areaID = request.getParameter("region");
                    //String userID = request.getParameter("userID");
                    ProjectMgr projectMgr = ProjectMgr.getInstance();
                    if (beginDate != null || endDate != null || clientID != null) {
                        request.setAttribute("beginDate", beginDate);
                        request.setAttribute("endDate", endDate);
                        request.setAttribute("clientID", clientID);
                        /*if (areaID != null) {
                        request.setAttribute("areaWbo", projectMgr.getOnSingleKey(areaID));
                        }*/
                        loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                        String usrID = (String) loggedUser.getAttribute("userId");

                        if (request.getParameter("my") != null && request.getParameter("my").equals("1")) {
                            request.setAttribute("data", appointmentMgr.getJobOrdersList(beginDate, endDate, clientID, usrID,/* areaID, */ null));
                        } else if (request.getParameter("pg") != null && request.getParameter("pg").equals("3")) {
                            request.setAttribute("data", appointmentMgr.getJobOrdersList(beginDate, endDate, null, null, /* areaID, userID*/ /*usrID*/ usrID));
                        } else {
                            request.setAttribute("data", appointmentMgr.getJobOrdersList(beginDate, endDate, clientID, null,/* areaID, userID*/ null));
                        }
                    }

                    String lastFilter = "AppointmentServlet?op=listJobOrders&beginDate=" + beginDate + "&endDate=" + endDate;
                    session.setAttribute("lastFilter", lastFilter);

                    Hashtable topMenu;
                    Vector tempVec;
                    topMenu = (Hashtable) request.getSession().getAttribute("topMenu");
                    if (topMenu != null && topMenu.size() > 0) {
                        tempVec = new Vector();
                        tempVec.add("lastFilter");
                        tempVec.add(lastFilter);
                        topMenu.put("lastFilter", tempVec);
                    } else {
                        topMenu = new Hashtable();
                        tempVec = new Vector();
                        tempVec.add("lastFilter");
                        tempVec.add(lastFilter);
                        topMenu.put("lastFilter", tempVec);

                    }

                    request.getSession().setAttribute("topMenu", topMenu);

                    request.setAttribute("techniciansList", userMgr.getAllTechnicians());

                    if (request.getParameter("pg") != null && request.getParameter("pg").equals("2")) {
                        servedPage = "docs/calendar/jobOrderLst.jsp";
                    } else if (request.getParameter("pg") != null && request.getParameter("pg").equals("3")) {
                        servedPage = "jobOrderTrack.jsp";
                    }
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 14:
                    servedPage = "/docs/calendar/view_appointment.jsp";
                    String appoinmentID = request.getParameter("appointmentID");
                    WebBusinessObject appointmentWbo = appointmentMgr.getOnSingleKey(appoinmentID);
                    ClientMgr clientMgr = ClientMgr.getInstance();
                    WebBusinessObject clientWbo = clientMgr.getOnSingleKey((String) appointmentWbo.getAttribute("clientId"));
                    ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
                    try {
                        request.setAttribute("unitsList", new ArrayList<>(clientProductMgr.getOnArbitraryDoubleKeyOracle((String) appointmentWbo.getAttribute("clientId"), "key1", "purche", "key4")));
                    } catch (Exception ex) {
                        java.util.logging.Logger.getLogger(ProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    request.setAttribute("technicianWbo", userMgr.getOnSingleKey((String) appointmentWbo.getAttribute("userId")));
                    request.setAttribute("createdByWbo", userMgr.getOnSingleKey((String) appointmentWbo.getAttribute("createdBy")));
                    request.setAttribute("appointmentWbo", appointmentWbo);
                    request.setAttribute("clientWbo", clientWbo);
                    this.forward(servedPage, request, response);
                    break;
                case 15:
                    servedPage = "/docs/client/client_with_last_appointment.jsp";
                    String createdBy = request.getParameter("createdBy");
                    String from = request.getParameter("from");
                    String to = request.getParameter("to");
                    String campaignId = request.getParameter("campaignId");
                    projectMgr = ProjectMgr.getInstance();
                    clientMgr = ClientMgr.getInstance();

                    UserDepartmentConfigMgr userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                    ArrayList<WebBusinessObject> userDepartments;
                    projectMgr = ProjectMgr.getInstance();
                    String selectedDepartment = request.getParameter("departmentID");
                    ArrayList<WebBusinessObject> departments = new ArrayList<>();
                    ArrayList<WebBusinessObject> campaignList = new ArrayList<>();
                     campaignMgr=CampaignMgr.getInstance();
            
                try {
                    campaignList=campaignMgr.getAllCampaignList();
                } catch (Exception ex) {
                    Logger.getLogger(AppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("campaignList", campaignList);
               
                     
                    try {
                        userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                        for (WebBusinessObject userDepartmentWbo : userDepartments) {
                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }
                        if (departments.isEmpty()) {
                            WebBusinessObject wboTemp = new WebBusinessObject();
                            wboTemp.setAttribute("projectName", "لا يوجد");
                            wboTemp.setAttribute("projectID", "none");
                            departments.add(wboTemp);
                            list = new ArrayList<>();
                        } else {
                            if (selectedDepartment == null) {
                                selectedDepartment = (String) departments.get(0).getAttribute("projectID");
                            }
                            String toPlusOneDay = to;
                            try {
                                SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
                                Date date1 = formatter.parse(to);
                                Calendar calendar = Calendar.getInstance();
                                calendar.setTime(date1);
                                calendar.add(Calendar.DATE, 1);
                                toPlusOneDay = formatter.format(calendar.getTime());
                            } catch (ParseException ex) {
                                logger.error(ex);
                            }
                            list = notificationMgr.getAppointmentByDate2(from, toPlusOneDay, selectedDepartment, null);
                        }
                    } catch (Exception ex) {
                        Logger.getLogger(AppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    request.setAttribute("departments", departments);
                    ArrayList<WebBusinessObject> ratesList = new ArrayList<>();
                    try {
                        ratesList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("CL-RATE", "key4"));
                    } catch (Exception ex) {
                        Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    request.setAttribute("ratesList", ratesList);

                    List<WebBusinessObject> employeeList = userMgr.getEmployeeByDepartmentId(selectedDepartment, null, null);
                    request.setAttribute("users", employeeList);

                    if (createdBy != null && from != null && to != null) {
                        if (createdBy.equals("-")) {
                            createdBy = "";
                        }
                        String toPlusOneDay = to;
                        try {
                            SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
                            Date d = formatter.parse(to);
                            Calendar calendar = Calendar.getInstance();
                            calendar.setTime(d);
                            calendar.add(Calendar.DATE, 1);
                            toPlusOneDay = formatter.format(calendar.getTime());
                        } catch (ParseException ex) {
                            logger.error(ex);
                        }
                        List<WebBusinessObject> clients = clientMgr.getClientsLastAppointmentByOwner(createdBy, from, toPlusOneDay, employeeList, request.getParameter("clientRate"),campaignId);
                        request.setAttribute("data", clients);
                        request.setAttribute("createdBy", request.getParameter("createdBy"));
                        request.setAttribute("clientRate", request.getParameter("clientRate"));
                        request.setAttribute("from", from);
                        request.setAttribute("to", to);
                        request.setAttribute("campaignId", campaignId);
                        
                    }
                    String defaultCampaign = "";
                    if (securityUser != null && securityUser.getDefaultCampaign() != null && !securityUser.getDefaultCampaign().isEmpty()) {
                        defaultCampaign = securityUser.getDefaultCampaign();
                        CampaignMgr campaignMgr = CampaignMgr.getInstance();
                        WebBusinessObject campaignWbo = campaignMgr.getOnSingleKey(defaultCampaign);
                        if (campaignWbo != null) {
                            defaultCampaign = (String) campaignWbo.getAttribute("campaignTitle");
                        } else {
                            defaultCampaign = "";
                        }
                    }
                    userProjects = new ArrayList<>();
                    try {
                        userProjects = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("1365240752318", "key2"));
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                    List<WebBusinessObject> meetings = projectMgr.getMeetingProjects();
                    List<WebBusinessObject> callResults = projectMgr.getCallResultsProjects();

                    request.setAttribute("defaultCampaign", defaultCampaign);
                    request.setAttribute("userProjects", userProjects);
                    request.setAttribute("meetings", meetings);
                    request.setAttribute("callResults", callResults);
                    request.setAttribute("departmentID", selectedDepartment);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 16:
                    ArrayList<WebBusinessObject> appointmentsList = new ArrayList<>();
                    servedPage = "/docs/client/client_appointments.jsp";
                    String dateType = request.getParameter("dateType");
                    String fromDateS = request.getParameter("fromDate");
                    String toDateS = request.getParameter("toDate");
                    String campaignID = request.getParameter("campaignID");
                    ArrayList<WebBusinessObject> campaignsList = new ArrayList<>(campaignMgr.getCashedTable());
                    request.setAttribute("campaignsList", campaignsList);
                    Calendar cal = Calendar.getInstance();
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
                    Date fromDate = new Date(),
                     toDate = new Date();
                    if (toDateS == null) {
                        toDateS = sdf.format(cal.getTime());
                        toDate = cal.getTime();
                    }
                    if (fromDateS == null) {
                        cal.add(Calendar.MONTH, -1);
                        fromDateS = sdf.format(cal.getTime());
                        fromDate = cal.getTime();
                    }
                    createdBy = request.getParameter("createdBy");
                    String rateID = request.getParameter("rateID");

                    userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                    projectMgr = ProjectMgr.getInstance();
                    selectedDepartment = request.getParameter("departmentID");
                    departments = new ArrayList<>();
                    try {
                        userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                        for (WebBusinessObject userDepartmentWbo : userDepartments) {
                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }
                        if (departments.isEmpty()) {
                            WebBusinessObject wboTemp = new WebBusinessObject();
                            wboTemp.setAttribute("projectName", "لا يوجد");
                            wboTemp.setAttribute("projectID", "none");
                            departments.add(wboTemp);
                            list = new ArrayList<>();
                        } else {
                            if (selectedDepartment == null) {
                                selectedDepartment = (String) departments.get(0).getAttribute("projectID");
                            } else if (selectedDepartment.equalsIgnoreCase("all")) {
                                String[] departmentIDs = new String[departments.size()];
                                int index = 0;
                                for (WebBusinessObject temp : departments) {
                                    departmentIDs[index++] = (String) temp.getAttribute("projectID");
                                }
                                selectedDepartment = Tools.concatenation(departmentIDs, ",");
                            }
                            list = notificationMgr.getAppointmentByDate(fromDate, toDate, selectedDepartment, null);
                        }
                    } catch (Exception ex) {
                        Logger.getLogger(AppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    request.setAttribute("departments", departments);

                    employeeList = userMgr.getEmployeeByDepartmentId(selectedDepartment, null, null);
                    request.setAttribute("usersList", employeeList);

                    if (request.getAttribute("reportType") != null || request.getParameter("reportType") != null) {
                        request.setAttribute("reportType", "true");
                    }
                    if (request.getParameter("reportType") != null) {
                        createdBy = (String) persistentUser.getAttribute("userId");
                    }
                    if (createdBy != null) {
                        if (createdBy.equals("all")) {
                            createdBy = "";
                        }
                        ArrayList<WebBusinessObject> clients = appointmentMgr.getAppointmentsClients(fromDateS, toDateS, createdBy, employeeList, rateID, request.getParameter("appointmentType"), request.getParameter("result"), dateType, campaignID);
                        Map<String, ArrayList<WebBusinessObject>> dataResult = new HashMap<>();
                        for (WebBusinessObject clientTempWbo : clients) {
                            try {
                                appointmentsList = appointmentMgr.getClientAppointments((String) clientTempWbo.getAttribute("clientID"), createdBy, fromDateS, toDateS, request.getParameter("appointmentType"), request.getParameter("result"), dateType);
                                dataResult.put((String) clientTempWbo.getAttribute("clientID"), appointmentsList);
                            } catch (Exception ex) {
                                Logger.getLogger(CommentsServlet.class.getName()).log(Level.SEVERE, null, ex);
                            }
                        }
                        request.setAttribute("dataResult", dataResult);
                        request.setAttribute("data", clients);
                    }
                    ratesList = new ArrayList<>();
                    try {
                        ratesList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("CL-RATE", "key4"));
                    } catch (Exception ex) {
                    }
                    //dateType
                    request.setAttribute("campaignID", campaignID);
                    request.setAttribute("dateType", dateType);
                    request.setAttribute("ratesList", ratesList);
                    request.setAttribute("departmentID", selectedDepartment);
                    request.setAttribute("fromDate", fromDateS);
                    request.setAttribute("toDate", toDateS);
                    request.setAttribute("createdBy", createdBy);
                    request.setAttribute("result", request.getParameter("result"));
                    request.setAttribute("rateID", rateID);
                    request.setAttribute("appointmentType", request.getParameter("appointmentType"));
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 17:
                    appointmentId = request.getParameter("appointmentId");
                    appointmentMgr.acceptAppointment(appointmentId);
                    break;
                case 18:
                    servedPage = "/docs/client/internal_appointments.jsp";
                    appointmentsList = appointmentMgr.getInternalCampaignAppointments(request.getParameter("callingPlanID"));
                    request.setAttribute("data", appointmentsList);
                    this.forward(servedPage, request, response);
                    break;
                case 19:
                    out = response.getWriter();
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("status", appointmentMgr.deleteOnSingleKey(request.getParameter("appointmentID")) ? "ok" : "no");
                    out.print(Tools.getJSONObjectAsString(wbo));
                    break;
                case 20:
                    out = response.getWriter();
                    try {
                        String b = request.getParameter("branch");
                        String c = request.getParameter("comment");
                        int d = Integer.parseInt(request.getParameter("duration"));
                        if (appointmentMgr.updateAppointmentComment(request.getParameter("appointmentID"), request.getParameter("comment"), request.getParameter("branch"), request.getParameter("duration")) //                            && appointmentMgr.caredAppointment(request.getParameter("appointmentID"))
                                ) {
                            wbo.setAttribute("status", "ok");
                        } else {
                            wbo.setAttribute("status", "no");
                        }
                    } catch (SQLException ex) {
                        logger.error(ex);
                    }
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;

                case 21:
                    request.setAttribute("reportType", "true");
                    this.forward("/AppointmentServlet?op=getAllClientAppointments", request, response);
                    break;
                case 22:
                    servedPage = "/docs/calendar/emp_statistic.jsp";

                    projectMgr = ProjectMgr.getInstance();

                    selectedDepartment = request.getParameter("departmentID");

                    try {
                        userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                        userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                        departments = new ArrayList<>();

                        for (WebBusinessObject userDepartmentWbo : userDepartments) {
                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }

                        if (departments.isEmpty()) {
                            WebBusinessObject wboTemp = new WebBusinessObject();
                            wboTemp.setAttribute("projectName", "لا يوجد");
                            wboTemp.setAttribute("projectID", "none");
                            departments.add(wboTemp);
                        } else {
                            if (selectedDepartment == null) {
                                selectedDepartment = (String) departments.get(0).getAttribute("projectID");
                            }
                        }

                        request.setAttribute("departments", departments);
                    } catch (Exception ex) {
                        Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    request.setAttribute("departmentID", selectedDepartment);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 23:
                    servedPage = "/docs/calendar/emp_statistic.jsp";

                    projectMgr = ProjectMgr.getInstance();
                    appointmentMgr = AppointmentMgr.getInstance();

                    selectedDepartment = request.getParameter("departmentID");

                    try {
                        //ArrayList<WebBusinessObject> userStatList = appointmentMgr.getEmpStatistic(request.getParameter("depratmentID"), request.getParameter("beginDate"), request.getParameter("endDate"));
                        ArrayList<WebBusinessObject> userStatList = appointmentMgr.getEmpStatWithNewClient(request.getParameter("depratmentID"), request.getParameter("beginDate"), request.getParameter("endDate"),session);
                        try {
                            request.setAttribute("callSum", userStatList.stream().mapToLong(w -> (Long.valueOf(w.getAttribute("call").toString()))).sum() + "");
                            request.setAttribute("noCallSum", userStatList.stream().mapToLong(w -> (Long.valueOf(w.getAttribute("not_answred").toString()))).sum() + "");
                            request.setAttribute("callDurationSum", userStatList.stream().mapToDouble(w -> (Double.valueOf(w.getAttribute("call_duration").toString()))).sum() + "");
                            request.setAttribute("meetingSum", userStatList.stream().mapToLong(w -> (Long.valueOf(w.getAttribute("meeting").toString()))).sum() + "");
                            request.setAttribute("meetingDurationSum", userStatList.stream().mapToDouble(w -> Double.valueOf(w.getAttribute("meeting_duration").toString())).sum() + "");
                            request.setAttribute("totalClientsSum", userStatList.stream().mapToLong(w -> (Long.valueOf(w.getAttribute("total_clients").toString()))).sum() + "");
                            request.setAttribute("visitClientsSum", userStatList.stream().mapToLong(w -> Long.valueOf(w.getAttribute("visitClientsCount").toString())).sum() + "");
                            request.setAttribute("callsClientsSum", userStatList.stream().mapToLong(w -> Long.valueOf(w.getAttribute("callsClientsCount").toString())).sum() + "");
                            request.setAttribute("newClientsCount", userStatList.stream().mapToLong(w -> Long.valueOf(w.getAttribute("newClientsCount").toString())).sum() + "");
                        } catch (Exception e) {
                            request.setAttribute("callSum", "0");
                            request.setAttribute("noCallSum", "0");
                            request.setAttribute("callDurationSum", "0");
                            request.setAttribute("meetingSum", "0");
                            request.setAttribute("meetingDurationSum", "0");
                            request.setAttribute("totalClientsSum", "0");
                            request.setAttribute("visitClientsSum", "0");
                            request.setAttribute("callsClientsSum", "0");
                            request.setAttribute("newClientsCount", "0");
                        }

                        userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                        userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                        departments = new ArrayList<>();

                        for (WebBusinessObject userDepartmentWbo : userDepartments) {
                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }

                        if (departments.isEmpty()) {
                            WebBusinessObject wboTemp = new WebBusinessObject();
                            wboTemp.setAttribute("projectName", "لا يوجد");
                            wboTemp.setAttribute("projectID", "none");
                            departments.add(wboTemp);
                        } else {
                            if (selectedDepartment == null) {
                                selectedDepartment = (String) departments.get(0).getAttribute("projectID");
                            }
                        }

                        request.setAttribute("departments", departments);
                        request.setAttribute("beginDate", request.getParameter("beginDate"));
                        request.setAttribute("endDate", request.getParameter("endDate"));
                        request.setAttribute("data", userStatList);
                    } catch (Exception ex) {
                        Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    request.setAttribute("departmentID", selectedDepartment);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 24:
                    createdBy = request.getParameter("createdBy");
                    from = request.getParameter("from");
                    to = request.getParameter("to");
                    campaignId = request.getParameter("campaignId");
                    selectedDepartment = request.getParameter("departmentID");
                    employeeList = userMgr.getEmployeeByDepartmentId(selectedDepartment, null, null);

                    clientMgr = ClientMgr.getInstance();
                    if (createdBy != null && from != null && to != null) {
                        if (createdBy.equals("-")) {
                            createdBy = "";
                        }
                        String toPlusOneDay = to;
                        try {
                            SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
                            Date d = formatter.parse(to);
                            Calendar calendar = Calendar.getInstance();
                            calendar.setTime(d);
                            calendar.add(Calendar.DATE, 1);
                            toPlusOneDay = formatter.format(calendar.getTime());
                        } catch (ParseException ex) {
                            logger.error(ex);
                        }
                        ArrayList<WebBusinessObject> clientsList = new ArrayList<>(clientMgr.getClientsLastAppointmentByOwner(createdBy, from, toPlusOneDay, employeeList, null,campaignId));
                        String headers[] = {"#", "Client No.", "Client Name", "Phone", "Mobile", "Inter. No.", "Apointmented By", "Last Appointment Date", "Comment"};
                        String attributes[] = {"Number", "clientNO", "name", "phone", "mobile", "interPhone", "createdByName", "creationTime", "comment"};
                        String dataTypes[] = {"", "String", "String", "String", "String", "String", "String", "String", "String"};

                        String[] headerStr = new String[1];
                        headerStr[0] = "Appointments";

                        HSSFWorkbook workBook = Tools.createExcelReport("Last Appointments", headerStr, null, headers, attributes, dataTypes, clientsList);

                        Calendar c = Calendar.getInstance();
                        Date fileDate = c.getTime();
                        SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");
                        String reportDate = df.format(fileDate);
                        String filename = "LastAppointments" + reportDate;

                        ServletOutputStream servletOutputStream = response.getOutputStream();
                        ByteArrayOutputStream bos = new ByteArrayOutputStream();
                        try {
                            workBook.write(bos);
                        } finally {
                            bos.close();
                        }
                        byte[] bytes = bos.toByteArray();
                        System.out.println(bytes.length);

                        response.setContentType("application/vnd.ms-excel");
                        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + ".xls\"");
                        response.setContentLength(bytes.length);
                        servletOutputStream.write(bytes, 0, bytes.length);
                        servletOutputStream.flush();
                        servletOutputStream.close();
                    }
                    break;
                case 25:
                    servedPage = "/docs/calendar/client_statistic.jsp";

                    projectMgr = ProjectMgr.getInstance();
                    CampaignMgr campMgr = CampaignMgr.getInstance();

                    selectedDepartment = request.getParameter("departmentID");
                    String selectedCampaign = request.getParameter("campaignId");

                    try {
                        userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                        userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                        departments = new ArrayList<>();

                        for (WebBusinessObject userDepartmentWbo : userDepartments) {
                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }

                        if (departments.isEmpty()) {
                            WebBusinessObject wboTemp = new WebBusinessObject();
                            wboTemp.setAttribute("projectName", "لا يوجد");
                            wboTemp.setAttribute("projectID", "none");
                            departments.add(wboTemp);
                        } else {
                            if (selectedDepartment == null) {
                                selectedDepartment = (String) departments.get(0).getAttribute("projectID");
                            }
                        }

                        campMgr.cashData();
                        List<WebBusinessObject> campaigns = new ArrayList<>(campMgr.getCashedTable());

                        request.setAttribute("campaigns", campaigns);
                        request.setAttribute("departments", departments);
                    } catch (Exception ex) {
                        Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    try {
                        if (request.getParameter("campaignID") == null || request.getParameter("campaignID").isEmpty()) {
                            request.setAttribute("projectsList", new ArrayList<>(projectMgr.getOnArbitraryKey("44", "key4")));
                        } else {
                            request.setAttribute("projectsList", CampaignProjectMgr.getInstance().getProjectByCampaignList(request.getParameter("campaignID")));
                        }
                    } catch (Exception ex) {
                        logger.error(ex);
                        request.setAttribute("projectsList", new ArrayList<WebBusinessObject>());
                    }

                    request.setAttribute("departmentID", selectedDepartment);
                    request.setAttribute("campaignID", "0");
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 26:
                    servedPage = "/docs/calendar/client_statistic.jsp";

                    projectMgr = ProjectMgr.getInstance();
                    appointmentMgr = AppointmentMgr.getInstance();
                    campMgr = CampaignMgr.getInstance();

                    selectedDepartment = request.getParameter("departmentID");
                    selectedCampaign = request.getParameter("campaignId");
                    String projectID = request.getParameter("projectID");

                    try {
                        ArrayList<WebBusinessObject> data = appointmentMgr.getClientStatistic(selectedDepartment, selectedCampaign,
                                request.getParameter("beginDate"), request.getParameter("endDate"), projectID);
                        if (!data.isEmpty()) {
                            if (data != null && data.size() > 0) {
                                ArrayList<String> tagNameList = new ArrayList<>();
                                ArrayList graphResultList = new ArrayList();
                                for (WebBusinessObject statUserwbo : data) {
                                    Map<String, Object> graphDataMap = new HashMap<>();
                                    ArrayList userDataList = new ArrayList();
                                    userDataList.add(statUserwbo.getAttribute("answered"));
                                    userDataList.add(statUserwbo.getAttribute("notAnswered"));
                                    graphDataMap.put("name", statUserwbo.getAttribute("userName"));
                                    graphDataMap.put("data", userDataList);
                                    graphResultList.add(graphDataMap);
                                }
                                String ratingCategories = JSONValue.toJSONString(tagNameList);
                                String resultsJson = JSONValue.toJSONString(graphResultList);
                                request.setAttribute("ratingCategories", ratingCategories);
                                request.setAttribute("jsonText", resultsJson);
                                request.setAttribute("data", data);
                            }
                        }
                        userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                        userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                        departments = new ArrayList<>();

                        for (WebBusinessObject userDepartmentWbo : userDepartments) {
                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }

                        if (departments.isEmpty()) {
                            WebBusinessObject wboTemp = new WebBusinessObject();
                            wboTemp.setAttribute("projectName", "لا يوجد");
                            wboTemp.setAttribute("projectID", "none");
                            departments.add(wboTemp);
                        } else {
                            if (selectedDepartment == null) {
                                selectedDepartment = (String) departments.get(0).getAttribute("projectID");
                            }
                        }

                        List<WebBusinessObject> campaigns = new ArrayList<>(campMgr.getCashedTable());

                        request.setAttribute("campaigns", campaigns);
                        request.setAttribute("departments", departments);
                    } catch (Exception ex) {
                        Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    try {
                        if (request.getParameter("campaignID") == null || request.getParameter("campaignID").isEmpty()) {
                            request.setAttribute("projectsList", new ArrayList<>(projectMgr.getOnArbitraryKey("44", "key4")));
                        } else {
                            request.setAttribute("projectsList", CampaignProjectMgr.getInstance().getProjectByCampaignList(request.getParameter("campaignID")));
                        }
                    } catch (Exception ex) {
                        logger.error(ex);
                        request.setAttribute("projectsList", new ArrayList<WebBusinessObject>());
                    }

                    request.setAttribute("beginDate", request.getParameter("beginDate").toString());
                    request.setAttribute("endDate", request.getParameter("endDate").toString());
                    request.setAttribute("departmentID", selectedDepartment);
                    request.setAttribute("campaignID", selectedCampaign);
                    request.setAttribute("projectID", projectID);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 27:
                    servedPage = "/docs/calendar/statistic_details.jsp";
                    selectedDepartment = request.getParameter("departmentID");
                    selectedCampaign = request.getParameter("campaignID");
                    projectID = request.getParameter("projectID");
                    type = request.getParameter("type");

                    appointmentMgr = AppointmentMgr.getInstance();
                    ArrayList dataList = new ArrayList();
                    HashMap dataEntryMap = new HashMap();

                    appointments = new ArrayList<WebBusinessObject>();
                    projectMgr = ProjectMgr.getInstance();
                    ArrayList<WebBusinessObject> callType = new ArrayList<WebBusinessObject>();
                    ArrayList<WebBusinessObject> callResult = new ArrayList<WebBusinessObject>();

                    String userID;

                    try {
                        String dID = request.getParameter("departmentID");

                        if (dID.equals("null")) {
                            loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");

                            userID = "";

                            if (request.getParameter("userID") == null || request.getParameter("userID").equals("null")) {
                                userID = (String) loggedUser.getAttribute("userId");
                            } else {
                                userID = request.getParameter("userID");
                            }

                            appointments = appointmentMgr.getCallCenterDetailsByUsrID(userID, request.getParameter("type"), request.getParameter("beginDate"), request.getParameter("endDate"), request.getParameter("campaignID"), request.getParameter("projectID"));
                       } else {
                            appointments = appointmentMgr.getCallCenterDetails(dID, request.getParameter("campaignID"), request.getParameter("type"), request.getParameter("beginDate"), request.getParameter("endDate"), projectID);
                            callType = appointmentMgr.getCallTypeStat(dID, request.getParameter("campaignID"), request.getParameter("type"), request.getParameter("beginDate"), request.getParameter("endDate"), projectID);
                            callResult = appointmentMgr.getCallResultStat(dID, request.getParameter("campaignID"), request.getParameter("type"), request.getParameter("beginDate"), request.getParameter("endDate"), projectID);
                        }

                        if (!callType.isEmpty()) {
                            dataList = new ArrayList();
                            int totalClientsCount = 0;

                            // populate series data map
                            for (WebBusinessObject clientCountWbo : callType) {
                                dataEntryMap = new HashMap();
                                totalClientsCount += Integer.parseInt(clientCountWbo.getAttribute("Total").toString());

                                dataEntryMap.put("name", clientCountWbo.getAttribute("CallType"));
                                dataEntryMap.put("y", Integer.parseInt(clientCountWbo.getAttribute("Total").toString()));

                                dataList.add(dataEntryMap);
                            }

                            // convert map to JSON string
                            String jsonCallTypeText = JSONValue.toJSONString(dataList);

                            request.setAttribute("totalCallTypeCount", totalClientsCount);
                            request.setAttribute("callType", callType);
                            request.setAttribute("jsonCallTypeText", jsonCallTypeText);
                        }

                        if (!callResult.isEmpty()) {
                            dataList = new ArrayList();
                            int totalClientsCount = 0;

                            // populate series data map
                            for (WebBusinessObject clientCountWbo : callResult) {
                                dataEntryMap = new HashMap();
                                totalClientsCount += Integer.parseInt(clientCountWbo.getAttribute("Total").toString());

                                dataEntryMap.put("name", clientCountWbo.getAttribute("CallResult"));
                                dataEntryMap.put("y", Integer.parseInt(clientCountWbo.getAttribute("Total").toString()));

                                dataList.add(dataEntryMap);
                            }

                            // convert map to JSON string
                            String jsonCallResultText = JSONValue.toJSONString(dataList);

                            request.setAttribute("totalCallResultCount", totalClientsCount);
                            request.setAttribute("callResult", callResult);
                            request.setAttribute("jsonCallResultText", jsonCallResultText);
                        }
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                    request.setAttribute("beginDate", request.getParameter("beginDate"));
                    request.setAttribute("endDate", request.getParameter("endDate"));
                    request.setAttribute("departmentID", selectedDepartment);
                    request.setAttribute("campaignID", selectedCampaign);
                    request.setAttribute("projectID", projectID);
                    request.setAttribute("type", type);
                    request.setAttribute("page", servedPage);
                    request.setAttribute("appointments", appointments);
                    this.forwardToServedPage(request, response);
                    break;
                case 28:
                    selectedDepartment = request.getParameter("departmentID");
                    selectedCampaign = request.getParameter("campaignID");
                    projectID = request.getParameter("projectID");
                    type = request.getParameter("type");

                    appointmentMgr = AppointmentMgr.getInstance();

                    appointments = new ArrayList<WebBusinessObject>();
                    try {
                        appointments = appointmentMgr.getCallCenterDetails(selectedDepartment, selectedCampaign, type, request.getParameter("beginDate"), request.getParameter("endDate"), projectID);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }

                    String headers[] = {"#", "Employee Name", "Client Name", "Appointment Date", "Appointment Type", "Call Result", "Automatic Call Duration", "Call Duration", "Comment"};
                    String attributes[] = {"Number", "User_NAME", "Client_NAME", "AppointmentDate", "appointmentType", "callRes", "autoCallDuration", "callDuration", "comment"};
                    String dataTypes[] = {"", "String", "String", "String", "String", "String", "String", "String", "String"};

                    String[] headerStr = new String[1];
                    headerStr[0] = type + "Calls";
                    HSSFWorkbook workBook = Tools.createExcelReport(type + " Calls", headerStr, null, headers, attributes, dataTypes, (ArrayList<WebBusinessObject>) appointments);

                    Calendar c = Calendar.getInstance();
                    Date fileDate = c.getTime();
                    SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");
                    String reportDate = df.format(fileDate);
                    String filename = type + "Calls" + reportDate;

                    ServletOutputStream servletOutputStream = response.getOutputStream();
                    ByteArrayOutputStream bos = new ByteArrayOutputStream();
                    try {
                        workBook.write(bos);
                    } finally {
                        bos.close();
                    }
                    byte[] bytes = bos.toByteArray();
                    System.out.println(bytes.length);

                    response.setContentType("application/vnd.ms-excel");
                    response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + ".xls\"");
                    response.setContentLength(bytes.length);
                    servletOutputStream.write(bytes, 0, bytes.length);
                    servletOutputStream.flush();
                    servletOutputStream.close();
                    break;
                case 29:
                    createdBy = request.getParameter("createdBy");
                    from = request.getParameter("from");
                    to = request.getParameter("to");
                    campaignId = request.getParameter("campaignId");
                    projectMgr = ProjectMgr.getInstance();
                    clientMgr = ClientMgr.getInstance();

                    userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                    projectMgr = ProjectMgr.getInstance();
                    selectedDepartment = request.getParameter("departmentID");

                    employeeList = userMgr.getEmployeeByDepartmentId(selectedDepartment, null, null);
                    request.setAttribute("users", employeeList);

                    List<WebBusinessObject> clients = null;

                    if (createdBy != null && from != null && to != null) {
                        if (createdBy.equals("-")) {
                            createdBy = "";
                        }
                        String toPlusOneDay = to;
                        try {
                            SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
                            Date d = formatter.parse(to);
                            Calendar calendar = Calendar.getInstance();
                            calendar.setTime(d);
                            calendar.add(Calendar.DATE, 1);
                            toPlusOneDay = formatter.format(calendar.getTime());
                        } catch (ParseException ex) {
                            logger.error(ex);
                        }
                        clients = clientMgr.getClientsLastAppointmentByOwner(createdBy, from, toPlusOneDay, employeeList, request.getParameter("clientRate"),campaignId);
                    }

                    String headers2[] = {"#", "Client ID", "Client Name", "Phone Number", "Mobile Number", "International Phone Number", "Classification", "Campaign","Last Commenter", "Last Follower", "Last Appointment Date", "Appointment Type", "Duration", "Comment","Client Creation Time","Campaign Name"};
                    String attributes2[] = {"Number", "id", "name", "phone", "mobile", "interPhone", "rateName", "campaignTitle","createdByName", "createdBy", "creationTime", "option2", "callDuration", "comment","clientCreationTime","campaignTitle"};
                    String dataTypes2[] = {"String", "String", "String", "String", "String", "String", "String", "String", "String", "String","String", "String", "String", "String","String","String"};

                    
                    String headerStrLP[] = {"LastAppointments","From Date:","To Date:","Department","Campaign","Classification"};
                    String [] headerValues={"",from,to,request.getParameter("departmentDisp"),request.getParameter("campaignDisp"),request.getParameter("clientRateDisp")};
                    workBook = Tools.createExcelReport("LastAppointments", headerStrLP, headerValues, headers2, attributes2, dataTypes2, (ArrayList<WebBusinessObject>) clients);

                    c = Calendar.getInstance();
                    fileDate = c.getTime();
                    df = new SimpleDateFormat("dd-MM-yyyy");
                    reportDate = df.format(fileDate);
                    filename = "LastAppointments" + reportDate;

                    servletOutputStream = response.getOutputStream();
                    bos = new ByteArrayOutputStream();
                    try {
                        workBook.write(bos);
                    } finally {
                        bos.close();
                    }
                    bytes = bos.toByteArray();
                    System.out.println(bytes.length);

                    response.setContentType("application/vnd.ms-excel");
                    response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + ".xls\"");
                    response.setContentLength(bytes.length);
                    servletOutputStream.write(bytes, 0, bytes.length);
                    servletOutputStream.flush();
                    servletOutputStream.close();

                    break;
                case 30:
                    out = response.getWriter();
                  
                    if (request.getParameter("result") != null && !request.getParameter("result").isEmpty()) {
                        if (appointmentMgr.updateAppointmentResult(request.getParameter("appointmentID"), request.getParameter("result"),
                                request.getParameter("nextAction"))
                                && appointmentMgr.caredAppointment(request.getParameter("appointmentID"))) {
                            wbo.setAttribute("status", "ok");
                            if (request.getParameter("nextAction") != null && !request.getParameter("nextAction").equalsIgnoreCase("No Action")) {
                                projectMgr = ProjectMgr.getInstance();
                                rateID = projectMgr.getActionRate(request.getParameter("nextAction"));
                                if (rateID != null) {
                                    clientID = request.getParameter("clientID");
                                    ClientRatingMgr clientRatingMgr = ClientRatingMgr.getInstance();
                                    try {
                                        clientRatingMgr.deleteOnArbitraryKey(clientID, "key1");
                                    } catch (Exception ex) {
                                        Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                                    }
                                    wbo = new WebBusinessObject();
                                    wbo.setAttribute("clientID", clientID);
                                    wbo.setAttribute("rateID", rateID);
                                    wbo.setAttribute("createdBy", persistentUser.getAttribute("userId"));
                                    wbo.setAttribute("option1", "UL");
                                    wbo.setAttribute("option2", "UL");
                                    wbo.setAttribute("option3", "UL");
                                    if (clientRatingMgr.saveObject(wbo)) {
                                        wbo.setAttribute("status", "ok");
                                    } else {
                                        wbo.setAttribute("status", "fail");
                                    }
                                }
                            }
                        } else {
                            wbo.setAttribute("status", "no");
                        }
                    } else {
                        try {
                            if (appointmentMgr.updateAppointmentComment(request.getParameter("appointmentID"), request.getParameter("comment"), request.getParameter("branch"), request.getParameter("duration"))
                                    && appointmentMgr.caredAppointment(request.getParameter("appointmentID"))) {
                                wbo.setAttribute("status", "ok");
                            } else {
                                wbo.setAttribute("status", "no");
                            }
                        } catch (SQLException ex) {
                            logger.error(ex);
                        }
                    }
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                case 31:
                    servedPage = "/docs/calendar/my_client_statistics.jsp";
                    projectMgr = ProjectMgr.getInstance();
                    campMgr = CampaignMgr.getInstance();
                    selectedCampaign = request.getParameter("campaignId") != null ? request.getParameter("campaignId") : "0";
                    if (request.getParameter("beginDate") != null) { // search
                        sdf = new SimpleDateFormat("yyyy/MM/dd");
                        try {
                            userID = "";
                            if (request.getParameter("rprtType") == null) {
                                if (request.getParameter("userID") == null) {
                                    userID = (String) persistentUser.getAttribute("userId");
                                } else {
                                    userID = request.getParameter("userID");
                                }
                            } else {
                                userID = request.getParameter("userID");
                            }
                            ArrayList<WebBusinessObject> data = appointmentMgr.getMyClientStatistic(userID, request.getParameter("campaignId"),
                                    new java.sql.Date(sdf.parse(request.getParameter("beginDate")).getTime()),
                                    new java.sql.Date(sdf.parse(request.getParameter("endDate")).getTime()), request.getParameter("projectID"));
                            if (!data.isEmpty()) {
                                String jsonText = null;
                                dataList = new ArrayList();
                                WebBusinessObject statWbo = data.get(0);
                                dataEntryMap = new HashMap();
                                dataEntryMap.put("name", "Answered");
                                dataEntryMap.put("y", statWbo.getAttribute("Answered"));
                                dataList.add(dataEntryMap);
                                dataEntryMap = new HashMap();
                                dataEntryMap.put("name", "Not_Answered");
                                dataEntryMap.put("y", statWbo.getAttribute("Not_Answered"));
                                dataList.add(dataEntryMap);
                                jsonText = JSONValue.toJSONString(dataList);
                                request.setAttribute("data", data);
                                request.setAttribute("jsonText", jsonText);
                            }
                        } catch (Exception ex) {
                            Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                    try {
                        campMgr.cashData();
                        List<WebBusinessObject> campaigns = new ArrayList<>(campMgr.getCashedTable());
                        request.setAttribute("campaigns", campaigns);
                    } catch (Exception ex) {
                        Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    try {
                        if (request.getParameter("campaignID") == null || request.getParameter("campaignID").isEmpty()) {
                            request.setAttribute("projectsList", new ArrayList<>(projectMgr.getOnArbitraryKey("44", "key4")));
                        } else {
                            request.setAttribute("projectsList", CampaignProjectMgr.getInstance().getProjectByCampaignList(request.getParameter("campaignID")));
                        }
                    } catch (Exception ex) {
                        logger.error(ex);
                        request.setAttribute("projectsList", new ArrayList<WebBusinessObject>());
                    }

                    request.setAttribute("beginDate", request.getParameter("beginDate"));
                    request.setAttribute("endDate", request.getParameter("endDate"));
                    request.setAttribute("campaignID", selectedCampaign);
                    request.setAttribute("projectID", request.getParameter("projectID"));
                    request.setAttribute("userID", request.getParameter("userID"));
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 32:
                    servedPage = "/docs/client/client_appointments_details.jsp";

                    try {
                        ArrayList<ArrayList<String>> clientAppntsist = new ArrayList<>();

                        if (request.getParameter("type") == null || request.getParameter("type").equals("")) {
                            clientAppntsist = notificationMgr.getAppointmentByDateAndUser(request.getParameter("beginDate"), request.getParameter("endDate"), request.getParameter("departmentID"), request.getParameter("userID"));
                        } else {
                            clientAppntsist = notificationMgr.getAppointmentByDateAndUserAndStatus(request.getParameter("type"), request.getParameter("beginDate"), request.getParameter("endDate"), request.getParameter("departmentID"), request.getParameter("userID"));
                        }

                        String appoitmentsJson = JSONValue.toJSONString(clientAppntsist);

                        request.setAttribute("appoitmentsJson", appoitmentsJson);
                    } catch (Exception ex) {
                        Logger.getLogger(AppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    request.setAttribute("userID", request.getParameter("userID"));
                    request.setAttribute("userName", request.getParameter("userName"));
                    request.setAttribute("departmentID", request.getParameter("departmentID"));
                    request.setAttribute("repType", request.getParameter("type"));

                    request.setAttribute("beginDate", request.getParameter("beginDate"));
                    request.setAttribute("endDate", request.getParameter("endDate"));

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 33:
                    servedPage = "/docs/client/dept_stat_details.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 34:
                    servedPage = "/docs/client/dept_stat_details.jsp";

                    try {
                        ArrayList<ArrayList<String>> deptsDetails = new ArrayList<>();

                        deptsDetails = AppointmentMgr.getInstance().getDeptsStatistics(request.getParameter("beginDate"), request.getParameter("endDate"));
                        String deptsJson = JSONValue.toJSONString(deptsDetails);

                        request.setAttribute("deptsJson", deptsJson);
                    } catch (Exception ex) {
                        Logger.getLogger(AppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 35:
                    servedPage = "/docs/Appointments/Appointment_statistic.jsp";

                    cal = Calendar.getInstance();
                    sdf = new SimpleDateFormat("yyyy/MM/dd");
                    request.setAttribute("toDate", sdf.format(cal.getTime()));
                    cal.add(Calendar.MONTH, -1);
                    request.setAttribute("fromDate", sdf.format(cal.getTime()));

                    request.setAttribute("rprtType", request.getParameter("rprtType"));
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 36:
                    String appointmentType = request.getParameter("appointmentType");

                    if (appointmentType != null) {
                        try {
                            if (appointmentType.equals("1")) {
                                servedPage = "/docs/Appointments/Appointment_statistic.jsp";
                                ArrayList<WebBusinessObject> dataTotal = AppointmentNotificationMgr.getInstance().getApntmnStatisticTotal(request.getParameter("beginDate"), request.getParameter("endDate"), null, null);
                                WebBusinessObject data = AppointmentNotificationMgr.getInstance().getAppointmentStatistic(request.getParameter("beginDate"), request.getParameter("endDate"), null, null);

                                WebBusinessObject statWbo = dataTotal.get(0);

                                if (!dataTotal.isEmpty()) {
                                    String jsonText = null;
                                    dataList = new ArrayList();

                                    dataEntryMap = new HashMap();
                                    dataEntryMap.put("type", "column");
                                    dataEntryMap.put("name", "Sccuess");
                                    dataEntryMap.put("data", statWbo.getAttribute("Sccuess"));
                                    dataList.add(dataEntryMap);

                                    dataEntryMap = new HashMap();
                                    dataEntryMap.put("type", "column");
                                    dataEntryMap.put("name", "Fail");
                                    dataEntryMap.put("data", statWbo.getAttribute("Fail"));
                                    dataList.add(dataEntryMap);

                                    jsonText = JSONValue.toJSONString(dataList);

                                    request.setAttribute("data", data);
                                    request.setAttribute("dataTotal", dataTotal);
                                    request.setAttribute("jsonText", jsonText);
                                }
                                request.setAttribute("fromDate", request.getParameter("beginDate"));
                                request.setAttribute("toDate", request.getParameter("endDate"));
                            } else {
                                servedPage = "/docs/Appointments/Appointment_Stat_Details.jsp";
                                ArrayList<ArrayList<String>> results = new ArrayList<>();
                                String displayType = request.getParameter("displayType");
                                beginDate = request.getParameter("beginDate");
                                endDate = request.getParameter("endDate");
                                
                                departments = new ArrayList<>();
                                userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                                projectMgr = ProjectMgr.getInstance();
                                selectedDepartment = request.getParameter("departmentID");
                                try {
                                    userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                                    for (WebBusinessObject userDepartmentWbo : userDepartments) {
                                        departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                                    }
                                } catch (Exception ex) {
                                    Logger.getLogger(CommentsServlet.class.getName()).log(Level.SEVERE, null, ex);
                                }

                                try {
                                    if(beginDate != null && endDate != null){
                                        results = AppointmentMgr.getInstance().getFuturedAppointmentDetails(beginDate, endDate, null, null,
                                                selectedDepartment, (String) persistentUser.getAttribute("userId"));
                                        String resultJson = JSONValue.toJSONString(results);
                                        request.setAttribute("resultJson", resultJson);
                                    }

                                    
                                } catch (Exception ex) {
                                    Logger.getLogger(AppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                                }
                                c = Calendar.getInstance();
                                sdf = new SimpleDateFormat("yyyy/MM/dd");
                                if (beginDate == null || beginDate.isEmpty()) {
                                    beginDate = sdf.format(c.getTime());
                                }
                                if (endDate == null || endDate.isEmpty()) {
                                    c.add(Calendar.MONTH, 1);
                                    endDate = sdf.format(c.getTime());
                                }
                                request.setAttribute("displayType", displayType);
                                request.setAttribute("appointmentType", appointmentType);
                                request.setAttribute("total", results.size() + "");
                                request.setAttribute("fromDate", beginDate);
                                request.setAttribute("toDate", endDate);
                                request.setAttribute("departmentID", request.getParameter("departmentID"));
                                request.setAttribute("departments", departments);
                            }
                        } catch (Exception ex) {
                            Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 37:
                    servedPage = "/docs/Appointments/Appointment_Stat_Details.jsp";
                    String rprtType = request.getParameter("rprtType");

                    try {
                        ArrayList<ArrayList<String>> results = new ArrayList<>();
                        if (rprtType != null && rprtType.equals("myReport")) {
                            if (request.getParameter("userID") == null || request.getParameter("userID").equals("null")) {
                                results = AppointmentMgr.getInstance().getAppointmentsDetailsByStatus(request.getParameter("type"), request.getParameter("beginDate"), request.getParameter("endDate"), (String) persistentUser.getAttribute("userId"), rprtType);
                            } else {
                                results = AppointmentMgr.getInstance().getAppointmentsDetailsByStatus(request.getParameter("type"), request.getParameter("beginDate"), request.getParameter("endDate"), request.getParameter("userID"), rprtType);
                            }

                        } else {
                            results = AppointmentMgr.getInstance().getAppointmentsDetailsByStatus(request.getParameter("type"), request.getParameter("beginDate"), request.getParameter("endDate"), null, null);
                        }
                        String resultJson = JSONValue.toJSONString(results);

                        request.setAttribute("resultJson", resultJson);
                    } catch (Exception ex) {
                        Logger.getLogger(AppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    request.setAttribute("rprtType", rprtType);
                    request.setAttribute("total", request.getParameter("total"));
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 38:
                    servedPage = "/docs/client/client_all_appointments.jsp";
                    appointments = new ArrayList<>();
                    try {
                        appointments = appointmentMgr.getClientAppointments(request.getParameter("clientID"),
                                "personal".equals(request.getParameter("type")) ? (String) persistentUser.getAttribute("userId") : "",
                                null, null, null, null, null);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                    request.setAttribute("appointments", appointments);
                    this.forward(servedPage, request, response);
                    break;
                case 39:
                    servedPage = "/docs/client/user_clients_statistics.jsp";
                    sdf = new SimpleDateFormat("yyyy/MM/dd");
                    try {
                        ArrayList<WebBusinessObject> data = appointmentMgr.getMyClientStatistic(request.getParameter("userID"), "0",
                                new java.sql.Date(sdf.parse(request.getParameter("beginDate")).getTime()),
                                new java.sql.Date(sdf.parse(request.getParameter("endDate")).getTime()), null);
                        if (!data.isEmpty()) {
                            String jsonText = null;
                            dataList = new ArrayList();
                            WebBusinessObject statWbo = data.get(0);
                            dataEntryMap = new HashMap();
                            dataEntryMap.put("name", "Answered");
                            dataEntryMap.put("y", statWbo.getAttribute("Answered"));
                            dataList.add(dataEntryMap);
                            dataEntryMap = new HashMap();
                            dataEntryMap.put("name", "Not_Answered");
                            dataEntryMap.put("y", statWbo.getAttribute("Not_Answered"));
                            dataList.add(dataEntryMap);
                            jsonText = JSONValue.toJSONString(dataList);
                            request.setAttribute("data", data);
                            request.setAttribute("jsonText", jsonText);
                        }
                    } catch (Exception ex) {
                        Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    request.setAttribute("userID", request.getParameter("userID"));
                    request.setAttribute("userName", request.getParameter("userName"));
                    request.setAttribute("beginDate", request.getParameter("beginDate"));
                    request.setAttribute("endDate", request.getParameter("endDate"));
                    request.setAttribute("campaignID", request.getParameter("campaignID"));
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 40:
                    appointmentType = request.getParameter("appointmentType");

                    userID = request.getParameter("userId");

                    if (appointmentType != null) {
                        try {
                            if (appointmentType.equals("1")) {
                                servedPage = "/docs/Appointments/Appointment_statistic.jsp";

                                if (request.getParameter("reportType") == null || request.getParameter("reportType").equals("null")) {
                                    userID = (String) persistentUser.getAttribute("userId");
                                } else {
                                    userID = request.getParameter("userId");
                                }

                                ArrayList<WebBusinessObject> dataTotal = AppointmentNotificationMgr.getInstance().getApntmnStatisticTotal(request.getParameter("beginDate"), request.getParameter("endDate"), userID, "myReport");
                                WebBusinessObject data = AppointmentNotificationMgr.getInstance().getAppointmentStatistic(request.getParameter("beginDate"), request.getParameter("endDate"), userID, "myReport");

                                WebBusinessObject statWbo = dataTotal.get(0);

                                if (!dataTotal.isEmpty()) {
                                    String jsonText = null;
                                    dataList = new ArrayList();

                                    dataEntryMap = new HashMap();
                                    dataEntryMap.put("type", "column");
                                    dataEntryMap.put("name", "Sccuess");
                                    dataEntryMap.put("data", statWbo.getAttribute("Sccuess"));
                                    dataList.add(dataEntryMap);

                                    dataEntryMap = new HashMap();
                                    dataEntryMap.put("type", "column");
                                    dataEntryMap.put("name", "Fail");
                                    dataEntryMap.put("data", statWbo.getAttribute("Fail"));
                                    dataList.add(dataEntryMap);

                                    jsonText = JSONValue.toJSONString(dataList);

                                    request.setAttribute("data", data);
                                    request.setAttribute("dataTotal", dataTotal);
                                    request.setAttribute("jsonText", jsonText);
                                }
                            } else {
                                servedPage = "/docs/Appointments/Appointment_Stat_Details.jsp";
                                ArrayList<ArrayList<String>> results = new ArrayList<>();

                                try {
                                    if (request.getParameter("userId") != null) {
                                        userID = request.getParameter("userId");
                                    } else {
                                        userID = (String) persistentUser.getAttribute("userId");
                                    }
                                    results = AppointmentMgr.getInstance().getFuturedAppointmentDetails(request.getParameter("beginDate"), request.getParameter("endDate"), userID, "myReport", null, null);
                                    String resultJson = JSONValue.toJSONString(results);

                                    request.setAttribute("resultJson", resultJson);
                                } catch (Exception ex) {
                                    Logger.getLogger(AppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                                }

                                request.setAttribute("total", new Integer(results.size()).toString());
                            }
                        } catch (Exception ex) {
                            Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }

                    request.setAttribute("fromDate", request.getParameter("beginDate").toString());
                    request.setAttribute("toDate", request.getParameter("endDate").toString());
                    request.setAttribute("rprtType", "myReport");
                    request.setAttribute("userID", userID);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 41:
                    servedPage = "/docs/calendar/emp_client_statistic.jsp";

                    projectMgr = ProjectMgr.getInstance();
                    userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();

                    departments = new ArrayList<>();

                    selectedDepartment = request.getParameter("departmentID");

                    try {
                        userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));

                        for (WebBusinessObject userDepartmentWbo : userDepartments) {
                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }
                        if (departments.isEmpty()) {
                            WebBusinessObject wboTemp = new WebBusinessObject();
                            wboTemp.setAttribute("projectName", "لا يوجد");
                            wboTemp.setAttribute("projectID", "none");
                            departments.add(wboTemp);
                        } else {
                            if (selectedDepartment == null) {
                                selectedDepartment = (String) departments.get(0).getAttribute("projectID");
                            }
                        }
                        request.setAttribute("departments", departments);
                    } catch (Exception ex) {
                        Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    try {
                        request.setAttribute("requestTypes", new ArrayList<>(ProjectMgr.getInstance().getOnArbitraryKey("RQ-TYPE", "key4")));
                    } catch (Exception ex) {
                        request.setAttribute("requestTypes", new ArrayList<>());
                    }

                    cal = Calendar.getInstance();
                    sdf = new SimpleDateFormat("yyyy/MM/dd");
                    request.setAttribute("toDate", sdf.format(cal.getTime()));
                    cal.add(Calendar.MONTH, -1);
                    request.setAttribute("fromDate", sdf.format(cal.getTime()));
                    request.setAttribute("departmentID", selectedDepartment);

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 42:
                    servedPage = "/docs/calendar/emp_client_statistic.jsp";

                    try {
                        ArrayList<ArrayList<String>> data = new ArrayList<>();

                        data = AppointmentMgr.getInstance().getEmpClientStatistic(request.getParameter("departmentID"), request.getParameter("beginDate"), request.getParameter("endDate"));

                        String resultJson = JSONValue.toJSONString(data);

                        request.setAttribute("data", data);
                        request.setAttribute("resultJson", resultJson);
                    } catch (Exception ex) {
                        Logger.getLogger(AppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    departments = new ArrayList<>();
                    selectedDepartment = request.getParameter("departmentID");

                    try {
                        userDepartments = new ArrayList<>(UserDepartmentConfigMgr.getInstance().getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));

                        for (WebBusinessObject userDepartmentWbo : userDepartments) {
                            departments.add(ProjectMgr.getInstance().getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }
                        if (departments.isEmpty()) {
                            WebBusinessObject wboTemp = new WebBusinessObject();
                            wboTemp.setAttribute("projectName", "لا يوجد");
                            wboTemp.setAttribute("projectID", "none");
                            departments.add(wboTemp);
                        } else {
                            if (selectedDepartment == null) {
                                selectedDepartment = (String) departments.get(0).getAttribute("projectID");
                            }
                        }
                        request.setAttribute("departments", departments);
                    } catch (Exception ex) {
                        Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    request.setAttribute("departmentID", request.getParameter("departmentID"));
                    request.setAttribute("fromDate", request.getParameter("beginDate"));
                    request.setAttribute("toDate", request.getParameter("endDate"));
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 43:
                    servedPage = "/docs/call_center/client_statistic.jsp";
                    cal = Calendar.getInstance();
                    sdf = new SimpleDateFormat("yyyy/MM/dd");
                    request.setAttribute("endDate", sdf.format(cal.getTime()));
                    cal.add(Calendar.MONTH, -1);
                    request.setAttribute("beginDate", sdf.format(cal.getTime()));
                    ratesList = new ArrayList<>();
                    projectMgr = ProjectMgr.getInstance();
                    try {
                        ratesList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("CL-RATE", "key4"));
                    } catch (Exception ex) {
                    }
                    request.setAttribute("ratesList", ratesList);
                    request.setAttribute("groups", UserGroupConfigMgr.getInstance().getAllUserGroupConfig((String) persistentUser.getAttribute("userId")));

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 44:
                    servedPage = "/docs/call_center/client_statistic.jsp";

                    ArrayList<WebBusinessObject> results = AppointmentMgr.getInstance().getCallCnterClientsStat(request.getParameter("beginDate"),
                            request.getParameter("endDate"), request.getParameter("rateID"),
                            request.getParameter("groupID"), request.getParameter("userID"));
                    ratesList = new ArrayList<>();
                    projectMgr = ProjectMgr.getInstance();
                    try {
                        ratesList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("CL-RATE", "key4"));
                    } catch (Exception ex) {
                    }
                    request.setAttribute("ratesList", ratesList);
                    request.setAttribute("beginDate", request.getParameter("beginDate"));
                    request.setAttribute("endDate", request.getParameter("endDate"));
                    request.setAttribute("rateID", request.getParameter("rateID"));
                    request.setAttribute("groupID", request.getParameter("groupID"));
                    request.setAttribute("userID", request.getParameter("userID"));
                    request.setAttribute("groups", UserGroupConfigMgr.getInstance().getAllUserGroupConfig((String) persistentUser.getAttribute("userId")));
                    request.setAttribute("data", results);

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 45:
                    out = response.getWriter();
                    if (request.getParameter("clientID") != null) {
                        wbo = appointmentMgr.getFutureAppointment(request.getParameter("clientID"));
                        if (wbo != null) {
                            wbo.setAttribute("status", "Ok");
                        } else {
                            wbo = new WebBusinessObject();
                            wbo.setAttribute("status", "No");
                        }
                    } else {
                        wbo = new WebBusinessObject();
                        wbo.setAttribute("status", "No");
                    }
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;

                case 46:
                    servedPage = "/jOQualityAssurance.jsp";

                    beginDate = request.getParameter("beginDate");
                    endDate = request.getParameter("endDate");

                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    loggegUserId = (String) loggedUser.getAttribute("userId");

                    ArrayList<WebBusinessObject> jOComplaintLst = appointmentMgr.getJOComplaint(beginDate, endDate, loggegUserId);

                    request.setAttribute("beginDate", beginDate);
                    request.setAttribute("endDate", endDate);
                    request.setAttribute("jOComplaintLst", jOComplaintLst);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 47:
                    servedPage = "/docs/calendar/future_emp_statistic.jsp";

                    projectMgr = ProjectMgr.getInstance();

                    selectedDepartment = request.getParameter("departmentID");

                    try {
                        userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                        userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                        departments = new ArrayList<>();

                        for (WebBusinessObject userDepartmentWbo : userDepartments) {
                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }

                        if (departments.isEmpty()) {
                            WebBusinessObject wboTemp = new WebBusinessObject();
                            wboTemp.setAttribute("projectName", "لا يوجد");
                            wboTemp.setAttribute("projectID", "none");
                            departments.add(wboTemp);
                        } else {
                            if (selectedDepartment == null) {
                                selectedDepartment = (String) departments.get(0).getAttribute("projectID");
                            }
                        }

                        request.setAttribute("departments", departments);
                    } catch (Exception ex) {
                        Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    request.setAttribute("departmentID", selectedDepartment);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 48:
                    servedPage = "/docs/calendar/future_emp_statistic.jsp";

                    projectMgr = ProjectMgr.getInstance();
                    appointmentMgr = AppointmentMgr.getInstance();

                    selectedDepartment = request.getParameter("departmentID");

                    try {
                        ArrayList<WebBusinessObject> userStatList = appointmentMgr.getFutureEmpStatistic(request.getParameter("depratmentID"), request.getParameter("beginDate"), request.getParameter("endDate"));

                        userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                        userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                        departments = new ArrayList<>();

                        for (WebBusinessObject userDepartmentWbo : userDepartments) {
                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }

                        if (departments.isEmpty()) {
                            WebBusinessObject wboTemp = new WebBusinessObject();
                            wboTemp.setAttribute("projectName", "لا يوجد");
                            wboTemp.setAttribute("projectID", "none");
                            departments.add(wboTemp);
                        } else {
                            if (selectedDepartment == null) {
                                selectedDepartment = (String) departments.get(0).getAttribute("projectID");
                            }
                        }

                        request.setAttribute("departments", departments);
                        request.setAttribute("beginDate", request.getParameter("beginDate"));
                        request.setAttribute("endDate", request.getParameter("endDate"));
                        request.setAttribute("data", userStatList);
                    } catch (Exception ex) {
                        Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    request.setAttribute("departmentID", selectedDepartment);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 49:
                    servedPage = "/docs/client/client_appointments_details.jsp";
                    String future = "ok";
                    try {
                        ArrayList<ArrayList<String>> clientAppntsist = new ArrayList<>();

                        if (request.getParameter("type").toString() == null || request.getParameter("type").toString().equals("")) {
                            clientAppntsist = notificationMgr.getFutureAppointmentByDateAndUser(request.getParameter("beginDate"), request.getParameter("endDate"), request.getParameter("departmentID"), request.getParameter("userID"), future);
                        } else {
                            clientAppntsist = notificationMgr.getFutureAppointmentByDateAndUserAndStatus(request.getParameter("type"), request.getParameter("beginDate"), request.getParameter("endDate"), request.getParameter("departmentID"), request.getParameter("userID"), future);
                        }

                        String appoitmentsJson = JSONValue.toJSONString(clientAppntsist);

                        request.setAttribute("appoitmentsJson", appoitmentsJson);
                    } catch (Exception ex) {
                        Logger.getLogger(AppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    request.setAttribute("userName", request.getParameter("userName"));
                    request.setAttribute("beginDate", request.getParameter("beginDate"));
                    request.setAttribute("endDate", request.getParameter("endDate"));
                    request.setAttribute("future", future);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 50:
                    servedPage = "/docs/Appointments/NotAnsweredApp.jsp";
                    beginDate = request.getParameter("beginDate");
                    endDate = request.getParameter("endDate");

                    session = request.getSession();
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    loggegUserId = (String) loggedUser.getAttribute("userId");
                    String calTyp = request.getParameter("calTyp");

                    AppointmentMgr appointmentMgr = AppointmentMgr.getInstance();

                    if (beginDate != null && !beginDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
                        ArrayList result = new ArrayList();
                        result = new ArrayList(appointmentMgr.getNotAnsweredAppointments(beginDate, endDate, loggegUserId, calTyp));
                        callResult = appointmentMgr.getCountOfNotAnsweredAndWrongApp(request.getParameter("beginDate"), request.getParameter("endDate"), loggegUserId);

                        if (!callResult.isEmpty()) {
                            dataList = new ArrayList();
                            int totalClientsCount = 0;

                            // populate series data map
                            for (WebBusinessObject clientCountWbo : callResult) {
                                dataEntryMap = new HashMap();
                                totalClientsCount += Integer.parseInt(clientCountWbo.getAttribute("Total").toString());

                                dataEntryMap.put("name", clientCountWbo.getAttribute("CallResult"));
                                dataEntryMap.put("y", Integer.parseInt(clientCountWbo.getAttribute("Total").toString()));

                                dataList.add(dataEntryMap);

                            }

                            String jsonCallResultText = JSONValue.toJSONString(dataList);

                            request.setAttribute("result", result);
                            request.setAttribute("totalCallResultCount", totalClientsCount);
                            request.setAttribute("callResult", callResult);
                            request.setAttribute("jsonCallResultText", jsonCallResultText);
                        }
                    }

                    request.setAttribute("calTyp", calTyp);
                    request.setAttribute("beginDate", beginDate);
                    request.setAttribute("endDate", endDate);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 51:
                    out = response.getWriter();
                    if (request.getParameter("appointmentID") != null) {
                        wbo = this.appointmentMgr.getOnSingleKey(request.getParameter("appointmentID"));
                        if (wbo != null) {
                            wbo.setAttribute("status", "ok");
                        } else {
                            wbo = new WebBusinessObject();
                            wbo.setAttribute("status", "no");
                        }
                    } else {
                        wbo = new WebBusinessObject();
                        wbo.setAttribute("status", "no");
                    }
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                case 52:
                    out = response.getWriter();
                    clientMgr = ClientMgr.getInstance();
                    WebBusinessObject res = clientMgr.getClientFirstAppointment(request.getParameter("clientID"));
                    if (res == null) {
                        res = new WebBusinessObject();
                        res.setAttribute("comment", "لا يوجد");
                        res.setAttribute("appointmentDate", "لا يوجد");
                        res.setAttribute("appointmentBy", "لا يوجد");
                        res.setAttribute("appointmentType", "لا يوجد");
                    }
                    out.write(Tools.getJSONObjectAsString(res));
                    break;
                case 53:
                    servedPage = "/docs/client/client_my_last_appointment.jsp";
                    from = request.getParameter("from");
                    to = request.getParameter("to");
                    campaignId = request.getParameter("campaignId");
                    projectMgr = ProjectMgr.getInstance();
                    clientMgr = ClientMgr.getInstance();
                    if (from != null && to != null) {
                        String toPlusOneDay = to;
                        try {
                            SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
                            Date d = formatter.parse(to);
                            Calendar calendar = Calendar.getInstance();
                            calendar.setTime(d);
                            calendar.add(Calendar.DATE, 1);
                            toPlusOneDay = formatter.format(calendar.getTime());
                        } catch (ParseException ex) {
                            logger.error(ex);
                        }
                        clients = clientMgr.getClientsLastAppointmentByOwner((String) persistentUser.getAttribute("userId"), from, toPlusOneDay, new ArrayList<WebBusinessObject>(), null,campaignId);
                        request.setAttribute("data", clients);
                        request.setAttribute("createdBy", request.getParameter("createdBy"));
                        request.setAttribute("from", from);
                        request.setAttribute("to", to);
                    }
                    defaultCampaign = "";
                    if (securityUser != null && securityUser.getDefaultCampaign() != null && !securityUser.getDefaultCampaign().isEmpty()) {
                        defaultCampaign = securityUser.getDefaultCampaign();
                        CampaignMgr campaignMgr = CampaignMgr.getInstance();
                        WebBusinessObject campaignWbo = campaignMgr.getOnSingleKey(defaultCampaign);
                        if (campaignWbo != null) {
                            defaultCampaign = (String) campaignWbo.getAttribute("campaignTitle");
                        } else {
                            defaultCampaign = "";
                        }
                    }
                    userProjects = new ArrayList<>();
                    try {
                        userProjects = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("1365240752318", "key2"));
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                    meetings = projectMgr.getMeetingProjects();
                    callResults = projectMgr.getCallResultsProjects();

                    request.setAttribute("defaultCampaign", defaultCampaign);
                    request.setAttribute("userProjects", userProjects);
                    request.setAttribute("meetings", meetings);
                    request.setAttribute("callResults", callResults);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 54:
                    out = response.getWriter();
                    appointmentMgr = AppointmentMgr.getInstance();
                    wbo = new WebBusinessObject();
                    WebBusinessObject objectXml = AppointmentNotificationMgr.getInstance().getOnSingleKey(request.getParameter("rowId"));
                    wbo.setAttribute("status", appointmentMgr.deteleAppointment(request.getParameter("rowId")) ? "Ok" : "No");
                    if ("Ok".equals(wbo.getAttribute("status"))) {
                        WebBusinessObject loggerWbo = new WebBusinessObject();
                        loggerWbo.setAttribute("objectXml", objectXml.getObjectAsXML());
                        loggerWbo.setAttribute("realObjectId", request.getParameter("rowId"));
                        loggerWbo.setAttribute("userId", securityUser.getUserId());
                        loggerWbo.setAttribute("objectName", objectXml.getAttribute("clientName") != null ? objectXml.getAttribute("clientName") : objectXml.getAttribute("mobile"));
                        loggerWbo.setAttribute("loggerMessage", "Appointment Deleted");
                        loggerWbo.setAttribute("eventName", "Delete");
                        loggerWbo.setAttribute("objectTypeId", "11");
                        loggerWbo.setAttribute("eventTypeId", "1");
                        loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                        LoggerMgr.getInstance().saveObject(loggerWbo);
                    }
                    out.print(Tools.getJSONObjectAsString(wbo));
                    break;

                case 55:
                    servedPage = "/docs/reports/lstEmpAppCmnt.jsp";
                    fromDateS = request.getParameter("fromDate");
                    toDateS = request.getParameter("toDate");
                    SimpleDateFormat oldFormat = new SimpleDateFormat("yyyy/MM/dd");
                    SimpleDateFormat nwFormat = new SimpleDateFormat("dd/MM/yyyy");
                    Date ftDate = new Date();
                    try {
                        ftDate = oldFormat.parse(fromDateS);
                        fromDateS = nwFormat.format(ftDate);

                        ftDate = oldFormat.parse(toDateS);
                        toDateS = nwFormat.format(ftDate);
                    } catch (ParseException ex) {
                        Logger.getLogger(AppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    String reportType = request.getParameter("reportType");
                    cal = Calendar.getInstance();

                    if (fromDateS != null && toDateS != null && request.getParameter("createdBy") != null) {
                        clients = notificationMgr.lstEmpAppCmnt(request.getParameter("createdBy"), fromDateS, toDateS);
                    } else {
                        clients = new ArrayList<WebBusinessObject>();
                    }
                    ArrayList<WebBusinessObject> usersList = userMgr.getUsersInMyReportDepartments((String) persistentUser.getAttribute("userId"));
                    if (usersList.isEmpty()) {
                        usersList = new ArrayList<>(userMgr.getCashedTable());
                    } else {
                        usersList.add(userMgr.getOnSingleKey((String) persistentUser.getAttribute("userId")));
                    }
                    request.setAttribute("usersList", usersList);
                    request.setAttribute("page", servedPage);
                    request.setAttribute("fromDate", fromDateS);
                    request.setAttribute("toDate", toDateS);
                    request.setAttribute("reportType", reportType);
                    request.setAttribute("userID", (String) persistentUser.getAttribute("userId"));
                    request.setAttribute("type", request.getParameter("type"));
                    request.setAttribute("createdBy", request.getParameter("createdBy"));
                    request.setAttribute("clients", clients);
                    this.forwardToServedPage(request, response);
                    break;

                case 56:
                    servedPage = "/docs/calendar/emp_statistic_by_group.jsp";

                    projectMgr = ProjectMgr.getInstance();
                    appointmentMgr = AppointmentMgr.getInstance();

                    String selectedGroup = request.getParameter("groupID");

                    try {
                        ArrayList<WebBusinessObject> userStatList = appointmentMgr.getEmpStatisticByGroup(request.getParameter("groupID"), request.getParameter("beginDate"), request.getParameter("endDate"));

                        userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                        userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                        departments = new ArrayList<>();

                        for (WebBusinessObject userDepartmentWbo : userDepartments) {
                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }

                        UserGroupConfigMgr userGroupConfigMgr = UserGroupConfigMgr.getInstance();
                        List<WebBusinessObject> groups = userGroupConfigMgr.getAllUserGroupConfig((String) loggedUser.getAttribute("userId"));

                        if (departments.isEmpty()) {
                            WebBusinessObject wboTemp = new WebBusinessObject();
                            wboTemp.setAttribute("projectName", "لا يوجد");
                            wboTemp.setAttribute("projectID", "none");
                            departments.add(wboTemp);
                        } else {
                            if (selectedGroup == null) {
                                selectedDepartment = (String) groups.get(0).getAttribute("group_id");
                            }
                        }

                        request.setAttribute("groups", groups);
                        request.setAttribute("departments", departments);
                        request.setAttribute("beginDate", request.getParameter("beginDate"));
                        request.setAttribute("endDate", request.getParameter("endDate"));
                        request.setAttribute("data", userStatList);
                    } catch (Exception ex) {
                        Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    request.setAttribute("groupID", selectedGroup);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 57:
                    PDFTools pdfTolls = new PDFTools();

                    StringBuilder appointmentClause = new StringBuilder();

                    if (request.getParameter("repType").toString().equals("meeting")) {
                        appointmentClause.append(" OPTION2 like '%meeting%' and OPTION9 in ('attended') AND ");
                    } else {
                        appointmentClause.append(" OPTION2 like '%call%' and OPTION9 not in ('not answered','wrong number') AND ");
                    }

                    appointmentClause.append("TRUNC(CREATION_TIME) BETWEEN to_date('" + request.getParameter("beginDate") + "','yyyy/mm/dd') AND to_date('" + request.getParameter("endDate") + "','yyyy/mm/dd') AND ");
                    appointmentClause.append("TRUNC(APPOINTMENT_DATE) BETWEEN to_date('" + request.getParameter("beginDate") + "','yyyy/mm/dd') AND to_date('" + request.getParameter("endDate") + "','yyyy/mm/dd') AND ");
                    appointmentClause.append("user_id = '" + request.getParameter("userID") + "'");

                    if (request.getParameter("projectID").toString() == null || request.getParameter("projectID").toString().isEmpty() || request.getParameter("projectID").toString().equals("")) {
                        appointmentClause.append("");
                    } else {
                        appointmentClause.append(" and APPOINTMENT_FOR IN (SELECT USER_ID FROM USERS WHERE USER_ID IN (SELECT EMP_ID FROM EMP_MGR WHERE MGR_ID IN (SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID ='" + request.getParameter("projectID") + "')) UNION SELECT OPTION_ONE USER_ID FROM PROJECT WHERE PROJECT_ID ='" + request.getParameter("projectID") + "')");
                    }

                    HashMap parameters = new HashMap();
                    parameters.put("empName", request.getParameter("userName"));
                    parameters.put("beginDate", request.getParameter("beginDate"));
                    parameters.put("endDate", request.getParameter("endDate"));
                    parameters.put("user_id", request.getParameter("userID"));
                    parameters.put("applointmentClause", appointmentClause);

                    pdfTolls.generatePdfReport("clientAppDetails", parameters, getServletContext(), response);
                    break;

                case 58:
                    servedPage = "/docs/Appointments/ClientViewsInSpecificDay.jsp";
                    clientID = request.getParameter("clientId");
                    date = request.getParameter("date");
                    ArrayList<WebBusinessObject> viewsLst = new ArrayList<WebBusinessObject>();

                    clientProductMgr = ClientProductMgr.getInstance();
                    if (clientID != null && date != null) {
                        viewsLst = new ArrayList<WebBusinessObject>(clientProductMgr.getViewsUnitByDate(clientID, date));
                        request.setAttribute("viewsLst", viewsLst);
                    }
                    request.setAttribute("clientID", clientID);
                    request.setAttribute("date", date);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 59:
                    servedPage = "/docs/Appointments/ClientPaymentInSpecificDay.jsp";
                    clientID = request.getParameter("clientId");
                    date = request.getParameter("date");
                    ArrayList<WebBusinessObject> paymentLst = new ArrayList<WebBusinessObject>();
                    PaymentPlanMgr paymentPlanMgr = PaymentPlanMgr.getInstance();

                    clientProductMgr = ClientProductMgr.getInstance();
                    if (clientID != null && date != null) {
                        try {
                            paymentLst = paymentPlanMgr.getPayPlanInSpecificDay(clientID, date);
                        } catch (UnsupportedTypeException ex) {
                            Logger.getLogger(AppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (NoSuchColumnException ex) {
                            Logger.getLogger(AppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        request.setAttribute("paymentLst", paymentLst);
                    }
                    request.setAttribute("clientID", clientID);
                    request.setAttribute("date", date);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 60:
                    pdfTolls = new PDFTools();

                    appointmentClause = new StringBuilder();

                    if (request.getParameter("userID").toString() == null || request.getParameter("userID").toString().isEmpty() || request.getParameter("userID").toString().equals("") || request.getParameter("userID").toString().equals("all")) {
                        appointmentClause.append("");
                    } else {
                        appointmentClause.append("users.user_id = '" + request.getParameter("userID") + "' AND ");
                    }

                    if (request.getParameter("departmentID").toString() == null || request.getParameter("departmentID").toString().isEmpty() || request.getParameter("departmentID").toString().equals("") || request.getParameter("departmentID").toString().equals("all")) {
                        appointmentClause.append("");
                    } else {
                        appointmentClause.append("APPOINTMENT_FOR IN (SELECT USER_ID FROM USERS WHERE USER_ID IN (SELECT EMP_ID FROM EMP_MGR WHERE MGR_ID IN (SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID IN (").append(request.getParameter("departmentID")).append("))) UNION SELECT OPTION_ONE USER_ID FROM PROJECT WHERE PROJECT_ID IN (").append(request.getParameter("departmentID")).append(")) AND ");
                    }

                    if (request.getParameter("rateID").toString() == null || request.getParameter("rateID").toString().isEmpty() || request.getParameter("rateID").toString().equals("") || request.getParameter("rateID").toString().equals("all")) {
                        appointmentClause.append("");
                    } else {
                        appointmentClause.append("CR.RATE_ID = '" + request.getParameter("rateID") + "' and ");
                    }
                    
                    if (request.getParameter("campaignID").toString() == null || request.getParameter("campaignID").toString().isEmpty() || request.getParameter("campaignID").toString().equals("") || request.getParameter("campaignID").toString().equals("all")) {
                        appointmentClause.append("");
                    } else {
                        appointmentClause.append("AP.CLIENT_ID IN (SELECT CLIENT_ID FROM CLIENT_CAMPAIGN WHERE CAMPAIGN_ID IN ( '" + request.getParameter("campaignID") + "')) and ");
                    }
                    
                    if (request.getParameter("result") != null && !request.getParameter("result").equals("all")) {
                        appointmentClause.append(" OPTION9 = '").append(request.getParameter("result")).append("' and ");
                    }

                    if (request.getParameter("dateType").toString().equals("registration")) {
                        appointmentClause.append(" TRUNC(CL.CREATION_TIME) BETWEEN to_date('" + request.getParameter("fromDate") + "','yyyy/mm/dd') AND to_date('" + request.getParameter("toDate") + "','yyyy/mm/dd') AND ");
                    } else {
                        appointmentClause.append(" TRUNC(AP.CURRENT_STATUS_SINCE) BETWEEN to_date('" + request.getParameter("fromDate") + "','yyyy/mm/dd') AND to_date('" + request.getParameter("toDate") + "','yyyy/mm/dd') AND ");
                    }
                    
                    appointmentClause.append(" AP.CURRENT_STATUS IN ('24', '25', '26', '29') and ");
                    appointmentClause.append(" AP.OPTION2 LIKE '%"+request.getParameter("appointmentType")+"%'");

                    parameters = new HashMap();
                    parameters.put("beginDate", request.getParameter("fromDate"));
                    parameters.put("endDate", request.getParameter("toDate"));
                    parameters.put("applointmentClause", appointmentClause);

                    pdfTolls.generatePdfReport("EmployeeClientAppoints", parameters, getServletContext(), response);
                    break;
                case 61:
                    servedPage = "/docs/Appointments/repeated_meetings.jsp";
                    java.sql.Date beginDateD = null;
                    java.sql.Date endDateD = null;
                    sdf = new SimpleDateFormat("yyyy/MM/dd");
                    try {
                        if (request.getParameter("beginDate") != null) {
                            beginDateD = new java.sql.Date(sdf.parse(request.getParameter("beginDate")).getTime());
                        }
                        if (request.getParameter("endDate") != null) {
                            endDateD = new java.sql.Date(sdf.parse(request.getParameter("endDate")).getTime());
                        }
                    } catch (ParseException ex) {
                        Logger.getLogger(AppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    clientMgr = ClientMgr.getInstance();
                    if (beginDateD != null && endDateD != null) {
                        clientMgr = ClientMgr.getInstance();
                        results = clientMgr.getRepeatedMeetingsClients(beginDateD, endDateD, request.getParameter("type").equals("repeated"));
                        request.setAttribute("data", results);
                        request.setAttribute("beginDate", request.getParameter("beginDate"));
                        request.setAttribute("endDate", request.getParameter("endDate"));
                    } else {
                        c = Calendar.getInstance();
                        request.setAttribute("endDate", sdf.format(c.getTime()));
                        c.add(Calendar.MONTH, -1);
                        request.setAttribute("beginDate", sdf.format(c.getTime()));
                    }
                    request.setAttribute("type", request.getParameter("type"));
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 62:
                    projectMgr = ProjectMgr.getInstance();
                    appointmentMgr = AppointmentMgr.getInstance();
                    try {
                        ArrayList<WebBusinessObject> userStatList = appointmentMgr.getEmpStatWithNewClient(request.getParameter("depratmentID"), request.getParameter("beginDate"), request.getParameter("endDate"),session);
                        DecimalFormat decFormat = new DecimalFormat("0.00");
                        for (WebBusinessObject userStatWbo : userStatList) {
                            userStatWbo.setAttribute("call_duration", decFormat.format(Double.parseDouble(userStatWbo.getAttribute("call_duration").toString()) / 60.0));
                            userStatWbo.setAttribute("meeting_duration", decFormat.format(Double.parseDouble(userStatWbo.getAttribute("meeting_duration").toString()) / 60.0));
                        }
                        String headersExc[] = {"#", "Employee Name", "Total All Client", "Rated Calls", "UnRated Calls", "Total Calls Time", "Visits", "Total Visits Time", "Total Clients No.", "Visits Clients"};
                        String attributesExc[] = {"Number", "userName", "clientAll", "call", "call_duration", "meeting", "meeting_duration", "total_clients", "visitClientsCount"};
                        String dataTypesExc[] = {"", "String", "String", "String", "String", "String", "String", "String", "String", "String"};
                        headerStr = new String[1];
                        headerStr[0] = "Employees Statistics";
                        workBook = Tools.createExcelReport("Employees Statistics", headerStr, null, headersExc, attributesExc, dataTypesExc, userStatList);
                        c = Calendar.getInstance();
                        fileDate = c.getTime();
                        df = new SimpleDateFormat("dd-MM-yyyy");
                        reportDate = df.format(fileDate);
                        filename = "EmployeesStatistics" + reportDate;
                        servletOutputStream = response.getOutputStream();
                        bos = new ByteArrayOutputStream();
                        try {
                            workBook.write(bos);
                        } finally {
                            bos.close();
                        }
                        bytes = bos.toByteArray();
                        response.setContentType("application/vnd.ms-excel");
                        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + ".xls\"");
                        response.setContentLength(bytes.length);
                        servletOutputStream.write(bytes, 0, bytes.length);
                        servletOutputStream.flush();
                        servletOutputStream.close();
                    } catch (Exception ex) {
                        Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    break;
                    
                case 63:
                servedPage = "/docs/reports/getClientChronOrder.jsp";
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                String empId = request.getParameter("empId");
                
                clientMgr = ClientMgr.getInstance();
                
                if(beginDate != null && endDate != null){
                    ArrayList<WebBusinessObject> clientsLst = new ArrayList<WebBusinessObject>();
                    clientsLst = clientMgr.getClientChronOrder(beginDate, endDate, empId);
                    request.setAttribute("clientsLst", clientsLst);
                }
                
                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("YYYY/MM/dd");
                
                if(endDate == null ){
                    endDate = sdf.format(cal.getTime());
                }
                
                cal.add(Calendar.DAY_OF_WEEK, -1);
                if(beginDate == null ){
                    beginDate = sdf.format(cal.getTime());
                }
                
                List<WebBusinessObject> employeesLst  = userMgr.getAllUsers();
                
                request.setAttribute("empId", empId);
                request.setAttribute("employeesLst", employeesLst);
                request.setAttribute("beginDate", beginDate);
                request.setAttribute("endDate", endDate);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;   
                
                
                case 64:
                    servedPage = "/docs/client/clientsCommChannels.jsp";
                    SeasonMgr seasonMgr = SeasonMgr.getInstance();
                    clientMgr = ClientMgr.getInstance();
                    ArrayList<WebBusinessObject> comCahhnels = new ArrayList<WebBusinessObject> ();
                    ArrayList<WebBusinessObject> clientsLst = new ArrayList<WebBusinessObject> ();
                    fromDateS = request.getParameter("fromDate");
                    toDateS = request.getParameter("toDate");
                    String groupID = request.getParameter("groupID");
                    cal = Calendar.getInstance();
                    sdf = new SimpleDateFormat("yyyy/MM/dd");
                    if (toDateS == null) {
                        toDateS = sdf.format(cal.getTime());
                        toDate = cal.getTime();
                    }
                    if (fromDateS == null) {
                        cal.add(Calendar.DATE, -7);
                        fromDateS = sdf.format(cal.getTime());
                        fromDate = cal.getTime();
                    }
                    try {
                        fromDate = sdf.parse(fromDateS);
                        toDate = sdf.parse(toDateS);
                    } catch (ParseException ex) {
                        fromDate = new Date();
                        toDate = new Date();
                    }

                    if (request.getParameter("chngCt") != null && request.getParameter("chngCt").equals("1")){
                        String clientsID[] = request.getParameterValues("clientcheck");
                        String comChannel = request.getParameter("comChannel");
                        clientMgr.chngComChannel(clientsID, comChannel);
                    }

                    UserGroupConfigMgr userGroupConfigMgr = UserGroupConfigMgr.getInstance();
                    GroupMgr groupMgr = GroupMgr.getInstance();
                    ArrayList<WebBusinessObject> groupsList = new ArrayList<>();
                    ArrayList<WebBusinessObject> userGroups = new ArrayList<WebBusinessObject>();
                     {
                        try {
                            userGroups = userGroupConfigMgr.getOnArbitraryKey2(loggedUser.getAttribute("userId").toString(), "key2");
                        } catch (Exception ex) {
                            Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                    if (!userGroups.isEmpty()) {
                        for (WebBusinessObject userGroupsWbo : userGroups) {
                            WebBusinessObject groupWbo = groupMgr.getOnSingleKey(userGroupsWbo.getAttribute("group_id").toString());
                            groupsList.add(groupWbo);
                        }
                    }
                    request.setAttribute("groupsList", groupsList);
                    comCahhnels = seasonMgr.getCashedTableAsArrayList();
                    if (groupID != null) {
                        clientsLst = clientMgr.getClientsWithoutComChannels(fromDate, toDate, groupID);
                        request.setAttribute("groupID", groupID);
                    }

                    request.setAttribute("clientsLst", clientsLst);
                    request.setAttribute("comCahhnels", comCahhnels);
                    request.setAttribute("fromDate", fromDateS);
                    request.setAttribute("toDate", toDateS);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 65:
                    servedPage = "/docs/client/existing_clients_log.jsp";
                    clientMgr = ClientMgr.getInstance();
                    clients = new ArrayList<WebBusinessObject>();
                    String groupId = request.getParameter("groupId");
                    if (request.getParameter("startDate") != null) {
                        sdf = new SimpleDateFormat("yyyy-MM-dd");
                        try {
                            clients = clientMgr.getExistingClientsLog(new java.sql.Date(sdf.parse(request.getParameter("startDate")).getTime()),new java.sql.Date(sdf.parse(request.getParameter("endDate")).getTime()), groupId);
                        } catch (ParseException ex) { clients = new ArrayList<>(); }
                    }
                    userGroupConfigMgr = UserGroupConfigMgr.getInstance();
                    groupMgr = GroupMgr.getInstance();
                    groupsList = new ArrayList<>();
                    userGroups = new ArrayList<WebBusinessObject>();
                    { try {
                            userGroups = userGroupConfigMgr.getOnArbitraryKey2(loggedUser.getAttribute("userId").toString(), "key2");
                        } catch (Exception ex) { Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);} }
                    if (!userGroups.isEmpty()) {
                        for (WebBusinessObject userGroupsWbo : userGroups) {
                            WebBusinessObject groupWbo = groupMgr.getOnSingleKey(userGroupsWbo.getAttribute("group_id").toString());
                            groupsList.add(groupWbo);
                        }
                    }
                    request.setAttribute("groupsList", groupsList);  request.setAttribute("groupId", request.getParameter("groupId"));
                    request.setAttribute("clients", clients);
                    request.setAttribute("startDate", request.getParameter("startDate"));
                    request.setAttribute("endDate", request.getParameter("endDate"));
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;  
                    
                case 66:
                    appointmentsList = new ArrayList<>();
                    appointmentMgr = AppointmentMgr.getInstance();
                    servedPage = "/docs/client/edit_client_appointments.jsp";
                    dateType = request.getParameter("dateType");
                    fromDateS = request.getParameter("fromDate");
                    toDateS = request.getParameter("toDate");
                    campaignID = request.getParameter("campaignID");
                    campaignsList = new ArrayList<>(campaignMgr.getCashedTable());
                    request.setAttribute("campaignsList", campaignsList);
                    cal = Calendar.getInstance();
                    sdf = new SimpleDateFormat("yyyy/MM/dd");
                    fromDate = new Date();
                    toDate = new Date();
                    if (toDateS == null) {
                        toDateS = sdf.format(cal.getTime());
                        toDate = cal.getTime();
                    }
                    if (fromDateS == null) {
                        cal.add(Calendar.MONTH, -1);
                        fromDateS = sdf.format(cal.getTime());
                        fromDate = cal.getTime();
                    }
                    createdBy = request.getParameter("createdBy");
                    rateID = request.getParameter("rateID");

                    userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                    projectMgr = ProjectMgr.getInstance();
                    selectedDepartment = request.getParameter("departmentID");
                    departments = new ArrayList<>();
                    try {
                        userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                        for (WebBusinessObject userDepartmentWbo : userDepartments) {
                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }
                        if (departments.isEmpty()) {
                            WebBusinessObject wboTemp = new WebBusinessObject();
                            wboTemp.setAttribute("projectName", "لا يوجد");
                            wboTemp.setAttribute("projectID", "none");
                            departments.add(wboTemp);
                            list = new ArrayList<>();
                        } else {
                            if (selectedDepartment == null) {
                                selectedDepartment = (String) departments.get(0).getAttribute("projectID");
                            } else if (selectedDepartment.equalsIgnoreCase("all")) {
                                String[] departmentIDs = new String[departments.size()];
                                int index = 0;
                                for (WebBusinessObject temp : departments) {
                                    departmentIDs[index++] = (String) temp.getAttribute("projectID");
                                }
                                selectedDepartment = Tools.concatenation(departmentIDs, ",");
                            }
                            list = notificationMgr.getAppointmentByDate(fromDate, toDate, selectedDepartment, null);
                        }
                    } catch (Exception ex) {
                        Logger.getLogger(AppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    request.setAttribute("departments", departments);

                    employeeList = userMgr.getEmployeeByDepartmentId(selectedDepartment, null, null);
                    request.setAttribute("usersList", employeeList);

                    if (request.getAttribute("reportType") != null || request.getParameter("reportType") != null) {
                        request.setAttribute("reportType", "true");
                    }
                    if (request.getParameter("reportType") != null) {
                        createdBy = (String) persistentUser.getAttribute("userId");
                    }
                    if (createdBy != null) {
                        if (createdBy.equals("all")) {
                            createdBy = "";
                        }
                        clients = appointmentMgr.getAppointmentsClients(fromDateS, toDateS, createdBy, employeeList, rateID, request.getParameter("appointmentType"), request.getParameter("result"), dateType, campaignID);
                        Map<String, ArrayList<WebBusinessObject>> dataResult = new HashMap<>();
                        for (WebBusinessObject clientTempWbo : clients) {
                            try {
                                appointmentsList = appointmentMgr.getClientAppointments((String) clientTempWbo.getAttribute("clientID"), createdBy, fromDateS, toDateS, request.getParameter("appointmentType"), request.getParameter("result"), dateType);
                                dataResult.put((String) clientTempWbo.getAttribute("clientID"), appointmentsList);
                            } catch (Exception ex) {
                                Logger.getLogger(CommentsServlet.class.getName()).log(Level.SEVERE, null, ex);
                            }
                        }
                        request.setAttribute("dataResult", dataResult);
                        request.setAttribute("data", clients);
                    }
                    ratesList = new ArrayList<>();
                    try {
                        ratesList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("CL-RATE", "key4"));
                    } catch (Exception ex) {
                    }
                    //dateType
                    request.setAttribute("campaignID", campaignID);
                    request.setAttribute("dateType", dateType);
                    request.setAttribute("ratesList", ratesList);
                    request.setAttribute("departmentID", selectedDepartment);
                    request.setAttribute("fromDate", fromDateS);
                    request.setAttribute("toDate", toDateS);
                    request.setAttribute("createdBy", createdBy);
                    request.setAttribute("result", request.getParameter("result"));
                    request.setAttribute("rateID", rateID);
                    request.setAttribute("appointmentType", request.getParameter("appointmentType"));
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;  
                    
                case 67:
                    appointmentMgr = AppointmentMgr.getInstance();
                    String appID = request.getParameter("appointmentID");
                    String newResult = request.getParameter("newResult");
                    
                    boolean updateRes = appointmentMgr.updateAppointmentResult(appID, newResult);
                    wbo = new WebBusinessObject();
                    if(updateRes == true){
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                    out = response.getWriter();
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                    
                case 68:
                servedPage = "/docs/reports/get_customized_clients_without_com_channel.jsp";
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                String employee = request.getParameter("employee");
                groupId = request.getParameter("groupId");
                
                int channelTotal = 0;
                userGroupConfigMgr = UserGroupConfigMgr.getInstance();
                groupMgr = GroupMgr.getInstance();
                groupsList = new ArrayList<>();
                userGroups = new ArrayList<WebBusinessObject>();
                
                {
                    try {
                        userGroups = userGroupConfigMgr.getOnArbitraryKey2(loggedUser.getAttribute("userId").toString(), "key2");
                    } catch (Exception ex) {
                        Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                if (!userGroups.isEmpty()) {
                        for (WebBusinessObject userGroupsWbo : userGroups) {
                            WebBusinessObject groupWbo = groupMgr.getOnSingleKey(userGroupsWbo.getAttribute("group_id").toString());
                            groupsList.add(groupWbo);
                        }
                    }
                request.setAttribute("groupsList", groupsList);
                request.setAttribute("groupId", request.getParameter("groupId"));
                clientMgr = ClientMgr.getInstance();
                if(beginDate != null && endDate != null){
                    ArrayList<WebBusinessObject> customizedClients = new ArrayList<WebBusinessObject>();
                    ArrayList<WebBusinessObject> customizedClientsChart = new ArrayList<WebBusinessObject>();
                    customizedClients = clientMgr.getCustomizedClients(beginDate, endDate, employee, groupId);
                    if(employee == null ||  employee.equals("")){
                        customizedClientsChart = clientMgr.getCustomizedClientsChart(beginDate, endDate, employee, groupId);
                        String jsonText = Tools.getJSONArrayAsString(customizedClientsChart);
                        request.setAttribute("jsonText", jsonText);
                    }
                    request.setAttribute("customizedClients", customizedClients);
                }
                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("YYYY/MM/dd");
                
                if(endDate == null ){
                    endDate = sdf.format(cal.getTime());
                }
                
                cal.add(Calendar.DAY_OF_WEEK, -1);
                if(beginDate == null ){
                    beginDate = sdf.format(cal.getTime());
                }
                request.setAttribute("employee", employee);
                request.setAttribute("beginDate", beginDate);
                request.setAttribute("endDate", endDate);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;    
                case 69:
                    servedPage = "/docs/calendar/emp_statistic_detailed.jsp";
                    projectMgr = ProjectMgr.getInstance();
                    selectedDepartment = request.getParameter("departmentID");
                    if (selectedDepartment != null) {
                        appointmentMgr = AppointmentMgr.getInstance();
                        ArrayList<WebBusinessObject> userStatList = appointmentMgr.getEmpStatistic(request.getParameter("depratmentID"), request.getParameter("beginDate"), request.getParameter("endDate"));
                        request.setAttribute("data", userStatList);
                        try {
                            request.setAttribute("callSum", userStatList.stream().mapToLong(w -> (Long.valueOf(w.getAttribute("call").toString()))).sum() + "");
                            request.setAttribute("callDurationSum", userStatList.stream().mapToDouble(w -> (Double.valueOf(w.getAttribute("call_duration").toString()))).sum() + "");
                            request.setAttribute("meetingSum", userStatList.stream().mapToLong(w -> (Long.valueOf(w.getAttribute("meeting").toString()))).sum() + "");
                            request.setAttribute("tsMeetingSum", userStatList.stream().mapToLong(w -> (Long.valueOf(w.getAttribute("tsMeeting").toString()))).sum() + "");
                            request.setAttribute("slsMeetingSum", userStatList.stream().mapToLong(w -> (Long.valueOf(w.getAttribute("slsMeeting").toString()))).sum() + "");
                            request.setAttribute("bkrMeetingSum", userStatList.stream().mapToLong(w -> (Long.valueOf(w.getAttribute("bkrMeeting").toString()))).sum() + "");
                            request.setAttribute("meetingDurationSum", userStatList.stream().mapToDouble(w -> Double.valueOf(w.getAttribute("meeting_duration").toString())).sum() + "");
                            request.setAttribute("totalClientsSum", userStatList.stream().mapToLong(w -> (Long.valueOf(w.getAttribute("total_clients").toString()))).sum() + "");
                            request.setAttribute("visitClientsSum", userStatList.stream().mapToLong(w -> Long.valueOf(w.getAttribute("visitClientsCount").toString())).sum() + "");
                        } catch (Exception e) {
                            request.setAttribute("callSum", "0");
                            request.setAttribute("callDurationSum", "0");
                            request.setAttribute("meetingSum", "0");
                            request.setAttribute("tsMeetingSum", "0");
                            request.setAttribute("slsMeetingSum", "0");
                            request.setAttribute("bkrMeetingSum", "0");
                            request.setAttribute("meetingDurationSum", "0");
                            request.setAttribute("totalClientsSum", "0");
                            request.setAttribute("visitClientsSum", "0");
                        }
                    }
                    try {
                        userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                        userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                        departments = new ArrayList<>();
                        for (WebBusinessObject userDepartmentWbo : userDepartments) {
                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }
                        if (departments.isEmpty()) {
                            WebBusinessObject wboTemp = new WebBusinessObject();
                            wboTemp.setAttribute("projectName", "لا يوجد");
                            wboTemp.setAttribute("projectID", "none");
                            departments.add(wboTemp);
                        } else {
                            if (selectedDepartment == null) {
                                selectedDepartment = (String) departments.get(0).getAttribute("projectID");
                            }
                        }
                        request.setAttribute("departments", departments);
                    } catch (Exception ex) {
                        Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    request.setAttribute("departmentID", selectedDepartment);
                    request.setAttribute("beginDate", request.getParameter("beginDate"));
                    request.setAttribute("endDate", request.getParameter("endDate"));
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 70:
                    projectMgr = ProjectMgr.getInstance();
                    appointmentMgr = AppointmentMgr.getInstance();
                    try {
                        ArrayList<WebBusinessObject> userStatList = appointmentMgr.getEmpStatistic(request.getParameter("depratmentID"), request.getParameter("beginDate"), request.getParameter("endDate"));
                        DecimalFormat decFormat = new DecimalFormat("0.00");
                        for (WebBusinessObject userStatWbo : userStatList) {
                            userStatWbo.setAttribute("call_duration", decFormat.format(Double.parseDouble(userStatWbo.getAttribute("call_duration").toString()) / 60.0));
                            userStatWbo.setAttribute("meeting_duration", decFormat.format(Double.parseDouble(userStatWbo.getAttribute("meeting_duration").toString()) / 60.0));
                        }
                        String headersExc[] = {"#", "Employee Name", "Answered Calls", "Total Calls Time", "Visits", "TS Visits", "SLS Visits", "Total Visits Time", "Total Clients No.", "Visits Clients"};
                        String attributesExc[] = {"Number", "userName", "call", "call_duration", "meeting", "tsMeeting", "slsMeeting", "meeting_duration", "total_clients", "visitClientsCount"};
                        String dataTypesExc[] = {"", "String", "String", "String", "String", "String", "String", "String", "String", "String"};
                        headerStr = new String[1];
                        headerStr[0] = "Detailed Employees Statistics";
                        workBook = Tools.createExcelReport("Detailed Employees Statistics", headerStr, null, headersExc, attributesExc, dataTypesExc, userStatList);
                        c = Calendar.getInstance();
                        fileDate = c.getTime();
                        df = new SimpleDateFormat("dd-MM-yyyy");
                        reportDate = df.format(fileDate);
                        filename = "DetailedEmployeesStatistics" + reportDate;
                        servletOutputStream = response.getOutputStream();
                        bos = new ByteArrayOutputStream();
                        try {
                            workBook.write(bos);
                        } finally {
                            bos.close();
                        }
                        bytes = bos.toByteArray();
                        response.setContentType("application/vnd.ms-excel");
                        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + ".xls\"");
                        response.setContentLength(bytes.length);
                        servletOutputStream.write(bytes, 0, bytes.length);
                        servletOutputStream.flush();
                        servletOutputStream.close();
                    } catch (Exception ex) {
                        Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    break;
                case 71:
                    servedPage = "/docs/client/future_client_appointments.jsp";
                    appointments = new ArrayList<>();
                    try {
                        appointmentMgr = AppointmentMgr.getInstance();
                        appointments = appointmentMgr.getFutureClientAppointments(request.getParameter("clientID"), (String) persistentUser.getAttribute("userId"));
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                    request.setAttribute("appointments", appointments);
                    this.forward(servedPage, request, response);
                    break;
                case 72:
                    appointmentMgr = AppointmentMgr.getInstance();
                    appID = request.getParameter("appointmentID");
                    String newType = request.getParameter("newType");
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("status", appointmentMgr.updateAppointmentMeetingType(appID, newType) ? "ok" : "no");
                    out = response.getWriter();
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                case 73:
                    appointmentMgr = AppointmentMgr.getInstance();
                    sdf = new SimpleDateFormat("yyyy/MM/dd");
                    try {
                        wbo.setAttribute("appointmentNo", appointmentMgr.getAppointmentsCount(request.getParameter("userID"),
                                new java.sql.Date(sdf.parse(request.getParameter("meetingDate")).getTime())));
                    } catch (ParseException ex) {
                        wbo.setAttribute("appointmentNo", 0);
                    }
                    out = response.getWriter();
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                case 74:
                    servedPage = "/docs/client/client_appointments_details.jsp";

                    try {
                        ArrayList<ArrayList<String>> clientAppntsist = new ArrayList<>();

                        if (request.getParameter("type") == null || request.getParameter("type").equals("")) {
                            clientAppntsist = notificationMgr.getAppointmentByDateAndUser(request.getParameter("beginDate"), request.getParameter("endDate"), request.getParameter("departmentID"), request.getParameter("userID"));
                        } else {
                            clientAppntsist = notificationMgr.getUserApptmentForFialCall(request.getParameter("type"), request.getParameter("beginDate"), request.getParameter("endDate"), request.getParameter("departmentID"), request.getParameter("userID"));
                        }

                        String appoitmentsJson = JSONValue.toJSONString(clientAppntsist);

                        request.setAttribute("appoitmentsJson", appoitmentsJson);
                    } catch (Exception ex) {
                        Logger.getLogger(AppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    request.setAttribute("userID", request.getParameter("userID"));
                    request.setAttribute("userName", request.getParameter("userName"));
                    request.setAttribute("departmentID", request.getParameter("departmentID"));
                    request.setAttribute("repType", request.getParameter("type"));

                    request.setAttribute("beginDate", request.getParameter("beginDate"));
                    request.setAttribute("endDate", request.getParameter("endDate"));

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 75:
                    servedPage = "/docs/client/client_uni_appntmnt_details.jsp";

                    try {
                        ArrayList<ArrayList<String>> clientAppntsist = new ArrayList<>();

                        clientAppntsist = notificationMgr.getUniqueUserAppointment(request.getParameter("departmentID"), request.getParameter("userID"), request.getParameter("total"), request.getParameter("beginDate"), request.getParameter("endDate"));

                        String appoitmentsJson = JSONValue.toJSONString(clientAppntsist);

                        request.setAttribute("appoitmentsJson", appoitmentsJson);
                    } catch (Exception ex) {
                        Logger.getLogger(AppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    request.setAttribute("userID", request.getParameter("userID"));
                    request.setAttribute("userName", request.getParameter("userName"));
                    request.setAttribute("departmentID", request.getParameter("departmentID"));

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    case 76:
                        WebBusinessObject wboApp=new WebBusinessObject();
                        ArrayList<WebBusinessObject> appWbo=new ArrayList<WebBusinessObject>();
                    try {
                        ArrayList<ArrayList<String>> clientAppntsist = new ArrayList<>();

                        if (request.getParameter("type") == null || request.getParameter("type").equals("")) {
                            clientAppntsist = notificationMgr.getAppointmentByDateAndUser(request.getParameter("beginDate"), request.getParameter("endDate"), request.getParameter("departmentID"), request.getParameter("userID"));
                        } else {
                            clientAppntsist = notificationMgr.getAppointmentByDateAndUserAndStatus(request.getParameter("type"), request.getParameter("beginDate"), request.getParameter("endDate"), request.getParameter("departmentID"), request.getParameter("userID"));
                        }

                        String appoitmentsJson = JSONValue.toJSONString(clientAppntsist);

                        request.setAttribute("appoitmentsJson", appoitmentsJson);
                        
                         String attributes3[] = {"CLIENT_NAME", "MOBILE", "PHONE", "CURRENT_STATUS_SINCE", "OPTION2", "OPTION9", "Note", "CALL_DURATION", "Comment", "CLIENT_ID", "CURRENT_STATUS"};
                    
                        for(int i=0;i< clientAppntsist.size();i++){
                             wboApp=new WebBusinessObject();
                            for(int j=0;j<11 ;j++){
                            
                            wboApp.setAttribute(attributes3[j],clientAppntsist.get(i).get(j));
                          
                            }
                             appWbo.add(wboApp);
                            
                    }
                        
                    
                    } catch (Exception ex) {
                        Logger.getLogger(AppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    
                    
                    String headers3[] = {"Client Name", "Phone Number", "International Phone Number","Status Since","Communication type","Appointment Status", "Appointment Result", "Period", "comment", "client id", "current status"};
                    String attributes3[] = {"CLIENT_NAME", "MOBILE", "PHONE", "CURRENT_STATUS_SINCE", "OPTION2", "OPTION9", "Note", "CALL_DURATION", "Comment", "CLIENT_ID", "CURRENT_STATUS"};
                    String dataTypes3[] = {"String", "String", "String", "Timestamp", "String", "String", "String", "String", "String", "String", "String", "String","String"};

                    headerStr = new String[1];
                    headerStr[0] = "AppointmentsByDateAndUser";
                      workBook = Tools.createExcelReport("AppointmentsByDateAndUser", headerStr, null, headers3 , attributes3, dataTypes3, (ArrayList<WebBusinessObject>) appWbo);
                    
                     c = Calendar.getInstance();
                    fileDate = c.getTime();
                    df = new SimpleDateFormat("dd-MM-yyyy");
                    reportDate = df.format(fileDate);
                    filename = "AppointmentsByDateAndUser" + reportDate;

                    servletOutputStream = response.getOutputStream();
                    bos = new ByteArrayOutputStream();
                    try {
                        workBook.write(bos);
                    } finally {
                        bos.close();
                    }
                    bytes = bos.toByteArray();
                    System.out.println(bytes.length);

                    response.setContentType("application/vnd.ms-excel");
                    response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + ".xls\"");
                    response.setContentLength(bytes.length);
                    servletOutputStream.write(bytes, 0, bytes.length);
                    servletOutputStream.flush();
                    servletOutputStream.close();

                    
                    break;
                    case 77:
                        //data from case 16
                         dateType = request.getParameter("dateType");
                     fromDateS = request.getParameter("fromDate");
                     toDateS = request.getParameter("toDate");
                     campaignID = request.getParameter("campaignID");
                     campaignsList = new ArrayList<>(campaignMgr.getCashedTable());
                     appointmentMgr=AppointmentMgr.getInstance();
                      cal = Calendar.getInstance();
                     sdf = new SimpleDateFormat("yyyy/MM/dd");
                     fromDate = new Date();
                     toDate = new Date();
                    
                     if (toDateS == null) {
                        toDateS = sdf.format(cal.getTime());
                        toDate = cal.getTime();
                    }
                    if (fromDateS == null) {
                        cal.add(Calendar.MONTH, -1);
                        fromDateS = sdf.format(cal.getTime());
                        fromDate = cal.getTime();
                    }
                    createdBy = request.getParameter("userID");
                     rateID = request.getParameter("rateID");

                    userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                    projectMgr = ProjectMgr.getInstance();
                    selectedDepartment = request.getParameter("departmentID");
                    departments = new ArrayList<>();
                    appointmentsList=new ArrayList<>();
                    ArrayList<WebBusinessObject> clients2=new ArrayList<>();
                    
                    try {
                        userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                        for (WebBusinessObject userDepartmentWbo : userDepartments) {
                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }
                        if (departments.isEmpty()) {
                            WebBusinessObject wboTemp = new WebBusinessObject();
                            wboTemp.setAttribute("projectName", "لا يوجد");
                            wboTemp.setAttribute("projectID", "none");
                            departments.add(wboTemp);
                            list = new ArrayList<>();
                        } else {
                            if (selectedDepartment == null) {
                                selectedDepartment = (String) departments.get(0).getAttribute("projectID");
                            } else if (selectedDepartment.equalsIgnoreCase("all")) {
                                String[] departmentIDs = new String[departments.size()];
                                int index = 0;
                                for (WebBusinessObject temp : departments) {
                                    departmentIDs[index++] = (String) temp.getAttribute("projectID");
                                }
                                selectedDepartment = Tools.concatenation(departmentIDs, ",");
                            }
                            list = notificationMgr.getAppointmentByDate(fromDate, toDate, selectedDepartment, null);
                        }
                    } catch (Exception ex) {
                        Logger.getLogger(AppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    request.setAttribute("departments", departments);

                    employeeList = userMgr.getEmployeeByDepartmentId(selectedDepartment, null, null);
                    request.setAttribute("usersList", employeeList);

                    if (request.getAttribute("reportType") != null || request.getParameter("reportType") != null) {
                        request.setAttribute("reportType", "true");
                    }
                    if (request.getParameter("reportType") != null) {
                        createdBy = (String) persistentUser.getAttribute("userId");
                    }
                    Map<String, ArrayList<WebBusinessObject>> dataResult = new HashMap<>();
                    if (createdBy != null) {
                        if (createdBy.equals("all")) {
                            createdBy = "";
                        }
                         clients2 = appointmentMgr.getAppointmentsClients(fromDateS, toDateS, createdBy, employeeList, rateID, request.getParameter("appointmentType"), request.getParameter("result"), dateType, campaignID);
                        
                        for (WebBusinessObject clientTempWbo : clients2) {
                            try {
                                appointmentsList = appointmentMgr.getClientAppointments((String) clientTempWbo.getAttribute("clientID"), createdBy, fromDateS, toDateS, request.getParameter("appointmentType"), request.getParameter("result"), dateType);
                                dataResult.put((String) clientTempWbo.getAttribute("clientID"), appointmentsList);
                            } catch (Exception ex) {
                                Logger.getLogger(CommentsServlet.class.getName()).log(Level.SEVERE, null, ex);
                            }
                        }
                    }
                    
                    String headers01[] = {"Client Number", "Client Name", "Client Mobile Number","International Phone","Client Email","Rate Name"};
                    String attributes01[] = {"clientNo", "clientName", "clientMobile", "interPhone", "clientEmail", "rateName"};
                    String dataTypes01[] = {"String", "String", "String", "String", "String", "String"};
                    String headers02[] = {"Client Notes", "Creation Time", "Appointment Date","Status Since","Created By","Appointment ", "Status Call ", "Result", "Call Duration", "Actual Duration ", "Cal Type"};
                    String attributes02[] = {"comment", "creationTime", "appointmentDate", "currentStatusSince", "createdByName", "statusNameAr", "option9", "note", "option8", "callDuration", "option2"};
                    String dataTypes02[] = {"String", "String", "String", "Timestamp", "String", "String", "String", "String", "String", "String", "String", "String","String"};

                    headerStr = new String[1];
                    headerStr[0] = "AppointmentsByUserAndNotes";
                    workBook = Tools.createExcelReportNested("AppointmentsByUserAndNotes", headerStr,new String [2], headers01 , attributes01, dataTypes01, clients2,headers02,attributes02,dataTypes02,dataResult);
                    
                     c = Calendar.getInstance();
                    fileDate = c.getTime();
                    df = new SimpleDateFormat("dd-MM-yyyy");
                    reportDate = df.format(fileDate);
                    filename = "AppointmentsByUserAndNotes" + reportDate;

                    servletOutputStream = response.getOutputStream();
                    bos = new ByteArrayOutputStream();
                    try {
                        workBook.write(bos);
                    } finally {
                        bos.close();
                    }
                    bytes = bos.toByteArray();
                    System.out.println(bytes.length);
                    response.setContentType("application/vnd.ms-excel");
                    response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + ".xls\"");
                    response.setContentLength(bytes.length);
                    servletOutputStream.write(bytes, 0, bytes.length);
                    servletOutputStream.flush();
                    servletOutputStream.close();
                        break;
                    case 78:
                    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
                    int hoursBeforeNeglect=Integer.parseInt(metaMgr.getHoursBeforeNeglect());
                    userId = request.getParameter("userId");
                    date = request.getParameter("date");
                    type=request.getParameter("type");
                    String typeStr="";
                    ArrayList<WebBusinessObject> appList=new ArrayList<>();
                    //ArrayList<WebBusinessObject> appointments=(ArrayList<WebBusinessObject>)request.getParameter("appointments");
                    appointments = notificationMgr.getUserOwnedAppointmentsByDate(userId, date);
                    for(WebBusinessObject wboUser:appointments){
                        String campaignName= "لايوجد";
                         if (wboUser.getAttribute("option5") != null && !((String) wboUser.getAttribute("option5")).equalsIgnoreCase("UL")) {
                            CampaignMgr campaignMgr = CampaignMgr.getInstance();
                            WebBusinessObject campaignWbo = campaignMgr.getOnSingleKey((String) wboUser.getAttribute("option5"));
                            if (campaignWbo != null) {
                                campaignName = (String) campaignWbo.getAttribute("campaignTitle");
                            }
                        }
                        
                         wboUser.setAttribute("campaignName",campaignName);
                         
                         //type
                         if (CRMConstants.CALL_RESULT_MEETING.equalsIgnoreCase(wboUser.getAttribute("option2").toString())) {
                            typeStr = "مقابلة";
                        } else if (CRMConstants.CALL_RESULT_FOLLOWUP.equalsIgnoreCase(wboUser.getAttribute("option2").toString())) {
                            typeStr = "متابعة مباشرة";
                        } else {
                            typeStr = "مكالمة";
                        }
                        wboUser.setAttribute("type",typeStr);
                        
                        int timeRemaining = Integer.parseInt((String) wboUser.getAttribute("timeRemaining"));
                        if(timeRemaining< -hoursBeforeNeglect*60 && type.equalsIgnoreCase(CRMConstants.APPOINTMENT_STATUS_NEGLECTED)){
                            appList.add(wboUser);
                        }
                        else if(timeRemaining>= -hoursBeforeNeglect*60 &&type.equalsIgnoreCase(CRMConstants.APPOINTMENT_STATUS_OPEN)){
                             appList.add(wboUser);
                        }
                        else if(wboUser.getAttribute("currentStatusCode").toString().equalsIgnoreCase(type)){
                        
                            appList.add(wboUser);
                        }
                         
                        
                    }
                    //excel
                     String headers4[] = {"Campaign Name","Client Name","Client Number", "Phone Number", "title","type","User Responsible","Created By", "Directed By", "Appointment Date", "comment"};
                    String attributes4[] = {"campaignName","clientName","clientNo", "mobile", "title", "type", "userName", "createdByName", "directedByName", "appointmentDate", "comment"};
                    String dataTypes4[] = {"String","String", "String", "String", "String", "String", "String", "String", "String", "String", "String"};

                    headerStr = new String[1];
                    headerStr[0] = "AppointmentsByDateAndUser";
                      workBook = Tools.createExcelReport("AppointmentsByDateAndUser", headerStr, null, headers4 , attributes4, dataTypes4,appList);
                    
                     c = Calendar.getInstance();
                    fileDate = c.getTime();
                    df = new SimpleDateFormat("dd-MM-yyyy");
                    reportDate = df.format(fileDate);
                    filename = "AppointmentsByDateAndUser" + reportDate;

                    servletOutputStream = response.getOutputStream();
                    bos = new ByteArrayOutputStream();
                    try {
                        workBook.write(bos);
                    } finally {
                        bos.close();
                    }
                    bytes = bos.toByteArray();
                    System.out.println(bytes.length);

                    response.setContentType("application/vnd.ms-excel");
                    response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + ".xls\"");
                    response.setContentLength(bytes.length);
                    servletOutputStream.write(bytes, 0, bytes.length);
                    servletOutputStream.flush();
                    servletOutputStream.close();
                    break;
                    case 79:
                    servedPage = "/docs/Search/search_for_client_with_lead.jsp";
                    try {
                        loggegUserId = (String) loggedUser.getAttribute("userId");
                        String userType = (String) userMgr.getByKeyColumnValue("key",(String) loggedUser.getAttribute("userId"),"key2");
                        request.setAttribute("data", IssueByComplaintUniqueMgr.getInstance().getClientsWithLead(loggegUserId,userType));
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                    try {
                        ArrayList<WebBusinessObject> userDepartmentsLead = new ArrayList<>(UserDepartmentConfigMgr.getInstance().getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                        ArrayList<WebBusinessObject> departmentsList = new ArrayList<>();
                        for (WebBusinessObject userDepartmentWbo : userDepartmentsLead) {
                            departmentsList.add(ProjectMgr.getInstance().getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }
                        request.setAttribute("departmentsList", departmentsList);
                    } catch (Exception ex) {
                        Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    try {
                        userMgr = UserMgr.getInstance();
                        request.setAttribute("employees", userMgr.getEmployeesByManager((String) persistentUser.getAttribute("userId")));
                    } catch (Exception ex) {
                    }
                    try {
                        request.setAttribute("typesList", new ArrayList<>(ProjectMgr.getInstance().getOnArbitraryKeyOracle("RQ-TYPE", "key4")));
                    } catch (Exception ex) {
                        request.setAttribute("typesList", new ArrayList<>());
                    }
                    projectMgr = ProjectMgr.getInstance();
                    request.setAttribute("meetings", projectMgr.getMeetingProjects());
                    request.setAttribute("callResults", projectMgr.getCallResultsProjects());
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    case 80:
                    servedPage = "/docs/calendar/emp_statistic_view_group.jsp";

                    projectMgr = ProjectMgr.getInstance();
                    appointmentMgr = AppointmentMgr.getInstance();

                    selectedDepartment = request.getParameter("departmentID");

                    try {
                        //ArrayList<WebBusinessObject> userStatList = appointmentMgr.getEmpStatistic(request.getParameter("depratmentID"), request.getParameter("beginDate"), request.getParameter("endDate"));
                        ArrayList<WebBusinessObject> userStatList = appointmentMgr.getEmpStatWithNewClient(request.getParameter("depratmentID"), request.getParameter("beginDate"), request.getParameter("endDate"),session);
                        try {
                            request.setAttribute("callSum", userStatList.stream().mapToLong(w -> (Long.valueOf(w.getAttribute("call").toString()))).sum() + "");
                            request.setAttribute("noCallSum", userStatList.stream().mapToLong(w -> (Long.valueOf(w.getAttribute("not_answred").toString()))).sum() + "");
                            request.setAttribute("callDurationSum", userStatList.stream().mapToDouble(w -> (Double.valueOf(w.getAttribute("call_duration").toString()))).sum() + "");
                            request.setAttribute("meetingSum", userStatList.stream().mapToLong(w -> (Long.valueOf(w.getAttribute("meeting").toString()))).sum() + "");
                            request.setAttribute("meetingDurationSum", userStatList.stream().mapToDouble(w -> Double.valueOf(w.getAttribute("meeting_duration").toString())).sum() + "");
                            request.setAttribute("totalClientsSum", userStatList.stream().mapToLong(w -> (Long.valueOf(w.getAttribute("total_clients").toString()))).sum() + "");
                            request.setAttribute("visitClientsSum", userStatList.stream().mapToLong(w -> Long.valueOf(w.getAttribute("visitClientsCount").toString())).sum() + "");
                            request.setAttribute("callsClientsSum", userStatList.stream().mapToLong(w -> Long.valueOf(w.getAttribute("callsClientsCount").toString())).sum() + "");
                            request.setAttribute("newClientsCount", userStatList.stream().mapToLong(w -> Long.valueOf(w.getAttribute("newClientsCount").toString())).sum() + "");
                        } catch (Exception e) {
                            request.setAttribute("callSum", "0");
                            request.setAttribute("noCallSum", "0");
                            request.setAttribute("callDurationSum", "0");
                            request.setAttribute("meetingSum", "0");
                            request.setAttribute("meetingDurationSum", "0");
                            request.setAttribute("totalClientsSum", "0");
                            request.setAttribute("visitClientsSum", "0");
                            request.setAttribute("callsClientsSum", "0");
                            request.setAttribute("newClientsCount", "0");
                        }

                        userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                        userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                        departments = new ArrayList<>();

                        for (WebBusinessObject userDepartmentWbo : userDepartments) {
                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }

                        if (departments.isEmpty()) {
                            WebBusinessObject wboTemp = new WebBusinessObject();
                            wboTemp.setAttribute("projectName", "لا يوجد");
                            wboTemp.setAttribute("projectID", "none");
                            departments.add(wboTemp);
                        } else {
                            if (selectedDepartment == null) {
                                selectedDepartment = (String) departments.get(0).getAttribute("projectID");
                            }
                        }

                        request.setAttribute("departments", departments);
                        request.setAttribute("beginDate", request.getParameter("beginDate"));
                        request.setAttribute("endDate", request.getParameter("endDate"));
                        request.setAttribute("data", userStatList);
                    } catch (Exception ex) {
                        Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    request.setAttribute("departmentID", selectedDepartment);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    case 81:
                    servedPage = "/docs/client/client_uni_appntmnt_details_custom.jsp";

                    try {
                        ArrayList<ArrayList<String>> clientAppntsist = new ArrayList<>();

                        clientAppntsist = notificationMgr.getUniqueUserAppointmentCustom(request.getParameter("projectID"));

                        String appoitmentsJson = JSONValue.toJSONString(clientAppntsist);

                        request.setAttribute("appoitmentsJson", appoitmentsJson);
                    } catch (Exception ex) {
                        Logger.getLogger(AppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    request.setAttribute("userID", request.getParameter("userID"));
                    request.setAttribute("userName", request.getParameter("userName"));
                    request.setAttribute("departmentID", request.getParameter("departmentID"));

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                        
            }
        } catch (SQLException ex) {
            Logger.getLogger(AppointmentServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
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
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    @Override
    protected int getOpCode(String opName) {
        if (opName.equals("getAppointmentsAjax")) {
            return 1;
        }
        if (opName.equals("countAppointment")) {
            return 2;
        }
        if (opName.equals("showAppointmentsByDate")) {
            return 3;
        }
        if (opName.equals("showClientAppointment")) {
            return 4;
        }
        if (opName.equals("updateAppointment")) {
            return 5;
        }
        if (opName.equals("removeAppointment")) {
            return 6;
        }
        if (opName.equals("showClientAppointmentsByDate")) {
            return 7;
        }
        if (opName.equals("redirectAppointment")) {
            return 8;
        }
        if (opName.equals("changeStatusAppointment")) {
            return 9;
        }
        if (opName.equals("updateAppointmentComment")) {
            return 10;
        }
        if (opName.equals("showAppointmentsForClient")) {
            return 11;
        }
        if (opName.equals("showAppointmentsForUser")) {
            return 12;
        }
        if (opName.equals("listJobOrders")) {
            return 13;
        }
        if (opName.equals("viewAppointment")) {
            return 14;
        }
        if (opName.equals("getLastAppointmentWithClient")) {
            return 15;
        }
        if (opName.equals("getAllClientAppointments")) {
            return 16;
        }
        if (opName.equals("acceptAppointment")) {
            return 17;
        }
        if (opName.equals("getInternalAppointments")) {
            return 18;
        }
        if (opName.equals("deleteAppointmentAjax")) {
            return 19;
        }
        if (opName.equals("appointmentDone")) {
            return 20;
        }
        if (opName.equals("myAppointment")) {
            return 21;
        }
        if (opName.equals("getCallCenterStatistics")) {
            return 22;
        }
        if (opName.equals("viewCallCenterStatistics")) {
            return 23;
        }
        if (opName.equals("getLastAppointmentWithClientExcel")) {
            return 24;
        }
        if (opName.equals("viewClientStatistics")) {
            return 25;
        }
        if (opName.equals("getClientStatistics")) {
            return 26;
        }
        if (opName.equals("showStatResultDetails")) {
            return 27;
        }
        if (opName.equals("getClientStatisticsExel")) {
            return 28;
        }
        if (opName.equals("getLastAppointmentWithClientExel")) {
            return 29;
        }
        if (opName.equals("updateAppointmentResult")) {
            return 30;
        }
        if (opName.equals("viewMyClientStatistics")) {
            return 31;
        }
        if (opName.equals("getEmpClientsDetails")) {
            return 32;
        }
        if (opName.equals("getDeptStatDetails")) {
            return 33;
        }
        if (opName.equals("ViewDeptStatDetails")) {
            return 34;
        }
        if (opName.equals("AppointmentStat")) {
            return 35;
        }
        if (opName.equals("ViewAppointmentStat")) {
            return 36;
        }
        if (opName.equals("showAppointmentStatResult")) {
            return 37;
        }
        if (opName.equals("getClientAppointments")) {
            return 38;
        }
        if (opName.equals("viewUserClientStatistics")) {
            return 39;
        }
        if (opName.equals("myViewAppointmentStat")) {
            return 40;
        }
        if (opName.equals("getCallCenterStatisticsByClient")) {
            return 41;
        }
        if (opName.equals("viewCallCenterStatisticsByClient")) {
            return 42;
        }
        if (opName.equals("getDataCetnerClientStatistic")) {
            return 43;
        }
        if (opName.equals("viewDataCetnerClientStatistic")) {
            return 44;
        }
        if (opName.equals("getFutureAppointment")) {
            return 45;
        }
        if (opName.equals("listJobOrderComplaint")) {
            return 46;
        }
        if (opName.equals("getFutureCallCenterStatistics")) {
            return 47;
        }
        if (opName.equals("viewFutureCallCenterStatistics")) {
            return 48;
        }
        if (opName.equals("getFutureEmpClientsDetails")) {
            return 49;
        }
        if (opName.equals("getAllNotAnsweredAppointments")) {
            return 50;
        }
        if (opName.equals("getAppointmentCommentAjax")) {
            return 51;
        }
        if (opName.equals("getFirstAppointmentAjax")) {
            return 52;
        }
        if (opName.equals("getMyLastAppointmentWithClient")) {
            return 53;
        }
        if (opName.equals("deleteAppointment")) {
            return 54;
        }
        if (opName.equals("lstEmpAppCmnt")) {
            return 55;
        }
        if (opName.equals("getCallCenterStatisticsByGroup")) {
            return 56;
        }
        if (opName.equals("clientAppDetailsPDF")) {
            return 57;
        }
        if (opName.equals("getClientsViewsInSpecificDay")) {
            return 58;
        }
        if (opName.equals("getClientsPaymentPlansInSpecificDay")) {
            return 59;
        }
        if (opName.equals("clientAppointmentPDF")) {
            return 60;
        }
        if (opName.equals("getRepeatedMeetingsClients")) {
            return 61;
        }
        if (opName.equals("getEmployeeStatisticsExcel")) {
            return 62;
        }
        if (opName.equals("getClientChronOrder")) {
            return 63;
        }
        if (opName.equals("clientsCommChannels")) {
            return 64;
        }
        if (opName.equals("reenteredClients")) {
            return 65;
        }
        if (opName.equals("updateClientAppointments")) {
            return 66;
        }
        if (opName.equals("updateApp")) {
            return 67;
        }
        if (opName.equals("getAllCustomizedClntsWithoutComChannel")) {
            return 68;
        }
        if (opName.equals("getCallCenterStatisticsDetail")) {
            return 69;
        }
        if (opName.equals("getEmployeeStatisticsDetailExcel")) {
            return 70;
        }
        if (opName.equals("getFutureClientAppointments")) {
            return 71;
        }
        if (opName.equals("updateMeetingType")) {
            return 72;
        }
        if (opName.equals("getAppointmentsCountAjax")) {
            return 73;
        }
        if (opName.equals("getEmpClientsFailCalls")) {
            return 74;
        }
        if (opName.equals("getEmpUniqueAppntmnt")) {
            return 75;
        }if (opName.equals("clientAppDetailsExcel")) {
            return 76;
        }if (opName.equals("clientAppointmentExcel")) {
            return 77;
        }if (opName.equals("showAppointmentsForUserExcel")) {
            return 78;
        }if (opName.equals("clientDetailsLead")) {
            return 79;
        }if (opName.equals("clientCustom")) {
            return 81;
        }

        return 0;
    }
}
