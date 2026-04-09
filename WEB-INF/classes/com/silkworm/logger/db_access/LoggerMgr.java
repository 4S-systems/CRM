/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.silkworm.logger.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.persistence.relational.StringValue;
import java.util.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author MSaudi
 */
public class LoggerMgr extends RDBGateWay {

    private static LoggerMgr loggerMgr = new LoggerMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static LoggerMgr getInstance() {
        return loggerMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("logger.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        Connection connection = null;
        int queryResult = -1;
        Vector SQLparams = new Vector();

        SQLCommandBean forQuery = new SQLCommandBean();
        SQLparams.addElement(new StringValue(UniqueIDGen.getNextID()));
        SQLparams.addElement(new StringValue(wbo.getAttribute("objectTypeId").toString()));
        SQLparams.addElement(new StringValue(wbo.getAttribute("eventTypeId").toString()));
        SQLparams.addElement(new StringValue(wbo.getAttribute("userId").toString()));
        SQLparams.addElement(new StringValue(wbo.getAttribute("objectName").toString()));
        SQLparams.addElement(new StringValue(wbo.getAttribute("eventName").toString()));
        SQLparams.addElement(new StringValue(wbo.getAttribute("loggerMessage").toString()));
        SQLparams.addElement(new StringValue(wbo.getAttribute("objectXml").toString()));
        SQLparams.addElement(new StringValue(wbo.getAttribute("realObjectId").toString()));
        SQLparams.addElement(new StringValue((String) wbo.getAttribute("ipForClient"))); //unused field

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("insertLog").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeUpdate();
        } catch (Exception se) {
            logger.error("SQL Exception  " + se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        return queryResult > 0;
    }

    public Vector getAllLogs(String busObjectType, String eventType, Timestamp fromDate, Timestamp toDate, String content) {
        Connection connection = null;
        SQLCommandBean forSelect = new SQLCommandBean();
        Vector result = new Vector();
        Vector params = new Vector();
        StringBuilder where = new StringBuilder();
        if (busObjectType != null && !busObjectType.isEmpty()) {
            where.append(" AND l.OBJECT_TYPE_ID = '").append(busObjectType).append("'");
        }
        if (eventType != null && !eventType.isEmpty()) {
            where.append(" AND l.EVENT_TYPE_ID = '").append(eventType).append("'");
        }
        if (content != null && !content.isEmpty()) {
            where.append(" AND l.OBJECT_XML LIKE '%").append(content).append("%'");
        }
        params.addElement(new TimestampValue(fromDate));
        params.addElement(new TimestampValue(toDate));
        try {
            connection = dataSource.getConnection();
            forSelect.setConnection(connection);
            forSelect.setSQLQuery(sqlMgr.getSql("selectAllLogs").trim() + where.toString());
            forSelect.setparams(params);
            result = forSelect.executeQuery();
        } catch (SQLException ex) {
            Logger.getLogger(LoggerMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(LoggerMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(LoggerMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        Vector reultBusObjs = new Vector();
        Row r = null;
        Enumeration e = result.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            WebBusinessObject wbo = fabricateBusObj(r);
            try {
                if (r.getString("full_name") != null) {
                    wbo.setAttribute("userName", r.getString("full_name"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(LoggerMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            reultBusObjs.add(wbo);
            
        }
        return reultBusObjs;
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
