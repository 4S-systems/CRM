package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class IssueByComplaintUniqueMgr extends RDBGateWay {

    private static final IssueByComplaintUniqueMgr issueByComplaintUniqueMgr = new IssueByComplaintUniqueMgr();

    public static IssueByComplaintUniqueMgr getInstance() {
        logger.info("Getting IssueByComplaintUniqueMgr Instance ....");
        return issueByComplaintUniqueMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("issue_by_complaint_unique.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {

        return false;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("id"));
        }

        return cashedData;
    }
    
    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
    
    public ArrayList<WebBusinessObject> getNewClientsBetweenDates(String beginDate, String endDate, String description, String senderID, String currentOwnerID) throws SQLException, Exception {
        Vector SQLparams = new Vector();
        String theQuery = getQuery("getNewClientsBetweenDates").trim().replaceAll("clientDescription", description);
        SQLparams.addElement(new StringValue(beginDate));
        SQLparams.addElement(new StringValue(endDate));
        Vector queryResult = null;
        StringBuilder where = new StringBuilder();
        if(senderID != null && !senderID.isEmpty()) {
            where.append(" and i.SENDER_ID  = '").append(senderID).append("'");
        }
        if(currentOwnerID != null && !currentOwnerID.isEmpty()) {
            where.append(" and i.CURRENT_OWNER_ID  = '").append(currentOwnerID).append("'");
        }
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery.replaceFirst("otherWhereStatement", where.toString()));
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        if (queryResult != null) {
            Row row;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                resultBusObjs.add(fabricateBusObj(row));
            }
        }
        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> getNewClientsBetweenDatesGrouped(String beginDate, String endDate, String description, String senderID, String groupID) throws SQLException, Exception {
        Vector SQLparams = new Vector();
        String theQuery = getQuery("getNewClientsBetweenDatesNew").trim().replaceAll("clientDescription", description);
        SQLparams.addElement(new StringValue(beginDate));
        SQLparams.addElement(new StringValue(endDate));
        Vector queryResult = null;
        StringBuilder where = new StringBuilder();
        if(senderID != null && !senderID.isEmpty()) {
            where.append(" and i.SENDER_ID  = '").append(senderID).append("'");
        }
        if(groupID != null && !groupID.isEmpty()) {
            where.append(" and UG.GROUP_ID  in (").append(groupID).append(")");
        }
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery.replaceFirst("otherWhereStatement", where.toString()));
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
             Row row;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                System.out.println("row.getColumns().length= "+row.getColumns().length);
                Column array[]= row.getColumns();
                WebBusinessObject wbo=new WebBusinessObject();
                for (int i = 0; i < array.length; i++) {
                    System.out.println("column "+i+" "+array[i].getName());
                    String colname=array[i].getName();
                    if(row.getString(colname)!=null && !row.getString(colname).equals("UL"))
                    {
                        wbo.setAttribute(colname, row.getString(colname));
                    }
                    else wbo.setAttribute(colname, "");
                }
                resultBusObjs.add(wbo);
            }
        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> getNewClientsBetweenDatesGroupedCount(String beginDate, String endDate, String description, String senderID, String groupID) throws SQLException, Exception {
        Vector SQLparams = new Vector();
        String theQuery = getQuery("getNewClientsBetweenDatesGroupedCount").trim().replaceAll("clientDescription", description);
        SQLparams.addElement(new StringValue(beginDate));
        SQLparams.addElement(new StringValue(endDate));
        Vector queryResult = null;
        StringBuilder where = new StringBuilder();
        if(senderID != null && !senderID.isEmpty()) {
            where.append(" and i.SENDER_ID  = '").append(senderID).append("'");
        }
        if(groupID != null && !groupID.isEmpty()) {
            where.append(" and UG.GROUP_ID  in (").append(groupID).append(")");
        }
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery.replaceFirst("otherWhereStatement", where.toString()));
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        if (queryResult != null) {
            Row row;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                resultBusObjs.add(fabricateBusObj(row));
            }
        }
        return resultBusObjs;
    }
    
    public Vector getAllCaseBetweenDatesByStatus(java.sql.Date beginDate, java.sql.Date endDate, String status, String ticket, String departmentID, String receipID, String ownerDepartmentID) throws SQLException, Exception {
        Vector SQLparams = new Vector();
        String theQuery = getQuery("getAllCaseBetweenDatesByStatus").trim().replaceAll("sssss", status);
        if(!ticket.isEmpty()) {
            theQuery = theQuery.replaceAll("tttttt", "and ticket_type = '" + ticket + "'");
        } else {
            theQuery = theQuery.replaceAll("tttttt", "and ticket_type in (select TASK_ID from DEP_TASK_PREV where PROJECT_ID = '" + departmentID + "')");
        }
        if(receipID != null) {
            theQuery += " and v.RECEIP_ID = '" + receipID + "'";
        }
        if (ownerDepartmentID != null) {
            theQuery += " and v.CURRENT_OWNER_ID IN (SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID = '" + ownerDepartmentID
                    + "' UNION ALL SELECT EMP_ID FROM EMP_MGR WHERE MGR_ID IN (SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID = '"
                    + ownerDepartmentID + "'))";
        }
        String[] statusTitles = new String[3];
        statusTitles[0] = "12";
        statusTitles[1] = "13";
        statusTitles[2] = "14";
        StringBuilder statusQuery = new StringBuilder(" and C.CURRENT_STATUS in (");
        statusQuery.append("select MAX(DECODE(client_status,'11', '11')) as client_status from client_rule where department_id ='"); // for status = 11
        statusQuery.append(departmentID).append("'").append(" union ");
        int i = 0;
        for (String statusTitle : statusTitles) {
            statusQuery.append("select MAX(DECODE(client_status,'99','").append(statusTitle).append("')) as client_status ");
            statusQuery.append("from client_rule where department_id = '").append(departmentID).append("'");
            if (i < statusTitles.length - 1) {
                statusQuery.append(" union ");
            }
            i++;
        }
        statusQuery.append(")");
        SQLparams.addElement(new DateValue(beginDate));
        SQLparams.addElement(new DateValue(endDate));
        // finally do the query
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery + statusQuery.toString());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }
        Vector<WebBusinessObject> reultBusObjs = new Vector();
        Row row;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            wbo = fabricateBusObj(row);
            reultBusObjs.add(wbo);
        }
        return reultBusObjs;
    }
    
    public Vector getAllCaseForClient(String clientID, String departmentID) throws SQLException, Exception {
        Vector SQLparams = new Vector();
        
        // finally do the query
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        
        SQLparams.addElement(new StringValue(clientID));
        SQLparams.addElement(new StringValue(departmentID));
        SQLparams.addElement(new StringValue(departmentID));
        SQLparams.addElement(new StringValue(departmentID));
        SQLparams.addElement(new StringValue(departmentID));
        
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getComplaintByClient").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }
        Vector<WebBusinessObject> reultBusObjs = new Vector();
        Row row;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            wbo = fabricateBusObj(row);
            reultBusObjs.add(wbo);
        }
        return reultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> getNewClientsByBranchBetweenDates(String beginDate, String endDate, String senderID, String branchID) throws SQLException, Exception {
        Vector SQLparams = new Vector();
        String theQuery = getQuery("getNewClientsBetweenDates").trim().replaceAll("clientDescription", "");
        SQLparams.addElement(new StringValue(beginDate));
        SQLparams.addElement(new StringValue(endDate));
        Vector queryResult = null;
        StringBuilder where = new StringBuilder();
        if(senderID != null && !senderID.isEmpty()) {
            where.append(" and i.SENDER_ID  = '").append(senderID).append("'");
        }
        if(branchID != null && !branchID.isEmpty()) {
            if(branchID.equals("none")) {
                where.append(" and (c.BRANCH IS NULL OR c.BRANCH  = 'UL')");
            } else {
                where.append(" and c.BRANCH  = '").append(branchID).append("'");
            }
        }
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery.replaceFirst("otherWhereStatement", where.toString()));
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        if (queryResult != null) {
            Row row;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                resultBusObjs.add(fabricateBusObj(row));
            }
        }
        return resultBusObjs;
    }
    
    public List<WebBusinessObject> getComplaintByCreatedBy(String createdBy, java.sql.Date beginDate, java.sql.Date endDate) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
        Vector<Row> result;
        Vector parameters = new Vector();

        parameters.addElement(new StringValue(createdBy));
        parameters.addElement(new DateValue(beginDate));
        parameters.addElement(new DateValue(endDate));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getComplaintByCreatedBy").trim());
            command.setparams(parameters);
            result = command.executeQuery();

            for (Row row : result) {
                data.add(fabricateBusObj(row));
            }
        } catch (SQLException ex) {
            logger.error(ex);
        } catch (UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }

        return data;
    }
    
    public ArrayList<WebBusinessObject> getAllCaseBetweenDatesByDepCode(java.sql.Date beginDate, java.sql.Date endDate, String departmentCode) {
        Vector SQLparams = new Vector();
        Connection connection = null;
        String theQuery = getQuery("getAllCaseBetweenDatesByDepCode").trim().replaceAll("departmentCode", departmentCode);
        SQLparams.addElement(new DateValue(beginDate));
        SQLparams.addElement(new DateValue(endDate));
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQLException " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException ex) {
                    Logger.getLogger(IssueByComplaintUniqueMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        ArrayList<WebBusinessObject> result = new ArrayList<>();
        Row row;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            wbo = fabricateBusObj(row);
            result.add(wbo);
        }
        return result;
    }
    
    public Vector getAllCaseBetweenDatesForLifeReport(java.sql.Date beginDate, java.sql.Date endDate, String status, String ticket, String departmentID, String departmentCode) throws SQLException, Exception {
        Vector SQLparams = new Vector();
        String theQuery = getQuery("getAllCaseBetweenDatesByStatus").trim().replaceAll("sssss", status);
        if(!ticket.isEmpty()) {
            theQuery = theQuery.replaceAll("tttttt", "and ticket_type = '" + ticket + "'");
        } else {
            theQuery = theQuery.replaceAll("tttttt", "and ticket_type in (select TASK_ID from DEP_TASK_PREV where PROJECT_ID = '" + departmentID + "')");
        }
        String[] statusTitles = new String[3];
        statusTitles[0] = "12";
        statusTitles[1] = "13";
        statusTitles[2] = "14";
        StringBuilder statusQuery = new StringBuilder(" and C.CURRENT_STATUS in (");
        statusQuery.append("select MAX(DECODE(client_status,'11', '11')) as client_status from client_rule where department_id ='"); // for status = 11
        statusQuery.append(departmentID).append("'").append(" union ");
        int i = 0;
        for (String statusTitle : statusTitles) {
            statusQuery.append("select MAX(DECODE(client_status,'99','").append(statusTitle).append("')) as client_status ");
            statusQuery.append("from client_rule where department_id = '").append(departmentID).append("'");
            if (i < statusTitles.length - 1) {
                statusQuery.append(" union ");
            }
            i++;
        }
        statusQuery.append(")");
        statusQuery.append(" and v.BUSINESS_COMP_ID like '").append(departmentCode).append("%'");
        SQLparams.addElement(new DateValue(beginDate));
        SQLparams.addElement(new DateValue(endDate));
        // finally do the query
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery + statusQuery.toString());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }
        Vector<WebBusinessObject> reultBusObjs = new Vector();
        Row row;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            wbo = fabricateBusObj(row);
            reultBusObjs.add(wbo);
        }
        return reultBusObjs;
    }
    
    public List<String> getClientComplaintsToBeFinished(String departmentCode, Integer interval) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector parameters = new Vector();
        List<String> data = new ArrayList<>();
        parameters.addElement(new IntValue(interval));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getClientComplaintsToBeFinished").replaceAll("departmentCode", departmentCode));
            command.setparams(parameters);
            result = command.executeQuery();
            for (Row row : result) {
                if (row.getString("COMP_ID") != null) {
                    data.add(row.getString("COMP_ID"));
                }
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(IssueByComplaintUniqueMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error, " + ex);
            }
        }
        return data;
    }
    
    public ArrayList<WebBusinessObject> getClientsWithNoComments(java.sql.Date beginDate, java.sql.Date endDate, String departmentID,
            String loggedUserID) throws SQLException, Exception {
        String theQuery = getQuery("getClientsWithNoComments").trim();
        Connection connection = dataSource.getConnection();
        Vector queryResult = null;
        Vector params = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        params.addElement(new DateValue(beginDate));
        params.addElement(new DateValue(endDate));
        StringBuilder where = new StringBuilder();
        if (departmentID == null || departmentID.isEmpty()) {
            where.append(" IN (SELECT DEPARTMENT_ID FROM USER_DEPARTMENT_CONFIG WHERE USER_ID = ?)");
            params.addElement(new StringValue(loggedUserID));
        } else {
            where.append(" = ? ");
            params.addElement(new StringValue(departmentID));
        }
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery.replace("whereStatement", where.toString()));
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        if (queryResult != null) {
            Row row;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                resultBusObjs.add(fabricateBusObj(row));
            }
        }
        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> getClientsWithNoCommentsInter(String interCode) throws SQLException, Exception {
        String theQuery = getQuery("getClientsWithNoCommentsInter").trim();
        Connection connection = dataSource.getConnection();
        Vector queryResult = null;
        Vector params = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        params.addElement(new StringValue(interCode));
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        if (queryResult != null) {
            Row row;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                resultBusObjs.add(fabricateBusObj(row));
            }
        }
        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> getEmpClientsWithNoComments(java.sql.Date beginDate, java.sql.Date endDate) throws SQLException, Exception {
        String theQuery = "SELECT UNIQUE I.CURRENT_OWNER, Count(I.CUSTOMER_ID) AS Total FROM ISSUE_BY_COMPLAINT_UNIQUE I LEFT JOIN CLIENT C ON I.CUSTOMER_ID = C.SYS_ID LEFT JOIN ISSUE_STATUS S ON I.CUSTOMER_ID = S.BUSINESS_OBJ_ID AND S.END_DATE IS NULL LEFT JOIN (SELECT COUNT(*) TOTAL_COMMENTS, BUSNIESS_OBJECT_ID FROM COMMENTS GROUP BY BUSNIESS_OBJECT_ID) CO ON I.CUSTOMER_ID = CO.BUSNIESS_OBJECT_ID LEFT JOIN (SELECT COUNT(*) TOTAL_APPOINTMENTS, CLIENT_ID FROM APPOINTMENT GROUP BY CLIENT_ID) AP ON I.CUSTOMER_ID = AP.CLIENT_ID WHERE COMP_SUBJECT = 'عميل جديد' AND CO.TOTAL_COMMENTS IS NULL AND AP.TOTAL_APPOINTMENTS IS NULL AND I.STATUS_AR_NAME IS NOT NULL AND C.CURRENT_STATUS = '12' AND TRUNC(ENTRY_DATE) BETWEEN ? AND ? Group By I.CURRENT_OWNER order by I.CURRENT_OWNER";
        Connection connection = dataSource.getConnection();
        Vector queryResult = null;
        
        Vector params = new Vector();
        params.addElement(new DateValue(beginDate)); 
        params.addElement(new DateValue(endDate));
        
        StringBuilder where = new StringBuilder();
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        if (queryResult != null) {
            Row row;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                
                WebBusinessObject wbo = new WebBusinessObject();
                
                wbo.setAttribute("current_owner", row.getString("CURRENT_OWNER"));
                wbo.setAttribute("total", row.getString("Total"));
                
                resultBusObjs.add(wbo);
            }
        }
        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> getClientsWithNoCommentsDetailes(java.sql.Date beginDate, java.sql.Date endDate) throws SQLException, Exception {
        String theQuery = getQuery("getClientsWithoutCommentsDetailes").trim();
        Connection connection = dataSource.getConnection();
        Vector queryResult = null;
        
        Vector params = new Vector();
        params.addElement(new DateValue(beginDate)); 
        params.addElement(new DateValue(endDate));
        
        StringBuilder where = new StringBuilder();
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }
        
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        if (queryResult != null) {
            Row row;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                resultBusObjs.add(fabricateBusObj(row));
            }
        }
        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> getMyActivityInPeriod(java.sql.Date beginDate, java.sql.Date endDate, String status, String createdBy) {
        Vector SQLparams = new Vector();
        String theQuery = getQuery("getMyActivityInPeriod").trim();
        SQLparams.addElement(new StringValue(status));
        SQLparams.addElement(new StringValue(createdBy));
        SQLparams.addElement(new DateValue(beginDate));
        SQLparams.addElement(new DateValue(endDate));
        Vector queryResult = null;
        Connection connection = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQLException Error " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(IssueByComplaintUniqueMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        ArrayList<WebBusinessObject> results = new ArrayList<>();
        Row row;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            wbo = fabricateBusObj(row);
            try {
                if(row.getString("BEGIN_DATE") != null) {
                    wbo.setAttribute("beginDate", row.getString("BEGIN_DATE"));
                }
                if(row.getString("US_STATUS_AR") != null) {
                    wbo.setAttribute("userStatusAR", row.getString("US_STATUS_AR"));
                }
                if(row.getString("US_STATUS_EN") != null) {
                    wbo.setAttribute("userStatusEn", row.getString("US_STATUS_EN"));
                }
                if(row.getString("SYS_ID") != null) {
                    wbo.setAttribute("sysID", row.getString("SYS_ID"));
                }
                if(row.getString("CURRENT_OWNER") != null) {
                    wbo.setAttribute("CURRENT_OWNER", row.getString("CURRENT_OWNER"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(IssueByComplaintUniqueMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            results.add(wbo);
        }
        return results;
    }
    
    public List<WebBusinessObject> getNonDistributedComplaints() {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        List<WebBusinessObject> data = new ArrayList<>();
        Vector<Row> result;
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getNonDistributedComplaints").trim());
            result = command.executeQuery();
            for (Row row : result) {
                data.add(fabricateBusObj(row));
            }
        } catch (SQLException | UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }
        return data;
    }
    
    public ArrayList<WebBusinessObject> getNonFollowersClientsDetails(String groupID, java.sql.Date fromDate, java.sql.Date toDate, String userID) {
        ArrayList<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
        Connection connection = null;
        Vector param = new Vector();
        param.addElement(new DateValue(fromDate));
        param.addElement(new DateValue(toDate));
        param.addElement(new DateValue(fromDate));
        param.addElement(new DateValue(toDate));
        param.addElement(new StringValue(groupID));
        param.addElement(new StringValue(userID));
        Vector queryResult;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getNonFollowersClientsDetails").trim());
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            while (e.hasMoreElements()) {
                Row row = (Row) e.nextElement();
                wbo = fabricateBusObj(row);
                try {
                    if (row.getString("CURRENT_OWNER_NAME") != null) {
                        wbo.setAttribute("currentOwnerName", row.getString("CURRENT_OWNER_NAME"));
                    }
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                }
                data.add(wbo);
            }
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception ex) {
            logger.error(ex.getMessage());
            return null;
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        return data;
    }
    
       public ArrayList<WebBusinessObject> getClientsWithLead() {
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        String theQuery = getQuery("getClientsWithNoCommentsLead").trim();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
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
        if (queryResult != null) {
            Row row;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                resultBusObjs.add(fabricateBusObj(row));
            }
        }
        return resultBusObjs;
    }

}