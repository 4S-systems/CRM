package com.maintenance.db_access;

import com.clients.db_access.ClientMgr;
import com.maintenance.common.DateParser;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.util.DateAndTimeControl;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class EmployeeView2Mgr extends RDBGateWay {

    private static EmployeeView2Mgr employeeViewMgr = new EmployeeView2Mgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

//    private static final String insertIssueSQL = "INSERT INTO ISSUE_TYPE VALUES (?,?,now(),?)";
    public static EmployeeView2Mgr getInstance() {
        System.out.println("Getting EmployeeViewMgr Instance ....");
        return employeeViewMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("employee_view2.xml")));
                System.out.println("jdhfjdfh");
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {
        return false;
    }

    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("id"));
        }

        return cashedData;
    }

    public ArrayList getClientComplaintList(String groupBy, String cMode) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector params = new Vector();
        Vector queryResult = null;
        String groupSelector = null;
        ArrayList resultBusObjs = new ArrayList();
        Row r = null;
        Enumeration e = null;
        String entryDate = null;

        SQLCommandBean forQuery = new SQLCommandBean();
        forQuery.setparams(params);

        String query = getQuery("getClientComplaintList").trim();

        if (groupBy.equals("department")) {
            groupSelector = "department_name";

        } else if (groupBy.equals("sender")) {
            groupSelector = "sender_name";

        } else if (groupBy.equals("client")) {
            groupSelector = "customer_name";

        }

        // add group selector
        query = query.replaceAll("group_selector", groupSelector);

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();

        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {}
        }

        e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            entryDate = (String) wbo.getAttribute("entryDate");
            wbo.setAttribute("complaintAge", DateAndTimeControl.getDelayTimeHex(entryDate, cMode));

            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public ArrayList getClientComplaintList(String groupBy, String cMode, String beginDate, String endDate) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector params = new Vector();
        Vector queryResult = null;
        String groupSelector = null;
        ArrayList resultBusObjs = new ArrayList();
        Row r = null;
        Enumeration e = null;
        String entryDate = null;

        SQLCommandBean forQuery = new SQLCommandBean();
        params.addElement(new DateValue(getSqlBeginDate(beginDate)));
        params.addElement(new DateValue(getSqlBeginDate(endDate)));
        forQuery.setparams(params);

        String query = getQuery("getClientComplaintList").trim();

        if (groupBy.equals("department")) {
            groupSelector = "department_name";
        } else if (groupBy.equals("sender")) {
            groupSelector = "sender_name";
        } else if (groupBy.equals("client")) {
            groupSelector = "customer_name";
        }

        // add group selector
        query = query.replaceAll("group_selector", groupSelector);

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
            }
        }

        e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            entryDate = (String) wbo.getAttribute("entryDate");
            wbo.setAttribute("complaintAge", DateAndTimeControl.getDelayTimeHex(entryDate, cMode));

            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getComplaintCountPerDepartment() {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getComplaintCountPerDepartment").trim());
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                wbo.setAttribute("departmentName", r.getString("department_name"));
                wbo.setAttribute("complaintCount", r.getString("complaint_count"));
                resultBusObjs.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return resultBusObjs;
    }

    public Vector getComplaintsByDepartment(String beginDate, String endDate, String cMode) {
        Vector queryResult = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        Vector params = new Vector();
        Connection connection = null;
        forUpdate.setSQLQuery(sqlMgr.getSql("getComplaintsByDepartment").trim());
        params.addElement(new DateValue(getSqlBeginDate(beginDate)));
        params.addElement(new DateValue(getSqlBeginDate(endDate)));
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setparams(params);
            queryResult = forUpdate.executeQuery();
        } catch (Exception se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }
        
        String entryDate = null;

        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo;
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            entryDate = (String) wbo.getAttribute("entryDate");
            wbo.setAttribute("complaintAge", DateAndTimeControl.getDelayTimeHex(entryDate, cMode));

            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getComplaints(String userId, String beginDate, String endDate, String type, String status) throws NoSuchColumnException {
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();

        params.addElement(new StringValue(userId));
        params.addElement(new StringValue(status));
        params.addElement(new StringValue(type));
        params.addElement(new DateValue(getSqlBeginDate(beginDate)));
        params.addElement(new DateValue(getSqlBeginDate(endDate)));
        Connection connection = null;
        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getComplaint").trim());
//            forQuery.setSQLQuery(getQuery("getComplaints").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (Exception se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }
        String entryDate = null;

        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo;
        Row r = null;
        Enumeration d = queryResult.elements();
        while (d.hasMoreElements()) {
            r = (Row) d.nextElement();
            wbo = new WebBusinessObject();
            wbo.setAttribute("businessId", r.getString("business_id"));
            wbo.setAttribute("businessComId", r.getString("business_comp_id"));
            wbo.setAttribute("customerName", r.getString("customer_name"));
            wbo.setAttribute("fullName", r.getString("full_name"));
            wbo.setAttribute("senderName", r.getString("sender_name"));
            wbo.setAttribute("entryDate", r.getString("entry_date"));
            wbo.setAttribute("compSubject", r.getString("comp_subject"));
            wbo.setAttribute("senderId", r.getString("sender_id"));
            wbo.setAttribute("entryDate", r.getString("entry_date"));
            if (r.getString("manager_comment") == null || r.getString("Manager_comment").isEmpty()) {
                wbo.setAttribute("managerComment", "no comment");

            } else {
                wbo.setAttribute("managerComment", r.getString("Manager_comment"));
            }
            wbo.setAttribute("comments", r.getString("comments"));
            wbo.setAttribute("status", r.getString("status_ar_name"));
//            wbo = fabricateBusObj(r);
//            entryDate = (String) wbo.getAttribute("entryDate");
//            wbo.setAttribute("complaintAge", DateAndTimeControl.getDelayTimeHex(entryDate, cMode));

            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> getDistributedClients(String createdBy, String beginDate, String endDate) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        StringBuilder where = new StringBuilder();
        StringBuilder qqq = new StringBuilder();
        
        if(beginDate != null && !beginDate.isEmpty()) {
            where.append(" and trunc(EV2.ENTRY_DATE) >= TO_DATE('").append(beginDate).append("','YYYY/MM/DD')");
        }
        
        if(endDate != null && !endDate.isEmpty()) {
            where.append(" and trunc(EV2.ENTRY_DATE) <= TO_DATE('").append(endDate).append("','YYYY/MM/DD')");
        }
        
        if(createdBy != null && !createdBy.isEmpty()) {
            qqq.append(" and (EV2.SENDER_ID ='").append(createdBy).append("' OR ev2.receip_id ='").append(createdBy).append("') ");
        }
        Vector params = new Vector();

        //params.addElement(new StringValue(createdBy));
        //params.addElement(new StringValue(createdBy));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getDistributedClients").trim() + qqq.toString() + where.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> results = new ArrayList<WebBusinessObject>();
        Row r;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            results.add(wbo);
            
            try {
                if(r.getString("CREATEDBY") != null){
                    wbo.setAttribute("createdBy", r.getString("CREATEDBY"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(EmployeeView2Mgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return results;
    }
    
    public ArrayList<WebBusinessObject> getMyClients(String createdBy, String beginDate, String endDate) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        StringBuilder where = new StringBuilder();
        if(createdBy != null && !createdBy.isEmpty()) {
            where.append(" and CURRENT_OWNER_ID = '").append(createdBy).append("'");
        }
        
        if(beginDate != null && !beginDate.isEmpty()) {
            where.append(" and trunc(ENTRY_DATE) >= TO_DATE('").append(beginDate).append("','YYYY/MM/DD')");
        }
        
        if(endDate != null && !endDate.isEmpty()) {
            where.append(" and trunc(ENTRY_DATE) <= TO_DATE('").append(endDate).append("','YYYY/MM/DD')");
        }
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getDistributedClients").trim() + where.toString());
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> results = new ArrayList<WebBusinessObject>();
        Row r;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            results.add(wbo);
        }
        return results;
    }

    private java.sql.Date getSqlBeginDate(String date) {
        DateParser parser = new DateParser();
        java.sql.Date sqlDate = parser.formatSqlDate(date);

        return sqlDate;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }

    @Override
    protected WebBusinessObject fabricateBusObj(Row row) {
        ListIterator li = supportedForm.getFormElemnts().listIterator();
        FormElement fe = null;
        Hashtable ht = new Hashtable();
        String colName;
        while (li.hasNext()) {
            try {
                fe = (FormElement) li.next();
                colName = (String) fe.getAttribute("column");
                // needs a case ......
                ht.put(fe.getAttribute("name"), row.getString(colName));
            } catch (Exception e) { /* raise an exception */ }
        }

        WebBusinessObject wbo = new WebBusinessObject(ht);
        return wbo;
    }
    
    public HashMap<String, Object> getDistributedClientsForPagination(String createdBy, String beginDate, String endDate, String sourceID, String searchValue, String start, String amount, String orderedBy, String dir) {
        Connection connection = null;
        String end;
        HashMap<String, Object> results = new HashMap<>();
        StringBuilder quaryList = new StringBuilder(getQuery("getDistributedClientsForPagination").trim());
        String quaryCount = getQuery("getDistributedClientsCount").trim();
        StringBuilder where = new StringBuilder();
        if(createdBy != null && !createdBy.isEmpty()) {
            where.append(" AND CLIENT_CREATED_BY = '").append(createdBy).append("'");
        }
        
        if(beginDate != null && !beginDate.isEmpty()) {
            where.append(" AND TRUNC(ENTRY_DATE) >= TO_DATE('").append(beginDate).append("','YYYY/MM/DD')");
        }
        
        if(endDate != null && !endDate.isEmpty()) {
            where.append(" AND TRUNC(ENTRY_DATE) <= TO_DATE('").append(endDate).append("','YYYY/MM/DD')");
        }
        
        if(sourceID != null && !sourceID.isEmpty()) {
            where.append(" AND SENDER_ID = '").append(sourceID).append("'");
        }
        
        StringBuilder wherePagination = new StringBuilder();
        if(searchValue != null && !searchValue.isEmpty()) {
            wherePagination.append(" AND (LOWER(CUSTOMER_NAME) LIKE LOWER('%").append(searchValue).append("%')");
            wherePagination.append(" OR LOWER(CLIENT_PHONE) LIKE LOWER('%").append(searchValue).append("%')");
            wherePagination.append(" OR LOWER(CLIENT_MOBILE) LIKE LOWER('%").append(searchValue).append("%')");
            wherePagination.append(" OR LOWER(FULL_NAME) LIKE LOWER('%").append(searchValue).append("%')");
            wherePagination.append(" OR TO_CHAR(ENTRY_DATE, 'yyyy-mm-dd HH:mi') LIKE LOWER('%").append(searchValue).append("%'))");
        }
        
        StringBuilder orderBy = new StringBuilder();
        orderBy.append(orderedBy).append(" ").append(dir);
        Vector<Row> queryResult;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(quaryCount.replaceAll("whereStatement", where.toString()));
            queryResult = forQuery.executeQuery();
            for (Row row : queryResult) {
                try {
                    results.put("total", row.getString("TOTAL_NO"));
                } catch (NoSuchColumnException ex) {
                    results.put("total", "0");
                }
                break;
            }
            
            forQuery.setSQLQuery(quaryCount.replaceAll("whereStatement", wherePagination.toString() + where.toString()));
            queryResult = forQuery.executeQuery();
            for (Row row : queryResult) {
                try {
                    results.put("totalAfterFilter", row.getString("TOTAL_NO"));
                } catch (NoSuchColumnException ex) {
                    results.put("totalAfterFilter", "0");
                }
                break;
            }
            start = (Integer.parseInt(start) + 1) + "";
            end = (Integer.parseInt(start) + Integer.parseInt(amount) - 1) + "";
            forQuery.setSQLQuery(quaryList.append(" WHERE I BETWEEN ").append(start).append(" AND ").append(end).toString()
                    .replaceAll("whereStatement", wherePagination.toString() + where.toString()).replaceAll("orderedBy", orderBy.toString()));
            queryResult = forQuery.executeQuery();
            ArrayList<WebBusinessObject> tiresCodeList = new ArrayList<>();
            for(Row row : queryResult) {
                tiresCodeList.add(fabricateBusObj(row));
            }
            
            results.put("resultList", tiresCodeList);
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        return results;
    }
    public ArrayList<WebBusinessObject> getMyClntsRated(String searchBy,String searchValue,String userID){
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new StringValue(userID));
        params.addElement(new StringValue(userID));
        String getQueryBy="";
        if(searchBy.equalsIgnoreCase("clientNo")){
        getQueryBy="getMyClientRatedByNo";
        }else if(searchBy.equalsIgnoreCase("clientName")){
        getQueryBy="getMyClientRatedByName";
        }else if(searchBy.equalsIgnoreCase("description")){
        getQueryBy="getMyClientRatedByDesc";
        }
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery(getQueryBy).replace("searchBy", searchValue).trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        Row r;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo=new WebBusinessObject(); 
             try {
               if (r.getString("sys_id") != null) {
                    wbo.setAttribute("id", r.getString("sys_id"));
                }else{
                    wbo.setAttribute("id", "--");
                }
                if (r.getString("client_no") != null) {
                    wbo.setAttribute("clientNO", r.getString("client_no"));
                }else{
                    wbo.setAttribute("clientNO", "--");
                }   
                if (r.getString("name") != null) {
                    wbo.setAttribute("name", r.getString("name"));
                }else{
                    wbo.setAttribute("name", "--");
                }    
                if (r.getString("mobile") != null) {
                    wbo.setAttribute("mobile", r.getString("mobile"));
                }else{
                    wbo.setAttribute("mobile", "--");
                }    
                if (r.getString("email") != null) {
                    wbo.setAttribute("email", r.getString("email"));
                }else{
                    wbo.setAttribute("email", "--");
                }    
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientMgr.class
                        .getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
   }
}