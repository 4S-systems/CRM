package com.maintenance.db_access;

import com.maintenance.common.DateParser;
import com.maintenance.common.Tools;
import com.silkworm.jsptags.DropdownDate;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.BookmarkMgr;
import com.silkworm.timeutil.DateServices;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import com.tracker.business_objects.WebIssue;
import java.sql.Connection;
import org.apache.log4j.xml.DOMConfigurator;
import com.silkworm.common.FilterQuery;
import com.silkworm.common.SecurityUser;
import com.silkworm.persistence.relational.StringValue;

public class IssueEquipmentMgr extends RDBGateWay {

    private static IssueEquipmentMgr issueEquipmentMgr = new IssueEquipmentMgr();
    WebIssue webIssue = null;
    WebBusinessObject viewOrigin = null;
    SqlMgr sqlMgr = SqlMgr.getInstance();
    BookmarkMgr bookmarkMgr = BookmarkMgr.getInstance();
    FilterQuery filterQuery = new FilterQuery();
    SecurityUser securityUser = new SecurityUser();

    public static IssueEquipmentMgr getInstance() {
        logger.info("Getting IssueEquipmentMgr Instance ....");
        return issueEquipmentMgr;
    }

    public IssueEquipmentMgr() {
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("issue_equipment.xml")));
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
                ht.put(fe.getAttribute("name"), r.getString(colName));
            } catch (Exception e) {
            }
        }
        WebIssue webIssue = new WebIssue(ht);
        state = (String) webIssue.getAttribute("currentStatus");
        if (state == null) {
            webIssue.setAttribute("currentStatus", "Finished");
        }

        issueOwnerId = (String) webIssue.getAttribute("assignedToId");
        webIssue.setIssueStateObject(webIssue);
        String userid = (String) currentUser.getAttribute("userId");
        webIssue.setWebUser(currentUser);
        webIssue.setViewrsIds(issueOwnerId, (String) currentUser.getAttribute("userId"));

        WebBusinessObject bm = bookmarkMgr.getBookmark((String) webIssue.getAttribute("id"), currentUser);
        webIssue.setBookmark(bm);

        String sDate = null;
        long lDeviation = 0;
        sDate = (String) webIssue.getAttribute("expectedEndDate");
        DateServices dt = new DateServices();
        lDeviation = dt.convertMySQLDate("2010-12-31") - dt.convertMySQLDate(sDate);
        String sCurrStatus = (String) webIssue.getAttribute("currentStatus");
        if ((!(sCurrStatus.equalsIgnoreCase("Resolved") || sCurrStatus.equalsIgnoreCase("Finished")) && lDeviation > 0)) {
            webIssue.setAttribute("isDelayed", "true");
        } else {
            webIssue.setAttribute("isDelayed", "false");
        }
        return (WebBusinessObject) webIssue;
    }

    public Vector getIssuesInRange(String filterName, String filterValue) throws Exception, SQLException {

        int firstParamMark = filterValue.indexOf(">");
        int secondParamMark = filterValue.indexOf("<");

        String firstParam = filterValue.substring(firstParamMark + 1, secondParamMark);
        String secondParam = filterValue.substring(secondParamMark + 1);

        int sepPos = filterValue.indexOf(":");
        String fromDate = filterValue.substring(0, sepPos);
        String toDate = filterValue.substring(sepPos + 1, firstParamMark);
        Long fromDateL = new Long(fromDate);
        Long toDateL = new Long(toDate);

        java.sql.Date d1 = new java.sql.Date(fromDateL.longValue());
        java.sql.Date d2 = new java.sql.Date(toDateL.longValue());
        Vector SQLparams = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        SQLparams.addElement(new StringValue(firstParam));
        if (filterValue.indexOf("ALL") >= 0) {
            forQuery.setSQLQuery(sqlMgr.getSql("selectIssueEquipmentListALL"));
        } else {
            SQLparams.addElement(new StringValue(secondParam));
            forQuery.setSQLQuery(sqlMgr.getSql("selectIssueStatusEquipmentListALL"));
        }

        SQLparams.addElement(new DateValue(d1));
        SQLparams.addElement(new DateValue(d2));
        Vector queryResult = null;

        Connection connection = dataSource.getConnection();
        try {
            forQuery.setConnection(connection);
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

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        viewOrigin = new WebBusinessObject();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            webIssue = (WebIssue) fabricateBusObj(r);
            viewOrigin.setAttribute("filter", filterName);
            viewOrigin.setAttribute("filterValue", filterValue);
            webIssue.setViewOrigin(viewOrigin);
            reultBusObjs.add(webIssue);
        }
        return reultBusObjs;
    }

    public Vector getIssuesInRangeByTrade(String filterName, String filterValue, HttpSession s) throws Exception, SQLException {
        filterQuery = new FilterQuery();
        securityUser = new SecurityUser();
        securityUser = (SecurityUser) s.getAttribute("securityUser");

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String userId = waUser.getAttribute("userId").toString();
        String projectId = waUser.getAttribute("projectID").toString();

        int firstParamMark = filterValue.indexOf(">");
        int secondParamMark = filterValue.indexOf("<");

        String firstParam = filterValue.substring(firstParamMark + 1, secondParamMark);
        String secondParam = filterValue.substring(secondParamMark + 1);

        String queryFilter = null;
        if (!securityUser.getSearchBy().equals("") && securityUser.getSearchBy() != null && !securityUser.getSearchBy().equals("all")) {
            queryFilter = filterQuery.getJobOrderQuery(securityUser.getSearchBy());
        }

        int sepPos = filterValue.indexOf(":");
        String fromDate = filterValue.substring(0, sepPos);
        String toDate = filterValue.substring(sepPos + 1, firstParamMark);
        Long fromDateL = new Long(fromDate);
        Long toDateL = new Long(toDate);

        java.sql.Date d1 = new java.sql.Date(fromDateL.longValue());
        java.sql.Date d2 = new java.sql.Date(toDateL.longValue());
        Vector SQLparams = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        SQLparams.addElement(new StringValue(firstParam));

        String branches = Tools.concatenation(securityUser.getBranchesAsArray(), ",");
        if (filterValue.indexOf("ALL") >= 0) {
            String sql = sqlMgr.getSql("selectIssueEquipmentByFilter").trim();
            sql = sql.replaceAll("ppp", branches);
//            forQuery.setSQLQuery(sqlMgr.getSql("selectIssueEquipmentListALLByTrade"));
            if (queryFilter != null && !queryFilter.equals("")) {
                forQuery.setSQLQuery(sql.concat(queryFilter));
            } else {
                forQuery.setSQLQuery(sql);
            }

        } else {
            String sql = sqlMgr.getSql("selectIssueStatusEquipmentByFilter").trim();
            sql = sql.replaceAll("ppp", branches);
            SQLparams.addElement(new StringValue(secondParam));
//            forQuery.setSQLQuery(sqlMgr.getSql("selectIssueStatusEquipmentListALL"));
            if (queryFilter != null && !queryFilter.equals("")) {
                forQuery.setSQLQuery(sql.concat(queryFilter));
            } else {
                forQuery.setSQLQuery(sql);
            }
        }

        SQLparams.addElement(new DateValue(d1));
        SQLparams.addElement(new DateValue(d2));

        if (!securityUser.getSearchBy().equals("") && securityUser.getSearchBy() != null && !securityUser.getSearchBy().equals("all")) {
            if (securityUser.getSearchBy().equals("byTradeAndSite")) {
                SQLparams.addElement(new StringValue(userId));
                SQLparams.addElement(new StringValue(userId));
            } else {
                SQLparams.addElement(new StringValue(userId));
            }
        }
//        SQLparams.addElement(new StringValue(projectId));
        Vector queryResult = null;

        Connection connection = dataSource.getConnection();
        try {
            forQuery.setConnection(connection);
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

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        viewOrigin = new WebBusinessObject();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            webIssue = (WebIssue) fabricateBusObj(r);
            viewOrigin.setAttribute("filter", filterName);
            viewOrigin.setAttribute("filterValue", filterValue);
            webIssue.setViewOrigin(viewOrigin);
            reultBusObjs.add(webIssue);
        }
        return reultBusObjs;
    }

    public Vector getIssuesInRangeByTitle(String filterName, String filterValue, String title) throws Exception, SQLException {



        int firstParamMark = filterValue.indexOf(">");
        int secondParamMark = filterValue.indexOf("<");

        String firstParam = filterValue.substring(firstParamMark + 1, secondParamMark);
        String secondParam = filterValue.substring(secondParamMark + 1);

        int sepPos = filterValue.indexOf(":");
        String fromDate = filterValue.substring(0, sepPos);
        String toDate = filterValue.substring(sepPos + 1, firstParamMark);
        Long fromDateL = new Long(fromDate);
        Long toDateL = new Long(toDate);

        java.sql.Date d1 = new java.sql.Date(fromDateL.longValue());
        java.sql.Date d2 = new java.sql.Date(toDateL.longValue());
        Vector SQLparams = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        SQLparams.addElement(new StringValue(firstParam));


        forQuery.setSQLQuery(" SELECT * FROM issue_equipment WHERE  UNIT_ID = ? AND ISSUE_TITLE = ? AND EXPECTED_B_DATE BETWEEN ?  AND ? ");

        SQLparams.addElement(new StringValue(title));
        SQLparams.addElement(new DateValue(d1));
        SQLparams.addElement(new DateValue(d2));

        Vector queryResult = null;

        Connection connection = dataSource.getConnection();
        try {
            forQuery.setConnection(connection);
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

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        viewOrigin = new WebBusinessObject();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            webIssue = (WebIssue) fabricateBusObj(r);
            viewOrigin.setAttribute("filter", filterName);
            viewOrigin.setAttribute("filterValue", filterValue);
            webIssue.setViewOrigin(viewOrigin);
            reultBusObjs.add(webIssue);
        }
        return reultBusObjs;
    }

    public Vector getALLIssuesByTrade(HttpServletRequest request,String filterName, String filterValue, HttpSession s) throws Exception, SQLException {
        filterQuery = new FilterQuery();
        securityUser = new SecurityUser();
        securityUser = (SecurityUser) s.getAttribute("securityUser");
        String eqCode = request.getParameter("eqCode");

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String userId = waUser.getAttribute("userId").toString();
        String projectId = waUser.getAttribute("projectID").toString();

        int firstParamMark = filterValue.indexOf(">");
        int secondParamMark = filterValue.indexOf("<");

        String firstParam = filterValue.substring(firstParamMark + 1, secondParamMark);
        String secondParam = filterValue.substring(secondParamMark + 1);
        String queryFilter = null;
        if (!securityUser.getSearchBy().equals("") && securityUser.getSearchBy() != null && !securityUser.getSearchBy().equals("all")) {
            queryFilter = filterQuery.getJobOrderQuery(securityUser.getSearchBy());
        }
        int sepPos = filterValue.indexOf(":");
        String fromDate = filterValue.substring(0, sepPos);
        String toDate = filterValue.substring(sepPos + 1, firstParamMark);
        Long fromDateL = new Long(fromDate);
        Long toDateL = new Long(toDate);

        java.sql.Date d1 = new java.sql.Date(fromDateL.longValue());
        java.sql.Date d2 = new java.sql.Date(toDateL.longValue());
        Vector SQLparams = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        if (eqCode != null && eqCode != "") {
            SQLparams.addElement(new StringValue(eqCode));
        }
        //SQLparams.addElement(new StringValue(firstParam));

        String site = securityUser.getSiteId();
        
        String branches = Tools.concatenation(securityUser.getBranchesAsArray(), ",");
        if (filterValue.indexOf("ALL") >= 0) {
            String sql = sqlMgr.getSql("getALLIssuesByFilter").trim();
            sql = sql.replaceAll("ppp", branches);
            // forQuery.setSQLQuery(sqlMgr.getSql("getALLIssuesByTrade"));
            if (queryFilter != null && !queryFilter.equals("")) {
                forQuery.setSQLQuery(sql.concat(queryFilter));
            } else {
                forQuery.setSQLQuery(sql);
            }
        } else {
            String sql = sqlMgr.getSql("selectIssueStatusByFilter").trim();
            sql = sql.replaceAll("ppp", site);
            SQLparams.addElement(new StringValue(secondParam));
//             forQuery.setSQLQuery(sqlMgr.getSql("selectIssueStatusEquipmentListOrder"));
            if (queryFilter != null && !queryFilter.equals("")) {
                forQuery.setSQLQuery(sql.concat(queryFilter));
            } else {
                forQuery.setSQLQuery(sql);
            }
        }



        SQLparams.addElement(new DateValue(d1));
        SQLparams.addElement(new DateValue(d2));

        if (!securityUser.getSearchBy().equals("") && securityUser.getSearchBy() != null && !securityUser.getSearchBy().equals("all")) {
            if (securityUser.getSearchBy().equals("byTradeAndSite")) {
                SQLparams.addElement(new StringValue(userId));
                SQLparams.addElement(new StringValue(userId));
            } else {
                SQLparams.addElement(new StringValue(userId));
            }
        }
//        SQLparams.addElement(new StringValue(projectId));
        Vector queryResult = null;

        Connection connection = dataSource.getConnection();
        try {
            forQuery.setConnection(connection);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
            logger.error("size" + queryResult.size());
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

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        viewOrigin = new WebBusinessObject();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            webIssue = (WebIssue) fabricateBusObj(r);
            viewOrigin.setAttribute("filter", filterName);
            viewOrigin.setAttribute("filterValue", filterValue);
            webIssue.setViewOrigin(viewOrigin);
            reultBusObjs.add(webIssue);
        }
        return reultBusObjs;
    }

    //het all issues from begin date to end
    public Vector getALLIssuesByOneDate(String filterValue, HttpSession s) throws Exception, SQLException {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        setUser(waUser);
        String userId = waUser.getAttribute("userId").toString();
        String projectId = waUser.getAttribute("projectID").toString();

        String beginDate = filterValue.substring(0, filterValue.indexOf(">"));
        Long fromDateL = new Long(beginDate);
        java.sql.Date bdate = new java.sql.Date(fromDateL.longValue());

        String searchType = filterValue.substring(filterValue.indexOf(">") + 1, filterValue.indexOf("<"));
        String eqStatus = filterValue.substring(filterValue.indexOf("<") + 1, filterValue.indexOf(":"));
        String eqId = filterValue.substring(filterValue.indexOf(":") + 1, filterValue.length());


        Vector SQLparams = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();




        String query = "";

        if (eqId.equalsIgnoreCase("All")) {
            SQLparams.addElement(new DateValue(bdate));
            if (eqStatus.equalsIgnoreCase("all")) {
                if (searchType.equalsIgnoreCase("begin")) {
//                    query=sqlMgr.getSql("getAllIssuesBeginDateStatusAll");
                    query = " SELECT * FROM issue_equipment WHERE  EXPECTED_B_DATE >= ? AND WORK_ORDER_TRADE in (select trade_id from user_trade where user_id =?)";
                } else {
//                    query=sqlMgr.getSql("getAllIssuesEndDateStatusAll");
                    query = " SELECT * FROM issue_equipment WHERE EXPECTED_E_DATE <= ? AND WORK_ORDER_TRADE in (select trade_id from user_trade where user_id =?)";
                }
            } else {
                if (searchType.equalsIgnoreCase("begin")) {
//                    query=sqlMgr.getSql("getAllIssuesBeginDate");
                    query = " SELECT * FROM issue_equipment WHERE  EXPECTED_B_DATE >= ? AND CURRENT_STATUS = ? AND WORK_ORDER_TRADE in (select trade_id from user_trade where user_id =?)";
                } else {
//                    query=sqlMgr.getSql("getAllIssuesEndDate");
                    query = " SELECT * FROM issue_equipment WHERE  EXPECTED_E_DATE <= ? AND CURRENT_STATUS = ? AND WORK_ORDER_TRADE in (select trade_id from user_trade where user_id =?)";
                }
                SQLparams.addElement(new StringValue(eqStatus));
            }
        } else {
            SQLparams.addElement(new StringValue(eqId));
            SQLparams.addElement(new DateValue(bdate));
            if (eqStatus.equalsIgnoreCase("all")) {
                if (searchType.equalsIgnoreCase("begin")) {
//                    query=sqlMgr.getSql("getIssuesBeginDateStatusAll");
                    query = " SELECT * FROM issue_equipment WHERE  UNIT_ID = ? AND EXPECTED_B_DATE >= ? AND WORK_ORDER_TRADE in (select trade_id from user_trade where user_id =?) AND PROJECT_NAME =?";
                } else {
//                    query=sqlMgr.getSql("getIssuesEndDateStatusAll");
                    query = " SELECT * FROM issue_equipment WHERE  UNIT_ID = ? AND EXPECTED_E_DATE <= ? AND WORK_ORDER_TRADE in (select trade_id from user_trade where user_id =?) AND PROJECT_NAME =?";
                }
            } else {
                if (searchType.equalsIgnoreCase("begin")) {
//                    query=sqlMgr.getSql("getIssuesBeginDate");
                    query = " SELECT * FROM issue_equipment WHERE  UNIT_ID = ? AND EXPECTED_B_DATE >= ? AND CURRENT_STATUS = ? AND WORK_ORDER_TRADE in (select trade_id from user_trade where user_id =?)";
                } else {
//                    query=sqlMgr.getSql("getIssuesEndDate");
                    query = " SELECT * FROM issue_equipment WHERE  UNIT_ID = ? AND EXPECTED_E_DATE <= ? AND CURRENT_STATUS = ? AND WORK_ORDER_TRADE in (select trade_id from user_trade where user_id =?)";
                }
                SQLparams.addElement(new StringValue(eqStatus));
            }
        }

        SQLparams.addElement(new StringValue(userId));
//        SQLparams.addElement(new StringValue(projectId));

        Vector queryResult = null;
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

            logger.error("size" + queryResult.size());
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

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        viewOrigin = new WebBusinessObject();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            webIssue = (WebIssue) fabricateBusObj(r);
            viewOrigin.setAttribute("filter", eqStatus);
            viewOrigin.setAttribute("filterValue", filterValue);
            webIssue.setViewOrigin(viewOrigin);
            reultBusObjs.add(webIssue);
        }
        return reultBusObjs;
    }

    public Vector getIssuesForPlan(HttpServletRequest request, HttpSession s, String status) throws Exception, SQLException {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        setUser(waUser);
        String userId = waUser.getAttribute("userId").toString();
        String projectId = waUser.getAttribute("projectID").toString();
        DropdownDate dropdownDate = new DropdownDate();
//        java.sql.Date bdate = new java.sql.Date(dropdownDate.getDate(request.getParameter("beginDate")).getTime());
//        java.sql.Date edate = new java.sql.Date(dropdownDate.getDate(request.getParameter("endDate")).getTime());

        DateParser dateParser = new DateParser();
        java.sql.Date bdate = dateParser.formatSqlDate(request.getParameter("beginDate"));

        java.sql.Date edate = dateParser.formatSqlDate(request.getParameter("endDate"));

        //java.sql.Date edate = new java.sql.Date(fromDateL.longValue());

        String eqId = (String) request.getParameter("unitId");

        Vector SQLparams = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();


        String query = "";

        if (eqId.equalsIgnoreCase("All")) {
            SQLparams.addElement(new DateValue(bdate));
            SQLparams.addElement(new DateValue(edate));
            SQLparams.addElement(new StringValue(status));
            query = " SELECT * FROM issue_equipment WHERE EXPECTED_B_DATE >= ? and EXPECTED_E_DATE <= ? AND CURRENT_STATUS = ? AND WORK_ORDER_TRADE in (select trade_id from user_trade where user_id =?) order by EXPECTED_B_DATE";
        } else {
            SQLparams.addElement(new StringValue(eqId));
            SQLparams.addElement(new DateValue(bdate));
            SQLparams.addElement(new DateValue(edate));
            SQLparams.addElement(new StringValue("Schedule"));
            query = " SELECT * FROM issue_equipment WHERE  UNIT_ID = ? AND EXPECTED_B_DATE >= ? AND EXPECTED_E_DATE <= ? AND CURRENT_STATUS = ? AND WORK_ORDER_TRADE in (select trade_id from user_trade where user_id =?) order by EXPECTED_B_DATE";
        }
//        SQLparams.addElement(new StringValue(projectId));
        SQLparams.addElement(new StringValue(userId));

        Vector queryResult = null;
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

            logger.error("size" + queryResult.size());
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

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        viewOrigin = new WebBusinessObject();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            webIssue = (WebIssue) fabricateBusObj(r);
            reultBusObjs.add(webIssue);
        }
        return reultBusObjs;
    }

    public Vector getIssuesForPlan(HttpServletRequest request, HttpSession s) throws Exception, SQLException {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        setUser(waUser);
        String userId = waUser.getAttribute("userId").toString();
        String projectId = waUser.getAttribute("projectID").toString();
        DropdownDate dropdownDate = new DropdownDate();
//        java.sql.Date bdate = new java.sql.Date(dropdownDate.getDate(request.getParameter("beginDate")).getTime());
//        java.sql.Date edate = new java.sql.Date(dropdownDate.getDate(request.getParameter("endDate")).getTime());

        DateParser dateParser = new DateParser();
        java.sql.Date bdate = dateParser.formatSqlDate(request.getParameter("beginDate"));

        java.sql.Date edate = dateParser.formatSqlDate(request.getParameter("endDate"));

        //java.sql.Date edate = new java.sql.Date(fromDateL.longValue());

        String eqId = (String) request.getParameter("unitId");

        Vector SQLparams = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();


        String query = "";

        if (eqId.equalsIgnoreCase("All")) {
            SQLparams.addElement(new DateValue(bdate));
            SQLparams.addElement(new DateValue(edate));
            SQLparams.addElement(new StringValue("Schedule"));
            query = " SELECT * FROM issue_equipment WHERE EXPECTED_B_DATE >= ? and EXPECTED_E_DATE <= ? AND CURRENT_STATUS = ? AND PROJECT_NAME = ? AND WORK_ORDER_TRADE in (select trade_id from user_trade where user_id =?)";
        } else {
            SQLparams.addElement(new StringValue(eqId));
            SQLparams.addElement(new DateValue(bdate));
            SQLparams.addElement(new DateValue(edate));
            SQLparams.addElement(new StringValue("Schedule"));
            query = " SELECT * FROM issue_equipment WHERE  UNIT_ID = ? AND EXPECTED_B_DATE >= ? AND EXPECTED_E_DATE <= ? AND CURRENT_STATUS = ? AND PROJECT_NAME = ? AND WORK_ORDER_TRADE in (select trade_id from user_trade where user_id =?)";
        }
        SQLparams.addElement(new StringValue(projectId));
        SQLparams.addElement(new StringValue(userId));

        Vector queryResult = null;
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

            logger.error("size" + queryResult.size());
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

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        viewOrigin = new WebBusinessObject();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            webIssue = (WebIssue) fabricateBusObj(r);
            reultBusObjs.add(webIssue);
        }
        return reultBusObjs;
    }

    public Vector getIssueBySchAndEqp(WebBusinessObject parameters, HttpSession s) throws Exception, SQLException {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String jsDateFormat = waUser.getAttribute("jsDateFormat").toString();

        setUser(waUser);
        String userId = waUser.getAttribute("userId").toString();
        DropdownDate dropdownDate = new DropdownDate();

        DateParser dateParser = new DateParser();
        java.sql.Date bdate = dateParser.formatSqlDate((String) parameters.getAttribute("beginDate"), jsDateFormat);
        java.sql.Date edate = dateParser.formatSqlDate((String) parameters.getAttribute("endDate"), jsDateFormat);

        String eqId = (String) parameters.getAttribute("eqpId");
        String schId = (String) parameters.getAttribute("schId");

        Vector SQLparams = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();

        String query = "";

        SQLparams.addElement(new StringValue(eqId));
        SQLparams.addElement(new DateValue(bdate));
        SQLparams.addElement(new DateValue(edate));
        SQLparams.addElement(new StringValue("Schedule"));
//        query=" SELECT * FROM issue_equipment WHERE  UNIT_ID = ? AND EXPECTED_B_DATE >= ? AND EXPECTED_E_DATE <= ? AND CURRENT_STATUS = ? AND WORK_ORDER_TRADE in (select trade_id from user_trade where user_id =?) and UNIT_SCHEDULE_ID in (select id from unit_schedule where PERIODIC_ID = ? )";
        query = " SELECT * FROM issue_equipment WHERE  UNIT_ID = ? AND EXPECTED_B_DATE between ? AND ? AND CURRENT_STATUS = ? AND WORK_ORDER_TRADE in (select trade_id from user_trade where user_id =?) and UNIT_SCHEDULE_ID in (select id from unit_schedule where PERIODIC_ID = ? )";

        SQLparams.addElement(new StringValue(userId));
        SQLparams.addElement(new StringValue(schId));

        Vector queryResult = null;
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

            logger.error("size" + queryResult.size());
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

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        viewOrigin = new WebBusinessObject();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            webIssue = (WebIssue) fabricateBusObj(r);
            reultBusObjs.add(webIssue);
        }
        return reultBusObjs;
    }

    public Vector getALLIssuesLaterClosed(String filterName, String filterValue, HttpSession s) throws Exception, SQLException {
        filterQuery = new FilterQuery();
        securityUser = new SecurityUser();
        securityUser = (SecurityUser) s.getAttribute("securityUser");
       // String site = securityUser.getSiteId();
        
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String userId = waUser.getAttribute("userId").toString();
        String projectId = waUser.getAttribute("projectID").toString();

        int firstParamMark = filterValue.indexOf(">");
        int secondParamMark = filterValue.indexOf("<");

        String firstParam = filterValue.substring(firstParamMark + 1, secondParamMark);
        String secondParam = filterValue.substring(secondParamMark + 1);
        String queryFilter = null;
        if (!securityUser.getSearchBy().equals("") && securityUser.getSearchBy() != null && !securityUser.getSearchBy().equals("all")) {
            queryFilter = filterQuery.getJobOrderQuery(securityUser.getSearchBy());
        }
        int sepPos = filterValue.indexOf(":");
        String fromDate = filterValue.substring(0, sepPos);
        String toDate = filterValue.substring(sepPos + 1, firstParamMark);
        Long fromDateL = new Long(fromDate);
        Long toDateL = new Long(toDate);

        java.sql.Date d1 = new java.sql.Date(fromDateL.longValue());
        java.sql.Date d2 = new java.sql.Date(toDateL.longValue());
        Vector SQLparams = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        //SQLparams.addElement(new StringValue(firstParam));

        if (filterValue.indexOf("ALL") >= 0) {
            // forQuery.setSQLQuery(sqlMgr.getSql("getALLIssuesByTrade"));
            if (queryFilter != null && !queryFilter.equals("")) {
                forQuery.setSQLQuery(sqlMgr.getSql("getALLIssuesByFilter").concat(queryFilter));
            } else {
                forQuery.setSQLQuery(sqlMgr.getSql("getALLIssuesByFilter"));
            }
        } else {
            SQLparams.addElement(new StringValue(secondParam));
//             forQuery.setSQLQuery(sqlMgr.getSql("selectIssueStatusEquipmentListOrder"));
            if (queryFilter != null && !queryFilter.equals("")) {
                forQuery.setSQLQuery(sqlMgr.getSql("selectIssueUnClosedStatusByFilter").concat(queryFilter));
            } else {
                forQuery.setSQLQuery(sqlMgr.getSql("selectIssueUnClosedStatusByFilter"));
            }
        }



        SQLparams.addElement(new DateValue(d1));
        SQLparams.addElement(new DateValue(d2));

        if (!securityUser.getSearchBy().equals("") && securityUser.getSearchBy() != null && !securityUser.getSearchBy().equals("all")) {
            if (securityUser.getSearchBy().equals("byTradeAndSite")) {
                SQLparams.addElement(new StringValue(userId));
                SQLparams.addElement(new StringValue(userId));
            } else {
                SQLparams.addElement(new StringValue(userId));
            }
        }
//        SQLparams.addElement(new StringValue(projectId));
        Vector queryResult = null;

        Connection connection = dataSource.getConnection();
        try {
            forQuery.setConnection(connection);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
            logger.error("size" + queryResult.size());
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

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        viewOrigin = new WebBusinessObject();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            webIssue = (WebIssue) fabricateBusObj(r);
            viewOrigin.setAttribute("filter", filterName);
            viewOrigin.setAttribute("filterValue", filterValue);
            webIssue.setViewOrigin(viewOrigin);
            reultBusObjs.add(webIssue);
        }
        return reultBusObjs;
    }

    public Vector getAllIssuesFromToJobOrder(String filterName, String filterValue, HttpSession session) throws SQLException {
        Vector params = new Vector();
        Connection connection = dataSource.getConnection();

        int sepPos = filterValue.indexOf(":");
        String from = filterValue.substring(0, sepPos);
        String to = filterValue.substring(sepPos + 1, filterValue.indexOf(">"));

        params.addElement(new IntValue(Integer.parseInt(from)));
        params.addElement(new IntValue(Integer.parseInt(to)));
        Vector result = new Vector();

        securityUser = (SecurityUser) session.getAttribute("securityUser");
        String branches = Tools.concatenation(securityUser.getBranchesAsArray(), ",");
        String sql = sqlMgr.getSql("getALLIssueFromToJobOrder").trim();
        sql = sql.replaceAll("ppp", branches);

        SQLCommandBean forSelect = new SQLCommandBean();
        try {
            forSelect.setConnection(connection);
            forSelect.setSQLQuery(sql);
            forSelect.setparams(params);
            result = forSelect.executeQuery();
        } catch (Exception E) {
        } finally {
            connection.close();
        }
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = result.elements();
        viewOrigin = new WebBusinessObject();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            webIssue = (WebIssue) fabricateBusObj(r);
            viewOrigin.setAttribute("filter", filterName);
            viewOrigin.setAttribute("filterValue", filterValue);
            webIssue.setViewOrigin(viewOrigin);
            reultBusObjs.add(webIssue);
        }
        return reultBusObjs;
    }
    /*
    public Vector getALLIssuesByOneDate2(HttpServletRequest request, HttpSession s,String beginEnd,String date) throws Exception, SQLException {
    DropdownDate dropdownDate = new DropdownDate();
    Vector SQLparams = new Vector();
    SQLCommandBean forQuery = new SQLCommandBean();
    WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
    String userId = waUser.getAttribute("userId").toString();

    String projectId=request.getParameter("projectName");
    String status=request.getParameter("statusName");
    String beginDate=request.getParameter("beginDate");
    long begin_date  =new Long(dropdownDate.getDate(request.getParameter("beginDate")).getTime());

    Long fromDateL = new Long(date);
    java.sql.Date d1 = new java.sql.Date(fromDateL.longValue());
    //        SQLparams.addElement(new StringValue(userId));
    //        SQLparams.addElement(new StringValue(projectId));
    //        SQLparams.addElement(new StringValue(status));
    //        SQLparams.addElement(new DateValue(begin_date));

    Vector queryResult = null;
    String query="";

    if(beginEnd.equalsIgnoreCase("end"))
    query="SELECT * FROM issue_equipment WHERE  UNIT_ID = "+projectId+" AND EXPECTED_E_DATE < "+d1;
    //            forQuery.setSQLQuery(sqlMgr.getSql("getALLIssuesByEndDate"));
    else
    query=" SELECT * FROM issue_equipment WHERE  UNIT_ID = "+projectId+" AND EXPECTED_B_DATE > "+d1;
    //            forQuery.setSQLQuery(sqlMgr.getSql("getALLIssuesByBeginDate"));

    Connection connection = dataSource.getConnection();
    try {

    forQuery.setConnection(connection);
    forQuery.setSQLQuery(query);
    //            forQuery.setparams(SQLparams);
    queryResult = forQuery.executeQuery();

    logger.error("size" + queryResult.size());
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

    Vector reultBusObjs = new Vector();

    Row r = null;
    Enumeration e = queryResult.elements();
    viewOrigin = new WebBusinessObject();
    while (e.hasMoreElements()) {
    r = (Row) e.nextElement();
    webIssue = (WebIssue) fabricateBusObj(r);
    webIssue.setViewOrigin(viewOrigin);
    reultBusObjs.add(webIssue);
    }
    return reultBusObjs;
    }
     */

    @Override
    protected void initSupportedQueries() {
      return;//  throw new UnsupportedOperationException("Not supported yet.");
    }
}
