/*
 * EquipByPlanMgr.java
 *
 * Created on October 13, 2008, 11:15 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.util.*;

import java.util.*;
import java.text.*;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class EquipByPlanMgr extends RDBGateWay {

    private static EquipByPlanMgr equipByIssueMgr = new EquipByPlanMgr();
    
    public EquipByPlanMgr() {
    }

    public static EquipByPlanMgr getInstance() {
        logger.info("Getting EquipByPlanMgr Instance ....");
        return equipByIssueMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("equip_by_plan.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public ArrayList getCashedTableAsArrayList() {
        return null;
    }

    public Vector getEquipsByPlan(String planId) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        SQLparams.addElement(new StringValue(planId));
        
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);

            forQuery.setSQLQuery(getQuery("getEquipsByPlan").trim());

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

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }
}

