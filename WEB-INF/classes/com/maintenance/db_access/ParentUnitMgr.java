package com.maintenance.db_access;

import com.maintenance.common.Tools;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class ParentUnitMgr extends RDBGateWay {
    
    private static ParentUnitMgr parentUnitMgr = new ParentUnitMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    
//    private static final String insertProSQL = "INSERT INTO place VALUES (?,?,?,NOW(),?)";
    public static ParentUnitMgr getInstance() {
        logger.info("Getting ParentUnitMgr Instance ....");
        return parentUnitMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("parent_unit.xml")));
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

        cashData();
        
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
            cashedData.add((String) wbo.getAttribute("parentName"));
        }
        
        return cashedData;
    }

    public Vector getParensName(String[] parenId){
        Connection connection = null;

        String quary = sqlMgr.getSql("selectParentsByParentIds").trim();

        quary = quary.replaceAll("iii", Tools.concatenation(parenId, ","));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(quary);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        Vector resAsWbo = new Vector();
        Row row;
        for (int i = 0; i < queryResult.size(); i++) {
            row = (Row) queryResult.get(i);
            try {
                resAsWbo.addElement(row.getString("PARENT_NAME"));
            } catch (NoSuchColumnException ex) {
                logger.error(ex.getMessage());
            }
        }

        return resAsWbo;
    }

    public String getSqlStatementSelectParentId(){
        StringBuffer dq = new StringBuffer("SELECT PARENT_ID FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name"));
        String theQuery = dq.substring(0, (dq.length()));

        return theQuery;
    }

    @Override
    protected void initSupportedQueries() {
     return;//   throw new UnsupportedOperationException("Not supported yet.");
    }
    
}
