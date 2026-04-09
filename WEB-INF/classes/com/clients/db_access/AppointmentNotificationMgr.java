package com.clients.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.List;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.commons.lang.time.DateUtils;
import org.apache.log4j.xml.DOMConfigurator;

public class AppointmentNotificationMgr extends RDBGateWay {

    private static final AppointmentNotificationMgr APPOINTMENT_NOTIFICATION_MGR = new AppointmentNotificationMgr();

    public static AppointmentNotificationMgr getInstance() {
        logger.info("Getting AppointmentNotificationMgr Instance ....");
        return APPOINTMENT_NOTIFICATION_MGR;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("appointment_notification.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document, " + e);
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
        WebBusinessObject wbo;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("projectName"));
        }

        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    public List<WebBusinessObject> getAppointment(String userId, int remaining) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector result = new Vector();
        List<WebBusinessObject> data;

        parameters.addElement(new StringValue(userId));
        parameters.addElement(new IntValue(remaining));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getAppointment"));
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        Row row;
        Enumeration e = result.elements();
        data = new ArrayList<WebBusinessObject>();

        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            data.add(fabricateBusObj(row));
        }
        return data;
    }

    public List<WebBusinessObject> getAppointment(String userId, int remaining, String excludedId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector result = new Vector();
        List<WebBusinessObject> data;

        parameters.addElement(new StringValue(userId));
        parameters.addElement(new IntValue(remaining));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getAppointmentExcluded").trim().replaceAll("IDS", excludedId));
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        Row row;
        Enumeration e = result.elements();
        data = new ArrayList<WebBusinessObject>();

        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            data.add(fabricateBusObj(row));
        }
        return data;
    }

    public List<WebBusinessObject> getUserAppointmentByDate(String userId, String date) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector result = new Vector();
        List<WebBusinessObject> data;

        parameters.addElement(new StringValue(userId));
        parameters.addElement(new StringValue(date));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getUserAppointmentByDate").trim());
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        Row row;
        Enumeration e = result.elements();
        data = new ArrayList<WebBusinessObject>();

        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            data.add(fabricateBusObj(row));
        }
        return data;
    }

    public List<WebBusinessObject> getAppointmentForByDate(String userId, String date) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector result = new Vector();
        List<WebBusinessObject> data;

        parameters.addElement(new StringValue(userId));
        parameters.addElement(new StringValue(date));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getAppointmentForByDate").trim());
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        Row row;
        Enumeration e = result.elements();
        data = new ArrayList<WebBusinessObject>();

        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            data.add(fabricateBusObj(row));
        }
        return data;
    }

    public List<WebBusinessObject> getClientAppointmentByDate(String clientId, String date) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector result = new Vector();
        List<WebBusinessObject> data;

        parameters.addElement(new StringValue(clientId));
        parameters.addElement(new StringValue(date));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getClientAppointmentByDate").trim());
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        Row row;
        Enumeration e = result.elements();
        data = new ArrayList<WebBusinessObject>();

        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            data.add(fabricateBusObj(row));
        }
        return data;
    }

    public List<WebBusinessObject> getAppointmentsByDateOrdered(String appointmentType, String userID, java.sql.Date fromDate, java.sql.Date toDate, String grpID, String DepID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result = new Vector();
        Vector parameters = new Vector();
        List<WebBusinessObject> data;
        StringBuilder grpCon = new StringBuilder();

        if (grpID != null) {
            grpCon.append(" AND UG.GROUP_ID = ? ");
            parameters.addElement(new StringValue(grpID));
        }

        parameters.addElement(new StringValue(appointmentType));
        //parameters.addElement(new StringValue(userID));
        parameters.addElement(new DateValue(fromDate));
        parameters.addElement(new DateValue(toDate));
        parameters.addElement(new StringValue(DepID));
        parameters.addElement(new StringValue(DepID));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(getQuery("getAppointmentsByDateOrdered").replaceAll("GRP_CON", grpCon.toString()).trim());
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        data = new ArrayList<WebBusinessObject>();
        for (Row row : result) {
            WebBusinessObject wbo = new WebBusinessObject();
            wbo = fabricateBusObj(row);
            try {
                if (row.getString("GROUP_ID") != null) {
                    wbo.setAttribute("grpID", row.getString("GROUP_ID"));
                } else {
                    wbo.setAttribute("grpID", "");
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(AppointmentNotificationMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            data.add(wbo);
        }
        return data;
    }

    public List<WebBusinessObject> doneAppointment(String userId, String clientId, String date) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector result = new Vector();
        List<WebBusinessObject> data;
//        parameters.addElement(new StringValue(userId));
        parameters.addElement(new StringValue(clientId));
        parameters.addElement(new StringValue(date));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getDoneAppointmentByDate").trim());
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        Row row;
        Enumeration e = result.elements();
        data = new ArrayList<WebBusinessObject>();

        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            data.add(fabricateBusObj(row));
        }
        return data;
    }

    public List<WebBusinessObject> pendingAppointment(String userId, String clientId, String date) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector result = new Vector();
        List<WebBusinessObject> data;
//        parameters.addElement(new StringValue(userId));
        parameters.addElement(new StringValue(clientId));
        parameters.addElement(new StringValue(date));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getPendingAppointmentByDate").trim());
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        Row row;
        Enumeration e = result.elements();
        data = new ArrayList<WebBusinessObject>();

        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            data.add(fabricateBusObj(row));
        }
        return data;
    }

    public List<WebBusinessObject> getUserAppointment(String userId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector result = new Vector();
        List<WebBusinessObject> data;

        parameters.addElement(new StringValue(userId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getUserAppointment").trim());
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        Row row;
        Enumeration e = result.elements();
        data = new ArrayList<WebBusinessObject>();

        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            data.add(fabricateBusObj(row));
        }
        return data;
    }

    public List<WebBusinessObject> getClientAppointment(String clientId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector result = new Vector();
        List<WebBusinessObject> data;

        parameters.addElement(new StringValue(clientId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getClientAppointment").trim());
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        Row row;
        Enumeration e = result.elements();
        data = new ArrayList<WebBusinessObject>();

        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            data.add(fabricateBusObj(row));
        }
        return data;
    }

    public List<WebBusinessObject> getAppointmentByDate(Date from, Date to, String departmentID, String appTyp) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = new Vector();
        List<WebBusinessObject> data;
        parameters.addElement(new DateValue(new java.sql.Date(from.getTime())));
        parameters.addElement(new DateValue(new java.sql.Date(to.getTime())));

        StringBuilder departmentQuery = new StringBuilder();

        if (appTyp != null && !appTyp.isEmpty()) {
            parameters.addElement(new StringValue(appTyp));
            departmentQuery.append(" AND OPTION2 = ? AND CURRENT_STATUS_CODE != '29' ");
        }

        if (departmentID != null && !departmentID.isEmpty()) {
            departmentQuery.append("AND APPOINTMENT_FOR IN (SELECT USER_ID FROM USERS WHERE USER_ID IN (SELECT EMP_ID FROM EMP_MGR WHERE MGR_ID IN");
            departmentQuery.append(" (SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID IN ('").append(departmentID);
            departmentQuery.append("'))) UNION SELECT OPTION_ONE USER_ID FROM PROJECT WHERE PROJECT_ID IN ('").append(departmentID).append("'))");
        }
        System.out.println("departmentQuery ===================================>>> " + departmentQuery);
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getAppointmentByDate").replaceFirst("departmentQuery", departmentQuery.toString()).trim());
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        WebBusinessObject wbo;
        data = new ArrayList<WebBusinessObject>();

        for (Row row : result) {
            try {
                wbo = fabricateBusObj(row);
                wbo.setAttribute("dayNo", row.getString("DAY_NO"));
                data.add(wbo);
            } catch (NoSuchColumnException ex) {
                logger.error(ex);
            }
        }
        return data;
    }

    public List<WebBusinessObject> getAppointmentByDate2(String from, String to, String departmentID, String appTyp) throws ParseException {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = new Vector();
        List<WebBusinessObject> data;

        Calendar calendar = Calendar.getInstance();
        //calendar.setTime(to);
        calendar.set(Calendar.HOUR, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        calendar.add(Calendar.DATE, 1);

        SimpleDateFormat formatter = new SimpleDateFormat("yyyy/M/dd hh:mm:ss");

        DateParser dateParser = new DateParser();
        java.sql.Date bdate = dateParser.formatSqlDate(from);
        java.sql.Date edate = dateParser.formatSqlDate(to);

        parameters.addElement(new TimestampValue(new Timestamp(bdate.getTime())));
        parameters.addElement(new TimestampValue(new Timestamp(edate.getTime())));

        StringBuilder departmentQuery = new StringBuilder();

        if (appTyp != null && !appTyp.isEmpty()) {
            parameters.addElement(new StringValue(appTyp));
            departmentQuery.append(" AND OPTION2 = ? AND CURRENT_STATUS_CODE != '29' ");
        }

        if (departmentID != null && !departmentID.isEmpty()) {
            departmentQuery.append("AND APPOINTMENT_FOR IN (SELECT USER_ID FROM USERS WHERE USER_ID IN (SELECT EMP_ID FROM EMP_MGR WHERE MGR_ID IN");
            departmentQuery.append(" (SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID = '").append(departmentID);
            departmentQuery.append("')) UNION SELECT OPTION_ONE USER_ID FROM PROJECT WHERE PROJECT_ID = '").append(departmentID).append("')");
        }
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getAppointmentByDate").replaceFirst("departmentQuery", departmentQuery.toString()).trim());
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        WebBusinessObject wbo;
        data = new ArrayList<WebBusinessObject>();

        for (Row row : result) {
            try {
                wbo = fabricateBusObj(row);
                wbo.setAttribute("dayNo", row.getString("DAY_NO"));
                data.add(wbo);
            } catch (NoSuchColumnException ex) {
                logger.error(ex);
            }
        }
        return data;
    }

    public ArrayList<ArrayList<String>> getAppointmentByDateAndUserAndStatus(String type, String from, String to, String departmentID, String userID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = new Vector();

        parameters.addElement(new StringValue(from));
        parameters.addElement(new StringValue(to));

        parameters.addElement(new StringValue(userID));

        StringBuilder departmentQuery = new StringBuilder();
        StringBuilder typeQuery = new StringBuilder();
        StringBuilder OptionQuery = new StringBuilder();

        if (departmentID != null && !departmentID.isEmpty()) {
            departmentQuery.append("AND APPOINTMENT_FOR IN (SELECT USER_ID FROM USERS WHERE USER_ID IN (SELECT EMP_ID FROM EMP_MGR WHERE MGR_ID IN");
            departmentQuery.append(" (SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID = '").append(departmentID);
            departmentQuery.append("')) UNION SELECT OPTION_ONE USER_ID FROM PROJECT WHERE PROJECT_ID = '").append(departmentID).append("')");
        }

        typeQuery.append("and OPTION2 like '%" + type + "%' ");

        if (type.equals("meeting")) {
            OptionQuery.append(" and OPTION9 in ('attended')");
        } else {
            OptionQuery.append(" and OPTION9 not in ('not answered','wrong number')");
        }

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            String Query = getQuery("getUserClientsAppointmentsByStatus").replaceFirst("departmentQuery", departmentQuery.toString()).trim();
            Query = Query.replaceFirst("typeQuery", typeQuery.toString()).trim();
            Query = Query.replaceFirst("OptionType", OptionQuery.toString()).trim();
            command.setSQLQuery(Query);
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        ArrayList<ArrayList<String>> data = new ArrayList<>();
        for (Row row : result) {
            try {
                ArrayList<String> wbo = new ArrayList<>();

                if (row.getString("CLIENT_NAME") != null) {
                    wbo.add(row.getString("CLIENT_NAME"));
                } else {
                    wbo.add("---");
                }

                if (row.getString("MOBILE") != null) {
                    wbo.add(row.getString("MOBILE"));
                } else {
                    wbo.add("---");
                }
                if (row.getString("PHONE") != null) {
                    wbo.add(row.getString("PHONE"));
                } else {
                    wbo.add("---");
                }

                if (row.getTimestamp("CURRENT_STATUS_SINCE") != null) {
                    wbo.add(row.getTimestamp("CURRENT_STATUS_SINCE").toString().substring(0, 11));
                } else {
                    wbo.add("---");
                }

                if (row.getString("OPTION2") != null) {
                    wbo.add(row.getString("OPTION2"));
                } else {
                    wbo.add("---");
                }

                if (row.getString("OPTION9") == null || row.getString("OPTION9").equals("UL")) {
                    wbo.add("---");
                } else {
                    wbo.add(row.getString("OPTION9"));
                }

                if (row.getString("Note") == null || row.getString("Note").equals("UL")) {
                    wbo.add("---");
                } else {
                    wbo.add(row.getString("Note"));
                }

                if (row.getString("CALL_DURATION") != null) {
                    wbo.add(row.getString("CALL_DURATION"));
                } else {
                    wbo.add("---");
                }

//                if (row.getBigDecimal("duration") != null) {
//                    wbo.add(row.getBigDecimal("duration").toString());
//                }else {
//                    wbo.add("0");
//                }
                if (row.getString("Comment") == null || row.getString("Comment").equals("UL")) {
                    wbo.add("---");
                } else {
                    wbo.add(row.getString("Comment"));
                }

                if (row.getString("CLIENT_ID") != null) {
                    wbo.add(row.getString("CLIENT_ID"));
                } else {
                    wbo.add("---");
                }

                if (row.getString("CURRENT_STATUS") != null) {
                    wbo.add(row.getString("CURRENT_STATUS"));
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

    public ArrayList<ArrayList<String>> getUniqueUserAppointment(String departmentID, String userID, String total, String beginDate, String endDate) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = new Vector();
        String Query = null;

        parameters.addElement(new StringValue(departmentID));
        parameters.addElement(new StringValue(userID));
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            if (total.equals("All")) {
                Query = getQuery("getUniqueUserAppntmntAllClient").trim();
            } else if (total.equals("1")) {
                Query = getQuery("getUniqueUserAppntmntAllClientDi").trim();
            } else if (total.equals("2")) {
                Query = getQuery("getUniqueUserAppntmntAllClientIn").trim();
            } else if (total.equals("3")) {
                Query = getQuery("getUniqueUserAppntmntAllClientIm").trim();
            } else if (total.equals("Un")) {
                Query = getQuery("getUniqueUserAppntmntAllClientUn").trim();
            } else {
                parameters.addElement(new StringValue(userID));
                Query = getQuery("getUniqueUserAppntmnt").trim();
            }

            command.setSQLQuery(Query);
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        ArrayList<ArrayList<String>> data = new ArrayList<>();
        for (Row row : result) {
            try {
                ArrayList<String> wbo = new ArrayList<>();

                if (row.getString("NAME") != null) {
                    wbo.add(row.getString("NAME"));
                } else {
                    wbo.add("---");
                }

                if (row.getString("MOBILE") != null) {
                    wbo.add(row.getString("MOBILE"));
                } else {
                    wbo.add("---");
                }
                if (row.getString("PHONE") != null) {
                    wbo.add(row.getString("PHONE"));
                } else {
                    wbo.add("---");
                }

                if (row.getString("INTER_PHONE") != null) {
                    wbo.add(row.getString("INTER_PHONE"));
                } else {
                    wbo.add("---");
                }

                if (row.getString("ENGLISHNAME") != null) {
                    wbo.add(row.getString("ENGLISHNAME"));
                } else {
                    wbo.add("---");
                }

                if (row.getString("CAMPAIGN_TITLE") != null) {
                    wbo.add(row.getString("CAMPAIGN_TITLE"));
                } else {
                    wbo.add("---");
                }

                if (row.getTimestamp("CURRENT_STATUS_SINCE") != null) {
                    wbo.add(row.getTimestamp("CURRENT_STATUS_SINCE").toString().substring(0, 11));
                } else {
                    wbo.add("---");
                }

                if (row.getString("OPTION2") != null) {
                    wbo.add(row.getString("OPTION2"));
                } else {
                    wbo.add("---");
                }

                if (row.getString("Note") == null || row.getString("Note").equals("UL")) {
                    wbo.add("---");
                } else {
                    wbo.add(row.getString("Note"));
                }

                if (row.getString("Comment") == null || row.getString("Comment").equals("UL")) {
                    wbo.add("---");
                } else {
                    wbo.add(row.getString("Comment"));
                }

                if (row.getString("CALL_DURATION") != null) {
                    wbo.add(row.getString("CALL_DURATION"));
                } else {
                    wbo.add("---");
                }

                if (row.getString("USER_ID") == null) {
                    wbo.add("---");
                } else {
                    wbo.add(row.getString("USER_ID"));
                }

                if (row.getString("CLIENT_ID") != null) {
                    wbo.add(row.getString("CLIENT_ID"));
                } else {
                    wbo.add("---");
                }
                
                if (row.getString("CLIENT_NO") != null) {
                    wbo.add(row.getString("CLIENT_NO"));
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
    
    public ArrayList<ArrayList<String>> getUniqueUserAppointmentCustom(String departmentID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = new Vector();
        String Query = null;

        parameters.addElement(new StringValue(departmentID));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            Query = getQuery("getClientCostom").trim();
            command.setSQLQuery(Query);
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        ArrayList<ArrayList<String>> data = new ArrayList<>();
        for (Row row : result) {
            try {
                ArrayList<String> wbo = new ArrayList<>();

                if (row.getString("NAME") != null) {
                    wbo.add(row.getString("NAME"));
                } else {
                    wbo.add("---");
                }

                if (row.getString("MOBILE") != null) {
                    wbo.add(row.getString("MOBILE"));
                } else {
                    wbo.add("---");
                }
                if (row.getString("PHONE") != null) {
                    wbo.add(row.getString("PHONE"));
                } else {
                    wbo.add("---");
                }

                if (row.getString("INTER_PHONE") != null) {
                    wbo.add(row.getString("INTER_PHONE"));
                } else {
                    wbo.add("---");
                }

                if (row.getString("ENGLISHNAME") != null) {
                    wbo.add(row.getString("ENGLISHNAME"));
                } else {
                    wbo.add("---");
                }

                if (row.getString("CAMPAIGN_TITLE") != null) {
                    wbo.add(row.getString("CAMPAIGN_TITLE"));
                } else {
                    wbo.add("---");
                }

                if (row.getString("sys_id") != null) {
                    wbo.add(row.getString("sys_id"));
                } else {
                    wbo.add("---");
                }
                
                if (row.getString("CLIENT_NO") != null) {
                    wbo.add(row.getString("CLIENT_NO"));
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

    public ArrayList<ArrayList<String>> getUserApptmentForFialCall(String type, String from, String to, String departmentID, String userID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = new Vector();

        parameters.addElement(new StringValue(from));
        parameters.addElement(new StringValue(to));

        parameters.addElement(new StringValue(userID));

        StringBuilder departmentQuery = new StringBuilder();
        StringBuilder typeQuery = new StringBuilder();
        StringBuilder OptionQuery = new StringBuilder();

        if (departmentID != null && !departmentID.isEmpty()) {
            departmentQuery.append("AND APPOINTMENT_FOR IN (SELECT USER_ID FROM USERS WHERE USER_ID IN (SELECT EMP_ID FROM EMP_MGR WHERE MGR_ID IN");
            departmentQuery.append(" (SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID = '").append(departmentID);
            departmentQuery.append("')) UNION SELECT OPTION_ONE USER_ID FROM PROJECT WHERE PROJECT_ID = '").append(departmentID).append("')");
        }

        typeQuery.append("and OPTION2 like '%" + type + "%' ");

        if (type.equals("meeting")) {
            OptionQuery.append(" and OPTION9 in ('attended')");
        } else {
            OptionQuery.append(" and OPTION9 in ('not answered','wrong number')");
        }

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            String Query = getQuery("getUserClientsAppointmentsByStatus").replaceFirst("departmentQuery", departmentQuery.toString()).trim();
            Query = Query.replaceFirst("typeQuery", typeQuery.toString()).trim();
            Query = Query.replaceFirst("OptionType", OptionQuery.toString()).trim();
            command.setSQLQuery(Query);
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        ArrayList<ArrayList<String>> data = new ArrayList<>();
        for (Row row : result) {
            try {
                ArrayList<String> wbo = new ArrayList<>();

                if (row.getString("CLIENT_NAME") != null) {
                    wbo.add(row.getString("CLIENT_NAME"));
                } else {
                    wbo.add("---");
                }

                if (row.getString("MOBILE") != null) {
                    wbo.add(row.getString("MOBILE"));
                } else {
                    wbo.add("---");
                }
                if (row.getString("PHONE") != null) {
                    wbo.add(row.getString("PHONE"));
                } else {
                    wbo.add("---");
                }

                if (row.getTimestamp("CURRENT_STATUS_SINCE") != null) {
                    wbo.add(row.getTimestamp("CURRENT_STATUS_SINCE").toString().substring(0, 11));
                } else {
                    wbo.add("---");
                }

                if (row.getString("OPTION2") != null) {
                    wbo.add(row.getString("OPTION2"));
                } else {
                    wbo.add("---");
                }

                if (row.getString("OPTION9") == null || row.getString("OPTION9").equals("UL")) {
                    wbo.add("---");
                } else {
                    wbo.add(row.getString("OPTION9"));
                }

                if (row.getString("Note") == null || row.getString("Note").equals("UL")) {
                    wbo.add("---");
                } else {
                    wbo.add(row.getString("Note"));
                }

                if (row.getString("CALL_DURATION") != null) {
                    wbo.add(row.getString("CALL_DURATION"));
                } else {
                    wbo.add("---");
                }

//                if (row.getBigDecimal("duration") != null) {
//                    wbo.add(row.getBigDecimal("duration").toString());
//                }else {
//                    wbo.add("0");
//                }
                if (row.getString("Comment") == null || row.getString("Comment").equals("UL")) {
                    wbo.add("---");
                } else {
                    wbo.add(row.getString("Comment"));
                }

                if (row.getString("CLIENT_ID") != null) {
                    wbo.add(row.getString("CLIENT_ID"));
                } else {
                    wbo.add("---");
                }

                if (row.getString("CURRENT_STATUS") != null) {
                    wbo.add(row.getString("CURRENT_STATUS"));
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

    public ArrayList<ArrayList<String>> getFutureAppointmentByDateAndUserAndStatus(String type, String from, String to, String departmentID, String userID, String future) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = new Vector();

        parameters.addElement(new StringValue(from));
        parameters.addElement(new StringValue(to));

        parameters.addElement(new StringValue(from));
        parameters.addElement(new StringValue(to));

        parameters.addElement(new StringValue(userID));

        StringBuilder departmentQuery = new StringBuilder();
        StringBuilder typeQuery = new StringBuilder();
        StringBuilder OptionQuery = new StringBuilder();

        if (departmentID != null && !departmentID.isEmpty()) {
            departmentQuery.append("AND APPOINTMENT_FOR IN (SELECT USER_ID FROM USERS WHERE USER_ID IN (SELECT EMP_ID FROM EMP_MGR WHERE MGR_ID IN");
            departmentQuery.append(" (SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID = '").append(departmentID);
            departmentQuery.append("')) UNION SELECT OPTION_ONE USER_ID FROM PROJECT WHERE PROJECT_ID = '").append(departmentID).append("')");
        }

        typeQuery.append("and OPTION2 like '%" + type + "%' ");

        /*if(type.equals("meeting")){
            OptionQuery.append(" and OPTION9 is null");
        } else {
            OptionQuery.append(" and OPTION9 not in ('not answered','wrong number')");
        }*/
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            String Query = getQuery("getFutureUserClientsAppointmentsByStatus").replaceFirst("departmentQuery", departmentQuery.toString()).trim();
            Query = Query.replaceFirst("OptionType", OptionQuery.toString()).trim();
            Query = Query.replaceFirst("typeQuery", typeQuery.toString()).trim();
            command.setSQLQuery(Query);
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        ArrayList<ArrayList<String>> data = new ArrayList<>();
        for (Row row : result) {
            try {
                ArrayList<String> wbo = new ArrayList<>();

                if (row.getString("CLIENT_NAME") != null) {
                    wbo.add(row.getString("CLIENT_NAME"));
                } else {
                    wbo.add("---");
                }

                if (row.getString("MOBILE") != null) {
                    wbo.add(row.getString("MOBILE"));
                } else {
                    wbo.add("---");
                }
                if (row.getString("PHONE") != null && row.getString("PHONE") != "UL") {
                    wbo.add(row.getString("PHONE"));
                } else {
                    wbo.add("---");
                }

                if (row.getTimestamp("CREATION_TIME") != null) {
                    wbo.add(row.getTimestamp("CREATION_TIME").toString().substring(0, 11));
                } else {
                    wbo.add("---");
                }

                if (row.getString("APPOINTMENT_PLACE") != null) {
                    wbo.add(row.getString("APPOINTMENT_PLACE"));
                } else {
                    wbo.add("---");
                }
                if (future == null || future.isEmpty() || future == "") {
                    if (row.getString("OPTION9") == null || row.getString("OPTION9").equals("UL")) {
                        wbo.add("---");
                    } else {
                        wbo.add(row.getString("OPTION9"));
                    }
                }

                if (row.getString("Note") == null || row.getString("Note").equals("UL")) {
                    wbo.add("---");
                } else {
                    wbo.add(row.getString("Note"));
                }

                if (row.getTimestamp("APPOINTMENT_DATE") != null) {
                    wbo.add(row.getTimestamp("APPOINTMENT_DATE").toString().substring(0, 11));
                } else {
                    wbo.add("---");
                }

//                if (row.getBigDecimal("duration") != null) {
//                    wbo.add(row.getBigDecimal("duration").toString());
//                }else {
//                    wbo.add("0");
//                }
                if (row.getString("Comment") == null || row.getString("Comment").equals("UL")) {
                    wbo.add("---");
                } else {
                    wbo.add(row.getString("Comment"));
                }

                if (row.getString("CLIENT_ID") != null) {
                    wbo.add(row.getString("CLIENT_ID"));
                } else {
                    wbo.add("---");
                }

                if (row.getString("CURRENT_STATUS") != null) {
                    wbo.add(row.getString("CURRENT_STATUS"));
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

    public ArrayList<ArrayList<String>> getAppointmentByDateAndUser(String from, String to, String departmentID, String userID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = new Vector();

        //Appointment Creation Time
        parameters.addElement(new StringValue(from));
        parameters.addElement(new StringValue(to));

        parameters.addElement(new StringValue(userID));

        StringBuilder departmentQuery = new StringBuilder();
        if (departmentID != null && !departmentID.isEmpty()) {
            departmentQuery.append("AND APPOINTMENT_FOR IN (SELECT USER_ID FROM USERS WHERE USER_ID IN (SELECT EMP_ID FROM EMP_MGR WHERE MGR_ID IN");
            departmentQuery.append(" (SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID = '").append(departmentID);
            departmentQuery.append("')) UNION SELECT OPTION_ONE USER_ID FROM PROJECT WHERE PROJECT_ID = '").append(departmentID).append("')");
        }
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getUserClientsAppointments").replaceFirst("departmentQuery", departmentQuery.toString()).trim());
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        ArrayList<ArrayList<String>> data = new ArrayList<>();
        for (Row row : result) {
            try {
                ArrayList<String> wbo = new ArrayList<>();

                if (row.getString("CLIENT_NAME") != null) {
                    wbo.add(row.getString("CLIENT_NAME"));
                } else {
                    wbo.add("---");
                }
                if (row.getString("MOBILE") != null) {
                    wbo.add(row.getString("MOBILE"));
                } else {
                    wbo.add("---");
                }
                if (row.getString("PHONE") != null) {
                    wbo.add(row.getString("PHONE"));
                } else {
                    wbo.add("---");
                }

                if (row.getTimestamp("CREATION_TIME") != null) {
                    wbo.add(row.getTimestamp("CREATION_TIME").toString().substring(0, 11));
                } else {
                    wbo.add("---");
                }

                if (row.getString("APPOINTMENT_PLACE") != null) {
                    wbo.add(row.getString("APPOINTMENT_PLACE"));
                } else {
                    wbo.add("---");
                }

                if (row.getString("OPTION9") == null || row.getString("OPTION9").equals("UL")) {
                    wbo.add("---");
                } else {
                    wbo.add(row.getString("OPTION9"));
                }

                if (row.getString("Note") == null || row.getString("Note").equals("UL")) {
                    wbo.add("---");
                } else {
                    wbo.add(row.getString("Note"));
                }

                if (row.getString("CALL_DURATION") != null) {
                    wbo.add(row.getString("CALL_DURATION"));
                } else {
                    wbo.add("---");
                }

//                if (row.getBigDecimal("duration") != null) {
//                    wbo.add(row.getBigDecimal("duration").toString());
//                }else {
//                    wbo.add("0");
//                }
                if (row.getString("Comment") == null || row.getString("Comment").equals("UL")) {
                    wbo.add("---");
                } else {
                    wbo.add(row.getString("Comment"));
                }

                if (row.getString("CLIENT_ID") != null) {
                    wbo.add(row.getString("CLIENT_ID"));
                } else {
                    wbo.add("---");
                }

                if (row.getString("CURRENT_STATUS") != null) {
                    wbo.add(row.getString("CURRENT_STATUS"));
                } else {
                    wbo.add("---");
                }

                if (row.getString("ID") != null) {
                    wbo.add(row.getString("ID"));
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

    public ArrayList<ArrayList<String>> getFutureAppointmentByDateAndUser(String from, String to, String departmentID, String userID, String future) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = new Vector();

        //Appointment Creation Time
        parameters.addElement(new StringValue(from));
        parameters.addElement(new StringValue(to));

        //Appointment Time
        parameters.addElement(new StringValue(from));
        parameters.addElement(new StringValue(to));

        parameters.addElement(new StringValue(userID));

        StringBuilder departmentQuery = new StringBuilder();
        if (departmentID != null && !departmentID.isEmpty()) {
            departmentQuery.append("AND APPOINTMENT_FOR IN (SELECT USER_ID FROM USERS WHERE USER_ID IN (SELECT EMP_ID FROM EMP_MGR WHERE MGR_ID IN");
            departmentQuery.append(" (SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID = '").append(departmentID);
            departmentQuery.append("')) UNION SELECT OPTION_ONE USER_ID FROM PROJECT WHERE PROJECT_ID = '").append(departmentID).append("')");
        }
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getFutureUserClientsAppointments").replaceFirst("departmentQuery", departmentQuery.toString()).trim());
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        ArrayList<ArrayList<String>> data = new ArrayList<>();
        for (Row row : result) {
            try {
                ArrayList<String> wbo = new ArrayList<>();

                if (row.getString("CLIENT_NAME") != null) {
                    wbo.add(row.getString("CLIENT_NAME"));
                } else {
                    wbo.add("---");
                }

                if (row.getString("MOBILE") != null) {
                    wbo.add(row.getString("MOBILE"));
                } else {
                    wbo.add("---");
                }
                if (row.getString("PHONE") != null && !row.getString("PHONE").equalsIgnoreCase("UL")) {
                    wbo.add(row.getString("PHONE"));
                } else {
                    wbo.add("---");
                }

                if (row.getTimestamp("CREATION_TIME") != null) {
                    wbo.add(row.getTimestamp("CREATION_TIME").toString().substring(0, 11));
                } else {
                    wbo.add("---");
                }

                if (row.getString("APPOINTMENT_PLACE") != null) {
                    wbo.add(row.getString("APPOINTMENT_PLACE"));
                } else {
                    wbo.add("---");
                }
                if (future == null || future.isEmpty() || future == "") {
                    if (row.getString("OPTION9") == null || row.getString("OPTION9").equals("UL")) {
                        wbo.add("---");
                    } else {
                        wbo.add(row.getString("OPTION9"));
                    }
                }

                if (row.getString("Note") == null || row.getString("Note").equals("UL")) {
                    wbo.add("---");
                } else {
                    wbo.add(row.getString("Note"));
                }

                if (row.getTimestamp("APPOINTMENT_DATE") != null) {
                    wbo.add(row.getTimestamp("APPOINTMENT_DATE").toString().substring(0, 11));
                } else {
                    wbo.add("---");
                }

//                if (row.getBigDecimal("duration") != null) {
//                    wbo.add(row.getBigDecimal("duration").toString());
//                }else {
//                    wbo.add("0");
//                }
                if (row.getString("Comment") == null || row.getString("Comment").equals("UL")) {
                    wbo.add("---");
                } else {
                    wbo.add(row.getString("Comment"));
                }

                if (row.getString("CLIENT_ID") != null) {
                    wbo.add(row.getString("CLIENT_ID"));
                } else {
                    wbo.add("---");
                }

                if (row.getString("CURRENT_STATUS") != null) {
                    wbo.add(row.getString("CURRENT_STATUS"));
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

    public ArrayList<WebBusinessObject> getFutureAppointmentByUserExcel(Date from, Date to, String userID, String future) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = new Vector();

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        Calendar c = Calendar.getInstance();
        c.setTime(new Date()); // Now use today date.
        c.add(Calendar.DATE, -1);
        Date yesterday = c.getTime();
        c.setTime(new Date()); // Now use today date.
        c.add(Calendar.DATE, 1);
        Date tomorrow = c.getTime();

        if (from == null) {
            parameters.addElement(new DateValue(new java.sql.Date(tomorrow.getTime())));
        } else {
            parameters.addElement(new DateValue(new java.sql.Date(from.getTime())));
        }
        if (to == null) {
            parameters.addElement(new DateValue(new java.sql.Date(yesterday.getTime())));
        } else {
            parameters.addElement(new DateValue(new java.sql.Date(to.getTime())));
        }
        parameters.addElement(new StringValue(userID));

        StringBuilder departmentQuery = new StringBuilder();
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getFutureAppointmentByUserExcel").trim());
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        ArrayList<WebBusinessObject> data = new ArrayList<>();
        for (Row row : result) {
            try {
                WebBusinessObject wbo = new WebBusinessObject();

                if (row.getString("CLIENT_NAME") != null) {
                    wbo.setAttribute("clientName", row.getString("CLIENT_NAME"));
                } else {
                    wbo.setAttribute("clientName", "---");
                }

                if (row.getString("MOBILE") != null) {
                    wbo.setAttribute("mobile", row.getString("MOBILE"));
                } else {
                    wbo.setAttribute("mobile", "---");
                }
                if (row.getString("PHONE") != null && !row.getString("PHONE").equalsIgnoreCase("UL")) {
                    wbo.setAttribute("interTel", row.getString("PHONE"));
                } else {
                    wbo.setAttribute("interTel", "---");
                }

                if (row.getTimestamp("CREATION_TIME") != null) {
                    wbo.setAttribute("creationTime", row.getTimestamp("CREATION_TIME").toString().substring(0, 11));
                } else {
                    wbo.setAttribute("creationTime", "---");
                }

                if (row.getString("APPOINTMENT_PLACE") != null) {
                    wbo.setAttribute("appointmentPlace", row.getString("APPOINTMENT_PLACE"));
                } else {
                    wbo.setAttribute("appointmentPlace", "---");
                }
                if (future == null || future.isEmpty() || future == "") {
                    if (row.getString("OPTION9") == null || row.getString("OPTION9").equals("UL")) {
                        wbo.setAttribute("option9", "---");
                    } else {
                        wbo.setAttribute("option9", row.getString("OPTION9"));
                    }
                }

                if (row.getString("Note") == null || row.getString("Note").equals("UL")) {
                    wbo.setAttribute("note", "---");
                } else {
                    wbo.setAttribute("note", row.getString("Note"));
                }

                if (row.getTimestamp("APPOINTMENT_DATE") != null) {
                    wbo.setAttribute("appointmentDate", row.getTimestamp("APPOINTMENT_DATE").toString().substring(0, 11));
                } else {
                    wbo.setAttribute("appointmentDate", "---");
                }

                if (row.getBigDecimal("duration") != null) {
                    wbo.setAttribute("duration", row.getBigDecimal("duration").toString());
                } else {
                    wbo.setAttribute("duration", "0");
                }

                if (row.getString("Comment") == null || row.getString("Comment").equals("UL")) {
                    wbo.setAttribute("comment", "---");
                } else {
                    wbo.setAttribute("comment", row.getString("Comment"));
                }

                if (row.getString("CLIENT_ID") != null) {
                    wbo.setAttribute("clientId", row.getString("CLIENT_ID"));
                } else {
                    wbo.setAttribute("clientId", "---");
                }
                if (row.getString("appTyp") != null) {
                    wbo.setAttribute("appTyp", row.getString("appTyp"));
                } else {
                    wbo.setAttribute("appTyp", "---");
                }

                data.add(wbo);
            } catch (Exception ex) {
                logger.error(ex);
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getFutureAppointmentsExcel(Date from, Date to, String departmentID, String future) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = new Vector();

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        Calendar c = Calendar.getInstance();
        c.setTime(new Date()); // Now use today date.
        c.add(Calendar.DATE, -1);
        Date yesterday = c.getTime();
        c.setTime(new Date()); // Now use today date.
        c.add(Calendar.DATE, 1);
        Date tomorrow = c.getTime();

        if (from == null) {
            parameters.addElement(new DateValue(new java.sql.Date(tomorrow.getTime())));
        } else {
            parameters.addElement(new DateValue(new java.sql.Date(from.getTime())));
        }
        if (to == null) {
            parameters.addElement(new DateValue(new java.sql.Date(yesterday.getTime())));
        } else {
            parameters.addElement(new DateValue(new java.sql.Date(to.getTime())));
        }

        StringBuilder departmentQuery = new StringBuilder();
        if (departmentID != null && !departmentID.isEmpty()) {
            departmentQuery.append("AND APPOINTMENT_FOR IN (SELECT USER_ID FROM USERS WHERE USER_ID IN (SELECT EMP_ID FROM EMP_MGR WHERE MGR_ID IN");
            departmentQuery.append(" (SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID = '").append(departmentID);
            departmentQuery.append("')) UNION SELECT OPTION_ONE USER_ID FROM PROJECT WHERE PROJECT_ID = '").append(departmentID).append("')");
        }
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getFutureAppointmentsExcel").replaceFirst("departmentQuery", departmentQuery.toString()).trim());
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        ArrayList<WebBusinessObject> data = new ArrayList<>();
        for (Row row : result) {
            try {
                WebBusinessObject wbo = new WebBusinessObject();

                if (row.getString("CLIENT_NAME") != null) {
                    wbo.setAttribute("clientName", row.getString("CLIENT_NAME"));
                } else {
                    wbo.setAttribute("clientName", "---");
                }

                if (row.getString("MOBILE") != null) {
                    wbo.setAttribute("mobile", row.getString("MOBILE"));
                } else {
                    wbo.setAttribute("mobile", "---");
                }
                if (row.getString("PHONE") != null && !row.getString("PHONE").equalsIgnoreCase("UL")) {
                    wbo.setAttribute("interTel", row.getString("PHONE"));
                } else {
                    wbo.setAttribute("interTel", "---");
                }

                if (row.getTimestamp("CREATION_TIME") != null) {
                    wbo.setAttribute("creationTime", row.getTimestamp("CREATION_TIME").toString().substring(0, 11));
                } else {
                    wbo.setAttribute("creationTime", "---");
                }

                if (row.getString("APPOINTMENT_PLACE") != null) {
                    wbo.setAttribute("appointmentPlace", row.getString("APPOINTMENT_PLACE"));
                } else {
                    wbo.setAttribute("appointmentPlace", "---");
                }
                if (future == null || future.isEmpty() || future == "") {
                    if (row.getString("OPTION9") == null || row.getString("OPTION9").equals("UL")) {
                        wbo.setAttribute("option9", "---");
                    } else {
                        wbo.setAttribute("option9", row.getString("OPTION9"));
                    }
                }

                if (row.getString("Note") == null || row.getString("Note").equals("UL")) {
                    wbo.setAttribute("note", "---");
                } else {
                    wbo.setAttribute("note", row.getString("Note"));
                }

                if (row.getTimestamp("APPOINTMENT_DATE") != null) {
                    wbo.setAttribute("appointmentDate", row.getTimestamp("APPOINTMENT_DATE").toString().substring(0, 11));
                } else {
                    wbo.setAttribute("appointmentDate", "---");
                }

                if (row.getBigDecimal("duration") != null) {
                    wbo.setAttribute("duration", row.getBigDecimal("duration").toString());
                } else {
                    wbo.setAttribute("duration", "0");
                }

                if (row.getString("Comment") == null || row.getString("Comment").equals("UL")) {
                    wbo.setAttribute("comment", "---");
                } else {
                    wbo.setAttribute("comment", row.getString("Comment"));
                }

                if (row.getString("CLIENT_ID") != null) {
                    wbo.setAttribute("clientId", row.getString("CLIENT_ID"));
                } else {
                    wbo.setAttribute("clientId", "---");
                }
                if (row.getString("appTyp") != null) {
                    wbo.setAttribute("appTyp", row.getString("appTyp"));
                } else {
                    wbo.setAttribute("appTyp", "---");
                }
                if (row.getString("USER_NAME") != null) {
                    wbo.setAttribute("userName", row.getString("USER_NAME"));
                } else {
                    wbo.setAttribute("userName", "---");
                }

                data.add(wbo);
            } catch (Exception ex) {
                logger.error(ex);
            }
        }
        return data;
    }

    public List<WebBusinessObject> getAppointmentByDateAndUser(Date from, Date to, String userID, String type) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = new Vector();

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        Calendar c = Calendar.getInstance();
        c.setTime(new Date()); // Now use today date.
        c.add(Calendar.DATE, -1);
        Date yesterday = c.getTime();
        c.setTime(new Date()); // Now use today date.
        c.add(Calendar.DATE, 1);
        Date tomorrow = c.getTime();
        List<WebBusinessObject> data;
        if (from == null) {
            parameters.addElement(new DateValue(new java.sql.Date(tomorrow.getTime())));
        } else {
            parameters.addElement(new DateValue(new java.sql.Date(from.getTime())));
        }
        if (to == null) {
            parameters.addElement(new DateValue(new java.sql.Date(yesterday.getTime())));
        } else {
            parameters.addElement(new DateValue(new java.sql.Date(to.getTime())));
        }

        parameters.addElement(new StringValue(userID));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getAppointmentByDateAndUser").replaceAll("typeTitle", type).trim());
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        WebBusinessObject wbo;
        data = new ArrayList<WebBusinessObject>();

        for (Row row : result) {
            try {
                wbo = fabricateBusObj(row);
                wbo.setAttribute("dayNo", row.getString("DAY_NO"));
                data.add(wbo);
            } catch (NoSuchColumnException ex) {
                logger.error(ex);
            }
        }
        return data;
    }

    public List<WebBusinessObject> getMeetingsByDateAndUser(Date from, Date to, String userID, String type) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = new Vector();
        List<WebBusinessObject> data;
        parameters.addElement(new DateValue(new java.sql.Date(from.getTime())));
        parameters.addElement(new DateValue(new java.sql.Date(to.getTime())));
        parameters.addElement(new StringValue(userID));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getMeetingsByDateAndUser").replaceAll("typeTitle", type).trim());
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        WebBusinessObject wbo;
        data = new ArrayList<WebBusinessObject>();

        for (Row row : result) {
            try {
                wbo = fabricateBusObj(row);
                wbo.setAttribute("dayNo", row.getString("DAY_NO"));
                data.add(wbo);
            } catch (NoSuchColumnException ex) {
                logger.error(ex);
            }
        }
        return data;
    }

    public List<WebBusinessObject> getCallsByDateAndUser(Date from, Date to, String userID, String type) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = new Vector();
        List<WebBusinessObject> data;
        parameters.addElement(new DateValue(new java.sql.Date(from.getTime())));
        parameters.addElement(new DateValue(new java.sql.Date(to.getTime())));
        parameters.addElement(new StringValue(userID));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getCallsByDateAndUser").replaceAll("typeTitle", type).trim());
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        WebBusinessObject wbo;
        data = new ArrayList<WebBusinessObject>();

        for (Row row : result) {
            try {
                wbo = fabricateBusObj(row);
                wbo.setAttribute("dayNo", row.getString("DAY_NO"));
                data.add(wbo);
            } catch (NoSuchColumnException ex) {
                logger.error(ex);
            }
        }
        return data;
    }

    public List<WebBusinessObject> getUserOwnedAppointmentsByDate(String userId, String date) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector result = new Vector();
        List<WebBusinessObject> data;

        parameters.addElement(new StringValue(userId));
        parameters.addElement(new StringValue(date));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getUserOwnedAppointmentsByDate").trim());
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        Row row;
        Enumeration e = result.elements();
        data = new ArrayList<WebBusinessObject>();

        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            data.add(fabricateBusObj(row));
        }
        return data;
    }

    public List<WebBusinessObject> getVisitCountsByDate(Date from, Date to, String departmentID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = new Vector();
        List<WebBusinessObject> data;

        Calendar calendar = Calendar.getInstance();
        calendar.setTime(to);
        calendar.set(Calendar.HOUR, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        calendar.add(Calendar.DATE, 1);
        parameters.addElement(new DateValue(new java.sql.Date(from.getTime())));
        parameters.addElement(new DateValue(new java.sql.Date(calendar.getTimeInMillis())));

        StringBuilder departmentQuery = new StringBuilder();
        if (departmentID != null && !departmentID.isEmpty()) {
            departmentQuery.append("AND APPOINTMENT_FOR IN (SELECT USER_ID FROM USERS WHERE USER_ID IN (SELECT EMP_ID FROM EMP_MGR WHERE MGR_ID IN");
            departmentQuery.append(" (SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID = '").append(departmentID);
            departmentQuery.append("')) UNION SELECT OPTION_ONE USER_ID FROM PROJECT WHERE PROJECT_ID = '").append(departmentID).append("')");
        }
        StringBuilder query = new StringBuilder("SELECT CLIENT_ID, CLIENT_NAME, USER_NAME, APPOINTMENT_FOR_NAME, APPOINTMENT_DATE, APPOINTMENT_FOR, DAY_NO, COUNT(DAY_NO) VISIT_COUNT FROM (");
        query.append(getQuery("getAppointmentByDate").replaceFirst("departmentQuery", departmentQuery.toString()).trim());
        query.append(") where TITLE = 'Job Order' group by CLIENT_ID, CLIENT_NAME, USER_NAME, APPOINTMENT_FOR_NAME, APPOINTMENT_DATE, APPOINTMENT_FOR, DAY_NO");
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.toString());
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        WebBusinessObject wbo;
        data = new ArrayList<WebBusinessObject>();

        for (Row row : result) {
            try {
                wbo = fabricateBusObj(row);
                wbo.setAttribute("dayNo", row.getString("DAY_NO"));
                wbo.setAttribute("visitCount", row.getString("VISIT_COUNT"));
                data.add(wbo);
            } catch (NoSuchColumnException ex) {
                logger.error(ex);
            }
        }
        return data;
    }

    public int getVisitsCountsForWorkerByDate(Date inDate, String userID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = new Vector();

        parameters.addElement(new StringValue(userID));
        parameters.addElement(new DateValue(new java.sql.Date(inDate.getTime())));

        String query = getQuery("getVisitsCountsForWorkerByDate").trim();
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query);
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }
        for (Row row : result) {
            try {
                if (row.getString("VISIT_COUNT") != null) {
                    return Integer.parseInt(row.getString("VISIT_COUNT"));
                }
            } catch (NoSuchColumnException ex) {
                logger.error(ex);
            }
        }
        return 0;
    }

    public ArrayList<WebBusinessObject> getSuccessAppointmentsByDate(Timestamp fromDate, Timestamp toDate, String userID, String campaignID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector parameters = new Vector();
        String query = getQuery("getSuccessAppointmentsByDate").trim();
        parameters.addElement(new TimestampValue(fromDate));
        parameters.addElement(new TimestampValue(toDate));
        if (userID != null && !userID.isEmpty()) {
            query += " AND AN.APPOINTMENT_FOR = ?";
            parameters.addElement(new StringValue(userID));
        }
        if (campaignID != null && !campaignID.isEmpty()) {
            query += " AND CL.SYS_ID IN (SELECT CLIENT_ID FROM CLIENT_CAMPAIGN WHERE CAMPAIGN_ID IN ('" + campaignID + "'))";
        }
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query);
            command.setparams(parameters);
            result = command.executeQuery();

            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                try {
                    if (row.getString("MOBILE") != null) {
                        wbo.setAttribute("mobile", row.getString("MOBILE"));
                    } else {
                        wbo.setAttribute("mobile", "");
                    }

                    if (row.getString("INTER_PHONE") != null) {
                        wbo.setAttribute("interPhone", row.getString("INTER_PHONE"));
                    } else {
                        wbo.setAttribute("interPhone", "");
                    }

                    if (row.getString("RECEIVE_DATE") != null) {
                        wbo.setAttribute("reciveDate", row.getString("RECEIVE_DATE"));
                    } else {
                        wbo.setAttribute("reciveDate", "");
                    }//

                    if (row.getString("COMCHANNEL") != null) {
                        wbo.setAttribute("comChannel", row.getString("COMCHANNEL"));
                    } else {
                        wbo.setAttribute("comChannel", "");
                    }
                    wbo.setAttribute("createdByName", row.getString("CREATED_BY_NAME") != null ? row.getString("CREATED_BY_NAME") : "");
                    wbo.setAttribute("statusName", row.getString("STATUS_NAME") != null ? row.getString("STATUS_NAME") : "");
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;
        } catch (UnsupportedTypeException | SQLException ex) {
            Logger.getLogger(this.getClass().getName()).log(Level.SEVERE, null, ex);
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

    public WebBusinessObject getAppointmentStatistic(String beginDate, String endDate, String usrID, String rprtType) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;

        Vector parameters = new Vector();

        if (rprtType != null) {
            if (rprtType.equals("myReport")) {
                parameters.addElement(new StringValue(usrID));
            }
        }

        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);

            if (rprtType != null) {
                if (rprtType.equals("myReport")) {
                    forQuery.setSQLQuery(getQuery("getMyAppointmentsStat").trim());
                }
            } else {
                forQuery.setSQLQuery(getQuery("getAppointmentsStat").trim());
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
                    if (r.getString("CARED") != null) {
                        wbo.setAttribute("cared", r.getString("CARED"));
                    } else {
                        wbo.setAttribute("cared", "---");
                    }

                    if (r.getString("NOT_CARED") != null) {
                        wbo.setAttribute("notCared", r.getString("NOT_CARED"));
                    } else {
                        wbo.setAttribute("notCared", "---");
                    }

                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                return wbo;
            }
        }
        return null;
    }

    public ArrayList<WebBusinessObject> getApntmnStatisticTotal(String beginDate, String endDate, String usrID, String rprtType) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;

        Vector parameters = new Vector();

        if (rprtType != null) {
            if (rprtType.equals("myReport")) {
                parameters.addElement(new StringValue(usrID));
            }
        }
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);

            if (rprtType != null) {
                if (rprtType.equals("myReport")) {
                    forQuery.setSQLQuery(getQuery("getMyAppointmentTotalStat").trim());
                }
            } else {
                forQuery.setSQLQuery(getQuery("getAppointmentTotalStat").trim());
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
                    if (r.getBigDecimal("Sccuess") != null) {
                        wbo.setAttribute("Sccuess", r.getBigDecimal("Sccuess"));
                    }

                    if (r.getBigDecimal("Fail") != null) {
                        wbo.setAttribute("Fail", r.getBigDecimal("Fail"));
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

    public List<WebBusinessObject> getAppointmentsByDepartmentOrdered(String appointmentType, String departmentID, java.sql.Date fromDate, java.sql.Date toDate) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result = new Vector();
        Vector parameters = new Vector();
        List<WebBusinessObject> data;

        parameters.addElement(new StringValue(appointmentType));
        parameters.addElement(new StringValue(departmentID));
        parameters.addElement(new DateValue(fromDate));
        parameters.addElement(new DateValue(toDate));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(getQuery("getAppointmentsByDepartmentOrdered").trim());
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        data = new ArrayList<WebBusinessObject>();
        for (Row row : result) {
            data.add(fabricateBusObj(row));
        }
        return data;
    }

    public List<WebBusinessObject> getFutureAppointments(String clientID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result = new Vector();
        Vector parameters = new Vector();
        List<WebBusinessObject> data;

        parameters.addElement(new StringValue(clientID));

        Calendar calendar = Calendar.getInstance();
        parameters.addElement(new DateValue(new java.sql.Date(calendar.getTimeInMillis())));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(getQuery("getFutureAppointments").trim());
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        data = new ArrayList<WebBusinessObject>();
        for (Row row : result) {
            data.add(fabricateBusObj(row));
        }
        return data;
    }

    public List<WebBusinessObject> lstEmpAppCmnt(String userID, String fromDate, String toDate) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = new Vector();
        List<WebBusinessObject> data;

        parameters.addElement(new StringValue(userID));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("lstEmpAppCmnt").replaceAll("frmDateStr", fromDate).replaceAll("tDateStr", toDate).trim());
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        WebBusinessObject wbo;
        data = new ArrayList<WebBusinessObject>();

        for (Row row : result) {
            try {
                wbo = fabricateBusObj(row);
                wbo.setAttribute("clientNo", row.getString("CLIENT_NO"));
                wbo.setAttribute("dayNo", row.getString("DAY_NO"));
                data.add(wbo);
            } catch (NoSuchColumnException ex) {
                logger.error(ex);
            }
        }
        return data;
    }

    public List<WebBusinessObject> getMyAppointmentByDate(Date from, Date to, String userID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = new Vector();
        List<WebBusinessObject> data;
        parameters.addElement(new DateValue(new java.sql.Date(from.getTime())));
        parameters.addElement(new DateValue(new java.sql.Date(to.getTime())));
        parameters.addElement(new StringValue(userID));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getMyAppointmentByDate").trim());
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }
        WebBusinessObject wbo;
        data = new ArrayList<>();
        for (Row row : result) {
            try {
                wbo = fabricateBusObj(row);
                wbo.setAttribute("dayNo", row.getString("DAY_NO"));
                data.add(wbo);
            } catch (NoSuchColumnException ex) {
                logger.error(ex);
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getSuccessAppointmentsCampaignStat(Timestamp fromDate, Timestamp toDate, String campaignID) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector parameters = new Vector();
        String query = getQuery("getSuccessAppointmentsCampaignStat").trim();
        parameters.addElement(new TimestampValue(fromDate));
        parameters.addElement(new TimestampValue(toDate));
        StringBuilder where = new StringBuilder();
        if (campaignID != null && !campaignID.isEmpty()) {
            where.append(" AND CL.SYS_ID IN (SELECT CLIENT_ID FROM CLIENT_CAMPAIGN WHERE CAMPAIGN_ID IN ('")
                    .append(campaignID).append("'))");
        }
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.replace("whereStatement", where.toString()));
            command.setparams(parameters);
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                try {
                    wbo.setAttribute("totalClient", row.getString("TOTAL_CLIENT") != null ? row.getString("TOTAL_CLIENT") : "");
                    wbo.setAttribute("campaignTitle", row.getString("CAMPAIGN_TITLE") != null ? row.getString("CAMPAIGN_TITLE") : "");
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;
        } catch (UnsupportedTypeException | SQLException ex) {
            Logger.getLogger(this.getClass().getName()).log(Level.SEVERE, null, ex);
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

    public List<WebBusinessObject> getFutureAppointmentForUser(String userId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector result = new Vector();
        List<WebBusinessObject> data;

        parameters.addElement(new StringValue(userId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getFutureAppointmentsForUser"));
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        Row row;
        Enumeration e = result.elements();
        data = new ArrayList<WebBusinessObject>();

        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            data.add(fabricateBusObj(row));
        }
        return data;
    }
    
     public List<WebBusinessObject> getPastAppointmentsForUser(String userId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector result = new Vector();
        List<WebBusinessObject> data;

        parameters.addElement(new StringValue(userId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getPastAppointmentsForUser"));
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        Row row;
        Enumeration e = result.elements();
        data = new ArrayList<WebBusinessObject>();

        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            data.add(fabricateBusObj(row));
        }
        return data;
    }
     
      public List<WebBusinessObject> getTodayAppointmentsForUser(String userId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector result = new Vector();
        List<WebBusinessObject> data;

        parameters.addElement(new StringValue(userId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getTodayAppointmentsForUser"));
            command.setparams(parameters);
            result = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }

        Row row;
        Enumeration e = result.elements();
        data = new ArrayList<WebBusinessObject>();

        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            data.add(fabricateBusObj(row));
        }
        return data;
    }
}
