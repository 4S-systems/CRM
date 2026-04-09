package com.maintenance.db_access;

import com.docviewer.business_objects.Document;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.servlets.MultipartRequest;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import java.util.*;
import java.sql.*;
import java.io.File;
import com.docviewer.db_access.QueryMgr;
import com.silkworm.db_access.FileMgr;
import com.silkworm.jsptags.DropdownDate;
import java.io.InputStream;
import java.math.BigDecimal;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSessionContext;
import org.apache.log4j.xml.DOMConfigurator;

public class DelayReasonsMgr extends RDBGateWay {
    
    //Variables
    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static DelayReasonsMgr delayReasonsMgr = new DelayReasonsMgr();
    
    public static DelayReasonsMgr getInstance() {
        logger.info("Getting DelayReasonsMgr Instance ....");
        return delayReasonsMgr;
    }
    /*******************************************/
    public void setQueryMgr(QueryMgr qm) {
        queryMgr = qm;
    }
    /***********************************************/
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("delay_reason.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public boolean saveObject(HttpServletRequest request, HttpSession s) throws java.sql.SQLException {
        
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertDelayReasonSql").trim());
            
            String issueId=request.getParameter("issueId");
            String [] reasons=request.getParameterValues("reason");
            
            for (int i = 0; i < reasons.length; i++) {
                params = new Vector();
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(reasons[i]));
                params.addElement(new StringValue("5"));
                params.addElement(new StringValue((String) waUser.getAttribute("userId")));
                params.addElement(new StringValue(issueId));
                
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                try {
                    Thread.sleep(200);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }
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
    
    public java.util.ArrayList getCashedTableAsArrayList() {
        return null;
    }
    
     public Vector getDelayReasons(String Id) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getdelayreasons").trim());
   
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(Id));
   
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
   
   
   
 /*   public boolean newob(HttpServletRequest request,String issueId) throws java.sql.SQLException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
   
        String [] compId=request.getParameterValues("compId");
        String [] tasks=request.getParameterValues("tasks");
        String [] taw=request.getParameterValues("taw");
   
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertMergeComplaintSql").trim());
   
   
   
            for (int i = 0; i < compId.length; i++) {
                params = new Vector();
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(issueId));
                params.addElement(new StringValue(tasks[i]));
                params.addElement(new StringValue(compId[i]));
                params.addElement(new StringValue(taw[i]));
   
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                try {
                    Thread.sleep(200);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }
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
   */

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
    
}
