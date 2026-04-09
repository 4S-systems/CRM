package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.util.*;

import java.util.*;
import java.text.*;
import java.sql.*;

import org.apache.log4j.xml.DOMConfigurator;

public class ComplaintTasksMgr extends RDBGateWay {
    private static ComplaintTasksMgr compTasksMgr = new ComplaintTasksMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    
    public ComplaintTasksMgr() {
    }
    
    public static ComplaintTasksMgr getInstance() {
        logger.info("Getting ComplaintsTasksMgr Instance ....");
        return compTasksMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("complaint_tasks.xml")));
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
    
    protected WebBusinessObject fabricateBusObj(Row r) {
        WebBusinessObject wbo=null;
        wbo=super.fabricateBusObj(r);
        Hashtable tab=wbo.getContents();
        int size=tab.size();
        if(size<7) {
            wbo.setAttribute("taskId","null");
        }
        return wbo;
    }
    
    public Vector getOnArbitraryKey(String keyValue, String keyIndex) throws SQLException, Exception {
        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;
        
        StringBuffer dq = new StringBuffer("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");
        dq.append(supportedForm.getTableSupported().getAttribute(keyIndex));
        dq.append(" = ? ");
        String theQuery = dq.toString();
        
        if (supportedForm == null) {
            initSupportedForm();
        }
        
        logger.info("the query " + theQuery);
        
        // finally do the query
        SQLparams.add(new StringValue(keyValue));
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }
        
        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();
        
        Row r = null;
        Enumeration e = queryResult.elements();
        
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }
        
        return reultBusObjs;
    }

    @Override
    protected void initSupportedQueries() {
       return; // throw new UnsupportedOperationException("Not supported yet.");
    }
}