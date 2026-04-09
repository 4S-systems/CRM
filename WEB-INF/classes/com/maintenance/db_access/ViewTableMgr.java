package com.maintenance.db_access;

import com.contractor.db_access.MaintainableMgr;
import com.maintenance.common.DateParser;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.util.*;
import com.tracker.db_access.IssueMgr;

import java.util.*;
import java.text.*;
import java.sql.*;

import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class ViewTableMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    UserTradeMgr userTradeMgr = UserTradeMgr.getInstance();
    ConfigureMainTypeMgr scheduleConfigMgr = ConfigureMainTypeMgr.getInstance();
    DateAndTimeControl dateAndTime = new DateAndTimeControl();
    private static ViewTableMgr viewTableMgr = new ViewTableMgr();
    public static Vector sheduleConfig = new Vector();
    public static Vector scheduleTasks = new Vector();
//    private static final String insertSchedule = "INSERT INTO schedule VALUES (?, ?, ?, ?, ?, now(), ?)";
    //private static final String updateScheduleSQL = "UPDATE schedule SET MAINTENANCE_TITLE = ?, DESCRIPTION = ?, FREQUENCY = ?, FREQUENCY_TYPE = ? WHERE ID = ?";
    private static final String getUnEmgScheduleSQL = "SELECT * FROM schedule WHERE ID != 1 ";

    public ViewTableMgr() {
    }

    public static ViewTableMgr getInstance() {
        logger.info("Getting ViewTableMgr Instance ....");
        return viewTableMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("viewTable.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }
    public Vector getMainTypesTables(String Scheduled_On)
     {
        Vector returned_Codes = new Vector();
        Vector params =new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Connection connection = null;
        try {
            params.addElement(new StringValue(Scheduled_On));
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            

            //3shn ageb el customer id mn el ticket id
            forInsert.setSQLQuery(sqlMgr.getSql("getTablesReleatedOnMainTypes").trim());
            forInsert.setparams(params);
            returned_Codes = forInsert.executeQuery();

        } catch (Exception se) {
            logger.error(se.getMessage());
           // JOptionPane.showMessageDialog(null, se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resAsWeb = new Vector();
        Row row;
        WebBusinessObject wbo;

         for (int i = 0; i < returned_Codes.size(); i++) {
             row = (Row) returned_Codes.get(i);
             wbo = super.fabricateBusObj(row);
             resAsWeb.add(wbo);
         }

        return resAsWeb;
      }

    public Vector getEquipTables(String Scheduled_On)
     {
        Vector returned_Codes = new Vector();
        Vector params=new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Connection connection = null;
        try {
            params.addElement(new StringValue(Scheduled_On));
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
           
            //3shn ageb el customer id mn el ticket id
            forInsert.setSQLQuery(sqlMgr.getSql("getTablesReleatedOnEquip").trim());
            forInsert.setparams(params);
            returned_Codes = forInsert.executeQuery();

        } catch (Exception se) {
            logger.error(se.getMessage());
           // JOptionPane.showMessageDialog(null, se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resAsWeb = new Vector();
        Row row;
        WebBusinessObject wbo;

         for (int i = 0; i < returned_Codes.size(); i++) {
             row = (Row) returned_Codes.get(i);
             wbo = super.fabricateBusObj(row);
             resAsWeb.add(wbo);
         }

        return resAsWeb;
      }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
