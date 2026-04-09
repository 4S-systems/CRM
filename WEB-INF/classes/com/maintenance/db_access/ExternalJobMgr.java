package com.maintenance.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.jsptags.DropdownDate;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.servlets.MultipartRequest;
import java.sql.SQLException;
import com.silkworm.util.*;
import java.util.*;
import java.text.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.sql.*;
import com.tracker.common.*;
import com.tracker.business_objects.*;
import org.apache.log4j.xml.DOMConfigurator;

public class ExternalJobMgr extends RDBGateWay {
    
    public static String PART = "part";
    public static String TOTAL = "total";

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static ExternalJobMgr externalJobMgr = new ExternalJobMgr();

    public ExternalJobMgr() {
    }

    public static ExternalJobMgr getInstance() {
        logger.info("Getting ExternalJobMgr Instance ....");
        return externalJobMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("external_job.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(MultipartRequest request, HttpSession s) throws NoUserInSessionException {
        DropdownDate dropdownDate = new DropdownDate();
//        java.sql.Timestamp conversionDate = dropdownDate.getDate(request.getParameter("conversionDate"));

        DateParser dateParser = new DateParser();
        java.sql.Date sqlDate = dateParser.formatSqlDate(request.getParameter("conversionDate"));
        java.sql.Timestamp conversionDate = new java.sql.Timestamp(sqlDate.getTime());

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        Vector docParams = new Vector();
        Vector issueParams = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(request.getParameter("receivedby")));
        params.addElement(new StringValue(request.getParameter("issueId")));
        params.addElement(new TimestampValue(conversionDate));
        params.addElement(new StringValue(request.getParameter("reason")));
        params.addElement(new FloatValue(new Float(request.getParameter("laborCost")).floatValue()));
        params.addElement(new FloatValue(new Float(request.getParameter("partCost")).floatValue()));
        params.addElement(new StringValue(request.getParameter("maintStatment")));
        params.addElement(new StringValue(request.getParameter("type")));

        if (request.getFile("file1") != null) {
            docParams.addElement(new StringValue(UniqueIDGen.getNextID()));
            docParams.addElement(new StringValue(request.getFile("file1").getName()));
            docParams.addElement(new StringValue(request.getParameter("issueId")));
            docParams.addElement(new StringValue("External Job Pic"));
            docParams.addElement(new ImageValue(request.getFile("file1")));
            docParams.addElement(new TimestampValue(conversionDate));
            docParams.addElement(new StringValue(waUser.getAttribute("userId").toString()));
            docParams.addElement(new StringValue(waUser.getAttribute("userName").toString()));
            docParams.addElement(new StringValue("image"));
            docParams.addElement(new StringValue("jpg"));
            docParams.addElement(new StringValue("1"));
        }

        issueParams.addElement(new StringValue((String) request.getParameter("issueId")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertExternalJobSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            forInsert.setSQLQuery(sqlMgr.getSql("updateExternalIssueSQL").trim());
            forInsert.setparams(issueParams);
            queryResult = forInsert.executeUpdate();
            cashData();
            if (request.getFile("file1") != null) {
                forInsert.setSQLQuery(sqlMgr.getSql("insertImageSQL").trim());
                forInsert.setparams(docParams);
                queryResult = forInsert.executeUpdate();
            }

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
            cashedData.add((String) wbo.getAttribute("reason"));
        }

        return cashedData;
    }

    public boolean updateExternalChange(HttpServletRequest request) throws SQLException {
        Connection connection = dataSource.getConnection();
        SQLCommandBean forUpdate = new SQLCommandBean();

        DateParser dateParser = new DateParser();
        java.sql.Date sqlDate = dateParser.formatSqlDate(request.getParameter("conversionDate"));
        java.sql.Timestamp conversionDate = new java.sql.Timestamp(sqlDate.getTime());

        Vector params = new Vector();
        params.addElement(new StringValue(request.getParameter("receivedby")));
        params.addElement(new TimestampValue(conversionDate));
        params.addElement(new StringValue(request.getParameter("reason")));
        params.addElement(new FloatValue(new Float(request.getParameter("laborCost")).floatValue()));
        params.addElement(new StringValue(request.getParameter("maintStatment")));
        params.addElement(new StringValue(request.getParameter("issueId")));

        forUpdate.setConnection(connection);
        forUpdate.setSQLQuery(sqlMgr.getSql("updateExternal"));
        forUpdate.setparams(params);
        int result = forUpdate.executeUpdate();
        connection.close();
        return result > 0;
    }

    @Override
    protected void initSupportedQueries() {
       return; // throw new UnsupportedOperationException("Not supported yet.");
    }
}
