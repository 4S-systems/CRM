/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.clients.db_access;

import com.crm.common.CRMConstants;
import com.crm.db_access.AlertMgr;
import com.crm.db_access.CommentsMgr;
import com.maintenance.common.DateParser;
import com.maintenance.common.Tools;
import com.maintenance.db_access.DistributionListMgr;
import com.maintenance.db_access.ExternalJobMgr;
import com.maintenance.db_access.IssueDocumentMgr;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.common.UserMgr;
import com.silkworm.db_access.FileMgr;
import com.silkworm.servlets.MultipartRequest;
import com.silkworm.uploader.FileMeta;
import com.tracker.db_access.IssueMgr;
import com.tracker.db_access.IssueStatusMgr;
import com.tracker.db_access.ProjectMgr;
import com.tracker.db_access.SequenceMgr;
import java.io.File;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.sql.*;
import java.text.SimpleDateFormat;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author Waled
 */
public class ClientComplaintsMgr extends RDBGateWay {

    private final SqlMgr sqlMgr = SqlMgr.getInstance();
    private SQLCommandBean command = new SQLCommandBean();
    private final IssueDocumentMgr documentMgr = IssueDocumentMgr.getInstance();
    private static final ClientComplaintsMgr CLIENT_COMPLAINTS_MGR = new ClientComplaintsMgr();

