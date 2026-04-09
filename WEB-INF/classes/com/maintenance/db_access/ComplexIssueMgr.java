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

public class ComplexIssueMgr extends RDBGateWay {
    
    private static ComplexIssueMgr complexIssueMgr = new ComplexIssueMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    
    public WebBusinessObject webIssue;
    
    public ComplexIssueMgr() {
    }
    
    public static ComplexIssueMgr getInstance() {
        logger.info("Getting TradeMgr Instance ....");
        return complexIssueMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("complex_issue.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public boolean saveObject(String[] tradeArr,String[] eqType,String[] desc,String[] index,String issueId, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        Connection connection=null;
        int size=tradeArr.length;
        
        try {
            
            connection = dataSource.getConnection();
            for (int i = 0; i < size; i++) {
                connection = dataSource.getConnection();
                forInsert.setConnection(connection);
                forInsert.setSQLQuery(sqlMgr.getSql("insertComplexIssue").trim());
                params = new Vector();
                queryResult = -1000;
                
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(issueId));
                params.addElement(new StringValue(tradeArr[i]));
                params.addElement(new StringValue(eqType[i]));
                params.addElement(new StringValue(desc[i]));
                params.addElement(new StringValue(index[i]));
                
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
            
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                
            }
        }
        
        
        return (queryResult > 0);
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
            cashedData.add((String) wbo.getAttribute("tradeName"));
        }
        
        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
    return; //    throw new UnsupportedOperationException("Not supported yet.");
    }
    
}
