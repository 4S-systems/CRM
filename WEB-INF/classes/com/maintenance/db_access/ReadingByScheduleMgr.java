package com.maintenance.db_access;

import com.SpareParts.db_access.*;
import com.contractor.db_access.MaintainableMgr;
import com.maintenance.common.ResultDataReportBean;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.MetaDataMgr;
import com.tracker.db_access.ProjectMgr;
import java.util.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class ReadingByScheduleMgr extends RDBGateWay {

    private static ReadingByScheduleMgr readingByScheduleMgr = new ReadingByScheduleMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static ReadingByScheduleMgr getInstance() {
        logger.info("Getting ReadingByScheduleMgr Instance ....");
        return readingByScheduleMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if(supportedForm == null) {
            try {
                supportedForm  = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("reading_by_schedule.xml")));
            } catch(Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for(int i=0; i<cashedTable.size();i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("id"));
        }

        return cashedData;
    }

    public List getScheduleWorkByMainType(String mainTypeId,String siteId,String sUnitId,String scheduleId) {
        WebBusinessObject wbo = new WebBusinessObject();
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String userName = metaDataMgr.getStoreErpName();
        String password = metaDataMgr.getStoreErpPassword();
        String driver = metaDataMgr.getDriverErp();
        String URL = metaDataMgr.getDataBaseErpUrl();
        Connection conn = null;

        Vector SQLparams = new Vector();
        Vector queryResult = new Vector();
        String sqlString =null;
        if(mainTypeId != null && !mainTypeId.equals("")
                && siteId != null && !siteId.equals("")){                       
            if(mainTypeId.equals("all")){
                if(scheduleId==null || scheduleId.equals("")){
                    SQLparams.addElement(new StringValue(siteId));
                    sqlString = "getReadingWorkByAllMainTypeAndSite";
                }else{
                    sqlString = "getReadingWorkByAllMainTypeAndSiteAndSchedule";
                    SQLparams.addElement(new StringValue(scheduleId));
                    SQLparams.addElement(new StringValue(siteId));
                }
                
            }else{
                if(scheduleId==null || scheduleId.equals("")){
                    SQLparams.addElement(new StringValue(mainTypeId));
                    SQLparams.addElement(new StringValue(siteId));
                    sqlString = "getReadingWorkByMainTypeAndSite";
                }else{
                    SQLparams.addElement(new StringValue(mainTypeId));
                    SQLparams.addElement(new StringValue(scheduleId));
                    SQLparams.addElement(new StringValue(siteId));
                    sqlString = "getReadingWorkByMainTypeAndSiteAndSchedule";
                }
                
            }
            
        }else if(mainTypeId != null && !mainTypeId.equals("")){
            
            if(mainTypeId.equals("all")){
                if(scheduleId==null || scheduleId.equals("")){
                    sqlString = "getReadingWorkByAllMainType";
                }else{
                    SQLparams.addElement(new StringValue(scheduleId));
                    sqlString = "getReadingWorkByAllMainTypeAndSchedule";
                }                
            }else{
                if(scheduleId==null || scheduleId.equals("")){
                    SQLparams.addElement(new StringValue(mainTypeId));
                    sqlString = "getReadingWorkByMainType";
                }else{
                    SQLparams.addElement(new StringValue(mainTypeId));
                    SQLparams.addElement(new StringValue(scheduleId));
                    sqlString = "getReadingWorkByMainTypeAndSchedule";
                }
                
            }
        }

        if(sUnitId != null && !sUnitId.equals("")){
            if(scheduleId==null || scheduleId.equals("")){
               SQLparams.addElement(new StringValue(sUnitId));
               sqlString = "getReadingWorkByUnit"; 
            }else{
                SQLparams.addElement(new StringValue(sUnitId));
                SQLparams.addElement(new StringValue(scheduleId));
                sqlString = "getReadingWorkByUnitAndSchedule";
            }
        }

        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        try {

            connection= dataSource.getConnection();
            connection.setAutoCommit(false);
            forQuery.setConnection(connection);
            forQuery.setparams(SQLparams);
            forQuery.setSQLQuery(sqlMgr.getSql(sqlString).trim());
            queryResult = forQuery.executeQuery();


        } catch (Exception se) {
            logger.error("database error " + se.getMessage());
        }finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        ResultDataReportBean resultDataReportBean = new ResultDataReportBean();
        List list = new ArrayList();
        
        while(e.hasMoreElements()) {
            try {
                MaintainableMgr unitMgr = MaintainableMgr.getInstance();
                WebBusinessObject unitWbo = new WebBusinessObject();
                ProjectMgr siteMgr = ProjectMgr.getInstance();
                WebBusinessObject siteWbo = new WebBusinessObject();
                
                r = (Row) e.nextElement();
                unitWbo = unitMgr.getOnSingleKey(r.getString("unitid"));
                siteWbo = siteMgr.getOnSingleKey(r.getString("site"));
                resultDataReportBean = new ResultDataReportBean();
//                resultDataReportBean.setSchId(r.getString("schid"));
//                resultDataReportBean.setSchTitle(r.getString("maintenance_title"));
                resultDataReportBean.setMainCatId(r.getString("maintype"));
                resultDataReportBean.setUnitId(r.getString("unitid"));
                resultDataReportBean.setBranchName(siteWbo.getAttribute("projectName").toString());
                resultDataReportBean.setUnitName(r.getString("unit_name"));
                resultDataReportBean.setJobOrderNo(r.getString("business_id"));
                list.add(resultDataReportBean);
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ReadingByScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return list;

    }

    public int getSUM_DISTANCE(String unitNo,java.sql.Date enteryDate) {
        WebBusinessObject wbo = new WebBusinessObject();
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String userName = metaDataMgr.getStoreErpName();
        String password = metaDataMgr.getStoreErpPassword();
        String driver = metaDataMgr.getDriverErp();
        String URL = metaDataMgr.getDataBaseErpUrl();
        Connection conn = null;
        int sum =0;
        Vector SQLparams = new Vector();
        Vector queryResult = new Vector();
        SQLparams.addElement(new DateValue(enteryDate));
        SQLparams.addElement(new StringValue(unitNo));



        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        try {

            Class.forName(driver);
            conn = DriverManager.getConnection(URL, userName, password);
            conn.setAutoCommit(false);
            forQuery.setConnection(conn);
            forQuery.setparams(SQLparams);
            forQuery.setSQLQuery(sqlMgr.getSql("getDistanceTravel").trim());
            queryResult = forQuery.executeQuery();


        } catch (Exception se) {
            logger.error("database error " + se.getMessage());
        }finally {
            try {
                conn.commit();
                conn.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        ResultDataReportBean resultDataReportBean = new ResultDataReportBean();
        List list = new ArrayList();
        while(e.hasMoreElements()) {

                r = (Row) e.nextElement();

            try {

                    sum = new Integer(r.getBigDecimal("DISTANCE").intValue());

            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ReadingByScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);
            } catch (UnsupportedConversionException ex) {
                Logger.getLogger(ReadingByScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return sum;

    }

    public int getAllSUM_DISTANCE(String unitNo) {
        WebBusinessObject wbo = new WebBusinessObject();
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String userName = metaDataMgr.getStoreErpName();
        String password = metaDataMgr.getStoreErpPassword();
        String driver = metaDataMgr.getDriverErp();
        String URL = metaDataMgr.getDataBaseErpUrl();
        Connection conn = null;
        int sum =0;
        Vector SQLparams = new Vector();
        Vector queryResult = new Vector();
        SQLparams.addElement(new StringValue(unitNo));

        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        try {

            Class.forName(driver);
            conn = DriverManager.getConnection(URL, userName, password);
            conn.setAutoCommit(false);
            forQuery.setConnection(conn);
            forQuery.setparams(SQLparams);
            forQuery.setSQLQuery(sqlMgr.getSql("getAllDistanceTravel").trim());
            queryResult = forQuery.executeQuery();


        } catch (Exception se) {
            logger.error("database error " + se.getMessage());
        }finally {
            try {
                conn.commit();
                conn.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        ResultDataReportBean resultDataReportBean = new ResultDataReportBean();
        List list = new ArrayList();
        while(e.hasMoreElements()) {

                r = (Row) e.nextElement();

            try {

                    sum = new Integer(r.getBigDecimal("DISTANCE").intValue());

            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ReadingByScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);
            } catch (UnsupportedConversionException ex) {
                Logger.getLogger(ReadingByScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return sum;

    }

    public List getReadingUnitWithoutJob(String mainTypeId,String siteId,String sUnitId,String scheduleId) {
        WebBusinessObject wbo = new WebBusinessObject();
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String userName = metaDataMgr.getStoreErpName();
        String password = metaDataMgr.getStoreErpPassword();
        String driver = metaDataMgr.getDriverErp();
        String URL = metaDataMgr.getDataBaseErpUrl();
        Connection conn = null;

        Vector SQLparams = new Vector();
        Vector queryResult = new Vector();
        String sqlString =null;
        if(mainTypeId != null && !mainTypeId.equals("")
                && siteId != null && !siteId.equals("")){
            if(mainTypeId.equals("all")){
                if(scheduleId==null || scheduleId.equals("")){
                    SQLparams.addElement(new StringValue(siteId));
                    sqlString = "getReadingByAllMainTypeAndSite";
                }else{
                    sqlString = "getReadingByAllMainTypeAndSiteAndSchedule";
                    SQLparams.addElement(new StringValue(scheduleId));
                    SQLparams.addElement(new StringValue(siteId));
                }

            }else{
                if(scheduleId==null || scheduleId.equals("")){
                    SQLparams.addElement(new StringValue(mainTypeId));
                    SQLparams.addElement(new StringValue(siteId));
                    sqlString = "getReadingByMainTypeAndSite";
                }else{
                    SQLparams.addElement(new StringValue(mainTypeId));
                    SQLparams.addElement(new StringValue(scheduleId));
                    SQLparams.addElement(new StringValue(siteId));
                    sqlString = "getReadingByMainTypeAndSiteAndSchedule";
                }

            }

        }else if(mainTypeId != null && !mainTypeId.equals("")){

            if(mainTypeId.equals("all")){
                if(scheduleId==null || scheduleId.equals("")){
                    sqlString = "getReadingByAllMainType";
                }else{
                    SQLparams.addElement(new StringValue(scheduleId));
                    sqlString = "getReadingByAllMainTypeAndSchedule";
                }
            }else{
                if(scheduleId==null || scheduleId.equals("")){
                    SQLparams.addElement(new StringValue(mainTypeId));
                    sqlString = "getReadingByMainType";
                }else{
                    SQLparams.addElement(new StringValue(mainTypeId));
                    SQLparams.addElement(new StringValue(scheduleId));
                    sqlString = "getReadingByMainTypeAndSchedule";
                }

            }
        }

        if(sUnitId != null && !sUnitId.equals("")){
            if(scheduleId==null || scheduleId.equals("")){
               SQLparams.addElement(new StringValue(sUnitId));
               sqlString = "getReadingByUnit";
            }else{
                SQLparams.addElement(new StringValue(sUnitId));
                SQLparams.addElement(new StringValue(scheduleId));
                sqlString = "getReadingByUnitAndSchedule";
            }
        }

        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        try {

            connection= dataSource.getConnection();
            connection.setAutoCommit(false);
            forQuery.setConnection(connection);
            forQuery.setparams(SQLparams);
            forQuery.setSQLQuery(sqlMgr.getSql(sqlString).trim());
            queryResult = forQuery.executeQuery();


        } catch (Exception se) {
            logger.error("database error " + se.getMessage());
        }finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        ResultDataReportBean resultDataReportBean = new ResultDataReportBean();
        List list = new ArrayList();

        while(e.hasMoreElements()) {
            try {
                MaintainableMgr unitMgr = MaintainableMgr.getInstance();
                WebBusinessObject unitWbo = new WebBusinessObject();
                ProjectMgr siteMgr = ProjectMgr.getInstance();
                WebBusinessObject siteWbo = new WebBusinessObject();

                r = (Row) e.nextElement();
                unitWbo = unitMgr.getOnSingleKey(r.getString("unitid"));
                siteWbo = siteMgr.getOnSingleKey(r.getString("site"));
                resultDataReportBean = new ResultDataReportBean();
//                resultDataReportBean.setSchId(r.getString("schid"));
//                resultDataReportBean.setSchTitle(r.getString("maintenance_title"));
                resultDataReportBean.setMainCatId(r.getString("maintype"));
                resultDataReportBean.setUnitId(r.getString("unitid"));
                if(siteWbo != null && !siteWbo.equals("")){
                    resultDataReportBean.setBranchName(siteWbo.getAttribute("projectName").toString());
                }
                resultDataReportBean.setUnitName(r.getString("unit_name"));
                resultDataReportBean.setSchId(r.getString("schid"));
                resultDataReportBean.setSchTitle(r.getString("maintenance_title"));
//                try {
                    resultDataReportBean.setWhichCloser(new Integer(r.getString("which_closer").toString()).intValue());
                    resultDataReportBean.setSchFrec(new Integer(r.getString("frequency").toString()).intValue());
//                } catch (UnsupportedConversionException ex) {
//                    Logger.getLogger(ReadingByScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);
//                }
//                resultDataReportBean.setJobOrderNo(r.getString("business_id"));
                list.add(resultDataReportBean);
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ReadingByScheduleMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return list;

    }

    @Override
    protected void initSupportedQueries() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

}