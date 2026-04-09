package com.maintenance.db_access;

import com.maintenance.common.Tools;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.persistence.relational.StringValue;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;

import com.tracker.business_objects.*;
import com.tracker.servlets.IssueServlet.IssueTitle;
import org.apache.log4j.xml.DOMConfigurator;

public class UnitScheduleMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private String uinqueID = null;
    private static UnitScheduleMgr unitScheduleMgr = new UnitScheduleMgr();

    public static UnitScheduleMgr getInstance() {
        logger.info("Getting IssueMaintenanceMgr Instance ....");
        return unitScheduleMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("unit_schedule.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        WebIssueType issueType = (WebIssueType) wbo;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        //params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(issueType.getIssueName()));
        params.addElement(new StringValue(issueType.getIssueDesc()));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertIssueSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            cashData();
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

    public boolean saveScheduleUnits(Vector items) {
        Vector params = new Vector();

        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        setUinqueID();
        params.addElement(new StringValue(uinqueID));
        params.addElement(new StringValue((String) items.elementAt(0)));
        params.addElement(new StringValue((String) items.elementAt(1)));
        params.addElement(new StringValue((String) items.elementAt(2)));
        params.addElement(new StringValue((String) items.elementAt(3)));
        params.addElement(new DateValue((java.sql.Date) items.elementAt(4)));
        params.addElement(new DateValue((java.sql.Date) items.elementAt(5)));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertScheduleUnitsSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            Thread.sleep(10);
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } catch (InterruptedException e) {
            logger.error("Thred exception " + e.getMessage());
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

    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("unitName"));
        }

        return cashedData;
    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("unitName"));
        }

        return cashedData;
    }

    public boolean updateIssueType(WebBusinessObject wbo) throws NoUserInSessionException {
        StringBuffer query = new StringBuffer("UPDATE ");
        query.append(supportedForm.getTableSupported().getAttribute("name"));
        query.append(" SET TYPE_DESC=?");
        query.append(" WHERE ");
        query.append(supportedForm.getTableSupported().getAttribute("key"));
        query.append(" = ?");


        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;


        params.addElement(new StringValue((String) wbo.getAttribute("issueDesc")));
        params.addElement(new StringValue((String) wbo.getAttribute("issueName")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(query.toString());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

            cashData();
        } catch (SQLException se) {
            logger.error("Exception updating issue type: " + se.getMessage());
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

    private void setUinqueID() {
        uinqueID = UniqueIDGen.getNextID();
    }

    public String getUinqueID() {
        return uinqueID;
    }

    public Vector getScheduleConfig() {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getScheduleConfig").trim());


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

    public Vector getBindedEqpsSchedules(String equipmentID, String scheduleID) {
        Vector SQLparams = new Vector();
        Vector queryResult = null;

        WebBusinessObject wbo = new WebBusinessObject();
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getUnitSchedules").trim());

        SQLparams.addElement(new StringValue(equipmentID));
        SQLparams.addElement(new StringValue(scheduleID));

        Connection connection = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
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

    public Vector getBindedEquipmentsSchedules(String scheduleID) {
        Vector SQLparams = new Vector();
        Vector queryResult = null;

        WebBusinessObject wbo = new WebBusinessObject();
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getUnitBindSchedules").trim());

        SQLparams.addElement(new StringValue(scheduleID));

        Connection connection = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
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

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo.getAttribute("unitName"));
        }
        return resultBusObjs;
    }

    public Vector getSchedulesUnits() {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getSchedulesUnitsSQL").trim());
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

    public Vector getListEmergency(HttpSession s) {
        WebBusinessObject wbo = new WebBusinessObject();
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String userId = waUser.getAttribute("userId").toString();
        Vector SQLparams = new Vector();

        Connection connection = null;
        SQLparams.addElement(new StringValue(userId));
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getListEmergency").trim());


        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
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

    public Vector getEquipmentUnitSchedules(Vector schedules, Vector equipments) {
        Vector eqpUnitSchedules = new Vector();

        try {
            for (int i = 0; i < equipments.size(); i++) {
                WebBusinessObject equipmentWbo = (WebBusinessObject) equipments.elementAt(i);

                for (int j = 0; j < schedules.size(); j++) {
                    WebBusinessObject scheduleWbo = (WebBusinessObject) schedules.elementAt(j);

                    Vector unitSchedules = unitScheduleMgr.getBindedEqpsSchedules(equipmentWbo.getAttribute("id").toString(), scheduleWbo.getAttribute("periodicID").toString());

                    if (unitSchedules.size() > 0) {
                        WebBusinessObject wbo = new WebBusinessObject();
                        WebBusinessObject usFirstWbo = (WebBusinessObject) unitSchedules.elementAt(0);
                        WebBusinessObject usLastWbo = (WebBusinessObject) unitSchedules.elementAt(unitSchedules.size() - 1);

                        wbo.setAttribute("id", usFirstWbo.getAttribute("id").toString());
                        wbo.setAttribute("periodicId", usFirstWbo.getAttribute("periodicId").toString());
                        wbo.setAttribute("maintenanceTitle", usFirstWbo.getAttribute("maintenanceTitle").toString());
                        wbo.setAttribute("beginDate", usFirstWbo.getAttribute("beginDate").toString());
                        wbo.setAttribute("endDate", usLastWbo.getAttribute("endDate").toString());
                        wbo.setAttribute("isConfigured", usFirstWbo.getAttribute("isConfigured").toString());
                        wbo.setAttribute("equipmentId", equipmentWbo.getAttribute("id").toString());
                        wbo.setAttribute("unitName", equipmentWbo.getAttribute("unitName").toString());
                        wbo.setAttribute("desc", equipmentWbo.getAttribute("desc").toString());
                        wbo.setAttribute("site", equipmentWbo.getAttribute("site").toString());
                        eqpUnitSchedules.addElement(wbo);
                    }
                }
            }

            if (eqpUnitSchedules.size() > 0) {
                for (int i = 0; i < equipments.size(); i++) {
                    WebBusinessObject equipmentWbo = (WebBusinessObject) equipments.elementAt(i);

                    for (int j = 0; j < eqpUnitSchedules.size(); j++) {
                        WebBusinessObject esWbo = (WebBusinessObject) eqpUnitSchedules.elementAt(j);
                        if (equipmentWbo.getAttribute("id").toString().equalsIgnoreCase(esWbo.getAttribute("equipmentId").toString())) {
                            equipments.remove(i);
                            i--;
                        }
                    }
                }
            }
        } catch (Exception ex) {
            logger.error("Get equipment Unit Schedules General error :: " + ex);
        }
        return eqpUnitSchedules;
    }

    public int getJobOrdersNo(String scheduleID, String eqpID) {
        int total = 0;

        try {
            Vector unitSchedules = unitScheduleMgr.getOnArbitraryDoubleKey(eqpID, "key1", scheduleID, "key2");
            total = unitSchedules.size();
        } catch (SQLException sqlEx) {
            logger.error("Get equipment Unit Schedules SQL error :: " + sqlEx);
        } catch (Exception ex) {
            logger.error("Get equipment Unit Schedules General error :: " + ex);
        }

        return total;
    }

    public Vector getLastUnitSchedule(String scheduleID, String equipmentID) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(scheduleID));
        SQLparams.addElement(new StringValue(equipmentID));

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getLastUnitScheduleSQL").trim());


        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
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

    public Vector getEqpUnitScheduleDates(String equipmentID, String scheduleID) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector resultBusObjs = new Vector();
        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLparams.addElement(new StringValue(equipmentID));
        SQLparams.addElement(new StringValue(scheduleID));

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getUnitScheduleDates").trim());
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
                wbo = new WebBusinessObject();

                r = (Row) e.nextElement();
                java.sql.Date bDate = r.getDate(1);
                java.sql.Date eDate = r.getDate(2);

                wbo.setAttribute("beginDate", bDate.toString());
                wbo.setAttribute("endDate", eDate.toString());
                wbo.setAttribute("isConfigured", r.getString(3));

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

    public Vector getEqpSchedules(String eqpID) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector results = new Vector();
        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(eqpID));

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getEqpSchedules").trim());

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
                String id = r.getString(1);
                results.add(id);
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

        return results;
    }

    public Vector getEqpSchedulesDates(String equipmentID, java.sql.Date begin, java.sql.Date end) {
        Connection connection = null;

        Vector resultBusObjs = new Vector();
        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLparams.addElement(new StringValue(equipmentID));
        SQLparams.addElement(new TimestampValue(new Timestamp(begin.getTime())));
        SQLparams.addElement(new TimestampValue(new Timestamp(end.getTime())));

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getUnitScheduleDate").trim());
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
                java.sql.Date bDate = r.getDate(1);

                resultBusObjs.add(bDate);
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

    public Vector getEqpDaySchedules(String eqpID, java.sql.Date dayDate) {
        WebBusinessObject wbo = null;
        Connection connection = null;

        Vector results = new Vector();
        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(eqpID));
        SQLparams.addElement(new DateValue(dayDate));

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getEquipmentDaySchedules").trim());

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
                wbo = new WebBusinessObject();
                wbo = fabricateBusObj(r);
                results.add(wbo);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } catch (Exception ex) {
            System.out.println("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                System.out.println("Close Error");
            }
        }

        return results;
    }

    public boolean isScheduleActive(String scheduleId, String unitId) {
        int results = -1000;
        Connection connection = null;
        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(scheduleId));
        SQLparams.addElement(new StringValue(unitId));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("isScheduleActive").trim());
            forQuery.setparams(SQLparams);

            results = forQuery.executeUpdate();
        } catch (SQLException se) {
            se.printStackTrace();
        } catch (Exception ex) {
            System.out.println("SQL Exception  " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        return results > 0;
    }

    public long getNumberIssues(IssueTitle issueTitle) {
        SQLCommandBean command = new SQLCommandBean();
        Vector<Row> result = new Vector<Row>();
        Connection connection = null;
        String query = "";

        if (issueTitle == IssueTitle.Emergency) {
            query = sqlMgr.getSql("getNumberEmrgencyIssues");
        } else if (issueTitle == IssueTitle.NotEmergency) {
            query = sqlMgr.getSql("getNumberNotEmrgencyIssues");
        } else {
            query = sqlMgr.getSql("getNumberIssues");
        }

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.trim());

            result = command.executeQuery();

            if (!result.isEmpty()) {
                Row row = result.get(0);
                String count = row.getString("NUMBER_ISSUES");
                return Long.valueOf(count).longValue();
            }
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error(ex.getMessage());
        } catch (NoSuchColumnException ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error " + ex.getMessage());
            }
        }

        return 0;
    }

    public long getNumberIssues(String scheduleId) {
        SQLCommandBean command = new SQLCommandBean();
        Vector<Row> result = new Vector<Row>();
        Vector params = new Vector();
        Connection connection = null;

        params.addElement(new StringValue(scheduleId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(sqlMgr.getSql("getNumberIssuesByScheduleId").trim());
            command.setparams(params);
            result = command.executeQuery();

            if (!result.isEmpty()) {
                Row row = result.get(0);
                String count = row.getString("NUMBER_ISSUES");
                return Long.valueOf(count).longValue();
            }
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error(ex.getMessage());
        } catch (NoSuchColumnException ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error " + ex.getMessage());
            }
        }

        return 0;
    }

    public Vector getSchedulesBeforeOrAfterDate(String unit_id, String schedule_id, int before, int after) {
        Connection connection = null;
        Vector resultBusObjs = new Vector();
        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            if (!unit_id.equals("") && !schedule_id.equals("")) {
                SQLparams.addElement(new StringValue(schedule_id));
                SQLparams.addElement(new StringValue(unit_id));
                forQuery.setSQLQuery(sqlMgr.getSql("getSchedulesBeforeOrAfterDate").trim());
            } else if (!schedule_id.equals("") && unit_id.equals("")) {
                SQLparams.addElement(new StringValue(schedule_id));
                forQuery.setSQLQuery(sqlMgr.getSql("getSchedulesBeforeOrAfterDateSchedules").trim());
            } else {
                SQLparams.addElement(new StringValue(unit_id));
                forQuery.setSQLQuery(sqlMgr.getSql("getSchedulesBeforeOrAfterDateUnits").trim());
            }
            SQLparams.addElement(new IntValue(before));
            SQLparams.addElement(new IntValue(after));
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                resultBusObjs.add(fabricateBusObj(r));
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

    public WebBusinessObject getUnitScheduleForScheduleDeserve(String unitID, String scheduleID, String date) {
        Connection connection = null;
        WebBusinessObject resultBusObjs = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            SQLparams.addElement(new StringValue(unitID));
            SQLparams.addElement(new StringValue(scheduleID));
            SQLparams.addElement(new DateValue(Tools.getSqlDate(date)));
            forQuery.setSQLQuery(sqlMgr.getSql("getunitScheduleforDeserve").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
            if (queryResult.size() > 0) {
                Row r = null;
                r = (Row) queryResult.get(0);
                resultBusObjs = fabricateBusObj(r);
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

    public Vector getEqpsByDueAfterDateSchedule(String scheduleId, String date) {
        Connection connection = null;
        Vector resultBusObjs = new Vector();
        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            SQLparams.addElement(new StringValue(scheduleId));
            SQLparams.addElement(new DateValue(Tools.getSqlDate(date)));
            forQuery.setSQLQuery(sqlMgr.getSql("getEqpsByDueAfterDateSchedule").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                resultBusObjs.add(fabricateBusObj(r));
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

    public String getSchNameBySubId(String id) throws NoSuchColumnException {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;

        Vector parameters = new Vector();
        Vector queryResult = new Vector();
        String schName = "";

            parameters.addElement(new StringValue(id));
            command.setparams(parameters);
            command.setSQLQuery(sqlMgr.getSql("getSchNameBySubId").trim());

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);

            queryResult = command.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                schName = r.getString("MAINTENANCE_TITLE");
            }
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

        return schName;
    }
    
    @Override
    protected void initSupportedQueries() {
       return; // throw new UnsupportedOperationException("Not supported yet.");
    }
}
