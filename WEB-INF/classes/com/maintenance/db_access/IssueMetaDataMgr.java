package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class IssueMetaDataMgr extends RDBGateWay {
    
    private static IssueMetaDataMgr issueMetaDataMgr = new IssueMetaDataMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    
//    private static final String insertProSQL = "INSERT INTO place VALUES (?,?,?,NOW(),?)";
    public static IssueMetaDataMgr getInstance() {
        logger.info("Getting issueMetaDataMgr Instance ....");
        return issueMetaDataMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("issue_meta_data.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
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
        
//        cashedData = new ArrayList();
//        WebBusinessObject wbo = null;
//        
//        for (int i = 0; i < cashedTable.size(); i++) {
//            wbo = (WebBusinessObject) cashedTable.elementAt(i);
//            cashedData.add((String) wbo.getAttribute("parentName"));
//        }
//        
        return cashedData;
    }
    
    public boolean getIssueTasks(String issueId) throws Exception {
        
        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(issueId));
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getIssueTasks").trim());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
            
        } catch (SQLException se) {
            logger.error("database error from getListOnSecondKey: ImageMgr " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }
        
        return queryResult.size() > 0;
    }

    @Override
    protected void initSupportedQueries() {
    return; //    throw new UnsupportedOperationException("Not supported yet.");
    }
    
}