    public static ClientComplaintsMgr getInstance() {
        logger.info("Getting ClientComplaintsMgr Instance ....");
        return CLIENT_COMPLAINTS_MGR;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("client_complaints.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public ArrayList getClientName(String equipmentID) {
        Vector prm = new Vector();
        prm.addElement(new StringValue(equipmentID));
        SQLCommandBean executeQuery = new SQLCommandBean();
        Vector resultQuery = new Vector();
        try {
            beginTransaction();
            executeQuery.setConnection(transConnection);
            executeQuery.setSQLQuery(getQuery("selectClient").trim());
            executeQuery.setparams(prm);
            resultQuery = executeQuery.executeQuery();
            endTransaction();
        } catch (Exception e) {
            logger.error("Could not execute Query");
        }
        ArrayList newData = new ArrayList();
        Row r = null;
        Enumeration e = resultQuery.elements();
        while (e.hasMoreElements()) {
            WebBusinessObject wbo = null;
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            newData.add(wbo);
        }
        return newData;
    }

    public ArrayList getAllClient() {
        Vector queryResult = new Vector();
        WebBusinessObject wbo = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        try {
            //connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("selectAllClientsName").trim());
            queryResult = forInsert.executeQuery();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        ArrayList resultBusObjs = new ArrayList();
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

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveClientComplaint(HttpServletRequest request, HttpSession s) throws NoUserInSessionException, SQLException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        String clientPhone = null;
        String comments = null;

        if (request.getParameter("phone").toString().equals("")) {
            clientPhone = "123456789";
        } else {
            clientPhone = request.getParameter("phone").toString();
        }

        if (request.getParameter("comments").toString().equals("")) {
            comments = "none";
        } else {
            comments = request.getParameter("comments").toString();
        }

        DateParser dateParser = new DateParser();
        java.sql.Date entryDate = dateParser.formatSqlDate(request.getParameter("entryDate"));
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
//        String clientNoByDate = null;
        String clientCompId = UniqueIDGen.getNextID();

        params.addElement(new StringValue(clientCompId));
        params.addElement(new StringValue(request.getParameter("1363611863801")));
        params.addElement(new StringValue(request.getParameter("clientId")));
        params.addElement(new StringValue(clientPhone));
        params.addElement(new StringValue(comments));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new DateValue(entryDate));
        params.addElement(new StringValue(request.getParameter("call_status")));
        params.addElement(new StringValue("UL"));

        //Connection connection = null;
        try {
            //connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertClientComplaint").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }

        } catch (SQLException se) {
            logger.error(se.getMessage());
            transConnection.rollback();
            return false;

        } finally {
            endTransaction();
        }

        return (queryResult > 0);
    }

    public boolean updateClient(HttpServletRequest request) throws NoUserInSessionException {

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue(request.getParameter("supplierNO")));
        params.addElement(new StringValue(request.getParameter("supplierName")));
        params.addElement(new StringValue(request.getParameter("designation")));
        params.addElement(new StringValue(request.getParameter("address")));
        params.addElement(new StringValue(request.getParameter("city")));
        params.addElement(new StringValue(request.getParameter("phone")));
        params.addElement(new StringValue(request.getParameter("fax")));
        params.addElement(new StringValue(request.getParameter("email")));
        params.addElement(new StringValue(request.getParameter("service")));
        if (request.getParameter("isActive") != null) {
            params.addElement(new StringValue("1"));
        } else {
            params.addElement(new StringValue("0"));
        }
        params.addElement(new StringValue(request.getParameter("note")));
        params.addElement(new StringValue(request.getParameter("clientID")));

        Connection connection = null;
        try {
            //connection = dataSource.getConnection();
            beginTransaction();
            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(getQuery("updateClient").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            endTransaction();

        } catch (SQLException se) {
            logger.error("Exception updating project: " + se.getMessage());
            return false;
        } finally {
        }

        return (queryResult > 0);
    }

    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        if (cashedTable != null) {
            for (int i = 0; i < cashedTable.size(); i++) {
                wbo = (WebBusinessObject) cashedTable.elementAt(i);
                cashedData.add((String) wbo.getAttribute("name"));
            }
        }

        return cashedData;
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

    public String getAllSuppNo() {
        Connection connection = null;
        ResultSet result = null;
        StringBuffer returnSB = null;

        try {
            connection = dataSource.getConnection();
            Statement select = connection.createStatement();
            result = select.executeQuery(sqlMgr.getSql("getAllSuppNo").trim());
            returnSB = new StringBuffer();
            while (result.next()) {
                returnSB.append(result.getString("SUPPLIER_NO") + ",");
            }
            returnSB.deleteCharAt(returnSB.length() - 1);
        } catch (SQLException e) {
            logger.error("error ================ > " + e.toString());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        return returnSB.toString();
    }

    public Vector getAllSuppliersByEquipment(HttpServletRequest request) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector params = new Vector();
        params.addElement(new StringValue(request.getParameter("equipmentID")));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            forQuery.setparams(params);
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectAllSuppliersSQL").trim());
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
        } catch (Exception e) {
            logger.error("Exception  " + e.getMessage());
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

    public ArrayList getAllSuppliers() {
        WebBusinessObject wbo = new WebBusinessObject();
        Tools tools = new Tools();
        Connection connection = null;
        Vector params = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        forQuery.setparams(params);
        try {
            connection = dataSource.getConnection();
        } catch (SQLException ex) {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        forQuery.setConnection(connection);
        forQuery.setSQLQuery(sqlMgr.getSql("selectAllSuppliers").trim());
        try {
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
            }
        }
        ArrayList resultBusObjs = new ArrayList();
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

    public boolean canDelete(String clientId) {
        boolean canDelete = false;
        ExternalJobMgr externalJobMgr = ExternalJobMgr.getInstance();
        Vector externalJobOrderVec = new Vector();

        try {
            externalJobOrderVec = externalJobMgr.getOnArbitraryKey(clientId, "key1");

            if (externalJobOrderVec.isEmpty()) {
                canDelete = true;
            }
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        return canDelete;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    public String saveClientComplaint2(HttpServletRequest request, WebBusinessObject persistentUser) throws NoUserInSessionException, SQLException {
//        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        String clientPhone = null;
        String comments = null;

        String servLevel = "0";
        String depCode = null;
        String ownerComplaint = (String) request.getAttribute("userId");
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        WebBusinessObject wboProj = new WebBusinessObject();
        Vector projectV = new Vector();
        try {
            projectV = projectMgr.getOnArbitraryKey(ownerComplaint, "key5");
            if (projectV.size() > 0) {
                wboProj = (WebBusinessObject) projectV.get(0);
                servLevel = (String) wboProj.getAttribute("optionTwo");
                depCode = (String) wboProj.getAttribute("eqNO");
            }
        } catch (Exception ex) {
            Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (request.getAttribute("orderUrgency") != null) {
            servLevel = (String) request.getAttribute("orderUrgency");
        }

        DateParser dateParser = new DateParser();

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String issueId = (String) request.getAttribute("issueId");
        IssueMgr issueMgr = IssueMgr.getInstance();
        WebBusinessObject issueWbo = new WebBusinessObject();
        issueWbo = (WebBusinessObject) issueMgr.getOnSingleKey(issueId);

//        String clientNoByDate = null;
        String clientCompId = UniqueIDGen.getNextID();

        params.addElement(new StringValue(clientCompId));
        params.addElement(new StringValue((String) request.getAttribute("issueId")));
//        params.addElement(new StringValue((String)request.getAttribute("clientId")));
//        params.addElement(new StringValue((String)request.getAttribute("userId")));
//        params.addElement(new StringValue((String)request.getAttribute("comment")));
        params.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
//        params.addElement(new StringValue("sent"));
        params.addElement(new StringValue("2"));
        params.addElement(new StringValue((String) issueWbo.getAttribute("businessID")));
        params.addElement(new StringValue(servLevel));
        params.addElement(new StringValue((String) request.getAttribute("ticketType")));
//        params.addElement(new StringValue("1"));
        params.addElement(new StringValue(depCode));
        WebBusinessObject wbo = new WebBusinessObject();
        UserMgr userMgr = UserMgr.getInstance();
        String ownerIssue = (String) request.getAttribute("userId");
        wbo = userMgr.getOnSingleKey(ownerIssue);
        params.addElement(new StringValue((String) wbo.getAttribute("userName")));
        params.addElement(new StringValue(ownerIssue));
        params.addElement(new StringValue((String) request.getAttribute("category")));
        //Connection connection = null;
        try {
            //connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertClientComplaint").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }

            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            params = new Vector();

            String issueStatusId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(issueStatusId));
            // 1 mean received from Issue // 2 mean sent from complaint //
            params.addElement(new StringValue("2"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue(clientCompId));
            params.addElement(new StringValue("client_complaint"));
            params.addElement(new StringValue((String) request.getAttribute("issueId")));
            params.addElement(new StringValue((String) persistentUser.getAttribute("userId")));

            forInsert.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }

            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            params = new Vector();

            String sysId = UniqueIDGen.getNextID();

            params.addElement(new StringValue(clientCompId));
            params.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
            params.addElement(new StringValue((String) request.getAttribute("userId")));
            params.addElement(new StringValue("1"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue((String) request.getAttribute("comment")));
            params.addElement(new StringValue(sysId));
            params.addElement(new StringValue((String) request.getAttribute("subject")));
            params.addElement(new StringValue(" "));
            forInsert.setSQLQuery(sqlMgr.getSql("saveDistributionList").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }
            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            params = new Vector();
            params.addElement(new StringValue("1"));

            forInsert.setSQLQuery(sqlMgr.getSql("updateGenericCount").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }
            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            params = new Vector();
            params.addElement(new StringValue((String) request.getAttribute("userId")));

            forInsert.setSQLQuery(sqlMgr.getSql("updateUserTicketsCount").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }
            
            if(request.getAttribute("SLA") != null || request.getAttribute("CRC") != null || request.getParameter("equClassID") != null){
                params = new Vector();
                params.addElement(new StringValue(clientCompId));
                params.addElement(new IntValue( Integer.parseInt( (String) request.getAttribute("SLA"))));
                params.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
                params.addElement(new TimestampValue(new Timestamp(System.currentTimeMillis())));
                params.addElement(new StringValue((String) request.getAttribute("CRC")));
                params.addElement(new StringValue((String) request.getParameter("equClassID")));
                
                forInsert.setSQLQuery(getQuery("insertClientComplaintSLA").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();

                if (queryResult < 0) {
                    transConnection.rollback();
                    return null;
                }
            }

        } catch (SQLException se) {
            logger.error(se.getMessage());
            transConnection.rollback();
            return null;

        } finally {
            endTransaction();
        }

        return clientCompId;
    }

    public WebBusinessObject saveClientComplaint3(HttpServletRequest request, WebBusinessObject persistentUser) throws NoUserInSessionException, SQLException {
//        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        String clientPhone = null;
        String comments = null;

        String servLevel = "0";
        String depCode = null;
        String ownerComplaint = (String) request.getAttribute("managerId");
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        WebBusinessObject wboProj = new WebBusinessObject();
        Vector projectV = new Vector();
        try {
            projectV = projectMgr.getOnArbitraryKey(ownerComplaint, "key5");
            if (projectV.size() > 0) {
                wboProj = (WebBusinessObject) projectV.get(0);
                servLevel = (String) wboProj.getAttribute("optionTwo");
                depCode = (String) wboProj.getAttribute("eqNO");
            }
        } catch (Exception ex) {
            Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (request.getAttribute("orderUrgency") != null) {
            servLevel = (String) request.getAttribute("orderUrgency");
        }

        DateParser dateParser = new DateParser();

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String issueId = (String) request.getAttribute("issueId");
        IssueMgr issueMgr = IssueMgr.getInstance();
        WebBusinessObject issueWbo = new WebBusinessObject();
        issueWbo = (WebBusinessObject) issueMgr.getOnSingleKey(issueId);

//        String clientNoByDate = null;
        String clientCompId = UniqueIDGen.getNextID();

        params.addElement(new StringValue(clientCompId));
        params.addElement(new StringValue((String) request.getAttribute("issueId")));
        params.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
        params.addElement(new StringValue("2"));
        params.addElement(new StringValue((String) issueWbo.getAttribute("businessID")));
        params.addElement(new StringValue(servLevel));
        params.addElement(new StringValue((String) request.getAttribute("ticketType")));
        params.addElement(new StringValue(depCode));
        WebBusinessObject wbo = new WebBusinessObject();
        UserMgr userMgr = UserMgr.getInstance();
        String ownerIssue = (String) request.getAttribute("managerId");
        wbo = userMgr.getOnSingleKey(ownerIssue);
        params.addElement(new StringValue((String) wbo.getAttribute("userName")));
        params.addElement(new StringValue(ownerIssue));
        params.addElement(new StringValue((String) request.getAttribute("category")));
        //Connection connection = null;
        try {
            //connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertClientComplaint").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }

            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            params = new Vector();

            String issueStatusId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(issueStatusId));
            // 1 mean received from Issue // 2 mean sent from complaint //
            params.addElement(new StringValue("2"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue(clientCompId));
            params.addElement(new StringValue("client_complaint"));
            params.addElement(new StringValue((String) request.getAttribute("issueId")));
            params.addElement(new StringValue((String) persistentUser.getAttribute("userId")));

            forInsert.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }

            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            params = new Vector();

            String sysId = UniqueIDGen.getNextID();

            params.addElement(new StringValue(clientCompId));
            params.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
            params.addElement(new StringValue((String) request.getAttribute("managerId")));
            params.addElement(new StringValue("1"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue((String) request.getAttribute("comment")));
            params.addElement(new StringValue(sysId));
            params.addElement(new StringValue((String) request.getAttribute("subject")));
            params.addElement(new StringValue(""));
            forInsert.setSQLQuery(sqlMgr.getSql("saveDistributionList").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }
            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            params = new Vector();
            params.addElement(new StringValue("1"));

            forInsert.setSQLQuery(sqlMgr.getSql("updateGenericCount").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }

            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            params = new Vector();
            params.addElement(new StringValue((String) request.getAttribute("managerId")));

            forInsert.setSQLQuery(sqlMgr.getSql("updateUserTicketsCount").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }

        } catch (SQLException se) {
            logger.error(se.getMessage());
            transConnection.rollback();
            return null;

        } finally {
            endTransaction();

        }
        WebBusinessObject data = new WebBusinessObject();
        data.setAttribute("issueId", issueId);
        data.setAttribute("compId", clientCompId);
        return data;

    }

    public boolean createNotificationComplaint(String clientComplaintId, String loggedUserId, String employeeId, String complaintTitle, String comment) throws Exception {
        command = new SQLCommandBean();
        Vector distributionListParameters = new Vector();
        int queryResult;
        String systemId = UniqueIDGen.getNextID();
        distributionListParameters.addElement(new StringValue(clientComplaintId));
        distributionListParameters.addElement(new StringValue(loggedUserId));
        distributionListParameters.addElement(new StringValue(employeeId));
        distributionListParameters.addElement(new StringValue("2"));
        distributionListParameters.addElement(new StringValue("0"));
        distributionListParameters.addElement(new StringValue("0"));
        distributionListParameters.addElement(new StringValue(""));
        distributionListParameters.addElement(new StringValue(systemId));
        //complaint comment option1
        distributionListParameters.addElement(new StringValue(complaintTitle));
        //distribution comment option2
        distributionListParameters.addElement(new StringValue(comment));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(sqlMgr.getSql("saveDistributionList").trim());
            command.setparams(distributionListParameters);
            queryResult = command.executeUpdate();
            if (queryResult < 0) {
                return false;
            }
        } catch (SQLException ex) {
            logger.error(ex);
            return false;
        } finally {
            connection.close();
        }
        return true;
    }

    synchronized public boolean tellManager(WebBusinessObject manager, String issueId, String ticketType, String subject, String comment, WebBusinessObject persistentUser) throws NoUserInSessionException, SQLException {
        
        Vector clientComplaintParameters = new Vector();
        Vector complaintStatusParameters = new Vector();
        Vector distributionListParameters = new Vector();
        Vector genericCountParameters = new Vector();
        Vector userTicketsCountParameters = new Vector();

        String servLevel = "0";
        String depCode = null;
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        WebBusinessObject wboProj = new WebBusinessObject();
        Vector projectVector = new Vector();
        try {
            projectVector = projectMgr.getOnArbitraryKey((String) manager.getAttribute("userId"), "key5");
            if (projectVector.size() > 0) {
                wboProj = (WebBusinessObject) projectVector.get(0);
                servLevel = (String) wboProj.getAttribute("optionTwo");
                depCode = (String) wboProj.getAttribute("eqNO");
            }
        } catch (Exception ex) {
            logger.error(ex);
        }

        command = new SQLCommandBean();
        int queryResult = -1000;

        IssueMgr issueMgr = IssueMgr.getInstance();
        WebBusinessObject issueWbo = new WebBusinessObject();
        issueWbo = (WebBusinessObject) issueMgr.getOnSingleKey(issueId);
        
        ArrayList<WebBusinessObject> unitsList = ProjectMgr.getInstance().getAllUnitsForClient((String) issueWbo.getAttribute("clientId"));
        StringBuilder subjectBuilder = new StringBuilder();
        for(WebBusinessObject unitWbo : unitsList) {
            subjectBuilder.append(" ").append(unitWbo.getAttribute("projectName")).append("\n");
        }
        if (subjectBuilder.length() > 0) {
            subject = subjectBuilder.toString();
        }

        String clientComplaintId = UniqueIDGen.getNextID();
        clientComplaintParameters.addElement(new StringValue(clientComplaintId));
        clientComplaintParameters.addElement(new StringValue(issueId));
        clientComplaintParameters.addElement(new StringValue(persistentUser != null ? (String) persistentUser.getAttribute("userId") : "-1")); // -1 for automatic user
        clientComplaintParameters.addElement(new StringValue("2"));
        clientComplaintParameters.addElement(new StringValue((String) issueWbo.getAttribute("businessID")));
        clientComplaintParameters.addElement(new StringValue(servLevel));
        clientComplaintParameters.addElement(new StringValue(ticketType));
        clientComplaintParameters.addElement(new StringValue(depCode));
        clientComplaintParameters.addElement(new StringValue((String) manager.getAttribute("userName")));
        clientComplaintParameters.addElement(new StringValue((String) manager.getAttribute("userId")));
        clientComplaintParameters.addElement(new StringValue("UL"));

        String issueStatusId = UniqueIDGen.getNextID();
        complaintStatusParameters.addElement(new StringValue(issueStatusId));
        // 1 mean received from Issue // 2 mean sent from complaint //
        complaintStatusParameters.addElement(new StringValue("2"));
        complaintStatusParameters.addElement(new StringValue("UL"));
        complaintStatusParameters.addElement(new StringValue("UL"));
        complaintStatusParameters.addElement(new StringValue("0"));
        complaintStatusParameters.addElement(new StringValue("UL"));
        complaintStatusParameters.addElement(new StringValue("UL"));
        complaintStatusParameters.addElement(new StringValue("UL"));
        complaintStatusParameters.addElement(new StringValue(clientComplaintId));
        complaintStatusParameters.addElement(new StringValue("client_complaint"));
        complaintStatusParameters.addElement(new StringValue(issueId));
        complaintStatusParameters.addElement(new StringValue(persistentUser != null ? (String) persistentUser.getAttribute("userId") : "-1"));

        String systemId = UniqueIDGen.getNextID();
        distributionListParameters.addElement(new StringValue(clientComplaintId));
        distributionListParameters.addElement(new StringValue(persistentUser != null ? (String) persistentUser.getAttribute("userId") : "-1"));
        distributionListParameters.addElement(new StringValue((String) manager.getAttribute("userId")));
        distributionListParameters.addElement(new StringValue("1"));
        distributionListParameters.addElement(new StringValue("0"));
        distributionListParameters.addElement(new StringValue("0"));
        distributionListParameters.addElement(new StringValue(comment));
        distributionListParameters.addElement(new StringValue(systemId));
        distributionListParameters.addElement(new StringValue(subject));
        distributionListParameters.addElement(new StringValue(""));

        genericCountParameters.addElement(new StringValue("1"));

        userTicketsCountParameters.addElement(new StringValue((String) manager.getAttribute("userId")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            command.setConnection(connection);
            command.setSQLQuery(sqlMgr.getSql("insertClientComplaint").trim());
            command.setparams(clientComplaintParameters);
            queryResult = command.executeUpdate();
            if (queryResult < 0) {
                connection.rollback();
                return false;
            }
            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                logger.error(ex);
            }

            command.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
            command.setparams(complaintStatusParameters);
            queryResult = command.executeUpdate();
            if (queryResult < 0) {
                connection.rollback();
                return false;
            }
            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                logger.error(ex);
            }

            command.setSQLQuery(sqlMgr.getSql("saveDistributionList").trim());
            command.setparams(distributionListParameters);
            queryResult = command.executeUpdate();
            if (queryResult < 0) {
                connection.rollback();
                return false;
            }
            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                logger.error(ex);
            }

            command.setSQLQuery(sqlMgr.getSql("updateGenericCount").trim());
            command.setparams(genericCountParameters);
            queryResult = command.executeUpdate();
            if (queryResult < 0) {
                connection.rollback();
                return false;
            }
            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                logger.error(ex);
            }

            command.setSQLQuery(sqlMgr.getSql("updateUserTicketsCount").trim());
            command.setparams(userTicketsCountParameters);
            queryResult = command.executeUpdate();
            if (queryResult < 0) {
                connection.rollback();
                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            connection.rollback();
            return false;

        } finally {
            connection.commit();
            connection.close();
        }
        return true;

    }

    public boolean saveClientOrder(HttpServletRequest request, WebBusinessObject persistentUser) throws NoUserInSessionException, SQLException {
//        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        String clientPhone = null;
        String comments = null;

        String servLevel = "0";
        String depCode = null;
        String ownerComplaint = (String) request.getAttribute("userId");
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        WebBusinessObject wboProj = new WebBusinessObject();
        Vector projectV = new Vector();
        try {
            projectV = projectMgr.getOnArbitraryKey(ownerComplaint, "key5");
            if (projectV.size() > 0) {
                wboProj = (WebBusinessObject) projectV.get(0);
                servLevel = (String) wboProj.getAttribute("optionTwo");
                depCode = (String) wboProj.getAttribute("eqNO");
            }
        } catch (Exception ex) {
            Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (request.getAttribute("orderUrgency") != null) {
            servLevel = (String) request.getAttribute("orderUrgency");
        }

        DateParser dateParser = new DateParser();

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String issueId = (String) request.getAttribute("issueId");
        IssueMgr issueMgr = IssueMgr.getInstance();
        WebBusinessObject issueWbo = new WebBusinessObject();
        issueWbo = (WebBusinessObject) issueMgr.getOnSingleKey(issueId);

//        String clientNoByDate = null;
        String clientCompId = UniqueIDGen.getNextID();
        request.setAttribute("clientCompId", clientCompId);

        params.addElement(new StringValue(clientCompId));
        params.addElement(new StringValue((String) request.getAttribute("issueId")));
//        params.addElement(new StringValue((String)request.getAttribute("clientId")));
//        params.addElement(new StringValue((String)request.getAttribute("userId")));
//        params.addElement(new StringValue((String)request.getAttribute("comment")));
        params.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
//        params.addElement(new StringValue("sent"));
        params.addElement(new StringValue("2"));
        params.addElement(new StringValue((String) issueWbo.getAttribute("businessID")));
        params.addElement(new StringValue(servLevel));
        params.addElement(new StringValue("25")); // 3la asas en da by7dd complaint , order, query, not sure!
//        params.addElement(new StringValue("1"));
        params.addElement(new StringValue(depCode));
        WebBusinessObject wbo = new WebBusinessObject();
        UserMgr userMgr = UserMgr.getInstance();
        String ownerIssue = (String) request.getAttribute("userId");
        wbo = userMgr.getOnSingleKey(ownerIssue);
        params.addElement(new StringValue((String) wbo.getAttribute("userName")));
        params.addElement(new StringValue(ownerIssue));
        params.addElement(new StringValue((String) request.getAttribute("category")));

        //Connection connection = null;
        try {
            //connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertClientComplaint").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }

            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            params = new Vector();

            String issueStatusId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(issueStatusId));
            // 1 mean received from Issue // 2 mean sent from complaint //
            params.addElement(new StringValue("2"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue(clientCompId));
            params.addElement(new StringValue("client_complaint"));
            params.addElement(new StringValue((String) request.getAttribute("issueId")));
            params.addElement(new StringValue((String) persistentUser.getAttribute("userId")));

            forInsert.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }

            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            params = new Vector();

            String sysId = UniqueIDGen.getNextID();

            params.addElement(new StringValue(clientCompId));
            params.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
            params.addElement(new StringValue((String) request.getAttribute("userId")));
            params.addElement(new StringValue("1"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue((String) request.getAttribute("comment")));
            params.addElement(new StringValue(sysId));
            params.addElement(new StringValue((String) request.getAttribute("subject")));
            params.addElement(new StringValue(" "));

            forInsert.setSQLQuery(sqlMgr.getSql("saveDistributionList").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            params = new Vector();
            params.addElement(new StringValue("1"));

            forInsert.setSQLQuery(sqlMgr.getSql("updateGenericCount").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            params = new Vector();
            params.addElement(new StringValue((String) request.getAttribute("userId")));

            forInsert.setSQLQuery(sqlMgr.getSql("updateUserTicketsCount").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }

        } catch (SQLException se) {
            logger.error(se.getMessage());
            transConnection.rollback();
            return false;

        } finally {
            endTransaction();
        }

        return (queryResult > 0);
    }

    public boolean saveClientQuery(HttpServletRequest request, WebBusinessObject persistentUser) throws NoUserInSessionException, SQLException {
//        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        String clientPhone = null;
        String comments = null;

        String servLevel = "0";
        String depCode = null;
        String ownerComplaint = (String) request.getAttribute("userId");
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        WebBusinessObject wboProj = new WebBusinessObject();
        Vector projectV = new Vector();
        try {
            projectV = projectMgr.getOnArbitraryKey(ownerComplaint, "key5");
            if (projectV.size() > 0) {
                wboProj = (WebBusinessObject) projectV.get(0);
                servLevel = (String) wboProj.getAttribute("optionTwo");
                depCode = (String) wboProj.getAttribute("eqNO");
            }
        } catch (Exception ex) {
            Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
        }

        DateParser dateParser = new DateParser();

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String issueId = (String) request.getAttribute("issueId");
        IssueMgr issueMgr = IssueMgr.getInstance();
        WebBusinessObject issueWbo = new WebBusinessObject();
        issueWbo = (WebBusinessObject) issueMgr.getOnSingleKey(issueId);

//        String clientNoByDate = null;
        String clientCompId = UniqueIDGen.getNextID();

        params.addElement(new StringValue(clientCompId));
        params.addElement(new StringValue((String) request.getAttribute("issueId")));
//        params.addElement(new StringValue((String)request.getAttribute("clientId")));
//        params.addElement(new StringValue((String)request.getAttribute("userId")));
//        params.addElement(new StringValue((String)request.getAttribute("comment")));
        params.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
//        params.addElement(new StringValue("sent"));
        params.addElement(new StringValue("2"));
        params.addElement(new StringValue((String) issueWbo.getAttribute("businessID")));
        params.addElement(new StringValue(servLevel));
        params.addElement(new StringValue((String) request.getAttribute("ticketType"))); // 3la asas en da by7dd complaint , order, query, not sure!
//        params.addElement(new StringValue("1"));
        params.addElement(new StringValue(depCode));
        WebBusinessObject wbo = new WebBusinessObject();
        UserMgr userMgr = UserMgr.getInstance();
        String ownerIssue = (String) request.getAttribute("userId");
        wbo = userMgr.getOnSingleKey(ownerIssue);
        params.addElement(new StringValue((String) wbo.getAttribute("userName")));
        params.addElement(new StringValue(ownerIssue));
        params.addElement(new StringValue((String) request.getAttribute("category")));
        //Connection connection = null;
        try {
            //connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertClientComplaint").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }

            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            params = new Vector();

            String issueStatusId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(issueStatusId));
            // 1 mean received from Issue // 2 mean sent from complaint //
            params.addElement(new StringValue("2"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue(clientCompId));
            params.addElement(new StringValue("client_complaint"));
            params.addElement(new StringValue((String) request.getAttribute("issueId")));
            params.addElement(new StringValue((String) persistentUser.getAttribute("userId")));

            forInsert.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }

            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            params = new Vector();

            String sysId = UniqueIDGen.getNextID();

            params.addElement(new StringValue(clientCompId));
            params.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
            params.addElement(new StringValue((String) request.getAttribute("userId")));
            params.addElement(new StringValue("1"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue((String) request.getAttribute("comment")));
            params.addElement(new StringValue(sysId));
            params.addElement(new StringValue((String) request.getAttribute("subject")));
            params.addElement(new StringValue(" "));
            forInsert.setSQLQuery(sqlMgr.getSql("saveDistributionList").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            params = new Vector();
            params.addElement(new StringValue("1"));

            forInsert.setSQLQuery(sqlMgr.getSql("updateGenericCount").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            params = new Vector();
            params.addElement(new StringValue((String) request.getAttribute("userId")));

            forInsert.setSQLQuery(sqlMgr.getSql("updateUserTicketsCount").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }

        } catch (SQLException se) {
            logger.error(se.getMessage());
            transConnection.rollback();
            return false;

        } finally {
            endTransaction();
        }

        return (queryResult > 0);
    }

    public boolean saveForwardComplaint(WebBusinessObject wbo, HttpServletRequest request, WebBusinessObject persistentUser) throws NoUserInSessionException, SQLException {
//        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        Vector queryResultV = null;
        Connection connection = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        String id = null;
        if (wbo.getAttribute("responsiblity") != null && !wbo.getAttribute("responsiblity").equals("")
                && wbo.getAttribute("responsiblity").toString().equals("1")) {

            try {
                params = new Vector();

                //params.addElement(new StringValue((String) waUser.getAttribute("userId")));
                params.addElement(new StringValue((String) wbo.getAttribute("clientCompId")));
                connection = dataSource.getConnection();
                forQuery.setConnection(connection);
                forQuery.setSQLQuery(sqlMgr.getSql("getCompStatusByUser").trim());
                forQuery.setparams(params);
                queryResultV = forQuery.executeQuery();
                Row r = null;
                Enumeration e = queryResultV.elements();
                while (e.hasMoreElements()) {
                    r = (Row) e.nextElement();
                    try {
                        id = r.getString("STATUS_ID").toString();
                    } catch (NoSuchColumnException ex) {
                        Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            } catch (UnsupportedTypeException uste) {
                logger.error("***** " + uste.getMessage());
            } catch (SQLException e) {
                logger.error(e.getMessage());
            } finally {
                try {
                    connection.close();
                } catch (SQLException sex) {
                    logger.error("troubles closing connection " + sex.getMessage());
                }
            }

            if (id != null && !id.equals("")) {
                params = new Vector();
                params.addElement(new StringValue(id));
                beginTransaction();
                forInsert.setConnection(transConnection);
                forInsert.setSQLQuery(sqlMgr.getSql("updateStatusByUser").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();

                if (queryResult < 0) {
                    transConnection.rollback();
                    return false;
                }
                try {
                    Thread.sleep(50);
                } catch (InterruptedException ex) {
                    Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
                } finally {
                    endTransaction();
                }
            }

            params = new Vector();
            String issueStatusId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(issueStatusId));
            params.addElement(new StringValue("4"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue((String) wbo.getAttribute("clientCompId")));
            params.addElement(new StringValue("client_complaint"));
            params.addElement(new StringValue((String) wbo.getAttribute("issueId")));
            params.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
//            params.addElement(new StringValue(" "));
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }

            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                endTransaction();
            }
        }

        params = new Vector();

        String sysId = UniqueIDGen.getNextID();

        params.addElement(new StringValue((String) wbo.getAttribute("clientCompId")));
        params.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
        params.addElement(new StringValue((String) wbo.getAttribute("employeeId")));
        params.addElement(new StringValue((String) wbo.getAttribute("responsiblity")));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue((String) wbo.getAttribute("complaintComment")));
        params.addElement(new StringValue(sysId));
        params.addElement(new StringValue((String) wbo.getAttribute("compSubject")));
        params.addElement(new StringValue((String) wbo.getAttribute("notes")));
        beginTransaction();
        forInsert.setConnection(transConnection);
        forInsert.setSQLQuery(sqlMgr.getSql("saveDistributionList").trim());
        forInsert.setparams(params);
        queryResult = forInsert.executeUpdate();

        if (queryResult < 0) {
            transConnection.rollback();
            return false;
        }

        try {
            Thread.sleep(50);
        } catch (InterruptedException ex) {
            Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            endTransaction();
        }

        params = new Vector();
        params.addElement(new StringValue((String) wbo.getAttribute("employeeId")));
        beginTransaction();
        forInsert.setConnection(transConnection);
        forInsert.setSQLQuery(sqlMgr.getSql("updateUserTicketsCount").trim());
        forInsert.setparams(params);
        queryResult = forInsert.executeUpdate();

        if (queryResult < 0) {
            transConnection.rollback();
            return false;
        }
        try {
            Thread.sleep(50);
        } catch (InterruptedException ex) {
            Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            endTransaction();
        }

        WebBusinessObject compWbo = getOnSingleKey(wbo.getAttribute("clientCompId").toString());
        if (!compWbo.getAttribute("currentStatus").toString().equals("4")) {
            updateClientComplaint(wbo.getAttribute("clientCompId").toString(), (String) wbo.getAttribute("employeeId"));

        }

        return true;
    }

    public boolean saveForwardComplaintSuperVisor(WebBusinessObject wbo, HttpServletRequest request, HttpSession s) throws NoUserInSessionException, SQLException {
//        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        Vector queryResultV = null;
        Connection connection = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        String id = null;
        if (wbo.getAttribute("responsiblity") != null && !wbo.getAttribute("responsiblity").equals("")
                && wbo.getAttribute("responsiblity").toString().equals("1")) {

            try {
                params = new Vector();

                //params.addElement(new StringValue((String) waUser.getAttribute("userId")));
                params.addElement(new StringValue((String) wbo.getAttribute("clientCompId")));
                connection = dataSource.getConnection();
                forQuery.setConnection(connection);
                forQuery.setSQLQuery(sqlMgr.getSql("getCompStatusByUser").trim());
                forQuery.setparams(params);
                queryResultV = forQuery.executeQuery();
                Row r = null;
                Enumeration e = queryResultV.elements();
                while (e.hasMoreElements()) {
                    r = (Row) e.nextElement();
                    try {
                        id = r.getString("STATUS_ID").toString();
                    } catch (NoSuchColumnException ex) {
                        Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            } catch (UnsupportedTypeException uste) {
                logger.error("***** " + uste.getMessage());
            } catch (SQLException e) {
                logger.error(e.getMessage());
            } finally {
                try {
                    connection.close();
                } catch (SQLException sex) {
                    logger.error("troubles closing connection " + sex.getMessage());
                }
            }

            if (id != null && !id.equals("")) {
                params = new Vector();
                params.addElement(new StringValue(id));
                beginTransaction();
                forInsert.setConnection(transConnection);
                forInsert.setSQLQuery(sqlMgr.getSql("updateStatusByUser").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();

                if (queryResult < 0) {
                    transConnection.rollback();
                    return false;
                }
                try {
                    Thread.sleep(50);
                } catch (InterruptedException ex) {
                    Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
                } finally {
                    endTransaction();
                }
            }

            params = new Vector();
            String issueStatusId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(issueStatusId));
            params.addElement(new StringValue("4"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue((String) wbo.getAttribute("clientCompId")));
            params.addElement(new StringValue("client_complaint"));
            params.addElement(new StringValue((String) wbo.getAttribute("issueId")));
            params.addElement(new StringValue((String) wbo.getAttribute("supervisorId")));
//            params.addElement(new StringValue(" "));
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }

            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                endTransaction();
            }
        }

        params = new Vector();

        String sysId = UniqueIDGen.getNextID();

        params.addElement(new StringValue((String) wbo.getAttribute("clientCompId")));
        params.addElement(new StringValue((String) wbo.getAttribute("supervisorId")));
        params.addElement(new StringValue((String) wbo.getAttribute("employeeId")));
        params.addElement(new StringValue((String) wbo.getAttribute("responsiblity")));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue((String) wbo.getAttribute("complaintComment")));
        params.addElement(new StringValue(sysId));
        params.addElement(new StringValue((String) wbo.getAttribute("compSubject")));
        params.addElement(new StringValue((String) wbo.getAttribute("notes")));
        beginTransaction();
        forInsert.setConnection(transConnection);
        forInsert.setSQLQuery(sqlMgr.getSql("saveDistributionList").trim());
        forInsert.setparams(params);
        queryResult = forInsert.executeUpdate();

        if (queryResult < 0) {
            transConnection.rollback();
            return false;
        }

        try {
            Thread.sleep(50);
        } catch (InterruptedException ex) {
            Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            endTransaction();
        }

        params = new Vector();
        params.addElement(new StringValue((String) wbo.getAttribute("employeeId")));
        beginTransaction();
        forInsert.setConnection(transConnection);
        forInsert.setSQLQuery(sqlMgr.getSql("updateUserTicketsCount").trim());
        forInsert.setparams(params);
        queryResult = forInsert.executeUpdate();

        if (queryResult < 0) {
            transConnection.rollback();
            return false;
        }
        try {
            Thread.sleep(50);
        } catch (InterruptedException ex) {
            Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            endTransaction();
        }

        WebBusinessObject compWbo = getOnSingleKey(wbo.getAttribute("clientCompId").toString());
        if (!compWbo.getAttribute("currentStatus").toString().equals("4")) {
            updateClientComplaint(wbo.getAttribute("clientCompId").toString(), (String) wbo.getAttribute("employeeId"));

        }

        return true;
    }

    public boolean distibutionResponsibility(String employeeId, String responsibility, WebBusinessObject wbo, HttpServletRequest request, WebBusinessObject persistentUser) throws NoUserInSessionException, SQLException {
//        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        Vector queryResultV = null;
        Connection connection = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        String id = null;
        if (responsibility != null && !responsibility.equals("")) {
            try {
                params = new Vector();
                params.addElement(new StringValue((String) wbo.getAttribute("clientCompId")));
                connection = dataSource.getConnection();
                forQuery.setConnection(connection);
                forQuery.setSQLQuery(sqlMgr.getSql("getCompStatusByUser").trim());
                forQuery.setparams(params);
                queryResultV = forQuery.executeQuery();
                Row r = null;
                Enumeration e = queryResultV.elements();
                while (e.hasMoreElements()) {
                    r = (Row) e.nextElement();
                    try {
                        id = r.getString("STATUS_ID").toString();
                    } catch (NoSuchColumnException ex) {
                        Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            } catch (UnsupportedTypeException uste) {
                logger.error("***** " + uste.getMessage());
            } catch (SQLException e) {
                logger.error(e.getMessage());
            } finally {
                try {
                    connection.close();
                } catch (SQLException sex) {
                    logger.error("troubles closing connection " + sex.getMessage());
                }
            }

            if (id != null && !id.equals("")) {
                params = new Vector();
                params.addElement(new StringValue(id));
                beginTransaction();
                forInsert.setConnection(transConnection);
                forInsert.setSQLQuery(sqlMgr.getSql("updateStatusByUser").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();

                if (queryResult < 0) {
                    transConnection.rollback();
                    return false;
                }
                try {
                    Thread.sleep(50);
                } catch (InterruptedException ex) {
                    Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
                } finally {
                    endTransaction();
                }
            }

            params = new Vector();
            String issueStatusId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(issueStatusId));
            params.addElement(new StringValue("4"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue((String) wbo.getAttribute("clientCompId")));
            params.addElement(new StringValue("client_complaint"));
            params.addElement(new StringValue((String) wbo.getAttribute("issueId")));
            params.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
//            params.addElement(new StringValue(" "));
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }

            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                endTransaction();
            }
        }

        params = new Vector();

        String sysId = UniqueIDGen.getNextID();

        params.addElement(new StringValue((String) wbo.getAttribute("clientCompId")));
        params.addElement(new StringValue((String) wbo.getAttribute("departmentMgrId")));
        params.addElement(new StringValue(employeeId));
        params.addElement(new StringValue(responsibility));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue((String) wbo.getAttribute("complaintComment")));
        params.addElement(new StringValue(sysId));
        params.addElement(new StringValue((String) wbo.getAttribute("compSubject")));
        params.addElement(new StringValue("UL"));
        beginTransaction();
        forInsert.setConnection(transConnection);
        forInsert.setSQLQuery(sqlMgr.getSql("saveDistributionList").trim());
        forInsert.setparams(params);
        queryResult = forInsert.executeUpdate();

        if (queryResult < 0) {
            transConnection.rollback();
            return false;
        }

        try {
            Thread.sleep(50);
        } catch (InterruptedException ex) {
            Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            endTransaction();
        }

        params = new Vector();
        params.addElement(new StringValue(employeeId));
        beginTransaction();
        forInsert.setConnection(transConnection);
        forInsert.setSQLQuery(sqlMgr.getSql("updateUserTicketsCount").trim());
        forInsert.setparams(params);
        queryResult = forInsert.executeUpdate();

        if (queryResult < 0) {
            transConnection.rollback();
            return false;
        }
        try {
            Thread.sleep(50);
        } catch (InterruptedException ex) {
            Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            endTransaction();
        }
        WebBusinessObject compWbo = getOnSingleKey(wbo.getAttribute("clientCompId").toString());
        if (!compWbo.getAttribute("currentStatus").toString().equals("4")) {
            updateClientComplaint(wbo.getAttribute("clientCompId").toString(), employeeId);

        }

        return true;
    }

    public boolean distibutionResponsibility2(String employeeId, String responsibility, WebBusinessObject wbo, HttpServletRequest request, WebBusinessObject persistentUser) throws NoUserInSessionException, SQLException {
//        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        Vector queryResultV = null;
        Connection connection = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        String id = null;
        if (responsibility != null && !responsibility.equals("")) {

            try {
                params = new Vector();

                //params.addElement(new StringValue((String) waUser.getAttribute("userId")));
                params.addElement(new StringValue((String) wbo.getAttribute("clientCompId")));
                connection = dataSource.getConnection();
                forQuery.setConnection(connection);
                forQuery.setSQLQuery(sqlMgr.getSql("getCompStatusByUser").trim());
                forQuery.setparams(params);
                queryResultV = forQuery.executeQuery();
                Row r = null;
                Enumeration e = queryResultV.elements();
                while (e.hasMoreElements()) {
                    r = (Row) e.nextElement();
                    try {
                        id = r.getString("STATUS_ID").toString();
                    } catch (NoSuchColumnException ex) {
                        Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            } catch (UnsupportedTypeException uste) {
                logger.error("***** " + uste.getMessage());
            } catch (SQLException e) {
                logger.error(e.getMessage());
            } finally {
                try {
                    connection.close();
                } catch (SQLException sex) {
                    logger.error("troubles closing connection " + sex.getMessage());
                }
            }

            if (id != null && !id.equals("")) {
                params = new Vector();
                params.addElement(new StringValue(id));
                beginTransaction();
                forInsert.setConnection(transConnection);
                forInsert.setSQLQuery(sqlMgr.getSql("updateStatusByUser").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();

                if (queryResult < 0) {
                    transConnection.rollback();
                    return false;
                }
                try {
                    Thread.sleep(50);
                } catch (InterruptedException ex) {
                    Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
                } finally {
                    endTransaction();
                }
            }

            params = new Vector();
            String issueStatusId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(issueStatusId));
            params.addElement(new StringValue("4"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue((String) wbo.getAttribute("clientCompId")));
            params.addElement(new StringValue("client_complaint"));
            params.addElement(new StringValue((String) wbo.getAttribute("issueId")));
            params.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
//            params.addElement(new StringValue(" "));
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }

            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                endTransaction();
            }
        }

        params = new Vector();

        String sysId = UniqueIDGen.getNextID();

        params.addElement(new StringValue((String) wbo.getAttribute("clientCompId")));
        params.addElement(new StringValue((String) wbo.getAttribute("managerId")));
        params.addElement(new StringValue(employeeId));
        params.addElement(new StringValue(responsibility));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue((String) wbo.getAttribute("complaintComment")));
        params.addElement(new StringValue(sysId));
        params.addElement(new StringValue((String) wbo.getAttribute("compSubject")));
        params.addElement(new StringValue(""));
        beginTransaction();
        forInsert.setConnection(transConnection);
        forInsert.setSQLQuery(sqlMgr.getSql("saveDistributionList").trim());
        forInsert.setparams(params);
        queryResult = forInsert.executeUpdate();

        if (queryResult < 0) {
            transConnection.rollback();
            return false;
        }
        try {
            Thread.sleep(50);
        } catch (InterruptedException ex) {
            Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
        }

        params = new Vector();
        params.addElement(new StringValue("1"));

        forInsert.setSQLQuery(sqlMgr.getSql("updateGenericCount").trim());
        forInsert.setparams(params);
        queryResult = forInsert.executeUpdate();

        if (queryResult < 0) {
            transConnection.rollback();
            return false;
        }

        try {
            Thread.sleep(50);
        } catch (InterruptedException ex) {
            Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            endTransaction();
        }
        WebBusinessObject compWbo = getOnSingleKey(wbo.getAttribute("clientCompId").toString());
        if (!compWbo.getAttribute("currentStatus").toString().equals("4")) {
            updateClientComplaint(wbo.getAttribute("clientCompId").toString(), employeeId);

        }

        return true;
    }

    public boolean distibutionResponsibility3(String employeeId, String responsibility, WebBusinessObject wbo, HttpServletRequest request, HttpSession s) throws NoUserInSessionException, SQLException {
//        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        Vector queryResultV = null;
        Connection connection = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        String id = null;
        if (responsibility != null && !responsibility.equals("")) {

            try {
                params = new Vector();

                //params.addElement(new StringValue((String) waUser.getAttribute("userId")));
                params.addElement(new StringValue((String) wbo.getAttribute("clientCompId")));
                connection = dataSource.getConnection();
                forQuery.setConnection(connection);
                forQuery.setSQLQuery(sqlMgr.getSql("getCompStatusByUser").trim());
                forQuery.setparams(params);
                queryResultV = forQuery.executeQuery();
                Row r = null;
                Enumeration e = queryResultV.elements();
                while (e.hasMoreElements()) {
                    r = (Row) e.nextElement();
                    try {
                        id = r.getString("STATUS_ID").toString();
                    } catch (NoSuchColumnException ex) {
                        Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            } catch (UnsupportedTypeException uste) {
                logger.error("***** " + uste.getMessage());
            } catch (SQLException e) {
                logger.error(e.getMessage());
            } finally {
                try {
                    connection.close();
                } catch (SQLException sex) {
                    logger.error("troubles closing connection " + sex.getMessage());
                }
            }

            if (id != null && !id.equals("")) {
                params = new Vector();
                params.addElement(new StringValue(id));
                beginTransaction();
                forInsert.setConnection(transConnection);
                forInsert.setSQLQuery(sqlMgr.getSql("updateStatusByUser").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();

                if (queryResult < 0) {
                    transConnection.rollback();
                    return false;
                }
                try {
                    Thread.sleep(50);
                } catch (InterruptedException ex) {
                    Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
                } finally {
                    endTransaction();
                }
            }

            params = new Vector();
            String issueStatusId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(issueStatusId));
            params.addElement(new StringValue("4"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue((String) wbo.getAttribute("clientCompId")));
            params.addElement(new StringValue("client_complaint"));
            params.addElement(new StringValue((String) wbo.getAttribute("issueId")));
            params.addElement(new StringValue((String) wbo.getAttribute("managerId")));
//            params.addElement(new StringValue(" "));
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }

            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                endTransaction();
            }
        }

        params = new Vector();

        String sysId = UniqueIDGen.getNextID();

        params.addElement(new StringValue((String) wbo.getAttribute("clientCompId")));
        params.addElement(new StringValue((String) wbo.getAttribute("managerId")));
        params.addElement(new StringValue(employeeId));
        params.addElement(new StringValue(responsibility));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue((String) wbo.getAttribute("complaintComment")));
        params.addElement(new StringValue(sysId));
        params.addElement(new StringValue((String) wbo.getAttribute("compSubject")));
        params.addElement(new StringValue(""));
        beginTransaction();
        forInsert.setConnection(transConnection);
        forInsert.setSQLQuery(sqlMgr.getSql("saveDistributionList").trim());
        forInsert.setparams(params);
        queryResult = forInsert.executeUpdate();

        if (queryResult < 0) {
            transConnection.rollback();
            return false;
        }
        try {
            Thread.sleep(50);
        } catch (InterruptedException ex) {
            Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
        }

        params = new Vector();
        params.addElement(new StringValue("1"));

        forInsert.setSQLQuery(sqlMgr.getSql("updateGenericCount").trim());
        forInsert.setparams(params);
        queryResult = forInsert.executeUpdate();

        if (queryResult < 0) {
            transConnection.rollback();
            return false;
        }

        try {
            Thread.sleep(50);
        } catch (InterruptedException ex) {
            Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            endTransaction();
        }
        WebBusinessObject compWbo = getOnSingleKey(wbo.getAttribute("clientCompId").toString());
        if (!compWbo.getAttribute("currentStatus").toString().equals("4")) {
            updateClientComplaint(wbo.getAttribute("clientCompId").toString(), employeeId);

        }

        return true;
    }

    public boolean updateClientComplaint(String clientCompId) throws NoUserInSessionException, SQLException {

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params = new Vector();
        params.addElement(new StringValue("4"));
        params.addElement(new StringValue(clientCompId));
        beginTransaction();
        forInsert.setConnection(transConnection);
        forInsert.setSQLQuery(sqlMgr.getSql("updateClientComplaint").trim());
        forInsert.setparams(params);
        queryResult = forInsert.executeUpdate();

        if (queryResult < 0) {
            transConnection.rollback();
            return false;
        }
        try {
            Thread.sleep(50);
        } catch (InterruptedException ex) {
            Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            endTransaction();
        }

        return (queryResult > 0);
    }

    public boolean updateClientComplaint(String clientCompId, String employeeId) throws NoUserInSessionException, SQLException {

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        UserMgr userMgr = UserMgr.getInstance();
        WebBusinessObject wbo2 = new WebBusinessObject();
        wbo2 = userMgr.getOnSingleKey(employeeId);
        String ownerName = "empty";
        if (wbo2 != null) {
            ownerName = (String) wbo2.getAttribute("userName");
        }
        params = new Vector();
        params.addElement(new StringValue("4"));

        params.addElement(new StringValue(employeeId));
        params.addElement(new StringValue(ownerName));
        params.addElement(new StringValue(clientCompId));
        beginTransaction();
        forInsert.setConnection(transConnection);
        forInsert.setSQLQuery(sqlMgr.getSql("updateClientComplaint2").trim());
        forInsert.setparams(params);
        queryResult = forInsert.executeUpdate();

        if (queryResult < 0) {
            transConnection.rollback();
            return false;
        }
        try {
            Thread.sleep(50);
        } catch (InterruptedException ex) {
            Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            endTransaction();
        }

        return (queryResult > 0);
    }

    public WebBusinessObject getOriginalOwner(String compId) throws SQLException, NoSuchColumnException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Vector queryResult = null;

        params = new Vector();

        params.addElement(new StringValue(compId));
        beginTransaction();
        forInsert.setConnection(transConnection);
        forInsert.setSQLQuery(sqlMgr.getSql("getOriginalOwner").trim());
        forInsert.setparams(params);
        try {
            queryResult = forInsert.executeQuery();

            if (queryResult != null && !queryResult.isEmpty()) {
                Vector resultBusObjs = new Vector();
                Row r = null;
                Enumeration q = queryResult.elements();
                WebBusinessObject wbo = new WebBusinessObject();
                while (q.hasMoreElements()) {

                    r = (Row) q.nextElement();

                    wbo = new WebBusinessObject();
                    wbo.setAttribute("id", r.getString(1));

                }
                String originalOwnerId = (String) wbo.getAttribute("id");
                DistributionListMgr distributionListMgr = DistributionListMgr.getInstance();
//                EmployeeViewMgr employeeViewMgr = EmployeeViewMgr.getInstance();
                wbo = new WebBusinessObject();
                wbo = distributionListMgr.getOnSingleKey(originalOwnerId);
                String ownerId = "";
                if (wbo != null) {
                    ownerId = (String) wbo.getAttribute("receipId");
                }
                try {
                    Thread.sleep(50);
                } catch (InterruptedException ex) {
                    Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                wbo = new WebBusinessObject();

                UserMgr um = UserMgr.getInstance();
                wbo = um.getOnSingleKey(ownerId);
                return wbo;
            } else {
                return null;
            }

        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            endTransaction();
        }

    }

    public WebBusinessObject getCurrentOwner(String compId) throws SQLException, NoSuchColumnException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        Vector queryResult = null;

        params = new Vector();

        params.addElement(new StringValue(compId));
        beginTransaction();
        forInsert.setConnection(transConnection);
        forInsert.setSQLQuery(sqlMgr.getSql("getCurrentOwner").trim());
        forInsert.setparams(params);
        try {
            queryResult = forInsert.executeQuery();

            if (queryResult != null && !queryResult.isEmpty()) {
                Vector resultBusObjs = new Vector();
                Row r = null;
//                for (WebBusinessObject wbo:queryResult) {
//                    
//                    WebBusinessObject wbo = new WebBusinessObject();
//                    wbo.setAttribute("id", queryResult.elementAt(0));
//                    System.out.println("result=" + wbo.getAttribute("id"));
//                }
                Enumeration q = queryResult.elements();
                WebBusinessObject wbo = new WebBusinessObject();
                while (q.hasMoreElements()) {

                    r = (Row) q.nextElement();

                    wbo = new WebBusinessObject();
                    wbo.setAttribute("id", r.getString(1));

                }
                String originalOwnerId = (String) wbo.getAttribute("id");
                DistributionListMgr distributionListMgr = DistributionListMgr.getInstance();
//                EmployeeViewMgr employeeViewMgr = EmployeeViewMgr.getInstance();
                wbo = new WebBusinessObject();
                wbo = distributionListMgr.getOnSingleKey(originalOwnerId);
                String ownerId = "";
                if (wbo != null) {
                    ownerId = (String) wbo.getAttribute("receipId");
                }
                try {
                    Thread.sleep(50);
                } catch (InterruptedException ex) {
                    Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                wbo = new WebBusinessObject();

                UserMgr um = UserMgr.getInstance();
                wbo = um.getOnSingleKey(ownerId);
                return wbo;
            } else {
                return null;
            }

        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            endTransaction();
        }

    }

    public WebBusinessObject getCurrentSenderAndResponsible(String clientCompliantId) {
        command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector result;
        WebBusinessObject wbo = null;

        parameters.addElement(new StringValue(clientCompliantId));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getCurrentSenderAndResponsible").trim());
            command.setparams(parameters);
            result = command.executeQuery();

            if (result != null && !result.isEmpty()) {
                String sender, senderId, responsible;
                Row row;
                Enumeration q = result.elements();
                while (q.hasMoreElements()) {
                    row = (Row) q.nextElement();
                    senderId = row.getString("SENDER_ID");
                    sender = row.getString("SENDER");
                    responsible = row.getString("RESPONSIBLE");
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("senderId", senderId);
                    wbo.setAttribute("sender", sender);
                    wbo.setAttribute("responsible", responsible);
                }
            }

        } catch (SQLException ex) {
            logger.error(ex);
        } catch (NoSuchColumnException ex) {
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
        return wbo;
    }

    public String getLastTicketTypeOnIssue(String issueId, String ticketType) {
        command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result;

        parameters.addElement(new StringValue(issueId));
        parameters.addElement(new StringValue(ticketType));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getLastTicketTypeOnIssue").trim());
            command.setparams(parameters);
            result = command.executeQuery();

            for (Row row : result) {
                return row.getString("ID");
            }

        } catch (SQLException ex) {
            logger.error(ex);
        } catch (NoSuchColumnException ex) {
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
        return null;
    }

    public String clientComplaintExtractingOrder(HttpServletRequest request, WebBusinessObject persistentUser, List<FileMeta> files, String managerId, String employeeId, String employeeName) throws NoUserInSessionException, SQLException {
        SequenceMgr sequenceMgr = SequenceMgr.getInstance();
        sequenceMgr.updateSequence();

        String businessID = sequenceMgr.getSequence();
        String servLevel = "0";
        String depCode = null;
        String documentTitle = request.getParameter("documentTitle");
        String issueId = request.getParameter("issueId");
        String description = request.getParameter("description");
        String documentType = request.getParameter("fileExtension");
        String ticketType = request.getParameter("ticketType");
        WebBusinessObject fileDescriptor = FileMgr.getInstance().getObjectFromCash(documentType);
        String metaType = (String) fileDescriptor.getAttribute("metaType");

        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new java.util.Date());

        Vector clientCompliantParameters = new Vector();
        Vector distributionListParameters = new Vector();
        Vector issueDocumentParameters = new Vector();
        Vector issueDocumentDataParameters = new Vector();
        Vector getCompStatusByUserParameters = new Vector();
        Vector saveCompStatusParameters = new Vector();
        Vector saveCompStatusParameters2 = new Vector();
        Vector saveDistributionListParameters2 = new Vector();
        Vector updateUserTicketsCountParameters = new Vector();
        Vector updateClientComplaint2Parameters = new Vector();

        command = new SQLCommandBean();
        int queryResult = -1000;

        String documentId = UniqueIDGen.getNextID();
        String clientComplaintId = UniqueIDGen.getNextID();

        if (!files.isEmpty() && managerId != null && employeeId != null) {
            // project info
            ProjectMgr projectMgr = ProjectMgr.getInstance();
            WebBusinessObject wboProject;
            Vector projectVector;
            try {
                projectVector = projectMgr.getOnArbitraryKey(managerId, "key5");
                if (projectVector.size() > 0) {
                    wboProject = (WebBusinessObject) projectVector.get(0);
                    servLevel = (String) wboProject.getAttribute("optionTwo");
                    depCode = (String) wboProject.getAttribute("eqNO");
                }
            } catch (Exception ex) {
                logger.error(ex);
            }

            // setup client complimet data
            clientCompliantParameters.addElement(new StringValue(clientComplaintId));
            clientCompliantParameters.addElement(new StringValue(issueId));
            clientCompliantParameters.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
            clientCompliantParameters.addElement(new StringValue("2"));
            clientCompliantParameters.addElement(new StringValue(businessID));
            clientCompliantParameters.addElement(new StringValue(servLevel));
            clientCompliantParameters.addElement(new StringValue(ticketType));
            clientCompliantParameters.addElement(new StringValue(depCode));
            clientCompliantParameters.addElement(new StringValue((String) persistentUser.getAttribute("userName")));
            clientCompliantParameters.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
            clientCompliantParameters.addElement(new StringValue("UL"));

            // setup distribution list data
            distributionListParameters.addElement(new StringValue(clientComplaintId));
            distributionListParameters.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
            distributionListParameters.addElement(new StringValue(managerId));
            distributionListParameters.addElement(new StringValue("1"));
            distributionListParameters.addElement(new StringValue("0"));
            distributionListParameters.addElement(new StringValue("0"));
            distributionListParameters.addElement(new StringValue((String) request.getParameter("comment")));
            distributionListParameters.addElement(new StringValue(UniqueIDGen.getNextID()));
            distributionListParameters.addElement(new StringValue((String) request.getParameter("subject")));
            distributionListParameters.addElement(new StringValue(" "));

            // setup document info.
            issueDocumentParameters.addElement(new StringValue(documentId));
            issueDocumentParameters.addElement(new StringValue(documentTitle));
            issueDocumentParameters.addElement(new StringValue(clientComplaintId));
            issueDocumentParameters.addElement(new StringValue("client_complaint"));
            issueDocumentParameters.addElement(new StringValue(description));
            issueDocumentParameters.addElement(new TimestampValue(getTimestamp(request.getParameter("documentDate"))));
            issueDocumentParameters.addElement(new StringValue(persistentUser.getAttribute("userId").toString()));
            issueDocumentParameters.addElement(new StringValue(persistentUser.getAttribute("userName").toString()));
            issueDocumentParameters.addElement(new StringValue(metaType));
            issueDocumentParameters.addElement(new StringValue(documentType));
            issueDocumentParameters.addElement(new StringValue(request.getParameter("configType")));
            System.out.println("name is ==> " + files.get(0).getFileName());
            issueDocumentParameters.addElement(new StringValue(files.get(0).getFileName()));//option1
            issueDocumentParameters.addElement(new StringValue(request.getParameter("")));
            issueDocumentParameters.addElement(new StringValue(request.getParameter("")));

            // setup document data info.
            issueDocumentDataParameters.addElement(new StringValue(documentId));
            issueDocumentDataParameters.addElement(new ImageValue(files.get(0).getContent(), files.get(0).getFileSize()));

            getCompStatusByUserParameters.addElement(new StringValue(clientComplaintId));
            updateUserTicketsCountParameters.addElement(new StringValue(employeeId));

            String issueStatusId = UniqueIDGen.getNextID();
            saveCompStatusParameters.addElement(new StringValue(issueStatusId));
            saveCompStatusParameters.addElement(new StringValue("2"));
            saveCompStatusParameters.addElement(new StringValue("UL"));
            saveCompStatusParameters.addElement(new StringValue("UL"));
            saveCompStatusParameters.addElement(new StringValue("0"));
            saveCompStatusParameters.addElement(new StringValue("UL"));
            saveCompStatusParameters.addElement(new StringValue("UL"));
            saveCompStatusParameters.addElement(new StringValue("UL"));
            saveCompStatusParameters.addElement(new StringValue(clientComplaintId));
            saveCompStatusParameters.addElement(new StringValue("client_complaint"));
            saveCompStatusParameters.addElement(new StringValue(issueId));
            saveCompStatusParameters.addElement(new StringValue((String) persistentUser.getAttribute("userId")));

            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }
            String issueStatusId2 = UniqueIDGen.getNextID();
            saveCompStatusParameters2.addElement(new StringValue(issueStatusId2));
            saveCompStatusParameters2.addElement(new StringValue("4"));
            saveCompStatusParameters2.addElement(new StringValue("UL"));
            saveCompStatusParameters2.addElement(new StringValue("UL"));
            saveCompStatusParameters2.addElement(new StringValue("0"));
            saveCompStatusParameters2.addElement(new StringValue("UL"));
            saveCompStatusParameters2.addElement(new StringValue("UL"));
            saveCompStatusParameters2.addElement(new StringValue("UL"));
            saveCompStatusParameters2.addElement(new StringValue(clientComplaintId));
            saveCompStatusParameters2.addElement(new StringValue("client_complaint"));
            saveCompStatusParameters2.addElement(new StringValue(issueId));
            saveCompStatusParameters2.addElement(new StringValue(managerId));

            String sysId = UniqueIDGen.getNextID();
            saveDistributionListParameters2.addElement(new StringValue(clientComplaintId));
            saveDistributionListParameters2.addElement(new StringValue(managerId));
            saveDistributionListParameters2.addElement(new StringValue(employeeId));
            saveDistributionListParameters2.addElement(new StringValue("1"));
            saveDistributionListParameters2.addElement(new StringValue("0"));
            saveDistributionListParameters2.addElement(new StringValue("0"));
            saveDistributionListParameters2.addElement(new StringValue((String) request.getParameter("comment")));
            saveDistributionListParameters2.addElement(new StringValue(sysId));
            saveDistributionListParameters2.addElement(new StringValue((String) request.getParameter("subject")));
            saveDistributionListParameters2.addElement(new StringValue((String) request.getParameter("notes")));

            updateClientComplaint2Parameters.addElement(new StringValue("4"));
            updateClientComplaint2Parameters.addElement(new StringValue(employeeId));
            updateClientComplaint2Parameters.addElement(new StringValue(employeeName));
            updateClientComplaint2Parameters.addElement(new StringValue(clientComplaintId));

            Connection connection = null;
            try {
                connection = dataSource.getConnection();
                connection.setAutoCommit(false);
                command.setConnection(connection);

                // saving client complaint data
                command.setSQLQuery(sqlMgr.getSql("insertClientComplaint").trim());
                command.setparams(clientCompliantParameters);
                queryResult = command.executeUpdate();
                if (queryResult < 0) {
                    connection.rollback();
                    return null;
                }
                try {
                    Thread.sleep(200);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }

                // saving distriution list data
                command.setSQLQuery(sqlMgr.getSql("saveDistributionList").trim());
                command.setparams(distributionListParameters);
                queryResult = command.executeUpdate();
                if (queryResult < 0) {
                    connection.rollback();
                    return null;
                }
                try {
                    Thread.sleep(200);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }

                command.setSQLQuery(sqlMgr.getSql("insertIssueDocument").trim());
                command.setparams(issueDocumentParameters);
                queryResult = command.executeUpdate();
                if (queryResult < 0) {
                    connection.rollback();
                    return null;
                }
                try {
                    Thread.sleep(200);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }

                // add alert type from attach file
                boolean saved = AlertMgr.getInstance().saveObject(clientComplaintId, CRMConstants.ALERT_TYPE_ID_ATTACH_FILE, persistentUser.getAttribute("userId").toString(), connection);
                if (!saved) {
                    connection.rollback();
                    return null;
                }
                try {
                    Thread.sleep(200);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }

                command.setSQLQuery(sqlMgr.getSql("insertIssueDocumentData").trim());
                command.setparams(issueDocumentDataParameters);
                queryResult = command.executeUpdate();
                if (queryResult < 0) {
                    connection.rollback();
                    return null;
                }
                try {
                    Thread.sleep(200);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }

                // create new issue status
                command.setSQLQuery(sqlMgr.getSql("saveCompStatus3").trim());
                command.setparams(saveCompStatusParameters);
                queryResult = command.executeUpdate();
                if (queryResult < 0) {
                    connection.rollback();
                    return null;
                }
                try {
                    Thread.sleep(200);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }

                // create new issue status
                command.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
                command.setparams(saveCompStatusParameters2);
                queryResult = command.executeUpdate();
                if (queryResult < 0) {
                    connection.rollback();
                    return null;
                }
                try {
                    Thread.sleep(200);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }

                command.setSQLQuery(sqlMgr.getSql("saveDistributionList").trim());
                command.setparams(saveDistributionListParameters2);
                queryResult = command.executeUpdate();
                if (queryResult < 0) {
                    connection.rollback();
                    return null;
                }
                try {
                    Thread.sleep(200);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }

                command.setSQLQuery(sqlMgr.getSql("updateUserTicketsCount").trim());
                command.setparams(updateUserTicketsCountParameters);
                queryResult = command.executeUpdate();
                if (queryResult < 0) {
                    connection.rollback();
                    return null;
                }
                try {
                    Thread.sleep(100);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }

                command.setSQLQuery(sqlMgr.getSql("updateClientComplaint2").trim());
                command.setparams(updateClientComplaint2Parameters);
                queryResult = command.executeUpdate();
                try {
                    Thread.sleep(100);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
                connection.rollback();
                return null;
            } catch (Exception ex) {
                logger.error(ex.getMessage());
                connection.rollback();
                return null;
            } finally {
                connection.commit();
                connection.close();
            }
        }

        if (queryResult > 0) {
            return issueId;
        } else {
            return null;
        }
    }

    public String clientComplaintExtractingOrderWithoutFiles(HttpServletRequest request, String managerId, String employeeId, String employeeName, WebBusinessObject persistentUser) throws NoUserInSessionException, SQLException {
//        WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");
        SequenceMgr sequenceMgr = SequenceMgr.getInstance();
        sequenceMgr.updateSequence();

        String businessID = sequenceMgr.getSequence();
        String servLevel = "0";
        String depCode = null;
        String comment = request.getParameter("comments");
//        String documentTitle = request.getParameter("documentTitle");
        String issueId = (String) request.getAttribute("issueId");
//        String description = request.getParameter("description");
//        String documentType = request.getParameter("fileExtension");
        String ticketType = "10";
//        WebBusinessObject fileDescriptor = FileMgr.getInstance().getObjectFromCash(documentType);
//        String metaType = (String) fileDescriptor.getAttribute("metaType");

        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new java.util.Date());

        Vector clientCompliantParameters = new Vector();
        Vector distributionListParameters = new Vector();
//        Vector issueDocumentParameters = new Vector();
//        Vector issueDocumentDataParameters = new Vector();
        Vector getCompStatusByUserParameters = new Vector();
        Vector saveCompStatusParameters = new Vector();
        Vector saveCompStatusParameters2 = new Vector();
        Vector saveDistributionListParameters2 = new Vector();
        Vector updateUserTicketsCountParameters = new Vector();
        Vector updateClientComplaint2Parameters = new Vector();

        command = new SQLCommandBean();
        int queryResult = -1000;

//        String documentId = UniqueIDGen.getNextID();
        String clientComplaintId = UniqueIDGen.getNextID();

        if (managerId != null && employeeId != null) {
            // project info
            ProjectMgr projectMgr = ProjectMgr.getInstance();
            WebBusinessObject wboProject;
            Vector projectVector;
            try {
                projectVector = projectMgr.getOnArbitraryKey(managerId, "key5");
                if (projectVector.size() > 0) {
                    wboProject = (WebBusinessObject) projectVector.get(0);
                    servLevel = (String) wboProject.getAttribute("optionTwo");
                    depCode = (String) wboProject.getAttribute("eqNO");
                }
            } catch (Exception ex) {
                logger.error(ex);
            }

            // setup client complimet data
            clientCompliantParameters.addElement(new StringValue(clientComplaintId));
            clientCompliantParameters.addElement(new StringValue(issueId));
            clientCompliantParameters.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
            clientCompliantParameters.addElement(new StringValue("2"));
            clientCompliantParameters.addElement(new StringValue(businessID));
            clientCompliantParameters.addElement(new StringValue(servLevel));
            clientCompliantParameters.addElement(new StringValue(ticketType));
            clientCompliantParameters.addElement(new StringValue(depCode));
            clientCompliantParameters.addElement(new StringValue((String) persistentUser.getAttribute("userName")));
            clientCompliantParameters.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
            clientCompliantParameters.addElement(new StringValue("UL"));

            // setup distribution list data
            distributionListParameters.addElement(new StringValue(clientComplaintId));
            distributionListParameters.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
            distributionListParameters.addElement(new StringValue(managerId));
            distributionListParameters.addElement(new StringValue("1"));
            distributionListParameters.addElement(new StringValue("0"));
            distributionListParameters.addElement(new StringValue("0"));
            distributionListParameters.addElement(new StringValue((String) request.getParameter("comment")));
            distributionListParameters.addElement(new StringValue(UniqueIDGen.getNextID()));
            distributionListParameters.addElement(new StringValue((String) request.getParameter("subject")));
            distributionListParameters.addElement(new StringValue(" "));

            // setup document info.
//            issueDocumentParameters.addElement(new StringValue(documentId));
//            issueDocumentParameters.addElement(new StringValue(documentTitle));
//            issueDocumentParameters.addElement(new StringValue(clientComplaintId));
//            issueDocumentParameters.addElement(new StringValue("client_complaint"));
//            issueDocumentParameters.addElement(new StringValue(description));
//            issueDocumentParameters.addElement(new TimestampValue(getTimestamp(request.getParameter("documentDate"))));
//            issueDocumentParameters.addElement(new StringValue(user.getAttribute("userId").toString()));
//            issueDocumentParameters.addElement(new StringValue(user.getAttribute("userName").toString()));
//            issueDocumentParameters.addElement(new StringValue(metaType));
//            issueDocumentParameters.addElement(new StringValue(documentType));
//            issueDocumentParameters.addElement(new StringValue(request.getParameter("configType")));
//            issueDocumentParameters.addElement(new StringValue(request.getParameter("")));
//            issueDocumentParameters.addElement(new StringValue(request.getParameter("")));
//            issueDocumentParameters.addElement(new StringValue(request.getParameter("")));
            // setup document data info.
//            issueDocumentDataParameters.addElement(new StringValue(documentId));
//            issueDocumentDataParameters.addElement(new ImageValue(request.getFile("file1")));
            getCompStatusByUserParameters.addElement(new StringValue(clientComplaintId));
            updateUserTicketsCountParameters.addElement(new StringValue(employeeId));

            String issueStatusId = UniqueIDGen.getNextID();
            saveCompStatusParameters.addElement(new StringValue(issueStatusId));
            saveCompStatusParameters.addElement(new StringValue("2"));
            saveCompStatusParameters.addElement(new StringValue("UL"));
            saveCompStatusParameters.addElement(new StringValue("UL"));
            saveCompStatusParameters.addElement(new StringValue("0"));
            saveCompStatusParameters.addElement(new StringValue("UL"));
            saveCompStatusParameters.addElement(new StringValue("UL"));
            saveCompStatusParameters.addElement(new StringValue("UL"));
            saveCompStatusParameters.addElement(new StringValue(clientComplaintId));
            saveCompStatusParameters.addElement(new StringValue("client_complaint"));
            saveCompStatusParameters.addElement(new StringValue(issueId));
            saveCompStatusParameters.addElement(new StringValue((String) persistentUser.getAttribute("userId")));

            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }
            String issueStatusId2 = UniqueIDGen.getNextID();
            saveCompStatusParameters2.addElement(new StringValue(issueStatusId2));
            saveCompStatusParameters2.addElement(new StringValue("4"));
            saveCompStatusParameters2.addElement(new StringValue("UL"));
            saveCompStatusParameters2.addElement(new StringValue("UL"));
            saveCompStatusParameters2.addElement(new StringValue("0"));
            saveCompStatusParameters2.addElement(new StringValue("UL"));
            saveCompStatusParameters2.addElement(new StringValue("UL"));
            saveCompStatusParameters2.addElement(new StringValue("UL"));
            saveCompStatusParameters2.addElement(new StringValue(clientComplaintId));
            saveCompStatusParameters2.addElement(new StringValue("client_complaint"));
            saveCompStatusParameters2.addElement(new StringValue(issueId));
            saveCompStatusParameters2.addElement(new StringValue(managerId));

            String sysId = UniqueIDGen.getNextID();
            saveDistributionListParameters2.addElement(new StringValue(clientComplaintId));
            saveDistributionListParameters2.addElement(new StringValue(managerId));
            saveDistributionListParameters2.addElement(new StringValue(employeeId));
            saveDistributionListParameters2.addElement(new StringValue("1"));
            saveDistributionListParameters2.addElement(new StringValue("0"));
            saveDistributionListParameters2.addElement(new StringValue("0"));
            saveDistributionListParameters2.addElement(new StringValue((String) request.getParameter("comment")));
            saveDistributionListParameters2.addElement(new StringValue(sysId));
            saveDistributionListParameters2.addElement(new StringValue((String) request.getParameter("subject")));
            saveDistributionListParameters2.addElement(new StringValue((String) request.getParameter("notes")));

            updateClientComplaint2Parameters.addElement(new StringValue("4"));
            updateClientComplaint2Parameters.addElement(new StringValue(employeeId));
            updateClientComplaint2Parameters.addElement(new StringValue(employeeName));
            updateClientComplaint2Parameters.addElement(new StringValue(clientComplaintId));

            Connection connection = null;
            try {
                connection = dataSource.getConnection();
                connection.setAutoCommit(false);
                command.setConnection(connection);

                // saving client complaint data
                command.setSQLQuery(sqlMgr.getSql("insertClientComplaint").trim());
                command.setparams(clientCompliantParameters);
                queryResult = command.executeUpdate();
                if (queryResult < 0) {
                    connection.rollback();
                    return null;
                }
                try {
                    Thread.sleep(200);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }

                // saving distriution list data
                command.setSQLQuery(sqlMgr.getSql("saveDistributionList").trim());
                command.setparams(distributionListParameters);
                queryResult = command.executeUpdate();
                if (queryResult < 0) {
                    connection.rollback();
                    return null;
                }
                try {
                    Thread.sleep(200);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }

//                command.setSQLQuery(sqlMgr.getSql("insertIssueDocument").trim());
//                command.setparams(issueDocumentParameters);
//                queryResult = command.executeUpdate();
//                if (queryResult < 0) {
//                    connection.rollback();
//                    return null;
//                }
//                try {
//                    Thread.sleep(200);
//                } catch (InterruptedException ex) {
//                    logger.error(ex.getMessage());
//                }
                // add alert type from attach file
//                boolean saved = AlertMgr.getInstance().saveObject(clientComplaintId, CRMConstants.ALERT_TYPE_ID_ATTACH_FILE, user.getAttribute("userId").toString(), connection);
//                if (!saved) {
//                    connection.rollback();
//                    return null;
//                }
//                try {
//                    Thread.sleep(200);
//                } catch (InterruptedException ex) {
//                    logger.error(ex.getMessage());
//                }
//                command.setSQLQuery(sqlMgr.getSql("insertIssueDocumentData").trim());
//                command.setparams(issueDocumentDataParameters);
//                queryResult = command.executeUpdate();
//                if (queryResult < 0) {
//                    connection.rollback();
//                    return null;
//                }
//                try {
//                    Thread.sleep(200);
//                } catch (InterruptedException ex) {
//                    logger.error(ex.getMessage());
//                }
                // create new issue status
                command.setSQLQuery(sqlMgr.getSql("saveCompStatus3").trim());
                command.setparams(saveCompStatusParameters);
                queryResult = command.executeUpdate();
                if (queryResult < 0) {
                    connection.rollback();
                    return null;
                }
                try {
                    Thread.sleep(200);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }

                // create new issue status
                command.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
                command.setparams(saveCompStatusParameters2);
                queryResult = command.executeUpdate();
                if (queryResult < 0) {
                    connection.rollback();
                    return null;
                }
                try {
                    Thread.sleep(200);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }

                command.setSQLQuery(sqlMgr.getSql("saveDistributionList").trim());
                command.setparams(saveDistributionListParameters2);
                queryResult = command.executeUpdate();
                if (queryResult < 0) {
                    connection.rollback();
                    return null;
                }
                try {
                    Thread.sleep(200);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }

                command.setSQLQuery(sqlMgr.getSql("updateUserTicketsCount").trim());
                command.setparams(updateUserTicketsCountParameters);
                queryResult = command.executeUpdate();
                if (queryResult < 0) {
                    connection.rollback();
                    return null;
                }
                try {
                    Thread.sleep(100);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }

                command.setSQLQuery(sqlMgr.getSql("updateClientComplaint2").trim());
                command.setparams(updateClientComplaint2Parameters);
                queryResult = command.executeUpdate();
                try {
                    Thread.sleep(100);
                } catch (InterruptedException ex) {
                    logger.error(ex.getMessage());
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
                connection.rollback();
                return null;
            } catch (Exception ex) {
                logger.error(ex.getMessage());
                connection.rollback();
                return null;
            } finally {
                connection.commit();
                connection.close();
            }
        }

        if (queryResult > 0) {
            return issueId;
        } else {
            return null;
        }
    }

    public boolean sendFile(MultipartRequest request, HttpSession session, String senderId, String recipientId, String businessId) throws SQLException {
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");

        String createdById = (String) loggedUser.getAttribute("userId");
        String createdByName = (String) loggedUser.getAttribute("userName");
        String issueId = request.getParameter("issueId");
        String ticketType = request.getParameter("ticketType");
        String comment = request.getParameter("comment");
        String subject = request.getParameter("subject");
        String notes = request.getParameter("notes");
        String documentTitle = request.getParameter("documentTitle");
        String description = request.getParameter("description");
        String documentType = request.getParameter("configType");
        File file = request.getFile("file1");
        Timestamp documentDate = getTimestamp(request.getParameter("documentDate"));
        WebBusinessObject fileDescriptor = FileMgr.getInstance().getObjectFromCash(documentType);
        String metaType = (String) fileDescriptor.getAttribute("metaType");
        String configType = request.getParameter("configType");

        String clientComplaintId = createMailInBox(senderId, recipientId, issueId, ticketType, businessId, comment, subject, notes);
        if (clientComplaintId != null) {
            return documentMgr.saveClientComplaintDocument(documentTitle, clientComplaintId, description, documentDate, metaType, documentType, createdById, createdByName, configType, file);
        }

        return false;
    }

    /**
     *
     * @param senderId
     * @param recipientId
     * @param issueId
     * @param ticketType
     * @param businessId
     * @param comment
     * @param subject
     * @param notes
     * @return if all things are ok return client complaint id and null
     * otherwise.
     * @throws SQLException
     */
    public synchronized String createMailInBox(String senderId, String recipientId, String issueId, String ticketType, String businessId, String comment, String subject, String notes) throws SQLException {
        SequenceMgr sequenceMgr = SequenceMgr.getInstance();
        sequenceMgr.updateSequence();

        if (businessId == null) {
            businessId = sequenceMgr.getSequence();
        }
        String clientComplaintId;
        String managerId = null;
        String departmentCode;
        String servelLevel = null;
        boolean isEmployeeIsManager = false;
        boolean isEmployeeHasManager = false;
        int result;

        Vector params;

        List<String> queries = new ArrayList<String>();
        List<Vector> parameters = new ArrayList<Vector>();

        command = new SQLCommandBean();

        clientComplaintId = UniqueIDGen.getNextID();

        // employee Info
        UserMgr userMgr = UserMgr.getInstance();
        String recipientName = userMgr.getByKeyColumnValue(recipientId, "key1");
        String senderName = userMgr.getByKeyColumnValue(senderId, "key1");

        // department info
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        departmentCode = projectMgr.getProjectCodeByManager(recipientId);
        if (departmentCode != null) {
            isEmployeeIsManager = true;
        }
        if (!isEmployeeIsManager) {
            WebBusinessObject departmentInfo = projectMgr.getManagerByEmployee(recipientId);
            if ((departmentInfo != null) && (departmentInfo.getAttribute("optionOne") != null) && (departmentInfo.getAttribute("eqNO") != null)) {
                managerId = (String) departmentInfo.getAttribute("optionOne");
                departmentCode = (String) departmentInfo.getAttribute("eqNO");
                servelLevel = (String) departmentInfo.getAttribute("optionTwo");
                isEmployeeHasManager = true;
            }
        }

        // setup client complimet data
        params = new Vector();
        params.addElement(new StringValue(clientComplaintId));
        params.addElement(new StringValue(issueId));
        params.addElement(new StringValue(senderId));
        params.addElement(new StringValue("2"));
        params.addElement(new StringValue(businessId));
        params.addElement(new StringValue(servelLevel));
        params.addElement(new StringValue(ticketType));
        params.addElement(new StringValue(departmentCode));
        params.addElement(new StringValue((isEmployeeHasManager) ? senderName : recipientName));
        params.addElement(new StringValue((isEmployeeHasManager) ? senderId : recipientId));
        params.addElement(new StringValue("UL"));
        parameters.add(params);
        queries.add(sqlMgr.getSql("insertClientComplaint").trim());

        // setup distribution list data
        params = new Vector();
        params.addElement(new StringValue(clientComplaintId));
        params.addElement(new StringValue(senderId));
        params.addElement(new StringValue((isEmployeeHasManager) ? managerId : recipientId));
        params.addElement(new StringValue("1"));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue(comment));
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(subject));
        params.addElement(new StringValue(notes));
        parameters.add(params);
        queries.add(sqlMgr.getSql("saveDistributionList").trim());

        params = new Vector();
        params.addElement(new StringValue(senderId));
        parameters.add(params);
        queries.add(sqlMgr.getSql("updateUserTicketsCount").trim());

        params = new Vector();
        String issueStatusId = UniqueIDGen.getNextID();
        params.addElement(new StringValue(issueStatusId));
        params.addElement(new StringValue("2"));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue(clientComplaintId));
        params.addElement(new StringValue("client_complaint"));
        params.addElement(new StringValue(issueId));
        params.addElement(new StringValue(senderId));
        parameters.add(params);
        queries.add(sqlMgr.getSql((isEmployeeHasManager) ? "saveCompStatus3" : "saveCompStatus").trim());

        if (isEmployeeHasManager) {
            params = new Vector();
            String sysId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(clientComplaintId));
            params.addElement(new StringValue(managerId));
            params.addElement(new StringValue(recipientId));
            params.addElement(new StringValue("1"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue(comment));
            params.addElement(new StringValue(sysId));
            params.addElement(new StringValue(subject));
            params.addElement(new StringValue(notes));
            parameters.add(params);
            queries.add(sqlMgr.getSql("saveDistributionList").trim());

            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }
            params = new Vector();
            String issueStatusId2 = UniqueIDGen.getNextID();
            params.addElement(new StringValue(issueStatusId2));
            params.addElement(new StringValue("4"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue(clientComplaintId));
            params.addElement(new StringValue("client_complaint"));
            params.addElement(new StringValue(issueId));
            params.addElement(new StringValue(managerId));
            parameters.add(params);
            queries.add(sqlMgr.getSql("saveCompStatus").trim());

            params = new Vector();
            params.addElement(new StringValue("4"));
            params.addElement(new StringValue(recipientId));
            params.addElement(new StringValue(recipientName));
            params.addElement(new StringValue(clientComplaintId));
            parameters.add(params);
            queries.add(sqlMgr.getSql("updateClientComplaint2").trim());
        }

        if (isEmployeeIsManager || isEmployeeHasManager) {
            Connection connection = null;
            try {
                connection = dataSource.getConnection();
                connection.setAutoCommit(false);
                command.setConnection(connection);

                // start execution
                for (int i = 0; i < parameters.size(); i++) {
                    command.setSQLQuery(queries.get(i));
                    command.setparams(parameters.get(i));
                    result = command.executeUpdate();
                    if (result < 0) {
                        connection.rollback();
                        return null;
                    }
                    try {
                        Thread.sleep(200);
                    } catch (InterruptedException ex) {
                        logger.error(ex.getMessage());
                    }
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
                connection.rollback();
                return null;
            } finally {
                connection.commit();
                connection.close();
            }
        } else {
            return null;
        }

        return clientComplaintId;
    }

    public synchronized String createMailInBox(String employeeId, String issueId, String ticketType, String businessId, String comment, String subject, String notes, WebBusinessObject loggedUser) throws NoUserInSessionException, SQLException {
        SequenceMgr sequenceMgr = SequenceMgr.getInstance();
        sequenceMgr.updateSequence();

        if (businessId == null) {
            businessId = sequenceMgr.getSequence();
        }
        String clientComplaintId = "";
        String managerId = null;
        String departmentCode;
        String servelLevel = null;
        boolean isEmployeeIsManager = false;
        boolean isEmployeeHasManager = false;

        Vector params;

        List<String> queries = new ArrayList<String>();
        List<Vector> parameters = new ArrayList<Vector>();

        command = new SQLCommandBean();
        int queryResult = -1000;

        clientComplaintId = UniqueIDGen.getNextID();

        // employee Info
        UserMgr userMgr = UserMgr.getInstance();
        String employeeName = userMgr.getByKeyColumnValue(employeeId, "key1");

        // department info
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        departmentCode = projectMgr.getProjectCodeByManager(employeeId);
        if (departmentCode != null) {
            isEmployeeIsManager = true;
        }
        if (!isEmployeeIsManager) {
            WebBusinessObject departmentInfo = projectMgr.getManagerByEmployee(employeeId);
            if ((departmentInfo != null) && (departmentInfo.getAttribute("optionOne") != null) && (departmentInfo.getAttribute("eqNO") != null)) {
                managerId = (String) departmentInfo.getAttribute("optionOne");
                departmentCode = (String) departmentInfo.getAttribute("eqNO");
                servelLevel = (String) departmentInfo.getAttribute("optionTwo");
                isEmployeeHasManager = true;
            }
        }

        // setup client complimet data
        params = new Vector();
        params.addElement(new StringValue(clientComplaintId));
        params.addElement(new StringValue(issueId));
        params.addElement(new StringValue((String) loggedUser.getAttribute("userId")));
        params.addElement(new StringValue("2"));
        params.addElement(new StringValue(businessId));
        params.addElement(new StringValue(servelLevel));
        params.addElement(new StringValue(ticketType));
        params.addElement(new StringValue(departmentCode));
        params.addElement(new StringValue((isEmployeeHasManager) ? (String) loggedUser.getAttribute("userName") : employeeName));
        params.addElement(new StringValue((isEmployeeHasManager) ? (String) loggedUser.getAttribute("userId") : employeeId));
        params.addElement(new StringValue("UL"));
        parameters.add(params);
        queries.add(sqlMgr.getSql("insertClientComplaint").trim());

        try {
                Thread.sleep(500);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }
        // setup distribution list data
        params = new Vector();
        params.addElement(new StringValue(clientComplaintId));
        params.addElement(new StringValue((String) loggedUser.getAttribute("userId")));
        params.addElement(new StringValue((isEmployeeHasManager) ? managerId : employeeId));
        params.addElement(new StringValue("1"));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue(comment != null ? comment : "UL"));//comment
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(subject));
        params.addElement(new StringValue(" "));
        parameters.add(params);
        queries.add(sqlMgr.getSql("saveDistributionList").trim());

        try {
                Thread.sleep(500);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }
        
        params = new Vector();
        params.addElement(new StringValue(employeeId));
        parameters.add(params);
        queries.add(sqlMgr.getSql("updateUserTicketsCount").trim());

        try {
                Thread.sleep(500);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }
        
        params = new Vector();
        String issueStatusId = UniqueIDGen.getNextID();
        params.addElement(new StringValue(issueStatusId));
        params.addElement(new StringValue("2"));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue(clientComplaintId));
        params.addElement(new StringValue("client_complaint"));
        params.addElement(new StringValue(issueId));
        params.addElement(new StringValue((String) loggedUser.getAttribute("userId")));
        parameters.add(params);
        queries.add(sqlMgr.getSql((isEmployeeHasManager) ? "saveCompStatus3" : "saveCompStatus").trim());

        try {
                Thread.sleep(500);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }
        
        if (isEmployeeHasManager) {
            params = new Vector();
            String sysId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(clientComplaintId));
            params.addElement(new StringValue(managerId));
            params.addElement(new StringValue(employeeId));
            params.addElement(new StringValue("1"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue(comment != null ? comment : "UL"));//comment
            params.addElement(new StringValue(sysId));
            params.addElement(new StringValue(subject));
            params.addElement(new StringValue(notes));
            parameters.add(params);
            queries.add(sqlMgr.getSql("saveDistributionList").trim());

            try {
                Thread.sleep(500);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }
            params = new Vector();
            String issueStatusId2 = UniqueIDGen.getNextID();
            params.addElement(new StringValue(issueStatusId2));
            params.addElement(new StringValue("4"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue(clientComplaintId));
            params.addElement(new StringValue("client_complaint"));
            params.addElement(new StringValue(issueId));
            params.addElement(new StringValue(managerId));
            parameters.add(params);
            queries.add(sqlMgr.getSql("saveCompStatus").trim());

            try {
                Thread.sleep(500);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }
            
            params = new Vector();
            params.addElement(new StringValue("4"));
            params.addElement(new StringValue(employeeId));
            params.addElement(new StringValue(employeeName));
            params.addElement(new StringValue(clientComplaintId));
            parameters.add(params);
            queries.add(sqlMgr.getSql("updateClientComplaint2").trim());
        
            try {
                Thread.sleep(500);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }
        
        }

        if (isEmployeeIsManager || isEmployeeHasManager) {
            Connection connection = null;
            try {
                connection = dataSource.getConnection();
                connection.setAutoCommit(false);
                command.setConnection(connection);

                // start execution
                for (int i = 0; i < parameters.size(); i++) {
                    command.setSQLQuery(queries.get(i));
                    command.setparams(parameters.get(i));
                    queryResult = command.executeUpdate();
                    
                    try {
                         Thread.sleep(500);
                        } catch (InterruptedException ex) {
                         logger.error(ex.getMessage());
                        }
                    
                    if (queryResult < 0) {
                        connection.rollback();
                        return null;
                    }
                    try {
                        Thread.sleep(500);
                    } catch (InterruptedException ex) {
                        logger.error(ex.getMessage());
                    }
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
                connection.rollback();
                return null;
            } finally {
                connection.commit();
                connection.close();
            }
        } else {
            return null;
        }

        return clientComplaintId;
    }

    public boolean changeCurrentOwnerToManager(String clientComplaintId, String employeeId) {
        String managerId = employeeId;
        String managerName;
        WebBusinessObject manager = ProjectMgr.getInstance().getManagerByEmployee(employeeId);
        if (manager != null) {
            managerId = (String) manager.getAttribute("optionOne");
        }

        managerName = (String) UserMgr.getInstance().getOnSingleKey(managerId).getAttribute("userName");

        return changeCurrentOwner(clientComplaintId, managerId, managerName);
    }

    public boolean changeCurrentOwner(String clientComplaintId, String userId, String userName) {
        command = new SQLCommandBean();
        Connection connection = null;
        Vector updateCurrentOwnerClientComplaintParameters = new Vector();
        int queryResult = -1000;

        updateCurrentOwnerClientComplaintParameters = new Vector();
        updateCurrentOwnerClientComplaintParameters.addElement(new StringValue(userId));
        updateCurrentOwnerClientComplaintParameters.addElement(new StringValue(userName));
        updateCurrentOwnerClientComplaintParameters.addElement(new StringValue(clientComplaintId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("updateCurrentOwner").trim());
            command.setparams(updateCurrentOwnerClientComplaintParameters);
            queryResult = command.executeUpdate();
        } catch (SQLException ex) {
            logger.error(ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }
        return (queryResult > 0);
    }

    public boolean updateCurrentStatus(String clientComplaintId, String statusCode) throws SQLException {
        SQLCommandBean command = new SQLCommandBean();
        Vector parameters = new Vector();
        int queryResult = -1000;

        parameters.addElement(new StringValue(statusCode));
        parameters.addElement(new StringValue(clientComplaintId));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("updateCurrentStatus").trim());
            command.setparams(parameters);
            queryResult = command.executeUpdate();
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        } finally {
            connection.close();
        }

        if (queryResult > 0) {
            return true;
        }
        return false;
    }

    public int getNumberOfAppropriations(String issueId) throws SQLException {
        Vector parameters = new Vector();
        Vector<Row> result;

        parameters.addElement(new StringValue(issueId));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            command = new SQLCommandBean();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getNumberOfAppropriations").trim());
            command.setparams(parameters);
            result = command.executeQuery();

            for (Row row : result) {
                return row.getBigDecimal("TOTAL").intValue();
            }
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error(ex.getMessage());
        } catch (NoSuchColumnException ex) {
            logger.error(ex.getMessage());
        } catch (UnsupportedConversionException ex) {
            logger.error(ex.getMessage());
        } finally {
            connection.close();
        }

        return 0;
    }

    public WebBusinessObject getClientComplaintByIssueAndType(String issueId, String ticketType) throws SQLException {
        Vector parameters = new Vector();
        Vector<Row> result;

        parameters.addElement(new StringValue(issueId));
        parameters.addElement(new StringValue(ticketType));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            command = new SQLCommandBean();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getClientComplaintByIssueAndType").trim());
            command.setparams(parameters);
            result = command.executeQuery();

            for (Row row : result) {
                return fabricateBusObj(row);
            }
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (UnsupportedTypeException ex) {
            logger.error(ex.getMessage());
        } finally {
            connection.close();
        }

        return null;
    }

    public boolean redistributionCompliant(String clientComplaintId, String issueId, String employeeId, String businessId, String comment, String subject, String notes, WebBusinessObject loggedUser) {
        IssueStatusMgr statusMgr = IssueStatusMgr.getInstance();
        try {
            // update current clomplaint status to close
            updateCurrentStatus(clientComplaintId, CRMConstants.CLIENT_COMPLAINT_STATUS_CLOSED);

            // close current clomplaint status in issue status table
            if (!statusMgr.isStatusExist(clientComplaintId, CRMConstants.OBJECT_TYPE_CLIENT_COMPLAINT, CRMConstants.CLIENT_COMPLAINT_STATUS_CLOSED)) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                WebBusinessObject wbo = new WebBusinessObject();
                wbo.setAttribute("businessObjectId", clientComplaintId);
                wbo.setAttribute("objectType", CRMConstants.OBJECT_TYPE_CLIENT_COMPLAINT);
                wbo.setAttribute("statusCode", CRMConstants.CLIENT_COMPLAINT_STATUS_CLOSED);
                wbo.setAttribute("date", sdf.format(Calendar.getInstance().getTime()));
                wbo.setAttribute("parentId", "UL");
                wbo.setAttribute("issueTitle", "UL");
                wbo.setAttribute("statusNote", CRMConstants.CLIENT_COMPLAINT_STATUS_FINISHED_NOTE);
                wbo.setAttribute("cuseDescription", "UL");
                wbo.setAttribute("actionTaken", CRMConstants.CLIENT_COMPLAINT_STATUS_FINISHED_NOTE);
                wbo.setAttribute("preventionTaken", "UL");
                statusMgr.changeStatus(wbo, loggedUser, null);
            }

            // start distribution
            String ticketType = getByKeyColumnValue(clientComplaintId, "key4");
            createMailInBox(employeeId, issueId, ticketType, businessId, comment, subject, notes, loggedUser);
        } catch (SQLException ex) {
            logger.error(ex);
            return false;
        } catch (NoUserInSessionException ex) {
            logger.error(ex);
            return false;
        }

        return true;
    }

    private Timestamp getTimestamp(String date) {
        // doc date
        DateParser dateParser = new DateParser();
        String[] tempDate = date.split(" ");
        java.sql.Date sqlDate = dateParser.formatSqlDate(tempDate[0]);
        if (tempDate.length > 1) {
            String[] tempTime = tempDate[1].split(":");
            if (tempTime.length > 0) {
                sqlDate.setTime(sqlDate.getTime() + (Integer.parseInt(tempTime[0]) * 60 * 60 * 1000) + (Integer.parseInt(tempTime[1]) * 60 * 1000));
            }
        }
        return new Timestamp(sqlDate.getTime());
    }

    public String getLastClientComplaintForIssue(String issueId) {
        command = new SQLCommandBean();
        Vector parameters = new Vector();
        Connection connection = null;
        Vector result;

        parameters.add(new StringValue(issueId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getLastClientComplaintForIssue").trim());
            command.setparams(parameters);

            result = command.executeQuery();

            if (!result.isEmpty()) {
                Enumeration e = result.elements();
                while (e.hasMoreElements()) {
                    try {
                        Row row = (Row) e.nextElement();
                        return row.getString("CLIENT_COMPLAINTS_ID");
                    } catch (NoSuchColumnException se) {
                        logger.error(se.getMessage());
                    }
                }
            }

        } catch (UnsupportedTypeException se) {
            logger.error(se.getMessage());
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        return null;
    }

    public boolean addClientComplaintProject(String projectId, String[] clientComplaintId, HttpSession session) {
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        for (int i = 0; i < clientComplaintId.length; i++) {
            try {
                params = new Vector();
                params.addElement(new StringValue(projectId));
                params.addElement(new StringValue(clientComplaintId[i]));
                params.addElement(new StringValue((String) loggedUser.getAttribute("userId")));

                beginTransaction();
                forInsert.setConnection(transConnection);
                forInsert.setSQLQuery(getQuery("insertClientComplaintProject").trim());
                forInsert.setparams(params);

                queryResult = forInsert.executeUpdate();

                if (queryResult < 0) {
                    transConnection.rollback();
                    return false;
                }
            } catch (SQLException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

        }
        try {
            Thread.sleep(50);
        } catch (InterruptedException ex) {
            Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            endTransaction();
        }

        return (queryResult > 0);
    }

    public ArrayList getProjectsUnderProject(String folderID) {

        Vector queryResult = new Vector();
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        ArrayList<WebBusinessObject> projects = new ArrayList<WebBusinessObject>();

        Vector parameters = new Vector();
        parameters.addElement(new StringValue(folderID));
        try {
            String query = getQuery("getClientComplaintByFolderCode").trim();
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(query);
            queryResult = command.executeQuery();
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
                logger.error("***** " + ex.getMessage());
            }
        }
        WebBusinessObject wbo;
        Row row;
        if (!queryResult.isEmpty()) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                wbo = fabricateBusObj(row);
                projects.add(wbo);
            }
        }

        return projects;
    }
    
    public List<WebBusinessObject> getEngEmployeeProduction(java.sql.Date beginDate, java.sql.Date endDate, String type) {
        if(type.equals("6")){
            type = "طلب تسليم";
        } else {
            type = "Extracting";
        }
        
        String theQuery = getQuery("getEngEmployeeProduction").trim();
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
        Vector<Row> result;
        Vector parameters = new Vector();

        parameters.addElement(new StringValue(type));
        parameters.addElement(new DateValue(beginDate));
        parameters.addElement(new DateValue(endDate));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(theQuery);
            command.setparams(parameters);
            result = command.executeQuery();
            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                try {
                    if (row.getString("TOTAL") != null) {
                        wbo.setAttribute("total", row.getString("TOTAL"));
                    }
                    if (row.getString("USER_NAME") != null) {
                        wbo.setAttribute("userName", row.getString("USER_NAME"));
                    }
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                }
                data.add(wbo);
            }
        } catch (SQLException ex) {
            logger.error(ex);
        } catch (UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }
        return data;
    }
    
