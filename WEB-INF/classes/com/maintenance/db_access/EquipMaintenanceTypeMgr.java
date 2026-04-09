package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import com.silkworm.util.*;
import java.util.*;
import java.text.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import com.tracker.common.*;
//import com.tracker.app_constants.ProjectConstants;

import com.tracker.business_objects.*;
import org.apache.log4j.xml.DOMConfigurator;

public class EquipMaintenanceTypeMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static EquipMaintenanceTypeMgr equipMaintenanceTypeMgr = new EquipMaintenanceTypeMgr();

//    private static final String insertfailureSQL = "INSERT INTO failure_code VALUES (?,?,now(),?,?)";
//    private static final String updatefailureSQL = "UPDATE failure_code SET TITLE = ?, CREATION_TIME = now(), CREATED_BY = ?, DESCRIPTION = ?  WHERE ID = ?";
    public EquipMaintenanceTypeMgr() {
    }

    public static EquipMaintenanceTypeMgr getInstance() {
        logger.info("Getting EquipMaintenanceTypeMgr Instance ....");
        return equipMaintenanceTypeMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("equip_mntnce_type.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(WebBusinessObject mainType, HttpSession s) throws NoUserInSessionException {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        //WebBusinessObject project = (WebBusinessObject) wbo;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        //params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) mainType.getAttribute("typeName")));
        params.addElement(new StringValue((String) mainType.getAttribute("categoryId")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));



        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertMainTypeSQL").trim());
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

    public ArrayList getCrewCodeAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            try {
//            if(wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")) {
                if (getCrewCodeforAssigne(wbo.getAttribute("id").toString())) {
                    cashedData.add(wbo);
                }
            } catch (Exception ex) {
                logger.error(ex.getMessage());
            }
        }

        return cashedData;
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
            cashedData.add((String) wbo.getAttribute("code"));
        }

        return cashedData;
    }

    public boolean updateMainType(WebBusinessObject mainType, HttpSession s) {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) mainType.getAttribute("typeName")));
        params.addElement(new StringValue((String) mainType.getAttribute("categoryId")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) mainType.getAttribute("typeId")));


        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateMainTypeSQL").trim());
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

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllFailure").trim());
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

    public boolean getActiveStaffCode(String categoryID) throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(categoryID));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getActiveStaffCode").trim());
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

    public boolean getSaveStaff(String staffCode) throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;

        SQLparams.addElement(new StringValue(staffCode));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getSaveStaff").trim());
//            forQuery.setSQLQuery("SELECT * FROM crew_employee WHERE CREW_ID = ? AND STAFF_CODE = ?");

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

    public boolean getCrewCodeforAssigne(String crewCode) throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;

        SQLparams.addElement(new StringValue(crewCode));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
//            forQuery.setSQLQuery(sqlMgr.getSql("getSaveStaff").trim());
            forQuery.setSQLQuery("SELECT * FROM crew_employee WHERE CREW_STAFF_ID = ?");

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

    public boolean getActiveMainType(String periodicID) throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(periodicID));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getActiveMainType").trim());
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

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
