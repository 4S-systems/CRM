package com.crm.servlets;

import com.android.business_objects.LiteWebBusinessObject;
import com.businessfw.oms.db_access.ClientSurveyMgr;
import com.clients.db_access.AppointmentMgr;
import com.clients.db_access.AppointmentNotificationMgr;
import com.clients.db_access.ClientComplaintsMgr;
import com.clients.db_access.ClientMgr;
import com.clients.db_access.ClientProductMgr;
import com.crm.common.CRMConstants;
import com.crm.common.CalendarUtils;
import com.crm.common.PDFTools;
import com.crm.db_access.ChannelsMgr;
import com.crm.db_access.ChannelsUsersMgr;
import com.maintenance.common.Tools;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.WebBusinessObject;
import com.crm.db_access.CommentsMgr;
import com.maintenance.common.DateParser;
import com.maintenance.common.SenderConfiurationMgr;
import static com.maintenance.common.Tools.getFileSeparator;
import com.maintenance.common.UserDepartmentConfigMgr;
import com.maintenance.common.WboCollectionDataSource;
import com.maintenance.db_access.DistributionListMgr;
import com.maintenance.db_access.IssueByComplaintMgr;
import com.maintenance.db_access.IssueByComplaintUniqueMgr;
import com.planning.db_access.SeasonMgr;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.common.SecurityUser;
import com.silkworm.common.UserMgr;
import com.silkworm.db_access.PersistentSessionMgr;
import com.silkworm.email.EmailUtility;
import com.silkworm.util.DateAndTimeControl;
import com.tracker.db_access.CampaignMgr;
import com.tracker.db_access.IssueMgr;
import com.tracker.db_access.ProjectMgr;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.tracker.servlets.TrackerBaseServlet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperRunManager;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.json.simple.JSONValue;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class CommentsServlet extends TrackerBaseServlet {

    private CommentsMgr commentsMgr;
    private ClientMgr clientMgr;
    private ChannelsMgr channelsMgr;
    private ProjectMgr projectMgr;
    private ChannelsUsersMgr channelsUsersMgr;
    private MetaDataMgr metaDataMgr;
    private Vector comments;
    private Vector clientsCommentsPDF;
    private List<WebBusinessObject> clients;
    private List<WebBusinessObject> users;
    private String clientComplaintId;
    private String channelId;
    private String comment;
    private String objectType;
    private String createdBy;
    private String from;
    private String to;

    private List<WebBusinessObject> list;
    private AppointmentNotificationMgr notificationMgr;
    private List<CalendarUtils.Day> days;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

        commentsMgr = CommentsMgr.getInstance();
        clientMgr = ClientMgr.getInstance();
        channelsMgr = ChannelsMgr.getInstance();
        channelsUsersMgr = ChannelsUsersMgr.getInstance();
        projectMgr = ProjectMgr.getInstance();
        metaDataMgr = MetaDataMgr.getInstance();
    }

    @Override
    public void destroy() {
    }

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String loggegUserId = (String) loggedUser.getAttribute("userId");
        String remoteAccess = session.getId();
        WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");

        WebBusinessObject wbo = new WebBusinessObject();

        switch (operation) {

            case 1:
                try {
                    if (commentsMgr.saveComment(request, persistentUser)) {
                        metaDataMgr = MetaDataMgr.getInstance();
                        WebBusinessObject clientComplaintsWbo = IssueByComplaintUniqueMgr.getInstance().getOnSingleKey("key2", request.getParameter("clientId"));
                        if (loggedUser != null && clientComplaintsWbo != null && clientComplaintsWbo.getAttribute("createdBy") != null) {
                            WebBusinessObject sourceUserWbo = userMgr.getOnSingleKey((String) clientComplaintsWbo.getAttribute("createdBy"));
                            WebBusinessObject commentUserWbo = userMgr.getOnSingleKey((String) loggedUser.getAttribute("userId"));
                            if (metaDataMgr.getSendMail() != null && metaDataMgr.getSendMail().equals("1")
                                    && sourceUserWbo != null && sourceUserWbo.getAttribute("email") != null
                                    && commentUserWbo != null && commentUserWbo.getAttribute("fullName") != null) {
                                String toEmail = (String) sourceUserWbo.getAttribute("email");
                                String subject = "تم أضافة تعليق للطلب " + clientComplaintsWbo.getAttribute("businessCompID") + " بواسطة " + commentUserWbo.getAttribute("fullName");
                                String content = request.getParameter("comment");
                                try {
                                    EmailUtility.sendMessage(toEmail, subject, content);
                                } catch (Exception ex) {
                                    Logger.getLogger(CommentsServlet.class.getName()).log(Level.SEVERE, null, ex);
                                }
                            }
                        }
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                } catch (NoUserInSessionException ex) {
                    logger.error(ex);
                } catch (SQLException ex) {
                    logger.error(ex);
                }
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 2:
                clientComplaintId = request.getParameter("clientComplaintId");
                channelId = request.getParameter("channelId");
                comment = request.getParameter("comment");
                objectType = request.getParameter("objectType");
                try {
                    String[] users;
                    if ("all".equalsIgnoreCase(channelId)) {
                        String[] channelsIds = channelsMgr.getChannelsIds(loggegUserId);
                        users = channelsUsersMgr.getUsersIds(channelsIds);
                    } else {
                        users = channelsUsersMgr.getUsersIds(channelId);
                    }
                    if (commentsMgr.saveChannelsComment(clientComplaintId, loggegUserId, objectType, comment, users)) {
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                } catch (SQLException ex) {
                    logger.error(ex);
                    wbo.setAttribute("status", "no");
                }
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 3:
                servedPage = "/show_comments.jsp";
                clientComplaintId = (String) request.getParameter("clientId");
                comments = new Vector();

                try {
                    comments = commentsMgr.getComments(clientComplaintId, loggegUserId);
                } catch (Exception ex) {
                    logger.error(ex);
                }

                request.setAttribute("page", servedPage);
                request.setAttribute("comments", comments);
                this.forward(servedPage, request, response);
                break;

            case 4:
                out = response.getWriter();
                String clientId = request.getParameter("clientId");
                wbo = new WebBusinessObject();
                commentsMgr = CommentsMgr.getInstance();
                try {
                    ArrayList commentsList = new ArrayList(commentsMgr.getOnArbitraryKeyOracle(clientId, "key1"));
                    wbo.setAttribute("count", commentsList.size());
                } catch (Exception ex) {
                    Logger.getLogger(CommentsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                out.print(Tools.getJSONObjectAsString(wbo));
                break;

            case 5:
                servedPage = "/docs/client/client_with_last_comment.jsp";
                createdBy = request.getParameter("createdBy");
                from = request.getParameter("from");
                to = request.getParameter("to");
                String interCode = request.getParameter("interCode");

                UserDepartmentConfigMgr userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                ArrayList<WebBusinessObject> userDepartments;
                projectMgr = ProjectMgr.getInstance();
                String selectedDepartment = request.getParameter("departmentID");
                ArrayList<WebBusinessObject> departments = new ArrayList<>();
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
                    }
                } catch (Exception ex) {
                    Logger.getLogger(CommentsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("departments", departments);

                List<WebBusinessObject> employeeList = userMgr.getEmployeeByDepartmentId(selectedDepartment, null, null);
                request.setAttribute("users", employeeList);

                if ((createdBy != null) && (from != null) && (to != null)) {
                    if (createdBy.equals("-")) {
                        createdBy = "";
                    }
                    String toPlusOneDay = to;
                    try {
                        SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
                        Date date = formatter.parse(to);
                        Calendar calendar = Calendar.getInstance();
                        calendar.setTime(date);
                        calendar.add(Calendar.DATE, 1);
                        toPlusOneDay = formatter.format(calendar.getTime());
                    } catch (ParseException ex) {
                        logger.error(ex);
                    }
                    clients = clientMgr.getClientsWithCommentsByOwnerDate(createdBy, from, toPlusOneDay, interCode, employeeList);
                    request.setAttribute("data", clients);
                    request.setAttribute("createdBy", request.getParameter("createdBy"));
                    request.setAttribute("from", from);
                    request.setAttribute("to", to);
                    request.setAttribute("interCode", interCode);
                    request.setAttribute("users", employeeList);
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
                List<WebBusinessObject> userProjects = new ArrayList<WebBusinessObject>();
                try {
                    userProjects = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("1365240752318", "key2"));
                } catch (Exception ex) {
                    logger.error(ex);
                }
                List<WebBusinessObject> meetings = projectMgr.getMeetingProjects();
                List<WebBusinessObject> callResults = projectMgr.getCallResultsProjects();

                users = userMgr.getUserList();

                request.setAttribute("defaultCampaign", defaultCampaign);
                request.setAttribute("userProjects", userProjects);
                request.setAttribute("meetings", meetings);
                request.setAttribute("callResults", callResults);
                request.setAttribute("page", servedPage);
                request.setAttribute("departmentID", selectedDepartment);
                //request.setAttribute("users", users);
                this.forwardToServedPage(request, response);
                break;
            case 6:
                createdBy = request.getParameter("createdBy");
                from = request.getParameter("from");
                to = request.getParameter("to");
                interCode = request.getParameter("interCode");
                selectedDepartment = request.getParameter("departmentID");

                if ((createdBy != null) && (from != null) && (to != null)) {
                    if (createdBy.equals("-")) {
                        createdBy = "";
                    }
                    String toPlusOneDay = to;
                    try {
                        SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
                        Date date = formatter.parse(to);
                        Calendar calendar = Calendar.getInstance();
                        calendar.setTime(date);
                        calendar.add(Calendar.DATE, 1);
                        toPlusOneDay = formatter.format(calendar.getTime());
                    } catch (ParseException ex) {
                        logger.error(ex);
                    }

                    employeeList = userMgr.getEmployeeByDepartmentId(selectedDepartment, null, null);

                    ArrayList<WebBusinessObject> clientsList = new ArrayList<>(clientMgr.getClientsWithCommentsByOwnerDate(createdBy, from, toPlusOneDay, interCode, employeeList));
                    String headers[] = {"#", "Client No.", "Client Name", "Phone", "Mobile", "Inter. No.", "Comment By", "Comment Date", "Comment","Client creation Time","Campaign Name"};
                    String attributes[] = {"Number", "clientNO", "name", "phone", "mobile", "interPhone", "createdByName", "creationTime", "comment","clCreation_time","CAMPAIGN_TITLE"};
                    String dataTypes[] = {"", "String", "String", "String", "String", "String", "String", "String", "String","String","String"};

                    String[] headerStr = new String[1];
                    headerStr[0] = "Last_Comments";
                    HSSFWorkbook workBook = Tools.createExcelReport("Last Comments", headerStr, null, headers, attributes, dataTypes, clientsList);

                    Calendar c = Calendar.getInstance();
                    Date fileDate = c.getTime();
                    SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");
                    String reportDate = df.format(fileDate);
                    String filename = "LastComments" + reportDate;

                    ServletOutputStream servletOutputStream = response.getOutputStream();
                    ByteArrayOutputStream bos = new ByteArrayOutputStream();
                    try {
                        workBook.write(bos);
                    } finally {
                        bos.close();
                    }
                    byte[] bytes = bos.toByteArray();
                    System.out.println(bytes.length);
                    //                bytes = bos.toByteArray();

                    response.setContentType("application/vnd.ms-excel");
                    response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + ".xls\"");
                    response.setContentLength(bytes.length);
                    servletOutputStream.write(bytes, 0, bytes.length);
                    servletOutputStream.flush();
                    servletOutputStream.close();
                }
                break;
            case 7:
                servedPage = "/docs/requests/request_comments_history.jsp";
                ArrayList<WebBusinessObject> commentsList = new ArrayList<>();
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                try {
                    commentsList = new ArrayList<>(commentsMgr.getOnArbitraryKeyOrdered(request.getParameter("issueID"), "key1", "key4"));
                    if (!commentsList.isEmpty()) {
                        if (commentsList.get(0).getAttribute("createdBy") != null) {
                            commentsList.get(0).setAttribute("createdByName", userMgr.getOnSingleKey((String) commentsList.get(0).getAttribute("createdBy")).getAttribute("fullName"));
                        }
                    }
                    for (int i = 1; i < commentsList.size(); i++) {
                        if (commentsList.get(i).getAttribute("creationTime") != null && commentsList.get(i - 1).getAttribute("creationTime") != null) {
                            commentsList.get(i).setAttribute("duration", (sdf.parse((String) commentsList.get(i).getAttribute("creationTime")).getTime()
                                    - sdf.parse((String) commentsList.get(i - 1).getAttribute("creationTime")).getTime()) / (1000 * 60));
                        }
                        if (commentsList.get(i).getAttribute("createdBy") != null) {
                            commentsList.get(i).setAttribute("createdByName", userMgr.getOnSingleKey((String) commentsList.get(i).getAttribute("createdBy")).getAttribute("fullName"));
                        }
                    }
                } catch (Exception ex) {
                    Logger.getLogger(CommentsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("commentsList", commentsList);
                this.forward(servedPage, request, response);
                break;

            case 8:
                servedPage = "/docs/issue/comments_popup.jsp";
                clientComplaintId = (String) request.getParameter("clientComplaintId");
                comments = new Vector();

                try {
                    comments = commentsMgr.getComments(clientComplaintId, loggegUserId);
                } catch (Exception ex) {
                    logger.error(ex);
                }

                request.setAttribute("page", servedPage);
                request.setAttribute("comments", comments);
                this.forward(servedPage, request, response);
                break;

            case 9:
                servedPage = "/docs/requests/new_comment.jsp";
                this.forward(servedPage, request, response);
                break;
            case 10:
                servedPage = "/docs/requests/show_comments.jsp";
                clientComplaintId = (String) request.getParameter("clientId");
                comments = new Vector();

                try {
                    comments = commentsMgr.getComments(clientComplaintId, loggegUserId);
                } catch (Exception ex) {
                    logger.error(ex);
                }

                request.setAttribute("page", servedPage);
                request.setAttribute("comments", comments);
                this.forward(servedPage, request, response);
                break;
            case 11:
                servedPage = "/docs/requests/update_comment.jsp";
                WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");
                request.setAttribute("commentWbo", commentsMgr.getLastUserIssueComment((String) user.getAttribute("userId"), request.getParameter("issueID")));
                this.forward(servedPage, request, response);
                break;
            case 12:
                wbo = new WebBusinessObject();
                try {
                    if (commentsMgr.updateComment(request, persistentUser)) {
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 13:
                metaDataMgr = MetaDataMgr.getInstance();
                issueMgr = IssueMgr.getInstance();

                String period = metaDataMgr.getDelayedTaskPeriod();

                Vector<WebBusinessObject> reportData = new Vector();
                Vector comments = commentsMgr.getIssuesComments("1"); // number of comments > 1

                try {
                    if (comments != null && comments.size() > 0) {
                        for (int i = 0; i < comments.size(); i++) {
                            Vector IssueCommentsVec = commentsMgr.getOnArbitraryKeyOrdered(comments.get(i).toString(), "key1", "key4");

                            if (IssueCommentsVec != null && IssueCommentsVec.size() > 0) {

                                WebBusinessObject comment1 = (WebBusinessObject) IssueCommentsVec.get(0);
                                WebBusinessObject comment2 = (WebBusinessObject) IssueCommentsVec.get(1);

                                java.util.Date commDate1 = Tools.stringToDate(comment1.getAttribute("creationTime").toString());
                                java.util.Date commDate2 = Tools.stringToDate(comment2.getAttribute("creationTime").toString());

                                long dateDiff = commDate2.getTime() - commDate1.getTime();
                                long dateLong = dateDiff / (1000 * 60 * 60 * 24);
                                int Days = (int) dateLong;

                                if (Days >= Integer.parseInt(period)) {
                                    wbo = new WebBusinessObject();
                                    WebBusinessObject issueWbo = issueMgr.getOnSingleKey((String) comment1.getAttribute("clientId"));

                                    wbo.setAttribute("IssueBusinessID", issueWbo.getAttribute("businessID"));
                                    WebBusinessObject userWbo = userMgr.getOnSingleKey((String) comment1.getAttribute("createdBy"));
                                    wbo.setAttribute("FromUser", userWbo.getAttribute("userName"));
                                    userWbo = userMgr.getOnSingleKey((String) comment2.getAttribute("createdBy"));
                                    wbo.setAttribute("ToUser", userWbo.getAttribute("userName"));
                                    wbo.setAttribute("Comment1", comment1.getAttribute("comment") != null ? comment1.getAttribute("comment") : "");
                                    wbo.setAttribute("Comment2", comment2.getAttribute("comment") != null ? comment2.getAttribute("comment") : "");
                                    wbo.setAttribute("Date1", comment1.getAttribute("creationTime").toString().substring(0, 10));
                                    wbo.setAttribute("Date2", comment2.getAttribute("creationTime").toString().substring(0, 10));
                                    wbo.setAttribute("Duration", Integer.toString(Days));

                                    reportData.add(wbo);
                                }
                            }
                        }
                    }

                    HashMap parameters = new HashMap();
                    ServletContext context = getServletConfig().getServletContext();

                    //ReportName
                    String report = "DelayedTasksReport";

                    //Report paths
                    /*String reportFileNameSource = context.getRealPath(getFileSeparator() + "reports" + getFileSeparator() + report + ".jrxml");
                     String reportFileName = context.getRealPath(getFileSeparator() + "reports" + getFileSeparator() + report + ".jasper");
                     String subReportDir = context.getRealPath(getFileSeparator() + "reports") + getFileSeparator();
                     String logoPath = context.getRealPath(getFileSeparator() + "images" + getFileSeparator() + metaDataMgr.getLogos().get("headReport3"));*/
                    String reportFileNameSource = context.getRealPath("/" + "reports" + getFileSeparator() + report + ".jrxml");
                    String reportFileName = context.getRealPath("/" + "reports" + getFileSeparator() + report + ".jasper");
                    String subReportDir = context.getRealPath("/" + "reports") + getFileSeparator();
                    String logoPath = context.getRealPath("/" + "images") + getFileSeparator() + metaDataMgr.getLogos().get("headReport3");

                    // set in parameters
                    parameters.put("logo", logoPath);
                    parameters.put("SUBREPORT_DIR", subReportDir);
                    parameters.put("period", period);

                    // Compile report if needed
                    File reportFileSource = new File(reportFileNameSource);
                    if (!reportFileSource.exists()) {
                        throw new FileNotFoundException(String.valueOf(reportFileSource));
                    }
                    File reportFile = new File(reportFileName);
                    if (!reportFile.exists() || reportFileSource.lastModified() > reportFile.lastModified()) {
                        JasperCompileManager.compileReportToFile(reportFileNameSource, reportFileName);
                    }

                    ServletOutputStream servletOutputStream = response.getOutputStream();
                    byte[] bytes;

                    WboCollectionDataSource itrate = new WboCollectionDataSource(reportData);
                    bytes = JasperRunManager.runReportToPdf(reportFileName, parameters, itrate);
                    response.setContentType("application/pdf");
                    response.setHeader("Content-Disposition", "inline; filename=\"" + report.toUpperCase() + ".pdf\"");
                    response.setContentLength(bytes.length);
                    servletOutputStream.write(bytes, 0, bytes.length);
                    servletOutputStream.flush();
                    servletOutputStream.close();
                } catch (Exception ex) {
                    logger.error("Fail To get Comments" + ex);
                }
                break;
            case 14:
                servedPage = "/docs/reports/comments_response_report.jsp";
                ArrayList<WebBusinessObject> issues;
                commentsMgr = CommentsMgr.getInstance();
                String fromDateS = request.getParameter("fromDate");
                String toDateS = request.getParameter("toDate");
                Calendar cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (toDateS == null) {
                    toDateS = sdf.format(cal.getTime());
                }
                if (fromDateS == null) {
                    cal.add(Calendar.MONTH, -1);
                    fromDateS = sdf.format(cal.getTime());
                }
                if (fromDateS != null && toDateS != null) {
                    DateParser dateParser = new DateParser();
                    String jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                    java.sql.Date fromDateD = dateParser.formatSqlDate(fromDateS, jsDateFormat);
                    java.sql.Date toDateD = dateParser.formatSqlDate(toDateS, jsDateFormat);
                    issues = commentsMgr.getCommentResponseInterval(fromDateD, toDateD);
                } else {
                    issues = new ArrayList<>();
                }
                request.setAttribute("page", servedPage);
                request.setAttribute("fromDate", fromDateS);
                request.setAttribute("toDate", toDateS);
                request.setAttribute("issues", issues);
                this.forwardToServedPage(request, response);
                break;
            case 15:
                wbo = new WebBusinessObject();
                try {
                    if (commentsMgr.updateCommentOwner(request.getParameter("commentID"))) {
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "no");
                    }
                } catch (SQLException ex) {
                    logger.error(ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 16:
                servedPage = "/docs/client/client_comments.jsp";
                clientsCommentsPDF = new Vector();
                fromDateS = request.getParameter("fromDate");
                toDateS = request.getParameter("toDate");
                createdBy = request.getParameter("createdBy");
                String campaignID = request.getParameter("campaignID");
                String rateID = request.getParameter("rateID");
                String subject = request.getParameter("subject");

                userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                departments = new ArrayList<>();
                userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                projectMgr = ProjectMgr.getInstance();
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
                        list = new ArrayList<>();
                    } else {
                        if (selectedDepartment == null) {
                            selectedDepartment = "all";
                        }
                    }
                } catch (Exception ex) {
                    Logger.getLogger(CommentsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                if (selectedDepartment != null && selectedDepartment.equals("all")) {
                    employeeList = new ArrayList<>();
                    for (WebBusinessObject departmentWbo : departments) {
                        employeeList.addAll(userMgr.getEmployeeByDepartmentId((String) departmentWbo.getAttribute("projectID"), null, null));
                    }
                } else {
                    employeeList = userMgr.getEmployeeByDepartmentId(selectedDepartment, null, null);
                }

                if (request.getAttribute("reportType") != null || request.getParameter("reportType") != null) {
                    request.setAttribute("reportType", "true");
                }
                if (request.getParameter("reportType") != null) {
                    createdBy = (String) persistentUser.getAttribute("userId");
                }
                if (fromDateS != null) {
                    request.setAttribute("fromDate", fromDateS);
                    request.setAttribute("toDate", toDateS);
                    request.setAttribute("createdBy", createdBy);
                    request.setAttribute("campaignID", campaignID);
                    request.setAttribute("rateID", rateID);
                    request.setAttribute("subject", subject);
                    request.setAttribute("departmentID", selectedDepartment);
                    if (createdBy == null || createdBy.equals("all")) {
                        createdBy = "";
                    }
                    commentsMgr = CommentsMgr.getInstance();
                    DistributionListMgr distributionListMgr = DistributionListMgr.getInstance();

                    clients = commentsMgr.getClientsComments(fromDateS, toDateS, createdBy, employeeList, campaignID, rateID, subject);
                    Map<String, ArrayList<WebBusinessObject>> dataResult = new HashMap<>();
                    for (WebBusinessObject clientWbo : clients) {
                        try {
                            commentsList = commentsMgr.getClientComments((String) clientWbo.getAttribute("clientID"), createdBy, subject);
                            dataResult.put((String) clientWbo.getAttribute("clientID"), commentsList);
                            clientWbo.setAttribute("isOwner", createdBy.equals(distributionListMgr.getLastResponsibleEmployee((String) clientWbo.getAttribute("clientID"))));

                            //Prepare PDF Report Object
                            WebBusinessObject clientWboTemp = new WebBusinessObject();
                            Vector<WebBusinessObject> clientsVec = new Vector();
                            clientsVec.add(clientWbo);
                            clientWboTemp.setAttribute("client", clientsVec);
                            clientWboTemp.setAttribute("comments", commentsList);
                            clientsCommentsPDF.add(clientWboTemp);
                        } catch (Exception ex) {
                            Logger.getLogger(CommentsServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }

                    }
                    request.setAttribute("dataResult", dataResult);
                    request.setAttribute("data", clients);
                }

                ArrayList<WebBusinessObject> prvType = securityUser.getComplaintMenuBtn();
                ArrayList<String> privilegesList = new ArrayList<>();
                for (WebBusinessObject wboTemp : prvType) {
                    if (wboTemp != null && wboTemp.getAttribute("prevCode") != null) {
                        privilegesList.add((String) wboTemp.getAttribute("prevCode"));
                    }
                }
                ArrayList<WebBusinessObject> usersArrList = new ArrayList<>();
                if (!privilegesList.contains("ALL_USERS")) {
                    usersArrList.add(userMgr.getOnSingleKey((String) persistentUser.getAttribute("userId")));
                    usersArrList.addAll(userMgr.getEmployeesByManager((String) persistentUser.getAttribute("userId")));
                } else {
                    usersArrList.addAll(userMgr.getCashedTable());
                }
                CampaignMgr campaignMgr = CampaignMgr.getInstance();
                List<WebBusinessObject> campaignsList;
                try {
                    campaignsList = new ArrayList<>(campaignMgr.getCashedTable());
//                    campaignsList.addAll(campaignMgr.getAllSubCampaigns());
//                    campaignsList.addAll(campaignMgr.getOnArbitraryKeyOracle("20", "key4"));
                } catch (Exception ex) {
                    campaignsList = new ArrayList<>();
                }
                ArrayList<WebBusinessObject> ratesList = new ArrayList<>();
                try {
                    ratesList = new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("CL-RATE", "key4"));
                } catch (Exception ex) {
                }
                request.setAttribute("ratesList", ratesList);
                request.setAttribute("users", usersArrList);
                request.setAttribute("departments", departments);
                request.setAttribute("users", "all".equals(selectedDepartment) || selectedDepartment == null ? new ArrayList<WebBusinessObject>() : employeeList);
                request.setAttribute("campaignsList", campaignsList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 17:
                servedPage = "/docs/issue/comments_popup.jsp";
                clientComplaintId = (String) request.getParameter("clientComplaintId");
                comments = new Vector();

                try {
                    comments = commentsMgr.getClientGeneralComments(clientComplaintId);
                } catch (Exception ex) {
                    logger.error(ex);
                }

                request.setAttribute("page", servedPage);
                request.setAttribute("comments", comments);
                this.forward(servedPage, request, response);
                break;
            case 18:
                servedPage = "/docs/reports/list_finish_close_comments.jsp";
                request.setAttribute("data", commentsMgr.getFinishCloseComments(request.getParameter("issueID")));
                request.setAttribute("issue", issueMgr.getOnSingleKey(request.getParameter("issueID")));
                this.forward(servedPage, request, response);
                break;
            case 19:
                servedPage = "/docs/reports/list_all_comments.jsp";
                request.setAttribute("data", commentsMgr.getAllComments(request.getParameter("issueID")));
                request.setAttribute("issue", issueMgr.getOnSingleKey(request.getParameter("issueID")));
                this.forward(servedPage, request, response);
                break;
            case 20:
                servedPage = "/docs/reports/list_all_comments.jsp";
                ArrayList<WebBusinessObject> data = commentsMgr.getAllComments(request.getParameter("issueID"));
                data.addAll(commentsMgr.getFinishCloseComments(request.getParameter("issueID")));
                request.setAttribute("data", data);
                request.setAttribute("issue", issueMgr.getOnSingleKey(request.getParameter("issueID")));
                this.forward(servedPage, request, response);
                break;
            case 21:
                servedPage = "/docs/reports/Three_comments_response_report.jsp";
                commentsMgr = CommentsMgr.getInstance();
                fromDateS = request.getParameter("fromDate");
                toDateS = request.getParameter("toDate");
                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (toDateS == null) {
                    toDateS = sdf.format(cal.getTime());
                }
                if (fromDateS == null) {
                    cal.add(Calendar.MONTH, -1);
                    fromDateS = sdf.format(cal.getTime());
                }
                if (fromDateS != null && toDateS != null) {
                    DateParser dateParser = new DateParser();
                    String jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                    java.sql.Date fromDateD = dateParser.formatSqlDate(fromDateS, jsDateFormat);
                    java.sql.Date toDateD = dateParser.formatSqlDate(toDateS, jsDateFormat);
                    issues = commentsMgr.getThreeCommentResponseInterval(fromDateD, toDateD);
                } else {
                    issues = new ArrayList<>();
                }
                request.setAttribute("page", servedPage);
                request.setAttribute("fromDate", fromDateS);
                request.setAttribute("toDate", toDateS);
                request.setAttribute("issues", issues);
                this.forwardToServedPage(request, response);
                break;

            case 22:
                servedPage = "/docs/reports/Empty_Third_comment_report.jsp";
                commentsMgr = CommentsMgr.getInstance();
                fromDateS = request.getParameter("fromDate");
                toDateS = request.getParameter("toDate");
                String projectID = request.getParameter("projectID");
                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (toDateS == null) {
                    toDateS = sdf.format(cal.getTime());
                }
                if (fromDateS == null) {
                    cal.add(Calendar.MONTH, -1);
                    fromDateS = sdf.format(cal.getTime());
                }
                if (projectID == null || projectID.equalsIgnoreCase("all")) {
                    projectID = "";
                }
                if (fromDateS != null && toDateS != null) {
                    DateParser dateParser = new DateParser();
                    String jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                    java.sql.Date fromDateD = dateParser.formatSqlDate(fromDateS, jsDateFormat);
                    java.sql.Date toDateD = dateParser.formatSqlDate(toDateS, jsDateFormat);
                    issues = commentsMgr.getThirdEmptyComment(fromDateD, toDateD, projectID);
                } else {
                    issues = new ArrayList<>();
                }
                try {
                    request.setAttribute("projectsList", new ArrayList<>(projectMgr.getOnArbitraryKey("44", "key4")));
                } catch (Exception ex) {
                    request.setAttribute("projectsList", new ArrayList<WebBusinessObject>());
                }
                request.setAttribute("page", servedPage);
                request.setAttribute("fromDate", fromDateS);
                request.setAttribute("toDate", toDateS);
                request.setAttribute("projectID", projectID);
                request.setAttribute("issues", issues);
                this.forwardToServedPage(request, response);
                break;

            case 23:
                servedPage = "/docs/reports/Client_First_comment_report.jsp";
                commentsMgr = CommentsMgr.getInstance();
                fromDateS = request.getParameter("fromDate");
                toDateS = request.getParameter("toDate");
                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (toDateS == null) {
                    toDateS = sdf.format(cal.getTime());
                }
                if (fromDateS == null) {
                    cal.add(Calendar.MONTH, -1);
                    fromDateS = sdf.format(cal.getTime());
                }
                if (fromDateS != null && toDateS != null) {
                    DateParser dateParser = new DateParser();
                    String jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                    java.sql.Date fromDateD = dateParser.formatSqlDate(fromDateS, jsDateFormat);
                    java.sql.Date toDateD = dateParser.formatSqlDate(toDateS, jsDateFormat);
                    issues = commentsMgr.getClientFirstCommentResponseInterval(fromDateD, toDateD);
                } else {
                    issues = new ArrayList<>();
                }
                request.setAttribute("page", servedPage);
                request.setAttribute("fromDate", fromDateS);
                request.setAttribute("toDate", toDateS);
                request.setAttribute("issues", issues);
                this.forwardToServedPage(request, response);
                break;
            case 24:
                servedPage = "/show_comments.jsp";
                clientId = (String) request.getParameter("clientId");
                comments = new Vector();
                try {
                    comments = commentsMgr.getAllClientComments(clientId);
                } catch (Exception ex) {
                    logger.error(ex);
                }
                request.setAttribute("page", servedPage);
                request.setAttribute("comments", comments);
                this.forward(servedPage, request, response);
                break;
            case 25:
                HashMap parameters = new HashMap();

                parameters.put("fromDate", request.getParameter("fromDate"));
                parameters.put("toDate", request.getParameter("toDate"));

                String companyName = metaDataMgr.getCompanyNameForLogo();
                String logoName = "logo.png";
                if (companyName != null) {
                    logoName = "logo-" + companyName + ".png";
                }

                parameters.put("CompanyName", companyName);
                parameters.put("logo", logoName);

                Tools.createPdfReportFromComapny("ClientsCommentsReport", parameters, clientsCommentsPDF, getServletContext(), response, request, logoName);
                break;

            case 26:
                SenderConfiurationMgr confiuration = SenderConfiurationMgr.getCurrentInstance();
                UserMgr userMgr = UserMgr.getInstance();
                IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();

                String group = confiuration.getClientEmpGroup();
                String daysNo = confiuration.getClientEmpDaysNo();

                java.util.Date todayDate = new java.util.Date();
                cal = Calendar.getInstance();

                cal.setTime(todayDate);
                cal.add(Calendar.DATE, -new Integer(daysNo));

                java.util.Date tempDate = cal.getTime();
                java.sql.Date bDate = new java.sql.Date(tempDate.getTime());
                java.util.Date eUtilDate = new java.util.Date();
                java.sql.Date eDate = new java.sql.Date(eUtilDate.getTime());

                int totalReservation,
                 totalConfirmed;
                reportData = new Vector();

                try {
                    List<WebBusinessObject> usersList = userMgr.getUsersByGroup(group);

                    for (WebBusinessObject userWbo : usersList) {
                        totalReservation = 0;
                        totalConfirmed = 0;

                        ArrayList<WebBusinessObject> issuesList = issueByComplaintMgr.getComplaintsPerEmployee((String) userWbo.getAttribute("userId"), bDate, eDate, null, null);

                        for (WebBusinessObject issueWbo : issuesList) {
                            if (issueWbo.getAttribute("totalConfirmed") != null && !issueWbo.getAttribute("totalConfirmed").equals("0")) {
                                totalConfirmed++;
                            } else if (issueWbo.getAttribute("totalReservation") != null && !issueWbo.getAttribute("totalReservation").equals("0")) {
                                totalReservation++;
                            }
                        }

                        userWbo.setAttribute("totalReservation", new Integer(totalReservation));
                        userWbo.setAttribute("totalConfirmed", new Integer(totalConfirmed));
                        userWbo.setAttribute("totalClients", new Integer(issuesList.size()));
                        reportData.add(userWbo);
                    }
                } catch (Exception ex) {
                    System.out.println("ClientsByEmployeeReport Exception = " + ex.getMessage());
                }

                parameters = new HashMap();
                parameters.put("fromDate", bDate.toString());
                parameters.put("toDate", eDate.toString());

                Tools.createPdfReportFromComapny("EmployeeProductivity", parameters, reportData, getServletContext(), response, request, (String) metaDataMgr.getLogos().get("headReport3"));
                break;

            case 27:
                commentsMgr = CommentsMgr.getInstance();

                issues = new ArrayList<>();

                fromDateS = request.getParameter("fromDateS");
                toDateS = request.getParameter("toDateS");
                projectID = request.getParameter("projectID");

                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (toDateS == null) {
                    toDateS = sdf.format(cal.getTime());
                }
                if (fromDateS == null) {
                    cal.add(Calendar.MONTH, -1);
                    fromDateS = sdf.format(cal.getTime());
                }
                if (projectID == null || projectID.equalsIgnoreCase("all")) {
                    projectID = "";
                }
                if (fromDateS != null && toDateS != null) {
                    DateParser dateParser = new DateParser();
                    String jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                    java.sql.Date fromDateD = dateParser.formatSqlDate(fromDateS, jsDateFormat);
                    java.sql.Date toDateD = dateParser.formatSqlDate(toDateS, jsDateFormat);
                    issues = commentsMgr.getThirdEmptyComment(fromDateD, toDateD, projectID);

                    if (issues != null && issues.size() > 0) {
                        for (int i = 0; i < issues.size(); i++) {
                            wbo = issues.get(i);

                            String diff = (String) wbo.getAttribute("diff");
                            diff = diff != null ? diff.substring(0, diff.indexOf(" ")) : "";
                            int total = 0;

                            if (!diff.isEmpty()) {
                                total += Double.parseDouble(diff);
                            }

                            wbo.setAttribute("diff", diff);

                            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                            cal = Calendar.getInstance();

                            String comment2Date = wbo.getAttribute("COMMENT2_CREATION_TIME").toString();
                            String comment3Date = dateFormat.format(cal.getTime());

                            //get the diffrenence between end and start date
                            DateAndTimeControl dtControl = new DateAndTimeControl();
                            Vector duration = dtControl.calculateDateDiff(comment2Date, comment3Date);

                            if (CRMConstants.ISSUE_STATUS_ACCEPTED.equals(wbo.getAttribute("current_status"))
                                    || CRMConstants.ISSUE_STATUS_FINAL_REJECTION.equals(wbo.getAttribute("current_status"))) {
                                wbo.setAttribute("comment3", "---");
                                wbo.setAttribute("duration", "---");
                                wbo.setAttribute("total", diff);
                            } else {
                                wbo.setAttribute("comment3", "لايوجد");
                                wbo.setAttribute("duration", duration.get(0).toString());
                                total += new Long((Long) duration.get(0));
                                wbo.setAttribute("total", new Integer(total).toString());
                            }

                            if (wbo.getAttribute("current_status").toString().equals("34")) {
                                wbo.setAttribute("current_status", "مقبول");
                            } else if (wbo.getAttribute("current_status").toString().equals("35")) {
                                wbo.setAttribute("current_status", "مرفوض");
                            } else if (wbo.getAttribute("current_status").toString().equals("36")) {
                                wbo.setAttribute("current_status", "مقبول بملاحظات");
                            } else if (wbo.getAttribute("current_status").toString().equals("40")) {
                                wbo.setAttribute("current_status", "مرفوض نهائيا");
                            } else if (wbo.getAttribute("current_status").toString().equals("41")) {
                                wbo.setAttribute("current_status", "جديد");
                            }
                        }
                    }
                } else {
                    issues = new ArrayList<>();
                }

                parameters = new HashMap();
                parameters.put("fromDate", fromDateS.toString());
                parameters.put("toDate", toDateS.toString());

                Tools.createPdfReportEmptyThirdComment("EmptyThirdComment", parameters, issues, getServletContext(), response, request, (String) metaDataMgr.getLogos().get("headReport3"));
                break;
            case 28:
                request.setAttribute("reportType", "true");
                this.forward("/CommentsServlet?op=getAllClientComments", request, response);
                break;
            case 29:
                out = response.getWriter();
                userMgr = UserMgr.getInstance();
                employeeList = userMgr.getEmployeeByDepartmentId(request.getParameter("departmentID"), null, null);
                out.write(Tools.getJSONArrayAsString(employeeList));
                break;
            case 30:
                out = response.getWriter();
                userMgr = UserMgr.getInstance();
                out.write(Tools.getJSONArrayAsString(ClientProductMgr.getInstance().getInterestedUnit(request.getParameter("clientID"))));
                break;
            case 31:
                out = response.getWriter();
                AppointmentMgr appointmentMgr = AppointmentMgr.getInstance();
                out.write(Tools.getJSONArrayAsString(appointmentMgr.getLastComment(request.getParameter("clientID"))));
                break;
            case 32:
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(commentsMgr.getClientFirstComment(request.getParameter("clientID"))));
                break;
            case 33:
                servedPage = "/docs/client/client_my_last_comment.jsp";
                from = request.getParameter("from");
                to = request.getParameter("to");
                interCode = request.getParameter("interCode");
                if (from != null && to != null) {
                    String toPlusOneDay = to;
                    try {
                        SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
                        Date date = formatter.parse(to);
                        Calendar calendar = Calendar.getInstance();
                        calendar.setTime(date);
                        calendar.add(Calendar.DATE, 1);
                        toPlusOneDay = formatter.format(calendar.getTime());
                    } catch (ParseException ex) {
                        logger.error(ex);
                    }
                    clients = clientMgr.getClientsWithCommentsByOwnerDate((String) persistentUser.getAttribute("userId"), from, toPlusOneDay, interCode, null);
                    request.setAttribute("data", clients);
                    request.setAttribute("from", from);
                    request.setAttribute("to", to);
                    request.setAttribute("interCode", interCode);
                }
                defaultCampaign = "";
                if (securityUser != null && securityUser.getDefaultCampaign() != null && !securityUser.getDefaultCampaign().isEmpty()) {
                    defaultCampaign = securityUser.getDefaultCampaign();
                    campaignMgr = CampaignMgr.getInstance();
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

            case 34:
                fromDateS = request.getParameter("fromDate");
                toDateS = request.getParameter("toDate");
                subject = request.getParameter("subject");
                user = (WebBusinessObject) session.getAttribute("loggedUser");
                createdBy = (String) loggedUser.getAttribute("userId");

                commentsMgr = CommentsMgr.getInstance();
                ArrayList<WebBusinessObject> clntCmnts = commentsMgr.getClientCommentsExcel(fromDateS, toDateS, createdBy, subject);

                String headers[] = {"#", "Client No.", "Client Name", "Mobile", "International No.", "Email", "Addition Time", "Comment", "Comment Addition Time"};
                String attributes[] = {"Number", "clntNo", "clntNm", "mbl", "intrCl", "mail", "addtionTime", "cmntDsc", "creationTime"};
                String dataTypes[] = {"", "String", "String", "String", "String", "String", "String", "String", "String"};
                String[] headerStr = new String[1];
                headerStr[0] = "Clients_Comment";
                HSSFWorkbook workBook = Tools.createExcelReport("Clients Comment", headerStr, null, headers, attributes, dataTypes, clntCmnts);
                Calendar c = Calendar.getInstance();
                java.util.Date fileDate = c.getTime();
                sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                sdf.applyPattern("yyyy-MM-dd");
                String reportDate = sdf.format(fileDate);
                String filename = "ClientsComment" + reportDate;
                try (ServletOutputStream servletOutputStream = response.getOutputStream()) {
                    ByteArrayOutputStream bos = new ByteArrayOutputStream();
                    try {
                        workBook.write(bos);
                    } finally {
                        bos.close();
                    }

                    byte[] bytes = bos.toByteArray();
                    response.setContentType("application/vnd.ms-excel");
                    response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + ".xls\"");
                    response.setContentLength(bytes.length);
                    servletOutputStream.write(bytes, 0, bytes.length);
                    servletOutputStream.flush();
                }
                break;
            case 35:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                ClientSurveyMgr clientSurveyMgr = ClientSurveyMgr.getInstance();
                try {
                    clientSurveyMgr.deleteOnArbitraryKey(request.getParameter("clientID"), "key1");
                } catch (Exception ex) {
                    Logger.getLogger(CommentsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                String[] ratesArr = request.getParameter("rateVal").split(",");
                String[] questionIDsArr = request.getParameter("questionID").split(",");
                ArrayList<LiteWebBusinessObject> surveyList = new ArrayList<>();
                LiteWebBusinessObject surveyWbo;
                for (int i = 0; i < ratesArr.length; i++) {
                    surveyWbo = new LiteWebBusinessObject();
                    surveyWbo.setAttribute("clientID", request.getParameter("clientID"));
                    surveyWbo.setAttribute("questionID", questionIDsArr[i]);
                    surveyWbo.setAttribute("rate", Integer.valueOf(ratesArr[i]));
                    surveyWbo.setAttribute("userID", (String) persistentUser.getAttribute("userId"));
                    surveyWbo.setAttribute("option1", "UL");
                    surveyWbo.setAttribute("option2", "UL");
                    surveyWbo.setAttribute("option3", "UL");
                    surveyWbo.setAttribute("option4", "UL");
                    surveyWbo.setAttribute("option5", "UL");
                    surveyWbo.setAttribute("option6", "UL");
                    surveyList.add(surveyWbo);
                }
                wbo.setAttribute("status", clientSurveyMgr.insertClientSurveyList(surveyList) ? "ok" : "fail");
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 36:
                servedPage = "/docs/survey/client_survey_stats.jsp";

                ArrayList<WebBusinessObject> suerveyQuesList = new ArrayList();
                ArrayList<LiteWebBusinessObject> questionRates = new ArrayList();

                String questionID = null;

                try {
                    suerveyQuesList = ProjectMgr.getInstance().getOnArbitraryKey2("SUR", "key6");
                    WebBusinessObject questionWbo = new WebBusinessObject();
                    questionWbo = suerveyQuesList.get(0);
                    long fromDateL = new Date().getTime();
                    long toDateL = new Date().getTime();
                    sdf = new SimpleDateFormat("yyyy/MM/dd");
                    if (request.getParameter("beginDate") != null) {
                        try {
                            fromDateL = sdf.parse(request.getParameter("beginDate")).getTime();
                        } catch (ParseException ex) {
                        }
                    }
                    if (request.getParameter("endDate") != null) {
                        try {
                            toDateL = sdf.parse(request.getParameter("endDate")).getTime();
                        } catch (ParseException ex) {
                        }
                    }

                    if (request.getParameter("questionID") == null) {
                        questionID = questionWbo.getAttribute("projectID").toString();
                    } else {
                        questionID = request.getParameter("questionID");
                    }

                    questionRates = ClientSurveyMgr.getInstance().getSurveyQuestionRates(questionID, fromDateL, toDateL);

                } catch (Exception ex) {
                    System.out.println("Get Survey Questions Error = " + ex.getMessage());
                }

                request.setAttribute("beginDate", request.getParameter("beginDate"));
                request.setAttribute("endDate", request.getParameter("endDate"));
                request.setAttribute("questionID", questionID);
                request.setAttribute("surveyQuestions", suerveyQuesList);
                request.setAttribute("questionRates", questionRates);

                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);
                break;

            case 37:
                servedPage = "/docs/survey/survey_stats.jsp";

                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                request.setAttribute("toDate", sdf.format(cal.getTime()));
                cal.add(Calendar.MONTH, -1);
                request.setAttribute("fromDate", sdf.format(cal.getTime()));

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 38:
                servedPage = "/docs/survey/survey_stats.jsp";

                ArrayList graphResultList = new ArrayList();
                ArrayList second_graphResultList = new ArrayList();
                ArrayList<String> questionNameList = new ArrayList();
                ArrayList<String> surveyStatNames = new ArrayList();

                surveyStatNames.add("Satisfyed");
                surveyStatNames.add("Some Satisfyed");
                surveyStatNames.add("DisSatisfyed");

                long fromDateL = new Date().getTime();
                long toDateL = new Date().getTime();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (request.getParameter("beginDate") != null) {
                    try {
                        fromDateL = sdf.parse(request.getParameter("beginDate")).getTime();
                    } catch (ParseException ex) {
                    }
                }
                if (request.getParameter("endDate") != null) {
                    try {
                        toDateL = sdf.parse(request.getParameter("endDate")).getTime();
                    } catch (ParseException ex) {
                    }
                }

                try {
                    ArrayList<WebBusinessObject> questionsList = ProjectMgr.getInstance().getOnArbitraryKey2("SUR", "key4");

                    if (questionsList != null && questionsList.size() > 0) {
                        for (WebBusinessObject quesWbo : questionsList) {
                            questionNameList.add(quesWbo.getAttribute("projectName").toString());
                        }

                        ArrayList<LiteWebBusinessObject> quesStatList = ClientSurveyMgr.getInstance().getSurveyStatsByQues(fromDateL, toDateL);

                        ArrayList quesSatsRates = new ArrayList();
                        ArrayList quesSomeSatsRates = new ArrayList();
                        ArrayList quesDisSatsRates = new ArrayList();

                        for (LiteWebBusinessObject quesWbo : quesStatList) {
                            //Perparation date for the first graph
                            quesSatsRates.add(quesWbo.getAttribute("sats"));
                            quesSomeSatsRates.add(quesWbo.getAttribute("someSats"));
                            quesDisSatsRates.add(quesWbo.getAttribute("disSats"));

                            //Perparation date for the second graph
                            ArrayList quesTemp = new ArrayList();
                            Map<String, Object> second_graphDataMap = new HashMap<String, Object>();

                            quesTemp.add(quesWbo.getAttribute("sats"));
                            quesTemp.add(quesWbo.getAttribute("someSats"));
                            quesTemp.add(quesWbo.getAttribute("disSats"));

                            second_graphDataMap.put("name", quesWbo.getAttribute("question"));
                            second_graphDataMap.put("data", quesTemp);

                            second_graphResultList.add(second_graphDataMap);
                        }

                        Map<String, Object> graphDataMap = new HashMap<String, Object>();
                        graphDataMap.put("name", "Satisfyed");
                        graphDataMap.put("data", quesSatsRates);
                        graphResultList.add(graphDataMap);

                        graphDataMap = new HashMap<String, Object>();
                        graphDataMap.put("name", "Some Satisfyed");
                        graphDataMap.put("data", quesSomeSatsRates);
                        graphResultList.add(graphDataMap);

                        graphDataMap = new HashMap<String, Object>();
                        graphDataMap.put("name", "Dis Satisfyed");
                        graphDataMap.put("data", quesDisSatsRates);
                        graphResultList.add(graphDataMap);

                        String questionsNameList = JSONValue.toJSONString(questionNameList);
                        String resultsJson = JSONValue.toJSONString(graphResultList);

                        String surveyStatNamesJSON = JSONValue.toJSONString(surveyStatNames);
                        String second_resultsJson = JSONValue.toJSONString(second_graphResultList);

                        request.setAttribute("questionsNameList", questionsNameList);
                        request.setAttribute("resultsJson", resultsJson);

                        request.setAttribute("surveyStatNamesJSON", surveyStatNamesJSON);
                        request.setAttribute("second_resultsJson", second_resultsJson);

                        request.setAttribute("graphResult", quesStatList);
                        request.setAttribute("questionNameList", questionNameList);
                    }
                } catch (Exception ex) {
                    Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("fromDate", request.getParameter("beginDate"));
                request.setAttribute("toDate", request.getParameter("endDate"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 39:
                servedPage = "/docs/survey/client_survey_stats_detailed.jsp";

                suerveyQuesList = new ArrayList();
                questionRates = new ArrayList();

                try {
                    suerveyQuesList = ProjectMgr.getInstance().getOnArbitraryKey2("SUR", "key6");
                    WebBusinessObject questionWbo = new WebBusinessObject();
                    questionWbo = suerveyQuesList.get(0);
                    fromDateL = new Date().getTime();
                    toDateL = new Date().getTime();
                    sdf = new SimpleDateFormat("yyyy/MM/dd");
                    if (request.getParameter("beginDate") != null) {
                        try {
                            fromDateL = sdf.parse(request.getParameter("beginDate")).getTime();
                        } catch (ParseException ex) {
                        }
                    }
                    if (request.getParameter("endDate") != null) {
                        try {
                            toDateL = sdf.parse(request.getParameter("endDate")).getTime();
                        } catch (ParseException ex) {
                        }
                    }

                    questionRates = ClientSurveyMgr.getInstance().getSurveyQuestionRatesDetails(fromDateL, toDateL);

                } catch (Exception ex) {
                    System.out.println("Get Survey Questions Error = " + ex.getMessage());
                }

                request.setAttribute("beginDate", request.getParameter("beginDate"));
                request.setAttribute("endDate", request.getParameter("endDate"));
                request.setAttribute("surveyQuestions", suerveyQuesList);
                request.setAttribute("questionRates", questionRates);

                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);
                break;
                
            case 40:
                PDFTools pdfTolls = new PDFTools();

                HashMap repParameters = new HashMap();

                repParameters.put("beginDate", request.getParameter("beginDate"));
                repParameters.put("endDate", request.getParameter("endDate"));

                pdfTolls.generatePdfReportWithStarsImgs("ClientSurvey", repParameters, getServletContext(), response);
                break;
            case 41:
                try {
                    String[] ids = request.getParameter("ids").split(",");
                    for (String id : ids) {
                        if (commentsMgr.saveComment(id, (String) persistentUser.getAttribute("userId"),
                                request.getParameter("type"), request.getParameter("businessObjectType"), request.getParameter("comment"), "UL",
                                request.getParameter("option2") != null ? request.getParameter("option2") : "UL")) {
                            wbo.setAttribute("status", "ok");
                        } else {
                            wbo.setAttribute("status", "no");
                        }
                    }
                } catch (NoUserInSessionException | SQLException ex) {
                    logger.error(ex);
                }
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
                case 42:
                out = response.getWriter();
                campaignMgr = CampaignMgr.getInstance();
                String[] seasonTypes = request.getParameterValues("seasonTypeF"); // array من القيم المختارة

                if (seasonTypes != null) {
                    for (String s : seasonTypes) {
                        System.out.println("Selected seasonTypeF: " + s);
                    }
                }
                String[] departmentIds = request.getParameterValues("seasonTypeF"); // array من القيم المختارة
                List<WebBusinessObject> campaignFList = campaignMgr.getCampaignsF(departmentIds);
                out.write(Tools.getJSONArrayAsString(campaignFList));

                break;
            
            default:
                System.out.println("No operation was matched");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Tables Direction Servlet";
    }

    @Override
    protected int getOpCode(String opName
    ) {
        if (opName.equals("saveComment")) {
            return 1;
        } else if (opName.equals("saveChannelComment")) {
            return 2;
        } else if (opName.equals("showComments")) {
            return 3;
        } else if (opName.equals("commentsCountAjax")) {
            return 4;
        } else if (opName.equals("getLastCommentWithClient")) {
            return 5;
        } else if (opName.equals("getLastCommentWithClientExcel")) {
            return 6;
        } else if (opName.equals("getCommentsHistoryReport")) {
            return 7;
        } else if (opName.equals("showCommentsPopup")) {
            return 8;
        } else if (opName.equals("getNewCommentForm")) {
            return 9;
        } else if (opName.equals("showCommentsDialog")) {
            return 10;
        } else if (opName.equals("getUpdateCommentDialog")) {
            return 11;
        } else if (opName.equals("updateCommentAjax")) {
            return 12;
        } else if (opName.equals("getDelayWorkPDF")) {
            return 13;
        } else if (opName.equals("getCommentResponseInterval")) {
            return 14;
        } else if (opName.equals("updateCommentOwnerAjax")) {
            return 15;
        } else if (opName.equals("getAllClientComments")) {
            return 16;
        } else if (opName.equals("showGenralClientCommentsPopup")) {
            return 17;
        } else if (opName.equals("viewFinishCloseComments")) {
            return 18;
        } else if (opName.equals("viewAllComments")) {
            return 19;
        } else if (opName.equals("viewAllIssueComments")) {
            return 20;
        } else if (opName.equals("getThreeCommentResponseInterval")) {
            return 21;
        } else if (opName.equals("getEmptyThirdCommentResponseInterval")) {
            return 22;
        } else if (opName.equals("getClientCommentResponseInterval")) {
            return 23;
        } else if (opName.equals("showClientComments")) {
            return 24;
        } else if (opName.equals("getClientCommentsPDF")) {
            return 25;
        } else if (opName.equals("employeeWork")) {
            return 26;
        } else if (opName.equals("getEmptyThirdCommentResponseIntervalPDF")) {
            return 27;
        } else if (opName.equals("myComments")) {
            return 28;
        } else if (opName.equals("getEmployeesList")) {
            return 29;
        } else if (opName.equals("getProjectsList")) {
            return 30;
        } else if (opName.equals("getLastComment")) {
            return 31;
        } else if (opName.equals("getFirstCommentAjax")) {
            return 32;
        } else if (opName.equals("getMyLastCommentWithClient")) {
            return 33;
        } else if (opName.equals("getAllClientCommentsExcel")) {
            return 34;
        } else if (opName.equals("saveClientSurveyAjax")) {
            return 35;
        } else if (opName.equals("SurveyStatByClient")) {
            return 36;
        } else if (opName.equals("getSurveyStats")) {
            return 37;
        } else if (opName.equals("viewSurveyStats")) {
            return 38;
        } else if (opName.equals("SurveyStatDetailedByClient")) {
            return 39;
        } else if (opName.equals("SurveyStatDetailedPDF")) {
            return 40;
        } else if (opName.equals("saveMultiCommentsAjax")) {
            return 41;
        } else if (opName.equals("getCampaignsF")) {
            return 42;
        } 
        return 0;
    }
}
