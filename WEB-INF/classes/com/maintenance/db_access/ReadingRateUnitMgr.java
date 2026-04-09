package com.maintenance.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class ReadingRateUnitMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static ReadingRateUnitMgr readingRateUnitMgr = new ReadingRateUnitMgr();
//    private static final String insertAverageUnitSQL = "INSERT INTO average_unit VALUES (?,?,?,?,?,?,?)";
//    private static final String updateAverageUnitSQL = "UPDATE average_unit SET CURRENT_READING = ?, ACUAL_READING = ?, ENTRY_TIME = ?, DESCRIPTION = ?, PREVIOUS_TIME = ? WHERE ID = ?";
//    private static final String countItemsSQL = "SELECT COUNT(ITEM_CODE) AS total FROM maintenance_item WHERE CATEGORY_ID = ?";
    public ReadingRateUnitMgr() {
    }

    public static ReadingRateUnitMgr getInstance() {
        logger.info("Getting ReadingRateUnitMgr Instance ....");
        return readingRateUnitMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("reading_rate_machine.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(WebBusinessObject Average, HttpSession s, long now) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        //WebBusinessObject project = (WebBusinessObject) wbo;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        //params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) Average.getAttribute("current_Reading")));
        params.addElement(new StringValue((String) Average.getAttribute("current_Reading")));
        params.addElement(new LongValue(now));
        params.addElement(new StringValue((String) Average.getAttribute("description")));
        params.addElement(new LongValue(now));
        params.addElement(new StringValue((String) Average.getAttribute("unit")));

//

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertAverageUnitSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            //
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

    public boolean saveEquipReading(WebBusinessObject Average, HttpSession s, long now) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        //WebBusinessObject project = (WebBusinessObject) wbo;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        //params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) Average.getAttribute("current_Reading")));
        params.addElement(new StringValue((String) Average.getAttribute("current_Reading")));
        params.addElement(new LongValue(now));
        params.addElement(new StringValue((String) Average.getAttribute("description")));
        params.addElement(new LongValue(now));
        params.addElement(new StringValue((String) Average.getAttribute("unit")));

//

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertAverageUnitSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            //
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

    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }

        return cashedData;
    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("empName"));
        }

        return cashedData;
    }

    public boolean updateAverage(WebBusinessObject Average, WebBusinessObject updateAverage, String prevDate, long now) {

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        int currentRead;
        int currentReadOld;
        int total;
        currentReadOld = new Integer(updateAverage.getAttribute("current_Reading").toString()).intValue();
        total = new Integer(updateAverage.getAttribute("acual_Reading").toString()).intValue();
        currentRead = new Integer(Average.getAttribute("current_Reading").toString()).intValue();
//        if (currentReadOld >= currentRead){
//
//        }else {

        params.addElement(new IntValue(currentRead));
        params.addElement(new IntValue(total + currentRead));
        params.addElement(new LongValue(now));
        params.addElement(new StringValue((String) Average.getAttribute("description")));
        params.addElement(new StringValue(prevDate));
        params.addElement(new StringValue((String) updateAverage.getAttribute("id")));



//        }
//        params.addElement(new StringValue((String)employee.getAttribute("employeeId")));


        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateAverageUnitSQL").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

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

    public boolean updateAverageConten(WebBusinessObject Average, WebBusinessObject updateAverage, String prevDate, long now, long size) {

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        long currentRead;
        int currentReadOld;
        int total;
        long counter;
        currentReadOld = new Integer(updateAverage.getAttribute("current_Reading").toString()).intValue();
        total = new Integer(updateAverage.getAttribute("acual_Reading").toString()).intValue();
        currentRead = new Integer(Average.getAttribute("current_Reading").toString()).intValue();
        counter = currentRead * size;
//        if (currentReadOld >= currentRead){
//
//        }else {

        params.addElement(new LongValue(currentRead));
        params.addElement(new LongValue(counter + total));
        params.addElement(new LongValue(now));
        params.addElement(new StringValue((String) Average.getAttribute("description")));
        params.addElement(new StringValue(prevDate));
        params.addElement(new StringValue((String) updateAverage.getAttribute("id")));



//        }
//        params.addElement(new StringValue((String)employee.getAttribute("employeeId")));


        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateAverageUnitSQL").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

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

    public Vector getAllItems() {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("selectAllAverage").trim());
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

    public String getTrueUpdate(String categoryId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(categoryId));

        Connection connection = null;
        String total = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getTrueUpdate").trim());

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
                total = r.getString(1);
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

        return total;

    }

    public Vector getAllItems(String categoryId) {
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(categoryId));
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer("SELECT * FROM maintenance_item WHERE CATEGORY_ID = ?");
//        query.append(sSearch);
//        query.append("%'");

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

    public String getDepartmentId(String department) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(department));

        Connection connection = null;
        String departmentId = null;

        StringBuffer query = new StringBuffer("SELECT DEPARTMENT_ID FROM department WHERE DEPARTMENT_NAME = ? ");

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
                departmentId = r.getString(1);
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

        return departmentId;

    }

    public boolean getActiveItem(String itemID) throws Exception {
        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(itemID));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery("SELECT * FROM quantified_mntence WHERE ITEM_ID = ?");
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

    public boolean checkDateUnit(String id) throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("checkDateUnit").trim());
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

    public Vector getScheduleByMainType(String categoryId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(categoryId));
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getScheduleByMainType").trim());
//        query.append(sSearch);
//        query.append("%'");

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

    public Vector getAllReadingForEquipment(String unitId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(unitId));
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getAllReadingForEquipment").trim());
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
    public String prevDate(String id) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(id));

        Connection connection = null;
        String enteryDate = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("prevDate").trim());

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
                enteryDate = r.getString(1);
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

        return enteryDate;

    }

    public boolean checkUnit(String id) throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("checkUnit").trim());
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

    public boolean checkEquipStatus(String id) {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("checkEquipStatus").trim());
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

    public boolean updateReadingRateUnitAsIssue(WebBusinessObject wboReadingRateUnit ) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) wboReadingRateUnit.getAttribute("issueId")));
        params.addElement(new StringValue((String) wboReadingRateUnit.getAttribute("unitId")));
        params.addElement(new StringValue((String) wboReadingRateUnit.getAttribute("readingCounter")));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("updateReadingRateByJO").trim());
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
    
    public String getReadingCounter(String issueId) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Vector queryResult = new Vector();

        params.addElement(new StringValue(issueId));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("selectReadingByJO").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeQuery();
            if(queryResult.size() > 0){
                Row row = (Row) queryResult.get(0);
                return row.getString("counter");
            }
        } catch (Exception se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }
        return null;
    }
    
    public Vector getHistoryReadingCounter(String unitId ,String stbeginDate ,String stendDate) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Vector queryResult = new Vector();

        DateParser parser = new DateParser();
        java.sql.Date beginDate,endDate;
        beginDate = parser.formatSqlDate(stbeginDate);
        endDate = parser.formatSqlDate(stendDate);
        // to get add one day to get at the same name
        endDate.setDate(endDate.getDate() + 1);

        long longBeginDate = beginDate.getTime();
        long longEndDate = endDate.getTime();

        params.addElement(new StringValue(unitId));
        params.addElement(new StringValue(String.valueOf(longBeginDate)));
        params.addElement(new StringValue(String.valueOf(longEndDate)));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("selectReadingRateByEquipment").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeQuery();
        } catch (Exception se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultAsBus = new Vector();
        WebBusinessObject wbo;
        Row row;
        for (int i = 0; i < queryResult.size(); i++) {
            row = (Row) queryResult.get(i);
            wbo = fabricateBusObj(row);
            resultAsBus.add(wbo);
        }

        return resultAsBus;
    }

    public Connection getDatabaseConnection() throws SQLException {
        return dataSource.getConnection();
    }

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
}
