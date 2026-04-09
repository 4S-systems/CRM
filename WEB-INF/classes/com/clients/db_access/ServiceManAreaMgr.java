/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.clients.db_access;

import com.maintenance.common.Tools;
import com.maintenance.db_access.ExternalJobMgr;
import com.maintenance.db_access.TradeMgr;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.common.MetaDataMgr;
import com.tracker.db_access.SequenceMgr;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import org.apache.log4j.xml.DOMConfigurator;
import org.omg.CORBA.Request;

/**
 *
 * @author Waled
 */
public class ServiceManAreaMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static ServiceManAreaMgr serviceManAreaMgr = new ServiceManAreaMgr();

    public static ServiceManAreaMgr getInstance() {
        logger.info("Getting DepartmentMgr Instance ....");
        return serviceManAreaMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("serviceman_area.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveUserArea(WebBusinessObject wbo) throws NoUserInSessionException, SQLException {

        String id = UniqueIDGen.getNextID();

        String createdBy = (String) wbo.getAttribute("createdBy");
        String userId = (String) wbo.getAttribute("userId");
        String tradesId = (String) wbo.getAttribute("tradesId");
        String notes = (String) wbo.getAttribute("notes");
        String begin_date = (String) wbo.getAttribute("begin_date");
        String end_date = (String) wbo.getAttribute("end_date");
        String areaId = (String) wbo.getAttribute("areaId");

        SimpleDateFormat formatter = new SimpleDateFormat("yyyy/M/dd hh:mm:ss");

        java.util.Date bDate = null;
        java.util.Date eDate = null;
        try {
            bDate = formatter.parse(begin_date);
            eDate = formatter.parse(end_date);
        } catch (ParseException ex) {
            Logger.getLogger(AppointmentMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        Vector params = new Vector();

        params.addElement(new StringValue(id));
        params.addElement(new StringValue(userId));
        params.addElement(new StringValue(tradesId));
        params.addElement(new TimestampValue(new Timestamp(bDate.getTime())));
        params.addElement(new TimestampValue(new Timestamp(eDate.getTime())));
        params.addElement(new StringValue(areaId));
        params.addElement(new StringValue(notes));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue(createdBy));

        Connection connection = null;
        int queryResult = -1000;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insertUserArea").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {

                return false;
            }

        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;

        } finally {
            connection.setAutoCommit(true);
            connection.close();
        }

        return (queryResult > 0);
    }

    public Vector getUserArea(String userId) throws SQLException {
        Connection connection = null;
        Vector queryResult = new Vector();
        Vector params = new Vector();
        Vector result = new Vector();
        try {
            params.addElement(new StringValue(userId));
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("getUserArea").trim());
            forInsert.setparams(params);
            try {
                queryResult = forInsert.executeQuery();
            } catch (UnsupportedTypeException ex) {
                Logger.getLogger(ServiceManAreaMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            Row r = null;
            Enumeration enumeration = queryResult.elements();
            while (enumeration.hasMoreElements()) {

                r = (Row) enumeration.nextElement();
                result.add(fabricateBusObj(r));
            }

        } catch (SQLException se) {
            logger.error(se.getMessage());
            return null;

        } finally {
            connection.setAutoCommit(true);
            connection.close();
        }
        return result;

    }

    public Vector getSupervisorArea(String area_id, String tradeId) throws SQLException {
        Connection connection = null;
        Vector queryResult = new Vector();
        Vector params = new Vector();
        Vector result = new Vector();
        try {
            params.addElement(new StringValue(area_id));
            params.addElement(new StringValue(tradeId));
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("getSupervisorArea").trim());
            forInsert.setparams(params);
            try {
                queryResult = forInsert.executeQuery();
            } catch (UnsupportedTypeException ex) {
                Logger.getLogger(ServiceManAreaMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            Row r = null;
            Enumeration enumeration = queryResult.elements();
            while (enumeration.hasMoreElements()) {

                r = (Row) enumeration.nextElement();
                result.add(fabricateBusObj(r));
            }

        } catch (SQLException se) {
            logger.error(se.getMessage());
            return null;

        } finally {
            connection.setAutoCommit(true);
            connection.close();
        }
        return result;

    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }
}
