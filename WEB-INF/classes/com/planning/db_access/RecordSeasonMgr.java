/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.planning.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.jsptags.DropdownDate;
import com.silkworm.persistence.relational.DateValue;
import com.silkworm.persistence.relational.IntValue;
import com.silkworm.persistence.relational.LongValue;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.TimestampValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author Waled
 */
public class RecordSeasonMgr extends RDBGateWay {

    public static RecordSeasonMgr recordSeasonMgr = new RecordSeasonMgr();

    public static RecordSeasonMgr getInstance() {
        logger.info("Getting SeasonMgr Instance ....");
        return recordSeasonMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("record_season.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        Vector params = new Vector();
        Vector params2 = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1;
        String Id = UniqueIDGen.getNextID();
        params.addElement(new StringValue(Id));
        params.addElement(new StringValue((String) wbo.getAttribute("code")));
        params.addElement(new StringValue((String) wbo.getAttribute("enName")));
        params.addElement(new StringValue((String) wbo.getAttribute("arName")));
        params.addElement(new StringValue((String)wbo.getAttribute("RecordDate")));
        params.addElement(new DateValue(new java.sql.Date(Calendar.getInstance().getTimeInMillis())));
        params.addElement(new StringValue((String) wbo.getAttribute("CommercialRegister")));
        params.addElement(new StringValue((String) wbo.getAttribute("TaxCardNumber")));
        params.addElement(new StringValue((String) wbo.getAttribute("userID")));
        params.addElement(new StringValue((String) wbo.getAttribute("AuthorizedPerson")));
        params.addElement(new StringValue((String) wbo.getAttribute("companyAddress")));
        params.addElement(new StringValue((String) wbo.getAttribute("isForever")));
        params.addElement(new StringValue((String) wbo.getAttribute("noSales")));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("recordSeason").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            
            params2.addElement(new StringValue((String) wbo.getAttribute("enName")));
            forInsert.setSQLQuery(getQuery("recordSeasonCampaign").trim());
            forInsert.setparams(params2);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        return (queryResult > 0);
    }

    public boolean recordSeason(HttpServletRequest request, HttpSession s) {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1;
        DateParser dateParser = new DateParser();
//        String newCode = request.getParameter("recordCode");
//        int index =newCode.indexOf("-");
//        String newCodeGen =newCode.substring(0, index); 
        String beginDate = request.getParameter("begin_date");
        String endDate = request.getParameter("end_date");
        String isForever = request.getParameter("forever");
        if (isForever == null || isForever.isEmpty()) {
            isForever = "0";
        }

        String Id = UniqueIDGen.getNextID();
        params.addElement(new StringValue(Id));
//        params.addElement(new StringValue(request.getParameter("code")));
        params.addElement(new StringValue(request.getParameter("code")));
        params.addElement(new StringValue(request.getParameter("arabic_name")));
        params.addElement(new StringValue(request.getParameter("arabic_name")));
        params.addElement(new DateValue(new java.sql.Date(Calendar.getInstance().getTimeInMillis())));
        params.addElement(new DateValue(new java.sql.Date(Calendar.getInstance().getTimeInMillis())));

//        params.addElement(new StringValue(request.getParameter("end_date")));
//        params.addElement(new DateValue(new java.sql.Date(new Date().getTime())));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue(isForever));
        try {
            //connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("recordSeason").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        return (queryResult > 0);
    }

    public boolean updateRecordSeason(HttpServletRequest request) {

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1;
        String isForever = request.getParameter("forever");
        if (isForever == null || isForever.isEmpty()) {
            isForever = "0";
        }
        //DateParser dropdownDate = new DateParser();
        //String newCode = request.getParameter("recordCode");
        //int index =newCode.indexOf("-");
        //String newCodeGen =newCode.substring(0, index); 
        //String Id = UniqueIDGen.getNextID();
        //params.addElement(new StringValue(Id));
        //params.addElement(new StringValue(newCodeGen));
        params.addElement(new StringValue(request.getParameter("arabic_name")));
        params.addElement(new StringValue(request.getParameter("arabic_name")));
        //params.addElement(new DateValue(dropdownDate.formatSqlDate(request.getParameter("begin_date"))));
        //params.addElement(new DateValue(dropdownDate.formatSqlDate(request.getParameter("end_date"))));
        //params.addElement(new StringValue(request.getParameter("prep_shoulder")));
        //params.addElement(new StringValue(request.getParameter("closer_shoulder")));

        //params.addElement(new StringValue(request.getParameter("recordCode")));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue(isForever));
        params.addElement(new StringValue((String) request.getAttribute("chCode")));

        params.addElement(new StringValue(request.getParameter("id")));
        try {
            //connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("updateRecordSeason").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        return (queryResult > 0);
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public ArrayList<WebBusinessObject> getToolsForCampaign(String campaignID) throws SQLException {
        String theQuery = getQuery("getToolsForCampaign");
        Vector parameters = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {
            parameters.addElement(new StringValue(campaignID));
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }
        Row r;
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            WebBusinessObject wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }
        }
