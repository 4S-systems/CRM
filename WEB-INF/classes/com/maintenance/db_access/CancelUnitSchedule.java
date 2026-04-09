package com.maintenance.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class CancelUnitSchedule extends RDBGateWay {
    
    private static CancelUnitSchedule cancelUnitSchedule = new CancelUnitSchedule();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    
    public static CancelUnitSchedule getInstance() {
        logger.info("Getting CancelUnitScheduleMgr Instance ....");
        return cancelUnitSchedule;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("cancel_unit_schedule.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public boolean saveObject(String scheduleId,String unitSchdHistId ,String reason,String rateNo ,HttpSession s,WebBusinessObject wbo) {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-mm-dd");
        java.sql.Date beginScheduleDate =  null;
        try {
            beginScheduleDate = new java.sql.Date(formatter.parse(wbo.getAttribute("beginScheduleDate").toString()).getTime());
        } catch (ParseException ex) {
            ex.printStackTrace();
        }
        
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(scheduleId));
        params.addElement(new StringValue(reason));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new DateValue(beginScheduleDate));
        params.addElement(new StringValue((String) wbo.getAttribute("totalCount")));
        params.addElement(new StringValue(rateNo));
        params.addElement(new StringValue(unitSchdHistId));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertcancelUnitSchedule").trim());
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
            cashedData.add(wbo);
        }
        
        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
    
}
