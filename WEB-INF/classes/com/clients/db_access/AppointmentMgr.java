package com.clients.db_access;

import com.crm.common.CRMConstants;
import com.maintenance.common.DateParser;
import com.maintenance.common.Tools;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.common.SecurityUser;
import com.silkworm.common.UserGroupMgr;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.util.DateAndTimeControl;
import com.tracker.db_access.IssueMgr;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import com.tracker.db_access.ProjectMgr;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import java.util.ArrayList;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

public class AppointmentMgr extends RDBGateWay {

    private static final AppointmentMgr APPOINTMENT_MGR = new AppointmentMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static AppointmentMgr getInstance() {
        logger.info("Getting ClientProductMgr Instance ....");
        return APPOINTMENT_MGR;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("appointment.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("projectName"));
        }

        return cashedData;
    }

    public boolean deteleAppointment(String id) throws SQLException {
        Connection connection = null;
        try {

            int queryResult = -1000;
            Vector params = new Vector();
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();

            params.addElement(new StringValue(id));
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("deleteAppointment").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {

                return false;
            } else {
                return true;
            }
        } catch (SQLException ex) {
            Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        } finally {
            connection.setAutoCommit(true);
            connection.close();

        }
    }
    
    public boolean updateAppointmentResult(String id, String newResult) throws SQLException {
        Connection connection = null;
        try {

            int queryResult = -1000;
            Vector params = new Vector();
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();

            params.addElement(new StringValue(newResult));
            params.addElement(new StringValue(id));
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("updateAppointmentResultNewResult").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {

                return false;
            } else {
                return true;
            }
        } catch (SQLException ex) {
            Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        } finally {
            connection.setAutoCommit(true);
            connection.close();

        }
    }
    
