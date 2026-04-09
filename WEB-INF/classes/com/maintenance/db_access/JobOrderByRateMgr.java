/*
 * EquipByIssueMgr.java
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
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class JobOrderByRateMgr extends RDBGateWay {

    private static JobOrderByRateMgr jobOrderByRateMgr = new JobOrderByRateMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public JobOrderByRateMgr() {
    }

    public static JobOrderByRateMgr getInstance() {
        logger.info("Getting EquipByIssueMgr Instance ....");
        return jobOrderByRateMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("job_order_by_rate.xml")));
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

public boolean saveJobOrderByRate(String scheduleId,String unitSchdHistId ,String issueId,String rateNo ,HttpSession s,WebBusinessObject wbo) {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(unitSchdHistId));
        params.addElement(new StringValue(scheduleId));
        params.addElement(new StringValue(rateNo));
        params.addElement(new StringValue((String) wbo.getAttribute("totalCount")));
        params.addElement(new StringValue(issueId));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertJobOrderByRate").trim());
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
  

//    public Vector getEqTasksInRangeByEMG(java.sql.Date beginDate, java.sql.Date endDate) {
//        WebBusinessObject wbo = new WebBusinessObject();
//        Connection connection = null;
//
//        Vector SQLparams = new Vector();
//        Vector queryResult = null;
//
//        SQLparams.addElement(new DateValue(beginDate));
//        SQLparams.addElement(new DateValue(endDate));
//
//
//        SQLCommandBean forQuery = new SQLCommandBean();
//        try {
//            connection = dataSource.getConnection();
//            forQuery.setConnection(connection);
//            forQuery.setSQLQuery(sqlMgr.getSql("getEqTasksInRangeByEMG").trim());
//            forQuery.setparams(SQLparams);
//            queryResult = forQuery.executeQuery();
//        } catch (SQLException se) {
//            logger.error("SQL Exception  " + se.getMessage());
//        } catch (UnsupportedTypeException uste) {
//            logger.error("***** " + uste.getMessage());
//        } finally {
//            try {
//                connection.close();
//            } catch (SQLException ex) {
//                logger.error(ex.getMessage());
//            }
//        }
//
//        Vector resultBusObjs = new Vector();
//
//        Row r = null;
//        Enumeration e = queryResult.elements();
//        while (e.hasMoreElements()) {
//            r = (Row) e.nextElement();
//            wbo = new WebBusinessObject();
//            wbo = fabricateBusObj(r);
//            resultBusObjs.add(wbo);
//        }
//        return resultBusObjs;
//    }
//

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
