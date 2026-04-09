package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.sql.SQLException;
import java.util.*;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class SchedulesOnEquipmentByItemMgr extends RDBGateWay {

    private static SchedulesOnEquipmentByItemMgr schedulesOnEquipmentByItemMgr = new SchedulesOnEquipmentByItemMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static SchedulesOnEquipmentByItemMgr getInstance() {
        logger.info("Getting SchedulesOnEquipmentByItemMgr Instance ....");
        return schedulesOnEquipmentByItemMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("schedules_on_equipment_by_item.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        return cashedData;
    }
    
    public Vector getByItemCode(String itemCode) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(itemCode));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            
//            forQuery.setSQLQuery(getQuery("getByItemCode").trim());
            forQuery.setSQLQuery("SELECT * FROM schedules_on_equipment_by_item WHERE item_id = ?");
            
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        
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
        
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                wbo.setAttribute("scheduleId", r.getString("schedule_id"));
                wbo.setAttribute("scheduleTitle", r.getString("schedule_title"));
                wbo.setAttribute("parentName", r.getString("parent_name"));
                
                if(r.getString("model_id") == null) {
                    wbo.setAttribute("modelId", "");
                    
                } else {
                    wbo.setAttribute("modelId", r.getString("model_id"));
                    
                }
                
                if(r.getString("main_type_id") == null) {
                    wbo.setAttribute("mainTypeId", "");
                    
                } else {
                    wbo.setAttribute("mainTypeId", r.getString("main_type_id"));
                    
                }
                
                resultBusObjs.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return resultBusObjs;
    }
   
    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
    
}
