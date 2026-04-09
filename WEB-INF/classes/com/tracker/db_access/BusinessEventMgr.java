package com.tracker.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.UserMgr;
import java.sql.SQLException;
import java.util.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class BusinessEventMgr extends RDBGateWay {

    private static BusinessEventMgr businessEventMgr = new BusinessEventMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static BusinessEventMgr getInstance() {
        logger.info("Getting ClientStatusMgr Instance ....");
        return businessEventMgr;
    }

    public BusinessEventMgr() {
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("business_event.xml")));
                System.out.println("event table loaded");
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean redirectComplaint(HttpServletRequest request, HttpSession session) throws SQLException {
        WebBusinessObject waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        waUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String causedBy = (String) waUser.getAttribute("userId");
        String compId = request.getParameter("compId");
        String note = request.getParameter("note");
        String departmentId = request.getParameter("department");
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        WebBusinessObject wbo = new WebBusinessObject();
        wbo = projectMgr.getOnSingleKey("key5", causedBy);
        String currentDepartmentId;
        String distDepartmentId = null;
        String currentOwnerId = null;
        if (wbo != null) {

            currentDepartmentId = (String) wbo.getAttribute("projectID");
            wbo = new WebBusinessObject();
            wbo = projectMgr.getOnSingleKey(departmentId);
            if (wbo != null) {
                distDepartmentId = (String) wbo.getAttribute("projectID");
                currentOwnerId = (String) wbo.getAttribute("optionOne");
            }
            Vector SQLparams = new Vector();
            int queryResult = -1000;
            String id = UniqueIDGen.getNextID();
            SQLCommandBean forQuery = new SQLCommandBean();
            Connection connection = null;




            try {
                beginTransaction();
                forQuery.setConnection(transConnection);
                SQLparams.addElement(new StringValue(currentOwnerId));
                SQLparams.addElement(new StringValue(compId));

                forQuery.setSQLQuery(getQuery("updateReceipId").trim());
                forQuery.setparams(SQLparams);
                queryResult = forQuery.executeUpdate();
                if (queryResult < 0) {
                    transConnection.rollback();
                    return false;
                }
                SQLparams = new Vector();
                SQLparams.addElement(new StringValue(id));
                SQLparams.addElement(new StringValue("1"));
                SQLparams.addElement(new StringValue(compId));
                SQLparams.addElement(new StringValue("issue complaint"));
                SQLparams.addElement(new StringValue(causedBy));
                SQLparams.addElement(new StringValue(currentDepartmentId));
                SQLparams.addElement(new StringValue(distDepartmentId));
                SQLparams.addElement(new StringValue(note));

//                connection = dataSource.getConnection();

//                forQuery.setConnection(connection);
                forQuery.setSQLQuery(getQuery("insert").trim());
                forQuery.setparams(SQLparams);
                queryResult = forQuery.executeUpdate();
                if (queryResult < 0) {
                    transConnection.rollback();
                    return false;
                }



            } catch (SQLException ex) {
                logger.error("SQL Exception  " + ex.getMessage());


            } finally {
                transConnection.commit();
                endTransaction();
            }





        } else {
            return false;
        }


        return true;
    }

    public boolean redirectComplaintToEmployee(HttpServletRequest request, HttpSession session) throws SQLException {
        WebBusinessObject waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

        String compId = request.getParameter("compId");
        String empId = request.getParameter("empId");
        Vector SQLparams = new Vector();
        int queryResult = -1000;
        String id = "";
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;




        Vector queryResult2 = new Vector();
        forQuery = new SQLCommandBean();

        try {
            String query = "select max(SYS_ID) from DISTRIBUTION_LIST where CLIENT_COM_ID=" + compId;
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query);
            queryResult2 = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        }
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult2.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            try {
                id = r.getString(1);
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(BusinessEventMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

        }







        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            SQLparams.addElement(new StringValue(empId));
            SQLparams.addElement(new StringValue(id));

            UserMgr mgr = UserMgr.getInstance();
            WebBusinessObject wbo = new WebBusinessObject();
            wbo = mgr.getOnSingleKey(empId);
            String userName = (String) wbo.getAttribute("userName");
            forQuery.setSQLQuery(getQuery("updateReceipId").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
            beginTransaction();
            forQuery.setConnection(transConnection);
            SQLparams = new Vector();

            SQLparams.addElement(new StringValue(empId));
            SQLparams.addElement(new StringValue(userName));
            SQLparams.addElement(new StringValue(compId));

            forQuery.setSQLQuery(getQuery("updateOwnerId").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }

        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());


        } finally {
            transConnection.commit();
            endTransaction();
        }
        return true;
    }

    public ArrayList getCashedTableAsArrayList() {

        return null;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }
}
