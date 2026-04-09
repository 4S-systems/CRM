package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.util.*;

import java.util.*;
import java.text.*;
import java.sql.*;

import org.apache.log4j.xml.DOMConfigurator;

public class TechMgr extends RDBGateWay {

    private static TechMgr techMgr = new TechMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    //SQL Statments.
//    private static final String insertTechSQL = "INSERT INTO tchnican VALUES (?, ?, ?, now(), ?)";
    private static final String updateTechSQL = "UPDATE tchnican SET TECH_NAME = ?, JOB_TITLE = ? WHERE TECH_ID = ?";

    public TechMgr() {
    }

    public static TechMgr getInstance() {
        logger.info("Getting TechMgr Instance ....");
        return techMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("tchnican.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(Hashtable hash) throws SQLException {

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(hash.get("techName").toString()));
        params.addElement(new StringValue(hash.get("techJob").toString()));
        params.addElement(new StringValue(hash.get("createdBy").toString()));

        Connection connection = null;

        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertTechSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
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

    public boolean updateTech(WebBusinessObject wbo) {

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) wbo.getAttribute("techName")));
        params.addElement(new StringValue((String) wbo.getAttribute("jobTitle")));
        params.addElement(new StringValue((String) wbo.getAttribute("techID")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateTechSQL").trim());
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

    public ArrayList getCashedTableAsArrayList() {
        return null;
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
