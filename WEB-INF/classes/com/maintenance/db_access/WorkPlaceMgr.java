package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.util.*;
import java.sql.*;

import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class WorkPlaceMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static WorkPlaceMgr workPlaceMgr = new WorkPlaceMgr();
    private WorkEquipMgr workEquipMgr = WorkEquipMgr.getInstance();

    public WorkPlaceMgr() {
    }

    public static WorkPlaceMgr getInstance() {
        logger.info("Getting WorkPlaceMgr Instance ....");
        return workPlaceMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("work_place.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean workPlaceNameExsit(String name){

        boolean found = false;

        WebBusinessObject wbo = workPlaceMgr.getOnSingleKey1(name);
        if(wbo != null)
            found = true;

        return found;
    }

    public boolean saveWorkPlace(WebBusinessObject wbo){

        String ID = UniqueIDGen.getNextID();
        Vector params = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        int queryResult = -1000;

        params.addElement(new StringValue(ID));
        params.addElement(new StringValue((String) wbo.getAttribute("name")));
        params.addElement(new StringValue((String) wbo.getAttribute("desc")));

        try{
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(params);
            forQuery.setSQLQuery(sqlMgr.getSql("insertWorkPlace").trim());
            queryResult = forQuery.executeUpdate();
        }catch(SQLException ex){
            logger.error(ex.getMessage());
            return false;
        }finally{
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
                return false;
            }
        }
        return  queryResult > 0;
    }

    public boolean updateWorkPlace(WebBusinessObject wbo, String ID){
        Vector params = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        int queryResult = -1000;

        params.addElement(new StringValue((String) wbo.getAttribute("name")));
        params.addElement(new StringValue((String) wbo.getAttribute("desc")));
        params.addElement(new StringValue(ID));

        try{
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(params);
            forQuery.setSQLQuery(sqlMgr.getSql("updateWorkPlace").trim());
            queryResult = forQuery.executeUpdate();
        }catch(SQLException ex){
            logger.error(ex.getMessage());
            return false;
        }finally{
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
                return false;
            }
        }
        return  queryResult > 0;
    }

    public boolean canDeleteWorkPlace(String id){
        boolean canDelete = true;
        try {
            Vector vecWorkEquipByWorkEquipId = workEquipMgr.getOnArbitraryKey(id, "key2");
            if(vecWorkEquipByWorkEquipId.size() > 0)
                    canDelete = false;
        }  catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        return canDelete;

    }

    public boolean deleteWorkPlace(String ID){
        Vector params = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        int queryResult = -1000;

        params.addElement(new StringValue(ID));

        try{
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(params);
            forQuery.setSQLQuery(sqlMgr.getSql("deleteWorkPlace").trim());
            queryResult = forQuery.executeUpdate();
        }catch(SQLException ex){
            logger.error(ex.getMessage());
            return false;
        }finally{
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
                return false;
            }
        }
        return  queryResult > 0;
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
            cashedData.add((String) wbo.getAttribute("title"));
        }

        return cashedData;
    }

    public ArrayList getAllWorkPlace(){
        workPlaceMgr.cashData();
        return workPlaceMgr.getCashedTableAsBusObjects();
    }

    @Override
    protected void initSupportedQueries() {
    return; //    throw new UnsupportedOperationException("Not supported yet.");
    }
}
