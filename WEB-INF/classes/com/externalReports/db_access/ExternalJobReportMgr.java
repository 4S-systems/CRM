/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.externalReports.db_access;

import com.maintenance.common.DateParser;
import com.maintenance.common.Tools;
import com.maintenance.db_access.AllMaintenanceInfoMgr;
import com.maintenance.db_access.QuantifiedItemsMgr;
import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.SqlMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.DateValue;
import com.silkworm.persistence.relational.IntValue;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author MSaudi
 */
public class ExternalJobReportMgr extends RDBGateWay {

    private static ExternalJobReportMgr ExternalJobReportMgr = new ExternalJobReportMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    public ExternalJobReportMgr() {
    }

    public static ExternalJobReportMgr getInstance() {
        logger.info("Getting ExternalJobReportMgr Instance ....");
        return ExternalJobReportMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("externalJobReport.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Vector genReport(String unit, String unitIndex, String sup, String supIndex, String site, String siteIndex, String[] status, String statusIndex, String sDate, String eDate) throws SQLException, Exception {
        QuantifiedItemsMgr quantifiedItemsMgr = QuantifiedItemsMgr.getInstance();
        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;
        boolean flag = false;
        StringBuffer dq = new StringBuffer("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");
        if (!unit.equals("All")) {
            dq.append(supportedForm.getTableSupported().getAttribute(unitIndex));
            dq.append(" = ?");
            SQLparams.addElement(new StringValue(unit));
            flag = true;
        }
        if (!sup.equals("All")) {
            if (flag == true) {
                dq.append(" AND ");
            }
            dq.append(supportedForm.getTableSupported().getAttribute(supIndex));
            dq.append(" = ?");
            SQLparams.addElement(new StringValue(sup));
            flag = true;
        }
        if (!site.equals("All")) {
            if (flag == true) {
                dq.append(" AND ");
            }
            dq.append(supportedForm.getTableSupported().getAttribute(siteIndex));
            dq.append(" = ?");
            SQLparams.addElement(new StringValue(site));
            flag = true;
        }
        if (flag == true) {
            dq.append(" AND ");
        }
        dq.append(supportedForm.getTableSupported().getAttribute("key5"));
        dq.append(" BETWEEN ? AND ? ");
        SQLparams.addElement(new DateValue(Tools.getSqlDate(sDate)));
        SQLparams.addElement(new DateValue(Tools.getSqlDate(eDate)));
        dq.append(" AND (");
        for (int i = 0; i < status.length; i++) {
            dq.append(supportedForm.getTableSupported().getAttribute(statusIndex));
            dq.append(" = ?");
            SQLparams.addElement(new StringValue(status[i]));
            if (i < status.length - 1) {
                dq.append(" OR ");
            }
        }
        dq.append(" ) ");
        String theQuery = dq.toString();
        logger.info("the query " + theQuery);

        // finally do the query

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        forQuery.setConnection(connection);
        forQuery.setSQLQuery(theQuery);
        forQuery.setparams(SQLparams);
        try {
            queryResult = forQuery.executeQuery();
        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(ExternalJobReportMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            wbo.setAttribute("items", quantifiedItemsMgr.getOnArbitraryKey(wbo.getAttribute("unit_schedule_id").toString(), "key1"));
            reultBusObjs.add(wbo);
        }
        return reultBusObjs;
    }

    public Vector getExternalJOBReportByModel(WebBusinessObject wboList) throws SQLException, Exception {

        String date_order = (String) wboList.getAttribute("date_order");

        DateParser parser = new DateParser();
        String startDate = (String) wboList.getAttribute("beginDate");
        String endDate = (String) wboList.getAttribute("endDate");
        java.sql.Date sqlStartDate, sqlEndDate;
        sqlStartDate = parser.formatSqlDate(startDate);
        sqlEndDate = parser.formatSqlDate(endDate);

        // to get resualt at the same day from end day add one day to end date
        sqlEndDate.setDate(sqlEndDate.getDate() + 1);

        String query;

        String model = Tools.concatenation((String[]) wboList.getAttribute("models"), ",");
        String site = Tools.concatenation((String[]) wboList.getAttribute("site"), ",");
       // String trade = Tools.concatenation((String[]) wboList.getAttribute("trade"), ",");
        String currenStatus = Tools.concatenation((String[]) wboList.getAttribute("currentStatus"), ",");

        Vector SQLparams = new Vector();
        SQLparams.addElement(new DateValue(sqlStartDate));
        SQLparams.addElement(new DateValue(sqlEndDate));

        query = sqlMgr.getSql("getExternalJOByModel").trim();
        //select distinct issue_id,UNIT_SCHEDULE_ID,issue_title,site,site_name,issue_date,current_status,current_status_since,business_id,business_id_by_date,expected_b_date,expected_e_date,actual_begin_date,actual_end_date,trade,unit_id,unit_no,unit_name,parent_id from all_maintenance_info where parent_id in (mmm) and site in (sss) and trade in (ttt) and iii1 issue_title like '%iii2' and current_status in (ccc) and issue_date between ? and ? order by unit_id, date_order,to_number(issue_id),site
        // replace all value as mmm,ccc, .. by true value
        query = query.replaceAll("mmm", model);
        query = query.replaceAll("sss", site);
        //query = query.replaceAll("ttt", trade);
        query = query.replaceAll("ccc", currenStatus);
        query = query.replaceAll("date_order", date_order);

        // finally do the query

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        forQuery.setConnection(connection);
        forQuery.setSQLQuery(query);
        forQuery.setparams(SQLparams);
        try {
            queryResult = forQuery.executeQuery();
        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(ExternalJobReportMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wboList = fabricateBusObj(r);
            //wboList.setAttribute("items", quantifiedItemsMgr.getOnArbitraryKey(wboList.getAttribute("unit_schedule_id").toString(), "key1"));
            reultBusObjs.add(wboList);
        }
        return reultBusObjs;
    }

    public Vector getExternalJOBReportByEquip(WebBusinessObject wboList) throws SQLException, Exception {

        String date_order = (String) wboList.getAttribute("date_order");

        DateParser parser = new DateParser();
        String startDate = (String) wboList.getAttribute("beginDate");
        String endDate = (String) wboList.getAttribute("endDate");
        String unitId = (String) wboList.getAttribute("unitId");
        java.sql.Date sqlStartDate, sqlEndDate;
        sqlStartDate = parser.formatSqlDate(startDate);
        sqlEndDate = parser.formatSqlDate(endDate);

        // to get resualt at the same day from end day add one day to end date
        sqlEndDate.setDate(sqlEndDate.getDate() + 1);

        String query;
        String site = Tools.concatenation((String[]) wboList.getAttribute("site"), ",");
        String currenStatus = Tools.concatenation((String[]) wboList.getAttribute("currentStatus"), ",");

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(unitId));
        SQLparams.addElement(new DateValue(sqlStartDate));
        SQLparams.addElement(new DateValue(sqlEndDate));

        query = sqlMgr.getSql("getExternalJOByEquip").trim();
        //select distinct issue_id,UNIT_SCHEDULE_ID,issue_title,site,site_name,issue_date,current_status,current_status_since,business_id,business_id_by_date,expected_b_date,expected_e_date,actual_begin_date,actual_end_date,trade,unit_id,unit_no,unit_name,parent_id from all_maintenance_info where parent_id in (mmm) and site in (sss) and trade in (ttt) and iii1 issue_title like '%iii2' and current_status in (ccc) and issue_date between ? and ? order by unit_id, date_order,to_number(issue_id),site
        // replace all value as mmm,ccc, .. by true value
        query = query.replaceAll("sss", site);
        query = query.replaceAll("ccc", currenStatus);
        query = query.replaceAll("date_order", date_order);

        // finally do the query

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        forQuery.setConnection(connection);
        forQuery.setSQLQuery(query);
        forQuery.setparams(SQLparams);
        try {
            queryResult = forQuery.executeQuery();
        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(ExternalJobReportMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wboList = fabricateBusObj(r);
            //wboList.setAttribute("items", quantifiedItemsMgr.getOnArbitraryKey(wboList.getAttribute("unit_schedule_id").toString(), "key1"));
            reultBusObjs.add(wboList);
        }
        return reultBusObjs;
    }

    public Vector getExternalJOBReportByMaintNum(String from, String to) {

        Connection connection = null;
        Vector SQLparams = new Vector();
        SQLparams.add(new IntValue(Integer.parseInt(from)));
        SQLparams.add(new IntValue(Integer.parseInt(to)));
        Vector resultSet = new Vector();
        SQLCommandBean forSelect = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forSelect.setConnection(connection);
            String query = sqlMgr.getSql("getExternalJOBReportByMaintNum").trim();
            forSelect.setSQLQuery(query);
            forSelect.setparams(SQLparams);
            resultSet = forSelect.executeQuery();
            
        } catch (Exception ex) {
            Logger.getLogger(ExternalJobReportMgr.class.getName()).log(Level.SEVERE, null, ex);

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

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
}
