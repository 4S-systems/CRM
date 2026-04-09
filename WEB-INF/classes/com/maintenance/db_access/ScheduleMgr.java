package com.maintenance.db_access;

import com.contractor.db_access.MaintainableMgr;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.util.*;
import com.tracker.db_access.IssueMgr;

import java.util.*;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.swing.JOptionPane;
import org.apache.log4j.xml.DOMConfigurator;

public class ScheduleMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    UserTradeMgr userTradeMgr = UserTradeMgr.getInstance();
    ConfigureMainTypeMgr scheduleConfigMgr = ConfigureMainTypeMgr.getInstance();
    ScheduleTasksMgr scheduleTasksMgr = ScheduleTasksMgr.getInstance();
    DateAndTimeControl dateAndTime = new DateAndTimeControl();
    UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
    IssueMgr issueMgr = IssueMgr.getInstance();
    private static ScheduleMgr schedualMgr = new ScheduleMgr();
    public static Vector sheduleConfig = new Vector();
    public static Vector scheduleTasks = new Vector();
    private static final String getUnEmgScheduleSQL = "SELECT * FROM schedule WHERE ID != 1 ";

    public ScheduleMgr() {
    }

    public static ScheduleMgr getInstance() {
        logger.info("Getting ScheduleMgr Instance ....");
        return schedualMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("schedule.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    public String getMianType(String mainId){
        Vector param = new Vector();
        param.addElement(new StringValue(mainId));
        Vector resultQuery = null;
        SQLCommandBean sqlQuery = new SQLCommandBean();
        try{
            beginTransaction();
            sqlQuery.setConnection(transConnection);
            sqlQuery.setSQLQuery(getQuery("mainCategoryType").trim());
            sqlQuery.setparams(param);
            resultQuery =sqlQuery.executeQuery();
            endTransaction();
        }catch(Exception e){
            logger.error("Error in execute Query");
        }
        String type = null;
        try {
            type = ((Row) resultQuery.get(0)).getString("BASIC_COUNTER");
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(ScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        return type;
    }
    public String getCatType(String mainId){
        Vector param = new Vector();
        param.addElement(new StringValue(mainId));
        Vector resultQuery = null;
        SQLCommandBean sqlQuery = new SQLCommandBean();
        try{
            beginTransaction();
            sqlQuery.setConnection(transConnection);
            sqlQuery.setSQLQuery(getQuery("categoryType").trim());
            sqlQuery.setparams(param);
            resultQuery =sqlQuery.executeQuery();
            endTransaction();
        }catch(Exception e){
            logger.error("Error in execute Query");
        }
        String type = null;
        try {
            type = ((Row) resultQuery.get(0)).getString("BASIC_COUNTER");
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(ScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        return type;
    }
    public String geteqpType(String mainId){
        Vector param = new Vector();
        param.addElement(new StringValue(mainId));
        Vector resultQuery = null;
        SQLCommandBean sqlQuery = new SQLCommandBean();
        try{
            beginTransaction();
            sqlQuery.setConnection(transConnection);
            sqlQuery.setSQLQuery(getQuery("equiptype").trim());
            sqlQuery.setparams(param);
            resultQuery =sqlQuery.executeQuery();
            endTransaction();
        }catch(Exception e){
            logger.error("Error in execute Query");
        }
        String type = null;
        try {
            type = ((Row) resultQuery.get(0)).getString("BASIC_COUNTER");
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(ScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        return type;
    }
    public String saveEquipSchedule(WebBusinessObject schedule, HttpSession s, String source) throws SQLException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String scheduleID = new String("");

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Connection connection = null;
        try {
            Vector userTrades = userTradeMgr.getOnArbitraryDoubleKey((String) waUser.getAttribute("userId"), "key1", (String) schedule.getAttribute("trade"), "key2");
            WebBusinessObject wbo = (WebBusinessObject) userTrades.elementAt(0);

            scheduleID = UniqueIDGen.getNextID();
            params.addElement(new StringValue(scheduleID));
            params.addElement(new StringValue((String) schedule.getAttribute("scheduleTitle")));
            params.addElement(new StringValue((String) schedule.getAttribute("scheduleDesc")));
            params.addElement(new IntValue(new Integer(schedule.getAttribute("frequency").toString())));
            params.addElement(new IntValue(new Integer(schedule.getAttribute("frequencyType").toString())));
            params.addElement(new IntValue(new Integer(schedule.getAttribute("duration").toString())));
            params.addElement(new StringValue((String) schedule.getAttribute("equipID")));
            //params.addElement(new StringValue((String) schedule.getAttribute("eqpCatID")));
            params.addElement(new StringValue((String) schedule.getAttribute("trade")));
            params.addElement(new StringValue((String) waUser.getAttribute("id")));
            params.addElement(new StringValue((String) wbo.getAttribute("Id")));
            params.addElement(new IntValue(new Integer(schedule.getAttribute("frequencyReal").toString())));

            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            if (source.equalsIgnoreCase("Km")) {
                forInsert.setSQLQuery(sqlMgr.getSql("insertEquipScheduleKm").trim());
            } else {
                forInsert.setSQLQuery(sqlMgr.getSql("insertEquipSchedule").trim());
            }
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return null;
        } catch (Exception ex) {
            logger.error("General Schedule Saving Exception " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return null;
            }
        }

        if (queryResult > 0) {
            return scheduleID;
        } else {
            return null;
        }
    }

    public boolean checkMainTypeTables(String tableName, String id) {
        Vector params = new Vector();
        Vector returned_Codes = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Connection connection = null;
        try {
            params.addElement(new StringValue(tableName));
            params.addElement(new StringValue(id));
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);

            //3shn ageb el customer id mn el ticket id
            forInsert.setSQLQuery(sqlMgr.getSql("AvailabilityOfMainTypeTables").trim());
            forInsert.setparams(params);
            returned_Codes = forInsert.executeQuery();

        } catch (Exception se) {
            logger.error(se.getMessage());
            JOptionPane.showMessageDialog(null, se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }
        if (returned_Codes.size() <= 0) {
            return true;
        }

        return false;
    }

    public boolean checkEquipTables(String tableName, String id) {
        Vector params = new Vector();
        Vector returned_Codes = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Connection connection = null;
        try {
            params.addElement(new StringValue(tableName));
            params.addElement(new StringValue(id));
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);

            //3shn ageb el customer id mn el ticket id
            forInsert.setSQLQuery(sqlMgr.getSql("AvailabilityOfEquipTables").trim());
            forInsert.setparams(params);
            returned_Codes = forInsert.executeQuery();

        } catch (Exception se) {
            logger.error(se.getMessage());
            JOptionPane.showMessageDialog(null, se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }
        if (returned_Codes.size() <= 0) {
            return true;
        }

        return false;
    }

    public Vector getAllReleatedTables(String id) {
        Vector params = new Vector();
        Vector returned_Codes = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Connection connection = null;
        try {
            params.addElement(new StringValue(id));
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);

            //3shn ageb el customer id mn el ticket id
            forInsert.setSQLQuery(sqlMgr.getSql("getReleatedSchedule").trim());
            forInsert.setparams(params);
            returned_Codes = forInsert.executeQuery();

        } catch (Exception se) {
            logger.error(se.getMessage());
            JOptionPane.showMessageDialog(null, se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resAsWeb = new Vector();
        Row row;
        WebBusinessObject wbo;

        for (int i = 0; i < returned_Codes.size(); i++) {
            row = (Row) returned_Codes.get(i);
            wbo = super.fabricateBusObj(row);
            resAsWeb.add(wbo);
        }

        return resAsWeb;
    }

    public Vector getMainTypeTablesByUnitID(String uniId) {
        Vector params = new Vector();
        Vector returned_Codes = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Connection connection = null;
        try {
            params.addElement(new StringValue(uniId));
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);

            //3shn ageb el customer id mn el ticket id
            forInsert.setSQLQuery(sqlMgr.getSql("getMainTypeScheduleBYUnitID").trim());
            forInsert.setparams(params);
            returned_Codes = forInsert.executeQuery();

        } catch (Exception se) {
            logger.error(se.getMessage());
            JOptionPane.showMessageDialog(null, se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resAsWeb = new Vector();
        Row row;
        WebBusinessObject wbo;

        for (int i = 0; i < returned_Codes.size(); i++) {
            row = (Row) returned_Codes.get(i);
            wbo = super.fabricateBusObj(row);
            resAsWeb.add(wbo);
        }

        return resAsWeb;
    }

    public String saveObject(WebBusinessObject schedule, HttpSession s) throws SQLException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String scheduleID = new String("");
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Connection connection = null;
        try {
            Vector userTrades = userTradeMgr.getOnArbitraryDoubleKey((String) waUser.getAttribute("userId"), "key1", (String) schedule.getAttribute("trade"), "key2");
            WebBusinessObject wbo = (WebBusinessObject) userTrades.elementAt(0);
            scheduleID = UniqueIDGen.getNextID();
            params.addElement(new StringValue(scheduleID));
            params.addElement(new StringValue((String) schedule.getAttribute("scheduleTitle")));
            params.addElement(new StringValue((String) schedule.getAttribute("scheduleDesc")));
            params.addElement(new IntValue(new Integer(schedule.getAttribute("frequency").toString())));
            params.addElement(new IntValue(new Integer(schedule.getAttribute("frequencyType").toString())));
            params.addElement(new IntValue(new Integer(schedule.getAttribute("duration").toString())));
            params.addElement(new StringValue((String) schedule.getAttribute("eqpCatID")));
            params.addElement(new StringValue((String) schedule.getAttribute("trade")));
            params.addElement(new StringValue((String) waUser.getAttribute("id")));
            params.addElement(new StringValue((String) wbo.getAttribute("Id")));
            params.addElement(new IntValue(new Integer(schedule.getAttribute("frequencyReal").toString())));
            params.addElement(new IntValue(new Integer(schedule.getAttribute("whichCloser").toString())));

            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertSchedule").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return null;
        } catch (Exception ex) {
            logger.error("General Schedule Saving Exception " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return null;
            }
        }
        if (queryResult > 0) {
            return scheduleID;
        } else {
            return null;
        }
    }

    public String saveMainTypeSchedule(WebBusinessObject schedule, HttpSession s) throws SQLException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String scheduleID = new String("");
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Connection connection = null;
        Vector userTrades = new Vector();
        try {
            userTrades = userTradeMgr.getOnArbitraryDoubleKey((String) waUser.getAttribute("userId"), "key1", (String) schedule.getAttribute("trade"), "key2");
            if (userTrades.size() <= 0) {
                scheduleID = "tradeFailure";
                return scheduleID;
            }

        } catch (SQLException ex) {
            ex.printStackTrace();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        try {

            WebBusinessObject wbo = (WebBusinessObject) userTrades.elementAt(0);
            scheduleID = UniqueIDGen.getNextID();
            params.addElement(new StringValue(scheduleID));
            params.addElement(new StringValue((String) schedule.getAttribute("scheduleTitle")));
            params.addElement(new StringValue((String) schedule.getAttribute("scheduleDesc")));
            params.addElement(new IntValue(new Integer(schedule.getAttribute("frequency").toString())));
            params.addElement(new IntValue(new Integer(schedule.getAttribute("frequencyType").toString())));
            params.addElement(new IntValue(new Integer(schedule.getAttribute("duration").toString())));
            params.addElement(new StringValue((String) schedule.getAttribute("trade")));
            params.addElement(new StringValue((String) waUser.getAttribute("id")));
            params.addElement(new StringValue((String) wbo.getAttribute("Id")));
            params.addElement(new StringValue((String) schedule.getAttribute("mainCatTypeId")));
            params.addElement(new IntValue(new Integer(schedule.getAttribute("frequencyReal").toString())));
            params.addElement(new IntValue(new Integer(schedule.getAttribute("whichCloser").toString())));

            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertMainCatSchedule").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return null;
        } catch (Exception ex) {
            logger.error("General Schedule Saving Exception " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return null;
            }
        }
        if (queryResult > 0) {
            return scheduleID;
        } else {
            return null;
        }
    }

    public String saveEquipSchedule(WebBusinessObject schedule, HttpSession session) throws SQLException {
        Vector parameters = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String scheduleID = "";

        WebBusinessObject waUser = (WebBusinessObject) session.getAttribute("loggedUser");

        Connection connection = null;
        try {
            Vector userTrades = userTradeMgr.getOnArbitraryDoubleKey((String) waUser.getAttribute("userId"), "key1", (String) schedule.getAttribute("trade"), "key2");
            WebBusinessObject wbo = (WebBusinessObject) userTrades.elementAt(0);

            scheduleID = UniqueIDGen.getNextID();
            parameters.addElement(new StringValue(scheduleID));
            parameters.addElement(new StringValue((String) schedule.getAttribute("scheduleTitle")));
            parameters.addElement(new StringValue((String) schedule.getAttribute("scheduleDesc")));
            parameters.addElement(new IntValue(new Integer(schedule.getAttribute("frequency").toString())));
            parameters.addElement(new IntValue(new Integer(schedule.getAttribute("frequencyType").toString())));
            parameters.addElement(new IntValue(new Integer(schedule.getAttribute("duration").toString())));
            parameters.addElement(new StringValue((String) schedule.getAttribute("equipID")));
            parameters.addElement(new NullValue());
            parameters.addElement(new StringValue((String) schedule.getAttribute("trade")));
            parameters.addElement(new StringValue((String) waUser.getAttribute("id")));
            parameters.addElement(new NullValue());
            parameters.addElement(new StringValue("Eqp"));
            parameters.addElement(new StringValue((String) wbo.getAttribute("Id")));
            parameters.addElement(new NullValue());
            parameters.addElement(new IntValue(new Integer(schedule.getAttribute("frequencyReal").toString())));
            parameters.addElement(new IntValue(new Integer(schedule.getAttribute("wichCloser").toString())));

            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertGeneralSchedule").trim());
            forInsert.setparams(parameters);

            queryResult = forInsert.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return null;
        } catch (Exception ex) {
            logger.error("General Schedule Saving Exception " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return null;
            }
        }

        if (queryResult > 0) {
            return scheduleID;
        } else {
            return null;
        }
    }

    public boolean saveMainTypeSchedule(HttpServletRequest request, HttpSession s) throws SQLException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) request.getParameter("scheduleTitle")));
        params.addElement(new StringValue((String) request.getParameter("scheduleDesc")));
        params.addElement(new StringValue((String) request.getParameter("frequency")));
        params.addElement(new StringValue((String) request.getParameter("frequencyType")));
        params.addElement(new StringValue((String) request.getParameter("duration")));
        params.addElement(new StringValue((String) request.getParameter("unitCatsId")));
        params.addElement(new StringValue((String) request.getParameter("equipCatID")));
        params.addElement(new StringValue((String) request.getParameter("scheduleType")));
        params.addElement(new StringValue((String) request.getParameter("workTrade")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertMainTypeSchedule").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public boolean updateSchedule(WebBusinessObject wbo, String source) {

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) wbo.getAttribute("schTitle")));
        params.addElement(new StringValue((String) wbo.getAttribute("scheduleDesc")));
        params.addElement(new StringValue((String) wbo.getAttribute("frequency")));
        params.addElement(new StringValue((String) wbo.getAttribute("frequencyType")));
        params.addElement(new IntValue(new Integer(wbo.getAttribute("duration").toString())));
        params.addElement(new StringValue((String) wbo.getAttribute("equipCatID")));
        params.addElement(new StringValue((String) wbo.getAttribute("tarde")));
        params.addElement(new IntValue(new Integer(wbo.getAttribute("frequencyReal").toString())));
        params.addElement(new IntValue(new Integer(wbo.getAttribute("whichCloser").toString())));
        params.addElement(new StringValue((String) wbo.getAttribute("periodicID")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            if (source.equalsIgnoreCase("cat")) {
                forUpdate.setSQLQuery(sqlMgr.getSql("updateScheduleSQL").trim());
            } else if (source.equalsIgnoreCase("maincat")) {
                forUpdate.setSQLQuery(sqlMgr.getSql("updateMainCatScheduleSQL").trim());
            } else {
                forUpdate.setSQLQuery(sqlMgr.getSql("updateEqpScheduleSQL").trim());
            }
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

            cashData();
        } catch (SQLException se) {

            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public boolean updateMainTypeSchedule(WebBusinessObject wbo) {

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) wbo.getAttribute("scheduleTitle")));
        params.addElement(new StringValue((String) wbo.getAttribute("scheduleDesc")));
        params.addElement(new StringValue((String) wbo.getAttribute("frequency")));
//        params.addElement(new StringValue((String)wbo.getAttribute("frequencyType")));
        params.addElement(new StringValue((String) wbo.getAttribute("duration")));
//        params.addElement(new StringValue((String)wbo.getAttribute("equipCatID")));
        params.addElement(new StringValue((String) wbo.getAttribute("periodicID")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateMainTypeSchedule").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

            cashData();
        } catch (SQLException se) {

            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public Vector getAllCategory() {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllCategory").trim());
//        query.append(sSearch);
//        query.append("%'");

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("maintenanceTitle"));
        }

        return cashedData;
    }

    public ArrayList getTaskforEquip() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            if (!wbo.getAttribute("periodicID").toString().equalsIgnoreCase("1") && !wbo.getAttribute("periodicID").toString().equalsIgnoreCase("2")) {
                cashedData.add(wbo);
            }
        }

        return cashedData;
    }

    public ArrayList getCashedTableAsBusObjects() {
        return null;
    }

    public WebBusinessObject formScraping(HttpServletRequest request) {
        WebBusinessObject schedule = new WebBusinessObject();

        int minutes = 0;
        String day = (String) request.getParameter("day");
        String hour = (String) request.getParameter("hour");
        String minute = (String) request.getParameter("minute");

        String frequency = request.getParameter("frequency");
        String frequencyType = request.getParameter("frequencyType");
        String frequencyReal = getFrequencyReal(frequency, frequencyType);

        if (day != null && !day.equals("")) {
            minutes = minutes + dateAndTime.getMinuteOfDay(day);
        }
        if (hour != null && !hour.equals("")) {
            minutes = minutes + dateAndTime.getMinuteOfHour(hour);
        }
        if (minute != null && !minute.equals("")) {
            minutes = minutes + new Integer(minute).intValue();
        }

        schedule.setAttribute("scheduleTitle", request.getParameter("scheduleTitle"));
        schedule.setAttribute("eqpCatID", request.getParameter("unitCats"));
        schedule.setAttribute("frequency", frequency);
        schedule.setAttribute("frequencyType", frequencyType);
        schedule.setAttribute("frequencyReal", frequencyReal);
        schedule.setAttribute("trade", request.getParameter("trade"));
        schedule.setAttribute("duration", minutes);
        schedule.setAttribute("whichCloser", request.getParameter("whichCloser"));

        if (request.getParameter("scheduleDesc") == null || request.getParameter("scheduleDesc").equalsIgnoreCase("")) {
            schedule.setAttribute("scheduleDesc", "No Description");
        } else {
            schedule.setAttribute("scheduleDesc", request.getParameter("scheduleDesc"));
        }

        return schedule;
    }

    public WebBusinessObject formMainCatSchScraping(HttpServletRequest request) {
        WebBusinessObject schedule = new WebBusinessObject();

        int minutes = 0;
        String day = (String) request.getParameter("day");
        String hour = (String) request.getParameter("hour");
        String minute = (String) request.getParameter("minute");

        String frequency = request.getParameter("frequency");
        String frequencyType = request.getParameter("frequencyType");
        String frequencyReal = getFrequencyReal(frequency, frequencyType);
        if (day != null && !day.equals("")) {
            minutes = minutes + dateAndTime.getMinuteOfDay(day);
        }
        if (hour != null && !hour.equals("")) {
            minutes = minutes + dateAndTime.getMinuteOfHour(hour);
        }
        if (minute != null && !minute.equals("")) {
            minutes = minutes + new Integer(minute).intValue();
        }

        schedule.setAttribute("scheduleTitle", request.getParameter("scheduleTitle"));
        schedule.setAttribute("mainCatTypeId", request.getParameter("mainCatType"));
        schedule.setAttribute("frequency", frequency);
        schedule.setAttribute("frequencyType", frequencyType);
        schedule.setAttribute("frequencyReal", frequencyReal);
        schedule.setAttribute("trade", request.getParameter("trade"));
        schedule.setAttribute("duration", minutes);
        schedule.setAttribute("whichCloser", request.getParameter("whichCloser"));

        if (request.getParameter("scheduleDesc") == null || request.getParameter("scheduleDesc").equalsIgnoreCase("")) {
            schedule.setAttribute("scheduleDesc", "No Description");
        } else {
            schedule.setAttribute("scheduleDesc", request.getParameter("scheduleDesc"));
        }

        return schedule;
    }

    public String getFrequencyReal(String frequency, String frequencyType) {
        int intFrequency = 0;

        try {
            intFrequency = Integer.valueOf(frequency).intValue();
        } catch (NumberFormatException ex) {
        }

        int multiplyBy = 1;
        if (frequencyType.equals("1")) {
            multiplyBy = 24;
        } else if (frequencyType.equals("2")) {
            multiplyBy = 168;
        } else if (frequencyType.equals("3")) {
            multiplyBy = 720;
        } else if (frequencyType.equals("4")) {
            multiplyBy = 8640;
        }

        return String.valueOf((intFrequency * multiplyBy));
    }

    public WebBusinessObject formEqpScheduleScraping(HttpServletRequest request) {
        WebBusinessObject schedule = new WebBusinessObject();
        MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();

        int minutes = 0;
        String day = (String) request.getParameter("day");
        String hour = (String) request.getParameter("hour");
        String minute = (String) request.getParameter("minute");
        String unitId = request.getParameter("unitId");
        String frequency = request.getParameter("frequency");
        String wichCloser = request.getParameter("wichCloser");
        String frequencyType = request.getParameter("frequencyType");
        String frequencyReal = getFrequencyReal(frequency, frequencyType);

        String mainCatId = (String) maintainableMgr.getOnSingleKey(unitId).getAttribute("maintTypeId");

        if (day != null && !day.equals("")) {
            minutes = minutes + dateAndTime.getMinuteOfDay(day);
        }
        if (hour != null && !hour.equals("")) {
            minutes = minutes + dateAndTime.getMinuteOfHour(hour);
        }
        if (minute != null && !minute.equals("")) {
            minutes = minutes + new Integer(minute).intValue();
        }

        schedule.setAttribute("scheduleTitle", request.getParameter("scheduleTitle"));
        schedule.setAttribute("equipID", unitId);
        schedule.setAttribute("eqpCatID", mainCatId);
        schedule.setAttribute("frequency", frequency);
        schedule.setAttribute("frequencyType", frequencyType);
        schedule.setAttribute("frequencyReal", frequencyReal);
        schedule.setAttribute("wichCloser", wichCloser);
        schedule.setAttribute("trade", request.getParameter("trade"));
        schedule.setAttribute("duration", minutes);

        if (request.getParameter("scheduleDesc") == null || request.getParameter("scheduleDesc").equalsIgnoreCase("")) {
            schedule.setAttribute("scheduleDesc", "No Description");
        } else {
            schedule.setAttribute("scheduleDesc", request.getParameter("scheduleDesc"));
        }

        return schedule;
    }

    public Vector getAllSchedule() {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllSchedule").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public boolean getActiveSchedule(String periodicID) throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(periodicID));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getActiveSchedule").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("database error from getListOnSecondKey: ImageMgr " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }

        return queryResult.size() > 0;
    }

    public Vector getUnEmgSchedule() {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getUnEmgScheduleSQL.trim());
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getScheduleMainType() {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getScheduleMainType").trim());
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public boolean getConfigSchedule(String id) throws Exception {
        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getScheduleParts").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("database error from getListOnSecondKey: ImageMgr " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }

        return queryResult.size() > 0;
    }

    public String getAllTimeScheduleNames() {
        Connection connection = null;
        ResultSet result = null;
        StringBuffer returnSB = null;

        try {
            connection = dataSource.getConnection();
            Statement select = connection.createStatement();
            result = select.executeQuery(sqlMgr.getSql("getAllTimeBasedScheduleSql").trim());
            returnSB = new StringBuffer();
            while (result.next()) {
                returnSB.append(result.getString("MAINTENANCE_TITLE") + ",");
            }
            returnSB.deleteCharAt(returnSB.length() - 1);
        } catch (SQLException e) {
            logger.error("error ================ > " + e.toString());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        return returnSB.toString();
    }

    public String getTaskName(String taskId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(taskId));

        Connection connection = null;
        String taskName = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getTaskName").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                taskName = r.getString(1);
            }

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } catch (NoSuchColumnException nosuch) {
            logger.error("***** " + nosuch.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        return taskName;

    }

    public Vector getScheduleCountByMainCat() {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getScheduleByMainCat").trim());
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getScheduleCountByCategories() {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getScheduleByCategory").trim());
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getScheduleCountByEquipment() {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getScheduleByEquipment").trim());
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getSchedulesByTrade(Vector userTrades, String equipmentID, String partentID) {
        String queryBuilder = "select * from schedule where (equip_id = ? or equip_cat_id = ? ) and schedule_type = 1 and schedule_trade in (";

        Vector resultBusObjs = new Vector();
        Vector SQLparams = new Vector();
        Vector queryResult = null;

        Connection connection = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        //Build Query and SQLParams
        if (userTrades.size() > 0) {
            SQLparams.addElement(new StringValue(equipmentID));
            SQLparams.addElement(new StringValue(partentID));

            for (int i = 0; i < userTrades.size(); i++) {
                if (i == userTrades.size() - 1) {
                    queryBuilder = queryBuilder + "?)";
                } else {
                    queryBuilder = queryBuilder + "?,";
                }

                WebBusinessObject tradeWbo = (WebBusinessObject) userTrades.elementAt(i);
                SQLparams.addElement(new StringValue(tradeWbo.getAttribute("tradeId").toString()));
            }

            try {
                connection = dataSource.getConnection();
                forQuery.setConnection(connection);
                forQuery.setSQLQuery(queryBuilder);
                forQuery.setparams(SQLparams);
                queryResult = forQuery.executeQuery();
            } catch (SQLException se) {
                logger.error("SQL Exception  " + se.getMessage());
            } catch (UnsupportedTypeException uste) {
                logger.error("***** " + uste.getMessage());
            } finally {
                try {
                    connection.close();
                } catch (SQLException ex) {
                    logger.error("Close Error");
                }
            }

            Row r = null;
            WebBusinessObject wbo = null;

            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                wbo = fabricateBusObj(r);
                resultBusObjs.add(wbo);
            }
        }

        return resultBusObjs;
    }

    public Vector getAllEqpSchsByTrade(Vector userTrades, String equipmentID, String partentID, String mainCatId) {
        String queryBuilder = "select * from schedule where (equip_id = ? or equip_cat_id = ? or MAIN_CAT_TYPE_ID = ? ) and schedule_type = 1 and schedule_trade in (";

        Vector resultBusObjs = new Vector();
        Vector SQLparams = new Vector();
        Vector queryResult = null;

        Connection connection = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        //Build Query and SQLParams
        if (userTrades.size() > 0) {
            SQLparams.addElement(new StringValue(equipmentID));
            SQLparams.addElement(new StringValue(partentID));
            SQLparams.addElement(new StringValue(mainCatId));

            for (int i = 0; i < userTrades.size(); i++) {
                if (i == userTrades.size() - 1) {
                    queryBuilder = queryBuilder + "?)";
                } else {
                    queryBuilder = queryBuilder + "?,";
                }

                WebBusinessObject tradeWbo = (WebBusinessObject) userTrades.elementAt(i);
                SQLparams.addElement(new StringValue(tradeWbo.getAttribute("tradeId").toString()));
            }

            try {
                connection = dataSource.getConnection();
                forQuery.setConnection(connection);
                forQuery.setSQLQuery(queryBuilder);
                forQuery.setparams(SQLparams);
                queryResult = forQuery.executeQuery();
            } catch (SQLException se) {
                logger.error("SQL Exception  " + se.getMessage());
            } catch (UnsupportedTypeException uste) {
                logger.error("***** " + uste.getMessage());
            } finally {
                try {
                    connection.close();
                } catch (SQLException ex) {
                    logger.error("Close Error");
                }
            }

            Row r = null;
            WebBusinessObject wbo = null;

            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                wbo = fabricateBusObj(r);
                resultBusObjs.add(wbo);
            }
        }

        return resultBusObjs;
    }

    public Vector getMainCatsSchByTrade(Vector userTrades, String equipmentID, String partentID) {

        String queryBuilder = "select * from schedule where MAIN_CAT_TYPE_ID = ? and schedule_type = 1 and schedule_trade in (";

        Vector resultBusObjs = new Vector();
        Vector SQLparams = new Vector();
        Vector queryResult = null;

        Connection connection = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        //Build Query and SQLParams
        if (userTrades.size() > 0) {
            SQLparams.addElement(new StringValue(partentID));

            for (int i = 0; i < userTrades.size(); i++) {
                if (i == userTrades.size() - 1) {
                    queryBuilder = queryBuilder + "?)";
                } else {
                    queryBuilder = queryBuilder + "?,";
                }

                WebBusinessObject tradeWbo = (WebBusinessObject) userTrades.elementAt(i);
                SQLparams.addElement(new StringValue(tradeWbo.getAttribute("tradeId").toString()));
            }

            try {
                connection = dataSource.getConnection();
                forQuery.setConnection(connection);
                forQuery.setSQLQuery(queryBuilder);
                forQuery.setparams(SQLparams);
                queryResult = forQuery.executeQuery();
            } catch (SQLException se) {
                logger.error("SQL Exception  " + se.getMessage());
            } catch (UnsupportedTypeException uste) {
                logger.error("***** " + uste.getMessage());
            } finally {
                try {
                    connection.close();
                } catch (SQLException ex) {
                    logger.error("Close Error");
                }
            }

            Row r = null;
            WebBusinessObject wbo = null;

            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                wbo = fabricateBusObj(r);
                resultBusObjs.add(wbo);
            }
        }

        return resultBusObjs;
    }

    public Vector getModelSchByTrade(Vector userTrades, String equipmentID, String partentID) {

        String queryBuilder = "select * from schedule where EQUIP_CAT_ID = ? and schedule_type = 1 and schedule_trade in (";

        Vector resultBusObjs = new Vector();
        Vector SQLparams = new Vector();
        Vector queryResult = null;

        Connection connection = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        //Build Query and SQLParams
        if (userTrades.size() > 0) {
            SQLparams.addElement(new StringValue(partentID));

            for (int i = 0; i < userTrades.size(); i++) {
                if (i == userTrades.size() - 1) {
                    queryBuilder = queryBuilder + "?)";
                } else {
                    queryBuilder = queryBuilder + "?,";
                }

                WebBusinessObject tradeWbo = (WebBusinessObject) userTrades.elementAt(i);
                SQLparams.addElement(new StringValue(tradeWbo.getAttribute("tradeId").toString()));
            }

            try {
                connection = dataSource.getConnection();
                forQuery.setConnection(connection);
                forQuery.setSQLQuery(queryBuilder);
                forQuery.setparams(SQLparams);
                queryResult = forQuery.executeQuery();
            } catch (SQLException se) {
                logger.error("SQL Exception  " + se.getMessage());
            } catch (UnsupportedTypeException uste) {
                logger.error("***** " + uste.getMessage());
            } finally {
                try {
                    connection.close();
                } catch (SQLException ex) {
                    logger.error("Close Error");
                }
            }

            Row r = null;
            WebBusinessObject wbo = null;

            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                wbo = fabricateBusObj(r);
                resultBusObjs.add(wbo);
            }
        }

        return resultBusObjs;
    }


    public boolean canDeleteSchedule(String scheduleID) {
        boolean results = false;

        try {
            sheduleConfig = scheduleConfigMgr.getOnArbitraryKey(scheduleID, "key1");
            scheduleTasks = scheduleTasksMgr.getOnArbitraryKey(scheduleID, "key1");

            if (sheduleConfig.size() <= 0 && scheduleTasks.size() <= 0) {
                results = true;
            } else {
                results = false;
            }

        } catch (Exception ex) {
            logger.error("Can Delete Schedule Exception ?? " + ex.getMessage());
        }

        return results;
    }

    public ArrayList getMainCatSchedules(String mainCatId) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;
        Vector params = new Vector();

        params.addElement(new StringValue(mainCatId));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getMainCatSchedules").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        ArrayList resultBusObjs = new ArrayList();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getSchBySubName(String name) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        String query = sqlMgr.getSql("getSchBySubName").trim().replaceAll("ppp", name);

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getScheduleForEquipment() {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        String query = sqlMgr.getSql("getScheduleForEquipment").trim();

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getAllScheduleForEquipmentAndMainTypeEquip(WebBusinessObject unitWbo) {

        String unitId = (String) unitWbo.getAttribute("id");
        String mainTypeId = (String) unitWbo.getAttribute("maintTypeId");
        String parentId = (String) unitWbo.getAttribute("parentId");
        String active, scheduleId;
        WebBusinessObject wbo;
        Vector allSchedule = new Vector();
        Vector mainTypeSchedule = new Vector();
        Vector parentSchedule = new Vector();
        try {
            allSchedule = schedualMgr.getOnArbitraryKey(unitId, "key2");
            parentSchedule = schedualMgr.getOnArbitraryKey(parentId, "key4");
            mainTypeSchedule = schedualMgr.getOnArbitraryKey(mainTypeId, "key7");
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        // merage 2 vector allSchedule and mainTypeSchedule
        for (int i = 0; i < mainTypeSchedule.size(); i++) {
            allSchedule.addElement((WebBusinessObject) mainTypeSchedule.get(i));
        }

        // merage 2 vector allSchedule and parentSchedule
        for (int i = 0; i < parentSchedule.size(); i++) {
            allSchedule.addElement((WebBusinessObject) parentSchedule.get(i));
        }

        // check for all vector allSchedule to verfay active or not
        for (int i = 0; i < allSchedule.size(); i++) {
            active = "no";
            mainTypeSchedule = null;
            wbo = (WebBusinessObject) allSchedule.get(i);
            scheduleId = (String) wbo.getAttribute("periodicID");
            if (unitScheduleMgr.isScheduleActive(scheduleId, unitId)) {
                active = "yes";
            }
            wbo.setAttribute("active", active);
        }

        return allSchedule;
    }
    
    public Vector getAllSchedulesForEquipment(WebBusinessObject unitWbo, java.sql.Date beginDate, java.sql.Date endDate) {
    
            String unitId = (String) unitWbo.getAttribute("id");
            String mainTypeId = (String) unitWbo.getAttribute("maintTypeId");
            String parentId = (String) unitWbo.getAttribute("parentId");
            String active;
            WebBusinessObject wbo, issueWbo;
            Vector allSchedule = new Vector();
            Vector mainTypeSchedule = new Vector();
            Vector parentSchedule = new Vector();
            Vector issuesByScheduleVec = new Vector();
            String issueDate, scheduleId, scheduleEqId;
            
        try {
            
            allSchedule = schedualMgr.getOnArbitraryKey(unitId, "key2");
            parentSchedule = schedualMgr.getOnArbitraryKey(parentId, "key4");
            mainTypeSchedule = schedualMgr.getOnArbitraryKey(mainTypeId, "key7");
            
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        // merge 2 vector allSchedule and mainTypeSchedule
        for (int i = 0; i < mainTypeSchedule.size(); i++) {
            allSchedule.addElement((WebBusinessObject) mainTypeSchedule.get(i));
        }
            
         // merge 2 vector allSchedule and parentSchedule
        for (int i = 0; i < parentSchedule.size(); i++) {
            allSchedule.addElement((WebBusinessObject) parentSchedule.get(i));
        }
        
        // check for all vector allSchedule to verify active or not
        for (int i = 0; i < allSchedule.size(); i++) {
            active = "no";
            mainTypeSchedule = null;
            wbo = (WebBusinessObject) allSchedule.get(i);
            scheduleEqId = (String) wbo.getAttribute("equipmentID");
            
            scheduleId = (String) wbo.getAttribute("periodicID");
            issuesByScheduleVec = issueMgr.getScheduleIssuesInRange(unitId, scheduleId, beginDate, endDate);
            if(issuesByScheduleVec != null && !issuesByScheduleVec.isEmpty()) {
                active = "yes";
                issueWbo = (WebBusinessObject) issuesByScheduleVec.get(0);
                issueDate = (String) issueWbo.getAttribute("expectedBeginDate");
                wbo.setAttribute("issueDate", issueDate);
            } 
             
            wbo.setAttribute("active", active);
        }

        return allSchedule;
    }

    public boolean deleteSchedule(String scheduleId) {
        ScheduleTasksMgr scheduleTasksMg = ScheduleTasksMgr.getInstance();
        ConfigureMainTypeMgr configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
        UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
        IssueMgr issueMgr = IssueMgr.getInstance();

        Vector issueDelVec = new Vector();
        Vector unitScheduleDelVec = new Vector();
        WebBusinessObject unitSchWbo = new WebBusinessObject();
        WebBusinessObject issueWbo = new WebBusinessObject();
        try {
            unitScheduleDelVec = unitScheduleMgr.getOnArbitraryKey(scheduleId, "key2");
            if (unitScheduleDelVec.size() > 0) {
                for (int i = 0; i < unitScheduleDelVec.size(); i++) {
                    unitSchWbo = (WebBusinessObject) unitScheduleDelVec.get(i);
                    issueDelVec = issueMgr.getOnArbitraryKey(unitSchWbo.getAttribute("id").toString(), "key3");
                    if (issueDelVec.size() > 0) {
                        for (int x = 0; x < issueDelVec.size(); x++) {
                            issueWbo = (WebBusinessObject) issueDelVec.get(x);
                            issueMgr.deleteOnSingleKey(issueWbo.getAttribute("id").toString());
                        }
                    }
                    unitScheduleMgr.deleteOnSingleKey(unitSchWbo.getAttribute("id").toString());
                }
            }
            schedualMgr.deleteOnSingleKey(scheduleId);

        } catch (SQLException ex) {
            Logger.getLogger(ScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(ScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);
        }

        return true;
    }

    public Vector getAllParentsSchedules(String id) {
        Vector returned_Codes = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Connection connection = null;
        Vector SQLparams = new Vector();
        String quary;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);

            if (id == null) {
                forInsert.setSQLQuery(sqlMgr.getSql("getAllParents").trim());
            } else {
                SQLparams.addElement(new StringValue(id));
                forInsert.setSQLQuery(sqlMgr.getSql("getAllParentsSchedulesByName").trim());
                forInsert.setparams(SQLparams);
            }
            //3shn ageb el customer id mn el ticket id
            returned_Codes = forInsert.executeQuery();

        } catch (Exception se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resAsWeb = new Vector();
        Row row;
        WebBusinessObject wbo;

        if (id == null) {
            try {
                connection = dataSource.getConnection();
                forInsert.setConnection(connection);
                for (int i = 0; i < returned_Codes.size(); i++) {

                    SQLparams = new Vector();
                    Vector returned_Codes2 = new Vector();
                    row = (Row) returned_Codes.get(i);
                    wbo = new WebBusinessObject();
                    wbo = super.fabricateBusObj(row);
                    SQLparams.addElement(new StringValue((String) wbo.getAttribute("id")));
                    forInsert.setSQLQuery(sqlMgr.getSql("getAllParentsSchedules").trim());
                    forInsert.setparams(SQLparams);
                    try {
                        returned_Codes2 = forInsert.executeQuery();
                        for (i = 0; i < returned_Codes2.size(); i++) {
                            wbo = new WebBusinessObject();
                            row = (Row) returned_Codes2.get(i);
                            wbo = super.fabricateBusObj(row);
                            resAsWeb.add(wbo);
                        }
                    } catch (UnsupportedTypeException ex) {
                        Logger.getLogger(ScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            } catch (SQLException ex) {
                Logger.getLogger(ScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        } else {
            for (int i = 0; i < returned_Codes.size(); i++) {
                SQLparams = new Vector();
                Vector returned_Codes2 = new Vector();
                row = (Row) returned_Codes.get(i);
                wbo = new WebBusinessObject();
                wbo = super.fabricateBusObj(row);
                resAsWeb.add(wbo);
            }
        }
        return resAsWeb;
    }

    public Vector getAllScheduleByTimeOnEquipmentByDirectAndInDirect(String unitId, String catId, String mainCatId) {
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector SQLparams = new Vector();
        Vector<Row> queryResult = new Vector();
        Connection connection = null;

        SQLparams.addElement(new StringValue(unitId));
        SQLparams.addElement(new StringValue(catId));
        SQLparams.addElement(new StringValue(mainCatId));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getAllScheduleByTimeOnEquipmentByDirectAndInDirect").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

        for (Row row : queryResult) {
            resultBusObjs.add(fabricateBusObj(row));
        }

        return resultBusObjs;
    }

    public boolean deleteExactlySchedule(String scheduleId) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();

        params.addElement(new StringValue(scheduleId));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);

            forInsert.setSQLQuery("{ CALL DELETE_SCHEDULE(?) }");
            forInsert.setparams(params);

            forInsert.executeUpdate();
        } catch (SQLException se) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (true);
    }
    
    public WebBusinessObject formTimeEqpScheduleScraping(HttpServletRequest request) {
        WebBusinessObject schedule = new WebBusinessObject();
        MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();

        int minutes=0;
         String day = (String)request.getParameter("day");
         String hour = (String) request.getParameter("hour");
         String minute = (String)request.getParameter("minute");
         String unitId = request.getParameter("unitId");

         String frequency = request.getParameter("frequency");
         String frequencyType = request.getParameter("frequencyType");
         String frequencyReal = getFrequencyReal(frequency, frequencyType);

         String mainCatId = (String) maintainableMgr.getOnSingleKey(unitId).getAttribute("maintTypeId");

           if(day != null && !day.equals("")){
                    minutes = minutes + dateAndTime.getMinuteOfDay(day);
                }
           if(hour != null && !hour.equals("")) {
                    minutes = minutes + dateAndTime.getMinuteOfHour(hour);
                }
           if(minute != null && !minute.equals("")) {
                     minutes = minutes + new Integer(minute).intValue();
                }

        schedule.setAttribute("scheduleTitle", request.getParameter("scheduleTitle"));
        schedule.setAttribute("equipID", unitId);
        schedule.setAttribute("eqpCatID", mainCatId);
        schedule.setAttribute("frequency", frequency);
        schedule.setAttribute("frequencyType", frequencyType);
        schedule.setAttribute("frequencyReal", frequencyReal);
        schedule.setAttribute("trade", request.getParameter("trade"));
        schedule.setAttribute("duration", minutes);
        
        if (request.getParameter("scheduleDesc") == null || request.getParameter("scheduleDesc").equalsIgnoreCase("")) {
            schedule.setAttribute("scheduleDesc", "No Description");
        } else {
            schedule.setAttribute("scheduleDesc", request.getParameter("scheduleDesc"));
        }
        
        return schedule;
    }

    public Vector getSchBySubName(String name, String scheduleOn) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        
        Vector parameters = new Vector();
        Vector<Row> rows = new Vector();
        
        if(scheduleOn != null && !scheduleOn.equalsIgnoreCase("all")) {
            parameters.addElement(new StringValue(scheduleOn));
            command.setparams(parameters);
            command.setSQLQuery(sqlMgr.getSql("getSchBySubNameAndScheduleOn").trim().replaceAll("ppp", name));
        } else {
            command.setSQLQuery(sqlMgr.getSql("getSchBySubName").trim().replaceAll("ppp", name));
        }

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);

            rows = command.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        
        Vector<WebBusinessObject> webBusinessObjects = new Vector();
        for(Row row : rows) {
            webBusinessObjects.add(fabricateBusObj(row));
        }
        
        return webBusinessObjects;
    }

    public Vector getSchByScheduleOn(String scheduleOn) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        
        Vector parameters = new Vector();
        Vector<Row> rows = new Vector();
        
        if(scheduleOn != null && !scheduleOn.equalsIgnoreCase("all")) {
            parameters.addElement(new StringValue(scheduleOn));
            command.setparams(parameters);
            command.setSQLQuery(sqlMgr.getSql("getSchByScheduleOn").trim());
        } else {
            command.setSQLQuery(sqlMgr.getSql("getAllSchedule").trim());
        }
        
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            rows = command.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        
        Vector<WebBusinessObject> webBusinessObjects = new Vector();
        for(Row row : rows) {
            webBusinessObjects.add(fabricateBusObj(row));
        }
        
        return webBusinessObjects;
    }

    public Vector getAllScheduleByModel(String modelId) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllScheduleByModel").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getScheduledSchedulesByEquip(String equipId) {

        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        SQLparams.addElement(new StringValue(equipId));
        StringBuffer query = new StringBuffer(getQuery("getScheduledSchedulesByEquip").trim());
        forQuery.setparams(SQLparams);

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();

            try {
                resultBusObjs.add(r.getString("schedule_id"));

            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);

            }
        }

        return resultBusObjs;
    }

    public Vector getScheduledSchedulesByEquipAndSchedule(String equipId,
                                                          String scheduleId) {

        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        SQLparams.addElement(new StringValue(equipId));
        SQLparams.addElement(new StringValue(scheduleId));
        StringBuffer query = new StringBuffer(getQuery("getScheduledSchedulesByEquipAndSchedule").trim());
        forQuery.setparams(SQLparams);

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();

            try {
                resultBusObjs.add(r.getString("schedule_id"));

            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);

            }
        }

        return resultBusObjs;
    }

    public Vector getSchedulesByBeforeDate(String beforeDateStr) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm");
        java.util.Date beforeDate = null;
        Timestamp beforeDateTS = null;

        try {
            beforeDate = dateFormat.parse(beforeDateStr);
            beforeDateTS = new java.sql.Timestamp(beforeDate.getTime());

        } catch (ParseException ex) {
            Logger.getLogger(ScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);

        }

        String query = getQuery("getSchedulesByBeforeDate").trim();
        SQLparams.addElement(new TimestampValue(beforeDateTS));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public boolean deleteBatchExactlySchedule(String[] scheduleIdArr) {
        Vector params = null;
        String scheduleId = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = 0;

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);

            forInsert.setSQLQuery("{ CALL DELETE_SCHEDULE(?) }");

            for(int i = 0; i < scheduleIdArr.length; i++) {
                scheduleId = scheduleIdArr[i];
                queryResult = -1000;
                params = new Vector();
                params.addElement(new StringValue(scheduleId));

                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();

                if(queryResult < 0) {
                    connection.rollback();
                    return false;
                }

                try {
                    Thread.sleep(50);

                } catch (InterruptedException ex) {
                    Logger.getLogger(ScheduleMgr.class.getName())
                            .log(Level.SEVERE, null, ex);
                    return false;

                }

            }

            connection.commit();

        } catch (SQLException se) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
            return false;

        } finally {
            try {
                connection.close();

            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return true;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;//    throw new UnsupportedOperationException("Not supported yet.");
    }
}
