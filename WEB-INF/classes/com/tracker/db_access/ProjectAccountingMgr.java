/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tracker.db_access;

import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.SqlMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.persistence.relational.UnsupportedConversionException;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author walid
 */
public class ProjectAccountingMgr extends RDBGateWay{
    private static ProjectAccountingMgr projectaccMgr = new ProjectAccountingMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static ProjectAccountingMgr getInstance() {
        logger.info("Getting ProjectMgr Instance ....");
        return projectaccMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("PROJECT_ACCOUNTING.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public boolean updateprojectAccount(String projectAccId, int maxInstalments, int mPrice, String garageNum, String lockerNum) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult;
        StringBuilder updateAtt = new StringBuilder();
        if(maxInstalments > 0){
            updateAtt.append(" MAX_INSTALMENT = ?");
            params.addElement(new StringValue(maxInstalments + ""));
        }
        
        if(mPrice > 0){
            if (updateAtt.length() > 0){
                updateAtt.append(" , ");
            }
            
            updateAtt.append(" METER_PRICE = ? ");
            params.addElement(new StringValue(mPrice + ""));
        }
        
        if(garageNum != null && Integer.parseInt(garageNum) > 0){
            if (updateAtt.length() > 0){
                updateAtt.append(" , ");
            }
            
            updateAtt.append(" GARAGE_NUM = ? ");
            params.addElement(new StringValue(garageNum));
        }
        
        if(lockerNum != null && Integer.parseInt(lockerNum) > 0){
            if (updateAtt.length() > 0){
                updateAtt.append(" , ");
            }
            
            updateAtt.append(" LOCKER_NUM = ? ");
            params.addElement(new StringValue(lockerNum));
        }
        
        params.addElement(new StringValue(projectAccId));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            // forInsert.setSQLQuery("UPDATE UNIT_PRICE SET OPTION2 =? WHERE UNIT_ID=?");forInsert.setSQLQuery(getQuery("updateProjectInfo").trim());
            forInsert.setSQLQuery(getQuery("updateProjectInfo").replaceAll("updateAtt", updateAtt.toString()).trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        
        return (queryResult > 0);
    }
    
    public boolean saveObject(WebBusinessObject projectAcc, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String projectAccId = UniqueIDGen.getNextID();
        params.addElement(new StringValue(projectAccId));
        params.addElement(new StringValue((String) projectAcc.getAttribute("maxInstalments")));
        params.addElement(new StringValue((String) projectAcc.getAttribute("projectId")));
        params.addElement(new StringValue((String) projectAcc.getAttribute("OPTION_1")));
        params.addElement(new StringValue((String) projectAcc.getAttribute("OPTION_2")));
        params.addElement(new StringValue((String) projectAcc.getAttribute("OPTION_3")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery("INSERT INTO PROJECT_ACC VALUES (?, ?, ?, ?, ?, ?,sysdate, ?, '0', '0', '0')");
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();
        }

        return (queryResult > 0);
    }
    
    public WebBusinessObject getProjectAccount(String projectId) throws UnsupportedConversionException{
        Connection connection = null;
        //String quary = "select * from project_acc where project_id="+projectId;//sqlMgr.getSql("getProjectAcc").trim();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        
        params.addElement(new StringValue(projectId));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getProjectAccount").trim());
            forQuery.setparams(params);
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
        
        WebBusinessObject projectAccWbo = new WebBusinessObject();
        Row row;
        for (int i = 0; i < queryResult.size(); i++){
            row = (Row) queryResult.get(i);
            try{
                if(row.getString("project_Acc_Id") != null){
                    projectAccWbo.setAttribute("projectAccId", row.getString("project_Acc_Id"));
                } 
                
                if(row.getString("MAX_INSTALMENT") != null){
                    projectAccWbo.setAttribute("maxInstalments", row.getString("MAX_INSTALMENT"));
                }
                
                if(row.getString("PROJECT_ID") != null){
                    projectAccWbo.setAttribute("projectId", row.getString("PROJECT_ID"));
                }
                
                if(row.getString("OPTION_1") != null){
                    projectAccWbo.setAttribute("OPTION_1", row.getString("OPTION_1"));
                }
                
                if(row.getString("OPTION_2") != null){
                    projectAccWbo.setAttribute("OPTION_2", row.getString("OPTION_2"));
                }
                
                if(row.getString("OPTION_3") != null){
                    projectAccWbo.setAttribute("OPTION_3", row.getString("OPTION_3"));
                }
                
                if(row.getString("CRETAION_TIME") != null){
                    projectAccWbo.setAttribute("creationTime", row.getString("CRETAION_TIME"));
                }
                
                if(row.getString("CREATED_BY") != null){
                    projectAccWbo.setAttribute("createdBy", row.getString("CREATED_BY"));
                }
                
                try {
                    projectAccWbo.setAttribute("meterPrice", row.getString("METER_PRICE") != null ? row.getString("METER_PRICE") : "0");
                } catch (Exception ex) {
                    projectAccWbo.setAttribute("meterPrice", "0");
                    Logger.getLogger(ProjectAccountingMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                if(row.getString("GARAGE_NUM") == null){
                    projectAccWbo.setAttribute("garageNumber", "0");
                } else {
                    projectAccWbo.setAttribute("garageNumber", row.getString("GARAGE_NUM"));
                }
                
                if(row.getString("LOCKER_NUM") == null){
                    projectAccWbo.setAttribute("lockerNumber", "0");
                } else {
                    projectAccWbo.setAttribute("lockerNumber", row.getString("LOCKER_NUM"));
                }
            } catch (NoSuchColumnException ex){
                logger.error(ex.getMessage());
            }
        }

        return projectAccWbo;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("projectID"));
        }

        return cashedData;
    } 
}