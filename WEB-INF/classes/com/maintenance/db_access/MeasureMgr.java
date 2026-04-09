package com.maintenance.db_access;

import com.maintenance.common.Tools;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.persistence.relational.StringValue;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
import java.sql.*;
import java.text.SimpleDateFormat;
import org.apache.log4j.xml.DOMConfigurator;

public class MeasureMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static MeasureMgr measureMgr = new MeasureMgr();

    public MeasureMgr() {
    }

    public static MeasureMgr getInstance() {
        logger.info("Getting measureMgr Instance ....");
        return measureMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("task.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(WebBusinessObject task, HttpSession s) throws NoUserInSessionException {
//       String  inserttaskSQL = " INSERT INTO TASKS VALUES (?,?,?,SYSDATE,?,'NONE')";
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        //WebBusinessObject project = (WebBusinessObject) wbo;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        //params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) task.getAttribute("title")));
        params.addElement(new StringValue((String) task.getAttribute("name")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) task.getAttribute("tradeName")));
        params.addElement(new StringValue((String) task.getAttribute("executionHrs")));
        params.addElement(new StringValue((String) task.getAttribute("empTitle")));
        params.addElement(new StringValue((String) task.getAttribute("taskType")));
        params.addElement(new StringValue((String) task.getAttribute("taskTitle")));
        params.addElement(new StringValue((String) task.getAttribute("categoryName")));
        params.addElement(new StringValue((String) task.getAttribute("jobzise")));
        params.addElement(new StringValue((String) task.getAttribute("engDesc")));


        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertTasksSQL").trim());
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

    public String saveTask(WebBusinessObject task, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String id = UniqueIDGen.getNextID();
        params.addElement(new StringValue(id));
        params.addElement(new StringValue((String) task.getAttribute("title")));
        params.addElement(new StringValue((String) task.getAttribute("name")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) task.getAttribute("tradeName")));
        params.addElement(new StringValue((String) task.getAttribute("executionHrs")));
        params.addElement(new StringValue((String) task.getAttribute("empTitle")));
        params.addElement(new StringValue((String) task.getAttribute("taskType")));
        params.addElement(new StringValue((String) task.getAttribute("taskTitle")));
        params.addElement(new StringValue((String) task.getAttribute("categoryName")));
        params.addElement(new StringValue((String) task.getAttribute("jobzise")));
        params.addElement(new StringValue((String) task.getAttribute("engDesc")));
        params.addElement(new StringValue((String) task.getAttribute("mainTypeId")));
        params.addElement(new StringValue((String) task.getAttribute("isMain")));
        params.addElement(new StringValue((String) task.getAttribute("costHour")));


        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertTasksSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            //
            cashData();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return null;
            }
        }
        if (queryResult > 0) {
            return id;
        } else {
            return null;
        }
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
            cashedData.add((String) wbo.getAttribute("title"));
        }

        return cashedData;
    }

    public boolean updatetaskCode(WebBusinessObject task, HttpSession s) {

//        String updatetaskSQL="UPDATE tasks SET TASK_NAME = ? , CREATED_BY = ? , CODE= ? WHERE ID = ? ";
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String isMain = (String) task.getAttribute("isMain");
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue((String) task.getAttribute("name")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) task.getAttribute("title")));
        params.addElement(new StringValue((String) task.getAttribute("tradeName")));
        params.addElement(new StringValue((String) task.getAttribute("executionHrs")));
        params.addElement(new StringValue((String) task.getAttribute("empTitle")));
        params.addElement(new StringValue((String) task.getAttribute("taskType")));
        params.addElement(new StringValue((String) task.getAttribute("taskTitle")));

        if (isMain.equals("yes")) {
            params.addElement(new StringValue((String) task.getAttribute("mainTypeId")));
            params.addElement(new StringValue(("")));

        } else {
            params.addElement(new StringValue(("")));
            params.addElement(new StringValue((String) task.getAttribute("categoryName")));

        }

        params.addElement(new StringValue((String) task.getAttribute("engDesc")));
        params.addElement(new StringValue((String) task.getAttribute("costHour")));
        params.addElement(new StringValue((String) task.getAttribute("taskId")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateTasksSQL").trim());
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

    public Vector getAllItems() {
        String qury = "SELECT * FROM TASKS";
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(qury.trim());
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

    public Vector getAllItems(String categoryId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(categoryId));
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllItemsById").trim());
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

    public Vector getAllItemsByDate(String beginDate, String endDate) {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        try {
            java.util.Date dateBeg = sdf.parse(beginDate);
            java.util.Date dateEnd = sdf.parse(endDate);
            java.sql.Date beginDatesql = new java.sql.Date(dateBeg.getTime());
            java.sql.Date endDatesql = new java.sql.Date(dateEnd.getTime());
            SQLparams.addElement(new DateValue(beginDatesql));
            SQLparams.addElement(new DateValue(endDatesql));
        } catch (Exception e) {
        }


        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllItemsByDate").trim());

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

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getDepartmentId").trim());

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
            forQuery.setSQLQuery(sqlMgr.getSql("getActiveItemFailure").trim());
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

    public boolean getActiveFailure(String categoryID) throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(categoryID));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getActiveFailure").trim());
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

    public String getFailureId(String failureCodeName) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(failureCodeName));

        Connection connection = null;
        String Id = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getFailureId").trim());

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
                Id = r.getString(1);
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

        return Id;

    }
    ///////////////////////////////////////////////////////////

    public boolean catogeryHasTask(String unitID) {
        Connection connection = null;

        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(unitID));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("CategoryTasks").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        return queryResult.size() > 0;
    }
    /////////////////////////////////////////////////////

    public boolean DelAllJobOrder(int i) throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
