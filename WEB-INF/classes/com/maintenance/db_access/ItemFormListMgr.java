package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.persistence.relational.StringValue;
import java.util.*;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class ItemFormListMgr extends RDBGateWay {
    
    private static ItemFormListMgr itemFormListMgr = new ItemFormListMgr();
    private StoresErpMgr storesErpMgr = StoresErpMgr.getInstance();
    SqlMgr sqlMgr = SqlMgr.getInstance();
 
    public static ItemFormListMgr getInstance() {
        logger.info("Getting ItemFormListMgr Instance ....");
        return itemFormListMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("item_form_list.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
   public boolean saveItemForm(String codeForm, String descForm,String branchCode,String remainStoreCode,String storeCode) throws NoUserInSessionException {
        
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(codeForm));
        params.addElement(new StringValue(descForm));
        params.addElement(new StringValue(branchCode));
        params.addElement(new StringValue(remainStoreCode));
        params.addElement(new StringValue(storeCode));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("saveItemForm").trim());
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

    public boolean getDeleteItemForm(String storeCode) throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;

        SQLparams.addElement(new StringValue(storeCode));

        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getDeleteItemForm").trim());
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


    public ArrayList getCashedTableAsArrayList() {
        
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        
        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("formDesc"));
        }
        
        return cashedData;
    }

    public Vector getSelectedItemForm() {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;



        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getSelectedItemForm").trim());

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
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
    
    public Vector getStoreByBranch(String branchCode) {
        WebBusinessObject wbo = new WebBusinessObject();
        WebBusinessObject wboStoreErp;
        Connection connection = null;
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        
        SQLparams.addElement(new StringValue(branchCode));
        
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(SQLparams);
            forQuery.setSQLQuery(sqlMgr.getSql("getStoreByBranch").trim());

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
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

        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            wbo = fabricateBusObj((Row) e.nextElement());
            wboStoreErp = storesErpMgr.getOnSingleKey((String) wbo.getAttribute("storeCode"));
            if(wboStoreErp != null) {
                if(wboStoreErp.getAttribute("nameEn") != null)
                {
                    wbo.setAttribute("nameAr", wboStoreErp.getAttribute("nameAr"));
                    wbo.setAttribute("nameEn", wboStoreErp.getAttribute("nameEn"));
                }
                else
                {
                wbo.setAttribute("nameAr", wboStoreErp.getAttribute("nameAr"));
                wbo.setAttribute("nameEn", wboStoreErp.getAttribute("nameAr"));
                }
            }


            resultBusObjs.add(wbo);
        }

        return resultBusObjs;
    }
    
   public String getBranchByStoreCode(String storeCode) {
       Vector<WebBusinessObject> itemFormListVec;
       String branchCode = null;

       try {
           itemFormListVec = itemFormListMgr.getOnArbitraryKey(storeCode, "key1");

           for (WebBusinessObject wbo : itemFormListVec) {
               branchCode = (String) wbo.getAttribute("branchCode");
           }

       } catch(Exception ex) { logger.error(ex.getMessage()); }

       return branchCode;
   }

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
}
