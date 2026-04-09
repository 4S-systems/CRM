package com.maintenance.db_access;

import com.maintenance.common.DateParser;
import com.maintenance.common.Tools;
import com.silkworm.xml.DOMFabricatorBean;
import com.silkworm.business_objects.*;
import java.util.*;
import com.silkworm.persistence.relational.*;
import com.silkworm.persistence.relational.StringValue;
import com.tracker.servlets.IssueServlet.IssueTitle;
import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class AllMaintenanceInfoMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static AllMaintenanceInfoMgr allMaintenanceInfoMgr = new AllMaintenanceInfoMgr();

    private AllMaintenanceInfoMgr() {
    }

    public static AllMaintenanceInfoMgr getInstance() {
        logger.info("Getting UnitMgr Instance .....");
        return allMaintenanceInfoMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("all_maintenance_info.xml")));
            } catch (Exception e) {
                logger.error(e.getMessage());
            }
        }
    }

    public Vector getAllMaintenanceBySiteType(WebBusinessObject wbo) {
        Connection connection = null;

        Vector queryResult = new Vector();
        String taskId = (String) wbo.getAttribute("taskId");
        String itemId = (String) wbo.getAttribute("itemId");
        String dateOrder = (String) wbo.getAttribute("dateOrder");
        
        DateParser parser = new DateParser();
        String startDate = (String) wbo.getAttribute("beginDate");
        String endDate = (String) wbo.getAttribute("endDate");
        java.sql.Date sqlStartDate, sqlEndDate;
        sqlStartDate = parser.formatSqlDate(startDate);
        sqlEndDate = parser.formatSqlDate(endDate);

        // to get resualt at the same day from end day add one day to end date
        sqlEndDate.setDate(sqlEndDate.getDate() + 1);

        String query;

        String mainType = Tools.concatenation((String[]) wbo.getAttribute("mainType"), ",");
        String site = Tools.concatenation((String[]) wbo.getAttribute("site"), ",");
        String trade = Tools.concatenation((String[]) wbo.getAttribute("trade"), ",");
        String issueTitle = (String) wbo.getAttribute("issueTitle");
        String currenStatus = Tools.concatenation((String[]) wbo.getAttribute("currentStatus"), ",");

        Vector SQLparams = new Vector();
        SQLparams.addElement(new DateValue(sqlStartDate));
        SQLparams.addElement(new DateValue(sqlEndDate));

        if ((taskId != null && !taskId.equals("")) && (itemId != null && !itemId.equals(""))) {
            query = sqlMgr.getSql("getByTypeSiteTaskItem").trim();

            SQLparams.addElement(new StringValue(itemId));
            SQLparams.addElement(new StringValue(taskId));

        } else if (taskId != null && !taskId.equals("")) {
            query = sqlMgr.getSql("getByTypeSiteTask").trim();

            SQLparams.addElement(new StringValue(taskId));

        } else if (itemId != null && !itemId.equals("")) {
            query = sqlMgr.getSql("getByTypeSiteItem").trim();

            SQLparams.addElement(new StringValue(itemId));

        } else {
            query = sqlMgr.getSql("getByTypeSite").trim();
        }

        // replace all value as mmm,ccc, .. by true value
        query = query.replaceAll("mmm", mainType);
        query = query.replaceAll("sss", site);
        query = query.replaceAll("ttt", trade);
        query = query.replaceAll("ccc", currenStatus);
        query = query.replaceAll("date_order", dateOrder);
        
        if (issueTitle.equals("Emergency")) {
            query = query.replaceAll("iii1", "");
            query = query.replaceAll("iii2", "Emergency");
        } else if(issueTitle.equals("notEmergency")){
            query = query.replaceAll("iii1", "NOT");
            query = query.replaceAll("iii2", "Emergency");
        }else {
            query = query.replaceAll("iii1", "");
            query = query.replaceAll("iii2", "");
        }

        SQLCommandBean forQuery = new SQLCommandBean();

        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
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
            reultBusObjs.add((WebBusinessObject) fabricateBusObj(r));
        }

        return reultBusObjs;


    }

    public Vector getAllMaintenanceByBrand(WebBusinessObject wbo) {
        Connection connection = null;

        String taskId = (String) wbo.getAttribute("taskId");
        String itemId = (String) wbo.getAttribute("itemId");
        String dateOrder = (String) wbo.getAttribute("dateOrder");
        
        DateParser parser = new DateParser();
        String startDate = (String) wbo.getAttribute("beginDate");
        String endDate = (String) wbo.getAttribute("endDate");
        java.sql.Date sqlStartDate, sqlEndDate;
        sqlStartDate = parser.formatSqlDate(startDate);
        sqlEndDate = parser.formatSqlDate(endDate);

        // to get resualt at the same day from end day add one day to end date
        sqlEndDate.setDate(sqlEndDate.getDate() + 1);

        String query;

        String brand = Tools.concatenation((String[]) wbo.getAttribute("brand"), ",");
        String site = Tools.concatenation((String[]) wbo.getAttribute("site"), ",");
        String trade = Tools.concatenation((String[]) wbo.getAttribute("trade"), ",");
        String issueTitle = (String) wbo.getAttribute("issueTitle");
        String currenStatus = Tools.concatenation((String[]) wbo.getAttribute("currentStatus"), ",");

        Vector SQLparams = new Vector();
        SQLparams.addElement(new DateValue(sqlStartDate));
        SQLparams.addElement(new DateValue(sqlEndDate));

        if ((taskId != null && !taskId.equals("")) && (itemId != null && !itemId.equals(""))) {
            query = sqlMgr.getSql("getByBrandSiteTaskItem").trim();

            SQLparams.addElement(new StringValue(itemId));
            SQLparams.addElement(new StringValue(taskId));

        } else if (taskId != null && !taskId.equals("")) {
            query = sqlMgr.getSql("getByBrandSiteTask").trim();

            SQLparams.addElement(new StringValue(taskId));

        } else if (itemId != null && !itemId.equals("")) {
            query = sqlMgr.getSql("getByBrandSiteItem").trim();

            SQLparams.addElement(new StringValue(itemId));

        } else {
            query = sqlMgr.getSql("getByBrandSite").trim();
        }

        // replace all value as mmm,ccc, .. by true value
        query = query.replaceAll("ppp", brand);
        query = query.replaceAll("sss", site);
        query = query.replaceAll("ttt", trade);
        query = query.replaceAll("ccc", currenStatus);
        query = query.replaceAll("date_order", dateOrder);
        
        if (issueTitle.equals("Emergency")) {
            query = query.replaceAll("iii1", "");
            query = query.replaceAll("iii2", "Emergency");
        } else if(issueTitle.equals("notEmergency")){
            query = query.replaceAll("iii1", "NOT");
            query = query.replaceAll("iii2", "Emergency");
        }else {
            query = query.replaceAll("iii1", "");
            query = query.replaceAll("iii2", "");
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
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
            reultBusObjs.add((WebBusinessObject) fabricateBusObj(r));
        }

        return reultBusObjs;


    }

    public Vector getAllMaintenanceBySites(WebBusinessObject wbo) {
        Connection connection = null;

        String dateOrder = (String) wbo.getAttribute("dateOrder");

        DateParser parser = new DateParser();
        String startDate = (String) wbo.getAttribute("beginDate");
        String endDate = (String) wbo.getAttribute("endDate");
        java.sql.Date sqlStartDate, sqlEndDate;
        sqlStartDate = parser.formatSqlDate(startDate);
        sqlEndDate = parser.formatSqlDate(endDate);

        // to get resualt at the same day from end day add one day to end date
        sqlEndDate.setDate(sqlEndDate.getDate() + 1);

        String query;

        String site = Tools.concatenation((String[]) wbo.getAttribute("site"), ",");
        String issueTitle = (String) wbo.getAttribute("issueTitle");
        String currenStatus = Tools.concatenation((String[]) wbo.getAttribute("currentStatus"), ",");

        Vector SQLparams = new Vector();
        SQLparams.addElement(new DateValue(sqlStartDate));
        SQLparams.addElement(new DateValue(sqlEndDate));

        query = sqlMgr.getSql("getSitesBySite").trim();

        // replace all value as mmm,ccc, .. by true value
        query = query.replaceAll("sss", site);
        query = query.replaceAll("ccc", currenStatus);
        query = query.replaceAll("date_order", dateOrder);

        if (issueTitle.equals("Emergency")) {
            query = query.replaceAll("iii1", "");
            query = query.replaceAll("iii2", "Emergency");
        } else if(issueTitle.equals("notEmergency")){
            query = query.replaceAll("iii1", "NOT");
            query = query.replaceAll("iii2", "Emergency");
        }else {
            query = query.replaceAll("iii1", "");
            query = query.replaceAll("iii2", "");
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
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
            reultBusObjs.add((WebBusinessObject) fabricateBusObj(r));
        }

        return reultBusObjs;


    }

    public Vector getAllMaintenanceByEquip(WebBusinessObject wbo) {
        Connection connection = null;

        String taskId = (String) wbo.getAttribute("taskId");
        String itemId = (String) wbo.getAttribute("itemId");
        String unitId = (String) wbo.getAttribute("unitId");
        String dateOrder = (String) wbo.getAttribute("dateOrder");

        DateParser parser = new DateParser();
        String startDate = (String) wbo.getAttribute("beginDate");
        String endDate = (String) wbo.getAttribute("endDate");
        java.sql.Date sqlStartDate, sqlEndDate;
        sqlStartDate = parser.formatSqlDate(startDate);
        sqlEndDate = parser.formatSqlDate(endDate);

        // to get resualt at the same day from end day add one day to end date
        sqlEndDate.setDate(sqlEndDate.getDate() + 1);

        String query;

        String trade = Tools.concatenation((String[]) wbo.getAttribute("trade"), ",");
        String issueTitle = (String) wbo.getAttribute("issueTitle");
        String currenStatus = Tools.concatenation((String[]) wbo.getAttribute("currentStatus"), ",");

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(unitId));
        SQLparams.addElement(new DateValue(sqlStartDate));
        SQLparams.addElement(new DateValue(sqlEndDate));

        if ((taskId != null && !taskId.equals("")) && (itemId != null && !itemId.equals(""))) {
            query = sqlMgr.getSql("getByEquipTaskItem").trim();

            SQLparams.addElement(new StringValue(itemId));
            SQLparams.addElement(new StringValue(taskId));

        } else if (taskId != null && !taskId.equals("")) {
            query = sqlMgr.getSql("getByEquipTask").trim();

            SQLparams.addElement(new StringValue(taskId));

        } else if (itemId != null && !itemId.equals("")) {
            query = sqlMgr.getSql("getByEquipItem").trim();

            SQLparams.addElement(new StringValue(itemId));

        } else {
            query = sqlMgr.getSql("getByEquip").trim();
        }

        // replace all value as mmm,ccc, .. by true value
        query = query.replaceAll("ttt", trade);
        query = query.replaceAll("ccc", currenStatus);
        query = query.replaceAll("date_order", dateOrder);

        if (issueTitle.equals("Emergency")) {
            query = query.replaceAll("iii1", "");
            query = query.replaceAll("iii2", "Emergency");
        } else if(issueTitle.equals("notEmergency")){
            query = query.replaceAll("iii1", "NOT");
            query = query.replaceAll("iii2", "Emergency");
        }else {
            query = query.replaceAll("iii1", "");
            query = query.replaceAll("iii2", "");
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
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
            reultBusObjs.add((WebBusinessObject) fabricateBusObj(r));
        }

        return reultBusObjs;
    }

    public Vector getAllMaintenanceBySiteType(WebBusinessObject wbo, IssueTitle issueTitle) {
        Connection connection = null;
        String taskId = (String) wbo.getAttribute("taskId");
        String itemId = (String) wbo.getAttribute("itemId");
        String unitId = (String) wbo.getAttribute("unitId");
        String dateOrder = (String) wbo.getAttribute("date_order");
        

        DateParser parser = new DateParser();
        String startDate = (String) wbo.getAttribute("beginDate");
        String endDate = (String) wbo.getAttribute("endDate");
        java.sql.Date sqlStartDate, sqlEndDate;
        sqlStartDate = parser.formatSqlDate(startDate);
        sqlEndDate = parser.formatSqlDate(endDate);

        String mainType = Tools.concatenation((String[]) wbo.getAttribute("mainType"), ",");
        String site = Tools.concatenation((String[]) wbo.getAttribute("site"), ",");
        String trade = Tools.concatenation((String[]) wbo.getAttribute("trade"), ",");


        // to get resualt at the same day from end day add one day to end date

        sqlEndDate.setDate(sqlEndDate.getDate() + 1);
        String query;
        Vector SQLparams = new Vector();
       
        SQLparams.addElement(new DateValue(sqlStartDate));
        SQLparams.addElement(new DateValue(sqlEndDate));

        if ((taskId != null && !taskId.equals("")) && (itemId != null && !itemId.equals(""))) {
            query = sqlMgr.getSql("getByTypeSiteTaskItemWithoutTitleStatus").trim();

            SQLparams.addElement(new StringValue(itemId));
            SQLparams.addElement(new StringValue(taskId));

        } else if (taskId != null && !taskId.equals("")) {
            query = sqlMgr.getSql("getByTypeSiteTaskWithoutTitleStatus").trim();

            SQLparams.addElement(new StringValue(taskId));

        } else if (itemId != null && !itemId.equals("")) {
            query = sqlMgr.getSql("getByTypeSiteItemWithoutTitleStatus").trim();

            SQLparams.addElement(new StringValue(itemId));

        } else {
            query = sqlMgr.getSql("getByTypeSiteWithoutTitleStatus").trim();
        }
       
       
         
        query = query.replaceAll("mmm", mainType);
        query = query.replaceAll("sss", site);
        query = query.replaceAll("ttt", trade);
        query = query.replaceAll("date_order", dateOrder);
       // replace all value as mmm,ccc, .. by true value
       

        if (issueTitle.equals("Emergency")) {
            query = query.replaceAll("iii1", "");
            query = query.replaceAll("iii2", "Emergency");
        } else if(issueTitle.equals("notEmergency")){
            query = query.replaceAll("iii1", "NOT");
            query = query.replaceAll("iii2", "Emergency");
        }else {
            query = query.replaceAll("iii1", "");
            query = query.replaceAll("iii2", "");
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
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
            reultBusObjs.add((WebBusinessObject) fabricateBusObj(r));
        }

        return reultBusObjs;


    }
     public Vector getInspectionOrderData(WebBusinessObject wbo, IssueTitle issueTitle) {
        Connection connection = null;

        String date_order = (String) wbo.getAttribute("date_order");

        DateParser parser = new DateParser();
        String startDate = (String) wbo.getAttribute("beginDate");
        String endDate = (String) wbo.getAttribute("endDate");
        java.sql.Date sqlStartDate, sqlEndDate;
        sqlStartDate = parser.formatSqlDate(startDate);
        sqlEndDate = parser.formatSqlDate(endDate);

       // String mainType = Tools.concatenation((String[]) wbo.getAttribute("mainType"), ",");
        String site = Tools.concatenation((String[]) wbo.getAttribute("site"), ",");
        String trade = Tools.concatenation((String[]) wbo.getAttribute("trade"), ",");


        // to get resualt at the same day from end day add one day to end date

        sqlEndDate.setDate(sqlEndDate.getDate() + 1);
        String query;
        Vector SQLparams = new Vector();
        if(wbo.getAttribute("unitId")!=null){
            query = sqlMgr.getSql("t2").trim();
            SQLparams.addElement(new StringValue(wbo.getAttribute("unitId").toString()));

        }else if(wbo.getAttribute("models")!=null){
            query = sqlMgr.getSql("t1").trim();
            String models = Tools.concatenation((String[]) wbo.getAttribute("models"), ",");
            query = query.replaceAll("mmm", models);

            System.out.println("XXXXXXXXXXXXXXXX");
        }else{
            query = sqlMgr.getSql("getByTypeSiteWithoutTitleStatus").trim();
            String mainType = Tools.concatenation((String[]) wbo.getAttribute("mainType"), ",");
            query = query.replaceAll("mmm", mainType);
            System.out.println("UUUUUUUUUUUUUUUU");
        }
        SQLparams.addElement(new DateValue(sqlStartDate));
        SQLparams.addElement(new DateValue(sqlEndDate));

        query = query.replaceAll("sss", site);
        query = query.replaceAll("ttt", trade);
        query = query.replaceAll("date_order", date_order);
       // replace all value as mmm,ccc, .. by true value


        if (issueTitle.equals("Emergency")) {
            query = query.replaceAll("iii1", "");
            query = query.replaceAll("iii2", "Emergency");
        } else if(issueTitle.equals("notEmergency")){
            query = query.replaceAll("iii1", "NOT");
            query = query.replaceAll("iii2", "Emergency");
        }else {
            query = query.replaceAll("iii1", "");
            query = query.replaceAll("iii2", "");
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
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
            reultBusObjs.add((WebBusinessObject) fabricateBusObj(r));
        }

        return reultBusObjs;


    }


    public Vector getAllMaintenanceBySiteBrand(WebBusinessObject wbo, IssueTitle issueTitle) {
        Connection connection = null;

        String taskId = (String) wbo.getAttribute("taskId");
        String itemId = (String) wbo.getAttribute("itemId");

        String date_order = (String) wbo.getAttribute("date_order");

        DateParser parser = new DateParser();
        String startDate = (String) wbo.getAttribute("beginDate");
        String endDate = (String) wbo.getAttribute("endDate");
        java.sql.Date sqlStartDate, sqlEndDate;
        sqlStartDate = parser.formatSqlDate(startDate);
        sqlEndDate = parser.formatSqlDate(endDate);

        // to get resualt at the same day from end day add one day to end date
        sqlEndDate.setDate(sqlEndDate.getDate() + 1);

        String query;

        String brand = Tools.concatenation((String[]) wbo.getAttribute("brand"), ",");
        String site = Tools.concatenation((String[]) wbo.getAttribute("site"), ",");
        String trade = Tools.concatenation((String[]) wbo.getAttribute("trade"), ",");

        Vector SQLparams = new Vector();
        SQLparams.addElement(new DateValue(sqlStartDate));
        SQLparams.addElement(new DateValue(sqlEndDate));

        if ((taskId != null && !taskId.equals("")) && (itemId != null && !itemId.equals(""))) {
            query = sqlMgr.getSql("getByBrandSiteTaskItemWithoutTitleStatus").trim();

            SQLparams.addElement(new StringValue(itemId));
            SQLparams.addElement(new StringValue(taskId));

        } else if (taskId != null && !taskId.equals("")) {
            query = sqlMgr.getSql("getByBrandSiteTaskWithoutTitleStatus").trim();

            SQLparams.addElement(new StringValue(taskId));

        } else if (itemId != null && !itemId.equals("")) {
            query = sqlMgr.getSql("getByBrandSiteItemWithoutTitleStatus").trim();

            SQLparams.addElement(new StringValue(itemId));

        } else {
            query = sqlMgr.getSql("getByBrandSiteWithoutTitleStatus").trim();
        }

        // replace all value as mmm,ccc, .. by true value
        query = query.replaceAll("ppp", brand);
        query = query.replaceAll("sss", site);
        query = query.replaceAll("ttt", trade);
        query = query.replaceAll("date_order", date_order);

        if (issueTitle.equals(IssueTitle.Emergency)) {
            query = query.replaceAll("iii1", "");
            query = query.replaceAll("iii2", "Emergency");
        } else if(issueTitle.equals(IssueTitle.NotEmergency)){
            query = query.replaceAll("iii1", "NOT");
            query = query.replaceAll("iii2", "Emergency");
        }else {
            query = query.replaceAll("iii1", "");
            query = query.replaceAll("iii2", "");
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
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
            reultBusObjs.add((WebBusinessObject) fabricateBusObj(r));
        }

        return reultBusObjs;


    }

    public Vector getAllMaintInfoOnCostCenters(WebBusinessObject wbo, IssueTitle issueTitle) {
        Connection connection = null;

        String[] costCodes = (String[]) wbo.getAttribute("costCode");
        String date_order = (String) wbo.getAttribute("date_order");

        DateParser parser = new DateParser();
        String startDate = (String) wbo.getAttribute("beginDate");
        String endDate = (String) wbo.getAttribute("endDate");
        java.sql.Date sqlStartDate, sqlEndDate;
        sqlStartDate = parser.formatSqlDate(startDate);
        sqlEndDate = parser.formatSqlDate(endDate);

        // to get resualt at the same day from end day add one day to end date
        sqlEndDate.setDate(sqlEndDate.getDate() + 1);

        String query;

        String site = Tools.concatenation((String[]) wbo.getAttribute("site"), ",");

        Vector SQLparams = new Vector();
        SQLparams.addElement(new DateValue(sqlStartDate));
        SQLparams.addElement(new DateValue(sqlEndDate));

        if (costCodes != null && costCodes[0].equals("allCostCenters")) {
            query = sqlMgr.getSql("getAllMaintInfoOnAllCostCenters").trim();
        } else {
            query = sqlMgr.getSql("getAllMaintInfoOnCostCenter").trim();
            String costCode = Tools.concatenation((String[]) wbo.getAttribute("costCode"), ",");
            query = query.replaceAll("costCodeValue", costCode);
        }

        // replace all value as mmm,ccc, .. by true value
        query = query.replaceAll("sss", site);
        query = query.replaceAll("date_order", date_order);

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
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
            reultBusObjs.add((WebBusinessObject) fabricateBusObj(r));
        }

        return reultBusObjs;
    }

    
    public Vector getAllMaintenanceBySites(WebBusinessObject wbo, IssueTitle issueTitle) {
        Connection connection = null;

        /*String taskId = (String) wbo.getAttribute("taskId");
        String itemId = (String) wbo.getAttribute("itemId");*/

        String date_order = (String) wbo.getAttribute("date_order");

        DateParser parser = new DateParser();
        String startDate = (String) wbo.getAttribute("beginDate");
        String endDate = (String) wbo.getAttribute("endDate");
        java.sql.Date sqlStartDate, sqlEndDate;
        sqlStartDate = parser.formatSqlDate(startDate);
        sqlEndDate = parser.formatSqlDate(endDate);

        // to get resualt at the same day from end day add one day to end date
        sqlEndDate.setDate(sqlEndDate.getDate() + 1);

        String query;

        String site = Tools.concatenation((String[]) wbo.getAttribute("site"), ",");
        //String trade = Tools.concatenation((String[]) wbo.getAttribute("trade"), ",");

        Vector SQLparams = new Vector();
        SQLparams.addElement(new DateValue(sqlStartDate));
        SQLparams.addElement(new DateValue(sqlEndDate));

        /*if ((taskId != null && !taskId.equals("")) && (itemId != null && !itemId.equals(""))) {
            query = sqlMgr.getSql("getBySitesTaskItemWithoutTitleStatus").trim();

            SQLparams.addElement(new StringValue(itemId));
            SQLparams.addElement(new StringValue(taskId));

        } else if (taskId != null && !taskId.equals("")) {
            query = sqlMgr.getSql("getBySitesTaskWithoutTitleStatus").trim();

            SQLparams.addElement(new StringValue(taskId));

        } else if (itemId != null && !itemId.equals("")) {
            query = sqlMgr.getSql("getBySitesItemWithoutTitleStatus").trim();

            SQLparams.addElement(new StringValue(itemId));

        } else {*/
            query = sqlMgr.getSql("getBySitesWithoutTitleStatus").trim();
        //}

        // replace all value as mmm,ccc, .. by true value
        query = query.replaceAll("sss", site);
        //query = query.replaceAll("ttt", trade);
        query = query.replaceAll("date_order", date_order);

        if (issueTitle.equals(IssueTitle.Emergency)) {
            query = query.replaceAll("iii1", "");
            query = query.replaceAll("iii2", "Emergency");
        } else if(issueTitle.equals(IssueTitle.NotEmergency)){
            query = query.replaceAll("iii1", "NOT");
            query = query.replaceAll("iii2", "Emergency");
        }else {
            query = query.replaceAll("iii1", "");
            query = query.replaceAll("iii2", "");
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
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
            reultBusObjs.add((WebBusinessObject) fabricateBusObj(r));
        }

        return reultBusObjs;


    }

    public Vector getAllMaintenanceByTasks(WebBusinessObject wbo, IssueTitle issueTitle) {
        Connection connection = null;

        String taskId = (String) wbo.getAttribute("taskId");
        /*String itemId = (String) wbo.getAttribute("itemId");*/

        String date_order = (String) wbo.getAttribute("date_order");

        DateParser parser = new DateParser();
        String startDate = (String) wbo.getAttribute("beginDate");
        String endDate = (String) wbo.getAttribute("endDate");
        java.sql.Date sqlStartDate, sqlEndDate;
        sqlStartDate = parser.formatSqlDate(startDate);
        sqlEndDate = parser.formatSqlDate(endDate);

        // to get resualt at the same day from end day add one day to end date
        sqlEndDate.setDate(sqlEndDate.getDate() + 1);

        String query;

        String site = Tools.concatenation((String[]) wbo.getAttribute("site"), ",");
        //String trade = Tools.concatenation((String[]) wbo.getAttribute("trade"), ",");

        Vector SQLparams = new Vector();
        SQLparams.addElement(new DateValue(sqlStartDate));
        SQLparams.addElement(new DateValue(sqlEndDate));

        /*if ((taskId != null && !taskId.equals("")) && (itemId != null && !itemId.equals(""))) {
            query = sqlMgr.getSql("getBySitesTaskItemWithoutTitleStatus").trim();

            SQLparams.addElement(new StringValue(itemId));
            SQLparams.addElement(new StringValue(taskId));

        } else if (taskId != null && !taskId.equals("")) {
            query = sqlMgr.getSql("getBySitesTaskWithoutTitleStatus").trim();

            SQLparams.addElement(new StringValue(taskId));

        } else if (itemId != null && !itemId.equals("")) {
            query = sqlMgr.getSql("getBySitesItemWithoutTitleStatus").trim();

            SQLparams.addElement(new StringValue(itemId));

        } else {*/
            query = sqlMgr.getSql("getAllMaintenanceByTasks").trim();
            SQLparams.addElement(new StringValue(taskId));
        //}

        // replace all value as mmm,ccc, .. by true value
        query = query.replaceAll("sss", site);
        //query = query.replaceAll("ttt", trade);
        query = query.replaceAll("date_order", date_order);

        if (issueTitle.equals(IssueTitle.Emergency)) {
            query = query.replaceAll("iii1", "");
            query = query.replaceAll("iii2", "Emergency");
        } else if(issueTitle.equals(IssueTitle.NotEmergency)){
            query = query.replaceAll("iii1", "NOT");
            query = query.replaceAll("iii2", "Emergency");
        }else {
            query = query.replaceAll("iii1", "");
            query = query.replaceAll("iii2", "");
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
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
            reultBusObjs.add((WebBusinessObject) fabricateBusObj(r));
        }

        return reultBusObjs;


    }

    public Vector getAllMaintenanceByEquip(WebBusinessObject wbo, IssueTitle issueTitle) {
        Connection connection = null;

        String taskId = (String) wbo.getAttribute("taskId");
        String itemId = (String) wbo.getAttribute("itemId");
        String unitId = (String) wbo.getAttribute("unitId");

        String date_order = (String) wbo.getAttribute("date_order");

        DateParser parser = new DateParser();
        String startDate = (String) wbo.getAttribute("beginDate");
        String endDate = (String) wbo.getAttribute("endDate");
        java.sql.Date sqlStartDate, sqlEndDate;
        sqlStartDate = parser.formatSqlDate(startDate);
        sqlEndDate = parser.formatSqlDate(endDate);

        // to get resualt at the same day from end day add one day to end date
        sqlEndDate.setDate(sqlEndDate.getDate() + 1);

        String query;

        String trade = Tools.concatenation((String[]) wbo.getAttribute("trade"), ",");
        String site = Tools.concatenation((String[]) wbo.getAttribute("site"), ",");
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(unitId));
        SQLparams.addElement(new DateValue(sqlStartDate));
        SQLparams.addElement(new DateValue(sqlEndDate));

        if ((taskId != null && !taskId.equals("")) && (itemId != null && !itemId.equals(""))) {
            query = sqlMgr.getSql("getByEquipTaskItemWithoutTitleStatus").trim();

            SQLparams.addElement(new StringValue(itemId));
            SQLparams.addElement(new StringValue(taskId));

        } else if (taskId != null && !taskId.equals("")) {
            query = sqlMgr.getSql("getByEquipTaskWithoutTitleStatus").trim();

            SQLparams.addElement(new StringValue(taskId));

        } else if (itemId != null && !itemId.equals("")) {
            query = sqlMgr.getSql("getByEquipItemWithoutTitleStatus").trim();

            SQLparams.addElement(new StringValue(itemId));

        } else {
            query = sqlMgr.getSql("getByEquipWithoutTitleStatus").trim();            
        }

        // replace all value as mmm,ccc, .. by true value
        query = query.replaceAll("ttt", trade);
        query = query.replaceAll("date_order", date_order);
        query = query.replaceAll("sss", site);

        if (issueTitle.equals("Emergency")) {
            query = query.replaceAll("iii1", "");
            query = query.replaceAll("iii2", "Emergency");
        } else if(issueTitle.equals("notEmergency")){
            query = query.replaceAll("iii1", "NOT");
            query = query.replaceAll("iii2", "Emergency");
        }else {
            query = query.replaceAll("iii1", "");
            query = query.replaceAll("iii2", "");
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
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
            reultBusObjs.add((WebBusinessObject) fabricateBusObj(r));
        }

        return reultBusObjs;
    }

    public Vector getDetailsMaintenanceByMaintNum(String from, String to) {
        Connection connection = null;
        Vector SQLparams = new Vector();
        SQLparams.add(new IntValue(Integer.parseInt(from)));
        SQLparams.add(new IntValue(Integer.parseInt(to)));
        Vector resultSet = new Vector();
        SQLCommandBean forSelect = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forSelect.setConnection(connection);
            String query = sqlMgr.getSql("getDetailsMaintenanceByMaintNum").trim();
            forSelect.setSQLQuery(query);
            forSelect.setparams(SQLparams);
            resultSet = forSelect.executeQuery();
        } catch (Exception ex) {
            Logger.getLogger(AllMaintenanceInfoMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("troubles closing connection " + ex.getMessage());
            }
        }

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = resultSet.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add((WebBusinessObject) fabricateBusObj(r));
        }

        return reultBusObjs;
    }

    public Vector getAllMaintenanceByMaintNum(String from, String to) {
        Connection connection = null;
        Vector SQLparams = new Vector();
        SQLparams.add(new IntValue(Integer.parseInt(from)));
        SQLparams.add(new IntValue(Integer.parseInt(to)));

        Vector resultSet = new Vector();
        SQLCommandBean forSelect = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forSelect.setConnection(connection);
            String query = sqlMgr.getSql("getAllMaintenanceInfobyMaintNumForAnySchedule").trim();
            forSelect.setSQLQuery(query);
            forSelect.setparams(SQLparams);
            resultSet = forSelect.executeQuery();
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("troubles closing connection " + ex.getMessage());
            }
        }

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = resultSet.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add((WebBusinessObject) fabricateBusObj(r));
        }

        return reultBusObjs;
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        cashData();
        for (int i = 0; i < cashedTable.size(); i++) {
            cashedData.add((WebBusinessObject) cashedTable.get(i));
        }
        return cashedData;
    }

    public Vector getCostingReports(WebBusinessObject wbo) throws SQLException {
        String reportType = wbo.getAttribute("reportType").toString();
        Connection connection = dataSource.getConnection();
        SQLCommandBean forSelect = new SQLCommandBean();
        String query = null;
        Vector parameters = new Vector();
        DateParser parser = new DateParser();
        java.sql.Date sqlStartDate, sqlEndDate;

        sqlStartDate = parser.formatSqlDate(wbo.getAttribute("beginDate").toString());
        sqlEndDate = parser.formatSqlDate(wbo.getAttribute("endDate").toString());

        // to get resualt at the same day from end day add one day to end date
        sqlEndDate.setDate(sqlEndDate.getDate() + 1);

        String site = Tools.concatenation((String[]) wbo.getAttribute("site"), ",");
        
        Vector<Row> result = new Vector();
        Vector data = new Vector();
        forSelect.setConnection(connection);
        if (reportType.equals("mainTypeRadio")) {
            query = sqlMgr.getSql("getCostingReportsByMainType").trim().replace("XXX", Tools.concatenation((String[]) wbo.getAttribute("mainType"), ","));

            parameters.addElement(new DateValue(sqlStartDate));
            parameters.addElement(new DateValue(sqlEndDate));
            parameters.addElement(new DateValue(sqlStartDate));
            parameters.addElement(new DateValue(sqlEndDate));
            parameters.addElement(new DateValue(sqlStartDate));
            parameters.addElement(new DateValue(sqlEndDate));

        } else if (reportType.equals("brandRadio")) {
            query = sqlMgr.getSql("getCostingReportsByBrand").trim().replace("XXX", Tools.concatenation((String[]) wbo.getAttribute("brand"), ","));

            parameters.addElement(new DateValue(sqlStartDate));
            parameters.addElement(new DateValue(sqlEndDate));
            parameters.addElement(new DateValue(sqlStartDate));
            parameters.addElement(new DateValue(sqlEndDate));
            parameters.addElement(new DateValue(sqlStartDate));
            parameters.addElement(new DateValue(sqlEndDate));

        } else if (reportType.equals("unit")) {
            if (wbo.getAttribute("unitId") != null && wbo.getAttribute("unitId") != "") {
                query = sqlMgr.getSql("getCostingReportsByUnit").trim();

                parameters.addElement(new DateValue(sqlStartDate));
                parameters.addElement(new DateValue(sqlEndDate));
                parameters.addElement(new StringValue(wbo.getAttribute("unitId").toString()));
                parameters.addElement(new DateValue(sqlStartDate));
                parameters.addElement(new DateValue(sqlEndDate));
                parameters.addElement(new StringValue(wbo.getAttribute("unitId").toString()));
                parameters.addElement(new DateValue(sqlStartDate));
                parameters.addElement(new DateValue(sqlEndDate));
                parameters.addElement(new StringValue(wbo.getAttribute("unitId").toString()));
                
            } else {
                query = sqlMgr.getSql("getCostingReportsByAllUnits").trim();

                parameters.addElement(new DateValue(sqlStartDate));
                parameters.addElement(new DateValue(sqlEndDate));
                parameters.addElement(new DateValue(sqlStartDate));
                parameters.addElement(new DateValue(sqlEndDate));
                parameters.addElement(new DateValue(sqlStartDate));
                parameters.addElement(new DateValue(sqlEndDate));

            }
        }

        query = query.replaceAll("SSS", site);

        forSelect.setSQLQuery(query);
        forSelect.setparams(parameters);
        try {
            result = forSelect.executeQuery();
        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(AllMaintenanceInfoMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        connection.close();
        WebBusinessObject temp;
        for (Row r : result) {
            temp = new WebBusinessObject();
            try {
                temp.setAttribute("itemsTotalCost", r.getBigDecimal("ITEMS_TOTAL_COST"));
                temp.setAttribute("laborsTotalCost", r.getBigDecimal("LABORS_TOTAL_COST"));
                temp.setAttribute("typeName", r.getString("TYPE_NAME"));
                temp.setAttribute("externalCost", r.getBigDecimal("EXTERNAL_COST"));
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(AllMaintenanceInfoMgr.class.getName()).log(Level.SEVERE, null, ex);
            } catch (UnsupportedConversionException ex) {
                Logger.getLogger(AllMaintenanceInfoMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            data.add(temp);
        }
        return data;
    }

    public Vector getCostingReportsGroup(WebBusinessObject wbo) throws SQLException {
        String reportType = wbo.getAttribute("reportType").toString();
        String sub = wbo.getAttribute("sub").toString();
        Connection connection = dataSource.getConnection();
        SQLCommandBean forSelect = new SQLCommandBean();
        String query = null;
        String site = Tools.concatenation((String[]) wbo.getAttribute("site"), ",");
        Vector parameters = new Vector();
        DateParser parser = new DateParser();
        java.sql.Date sqlStartDate, sqlEndDate;
        sqlStartDate = parser.formatSqlDate(wbo.getAttribute("beginDate").toString());
        sqlEndDate = parser.formatSqlDate(wbo.getAttribute("endDate").toString());
        
        // to get resualt at the same day from end day add one day to end date
        sqlEndDate.setDate(sqlEndDate.getDate() + 1);

        parameters.addElement(new DateValue(sqlStartDate));
        parameters.addElement(new DateValue(sqlEndDate));
        parameters.addElement(new DateValue(sqlStartDate));
        parameters.addElement(new DateValue(sqlEndDate));
        parameters.addElement(new DateValue(sqlStartDate));
        parameters.addElement(new DateValue(sqlEndDate));
        Vector<Row> result = new Vector();
        Vector data = new Vector();
        forSelect.setConnection(connection);
        if (reportType.equals("mainTypeRadio") && sub.equals("units")) {
            query = sqlMgr.getSql("getCostingReportsByMainTypeAndUnits").trim().replace("XXX", Tools.concatenation((String[]) wbo.getAttribute("mainType"), ","));
        } else if (reportType.equals("mainTypeRadio") && sub.equals("brands")) {
            query = sqlMgr.getSql("getCostingReportsByMainTypeAndBrands").trim().replace("XXX", Tools.concatenation((String[]) wbo.getAttribute("mainType"), ","));
        } else if (reportType.equals("brandRadio") && sub.equals("units")) {
            query = sqlMgr.getSql("getCostingReportsByBrandAndUnits").trim().replace("XXX", Tools.concatenation((String[]) wbo.getAttribute("brand"), ","));
        }

        query = query.replaceAll("SSS", site);

        forSelect.setSQLQuery(query);
        forSelect.setparams(parameters);
        try {
            result = forSelect.executeQuery();
        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(AllMaintenanceInfoMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        connection.close();
        WebBusinessObject temp;
        for (Row r : result) {
            temp = new WebBusinessObject();
            try {
                temp.setAttribute("itemsTotalCost", r.getBigDecimal("ITEMS_TOTAL_COST"));
                temp.setAttribute("laborsTotalCost", r.getBigDecimal("LABORS_TOTAL_COST"));
                temp.setAttribute("externalCost", r.getBigDecimal("EXTERNAL_COST"));
                temp.setAttribute("mainName", r.getString("MAIN_NAME"));
                temp.setAttribute("mainId", r.getString("MAIN_ID"));
                temp.setAttribute("subName", r.getString("SUB_NAME"));
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(AllMaintenanceInfoMgr.class.getName()).log(Level.SEVERE, null, ex);
            } catch (UnsupportedConversionException ex) {
                Logger.getLogger(AllMaintenanceInfoMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            data.add(temp);
        }
        return data;
    }

    public Vector getAllMaintenanceByDate(WebBusinessObject wbo) {
        Connection connection = null;
        DateParser parser = new DateParser();
        String startDate = (String) wbo.getAttribute("beginDate");
        String endDate = (String) wbo.getAttribute("endDate");
        String[] sites = (String[]) wbo.getAttribute("sites");
        String[] tradeArr = (String[]) wbo.getAttribute("tradeArr");
        String[] mainTypeArr = (String[]) wbo.getAttribute("mainTypeArr");
        String unitId = (String) wbo.getAttribute("unitId");
        String tradeStr = null, mainTypeStr = null;
        
        String site = Tools.concatenation(sites, ",");
        
        if(tradeArr != null && tradeArr.length > 0) {
            tradeStr = Tools.concatenation(tradeArr, ",");
            
        }
        
        if(mainTypeArr != null && mainTypeArr.length > 0) {
            mainTypeStr = Tools.concatenation(mainTypeArr, ",");
            
        }
        
        java.sql.Date sqlStartDate, sqlEndDate;
        sqlStartDate = parser.formatSqlDate(startDate);
        sqlEndDate = parser.formatSqlDate(endDate);

        // to get resualt at the same day from end day add one day to end date
        sqlEndDate.setDate(sqlEndDate.getDate() + 1);
        String query;
        String currenStatus = (String) wbo.getAttribute("currentStatus");

        Vector SQLparams = new Vector();
        SQLparams.addElement(new DateValue(sqlStartDate));
        SQLparams.addElement(new DateValue(sqlEndDate));
        
        if (!currenStatus.equalsIgnoreCase("all")) {
            SQLparams.addElement(new StringValue(currenStatus));
            
            if(unitId.equals("")) {
                query = sqlMgr.getSql("getByMainTypeAndDate").trim();
                query = query.replace("mainTypeParam", mainTypeStr);
                
            } else {
                query = sqlMgr.getSql("getByUnitAndDate").trim();
                SQLparams.addElement(new StringValue(unitId));
            }
            
        } else {
            
            if(unitId.equals("")) {
                query = sqlMgr.getSql("getByMainTypeAndDateAll").trim();
                query = query.replace("mainTypeParam", mainTypeStr);
                
            } else {
                query = sqlMgr.getSql("getByUnitAndDateAll").trim();
                SQLparams.addElement(new StringValue(unitId));
                
            }
            
        }
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        query = query.replace("tradeParam", tradeStr);
        query = query.replace("sitesParam", site);
        
        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
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
            reultBusObjs.add((WebBusinessObject) fabricateBusObj(r));
        }

        return reultBusObjs;
    }


    public Vector getAllMaintenanceByTaskAndModel(WebBusinessObject wbo) {
        Connection connection = null;

        String taskId = (String) wbo.getAttribute("taskId");
        String dateOrder = (String) wbo.getAttribute("dateOrder");

        DateParser parser = new DateParser();
        String startDate = (String) wbo.getAttribute("beginDate");
        String endDate = (String) wbo.getAttribute("endDate");
        java.sql.Date sqlStartDate, sqlEndDate;
        sqlStartDate = parser.formatSqlDate(startDate);
        sqlEndDate = parser.formatSqlDate(endDate);

        // to get resualt at the same day from end day add one day to end date
        sqlEndDate.setDate(sqlEndDate.getDate() + 1);

        String query;

        String brand = Tools.concatenation((String[]) wbo.getAttribute("brand"), ",");
        String site = Tools.concatenation((String[]) wbo.getAttribute("site"), ",");
        String issueTitle = (String) wbo.getAttribute("issueTitle");
        String currenStatus = Tools.concatenation((String[]) wbo.getAttribute("currentStatus"), ",");

        Vector SQLparams = new Vector();
        SQLparams.addElement(new DateValue(sqlStartDate));
        SQLparams.addElement(new DateValue(sqlEndDate));

        query = sqlMgr.getSql("getAllMaintenanceByTaskAndModel").trim();

        SQLparams.addElement(new StringValue(taskId));


        // replace all value as mmm,ccc, .. by true value
        query = query.replaceAll("ppp", brand);
        query = query.replaceAll("sss", site);
        query = query.replaceAll("ccc", currenStatus);
        query = query.replaceAll("date_order", dateOrder);

        if (issueTitle.equals("Emergency")) {
            query = query.replaceAll("iii1", "");
            query = query.replaceAll("iii2", "Emergency");
        } else if(issueTitle.equals("notEmergency")){
            query = query.replaceAll("iii1", "NOT");
            query = query.replaceAll("iii2", "Emergency");
        }else {
            query = query.replaceAll("iii1", "");
            query = query.replaceAll("iii2", "");
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
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
            reultBusObjs.add((WebBusinessObject) fabricateBusObj(r));
        }

        return reultBusObjs;


    }
public Vector getAllMaintenanceByTaskAndEqp(WebBusinessObject wbo) {
        Connection connection = null;

        String taskId = (String) wbo.getAttribute("taskId");
        String dateOrder = (String) wbo.getAttribute("dateOrder");

        DateParser parser = new DateParser();
        String startDate = (String) wbo.getAttribute("beginDate");
        String endDate = (String) wbo.getAttribute("endDate");
        java.sql.Date sqlStartDate, sqlEndDate;
        sqlStartDate = parser.formatSqlDate(startDate);
        sqlEndDate = parser.formatSqlDate(endDate);

        // to get resualt at the same day from end day add one day to end date
        sqlEndDate.setDate(sqlEndDate.getDate() + 1);

        String query;

        String unitId = wbo.getAttribute("unitId").toString();
        String site = Tools.concatenation((String[]) wbo.getAttribute("site"), ",");
        String issueTitle = (String) wbo.getAttribute("issueTitle");
        String currenStatus = Tools.concatenation((String[]) wbo.getAttribute("currentStatus"), ",");

        Vector SQLparams = new Vector();
        SQLparams.addElement(new DateValue(sqlStartDate));
        SQLparams.addElement(new DateValue(sqlEndDate));

        query = sqlMgr.getSql("getAllMaintenanceByTaskAndEqp").trim();

        SQLparams.addElement(new StringValue(taskId));


        // replace all value as mmm,ccc, .. by true value
        query = query.replaceAll("ppp", unitId);
        query = query.replaceAll("sss", site);
        query = query.replaceAll("ccc", currenStatus);
        query = query.replaceAll("date_order", dateOrder);

        if (issueTitle.equals("Emergency")) {
            query = query.replaceAll("iii1", "");
            query = query.replaceAll("iii2", "Emergency");
        } else if(issueTitle.equals("notEmergency")){
            query = query.replaceAll("iii1", "NOT");
            query = query.replaceAll("iii2", "Emergency");
        }else {
            query = query.replaceAll("iii1", "");
            query = query.replaceAll("iii2", "");
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
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
            reultBusObjs.add((WebBusinessObject) fabricateBusObj(r));
        }

        return reultBusObjs;


    }
    public Connection getReportConn() throws SQLException {
        return dataSource.getConnection();
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
