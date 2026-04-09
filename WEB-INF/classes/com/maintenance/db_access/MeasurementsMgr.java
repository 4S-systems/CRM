/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author khaled abdo
 */
public class MeasurementsMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static MeasurementsMgr measureMgr = new MeasurementsMgr();

    public MeasurementsMgr() {
    }

    public static MeasurementsMgr getInstance() {
        System.out.println("Getting MeasureMgr Instance ....");
        return measureMgr;

    }

    protected void initSupportedForm() {
        if (supportedForm == null) {
            try {
                System.out.println("MeasureMgr ..***********.trying to get the XML file from path:: " + webInfPath);
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("Measurements.xml")));
            } catch (Exception e) {
                System.out.println("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(HttpServletRequest request, HttpSession s) throws NoUserInSessionException {

        WebBusinessObject loguser = (WebBusinessObject) s.getAttribute("loggedUser");
        loguser.printSelf();
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) request.getParameter("arDesc")));
        params.addElement(new StringValue((String) request.getParameter("enDesc")));
        params.addElement(new StringValue((String) request.getParameter("code")));
        params.addElement(new StringValue((String) request.getParameter("minAllow")));
        params.addElement(new StringValue((String) request.getParameter("maxAllow")));
        params.addElement(new StringValue((String) request.getParameter("action_Taken_Before_Allow")));
        params.addElement(new StringValue((String) request.getParameter("action_Taken_Above_Allow")));
        params.addElement(new StringValue((String) request.getParameter("measurementUnitId")));
        params.addElement(new StringValue((String) request.getParameter("frequency")));
        params.addElement(new StringValue((String) loguser.getAttribute("userId")));


        Connection connection = null;
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertData").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
        }

        return (queryResult > 0);
    }

    public boolean updateObject(HttpServletRequest request, HttpSession s) throws NoUserInSessionException {

        WebBusinessObject loguser = (WebBusinessObject) s.getAttribute("loggedUser");
        loguser.printSelf();
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) request.getParameter("arDesc")));
        params.addElement(new StringValue((String) request.getParameter("enDesc")));
        params.addElement(new StringValue((String) request.getParameter("code")));
        params.addElement(new StringValue((String) request.getParameter("minAllow")));
        params.addElement(new StringValue((String) request.getParameter("maxAllow")));
        params.addElement(new StringValue((String) request.getParameter("action_Taken_Before_Allow")));
        params.addElement(new StringValue((String) request.getParameter("action_Taken_Above_Allow")));
        params.addElement(new StringValue((String) request.getParameter("frequency")));
        params.addElement(new StringValue((String) request.getParameter("measurementUnitId")));
        params.addElement(new StringValue((String) request.getParameter("id")));


        Connection connection = null;
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("updateObject").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
        }

        return (queryResult > 0);
    }

    public ArrayList getAllAsArrayList() {
        super.cashData();
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }

        return cashedData;

    }
    /*public String getMeasureName(String id) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Vector queryResult = new Vector();

        params.addElement(new StringValue(id));


        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("getMeasureName").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeQuery();

            return ((Row) queryResult.get(0)).getString("base");

        } catch (Exception se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        return "";
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
            cashedData.add((String) wbo.getAttribute("Base"));
        }

        return cashedData;
    }

    public Vector getAllAsVector() {
        super.cashData();
        return cashedTable;
    }

    public ArrayList getAllAsArrayList() {
        super.cashData();
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }

        return cashedData;

    }

    public Vector getMeasurmentName(String id) {
        Vector returned_Codes = new Vector();
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Connection connection = null;
        try {
            params.addElement(new StringValue(id));
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("getSpecificMeasureName").trim());
            forInsert.setparams(params);
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

        for (int i = 0; i < returned_Codes.size(); i++) {
            row = (Row) returned_Codes.get(i);
            wbo = super.fabricateBusObj(row);
            resAsWeb.add(wbo);
        }
        return resAsWeb;
    }
*/
    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }
}
