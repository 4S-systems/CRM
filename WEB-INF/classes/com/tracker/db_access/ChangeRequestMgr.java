package com.tracker.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import com.silkworm.util.*;
import java.util.*;
import java.text.*;
import javax.servlet.http.HttpSession;
import java.sql.*;

import com.tracker.business_objects.WebIssue;
import com.tracker.common.*;
import org.apache.log4j.xml.DOMConfigurator;

public class ChangeRequestMgr extends RDBGateWay {

    private static ChangeRequestMgr changeRequestMgr = new ChangeRequestMgr();
    SQLCommandBean forInsert = null;
    private String centralView = null;
    private static final String insertRequestSQL = "INSERT INTO CHANGE_REQUEST VALUES (?,?,?)";
    WebIssue webIssue = null;
    WebBusinessObject viewOrigin = null;

    public static ChangeRequestMgr getInstance() {
        logger.info("Getting changeRequestMgr Instance ....");
        return changeRequestMgr;
    }

    public ChangeRequestMgr() {
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("issue.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(WebBusinessObject wbo, HttpSession s) {

        WebIssue issue = (WebIssue) wbo;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String docID = (String) wbo.getAttribute("docID");
        String requiredChange = (String) wbo.getAttribute("requiredChange");

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(docID));
        params.addElement(new StringValue(requiredChange));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(insertRequestSQL);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
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
        return null;
    }

    public ArrayList getCashedTableAsArrayList() {

        return null;
    }

    protected WebBusinessObject fabricateBusObj(Row r) {

        ListIterator li = supportedForm.getFormElemnts().listIterator();
        FormElement fe = null;
        Hashtable ht = new Hashtable();
        String colName;
        String state = null;
        String issueOwnerId = null;

        while (li.hasNext()) {

            try {
                fe = (FormElement) li.next();
                colName = (String) fe.getAttribute("column");
                // needs a case ......
                ht.put(fe.getAttribute("name"), r.getString(colName));
            } catch (Exception e) {
            // raise an exception

            }

        }


        WebIssue webIssue = new WebIssue(ht);
        // fish for status
        state = (String) webIssue.getAttribute("currentStatus");

        issueOwnerId = (String) webIssue.getAttribute("assignedToId");

        webIssue.setIssueStateObject(webIssue);

        //  webIssue.setViewOrigin(centralView);
        webIssue.setViewrsIds(issueOwnerId, (String) currentUser.getAttribute("userId"));

        return (WebBusinessObject) webIssue;
    }

    public Vector getIssueList(String issueStatus, WebBusinessObject user) {

        centralView = AppConstants.getMatchingView(issueStatus);

        WebBusinessObject wbo = null;
        Connection connection = null;

        StringBuffer query = new StringBuffer("SELECT * FROM ");
        query.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ASSIGNED_TO_ID = ? AND CURRENT_STATUS = ?");

        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue((String) user.getAttribute("userId")));
        SQLparams.addElement(new StringValue(issueStatus));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {

            if (issueStatus.equalsIgnoreCase("SCHEDULE")) {
                return getSearchOnStatus(issueStatus);
            }

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
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

        // process the vector
        // vector of business objects

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }


        return reultBusObjs;


    }

    public Vector getAllIssues() {

        WebBusinessObject issue = null;
        // centralView = new String(AppConstants.LIST_ALL);

        viewOrigin = new WebBusinessObject();
        viewOrigin.setAttribute("filterName", "ListAll");
        viewOrigin.setAttribute("filterValue", "ALL");
        //

        Vector conditionedData = new Vector();



        Vector data = null;
        try {
            data = super.getAllTableRaws();

            Enumeration issueEnum = data.elements();

            while (issueEnum.hasMoreElements()) {
                issue = (WebBusinessObject) issueEnum.nextElement();
                issue.setViewOrigin(viewOrigin);
                conditionedData.addElement(issue);
            }

        } catch (SQLException sqlEx) {
            logger.error("Unable to get All table rows");

        } catch (Exception ex) {


        } finally {

        }
        return conditionedData;
    }

    public Vector getSearchOnStatus(String status) {



        centralView = new String(AppConstants.LIST_SCHEDULE);
        try {
            return super.getSearchOnStatus(status);
        } catch (SQLException seqlEx) {
            ;
        } catch (Exception ex) {
            ;
        }
        return null;
    }

    private boolean executeQuery(String query, Vector p) throws SQLException {
        int queryResult = -1000;
        Vector params = p;

        try {
            forInsert.setSQLQuery(query);

            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
        } catch (Exception ex) {
            logger.error("Save Assigned Issue Exception : " + ex.getMessage());
            return false;
        }

        return (queryResult > 0);
    }

    public Vector getIssuesInRange(String filterName, String filterValue) throws Exception, SQLException {


        QueryMgrFactory qMgrFactory = QueryMgrFactory.getInstance();

        //    setQueryMgr(qMgrFactory.getQueryMgr(filterValue));

        IQueryMgr queryMgr = qMgrFactory.getQueryMgr(filterValue);
//           setQueryMgr(m);

        Vector SQLparams = null;
//        SQLparams.addElement(new DateValue(d1));
//        SQLparams.addElement(new DateValue(d2));

        SQLparams = queryMgr.getQueryVectorParam(filterValue);


        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {
            forQuery.setConnection(connection);
            //forQuery.setSQLQuery(docsInRangeSQL);
            forQuery.setSQLQuery(queryMgr.getQuery(filterName, ""));
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception" + se.getMessage());
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("UnspportedTypeException " + uste.getMessage());
        } catch (Exception ex) {
            logger.error("UNKNOWN Exception" + ex.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        viewOrigin = new WebBusinessObject();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            //  wbo = fabricateBusObj(r);

            webIssue = (WebIssue) fabricateBusObj(r);

            viewOrigin.setAttribute("filter", filterName);
            viewOrigin.setAttribute("filterValue", filterValue);
            webIssue.setViewOrigin(viewOrigin);

            reultBusObjs.add(webIssue);
        }

        return reultBusObjs;
    }

    @Override
    protected void initSupportedQueries() {
    return; //    throw new UnsupportedOperationException("Not supported yet.");
    }
}