    public boolean updateAppointmentFor(String id, String appointmentFor, String diretedBy) {
        SQLCommandBean forInsert = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        int result = -1000;

        parameters.addElement(new StringValue(appointmentFor));
        parameters.addElement(new StringValue(diretedBy));
        parameters.addElement(new StringValue(id));

        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("updateAppointmentFor").trim());
            forInsert.setparams(parameters);
            result = forInsert.executeUpdate();
        } catch (SQLException ex) {
            logger.error(ex);
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
                return false;
            }
        }

        if (result < 0) {
            return false;
        } else {
            return true;
        }
    }

    public boolean updateCurrentStatus(String id, String statusCode) {
        SQLCommandBean forInsert = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        int result = -1000;

        parameters.addElement(new StringValue(statusCode));
        parameters.addElement(new StringValue(id));

        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("updateCurrentStatus").trim());
            forInsert.setparams(parameters);
            result = forInsert.executeUpdate();
        } catch (SQLException ex) {
            logger.error(ex);
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
                return false;
            }
        }

        if (result < 0) {
            return false;
        } else {
            return true;
        }
    }

    public boolean ignoreAppointment(String appointmentId) {
        return updateCurrentStatus(appointmentId, CRMConstants.APPOINTMENT_STATUS_NEGLECTED);
    }

    public boolean caredAppointment(String appointmentId) {
        return updateCurrentStatus(appointmentId, CRMConstants.APPOINTMENT_STATUS_CARED);
    }

    public boolean doneAppointment(String appointmentId) {
        return updateCurrentStatus(appointmentId, CRMConstants.APPOINTMENT_STATUS_DONE);
    }

    public boolean updateAppointment(HttpServletRequest request, HttpSession s) throws SQLException, ParseException {
        WebBusinessObject loggedUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String jsDateFormat = loggedUser.getAttribute("jsDateFormat").toString();
        String userId = (String) loggedUser.getAttribute("userId");
        Connection connection = null;
        String date = request.getParameter("date");
        DateParser dateParser = new DateParser();
        boolean slash = date.contains("/");
        String splitchar = "-";
        if (slash) {
            splitchar = "/";
        }
        String[] dates = ((String) date.split(" ")[1]).split(splitchar);

        if (dates.length < 2) {
            dates = ((String) date.split(" ")[0]).split(splitchar);
        }
        String finalDate = dates[2] + "/" + dates[1] + "/" + dates[0];

        java.sql.Date bdate = dateParser.formatSqlDate(finalDate, jsDateFormat);

        // Haytham
        // option1 holds the Appointment Done Status
        // option2 holds the Appointment Mechanice Type (Phone - Internet - Meeting)
        // option3 holds the Appointment meeting way (Incoming - outgoing)
        String result = request.getParameter("result");
        String title = request.getParameter("title");
        String noteId = request.getParameter("note");
        String id = request.getParameter("appointmentId");
        String appDir = request.getParameter("appDir");
        String appStatus = request.getParameter("appStatus");
        String appType = request.getParameter("appType");
        // to add comment to appointment
        String comment = "";
        String privacy = request.getParameter("privacy");
        if (request.getParameter("comment") != null && !request.getParameter("comment").equals("&#13;&#10;")) {
            comment = request.getParameter("comment");
            Calendar cal = Calendar.getInstance();
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm a");
            comment = " " + comment + " On " + sdf.format(cal.getTime());
        }
        String callDuration = request.getParameter("callDuration") != null ? request.getParameter("callDuration") : "0";
        // if note equal call in x week
        String clientId = request.getParameter("clientId");
        String appointmentPlace = request.getParameter("appointmentPlace");
        String note = "UL";
        int delayValueByHour = 0;
        Calendar calendar = Calendar.getInstance();;
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        WebBusinessObject noteInfo = projectMgr.getOnSingleKey(noteId);
        if (noteInfo != null) {
            note = (String) noteInfo.getAttribute("projectName");
            String optionOne = (String) noteInfo.getAttribute("optionOne");
            if (optionOne != null) {
                // check optionOne contains int value
                try {
                    delayValueByHour = Integer.parseInt(optionOne);
                    if (delayValueByHour > 0) {
                        appStatus = "on";// close above appointment
                        calendar.setTime(bdate);
                        calendar.add(Calendar.HOUR, delayValueByHour);
                    }
                } catch (NumberFormatException ex) {
                }
            }
        } else if (request.getParameter("note") != null) {
            note = request.getParameter("note");
        }


        Vector parameters = new Vector();
        parameters.addElement(new StringValue(title));
        parameters.addElement(new StringValue(note));
        parameters.addElement(new DateValue(bdate));
        parameters.addElement(new StringValue(userId));
        parameters.addElement(new StringValue(appStatus));
        parameters.addElement(new StringValue(appType));
        parameters.addElement(new StringValue(appDir));
        parameters.addElement(new StringValue("update".equals(request.getParameter("type")) ? request.getParameter("currentStatus") : CRMConstants.APPOINTMENT_STATUS_CARED));
        parameters.addElement(new StringValue(comment));
        parameters.addElement(new StringValue(callDuration));
        parameters.addElement(new StringValue(appointmentPlace));
        parameters.addElement(new StringValue(result));
        parameters.addElement(new StringValue(id));

        try {
            int queryResult;
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();

            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("updateAppointment").trim());
            forInsert.setparams(parameters);
            queryResult = forInsert.executeUpdate();

            if (delayValueByHour > 0) {
                return (queryResult > 0) && saveAppointment(userId, clientId, title, calendar.getTime(), note, appType, appointmentPlace, null, null, comment, CRMConstants.APPOINTMENT_STATUS_OPEN, null, null, privacy, 0, null, null, "UL", null);
            }

            if (queryResult <= 0) {
                return false;
            } else {
                return true;
            }
        } catch (SQLException ex) {
            logger.error(ex);
            return false;
        } catch (NoUserInSessionException ex) {
            logger.error(ex);
            return false;
        } finally {
            connection.setAutoCommit(true);
            connection.close();
        }
    }

    public boolean updateAppointmentComment(String appointmentID, String comment, String branch, String duration) throws SQLException {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameter = new Vector();

        if(comment != null && !comment.equals("&#13;&#10;")) {
            Calendar cal = Calendar.getInstance();
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm a");
            comment = " " + comment + " On " + sdf.format(cal.getTime());
        }

        parameter.add(new StringValue(comment));
        parameter.add(new StringValue(branch));
        parameter.add(new StringValue(duration));
        parameter.add(new StringValue(appointmentID));
        int result = -1000;
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("updateAppointmentComment").trim());
            command.setparams(parameter);
            result = command.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        } catch (Exception e) {
            Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, e);
            return false;
        } finally {
            connection.setAutoCommit(true);
            connection.close();
        }
        return (result > 0);

    }

    public boolean updateAppointmentResult(String appointmentID, String appointmentResult, String nextAction) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameter = new Vector();
        parameter.add(new StringValue(appointmentResult));
        parameter.add(new StringValue(nextAction));
        parameter.add(new StringValue(appointmentID));
        int result = -1000;
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("updateAppointmentResult").trim());
            command.setparams(parameter);
            result = command.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        } catch (Exception e) {
            Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, e);
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return (result > 0);

    }

    public boolean acceptAppointment(String appointmentId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameter = new Vector();
        parameter.add(new StringValue(appointmentId));
        int result = -1000;
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("acceptAppointment").trim());
            command.setparams(parameter);
            result = command.executeUpdate();
        } catch (SQLException ex) {
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                return false;
            }
        }
        return (result > 0);
    }

    public boolean updateAppointmentNoteAndStatus(String appointmentId, String noteId) {
        WebBusinessObject appointment = APPOINTMENT_MGR.getOnSingleKey(appointmentId);
        WebBusinessObject noteInfo = ProjectMgr.getInstance().getOnSingleKey(noteId);
        if (appointment != null && noteInfo != null) {
            SQLCommandBean command = new SQLCommandBean();
            Connection connection = null;
            List<Vector> parameters = new ArrayList<Vector>();
            List<String> queries = new ArrayList<String>();
            Vector parameter;
            int result;

            String note = (String) noteInfo.getAttribute("projectName");
            int delayValueByHour = 0;
            String optionOne = (String) noteInfo.getAttribute("optionOne");
            if (optionOne != null) {
                // check optionOne contains int value
                try {
                    delayValueByHour = Integer.parseInt(optionOne);
                } catch (NumberFormatException ex) {
                }
            }

            parameter = new Vector();
            parameter.add(new StringValue(note));
            parameter.add(new StringValue(appointmentId));
            parameters.add(parameter);
            queries.add(getQuery("updateNote"));

            parameter = new Vector();
            parameter.add(new StringValue(CRMConstants.APPOINTMENT_STATUS_CARED));
            parameter.add(new StringValue(appointmentId));
            parameters.add(parameter);
            queries.add(getQuery("updateCurrentStatus"));

            if (delayValueByHour > 0) {
                Timestamp timestamp = APPOINTMENT_MGR.getByKeyColumnTimestamp(appointmentId, "key3");
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(timestamp);
                calendar.add(Calendar.HOUR, delayValueByHour);
                String userId = (String) appointment.getAttribute("userId");
                String clientId = (String) appointment.getAttribute("clientId");
                String title = (String) appointment.getAttribute("title");
                String appType = (String) appointment.getAttribute("option2");
                String appointmentPlace = (String) appointment.getAttribute("appointmentPlace");
                String issueId = (String) appointment.getAttribute("issueId");
                String clientComplaintId = (String) appointment.getAttribute("clientComplaintId");

                parameter = new Vector();
                String id = UniqueIDGen.getNextID();
                parameter.addElement(new StringValue(id));
                parameter.addElement(new StringValue(userId));
                parameter.addElement(new StringValue(clientId));
                parameter.addElement(new StringValue(note));
                parameter.addElement(new StringValue("UL"));
                parameter.addElement(new StringValue(appType));
                parameter.addElement(new StringValue("UL"));
                parameter.addElement(new StringValue(title));
                parameter.addElement(new TimestampValue(new Timestamp(calendar.getTime().getTime())));
                parameter.addElement(new StringValue(appointmentPlace));
                parameter.addElement(new StringValue(userId));
                parameter.addElement(new StringValue(issueId));
                parameter.addElement(new StringValue(clientComplaintId));
                parameter.addElement(new StringValue(CRMConstants.APPOINTMENT_STATUS_OPEN));
                parameter.addElement(new StringValue("UL"));
                parameter.addElement(new StringValue("UL"));
                parameter.addElement(new StringValue("UL"));
                parameter.addElement(new StringValue("UL"));
                parameter.addElement(new StringValue("0")); // call duration
                parameter.addElement(new StringValue("UL")); // option 7
                parameter.addElement(new StringValue("UL")); // option 8
                parameter.addElement(new StringValue("UL")); // option 9
                parameters.add(parameter);
                queries.add(getQuery("insertAppointment"));
            }

            try {
                connection = dataSource.getConnection();
                connection.setAutoCommit(false);
                command.setConnection(connection);

                // start execution
                for (int i = 0; i < parameters.size(); i++) {
                    command.setSQLQuery(queries.get(i));
                    command.setparams(parameters.get(i));
                    result = command.executeUpdate();
                    if (result < 0) {
                        connection.rollback();
                        return false;
                    }
                    try {
                        Thread.sleep(50);
                    } catch (InterruptedException ex) {
                        logger.error(ex.getMessage());
                    }
                }
            } catch (SQLException se) {
                logger.error(se.getMessage());
                return false;
            } finally {
                try {
                    connection.commit();
                    connection.close();
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                }
            }
        }
        //
        //updateNote
        return true;
    }

    public boolean saveFollowUpAppointment(HttpServletRequest request, HttpSession session, String userID) throws NoUserInSessionException, SQLException {
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        String clientId = request.getParameter("clientId");
        String title = request.getParameter("title");
        String appointmentPlace = request.getParameter("appointmentPlace");
        String appType = request.getParameter("appType");
        String note = request.getParameter("note");
        String comment = null;
        String privacy = request.getParameter("privacy");
        String callStatus = request.getParameter("callStatus");
        String meetingDate = request.getParameter("meetingDate");
        String timer = request.getParameter("timer");
        String timeFlag=request.getParameter("timeflag")==null?"0":request.getParameter("timeflag");
        int callDuration = request.getParameter("callDuration") != null ? Integer.parseInt(request.getParameter("callDuration")) : 1;
        if (request.getParameter("comment") != null) {
            comment = request.getParameter("comment");
        }
        java.util.Date date = new java.util.Date(DateAndTimeControl.getOracleDateTimeNow().getTime());
        String resultValue = request.getParameter("resultValue");
        if (appType == null) {
            appType = "UL";
        }
        boolean result = saveAppointment(userID, clientId, title, date, note, appType, appointmentPlace, null, null, comment, CRMConstants.APPOINTMENT_STATUS_DIRECT_FOLLOW_UP, securityUser.getDefaultCampaign(), null, privacy, callDuration, callStatus, timer, "UL", null);try {
            Thread.sleep(1000); // delay to prevent appointment creation time duplication 
        } catch (InterruptedException ie) {
        }

        String callResult = request.getParameter("callResult");
        String nextAction = request.getParameter("nextAction");

        Calendar scheduled = null;

        if (CRMConstants.CALL_RESULT_CALL.equalsIgnoreCase(nextAction)) {
            WebBusinessObject noteInfo = ProjectMgr.getInstance().getOnSingleKey(resultValue);
            if (resultValue.equalsIgnoreCase(CRMConstants.CALL_RESULT_OTHER_DATE)) {
                String callresultdate = (String) request.getParameter("callresultdate");
                try {
                    scheduled = Calendar.getInstance();
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd hh:mm");
                    scheduled.setTime(sdf.parse(callresultdate));
                } catch (Exception ex) {
                }
            } else if (noteInfo != null) {
                note = (String) noteInfo.getAttribute("projectName");
                String optionOne = (String) noteInfo.getAttribute("optionOne");
                if (optionOne != null) {
                    // check optionOne contains int value
                    try {
                        int delayValueByHour = Integer.parseInt(optionOne);
                        scheduled = Calendar.getInstance();
                        scheduled.setTime(date);
                        scheduled.add(Calendar.HOUR, delayValueByHour);
                    } catch (NumberFormatException ex) {
                    }
                }
            }
        } else if(timeFlag.equals("0")){                 
        if (CRMConstants.CALL_RESULT_MEETING.equalsIgnoreCase(nextAction) || nextAction.equals("Visit") || nextAction.equals("Wait") || nextAction.equals("Follow")
                || nextAction.equals("SendEmail") || nextAction.equals("SendSMS") || nextAction.equals("SendOffer") ||  nextAction.equals("Interested") ) {
            java.util.Date tempDate = new java.util.Date();
            try {
                SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd HH:mm");
                tempDate = formatter.parse(meetingDate);
            } catch (ParseException ex) {
                logger.error(ex);
            }
            scheduled = Calendar.getInstance();
            scheduled.setTime(tempDate);
            note = nextAction;

        }
        }else if(timeFlag.equals("2")) // appear on calender only if time field appeared in call popup
        {
             
            java.util.Date tempDate = new java.util.Date();
            try {
                SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd HH:mm");
                tempDate = formatter.parse(meetingDate);
            } catch (ParseException ex) {
                logger.error(ex);
            }
            scheduled = Calendar.getInstance();
            scheduled.setTime(tempDate);
            note = nextAction;

        
        }

        if (scheduled != null && scheduled.getTime().after(date)) {
            if (nextAction.equals("Follow") || nextAction.equals("Wait") || nextAction.equals("Interested") || nextAction.equals("not answered")) {
                nextAction = "call";
            }
            result = result && saveAppointment(userID, clientId, title, scheduled.getTime(), note, nextAction != null ? nextAction : callResult, appointmentPlace, null, null, 
                    "0".equals(metaDataMgr.getCopyToFuture()) ? "" : comment, CRMConstants.APPOINTMENT_STATUS_OPEN, securityUser.getDefaultCampaign(), null, privacy, 0, null, null, "UL", null);
        }
        return result;
    }

    public boolean saveAppointment(HttpServletRequest request, String userID) throws NoUserInSessionException, SQLException {
        String clientId = request.getParameter("clientId");
        String appID = request.getParameter("appID");
        String title = request.getParameter("title");
        String date = request.getParameter("date");
        String note = request.getParameter("note");
        String appointmentPlace = request.getParameter("appointmentPlace");
        String appType = request.getParameter("appType");
        String privacy = request.getParameter("privacy");
        String comment = null;
        if (request.getParameter("comment") != null) {
            comment = request.getParameter("comment");

        }
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd HH:mm");
        java.util.Date appDate = null;
        try {
            appDate = formatter.parse(date);
        } catch (ParseException ex) {
            logger.error(ex);
        }

        if (note != null && !note.equals("")) {
        } else {
            note = "&#1604;&#1575; &#1578;&#1608;&#1580;&#1583; &#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
        }
        if (appType == null) {
            appType = "UL";
        }

        return saveAppointment(userID, clientId, title, appDate, note, appType, appointmentPlace, null, null,
                "0".equals(metaDataMgr.getCopyToFuture()) ? "" : comment, CRMConstants.APPOINTMENT_STATUS_OPEN, null, null, privacy, 0, null, null, appID, null);
    }
    
    public String testSaveAppointment(String appID) throws NoUserInSessionException, SQLException {
        Vector result = new Vector();
        Vector parameter = new Vector();

        parameter.addElement(new StringValue(appID));

        Connection connection = null;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("testSaveAppointment").trim());
            forInsert.setparams(parameter);
            try {
                result = forInsert.executeQuery();
            } catch (UnsupportedTypeException ex) {
                Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());

        } finally {
            connection.setAutoCommit(true);
            connection.close();
        }
        String resultN = new String();

        Row r = null;
        Enumeration e = result.elements();

        while (e.hasMoreElements()) {
            try {
                r = (Row) e.nextElement();
                resultN = r.getString("CURRENT_STATUS");
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return resultN;
    }

    public boolean saveAppointment2(HttpServletRequest request, String userID) throws NoUserInSessionException, SQLException {
        String clientId = request.getParameter("clientIdx");
        String title = request.getParameter("title");
        String date = request.getParameter("date");
        String time = request.getParameter("time");
        String appType = request.getParameter("appType");
        String appointmentPlace = request.getParameter("appointmentPlace");
        String comment = request.getParameter("comment");
        String privacy = request.getParameter("privacy");
        if (time.equals("") || time == null) {
            time = "UL";
        }

        String hour = time.substring(0, time.indexOf(":"));
        String min_ = time.substring(time.indexOf(":") + 1, time.length() - 1);
        int h = Integer.parseInt(hour);
        int m = (int) Integer.parseInt(min_);

        Calendar Cal = Calendar.getInstance();

        int year = new Integer(date.substring(0, 4)).intValue();

        int month = new Integer(date.substring(5, date.lastIndexOf("/"))).intValue();
        int day = new Integer(date.substring(date.lastIndexOf("/") + 1, date.length())).intValue();
        Cal.set(year, month - 1, day, h, m, 00);
        java.util.Date dateTime = Cal.getTime();

        String note = request.getParameter("note");

        if (note != null && !note.equals("")) {
        } else {
            note = "&#1604;&#1575; &#1578;&#1608;&#1580;&#1583; &#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
        }
        if (appType == null) {
            appType = "UL";
        }

        return saveAppointment(userID, clientId, title, dateTime, note, appType, appointmentPlace, null, null, comment, CRMConstants.APPOINTMENT_STATUS_OPEN, null, null, privacy, 0, null, null, "UL", null);
    }

    public boolean saveAppointment(String userId, String clientId, String title, java.util.Date date, String note, String appType, String appointmentPlace, String issueId, String clientComplaintId, String comment, String status, String activeCampaign, String callingPlanID, String privacy, Integer callDuration, String callStatus, String timer, String prntApp, String appointmentBy) throws NoUserInSessionException, SQLException {
        if (issueId == null || clientComplaintId == null) {
            issueId = IssueMgr.getInstance().getLastIssueForClient(clientId);
            clientComplaintId = ClientComplaintsMgr.getInstance().getLastClientComplaintForIssue(issueId);
        }

        int result = -1000;
        String id = UniqueIDGen.getNextID();

        Vector parameter = new Vector();

        parameter.addElement(new StringValue(id));
        parameter.addElement(new StringValue(appointmentBy != null ? appointmentBy : userId)); // if it is created by other user use appointmentBy else use same userId
        parameter.addElement(new StringValue(clientId));
        parameter.addElement(new StringValue(note));
        parameter.addElement(new StringValue("UL"));
        parameter.addElement(new StringValue(appType));
        parameter.addElement(new StringValue("UL"));
        parameter.addElement(new StringValue(title));
        parameter.addElement(new TimestampValue(new Timestamp(date.getTime())));
        parameter.addElement(new StringValue(appointmentPlace));
        parameter.addElement(new StringValue(userId));
        parameter.addElement(new StringValue(issueId));
        parameter.addElement(new StringValue(clientComplaintId));
        parameter.addElement(new StringValue(status));
        parameter.addElement(new StringValue(comment));
        parameter.addElement(new StringValue(callingPlanID != null ? callingPlanID : "UL")); // for option4
        if (activeCampaign != null) {
            parameter.addElement(new StringValue(activeCampaign)); // for option5
        } else {
            parameter.addElement(new StringValue("UL")); // for option5
        }
        if (privacy == null) {
            privacy = "Public";
        }
        parameter.addElement(new StringValue(privacy)); // for option6
        parameter.addElement(new IntValue(callDuration != null ? callDuration : 0)); // call duration
        parameter.addElement(new StringValue(prntApp)); // option 7
        parameter.addElement(new StringValue(timer != null ? timer : "UL")); // option 8
        parameter.addElement(new StringValue(callStatus)); // option 9

        Connection connection = null;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insertAppointment").trim());
            forInsert.setparams(parameter);
            result = forInsert.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;

        } finally {
            connection.setAutoCommit(true);
            connection.close();
        }

        return (result > 0);
    }

    public Vector getAppointments(String keyValue, String keyIndex) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;

        StringBuffer dq = new StringBuffer("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");
        dq.append(supportedForm.getTableSupported().getAttribute(keyIndex));
        dq.append(" = ? ");

        dq.append(" order by creation_time desc");
        String theQuery = dq.toString();

        if (supportedForm == null) {

            initSupportedForm();
        }

        logger.info("the query " + theQuery);
        logger.info("param Value Key " + keyValue);

        // finally do the query
        SQLparams.add(new StringValue(keyValue));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;

    }

    public Vector getAppointmentsDates(String userId, java.sql.Date begin, java.sql.Date end) {
        Connection connection = null;

        Vector resultBusObjs = new Vector();
        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLparams.addElement(new StringValue(userId));
//        SQLparams.addElement(new TimestampValue(new Timestamp(begin.getTime())));
//        SQLparams.addElement(new TimestampValue(new Timestamp(end.getTime())));
        String b = begin.toString().replaceAll("-", "/");
        String en = end.toString().replaceAll("-", "/");
        String query2 = getQuery("userAppointment");
        String q1 = query2.replaceAll("beginDate", b);
        String q2 = q1.replaceAll("endDate", en);
//        StringBuffer query = new StringBuffer(getQuery("userAppointment"));
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(q2);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                WebBusinessObject wbo = new WebBusinessObject();
                r = (Row) e.nextElement();
                java.sql.Date bDate = r.getDate(1);
                userId = r.getString(2);
                String clientID = r.getString(3);
                wbo.setAttribute("date", bDate);
                wbo.setAttribute("userId", userId);

                resultBusObjs.add(wbo);
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (Exception ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        return resultBusObjs;
    }

    public Vector getAppointmentsDates(String userId, String date) {
        Connection connection = null;

        Vector resultBusObjs = new Vector();
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        Vector newDate = new Vector();
        SQLparams.addElement(new StringValue(userId));

        String query2 = getQuery("userAppointmentByDate");
        String q1 = query2.replaceAll("ppp", date);

//        StringBuffer query = new StringBuffer(getQuery("userAppointment"));
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(q1);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();
            resultBusObjs = new Vector();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                resultBusObjs.add(fabricateBusObj(r));
            }
            ClientMgr clientMgr = ClientMgr.getInstance();

            if (resultBusObjs != null & !resultBusObjs.isEmpty()) {
                for (int i = 0; i < resultBusObjs.size(); i++) {
                    WebBusinessObject wbo = new WebBusinessObject();
                    WebBusinessObject temp = new WebBusinessObject();
                    temp = (WebBusinessObject) resultBusObjs.get(i);
                    String clientId = (String) temp.getAttribute("clientId");
                    String clientCompId = (String) temp.getAttribute("option1");
                    wbo = clientMgr.getOnSingleKey(clientId);
                    if (wbo != null) {
                        temp.setAttribute("clientId", wbo.getAttribute("id"));
                        temp.setAttribute("clientNO", wbo.getAttribute("clientNO"));
                        temp.setAttribute("name", wbo.getAttribute("name"));
                        if (wbo.getAttribute("address") != null && !wbo.getAttribute("address").equals("")) {
                            temp.setAttribute("address", wbo.getAttribute("address"));
                        } else {
                            temp.setAttribute("address", " ");
                        }
                        temp.setAttribute("phone", wbo.getAttribute("phone"));
                        temp.setAttribute("mobile", wbo.getAttribute("mobile"));
                    }
                    newDate.add(temp);
                }
            } else {
                newDate = resultBusObjs;
            }

        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (Exception ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        return newDate;
    }

    public Vector getNotAnsweredAppointments(String beginDate, String endDate, String loggegUserId, String calTyp) {
        Connection connection = null;

        Vector resultBusObjs = new Vector();
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        Vector newDate = new Vector();

        SQLparams.addElement(new StringValue(loggegUserId));

        SQLparams.addElement(new StringValue(beginDate));
        SQLparams.addElement(new StringValue(endDate));

        SQLparams.addElement(new StringValue(beginDate));
        SQLparams.addElement(new StringValue(endDate));
        String query2=null;

        if (!calTyp.isEmpty() && calTyp.equalsIgnoreCase("NA")) {
            query2 = getQuery("getNotAnsweredAppointments");
        } else if (!calTyp.isEmpty() && calTyp.equalsIgnoreCase("WN")) {
            query2 = getQuery("getWrongNumberAppointments");
        } else if (!calTyp.isEmpty() && calTyp.equalsIgnoreCase("AN")) {
            query2 = getQuery("getAnsweredAppointments");
        }

//        StringBuffer query = new StringBuffer(getQuery("userAppointment"));
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query2);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();
            resultBusObjs = new Vector();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                WebBusinessObject wbo = new WebBusinessObject();
                try {
                    if (r.getString("CREATION_TIME") != null) {
                        wbo.setAttribute("creationTime", r.getString("CREATION_TIME"));
                    } else {
                        wbo.setAttribute("creationTime", "");
                    }

                    if (r.getString("NOTE") != null) {
                        wbo.setAttribute("note", r.getString("NOTE"));
                    } else {
                        wbo.setAttribute("note", "");
                    }

                    if (r.getString("APPOINTMENT_DATE") != null) {
                        wbo.setAttribute("appDate", r.getString("APPOINTMENT_DATE"));
                    } else {
                        wbo.setAttribute("appDate", "");

                    }

                    if (r.getString("APPOINTMENT_PLACE") != null) {
                        wbo.setAttribute("appPlace", r.getString("APPOINTMENT_PLACE"));
                    } else {
                        wbo.setAttribute("appPlace", "");

                    }

                    if (r.getString("ClientName") != null) {
                        wbo.setAttribute("clientName", r.getString("ClientName"));
                    } else {
                        wbo.setAttribute("clientName", "");
                    }

                    if (r.getString("EmpName") != null) {
                        wbo.setAttribute("empName", r.getString("EmpName"));
                    } else {
                        wbo.setAttribute("empName", "");
                    }
                    if (r.getString("MOBILE") != null) {
                        wbo.setAttribute("mobile", r.getString("MOBILE"));
                    } else {
                        wbo.setAttribute("mobile", "");
                    }
                    if (r.getString("COMMENT") != null) {
                        wbo.setAttribute("comment", r.getString("COMMENT"));
                    } else {
                        wbo.setAttribute("comment", "");
                    }
                    if (r.getString("SYS_ID") != null) {
                        wbo.setAttribute("clientId", r.getString("SYS_ID"));
                    } else {
                        wbo.setAttribute("clientId", "");
                    }
                    if (r.getString("CALL_DURATION") == null) {
                        wbo.setAttribute("callDur", "");
                       
                    } else {
                         wbo.setAttribute("callDur", r.getString("CALL_DURATION"));
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                newDate.add(wbo);
            }

        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (Exception ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        return newDate;
    }

    public String getCountAppointmentsDates(String userId, String date) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector result;
        String number = "0";

        parameters.addElement(new StringValue(userId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("userCountAppointmentByDate").trim().replaceAll("ppp", date));
            command.setparams(parameters);
            result = command.executeQuery();

            Row row;
            Enumeration e = result.elements();
            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                number = row.getString(1);
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (NoSuchColumnException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error" + ex);
            }
        }

        return number;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    public ArrayList<WebBusinessObject> getAppointmentsCountPerUser(String startDate, String endDate) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            StringBuilder sql = new StringBuilder(getQuery("userAppointmentsReport").trim());
            if (startDate != null && !startDate.isEmpty()) {
                sql.append(" and AP.CREATION_TIME >= ?");
                params.addElement(new TimestampValue(java.sql.Timestamp.valueOf(startDate + " 00:00:01")));
            }
            if (endDate != null && !endDate.isEmpty()) {
                sql.append(" and AP.CREATION_TIME <= ?");
                params.addElement(new TimestampValue(java.sql.Timestamp.valueOf(endDate + " 23:59:59")));
            }
            sql.append(" GROUP BY US.FULL_NAME");
            forQuery.setSQLQuery(sql.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                wbo.setAttribute("appointmentsCount", r.getString("APPOINTMENT_COUNT"));
                wbo.setAttribute("userName", r.getString("FULL_NAME"));
                resultBusObjs.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getLastComment(String clientID) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            params.addElement(new StringValue(clientID));
            params.addElement(new StringValue(clientID));
            StringBuilder sql = new StringBuilder(getQuery("getLastComment").trim());
            forQuery.setSQLQuery(sql.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                if (r.getString("COMMENT") != null) {
                    wbo.setAttribute("lstComment", r.getString("COMMENT"));
                } else {
                    wbo.setAttribute("lstComment", "");
                }
                wbo.setAttribute("appID", r.getString("ID"));

                resultBusObjs.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return resultBusObjs;
    }

    public boolean saveJoborder(HttpServletRequest request, HttpSession session, String complaintId) throws NoUserInSessionException, SQLException {
        String clientId = request.getParameter("clientId");
        String note = request.getParameter("note");
        String title = request.getParameter("title");
        String address = request.getParameter("address");
        String joborderForId = request.getParameter("userId");
        String comment = request.getParameter("comment");
        String unitID = request.getParameter("unitID");
        String status = "29";
        java.util.Date date = DateAndTimeControl.getDate(request.getParameter("joborderDate") + " 00:00:00");
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String userId = (String) loggedUser.getAttribute("userId");

        String issueId = IssueMgr.getInstance().getLastIssueForClient(clientId);
        String clientComplaintId = ClientComplaintsMgr.getInstance().getLastClientComplaintForIssue(issueId);

        if (clientComplaintId == null) {
            clientComplaintId = complaintId;
        }

        int result = -1000;
        String id = UniqueIDGen.getNextID();

        Vector parameter = new Vector();

        parameter.addElement(new StringValue(id));
        parameter.addElement(new StringValue(userId));
        parameter.addElement(new StringValue(clientId));
        parameter.addElement(new StringValue(note));
        parameter.addElement(new StringValue("UL"));
        parameter.addElement(new StringValue(CRMConstants.CALL_RESULT_JOB_ORDER));//appType
        parameter.addElement(new StringValue("UL"));
        parameter.addElement(new StringValue(title));
        parameter.addElement(new TimestampValue(new Timestamp(date.getTime())));
        parameter.addElement(new StringValue(address));
        parameter.addElement(new StringValue(joborderForId));
        parameter.addElement(new StringValue(issueId));
        parameter.addElement(new StringValue(clientComplaintId));
        parameter.addElement(new StringValue(status));
        parameter.addElement(new StringValue(comment));
        parameter.addElement(new StringValue("UL")); // for option4
        parameter.addElement(new StringValue("UL")); // for option5
        parameter.addElement(new StringValue(unitID)); // for option6
        parameter.addElement(new StringValue("0")); // call duration
        parameter.addElement(new StringValue("UL")); // option 7
        parameter.addElement(new StringValue("UL")); // option 8
        parameter.addElement(new StringValue("UL")); // option 9
        Connection connection = null;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insertAppointment").trim());
            forInsert.setparams(parameter);
            result = forInsert.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            if (connection != null) {
                connection.setAutoCommit(true);
                connection.close();
            }
        }
        return (result > 0);
    }

    public ArrayList<WebBusinessObject> getJobOrdersList(String beginDate, String endDate, String clientID, String usrID, /*, String areaID, String userID*/ String comID) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            StringBuilder sql = new StringBuilder(getQuery("getJobOrdersList").trim());
            if (beginDate != null && !beginDate.isEmpty()) {
                sql.append(" and trunc(AP.CREATION_TIME) >= to_date(?,'YYYY/MM/DD')");
                params.addElement(new StringValue(beginDate));
            }
            if (endDate != null && !endDate.isEmpty()) {
                sql.append(" and trunc(AP.CREATION_TIME) <= to_date(?,'YYYY/MM/DD')");
                params.addElement(new StringValue(endDate));
            }
            if (clientID != null && !clientID.isEmpty()) {
                sql.append(" AND CLIENT_ID = ?");
                params.addElement(new StringValue(clientID));
            }
            /*if (areaID != null && !areaID.isEmpty()) {
             sql.append(" AND CL.REGION = '").append(areaID).append("'");
             }*/
            if (usrID != null && !usrID.isEmpty()) {
                sql.append("  AND APPOINTMENT_FOR = '").append(usrID).append("' AND (IST.STATUS_NAME != '7' AND IST.STATUS_NAME != '6')");
            }

            if (comID != null && !comID.isEmpty()) {
                sql.append("  AND CLIENT_ID = '").append(comID).append("'");
            }

            forQuery.setSQLQuery(sql.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        Row r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            try {
                while (e.hasMoreElements()) {
                    r = (Row) e.nextElement();
                    wbo = fabricateBusObj(r);
                    if (r.getString("NAME") != null) {
                        wbo.setAttribute("clientName", r.getString("NAME"));
                    } else {
                        wbo.setAttribute("clientName", "");
                    }

                    if (r.getString("ADDRESS") != null) {
                        wbo.setAttribute("clientAddress", r.getString("ADDRESS"));
                    } else {
                        wbo.setAttribute("clientAddress", "");
                    }

                    if (r.getString("MOBILE") != null) {
                        wbo.setAttribute("clientMobile", r.getString("MOBILE"));
                    } else {
                        wbo.setAttribute("clientMobile", "");
                    }

                    if (r.getString("BUSINESS_ID") != null) {
                        wbo.setAttribute("businessID", r.getString("BUSINESS_ID"));
                    } else {
                        wbo.setAttribute("businessID", "");
                    }

                    if (r.getString("BUSINESS_ID_BY_DATE") != null) {
                        wbo.setAttribute("businessIDByDate", r.getString("BUSINESS_ID_BY_DATE"));
                    } else {
                        wbo.setAttribute("businessIDByDate", "");
                    }

                    if (r.getString("PROJECT_NAME") != null) {
                        wbo.setAttribute("unitNo", r.getString("PROJECT_NAME"));
                    } else {
                        wbo.setAttribute("unitNo", "");
                    }

                    if (r.getString("COMPLAINT_STATUS_SINCE") != null) {
                        wbo.setAttribute("complaintStatusSince", r.getString("COMPLAINT_STATUS_SINCE"));
                    } else {
                        wbo.setAttribute("complaintStatusSince", "");
                    }

                    if (r.getString("STATUS_CODE") != null) {
                        wbo.setAttribute("statusCode", r.getString("STATUS_CODE"));
                    } else {
                        wbo.setAttribute("statusCode", "");
                    }

                    if (r.getString("CASE_EN") != null) {
                        wbo.setAttribute("statusEnName", r.getString("CASE_EN"));
                    } else {
                        wbo.setAttribute("statusEnName", "");
                    }

                    if (r.getString("CASE_AR") != null) {
                        wbo.setAttribute("statusArName", r.getString("CASE_AR"));
                    } else {
                        wbo.setAttribute("statusArName", "");
                    }

                    if (r.getString("CURRENT_OWNER") != null) {
                        wbo.setAttribute("currentOwner", r.getString("CURRENT_OWNER"));
                    } else {
                        wbo.setAttribute("currentOwner", "");
                    }

                    if (r.getString("CREATED_BY_NAME") != null) {
                        wbo.setAttribute("createdByName", r.getString("CREATED_BY_NAME"));
                    } else {
                        wbo.setAttribute("createdByName", "");
                    }

                    if (r.getString("BRANCHNAME") != null) {
                        wbo.setAttribute("branchName", r.getString("BRANCHNAME"));
                    } else {
                        wbo.setAttribute("branchName", "");
                    }

                    if (r.getString("comPrj") != null) {
                        wbo.setAttribute("comPrj", r.getString("comPrj"));
                    } else {
                        wbo.setAttribute("comPrj", "");
                    }

                    if (r.getString("APPOINTMENT_DATE") != null) {
                        java.util.Date nowDate = new java.util.Date();
                        java.util.Date appDate = new java.util.Date();
                        try {
                            appDate = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.s").parse(r.getString("APPOINTMENT_DATE"));
                        } catch (ParseException ex) {
                            Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        String ss = r.getString("APPOINTMENT_DATE");
                        final long DAY_IN_MILLIS = 1000 * 60 * 60 * 24;
                        int diffInDays = 0;
                        diffInDays = (int) ((appDate.getTime() - nowDate.getTime()) / DAY_IN_MILLIS);
                        //int sla = Integer.parseInt(r.getString("SLA_EXECUTION_PERIOD")) - diffInDays;
                        if (diffInDays >= 3) {
                            wbo.setAttribute("trColor", "#93FEC5"); //green
                        } else if (diffInDays < 3 && diffInDays > 1 && (r.getString("STATUS_CODE") != null && (!(r.getString("STATUS_CODE")).equals("6")))) {
                            if (r.getString("STATUS_CODE") != null && (!(r.getString("STATUS_CODE")).equals("7"))) {
                                wbo.setAttribute("trColor", "#FEFFAF"); //yellow
                            } else {
                                wbo.setAttribute("trColor", "#FFFFFF"); //white
                            }
                        } else if (diffInDays <= 1 && (r.getString("STATUS_CODE") != null && (!(r.getString("STATUS_CODE")).equals("6")))) {
                            if (r.getString("STATUS_CODE") != null && (!(r.getString("STATUS_CODE")).equals("7"))) {
                                wbo.setAttribute("trColor", "#FFAFAF"); //red
                            } else {
                                wbo.setAttribute("trColor", "#FFFFFF"); //white
                            }
                        } else {
                            wbo.setAttribute("trColor", "#FFFFFF"); //white
                        }

                    }
                    resultBusObjs.add(wbo);
                }
            } catch (NoSuchColumnException ce) {
                logger.error(ce);
            }
        }
        return resultBusObjs;
    }

    public List<WebBusinessObject> getAppointmentFollowUpProductions(String groupId, String begin, String end) {
        return getAppointmentProductions(groupId, CRMConstants.CALL_RESULT_FOLLOWUP, begin, end);
    }

    public List<WebBusinessObject> getAppointmentProductions(String groupId, String type, String begin, String end) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> rows;
        Vector parameters = new Vector();
        WebBusinessObject wbo;

        parameters.addElement(new StringValue(groupId));
        parameters.addElement(new StringValue(type));
        parameters.addElement(new StringValue(begin));
        parameters.addElement(new StringValue(end));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getAppointmentProductions").trim());
            command.setparams(parameters);
            rows = command.executeQuery();

            List<WebBusinessObject> results = new ArrayList<>();
            for (Row row : rows) {
                try {
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("fullName", row.getString("FULL_NAME"));
                    wbo.setAttribute("noTicket", String.valueOf(row.getBigDecimal("TOTAL")));
                    results.add(wbo);
                } catch (NoSuchColumnException ex) {
                    logger.error("SQL Exception  " + ex.getMessage());
                } catch (UnsupportedConversionException ex) {
                    logger.error("SQL Exception  " + ex.getMessage());
                }
            }
            return results;
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        return new ArrayList<>();
    }

    public Vector<WebBusinessObject> getAppointmentsByClientID(String clientID) {

        Vector<WebBusinessObject> data = new Vector<WebBusinessObject>();
        WebBusinessObject wbo;
        Connection connection = null;
        Vector parameters = new Vector();

        parameters.addElement(new StringValue(clientID));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            //forQuery.setSQLQuery(getQuery("getAppointmentsByClientIDNew").trim());
            forQuery.setSQLQuery(getQuery("getAppointmentsByClientIDNew").trim());
            forQuery.setparams(parameters);

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }

        // process the vector
        // vector of business objects
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            try {
                if (r.getString("COMMENT") == null) {
                    wbo.setAttribute("comment", "---");
                } else {
                    wbo.setAttribute("comment", r.getString("COMMENT"));
                }

                if (r.getString("FULL_NAME") == null) {
                    wbo.setAttribute("userName", "---");
                } else {
                    wbo.setAttribute("userName", r.getString("FULL_NAME"));
                }

                if (r.getString("CREATION_TIME") == null) {
                    wbo.setAttribute("appointmentDate", "---");
                } else {
                    wbo.setAttribute("appointmentDate", r.getString("CREATION_TIME"));
                }

                if (r.getString("APPOINTMENT_DATE") == null) {
                    wbo.setAttribute("newAppointmentDate", "---");
                } else {
                    wbo.setAttribute("newAppointmentDate", r.getString("APPOINTMENT_DATE"));
                }

                if (r.getString("NOTE") == null) {
                    wbo.setAttribute("note", "---");
                } else {
                    wbo.setAttribute("note", r.getString("NOTE"));
                }

                if (r.getString("CURRENT_STATUS") == null) {
                    wbo.setAttribute("currentStatus", "---");
                } else {
                    wbo.setAttribute("currentStatus", r.getString("CURRENT_STATUS"));
                }

                if (r.getString("CASE_AR") == null) {
                    wbo.setAttribute("currentStatusName", "---");
                } else {
                    wbo.setAttribute("currentStatusName", r.getString("CASE_AR"));
                }

                data.add(wbo);
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
//            data.addElement(fabricateBusObj((Row) e.nextElement()));
        }

        return data;
    }

    public ArrayList<WebBusinessObject> getAppointmentsClients(String fromDate, String toDate, String createdBy, List<WebBusinessObject> employeeList, String rateID, String appointmentType, String result, String dateType, String campaignID) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector params = new Vector();
        WebBusinessObject wbo;
        Connection connection = null;
        StringBuilder where = new StringBuilder();
        if(dateType == null || dateType.equals("app")){
            if (fromDate != null && !fromDate.isEmpty()) {
                where.append(" trunc(AP.CURRENT_STATUS_SINCE) >= ? ");
                params.add(new DateValue(java.sql.Date.valueOf(fromDate.replaceAll("/", "-"))));
            }
            if (toDate != null && !toDate.isEmpty()) {
                if (where.length() > 0) {
                    where.append(" and");
                }
                where.append(" trunc(AP.CURRENT_STATUS_SINCE) <= ? ");
                params.add(new DateValue(java.sql.Date.valueOf(toDate.replaceAll("/", "-"))));
            }
        } else if("registration".equals(dateType)){
            if (fromDate != null && !fromDate.isEmpty()) {
                where.append(" trunc(AP.APPOINTMENT_DATE) >= ? ");
                params.add(new DateValue(java.sql.Date.valueOf(fromDate.replaceAll("/", "-"))));
            }
            if (toDate != null && !toDate.isEmpty()) {
                if (where.length() > 0) {
                    where.append(" and");
                }
                where.append(" trunc(CL.CREATION_TIME) <= ? ");
                params.add(new DateValue(java.sql.Date.valueOf(toDate.replaceAll("/", "-"))));
            }
        }
        if (createdBy != null && !createdBy.isEmpty()) {
            if (where.length() > 0) {
                where.append(" and");
            }
            where.append("   AP.APPOINTMENT_FOR = '").append(createdBy).append("'");
        } else {
            if (where.length() > 0) {
                where.append(" and");
            }
            where.append("(");
            for (int i = 0; i < employeeList.size(); i++) {
                WebBusinessObject mywbo = employeeList.get(i);
                String user_id = (String) mywbo.getAttribute("userId");
                where.append("   AP.APPOINTMENT_FOR = '").append(user_id).append("'");
                if (i != (employeeList.size() - 1)) {
                    where.append(" or");
                }
            }
            where.append(")");
        }
        if (rateID != null && !rateID.isEmpty()) {
            if (where.length() > 0) {
                where.append(" and");
            }
            where.append(" CR.RATE_ID = ? ");
            params.add(new StringValue(rateID));
        }
        if (appointmentType != null) {
            where.append(" AND AP.OPTION2 LIKE '%").append(appointmentType).append("%'");
        }
        if (result != null && !result.equals("all")) {
            where.append(" AND AP.OPTION9 = '").append(result).append("'");
        }
        if (campaignID != null && !campaignID.equals("") && !campaignID.equals(" ")) {
            where.append(" AND CL.SYS_ID IN (SELECT CLIENT_ID FROM CLIENT_CAMPAIGN WHERE CAMPAIGN_ID IN ('")
                    .append(campaignID).append("'))");
        }
        if (where.length() > 0) {
            where.insert(0, "and");
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getAppointmentsClients").replaceAll("whereStatement", where.toString()).trim());
            forQuery.setparams(params);

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        Row r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    wbo.setAttribute("clientID", r.getString("SYS_ID"));
                    wbo.setAttribute("clientNo", r.getString("CLIENT_NO"));
                    wbo.setAttribute("clientName", r.getString("NAME"));
                    wbo.setAttribute("clientMobile", r.getString("MOBILE"));
                    if (r.getString("INTER_PHONE") == null) {
                        wbo.setAttribute("interPhone","---");
                    } else {
                        wbo.setAttribute("interPhone", r.getString("INTER_PHONE"));
                    }
                    if (r.getString("EMAIL") == null) {
                        wbo.setAttribute("clientEmail","---");
                    } else {
                        wbo.setAttribute("clientEmail", r.getString("EMAIL"));
                    }
                    wbo.setAttribute("rateName", r.getString("RATE_NAME") != null ? r.getString("RATE_NAME") : "");
                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getClientAppointments(String clientID, String createdBy, String fromDate, String toDate, String appointmentType, String result, String dateType) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(clientID));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        StringBuilder where = new StringBuilder();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        if (fromDate != null && toDate != null) {
            if (dateType == null || "app".equals(dateType)) {
                where.append(" AND TRUNC(AP.CURRENT_STATUS_SINCE) BETWEEN ? AND ? ");
            } else {
                where.append(" AND TRUNC(AP.APPOINTMENT_DATE) BETWEEN ? AND ? ");
            }
            try {
                parameters.addElement(new DateValue(new java.sql.Date(sdf.parse(fromDate).getTime())));
                parameters.addElement(new DateValue(new java.sql.Date(sdf.parse(toDate).getTime())));
            } catch (ParseException ex) {
                parameters.addElement(new DateValue(new java.sql.Date(Calendar.getInstance().getTimeInMillis())));
                parameters.addElement(new DateValue(new java.sql.Date(Calendar.getInstance().getTimeInMillis())));
            }
        }
        if (appointmentType != null) {
            where.append(" AND AP.OPTION2 LIKE '%").append(appointmentType).append("%'");
        }
        if (result != null && !result.equals("all")) {
            where.append(" AND AP.OPTION9 = '").append(result).append("'");
        }

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientAppointments").replaceAll("createdBy", createdBy).replace("whereStatement", where.toString()).trim());
            forQuery.setparams(parameters);

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                try {
                    if (r.getString("CREATED_BY_NAME") != null) {
                        wbo.setAttribute("createdByName", r.getString("CREATED_BY_NAME"));
                    }
                    if (r.getString("STATUS_NAME_EN") != null) {
                        wbo.setAttribute("statusNameEn", r.getString("STATUS_NAME_EN"));
                    }
                    if (r.getString("STATUS_NAME_AR") != null) {
                        wbo.setAttribute("statusNameAr", r.getString("STATUS_NAME_AR"));
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getInternalCampaignAppointments(String callingPlanID) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(callingPlanID));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getInternalCampaignAppointments").trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                try {
                    if (r.getString("NAME") != null) {
                        wbo.setAttribute("clientName", r.getString("NAME"));
                    }
                    if (r.getString("PHONE") != null) {
                        wbo.setAttribute("clientPhone", r.getString("PHONE"));
                    }
                    if (r.getString("MOBILE") != null) {
                        wbo.setAttribute("clientMobile", r.getString("MOBILE"));
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getEmpStatistic(String departmentID, String beginDate, String endDate) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;

        Vector parameters = new Vector();
        
        //Visits Clients
        parameters.addElement(new StringValue(departmentID));
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));

        // Appointment Creation Time
        parameters.addElement(new StringValue(departmentID));
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));
        
        //NewClient
        parameters.addElement(new StringValue(departmentID));
        
        // Calls Creation Time
        parameters.addElement(new StringValue(departmentID));
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getEmpStatistic_old").trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    if (r.getString("USER_ID") != null) {
                        wbo.setAttribute("userID", r.getString("USER_ID"));
                    }

                    if (r.getString("full_name") != null) {
                        wbo.setAttribute("userName", r.getString("full_name"));
                    }

                    if (r.getBigDecimal("call") != null) {
                        wbo.setAttribute("call", r.getBigDecimal("call"));
                    } else {
                        wbo.setAttribute("call", "0");
                    }

                    if (r.getBigDecimal("call_duration") != null) {
                        wbo.setAttribute("call_duration", r.getBigDecimal("call_duration"));
                    } else {
                        wbo.setAttribute("call_duration", "0");
                    }

                    if (r.getBigDecimal("meeting") != null) {
                        wbo.setAttribute("meeting", r.getBigDecimal("meeting"));
                    } else {
                        wbo.setAttribute("meeting", "0");
                    }

                    if (r.getBigDecimal("ts_meeting") != null) {
                        wbo.setAttribute("tsMeeting", r.getBigDecimal("ts_meeting"));
                    } else {
                        wbo.setAttribute("tsMeeting", "0");
                    }

                    if (r.getBigDecimal("sls_meeting") != null) {
                        wbo.setAttribute("slsMeeting", r.getBigDecimal("sls_meeting"));
                    } else {
                        wbo.setAttribute("slsMeeting", "0");
                    }

                    if (r.getBigDecimal("bkr_meeting") != null) {
                        wbo.setAttribute("bkrMeeting", r.getBigDecimal("bkr_meeting"));
                    } else {
                        wbo.setAttribute("bkrMeeting", "0");
                    }

                    if (r.getBigDecimal("meeting_duration") != null) {
                        wbo.setAttribute("meeting_duration", r.getBigDecimal("meeting_duration"));
                    } else {
                        wbo.setAttribute("meeting_duration", "0");
                    }

                    if (r.getBigDecimal("not_answred") != null) {
                        wbo.setAttribute("not_answred", r.getBigDecimal("not_answred"));
                    } else {
                        wbo.setAttribute("not_answred", "0");
                    }

                    if (r.getBigDecimal("total_clients") != null) {
                        wbo.setAttribute("total_clients", r.getBigDecimal("total_clients"));
                    } else {
                        wbo.setAttribute("total_clients", "0");
                    }
                    if (r.getBigDecimal("CLIENT_COUNT") != null) {
                        wbo.setAttribute("visitClientsCount", r.getBigDecimal("CLIENT_COUNT"));
                    } else {
                        wbo.setAttribute("visitClientsCount", "0");
                    }
                    if (r.getBigDecimal("ANS_CLIENT_COUNT") != null) {
                        wbo.setAttribute("callsClientsCount", r.getBigDecimal("ANS_CLIENT_COUNT"));
                    } else {
                        wbo.setAttribute("callsClientsCount", "0");
                    }
                    if (r.getBigDecimal("NEW_ANS_CLIENT_COUNT") != null) {
                        wbo.setAttribute("newClientsCount", r.getBigDecimal("NEW_ANS_CLIENT_COUNT"));
                    } else {
                        wbo.setAttribute("newClientsCount", "0");
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                } catch (UnsupportedConversionException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }
    
    public ArrayList<WebBusinessObject> getEmpStatWithNewClient(String departmentID, String beginDate, String endDate,HttpSession session) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;

        Vector parameters = new Vector();
        //Visits Clients
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));

        parameters.addElement(new StringValue(departmentID));
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));

                StringBuilder where = new StringBuilder();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String userGroup = UserGroupMgr.getInstance().getByKeyColumnValue("key6", loggedUser.getAttribute("userId").toString(),"key8");
        if (userGroup.equals("Team Leader"))
        {
            where.append(" AND COMMENTS !='1' ");
        } else {
            where.append(" ");
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getEmpStatistic").replaceAll("wherestatment", where.toString()).trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    if (r.getString("user_id") != null) {
                        wbo.setAttribute("userID", r.getString("user_id"));
                    }

                    if (r.getString("full_name") != null) {
                        wbo.setAttribute("userName", r.getString("full_name"));
                    }
                    
                    if (r.getString("group_name") != null) {
                        wbo.setAttribute("group_name", r.getString("group_name"));
                    }

                    if (r.getBigDecimal("all_client") != null) {
                        wbo.setAttribute("call", r.getBigDecimal("all_client"));
                    } else {
                        wbo.setAttribute("call", "0");
                    }

                    if (r.getBigDecimal("distinct_client_count") != null) {
                        wbo.setAttribute("call_duration", r.getBigDecimal("distinct_client_count"));
                    } else {
                        wbo.setAttribute("call_duration", "0");
                    }

                    if (r.getBigDecimal("diff") != null) {
                        wbo.setAttribute("meeting", r.getBigDecimal("diff"));
                    } else {
                        wbo.setAttribute("meeting", "0");
                    }

                    if (r.getBigDecimal("nomination") != null) {
                        wbo.setAttribute("tsMeeting", r.getBigDecimal("nomination"));
                    } else {
                        wbo.setAttribute("tsMeeting", "0");
                    }

                    if (r.getBigDecimal("direct") != null) {
                        wbo.setAttribute("slsMeeting", r.getBigDecimal("direct"));
                    } else {
                        wbo.setAttribute("slsMeeting", "0");
                    }

                    if (r.getBigDecimal("indirect") != null) {
                        wbo.setAttribute("bkrMeeting", r.getBigDecimal("indirect"));
                    } else {
                        wbo.setAttribute("bkrMeeting", "0");
                    }

                    if (r.getBigDecimal("total") != null) {
                        wbo.setAttribute("meeting_duration", r.getBigDecimal("total"));
                    } else {
                        wbo.setAttribute("meeting_duration", "0");
                    }

                    if (r.getBigDecimal("reserve") != null) {
                        wbo.setAttribute("not_answred", r.getBigDecimal("reserve"));
                    } else {
                        wbo.setAttribute("not_answred", "0");
                    }

                    if (r.getBigDecimal("buyrel") != null) {
                        wbo.setAttribute("total_clients", r.getBigDecimal("buyrel"));
                    } else {
                        wbo.setAttribute("total_clients", "0");
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                } catch (UnsupportedConversionException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }
    
    public ArrayList<WebBusinessObject> getEmpStatisticByGroup(String grouptID, String beginDate, String endDate) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;

        Vector parameters = new Vector();
        parameters.addElement(new StringValue(grouptID));

        //Appointment Creation Time
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));

        //Appointment Time
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getEmpStatisticByGroup").trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    if (r.getString("USER_ID") != null) {
                        wbo.setAttribute("userID", r.getString("USER_ID"));
                    }

                    if (r.getString("full_name") != null) {
                        wbo.setAttribute("userName", r.getString("full_name"));
                    }

                    if (r.getBigDecimal("call") != null) {
                        wbo.setAttribute("call", r.getBigDecimal("call"));
                    } else {
                        wbo.setAttribute("call", "0");
                    }

                    if (r.getBigDecimal("call_duration") != null) {
                        wbo.setAttribute("call_duration", r.getBigDecimal("call_duration"));
                    } else {
                        wbo.setAttribute("call_duration", "0");
                    }

                    if (r.getBigDecimal("meeting") != null) {
                        wbo.setAttribute("meeting", r.getBigDecimal("meeting"));
                    } else {
                        wbo.setAttribute("meeting", "0");
                    }

                    if (r.getBigDecimal("meeting_duration") != null) {
                        wbo.setAttribute("meeting_duration", r.getBigDecimal("meeting_duration"));
                    } else {
                        wbo.setAttribute("meeting_duration", "0");
                    }

                    if (r.getBigDecimal("not_answred") != null) {
                        wbo.setAttribute("not_answred", r.getBigDecimal("not_answred"));
                    } else {
                        wbo.setAttribute("not_answred", "0");
                    }

                    if (r.getBigDecimal("total_clients") != null) {
                        wbo.setAttribute("total_clients", r.getBigDecimal("total_clients"));
                    } else {
                        wbo.setAttribute("total_clients", "0");
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                } catch (UnsupportedConversionException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getFutureEmpStatistic(String departmentID, String beginDate, String endDate) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;

        Vector parameters = new Vector();
        parameters.addElement(new StringValue(departmentID));

        //Appointment Creation Time
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));

        //Appointment Time
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getFutureEmpStatistic").trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    if (r.getString("USER_ID") != null) {
                        wbo.setAttribute("userID", r.getString("USER_ID"));
                    }

                    if (r.getString("full_name") != null) {
                        wbo.setAttribute("userName", r.getString("full_name"));
                    }

                    if (r.getBigDecimal("call") != null) {
                        wbo.setAttribute("call", r.getBigDecimal("call"));
                    } else {
                        wbo.setAttribute("call", "0");
                    }

                    if (r.getBigDecimal("call_duration") != null) {
                        wbo.setAttribute("call_duration", r.getBigDecimal("call_duration"));
                    } else {
                        wbo.setAttribute("call_duration", "0");
                    }

                    if (r.getBigDecimal("meeting") != null) {
                        wbo.setAttribute("meeting", r.getBigDecimal("meeting"));
                    } else {
                        wbo.setAttribute("meeting", "0");
                    }

                    if (r.getBigDecimal("meeting_duration") != null) {
                        wbo.setAttribute("meeting_duration", r.getBigDecimal("meeting_duration"));
                    } else {
                        wbo.setAttribute("meeting_duration", "0");
                    }

                    if (r.getBigDecimal("not_answred") != null) {
                        wbo.setAttribute("not_answred", r.getBigDecimal("not_answred"));
                    } else {
                        wbo.setAttribute("not_answred", "0");
                    }

                    if (r.getBigDecimal("total_clients") != null) {
                        wbo.setAttribute("total_clients", r.getBigDecimal("total_clients"));
                    } else {
                        wbo.setAttribute("total_clients", "0");
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                } catch (UnsupportedConversionException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }

    public ArrayList<ArrayList<String>> getEmpClientStatistic(String departmentID, String beginDate, String endDate) {
        ArrayList<ArrayList<String>> data = new ArrayList<>();
        Connection connection = null;

        Vector parameters = new Vector();
        parameters.addElement(new StringValue(departmentID));
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));

        Vector<Row> queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getEmpClientStatistic").trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            for (Row r : queryResult) {
                try {
                    ArrayList<String> wbo = new ArrayList<>();

                    if (r.getString("full_name") != null) {
                        wbo.add(r.getString("full_name"));
                    } else {
                        wbo.add("---");
                    }

                    if (r.getString("Name") != null) {
                        wbo.add(r.getString("Name"));
                    } else {
                        wbo.add("---");
                    }

                    if (r.getBigDecimal("call") != null) {
                        wbo.add(r.getBigDecimal("call").toString());
                    } else {
                        wbo.add("0");
                    }

                    if (r.getBigDecimal("call_duration") != null) {
                        wbo.add(r.getBigDecimal("call_duration").toString());
                    } else {
                        wbo.add("0");
                    }

                    if (r.getBigDecimal("meeting") != null) {
                        wbo.add(r.getBigDecimal("meeting").toString());
                    } else {
                        wbo.add("0");
                    }

                    if (r.getBigDecimal("meeting_duration") != null) {
                        wbo.add(r.getBigDecimal("meeting_duration").toString());
                    } else {
                        wbo.add("0");
                    }

                    if (r.getString("SYS_ID") != null) {
                        wbo.add(r.getString("SYS_ID"));
                    }

                    if (r.getString("USER_ID") != null) {
                        wbo.add(r.getString("USER_ID"));
                    }

                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getClientStatistic(String departmentID, String campaignID, String beginDate, String endDate, String projectID) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;
        StringBuilder where = new StringBuilder();
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(departmentID));
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));
        parameters.addElement(new StringValue(departmentID));
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));
//        if (departmentID != null && !departmentID.isEmpty()) {
//            where.append(" AND AP.USER_ID IN (SELECT EMP_ID FROM EMP_MGR WHERE MGR_ID = (SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID = ?))");
//            parameters.addElement(new StringValue(departmentID));
//        }
        if (campaignID != null && !campaignID.isEmpty()) {
            where.append(" AND AP.CLIENT_ID IN (SELECT CLIENT_ID FROM CLIENT_CAMPAIGN WHERE CAMPAIGN_ID IN ('")
                    .append(campaignID.replaceAll(",", "','")).append("'))");
        }
        if (projectID != null && !projectID.isEmpty()) {
            where.append(" AND CL.SYS_ID IN (SELECT CP.CLIENT_ID FROM CLIENT_PROJECTS CP WHERE CP.PRODUCT_CATEGORY_ID = ?) ");
            parameters.addElement(new StringValue(projectID));
        }
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientCallStatistic").replaceAll("whereStatement", where.toString()).trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    wbo.setAttribute("answered", r.getBigDecimal("ANSWERED") != null ? r.getBigDecimal("ANSWERED") : "0");
                    wbo.setAttribute("notAnswered", r.getBigDecimal("NOT_ANSWERED") != null ? r.getBigDecimal("NOT_ANSWERED") : "0");
                    wbo.setAttribute("userName", r.getString("USER_NAME"));
                    wbo.setAttribute("userID", r.getString("USER_ID"));
                } catch (NoSuchColumnException | UnsupportedConversionException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getMyClientStatistic(String userID, String campaignID, java.sql.Date beginDate, java.sql.Date endDate,
            String projectID) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;

        Vector parameters = new Vector();
        parameters.addElement(new StringValue(userID));
        parameters.addElement(new DateValue(beginDate));
        parameters.addElement(new DateValue(endDate));
        StringBuilder whrStmnt = new StringBuilder();
        if (!campaignID.equals("0")) {
            whrStmnt.append(" AND AP.CLIENT_ID IN (SELECT CLIENT_ID FROM CLIENT_CAMPAIGN WHERE CAMPAIGN_ID IN ('")
                    .append(campaignID.replaceAll(",", "','")).append("'))");
        }
        if (projectID != null && !projectID.equals("")) {
            whrStmnt.append(" AND CL.SYS_ID IN (SELECT CP.CLIENT_ID FROM CLIENT_PROJECTS CP WHERE CP.PRODUCT_CATEGORY_ID = ?)");
            parameters.addElement(new StringValue(projectID));
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getMyCallCenterStat").replaceAll("whrStmnt", whrStmnt.toString()).trim());

            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    if (r.getBigDecimal("Answered") != null) {
                        wbo.setAttribute("Answered", r.getBigDecimal("Answered"));
                    } else {
                        wbo.setAttribute("Answered", "0");
                    }

                    if (r.getBigDecimal("Not_Answered") != null) {
                        wbo.setAttribute("Not_Answered", r.getBigDecimal("Not_Answered"));
                    } else {
                        wbo.setAttribute("Not_Answered", "0");
                    }
                } catch (NoSuchColumnException | UnsupportedConversionException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getCallCenterDetails(String departmentID, String campaignID, String type, String beginDate, String endDate, String projectID) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;

        Vector parameters = new Vector();
        if (!departmentID.equals("0")) {
            parameters.addElement(new StringValue(departmentID));
        }
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));
        if (!campaignID.equals("0")) {
            parameters.addElement(new StringValue(campaignID));
        }
        
        StringBuilder whrStmnt = new StringBuilder();
        if (projectID != null && !projectID.isEmpty()) {
            whrStmnt.append(" AND Appointment.CLIENT_ID IN (SELECT CP.CLIENT_ID FROM CLIENT_PROJECTS CP WHERE CP.PRODUCT_CATEGORY_ID = ?) ");
            parameters.addElement(new StringValue(projectID));
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            if (type.equals("Answered") && campaignID.equals("0") && departmentID.equals("0")) {
                forQuery.setSQLQuery(getQuery("getAbstarctAnsweredDetailed").trim());
            } else if (type.equals("Answered") && campaignID.equals("0") && !departmentID.equals("0")) {
                forQuery.setSQLQuery(getQuery("getAnsweredDetailed").trim());
            } else if (type.equals("Answered") && !campaignID.equals("0") && !departmentID.equals("0")) {
                forQuery.setSQLQuery(getQuery("getAnsweredDetailedWithCampaign").replaceAll("whrStmnt", whrStmnt.toString()).trim());
            } else if (type.equals("Answered") && !campaignID.equals("0") && departmentID.equals("0")) {
                forQuery.setSQLQuery(getQuery("getAnswerDetWithCampOnly").replaceAll("whrStmnt", whrStmnt.toString()).trim());
            } else if (type.equals("Not_Answered") && campaignID.equals("0") && departmentID.equals("0")) {
                forQuery.setSQLQuery(getQuery("getAbstractNotAnsweredDetailed").trim());
            } else if (type.equals("Not_Answered") && campaignID.equals("0") && !departmentID.equals("0")) {
                forQuery.setSQLQuery(getQuery("getNotAnsweredDetailed").trim());
            } else if (type.equals("Not_Answered") && !campaignID.equals("0") && !departmentID.equals("0")) {
                forQuery.setSQLQuery(getQuery("getNotAnsweredDetailedWithCampaign").replaceAll("whrStmnt", whrStmnt.toString()).trim());
            } else if (type.equals("Not_Answered") && !campaignID.equals("0") && departmentID.equals("0")) {
                forQuery.setSQLQuery(getQuery("getNotAnsweredDetlWithCampOnly").replaceAll("whrStmnt", whrStmnt.toString()).trim());
            }

            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    if (r.getString("FULL_NAME") != null) {
                        wbo.setAttribute("User_NAME", r.getString("FULL_NAME"));
                    } else {
                        wbo.setAttribute("User_NAME", "---");
                    }

                    if (r.getString("NAME") != null) {
                        wbo.setAttribute("Client_NAME", r.getString("NAME"));
                    } else {
                        wbo.setAttribute("Client_NAME", "---");
                    }

                    if (r.getString("APPOINTMENT_DATE") != null) {
                        wbo.setAttribute("AppointmentDate", r.getString("APPOINTMENT_DATE"));
                    } else {
                        wbo.setAttribute("AppointmentDate", "---");
                    }

                    if (r.getString("COMMENT") != null) {
                        wbo.setAttribute("comment", r.getString("COMMENT"));
                    } else {
                        wbo.setAttribute("comment", "---");
                    }

                    if (r.getString("OPTION2") != null) {
                        wbo.setAttribute("appointmentType", r.getString("OPTION2"));
                    } else {
                        wbo.setAttribute("appointmentType", "---");
                    }

                    if (r.getString("OPTION9") != null) {
                        wbo.setAttribute("callStatue", r.getString("OPTION9"));
                    } else {
                        wbo.setAttribute("callStatue", "---");
                    }

                    if (r.getString("OPTION8") != null && !r.getString("OPTION8").equals("UL")) {
                        wbo.setAttribute("autoCallDuration", r.getString("OPTION8"));
                    } else {
                        wbo.setAttribute("autoCallDuration", "---");
                    }

                    if (r.getString("CALL_DURATION") != null) {
                        wbo.setAttribute("callDuration", r.getString("CALL_DURATION"));
                    } else {
                        wbo.setAttribute("callDuration", "---");
                    }

                    if (r.getString("NOTE") != null) {
                        wbo.setAttribute("callRes", r.getString("NOTE"));
                    } else {
                        wbo.setAttribute("callRes", "---");
                    }

                    if (r.getString("CLIENT_ID") != null) {
                        wbo.setAttribute("CLIENT_ID", r.getString("CLIENT_ID"));
                    } else {
                        wbo.setAttribute("CLIENT_ID", "---");
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getCallTypeStat(String departmentID, String campaignID, String type, String beginDate, String endDate, String projectID) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;

        Vector parameters = new Vector();
        if (type.equals("Answered")) {
            parameters.addElement(new StringValue("answered"));
        } else {
            parameters.addElement(new StringValue("not answered"));
        }
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));

        if (!departmentID.equals("0")) {
            parameters.addElement(new StringValue(departmentID));
        }
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));
        if (type.equals("Answered")) {
            parameters.addElement(new StringValue("answered"));
        } else {
            parameters.addElement(new StringValue("not answered"));
        }

        if (!campaignID.equals("0")) {
            parameters.addElement(new StringValue(campaignID));
        }
        
        StringBuilder whrStmnt = new StringBuilder();
        if (projectID != null && !projectID.isEmpty()) {
            whrStmnt.append(" AND Appointment.CLIENT_ID IN (SELECT CP.CLIENT_ID FROM CLIENT_PROJECTS CP WHERE CP.PRODUCT_CATEGORY_ID = ?)");
            parameters.addElement(new StringValue(projectID));
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);

            String query = "";
            if (!campaignID.equals("0") && !departmentID.equals("0")) {
                query = getQuery("getCallTypeStatWithCampaign").replaceAll("whrStmnt", whrStmnt.toString()).trim();
            } else if (!campaignID.equals("0") && departmentID.equals("0")) {
                query = getQuery("getCallTypeStatWithCampaignOnly").replaceAll("whrStmnt", whrStmnt.toString()).trim();
            } else if (campaignID.equals("0") && !departmentID.equals("0")) {
                query = getQuery("getCallTypeStat");
            } else if (campaignID.equals("0") && departmentID.equals("0")) {
                query = getQuery("getAbstractCallTypeStat");
            }

            forQuery.setSQLQuery(query.trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    if (r.getBigDecimal("Total") != null) {
                        wbo.setAttribute("Total", r.getBigDecimal("Total"));
                    } else {
                        wbo.setAttribute("Total", "0");
                    }

                    if (r.getString("OPTION2") != null) {
                        wbo.setAttribute("CallType", r.getString("OPTION2"));
                    } else {
                        wbo.setAttribute("CallType", "---");
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getCallResultStat(String departmentID, String campaignID, String type, String beginDate, String endDate, String projectID) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;

        Vector parameters = new Vector();
        if (type.equals("Answered")) {
            parameters.addElement(new StringValue("answered"));
        } else {
            parameters.addElement(new StringValue("not answered"));
        }
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));
        if (!departmentID.equals("0")) {
            parameters.addElement(new StringValue(departmentID));
        }

        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));
        if (type.equals("Answered")) {
            parameters.addElement(new StringValue("answered"));
        } else {
            parameters.addElement(new StringValue("not answered"));
        }

        if (!campaignID.equals("0")) {
            parameters.addElement(new StringValue(campaignID));
        }
        
        StringBuilder whrStmnt = new StringBuilder();
        if (projectID != null && !projectID.isEmpty()) {
            whrStmnt.append(" AND Appointment.CLIENT_ID IN (SELECT CP.CLIENT_ID FROM CLIENT_PROJECTS CP WHERE CP.PRODUCT_CATEGORY_ID = ?)");
            parameters.addElement(new StringValue(projectID));
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);

            String query = "";
            if (!campaignID.equals("0") && !departmentID.equals("0")) {
                query = getQuery("getCallResultStatWithCampaign").replaceAll("whrStmnt", whrStmnt.toString()).trim();
            } else if (!campaignID.equals("0") && departmentID.equals("0")) {
                query = getQuery("getCallResultStatWithCampOnly").replaceAll("whrStmnt", whrStmnt.toString()).trim();
            } else if (campaignID.equals("0") && !departmentID.equals("0")) {
                query = getQuery("getCallResultStat");
            } else if (campaignID.equals("0") && departmentID.equals("0")) {
                query = getQuery("getAbstractCallResultStat");
            }

            forQuery.setSQLQuery(query.trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    if (r.getBigDecimal("Total") != null) {
                        wbo.setAttribute("Total", r.getBigDecimal("Total"));
                    } else {
                        wbo.setAttribute("Total", "0");
                    }

                    if (r.getString("NOTE") != null) {
                        wbo.setAttribute("CallResult", r.getString("NOTE"));
                    } else {
                        wbo.setAttribute("CallResult", "---");
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }
    
    public ArrayList<WebBusinessObject> getCountOfNotAnsweredAndWrongApp(String beginDate, String endDate, String loggegUserId) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;

        Vector parameters = new Vector();
        
        parameters.addElement(new StringValue(loggegUserId));
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));
        
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);

            String query = "";
            query = getQuery("getCountOfAnsweredAndWrongApp");
            
            forQuery.setSQLQuery(query.trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    if (r.getBigDecimal("Total") != null) {
                        wbo.setAttribute("Total", r.getBigDecimal("Total"));
                    } else {
                        wbo.setAttribute("Total", "0");
                    }

                    if (r.getString("OPTION9") != null) {
                        wbo.setAttribute("CallResult", r.getString("OPTION9"));
                    } else {
                        wbo.setAttribute("CallResult", "---");
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getCallCenterDetailsByUsrID(String usrID, String type, String beginDate, String endDate, String campaignID, String projectID) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;
        
        StringBuilder where = new StringBuilder();
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(usrID));
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));
        if (campaignID != null && !campaignID.isEmpty() && !"0".equals(campaignID)) {
            where.append(" AND AP.CLIENT_ID IN (SELECT CLIENT_ID FROM CLIENT_CAMPAIGN WHERE CAMPAIGN_ID IN ('")
                    .append(campaignID.replaceAll(",", "','")).append("'))");
        }
        if (projectID != null && !projectID.isEmpty()) {
            where.append(" AND CL.SYS_ID IN (SELECT CP.CLIENT_ID FROM CLIENT_PROJECTS CP WHERE CP.PRODUCT_CATEGORY_ID = ?) ");
            parameters.addElement(new StringValue(projectID));
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getCallCenterDetailsByUsrID").replaceAll("option9Val", type.equals("Answered") ? "'answered'" : "'not answered'").trim()
            + where.toString() + " ORDER BY AP.APPOINTMENT_DATE");
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    if (r.getString("FULL_NAME") != null) {
                        wbo.setAttribute("User_NAME", r.getString("FULL_NAME"));
                    } else {
                        wbo.setAttribute("User_NAME", "---");
                    }

                    if (r.getString("NAME") != null) {
                        wbo.setAttribute("Client_NAME", r.getString("NAME"));
                    } else {
                        wbo.setAttribute("Client_NAME", "---");
                    }

                    if (r.getString("APPOINTMENT_DATE") != null) {
                        wbo.setAttribute("AppointmentDate", r.getString("APPOINTMENT_DATE"));
                    } else {
                        wbo.setAttribute("AppointmentDate", "---");
                    }

                    if (r.getString("COMMENT") != null) {
                        wbo.setAttribute("comment", r.getString("COMMENT"));
                    } else {
                        wbo.setAttribute("comment", "---");
                    }

                    if (r.getString("OPTION2") != null) {
                        wbo.setAttribute("appointmentType", r.getString("OPTION2"));
                    } else {
                        wbo.setAttribute("appointmentType", "---");
                    }

                    if (r.getString("OPTION9") != null) {
                        wbo.setAttribute("callStatue", r.getString("OPTION9"));
                    } else {
                        wbo.setAttribute("callStatue", "---");
                    }

                    if (r.getString("OPTION8") != null && !r.getString("OPTION8").equals("UL")) {
                        wbo.setAttribute("autoCallDuration", r.getString("OPTION8"));
                    } else {
                        wbo.setAttribute("autoCallDuration", "---");
                    }

                    if (r.getString("CALL_DURATION") != null) {
                        wbo.setAttribute("callDuration", r.getString("CALL_DURATION"));
                    } else {
                        wbo.setAttribute("callDuration", "---");
                    }

                    if (r.getString("NOTE") != null) {
                        wbo.setAttribute("callRes", r.getString("NOTE"));
                    } else {
                        wbo.setAttribute("callRes", "---");
                    }

                    if (r.getString("CLIENT_ID") != null) {
                        wbo.setAttribute("CLIENT_ID", r.getString("CLIENT_ID"));
                    } else {
                        wbo.setAttribute("CLIENT_ID", "---");
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }

    public ArrayList<ArrayList<String>> getAppointmentsDetailsByStatus(String type, String beginDate, String endDate, String usrID, String rprtType) {
        Connection connection = null;

        ArrayList<ArrayList<String>> data = new ArrayList<>();

        Vector parameters = new Vector();
        if (rprtType != null && rprtType.equals("myReport")) {
            parameters.addElement(new StringValue(usrID));
        }
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));
        StringBuilder where = new StringBuilder(" and Appointment.current_status in (");
        where.append(Tools.concatenation(type.split(","), ","));
        where.append(")");

        Vector<Row> queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);

            if (rprtType != null && rprtType.equals("myReport")) {
                forQuery.setSQLQuery(getQuery("getMyAppointmentDetails").trim().replace("whereStatement", where.toString()));
            } else {
                forQuery.setSQLQuery(getQuery("getAppointmentDetails").trim().replace("whereStatement", where.toString()));
            }

            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }

        if (queryResult != null) {
            for (Row r : queryResult) {
                try {
                    ArrayList<String> wbo = new ArrayList<>();
                    if (r.getString("NAME") != null) {
                        wbo.add(r.getString("NAME"));
                    } else {
                        wbo.add("---");
                    }

                    if (r.getString("FULL_NAME") != null) {
                        wbo.add(r.getString("FULL_NAME"));
                    } else {
                        wbo.add("---");
                    }

                    if (r.getString("creation_time") != null) {
                        wbo.add(r.getString("creation_time"));
                    } else {
                        wbo.add("---");
                    }

                    if (r.getString("APPOINTMENT_DATE") != null) {
                        wbo.add(r.getString("APPOINTMENT_DATE"));
                    } else {
                        wbo.add("---");
                    }

                    if (r.getString("APPOINTMENT_PLACE") != null) {
                        wbo.add(r.getString("APPOINTMENT_PLACE"));
                    } else {
                        wbo.add("---");
                    }

                    if (r.getString("COMMENT") != null) {
                        wbo.add(r.getString("COMMENT"));
                    } else {
                        wbo.add("---");
                    }

                    /*if (r.getString("OPTION2") != null) {
                     wbo.add(r.getString("OPTION2"));
                     } else {
                     wbo.add("---");
                     }*/
                    if (r.getString("OPTION9") != null && !r.getString("OPTION9").equals("UL")) {
                        wbo.add(r.getString("OPTION9"));
                    } else {
                        wbo.add("---");
                    }

                    if (r.getString("OPTION8") != null && !r.getString("OPTION8").equals("UL")) {
                        wbo.add(r.getString("OPTION8"));
                    } else {
                        wbo.add("---");
                    }

                    /*if (r.getString("CALL_DURATION") != null) {
                     wbo.add(r.getString("CALL_DURATION"));
                     } else {
                     wbo.add("---");
                     }

                     if (r.getString("NOTE") != null) {
                     wbo.add(r.getString("NOTE"));
                     } else {
                     wbo.add("---");
                     }*/
                    if (r.getString("CLIENT_ID") != null) {
                        wbo.add(r.getString("CLIENT_ID"));
                    } else {
                        wbo.add("---");
                    }

                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
            }
        }
        return data;
    }

    public ArrayList<ArrayList<String>> getFuturedAppointmentDetails(String beginDate, String endDate, String usrID, String rprtType, String departmentID, String loggedUserID) {
        Connection connection = null;
        ArrayList<ArrayList<String>> data = new ArrayList<>();
        Vector parameters = new Vector();

        if (loggedUserID != null) {
            parameters.addElement(new StringValue(loggedUserID));
        } else {
            parameters.addElement(new StringValue(""));
        }
        if (rprtType != null) {
            if (rprtType.equals("myReport")) {
                parameters.addElement(new StringValue(usrID));
            }
        }

        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));
        Vector<Row> queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);

            if (rprtType != null) {
                if (rprtType.equals("myReport")) {
                    forQuery.setSQLQuery(getQuery("getMyFuturedAppointmentDetails").trim());
                }
            } else {
                StringBuilder where = new StringBuilder();
                if (departmentID != null) {
                    if (departmentID.equals("all")) {
                        where.append(" AND APPOINTMENT.USER_ID IN (SELECT EMP_ID FROM EMP_MGR WHERE MGR_ID IN (SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID IN (SELECT DEPARTMENT_ID FROM USER_DEPARTMENT_CONFIG WHERE USER_ID = ?)))");
                        parameters.addElement(new StringValue(loggedUserID));
                    } else {
                        where.append(" AND APPOINTMENT.USER_ID IN (SELECT EMP_ID FROM EMP_MGR WHERE MGR_ID IN (SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID = ?))");
                        parameters.addElement(new StringValue(departmentID));
                    }
                }
                forQuery.setSQLQuery(getQuery("getFuturedAppointmentDetails").trim() + where.toString());
            }

            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            for (Row r : queryResult) {
                try {
                    ArrayList<String> wbo = new ArrayList<>();
                    wbo.add(r.getString("NAME") != null ? r.getString("NAME") : "---");
                    wbo.add(r.getString("FULL_NAME") != null ? r.getString("FULL_NAME") : "---");
                    wbo.add(r.getString("creation_time") != null ? r.getString("creation_time").substring(0, 16) : "---");
                    wbo.add(r.getString("APPOINTMENT_DATE") != null ? r.getString("APPOINTMENT_DATE").substring(0, 16) : "---");
                    wbo.add(r.getString("APPOINTMENT_PLACE") != null ? r.getString("APPOINTMENT_PLACE") : "---");
                    wbo.add(r.getString("COMMENT") != null ? r.getString("COMMENT") : "---");
                    wbo.add(r.getString("OPTION9") != null && !r.getString("OPTION9").equals("UL") ? r.getString("OPTION9") : "---");
                    if (departmentID != null && loggedUserID != null) {
                        wbo.add(r.getString("COMMENT_DESC") != null ? r.getString("COMMENT_DESC") : "---");
                        wbo.add(r.getString("COMMENTED_ON_TIME") != null ? r.getString("COMMENTED_ON_TIME").substring(0, 16) : "---");
                    }
                    wbo.add(r.getString("CLIENT_ID") != null ? r.getString("CLIENT_ID") : "---");
                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    logger.error(ex);
                }
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getCallTypeStatByUsrID(String usrID, String type, String beginDate, String endDate) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;

        Vector parameters = new Vector();
        parameters.addElement(new StringValue(usrID));
        if (type.equals("Answered")) {
            parameters.addElement(new StringValue("answered"));
        } else {
            parameters.addElement(new StringValue("not answered"));
        }
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));
        if (type.equals("Answered")) {
            parameters.addElement(new StringValue("answered"));
        } else {
            parameters.addElement(new StringValue("not answered"));
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);

            String query = "";
            query = getQuery("getCallTypeStatByUsrID");

            forQuery.setSQLQuery(query.trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    if (r.getBigDecimal("Total") != null) {
                        wbo.setAttribute("Total", r.getBigDecimal("Total"));
                    } else {
                        wbo.setAttribute("Total", "0");
                    }

                    if (r.getString("OPTION2") != null) {
                        wbo.setAttribute("CallType", r.getString("OPTION2"));
                    } else {
                        wbo.setAttribute("CallType", "---");

                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(AppointmentMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(AppointmentMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getCallResultStatByUsrID(String usrID, String type, String beginDate, String endDate) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;

        Vector parameters = new Vector();
        parameters.addElement(new StringValue(usrID));
        if (type.equals("Answered")) {
            parameters.addElement(new StringValue("answered"));
        } else {
            parameters.addElement(new StringValue("not answered"));
        }
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));
        if (type.equals("Answered")) {
            parameters.addElement(new StringValue("answered"));
        } else {
            parameters.addElement(new StringValue("not answered"));
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);

            String query = "";
            query = getQuery("getCallResultStatByUsrID");

            forQuery.setSQLQuery(query.trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    if (r.getBigDecimal("Total") != null) {
                        wbo.setAttribute("Total", r.getBigDecimal("Total"));
                    } else {
                        wbo.setAttribute("Total", "0");
                    }

                    if (r.getString("NOTE") != null) {
                        wbo.setAttribute("CallResult", r.getString("NOTE"));
                    } else {
                        wbo.setAttribute("CallResult", "---");

                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(AppointmentMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(AppointmentMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }

    public ArrayList<ArrayList<String>> getDeptsStatistics(String beginDate, String endDate) {
        Connection connection = null;

        Vector parameters = new Vector();
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));

        Vector<Row> queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getDeptsStatistic").trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }

        ArrayList<ArrayList<String>> data = new ArrayList<>();
        for (Row row : queryResult) {
            try {
                ArrayList<String> wbo = new ArrayList<>();

                if (row.getString("project_name") != null) {
                    wbo.add(row.getString("project_name"));
                } else {
                    wbo.add("---");
                }

                if (row.getString("full_name") != null) {
                    wbo.add(row.getString("full_name"));
                } else {
                    wbo.add("---");
                }

                if (row.getBigDecimal("call") != null) {
                    wbo.add(row.getBigDecimal("call").toString());
                } else {
                    wbo.add("0");
                }

                if (row.getBigDecimal("call_duration") != null) {
                    wbo.add(row.getBigDecimal("call_duration").toString());
                } else {
                    wbo.add("0");
                }

                if (row.getBigDecimal("meeting") != null) {
                    wbo.add(row.getBigDecimal("meeting").toString());
                } else {
                    wbo.add("0");
                }

                if (row.getBigDecimal("meeting_duration") != null) {
                    wbo.add(row.getBigDecimal("meeting_duration").toString());
                } else {
                    wbo.add("0");
                }

                if (row.getString("USER_ID") != null) {
                    wbo.add(row.getString("USER_ID"));
                } else {
                    wbo.add("---");
                }

                if (row.getString("option_one") != null) {
                    wbo.add(row.getString("option_one"));
                } else {
                    wbo.add("---");
                }

                data.add(wbo);
            } catch (Exception ex) {
                logger.error(ex);
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getCallCnterClientsStat(String beginDate, String endDate, String rateID,
            String groupID, String userID) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;

        Vector parameters = new Vector();

        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        StringBuilder where = new StringBuilder();
        if (rateID != null && !rateID.isEmpty()) {
            where.append(" AND CR.RATE_ID = ?");
            parameters.addElement(new StringValue(rateID));
        }
        if (userID != null && !userID.isEmpty()) {
            where.append(" AND AP.USER_ID = ?");
            parameters.addElement(new StringValue(userID));
        } else {
            where.append(" AND AP.USER_ID IN (SELECT USER_ID FROM USER_GROUP WHERE GROUP_ID = ?)");
            parameters.addElement(new StringValue(groupID != null ? groupID : ""));
        }
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);

            String query = "";
            query = getQuery("getClientStatistic").replace("whereStatement", where.toString());

            forQuery.setSQLQuery(query.trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    if (r.getString("CLIENT_ID") != null) {
                        wbo.setAttribute("CLIENT_ID", r.getString("CLIENT_ID"));
                    } else {
                        wbo.setAttribute("CLIENT_ID", "---");

                    }

                    if (r.getString("NAME") != null) {
                        wbo.setAttribute("CLIENT_NAME", r.getString("NAME"));
                    } else {
                        wbo.setAttribute("CLIENT_NAME", "---");

                    }

                    if (r.getBigDecimal("call") != null) {
                        wbo.setAttribute("call", r.getBigDecimal("call"));
                    } else {
                        wbo.setAttribute("call", "0");
                    }

                    if (r.getBigDecimal("meeting") != null) {
                        wbo.setAttribute("meeting", r.getBigDecimal("meeting"));
                    } else {
                        wbo.setAttribute("meeting", "0");
                    }


                    if (r.getString("RATE") != null && !r.getString("RATE").equals("null")) {
                        wbo.setAttribute("rate", r.getString("RATE"));
                    } else {
                        wbo.setAttribute("rate", " ");
                    }

                    if (r.getString("FULL_NAME") != null) {
                        wbo.setAttribute("fullName", r.getString("FULL_NAME"));
                    } else {
                        wbo.setAttribute("fullName", " ");
                    }
                } catch (NoSuchColumnException | UnsupportedConversionException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }

    public WebBusinessObject getFutureAppointment(String clientID) {
        Connection connection = null;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(clientID));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            String query = getQuery("getFutureAppointment");
            forQuery.setSQLQuery(query.trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                return wbo;
            }
        }
        return null;
    }

    public ArrayList<WebBusinessObject> getJOComplaint(String beginDate, String endDate, String usrID) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;

        Vector parameters = new Vector();

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            StringBuilder sql = new StringBuilder(getQuery("getJOComplaint").trim());

            parameters.addElement(new StringValue(usrID));

            if (beginDate != null && !beginDate.isEmpty()) {
                sql.append(" AND trunc(CC.CREATION_TIME) >= to_date(?, 'yyyy/MM/dd')");
                parameters.addElement(new StringValue(beginDate));
            }

            if (endDate != null && !endDate.isEmpty()) {
                sql.append(" AND trunc(CC.CREATION_TIME) <= to_date(?, 'yyyy/MM/dd')");
                parameters.addElement(new StringValue(endDate));
            }
            sql.append(" ORDER BY CC.CREATION_TIME");

            forQuery.setSQLQuery(sql.toString());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    if (r.getString("complaintID") != null) {
                        wbo.setAttribute("complaintID", r.getString("complaintID"));
                    } else {
                        wbo.setAttribute("complaintID", "");
                    }

                    if (r.getString("ISSUE_ID") != null) {
                        wbo.setAttribute("issueID", r.getString("ISSUE_ID"));
                    } else {
                        wbo.setAttribute("issueID", "");
                    }

                    if (r.getString("SYS_ID") != null) {
                        wbo.setAttribute("clientID", r.getString("SYS_ID"));
                    } else {
                        wbo.setAttribute("clientID", "");

                    }

                    if (r.getString("CLIENT_NO") != null) {
                        wbo.setAttribute("clientNo", r.getString("CLIENT_NO"));
                    } else {
                        wbo.setAttribute("clientNo", "");

                    }

                    if (r.getString("NAME") != null) {
                        wbo.setAttribute("clientName", r.getString("NAME"));
                    } else {
                        wbo.setAttribute("clientName", "");
                    }

                    if (r.getString("PHONE") != null) {
                        wbo.setAttribute("clientPhone", r.getString("PHONE"));
                    } else {
                        wbo.setAttribute("clientPhone", "");
                    }

                    if (r.getString("MOBILE") != null) {
                        wbo.setAttribute("ClientMob", r.getString("MOBILE"));
                    } else {
                        wbo.setAttribute("ClientMob", "");
                    }

                    if (r.getString("EMAIL") != null) {
                        wbo.setAttribute("clientMail", r.getString("EMAIL"));
                    } else {
                        wbo.setAttribute("clientMail", "");
                    }

                    if (r.getString("ANY_COMMENT") != null) {
                        wbo.setAttribute("compliantDesc", r.getString("ANY_COMMENT"));
                    } else {
                        wbo.setAttribute("compliantDesc", "");
                    }

                    if (r.getString("SERV_LEVEL_AGR") != null) {
                        if (r.getString("SERV_LEVEL_AGR").equals("1")) {
                            wbo.setAttribute("priorty", "Normal");
                        } else if (r.getString("SERV_LEVEL_AGR").equals("2")) {
                            wbo.setAttribute("priorty", "Urgent");
                        }
                    } else {
                        wbo.setAttribute("SERV_LEVEL_AGR", "");
                    }

                    if (r.getString("CASE_EN") != null) {
                        wbo.setAttribute("complaintStatus", r.getString("CASE_EN"));
                    } else {
                        wbo.setAttribute("complaintStatus", "");
                    }

                    if (r.getString("CREATION_TIME") != null) {
                        wbo.setAttribute("creationTime", r.getString("CREATION_TIME"));
                    } else {
                        wbo.setAttribute("creationTime", "");
                    }

                    if (r.getString("FULL_NAME") != null) {
                        wbo.setAttribute("reciptUsr", r.getString("FULL_NAME"));
                    } else {
                        wbo.setAttribute("reciptUsr", "");
                    }

                    if (r.getString("eqClassID") != null) {
                        wbo.setAttribute("eqClassID", r.getString("eqClassID"));
                    } else {
                        wbo.setAttribute("eqClassID", "");
                    }

                    if (r.getString("eqClassName") != null) {
                        wbo.setAttribute("eqClass", r.getString("eqClassName"));
                    } else {
                        wbo.setAttribute("eqClass", "");
                    }

                    if (r.getString("originalIssID") != null) {
                        wbo.setAttribute("oIssID", r.getString("originalIssID"));
                    } else {
                        wbo.setAttribute("oIssID", "");
                    }

                    if (r.getString("USER_ID") != null) {
                        wbo.setAttribute("oUsrID", r.getString("USER_ID"));
                    } else {
                        wbo.setAttribute("oUsrID", "");
                    }

                    if (r.getString("eq_ID") != null) {
                        wbo.setAttribute("eqID", r.getString("eq_ID"));
                    } else {
                        wbo.setAttribute("eqID", "");
                    }

                    if (r.getString("eq_Name") != null) {
                        wbo.setAttribute("eqName", r.getString("eq_Name"));
                    } else {
                        wbo.setAttribute("eqName", "");
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }
    
    public Vector getAppointmentSorted(String clientID) {
        Vector data = new Vector();
        Connection connection = null;

        Vector parameters = new Vector();

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            StringBuilder sql = new StringBuilder(getQuery("getAppointmentSorted").trim());

            parameters.addElement(new StringValue(clientID));

            forQuery.setSQLQuery(sql.toString());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                data.add(fabricateBusObj(r));
            }
        }
        return data;
    }
    public String getScheduleLastAppointment(String scheduleID) {
        try {
            Vector<WebBusinessObject> result = getOnArbitraryKeyOrdered(scheduleID, "key4", "key3");
            if(!result.isEmpty()) {
                return (String) result.get(result.size() - 1).getAttribute("appointmentDate");
            }
        } catch (Exception ex) {
            Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
    
    public boolean deleteAllFutureAppointments(String clientID) {
        SQLCommandBean command = new SQLCommandBean();
	Vector parameters = new Vector();
	parameters.addElement(new StringValue(clientID));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("deleteAllFutureAppointments"));
	    command.setparams(parameters);
            command.executeUpdate();
        } catch (SQLException ex) {
            try {
                connection.rollback();
            } catch (SQLException sq) {
                logger.error("Close Error " + sq.getMessage());
            }
            logger.error(ex.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error " + ex.getMessage());
                return false;
            }
        }
        return (true);
    }
    
    public ArrayList<WebBusinessObject> getFutureClientAppointments(String clientID, String createdBy) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(clientID));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getFutureClientAppointments").trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                try {
                    if (r.getString("CREATED_BY_NAME") != null) {
                        wbo.setAttribute("createdByName", r.getString("CREATED_BY_NAME"));
                    }
                    if (r.getString("STATUS_NAME_EN") != null) {
                        wbo.setAttribute("statusNameEn", r.getString("STATUS_NAME_EN"));
                    }
                    if (r.getString("STATUS_NAME_AR") != null) {
                        wbo.setAttribute("statusNameAr", r.getString("STATUS_NAME_AR"));
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        return data;
    }
    
    public boolean updateAppointmentMeetingType(String id, String newType) throws SQLException {
        Connection connection = null;
        int queryResult = -1000;
        try {
            Vector params = new Vector();
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            params.addElement(new StringValue(newType));
            params.addElement(new StringValue(id));
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("updateAppointmentMeetingType").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        } finally {
            connection.close();
        }
        return queryResult >= 0;
    }
    
    public WebBusinessObject getEmployeeCallStatistics(String userID, java.sql.Date inDate) {
        Connection connection = null;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(userID));
        parameters.addElement(new DateValue(inDate));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getEmployeeCallStatistics").trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        WebBusinessObject wbo = new WebBusinessObject();
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                try {
                    wbo.setAttribute("total12", r.getString("TOTAL12") != null ? r.getString("TOTAL12") : "0");
                    wbo.setAttribute("total15", r.getString("TOTAL15") != null ? r.getString("TOTAL15") : "0");
                    wbo.setAttribute("total18", r.getString("TOTAL18") != null ? r.getString("TOTAL18") : "0");
                    wbo.setAttribute("total21", r.getString("TOTAL21") != null ? r.getString("TOTAL21") : "0");
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        return wbo;
    }
    
    public Integer getAppointmentsCount(String userID, java.sql.Date inDate) {
        Connection connection = null;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(userID));
        parameters.addElement(new DateValue(inDate));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getAppointmentsCount").trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                try {
                    return r.getString("APPOINTMENT_NO") != null ? Integer.valueOf(r.getString("APPOINTMENT_NO")) : 0;
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        return 0;
    }
    
    public Integer getAppointmentsCountInPeriod(String userID,java.sql.Date from,java.sql.Date to){
        
        int data =0;
        Connection connection = null;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(userID));
        parameters.addElement(new DateValue(from));
        parameters.addElement(new DateValue(to));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getAppointmentsCountInPeriod").trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                try {
                   return r.getString("appointCount") != null ? Integer.valueOf(r.getString("appointCount")) : 0;
                    
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                
            }
        }
        return 0;
    }
}