//        SQLparams.addElement(new StringValue(categoryID));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("del" + i).trim());
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

    public boolean DelScheduleConfigure(int i) throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
//        SQLparams.addElement(new StringValue(categoryID));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("delconf" + i).trim());
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

    public String getAllUnitSheduleForIssue(String id) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(id));

        Connection connection = null;
        String Id = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllUnitSheduleForIssue").trim());

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
                Id = r.getString(1);
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

        return Id;

    }

    public Vector getAllUnitSheduleForEquip(String id) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(id));
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllUnitSheduleForEquip").trim());
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

    public boolean getEMG(String id) throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getEMG").trim());
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

    public boolean DelQuanEmg(String id) throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("DelQuanEmg").trim());
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

    public boolean getDOC(String id) throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getDOC").trim());
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

    public boolean DelDocEmg(String id) throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("DelDocEmg").trim());
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

    public boolean DelStatusEmg() throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;

        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("DelStatusEmg").trim());
//

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

    public boolean DelIssueEmg() throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;

        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("DelIssueEmg").trim());


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

    public boolean DelUnitSchEmg() throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;

        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("DelUnitSchEmg").trim());


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

    public Vector getIssueEmg() {

        Vector SQLparams = new Vector();
//        SQLparams.addElement(new StringValue(id));
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getIssueEmg").trim());
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

    public boolean DelAcualEmg(String id) throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(id));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("DelAcualEmg").trim());
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

    public Vector getUnitSchEmg() {

        Vector SQLparams = new Vector();
//        SQLparams.addElement(new StringValue(id));
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getUnitSchEmg").trim());
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

    public boolean getActiveTask(String categoryID) throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(categoryID));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getActiveTask").trim());
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

    public String getTotalTasks(String categoryId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(categoryId));

        Connection connection = null;
        String total = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getTotalTasks").trim());

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

    public String getTotalTasksByTrade(String tradeId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(tradeId));

        Connection connection = null;
        String total = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getTotalTasksByTrade").trim());

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

    public Vector getAllTasksByCategory(String categoryId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(categoryId));
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllTasksByCategory").trim());
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

    public Vector getItemRecord(String query, String Id) {

        Connection connection = null;
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(Id));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        WebBusinessObject result = null;

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            result = (WebBusinessObject) fabricateBusObj(r);
            reultBusObjs.add(result);
        }
        return reultBusObjs;
    }

    public Vector getItemRecordAll(String query) {

        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        WebBusinessObject result = null;

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            result = (WebBusinessObject) fabricateBusObj(r);
            reultBusObjs.add(result);
        }
        return reultBusObjs;
    }

    public Vector getTasksBySubName(String name, String Type) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        String query = "";


        if (Type.equalsIgnoreCase("name")) {
            query = sqlMgr.getSql("getTasksBySubName").trim().replaceAll("ppp", name);
        } else {
            query = sqlMgr.getSql("getTasksBySubCode").trim().replaceAll("ppp", name);
        }


        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            //  forQuery.setparams(SQLparams);
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
    /////////////////////End//////////////////////

    public Vector getTasksBySubName(String name) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        String query = "";


        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getTasksBySubName").trim().replaceAll("ppp", name));
            //  forQuery.setparams(SQLparams);
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

    public Vector getTasksBySubCode(String code) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getTasksBySubCode").trim().replaceAll("ppp", code));
            //  forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
            System.out.println(queryResult);
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

    public Vector getTasksbyParentSorting(String parentId) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getTasksbyParentSorting").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(parentId));
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

    public Vector getTasksByBasicTypeSorting(String parentId) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getTasksByBasicTypeSorting").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(parentId));
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

    public String getCostTaskHour(String taskId) {
        WebBusinessObject wboTask = measureMgr.getOnSingleKey(taskId);

        if (wboTask != null) {
            return (String) wboTask.getAttribute("costHour");
        }

        return "0";
    }

    public Vector maintenanceOperationAnalysisTotaly(WebBusinessObject wbo) {
        Connection connection = null;
        StringBuilder query = new StringBuilder("SELECT LABOR_COST.*, COST_SPARE_PARTS_TASK.COST_PARTS FROM (SELECT TASKS.ID, TASKS.CODE, TASKS.TASK_NAME, COUNT(ISSUE.ID) AS TASK_NUMBER, SUM(ISSUE_TASKS.TOTAL_COST_TASK) AS COST_LABOR FROM TASKS JOIN ISSUE_TASKS "
                + "ON TASKS.ID = ISSUE_TASKS.CODE_TASK "
                + "JOIN ISSUE "
                + "ON ISSUE_TASKS.ISSUE_ID = ISSUE.ID "
                + "JOIN MAINTAINABLE_UNIT "
                + "ON MAINTAINABLE_UNIT.ID = ISSUE.UNIT_ID "
                + "WHERE ");
        if (wbo.getAttribute("mainTaypeValues") != null) {
            query.append("MAINTAINABLE_UNIT.MAIN_TYPE_ID IN ( ").append(Tools.concatenation((String[]) wbo.getAttribute("mainTaypeValues"), ",")).append(" )");
            query.append(" AND ");
        } else if (wbo.getAttribute("unitId") != null) {
            query.append("MAINTAINABLE_UNIT.ID = ");
            query.append("'").append(wbo.getAttribute("unitId").toString()).append("'");
            query.append(" AND ");
        } else if (wbo.getAttribute("brand") != null) {
            query.append("MAINTAINABLE_UNIT.PARENT_ID IN ( ").append(Tools.concatenation((String[]) wbo.getAttribute("brand"), ",")).append(" )");
            query.append(" AND ");
        }

        query.append(" ISSUE.CURRENT_STATUS IN ( ").append(Tools.concatenation((String[]) wbo.getAttribute("issueStatus"), ",")).append(" )");
        query.append(" AND ");
        query.append("ISSUE.EXPECTED_B_DATE BETWEEN to_date('SSSSS 00:00:00', 'YYYY-MM-DD HH24:MI:SS') AND "
                + "to_date('EEEEE 00:00:00', 'YYYY-MM-DD HH24:MI:SS') ");
        wbo.getAttribute("beginDate").toString();
        wbo.getAttribute("endDate").toString();
        if (!wbo.getAttribute("issueTitle").toString().equalsIgnoreCase("both")) {
            query.append(" AND ");
            query.append("ISSUE.ISSUE_TITLE");
            if (wbo.getAttribute("issueTitle").toString().equalsIgnoreCase("Emergency")) {
                query.append(" = ");
            } else {
                query.append(" != ");
            }
            query.append("'Emergency'");
        }

        query.append(" AND ");
        query.append("ISSUE.PROJECT_NAME IN ( ").append(Tools.concatenation((String[]) wbo.getAttribute("sitesValues"), ",")).append(" )");
        query.append(" AND ");
        query.append("ISSUE.WORK_ORDER_TRADE IN ( ").append(Tools.concatenation((String[]) wbo.getAttribute("tradeValues"), ",")).append(" )");
        query.append(" GROUP BY TASKS.ID, TASKS.CODE, TASKS.TASK_NAME ) LABOR_COST FULL JOIN COST_SPARE_PARTS_TASK ON LABOR_COST.ID = COST_SPARE_PARTS_TASK.ID WHERE LABOR_COST.ID IS NOT NULL");

        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString().trim().replaceAll("SSSSS", wbo.getAttribute("beginDate").toString()).replaceAll("EEEEE", wbo.getAttribute("endDate").toString()));
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
            wbo = new WebBusinessObject();
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                wbo.setAttribute("taskNumber", r.getBigDecimal("TASK_NUMBER"));
            } catch (Exception ex) {
            }
            try {
                wbo.setAttribute("costLabor", r.getBigDecimal("COST_LABOR").toString());
            } catch (Exception ex) {
                wbo.setAttribute("costLabor", "0");
            }
            try {
                wbo.setAttribute("costParts", r.getBigDecimal("COST_PARTS").toString());
            } catch (Exception ex) {
                wbo.setAttribute("costParts", "0");
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector maintenanceOperationAnalysisDetailed(WebBusinessObject wbo) {
        Connection connection = null;
        StringBuilder query = new StringBuilder("SELECT LABOR_COST.*, COST_SPARE_PARTS_TASK.COST_PARTS FROM (SELECT TASKS.ID, TASKS.CODE, MAINTAINABLE_UNIT.UNIT_NAME, TASKS.TASK_NAME, COUNT(ISSUE.ID) AS TASK_NUMBER, SUM(ISSUE_TASKS.TOTAL_COST_TASK) AS COST_LABOR FROM TASKS JOIN ISSUE_TASKS "
                + "ON TASKS.ID = ISSUE_TASKS.CODE_TASK "
                + "JOIN ISSUE "
                + "ON ISSUE_TASKS.ISSUE_ID = ISSUE.ID "
                + "JOIN MAINTAINABLE_UNIT "
                + "ON MAINTAINABLE_UNIT.ID = ISSUE.UNIT_ID "
                + "WHERE ");
        if (wbo.getAttribute("mainTaypeValues") != null) {
            query.append("MAINTAINABLE_UNIT.MAIN_TYPE_ID IN ( ").append(Tools.concatenation((String[]) wbo.getAttribute("mainTaypeValues"), ",")).append(" )");
            query.append(" AND ");
        } else if (wbo.getAttribute("unitId") != null) {
            query.append("MAINTAINABLE_UNIT.ID = ");
            query.append("'").append(wbo.getAttribute("unitId").toString()).append("'");
            query.append(" AND ");
        } else if (wbo.getAttribute("brand") != null) {
            query.append("MAINTAINABLE_UNIT.PARENT_ID IN ( ").append(Tools.concatenation((String[]) wbo.getAttribute("brand"), ",")).append(" )");
            query.append(" AND ");
        }

        query.append(" ISSUE.CURRENT_STATUS IN ( ").append(Tools.concatenation((String[]) wbo.getAttribute("issueStatus"), ",")).append(" )");
        query.append(" AND ");
        query.append("ISSUE.EXPECTED_B_DATE BETWEEN to_date('SSSSS 00:00:00', 'YYYY-MM-DD HH24:MI:SS') AND "
                + "to_date('EEEEE 00:00:00', 'YYYY-MM-DD HH24:MI:SS') ");
        wbo.getAttribute("beginDate").toString();
        wbo.getAttribute("endDate").toString();
        if (!wbo.getAttribute("issueTitle").toString().equalsIgnoreCase("both")) {
            query.append(" AND ");
            query.append("ISSUE.ISSUE_TITLE");
            if (wbo.getAttribute("issueTitle").toString().equalsIgnoreCase("Emergency")) {
                query.append(" = ");
            } else {
                query.append(" != ");
            }
            query.append("'Emergency'");
        }

        query.append(" AND ");
        query.append("ISSUE.PROJECT_NAME IN ( ").append(Tools.concatenation((String[]) wbo.getAttribute("sitesValues"), ",")).append(" )");
        query.append(" AND ");
        query.append("ISSUE.WORK_ORDER_TRADE IN ( ").append(Tools.concatenation((String[]) wbo.getAttribute("tradeValues"), ",")).append(" )");
        query.append(" GROUP BY TASKS.ID, TASKS.CODE, TASKS.TASK_NAME, MAINTAINABLE_UNIT.UNIT_NAME ) LABOR_COST FULL JOIN COST_SPARE_PARTS_TASK ON LABOR_COST.ID = COST_SPARE_PARTS_TASK.ID WHERE LABOR_COST.ID IS NOT NULL");

        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString().trim().replaceAll("SSSSS", wbo.getAttribute("beginDate").toString()).replaceAll("EEEEE", wbo.getAttribute("endDate").toString()));
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
            wbo = new WebBusinessObject();
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                wbo.setAttribute("taskNumber", r.getBigDecimal("TASK_NUMBER"));
            } catch (Exception ex) {
            }
            try {
                wbo.setAttribute("costLabor", r.getBigDecimal("COST_LABOR").toString());
            } catch (Exception ex) {
                wbo.setAttribute("costLabor", "0");
            }
            try {
                wbo.setAttribute("costParts", r.getBigDecimal("COST_PARTS").toString());
            } catch (Exception ex) {
                wbo.setAttribute("costParts", "0");
            }
            try {
                wbo.setAttribute("unitName", r.getString("UNIT_NAME"));
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(MeasureMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector maintenanceOperationAnalysisAnalyised(WebBusinessObject wbo) {
        Connection connection = null;
        StringBuilder query = new StringBuilder("SELECT LABOR_COST.*, COST_SPARE_PARTS_TASK.COST_PARTS FROM (SELECT TASKS.ID, TASKS.CODE, ISSUE.BUSINESS_ID AS ISSUE_CODE, ISSUE.ACTUAL_BEGIN_DATE AS B_DATE, MAINTAINABLE_UNIT.UNIT_NAME, TASKS.TASK_NAME, COUNT(ISSUE.ID) AS TASK_NUMBER, SUM(ISSUE_TASKS.TOTAL_COST_TASK) AS COST_LABOR FROM TASKS JOIN ISSUE_TASKS "
                + "ON TASKS.ID = ISSUE_TASKS.CODE_TASK "
                + "JOIN ISSUE "
                + "ON ISSUE_TASKS.ISSUE_ID = ISSUE.ID "
                + "JOIN MAINTAINABLE_UNIT "
                + "ON MAINTAINABLE_UNIT.ID = ISSUE.UNIT_ID "
                + "WHERE ");
        if (wbo.getAttribute("mainTaypeValues") != null) {
            query.append("MAINTAINABLE_UNIT.MAIN_TYPE_ID IN ( ").append(Tools.concatenation((String[]) wbo.getAttribute("mainTaypeValues"), ",")).append(" )");
            query.append(" AND ");
        } else if (wbo.getAttribute("unitId") != null) {
            query.append("MAINTAINABLE_UNIT.ID = ");
            query.append("'").append(wbo.getAttribute("unitId").toString()).append("'");
            query.append(" AND ");
        } else if (wbo.getAttribute("brand") != null) {
            query.append("MAINTAINABLE_UNIT.PARENT_ID IN ( ").append(Tools.concatenation((String[]) wbo.getAttribute("brand"), ",")).append(" )");
            query.append(" AND ");
        }

        query.append(" ISSUE.CURRENT_STATUS IN ( ").append(Tools.concatenation((String[]) wbo.getAttribute("issueStatus"), ",")).append(" )");
        query.append(" AND ");
        query.append("ISSUE.EXPECTED_B_DATE BETWEEN to_date('SSSSS 00:00:00', 'YYYY-MM-DD HH24:MI:SS') AND "
                + "to_date('EEEEE 00:00:00', 'YYYY-MM-DD HH24:MI:SS') ");
        wbo.getAttribute("beginDate").toString();
        wbo.getAttribute("endDate").toString();
        if (!wbo.getAttribute("issueTitle").toString().equalsIgnoreCase("both")) {
            query.append(" AND ");
            query.append("ISSUE.ISSUE_TITLE");
            if (wbo.getAttribute("issueTitle").toString().equalsIgnoreCase("Emergency")) {
                query.append(" = ");
            } else {
                query.append(" != ");
            }
            query.append("'Emergency'");
        }

        query.append(" AND ");
        query.append("ISSUE.PROJECT_NAME IN ( ").append(Tools.concatenation((String[]) wbo.getAttribute("sitesValues"), ",")).append(" )");
        query.append(" AND ");
        query.append("ISSUE.WORK_ORDER_TRADE IN ( ").append(Tools.concatenation((String[]) wbo.getAttribute("tradeValues"), ",")).append(" )");
        query.append(" GROUP BY TASKS.ID, TASKS.CODE, TASKS.TASK_NAME, MAINTAINABLE_UNIT.UNIT_NAME, ISSUE.BUSINESS_ID,ISSUE.ACTUAL_BEGIN_DATE ) LABOR_COST FULL JOIN COST_SPARE_PARTS_TASK ON LABOR_COST.ID = COST_SPARE_PARTS_TASK.ID WHERE LABOR_COST.ID IS NOT NULL");

        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString().trim().replaceAll("SSSSS", wbo.getAttribute("beginDate").toString()).replaceAll("EEEEE", wbo.getAttribute("endDate").toString()));
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
            wbo = new WebBusinessObject();
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                wbo.setAttribute("taskNumber", r.getBigDecimal("TASK_NUMBER"));
            } catch (Exception ex) {
            }
            try {
                wbo.setAttribute("costLabor", r.getBigDecimal("COST_LABOR").toString());
            } catch (Exception ex) {
                wbo.setAttribute("costLabor", "0");
            }
            try {
                wbo.setAttribute("costParts", r.getBigDecimal("COST_PARTS").toString());
            } catch (Exception ex) {
                wbo.setAttribute("costParts", "0");
            }
            try {
                wbo.setAttribute("unitName", r.getString("UNIT_NAME"));
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(MeasureMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            try {
                wbo.setAttribute("issueCode", r.getString("ISSUE_CODE"));
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(MeasureMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            try {
                wbo.setAttribute("bDate", r.getDate("B_DATE").toString());
            } catch (Exception ex) {
                wbo.setAttribute("bDate", "-----");
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public String getTaskNameById(String id) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(id));

        Connection connection = null;
        String total = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getTaskNameById").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        Row r = null;
        WebBusinessObject wbo = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
        }
        return wbo.getAttribute("name").toString();

    }

    public ArrayList getTasksbyIssueId(String issueId) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getTasksbyIssueId").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(issueId));
        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

            endTransaction();

        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
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
        return Tools.toArrayList(resultBusObjs);
    }

    public Vector getTasksUnattachedToParts() {

        WebBusinessObject wbo = new WebBusinessObject();

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(getQuery("getTasksUnattachedToParts").trim());
            queryResult = forQuery.executeQuery();


        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(MeasureMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            endTransaction();
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getTasksAttachedToParts() {

        WebBusinessObject wbo = new WebBusinessObject();

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(getQuery("getTasksAttachedToParts").trim());
            queryResult = forQuery.executeQuery();


        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(MeasureMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } finally {
            endTransaction();
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }
}