    public List<WebBusinessObject> getNewClientComplaintsStatusRatio(java.sql.Date beginDate, java.sql.Date endDate) {
        String theQuery = getQuery("getNewClientComplaintsStatusRatio").trim();
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
        Vector<Row> result;
        Vector parameters = new Vector();

        parameters.addElement(new DateValue(beginDate));
        parameters.addElement(new DateValue(endDate));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(theQuery);
            command.setparams(parameters);
            result = command.executeQuery();
            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                try {
                    if (row.getString("TOTAL") != null) {
                        wbo.setAttribute("total", row.getString("TOTAL"));
                    }
                    if (row.getString("STATUS_NAME_AR") != null) {
                        wbo.setAttribute("statusNameAr", row.getString("STATUS_NAME_AR"));
                    }
                    if (row.getString("STATUS_NAME_EN") != null) {
                        wbo.setAttribute("statusNameEn", row.getString("STATUS_NAME_EN"));
                    }
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                }
                data.add(wbo);
            }
        } catch (SQLException ex) {
            logger.error(ex);
        } catch (UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }
        return data;
    }
     public boolean updateBusinessCompID(String clientComplaintId, String newCode) throws SQLException {
        SQLCommandBean updateCommand = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        int queryResult = -1000;
        parameters.addElement(new StringValue(newCode));
        parameters.addElement(new StringValue(clientComplaintId));
        try {
            connection = dataSource.getConnection();
            updateCommand.setConnection(connection);
            updateCommand.setSQLQuery(getQuery("updateBusinessCompID").trim());
            updateCommand.setparams(parameters);
            queryResult = updateCommand.executeUpdate();
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        } finally {
            if(connection != null) {
                connection.close();
            }
        }
        return queryResult > 0;
    }
    public boolean updateBusinessCompCmnt(String clientComplaintId, String newCode) throws SQLException {
        SQLCommandBean updateCommand = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        int queryResult = -1000;
        parameters.addElement(new StringValue(newCode));
        parameters.addElement(new StringValue(clientComplaintId));
        try {
            connection = dataSource.getConnection();
            updateCommand.setConnection(connection);
            updateCommand.setSQLQuery(getQuery("updateBusinessCompComment").trim());
            updateCommand.setparams(parameters);
            queryResult = updateCommand.executeUpdate();
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        } finally {
            if(connection != null) {
                connection.close();
            }
        }
        return queryResult > 0;
    }
            
    public ArrayList<WebBusinessObject> getAllQCNotCompletedComplaints() {
        String theQuery = getQuery("getAllQCNotCompletedComplaints").trim();
        SQLCommandBean selectCommand = new SQLCommandBean();
        Connection connection = null;
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        ArrayList<Row> result;
        try {
            connection = dataSource.getConnection();
            selectCommand.setConnection(connection);
            selectCommand.setSQLQuery(theQuery);
            result = new ArrayList<>(selectCommand.executeQuery());
            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                try {
                    if (row.getString("ISSUE_STATUS") != null) {
                        wbo.setAttribute("issueStatus", row.getString("ISSUE_STATUS"));
                    }
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                }
                data.add(wbo);
            }
        } catch (SQLException | UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }
        return data;
    }
    
    public String saveClientComplaintWithoutDistribute(WebBusinessObject wbo) throws NoUserInSessionException, SQLException {
        String servLevel = "0";
        String depCode = null;
        String ownerComplaint = (String) wbo.getAttribute("userId");
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        WebBusinessObject wboProj;
        Vector projectV;
        try {
            projectV = projectMgr.getOnArbitraryKey(ownerComplaint, "key5");
            if (projectV.size() > 0) {
                wboProj = (WebBusinessObject) projectV.get(0);
                servLevel = (String) wboProj.getAttribute("optionTwo");
                depCode = (String) wboProj.getAttribute("eqNO");
            } else {
                WebBusinessObject managerWbo = projectMgr.getManagerByEmployee(ownerComplaint);
                if (managerWbo != null) {
                    depCode = (String) managerWbo.getAttribute("eqNO");
                }
            }
        } catch (Exception ex) {
            Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (wbo.getAttribute("orderUrgency") != null) {
            servLevel = (String) wbo.getAttribute("orderUrgency");
        }

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult;

        String issueId = (String) wbo.getAttribute("issueId");
        IssueMgr issueMgr = IssueMgr.getInstance();
        WebBusinessObject issueWbo = (WebBusinessObject) issueMgr.getOnSingleKey(issueId);

        String clientCompId = UniqueIDGen.getNextID();
        params.addElement(new StringValue(clientCompId));
        params.addElement(new StringValue((String) wbo.getAttribute("issueId")));
        params.addElement(new StringValue((String) wbo.getAttribute("userId")));
        params.addElement(new StringValue("2"));
        params.addElement(new StringValue((String) issueWbo.getAttribute("businessID")));
        params.addElement(new StringValue(servLevel));
        params.addElement(new StringValue((String) wbo.getAttribute("ticketType")));
        params.addElement(new StringValue(depCode));
        params.addElement(new StringValue((String) wbo.getAttribute("userName")));
        params.addElement(new StringValue((String) wbo.getAttribute("userId")));
        params.addElement(new StringValue((String) wbo.getAttribute("category")));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertClientComplaint").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }
            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            params = new Vector();

            String issueStatusId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(issueStatusId));
            // 1 mean received from Issue // 2 mean sent from complaint //
            params.addElement(new StringValue("2"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue(clientCompId));
            params.addElement(new StringValue("client_complaint"));
            params.addElement(new StringValue((String) wbo.getAttribute("issueId")));
            params.addElement(new StringValue((String) wbo.getAttribute("userId")));
            forInsert.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }
            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            params = new Vector();
            params.addElement(new StringValue("1"));
            forInsert.setSQLQuery(sqlMgr.getSql("updateGenericCount").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }
            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            params = new Vector();
            params.addElement(new StringValue((String) wbo.getAttribute("userId")));
            forInsert.setSQLQuery(sqlMgr.getSql("updateUserTicketsCount").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            transConnection.rollback();
            return null;
        } finally {
            endTransaction();
        }
        return clientCompId;
    }
    
    public boolean distributeComplaint(String clientComplaintID, String emplyeeID, String distributerID, String subject, String comment) throws SQLException {
        SQLCommandBean updateCommand = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        int queryResult = -1000;
        parameters.addElement(new StringValue(clientComplaintID));
        parameters.addElement(new StringValue(distributerID));
        parameters.addElement(new StringValue(emplyeeID));
        parameters.addElement(new StringValue("1"));
        parameters.addElement(new StringValue("0"));
        parameters.addElement(new StringValue("0"));
        parameters.addElement(new StringValue(comment != null ? comment : "UL"));
        parameters.addElement(new StringValue(UniqueIDGen.getNextID()));
        parameters.addElement(new StringValue(subject != null ? subject : "UL"));
        parameters.addElement(new StringValue(" "));
        try {
            connection = dataSource.getConnection();
            updateCommand.setConnection(connection);
            updateCommand.setSQLQuery(sqlMgr.getSql("saveDistributionList").trim());
            updateCommand.setparams(parameters);
            queryResult = updateCommand.executeUpdate();
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        } finally {
            if (connection != null) {
                connection.close();
            }
        }
        return queryResult > 0;
    }
    
    public synchronized String createFutureMailInBox(String senderId, String recipientId, String issueId, String ticketType, String businessId, String comment, String subject, java.sql.Date entryDate) {
        SequenceMgr sequenceMgr = SequenceMgr.getInstance();
        sequenceMgr.updateSequence();
        if (businessId == null) {
            businessId = sequenceMgr.getSequence();
        }
        String clientComplaintId;
        String managerId = null;
        String departmentCode;
        String servelLevel = null;
        boolean isEmployeeIsManager = false;
        boolean isEmployeeHasManager = false;
        int result;

        Vector params;

        List<String> queries = new ArrayList<>();
        List<Vector> parameters = new ArrayList<>();

        command = new SQLCommandBean();

        clientComplaintId = UniqueIDGen.getNextID();

        // employee Info
        UserMgr userMgr = UserMgr.getInstance();
        String recipientName = userMgr.getByKeyColumnValue(recipientId, "key1");
        String senderName = userMgr.getByKeyColumnValue(senderId, "key1");

        // department info
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        departmentCode = projectMgr.getProjectCodeByManager(recipientId);
        if (departmentCode != null) {
            isEmployeeIsManager = true;
        }
        if (!isEmployeeIsManager) {
            WebBusinessObject departmentInfo = projectMgr.getManagerByEmployee(recipientId);
            if ((departmentInfo != null) && (departmentInfo.getAttribute("optionOne") != null) && (departmentInfo.getAttribute("eqNO") != null)) {
                managerId = (String) departmentInfo.getAttribute("optionOne");
                departmentCode = (String) departmentInfo.getAttribute("eqNO");
                servelLevel = (String) departmentInfo.getAttribute("optionTwo");
                isEmployeeHasManager = true;
            }
        }

        // setup client complimet data
        params = new Vector();
        params.addElement(new StringValue(clientComplaintId));
        params.addElement(new StringValue(issueId));
        params.addElement(new StringValue(senderId));
        params.addElement(new StringValue("2"));
        params.addElement(new StringValue(businessId));
        params.addElement(new StringValue(servelLevel));
        params.addElement(new StringValue(ticketType));
        params.addElement(new StringValue(departmentCode));
        params.addElement(new StringValue((isEmployeeHasManager) ? senderName : recipientName));
        params.addElement(new StringValue((isEmployeeHasManager) ? senderId : recipientId));
        params.addElement(new StringValue("UL"));
        parameters.add(params);
        queries.add(sqlMgr.getSql("insertClientComplaint").trim());

        // setup distribution list data
        params = new Vector();
        params.addElement(new StringValue(clientComplaintId));
        params.addElement(new StringValue(senderId));
        params.addElement(new StringValue((isEmployeeHasManager) ? managerId : recipientId));
        params.addElement(new DateValue(entryDate));
        params.addElement(new StringValue("1"));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue(comment));
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(subject));
        params.addElement(new StringValue(comment));
        parameters.add(params);
        queries.add(sqlMgr.getSql("saveFutureDistributionList").trim());

        params = new Vector();
        params.addElement(new StringValue(senderId));
        parameters.add(params);
        queries.add(sqlMgr.getSql("updateUserTicketsCount").trim());

        params = new Vector();
        String issueStatusId = UniqueIDGen.getNextID();
        params.addElement(new StringValue(issueStatusId));
        params.addElement(new StringValue("2"));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue(clientComplaintId));
        params.addElement(new StringValue("client_complaint"));
        params.addElement(new StringValue(issueId));
        params.addElement(new StringValue(senderId));
        parameters.add(params);
        queries.add(sqlMgr.getSql((isEmployeeHasManager) ? "saveCompStatus3" : "saveCompStatus").trim());

        if (isEmployeeHasManager) {
            params = new Vector();
            String sysId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(clientComplaintId));
            params.addElement(new StringValue(managerId));
            params.addElement(new StringValue(recipientId));
            params.addElement(new StringValue("1"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue(comment));
            params.addElement(new StringValue(sysId));
            params.addElement(new StringValue(subject));
            params.addElement(new StringValue(comment));
            parameters.add(params);
            queries.add(sqlMgr.getSql("saveDistributionList").trim());

            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }
            params = new Vector();
            String issueStatusId2 = UniqueIDGen.getNextID();
            params.addElement(new StringValue(issueStatusId2));
            params.addElement(new StringValue("4"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue(clientComplaintId));
            params.addElement(new StringValue("client_complaint"));
            params.addElement(new StringValue(issueId));
            params.addElement(new StringValue(managerId));
            parameters.add(params);
            queries.add(sqlMgr.getSql("saveCompStatus").trim());

            params = new Vector();
            params.addElement(new StringValue("4"));
            params.addElement(new StringValue(recipientId));
            params.addElement(new StringValue(recipientName));
            params.addElement(new StringValue(clientComplaintId));
            parameters.add(params);
            queries.add(sqlMgr.getSql("updateClientComplaint2").trim());
        }
        if (isEmployeeIsManager || isEmployeeHasManager) {
            Connection connection = null;
            try {
                connection = dataSource.getConnection();
                connection.setAutoCommit(false);
                command.setConnection(connection);
                // start execution
                for (int i = 0; i < parameters.size(); i++) {
                    command.setSQLQuery(queries.get(i));
                    command.setparams(parameters.get(i));
                    result = command.executeUpdate();
                    if (result < 0) {
                        connection.rollback();
                        return null;
                    }
                    try {
                        Thread.sleep(200);
                    } catch (InterruptedException ex) {
                        logger.error(ex.getMessage());
                    }
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
                try {
                    connection.rollback();
                } catch (SQLException ex1) {
                    Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex1);
                }
                return null;
            } finally {
                try {
                    connection.commit();
                    connection.close();
                } catch (SQLException ex) {
                    Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        } else {
            return null;
        }
        return clientComplaintId;
    }
    
    public WebBusinessObject getActiveClientComplaint(String clientID) {
        Vector parameters = new Vector();
        Vector<Row> result;
        Connection connection = null;
        parameters.addElement(new StringValue(clientID));
        SQLCommandBean selectCommand = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            selectCommand = new SQLCommandBean();
            selectCommand.setConnection(connection);
            selectCommand.setSQLQuery(getQuery("getActiveClientComplaint").trim());
            selectCommand.setparams(parameters);
            result = selectCommand.executeQuery();
            WebBusinessObject wbo = null;
            for (Row row : result) {
                wbo = new WebBusinessObject();
                if(row.getString("CLIENT_COMPLAINT_ID") != null) {
                    wbo.setAttribute("clientComplaintID", row.getString("CLIENT_COMPLAINT_ID"));
                }
                if(row.getString("ISSUE_ID") != null) {
                    wbo.setAttribute("issueID", row.getString("ISSUE_ID"));
                }
                return wbo;
            }
        } catch (SQLException | UnsupportedTypeException ex) {
            logger.error(ex.getMessage());
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return null;
    }
    
    public boolean updateClientComplaintsType() {
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        beginTransaction();
        forInsert.setConnection(transConnection);
        forInsert.setSQLQuery(getQuery("updateClientComplaintsType").trim());
        try {
            queryResult = forInsert.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        if (queryResult < 0) {
            try {
                transConnection.rollback();
            } catch (SQLException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            return false;
        }
        try {
            Thread.sleep(50);
        } catch (InterruptedException ex) {
            Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            endTransaction();
        }
        return (queryResult > 0);
    }
    
    public ArrayList<WebBusinessObject> getCustomerServiceReport(java.sql.Date fromDate, java.sql.Date toDate, String departmentID, String[] ticketTypeIDs) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        params.addElement(new StringValue(departmentID));
        params.addElement(new StringValue(departmentID));
        try {
            StringBuilder sum = new StringBuilder();
            StringBuilder count = new StringBuilder();
            StringBuilder in = new StringBuilder();

            for (String ticketTypeID : ticketTypeIDs) {
                sum.append("SUM(TOTAL_").append(ticketTypeID).append(")TOTAL_").append(ticketTypeID).append(",");
                count.append("COUNT(CASE WHEN TICKET_TYPE = '").append(ticketTypeID).append("' THEN TICKET_TYPE END) TOTAL_")
                        .append(ticketTypeID).append(",");
            }
            in.append("'").append(Tools.arrayToString(ticketTypeIDs, "','")).append("'");
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            String sql = getQuery("getCustomerServiceReport").trim();
            sql = sql.replaceFirst("sumStatement", sum.toString()).replaceFirst("countStatement", count.toString())
                    .replaceFirst("inStatement", in.toString());
            forQuery.setSQLQuery(sql);
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
        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                if (r.getString("USER_ID") != null) {
                    wbo.setAttribute("userID", r.getString("USER_ID"));
                }
                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("userName", r.getString("FULL_NAME"));
                }
                for (String ticketTypeID : ticketTypeIDs) {
                    if (r.getBigDecimal("TOTAL_" + ticketTypeID) != null) {
                        wbo.setAttribute("total" + ticketTypeID, r.getBigDecimal("TOTAL_" + ticketTypeID));
                    }
                }
                resultBusObjs.add(wbo);
            }
        } catch (NoSuchColumnException | UnsupportedConversionException ce) {
            logger.error(ce);
        }
        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> getRequestsByUserInPeriod(java.sql.Date beginDate, java.sql.Date endDate, String userID, String type) {
        Vector SQLparams = new Vector();
        String theQuery = getQuery("getRequestsByUserInPeriod").trim();
        SQLparams.addElement(new StringValue(userID));
        SQLparams.addElement(new StringValue(type));
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
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
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
                if(row.getString("CURRENT_OWNER_NAME") != null) {
                    wbo.setAttribute("currentOwnerName", row.getString("CURRENT_OWNER_NAME"));
                }
                if(row.getString("BUSINESS_ID_BY_DATE") != null) {
                    wbo.setAttribute("businessIDbyDate", row.getString("BUSINESS_ID_BY_DATE"));
                }
                if(row.getString("CLIENT_ID") != null) {
                    wbo.setAttribute("clientID", row.getString("CLIENT_ID"));
                }
                if(row.getString("CLIENT_NAME") != null) {
                    wbo.setAttribute("clientName", row.getString("CLIENT_NAME"));
                }
                if(row.getString("STATUS_NAME_AR") != null) {
                    wbo.setAttribute("statusNameAr", row.getString("STATUS_NAME_AR"));
                }
                if(row.getString("STATUS_NAME_EN") != null) {
                    wbo.setAttribute("statusNameEn", row.getString("STATUS_NAME_EN"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            results.add(wbo);
        }
        return results;
    }
            
    public ArrayList<WebBusinessObject> getDistributionRequestsReport(java.sql.Date fromDate, java.sql.Date toDate, String departmentID, String[] ticketTypeIDs) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        params.addElement(new StringValue(departmentID));
        try {
            StringBuilder sum = new StringBuilder();
            StringBuilder count = new StringBuilder();
            StringBuilder in = new StringBuilder();

            for (String ticketTypeID : ticketTypeIDs) {
                sum.append("SUM(TOTAL_").append(ticketTypeID).append(")TOTAL_").append(ticketTypeID).append(",");
                count.append("COUNT(CASE WHEN TICKET_TYPE = '").append(ticketTypeID).append("' THEN TICKET_TYPE END) TOTAL_")
                        .append(ticketTypeID).append(",");
            }
            in.append("'").append(Tools.arrayToString(ticketTypeIDs, "','")).append("'");
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            String sql = getQuery("getDistributionRequestsReport").trim();
            sql = sql.replaceFirst("sumStatement", sum.toString()).replaceFirst("countStatement", count.toString())
                    .replaceFirst("inStatement", in.toString());
            forQuery.setSQLQuery(sql);
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
        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                if (r.getString("USER_ID") != null) {
                    wbo.setAttribute("userID", r.getString("USER_ID"));
                }
                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("userName", r.getString("FULL_NAME"));
                }
                for (String ticketTypeID : ticketTypeIDs) {
                    if (r.getBigDecimal("TOTAL_" + ticketTypeID) != null) {
                        wbo.setAttribute("total" + ticketTypeID, r.getBigDecimal("TOTAL_" + ticketTypeID));
                    }
                }
                resultBusObjs.add(wbo);
            }
        } catch (NoSuchColumnException | UnsupportedConversionException ce) {
            logger.error(ce);
        }
        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> getRequestsByOwnerInPeriod(java.sql.Date beginDate, java.sql.Date endDate, String ownerID, String type) {
        Vector SQLparams = new Vector();
        String theQuery = getQuery("getRequestsByOwnerInPeriod").trim();
        SQLparams.addElement(new StringValue(ownerID));
        SQLparams.addElement(new StringValue(type));
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
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
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
                if(row.getString("CREATED_BY_NAME") != null) {
                    wbo.setAttribute("createdByName", row.getString("CREATED_BY_NAME"));
                }
                if(row.getString("BUSINESS_ID_BY_DATE") != null) {
                    wbo.setAttribute("businessIDbyDate", row.getString("BUSINESS_ID_BY_DATE"));
                }
                if(row.getString("CLIENT_ID") != null) {
                    wbo.setAttribute("clientID", row.getString("CLIENT_ID"));
                }
                if(row.getString("CLIENT_NAME") != null) {
                    wbo.setAttribute("clientName", row.getString("CLIENT_NAME"));
                }
                if(row.getString("STATUS_NAME_AR") != null) {
                    wbo.setAttribute("statusNameAr", row.getString("STATUS_NAME_AR"));
                }
                if(row.getString("STATUS_NAME_EN") != null) {
                    wbo.setAttribute("statusNameEn", row.getString("STATUS_NAME_EN"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            results.add(wbo);
        }
        return results;
    }
    
    public WebBusinessObject saveJobOrderComplaint(HttpServletRequest request, WebBusinessObject persistentUser) throws NoUserInSessionException, SQLException {
        String servLevel = "0";
        String depCode = "QA";

        if (request.getAttribute("orderUrgency") != null) {
            servLevel = (String) request.getAttribute("orderUrgency");
        }

        DateParser dateParser = new DateParser();

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String issueId = (String) request.getParameter("issueID");
        IssueMgr issueMgr = IssueMgr.getInstance();
        WebBusinessObject issueWbo = new WebBusinessObject();
        issueWbo = (WebBusinessObject) issueMgr.getOnSingleKey(issueId);

//        String clientNoByDate = null;
        String clientCompId = UniqueIDGen.getNextID();

        params.addElement(new StringValue(clientCompId));
        params.addElement(new StringValue((String) request.getParameter("issueID")));
        params.addElement(new StringValue("1502277730347"));    //(String) persistentUser.getAttribute("userId")
        params.addElement(new StringValue("2"));
        params.addElement(new StringValue((String) issueWbo.getAttribute("businessID")));
        params.addElement(new StringValue(servLevel));
        params.addElement(new StringValue((String) request.getAttribute("ticketType")));
        params.addElement(new StringValue(depCode));
        WebBusinessObject wbo = new WebBusinessObject();
        UserMgr userMgr = UserMgr.getInstance();
        String ownerIssue = (String) request.getParameter("usrID");
        wbo = userMgr.getOnSingleKey(ownerIssue);
        params.addElement(new StringValue((String) wbo.getAttribute("userName")));
        params.addElement(new StringValue(ownerIssue));
        params.addElement(new StringValue((String) request.getParameter("compID")));
        //Connection connection = null;
        try {
            //connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertClientComplaint").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }

            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            params = new Vector();

            String issueStatusId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(issueStatusId));
            // 1 mean received from Issue // 2 mean sent from complaint //
            params.addElement(new StringValue("2"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue(clientCompId));
            params.addElement(new StringValue("client_complaint"));
            params.addElement(new StringValue((String) request.getAttribute("issueId")));
            params.addElement(new StringValue("1502277730347"));    //(String) persistentUser.getAttribute("userId")

            forInsert.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }

            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            params = new Vector();

            String sysId = UniqueIDGen.getNextID();

            params.addElement(new StringValue(clientCompId));
            params.addElement(new StringValue("1502277730347"));    //(String) persistentUser.getAttribute("userId")
            params.addElement(new StringValue(ownerIssue));
            params.addElement(new StringValue("1"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue((String) request.getAttribute("comment")));
            params.addElement(new StringValue(sysId));
            params.addElement(new StringValue((String) request.getAttribute("subject")));
            params.addElement(new StringValue(""));
            forInsert.setSQLQuery(sqlMgr.getSql("saveDistributionList").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }
            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            params = new Vector();
            params.addElement(new StringValue("1"));

            forInsert.setSQLQuery(sqlMgr.getSql("updateGenericCount").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }

            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            params = new Vector();
            params.addElement(new StringValue(ownerIssue));

            forInsert.setSQLQuery(sqlMgr.getSql("updateUserTicketsCount").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }

        } catch (SQLException se) {
            logger.error(se.getMessage());
            transConnection.rollback();
            return null;

        } finally {
            endTransaction();

        }
        WebBusinessObject data = new WebBusinessObject();
        data.setAttribute("issueId", issueId);
        data.setAttribute("compId", clientCompId);
        return data;

    }
    
    public ArrayList<WebBusinessObject> getComplaintsWithRate(String rateID) {
        Vector parameters = new Vector();
        Vector<Row> result;
        Connection connection = null;
        parameters.addElement(new StringValue(rateID));
        SQLCommandBean selectCommand = new SQLCommandBean();
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        try {
            connection = dataSource.getConnection();
            selectCommand = new SQLCommandBean();
            selectCommand.setConnection(connection);
            selectCommand.setSQLQuery(getQuery("getComplaintsWithRate").trim());
            selectCommand.setparams(parameters);
            result = selectCommand.executeQuery();
            WebBusinessObject wbo = null;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                if(row.getString("CLIENT_ID") != null) {
                    wbo.setAttribute("clientID", row.getString("CLIENT_ID"));
                }
                data.add(wbo);
            }
        } catch (SQLException | UnsupportedTypeException ex) {
            logger.error(ex.getMessage());
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(IssueMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(IssueMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return data;
    }
    
    public ArrayList<WebBusinessObject> getRecentComplaints(int withIn) {
        String theQuery = getQuery("getRecentComplaints").trim();
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector<Row> result;
        Vector params = new Vector();
        params.addElement(new IntValue(withIn));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(theQuery);
            command.setparams(params);
            result = command.executeQuery();
            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = fabricateBusObj(row);
                try {
                    if (row.getString("CLIENT_COMPLAINT_ID") != null) {
                        wbo.setAttribute("clientComplaintID", row.getString("CLIENT_COMPLAINT_ID"));
                    }
                    if (row.getString("COMPLAINT_CREATED_BY") != null) {
                        wbo.setAttribute("createdBy", row.getString("COMPLAINT_CREATED_BY"));
                    }
                    if (row.getString("BUSINESS_ID") != null) {
                        wbo.setAttribute("businessID", row.getString("BUSINESS_ID"));
                    }
                    if (row.getString("BUSINESS_ID_BY_DATE") != null) {
                        wbo.setAttribute("businessIDbyDate", row.getString("BUSINESS_ID_BY_DATE"));
                    }
                    if (row.getString("BUSINESS_COMP_ID") != null) {
                        wbo.setAttribute("businessCompID", row.getString("BUSINESS_COMP_ID"));
                    }
                    if (row.getString("FULL_NAME") != null) {
                        wbo.setAttribute("ownerName", row.getString("FULL_NAME"));
                    }
                    if (row.getString("STATUS_NAME") != null) {
                        wbo.setAttribute("statusName", row.getString("STATUS_NAME"));
                    }
                    if (row.getString("EMAIL") != null) {
                        wbo.setAttribute("email", row.getString("EMAIL"));
                    }
                    if (row.getString("TYPE_NAME") != null) {
                        wbo.setAttribute("typeName", row.getString("TYPE_NAME"));
                    }
                    if (row.getString("CLIENT_NAME") != null) {
                        wbo.setAttribute("clientName", row.getString("CLIENT_NAME"));
                    }
                    if (row.getString("MOBILE") != null) {
                        wbo.setAttribute("mobile", row.getString("MOBILE"));
                    }
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                }
                data.add(wbo);
            }
        } catch (SQLException | UnsupportedTypeException ex) {
            logger.error(ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex);
            }
        }
        return data;
    }
}
