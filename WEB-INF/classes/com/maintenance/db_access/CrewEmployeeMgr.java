package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class CrewEmployeeMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static CrewEmployeeMgr crewEmployeeMgr = new CrewEmployeeMgr();

    public static CrewEmployeeMgr getInstance() {
        logger.info("Getting CrewEmployeeMgr Instance ....");
        return crewEmployeeMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("crew_employee.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveCrewEmployee(HttpServletRequest request, HttpSession s, String staff) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        String query = sqlMgr.getSql("insertCrewEmployee").trim();


        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
//        String staffcode = null;


        Connection connection = null;
        try {
//            for(int i = 0; i < staff.length; i++){
//                for(int x = 0; x < leader.length; x++){
            Vector params = new Vector();
            params.addElement(new StringValue(UniqueIDGen.getNextID()));
            params.addElement(new StringValue(request.getParameter("staffCode")));
//                staffcode = staff[i];
            params.addElement(new StringValue(staff));
            params.addElement(new StringValue((String) waUser.getAttribute("userId")));
            // params.addElement(new StringValue(leader[i]));




            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(query);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }
//            } 
//        }
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

    public boolean saveCrewFlag(HttpServletRequest request, HttpSession s, String staff) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        
        String query = sqlMgr.getSql("UpdateCrewFlag").trim();

        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
//        String staffcode = null;


        Connection connection = null;
        try {
            Vector params = new Vector();
            params.addElement(new StringValue("1"));
            params.addElement(new StringValue(request.getParameter("staffCode")));

            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(query);
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

    public boolean updateCrew(HttpServletRequest request) throws NoUserInSessionException {
//        
//
//        Vector params = new Vector();
//        SQLCommandBean forUpdate = new SQLCommandBean();
//        int queryResult = -1000;
//        params.addElement(new StringValue(request.getParameter("crewCode")));
//        params.addElement(new StringValue(request.getParameter("missionDesc")));
//        params.addElement(new StringValue(request.getParameter("typicalDuration")));
//        params.addElement(new StringValue(request.getParameter("typicalCost")));
//        params.addElement(new StringValue(request.getParameter("crewName")));
//        params.addElement(new StringValue(request.getParameter("crewID")));
//
//        Connection connection = null;
//        try {
//            connection = dataSource.getConnection();
//            forUpdate.setConnection(connection);
//            forUpdate.setSQLQuery(sqlMgr.getSql("updateCrewMission").trim());
//            forUpdate.setparams(params);
//            queryResult = forUpdate.executeUpdate();
//
//            cashData();
//        } catch(SQLException se) {
//            logger.error("Exception updating project: " + se.getMessage());
//            return false;
//        } finally {
//            try {
//                connection.close();
//            } catch(SQLException ex) {
//                return false;
//            }
//        }
//
//        return (queryResult > 0);
        return false;
    }

    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        if (cashedTable != null) {
            for (int i = 0; i < cashedTable.size(); i++) {
                wbo = (WebBusinessObject) cashedTable.elementAt(i);
                cashedData.add((String) wbo.getAttribute("crewID"));
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

    public boolean hasStaff(String crewID) throws Exception {

        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new StringValue(crewID));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectHasStaff").trim().replace("$", "'" + crewID + "'"));
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {

        } catch (UnsupportedTypeException uste) {
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                return false;
            }
        }

        return queryResult.size() > 0;
    }

    public Vector getStaffCode(String categoryId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(categoryId));
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getStaffCode").trim());
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

//    public Vector getActiveLeader(String categoryId){
//        
//        Vector SQLparams = new  Vector();
//        SQLparams.addElement(new StringValue(categoryId));
//       
//        WebBusinessObject wbo = new WebBusinessObject();
//        Connection connection = null;
//        StringBuffer query = new StringBuffer("SELECT * FROM CREW_STAFF_ID WHERE CREW_STAFF_ID = ? AND LEADER ='1'");
////        query.append(sSearch);
////        query.append("%'");
//        
//        Vector queryResult = null;
//        SQLCommandBean forQuery = new SQLCommandBean();
//        try {
//            connection= dataSource.getConnection();
//            forQuery.setConnection(connection);
//            forQuery.setSQLQuery(query.toString());
//            forQuery.setparams(SQLparams);
//            queryResult = forQuery.executeQuery();
//            
//            
//        } catch(SQLException se) {
//            logger.error("SQL Exception  " + se.getMessage());
//        }
//        
//        catch(UnsupportedTypeException uste) {
//            logger.error("***** " + uste.getMessage());
//        } finally {
//            try {
//                connection.close();
//            } catch(SQLException ex) {
//                logger.error("Close Error");
//            }
//        }
//        
//        Vector resultBusObjs = new Vector();
//        
//        Row r = null;
//        Enumeration e = queryResult.elements();
//        while(e.hasMoreElements()) {
//            r = (Row) e.nextElement();
//            wbo = new WebBusinessObject();
//            wbo = fabricateBusObj(r);
//            resultBusObjs.add(wbo);
//        }
//        return resultBusObjs;
// 
//    }
    public boolean getActiveLeader(String categoryId, String empId) throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(categoryId));
        SQLparams.addElement(new StringValue(empId));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery("SELECT * FROM crew_employee WHERE CREW_STAFF_ID = ? AND EMPLOYEE_ID = ? AND LEADER ='1'");
//    );
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

    public boolean getActiveCrew(String categoryId) throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(categoryId));

        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery("SELECT * FROM crew_employee WHERE CREW_STAFF_ID = ?");
//    );
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

    public boolean UpdateStaffFlag(String Id) throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue("0"));
        SQLparams.addElement(new StringValue(Id));

        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("UpdateStaffFlag").trim());
//    );
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
        return; //throw new UnsupportedOperationException("Not supported yet.");
    }
}
