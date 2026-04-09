package com.maintenance.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import com.silkworm.util.*;
import java.util.*;
import java.text.*;
import java.sql.*;
import com.tracker.common.*;
//import com.tracker.app_constants.ProjectConstants;

import com.tracker.business_objects.*;
import org.apache.log4j.xml.DOMConfigurator;

public class WorkEquipMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static WorkEquipMgr workEquipMgr = new WorkEquipMgr();

    public WorkEquipMgr() {
    }

    public static WorkEquipMgr getInstance() {
        logger.info("Getting WorkEquipMgr Instance ....");
        return workEquipMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("work_equip.xml")));
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

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("title"));
        }

        return cashedData;
    }
       public ArrayList getAllWorkEquip(){
        workEquipMgr.cashData();
        return workEquipMgr.getCashedTableAsBusObjects();
    }
       public boolean saveObject(WebBusinessObject wbo ,String mode){

        String Id = UniqueIDGen.getNextID();

        Vector parms = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        int queryResult = -1000;

        parms.addElement(new StringValue(Id));
        parms.addElement(new StringValue((String) wbo.getAttribute("unitId")));
        parms.addElement(new StringValue((String) wbo.getAttribute("placeId")));
        parms.addElement(new StringValue((String) wbo.getAttribute("failure")));

        if(mode.equalsIgnoreCase("full")){
            parms.addElement(new StringValue((String) wbo.getAttribute("jobOrderId")));

            String strItemDate = (String) wbo.getAttribute("itemDate");
            DateParser parser = new DateParser();
            java.sql.Date itemDate = parser.formatSqlDate(strItemDate);

            parms.addElement(new DateValue(itemDate));

            forQuery.setSQLQuery(sqlMgr.getSql("insertWorkEquip").trim());

        }else{
            forQuery.setSQLQuery(sqlMgr.getSql("insertWorkEquipWithoutJobOrder").trim());
        }

            String strHelpDate = (String) wbo.getAttribute("helpDate");
            DateParser parser = new DateParser();
            java.sql.Date helpDate = parser.formatSqlDate(strHelpDate);

            parms.addElement(new DateValue(helpDate));
            parms.addElement(new StringValue((String) wbo.getAttribute("callType")));

            Connection connection = null;
            try{
               connection = dataSource.getConnection();
               forQuery.setConnection(connection);
               forQuery.setparams(parms);
               queryResult = forQuery.executeUpdate();
            }catch(SQLException ex){
                logger.error(ex.getMessage());
                return false;
            }finally{
                try{
                    connection.close();
                }catch(SQLException ex){
                    logger.error(ex.getMessage());
                    return false;
                }
            }
          return queryResult > 0;
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
   
}
