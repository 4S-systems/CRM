package com.maintenance.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.jsptags.DropdownDate;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

public class FailureIssueMachineMgr extends RDBGateWay {

    private static FailureIssueMachineMgr failureIssueMachineMgr = new FailureIssueMachineMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

//    private static final String insertIssueSQL = "INSERT INTO ISSUE_TYPE VALUES (?,?,now(),?)";
    public static FailureIssueMachineMgr getInstance() {
        logger.info("Getting FailureIssueMachineMgr Instance ....");
        return failureIssueMachineMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("failure_issue_machine.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {
//        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
//        WebIssueType issueType = (WebIssueType)wbo;
//        Vector params = new Vector();
//        SQLCommandBean forInsert = new SQLCommandBean();
//        int queryResult = -1000;
//
//        //params.addElement(new StringValue(UniqueIDGen.getNextID()));
//        params.addElement(new StringValue(issueType.getIssueName()));
//        params.addElement(new StringValue(issueType.getIssueDesc()));
//        params.addElement(new StringValue((String)waUser.getAttribute("userId")));
//
//        Connection connection = null;
//        try
//        {
//            connection = dataSource.getConnection();
//            forInsert.setConnection(connection);
//            forInsert.setSQLQuery(insertIssueSQL);
//            forInsert.setparams(params);
//            queryResult = forInsert.executeUpdate();
//
//            //
//            cashData();
//        }
//        catch(SQLException se)
//        {
//            logger.error(se.getMessage());
//            return false;
//        }
//        finally
//        {
//            try
//            {
//                connection.close();
//            }
//            catch(SQLException ex)
//            {
//                logger.error("Close Error");
//                return false;
//            }
//        }
//
//        return (queryResult > 0);
        return false;
    }

    public Vector getFailureUnit(HttpServletRequest request) {
        DropdownDate dropdownDate = new DropdownDate();

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getFailureUnit").trim());
        Vector params = new Vector();
//        java.sql.Timestamp beginDate = dropdownDate.getDate(request.getParameter("beginDate"));
//        java.sql.Timestamp endDate = dropdownDate.getDate(request.getParameter("endDate"));
        
        DateParser dateParser=new DateParser();
        java.sql.Date sqlDate=dateParser.formatSqlDate(request.getParameter("beginDate"));
        java.sql.Timestamp beginDate=new java.sql.Timestamp(sqlDate.getTime());
        
        sqlDate=dateParser.formatSqlDate(request.getParameter("endDate"));
        java.sql.Timestamp endDate=new java.sql.Timestamp(sqlDate.getTime());
        
        String parentId = request.getParameter("unitName").toString();

        params.addElement(new StringValue(parentId));
        params.addElement(new TimestampValue(beginDate));
        params.addElement(new TimestampValue(endDate));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {

        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {

            }
        }
        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getEMGFailureUnit(HttpServletRequest request) {
        DropdownDate dropdownDate = new DropdownDate();

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getEMGFailureUnit").trim());
        Vector params = new Vector();
//        java.sql.Timestamp beginDate = dropdownDate.getDate(request.getParameter("beginDate"));
//        java.sql.Timestamp endDate = dropdownDate.getDate(request.getParameter("endDate"));
       
        DateParser dateParser=new DateParser();
        java.sql.Date sqlDate=dateParser.formatSqlDate(request.getParameter("beginDate"));
        java.sql.Timestamp beginDate=new java.sql.Timestamp(sqlDate.getTime());
        
        sqlDate=dateParser.formatSqlDate(request.getParameter("endDate"));
        java.sql.Timestamp endDate=new java.sql.Timestamp(sqlDate.getTime());
        
        String parentId = request.getParameter("unitName").toString();

        params.addElement(new StringValue(parentId));
        params.addElement(new TimestampValue(beginDate));
        params.addElement(new TimestampValue(endDate));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {

        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {

            }
        }
        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("issueId"));
        }

        return cashedData;
    }

    public boolean getCheckEndDate(String Id) throws Exception {

        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(Id));
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getCheckEndDate").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("database error " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }

        return queryResult.size() > 0;
    }

    public String getEndDate(String issueId) {

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(issueId));

        Connection connection = null;
        String endDate = null;

        StringBuffer query = new StringBuffer(sqlMgr.getSql("getEndDate").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                endDate = r.getString(1);
                if (null == endDate) {
                    endDate = "1";
                }
            }

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } catch (NoSuchColumnException nosuch) {
            logger.error("***** " + nosuch.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        return endDate;

    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
