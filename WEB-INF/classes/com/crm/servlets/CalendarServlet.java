package com.crm.servlets;

import com.clients.db_access.AppointmentMgr;
import com.clients.db_access.AppointmentNotificationMgr;
import com.crm.common.CalendarUtils;
import com.maintenance.common.Tools;
import com.maintenance.common.UserDepartmentConfigMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.common.UserMgr;
import com.tracker.db_access.ProjectMgr;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.tracker.servlets.TrackerBaseServlet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.commons.lang.time.DateUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

public class CalendarServlet extends TrackerBaseServlet {

    AppointmentNotificationMgr notificationMgr;
    private AppointmentMgr appointmentMgr;
    private WebBusinessObject monthWbo;
    private List<WebBusinessObject> list;
    private Map<String, Map<String, WebBusinessObject>> appointmentInfo;
    private CalendarUtils utils;
    private Calendar calendar;
    private Calendar calendarFrom, calendarTo;
    private List<Integer> years;
    private List<CalendarUtils.Month> months;
    private List<CalendarUtils.Day> days;
    private Hashtable<String, String> data;
    private String[] monthsArray;
    private String date;
    private int selectedYear;
    private int selectedMonth;
    private int day;
    private int month;
    private int year;
    private int minDate;
    private int maxDate;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
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
        appointmentMgr = AppointmentMgr.getInstance();
        notificationMgr = AppointmentNotificationMgr.getInstance();
        utils = CalendarUtils.getInstance();
        years = utils.getDefaultYears();
        months = utils.getMonths();
        calendar = utils.getCalendar();
        monthsArray = new String[]{"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
        try {
            switch (operation) {
                case 1:
                    servedPage = "/docs/calender/calendar.jsp";
                    if (request.getParameter("month") != null) {
                        month = Integer.parseInt(request.getParameter("month"));
                        if (month > 11) {
                            month = calendar.get(Calendar.MONTH);
                        }
                    } else {
                        month = calendar.get(Calendar.MONTH);
                    }
                    year = request.getParameter("year") != null ? Integer.parseInt(request.getParameter("year")) : calendar.get(Calendar.YEAR);
                    monthWbo = new WebBusinessObject();
                    monthWbo.setAttribute("id", new Integer(month).toString());
                    monthWbo.setAttribute("name", monthsArray[month]);

                    data = new Hashtable<String, String>();
                    for (int d = 1; d < 32; d++) {
                        date = year + "/" + (month + 1) + "/" + d;
                        data.put(d + "", appointmentMgr.getCountAppointmentsDates(loggegUserId, date));
                    }

                    if (month == calendar.get(Calendar.MONTH) && year == calendar.get(Calendar.YEAR)) {
                        day = calendar.get(Calendar.DATE);
                    } else if (month > calendar.get(Calendar.MONTH) || year  > calendar.get(Calendar.YEAR)) {
                        day = 1;
                    } else {
                        day = 32;
                    }

                    ArrayList<String> yearsList = new ArrayList<String>();
                    for (Integer y : years) {
                        yearsList.add(y.toString());
                    }
        
                    request.setAttribute("currentDay", day);
                    request.setAttribute("month", monthWbo);
                    request.setAttribute("years", yearsList);
                    request.setAttribute("year", year);
                    request.setAttribute("userId", loggegUserId);
                    request.setAttribute("data", data);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 2:
                    servedPage = "/docs/calender/calendar_supprot.jsp";
                    if (request.getParameter("month") != null) {
                        month = Integer.parseInt(request.getParameter("month"));
                        if (month > 11) {
                            month = calendar.get(Calendar.MONTH);
                        }
                    } else {
                        month = calendar.get(Calendar.MONTH);
                    }
                    year = calendar.get(Calendar.YEAR);
                    monthWbo = new WebBusinessObject();
                    monthWbo.setAttribute("id", new Integer(month).toString());
                    monthWbo.setAttribute("name", monthsArray[month]);

                    data = new Hashtable<String, String>();
                    for (int day = 1; day < 32; day++) {
                        date = year + "/" + (month + 1) + "/" + day;
                        data.put(day + "", appointmentMgr.getCountAppointmentsDates(loggegUserId, date));
                    }

                    request.setAttribute("month", monthWbo);
                    request.setAttribute("userId", loggegUserId);
                    request.setAttribute("data", data);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 3:
                    servedPage = "/docs/calender/calendar_1.jsp";
                    if (request.getParameter("month") != null) {
                        month = Integer.parseInt(request.getParameter("month"));
                        if (month > 11) {
                            month = calendar.get(Calendar.MONTH);
                        }
                    } else {
                        month = calendar.get(Calendar.MONTH);
                    }
                    year = calendar.get(Calendar.YEAR);
                    monthWbo = new WebBusinessObject();
                    monthWbo.setAttribute("id", new Integer(month).toString());
                    monthWbo.setAttribute("name", monthsArray[month]);

                    data = new Hashtable<String, String>();
                    for (int d = 1; d < 32; d++) {
                        date = year + "/" + (month + 1) + "/" + d;
                        data.put(d + "", appointmentMgr.getCountAppointmentsDates(loggegUserId, date));
                    }

                    if (month == calendar.get(Calendar.MONTH)) {
                        day = calendar.get(Calendar.DATE);
                    } else {
                        day = 1;
                    }

                    request.setAttribute("currentDay", day);
                    request.setAttribute("month", monthWbo);
                    request.setAttribute("userId", loggegUserId);
                    request.setAttribute("data", data);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 4:
                    servedPage = "/docs/calendar/generic_appointment.jsp";
                    selectedYear = (request.getParameter("selectedYear") == null) ? calendar.get(Calendar.YEAR) : Integer.parseInt(request.getParameter("selectedYear"));
                    selectedMonth = (request.getParameter("selectedMonth") == null) ? calendar.get(Calendar.MONTH) : Integer.parseInt(request.getParameter("selectedMonth"));
                    String selectedDepartment = request.getParameter("departmentID");
                    ProjectMgr projectMgr = ProjectMgr.getInstance();
                    boolean canViewAll = false;
                    MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
                    calendarFrom = utils.getCalendar(selectedYear, selectedMonth);
                    days = utils.getDaysShort(calendarFrom, 1);
                    try {
                        UserDepartmentConfigMgr userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                        ArrayList<WebBusinessObject> userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                        ArrayList<WebBusinessObject> departments = new ArrayList<>();
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
                            list = notificationMgr.getAppointmentByDate(days.get(0).getDate(), days.get(days.size() - 1).getDate(), selectedDepartment, null);
                        }
                        request.setAttribute("departments", departments);
                    } catch (Exception ex) {
                        Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    appointmentInfo = new HashMap<String, Map<String, WebBusinessObject>>();
                    Map<String, WebBusinessObject> appointmentDay;

                    String clientId;
                    String clientName;
                    int appointmentDayValue;
                    for (WebBusinessObject appointment : list) {
                        clientId = (String) appointment.getAttribute("clientId");
                        clientName = (String) appointment.getAttribute("clientName");
                        appointmentDay = appointmentInfo.get(clientId + "@@" + clientName);
                        if (appointmentDay == null) {
                            appointmentDay = new HashMap();
                            appointmentInfo.put(clientId + "@@" + clientName, appointmentDay);
                        }

                        try {
                            appointmentDayValue = Integer.parseInt((String) appointment.getAttribute("dayNo"));
                            appointmentDay.put(appointmentDayValue + "", appointment);
                        } catch (NumberFormatException ex) {
                            logger.error(ex);
                        }
                    }

                    request.setAttribute("page", servedPage);
                    request.setAttribute("data", appointmentInfo);
                    request.setAttribute("years", years);
                    request.setAttribute("months", months);
                    request.setAttribute("days", days);
                    request.setAttribute("departmentID", selectedDepartment);
                    request.setAttribute("selectedYear", selectedYear);
                    request.setAttribute("selectedMonth", selectedMonth);
                    this.forwardToServedPage(request, response);
                    break;
                case 5:
                    servedPage = "/docs/calendar/user_appointments.jsp";
                    selectedYear = (request.getParameter("selectedYear") == null) ? calendar.get(Calendar.YEAR) : Integer.parseInt(request.getParameter("selectedYear"));
                    selectedMonth = (request.getParameter("selectedMonth") == null) ? calendar.get(Calendar.MONTH) : Integer.parseInt(request.getParameter("selectedMonth"));
                    String type = request.getParameter("type") != null ? request.getParameter("type") : "";
                    calendarFrom = utils.getCalendar(selectedYear, selectedMonth);
                    days = utils.getDaysShort(calendarFrom, 1);
                    String future1=(String) request.getParameter("future")!=null?(String) request.getParameter("future"):"0";
                    Date today = DateUtils.truncate(new Date(), Calendar.DAY_OF_MONTH);
                    SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM-dd");
                    
                    Calendar c1 = Calendar.getInstance();
                    c1.setTime(new Date()); // Now use today date.
                    c1.add(Calendar.HOUR, -24);
                    Date yes=c1.getTime();
                    if(future1.equals("today"))
                        list = notificationMgr.getAppointmentByDateAndUser(today, today, (String) loggedUser.getAttribute("userId"), type);
                    else if(future1.equals("yes"))
                        list = notificationMgr.getAppointmentByDateAndUser(null, days.get(days.size() - 1).getDate(), (String) loggedUser.getAttribute("userId"), type);
                    else if(future1.equals("no"))
                        list = notificationMgr.getAppointmentByDateAndUser(days.get(0).getDate(), null, (String) loggedUser.getAttribute("userId"), type);
                    else if(future1.equals("selectedDate")){
                        year = Integer.parseInt(request.getParameter("currentYear"));
                        month = Integer.parseInt(request.getParameter("currentMonth"));
                        day = Integer.parseInt(request.getParameter("day"));

                        Date selectedDate = utils.getDate(year, month, day);
                        list = notificationMgr.getAppointmentByDateAndUser(selectedDate, selectedDate, (String) loggedUser.getAttribute("userId"), type);
                        request.setAttribute("selectedDate",sdf1.format(selectedDate).toString());
                        
                    } else 
                        list = notificationMgr.getAppointmentByDateAndUser(days.get(0).getDate(), days.get(days.size() - 1).getDate(), (String) loggedUser.getAttribute("userId"), type);

                    appointmentInfo = new HashMap<String, Map<String, WebBusinessObject>>();
                    Map<String, String> clientMobile = new HashMap<>();
                    projectMgr = ProjectMgr.getInstance();

                    for (WebBusinessObject appointment : list) {
                        clientId = (String) appointment.getAttribute("clientId");
                        clientName = (String) appointment.getAttribute("clientName");
                        appointmentDay = appointmentInfo.get(clientId + "@@" + clientName);
                        if (appointmentDay == null) {
                            appointmentDay = new HashMap();
                            appointmentInfo.put(clientId + "@@" + clientName, appointmentDay);
                        }
                        try {
                            appointmentDayValue = Integer.parseInt((String) appointment.getAttribute("dayNo"));
                            appointmentDay.put(appointmentDayValue + "", appointment);
                        } catch (NumberFormatException ex) {
                            logger.error(ex);
                        }
                        clientMobile.put(clientId, (String) appointment.getAttribute("mobile"));
                    }
                   
                    request.setAttribute("future", request.getParameter("future"));
                    request.setAttribute("page", servedPage);
                    request.setAttribute("data", appointmentInfo);
                    request.setAttribute("years", years);
                    request.setAttribute("months", months);
                    request.setAttribute("days", days);
                    request.setAttribute("clientMobile", clientMobile);
                    
                   
                    
                    try {
                        request.setAttribute("departments", new ArrayList<WebBusinessObject>(ProjectMgr.getInstance().getOnArbitraryKeyOracle("div", "key4")));
                    } catch (Exception ex) {
                        Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    request.setAttribute("departmentID", request.getParameter("departmentID"));
                    request.setAttribute("selectedYear", selectedYear);
                    request.setAttribute("selectedMonth", selectedMonth);
                    request.setAttribute("typesList", projectMgr.getMeetingProjects());
                    request.setAttribute("type", type);
                    this.forwardToServedPage(request, response);
                    break;
                case 6:
                    servedPage = "/docs/calendar/user_appointment_calendar.jsp";
                    selectedYear = (request.getParameter("selectedYear") == null) ? calendar.get(Calendar.YEAR) : Integer.parseInt(request.getParameter("selectedYear"));
                    selectedMonth = (request.getParameter("selectedMonth") == null) ? calendar.get(Calendar.MONTH) : Integer.parseInt(request.getParameter("selectedMonth"));
                    selectedDepartment = request.getParameter("departmentID");
                    projectMgr = ProjectMgr.getInstance();
                    canViewAll = false;
                    metaDataMgr = MetaDataMgr.getInstance();
                    calendarFrom = utils.getCalendar(selectedYear, selectedMonth);
                    days = utils.getDaysShort(calendarFrom, 1);
                    try {
                        UserDepartmentConfigMgr userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                        ArrayList<WebBusinessObject> userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                        ArrayList<WebBusinessObject> departments = new ArrayList<>();
                        for (WebBusinessObject userDepartmentWbo : userDepartments) {
                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }
                        if(departments.isEmpty()) {
                            WebBusinessObject wboTemp = new WebBusinessObject();
                            wboTemp.setAttribute("projectName", "لا يوجد");
                            wboTemp.setAttribute("projectID", "none");
                            departments.add(wboTemp);
                            list = new ArrayList<>();
                        } else {
                            if (selectedDepartment == null) {
                                selectedDepartment = (String) departments.get(0).getAttribute("projectID");
                            }
                            list = notificationMgr.getAppointmentByDate(days.get(0).getDate(), days.get(days.size() - 1).getDate(), selectedDepartment, null);
                        }
                        request.setAttribute("departments", departments);
                    } catch (Exception ex) {
                        Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    appointmentInfo = new HashMap<String, Map<String, WebBusinessObject>>();
                    String userId, userName;
                    for (WebBusinessObject appointment : list) {
                        userId = (String) appointment.getAttribute("userId");
                        userName = (String) appointment.getAttribute("userName");
                        appointmentDay = appointmentInfo.get(userId + "@@" + userName);
                        if (appointmentDay == null) {
                            appointmentDay = new HashMap();
                            appointmentInfo.put(userId + "@@" + userName, appointmentDay);
                        }

                        try {
                            appointmentDayValue = Integer.parseInt((String) appointment.getAttribute("dayNo"));
                            appointmentDay.put(appointmentDayValue + "", appointment);
                        } catch (NumberFormatException ex) {
                            logger.error(ex);
                        }
                    }

                    request.setAttribute("page", servedPage);
                    request.setAttribute("data", appointmentInfo);
                    request.setAttribute("years", years);
                    request.setAttribute("months", months);
                    request.setAttribute("days", days);
                    request.setAttribute("departmentID", selectedDepartment);
                    request.setAttribute("selectedYear", selectedYear);
                    request.setAttribute("selectedMonth", selectedMonth);
                    this.forwardToServedPage(request, response);
                    break;
		    
		case 7:
                    servedPage = "/docs/calendar/userVisitsCalendar.jsp";
                    selectedYear = (request.getParameter("selectedYear") == null) ? calendar.get(Calendar.YEAR) : Integer.parseInt(request.getParameter("selectedYear"));
                    selectedMonth = (request.getParameter("selectedMonth") == null) ? calendar.get(Calendar.MONTH) : Integer.parseInt(request.getParameter("selectedMonth"));
                    selectedDepartment = request.getParameter("departmentID");
                    projectMgr = ProjectMgr.getInstance();
                    canViewAll = false;
                    metaDataMgr = MetaDataMgr.getInstance();
                    calendarFrom = utils.getCalendar(selectedYear, selectedMonth);
                    days = utils.getDaysShort(calendarFrom, 1);
                    try {
                        UserDepartmentConfigMgr userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                        ArrayList<WebBusinessObject> userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                        ArrayList<WebBusinessObject> departments = new ArrayList<>();
                        for (WebBusinessObject userDepartmentWbo : userDepartments) {
                            departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }
                        if(departments.isEmpty()) {
                            WebBusinessObject wboTemp = new WebBusinessObject();
                            wboTemp.setAttribute("projectName", "لا يوجد");
                            wboTemp.setAttribute("projectID", "none");
                            departments.add(wboTemp);
                            list = new ArrayList<>();
                        } else {
                            if (selectedDepartment == null) {
                                selectedDepartment = (String) departments.get(0).getAttribute("projectID");
                            }
                            list = notificationMgr.getAppointmentByDate(days.get(0).getDate(), days.get(days.size() - 1).getDate(), selectedDepartment, "meeting");
                        }
                        request.setAttribute("departments", departments);
                    } catch (Exception ex) {
                        Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    appointmentInfo = new HashMap<String, Map<String, WebBusinessObject>>();
                    for (WebBusinessObject appointment : list) {
                        userId = (String) appointment.getAttribute("userId");
                        userName = (String) appointment.getAttribute("userName");
                        appointmentDay = appointmentInfo.get(userId + "@@" + userName);
                        if (appointmentDay == null) {
                            appointmentDay = new HashMap();
                            appointmentInfo.put(userId + "@@" + userName, appointmentDay);
                        }

                        try {
                            appointmentDayValue = Integer.parseInt((String) appointment.getAttribute("dayNo"));
                            appointmentDay.put(appointmentDayValue + "", appointment);
                        } catch (NumberFormatException ex) {
                            logger.error(ex);
                        }
                    }

                    request.setAttribute("page", servedPage);
                    request.setAttribute("data", appointmentInfo);
                    request.setAttribute("years", years);
                    request.setAttribute("months", months);
                    request.setAttribute("days", days);
                    request.setAttribute("departmentID", selectedDepartment);
                    request.setAttribute("selectedYear", selectedYear);
                    request.setAttribute("selectedMonth", selectedMonth);
                    this.forwardToServedPage(request, response);
                    break;
                
                case 8:
                    servedPage = "/docs/calendar/user_appointments.jsp";
                    selectedYear = (request.getParameter("selectedYear") == null) ? calendar.get(Calendar.YEAR) : Integer.parseInt(request.getParameter("selectedYear"));
                    selectedMonth = (request.getParameter("selectedMonth") == null) ? calendar.get(Calendar.MONTH) : Integer.parseInt(request.getParameter("selectedMonth"));
                    type = request.getParameter("type") != null ? request.getParameter("type") : "";
                    String reportType = request.getParameter("reportType") != null ? request.getParameter("reportType") : "meeting";
                    calendarFrom = utils.getCalendar(selectedYear, selectedMonth);
                    days = utils.getDaysShort(calendarFrom, 1);
                    list = notificationMgr.getMeetingsByDateAndUser(days.get(0).getDate(), days.get(days.size() - 1).getDate(), (String) loggedUser.getAttribute("userId"), type);
                    appointmentInfo = new HashMap<String, Map<String, WebBusinessObject>>();
                    clientMobile = new HashMap<>();
                    projectMgr = ProjectMgr.getInstance();
                    
                    for (WebBusinessObject appointment : list) {
                        clientId = (String) appointment.getAttribute("clientId");
                        clientName = (String) appointment.getAttribute("clientName");
                        appointmentDay = appointmentInfo.get(clientId + "@@" + clientName);
                        if (appointmentDay == null) {
                            appointmentDay = new HashMap();
                            appointmentInfo.put(clientId + "@@" + clientName, appointmentDay);
                        }
                        try {
                            appointmentDayValue = Integer.parseInt((String) appointment.getAttribute("dayNo"));
                            appointmentDay.put(appointmentDayValue + "", appointment);
                        } catch (NumberFormatException ex) {
                            logger.error(ex);
                        }
                        clientMobile.put(clientId, (String) appointment.getAttribute("mobile"));
                    }
                   
                     
                    request.setAttribute("page", servedPage);
                    request.setAttribute("data", appointmentInfo);
                    request.setAttribute("years", years);
                    request.setAttribute("months", months);
                    request.setAttribute("days", days);
                    request.setAttribute("clientMobile", clientMobile);
                    
                   
                    
                    try {
                        request.setAttribute("departments", new ArrayList<WebBusinessObject>(ProjectMgr.getInstance().getOnArbitraryKeyOracle("div", "key4")));
                    } catch (Exception ex) {
                        Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    request.setAttribute("departmentID", request.getParameter("departmentID"));
                    request.setAttribute("selectedYear", selectedYear);
                    request.setAttribute("selectedMonth", selectedMonth);
                    request.setAttribute("typesList", projectMgr.getMeetingProjects());
                    request.setAttribute("type", type);
                    request.setAttribute("reportType", reportType);
                    this.forwardToServedPage(request, response);
                    break;
                
                case 9:
                    servedPage = "/docs/calendar/user_appointments.jsp";
                    selectedYear = (request.getParameter("selectedYear") == null) ? calendar.get(Calendar.YEAR) : Integer.parseInt(request.getParameter("selectedYear"));
                    selectedMonth = (request.getParameter("selectedMonth") == null) ? calendar.get(Calendar.MONTH) : Integer.parseInt(request.getParameter("selectedMonth"));
                    type = request.getParameter("type") != null ? request.getParameter("type") : "";
                    reportType = request.getParameter("reportType") != null ? request.getParameter("reportType") : "call";
                    calendarFrom = utils.getCalendar(selectedYear, selectedMonth);
                    days = utils.getDaysShort(calendarFrom, 1);
                    list = notificationMgr.getCallsByDateAndUser(days.get(0).getDate(), days.get(days.size() - 1).getDate(), (String) loggedUser.getAttribute("userId"), type);
                    appointmentInfo = new HashMap<String, Map<String, WebBusinessObject>>();
                    clientMobile = new HashMap<>();
                    projectMgr = ProjectMgr.getInstance();

                    for (WebBusinessObject appointment : list) {
                        clientId = (String) appointment.getAttribute("clientId");
                        clientName = (String) appointment.getAttribute("clientName");
                        appointmentDay = appointmentInfo.get(clientId + "@@" + clientName);
                        if (appointmentDay == null) {
                            appointmentDay = new HashMap();
                            appointmentInfo.put(clientId + "@@" + clientName, appointmentDay);
                        }
                        try {
                            appointmentDayValue = Integer.parseInt((String) appointment.getAttribute("dayNo"));
                            appointmentDay.put(appointmentDayValue + "", appointment);
                        } catch (NumberFormatException ex) {
                            logger.error(ex);
                        }
                        clientMobile.put(clientId, (String) appointment.getAttribute("mobile"));
                    }
                   
                     
                    request.setAttribute("page", servedPage);
                    request.setAttribute("data", appointmentInfo);
                    request.setAttribute("years", years);
                    request.setAttribute("months", months);
                    request.setAttribute("days", days);
                    request.setAttribute("clientMobile", clientMobile);
                    
                   
                    
                    try {
                        request.setAttribute("departments", new ArrayList<WebBusinessObject>(ProjectMgr.getInstance().getOnArbitraryKeyOracle("div", "key4")));
                    } catch (Exception ex) {
                        Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    request.setAttribute("departmentID", request.getParameter("departmentID"));
                    request.setAttribute("selectedYear", selectedYear);
                    request.setAttribute("selectedMonth", selectedMonth);
                    request.setAttribute("typesList", projectMgr.getMeetingProjects());
                    request.setAttribute("type", type);
                    request.setAttribute("reportType", reportType);
                    this.forwardToServedPage(request, response);
                    break; 
                
                case 10:
                    StringBuilder title = new StringBuilder("Future Appointments");
                    Calendar c = Calendar.getInstance();
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    sdf.applyPattern("yyyy-MM-dd");
                    String startDate = sdf.format(c.getTime());
                    String future = (String) request.getParameter("future")!=null?(String) request.getParameter("future"):"0";
                    String typeU = (String)request.getParameter("type");
                    selectedYear = (request.getParameter("selectedYear") == null) ? calendar.get(Calendar.YEAR) : Integer.parseInt(request.getParameter("selectedYear"));
                    selectedMonth = (request.getParameter("selectedMonth") == null) ? calendar.get(Calendar.MONTH) : Integer.parseInt(request.getParameter("selectedMonth"));
                     type = request.getParameter("type") != null ? request.getParameter("type") : "";
                    calendarFrom = utils.getCalendar(selectedYear, selectedMonth);
                    days = utils.getDaysShort(calendarFrom, 1);
                     Date from;
                     Date to;
                     today = DateUtils.truncate(new Date(), Calendar.DAY_OF_MONTH);
                     if (future.equalsIgnoreCase("today")){
                         from=today;to=today;
                     }else  if (future.equalsIgnoreCase("yes")){
                         from=null;to= days.get(days.size() - 1).getDate();
                      }else  if (future.equalsIgnoreCase("no")){
                          from=days.get(0).getDate(); to=null;
                     }else {
                      from=days.get(0).getDate();
                      to= days.get(days.size() - 1).getDate();
                      }
                    if(typeU.equalsIgnoreCase("manager")){
                        String departmentID = request.getParameter("departmentID");
                        ArrayList<WebBusinessObject> clientAppntsist = new ArrayList<>();
                        clientAppntsist = notificationMgr.getFutureAppointmentsExcel(from,to,departmentID, future);

                        title.append(" From : ").append(startDate); 
                        String headers[] = {"#", "Client Name", "Mobile", "International No", "Employee Name", "Registration Date", "Branch", "Call Result", "Future Appointment Date", "Contacting After","Appointment Type", "Notes"};
                        String attributes[] = {"Number", "clientName", "mobile", "interTel", "userName", "creationTime", "appointmentPlace", "note","appointmentDate", "duration","appTyp", "comment"};
                        String dataTypes[] = {"String", "String", "String", "String", "String","String", "String", "String", "String", "String", "String", "String"};
                        String[] headerStr = new String[1];
                        headerStr[0] = title.toString();
                        HSSFWorkbook workBook = Tools.createExcelReport("Employees Future Appointments", headerStr, null, headers, attributes, dataTypes, clientAppntsist);
                        c = Calendar.getInstance();
                        Date fileDate = c.getTime();
                        sdf = new SimpleDateFormat("yyyy-MM-dd");
                        String reportDate = sdf.format(fileDate);
                        String filename = "EmployeesFutureAppointments" + reportDate;
                        
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
                    } else {
                        loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                        loggegUserId = (String) loggedUser.getAttribute("userId");
                        UserMgr userMgr = UserMgr.getInstance();
                        String loggegUserName = userMgr.getOnSingleKey(loggegUserId).getAttribute("fullName").toString();
                        ArrayList<WebBusinessObject> clientAppntsist = new ArrayList<>();
                        clientAppntsist = notificationMgr.getFutureAppointmentByUserExcel(from,to,loggegUserId, future);

                        title.append(" Employee : ").append(loggegUserName);
                        title.append(" From : ").append(startDate); 
                        String headers[] = {"#", "Client Name", "Mobile", "International No", "Registration Date", "Branch", "Call Result", "Future Appointment Date", "Contacting After","Appointment Type", "Notes"};
                        String attributes[] = {"Number", "clientName", "mobile", "interTel", "creationTime", "appointmentPlace", "note","appointmentDate", "duration","appTyp", "comment"};
                        String dataTypes[] = {"String", "String", "String", "String", "String", "String", "String", "String", "String", "String", "String"};
                        String[] headerStr = new String[1];
                        headerStr[0] = title.toString();
                        HSSFWorkbook workBook = Tools.createExcelReport("Future Appointments", headerStr, null, headers, attributes, dataTypes, clientAppntsist);
                        c = Calendar.getInstance();
                        Date fileDate = c.getTime();
                        sdf = new SimpleDateFormat("yyyy-MM-dd");
                        String reportDate = sdf.format(fileDate);
                        String filename = "FutureAppointments" + reportDate;
                        
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
                    }
                    
                    
                    break;
                case 11:
                    servedPage = "/docs/calendar/my_appointment.jsp";
                    selectedYear = (request.getParameter("selectedYear") == null) ? calendar.get(Calendar.YEAR) : Integer.parseInt(request.getParameter("selectedYear"));
                    selectedMonth = (request.getParameter("selectedMonth") == null) ? calendar.get(Calendar.MONTH) : Integer.parseInt(request.getParameter("selectedMonth"));
                    projectMgr = ProjectMgr.getInstance();
                    canViewAll = false;
                    metaDataMgr = MetaDataMgr.getInstance();
                    calendarFrom = utils.getCalendar(selectedYear, selectedMonth);
                    days = utils.getDaysShort(calendarFrom, 1);
                    try {
                        list = notificationMgr.getMyAppointmentByDate(days.get(0).getDate(), days.get(days.size() - 1).getDate(), loggegUserId);
                    } catch (Exception ex) {
                        Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    appointmentInfo = new HashMap<>();
                    for (WebBusinessObject appointment : list) {
                        clientId = (String) appointment.getAttribute("clientId");
                        clientName = (String) appointment.getAttribute("clientName");
                        appointmentDay = appointmentInfo.get(clientId + "@@" + clientName);
                        if (appointmentDay == null) {
                            appointmentDay = new HashMap();
                            appointmentInfo.put(clientId + "@@" + clientName, appointmentDay);
                        }

                        try {
                            appointmentDayValue = Integer.parseInt((String) appointment.getAttribute("dayNo"));
                            appointmentDay.put(appointmentDayValue + "", appointment);
                        } catch (NumberFormatException ex) {
                            logger.error(ex);
                        }
                    }

                    request.setAttribute("page", servedPage);
                    request.setAttribute("data", appointmentInfo);
                    request.setAttribute("years", years);
                    request.setAttribute("months", months);
                    request.setAttribute("days", days);
                    request.setAttribute("selectedYear", selectedYear);
                    request.setAttribute("selectedMonth", selectedMonth);
                    this.forwardToServedPage(request, response);
                    break;
                default:
                    System.out.println("No operation was matched");
            }

        } catch (NumberFormatException ex) {
            System.out.println("Error Msg = " + ex.getMessage());
            logger.error(ex.getMessage());
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
        return "Search Servlet";
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("showCalendar")) {
            return 1;
        }
        if (opName.equalsIgnoreCase("showCalendarSupport")) {
            return 2;
        }
        if (opName.equalsIgnoreCase("showClientCalendar")) {
            return 3;
        }
        if (opName.equalsIgnoreCase("genericAppointmentCalendar")) {
            return 4;
        }
        if (opName.equalsIgnoreCase("getAppointmentsForUser")) {
            return 5;
        }
        if (opName.equalsIgnoreCase("getUsersAppointmentCalendar")) {
            return 6;
        }
	if (opName.equalsIgnoreCase("getUsersVisitsCalendar")) {
            return 7;
        }
        if (opName.equalsIgnoreCase("getUsersMeetingsCalendar")) {
            return 8;
        }
        if (opName.equalsIgnoreCase("getUsersCallsCalendar")) {
            return 9;
        }
        if (opName.equalsIgnoreCase("getFutureAppToEmpExcel")) {
            return 10;
        }
        if (opName.equalsIgnoreCase("getMyAppointments")) {
            return 11;
        }
       
        return 0;
    }
}
