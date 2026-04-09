/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.DatabaseController.db_access;

import com.android.business_objects.LiteBusinessForm;
import com.android.business_objects.LiteWebBusinessObject;
import com.android.db_access.LiteRDBGateWay;
import com.android.exceptions.LiteUnsupportedTypeException;
import com.android.persistence.LiteRow;
import com.android.persistence.LiteSQLCommandBean;
import com.android.persistence.LiteStringValue;
import com.silkworm.business_objects.DOMFabricatorBean;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author java
 */
public class DBTablesConfigMgr extends LiteRDBGateWay{

    private static final DBTablesConfigMgr dBTablesConfigMgr = new DBTablesConfigMgr();

    public static DBTablesConfigMgr getInstance() {
        logger.info("Getting EmployeeLoginMgr Instance ....");
        return dBTablesConfigMgr;
    }
    
    @Override
    public boolean saveObject(LiteWebBusinessObject lwbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new LiteBusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("DB_Tables_Config.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }    
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        LiteWebBusinessObject wbo = null;
        if (cashedTable != null) {
            for (int i = 0; i < cashedTable.size(); i++) {
                wbo = (LiteWebBusinessObject) cashedTable.elementAt(i);
                cashedData.add((String) wbo.getAttribute("name"));
            }
        }

        return cashedData;
    }
    
    public LiteWebBusinessObject getLctnTypTbl(String lctnTyp) {
        LiteWebBusinessObject wbo = new LiteWebBusinessObject();
        Connection connection = null;
        Vector<LiteRow> query = new Vector<>();
        Vector parameters = new Vector();
        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        
        parameters.addElement(new LiteStringValue(lctnTyp));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(parameters);
            forQuery.setSQLQuery(getQuery("getLctnTypTbl").trim());
            query = forQuery.executeQuery();
        } catch (SQLException ex) {
            Logger.getLogger(DBTablesConfigMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (LiteUnsupportedTypeException ex) {
            Logger.getLogger(DBTablesConfigMgr.class.getName()).log(Level.SEVERE, null, ex);
        }finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        for (LiteRow row : query) {
            wbo = fabricateBusObj(row);
        }
        
        return wbo;
    }
    
    public ArrayList<LiteWebBusinessObject> getselectedLst(LiteWebBusinessObject queryLiteWbo) {
        LiteWebBusinessObject wbo = new LiteWebBusinessObject();
        Connection connection = null;
        Vector<LiteRow> query = new Vector<>();
        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        StringBuilder tblNm = new StringBuilder();
        StringBuilder whereStmnt = new StringBuilder();
        
        tblNm.append(queryLiteWbo.getAttribute("tableName").toString());
        whereStmnt.append(queryLiteWbo.getAttribute("condition").toString());

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getselectedLst").replaceAll("TBL_NM", tblNm.toString()).replace("WHERE_STMNT", whereStmnt.toString()).trim());
            query = forQuery.executeQuery();
        } catch (SQLException ex) {
            Logger.getLogger(DBTablesConfigMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (LiteUnsupportedTypeException ex) {
            Logger.getLogger(DBTablesConfigMgr.class.getName()).log(Level.SEVERE, null, ex);
        }finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        
        try {
            supportedForm = new LiteBusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("client.xml")));
        } catch (Exception e) {
            logger.error("Could not locate XML Document");
        }
        
        
        ArrayList<LiteWebBusinessObject> rsltLst = new ArrayList<LiteWebBusinessObject>();
        for (LiteRow row : query) {
            wbo = fabricateBusObj(row);
            rsltLst.add(wbo);
        }
        
        return rsltLst;
    }
}