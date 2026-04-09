package com.maintenance.db_access;

import com.SpareParts.db_access.UsedSparePartsMgr;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.apache.log4j.xml.DOMConfigurator;

public class QuantifiedMntenceMgr extends RDBGateWay {
    
    private static QuantifiedMntenceMgr quantifiedMntenceMgr = new QuantifiedMntenceMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    public static QuantifiedMntenceMgr getInstance() {
        logger.info("Getting IssueMaintenanceMgr Instance ....");
        return quantifiedMntenceMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("quantified_maintainance.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public void delete(String id, HttpSession s) throws SQLException {
        
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        
        try {
            deleteOnArbitraryKey(id, "key1");
            
        } catch (SQLException sqlEx) {
            logger.error("i can't do delete in QuantifiedMntenceMGR");
            logger.error(sqlEx.getMessage());
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }
        
    }
    
    public boolean saveObject(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException { return false; }
    
    public void saveObject(String[] qun, String[] pr, String[] cost, String[] note, String[] id, String Uid,String isDirectPrch, HttpSession s) {
        
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        
        int size = qun.length;
        
        Connection connection = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        try {
            
            connection = dataSource.getConnection();
            for (int i = 0; i < size; i++) {
                forInsert.setConnection(connection);
                forInsert.setSQLQuery(sqlMgr.getSql("insertQuantifiedMntence").trim());
                Vector params = new Vector();
                
                int queryResult = -1000;
                
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(Uid));
                params.addElement(new StringValue(id[i]));
                params.addElement(new FloatValue(new Float(qun[i]).floatValue()));
                params.addElement(new FloatValue(new Float(pr[i]).floatValue()));
                params.addElement(new FloatValue(new Float(cost[i]).floatValue()));
                params.addElement(new StringValue(note[i]));
                params.addElement(new StringValue((String) waUser.getAttribute("userId")));
                params.addElement(new StringValue(isDirectPrch));
                params.addElement(new FloatValue(new Float(qun[i]).floatValue()));
                
                
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
    }

    public boolean saveItemsObject(String[] qun, String[] pr, String[] cost, String[] note, String[] id,String[] branchs,String[] stores, String Uid,String isDirectPrch,String[] attachedOn, HttpSession s) {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        int size = qun.length;

        Connection connection = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        try {
            int queryResult = -1000;
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertQuantifiedFromTasks").trim());
            for (int i = 0; i < size; i++) {
                if((branchs[i] != null && !branchs[i].equals("none") && !branchs[i].equals("null")) && (stores[i] != null && !stores[i].equals("none") && !stores[i].equals("null"))) {
                    Vector params = new Vector();

                    params.addElement(new StringValue(UniqueIDGen.getNextID()));
                    params.addElement(new StringValue(Uid));
                    params.addElement(new StringValue(id[i]));
                    params.addElement(new FloatValue(new Float(qun[i]).floatValue()));
                    params.addElement(new FloatValue(new Float(pr[i]).floatValue()));
                    params.addElement(new FloatValue(new Float(cost[i]).floatValue()));
                    params.addElement(new StringValue(note[i]));
                    params.addElement(new StringValue((String) waUser.getAttribute("userId")));
                    params.addElement(new StringValue(isDirectPrch));
                    params.addElement(new StringValue(branchs[i]));
                    params.addElement(new StringValue(stores[i]));
                    params.addElement(new FloatValue(new Float(qun[i]).floatValue()));


                    forInsert.setparams(params);
                    try{
                        queryResult = forInsert.executeUpdate();
                    }catch(Exception ex){
                        System.out.println(ex.getMessage());
                    }
                    if(queryResult <= 0){
                        connection.rollback();
                        return false;
                    }
                    try {
                        Thread.sleep(200);
                    } catch (InterruptedException ex) {
                        logger.error(ex.getMessage());
                    }
                } else {
                    connection.rollback();
                    return false;
                }
            }
        } catch (SQLException se) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                logger.error(se.getMessage());
            }
            logger.error(se.getMessage());
            return false;

        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }
        return true;
    }

    public boolean saveItemsObject(String[] qun, String[] costCode, String[] pr, String[] cost, String[] note, String[] id,String[] branchs,String[] stores, String Uid,String isDirectPrch,String[] attachedOn, HttpSession s) {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        int size = qun.length;

        Connection connection = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        try {
            int queryResult = -1000;
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertQuantifiedFromTasks1").trim());
            for (int i = 0; i < size; i++) {
                if((branchs[i] != null && !branchs[i].equals("none") && !branchs[i].equals("null")) && (stores[i] != null && !stores[i].equals("none") && !stores[i].equals("null"))) {
                    Vector params = new Vector();

                    params.addElement(new StringValue(UniqueIDGen.getNextID()));
                    params.addElement(new StringValue(Uid));
                    params.addElement(new StringValue(id[i]));
                    params.addElement(new FloatValue(new Float(qun[i]).floatValue()));
                    params.addElement(new FloatValue(new Float(pr[i]).floatValue()));
                    params.addElement(new FloatValue(new Float(cost[i]).floatValue()));
                    params.addElement(new StringValue(note[i]));
                    params.addElement(new StringValue((String) waUser.getAttribute("userId")));
                    params.addElement(new StringValue(isDirectPrch));
                    params.addElement(new StringValue(costCode[i]));
                    params.addElement(new StringValue(branchs[i]));
                    params.addElement(new StringValue(stores[i]));
                    params.addElement(new FloatValue(new Float(qun[i]).floatValue()));


                    forInsert.setparams(params);
                    try{
                        queryResult = forInsert.executeUpdate();
                    }catch(Exception ex){
                        System.out.println(ex.getMessage());
                    }
                    if(queryResult <= 0){
                        connection.rollback();
                        return false;
                    }
                    try {
                        Thread.sleep(200);
                    } catch (InterruptedException ex) {
                        logger.error(ex.getMessage());
                    }
                } else {
                    connection.rollback();
                    return false;
                }
            }
        } catch (SQLException se) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                logger.error(se.getMessage());
            }
            logger.error(se.getMessage());
            return false;

        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }
        return true;
    }

     public void saveObject2(String[] qun, String[] pr, String[] cost, String[] note, String[] id, String Uid,String isDirectPrch,String[] attachedOn, HttpSession s) {

        Vector activeStoreVec = new Vector();
        ActiveStoreMgr activeStoreMgr = ActiveStoreMgr.getInstance();
        WebBusinessObject storeDataWbo = new WebBusinessObject();
        WebBusinessObject branchDataWbo = new WebBusinessObject();
        WebBusinessObject activeStoreWbo = new WebBusinessObject();
        StoresErpMgr storesErpMgr = StoresErpMgr.getInstance();
        BranchErpMgr branchErpMgr = BranchErpMgr.getInstance();
        String storeErpId = null;
        String branchErpId = null;


        activeStoreVec = activeStoreMgr.getActiveStore(s);
    if(activeStoreVec.size()>0) {
        activeStoreWbo = (WebBusinessObject)activeStoreVec.get(0);
         storeDataWbo = storesErpMgr.getOnSingleKey(activeStoreWbo.getAttribute("storeCode").toString());
         branchDataWbo = branchErpMgr .getOnSingleKey(activeStoreWbo.getAttribute("branchCode").toString());
         storeErpId = storeDataWbo.getAttribute("code").toString();
         branchErpId = branchDataWbo.getAttribute("code").toString();
    }

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        
        int size = qun.length;
        
        Connection connection = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        try {
            
            connection = dataSource.getConnection();
            for (int i = 0; i < size; i++) {
                forInsert.setConnection(connection);
//                String query="INSERT INTO quantified_mntence VALUES (?, ?, ?, ?, ?, ?, ?, ?, SYSDATE,?,'2')";
                forInsert.setSQLQuery(sqlMgr.getSql("insertQuantifiedFromTasks").trim());
//                forInsert.setSQLQuery(query.trim());
                Vector params = new Vector();
                
                int queryResult = -1000;
                
                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue(Uid));
                params.addElement(new StringValue(id[i]));
                params.addElement(new FloatValue(new Float(qun[i]).floatValue()));
                params.addElement(new FloatValue(new Float(pr[i]).floatValue()));
                params.addElement(new FloatValue(new Float(cost[i]).floatValue()));
                params.addElement(new StringValue(note[i]));
                params.addElement(new StringValue((String) waUser.getAttribute("userId")));
                params.addElement(new StringValue(isDirectPrch));
                params.addElement(new StringValue(branchErpId));
                params.addElement(new StringValue(storeErpId));
                params.addElement(new FloatValue(new Float(qun[i]).floatValue()));
//                params.addElement(new StringValue(attachedOn[i]));
                
                
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
    }
    
    public ArrayList getCashedTableAsArrayList() {
        
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        
        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("id"));
        }
        
        return cashedData;
    }
    
    public Vector getItemSchedule(String issueId) {
        
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();
        
        SQLparams.addElement(new StringValue(issueId));
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("stItemSQL").trim());
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
            wbo = (WebBusinessObject) fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }
    
    public Vector getSpecialItemSchedule(String issueId,String isDirectPrch) {
        
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();
        
        SQLparams.addElement(new StringValue(issueId));
        SQLparams.addElement(new StringValue(isDirectPrch));
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("stSpecialItemSQL").trim());
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
            wbo = (WebBusinessObject) fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }
    
    public Vector getAllQuantified() {
        
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectAllQuntified").trim());
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
            wbo = (WebBusinessObject) fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public boolean updatePrice(float  price ,String quantifiedId) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();

        SQLparams.addElement(new FloatValue(price));
        SQLparams.addElement(new FloatValue(price));
        SQLparams.addElement(new StringValue(quantifiedId));

        int queryResult = -1000;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("updatePrice").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeUpdate();
            Thread.sleep(300);

        } catch (Exception se) {
            logger.error("SQL Exception  " + se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        return queryResult > 0;
    }

    public float getQuantityStatusByItemID(String itemId, String scheduleId, String isDirectPrch) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector params = new Vector();

        params.addElement(new StringValue(scheduleId));
        params.addElement(new StringValue(isDirectPrch));
        params.addElement(new StringValue(itemId));


        SQLCommandBean forQuery = new SQLCommandBean();
        Vector queryResult = null;
        try {
            connection = dataSource.getConnection();

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getQuantityStatusByItemID").trim());
            forQuery.setparams(params);
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

        if(queryResult.size() > 0){
            Row r = (Row)queryResult.get(0);
            try {
                return r.getBigDecimal("QUANTITY_STATUS").floatValue();
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(UsedSparePartsMgr.class.getName()).log(Level.SEVERE, null, ex);
            } catch (UnsupportedConversionException ex) {
                Logger.getLogger(UsedSparePartsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return 0;
    }

    public boolean UpdateItemQuantityStatus(String itemId, String scheduleId, String isDirectPrch,Double quant) {

        Connection connection = null;
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        Vector params = new Vector();

        params.addElement(new FloatValue(new Float(quant).floatValue()));
        params.addElement(new StringValue(scheduleId));
        params.addElement(new StringValue(isDirectPrch));
        params.addElement(new StringValue(itemId));


        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("updateQuantityStatus").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeUpdate();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }
        return (queryResult > 0);
    }

    @Override
    protected void initSupportedQueries() {
        return; //throw new UnsupportedOperationException("Not supported yet.");
    }

    public boolean updateAlterPart(WebBusinessObject wbo, String id) {



        Connection connection = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        try {
            int queryResult = -1000;
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("updateAlterPartForQuantified").trim());

                    Vector params = new Vector();


                    params.addElement(new StringValue(wbo.getAttribute("itemId").toString()));
                    params.addElement(new FloatValue(new Float(wbo.getAttribute("itemQuantity").toString()).floatValue()));
                    params.addElement(new FloatValue(new Float(wbo.getAttribute("itemPrice").toString()).floatValue()));
                    params.addElement(new FloatValue(new Float(wbo.getAttribute("totalCost").toString()).floatValue()));
                    params.addElement(new StringValue(wbo.getAttribute("branchCode").toString()));
                    params.addElement(new StringValue(wbo.getAttribute("storeCode").toString()));
                    params.addElement(new StringValue(id));

                    forInsert.setparams(params);
                    try{
                        queryResult = forInsert.executeUpdate();
                    }catch(Exception ex){
                        System.out.println(ex.getMessage());
                    }
                    if(queryResult <= 0){
                        connection.rollback();
                        return false;
                    }
                    try {
                        Thread.sleep(200);
                    } catch (InterruptedException ex) {
                        logger.error(ex.getMessage());
                    }


        } catch (SQLException se) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                logger.error(se.getMessage());
            }
            logger.error(se.getMessage());
            return false;

        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }
        return true;
    }


}
