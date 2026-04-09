package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.util.*;

import java.util.*;
import java.text.*;
import java.sql.*;

import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

public class ScheduleItemMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static ScheduleItemMgr scheduleItemMgr = new ScheduleItemMgr();

    public ScheduleItemMgr() {
    }

    public static ScheduleItemMgr getInstance() {
        logger.info("Getting ScheduleItemMgr Instance ....");
        return scheduleItemMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("schedule_item.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(HttpServletRequest request, String scheduleId) throws SQLException {

        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;


        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertScheduleItemSQL").trim());

            String[] sDescription = request.getParameterValues("description");
            for (int i = 0; i < sDescription.length; i++) {
                Vector params = new Vector();
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(scheduleId));
                params.addElement(new StringValue(sDescription[i]));

                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
            }

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

    public boolean updateObject(HttpServletRequest request, String scheduleId) throws SQLException {

        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;


        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("updateScheduleItemSQL").trim());

            String[] sDescription = request.getParameterValues("description");
            String[] sID = request.getParameterValues("itemID");
            for (int i = 0; i < sID.length; i++) {
                Vector params = new Vector();
                params.addElement(new StringValue(sDescription[i]));
                params.addElement(new StringValue(sID[i]));
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
            }

            forInsert.setSQLQuery(sqlMgr.getSql("insertScheduleItemSQL").trim());

            for (int i = sID.length; i < sDescription.length; i++) {
                Vector params = new Vector();
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(scheduleId));
                params.addElement(new StringValue(sDescription[i]));

                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
            }

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

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("description"));
        }

        return cashedData;
    }

    public ArrayList getCashedTableAsBusObjects() {
        return null;
    }

    public boolean hasList(String scheduleId) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("hasListSQL").trim());
        Vector params = new Vector();
        params.addElement(new StringValue(scheduleId));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
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
        return queryResult.size() > 0;
    }

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
}
