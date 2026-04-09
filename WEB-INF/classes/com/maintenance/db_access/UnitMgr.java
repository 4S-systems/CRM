package com.maintenance.db_access;

import com.silkworm.xml.DOMFabricatorBean;
import com.silkworm.business_objects.*;
import java.util.*;
import com.silkworm.persistence.relational.*;
import com.silkworm.events.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class UnitMgr extends RDBGateWay {
    
    Vector businessObjectEventListeners = null;
    UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static UnitMgr maintainableMgr = new UnitMgr();
    
    private UnitMgr() {
    }
    
    public static UnitMgr getInstance() {
        logger.info("Getting UnitMgr Instance ....");
        return maintainableMgr;
    }
    
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("maintainableUnit.xml")));//"C:\\temp\\maintainableUnit.xml"));
            } catch (Exception e) {
                logger.error(e.getMessage());
            }
        }
    }
    
    protected WebBusinessObject fabricateBusObj(Row r) {
        
        ListIterator li = supportedForm.getFormElemnts().listIterator();
        FormElement fe = null;
        Hashtable ht = new Hashtable();
        String colName;
        String state = null;
        String docOwnerId = null;
        
        
        
        while (li.hasNext()) {
            
            try {
                fe = (FormElement) li.next();
                colName = (String) fe.getAttribute("column");
                // needs a case ......
                ht.put(fe.getAttribute("name"), r.getString(colName));
            } catch (Exception e) {
                
            }
            
        }
        
        MaintainableUnit expense = new MaintainableUnit(ht);
        return (WebBusinessObject) expense;
    }
    
    public Vector getChildren(String parentId) {
        MaintainableUnit expense = null;
        Connection connection = null;
//        String query = "SELECT * FROM maintainable_unit WHERE PARENT_ID = ? ORDER BY UNIT_NAME";
        
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(parentId));
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectMaintainableUnit").trim());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        Vector reultBusObjs = new Vector();
        
        Row r = null;
        Enumeration e = queryResult.elements();
        
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            expense = (MaintainableUnit) fabricateBusObj(r);
            reultBusObjs.add(expense);
        }
        
        return reultBusObjs;
        
        
    }
    
    public Vector getRootNodes() {
        MaintainableUnit expense = null;
        
        Connection connection = null;
//        String query = "SELECT * FROM maintainable_unit WHERE PARENT_ID = '0' ORDER BY UNIT_NAME";
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectRootNodes").trim());
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        
        Vector reultBusObjs = new Vector();
        
        Row r = null;
        Enumeration e = queryResult.elements();
        
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            expense = (MaintainableUnit) fabricateBusObj(r);
            reultBusObjs.add(expense);
        }
        return reultBusObjs;
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    /****************ibrahim*****************/
    
    public Vector getEquipment() {
        
        MaintainableUnit expense = null;
        Connection connection = null;
        
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectEqWithoutSite").trim());
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        
        Vector reultBusObjs = new Vector();
        
        Row r = null;
        Enumeration e = queryResult.elements();
        
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            expense = (MaintainableUnit) fabricateBusObj(r);
            reultBusObjs.add(expense);
        }
        return reultBusObjs;
        
    }
    
    public Vector getEquipment(String projectId) {
        
        MaintainableUnit expense = null;
        Connection connection = null;
        
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        SQLparams.addElement(new StringValue(projectId));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectEq").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        
        Vector reultBusObjs = new Vector();
        
        Row r = null;
        Enumeration e = queryResult.elements();
        
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            expense = (MaintainableUnit) fabricateBusObj(r);
            reultBusObjs.add(expense);
        }
        return reultBusObjs;
        
//        cashedData = new ArrayList();
//        WebBusinessObject wbo = null;
//
//        for (int i = 0; i < cashedTable.size(); i++) {
//            wbo = (WebBusinessObject) cashedTable.elementAt(i);
//            cashedData.add(wbo);
//        }
//
//        return cashedData;
    }
    /****************************************************/
    public ArrayList getCashedTableAsArrayList() {
        
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        
        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("UNIT_NAME"));
        }
        
        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
    
    public ArrayList<WebBusinessObject> getAllUnitInfo() {
        Vector param = new Vector();
        Connection connection = null;
        Vector<Row> rows = null;
        SQLCommandBean command = new SQLCommandBean();
        WebBusinessObject wbo;
        ArrayList<WebBusinessObject> result = new ArrayList<>();
         
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getAllUnitInfo").trim());
            command.setparams(param);
            rows = command.executeQuery();
            for (Row row : rows) {
                wbo = fabricateBusObj(row);
                if (row.getString("PROJECT_ID") != null) {
                    wbo.setAttribute("projectID", row.getString("PROJECT_ID"));
                }
                if (row.getString("PROJECT_NAME") != null) {
                    wbo.setAttribute("projectName", row.getString("PROJECT_NAME"));
                }
                if (row.getString("STATUS_NAME") != null) {
                    wbo.setAttribute("statusID", row.getString("STATUS_NAME"));
                }
                if (row.getString("CASE_AR") != null) {
                    wbo.setAttribute("statusNameAr", row.getString("CASE_AR"));
                }
                if (row.getString("CASE_EN") != null) {
                    wbo.setAttribute("statusNameEn", row.getString("CASE_EN"));
                }
                result.add(wbo);
            }
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(UnitMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        return result;
    }
}
