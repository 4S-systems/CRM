/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.clients.db_access;
 
import com.maintenance.common.Tools;
import com.maintenance.db_access.ExternalJobMgr;
import com.maintenance.db_access.TradeMgr;
import com.maintenance.db_access.UserCompaniesMgr;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.common.UserMgr;
import com.tracker.db_access.ProjectMgr;
import com.tracker.db_access.SequenceMgr;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.sql.*;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import static java.util.Calendar.YEAR;
import org.apache.log4j.xml.DOMConfigurator;
import java.sql.Date;
import java.sql.SQLException;

/**
 *
 * @author Waled
 */
public class ClientMgr extends RDBGateWay
{

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static ClientMgr clientMgr = new ClientMgr();

    public static ClientMgr getInstance()
    {
        logger.info("Getting DepartmentMgr Instance ....");
        return clientMgr;
    }

    protected void initSupportedForm()
    {
        if (webInfPath != null)
        {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null)
        {
            try
            {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("client.xml")));
            }
            catch (Exception e)
            {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public ArrayList getClientName(String equipmentID)
    {
        Vector prm = new Vector();
        prm.addElement(new StringValue(equipmentID));
        SQLCommandBean executeQuery = new SQLCommandBean();
        Vector resultQuery = new Vector();
        try
        {
            beginTransaction();
            executeQuery.setConnection(transConnection);
            executeQuery.setSQLQuery(getQuery("selectClient").trim());
            executeQuery.setparams(prm);
            resultQuery = executeQuery.executeQuery();
            endTransaction();
        }
        catch (Exception e)
        {
            logger.error("Could not execute Query");
        }
        ArrayList newData = new ArrayList();
        Row r = null;
        Enumeration e = resultQuery.elements();
        while (e.hasMoreElements())
        {
            WebBusinessObject wbo = null;
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            newData.add(wbo);
        }
        return newData;
    }

    public ArrayList getAllClient()
    {
        Vector queryResult = new Vector();
        WebBusinessObject wbo = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        try
        {
            //connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("selectAllClientsName").trim());
            queryResult = forInsert.executeQuery();
            endTransaction();
        }
        catch (SQLException se)
        {
            logger.error(se.getMessage());
        }
        catch (UnsupportedTypeException ex)
        {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        ArrayList resultBusObjs = new ArrayList();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;

    }

    public ArrayList getAllClientsWithMark(String clientStatus, String clientProject, String clientArea, String clientJob, String departmentID, HttpSession s, java.sql.Date fromDate, java.sql.Date toDate, boolean displayProject, String clientClass, String groupID, String interCode)
    {
        Vector queryResult = new Vector();
        WebBusinessObject wbo = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Vector params = new Vector();
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        StringBuilder query = new StringBuilder(getQuery("getClientsWithMark").trim());
        StringBuilder fieldsName = new StringBuilder();
        if (displayProject)
        {
            fieldsName.append(", CASE WHEN pp.PROJECT_NAME IS NOT NULL THEN pp.PROJECT_NAME ELSE 'None' END PROJECT_NAME");
            query.append(" left join client_projects cp on t.SYS_ID = cp.CLIENT_ID and cp.PRODUCT_ID = 'interested'");
            query.append(" left join project pp on cp.PRODUCT_CATEGORY_ID = pp.PROJECT_ID");
        }
        // for rate
        fieldsName.append(", RP.PROJECT_NAME RATE_NAME");
        query.append(" LEFT JOIN CLIENT_RATING CR ON CR.CLIENT_ID = t.SYS_ID LEFT JOIN PROJECT RP ON CR.RATE_ID = RP.PROJECT_ID ");
        
        query.append(" where");
        String[] statusTitles = new String[3];
        statusTitles[0] = "12";
        statusTitles[1] = "13";
        statusTitles[2] = "14";
        query.append(" t.CURRENT_STATUS in (");
        query.append("select MAX(DECODE(client_status,'11', '11')) as client_status from client_rule where department_id ='"); // for status = 11
        query.append(departmentID).append("'").append(" union ");
        int i = 0;
        for (String statusTitle : statusTitles)
        {
            query.append("select MAX(DECODE(client_status,'99','").append(statusTitle).append("')) as client_status ");
            query.append("from client_rule where department_id = '").append(departmentID).append("'");
            if (i < statusTitles.length - 1)
        {
                query.append(" union ");
        }
            i++;
                }
        query.append(")");
        if (clientStatus != null && !clientStatus.equalsIgnoreCase("all")) {
            query.append(" and t.CURRENT_STATUS = '").append(clientStatus).append("'");
        }
        if (clientArea != null && !clientArea.equalsIgnoreCase("all")) {
            query.append(" and t.REGION = '").append(clientArea).append("'");
                }
        if (clientProject != null && !clientProject.equalsIgnoreCase("all")) {
            query.append(" and t.SYS_ID in (select cp.CLIENT_ID from client_projects cp where cp.PRODUCT_CATEGORY_ID = '").append(clientProject).append("')");
                }
        if (clientJob != null && !clientJob.equalsIgnoreCase("all")) {
            query.append(" and t.JOB  = '").append(clientJob).append("'");
                    }
        if (interCode != null && !interCode.isEmpty()) {
            query.append(" AND (T.INTER_PHONE  LIKE '").append(interCode).append("%' OR T.INTER_PHONE  LIKE '")
                    .append(interCode.replace("00", "")).append("%')");
                }
        if (fromDate != null && toDate != null)
        {
            query.append(" and trunc(t.CREATION_TIME) between ? and ?");
            params.addElement(new DateValue(fromDate));
            params.addElement(new DateValue(toDate));
                }

        if (clientClass != null && !clientClass.isEmpty())
        {
            if ("1".equals(clientClass))
            {
                query.append(" AND CR.RATE_ID IS NULL");
            }
            else
            {
                query.append(" AND CR.RATE_ID = ?");
                params.addElement(new StringValue(clientClass));
        }
        }
        if (groupID != null) {
            if (groupID.contains("all")) {
                query.append(" AND T.CREATED_BY IN (SELECT USER_ID FROM USER_GROUP WHERE GROUP_ID IN (SELECT GROUP_ID FROM USER_GROUP_CONFIG WHERE USER_ID = ?))");
                params.addElement(new StringValue((String) waUser.getAttribute("userId")));
            } else {
                query.append(" AND T.CREATED_BY IN (SELECT USER_ID FROM USER_GROUP WHERE GROUP_ID IN (").append(groupID).append("))");
    }
        }

        try
        {
            //connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(query.toString().replaceAll("fields_name", fieldsName.toString()));
            forInsert.setparams(params);
            queryResult = forInsert.executeQuery();
            endTransaction();
        }
        catch (SQLException se)
        {
            logger.error(se.getMessage());
        }
        catch (UnsupportedTypeException ex)
        {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        ArrayList resultBusObjs = new ArrayList();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try
            {
                if (r.getString("BOOKMARK_ID") != null)
                {
                    wbo.setAttribute("markID", r.getString("BOOKMARK_ID"));
                }
                if (r.getString("BOOKMARK") != null)
                {
                    wbo.setAttribute("bookmarkText", r.getString("BOOKMARK"));
                }
                if (r.getString("FULL_NAME") != null)
                {
                    wbo.setAttribute("createdByName", r.getString("FULL_NAME"));
                }
                if (r.getString("BRANCH_NAME") != null)
                {
                    wbo.setAttribute("branchName", r.getString("BRANCH_NAME"));
                }
                if (r.getString("KNOW_US_BY") != null) {
                    wbo.setAttribute("knowUsBy", r.getString("KNOW_US_BY"));
                }
                if (displayProject) {
                    if (r.getString("PROJECT_NAME") != null) 
                    {
                        wbo.setAttribute("projectName", r.getString("PROJECT_NAME"));
                    }
                }
                if (r.getString("RATE_NAME") != null) {
                    wbo.setAttribute("rateName", r.getString("RATE_NAME"));
                }
            }
            catch (NoSuchColumnException ex)
            {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;

    }
    
    public ArrayList getAllClientsComments(String clientJob, java.sql.Date fromDate, java.sql.Date toDate)
    {
        Vector queryResult = new Vector();
        WebBusinessObject wbo = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        Vector params = new Vector();
        StringBuilder query = new StringBuilder(getQuery("getAllClientsComments").trim());
        if (fromDate != null && toDate != null)
        {
            query.append(" and trunc(cc.CREATION_TIME) between ? and ?");
            params.addElement(new DateValue(fromDate));
            params.addElement(new DateValue(toDate));
        }

        if (clientJob != null && !clientJob.equalsIgnoreCase("all")) {
            query.append(" and cgc.id  = '").append(clientJob).append("'");
        }
       
        try
        {
            //connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(query.toString());
            forInsert.setparams(params);
            queryResult = forInsert.executeQuery();
            endTransaction();
        }
        catch (SQLException se)
        {
            logger.error(se.getMessage());
        }
        catch (UnsupportedTypeException ex)
        {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        ArrayList resultBusObjs = new ArrayList();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try
            {
                if (r.getString("client_no") != null)
                {
                    wbo.setAttribute("client_no", r.getString("client_no"));
                } else {
                    wbo.setAttribute("client_no", "");
                }
                if (r.getString("name") != null)
                {
                    wbo.setAttribute("name", r.getString("name"));
                } else {
                    wbo.setAttribute("name", "");
                }
                if (r.getString("mobile") != null)
                {
                    wbo.setAttribute("mobile", r.getString("mobile"));
                } else {
                    wbo.setAttribute("mobile", "");
                }
                if (r.getString("address") != null)
                {
                    wbo.setAttribute("address", r.getString("address"));
                } else {
                    wbo.setAttribute("address", "");
                }
                if (r.getString("clientssn") != null) {
                    wbo.setAttribute("clientssn", r.getString("clientssn"));
                } else {
                    wbo.setAttribute("clientssn", "");
                }
                if (r.getString("full_name") != null) {
                    wbo.setAttribute("full_name", r.getString("full_name"));
                } else {
                    wbo.setAttribute("full_name", "");
                }
                if (r.getString("campaign_title") != null) {
                    wbo.setAttribute("campaign_title", r.getString("campaign_title"));
                } else {
                    wbo.setAttribute("campaign_title", "");
                }
                if (r.getString("englishname") != null) {
                    wbo.setAttribute("englishname", r.getString("englishname"));
                } else {
                    wbo.setAttribute("englishname", "");
                }
                if (r.getString("case_en") != null) {
                    wbo.setAttribute("case_en", r.getString("case_en"));
                } else {
                    wbo.setAttribute("case_en", "");
                }
                if (r.getString("description") != null) {
                    wbo.setAttribute("description", r.getString("description"));
                } else {
                    wbo.setAttribute("description", "");
                }
            }
            catch (NoSuchColumnException ex)
            {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;

    }

    public Vector selectAllClient()
    {
        Vector queryResult = new Vector();
        WebBusinessObject wbo = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        try
        {
            //connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("selectAllClients").trim());
            queryResult = forInsert.executeQuery();
            endTransaction();
        }
        catch (SQLException se)
        {
            logger.error(se.getMessage());
        }
        catch (UnsupportedTypeException ex)
        {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        Vector resultBusObjs = new Vector();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;

    }

    public Vector clientByName(String clientName, String srchType) throws SQLException
    {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        String query = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();

        if (srchType != null)
        {
            if (srchType == "id")
            {
                query = getQuery("getClientsByID").trim();
                query = query.replaceAll("clientno", clientName);
            }
            if (srchType == "all")
            {
                query = getQuery("getClients").trim();
            }
        }
        else
        {
            query = getQuery("getClientByName").trim();
            query = query.replaceAll("clientName", clientName);
        }

        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();

        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {

            connection.close();

        }

        Vector reultBusObjs = new Vector();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {

            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            reultBusObjs.add(wbo);
        }

        return reultBusObjs;

    }

    public Vector clientByNameForSales(String clientName, String departmentID) throws SQLException
    {
        WebBusinessObject wbo;
        Connection connection = null;
        String query;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        query = getQuery("getClientByNameForSales").trim();
        query = query.replaceAll("clientName", clientName);
        String[] statusTitles = new String[3];
        statusTitles[0] = "12";
        statusTitles[1] = "13";
        statusTitles[2] = "14";
        statusTitles[2] = "86";
        statusTitles[2] = "87";
        StringBuilder statusQuery = new StringBuilder(" and C.CURRENT_STATUS in (");
        statusQuery.append("select MAX(DECODE(client_status,'11', '11')) as client_status from client_rule where department_id ='"); // for status = 11
        statusQuery.append(departmentID).append("'").append(" union ");
        int i = 0;
        for (String statusTitle : statusTitles)
        {
            statusQuery.append("select MAX(DECODE(client_status,'99','").append(statusTitle).append("')) as client_status ");
            statusQuery.append("from client_rule where department_id = '").append(departmentID).append("'");
            if (i < statusTitles.length - 1)
            {
                statusQuery.append(" union ");
            }
            i++;
        }
        statusQuery.append(")");
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query + statusQuery.toString());
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            connection.close();
        }
        Vector resultBusObjs = new Vector();
        Row r;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {
            try
            {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                if (r.getString("CASE_AR") != null)
                {
                    wbo.setAttribute("currentStatusNameAr", r.getString("CASE_AR"));

                }
                if (r.getString("CASE_EN") != null)
                {
                    wbo.setAttribute("currentStatusNameEn", r.getString("CASE_EN"));
                }
//                if (r.getString("ID") != null) {
//                    wbo.setAttribute("issueID", r.getString("ID"));
//                }
                resultBusObjs.add(wbo);
            }
            catch (NoSuchColumnException ex)
            {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return resultBusObjs;
    }
 public Vector clientByEmailForSales(String clientEmail, String departmentID) throws SQLException
    {
        WebBusinessObject wbo;
        Connection connection = null;
        String query;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        query = getQuery("clientByEmailForSales").trim();
        query = query.replaceAll("clientEmail", clientEmail);
        String[] statusTitles = new String[3];
        statusTitles[0] = "12";
        statusTitles[1] = "13";
        statusTitles[2] = "14";
        StringBuilder statusQuery = new StringBuilder(" and C.CURRENT_STATUS in (");
        statusQuery.append("select MAX(DECODE(client_status,'11', '11')) as client_status from client_rule where department_id ='"); // for status = 11
        statusQuery.append(departmentID).append("'").append(" union ");
        int i = 0;
        for (String statusTitle : statusTitles)
        {
            statusQuery.append("select MAX(DECODE(client_status,'99','").append(statusTitle).append("')) as client_status ");
            statusQuery.append("from client_rule where department_id = '").append(departmentID).append("'");
            if (i < statusTitles.length - 1)
            {
                statusQuery.append(" union ");
            }
            i++;
        }
        statusQuery.append(")");
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query + statusQuery.toString());
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            connection.close();
        }
        Vector resultBusObjs = new Vector();
        Row r;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {
            try
            {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                if (r.getString("CASE_AR") != null)
                {
                    wbo.setAttribute("currentStatusNameAr", r.getString("CASE_AR"));

                }
                if (r.getString("CASE_EN") != null)
                {
                    wbo.setAttribute("currentStatusNameEn", r.getString("CASE_EN"));
                }
//                if (r.getString("ID") != null) {
//                    wbo.setAttribute("issueID", r.getString("ID"));
//                }
                resultBusObjs.add(wbo);
            }
            catch (NoSuchColumnException ex)
            {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return resultBusObjs;
    }

    /* public Vector getClientsById(String clientId) throws SQLException{
     WebBusinessObject wbo;
     Connection connection = null;
     Vector queryResult = new Vector();
     SQLCommandBean forQuery = new SQLCommandBean();
     try {
     connection = dataSource.getConnection();
     forQuery.setConnection(connection);
     forQuery.setSQLQuery(getQuery("getClientById").trim().replaceAll("num", clientId));
     queryResult = forQuery.executeQuery();
     } catch (SQLException ex) {
     logger.error("SQL Exception  " + ex.getMessage());

     } catch (UnsupportedTypeException uste) {
     logger.error("***** " + uste.getMessage());
     } finally {
     connection.close();
     }
     Row r;
     Vector result = new Vector();
     Enumeration e = queryResult.elements();
     while (e.hasMoreElements()) {

     r = (Row) e.nextElement();
     wbo = fabricateBusObj(r);
     result.add(wbo);

     }
     return  result;
     }*/
    public Vector getClientsByNo(String clientNo, String departmentID) throws SQLException, NoSuchColumnException
    {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        String[] statusTitles = new String[3];
        statusTitles[0] = "12";
        statusTitles[1] = "13";
        statusTitles[2] = "14";
        StringBuilder statusQuery = new StringBuilder(" and C.CURRENT_STATUS in (");
        statusQuery.append("select MAX(DECODE(client_status,'11', '11')) as client_status from client_rule where department_id ='"); // for status = 11
        statusQuery.append(departmentID).append("'").append(" union ");
        int i = 0;
        for (String statusTitle : statusTitles)
        {
            statusQuery.append("select MAX(DECODE(client_status,'99','").append(statusTitle).append("')) as client_status ");
            statusQuery.append("from client_rule where department_id = '").append(departmentID).append("'");
            if (i < statusTitles.length - 1)
            {
                statusQuery.append(" union ");
            }
            i++;
        }
        statusQuery.append(")");
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientByNo").trim().replaceAll("num", clientNo) + statusQuery.toString());
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());

        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            connection.close();
        }
        Row r;
        Vector resultBusObjs = new Vector();
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {

            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);

        }
        return resultBusObjs;
    }
    
    public Vector getClientsByEmail(String clientMail, String departmentID) throws SQLException, NoSuchColumnException
    {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        String[] statusTitles = new String[3];
        statusTitles[0] = "12";
        statusTitles[1] = "13";
        statusTitles[2] = "14";
        StringBuilder statusQuery = new StringBuilder(" and C.CURRENT_STATUS in (");
        statusQuery.append("select MAX(DECODE(client_status,'11', '11')) as client_status from client_rule where department_id ='"); // for status = 11
        statusQuery.append(departmentID).append("'").append(" union ");
        int i = 0;
        for (String statusTitle : statusTitles)
        {
            statusQuery.append("select MAX(DECODE(client_status,'99','").append(statusTitle).append("')) as client_status ");
            statusQuery.append("from client_rule where department_id = '").append(departmentID).append("'");
            if (i < statusTitles.length - 1)
            {
                statusQuery.append(" union ");
            }
            i++;
        }
        statusQuery.append(")");
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientByMail").trim().replaceAll("mail", clientMail) + statusQuery.toString());
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());

        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            connection.close();
        }
        Row r;
        Vector resultBusObjs = new Vector();
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {

            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);

        }
        return resultBusObjs;
    }


    public Vector getClientByComVec(String clientNo, String departmentID) throws SQLException, NoSuchColumnException
    {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        String[] statusTitles = new String[3];
        statusTitles[0] = "12";
        statusTitles[1] = "13";
        statusTitles[2] = "14";
        StringBuilder statusQuery = new StringBuilder(" and C.CURRENT_STATUS in (");
        statusQuery.append("select MAX(DECODE(client_status,'11', '11')) as client_status from client_rule where department_id ='"); // for status = 11
        statusQuery.append(departmentID).append("'").append(" union ");
        int i = 0;
        for (String statusTitle : statusTitles)
        {
            statusQuery.append("select MAX(DECODE(client_status,'99','").append(statusTitle).append("')) as client_status ");
            statusQuery.append("from client_rule where department_id = '").append(departmentID).append("'");
            if (i < statusTitles.length - 1)
            {
                statusQuery.append(" union ");
            }
            i++;
        }
        statusQuery.append(")");
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientByOtherPhoneNo").trim().replaceAll("num", clientNo) + statusQuery.toString());
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());

        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            connection.close();
        }
        Row r;
        Vector resultBusObjs = new Vector();
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {

            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);

        }
        return resultBusObjs;
    }
    public Vector getClientByOtherEmails(String clientEmail, String departmentID) throws SQLException, NoSuchColumnException
    {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        String[] statusTitles = new String[3];
        statusTitles[0] = "12";
        statusTitles[1] = "13";
        statusTitles[2] = "14";
        StringBuilder statusQuery = new StringBuilder(" and C.CURRENT_STATUS in (");
        statusQuery.append("select MAX(DECODE(client_status,'11', '11')) as client_status from client_rule where department_id ='"); // for status = 11
        statusQuery.append(departmentID).append("'").append(" union ");
        int i = 0;
        for (String statusTitle : statusTitles)
        {
            statusQuery.append("select MAX(DECODE(client_status,'99','").append(statusTitle).append("')) as client_status ");
            statusQuery.append("from client_rule where department_id = '").append(departmentID).append("'");
            if (i < statusTitles.length - 1)
            {
                statusQuery.append(" union ");
            }
            i++;
        }
        statusQuery.append(")");
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientByOtherEmails").trim().replaceAll("ClientEmail", clientEmail) + statusQuery.toString());
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());

        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            connection.close();
        }
        Row r;
        Vector resultBusObjs = new Vector();
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {

            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);

        }
        return resultBusObjs;
    }

    public Vector getClientByComMail(String clientMail, String departmentID) throws SQLException, NoSuchColumnException
    {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        String[] statusTitles = new String[3];
        statusTitles[0] = "12";
        statusTitles[1] = "13";
        statusTitles[2] = "14";
        StringBuilder statusQuery = new StringBuilder(" and C.CURRENT_STATUS in (");
        statusQuery.append("select MAX(DECODE(client_status,'11', '11')) as client_status from client_rule where department_id ='"); // for status = 11
        statusQuery.append(departmentID).append("'").append(" union ");
        int i = 0;
        for (String statusTitle : statusTitles)
        {
            statusQuery.append("select MAX(DECODE(client_status,'99','").append(statusTitle).append("')) as client_status ");
            statusQuery.append("from client_rule where department_id = '").append(departmentID).append("'");
            if (i < statusTitles.length - 1)
            {
                statusQuery.append(" union ");
            }
            i++;
        }
        statusQuery.append(")");
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientByOtherEmail").trim().replaceAll("mail", clientMail) + statusQuery.toString());
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());

        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            connection.close();
        }
        Row r;
        Vector resultBusObjs = new Vector();
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {

            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);

        }
        return resultBusObjs;
    }

    public Vector clientByDescForSales(String description, String departmentID) throws SQLException
    {
        WebBusinessObject wbo;
        Connection connection = null;
        String query;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        query = getQuery("getClientByDescForSales").trim();
        query = query.replaceAll("clientDescription", description);
        String[] statusTitles = new String[3];
        statusTitles[0] = "12";
        statusTitles[1] = "13";
        statusTitles[2] = "14";
        StringBuilder statusQuery = new StringBuilder(" and C.CURRENT_STATUS in (");
        statusQuery.append("select MAX(DECODE(client_status,'11', '11')) as client_status from client_rule where department_id ='"); // for status = 11
        statusQuery.append(departmentID).append("'").append(" union ");
        int i = 0;
        for (String statusTitle : statusTitles)
        {
            statusQuery.append("select MAX(DECODE(client_status,'99','").append(statusTitle).append("')) as client_status ");
            statusQuery.append("from client_rule where department_id = '").append(departmentID).append("'");
            if (i < statusTitles.length - 1)
            {
                statusQuery.append(" union ");
            }
            i++;
        }
        statusQuery.append(")");
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query + statusQuery.toString());
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            connection.close();
        }
        Vector resultBusObjs = new Vector();
        Row r;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {
            try
            {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                if (r.getString("CASE_AR") != null)
                {
                    wbo.setAttribute("currentStatusNameAr", r.getString("CASE_AR"));

                }
                if (r.getString("CASE_EN") != null)
                {
                    wbo.setAttribute("currentStatusNameEn", r.getString("CASE_EN"));
                }
                if (r.getString("ID") != null)
                {
                    wbo.setAttribute("issueID", r.getString("ID"));
                }
                resultBusObjs.add(wbo);
            }
            catch (NoSuchColumnException ex)
            {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return resultBusObjs;
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException
    {
        return false;
    }

    public boolean saveClient(HttpServletRequest request, HttpSession s, WebBusinessObject persistentUser) throws NoUserInSessionException, SQLException
    {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String connectByRealEstate = metaDataMgr.getConnectByRealEstate();
        String code = null;
        String userName = null;
        String password = null;
        String driver = null;
        String URL = null;
        Connection conn = null;
        String clientNo = null;
//        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String clientStatus = null;
        SequenceMgr sequenceMgr = SequenceMgr.getInstance();
        /////////// Get Client date from Real Estate ////////////
        if (connectByRealEstate != null && !connectByRealEstate.equals("")
                && connectByRealEstate.equals("1"))
        {
            userName = metaDataMgr.getRealEstateName();
            password = metaDataMgr.getRealEstatePassword();
            driver = metaDataMgr.getDriverErp();
            URL = metaDataMgr.getDataBaseErpUrl();
            Vector queryRsult = new Vector();
            SQLCommandBean forQuery = new SQLCommandBean();
            try
            {
                Class.forName(driver);
                conn = DriverManager.getConnection(URL, userName, password);
                conn.setAutoCommit(false);
                forQuery.setConnection(conn);
                String myQuery = getQuery("getMaxCodeOfClient").trim();
                forQuery.setSQLQuery(myQuery);
                queryRsult = forQuery.executeQuery();
            }
            catch (Exception se)
            {
                logger.error("database error " + se.getMessage());
            }
            finally
            {
                try
                {
                    conn.commit();
                    conn.close();
                }
                catch (SQLException sex)
                {
                    logger.error("troubles closing connection " + sex.getMessage());
                    return false;
                }
            }

            Vector resultBusObjs = new Vector();
            WebBusinessObject wbo2;
            Row r = null;
            Enumeration e = queryRsult.elements();

            while (e.hasMoreElements())
            {
                r = (Row) e.nextElement();
                try
                {
                    if (r.getString("code") != null)
                    {
                        code = r.getString("code");
                    }
                }
                catch (NullPointerException exm)
                {
                    code = "0";
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                    return false;
                }
            }
            Integer iCode = new Integer(code) + 1;
            String str0 = "";
            for (int x = iCode.toString().length(); x < 8; x++)
            {
                str0 = str0 + "0";
            }
            code = str0 + iCode.toString();
            sequenceMgr.updateSequence();
            clientNo = sequenceMgr.getSequence();
            request.setAttribute("clientNo", clientNo);
        }
        else
        {
            String automatedClientNo = request.getParameter("automatedClientNo");

            if (automatedClientNo == null || automatedClientNo == "")
            {
                clientNo = request.getParameter("clientNO");

            }
            else
            {
                sequenceMgr.updateSequence();
                clientNo = sequenceMgr.getSequence();
            }
            request.setAttribute("clientNo", clientNo);
        }
        ///////////////////////////////////////////

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String clientNoByDate = null;

        String id = UniqueIDGen.getNextID();
        params.addElement(new StringValue(id));
        params.addElement(new StringValue(clientNo));
        params.addElement(new StringValue(request.getParameter("clientName")));
        params.addElement(new StringValue(request.getParameter("gender")));
        params.addElement(new StringValue(request.getParameter("matiralStatus")));

        if (request.getParameter("clientMobile") != null && !request.getParameter("clientMobile").isEmpty())
        {
            String mobile = request.getParameter("clientMobile");
            if (request.getParameter("internationalM") != null && !request.getParameter("internationalM").isEmpty())
            {
                mobile = request.getParameter("internationalM") + "-" + mobile;
            }
            params.addElement(new StringValue(mobile));
        }
        else
        {
            params.addElement(new StringValue(" "));
        }
//        params.addElement(new StringValue("xxxxxxxxx"));
        if (request.getParameter("phone") != null && !request.getParameter("phone").isEmpty())
        {
            String phone = request.getParameter("phone");
            if (request.getParameter("internationalP") != null && !request.getParameter("internationalP").isEmpty())
            {
                phone = request.getParameter("internationalP") + "-" + phone;
            }
            params.addElement(new StringValue(phone));
        }
        else
        {
            params.addElement(new StringValue(" "));
        }
        if (request.getParameter("clientSalary") != null && !request.getParameter("clientSalary").isEmpty())
        {
            params.addElement(new StringValue(request.getParameter("clientSalary")));
        }
        else
        {
            params.addElement(new StringValue(""));
        }
        if (request.getParameter("address") != null && !request.getParameter("address").isEmpty())
        {
            params.addElement(new StringValue(request.getParameter("address")));
        }
        else
        {
            params.addElement(new StringValue(""));
        }
        if (request.getParameter("email") != null && !request.getParameter("email").isEmpty())
        {
            params.addElement(new StringValue(request.getParameter("email")));
        }
        else
        {
            params.addElement(new StringValue(""));
        }

        if (request.getParameter("isActive") != null)
        {
            params.addElement(new StringValue("1"));
            clientStatus = "1";

        }
        else
        {
            params.addElement(new StringValue("0"));
            clientStatus = "0";
        }
        params.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
//        params.addElement(new StringValue("1"));
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new java.util.Date());
        clientNoByDate = (calendar.get(Calendar.MONTH) + 1) + "/" + calendar.get(Calendar.YEAR);
        params.addElement(new StringValue(clientNoByDate));

        if (request.getParameter("clientSsn") != null && !request.getParameter("clientSsn").isEmpty())
        {
            params.addElement(new StringValue(request.getParameter("clientSsn")));
        }
        else
        {
            params.addElement(new StringValue(""));
        }
        if (request.getParameter("age") != null && !request.getParameter("age").isEmpty())
        {
            params.addElement(new StringValue(request.getParameter("age")));
        }
        else
        {
            params.addElement(new StringValue("20-30"));
        }
        if (request.getParameter("partner") != null && !request.getParameter("partner").isEmpty())
        {
            params.addElement(new StringValue(request.getParameter("partner")));
        }
        else
        {
            params.addElement(new StringValue("  "));
        }

        params.addElement(new StringValue((String) request.getAttribute("jobTitle")));

        params.addElement(new StringValue(request.getParameter("workOut")));//option1
        params.addElement(new StringValue(request.getParameter("kindred")));//option2
        params.addElement(new StringValue(""));//option3

        if (connectByRealEstate != null && !connectByRealEstate.equals("")
                && connectByRealEstate.equals("1"))
        {
            params.addElement(new StringValue(code));
            request.setAttribute("code", code);
        }
        else
        {
            params.addElement(new StringValue(clientNo));
            request.setAttribute("code", clientNoByDate);
        }
        if (request.getParameter("nationality") != null && !request.getParameter("nationality").equals(""))
        {
            params.addElement(new StringValue(request.getParameter("nationality")));
        }
        else
        {
            params.addElement(new StringValue(""));
        }
        params.addElement(new StringValue((String) request.getAttribute("regionTitle")));
        request.setAttribute("clientId", id);
        if (request.getParameter("description") != null && !request.getParameter("description").isEmpty())
        {
            params.addElement(new StringValue(request.getParameter("description")));
        }
        else
        {
            params.addElement(new StringValue(" "));
        }
        params.addElement(new StringValue(""));//interPhone
//        Connection connection = null;
        try
        {
//            connection = dataSource.getConnection();
            beginTransaction();
//            connection.setAutoCommit(true);
            forInsert.setConnection(transConnection);
            String myQuery = getQuery("insertClient").trim();
            forInsert.setSQLQuery(myQuery);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0)
            {
                transConnection.rollback();
                return false;

            }
            if (clientStatus.equals("1"))
            {
                params = new Vector();

                queryResult = -1000;

                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue("New"));
                params.addElement(new StringValue(id));
                params.addElement(new StringValue("No Description"));
                forInsert.setConnection(transConnection);
                forInsert.setSQLQuery(getQuery("insertInitialClientStatus").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();

                if (queryResult < 0)
                {
                    transConnection.rollback();
                    return false;
                }
            }

        }
        catch (SQLException se)
        {
            logger.error(se.getMessage());
            transConnection.rollback();
            return false;
//
        }
        finally
        {
            endTransaction();
        }

        //////////// Insert Client In Real Estate  //////
        if (connectByRealEstate != null && !connectByRealEstate.equals("")
                && connectByRealEstate.equals("1"))
        {
            int qryResult = -1000;
            if (queryResult > 0)
            {
                Vector SQLparams = new Vector();
                SQLparams.addElement(new StringValue(code));
                SQLparams.addElement(new StringValue(request.getParameter("clientName")));
                SQLparams.addElement(new StringValue(request.getParameter("clientName")));
                try
                {
                    Class.forName(driver);
                    conn = DriverManager.getConnection(URL, userName, password);
                    conn.setAutoCommit(false);
                    forInsert.setConnection(conn);
                    forInsert.setparams(SQLparams);
                    String myQuery = getQuery("saveClientInRealEstate").trim();
                    forInsert.setSQLQuery(myQuery);
                    qryResult = forInsert.executeUpdate();
                }
                catch (Exception se)
                {
                    logger.error("database error " + se.getMessage());
                }
                finally
                {
                    try
                    {
                        conn.commit();
                        conn.close();
                    }
                    catch (SQLException sex)
                    {
                        logger.error("troubles closing connection " + sex.getMessage());
                        return false;
                    }
                }
            }
        }
        //////////////////////////////////////////////////

        return (queryResult > 0);

    }

    public String UpdateClient(WebBusinessObject wbo) throws NoUserInSessionException, SQLException
    {

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(wbo.getAttribute("ownerName").toString()));
        params.addElement(new StringValue(wbo.getAttribute("ownerTel").toString()));
        params.addElement(new StringValue(wbo.getAttribute("ownerId").toString()));

        Connection connection = null;
        try
        {
            connection = dataSource.getConnection();
            connection.setAutoCommit(true);
//            beginTransaction();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("updateOwner").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
//            return true;
//            endTransaction();

        }
        catch (SQLIntegrityConstraintViolationException ex)
        {
            logger.error(ex.getMessage());
            return "dublicate";
        }
        finally
        {
            connection.close();

        }

        if (queryResult > 0)
        {
            return "Ok";
        }
        else
        {
            return "No";
        }

    }

    public String addToCart(WebBusinessObject wbo) throws NoUserInSessionException, SQLException
    {

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        String ID = UniqueIDGen.getNextID();
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        String unitNm = projectMgr.getOnSingleKey(wbo.getAttribute("projectID").toString()).getAttribute("projectName").toString();
        params.addElement(new StringValue(ID));
        params.addElement(new StringValue(wbo.getAttribute("clientID").toString()));
        params.addElement(new StringValue(wbo.getAttribute("projectID").toString()));
        params.addElement(new StringValue(wbo.getAttribute("userId").toString()));
        if(wbo.getAttribute("productCategoryID").toString()!=null && wbo.getAttribute("productCategoryID").toString().equalsIgnoreCase("") && wbo.getAttribute("productCategoryID").toString().equalsIgnoreCase(" ")){
            params.addElement(new StringValue(wbo.getAttribute("productCategoryID").toString()));
            params.addElement(new StringValue(unitNm));
            params.addElement(new StringValue(wbo.getAttribute("productCategoryName").toString()));
        } else {
            String ProjectID = projectMgr.getOnSingleKey(wbo.getAttribute("projectID").toString()).getAttribute("mainProjId").toString();
            String projectNm = projectMgr.getOnSingleKey(ProjectID).getAttribute("projectName").toString();
            
            params.addElement(new StringValue(ProjectID));
            params.addElement(new StringValue(unitNm));
            params.addElement(new StringValue(projectNm));
        }
        

        Connection connection = null;
        try
        {
            connection = dataSource.getConnection();
            connection.setAutoCommit(true);
//            beginTransaction();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("addToCart").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
//            return true;
//            endTransaction();

        }
        catch (SQLIntegrityConstraintViolationException ex)
        {
            logger.error(ex.getMessage());
            return "dublicate";
        }
        finally
        {
            connection.close();

        }

        if (queryResult > 0)
        {
            return "Ok";
        }
        else
        {
            return "No";
        }

    }

    public WebBusinessObject selectOwnerInfo(HttpServletRequest request) throws NoUserInSessionException, SQLException, UnsupportedTypeException
    {

        WebBusinessObject wbo = new WebBusinessObject();

        Vector params = new Vector();
        SQLCommandBean command = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) request.getAttribute("ownerID")));

        Connection connection = null;
        connection = dataSource.getConnection();
        connection.setAutoCommit(true);
        command.setConnection(connection);

        command.setSQLQuery(getQuery("selectOwnerInfo").trim());
        command.setparams(params);
        //queryResult = command.executeQuery();

        Vector<Row> rows = null;

        rows = command.executeQuery();
        for (Row row : rows)
        {
            try
            {
                if (row.getString("NAME") != null)
                {
                    wbo.setAttribute("name", row.getString("NAME"));
                }
                if (row.getString("MOBILE") != null)
                {
                    wbo.setAttribute("mobile", row.getString("MOBILE"));
                }
                return wbo;
            }
            catch (NoSuchColumnException ex)
            {
                logger.error("SQL Exception  " + ex.getMessage());
            }
        }
        try
        {
            if (connection != null)
            {
                connection.close();
            }
        }
        catch (SQLException ex)
        {
            logger.error(ex.getMessage());
        }

        return wbo;
    }

    public boolean saveCompany(HttpServletRequest request, HttpSession s, WebBusinessObject persistentUser) throws NoUserInSessionException, SQLException
    {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String connectByRealEstate = metaDataMgr.getConnectByRealEstate();
        String code = null;
        String userName = null;
        String password = null;
        String driver = null;
        String URL = null;
        Connection conn = null;
        String clientNo = null;
//        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String clientStatus = null;
        SequenceMgr sequenceMgr = SequenceMgr.getInstance();
        /////////// Get Client date from Real Estate ////////////
        if (connectByRealEstate != null && !connectByRealEstate.equals("")
                && connectByRealEstate.equals("1"))
        {
            userName = metaDataMgr.getRealEstateName();
            password = metaDataMgr.getRealEstatePassword();
            driver = metaDataMgr.getDriverErp();
            URL = metaDataMgr.getDataBaseErpUrl();
            Vector queryRsult = new Vector();
            SQLCommandBean forQuery = new SQLCommandBean();
            try
            {
                Class.forName(driver);
                conn = DriverManager.getConnection(URL, userName, password);
                conn.setAutoCommit(false);
                forQuery.setConnection(conn);
                String myQuery = getQuery("getMaxCodeOfClient").trim();
                forQuery.setSQLQuery(myQuery);
                queryRsult = forQuery.executeQuery();
            }
            catch (Exception se)
            {
                logger.error("database error " + se.getMessage());
            }
            finally
            {
                try
                {
                    conn.commit();
                    conn.close();
                }
                catch (SQLException sex)
                {
                    logger.error("troubles closing connection " + sex.getMessage());
                    return false;
                }
            }

            Vector resultBusObjs = new Vector();
            WebBusinessObject wbo2;
            Row r = null;
            Enumeration e = queryRsult.elements();

            while (e.hasMoreElements())
            {
                r = (Row) e.nextElement();
                try
                {
                    if (r.getString("code") != null)
                    {
                        code = r.getString("code");
                    }
                }
                catch (NullPointerException exm)
                {
                    code = "0";

                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);

                    return false;
                }
            }
            Integer iCode = new Integer(code) + 1;
            String str0 = "";
            for (int x = iCode.toString().length(); x < 8; x++)
            {
                str0 = str0 + "0";
            }
            code = str0 + iCode.toString();
            sequenceMgr.updateSequence();
            clientNo = sequenceMgr.getSequence();
            request.setAttribute("clientNo", clientNo);
        }
        else
        {
            String automatedClientNo = request.getParameter("automatedClientNo");

            if (automatedClientNo == null || automatedClientNo == "")
            {
                clientNo = request.getParameter("clientNO");

            }
            else
            {
                sequenceMgr.updateSequence();
                clientNo = sequenceMgr.getSequence();
            }
            request.setAttribute("clientNo", clientNo);
        }
        ///////////////////////////////////////////

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String clientNoByDate = null;

        String id = UniqueIDGen.getNextID();
        params.addElement(new StringValue(id));
        params.addElement(new StringValue(clientNo));
        params.addElement(new StringValue(request.getParameter("clientName")));
//        params.addElement(new StringValue(request.getParameter("gender")));
//        params.addElement(new StringValue(request.getParameter("matiralStatus")));
        if (request.getParameter("gender") != null && !request.getParameter("gender").isEmpty())
        {
            params.addElement(new StringValue(request.getParameter("gender")));
        }
        else
        {
            params.addElement(new StringValue(" "));
        }
        if (request.getParameter("matiralStatus") != null && !request.getParameter("matiralStatus").isEmpty())
        {
            params.addElement(new StringValue(request.getParameter("matiralStatus")));
        }
        else
        {
            params.addElement(new StringValue(" "));
        }

        if (request.getParameter("clientMobile") != null && !request.getParameter("clientMobile").isEmpty())
        {
            String mobile = request.getParameter("clientMobile");
            if (request.getParameter("internationalM") != null && !request.getParameter("internationalM").isEmpty())
            {
                mobile = request.getParameter("internationalM") + mobile;
            }
            params.addElement(new StringValue(mobile));
        }
        else
        {
            params.addElement(new StringValue(" "));
        }
//        params.addElement(new StringValue("xxxxxxxxx"));
        if (request.getParameter("phone") != null && !request.getParameter("phone").isEmpty())
        {
            String phone = request.getParameter("phone");
            if (request.getParameter("internationalP") != null && !request.getParameter("internationalP").isEmpty())
            {
                phone = request.getParameter("internationalP") + phone;
            }
            params.addElement(new StringValue(phone));
        }
        else
        {
            params.addElement(new StringValue(" "));
        }
        if (request.getParameter("clientSalary") != null && !request.getParameter("clientSalary").isEmpty())
        {
            params.addElement(new StringValue(request.getParameter("clientSalary")));
        }
        else
        {
            params.addElement(new StringValue("0"));
        }
        if (request.getParameter("address") != null && !request.getParameter("address").isEmpty())
        {
            params.addElement(new StringValue(request.getParameter("address")));
        }
        else
        {
            params.addElement(new StringValue(""));
        }
        if (request.getParameter("email") != null && !request.getParameter("email").isEmpty())
        {
            params.addElement(new StringValue(request.getParameter("email")));
        }
        else
        {
            params.addElement(new StringValue(""));
        }

        params.addElement(new StringValue("1"));
        clientStatus = "1";
        params.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
//        params.addElement(new StringValue("1"));
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new java.util.Date());
        clientNoByDate = (calendar.get(Calendar.MONTH) + 1) + "/" + calendar.get(Calendar.YEAR);
        params.addElement(new StringValue(clientNoByDate));

        if (request.getParameter("clientSsn") != null && !request.getParameter("clientSsn").isEmpty())
        {
            params.addElement(new StringValue(request.getParameter("clientSsn")));
        }
        else
        {
            params.addElement(new StringValue(""));
        }
        if (request.getAttribute("ageGroup") != null && !request.getAttribute("ageGroup").equals(""))
        {
            params.addElement(new StringValue(request.getAttribute("ageGroup").toString()));
        }
        else
        {
            params.addElement(new StringValue(request.getParameter("isSup")));
        }
        if (request.getParameter("partner") != null && !request.getParameter("partner").isEmpty())
        {
            params.addElement(new StringValue(request.getParameter("partner")));
        }
        else
        {
            params.addElement(new StringValue(request.getParameter("knowUsThrough")));
        }
        if (request.getParameter("jobTitle") != null && !request.getParameter("jobTitle").isEmpty())
        {
            params.addElement(new StringValue(request.getParameter("jobTitle")));
        }
        else
        {
            params.addElement(new StringValue("  "));
        }
        if (request.getParameter("workOut") != null && !request.getParameter("workOut").isEmpty())
        {
            params.addElement(new StringValue(request.getParameter("workOut")));
        }
        else
        {
            params.addElement(new StringValue("  "));
        }
        if (request.getParameter("kindred") != null && !request.getParameter("kindred").isEmpty())
        {
            params.addElement(new StringValue(request.getParameter("kindred")));
        }
        else
        {
            params.addElement(new StringValue("  "));
        }

         if (request.getParameter("knowUsThrough") != null && !request.getParameter("knowUsThrough").isEmpty())
        {
            params.addElement(new StringValue(request.getParameter("knowUsThrough")));
        }
        else
        {
            params.addElement(new StringValue("  "));
        }

      

        if (connectByRealEstate != null && !connectByRealEstate.equals("")
                && connectByRealEstate.equals("1"))
        {
            params.addElement(new StringValue(code));
            request.setAttribute("code", code);
        }
        else
        {
            params.addElement(new StringValue(clientNo));
            request.setAttribute("code", clientNoByDate);
        }
        if (request.getParameter("nationality") != null && !request.getParameter("nationality").equals(""))
        {
            params.addElement(new StringValue(request.getParameter("nationality")));
        }
        else
        {
            params.addElement(new StringValue(""));
        }
        params.addElement(new StringValue((String) request.getAttribute("regionTitle")));
        request.setAttribute("clientId", id);
        params.addElement(new StringValue("11"));// current status

        //Paramater No 24
        if (request.getParameter("description") != null && !request.getParameter("description").equals(""))
        {
            params.addElement(new StringValue(request.getParameter("description")));
        }
        else
        {
            params.addElement(new StringValue(" "));
        }
        params.addElement(new StringValue("UL"));
         if (request.getParameter("interNum") != null && !request.getParameter("interNum").equals(""))
        {
            params.addElement(new StringValue(request.getParameter("interNum")));
        }
        else
        {
            params.addElement(new StringValue(" "));
        }
       
//        Connection connection = null;
        try
        {
//            connection = dataSource.getConnection();
            beginTransaction();
//            connection.setAutoCommit(true);
            forInsert.setConnection(transConnection);
            String myQuery = getQuery("insertCompany").trim();
            forInsert.setSQLQuery(myQuery);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0)
            {
                transConnection.rollback();
                return false;

            }
            if (clientStatus.equals("1"))
            {
                params = new Vector();

                queryResult = -1000;

                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue("New"));
                params.addElement(new StringValue(id));
                params.addElement(new StringValue("No Description"));
                forInsert.setConnection(transConnection);
                forInsert.setSQLQuery(getQuery("insertInitialClientStatus").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();

                if (queryResult < 0)
                {
                    transConnection.rollback();
                    return false;
                }
                
                params = new Vector();

                queryResult = -1000;

                params.addElement(new StringValue(id));
                forInsert.setConnection(transConnection);
                forInsert.setSQLQuery(getQuery("updateNameProject").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();

                if (queryResult < 0) {
                    transConnection.rollback();
                    return false;
                }
            }

        }
        catch (SQLException se)
        {
            logger.error(se.getMessage());
            transConnection.rollback();
            return false;
//
        }
        finally
        {
            endTransaction();
        }

        //////////// Insert Client In Real Estate  //////
        if (connectByRealEstate != null && !connectByRealEstate.equals("")
                && connectByRealEstate.equals("1"))
        {
            int qryResult = -1000;
            if (queryResult > 0)
            {
                Vector SQLparams = new Vector();
                SQLparams.addElement(new StringValue(code));
                SQLparams.addElement(new StringValue(request.getParameter("clientName")));
                SQLparams.addElement(new StringValue(request.getParameter("clientName")));
                try
                {
                    Class.forName(driver);
                    conn = DriverManager.getConnection(URL, userName, password);
                    conn.setAutoCommit(false);
                    forInsert.setConnection(conn);
                    forInsert.setparams(SQLparams);
                    String myQuery = getQuery("saveClientInRealEstate").trim();
                    forInsert.setSQLQuery(myQuery);
                    qryResult = forInsert.executeUpdate();
                }
                catch (Exception se)
                {
                    logger.error("database error " + se.getMessage());
                }
                finally
                {
                    try
                    {
                        conn.commit();
                        conn.close();
                    }
                    catch (SQLException sex)
                    {
                        logger.error("troubles closing connection " + sex.getMessage());
                        return false;
                    }
                }
            }
        }
        //////////////////////////////////////////////////

        return (queryResult > 0);

    }
    
  public String  confirmClientLegalDispute(WebBusinessObject persistentUser,String clientID,String Reason)throws NoUserInSessionException, SQLException
  {
      Vector  parameters = new Vector();
      SQLCommandBean forInsert = new SQLCommandBean();
      int queryResult = -1000;
      Connection connection = null;
      try{
          String issueStatusId = UniqueIDGen.getNextID();
            parameters.addElement(new StringValue(issueStatusId));
            
            parameters.addElement(new StringValue("84"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue(Reason));
            parameters.addElement(new StringValue("0"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue(clientID));
            parameters.addElement(new StringValue("client"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
            connection = dataSource.getConnection();
            connection.setAutoCommit(true);
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insertClientStatus").trim());
            forInsert.setparams(parameters);
            queryResult = forInsert.executeUpdate();
 
        }
        catch (Exception ex)
        {
            logger.error(ex.getMessage());
            return "no";
        }
        finally
        {
            connection.close();

        }
      if(queryResult>0)
          return "ok";
          else
          return "no";
  }
  public String  updateClientStatusNew(String clientID,String Reason)throws NoUserInSessionException, SQLException
  {
      Vector  parameters = new Vector();
      SQLCommandBean forInsert = new SQLCommandBean();
      int queryResult = -1000;
      Connection connection = null;
      try{
            parameters.addElement(new StringValue(Reason));
            parameters.addElement(new StringValue(clientID));
            connection = dataSource.getConnection();
            connection.setAutoCommit(true);
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("updateClientStatus").trim());
            forInsert.setparams(parameters);
            queryResult = forInsert.executeUpdate();
 
        }
        catch (Exception ex)
        {
            logger.error(ex.getMessage());
            return "no";
        }
        finally
        {
            connection.close();

        }
      if(queryResult>0)
          return "ok";
          else
          return "no";
  }
public String  ReleaseClientLegalDispute(WebBusinessObject persistentUser,String clientID,String Reason)throws NoUserInSessionException, SQLException
  {
      Vector  parameters = new Vector();
      SQLCommandBean forInsert = new SQLCommandBean();
      int queryResult = -1000;
      Connection connection = null;
      try{
          String issueStatusId = UniqueIDGen.getNextID();
            parameters.addElement(new StringValue(issueStatusId));
            
            parameters.addElement(new StringValue("11"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue(Reason));
            parameters.addElement(new StringValue("0"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue(clientID));
            parameters.addElement(new StringValue("client"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
            connection = dataSource.getConnection();
            connection.setAutoCommit(true);
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insertClientStatus").trim());
            forInsert.setparams(parameters);
            queryResult = forInsert.executeUpdate();
 
        }
        catch (Exception ex)
        {
            logger.error(ex.getMessage());
            return "no";
        }
        finally
        {
            connection.close();

        }
      if(queryResult>0)
          return "ok";
          else
          return "no";
  }

  
  
    public synchronized boolean saveClientData(HttpServletRequest request, HttpSession s, WebBusinessObject persistentUser) throws NoUserInSessionException, SQLException
    {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String connectByRealEstate = metaDataMgr.getConnectByRealEstate();
        String code = null;
        String userName = null;
        String password = null;
        String driver = null;
        String URL = null;
        Connection conn = null;
        String clientNo = null;
        String clientStatus = null;
        SequenceMgr sequenceMgr = SequenceMgr.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        Calendar c = Calendar.getInstance();
//        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

    String automatedClientNo = request.getParameter("automatedClientNo");
            if (automatedClientNo == null || automatedClientNo == "")
            {
                clientNo = request.getParameter("clientNO");
            }
            else
            {
                sequenceMgr.updateSequence();
                clientNo = sequenceMgr.getSequence();
            }
        request.setAttribute("clientNo", clientNo);
        ///////////////////////////////////////////

        Vector parameters = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String clientNoByDate = null;
        String id = UniqueIDGen.getNextID();
        parameters.addElement(new StringValue(id));
        parameters.addElement(new StringValue(clientNo));
        parameters.addElement(new StringValue(request.getParameter("clientName").trim()));
        parameters.addElement(new StringValue(request.getParameter("gender")));
        if (request.getParameter("matiralStatus") != null && !(request.getParameter("matiralStatus").equals(""))){
        parameters.addElement(new StringValue(request.getParameter("matiralStatus")));
        } else{
        parameters.addElement(new StringValue("0"));
        }
        String mobile = " ";
        if (request.getParameter("clientMobile") != null && !request.getParameter("clientMobile").isEmpty())
        {
            mobile = request.getParameter("clientMobile");
            if (request.getParameter("phoneCount") != null && !request.getParameter("phoneCount").isEmpty())
            {
                mobile = request.getParameter("phoneCount") + mobile;
            }
        }
        parameters.addElement(new StringValue(mobile));

        String phone = " ";
        if (request.getParameter("phone") != null && !request.getParameter("phone").isEmpty())
        {
            phone = request.getParameter("phone");

            if (request.getParameter("localP") != null && !request.getParameter("localP").isEmpty())
            {
                phone = request.getParameter("localP") + phone;
            }
            if (request.getParameter("internationalP") != null && !request.getParameter("internationalP").isEmpty())
            {
                phone = request.getParameter("internationalP") + phone;

            }
        }
        parameters.addElement(new StringValue(phone));
        parameters.addElement(new StringValue(request.getParameter("clientSalary")));
        parameters.addElement(new StringValue(request.getParameter("address")));
        if (request.getParameter("email") != null && !request.getParameter("email").isEmpty())
        {
            parameters.addElement(new StringValue(request.getParameter("email")));
        }
        else
        {
            parameters.addElement(new StringValue(""));
        }
        if (request.getParameter("isActive") != null)
        {
            parameters.addElement(new StringValue("1"));
            clientStatus = "1";

        }
        else
        {
            parameters.addElement(new StringValue("0"));
            clientStatus = "0";
        }
        parameters.addElement(new StringValue((String) persistentUser.getAttribute("userId")));

        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new java.util.Date());
        clientNoByDate = (calendar.get(Calendar.MONTH) + 1) + "/" + calendar.get(Calendar.YEAR);
        parameters.addElement(new StringValue(clientNoByDate));
        parameters.addElement(new StringValue(request.getParameter("passport")));
        parameters.addElement(new StringValue(request.getParameter("age")));
        if (request.getParameter("partner") != null && !request.getParameter("partner").isEmpty())
        {
            parameters.addElement(new StringValue(request.getParameter("partner")));
        }
        else
        {
            parameters.addElement(new StringValue("  "));
        }

        parameters.addElement(new StringValue(request.getParameter("job")));
        parameters.addElement(new StringValue(request.getParameter("workOut")));//option1

        //option2 -- Save Company ID insted of Relatives Abrod
        UserCompaniesMgr userCompanyMgr = UserCompaniesMgr.getInstance();
        WebBusinessObject userCompanyWbo = userCompanyMgr.getOnSingleKey("key1", persistentUser.getAttribute("userId").toString());
        if (userCompanyWbo != null)
        {
            parameters.addElement(new StringValue(userCompanyWbo.getAttribute("companyID").toString()));
        }
        else
        {
            parameters.addElement(new StringValue(request.getParameter("kindred")));
        }
        //parameters.addElement(new StringValue(request.getParameter("kindred")));

        parameters.addElement(new StringValue(request.getParameter("dialedNumber")));//option3

        if (connectByRealEstate != null && !connectByRealEstate.equals("")
                && connectByRealEstate.equals("1"))
        {
            parameters.addElement(new StringValue(code));
            request.setAttribute("code", code);
            }
        else
        {
            parameters.addElement(new StringValue(clientNo));
            request.setAttribute("code", clientNoByDate);
            }
        if (request.getParameter("nationality") != null && !request.getParameter("nationality").equals(""))
        {
            parameters.addElement(new StringValue(request.getParameter("nationality")));
        }
        else
        {
            parameters.addElement(new StringValue(""));
        }
        parameters.addElement(new StringValue((String) request.getAttribute("regionTitle")));
        try
        {
            parameters.addElement(new DateValue(new java.sql.Date(sdf.parse(request.getParameter("birthDate")).getTime())));
        }
        catch (ParseException | NullPointerException ex)
        {
            parameters.addElement(new DateValue(new java.sql.Date(c.getTimeInMillis())));
        }
        parameters.addElement(new StringValue("12"));

        request.setAttribute("clientId", id);
        if (request.getParameter("description") != null && !request.getParameter("description").equals(""))
        {
            parameters.addElement(new StringValue(request.getParameter("description")));
        }
        else
        {
            parameters.addElement(new StringValue(" "));
        }
        if (request.getParameter("clientBranch") != null && !request.getParameter("clientBranch").equals(""))
        {
            parameters.addElement(new StringValue(request.getParameter("clientBranch")));
        }
        else
        {
            parameters.addElement(new StringValue(" "));
        }
        parameters.addElement(new StringValue(request.getParameter("interPhone")));

//        Connection connection = null;
        try
        {
//            connection = dataSource.getConnection();
            beginTransaction();
//            connection.setAutoCommit(true);
            forInsert.setConnection(transConnection);
            String myQuery = getQuery("insertClient").trim();
            forInsert.setSQLQuery(myQuery);
            forInsert.setparams(parameters);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0)
            {
                transConnection.rollback();
                return false;

            }
            if (clientStatus.equals("1"))
            {
                parameters = new Vector();

                queryResult = -1000;

                parameters.addElement(new StringValue(UniqueIDGen.getNextID()));
                parameters.addElement(new StringValue("New"));
                parameters.addElement(new StringValue(id));
                parameters.addElement(new StringValue("No Description"));

                forInsert.setConnection(transConnection);
                forInsert.setSQLQuery(getQuery("insertInitialClientStatus").trim());
                forInsert.setparams(parameters);
                queryResult = forInsert.executeUpdate();

                if (queryResult < 0)
                {
                    transConnection.rollback();
                    return false;

                }
            }

            parameters = new Vector();

            String issueStatusId = UniqueIDGen.getNextID();
            parameters.addElement(new StringValue(issueStatusId));
            // 'lead' for new clinet
            parameters.addElement(new StringValue("12"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue("0"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue(id));
            parameters.addElement(new StringValue("client"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue((String) persistentUser.getAttribute("userId")));

            forInsert.setSQLQuery(getQuery("insertClientStatus").trim());
            forInsert.setparams(parameters);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0)
            {
                transConnection.rollback();
                return false;
            }
        }
        catch (SQLException se)
        {
            logger.error(se.getMessage());
            transConnection.rollback();
            return false;

        }
        finally
        {
            endTransaction();
        }

        //////////// Insert Client In Real Estate  //////
        if (connectByRealEstate != null && !connectByRealEstate.equals("") && connectByRealEstate.equals("1"))
        {
            int qryResult = -1000;
            if (queryResult > 0)
            {
                Vector SQLparams = new Vector();
                SQLparams.addElement(new StringValue(code));
                SQLparams.addElement(new StringValue(request.getParameter("clientName")));
                SQLparams.addElement(new StringValue(request.getParameter("clientName")));
                try
                {
                    Class.forName(driver);
                    conn = DriverManager.getConnection(URL, userName, password);
                    conn.setAutoCommit(false);
                    forInsert.setConnection(conn);
                    forInsert.setparams(SQLparams);
                    String myQuery = getQuery("saveClientInRealEstate").trim();
                    forInsert.setSQLQuery(myQuery);
                    qryResult = forInsert.executeUpdate();
                }
                catch (ClassNotFoundException se)
                {
                    logger.error("database error " + se.getMessage());
                }
                catch (SQLException se)
                {
                    logger.error("database error " + se.getMessage());
                }
                finally
                {
                    try
                    {
                        conn.commit();
                        conn.close();
                    }
                    catch (SQLException sex)
                    {
                        logger.error("troubles closing connection " + sex.getMessage());
                        return false;
                    }
                }
            }
        }
        //////////////////////////////////////////////////

        return (queryResult > 0);
    }
    
    
        public synchronized boolean saveClientData5(HttpServletRequest request, HttpSession s, WebBusinessObject persistentUser,String oldClientID) throws NoUserInSessionException, SQLException
    {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String connectByRealEstate = metaDataMgr.getConnectByRealEstate();
        String code = null;
        String userName = null;
        String password = null;
        String driver = null;
        String URL = null;
        Connection conn = null;
        String clientNo = null;
        String clientStatus = null;
        SequenceMgr sequenceMgr = SequenceMgr.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        Calendar c = Calendar.getInstance();
//        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

    String automatedClientNo = request.getParameter("automatedClientNo");
            if (automatedClientNo == null || automatedClientNo == "")
            {
                clientNo = request.getParameter("clientNO");
            }
            else
            {
                sequenceMgr.updateSequence();
                clientNo = sequenceMgr.getSequence();
            }
        request.setAttribute("clientNo", clientNo);
        ///////////////////////////////////////////

        Vector parameters = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String clientNoByDate = null;
        String id = UniqueIDGen.getNextID();
        parameters.addElement(new StringValue(id));
        parameters.addElement(new StringValue(clientNo));
        parameters.addElement(new StringValue(request.getParameter("clientName").trim()));
        parameters.addElement(new StringValue(request.getParameter("gender")));
        if (request.getParameter("matiralStatus") != null && !(request.getParameter("matiralStatus").equals(""))){
        parameters.addElement(new StringValue(request.getParameter("matiralStatus")));
        } else{
        parameters.addElement(new StringValue("0"));
        }
        String mobile = " ";
        if (request.getParameter("clientMobile") != null && !request.getParameter("clientMobile").isEmpty())
        {
            mobile = request.getParameter("clientMobile");
            if (request.getParameter("phoneCount") != null && !request.getParameter("phoneCount").isEmpty())
            {
                mobile = request.getParameter("phoneCount") + mobile;
            }
        }
        parameters.addElement(new StringValue(mobile));

        String phone = " ";
        if (request.getParameter("phone") != null && !request.getParameter("phone").isEmpty())
        {
            phone = request.getParameter("phone");

            if (request.getParameter("localP") != null && !request.getParameter("localP").isEmpty())
            {
                phone = request.getParameter("localP") + phone;
            }
            if (request.getParameter("internationalP") != null && !request.getParameter("internationalP").isEmpty())
            {
                phone = request.getParameter("internationalP") + phone;

            }
        }
        parameters.addElement(new StringValue(phone));
        parameters.addElement(new StringValue(request.getParameter("clientSalary")));
        parameters.addElement(new StringValue(request.getParameter("address")));
        if (request.getParameter("email") != null && !request.getParameter("email").isEmpty())
        {
            parameters.addElement(new StringValue(request.getParameter("email")));
        }
        else
        {
            parameters.addElement(new StringValue(""));
        }
        if (request.getParameter("isActive") != null)
        {
            parameters.addElement(new StringValue("1"));
            clientStatus = "1";

        }
        else
        {
            parameters.addElement(new StringValue("0"));
            clientStatus = "0";
        }
        parameters.addElement(new StringValue((String) persistentUser.getAttribute("userId")));

        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new java.util.Date());
        clientNoByDate = (calendar.get(Calendar.MONTH) + 1) + "/" + calendar.get(Calendar.YEAR);
        parameters.addElement(new StringValue(clientNoByDate));
        parameters.addElement(new StringValue(request.getParameter("passport")));
        parameters.addElement(new StringValue(request.getParameter("age")));
        if (request.getParameter("partner") != null && !request.getParameter("partner").isEmpty())
        {
            parameters.addElement(new StringValue(request.getParameter("partner")));
        }
        else
        {
            parameters.addElement(new StringValue("  "));
        }

        parameters.addElement(new StringValue(request.getParameter("job")));
        parameters.addElement(new StringValue(request.getParameter("workOut")));//option1

        //option2 -- Save Company ID insted of Relatives Abrod
        UserCompaniesMgr userCompanyMgr = UserCompaniesMgr.getInstance();
        WebBusinessObject userCompanyWbo = userCompanyMgr.getOnSingleKey("key1", persistentUser.getAttribute("userId").toString());
        if (userCompanyWbo != null)
        {
            parameters.addElement(new StringValue(userCompanyWbo.getAttribute("companyID").toString()));
        }
        else
        {
            parameters.addElement(new StringValue(request.getParameter("kindred")));
        }
        //parameters.addElement(new StringValue(request.getParameter("kindred")));

        parameters.addElement(new StringValue(request.getParameter("dialedNumber")));//option3

        if (connectByRealEstate != null && !connectByRealEstate.equals("")
                && connectByRealEstate.equals("1"))
        {
            if(oldClientID.equals(null)){

            parameters.addElement(new StringValue(code));
            request.setAttribute("code", code);
        }else {
                        parameters.addElement(new StringValue(oldClientID));
            }
            
            }
        else
        {
            if(oldClientID.equals(null)){
            parameters.addElement(new StringValue(clientNo));
            request.setAttribute("code", clientNoByDate);
            }else {
                        parameters.addElement(new StringValue(oldClientID));
            }
        
            }
        if (request.getParameter("nationality") != null && !request.getParameter("nationality").equals(""))
        {
            parameters.addElement(new StringValue(request.getParameter("nationality")));
        }
        else
        {
            parameters.addElement(new StringValue(""));
        }
        parameters.addElement(new StringValue((String) request.getAttribute("regionTitle")));
        try
        {
            parameters.addElement(new DateValue(new java.sql.Date(sdf.parse(request.getParameter("birthDate")).getTime())));
        }
        catch (ParseException | NullPointerException ex)
        {
            parameters.addElement(new DateValue(new java.sql.Date(c.getTimeInMillis())));
        }
        parameters.addElement(new StringValue("12"));

        request.setAttribute("clientId", id);
        if (request.getParameter("description") != null && !request.getParameter("description").equals(""))
        {
            parameters.addElement(new StringValue(request.getParameter("description")));
        }
        else
        {
            parameters.addElement(new StringValue(" "));
        }
        if (request.getParameter("clientBranch") != null && !request.getParameter("clientBranch").equals(""))
        {
            parameters.addElement(new StringValue(request.getParameter("clientBranch")));
        }
        else
        {
            parameters.addElement(new StringValue(" "));
        }
        parameters.addElement(new StringValue(request.getParameter("interPhone")));

//        Connection connection = null;
        try
        {
//            connection = dataSource.getConnection();
            beginTransaction();
//            connection.setAutoCommit(true);
            forInsert.setConnection(transConnection);
            String myQuery = getQuery("insertClient").trim();
            forInsert.setSQLQuery(myQuery);
            forInsert.setparams(parameters);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0)
            {
                transConnection.rollback();
                return false;

            }
            if (clientStatus.equals("1"))
            {
                parameters = new Vector();

                queryResult = -1000;

                parameters.addElement(new StringValue(UniqueIDGen.getNextID()));
                parameters.addElement(new StringValue("New"));
                parameters.addElement(new StringValue(id));
                parameters.addElement(new StringValue("No Description"));

                forInsert.setConnection(transConnection);
                forInsert.setSQLQuery(getQuery("insertInitialClientStatus").trim());
                forInsert.setparams(parameters);
                queryResult = forInsert.executeUpdate();

                if (queryResult < 0)
                {
                    transConnection.rollback();
                    return false;

                }
            }

            parameters = new Vector();

            String issueStatusId = UniqueIDGen.getNextID();
            parameters.addElement(new StringValue(issueStatusId));
            // 'lead' for new clinet
            parameters.addElement(new StringValue("12"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue("0"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue(id));
            parameters.addElement(new StringValue("client"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue((String) persistentUser.getAttribute("userId")));

            forInsert.setSQLQuery(getQuery("insertClientStatus").trim());
            forInsert.setparams(parameters);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0)
            {
                transConnection.rollback();
                return false;
            }
        }
        catch (SQLException se)
        {
            logger.error(se.getMessage());
            transConnection.rollback();
            return false;

        }
        finally
        {
            endTransaction();
        }

        //////////// Insert Client In Real Estate  //////
        if (connectByRealEstate != null && !connectByRealEstate.equals("") && connectByRealEstate.equals("1"))
        {
            int qryResult = -1000;
            if (queryResult > 0)
            {
                Vector SQLparams = new Vector();
                SQLparams.addElement(new StringValue(code));
                SQLparams.addElement(new StringValue(request.getParameter("clientName")));
                SQLparams.addElement(new StringValue(request.getParameter("clientName")));
                try
                {
                    Class.forName(driver);
                    conn = DriverManager.getConnection(URL, userName, password);
                    conn.setAutoCommit(false);
                    forInsert.setConnection(conn);
                    forInsert.setparams(SQLparams);
                    String myQuery = getQuery("saveClientInRealEstate").trim();
                    forInsert.setSQLQuery(myQuery);
                    qryResult = forInsert.executeUpdate();
                }
                catch (ClassNotFoundException se)
                {
                    logger.error("database error " + se.getMessage());
                }
                catch (SQLException se)
                {
                    logger.error("database error " + se.getMessage());
                }
                finally
                {
                    try
                    {
                        conn.commit();
                        conn.close();
                    }
                    catch (SQLException sex)
                    {
                        logger.error("troubles closing connection " + sex.getMessage());
                        return false;
                    }
                }
            }
        }
        //////////////////////////////////////////////////

        return (queryResult > 0);
    }

    ////////////////////////////////////////////////////////////////

    public boolean saveClientRealState(HttpServletRequest request, HttpSession s, WebBusinessObject persistentUser) throws NoUserInSessionException, SQLException
    {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String connectByRealEstate = metaDataMgr.getConnectByRealEstate();
        String code = null;
        String userName = null;
        String password = null;
        String driver = null;
        String URL = null;
        Connection conn = null;
        String clientNo = null;
        String clientNoRealState = null;
//        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String clientStatus = null;
        boolean excuteQuery = false;
        SequenceMgr sequenceMgr = SequenceMgr.getInstance();
        /////////// Get Client date from Real Estate ////////////

        userName = metaDataMgr.getRealEstateName();
        password = metaDataMgr.getRealEstatePassword();
        driver = metaDataMgr.getDriverErp();
        URL = metaDataMgr.getDataBaseErpUrl();
        Vector queryRsult = new Vector();
        Vector parameter = new Vector();

        SQLCommandBean forQuery = new SQLCommandBean();

        String automatedClientNo = request.getParameter("automatedClientNo");

        if (automatedClientNo == null || automatedClientNo == "")
        {
            clientNoRealState = (String) request.getParameter("clientNO");

            try
            {
                parameter.add(new StringValue(clientNoRealState));
                Class.forName(driver);
                conn = DriverManager.getConnection(URL, userName, password);
                conn.setAutoCommit(false);
                forQuery.setConnection(conn);
                forQuery.setparams(parameter);
                String myQuery = getQuery("checkCodeUnique").trim();
                forQuery.setSQLQuery(myQuery);
                queryRsult = forQuery.executeQuery();

                if (queryRsult.size() > 0)
                {
                    excuteQuery = false;

                }
                else
                {
                    excuteQuery = true;

                    String str0 = "";
                    for (int x = clientNoRealState.length(); x < 8; x++)
                    {
                        str0 = str0 + "0";
                    }
                    code = str0 + clientNoRealState;

                    sequenceMgr.updateSequence();
                    clientNo = sequenceMgr.getSequence();
                    Vector params = new Vector();
                    SQLCommandBean forInsert = new SQLCommandBean();
                    int queryResult = -1000;
                    String clientNoByDate = null;

                    String id = UniqueIDGen.getNextID();
                    params.addElement(new StringValue(id));
                    params.addElement(new StringValue(clientNo));
                    params.addElement(new StringValue(request.getParameter("clientName")));
                    params.addElement(new StringValue(request.getParameter("gender")));
                    params.addElement(new StringValue(request.getParameter("matiralStatus")));

                    if (request.getParameter("clientMobile") != null && !request.getParameter("clientMobile").isEmpty())
                    {
                        params.addElement(new StringValue(request.getParameter("clientMobile")));
                    }
                    else
                    {
                        params.addElement(new StringValue(" "));
                    }
//        params.addElement(new StringValue("xxxxxxxxx"));
                    if (request.getParameter("phone") != null && !request.getParameter("phone").isEmpty())
                    {
                        params.addElement(new StringValue(request.getParameter("phone")));
                    }
                    else
                    {
                        params.addElement(new StringValue(" "));
                    }
                    if (request.getParameter("clientSalary") != null && !request.getParameter("clientSalary").isEmpty())
                    {
                        params.addElement(new StringValue(request.getParameter("clientSalary")));
                    }
                    else
                    {
                        params.addElement(new StringValue(""));
                    }
                    if (request.getParameter("address") != null && !request.getParameter("address").isEmpty())
                    {
                        params.addElement(new StringValue(request.getParameter("address")));
                    }
                    else
                    {
                        params.addElement(new StringValue(""));
                    }
                    if (request.getParameter("email") != null && !request.getParameter("email").isEmpty())
                    {
                        params.addElement(new StringValue(request.getParameter("email")));
                    }
                    else
                    {
                        params.addElement(new StringValue(""));
                    }

                    if (request.getParameter("isActive") != null)
                    {
                        params.addElement(new StringValue("1"));
                        clientStatus = "1";

                    }
                    else
                    {
                        params.addElement(new StringValue("0"));
                        clientStatus = "0";
                    }
                    params.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
//        params.addElement(new StringValue("1"));
                    Calendar calendar = Calendar.getInstance();
                    calendar.setTime(new java.util.Date());
                    clientNoByDate = (calendar.get(Calendar.MONTH) + 1) + "/" + calendar.get(Calendar.YEAR);
                    params.addElement(new StringValue(clientNoByDate));

                    if (request.getParameter("clientSsn") != null && !request.getParameter("clientSsn").isEmpty())
                    {
                        params.addElement(new StringValue(request.getParameter("clientSsn")));
                    }
                    else
                    {
                        params.addElement(new StringValue(""));
                    }
                    if (request.getParameter("age") != null && !request.getParameter("age").isEmpty())
                    {
                        params.addElement(new StringValue(request.getParameter("age")));
                    }
                    else
                    {
                        params.addElement(new StringValue("20-30"));
                    }
                    if (request.getParameter("partner") != null && !request.getParameter("partner").isEmpty())
                    {
                        params.addElement(new StringValue(request.getParameter("partner")));
                    }
                    else
                    {
                        params.addElement(new StringValue("  "));
                    }

                    params.addElement(new StringValue((String) request.getAttribute("jobTitle")));

                    params.addElement(new StringValue(request.getParameter("workOut")));//option1
                    params.addElement(new StringValue(request.getParameter("kindred")));//option2
                    params.addElement(new StringValue(""));//option3

                    if (connectByRealEstate != null && !connectByRealEstate.equals("")
                            && connectByRealEstate.equals("1"))
                    {
                        params.addElement(new StringValue(code));
                        request.setAttribute("code", code);
                    }
                    else
                    {
                        params.addElement(new StringValue(clientNo));
                        request.setAttribute("code", clientNoByDate);
                    }

                    request.setAttribute("clientId", id);
                    params.addElement(new StringValue(""));//interPhone
//        Connection connection = null;
                    try
                    {
//            connection = dataSource.getConnection();
                        beginTransaction();
//            connection.setAutoCommit(true);
                        forInsert.setConnection(transConnection);
                        myQuery = getQuery("insertClient").trim();
                        forInsert.setSQLQuery(myQuery);
                        forInsert.setparams(params);
                        queryResult = forInsert.executeUpdate();

                        if (queryResult < 0)
                        {
                            transConnection.rollback();
                            return false;

                        }
                        if (clientStatus.equals("1"))
                        {
                            params = new Vector();

                            queryResult = -1000;

                            params.addElement(new StringValue(UniqueIDGen.getNextID()));
                            params.addElement(new StringValue("New"));
                            params.addElement(new StringValue(id));
                            params.addElement(new StringValue("No Description"));
                            forInsert.setConnection(transConnection);
                            forInsert.setSQLQuery(getQuery("insertInitialClientStatus").trim());
                            forInsert.setparams(params);
                            queryResult = forInsert.executeUpdate();

                            if (queryResult < 0)
                            {
                                transConnection.rollback();
                                return false;
                            }
                        }

                    }
                    catch (SQLException se)
                    {
                        logger.error(se.getMessage());
                        transConnection.rollback();
                        return false;
//
                    }
                    finally
                    {
                        endTransaction();
                    }

                    //////////// Insert Client In Real Estate  //////
                    if (connectByRealEstate != null && !connectByRealEstate.equals("")
                            && connectByRealEstate.equals("1"))
                    {
                        int qryResult = -1000;
                        if (queryResult > 0)
                        {
                            Vector SQLparams = new Vector();
                            SQLparams.addElement(new StringValue(code));
                            SQLparams.addElement(new StringValue(request.getParameter("clientName")));
                            SQLparams.addElement(new StringValue(request.getParameter("clientName")));
                            try
                            {
                                Class.forName(driver);
                                conn = DriverManager.getConnection(URL, userName, password);
                                conn.setAutoCommit(false);
                                forInsert.setConnection(conn);
                                forInsert.setparams(SQLparams);
                                myQuery = getQuery("saveClientInRealEstate").trim();
                                forInsert.setSQLQuery(myQuery);
                                qryResult = forInsert.executeUpdate();
                            }
                            catch (Exception se)
                            {
                                logger.error("database error " + se.getMessage());
                            }
                            finally
                            {
                                try
                                {
                                    conn.commit();
                                    conn.close();
                                }
                                catch (SQLException sex)
                                {
                                    logger.error("troubles closing connection " + sex.getMessage());
                                    return false;
                                }
                            }
                        }
                    }
                }

            }
            catch (Exception se)
            {

                logger.error("database error " + se.getMessage());
                return false;
            }
            return excuteQuery;
        }
        else
        {
            return saveClient(request, s, persistentUser);
        }

    }

    public boolean saveCompanyRealState(HttpServletRequest request, HttpSession s, WebBusinessObject persistentUser) throws NoUserInSessionException, SQLException
    {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String connectByRealEstate = metaDataMgr.getConnectByRealEstate();
        String code = null;
        String userName = null;
        String password = null;
        String driver = null;
        String URL = null;
        Connection conn = null;
        String clientNo = null;
        String clientNoRealState = null;
//        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String clientStatus = null;
        boolean excuteQuery = false;
        SequenceMgr sequenceMgr = SequenceMgr.getInstance();
        /////////// Get Client date from Real Estate ////////////

        userName = metaDataMgr.getRealEstateName();
        password = metaDataMgr.getRealEstatePassword();
        driver = metaDataMgr.getDriverErp();
        URL = metaDataMgr.getDataBaseErpUrl();
        Vector queryRsult = new Vector();
        Vector parameter = new Vector();

        SQLCommandBean forQuery = new SQLCommandBean();

        String automatedClientNo = request.getParameter("automatedClientNo");

        if (automatedClientNo == null || automatedClientNo == "")
        {
            clientNoRealState = (String) request.getParameter("clientNO");

            try
            {
                parameter.add(new StringValue(clientNoRealState));
                Class.forName(driver);
                conn = DriverManager.getConnection(URL, userName, password);
                conn.setAutoCommit(false);
                forQuery.setConnection(conn);
                forQuery.setparams(parameter);
                String myQuery = getQuery("checkCodeUnique").trim();
                forQuery.setSQLQuery(myQuery);
                queryRsult = forQuery.executeQuery();

                if (queryRsult.size() > 0)
                {
                    excuteQuery = false;

                }
                else
                {
                    excuteQuery = true;

                    String str0 = "";
                    for (int x = clientNoRealState.length(); x < 8; x++)
                    {
                        str0 = str0 + "0";
                    }
                    code = str0 + clientNoRealState;

                    sequenceMgr.updateSequence();
                    clientNo = sequenceMgr.getSequence();
                    Vector params = new Vector();
                    SQLCommandBean forInsert = new SQLCommandBean();
                    int queryResult = -1000;
                    String clientNoByDate = null;

                    String id = UniqueIDGen.getNextID();
                    params.addElement(new StringValue(id));
                    params.addElement(new StringValue(clientNo));
                    params.addElement(new StringValue(request.getParameter("clientName")));
                    params.addElement(new StringValue(request.getParameter("gender")));
                    params.addElement(new StringValue(request.getParameter("matiralStatus")));

                    if (request.getParameter("clientMobile") != null && !request.getParameter("clientMobile").isEmpty())
                    {
                        params.addElement(new StringValue(request.getParameter("clientMobile")));
                    }
                    else
                    {
                        params.addElement(new StringValue(" "));
                    }
//        params.addElement(new StringValue("xxxxxxxxx"));
                    if (request.getParameter("phone") != null && !request.getParameter("phone").isEmpty())
                    {
                        params.addElement(new StringValue(request.getParameter("phone")));
                    }
                    else
                    {
                        params.addElement(new StringValue(" "));
                    }
                    if (request.getParameter("clientSalary") != null && !request.getParameter("clientSalary").isEmpty())
                    {
                        params.addElement(new StringValue(request.getParameter("clientSalary")));
                    }
                    else
                    {
                        params.addElement(new StringValue(""));
                    }
                    if (request.getParameter("address") != null && !request.getParameter("address").isEmpty())
                    {
                        params.addElement(new StringValue(request.getParameter("address")));
                    }
                    else
                    {
                        params.addElement(new StringValue(""));
                    }
                    if (request.getParameter("email") != null && !request.getParameter("email").isEmpty())
                    {
                        params.addElement(new StringValue(request.getParameter("email")));
                    }
                    else
                    {
                        params.addElement(new StringValue(""));
                    }

                    if (request.getParameter("isActive") != null)
                    {
                        params.addElement(new StringValue("1"));
                        clientStatus = "1";

                    }
                    else
                    {
                        params.addElement(new StringValue("0"));
                        clientStatus = "0";
                    }
                    params.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
//        params.addElement(new StringValue("1"));
                    Calendar calendar = Calendar.getInstance();
                    calendar.setTime(new java.util.Date());
                    clientNoByDate = (calendar.get(Calendar.MONTH) + 1) + "/" + calendar.get(Calendar.YEAR);
                    params.addElement(new StringValue(clientNoByDate));

                    if (request.getParameter("clientSsn") != null && !request.getParameter("clientSsn").isEmpty())
                    {
                        params.addElement(new StringValue(request.getParameter("clientSsn")));
                    }
                    else
                    {
                        params.addElement(new StringValue(""));
                    }
                    if (request.getParameter("age") != null && !request.getParameter("age").isEmpty())
                    {
                        params.addElement(new StringValue(request.getParameter("age")));
                    }
                    else
                    {
                        params.addElement(new StringValue("20-30"));
                    }
                    if (request.getParameter("partner") != null && !request.getParameter("partner").isEmpty())
                    {
                        params.addElement(new StringValue(request.getParameter("partner")));
                    }
                    else
                    {
                        params.addElement(new StringValue("  "));
                    }

                    params.addElement(new StringValue((String) request.getAttribute("jobTitle")));

                    params.addElement(new StringValue(request.getParameter("workOut")));//option1
                    params.addElement(new StringValue(request.getParameter("kindred")));//option2
                    params.addElement(new StringValue(""));//option3

                    if (connectByRealEstate != null && !connectByRealEstate.equals("")
                            && connectByRealEstate.equals("1"))
                    {
                        params.addElement(new StringValue(code));
                        request.setAttribute("code", code);
                    }
                    else
                    {
                        params.addElement(new StringValue(clientNo));
                        request.setAttribute("code", clientNoByDate);
                    }

                    request.setAttribute("clientId", id);
                    params.addElement(new StringValue(request.getParameter("")));//interPhone
//        Connection connection = null;
                    try
                    {
//            connection = dataSource.getConnection();
                        beginTransaction();
//            connection.setAutoCommit(true);
                        forInsert.setConnection(transConnection);
                        myQuery = getQuery("insertClient").trim();
                        forInsert.setSQLQuery(myQuery);
                        forInsert.setparams(params);
                        queryResult = forInsert.executeUpdate();

                        if (queryResult < 0)
                        {
                            transConnection.rollback();
                            return false;

                        }
                        if (clientStatus.equals("1"))
                        {
                            params = new Vector();

                            queryResult = -1000;

                            params.addElement(new StringValue(UniqueIDGen.getNextID()));
                            params.addElement(new StringValue("New"));
                            params.addElement(new StringValue(id));
                            params.addElement(new StringValue("No Description"));
                            forInsert.setConnection(transConnection);
                            forInsert.setSQLQuery(getQuery("insertInitialClientStatus").trim());
                            forInsert.setparams(params);
                            queryResult = forInsert.executeUpdate();

                            if (queryResult < 0)
                            {
                                transConnection.rollback();
                                return false;
                            }
                        }

                    }
                    catch (SQLException se)
                    {
                        logger.error(se.getMessage());
                        transConnection.rollback();
                        return false;
//
                    }
                    finally
                    {
                        endTransaction();
                    }

                    //////////// Insert Client In Real Estate  //////
                    if (connectByRealEstate != null && !connectByRealEstate.equals("")
                            && connectByRealEstate.equals("1"))
                    {
                        int qryResult = -1000;
                        if (queryResult > 0)
                        {
                            Vector SQLparams = new Vector();
                            SQLparams.addElement(new StringValue(code));
                            SQLparams.addElement(new StringValue(request.getParameter("clientName")));
                            SQLparams.addElement(new StringValue(request.getParameter("clientName")));
                            try
                            {
                                Class.forName(driver);
                                conn = DriverManager.getConnection(URL, userName, password);
                                conn.setAutoCommit(false);
                                forInsert.setConnection(conn);
                                forInsert.setparams(SQLparams);
                                myQuery = getQuery("saveClientInRealEstate").trim();
                                forInsert.setSQLQuery(myQuery);
                                qryResult = forInsert.executeUpdate();
                            }
                            catch (Exception se)
                            {
                                logger.error("database error " + se.getMessage());
                            }
                            finally
                            {
                                try
                                {
                                    conn.commit();
                                    conn.close();
                                }
                                catch (SQLException sex)
                                {
                                    logger.error("troubles closing connection " + sex.getMessage());
                                    return false;
                                }
                            }
                        }
                    }
                }

            }
            catch (Exception se)
            {

                logger.error("database error " + se.getMessage());
                return false;
            }
            return excuteQuery;
        }
        else
        {
            return saveClient(request, s, persistentUser);
        }

    }
    ////////////////////////////////////////////////////////////////

    public boolean saveClientRealState2(HttpServletRequest request, HttpSession s, WebBusinessObject persistentUser) throws NoUserInSessionException, SQLException
    {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String connectByRealEstate = metaDataMgr.getConnectByRealEstate();
        String code = null;
        String userName = null;
        String password = null;
        String driver = null;
        String URL = null;
        Connection conn = null;
        String clientNo = null;
        String clientNoRealState = null;
//        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String clientStatus = null;
        boolean excuteQuery = false;
        SequenceMgr sequenceMgr = SequenceMgr.getInstance();
        /////////// Get Client date from Real Estate ////////////

        userName = metaDataMgr.getRealEstateName();
        password = metaDataMgr.getRealEstatePassword();
        driver = metaDataMgr.getDriverErp();
        URL = metaDataMgr.getDataBaseErpUrl();
        Vector queryRsult = new Vector();
        Vector parameter = new Vector();

        SQLCommandBean forQuery = new SQLCommandBean();

        String automatedClientNo = request.getParameter("automatedClientNo");

        if (automatedClientNo == null || automatedClientNo == "")
        {
            clientNoRealState = (String) request.getParameter("clientNO");

            try
            {
                parameter.add(new StringValue(clientNoRealState));
                Class.forName(driver);
                conn = DriverManager.getConnection(URL, userName, password);
                conn.setAutoCommit(false);
                forQuery.setConnection(conn);
                forQuery.setparams(parameter);
                String myQuery = getQuery("checkCodeUnique").trim();
                forQuery.setSQLQuery(myQuery);
                queryRsult = forQuery.executeQuery();

                if (queryRsult.size() > 0)
                {
                    excuteQuery = false;

                }
                else
                {
                    excuteQuery = true;

                    String str0 = "";
                    for (int x = clientNoRealState.length(); x < 8; x++)
                    {
                        str0 = str0 + "0";
                    }
                    code = str0 + clientNoRealState;

                    sequenceMgr.updateSequence();
                    clientNo = sequenceMgr.getSequence();
                    Vector params = new Vector();
                    SQLCommandBean forInsert = new SQLCommandBean();
                    int queryResult = -1000;
                    String clientNoByDate = null;
                    String id = UniqueIDGen.getNextID();
                    params.addElement(new StringValue(id));
                    params.addElement(new StringValue(clientNo));
                    params.addElement(new StringValue(request.getParameter("clientName")));
                    params.addElement(new StringValue(request.getParameter("gender")));
                    params.addElement(new StringValue(request.getParameter("matiralStatus")));
                    if (request.getParameter("clientMobile") != null && !request.getParameter("clientMobile").isEmpty())
                    {
                        params.addElement(new StringValue(request.getParameter("clientMobile")));
                    }
                    else
                    {
                        params.addElement(new StringValue(" "));
                    }
                    if (request.getParameter("phone") != null && !request.getParameter("phone").isEmpty())
                    {
                        params.addElement(new StringValue(request.getParameter("phone")));
                    }
                    else
                    {
                        params.addElement(new StringValue(" "));
                    }
                    params.addElement(new StringValue(request.getParameter("clientSalary")));

                    params.addElement(new StringValue(request.getParameter("address")));

                    if (request.getParameter("email") != null && !request.getParameter("email").isEmpty())
                    {
                        params.addElement(new StringValue(request.getParameter("email")));
                    }
                    else
                    {
                        params.addElement(new StringValue(""));
                    }
                    if (request.getParameter("isActive") != null)
                    {
                        params.addElement(new StringValue("1"));
                        clientStatus = "1";

                    }
                    else
                    {
                        params.addElement(new StringValue("0"));
                        clientStatus = "0";
                    }
                    params.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
//        params.addElement(new StringValue("1"));
                    Calendar calendar = Calendar.getInstance();
                    calendar.setTime(new java.util.Date());
                    clientNoByDate = (calendar.get(Calendar.MONTH) + 1) + "/" + calendar.get(Calendar.YEAR);
                    params.addElement(new StringValue(clientNoByDate));

                    params.addElement(new StringValue(request.getParameter("clientSsn")));
                    params.addElement(new StringValue(request.getParameter("age")));
                    if (request.getParameter("partner") != null && !request.getParameter("partner").isEmpty())
                    {
                        params.addElement(new StringValue(request.getParameter("partner")));
                    }
                    else
                    {
                        params.addElement(new StringValue("  "));
                    }

                    TradeMgr tradeMgr = TradeMgr.getInstance();
                    WebBusinessObject wbo = new WebBusinessObject();
                    wbo = tradeMgr.getOnSingleKey("key2", request.getParameter("job"));
                    if (wbo != null)
                    {
                        params.addElement(new StringValue((String) wbo.getAttribute("tradeName")));
                    }
                    else
                    {
                        params.addElement(new StringValue(" "));
                    }
                    params.addElement(new StringValue(request.getParameter("workOut")));//option1
                    params.addElement(new StringValue(request.getParameter("kindred")));//option2
                    params.addElement(new StringValue(request.getParameter("company")));//option3

                    if (connectByRealEstate != null && !connectByRealEstate.equals("")
                            && connectByRealEstate.equals("1"))
                    {
                        params.addElement(new StringValue(code));
                        request.setAttribute("code", code);
                    }
                    else
                    {
                        params.addElement(new StringValue(clientNo));
                        request.setAttribute("code", clientNoByDate);
                    }

                    request.setAttribute("clientId", id);
                    params.addElement(new StringValue(request.getParameter("interPhone")));
//        Connection connection = null;
                    try
                    {
//            connection = dataSource.getConnection();
                        beginTransaction();
//            connection.setAutoCommit(true);
                        forInsert.setConnection(transConnection);
                        myQuery = getQuery("insertClient").trim();
                        forInsert.setSQLQuery(myQuery);
                        forInsert.setparams(params);
                        queryResult = forInsert.executeUpdate();

                        if (queryResult < 0)
                        {
                            transConnection.rollback();
                            return false;

                        }
                        if (clientStatus.equals("1"))
                        {
                            params = new Vector();

                            queryResult = -1000;

                            params.addElement(new StringValue(UniqueIDGen.getNextID()));
                            params.addElement(new StringValue("New"));
                            params.addElement(new StringValue(id));
                            params.addElement(new StringValue("No Description"));

                            forInsert.setConnection(transConnection);
                            forInsert.setSQLQuery(getQuery("insertInitialClientStatus").trim());
                            forInsert.setparams(params);
                            queryResult = forInsert.executeUpdate();

                            if (queryResult < 0)
                            {
                                transConnection.rollback();
                                return false;

                            }
                        }

                    }
                    catch (SQLException se)
                    {
                        logger.error(se.getMessage());
                        transConnection.rollback();
                        return false;

                    }
                    finally
                    {
                        endTransaction();
                    }

                    //////////// Insert Client In Real Estate  //////
                    if (connectByRealEstate != null && !connectByRealEstate.equals("")
                            && connectByRealEstate.equals("1"))
                    {
                        int qryResult = -1000;
                        if (queryResult > 0)
                        {
                            Vector SQLparams = new Vector();
                            SQLparams.addElement(new StringValue(code));
                            SQLparams.addElement(new StringValue(request.getParameter("clientName")));
                            SQLparams.addElement(new StringValue(request.getParameter("clientName")));
                            try
                            {
                                Class.forName(driver);
                                conn = DriverManager.getConnection(URL, userName, password);
                                conn.setAutoCommit(false);
                                forInsert.setConnection(conn);
                                forInsert.setparams(SQLparams);
                                myQuery = getQuery("saveClientInRealEstate").trim();
                                forInsert.setSQLQuery(myQuery);
                                qryResult = forInsert.executeUpdate();
                            }
                            catch (Exception se)
                            {
                                logger.error("database error " + se.getMessage());
                            }
                            finally
                            {
                                try
                                {
                                    conn.commit();
                                    conn.close();
                                }
                                catch (SQLException sex)
                                {
                                    logger.error("troubles closing connection " + sex.getMessage());
                                    return false;
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception se)
            {

                logger.error("database error " + se.getMessage());
                return false;
            }
            return excuteQuery;
        }
        else
        {
            return saveClientData(request, s, persistentUser);
        }

    }
    ////////////////////////////////////////////////////////////////

    public boolean updateClient(HttpServletRequest request) throws NoUserInSessionException, SQLException
    {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String connectByRealEstate = metaDataMgr.getConnectByRealEstate();
        String code = null;
        String userName = null;
        String password = null;
        String driver = null;
        String URL = null;
        Connection conn = null;
        String clientId = null;
        Vector SQLparams = new Vector();
        /////////// Get Client date from Real Estate ////////////
        if (connectByRealEstate != null && !connectByRealEstate.equals("")
                && connectByRealEstate.equals("1"))
        {
            userName = metaDataMgr.getRealEstateName();
            password = metaDataMgr.getRealEstatePassword();
            driver = metaDataMgr.getDriverErp();
            URL = metaDataMgr.getDataBaseErpUrl();
            Vector queryRsult = new Vector();
            SQLparams = new Vector();
            SQLCommandBean forQuery = new SQLCommandBean();
            SQLparams.addElement(new StringValue(request.getParameter("code")));
            try
            {
                Class.forName(driver);
                conn = DriverManager.getConnection(URL, userName, password);
                conn.setAutoCommit(false);
                forQuery.setConnection(conn);
                forQuery.setparams(SQLparams);
                String myQuery = getQuery("getClientInRealEstate").trim();
                forQuery.setSQLQuery(myQuery);
                queryRsult = forQuery.executeQuery();
            }
            catch (Exception se)
            {
                logger.error("database error " + se.getMessage());
            }
            finally
            {
                try
                {
                    conn.commit();
                    conn.close();
                }
                catch (SQLException sex)
                {
                    logger.error("troubles closing connection " + sex.getMessage());
                    return false;
                }
            }

            Vector resultBusObjs = new Vector();
            WebBusinessObject wbo2;
            Row r = null;
            Enumeration e = queryRsult.elements();

            while (e.hasMoreElements())
            {
                r = (Row) e.nextElement();
                try
                {
                    clientId = r.getString("clientId");

                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        ///////////////////////////////////////////

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue(request.getParameter("clientNO")));
        params.addElement(new StringValue(request.getParameter("name")));
        params.addElement(new StringValue(request.getParameter("gender")));
        params.addElement(new StringValue(request.getParameter("matiral_status")));
        params.addElement(new StringValue(request.getParameter("mobile")));
        if (request.getParameter("phone") != null && !request.getParameter("phone").isEmpty())
        {
            params.addElement(new StringValue(request.getParameter("phone")));
        }
        else
        {
            params.addElement(new StringValue(" "));
        }
        if (request.getParameter("salary") != null && !request.getParameter("salary").isEmpty())
        {
            params.addElement(new StringValue(request.getParameter("salary")));
        }
        else
        {
            params.addElement(new StringValue("0"));
        }

        params.addElement(new StringValue(request.getParameter("address")));
        params.addElement(new StringValue(request.getParameter("email")));

        if (request.getParameter("clientSsn") != null && !request.getParameter("clientSsn").isEmpty())
        {
            params.addElement(new StringValue(request.getParameter("clientSsn")));
        }
        else
        {
            params.addElement(new StringValue("  "));
        }
        params.addElement(new StringValue(request.getParameter("age")));
        if (request.getParameter("partner") != null && !request.getParameter("partner").isEmpty())
        {
            params.addElement(new StringValue(request.getParameter("partner")));
        }
        else
        {
            params.addElement(new StringValue("  "));
        }
        if (request.getParameter("isActive") != null)
        {
            params.addElement(new StringValue("1"));
        }
        else
        {
            params.addElement(new StringValue("0"));
        }
        if (request.getParameter("workOut") != null)
        {
            params.addElement(new StringValue(request.getParameter("workOut")));
        }
        else
        {
            params.addElement(new StringValue("0"));
        }
        if (request.getParameter("kindred") != null)
        {
            params.addElement(new StringValue(request.getParameter("kindred")));
        }
        else
        {
            params.addElement(new StringValue("0"));
        }
        if (request.getParameter("clientJob") != null)
        {
            params.addElement(new StringValue(request.getParameter("clientJob")));
        }
        else
        {
            params.addElement(new StringValue("not selected"));
        }
        if (request.getParameter("birthDate") != null)
        {
            String birthDate = (String) request.getParameter("birthDate");
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            try
            {
                params.addElement(new DateValue(new java.sql.Date(sdf.parse(birthDate).getTime())));
            }
            catch (ParseException ex)
            {
                Calendar c = Calendar.getInstance();
                params.addElement(new DateValue(new java.sql.Date(c.getTimeInMillis())));
            }
        }
        else
        {
            Calendar c = Calendar.getInstance();
            params.addElement(new DateValue(new java.sql.Date(c.getTimeInMillis())));
        }
        params.addElement(new StringValue(request.getParameter("regionID")));
        params.addElement(new StringValue(request.getParameter("dialedNumber")));// option3
        params.addElement(new StringValue(request.getParameter("description")));
        params.addElement(new StringValue(request.getParameter("clientBranch")));
        params.addElement(new StringValue(request.getParameter("interPhone")));
        params.addElement(new StringValue(request.getParameter("clientID")));

        Connection connection = null;
        try
        {
            connection = dataSource.getConnection();
            connection.setAutoCommit(true);
//            beginTransaction();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("updateClient").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
//            return true;
//            endTransaction();

        }
        catch (SQLException se)
        {
            logger.error("Exception updating project: " + se.getMessage());
            return false;
        }
        finally
        {
            connection.close();

        }

        if (queryResult > 0)
        {
            //////////// Update Client In Real Estate  //////
            if (connectByRealEstate != null && !connectByRealEstate.equals("")
                    && connectByRealEstate.equals("1"))
            {
                int qryResult = -1000;
                if (queryResult > 0)
                {
                    SQLparams = new Vector();
                    SQLparams.addElement(new StringValue(request.getParameter("name")));
                    SQLparams.addElement(new StringValue(request.getParameter("name")));
                    SQLparams.addElement(new StringValue(clientId));
                    try
                    {
                        Class.forName(driver);
                        conn = DriverManager.getConnection(URL, userName, password);
                        conn.setAutoCommit(false);
                        forUpdate.setConnection(conn);
                        forUpdate.setparams(SQLparams);
                        String myQuery = getQuery("updateClientInRealEstate").trim();
                        forUpdate.setSQLQuery(myQuery);
                        qryResult = forUpdate.executeUpdate();
                    }
                    catch (Exception se)
                    {
                        logger.error("database error " + se.getMessage());
                    }
                    finally
                    {
                        try
                        {
                            conn.commit();
                            conn.close();
                        }
                        catch (SQLException sex)
                        {
                            logger.error("troubles closing connection " + sex.getMessage());
                            return false;
                        }
                    }
                }
            }
            //////////////////////////////////////////////////
        }

        return (queryResult > 0);
    }

    public boolean updateCompany(HttpServletRequest request) throws NoUserInSessionException, SQLException
    {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String connectByRealEstate = metaDataMgr.getConnectByRealEstate();
        String code = null;
        String userName = null;
        String password = null;
        String driver = null;
        String URL = null;
        Connection conn = null;
        String clientId = null;
        Vector SQLparams = new Vector();
        /////////// Get Client date from Real Estate ////////////
        if (connectByRealEstate != null && !connectByRealEstate.equals("")
                && connectByRealEstate.equals("1"))
        {
            userName = metaDataMgr.getRealEstateName();
            password = metaDataMgr.getRealEstatePassword();
            driver = metaDataMgr.getDriverErp();
            URL = metaDataMgr.getDataBaseErpUrl();
            Vector queryRsult = new Vector();
            SQLparams = new Vector();
            SQLCommandBean forQuery = new SQLCommandBean();
            SQLparams.addElement(new StringValue(request.getParameter("code")));
            try
            {
                Class.forName(driver);
                conn = DriverManager.getConnection(URL, userName, password);
                conn.setAutoCommit(false);
                forQuery.setConnection(conn);
                forQuery.setparams(SQLparams);
                String myQuery = getQuery("getClientInRealEstate").trim();
                forQuery.setSQLQuery(myQuery);
                queryRsult = forQuery.executeQuery();
            }
            catch (Exception se)
            {
                logger.error("database error " + se.getMessage());
            }
            finally
            {
                try
                {
                    conn.commit();
                    conn.close();
                }
                catch (SQLException sex)
                {
                    logger.error("troubles closing connection " + sex.getMessage());
                    return false;
                }
            }

            Vector resultBusObjs = new Vector();
            WebBusinessObject wbo2;
            Row r = null;
            Enumeration e = queryRsult.elements();

            while (e.hasMoreElements())
            {
                r = (Row) e.nextElement();
                try
                {
                    clientId = r.getString("clientId");

                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        ///////////////////////////////////////////

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue(request.getParameter("clientNO")));
        params.addElement(new StringValue(request.getParameter("name")));

        if (request.getParameter("mobile") != null && !request.getParameter("mobile").isEmpty())
        {
            params.addElement(new StringValue(request.getParameter("mobile")));
        }
        else
        {
            params.addElement(new StringValue(" "));
        }
        if (request.getParameter("phone") != null && !request.getParameter("phone").isEmpty())
        {
            params.addElement(new StringValue(request.getParameter("phone")));
        }
        else
        {
            params.addElement(new StringValue(" "));
        }

        params.addElement(new StringValue(request.getParameter("address")));
        params.addElement(new StringValue(request.getParameter("email")));

        if (request.getParameter("isActive") != null)
        {
            params.addElement(new StringValue("1"));
        }
        else
        {
            params.addElement(new StringValue("0"));
        }
        if (request.getParameter("region") != null && !request.getParameter("region").isEmpty())
        {
            params.addElement(new StringValue(request.getParameter("region")));
        }
        else
        {
            params.addElement(new StringValue("UL"));
        }
        if (request.getParameter("job") != null && !request.getParameter("job").isEmpty())
        {
            params.addElement(new StringValue(request.getParameter("job")));
        }
        else
        {
            params.addElement(new StringValue("UL"));
        }
        params.addElement(new StringValue(request.getParameter("clientID")));

        Connection connection = null;
        try
        {
            connection = dataSource.getConnection();
            connection.setAutoCommit(true);
//            beginTransaction();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("updateCompany").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
//            return true;
//            endTransaction();

        }
        catch (SQLException se)
        {
            logger.error("Exception updating project: " + se.getMessage());
            return false;
        }
        finally
        {
            connection.close();

        }

        if (queryResult > 0)
        {
            //////////// Update Client In Real Estate  //////
            if (connectByRealEstate != null && !connectByRealEstate.equals("")
                    && connectByRealEstate.equals("1"))
            {
                int qryResult = -1000;
                if (queryResult > 0)
                {
                    SQLparams = new Vector();
                    SQLparams.addElement(new StringValue(request.getParameter("name")));
                    SQLparams.addElement(new StringValue(request.getParameter("name")));
                    SQLparams.addElement(new StringValue(clientId));
                    try
                    {
                        Class.forName(driver);
                        conn = DriverManager.getConnection(URL, userName, password);
                        conn.setAutoCommit(false);
                        forUpdate.setConnection(conn);
                        forUpdate.setparams(SQLparams);
                        String myQuery = getQuery("updateClientInRealEstate").trim();
                        forUpdate.setSQLQuery(myQuery);
                        qryResult = forUpdate.executeUpdate();
                    }
                    catch (Exception se)
                    {
                        logger.error("database error " + se.getMessage());
                    }
                    finally
                    {
                        try
                        {
                            conn.commit();
                            conn.close();
                        }
                        catch (SQLException sex)
                        {
                            logger.error("troubles closing connection " + sex.getMessage());
                            return false;
                        }
                    }
                }
            }
            //////////////////////////////////////////////////
        }

        return (queryResult > 0);
    }

    public boolean updateCounter(HttpServletRequest request) throws NoUserInSessionException, SQLException
    {

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue(request.getParameter("count")));
        Connection connection = null;
        try
        {
            connection = dataSource.getConnection();
            connection.setAutoCommit(true);
//            beginTransaction();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("updateCounter").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            return true;
//            endTransaction();

        }
        catch (SQLException se)
        {
            logger.error("Exception updating project: " + se.getMessage());
            return false;
        }
        finally
        {
            connection.close();

        }

//        return (queryResult > 0);
    }

    public ArrayList getCashedTableAsArrayList()
    {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        if (cashedTable != null)
        {
            for (int i = 0; i < cashedTable.size(); i++)
            {
                wbo = (WebBusinessObject) cashedTable.elementAt(i);
                cashedData.add((String) wbo.getAttribute("name"));
            }
        }

        return cashedData;
    }

    public ArrayList getCashedTableAsBusObjects()
    {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++)
        {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }

        return cashedData;
    }

    public String getAllSuppNo()
    {
        Connection connection = null;
        ResultSet result = null;
        StringBuffer returnSB = null;

        try
        {
            connection = dataSource.getConnection();
            Statement select = connection.createStatement();
            result = select.executeQuery(sqlMgr.getSql("getAllSuppNo").trim());
            returnSB = new StringBuffer();
            while (result.next())
            {
                returnSB.append(result.getString("SUPPLIER_NO") + ",");
            }
            returnSB.deleteCharAt(returnSB.length() - 1);
        }
        catch (SQLException e)
        {
            logger.error("error ================ > " + e.toString());
        }
        finally
        {
            try
            {
                connection.close();
            }
            catch (SQLException sex)
            {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        return returnSB.toString();
    }

    public Vector getAllSuppliersByEquipment(HttpServletRequest request)
    {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector params = new Vector();
        params.addElement(new StringValue(request.getParameter("equipmentID")));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try
        {
            forQuery.setparams(params);
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectAllSuppliersSQL").trim());
            queryResult = forQuery.executeQuery();

        }
        catch (SQLException se)
        {
            logger.error("SQL Exception  " + se.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
        }
        catch (Exception e)
        {
            logger.error("Exception  " + e.getMessage());
        }
        finally
        {
            try
            {
                connection.close();
            }
            catch (SQLException ex)
            {
            }
        }
        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getClientReportByDate(String date)
    {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector params = new Vector();
        params.addElement(new StringValue(date));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try
        {
            forQuery.setparams(params);
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientReportByDate"));
            queryResult = forQuery.executeQuery();

        }
        catch (SQLException se)
        {
            logger.error("SQL Exception  " + se.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
        }
        catch (Exception e)
        {
            logger.error("Exception  " + e.getMessage());
        }
        finally
        {
            try
            {
                connection.close();
            }
            catch (SQLException ex)
            {
            }
        }
        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getClientReportByAgeGroup(String age)
    {
        Connection connection = null;
        Vector parameters = new Vector();

        parameters.addElement(new StringValue(age));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try
        {
            forQuery.setparams(parameters);
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientReportByAgeGroup"));
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException se)
        {
            logger.error("SQL Exception  " + se.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("Exception  " + uste.getMessage());
        }
        catch (Exception e)
        {
            logger.error("Exception  " + e.getMessage());
        }
        finally
        {
            try
            {
                connection.close();
            }
            catch (SQLException ex)
            {
                logger.error("Exception  " + ex.getMessage());
            }
        }

        Vector result = new Vector();
        Row row;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {
            row = (Row) e.nextElement();
            result.add(fabricateBusObj(row));
        }
        return result;
    }

    public Vector getClientsOnly()
    {
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientsOnly"));
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException se)
        {
            logger.error("SQL Exception  " + se.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("Exception  " + uste.getMessage());
        }
        catch (Exception e)
        {
            logger.error("Exception  " + e.getMessage());
        }
        finally
        {
            try
            {
                connection.close();
            }
            catch (SQLException ex)
            {
                logger.error("Exception  " + ex.getMessage());
            }
        }

        Vector result = new Vector();
        Row row;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {
            row = (Row) e.nextElement();
            result.add(fabricateBusObj(row));
        }
        return result;
    }

    public Vector getClientByAgeGroupAndNoOrName(String age, String no, String name)
    {
        Connection connection = null;
        Vector parameters = new Vector();

        parameters.addElement(new StringValue(age));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        String query = getQuery("getClientByAgeGroupAndNoOrName");
        query = query.replaceAll("ooooo", no);
        query = query.replaceAll("nnnnn", name);

        try
        {
            forQuery.setparams(parameters);
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException se)
        {
            logger.error("SQL Exception  " + se.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("Exception  " + uste.getMessage());
        }
        catch (Exception e)
        {
            logger.error("Exception  " + e.getMessage());
        }
        finally
        {
            try
            {
                connection.close();
            }
            catch (SQLException ex)
            {
                logger.error("Exception  " + ex.getMessage());
            }
        }

        Vector result = new Vector();
        Row row;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {
            row = (Row) e.nextElement();
            result.add(fabricateBusObj(row));
        }
        return result;
    }

    public Vector getClientReportByJob(String job)
    {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector params = new Vector();
        params.addElement(new StringValue(job));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try
        {
            forQuery.setparams(params);
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            if (job.equalsIgnoreCase("all"))
            {
                forQuery.setSQLQuery(getQuery("clients"));
            }
            else
            {
                forQuery.setSQLQuery(getQuery("getClientReportByjob"));
            }
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException se)
        {
            logger.error("SQL Exception  " + se.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
        }
        catch (Exception e)
        {
            logger.error("Exception  " + e.getMessage());
        }
        finally
        {
            try
            {
                connection.close();
            }
            catch (SQLException ex)
            {
            }
        }
        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public ArrayList getAllSuppliers()
    {
        WebBusinessObject wbo = new WebBusinessObject();
        Tools tools = new Tools();
        Connection connection = null;
        Vector params = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        forQuery.setparams(params);
        try
        {
            connection = dataSource.getConnection();

        }
        catch (SQLException ex)
        {
            Logger.getLogger(ClientMgr.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
        forQuery.setConnection(connection);
        forQuery.setSQLQuery(sqlMgr.getSql("selectAllSuppliers").trim());
        try
        {
            queryResult = forQuery.executeQuery();

        }
        catch (SQLException ex)
        {
            Logger.getLogger(ClientMgr.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
        catch (UnsupportedTypeException ex)
        {
            Logger.getLogger(ClientMgr.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                connection.close();
            }
            catch (SQLException ex)
            {
            }
        }
        ArrayList resultBusObjs = new ArrayList();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public boolean canDelete(String clientId)
    {
        boolean canDelete = false;
        ExternalJobMgr externalJobMgr = ExternalJobMgr.getInstance();
        Vector externalJobOrderVec = new Vector();

        try
        {
            externalJobOrderVec = externalJobMgr.getOnArbitraryKey(clientId, "key1");

            if (externalJobOrderVec.isEmpty())
            {
                canDelete = true;
            }
        }
        catch (Exception ex)
        {
            logger.error(ex.getMessage());
        }

        return canDelete;
    }

    public WebBusinessObject getClientByCall(String callId) throws SQLException
    {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = new Vector();

        SQLparams.addElement(new StringValue(callId));

        SQLCommandBean forQuery = new SQLCommandBean();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientByCall").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());

        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {

            connection.close();
        }
        Row r;

        if (!queryResult.isEmpty())
        {
            Enumeration e = queryResult.elements();
            r = (Row) e.nextElement();

            wbo = fabricateBusObj(r);
            return wbo;
        }
        else
        {
            return null;
        }

    }

    public String getCounter() throws SQLException, NoSuchColumnException
    {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = new Vector();

        SQLCommandBean forQuery = new SQLCommandBean();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getCounter").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());

        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {

            connection.close();
        }
        Row r;

        if (!queryResult.isEmpty())
        {
            Enumeration e = queryResult.elements();
            r = (Row) e.nextElement();
            String count = r.getString("option3");

            return count;
        }
        else
        {
            return null;
        }

    }

    public boolean deleteClientInRealEstate(HttpServletRequest request) throws NoUserInSessionException, SQLException
    {

        /////////// Get Client date from Real Estate ////////////
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String userName = metaDataMgr.getRealEstateName();
        String password = metaDataMgr.getRealEstatePassword();
        String driver = metaDataMgr.getDriverErp();
        String URL = metaDataMgr.getDataBaseErpUrl();
        Connection conn = null;
        Vector queryRsult = new Vector();
        Vector SQLparams = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        SQLparams.addElement(new StringValue(request.getParameter("code")));
        try
        {
            Class.forName(driver);
            conn = DriverManager.getConnection(URL, userName, password);
            conn.setAutoCommit(false);
            forQuery.setConnection(conn);
            forQuery.setparams(SQLparams);
            String myQuery = getQuery("getClientInRealEstate").trim();
            forQuery.setSQLQuery(myQuery);
            queryRsult = forQuery.executeQuery();
        }
        catch (Exception se)
        {
            logger.error("database error " + se.getMessage());
        }
        finally
        {
            try
            {
                conn.commit();
                conn.close();
            }
            catch (SQLException sex)
            {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }

        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo2;
        Row r = null;
        Enumeration e = queryRsult.elements();
        String clientId = null;
        while (e.hasMoreElements())
        {
            r = (Row) e.nextElement();
            try
            {
                clientId = r.getString("clientId");

            }
            catch (NoSuchColumnException ex)
            {
                Logger.getLogger(ClientMgr.class
                        .getName()).log(Level.SEVERE, null, ex);
            }
        }

        ///////////////////////////////////////////
        SQLCommandBean forUpdate = new SQLCommandBean();

        //////////// Update Client In Real Estate  //////
        int qryResult = -1000;

        SQLparams = new Vector();
        SQLparams.addElement(new StringValue(clientId));
        try
        {
            Class.forName(driver);
            conn = DriverManager.getConnection(URL, userName, password);
            conn.setAutoCommit(false);
            forUpdate.setConnection(conn);
            forUpdate.setparams(SQLparams);
            String myQuery = getQuery("deleteClientInRealEstate").trim();
            forUpdate.setSQLQuery(myQuery);
            qryResult = forUpdate.executeUpdate();
        }
        catch (Exception se)
        {
            logger.error("database error " + se.getMessage());
        }
        finally
        {
            try
            {
                conn.commit();
                conn.close();
            }
            catch (SQLException sex)
            {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }

        //////////////////////////////////////////////////
        return (qryResult > 0);
    }

    public String getAgeGroupByIssueId(String issueId) throws SQLException, NoSuchColumnException
    {
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = new Vector();

        SQLparams.addElement(new StringValue(issueId));
        SQLCommandBean forQuery = new SQLCommandBean();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getAgeGroupByIssueId").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            connection.close();
        }

        Row row;
        if (!queryResult.isEmpty())
        {
            Enumeration e = queryResult.elements();
            row = (Row) e.nextElement();
            String count = row.getString("AGE_GROUP");
            return count;
        }
        else
        {
            return null;
        }
    }
    
        public String getLastComment(String issueId) throws SQLException, NoSuchColumnException
    {
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = new Vector();

        SQLparams.addElement(new StringValue(issueId));
        SQLCommandBean forQuery = new SQLCommandBean();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getLastCommentDetails").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            connection.close();
        }

        Row row;
        if (!queryResult.isEmpty())
        {
            Enumeration e = queryResult.elements();
            row = (Row) e.nextElement();
            String count = row.getString("comment_desc");
            return count;
        }
        else
        {
            return null;
        }
    }

        public String getLastAppointment(String issueId) throws SQLException, NoSuchColumnException
    {
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = new Vector();

        SQLparams.addElement(new StringValue(issueId));
        SQLCommandBean forQuery = new SQLCommandBean();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getLastAppointmentDetails").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            connection.close();
        }

        Row row;
        if (!queryResult.isEmpty())
        {
            Enumeration e = queryResult.elements();
            row = (Row) e.nextElement();
            String count = row.getString("comment");
            return count;
        }
        else
        {
            return null;
        }
    }


        
        @Override
    protected void initSupportedQueries()
    {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }

    public boolean updateClientStatus(String clientID, String newClientStatus, WebBusinessObject loggedUser)
    {
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue(newClientStatus));
        params.addElement(new StringValue(clientID));
        Connection connection = null;
        try
        {
            connection = dataSource.getConnection();
            connection.setAutoCommit(true);
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("updateClientStatus").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
        }
        catch (SQLException se)
        {
            logger.error("Exception updating client status: " + se.getMessage());
            return false;
        }
        finally
        {
            try
            {
                connection.close();

            }
            catch (SQLException ex)
            {
                Logger.getLogger(ClientMgr.class
                        .getName()).log(Level.SEVERE, null, ex);
            }

        }
        return (queryResult > 0);
    }
    
    public ArrayList<WebBusinessObject> getClientStatusList() throws NoSuchColumnException
    {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;
        ArrayList resultBusObjs = new ArrayList();
        Row r = null;
        Enumeration e = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        String query = getQuery("getStatusTypes").trim();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error(ex.getMessage());
        }
        catch (UnsupportedTypeException ex)
        {
            logger.error(ex.getMessage());
        }
        finally
        {
            try
            {
                connection.close();
            }
            catch (SQLException ex)
            {
            }
        }
        e = queryResult.elements();
        while (e.hasMoreElements())
        {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo.setAttribute("id", r.getString("id"));
            wbo.setAttribute("enDesc", r.getString("case_en"));
            wbo.setAttribute("arDesc", r.getString("case_ar"));
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public List<WebBusinessObject> getUnHandledClients(String beginDate, String endDate, String createdBy, String campaignID, String description, String clientType, String phoneNo, String projectID, String clientTyp, String preDepartmentID, String loggedUserID)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector queryResult = null;
        StringBuilder query = new StringBuilder(getQuery("getUnHandledClients").trim());
        if (beginDate != null && !beginDate.isEmpty())
        {
            query.append(" and cl.CREATION_TIME >= TO_DATE('").append(beginDate).append(" 00:00:00','YYYY/MM/DD HH24:mi:ss')");
        }
        if (endDate != null && !endDate.isEmpty())
        {
            query.append(" and cl.CREATION_TIME <= TO_DATE('").append(endDate).append(" 23:59:59','YYYY/MM/DD HH24:mi:ss')");
        }
        if (createdBy != null && !createdBy.isEmpty())
        {
            query.append(" and cl.CREATED_BY = '").append(createdBy).append("'");
        }
        if (campaignID != null && !campaignID.isEmpty())
        {
            query.append(" and cc.CAMPAIGN_ID = '").append(campaignID).append("'");
        }
        if (description != null && !description.isEmpty())
        {
            query.append(" and (cl.DESCRIPTION like '%").append(description).append("%')");
        }
        if (clientType != null && !clientType.isEmpty())
        {
            query.append(" and cl.CURRENT_STATUS = '").append(clientType).append("'");
        }
        if (phoneNo != null && !phoneNo.isEmpty())
        {
            query.append(" and (cl.MOBILE = '").append(phoneNo).append("' or cl.INTER_PHONE = '")
                    .append(phoneNo).append("' or cl.PHONE = '").append(phoneNo).append("')");
        }
        if (projectID != null && !projectID.isEmpty())
        {
            query.append(" and cl.SYS_ID IN (SELECT CLIENT_ID FROM CLIENT_PROJECTS WHERE PROJECT_ID = '").append(projectID).append("') ");
        }
        if (clientTyp != null && !clientTyp.isEmpty() && !clientTyp.equalsIgnoreCase("all"))
        {
            if (clientTyp.equalsIgnoreCase("cust"))
            {
                query.append(" and cl.CURRENT_STATUS = '11' ");
            }
            else if (clientTyp.equalsIgnoreCase("lead"))
            {
                query.append(" and cl.CURRENT_STATUS = '12' ");
            }
        }
        if (preDepartmentID != null && !preDepartmentID.isEmpty()) {
            query.append(" and (cl.SYS_ID IN (SELECT CLIENT_ID FROM WITHDRAW WHERE ORIGINAL_USER_ID IN (SELECT EMP_ID FROM EMP_MGR WHERE MGR_ID = (SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID = '").append(preDepartmentID).append("'))) ");
            query.append(" OR CL.CREATED_BY IN (SELECT EMP_ID FROM EMP_MGR WHERE MGR_ID IN (SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID = '")
                    .append(preDepartmentID).append("') UNION ALL SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID = '").append(preDepartmentID).append("')) ");
        } else if (loggedUserID != null) {
            query.append(" AND CL.CREATED_BY IN (SELECT EMP_ID FROM EMP_MGR WHERE MGR_ID IN (SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID IN (SELECT DEPARTMENT_ID FROM USER_DEPARTMENT_CONFIG WHERE USER_ID = '")
                    .append(loggedUserID).append("')) UNION ALL SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID IN (SELECT DEPARTMENT_ID FROM USER_DEPARTMENT_CONFIG WHERE USER_ID = '")
                    .append(loggedUserID).append("')) ");
        }
        query.append(" order by u.FULL_NAME");
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.toString());
            queryResult = command.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error(ex);
        }
        catch (UnsupportedTypeException ex)
        {
            logger.error(ex);
        }
        finally
        {
            try
            {
                connection.close();
            }
            catch (SQLException ex)
            {
                logger.error(ex);
            }
        }

        List result = new ArrayList();
        if (queryResult != null)
        {
            Enumeration e = queryResult.elements();
            Row r;
            while (e.hasMoreElements())
            {
                try
                {
                    r = (Row) e.nextElement();
                    WebBusinessObject wbo = fabricateBusObj(r);
                    if (r.getString("full_name") != null)
                    {
                        wbo.setAttribute("createdByName", r.getString("full_name"));
                    }
                    if (r.getString("STATUS_NAME_AR") != null)
                    {
                        wbo.setAttribute("statusNameAr", r.getString("STATUS_NAME_AR"));
                    }
                    if (r.getString("STATUS_NAME_EN") != null)
                    {
                        wbo.setAttribute("statusNameEn", r.getString("STATUS_NAME_EN"));
                    }

                    result.add(wbo);

                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        return result;
    }

    public Vector getAllClientInAppointment(int year)
    {

        Vector param = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        String query = sqlMgr.getSql("selectClientAppointment").trim();

        try
        {
            param = new Vector();
            param.addElement(new StringValue(String.valueOf(year)));
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();

        }
        catch (SQLException se)
        {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
            return null;
        }
        finally
        {
            try
            {
                connection.close();

            }
            catch (SQLException ex)
            {
                Logger.getLogger(ClientMgr.class
                        .getName()).log(Level.SEVERE, null, ex);
            }
        }
        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo = new WebBusinessObject();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public WebBusinessObject getClientByNo(String num, String projectName, String searchType, String departmentID) throws SQLException
    {
        WebBusinessObject wbo;
        if (searchType != null)
        {
            String[] statusTitles = new String[3];
            statusTitles[0] = "12";
            statusTitles[1] = "13";
            statusTitles[2] = "14";
            StringBuilder statusQuery = new StringBuilder(" and C.CURRENT_STATUS in (");
            statusQuery.append("select MAX(DECODE(client_status,'11', '11')) as client_status from client_rule where department_id ='"); // for status = 11
            statusQuery.append(departmentID).append("'").append(" union ");
            int i = 0;
            for (String statusTitle : statusTitles)
            {
                statusQuery.append("select MAX(DECODE(client_status,'99','").append(statusTitle).append("')) as client_status ");
                statusQuery.append("from client_rule where department_id = '").append(departmentID).append("'");
                if (i < statusTitles.length - 1)
                {
                    statusQuery.append(" union ");
                }
                i++;
            }
            statusQuery.append(")");
            Connection connection = null;
            Vector queryResult = new Vector();
            SQLCommandBean forQuery = new SQLCommandBean();
            try
            {
                connection = dataSource.getConnection();
                forQuery.setConnection(connection);
                if (searchType.equalsIgnoreCase("searchByPhone"))
                {
                    forQuery.setSQLQuery(getQuery("getClientByPhoneNo").trim().replaceAll("num", num) + statusQuery.toString());
                }
                else if (searchType.equalsIgnoreCase("searchByEmail"))
                {
                    forQuery.setSQLQuery(getQuery("getClientByEmail").trim().replaceAll("emailAddress", num.toLowerCase()) + statusQuery.toString());
                }
                else
                {
                    forQuery.setSQLQuery(getQuery("getClientByUnitNo").trim().replaceAll("num", num).replaceFirst("projectName", projectName) + statusQuery.toString());
                }
                queryResult = forQuery.executeQuery();
            }
            catch (SQLException ex)
            {
                logger.error("SQL Exception  " + ex.getMessage());

            }
            catch (UnsupportedTypeException uste)
            {
                logger.error("***** " + uste.getMessage());
            }
            finally
            {
                connection.close();
            }
            Row r;
            if (!queryResult.isEmpty())
            {
                Enumeration e = queryResult.elements();
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                try
                {
                    if (r.getString("branchName") != null)
                    {
                        wbo.setAttribute("branchName", r.getString("branchName"));

                    }
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                return wbo;
            }
            else
            {
                return null;
            }
        }
        return null;
    }

    public ArrayList<WebBusinessObject> getClientByCom(String num, String projectName, String searchType, String departmentID) throws SQLException
    {
        ArrayList resultBusObjs = new ArrayList();
        WebBusinessObject wbo;
        if (searchType != null)
        {
            String[] statusTitles = new String[3];
            statusTitles[0] = "12";
            statusTitles[1] = "13";
            statusTitles[2] = "14";
            StringBuilder statusQuery = new StringBuilder(" and C.CURRENT_STATUS in (");
            statusQuery.append("select MAX(DECODE(client_status,'11', '11')) as client_status from client_rule where department_id ='"); // for status = 11
            statusQuery.append(departmentID).append("'").append(" union ");
            int i = 0;
            for (String statusTitle : statusTitles)
            {
                statusQuery.append("select MAX(DECODE(client_status,'99','").append(statusTitle).append("')) as client_status ");
                statusQuery.append("from client_rule where department_id = '").append(departmentID).append("'");
                if (i < statusTitles.length - 1)
                {
                    statusQuery.append(" union ");
                }
                i++;
            }
            statusQuery.append(")");
            Connection connection = null;
            Vector queryResult = new Vector();
            SQLCommandBean forQuery = new SQLCommandBean();
            try
            {
                connection = dataSource.getConnection();
                forQuery.setConnection(connection);
                if (searchType.equalsIgnoreCase("searchByPhone"))
                {
                    forQuery.setSQLQuery(getQuery("getClientByOtherPhoneNo").trim().replaceAll("num", num) + statusQuery.toString());
                }
                else if (searchType.equalsIgnoreCase("searchByEmail"))
                {
                    forQuery.setSQLQuery(getQuery("getClientByOtheremail").trim().replaceAll("emailAddress", num.toLowerCase()) + statusQuery.toString());
                }/* else {
                    forQuery.setSQLQuery(getQuery("getClientByUnitNo").trim().replaceAll("num", num).replaceFirst("projectName", projectName) + statusQuery.toString());
                }*/
                queryResult = forQuery.executeQuery();
            }
            catch (SQLException ex)
            {
                logger.error("SQL Exception  " + ex.getMessage());

            }
            catch (UnsupportedTypeException uste)
            {
                logger.error("***** " + uste.getMessage());
            }
            finally
            {
                connection.close();
            }
            Row r;
            if (!queryResult.isEmpty())
            {
                Enumeration e = queryResult.elements();
                while (e.hasMoreElements())
                {
                    r = (Row) e.nextElement();
                    wbo = fabricateBusObj(r);
                    try
                    {
                        if (r.getString("branchName") != null)
                        {
                            wbo.setAttribute("branchName", r.getString("branchName"));
                        }
                        if (r.getString("ID") != null)
                        {
                            wbo.setAttribute("issueID", r.getString("ID"));
                        }
                        if (r.getString("CASE_AR") != null)
                        {
                            wbo.setAttribute("currentStatusNameAr", r.getString("CASE_AR"));
                        }
                        if (r.getString("CASE_EN") != null)
                        {
                            wbo.setAttribute("currentStatusNameEn", r.getString("CASE_EN"));
                        }
                    }
                    catch (NoSuchColumnException ex)
                    {
                        Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    resultBusObjs.add(wbo);
                }
                return resultBusObjs;
            }
            else
            {
                return resultBusObjs;
            }
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getClientByNoAndCompany(String num, String projectName, String searchType, String departmentID, String companyID) throws SQLException
    {
        WebBusinessObject wbo;
        ArrayList resultBusObjs = new ArrayList();
        if (searchType != null)
        {
            String[] statusTitles = new String[3];
            statusTitles[0] = "12";
            statusTitles[1] = "13";
            statusTitles[2] = "14";
            StringBuilder statusQuery = new StringBuilder(" and C.CURRENT_STATUS in (");
            statusQuery.append("select MAX(DECODE(client_status,'11', '11')) as client_status from client_rule where department_id ='"); // for status = 11
            statusQuery.append(departmentID).append("'").append(" union ");
            int i = 0;
            for (String statusTitle : statusTitles)
            {
                statusQuery.append("select MAX(DECODE(client_status,'99','").append(statusTitle).append("')) as client_status ");
                statusQuery.append("from client_rule where department_id = '").append(departmentID).append("'");
                if (i < statusTitles.length - 1)
                {
                    statusQuery.append(" union ");
                }
                i++;
            }
            statusQuery.append(")");
            Connection connection = null;
            Vector queryResult = new Vector();
            SQLCommandBean forQuery = new SQLCommandBean();
            Vector param = new Vector();
            param.addElement(new StringValue(String.valueOf(companyID)));
            try
            {
                connection = dataSource.getConnection();
                forQuery.setConnection(connection);
                if (searchType.equalsIgnoreCase("searchByPhone"))
                {
                    forQuery.setSQLQuery(getQuery("getClientByPhoneNoAndCompany").trim().replaceAll("num", num) + statusQuery.toString());
                }
                else if (searchType.equalsIgnoreCase("searchByEmail"))
                {
                    forQuery.setSQLQuery(getQuery("getClientByEmail").trim().replaceAll("emailAddress", num.toLowerCase()) + statusQuery.toString());
                }
                else
                {
                    forQuery.setSQLQuery(getQuery("getClientByUnitNo").trim().replaceAll("num", num).replaceFirst("projectName", projectName) + statusQuery.toString());
                }
                forQuery.setparams(param);
                queryResult = forQuery.executeQuery();
            }
            catch (SQLException ex)
            {
                logger.error("SQL Exception  " + ex.getMessage());

            }
            catch (UnsupportedTypeException uste)
            {
                logger.error("***** " + uste.getMessage());
            }
            finally
            {
                connection.close();
            }
            Row r;
            if (!queryResult.isEmpty())
            {
                Enumeration e = queryResult.elements();
                e = queryResult.elements();
                while (e.hasMoreElements())
                {
                    r = (Row) e.nextElement();
                    wbo = fabricateBusObj(r);
                    try
                    {
                        if (r.getString("branchName") != null)
                        {
                            wbo.setAttribute("branchName", r.getString("branchName"));
                        }
                        if (r.getString("ID") != null)
                        {
                            wbo.setAttribute("issueID", r.getString("ID"));
                        }
                        if (r.getString("CASE_AR") != null)
                        {
                            wbo.setAttribute("currentStatusNameAr", r.getString("CASE_AR"));
                        }
                        if (r.getString("CASE_EN") != null)
                        {
                            wbo.setAttribute("currentStatusNameEn", r.getString("CASE_EN"));
                        }
                    }
                    catch (NoSuchColumnException ex)
                    {
                        Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    resultBusObjs.add(wbo);
                }
                return resultBusObjs;
            }
            else
            {
                return resultBusObjs;
            }
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getClientLstByNo(String num, String projectName, String searchType, String departmentID) throws SQLException
    {
        WebBusinessObject wbo;
        ArrayList resultBusObjs = new ArrayList();
        if (searchType != null)
        {
            String[] statusTitles = new String[3];
            statusTitles[0] = "12";
            statusTitles[1] = "13";
            statusTitles[2] = "14";
            StringBuilder statusQuery = new StringBuilder(" and C.CURRENT_STATUS in (");
            statusQuery.append("select MAX(DECODE(client_status,'11', '11')) as client_status from client_rule where department_id ='"); // for status = 11
            statusQuery.append(departmentID).append("'").append(" union ");
            int i = 0;
            for (String statusTitle : statusTitles)
            {
                statusQuery.append("select MAX(DECODE(client_status,'99','").append(statusTitle).append("')) as client_status ");
                statusQuery.append("from client_rule where department_id = '").append(departmentID).append("'");
                if (i < statusTitles.length - 1)
                {
                    statusQuery.append(" union ");
                }
                i++;
            }
            statusQuery.append(")");
            Connection connection = null;
            Vector queryResult = new Vector();
            SQLCommandBean forQuery = new SQLCommandBean();
            try
            {
                connection = dataSource.getConnection();
                forQuery.setConnection(connection);
                if (searchType.equalsIgnoreCase("searchByPhone"))
                {
                    forQuery.setSQLQuery(getQuery("getClientByPhoneNo").trim().replaceAll("num", num) + statusQuery.toString());
                }
                else if (searchType.equalsIgnoreCase("searchByEmail"))
                {
                    forQuery.setSQLQuery(getQuery("getClientByEmail").trim().replaceAll("emailAddress", num.toLowerCase()) + statusQuery.toString());
                }
                else
                {
                    forQuery.setSQLQuery(getQuery("getClientByUnitNo").trim().replaceAll("num", num).replaceFirst("projectName", projectName) + statusQuery.toString());
                }
                queryResult = forQuery.executeQuery();
            }
            catch (SQLException ex)
            {
                logger.error("SQL Exception  " + ex.getMessage());

            }
            catch (UnsupportedTypeException uste)
            {
                logger.error("***** " + uste.getMessage());
            }
            finally
            {
                connection.close();
            }
            Row r;
            if (!queryResult.isEmpty())
            {
                Enumeration e = queryResult.elements();
                while (e.hasMoreElements())
                {
                    r = (Row) e.nextElement();
                    wbo = fabricateBusObj(r);
                    try
                    {
                        if (r.getString("branchName") != null)
                        {
                            wbo.setAttribute("branchName", r.getString("branchName"));
                        }
                        if (r.getString("ID") != null)
                        {
                            wbo.setAttribute("issueID", r.getString("ID"));
                        }
                        if (r.getString("CASE_AR") != null)
                        {
                            wbo.setAttribute("currentStatusNameAr", r.getString("CASE_AR"));
                        }
                        if (r.getString("CASE_EN") != null)
                        {
                            wbo.setAttribute("currentStatusNameEn", r.getString("CASE_EN"));
                        }
                    }
                    catch (NoSuchColumnException ex)
                    {
                        Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    resultBusObjs.add(wbo);
                }
                return resultBusObjs;
            }
            else
            {
                return resultBusObjs;
            }
        }
        return resultBusObjs;
    }

    public WebBusinessObject getClientByNoAndID(String num) throws SQLException
    {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientByNoAndID").trim().replaceAll("num", num));
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());

        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            connection.close();
        }
        Row r;
        if (!queryResult.isEmpty())
        {
            Enumeration e = queryResult.elements();
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            return wbo;
        }
        else
        {
            return null;
        }
    }

    public boolean updateClient(WebBusinessObject clientWbo) throws NoUserInSessionException, SQLException
    {
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue(clientWbo.getAttribute("clientNO").toString()));
        params.addElement(new StringValue(clientWbo.getAttribute("name").toString()));
        params.addElement(new StringValue(clientWbo.getAttribute("gender").toString()));
        params.addElement(new StringValue(clientWbo.getAttribute("matiralStatus").toString()));
        if (clientWbo.getAttribute("mobile") != null && !clientWbo.getAttribute("mobile").toString().isEmpty())
        {
            params.addElement(new StringValue(clientWbo.getAttribute("mobile").toString()));
        }
        else
        {
            params.addElement(new StringValue(" "));
        }
        if (clientWbo.getAttribute("phone") != null && !clientWbo.getAttribute("phone").toString().isEmpty())
        {
            params.addElement(new StringValue(clientWbo.getAttribute("phone").toString()));
        }
        else
        {
            params.addElement(new StringValue(" "));
        }
        if (clientWbo.getAttribute("salary") != null && !clientWbo.getAttribute("salary").toString().isEmpty())
        {
            params.addElement(new StringValue(clientWbo.getAttribute("salary").toString()));
        }
        else
        {
            params.addElement(new StringValue("0"));
        }
        params.addElement(new StringValue(clientWbo.getAttribute("address").toString()));
        params.addElement(new StringValue(clientWbo.getAttribute("email").toString()));
        if (clientWbo.getAttribute("clientSsn") != null && !clientWbo.getAttribute("clientSsn").toString().isEmpty())
        {
            params.addElement(new StringValue(clientWbo.getAttribute("clientSsn").toString()));
        }
        else
        {
            params.addElement(new StringValue("  "));
        }
        params.addElement(new StringValue(clientWbo.getAttribute("age").toString()));
        if (clientWbo.getAttribute("partner") != null && !clientWbo.getAttribute("partner").toString().isEmpty())
        {
            params.addElement(new StringValue(clientWbo.getAttribute("partner").toString()));
        }
        else
        {
            params.addElement(new StringValue("  "));
        }
        if (clientWbo.getAttribute("isActive") != null)
        {
            params.addElement(new StringValue("1"));
        }
        else
        {
            params.addElement(new StringValue("0"));
        }
        if (clientWbo.getAttribute("workOut") != null)
        {
            params.addElement(new StringValue(clientWbo.getAttribute("workOut").toString()));
        }
        else
        {
            params.addElement(new StringValue("0"));
        }
        if (clientWbo.getAttribute("kindred") != null)
        {
            params.addElement(new StringValue(clientWbo.getAttribute("kindred").toString()));
        }
        else
        {
            params.addElement(new StringValue("0"));
        }
        if (clientWbo.getAttribute("job") != null)
        {
            params.addElement(new StringValue(clientWbo.getAttribute("job").toString()));
        }
        else
        {
            params.addElement(new StringValue("not selected"));
        }
        if (clientWbo.getAttribute("birthDate") != null)
        {
            String birthDate = (String) clientWbo.getAttribute("birthDate");
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            try
            {
                params.addElement(new DateValue(new java.sql.Date(sdf.parse(birthDate).getTime())));
            }
            catch (ParseException ex)
            {
                Calendar c = Calendar.getInstance();
                params.addElement(new DateValue(new java.sql.Date(c.getTimeInMillis())));
            }
        }
        else
        {
            Calendar c = Calendar.getInstance();
            params.addElement(new DateValue(new java.sql.Date(c.getTimeInMillis())));
        }
        params.addElement(new StringValue(clientWbo.getAttribute("region").toString()));
        params.addElement(new StringValue((String) clientWbo.getAttribute("option3")));// option3
        if (clientWbo.getAttribute("description") != null)
        {
            params.addElement(new StringValue((String) clientWbo.getAttribute("description")));
        }
        else
        {
            params.addElement(new StringValue(" "));
        }
        if (clientWbo.getAttribute("branch") != null)
        {
            params.addElement(new StringValue((String) clientWbo.getAttribute("branch")));
        }
        else
        {
            params.addElement(new StringValue("UL"));
        }
        if (clientWbo.getAttribute("interPhone") != null)
        {
            params.addElement(new StringValue((String) clientWbo.getAttribute("interPhone")));
        }
        else
        {
            params.addElement(new StringValue(""));
        }

        params.addElement(new StringValue(clientWbo.getAttribute("id").toString()));
        Connection connection = null;
        try
        {
            connection = dataSource.getConnection();
            connection.setAutoCommit(true);
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("updateClient").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

        }
        catch (SQLException se)
        {
            logger.error("Exception updating project: " + se.getMessage());
            return false;
        }
        finally
        {
            connection.close();
        }
        return (queryResult > 0);
    }

    public WebBusinessObject saveWebClient(String clientName, String mobile, String phone, String email, String description, HttpSession s, WebBusinessObject persistentUser, String season) throws NoUserInSessionException, SQLException
    {
        WebBusinessObject clientWbo = null;
        metaDataMgr = MetaDataMgr.getInstance();
        String clientNo;
        SequenceMgr sequenceMgr = SequenceMgr.getInstance();
//        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        sequenceMgr.updateSequence();
        clientNo = sequenceMgr.getSequence();
        Vector parameters = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult;
        String clientNoByDate;
        String id = UniqueIDGen.getNextID();
        parameters.addElement(new StringValue(id));
        parameters.addElement(new StringValue(clientNo));
        parameters.addElement(new StringValue(clientName));
        parameters.addElement(new StringValue("UL"));//age
        parameters.addElement(new StringValue("UL"));//matiralStatus
        parameters.addElement(new StringValue(mobile != null && !mobile.isEmpty() ? mobile : "UL"));
        parameters.addElement(new StringValue(phone != null && !phone.isEmpty() ? phone : "UL"));
        parameters.addElement(new StringValue(""));//clientSalary
        parameters.addElement(new StringValue(""));//address
        parameters.addElement(new StringValue(email));
        parameters.addElement(new StringValue("0"));//isActive
        parameters.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new java.util.Date());
        clientNoByDate = (calendar.get(Calendar.MONTH) + 1) + "/" + calendar.get(Calendar.YEAR);
        parameters.addElement(new StringValue(clientNoByDate));
        parameters.addElement(new StringValue(""));//clientSsn
        parameters.addElement(new StringValue("30-40"));//age
        parameters.addElement(new StringValue("  "));//partner
        parameters.addElement(new StringValue(""));//job
        parameters.addElement(new StringValue(""));//option1
        parameters.addElement(new StringValue(""));//option2
        parameters.addElement(new StringValue(season));//option3
        parameters.addElement(new StringValue(clientNo));
        parameters.addElement(new StringValue(""));//nationality
        parameters.addElement(new StringValue(""));//regionTitle
        parameters.addElement(new DateValue(new java.sql.Date(calendar.getTimeInMillis())));
        parameters.addElement(new StringValue("12"));
        parameters.addElement(new StringValue(description));//description
        parameters.addElement(new StringValue("UL"));//branch
        parameters.addElement(new StringValue(phone != null && !phone.isEmpty() ? phone : "UL"));
        try
        {
            beginTransaction();
            forInsert.setConnection(transConnection);
            String myQuery = getQuery("insertClient").trim();
            forInsert.setSQLQuery(myQuery);
            forInsert.setparams(parameters);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0)
            {
                transConnection.rollback();
                return clientWbo;
            }
            parameters = new Vector();
            String issueStatusId = UniqueIDGen.getNextID();
            parameters.addElement(new StringValue(issueStatusId));
            // 'lead' for new clinet
            parameters.addElement(new StringValue("12"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue("0"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue(id));
            parameters.addElement(new StringValue("client"));
            parameters.addElement(new StringValue("UL"));
            parameters.addElement(new StringValue((String) persistentUser.getAttribute("userId")));

            forInsert.setSQLQuery(getQuery("insertClientStatus").trim());
            forInsert.setparams(parameters);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0)
            {
                transConnection.rollback();
                return clientWbo;
            }
            else
            {
                clientWbo = new WebBusinessObject();
                clientWbo.setAttribute("clientId", id);
                clientWbo.setAttribute("clientNo", clientNo);
            }
        }
        catch (SQLException se)
        {
            logger.error(se.getMessage());
            transConnection.rollback();
            return clientWbo;

        }
        finally
        {
            endTransaction();
            try
            {
                Thread.sleep(200);

            }
            catch (InterruptedException ex)
            {
                Logger.getLogger(ClientMgr.class
                        .getName()).log(Level.SEVERE, null, ex);
            }
        }
        return clientWbo;
    }

    public ArrayList<WebBusinessObject> getListOfContractors()
    {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;
        ArrayList resultBusObjs = new ArrayList();
        Row r = null;
        Enumeration e = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        String query = getQuery("getContractorsWithJob").trim();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error(ex.getMessage());
        }
        catch (UnsupportedTypeException ex)
        {
            logger.error(ex.getMessage());
        }
        finally
        {
            try
            {
                connection.close();
            }
            catch (SQLException ex)
            {
            }
        }
        e = queryResult.elements();
        while (e.hasMoreElements())
        {
            try
            {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                wbo.setAttribute("client_no", r.getString("client_no"));
                wbo.setAttribute("name", r.getString("name"));
                wbo.setAttribute("id", r.getString("id"));
                if (r.getString("OPTION1") == null || r.getString("OPTION1").equals(""))
                {
                    wbo.setAttribute("job", "ط¸â€‍ط·آ§ ط¸ظ¹ط¸ث†ط·آ¬ط·آ¯");
                }
                else
                {
                    wbo.setAttribute("job", r.getString("OPTION1"));
                }

                resultBusObjs.add(wbo);

            }
            catch (NoSuchColumnException ex)
            {
                Logger.getLogger(ClientMgr.class
                        .getName()).log(Level.SEVERE, null, ex);
            }
        }
        return resultBusObjs;
    }

    public boolean deleteAllClientData(String clientId) throws SQLException
    {
        Connection connection = null;
        Vector params = new Vector();
        params.add(new StringValue(clientId));
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        try
        {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            // Delete Client
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("deleteClientWithID"));
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            // Delete Client
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("deleteClientWithID2"));
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            // Delete Appointments
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("deleteAppointmentsWithClientID"));
            forUpdate.setparams(params);
            forUpdate.executeUpdate();
            // Delete Bookmarks
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("deleteBookmarksWithClientID"));
            forUpdate.setparams(params);
            forUpdate.executeUpdate();
            // Delete Campaigns
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("deleteCampaignWithClientID"));
            forUpdate.setparams(params);
            forUpdate.executeUpdate();
            // Delete Communications
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("deleteCommunicationsWithClientID"));
            forUpdate.setparams(params);
            forUpdate.executeUpdate();
            // Delete Incentives
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("deleteIncentiveWithClientID"));
            forUpdate.setparams(params);
            forUpdate.executeUpdate();
            // Delete Seasons
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("deleteSeasonsWithClientID"));
            forUpdate.setparams(params);
            forUpdate.executeUpdate();
            // Delete Client Status
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("deleteStatusWithClientID"));
            forUpdate.setparams(params);
            forUpdate.executeUpdate();
            // Delete Issue Status
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("deleteIssueStatusWithClientID"));
            forUpdate.setparams(params);
            forUpdate.executeUpdate();
            // Delete Comments
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("deleteCommentsWithClientID"));
            forUpdate.setparams(params);
            forUpdate.executeUpdate();
            // Delete Documents
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("deleteDocumentsWithClientID"));
            forUpdate.setparams(params);
            forUpdate.executeUpdate();

            // Delete Issues
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("deleteIssuesWithCLientID"));
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

            // Delete Rating
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("deleteRateWithCLientID"));
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

            connection.commit();
            connection.setAutoCommit(true);
        }
        catch (SQLException se)
        {
            logger.error("database error " + se.getMessage());
            if (connection != null)
            {
                connection.rollback();
            }
            return false;
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.commit();
                    connection.close();
                }
            }
            catch (SQLException sex)
            {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }
        return true;
    }

    public boolean deleteClient(String clientId) throws SQLException
    {
        Connection connection = null;
        Vector params = new Vector();
        params.add(new StringValue(clientId));
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        try
        {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            // Delete Client
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("deleteClienstWithID2"));
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

            connection.commit();
            connection.setAutoCommit(true);
        }
        catch (SQLException se)
        {
            logger.error("database error " + se.getMessage());
            if (connection != null)
            {
                connection.rollback();
            }
            return false;
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.commit();
                    connection.close();
                }
            }
            catch (SQLException sex)
            {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }
        return (queryResult > 0);
    }

    public ArrayList<WebBusinessObject> getNonFollowersClients(String period, String currentOwnerID, String rateID)
    {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        Vector params = new Vector();
        params.addElement(new StringValue(period));
        params.addElement(new StringValue(period));
        SQLCommandBean forQuery = new SQLCommandBean();
        String query;
        if (currentOwnerID == null || currentOwnerID.isEmpty())
        {
            query = getQuery("getNonFollowers").replaceAll("currentOwnerID", "%").trim();
        }
        else
        {
            query = getQuery("getNonFollowers").replaceAll("currentOwnerID", currentOwnerID).trim();
        }
        StringBuilder where = new StringBuilder();
        if (rateID != null && !rateID.isEmpty())
        {
            where.append(" AND CR.RATE_ID = '").append(rateID).append("'");
        }
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query + where.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> results = new ArrayList<WebBusinessObject>();
        Row r;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try
            {
                if (r.getString("CURRENT_OWNER_ID") != null)
                {
                    wbo.setAttribute("currentOwnerID", r.getString("CURRENT_OWNER_ID"));
                }
                if (r.getString("CURRENT_OWNER_NAME") != null)
                {
                    wbo.setAttribute("currentOwnerName", r.getString("CURRENT_OWNER_NAME"));
                }
                if (r.getString("RATE_NAME") != null)
                {
                    wbo.setAttribute("rateName", r.getString("RATE_NAME"));
                }
                if (r.getString("IMAGE_NAME") != null)
                {
                    wbo.setAttribute("imageName", r.getString("IMAGE_NAME"));

                }
                try
                {
                    if (r.getTimestamp("LAST_COM_DATE") == null)
                    {
                        wbo.setAttribute("lastComDate", "---");

                    }
                    else
                    {
                        wbo.setAttribute("lastComDate", r.getString("LAST_COM_DATE").split(" ")[0]);
                    }
                    if (r.getTimestamp("LAST_APP_DATE") == null)
                    {
                        wbo.setAttribute("lastAppDate", "---");

                    }
                    else
                    {
                        wbo.setAttribute("lastAppDate", r.getString("LAST_APP_DATE").split(" ")[0]);
                    }
                }
                catch (UnsupportedConversionException ex)
                {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }

            }
            catch (NoSuchColumnException ex)
            {
                Logger.getLogger(ClientMgr.class
                        .getName()).log(Level.SEVERE, null, ex);
            }
            results.add(wbo);
        }
        return results;
    }

    public ArrayList<WebBusinessObject> getEmployeeProductions(String groupId, String bDate, String eDate)
    {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        Vector params = new Vector();
        params.addElement(new StringValue(bDate));
        params.addElement(new StringValue(eDate));
        params.addElement(new StringValue(groupId));
        SQLCommandBean forQuery = new SQLCommandBean();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getEmployeeProductions").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> results = new ArrayList<WebBusinessObject>();
        Row r;
        Enumeration e = queryResult.elements();
        UserMgr user = UserMgr.getInstance();
        WebBusinessObject userWbo = null;
        while (e.hasMoreElements())
        {
            userWbo = new WebBusinessObject();
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try
            {
                String userId = r.getString("CREATED_BY");
                userWbo = user.getOnSingleKey(userId);
                wbo.setAttribute("currentOwnerFullName", userWbo.getAttribute("fullName"));
                wbo.setAttribute("noTicket", String.valueOf(r.getBigDecimal("TOTAL")));

            }
            catch (NoSuchColumnException ex)
            {
                Logger.getLogger(ClientMgr.class
                        .getName()).log(Level.SEVERE, null, ex);
            }
            catch (UnsupportedConversionException ex)
            {
                Logger.getLogger(ClientMgr.class
                        .getName()).log(Level.SEVERE, null, ex);
            }
            results.add(wbo);
        }
        return results;
    }

    public ArrayList<WebBusinessObject> getProductivityByGroup(String groupID, String firstDateOfQuarter)
    {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        Vector params = new Vector();
        params.addElement(new StringValue(groupID));
        params.addElement(new StringValue(firstDateOfQuarter));
        params.addElement(new StringValue(firstDateOfQuarter));
        SQLCommandBean forQuery = new SQLCommandBean();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getProductivityByGroup").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> results = new ArrayList<WebBusinessObject>();
        Row r;
        if (queryResult != null)
        {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements())
            {
                try
                {
                    r = (Row) e.nextElement();
                    wbo = new WebBusinessObject();
                    if (r.getBigDecimal("total") != null)
                    {
                        wbo.setAttribute("total", r.getBigDecimal("total"));
                    }
                    if (r.getString("start_date") != null)
                    {
                        wbo.setAttribute("startDate", r.getString("start_date").split(" ")[0]);
                    }
                    if (r.getString("end_date") != null)
                    {
                        wbo.setAttribute("endDate", r.getString("end_date").split(" ")[0]);
                    }
                    results.add(wbo);

                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                catch (UnsupportedConversionException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        return results;
    }

    public ArrayList<WebBusinessObject> getProductivityByUser(String userID, String firstDateOfQuarter)
    {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        Vector params = new Vector();
        params.addElement(new StringValue(userID));
        params.addElement(new StringValue(firstDateOfQuarter));
        params.addElement(new StringValue(firstDateOfQuarter));
        SQLCommandBean forQuery = new SQLCommandBean();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getProductivityByUser").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> results = new ArrayList<WebBusinessObject>();
        Row r;
        if (queryResult != null)
        {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements())
            {
                try
                {
                    r = (Row) e.nextElement();
                    wbo = new WebBusinessObject();
                    if (r.getBigDecimal("total") != null)
                    {
                        wbo.setAttribute("total", r.getBigDecimal("total"));
                    }
                    if (r.getString("start_date") != null)
                    {
                        wbo.setAttribute("startDate", r.getString("start_date").split(" ")[0]);
                    }
                    if (r.getString("end_date") != null)
                    {
                        wbo.setAttribute("endDate", r.getString("end_date").split(" ")[0]);
                    }
                    results.add(wbo);

                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                catch (UnsupportedConversionException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        return results;
    }

    public ArrayList<WebBusinessObject> getAppointmentsByUser(String userID, String firstDateOfQuarter)
    {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        Vector params = new Vector();
        params.addElement(new StringValue(userID));
        params.addElement(new StringValue(firstDateOfQuarter));
        params.addElement(new StringValue(firstDateOfQuarter));
        SQLCommandBean forQuery = new SQLCommandBean();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getAppointmentsByUser").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> results = new ArrayList<WebBusinessObject>();
        Row r;
        if (queryResult != null)
        {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements())
            {
                try
                {
                    r = (Row) e.nextElement();
                    wbo = new WebBusinessObject();
                    if (r.getBigDecimal("total") != null)
                    {
                        wbo.setAttribute("total", r.getBigDecimal("total"));
                    }
                    if (r.getString("start_date") != null)
                    {
                        wbo.setAttribute("startDate", r.getString("start_date").split(" ")[0]);
                    }
                    if (r.getString("end_date") != null)
                    {
                        wbo.setAttribute("endDate", r.getString("end_date").split(" ")[0]);
                    }
                    results.add(wbo);

                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                catch (UnsupportedConversionException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        return results;
    }

    public List<WebBusinessObject> getClientsWithCommentsByOwnerDate(String createdBy, String from, String to, String interCode, List<WebBusinessObject> employeeList)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result = null;
        Vector parameters = new Vector();

        StringBuilder where = new StringBuilder();

        if (createdBy.isEmpty())
        {
            where.append("(");
            for (int i = 0; i < employeeList.size(); i++)
            {
                WebBusinessObject empWbo = employeeList.get(i);
                String user_id = (String) empWbo.getAttribute("userId");
                where.append(" CO.CREATED_BY = '").append(user_id).append("'");
                if (i != (employeeList.size() - 1))
                {
                    where.append(" or");
                }
            }
            where.append(")");
        }
        else
        {
            where.append(" CO.CREATED_BY like ? ");
            parameters.addElement(new StringValue(createdBy));
        }

        if (where.length() > 0)
        {
            where.append(" AND ");
        }
        if (interCode != null && !"-".equals(interCode))
        {
            parameters.addElement(new StringValue(interCode + "%"));
        }

        parameters.addElement(new StringValue(from));
        parameters.addElement(new StringValue(to));
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getClientsWithCommentsByOwnerDate").replaceAll("wherestatment", where.toString()).trim());
            //command.setSQLQuery(getQuery("getClientsWithCommentsByOwnerDate").replaceAll("wherestatment", where.toString()).trim());
            command.setparams(parameters);
            result = command.executeQuery();

            List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getString("CREATED_BY") != null)
                    {
                        wbo.setAttribute("createdBy", row.getString("CREATED_BY"));
                    }
                    if (row.getString("CREATED_BY_NAME") != null)
                    {
                        wbo.setAttribute("createdByName", row.getString("CREATED_BY_NAME"));
                    }
                    if (row.getString("COMMENT_DESC") != null)
                    {
                        wbo.setAttribute("comment", row.getString("COMMENT_DESC"));
                    }
                    if (row.getString("CREATION_TIME") != null)
                    {
                        wbo.setAttribute("creationTime", row.getString("CREATION_TIME"));
                    }
                    if (row.getString("clCreation_time") != null)
                    {
                        wbo.setAttribute("clCreation_time", row.getString("clCreation_time"));
                    }
                    if (row.getString("CAMPAIGN_TITLE") != null)
                    {
                        wbo.setAttribute("CAMPAIGN_TITLE", row.getString("CAMPAIGN_TITLE"));
                    }
                    data.add(wbo);
                }
                catch (NoSuchColumnException ex)
                {
                    logger.error(ex);
                }
            }

            return data;
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }

        return new ArrayList<WebBusinessObject>();
    }

    public String getLastClientPhone()
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        String phoneNumber = "";
        String id = "";
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery("select * from test_phone where id in (select max(id) from test_phone)");
            result = command.executeQuery();
            for (Row row : result)
            {
                try
                {
                    if (row.getString("PHONE") != null)
                    {
                        phoneNumber = row.getString("PHONE");
                    }
                    if (row.getString("ID") != null)
                    {
                        id = row.getString("ID");
                    }
                }
                catch (NoSuchColumnException ex)
                {
                    logger.error(ex);
                }
            }
            command.setSQLQuery("delete from test_phone");
            command.executeUpdate();

        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return phoneNumber;
    }

    public WebBusinessObject getClientByUnitID(String unitID) throws SQLException
    {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector parameters = new Vector();

        parameters.addElement(new StringValue(unitID));
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientByUnitID").trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());

        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            connection.close();
        }
        Row r;
        if (!queryResult.isEmpty())
        {
            Enumeration e = queryResult.elements();
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            return wbo;
        }
        else
        {
            return null;
        }
    }

    public ArrayList<WebBusinessObject> getGroupSummary(String groupId, java.sql.Date fromDate, java.sql.Date toDate)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> rows;
        WebBusinessObject wbo;
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy");
        String query = getQuery("getGroupSummary").trim().replaceAll("groupID", groupId).replaceAll("fromDate",
                sdf.format(fromDate)).replaceAll("toDate", sdf.format(toDate));
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query);
            rows = command.executeQuery();

            ArrayList<WebBusinessObject> results = new ArrayList<>();
            for (Row row : rows)
            {
                try
                {
                    wbo = fabricateBusObj(row);
                    if (row.getBigDecimal("TOTAL_CLIENTS") != null)
                    {
                        wbo.setAttribute("totalClients", row.getBigDecimal("TOTAL_CLIENTS") + "");
                    }
                    else
                    {
                        wbo.setAttribute("totalClients", "0");
                    }
                    if (row.getBigDecimal("TOTAL_COMMENTS") != null)
                    {
                        wbo.setAttribute("totalComments", row.getBigDecimal("TOTAL_COMMENTS") + "");
                    }
                    else
                    {
                        wbo.setAttribute("totalComments", "0");
                    }
                    if (row.getBigDecimal("TOTAL_APPOINTMENTS") != null)
                    {
                        wbo.setAttribute("totalAppointments", row.getBigDecimal("TOTAL_APPOINTMENTS") + "");
                    }
                    else
                    {
                        wbo.setAttribute("totalAppointments", "0");
                    }
                    if (row.getBigDecimal("TOTAL_FINISH") != null)
                    {
                        wbo.setAttribute("totalFinish", row.getBigDecimal("TOTAL_FINISH") + "");
                    }
                    else
                    {
                        wbo.setAttribute("totalFinish", "0");
                    }
                    if (row.getBigDecimal("TOTAL_CLOSURE") != null)
                    {
                        wbo.setAttribute("totalClosure", row.getBigDecimal("TOTAL_CLOSURE") + "");
                    }
                    else
                    {
                        wbo.setAttribute("totalClosure", "0");
                    }
                    if (row.getBigDecimal("TOTAL_CONFIRMED") != null)
                    {
                        wbo.setAttribute("totalConfirmed", row.getBigDecimal("TOTAL_CONFIRMED") + "");
                    }
                    else
                    {
                        wbo.setAttribute("totalConfirmed", "0");
                    }
                    if (row.getBigDecimal("TOTAL_NON_CONFIRMED") != null)
                    {
                        wbo.setAttribute("totalNonConfirmed", row.getBigDecimal("TOTAL_NON_CONFIRMED") + "");
                    }
                    else
                    {
                        wbo.setAttribute("totalNonConfirmed", "0");
                    }
                    if (row.getString("USER_NAME") != null)
                    {
                        wbo.setAttribute("userName", row.getString("USER_NAME"));
                    }
                    if (row.getString("CREATED_BY") != null)
                    {
                        wbo.setAttribute("createdBy", row.getString("CREATED_BY"));
                    }
                    results.add(wbo);
                }
                catch (NoSuchColumnException ex)
                {
                    logger.error("SQL Exception  " + ex.getMessage());

                }
                catch (UnsupportedConversionException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
            }
            return results;
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }

    public ArrayList<WebBusinessObject> getClientsByProject(String projectID, java.sql.Date beginDate, java.sql.Date endDate, boolean hasVisits)
    {
        Vector param = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        StringBuilder where = new StringBuilder();
        if (hasVisits) {
            where.append(" AND C.SYS_ID IN (SELECT CLIENT_ID FROM APPOINTMENT WHERE OPTION9 = 'attended') ");
        }
        String query = getQuery("getClientsByProject").trim() + where.toString();
        try
        {
            param.addElement(new StringValue(projectID));
            param.addElement(new StringValue(projectID));
            param.addElement(new DateValue(beginDate));
            param.addElement(new DateValue(endDate));
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException se)
        {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
            return null;
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        if (queryResult != null)
        {
            WebBusinessObject wbo;
            Row r;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements())
            {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                try
                {
                    if (r.getString("interestingTime") != null)
                    {
                        wbo.setAttribute("interestedTime", r.getString("interestingTime"));
                    }
                    else
                    {
                        wbo.setAttribute("interestedTime", "---");
                    }
                    if (r.getString("createdBy") != null)
                    {
                        wbo.setAttribute("createdBy", r.getString("createdBy"));
                    }
                    else
                    {
                        wbo.setAttribute("createdBy", "---");
                    }
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                resultBusObjs.add(wbo);
            }
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getClosedClients(java.sql.Date fromDate, java.sql.Date toDate)
    {
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        String query = getQuery("getClosedClients").trim();
        Vector params = new Vector();
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException se)
        {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
            return null;
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        if (queryResult != null)
        {
            WebBusinessObject wbo;
            Row r;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements())
            {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                try
                {
                    if (r.getString("BUSINESS_ID") != null)
                    {
                        wbo.setAttribute("businessID", r.getString("BUSINESS_ID"));
                    }
                    if (r.getString("BUSINESS_ID_BY_DATE") != null)
                    {
                        wbo.setAttribute("businessIDByDate", r.getString("BUSINESS_ID_BY_DATE"));
                    }
                    if (r.getString("SALESMAN_NAME") != null)
                    {
                        wbo.setAttribute("slaesmanName", r.getString("SALESMAN_NAME"));
                    }
                    if (r.getString("CLOSED_BY_NAME") != null)
                    {
                        wbo.setAttribute("closedByName", r.getString("CLOSED_BY_NAME"));
                    }
                    wbo.setAttribute("endDate", r.getString("END_DATE") != null ? r.getString("END_DATE").substring(0, 16) : "");
                }
                catch (NoSuchColumnException ex)
                {
                    logger.error(ex);
                }
                resultBusObjs.add(wbo);
            }
        }
        return resultBusObjs;
    }

    public Vector getAbstrcatClient(String groupID)
    {
        Vector data = new Vector();
        Connection connection = null;
        Vector param = new Vector();
        param.addElement(new StringValue(groupID));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getAbstractClient").trim());
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();

            // process the vector
            // vector of business objects
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;

            while (e.hasMoreElements())
            {
                Row row = (Row) e.nextElement();
                wbo = fabricateBusObj(row);

                try
                {
                    if (row.getString("client_count") != null)
                    {
                        wbo.setAttribute("client_count", row.getString("client_count"));
                    }
                    if (row.getString("User_name") != null)
                    {
                        wbo.setAttribute("User_name", row.getString("User_name"));
                    }
                }
                catch (NoSuchColumnException ex)
                {
                    logger.error(ex);
                }

                data.addElement(wbo);
            }
        }
        catch (SQLException se)
        {
            logger.error("troubles closing connection " + se.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        catch (Exception ex)
        {
            logger.error(ex.getMessage());
            return null;
        }
        finally
        {
            try
            {
                connection.close();
            }
            catch (SQLException sex)
            {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }

        return data;
    }

    public ArrayList<WebBusinessObject> getCampaignClients(String campaignID, String startDate, String endDate)
    {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new StringValue(campaignID));
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            StringBuilder sql = new StringBuilder(getQuery("getCampaignClients").trim());
            if (startDate != null && !startDate.isEmpty())
            {
                sql.append(" and cc.CREATION_TIME >= ?");
                params.addElement(new TimestampValue(java.sql.Timestamp.valueOf(startDate + " 00:00:01")));
            }
            if (endDate != null && !endDate.isEmpty())
            {
                sql.append(" and cc.CREATION_TIME <= ?");
                params.addElement(new TimestampValue(java.sql.Timestamp.valueOf(endDate + " 23:59:59")));
            }
            forQuery.setSQLQuery(sql.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();

        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());

        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());

        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        Row r;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try
            {
                if (r.getString("CREATED_BY_NAME") != null)
                {
                    wbo.setAttribute("createdByName", r.getString("CREATED_BY_NAME"));

                }
            }
            catch (NoSuchColumnException ex)
            {
                Logger.getLogger(ClientMgr.class
                        .getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getCampaignSolidClients(String campaignID, String startDate, String endDate)
    {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new StringValue(campaignID));
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            StringBuilder sql = new StringBuilder(getQuery("getCampaignSolidClients").trim());
            if (startDate != null && !startDate.isEmpty())
            {
                sql.append(" and cc.CREATION_TIME >= ?");
                params.addElement(new TimestampValue(java.sql.Timestamp.valueOf(startDate + " 00:00:01")));
            }
            if (endDate != null && !endDate.isEmpty())
            {
                sql.append(" and cc.CREATION_TIME <= ?");
                params.addElement(new TimestampValue(java.sql.Timestamp.valueOf(endDate + " 23:59:59")));
            }
            forQuery.setSQLQuery(sql.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();

        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());

        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());

        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        Row r;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try
            {
                if (r.getString("CREATED_BY_NAME") != null)
                {
                    wbo.setAttribute("createdByName", r.getString("CREATED_BY_NAME"));

                }
            }
            catch (NoSuchColumnException ex)
            {
                Logger.getLogger(ClientMgr.class
                        .getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getCampaignNonSoldClients(String campaignID, String startDate, String endDate) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new StringValue(campaignID));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            StringBuilder sql = new StringBuilder(getQuery("getCampaignNonSoldClients").trim());
            if (startDate != null && !startDate.isEmpty()) {
                sql.append(" and cc.CREATION_TIME >= ?");
                params.addElement(new TimestampValue(java.sql.Timestamp.valueOf(startDate + " 00:00:01")));
            }
            if (endDate != null && !endDate.isEmpty()) {
                sql.append(" and cc.CREATION_TIME <= ?");
                params.addElement(new TimestampValue(java.sql.Timestamp.valueOf(endDate + " 23:59:59")));
            }
            forQuery.setSQLQuery(sql.toString());
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
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("CREATED_BY_NAME") != null) {
                    wbo.setAttribute("createdByName", r.getString("CREATED_BY_NAME"));

                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientMgr.class
                        .getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getEmployeeClientsWithCampaign(String employeeID, String campaignID, String startDate, String endDate)
    {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new StringValue(campaignID));
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            StringBuilder sql = new StringBuilder(getQuery("getCampaignClients").trim());
            if (startDate != null && !startDate.isEmpty())
            {
                sql.append(" and cc.CREATION_TIME >= ?");
                params.addElement(new TimestampValue(java.sql.Timestamp.valueOf(startDate + " 00:00:01")));
            }
            if (endDate != null && !endDate.isEmpty())
            {
                sql.append(" and cc.CREATION_TIME <= ?");
                params.addElement(new TimestampValue(java.sql.Timestamp.valueOf(endDate + " 23:59:59")));
            }
            if (employeeID != null && !employeeID.isEmpty()) {
                sql.append(" and CL.CURRENT_OWNER_ID = '").append(employeeID).append("'");
            }
            forQuery.setSQLQuery(sql.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();

        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());

        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());

        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        Row r;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try
            {
                if (r.getString("CREATED_BY_NAME") != null)
                {
                    wbo.setAttribute("createdByName", r.getString("CREATED_BY_NAME"));
                }
                if (r.getString("CURRENT_OWNER_NAME") != null)
                {
                    wbo.setAttribute("currentOwnerName", r.getString("CURRENT_OWNER_NAME"));
                }
                if (r.getString("CLIENT_RATE") != null)
                {
                    wbo.setAttribute("clientRate", r.getString("CLIENT_RATE"));

                }
                wbo.setAttribute("businessID", r.getString("BUSINESS_ID") != null ? r.getString("BUSINESS_ID") : "");
            }
            catch (NoSuchColumnException ex)
            {
                Logger.getLogger(ClientMgr.class
                        .getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public Vector getNonFollowersClientsSummary(String groupID, java.sql.Date fromDate, java.sql.Date toDate)
    {
        Vector data = new Vector();
        Connection connection = null;
        Vector param = new Vector();
        param.addElement(new DateValue(fromDate));
        param.addElement(new DateValue(toDate));
        param.addElement(new DateValue(fromDate));
        param.addElement(new DateValue(toDate));
        param.addElement(new StringValue(groupID));
        Vector queryResult;
        SQLCommandBean forQuery = new SQLCommandBean();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getNonFollowersClientsSummary").trim());
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            while (e.hasMoreElements())
            {
                Row row = (Row) e.nextElement();
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getString("CLIENT_COUNT") != null)
                    {
                        wbo.setAttribute("clientCount", row.getString("CLIENT_COUNT"));
                    }
                    if (row.getString("USER_NAME") != null)
                    {
                        wbo.setAttribute("userName", row.getString("USER_NAME"));
                    }
                }
                catch (NoSuchColumnException ex)
                {
                    logger.error(ex);
                }
                data.addElement(wbo);
            }
        }
        catch (SQLException se)
        {
            logger.error("troubles closing connection " + se.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        catch (Exception ex)
        {
            logger.error(ex.getMessage());
            return null;
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException sex)
            {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getAverageResponseSpeed(java.sql.Date fromDate, java.sql.Date toDate, String departmentID, String campaignID)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> rows;
        Vector parameters = new Vector();
        WebBusinessObject wbo;

        parameters.addElement(new DateValue(fromDate));
        parameters.addElement(new DateValue(toDate));
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getAverageResponseSpeed").trim()
                    .replaceAll("departmentID", departmentID != null ? departmentID : "")
                    .replaceAll("campaignID", campaignID != null ? campaignID : ""));
            command.setparams(parameters);
            rows = command.executeQuery();

            ArrayList<WebBusinessObject> results = new ArrayList<>();
            for (Row row : rows)
            {
                try
                {
                    wbo = fabricateBusObj(row);
                    if (row.getTimestamp("FIRST_COMMENT_DATE") != null)
                    {
                        wbo.setAttribute("firstCommentDate", row.getString("FIRST_COMMENT_DATE"));
                    }
                    if (row.getTimestamp("FIRST_APPOINTMENT_DATE") != null)
                    {
                        wbo.setAttribute("firstAppointmentDate", row.getString("FIRST_APPOINTMENT_DATE"));
                    }
                    results.add(wbo);
                }
                catch (NoSuchColumnException ex)
                {
                    logger.error("SQL Exception  " + ex.getMessage());

                }
                catch (UnsupportedConversionException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
            }
            return results;
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }

    public List<WebBusinessObject> getClientsLastAppointmentByOwner(String createdBy, String from, String to, List<WebBusinessObject> employeeList, String rateID,String campaign)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result = null;
        Vector parameters = new Vector();

        StringBuilder where = new StringBuilder();

        if (createdBy.isEmpty())
        {

            where.append("(");
            for (int i = 0; i < employeeList.size(); i++)
            {
                WebBusinessObject mywbo = employeeList.get(i);
                String user_id = (String) mywbo.getAttribute("userId");
                where.append("   AP.USER_ID = '").append(user_id).append("'");
                if (i != (employeeList.size() - 1))
                {
                    where.append(" or");
                }
            }
            where.append(") ");
        }
        else
        {
            where.append(" AP.USER_ID LIKE ? ");
            parameters.addElement(new StringValue(createdBy));
        }
        if (rateID != null && !rateID.isEmpty()) {
            if ("1".equals(rateID)) {
                where.append(" AND CR.RATE_ID IS NULL");
            } else {
                where.append(" AND CR.RATE_ID = ? ");
                parameters.addElement(new StringValue(rateID));
            }
        }
        if (campaign!= null && !campaign.isEmpty() ){
             where.append(" AND  CCP.CAMPAIGN_ID= ?");
             parameters.addElement(new StringValue(campaign));
        }
        parameters.addElement(new StringValue(from));
        parameters.addElement(new StringValue(to));
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getClientsLastAppointmentByOwner").replaceAll("wherestatment", where.toString()).trim());
            command.setparams(parameters);
            result = command.executeQuery();

            List<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getString("USER_ID") != null)
                    {
                        wbo.setAttribute("createdBy", row.getString("USER_ID"));
                    }
                    if (row.getString("CREATED_BY_NAME") != null)
                    {
                        wbo.setAttribute("createdByName", row.getString("CREATED_BY_NAME"));
                    }
                    if (row.getString("NOTE") != null)
                    {
                        wbo.setAttribute("note", row.getString("NOTE"));
                    }
                    if (row.getString("CREATION_TIME") != null)
                    {
                        wbo.setAttribute("creationTime", row.getString("CREATION_TIME"));
                    }
//                    if (row.getString("APPOINTMENT_DATE") != null)
//                    {
//                        wbo.setAttribute("appointmentDate", row.getString("APPOINTMENT_DATE"));
//                    }
//                    if (row.getString("OPTION2") != null)
//                    {
//                        wbo.setAttribute("option2", row.getString("OPTION2"));
//                    }
//                    else
//                    {
//                        wbo.setAttribute("option2", "");
//                    }
                    if (row.getString("COMMENT") != null)
                    {
                        wbo.setAttribute("comment", row.getString("COMMENT"));
                    }
                    else
                    {
                        wbo.setAttribute("comment", "");
                    }
//                    if (row.getString("FCom") != null)
//                    {
//                        wbo.setAttribute("FCom", row.getString("FCom"));
//                    }
//                    else
//                    {
//                        wbo.setAttribute("comment", "");
//                    }
//                    if (row.getString("CALL_DURATION") == null)
//                    {
//                        wbo.setAttribute("callDuration", "0");
//                    }
//                    else
//                    {
//                        wbo.setAttribute("callDuration", row.getString("CALL_DURATION"));
//                    }
                    String phone;
                    if (row.getString("PHONE") != null)
                    {
                        if (!row.getString("PHONE").equals("UL"))
                        {
                            phone = row.getString("PHONE");
                        }
                        else
                        {
                            phone = "";
                        }
                        wbo.setAttribute("phone", phone);
                    }
                    String mobile;
                    if (row.getString("MOBILE") != null)
                    {
                        if (!row.getString("MOBILE").equals("UL"))
                        {
                            mobile = row.getString("MOBILE");
                        }
                        else
                        {
                            mobile = "";
                        }
                        wbo.setAttribute("mobile", mobile);
                    }
                    String intr;
                    if (row.getString("INTER_PHONE") != null)
                    {
                        if (!row.getString("INTER_PHONE").equals("UL"))
                        {
                            intr = row.getString("INTER_PHONE");
                        }
                        else
                        {
                            intr = "";
                        }
                        wbo.setAttribute("interPhone", intr);
                    }
                    wbo.setAttribute("rateName", row.getString("RATE_NAME") != null ? row.getString("RATE_NAME") : "");
                    wbo.setAttribute("clientCreationTime", row.getString("clientCreationTime") != null ? row.getString("clientCreationTime") : "");
                    wbo.setAttribute("campaignTitle", row.getString("CAMPAIGN_TITLE") != null ? row.getString("CAMPAIGN_TITLE") : "");
                    data.add(wbo);
                }
                catch (NoSuchColumnException ex)
                {
                    logger.error(ex);
                }
            }

            return data;
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }

        return new ArrayList<>();
    }

    public ArrayList<WebBusinessObject> getActiveClientByOwner(String ownerID)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(ownerID));
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getActiveClientByOwner").trim());
            command.setparams(parameters);
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getString("PLAN_FLAG") != null)
                    {
                        wbo.setAttribute("planFlag", row.getString("PLAN_FLAG"));

                    }
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                try
                {
                    if (row.getString("STATUS_NAME") != null)
                    {
                        wbo.setAttribute("statusName", row.getString("STATUS_NAME"));

                    }
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;

        }
        catch (UnsupportedTypeException | SQLException ex)
        {
            Logger.getLogger(ClientMgr.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }

    public ArrayList<WebBusinessObject> getBuildingCustomers(String buildingID)
    {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;
        Vector param = new Vector();
        param.addElement(new StringValue(buildingID));
        Vector queryResult;
        SQLCommandBean forQuery = new SQLCommandBean();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getBuildingCustomers").trim());
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements())
            {
                Row row = (Row) e.nextElement();
                data.add(fabricateBusObj(row));
            }
        }
        catch (SQLException se)
        {
            logger.error("troubles closing connection " + se.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        catch (Exception ex)
        {
            logger.error(ex.getMessage());
            return null;
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException sex)
            {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getNonCustomersByOwner(String ownerID)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(ownerID));
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getNonCustomersByOwner").trim());
            command.setparams(parameters);
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getString("STATUS_NAME") != null)
                    {
                        wbo.setAttribute("statusName", row.getString("STATUS_NAME"));

                    }
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;

        }
        catch (UnsupportedTypeException | SQLException ex)
        {
            Logger.getLogger(ClientMgr.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }

    public ArrayList<WebBusinessObject> getCustomersClassification(String ownerID, Timestamp fromDate, Timestamp toDate, String clientRate, String prjID, String hashTag, String type, String campaignID)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(ownerID));
        parameters.addElement(new StringValue(ownerID));
        StringBuilder query = new StringBuilder(getQuery("getCustomersClassification1").trim());
        /*if (fromDate != null) {
            query.append(" AND TRUNC(CC.CREATION_TIME) >= TRUNC(?)");
            parameters.addElement(new TimestampValue(fromDate));
        }
        if (toDate != null) {
            query.append(" AND TRUNC(CC.CREATION_TIME) <= TRUNC(?)");
            parameters.addElement(new TimestampValue(toDate));
        }*/
        if (fromDate != null && toDate != null)
        {
            query.append(" and ");
            query.append("trunc(CC.CREATION_TIME) between ? and ?");
            parameters.addElement(new TimestampValue(fromDate));
            parameters.addElement(new TimestampValue(toDate));
        }
        if (type != null && !type.isEmpty()) {
            query.append(" AND CCT.TYPE_TAG LIKE '").append(type).append("%'");
        } 
        if (clientRate != null && !clientRate.isEmpty())
        {
            if ("1".equals(clientRate))
            {
                query.append(" AND CR.RATE_ID IS NULL");
            } 
            else if ("2".equals(clientRate))
            {
                query.append(" ");
            }
            else
                
            {
                query.append(" AND CR.RATE_ID = ?");
                parameters.addElement(new StringValue(clientRate));
            }
        }

        if (prjID != null && !prjID.isEmpty())
        {
            query.append(" AND CL.SYS_ID in (select CP.CLIENT_ID from CLIENT_PROJECTS cp where CP.PRODUCT_ID = 'interested' and (CP.PRODUCT_CATEGORY_ID = ? OR CP.PROJECT_ID = ?))");
            parameters.addElement(new StringValue(prjID));
            parameters.addElement(new StringValue(prjID));
        }

        if (hashTag != null && !hashTag.isEmpty())
        {
            query.append("AND IC.CUSTOMER_ID IN (SELECT AAP.CLIENT_ID FROM APPOINTMENT AAP WHERE AAP.USER_ID = ? AND LOWER(AAP.\"COMMENT\") LIKE LOWER('%").append(hashTag).append("%'))");
            parameters.addElement(new StringValue(ownerID));
        }
        if (campaignID != null && !campaignID.isEmpty()) {
            query.append(" AND IC.CUSTOMER_ID IN (SELECT CLIENT_ID FROM CLIENT_CAMPAIGN WHERE CAMPAIGN_ID = ?) ");
            parameters.addElement(new StringValue(campaignID));
        }

        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.toString());
            command.setparams(parameters);
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {   if (row.getString("interphone") != null)
                    {
                        wbo.setAttribute("interphone", row.getString("interphone"));
                    }
                    if (row.getString("CLASS_TITLE") != null)
                    {
                        wbo.setAttribute("classTitle", row.getString("CLASS_TITLE"));
                    }
                    if (row.getString("IMAGE_NAME") != null)
                    {
                        wbo.setAttribute("imageName", row.getString("IMAGE_NAME"));
                    }
                    if (row.getString("RATE_ID") != null)
                    {
                        wbo.setAttribute("rateID", row.getString("RATE_ID"));
                    }
                    if (row.getString("ENGLISHNAME") != null && !row.getString("ENGLISHNAME").equals("null"))
                    {
                        wbo.setAttribute("seasonName", row.getString("ENGLISHNAME"));
                    }
                    else
                    {
                        wbo.setAttribute("seasonName", "---");

                    }

                    try
                    {
                        if (row.getTimestamp("COMDATE") != null)
                        {
                            wbo.setAttribute("comDate", row.getTimestamp("COMDATE"));
                        }
                        else
                        {
                            wbo.setAttribute("comDate", "---");

                        }
                    }
                    catch (UnsupportedConversionException ex)
                    {
                        Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    try
                    {
                        if (row.getTimestamp("APPDATE") != null)
                        {
                            wbo.setAttribute("appDate", row.getTimestamp("APPDATE"));
                        }
                        else
                        {
                            wbo.setAttribute("appDate", "---");

                        }
                    }
                    catch (UnsupportedConversionException ex)
                    {
                        Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    try
                    {
                        if (row.getTimestamp("appointment_date") != null)
                        {
                            wbo.setAttribute("appointment_date", row.getTimestamp("appointment_date"));
                        }
                        else
                        {
                            wbo.setAttribute("appointment_date", "---");

                        }
                    }
                    catch (UnsupportedConversionException ex)
                    {
                        Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    
                    if (row.getString("lstAppCom") != null)
                    {
                        wbo.setAttribute("lstAppCom", row.getString("lstAppCom"));
                    }
                    else
                    {
                        wbo.setAttribute("lstAppCom", "---");

                    }

                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;

        }
        catch (UnsupportedTypeException | SQLException ex)
        {
            Logger.getLogger(ClientMgr.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }

    public ArrayList<WebBusinessObject> getAllCustomersClassification()
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getAllCustomersClassification").trim());
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getString("CLASS_TITLE") != null)
                    {
                        wbo.setAttribute("classTitle", row.getString("CLASS_TITLE"));
                    }
                    if (row.getString("IMAGE_NAME") != null)
                    {
                        wbo.setAttribute("imageName", row.getString("IMAGE_NAME"));
                    }
                    if (row.getString("RATE_ID") != null)
                    {
                        wbo.setAttribute("rateID", row.getString("RATE_ID"));

                    }
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;

        }
        catch (UnsupportedTypeException | SQLException ex)
        {
            Logger.getLogger(ClientMgr.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }
//    public Vector getAbstrcatClients() {
//        Vector data = new Vector();
//        Connection connection = null;
//
//        Vector queryResult = null;
//        SQLCommandBean forQuery = new SQLCommandBean();
//
//        try {
//            connection = dataSource.getConnection();
//            forQuery.setConnection(connection);
//            forQuery.setSQLQuery(getQuery("getAbstractClients").trim());
//            queryResult = forQuery.executeQuery();
//
//            // process the vector
//            // vector of business objects
//            Enumeration e = queryResult.elements();
//            WebBusinessObject wbo;
//
//            while (e.hasMoreElements()) {
//                Row row = (Row) e.nextElement();
//                wbo = fabricateBusObj(row);
//
//                try {
//                    if (row.getString("client_count") != null) {
//                        wbo.setAttribute("client_count", row.getString("client_count"));
//                    }
//                    if (row.getString("User_name") != null) {
//                        wbo.setAttribute("User_name", row.getString("User_name"));
//                    }
//                } catch (NoSuchColumnException ex) {
//                    logger.error(ex);
//                }
//
//                data.addElement(wbo);
//            }
//        } catch (SQLException se) {
//            logger.error("troubles closing connection " + se.getMessage());
//        } catch (UnsupportedTypeException uste) {
//            logger.error("***** " + uste.getMessage());
//        } catch (Exception ex) {
//            logger.error(ex.getMessage());
//            return null;
//        } finally {
//            try {
//                connection.close();
//            } catch (SQLException sex) {
//                logger.error("troubles closing connection " + sex.getMessage());
//            }
//        }
//
//        return data;
//    }

    public ArrayList<ArrayList<String>> getRepeatedTelphone(String type)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;

        StringBuilder andStmt = new StringBuilder();

        if (type != null)
        {
            if (type.equals("mobileNum"))
            {
                andStmt.append("AND (Client.MOBILE <> 'UL') AND (Client.MOBILE <> ' ')");
            }
            else if (type.equals("UL"))
            {
                andStmt.append(" AND (Client.MOBILE = 'UL' OR Client.MOBILE = null OR Client.MOBILE = 'null' OR Client.MOBILE = '' OR Client.MOBILE = ' ')");
            }

        }

        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getRepeatedTelephone").replaceAll("andStmt", andStmt.toString()).trim());
            result = command.executeQuery();
            ArrayList<ArrayList<String>> data = new ArrayList<>();
            for (Row row : result)
            {
                ArrayList<String> object = new ArrayList<>();
                try
                {

                    /*if (row.getString("SYS_ID") != null) {
                     object.add(row.getString("SYS_ID"));
                     }*/
                    if (row.getString("MOBILE") != null)
                    {
                        object.add(row.getString("MOBILE"));
                    }
                    else
                    {
                        object.add("---");
                    }

                    if (row.getString("CLIENT_NO") != null)
                    {
                        object.add(row.getString("CLIENT_NO"));
                    }

                    if (row.getString("NAME") != null)
                    {
                        object.add(row.getString("NAME"));
                    }

                    if (row.getString("INTER_PHONE") != null && !"UL".equals(row.getString("INTER_PHONE"))) {
                        object.add(row.getString("INTER_PHONE"));
                    } else {
                        object.add("---");
                    }

                    if (row.getString("EMAIL") != null) {
                        object.add(row.getString("EMAIL"));
                    } else {
                        object.add("---");
                    }

                    String ViewURL = "<a target='blank' href='ClientServlet?op=clientDetails&clientId=" + row.getString("SYS_ID") + "'><image style='height:25px;' src='images/client_details.jpg' title='View'/></a>";
                    String DeleteURL = "<a target='blank' href='ClientServlet?op=DeleteRepeatedClient&clientID=" + row.getString("SYS_ID") + "&phn=1'><image style='height:25px;' src='images/icons/remove.png' title='Delete'/></a>";

                    object.add(ViewURL);
                    object.add(DeleteURL);

                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                data.add(object);
            }
            return data;

        }
        catch (UnsupportedTypeException | SQLException ex)
        {
            Logger.getLogger(ClientMgr.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }

    public ArrayList<WebBusinessObject> getRepeatedTelphoneWBO()
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getRepeatedTelephone").trim());
            result = command.executeQuery();

            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getString("MOBILE") != null)
                    {
                        wbo.setAttribute("mobile", row.getString("MOBILE"));
                    }
                    else
                    {
                        wbo.setAttribute("mobile", "---");
                    }

                    if (row.getString("CLIENT_NO") != null)
                    {
                        wbo.setAttribute("clientNO", row.getString("CLIENT_NO"));
                    }

                    if (row.getString("NAME") != null)
                    {
                        wbo.setAttribute("name", row.getString("NAME"));

                    }
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;

        }
        catch (UnsupportedTypeException | SQLException ex)
        {
            Logger.getLogger(ClientMgr.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }
    
    public ArrayList<WebBusinessObject> getClientChronOrder(String fromDate, String endDate, String empId)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector param = new Vector();
        param.addElement(new StringValue(fromDate));
        param.addElement(new StringValue(endDate));
        
        StringBuilder query = new StringBuilder("SELECT CL.*, UCL.CREATION_TIME AS CUSTDATE, CC.CREATION_TIME AS DISTDATE , (SELECT MIN(AP.CREATION_TIME) FROM APPOINTMENT AP WHERE AP.CLIENT_ID =  CL.SYS_ID) AS CLASSTIME FROM CLIENT CL LEFT JOIN USER_CLIENT_LOCK UCL ON CL.SYS_ID = UCL.CLIENT_ID LEFT JOIN ISSUE ISS ON CL.SYS_ID = ISS.URGENCY_ID LEFT JOIN CLIENT_COMPLAINTS CC ON ISS.ID = CC.ISSUE_ID WHERE CC.CREATION_TIME = (SELECT MIN(CREATION_TIME) FROM CLIENT_COMPLAINTS WHERE ISSUE_ID = ISS.ID) AND TRUNC(CL.CREATION_TIME) between to_date(?,'YYYY-MM-DD') and to_date(?,'YYYY-MM-DD')".trim());
        
        if(empId != null && !empId.equalsIgnoreCase("")){
            query.append("AND UCL.USER_ID = ?");
            param.addElement(new StringValue(empId));
        }
        Vector<Row> result;
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.toString());
            
            command.setparams(param);
            result = command.executeQuery();

            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getString("CUSTDATE") != null)
                    {
                        wbo.setAttribute("customizationDate", row.getString("CUSTDATE"));
                    }

                    if (row.getString("DISTDATE") != null)
                    {
                        wbo.setAttribute("distributionDate", row.getString("DISTDATE"));
                    }

                    if (row.getString("CLASSTIME") != null)
                    {
                        wbo.setAttribute("classificationDate", row.getString("CLASSTIME"));

                    }
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;

        }
        catch (UnsupportedTypeException | SQLException ex)
        {
            Logger.getLogger(ClientMgr.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }

    public ArrayList<WebBusinessObject> getRepeatedClientTelphoneWBO()
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getRepeatedClientTel").trim());
            result = command.executeQuery();

            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getString("MOBILE") != null)
                    {
                        wbo.setAttribute("mobile", row.getString("MOBILE"));
                    }
                    else
                    {
                        wbo.setAttribute("mobile", "---");
                    }

                    if (row.getString("PHONE") != null)
                    {
                        wbo.setAttribute("phone", row.getString("PHONE"));
                    }
                    else
                    {
                        wbo.setAttribute("phone", "---");
                    }

                    if (row.getString("INTER_PHONE") != null)
                    {
                        wbo.setAttribute("interPhone", row.getString("INTER_PHONE"));
                    }
                    else
                    {
                        wbo.setAttribute("interPhone", "---");
                    }

                    if (row.getString("CLIENT_NO") != null)
                    {
                        wbo.setAttribute("clientNO", row.getString("CLIENT_NO"));
                    }

                    if (row.getString("NAME") != null)
                    {
                        wbo.setAttribute("name", row.getString("NAME"));

                    }
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;

        }
        catch (UnsupportedTypeException | SQLException ex)
        {
            Logger.getLogger(ClientMgr.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }

    public boolean updateClientMobile(String clientNo, String mobile, String phone, String interPhone)
    {
        Connection connection = null;
        try
        {
            int queryResult = 0;
            Vector params = new Vector();
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);

            forInsert.setSQLQuery(getQuery("updateClientMobile").trim());

            params.addElement(new StringValue((String) phone));
            params.addElement(new StringValue((String) mobile));
            params.addElement(new StringValue((String) interPhone));
            params.addElement(new StringValue((String) clientNo));

            forInsert.setparams(params);

            queryResult = forInsert.executeUpdate();
            if (queryResult > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        catch (SQLException ex)
        {
            logger.error(ex);
            return false;
        }
        finally
        {
            if (connection != null)
            {
                try
                {
                    connection.setAutoCommit(true);
                    connection.close();

                }
                catch (SQLException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
    }

    public boolean updateClientPhone(String clientNo, String phone)
    {
        Connection connection = null;
        try
        {
            int queryResult = 0;
            Vector params = new Vector();
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);

            forInsert.setSQLQuery(getQuery("updateClientTelephon").trim());

            params.addElement(new StringValue((String) phone));
            params.addElement(new StringValue((String) clientNo));

            forInsert.setparams(params);

            queryResult = forInsert.executeUpdate();
            if (queryResult > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        catch (SQLException ex)
        {
            logger.error(ex);
            return false;
        }
        finally
        {
            if (connection != null)
            {
                try
                {
                    connection.setAutoCommit(true);
                    connection.close();

                }
                catch (SQLException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
    }

    public ArrayList getInterClients(String inetrCode)
    {
        Vector prm = new Vector();
        if (inetrCode == "")
        {
            prm.addElement(new StringValue(" "));
        }
        else
        {
            prm.addElement(new StringValue(inetrCode));
        }

        SQLCommandBean executeQuery = new SQLCommandBean();
        Vector resultQuery = new Vector();
        try
        {
            beginTransaction();
            executeQuery.setConnection(transConnection);
            executeQuery.setSQLQuery(getQuery("getIntterClients").trim());
            executeQuery.setparams(prm);
            resultQuery = executeQuery.executeQuery();
            endTransaction();
        }
        catch (Exception e)
        {
            logger.error("Could not execute Query");
        }
        ArrayList newData = new ArrayList();
        Row r = null;
        Enumeration e = resultQuery.elements();
        while (e.hasMoreElements())
        {
            WebBusinessObject wbo = null;
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if(r.getString("CURRENT_OWNER") != null) {
                    wbo.setAttribute("currentOwner", r.getString("CURRENT_OWNER"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            newData.add(wbo);
        }
        return newData;
    }

    public ArrayList getCountryClients()
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> rows;
        WebBusinessObject wbo;

        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getTotalClients1").trim());
            rows = command.executeQuery();

            HashMap<String, String> countyFlagsHM = new HashMap<String, String>();
            countyFlagsHM.put("00974", "Qatar.png");
            countyFlagsHM.put("00971", "Emirates.png");
            countyFlagsHM.put("00966", "KSA.png");
            countyFlagsHM.put("00965", "Kwait.png");
            countyFlagsHM.put("00973", "Bahrin.png");
            countyFlagsHM.put("00968", "Oman.png");
            countyFlagsHM.put("00213", "Algeria.png");
            countyFlagsHM.put("00964", "Iraq.png");
            countyFlagsHM.put("00967", "Yemen.png");
            countyFlagsHM.put("00963", "Syria.png");
            countyFlagsHM.put("00961", "Lebanon.png");

            ArrayList<WebBusinessObject> results = new ArrayList<>();
            for (Row row : rows)
            {
                try
                {
                    wbo = fabricateBusObj(row);
                    if (row.getString("Country_Code") != null)
                    {
                        if (row.getString("Country_Code") != null)
                        {
                            wbo.setAttribute("Country_Code", row.getString("Country_Code"));
                            if (countyFlagsHM.get(row.getString("Country_Code")) != null)
                            {
                                wbo.setAttribute("Country_Flag", countyFlagsHM.get(row.getString("Country_Code")));
                            }
                            else
                            {
                                wbo.setAttribute("Country_Flag", "unknown.png");
                            }

                        }
                        if (row.getBigDecimal("Total_Clients") != null)
                        {
                            wbo.setAttribute("Total_Clients", row.getString("Total_Clients"));
                        }
                        results.add(wbo);
                    }
                }
                catch (NoSuchColumnException ex)
                {
                    logger.error("SQL Exception  " + ex.getMessage());

                }
                catch (UnsupportedConversionException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
            }
            return results;
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }

    public ArrayList<WebBusinessObject> getInterLocalClients()
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> rows;
        WebBusinessObject wbo;
        ArrayList<WebBusinessObject> results = new ArrayList<>();

        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getTotalInterClients").trim());
            rows = command.executeQuery();

            for (Row row : rows)
            {
                try
                {
                    wbo = fabricateBusObj(row);
                    wbo.setAttribute("clientTyp", "International");
                    if (row.getBigDecimal("Total_Clients") != null)
                    {
                        wbo.setAttribute("Total_Clients", row.getString("Total_Clients"));
                    }
                    results.add(wbo);
                }
                catch (NoSuchColumnException ex)
                {
                    logger.error("SQL Exception  " + ex.getMessage());

                }
                catch (UnsupportedConversionException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }

        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getTotalLocalClients").trim());
            rows = command.executeQuery();

            for (Row row : rows)
            {
                try
                {
                    wbo = fabricateBusObj(row);
                    wbo.setAttribute("clientTyp", "Local");
                    if (row.getBigDecimal("Total_Clients") != null)
                    {
                        wbo.setAttribute("Total_Clients", row.getString("Total_Clients"));
                    }
                    results.add(wbo);
                }
                catch (NoSuchColumnException ex)
                {
                    logger.error("SQL Exception  " + ex.getMessage());

                }
                catch (UnsupportedConversionException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
            }
            return results;
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }

    public ArrayList<WebBusinessObject> getClientsCampaigns(Timestamp fromDate, Timestamp toDate, String campaignID, String extraCampaign, String projectID)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector parameters = new Vector();
        String query = getQuery("getClientsCampaigns").trim();
        StringBuilder where = new StringBuilder();
        if (fromDate != null)
        {
            where.append(" WHERE TRUNC(CL.CREATION_TIME) >= ?");
            parameters.addElement(new TimestampValue(fromDate));
        }
        if (toDate != null)
        {
            if (where.toString().isEmpty())
            {
                where.append(" WHERE ");
            }
            else
            {
                where.append(" AND ");
            }
            where.append(" TRUNC(CL.CREATION_TIME) <= ?");
            parameters.addElement(new TimestampValue(toDate));
        }
        if (campaignID != null && !campaignID.isEmpty())
        {
            if (where.toString().isEmpty())
            {
                where.append(" WHERE ");
            }
            else
            {
                where.append(" AND ");
            }
            where.append(" CM.CAMPAIGN_ID = ?");
            parameters.addElement(new StringValue(campaignID));
        }

        if (projectID != null && !projectID.isEmpty())
        {
            if (where.toString().isEmpty())
            {
                where.append(" WHERE ");
            }
            else
            {
                where.append(" AND ");
            }
            where.append(" CL.SYS_ID IN (SELECT CP.CLIENT_ID FROM CLIENT_PROJECTS CP WHERE CP.PRODUCT_CATEGORY_ID = ?) ");
            parameters.addElement(new StringValue(projectID));
        }

        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.replaceAll("whereStatement", where.toString()) + (extraCampaign != null ? "WHERE Time_Diff >= 1" : ""));
            command.setparams(parameters);
            result = command.executeQuery();

            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getString("CREATION_TIME") != null)
                    {
                        wbo.setAttribute("creationTime", row.getString("CREATION_TIME").substring(0, 10));
                    }
                    else
                    {
                        wbo.setAttribute("creationTime", "");
                    }
                    if (row.getString("CAMPAIGN_TITLE") != null)
                    {
                        wbo.setAttribute("campaignTitle", row.getString("CAMPAIGN_TITLE"));
                    }
                    else
                    {
                        wbo.setAttribute("campaignTitle", "None");
                    }
                    if (row.getTimestamp("CAMPAIGN_TIME") != null)
                    {
                        wbo.setAttribute("campaignTime", row.getString("CAMPAIGN_TIME").substring(0, 10));
                    }
                    else
                    {
                        wbo.setAttribute("campaignTime", "");
                    }
                    if (row.getString("OWNER_ID") != null)
                    {
                        wbo.setAttribute("ownerID", row.getString("OWNER_ID"));
                    }
                    else
                    {
                        wbo.setAttribute("ownerID", "");
                    }
                    if (row.getString("OWNER_NAME") != null)
                    {
                        wbo.setAttribute("ownerName", row.getString("OWNER_NAME"));
                    }
                    else
                    {
                        wbo.setAttribute("ownerName", "");
                    }
                    if (row.getString("BUSINESS_COMP_ID") != null)
                    {
                        wbo.setAttribute("businessCompID", row.getString("BUSINESS_COMP_ID"));
                    }
                    else
                    {
                        wbo.setAttribute("businessCompID", "");
                    }
                    if (row.getString("ISSUE_ID") != null)
                    {
                        wbo.setAttribute("issueID", row.getString("ISSUE_ID"));
                    }
                    else
                    {
                        wbo.setAttribute("issueID", "");
                    }
                    if (row.getBigDecimal("Time_Diff") != null)
                    {
                        wbo.setAttribute("Time_Diff", row.getString("Time_Diff"));
                    }
                    else
                    {
                        wbo.setAttribute("Time_Diff", "0");
                    }
                    if (row.getBigDecimal("REQUEST_AGE") != null)
                    {
                        wbo.setAttribute("requestAge", row.getString("REQUEST_AGE"));
                    }
                    else
                    {
                        wbo.setAttribute("requestAge", "0");
                    }
                    if (row.getString("SOURCE_NAME") != null)
                    {
                        wbo.setAttribute("sourceName", row.getString("SOURCE_NAME"));
                    }
                    else
                    {
                        wbo.setAttribute("sourceName", "");

                    }

                }
                catch (NoSuchColumnException | UnsupportedConversionException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;

        }
        catch (UnsupportedTypeException | SQLException ex)
        {
            Logger.getLogger(ClientMgr.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }

    public ArrayList<WebBusinessObject> getClientsOfCommChannels(Timestamp fromDate, Timestamp toDate, String channelID, String departmentID)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector parameters = new Vector();
        String query = getQuery("getClientsOfCommChannels").trim();
        StringBuilder where = new StringBuilder();
        if (fromDate != null)
        {
            where.append(" AND TRUNC(C.CREATION_TIME) >= ?");
            parameters.addElement(new TimestampValue(fromDate));
        }
        if (toDate != null)
        {
            where.append(" AND TRUNC(C.CREATION_TIME) <= ?");
            parameters.addElement(new TimestampValue(toDate));
        }
        if (channelID != null && !channelID.isEmpty())
        {
            where.append(" AND COM.ID = ?");
            parameters.addElement(new StringValue(channelID));
        }
        where.append(" AND C.CREATED_BY IN (SELECT USER_ID FROM USERS WHERE USER_ID IN (SELECT EMP_MGR.EMP_ID FROM EMP_MGR WHERE EMP_MGR.MGR_ID = (SELECT PROJECT.OPTION_ONE FROM PROJECT WHERE PROJECT.PROJECT_ID = '").append(departmentID).append("') UNION SELECT PROJECT.OPTION_ONE FROM PROJECT WHERE PROJECT.PROJECT_ID = '").append(departmentID).append("'").append("))");
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.replaceAll("wherecon", where.toString()));
            command.setparams(parameters);
            result = command.executeQuery();

            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getString("SYS_ID") != null)
                    {
                        wbo.setAttribute("clientId", row.getString("SYS_ID"));
                    }
                    else
                    {
                        wbo.setAttribute("clientId", "");
                    }
                    if (row.getString("CREATION_TIME") != null)
                    {
                        wbo.setAttribute("creationTime", row.getString("CREATION_TIME").substring(0, 10));
                    }
                    else
                    {
                        wbo.setAttribute("creationTime", "");
                    }
                    if (row.getString("camp") != null)
                    {
                        wbo.setAttribute("camp", row.getString("camp"));
                    }
                    else
                    {
                        wbo.setAttribute("camp", "None");
                    }
                    if (row.getString("comChannel") != null)
                    {
                        wbo.setAttribute("comChannel", row.getString("comChannel"));
                    }
                    else
                    {
                        wbo.setAttribute("comChannel", "غير محدد");
                    }
                    if (row.getString("createdBy") != null)
                    {
                        wbo.setAttribute("createdBy", row.getString("createdBy"));
                    }
                    else
                    {
                        wbo.setAttribute("createdBy", "");
                    }
                    if (row.getString("NAME") != null)
                    {
                        wbo.setAttribute("name", row.getString("NAME"));
                    }
                    else
                    {
                        wbo.setAttribute("name", "");
                    }
                    if (row.getString("MOBILE") != null)
                    {
                        wbo.setAttribute("mobile", row.getString("MOBILE"));
                    }
                    else
                    {
                        wbo.setAttribute("mobile", "");
                    }
                    if (row.getString("EMAIL") != null)
                    {
                        wbo.setAttribute("email", row.getString("EMAIL"));
                    }
                    else
                    {
                        wbo.setAttribute("email", "---");
                    }
                    if (row.getString("CLIENT_NO") != null)
                    {
                        wbo.setAttribute("clientNo", row.getString("CLIENT_NO"));
                    }
                    else
                    {
                        wbo.setAttribute("clientNo", "---");
                    }

                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;

        }
        catch (UnsupportedTypeException | SQLException ex)
        {
            Logger.getLogger(ClientMgr.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }

    public ArrayList<WebBusinessObject> getClientsNotInCampaign(Timestamp fromDate, Timestamp toDate, String campaignID)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector parameters = new Vector();
        String query = getQuery("getClientsNotInCampaign").trim();
        parameters.addElement(new StringValue(campaignID));
        StringBuilder where = new StringBuilder();
        if (fromDate != null)
        {
            where.append(" AND TRUNC(CL.CREATION_TIME) >= TRUNC(?)");
            parameters.addElement(new TimestampValue(fromDate));
        }
        if (toDate != null)
        {
            where.append(" AND TRUNC(CL.CREATION_TIME) <= TRUNC(?)");
            parameters.addElement(new TimestampValue(toDate));
        }
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query + where.toString());
            command.setparams(parameters);
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                data.add(wbo);
            }
            return data;

        }
        catch (UnsupportedTypeException | SQLException ex)
        {
            Logger.getLogger(ClientMgr.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }

    public void saveUsrLock(String clientID, String usrID, String createdBy)
    {
        Connection connection = null;
        try
        {
            int queryResult = 0;
            Vector params = new Vector();
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            String usrLockID = UniqueIDGen.getNextID();

            forInsert.setSQLQuery(getQuery("saveUsrLock").trim());

            params.addElement(new StringValue(usrLockID));
            params.addElement(new StringValue(usrID));
            params.addElement(new StringValue(clientID));
            params.addElement(new StringValue(createdBy));
            params.addElement(new TimestampValue(new Timestamp(System.currentTimeMillis())));

            forInsert.setparams(params);

            queryResult = forInsert.executeUpdate();
        }
        catch (SQLException ex)
        {
            logger.error(ex);
        }
        finally
        {
            if (connection != null)
            {
                try
                {
                    connection.setAutoCommit(true);
                    connection.close();

                }
                catch (SQLException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
    }

    public ArrayList<WebBusinessObject> getClientSourceCampaignCount(String campaignID, String startDate, String endDate)
    {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;
        Vector param = new Vector();
        param.addElement(new StringValue(campaignID));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        StringBuilder where = new StringBuilder();
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy");
        if (startDate != null && !startDate.isEmpty())
        {
            where.append(" AND TRUNC(C.CREATION_TIME) >= '").append(sdf.format(java.sql.Date.valueOf(startDate))).append("'");
        }
        if (endDate != null && !endDate.isEmpty())
        {
            where.append(" AND TRUNC(C.CREATION_TIME) <= '").append(sdf.format(java.sql.Date.valueOf(endDate))).append("'");
        }

        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientSourceCampaignCount").replaceAll("dateCondition", where.toString()).trim());
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            while (e.hasMoreElements())
            {
                Row row = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try
                {
                    if (row.getString("TOTAL") != null)
                    {
                        wbo.setAttribute("total", row.getString("TOTAL"));
                    }
                    if (row.getString("CREATED_BY_NAME") != null)
                    {
                        wbo.setAttribute("name", row.getString("CREATED_BY_NAME"));
                    }
                }
                catch (NoSuchColumnException ex)
                {
                    logger.error(ex);
                }
                data.add(wbo);
            }
        }
        catch (SQLException | UnsupportedTypeException e)
        {
            return null;
        }
        finally
        {
            try
            {
                connection.close();
            }
            catch (SQLException sex)
            {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }

        return data;
    }

    public ArrayList<WebBusinessObject> getClientResponsibleCampaignCount(String campaignID, String startDate, String endDate)
    {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Connection connection = null;
        Vector param = new Vector();
        param.addElement(new StringValue(campaignID));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        StringBuilder where = new StringBuilder();
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy");
        if (startDate != null && !startDate.isEmpty())
        {
            where.append(" AND TRUNC(C.CREATION_TIME) >= '").append(sdf.format(java.sql.Date.valueOf(startDate))).append("'");
        }
        if (endDate != null && !endDate.isEmpty())
        {
            where.append(" AND TRUNC(C.CREATION_TIME) <= '").append(sdf.format(java.sql.Date.valueOf(endDate))).append("'");
        }

        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientResponsibleCampaignCount").replaceAll("dateCondition", where.toString()).trim());
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
            Enumeration e = queryResult.elements();
            WebBusinessObject wbo;
            while (e.hasMoreElements())
            {
                Row row = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try
                {
                    if (row.getString("TOTAL") != null)
                    {
                        wbo.setAttribute("total", row.getString("TOTAL"));
                    }
                    if (row.getString("CURRENT_OWNER_NAME") != null)
                    {
                        wbo.setAttribute("name", row.getString("CURRENT_OWNER_NAME"));
                    }
                }
                catch (NoSuchColumnException ex)
                {
                    logger.error(ex);
                }
                data.add(wbo);
            }
        }
        catch (SQLException | UnsupportedTypeException e)
        {
            return null;
        }
        finally
        {
            try
            {
                connection.close();
            }
            catch (SQLException sex)
            {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }

        return data;
    }

    public List<WebBusinessObject> getMyUnHandledClients(String beginDate, String endDate, String createdBy, String campaignID, String description, String clientType, String loggedID, String lockBeginDate, String lockEndDate, String phoneNo, String projectID)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector queryResult = null;
        Vector prm = new Vector();
        //prm.addElement(new StringValue(loggedID));
        StringBuilder timeCondition = new StringBuilder();

        if (lockBeginDate != null && !lockBeginDate.isEmpty())
        {
            if (timeCondition.length() <= 0)
            {
                timeCondition.append("WHERE ");
            }
            timeCondition.append(" CREATION_TIME >= TO_DATE('").append(lockBeginDate).append(" 00:00:00','YYYY/MM/DD HH24:mi:ss')");
        }
        if (lockEndDate != null && !lockEndDate.isEmpty())
        {
            if (timeCondition.length() <= 0)
            {
                timeCondition.append("WHERE ");
            }
            else
            {
                timeCondition.append("AND ");
            }
            timeCondition.append(" CREATION_TIME <= TO_DATE('").append(lockEndDate).append(" 23:59:59','YYYY/MM/DD HH24:mi:ss')");
        }

        StringBuilder query = new StringBuilder(getQuery("getMyUnHandledClients").replaceAll("timeCondition", timeCondition.toString()).trim());

        if (beginDate != null && !beginDate.isEmpty())
        {
            query.append(" and cl.CREATION_TIME >= TO_DATE('").append(beginDate).append(" 00:00:00','YYYY/MM/DD HH24:mi:ss')");
        }
        if (endDate != null && !endDate.isEmpty())
        {
            query.append(" and cl.CREATION_TIME <= TO_DATE('").append(endDate).append(" 23:59:59','YYYY/MM/DD HH24:mi:ss')");
        }
        if (createdBy != null && !createdBy.isEmpty())
        {
            query.append(" u.receip_id = '").append(createdBy).append("'");
        }
        if (campaignID != null && !campaignID.isEmpty())
        {
            query.append(" and cc.CAMPAIGN_ID = '").append(campaignID).append("'");
        }
        if (description != null && !description.isEmpty())
        {
            query.append(" and (cl.DESCRIPTION like '%").append(description).append("%')");
        }
        if (clientType != null && !clientType.isEmpty())
        {
            query.append(" and cl.CURRENT_STATUS = '").append(clientType).append("'");
        }
        if (phoneNo != null && !phoneNo.isEmpty())
        {
            query.append(" and (cl.MOBILE = '").append(phoneNo).append("' or cl.INTER_PHONE = '")
                    .append(phoneNo).append("' or cl.PHONE = '").append(phoneNo).append("')");
        }
        //if (loggedID != null && !loggedID.isEmpty())
        //{
        //    query.append(" and ul.USER_ID = '").append(loggedID).append("'");
        //}

        if (projectID != null && !projectID.isEmpty())
        {
            query.append(" and cl.SYS_ID IN (SELECT CLIENT_ID FROM CLIENT_PROJECTS WHERE PRODUCT_CATEGORY_ID = '").append(projectID).append("') ");
        }

        query.append(" order by cl.CREATION_TIME desc");
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.toString());
            command.setparams(prm);
            queryResult = command.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error(ex);
        }
        catch (UnsupportedTypeException ex)
        {
            logger.error(ex);
        }
        finally
        {
            try
            {
                connection.close();
            }
            catch (SQLException ex)
            {
                logger.error(ex);
            }
        }

        List result = new ArrayList();
        if (queryResult != null)
        {
            Enumeration e = queryResult.elements();
            Row r;
            while (e.hasMoreElements())
            {
                try
                {
                    r = (Row) e.nextElement();
                    WebBusinessObject wbo = fabricateBusObj(r);
                    if (r.getString("full_name") != null)
                    {
                        wbo.setAttribute("createdByName", r.getString("full_name"));
                    }
                    if (r.getString("STATUS_NAME_AR") != null)
                    {
                        wbo.setAttribute("statusNameAr", r.getString("STATUS_NAME_AR"));
                    }
                    if (r.getString("STATUS_NAME_EN") != null)
                    {
                        wbo.setAttribute("statusNameEn", r.getString("STATUS_NAME_EN"));
                    }

                    if (r.getString("EMPNAME") != null)
                    {
                        wbo.setAttribute("empName", r.getString("EMPNAME"));
                    }
                    else
                    {
                        wbo.setAttribute("empName", "");
                    }

                    //if (r.getString("ID") != null)
                    //{
                    //    wbo.setAttribute("lckID", r.getString("ID"));
                    //}
                    //else
                    //{
                    //    wbo.setAttribute("lckID", "");
                    //}

                    result.add(wbo);

                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        return result;
    }

    public void removeLock(String LckID) throws SQLException
    {
        Connection connection = null;
        Vector params = new Vector();
        params.add(new StringValue(LckID));
        SQLCommandBean forUpdate = new SQLCommandBean();
        try
        {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("removeLock"));
            forUpdate.setparams(params);
            forUpdate.executeUpdate();
            connection.commit();
            connection.setAutoCommit(true);
        }
        catch (SQLException se)
        {
            logger.error("database error " + se.getMessage());
            if (connection != null)
            {
                connection.rollback();
            }
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.commit();
                    connection.close();
                }
            }
            catch (SQLException sex)
            {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
    }

    public ArrayList<WebBusinessObject> getExistingClientsLog(java.sql.Date fromDate, java.sql.Date toDate, String groupId)
    {
        Vector param = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        String query = getQuery("getExistingClientsLog").trim();
        try
        {
            param.addElement(new DateValue(fromDate));
            param.addElement(new DateValue(toDate));
            param.addElement(new StringValue(groupId));
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException se)
        {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
            return null;
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        if (queryResult != null)
        {
            WebBusinessObject wbo;
            Row r;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements())
            {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                try
                {
                    if (r.getString("EVENT_TIME") != null)
                    {
                        wbo.setAttribute("eventTime", r.getString("EVENT_TIME"));
                    }
                    if (r.getString("CURRENT_OWNER_NAME") != null)
                    {
                        wbo.setAttribute("currentOwnerName", r.getString("CURRENT_OWNER_NAME"));
                    }
                    if (r.getString("SOURCE_NAME") != null)
                    {
                        wbo.setAttribute("sourceName", r.getString("SOURCE_NAME"));

                    }
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                resultBusObjs.add(wbo);
            }
        }
        return resultBusObjs;
    }
    
    
    public ArrayList<WebBusinessObject> getCustomizedClients(String fromDate, String toDate, String empID, String groupId)
    {
        Vector param = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        StringBuilder query = new StringBuilder(getQuery("getCustomizedClients").trim());
        
        try
        {
            param.addElement(new StringValue(fromDate));
            param.addElement(new StringValue(toDate));
            param.addElement(new StringValue(groupId));
            
            
            if (empID != null && !empID.isEmpty() && empID != "")
            {
                query.append(" and UCL.USER_ID = ?");
                param.addElement(new StringValue(empID));
            }
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException se)
        {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
            return null;
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        if (queryResult != null)
        {
            WebBusinessObject wbo;
            Row r;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements())
            {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                try
                {
                    if (r.getString("NAME") != null)
                    {
                        wbo.setAttribute("clientNm", r.getString("NAME"));
                    } else {
                        wbo.setAttribute("clientNm", "");
                    }
                    
                    if (r.getString("USERNAME") != null)
                    {
                        wbo.setAttribute("empNm", r.getString("USERNAME"));
                    } else {
                        wbo.setAttribute("empNm", "");
                    }
                    
                    if (r.getString("CREATEDBY") != null)
                    {
                        wbo.setAttribute("createdBy", r.getString("CREATEDBY"));
                    } else {
                        wbo.setAttribute("createdBy", "");
                    }
                    
                    if (r.getString("CREATION_TIME") != null)
                    {
                        wbo.setAttribute("creationTime", r.getString("CREATION_TIME"));
                    }
                    
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                resultBusObjs.add(wbo);
            }
        }
        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> getCustomizedClientsChart(String fromDate, String toDate, String empID, String groupId)
    {
        Vector param = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        StringBuilder query = new StringBuilder(getQuery("getCustomizedClientsChart").trim());
        StringBuilder cond = new StringBuilder();
        try
        {
            param.addElement(new StringValue(fromDate));
            param.addElement(new StringValue(toDate));
            param.addElement(new StringValue(groupId));
            
            
            if (empID != null && !empID.isEmpty() && empID != "")
            {
                cond.append(" and UCL.USER_ID = ?");
                param.addElement(new StringValue(empID));
            }
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString().replaceAll("dateCon", cond.toString()).trim());
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException se)
        {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
            return null;
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        if (queryResult != null)
        {
            WebBusinessObject wbo;
            Row r;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements())
            {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                try
                {
                    if (r.getString("TOTAL") != null)
                    {
                        wbo.setAttribute("total", r.getString("TOTAL"));
                        wbo.setAttribute("y", Integer.parseInt(r.getString("TOTAL")));
                    }
                    
                    if (r.getString("USERNAME") != null)
                    {
                        wbo.setAttribute("empNm", r.getString("USERNAME"));
                    }
                    
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                resultBusObjs.add(wbo);
            }
        }
        return resultBusObjs;
    }

    public WebBusinessObject getClientFirstCommentAppointment(String clientID, String type)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> rows;
        Vector parameters = new Vector();
        WebBusinessObject wbo;

        parameters.addElement(new StringValue(clientID));
        parameters.addElement(new StringValue(clientID));
        parameters.addElement(new StringValue(clientID));
        parameters.addElement(new StringValue(clientID));
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getClientFirstCommentAppointment").trim());
            command.setparams(parameters);
            rows = command.executeQuery();
            for (Row row : rows)
            {
                try
                {
                    wbo = fabricateBusObj(row);
                    if ("comment".equals(type))
                    {
                        if (row.getString("COMMENT_DESC") != null)
                        {
                            wbo.setAttribute("comment", row.getString("COMMENT_DESC"));
                        }
                        if (row.getString("COMMENT_USER") != null)
                        {
                            wbo.setAttribute("userName", row.getString("COMMENT_USER"));
                        }
                    }
                    else
                    {
                        if (row.getString("APPOINTMENT_COMMENT") != null)
                        {
                            wbo.setAttribute("comment", row.getString("APPOINTMENT_COMMENT"));
                        }
                        if (row.getString("APPOINTMENT_USER") != null)
                        {
                            wbo.setAttribute("userName", row.getString("APPOINTMENT_USER"));
                        }
                    }
                    return wbo;
                }
                catch (NoSuchColumnException ex)
                {
                    logger.error("SQL Exception  " + ex.getMessage());
                }
            }
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return null;
    }

    public WebBusinessObject getClientKnownUsTotal(java.sql.Date fromDate, java.sql.Date toDate)
    {
        Vector param = new Vector();
        Connection connection = null;
        Vector<Row> rows = null;
        SQLCommandBean command = new SQLCommandBean();
        WebBusinessObject wbo = new WebBusinessObject();
        try
        {
            param.addElement(new DateValue(fromDate));
            param.addElement(new DateValue(toDate));
            param.addElement(new DateValue(fromDate));
            param.addElement(new DateValue(toDate));
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getClientKnownUsTotal").trim());
            command.setparams(param);
            rows = command.executeQuery();
            for (Row row : rows)
            {
                try
                {
                    if (row.getString("NO_DATA") != null)
                    {
                        wbo.setAttribute("noData", row.getString("NO_DATA"));
                    }
                    if (row.getString("HAVE_DATA") != null)
                    {
                        wbo.setAttribute("haveData", row.getString("HAVE_DATA"));
                    }
                    return wbo;
                }
                catch (NoSuchColumnException ex)
                {
                    logger.error("SQL Exception  " + ex.getMessage());
                }
            }
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return null;
    }

    public ArrayList<WebBusinessObject> getClientKnownUsStatistics(java.sql.Date fromDate, java.sql.Date toDate)
    {
        Vector param = new Vector();
        Connection connection = null;
        Vector<Row> rows = null;
        SQLCommandBean command = new SQLCommandBean();
        WebBusinessObject wbo;
        ArrayList<WebBusinessObject> result = new ArrayList<>();
        try
        {
            param.addElement(new DateValue(fromDate));
            param.addElement(new DateValue(toDate));
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getClientKnownUsStatistics").trim());
            command.setparams(param);
            rows = command.executeQuery();
            for (Row row : rows)
            {
                wbo = new WebBusinessObject();
                try
                {
                    if (row.getString("ID") != null)
                    {
                        wbo.setAttribute("id", row.getString("ID"));
                    }
                    if (row.getString("ENGLISHNAME") != null)
                    {
                        wbo.setAttribute("englishName", row.getString("ENGLISHNAME"));
                        wbo.setAttribute("name", row.getString("ENGLISHNAME"));
                    } else {
                        wbo.setAttribute("englishName", "No Channel");
                        wbo.setAttribute("name", "No Channel");
                    }
                    if (row.getString("ARABICNAME") != null)
                    {
                        wbo.setAttribute("arabicName", row.getString("ARABICNAME"));
                    } else {
                        wbo.setAttribute("arabicName", "No Channel");
                    }
                    if (row.getString("TOTAL") != null)
                    {
                        wbo.setAttribute("total", row.getString("TOTAL"));
                        wbo.setAttribute("y", Integer.parseInt(row.getString("TOTAL")));
                    }
                    if (row.getString("TOTAL_AMOUNT") != null) {
                        wbo.setAttribute("totalAmount", row.getString("TOTAL_AMOUNT"));
                    } else {
                        wbo.setAttribute("totalAmount", "0");
                    }
                    result.add(wbo);
                }
                catch (NoSuchColumnException ex)
                {
                    logger.error("SQL Exception  " + ex.getMessage());
                }
            }
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return result;
    }

    public ArrayList<WebBusinessObject> getOwnerClients()
    {
        Vector param = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        String query = getQuery("getOwnerClients").trim();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException se)
        {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
            return null;
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        if (queryResult != null)
        {
            WebBusinessObject wbo;
            Row r;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements())
            {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                try
                {
                    if (r.getString("SYS_ID") != null)
                    {
                        wbo.setAttribute("id", r.getString("SYS_ID"));
                    }
                    if (r.getString("NAME") != null)
                    {
                        wbo.setAttribute("name", r.getString("NAME"));
                    }
                    if (r.getString("CLIENT_NO") != null)
                    {
                        wbo.setAttribute("clientNO", r.getString("CLIENT_NO"));

                    }
                    if (r.getString("INTER_PHONE") != null)
                    {
                        wbo.setAttribute("interPhone", r.getString("INTER_PHONE"));

                    }
                    if (r.getString("CREATED_BY") != null)
                    {
                        wbo.setAttribute("createdBy", r.getString("CREATED_BY"));

                    }
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                resultBusObjs.add(wbo);
            }
        }
        return resultBusObjs;
    }

    public WebBusinessObject getIssueID(String ClientID)
    {
        WebBusinessObject wbo = null;
        Vector param = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        param.addElement(new StringValue(ClientID));

        String query = getQuery("getIssueID").trim();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException se)
        {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
            return null;
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        if (queryResult != null)
        {

            Row r;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements())
            {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                try
                {
                    if (r.getString("ID") != null)
                    {
                        wbo.setAttribute("issueID", r.getString("ID"));

                    }
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }

            }
        }
        return wbo;
    }

    public ArrayList<WebBusinessObject> getClientListForProductivity(String groupID, java.sql.Date fromDate, java.sql.Date toDate)
    {
        Vector param = new Vector();
        Connection connection = null;
        Vector<Row> rows = null;
        SQLCommandBean command = new SQLCommandBean();
        WebBusinessObject wbo;
        ArrayList<WebBusinessObject> result = new ArrayList<>();
        try
        {
            param.addElement(new StringValue(groupID));
            param.addElement(new DateValue(fromDate));
            param.addElement(new DateValue(toDate));
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getClientListForProductivity").trim());
            command.setparams(param);
            rows = command.executeQuery();
            for (Row row : rows)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getString("SOURCE_NAME") != null)
                    {
                        wbo.setAttribute("sourceName", row.getString("SOURCE_NAME"));

                    }
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                result.add(wbo);
            }
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return result;
    }

    public WebBusinessObject getIssueStatusID(String businessObjID)
    {
        WebBusinessObject wbo = null;
        Vector param = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        param.addElement(new StringValue(businessObjID));

        String query = getQuery("getIssueStatusID").trim();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException se)
        {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
            return null;
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        if (queryResult != null)
        {

            Row r;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements())
            {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                try
                {
                    if (r.getString("STATUS_ID") != null)
                    {
                        wbo.setAttribute("issueStatusID", r.getString("STATUS_ID"));
                    }
                    if (r.getString("BUSINESS_ID") != null)
                    {
                        wbo.setAttribute("bussinessID", r.getString("BUSINESS_ID"));

                    }
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }

            }
        }
        return wbo;
    }

    public Map<String, String> getClientsEmails()
    {
        Map<String, String> emailsMap = new HashMap<>();
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        String query = getQuery("getClientsEmails").trim();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException se)
        {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
            return null;
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        if (queryResult != null)
        {
            Row r;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements())
            {
                r = (Row) e.nextElement();
                try
                {
                    if (r.getString("EMAIL") != null)
                    {
                        emailsMap.put(r.getString("EMAIL"), r.getString("SYS_ID"));

                    }
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        return emailsMap;
    }

    public String saveClient(WebBusinessObject wbo) throws NoUserInSessionException, InterruptedException
    {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String id = UniqueIDGen.getNextID();
        params.addElement(new StringValue(id));
        params.addElement(new StringValue(id));
        params.addElement(new StringValue((String) wbo.getAttribute("ClientName")));
        params.addElement(new StringValue((String) wbo.getAttribute("ClientTel")));

        Connection connection = null;
        try
        {
            beginTransaction();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insertBokerClient").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            queryResult = -1000;

            try
            {
                Thread.sleep(100);
            }
            catch (InterruptedException ex)
            {
                logger.error(ex.getMessage());
            }

            ProjectMgr projectMgr = ProjectMgr.getInstance();
            WebBusinessObject projectWbo = projectMgr.getOnSingleKey(wbo.getAttribute("projectId").toString());
            WebBusinessObject mainProjectWbo = projectMgr.getOnSingleKey(projectWbo.getAttribute("mainProjId").toString());

            Vector paramsClientProject = new Vector();
            paramsClientProject.addElement(new StringValue(UniqueIDGen.getNextID()));
            paramsClientProject.addElement(new StringValue(id));
            paramsClientProject.addElement(new StringValue((String) wbo.getAttribute("projectId")));
            paramsClientProject.addElement(new StringValue((String) projectWbo.getAttribute("mainProjId")));
            paramsClientProject.addElement(new StringValue((String) projectWbo.getAttribute("projectName")));
            paramsClientProject.addElement(new StringValue((String) mainProjectWbo.getAttribute("projectName")));

            forInsert.setSQLQuery(getQuery("insertBokerClientProject").trim());
            forInsert.setparams(paramsClientProject);
            queryResult = forInsert.executeUpdate();

            endTransaction();
        }
        catch (SQLIntegrityConstraintViolationException se)
        {
            logger.error(se.getMessage());
            return "dublicate";
        }
        catch (SQLException ex)
        {
            logger.error(ex.getMessage());
            return ex.getMessage();
        }
        finally
        {
            try
            {
                connection.close();
            }
            catch (SQLException ex)
            {
                logger.error("Close Error");
                return ex.getMessage();
            }
        }

        return "ok";
    }

    public String saveClient(String clientName, String clientNumber) throws NoUserInSessionException, InterruptedException
    {
        Vector params = new Vector();
        Vector params2 = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String id = UniqueIDGen.getNextID();
        params.addElement(new StringValue(id));
        params.addElement(new StringValue(id));
        params.addElement(new StringValue(clientName));
        params.addElement(new StringValue(clientNumber));
        params.addElement(new StringValue("12"));
        
        String statusId = UniqueIDGen.getNextID();
        params2.addElement(new StringValue(statusId));
        params2.addElement(new StringValue(id));
        

        Connection connection = null;
        try
        {
            beginTransaction();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insertClientAndroid").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult > 0)
            {
                forInsert.setSQLQuery(getQuery("insertClientStatusAndroid").trim());
                forInsert.setparams(params2);
                queryResult = forInsert.executeUpdate();
            }
            endTransaction();
        }
        catch (SQLIntegrityConstraintViolationException se)
        {
            logger.error(se.getMessage());
            return "dublicate";
        }
        catch (SQLException ex)
        {
            logger.error(ex.getMessage());
            return ex.getMessage();
        }
        finally
        {
            try
            {
                connection.close();
            }
            catch (SQLException ex)
            {
                logger.error("Close Error");
                return ex.getMessage();
            }
        }

        return "ok";
    }

    public ArrayList getClientsBrokerProjects(java.sql.Date fromDate, java.sql.Date toDate, String clientID)
    {
        Vector queryResult = new Vector();
        WebBusinessObject wbo = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        StringBuilder query = new StringBuilder();
        Vector pram = new Vector();

        pram.addElement(new StringValue(clientID));

        if (fromDate != null)
        {
            query.append("AND trunc(PROJECT.CREATION_TIME) >= ?");
            pram.addElement(new DateValue(fromDate));
        }
        else
        {
            query.append("");
        }

        if (toDate != null)
        {
            query.append("AND trunc(PROJECT.CREATION_TIME) <= ?");
            pram.addElement(new DateValue(toDate));
        }
        else
        {
            query.append("");
        }

        try
        {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setparams(pram);
            forInsert.setSQLQuery(getQuery("getBokerClientProject").replaceAll("dateCon", query.toString()).trim());
            queryResult = forInsert.executeQuery();
            endTransaction();
        }
        catch (SQLException se)
        {
            logger.error(se.getMessage());

        }
        catch (UnsupportedTypeException ex)
        {
            Logger.getLogger(ClientMgr.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
        ArrayList resultBusObjs = new ArrayList();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try
            {
                if (r.getString("NAME") != null)
                {
                    wbo.setAttribute("ClientName", r.getString("NAME"));
                }

                if (r.getString("MOBILE") != null)
                {
                    wbo.setAttribute("ClientMobile", r.getString("MOBILE"));
                }

                if (r.getString("project_id") != null)
                {
                    wbo.setAttribute("project_id", r.getString("project_id"));
                }

                if (r.getString("PRODUCT_CATEGORY_ID") != null)
                {
                    wbo.setAttribute("productCategoryID", r.getString("PRODUCT_CATEGORY_ID"));
                }
                else
                {
                    wbo.setAttribute("productCategoryID", "---");
                }

                if (r.getString("PRODUCT_NAME") != null)
                {
                    wbo.setAttribute("projectName", r.getString("PRODUCT_NAME"));
                }
                else
                {
                    wbo.setAttribute("projectName", "---");
                }

                if (r.getString("PRODUCT_CATEGORY_NAME") != null)
                {
                    wbo.setAttribute("productCategoryName", r.getString("PRODUCT_CATEGORY_NAME"));
                }
                else
                {
                    wbo.setAttribute("productCategoryName", "---");
                }

                if (r.getString("PROJECT_DESCRIPTION") != null)
                {
                    wbo.setAttribute("productDesc", r.getString("PROJECT_DESCRIPTION"));
                }
                else
                {
                    wbo.setAttribute("productDesc", "---");

                }
            }
            catch (NoSuchColumnException ex)
            {
                Logger.getLogger(ClientMgr.class
                        .getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> GetClientsBirthDays(String clientStatus, String clientProject, String clientArea, String clientJob, String interCode)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector queryResult = null;
        WebBusinessObject wbo = null;
        StringBuilder query = new StringBuilder(getQuery("getClientBirthDay").trim());

        if (clientStatus != null && !clientStatus.equalsIgnoreCase("all")) {
            query.append(" AND client.CURRENT_STATUS = '").append(clientStatus).append("'");
        }
        if (clientArea != null && !clientArea.equalsIgnoreCase("all")) {
            query.append(" and client.REGION = '").append(clientArea).append("'");
        }
        if (clientProject != null && !clientProject.equalsIgnoreCase("all")) {
            query.append(" and client.SYS_ID in (select cp.CLIENT_ID from client_projects cp where cp.PRODUCT_CATEGORY_ID = '").append(clientProject).append("')");
        }
        if (clientJob != null && !clientJob.equalsIgnoreCase("all")) {
            query.append(" and client.JOB  = '").append(clientJob).append("'");
        }
        if (interCode != null && !interCode.isEmpty()) {
            query.append(" AND CLIENT.INTER_PHONE  LIKE '").append(interCode).append("%'");
        }

        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.toString());
            queryResult = command.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error(ex);
        }
        catch (UnsupportedTypeException ex)
        {
            logger.error(ex);
        }
        finally
        {
            try
            {
                connection.close();
            }
            catch (SQLException ex)
            {
                logger.error(ex);
            }
        }

        ArrayList result = new ArrayList();
        if (queryResult != null)
        {
            Enumeration e = queryResult.elements();
            Row r;
            while (e.hasMoreElements())
            {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                wbo = fabricateBusObj(r);
                try
                {
                    if (r.getString("SYS_ID") != null)
                    {
                        wbo.setAttribute("id", r.getString("SYS_ID"));
                    }

                    if (r.getString("CLIENT_NO") != null)
                    {
                        wbo.setAttribute("ClientNo", r.getString("CLIENT_NO"));
                    }

                    if (r.getString("NAME") != null)
                    {
                        wbo.setAttribute("ClientName", r.getString("NAME"));
                    }

                    if (r.getString("BIRTH_DATE") != null)
                    {
                        wbo.setAttribute("ClientBirthDate", r.getString("BIRTH_DATE"));
                    }
                    else
                    {
                        wbo.setAttribute("ClientBirthDate", "---");
                    }

                    if (r.getString("email") != null)
                    {
                        wbo.setAttribute("ClientEmail", r.getString("email"));
                    }
                    else
                    {
                        wbo.setAttribute("ClientEmail", "---");
                    }
                    if (r.getString("RATENAME") != null)
                    {
                        wbo.setAttribute("rateName", r.getString("RATENAME"));
                    }
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                result.add(wbo);
            }
        }

        return result;
    }
    
    public ArrayList<WebBusinessObject> GetClientsByEmail(String clientStatus, String clientProject, String clientArea, String clientJob, String interCode)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector queryResult = null;
        WebBusinessObject wbo = null;
        StringBuilder query = new StringBuilder(getQuery("getClientByEmail").trim());

        if (clientStatus != null && !clientStatus.equalsIgnoreCase("all")) {
            query.append(" AND client.CURRENT_STATUS = '").append(clientStatus).append("'");
        }
        if (clientArea != null && !clientArea.equalsIgnoreCase("all")) {
            query.append(" and client.REGION = '").append(clientArea).append("'");
        }
        if (clientProject != null && !clientProject.equalsIgnoreCase("all")) {
            query.append(" and client.SYS_ID in (select cp.CLIENT_ID from client_projects cp where cp.PRODUCT_CATEGORY_ID = '").append(clientProject).append("')");
        }
        if (clientJob != null && !clientJob.equalsIgnoreCase("all")) {
            query.append(" and client.JOB  = '").append(clientJob).append("'");
        }
        if (interCode != null && !interCode.isEmpty()) {
            query.append(" AND CLIENT.INTER_PHONE  LIKE '").append(interCode).append("%'");
        }

        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.toString());
            queryResult = command.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error(ex);
        }
        catch (UnsupportedTypeException ex)
        {
            logger.error(ex);
        }
        finally
        {
            try
            {
                connection.close();
            }
            catch (SQLException ex)
            {
                logger.error(ex);
            }
        }

        ArrayList result = new ArrayList();
        if (queryResult != null)
        {
            Enumeration e = queryResult.elements();
            Row r;
            while (e.hasMoreElements())
            {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                wbo = fabricateBusObj(r);
                try
                {
                    if (r.getString("SYS_ID") != null)
                    {
                        wbo.setAttribute("id", r.getString("SYS_ID"));
                    }

                    if (r.getString("CLIENT_NO") != null)
                    {
                        wbo.setAttribute("ClientNo", r.getString("CLIENT_NO"));
                    }

                    if (r.getString("NAME") != null)
                    {
                        wbo.setAttribute("ClientName", r.getString("NAME"));
                    }

                    if (r.getString("BIRTH_DATE") != null)
                    {
                        wbo.setAttribute("ClientBirthDate", r.getString("BIRTH_DATE"));
                    }
                    else
                    {
                        wbo.setAttribute("ClientBirthDate", "---");
                    }

                    if (r.getString("email") != null)
                    {
                        wbo.setAttribute("ClientEmail", r.getString("email"));
                    }
                    else
                    {
                        wbo.setAttribute("ClientEmail", "---");
                    }
                    if (r.getString("RATENAME") != null)
                    {
                        wbo.setAttribute("rateName", r.getString("RATENAME"));
                    }
                   

                    
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                result.add(wbo);
            }
        }

        return result;
    }

    public boolean upEmail(String email, String clientID)
    {
        Connection connection = null;
        try
        {
            int queryResult = 0;
            Vector params = new Vector();
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);

            forInsert.setSQLQuery(getQuery("upEmail").trim());

            params.addElement(new StringValue((String) email));
            params.addElement(new StringValue((String) clientID));

            forInsert.setparams(params);

            queryResult = forInsert.executeUpdate();
            if (queryResult > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        catch (SQLException ex)
        {
            logger.error(ex);
            return false;
        }
        finally
        {
            if (connection != null)
            {
                try
                {
                    connection.setAutoCommit(true);
                    connection.close();

                }
                catch (SQLException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
    }

    public WebBusinessObject getClientByMobile(String mobile)
    {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientByMobile").replace("mobileNo", mobile).trim());
            queryResult = forQuery.executeQuery();
            if (queryResult.isEmpty())
            {
                forQuery.setSQLQuery(getQuery("getClientByExtMobile").replace("mobileNo", mobile).trim());
                queryResult = forQuery.executeQuery();
            }
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());

        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        Row r;
        if (!queryResult.isEmpty())
        {
            Enumeration e = queryResult.elements();
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            return wbo;
        }
        else
        {
            return null;
        }
    }

    public ArrayList<WebBusinessObject> getPartnerClient(String searchval, String oClntID)
    {
        Vector queryResult = new Vector();
        WebBusinessObject wbo = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        StringBuilder val = new StringBuilder();
        Vector pram = new Vector();

        val.append(getQuery("getPartnerClient"));

        pram.addElement(new StringValue(oClntID));

        if (searchval != null && !searchval.isEmpty())
        {
            val.append(" AND ( CL.CLIENT_NO LIKE'%" + searchval + "%' OR CL.MOBILE LIKE'%" + searchval + "%' OR CL.PHONE LIKE'%" + searchval + "%' OR CL.INTER_PHONE LIKE'%" + searchval + "%' ) ");
        }

        try
        {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setparams(pram);
            forInsert.setSQLQuery(val.toString().trim());
            queryResult = forInsert.executeQuery();
            endTransaction();
        }
        catch (Exception ex)
        {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
        }

        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            try
            {
                if (r.getString("SYS_ID") != null)
                {
                    wbo.setAttribute("clntID", r.getString("SYS_ID"));
                }

                if (r.getString("CLIENT_NO") != null)
                {
                    wbo.setAttribute("clntNo", r.getString("CLIENT_NO"));
                }

                if (r.getString("NAME") != null)
                {
                    wbo.setAttribute("clntNm", r.getString("NAME"));
                }

                if (r.getString("MOBILE") != null)
                {
                    wbo.setAttribute("clntMb", r.getString("MOBILE"));
                }

                if (r.getString("PHONE") != null)
                {
                    wbo.setAttribute("clntPh", r.getString("PHONE"));
                }

                if (r.getString("INTER_PHONE") != null)
                {
                    wbo.setAttribute("clntIntPh", r.getString("INTER_PHONE"));
                }

                if (r.getString("EMAIL") != null)
                {
                    wbo.setAttribute("clntEML", r.getString("EMAIL"));
                }

            }
            catch (NoSuchColumnException ex)
            {
                Logger.getLogger(ClientMgr.class
                        .getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }

        if (searchval != null && !searchval.isEmpty())
        {
            pram = new Vector();

            pram.addElement(new StringValue(oClntID));

            val = new StringBuilder();
            val.append(searchval);

            try
            {
                beginTransaction();
                forInsert.setConnection(transConnection);
                forInsert.setparams(pram);
                forInsert.setSQLQuery(getQuery("getPartnerClientCom").replaceAll("val", val.toString()).trim());
                queryResult = forInsert.executeQuery();
                endTransaction();
            }
            catch (Exception ex)
            {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            r = null;
            e = queryResult.elements();
            while (e.hasMoreElements())
            {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                wbo = fabricateBusObj(r);
                try
                {
                    if (r.getString("SYS_ID") != null)
                    {
                        wbo.setAttribute("clntID", r.getString("SYS_ID"));
                    }

                    if (r.getString("CLIENT_NO") != null)
                    {
                        wbo.setAttribute("clntNo", r.getString("CLIENT_NO"));
                    }

                    if (r.getString("NAME") != null)
                    {
                        wbo.setAttribute("clntNm", r.getString("NAME"));
                    }

                    if (r.getString("MOBILE") != null)
                    {
                        wbo.setAttribute("clntMb", r.getString("MOBILE"));
                    }

                    if (r.getString("PHONE") != null)
                    {
                        wbo.setAttribute("clntPh", r.getString("PHONE"));
                    }

                    if (r.getString("INTER_PHONE") != null)
                    {
                        wbo.setAttribute("clntIntPh", r.getString("INTER_PHONE"));
                    }

                    if (r.getString("EMAIL") != null)
                    {
                        wbo.setAttribute("clntEML", r.getString("EMAIL"));
                    }

                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                resultBusObjs.add(wbo);
            }
        }

        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> selectUnratedCl(java.sql.Date fromDate, java.sql.Date toDate, String campaignID, String employeeID, String projectID, String type, String department)
    {
        ClientComplaintsMgr clientComplaintsMgr = new ClientComplaintsMgr();
        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
        clientComplaintsMgr.updateClientComplaintsType();

        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector params = new Vector();
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        StringBuilder where = new StringBuilder();
        if (campaignID != null && !campaignID.equals("''") && !campaignID.equals(""))
        {
            where.append(" AND CCT.STATUS_CODE NOT IN ('5', '6', '7') AND CL.SYS_ID IN (SELECT CC.CLIENT_ID FROM CLIENT_CAMPAIGN CC WHERE CC.CAMPAIGN_ID IN (")
                    .append(campaignID).append("))");
        }

        if (employeeID != null && !employeeID.isEmpty())
        {
            where.append(" AND CCT.STATUS_CODE NOT IN ('5', '6', '7') AND CCT.CURRENT_OWNER_ID = '").append(employeeID).append("'");
        }
        if (type != null && !type.isEmpty())
        {
            where.append(" AND CCT.STATUS_CODE NOT IN ('5', '6', '7') AND CCT.TYPE_TAG LIKE '").append(type).append("%'");
        }
        if (projectID != null && !projectID.isEmpty() && !projectID.equals("''") && !projectID.equals(""))
        {
            where.append(" AND CCT.STATUS_CODE NOT IN ('5', '6', '7') AND CL.SYS_ID IN (SELECT CLIENT_ID FROM CLIENT_PROJECTS WHERE PRODUCT_CATEGORY_ID = '").append(projectID).append("' or project_id = '").append(projectID).append("')");
        }

        if ((employeeID == null || employeeID.isEmpty()) && (department != null && !department.isEmpty() && !department.equalsIgnoreCase("all")))
        {
            where.append(" AND CCT.STATUS_CODE NOT IN ('5', '6', '7') AND CCT.CURRENT_OWNER_ID IN (SELECT USER_ID FROM USERS WHERE USER_ID IN (SELECT EMP_MGR.EMP_ID FROM EMP_MGR WHERE EMP_MGR.MGR_ID = (SELECT PROJECT.OPTION_ONE FROM PROJECT WHERE PROJECT.PROJECT_ID = '").append(department).append("') UNION SELECT PROJECT.OPTION_ONE FROM PROJECT WHERE PROJECT.PROJECT_ID = '").append(department).append("'").append("))");
        }
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("selectUnratedCl1").trim() + where.toString());
            command.setparams(params);
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getString("SYS_ID") != null)
                    {
                        wbo.setAttribute("clientID", row.getString("SYS_ID"));
                    }

                    if (row.getString("NAME") != null)
                    {
                        wbo.setAttribute("clientName", row.getString("NAME"));
                    }
                    if (row.getString("MOBILE") != null)
                    {
                        wbo.setAttribute("mobile", row.getString("MOBILE"));
                    }
                    if (row.getTimestamp("CREATION_TIME") != null)
                    {
                        wbo.setAttribute("clientCreationTime", row.getString("CREATION_TIME").substring(0, 16));
                    }
                    else
                    {
                        wbo.setAttribute("clientCreationTime", "");
                    }
                    if (row.getTimestamp("FNA") != null)
                    {
                        wbo.setAttribute("fna", row.getString("FNA"));
                    }
                    else
                    {
                        wbo.setAttribute("fna", "---");
                    }
                    if (row.getString("INTER_PHONE") != null)
                    {
                        wbo.setAttribute("interPhone", row.getString("INTER_PHONE"));
                    }
                    else
                    {
                        wbo.setAttribute("interPhone", "---");
                    }
                    if (row.getString("full_name") != null)
                    {
                        wbo.setAttribute("full_name", row.getString("full_name"));
                    }
                    else
                    {
                        wbo.setAttribute("full_name", "");
                    }
                    if (row.getString("sender_name") != null)
                    {
                        wbo.setAttribute("sender_name", row.getString("sender_name"));
                    }
                    else
                    {
                        wbo.setAttribute("sender_name", "");
                    }
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                catch (Exception ex)
                {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;
        }
        catch (UnsupportedTypeException | SQLException ex)
        {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }
    
    public ArrayList<WebBusinessObject> selectUnratedClForComChannels(java.sql.Date fromDate, java.sql.Date toDate, String channelID, String employeeID, String projectID, String type, String department)
    {
        ClientComplaintsMgr clientComplaintsMgr = new ClientComplaintsMgr();
        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
        clientComplaintsMgr.updateClientComplaintsType();

        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector params = new Vector();
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        StringBuilder where = new StringBuilder();
        if (channelID != null && !channelID.equals("''") && !channelID.equals(""))
        {
            where.append(" AND CL.OPTION3 IN (").append(channelID).append(")");
        }

        if (employeeID != null && !employeeID.isEmpty())
        {
            where.append(" AND CL.SYS_ID IN (SELECT ISS.URGENCY_ID FROM ISSUE ISS WHERE ISS.ID IN (SELECT CC.ISSUE_ID FROM CLIENT_COMPLAINTS CC WHERE CC.CURRENT_OWNER_ID IN ('").append(employeeID).append("' )))");
        }
        if (type != null && !type.isEmpty())
        {
            where.append(" AND CCT.TYPE_TAG LIKE '").append(type).append("%'");
        }
        if (projectID != null && !projectID.isEmpty() && !projectID.equals("''") && !projectID.equals(""))
        {
            where.append(" AND CL.SYS_ID IN (SELECT CLIENT_ID FROM CLIENT_PROJECTS WHERE PRODUCT_CATEGORY_ID = '").append(projectID).append("' or project_id = '").append(projectID).append("')");
        }

        if ((employeeID == null || employeeID.isEmpty()) && (department != null && !department.isEmpty() && !department.equalsIgnoreCase("all")))
        {
            where.append(" AND CL.SYS_ID IN (SELECT ISS.URGENCY_ID FROM ISSUE ISS WHERE ISS.ID IN (SELECT CC.ISSUE_ID FROM CLIENT_COMPLAINTS CC WHERE CC.CURRENT_OWNER_ID IN (SELECT USER_ID FROM USERS WHERE USER_ID IN (SELECT EMP_MGR.EMP_ID FROM EMP_MGR WHERE EMP_MGR.MGR_ID = (SELECT PROJECT.OPTION_ONE FROM PROJECT WHERE PROJECT.PROJECT_ID = '").append(department).append("') UNION SELECT PROJECT.OPTION_ONE FROM PROJECT WHERE PROJECT.PROJECT_ID = '").append(department).append("'").append("))))");
        }
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("selectUnratedCl").trim() + where.toString());
            command.setparams(params);
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getString("SYS_ID") != null)
                    {
                        wbo.setAttribute("clientID", row.getString("SYS_ID"));
                    }

                    if (row.getString("NAME") != null)
                    {
                        wbo.setAttribute("clientName", row.getString("NAME"));
                    }
                    if (row.getString("MOBILE") != null)
                    {
                        wbo.setAttribute("mobile", row.getString("MOBILE"));
                    }
                    if (row.getTimestamp("CREATION_TIME") != null)
                    {
                        wbo.setAttribute("clientCreationTime", row.getString("CREATION_TIME").substring(0, 16));
                    }
                    else
                    {
                        wbo.setAttribute("clientCreationTime", "");
                    }
                    if (row.getTimestamp("FNA") != null)
                    {
                        wbo.setAttribute("fna", row.getString("FNA"));
                    }
                    else
                    {
                        wbo.setAttribute("fna", "---");
                    }
                    if (row.getString("INTER_PHONE") != null)
                    {
                        wbo.setAttribute("interPhone", row.getString("INTER_PHONE"));
                    }
                    else
                    {
                        wbo.setAttribute("interPhone", "---");
                    }
                    if (row.getString("KNOWN_US_FROM") != null) {
                        wbo.setAttribute("knownUsFrom", row.getString("KNOWN_US_FROM"));
                    }
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                catch (Exception ex)
                {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;
        }
        catch (UnsupportedTypeException | SQLException ex)
        {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }

    public ArrayList<WebBusinessObject> selectAttendedClients(java.sql.Date fromDate, java.sql.Date toDate, String campaignID, String employeeID)
    {
        ClientComplaintsMgr clientComplaintsMgr = new ClientComplaintsMgr();
        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
        clientComplaintsMgr.updateClientComplaintsType();

        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector params = new Vector();
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        StringBuilder where = new StringBuilder();
        if (campaignID != null && !campaignID.equals("''") && !campaignID.equals(""))
        {
            where.append(" AND CL.SYS_ID IN (SELECT CC.CLIENT_ID FROM CLIENT_CAMPAIGN CC WHERE CC.CAMPAIGN_ID IN (")
                    .append(campaignID).append("))");
        }

        if (employeeID != null && !employeeID.isEmpty())
        {
            where.append(" AND CL.SYS_ID IN (SELECT ISS.URGENCY_ID FROM ISSUE ISS WHERE ISS.ID IN (SELECT CC.ISSUE_ID FROM CLIENT_COMPLAINTS CC WHERE CC.CURRENT_OWNER_ID IN ('").append(employeeID).append("' )))");
        }
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("selectUnratedClAttended").trim() + where.toString());
            command.setparams(params);
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getString("SYS_ID") != null)
                    {
                        wbo.setAttribute("clientID", row.getString("SYS_ID"));
                    }

                    if (row.getString("NAME") != null)
                    {
                        wbo.setAttribute("clientName", row.getString("NAME"));
                    }
                    if (row.getString("MOBILE") != null)
                    {
                        wbo.setAttribute("mobile", row.getString("MOBILE"));
                    }
                    if (row.getTimestamp("CREATION_TIME") != null)
                    {
                        wbo.setAttribute("clientCreationTime", row.getString("CREATION_TIME").substring(0, 16));
                    }
                    else
                    {
                        wbo.setAttribute("clientCreationTime", "");
                    }
                    if (row.getTimestamp("APPOINTMENT_DATE") != null)
                    {
                        wbo.setAttribute("appointmentDate", row.getString("APPOINTMENT_DATE").substring(0, 16));
                    }
                    else
                    {
                        wbo.setAttribute("appointmentDate", "");
                    }
                    if (row.getString("APPOINTMENT_PLACE") != null)
                    {
                        wbo.setAttribute("appointmentPlace", row.getString("APPOINTMENT_PLACE"));
                    }
                    else
                    {
                        wbo.setAttribute("appointmentPlace", "");
                    }
                    if (row.getString("COMMENT") != null)
                    {
                        wbo.setAttribute("appointmentComment", row.getString("COMMENT"));
                    }
                    else
                    {
                        wbo.setAttribute("appointmentComment", "");
                    }
                    if (row.getString("OPTION9") != null)
                    {
                        wbo.setAttribute("attended", row.getString("OPTION9"));
                    }
                    else
                    {
                        wbo.setAttribute("attended", "---");
                    }
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                catch (Exception ex)
                {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;
        }
        catch (UnsupportedTypeException | SQLException ex)
        {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }

    public WebBusinessObject selectUnratedRatedCountCl(java.sql.Date fromDate, java.sql.Date toDate, String campaignID, String employeeID, String projectID, String type, String department)
    {
        ClientComplaintsMgr clientComplaintsMgr = new ClientComplaintsMgr();
        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
        clientComplaintsMgr.updateClientComplaintsType();

        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector params = new Vector();
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));

        StringBuilder where = new StringBuilder();

        if (campaignID != null && !campaignID.equals("''") && !campaignID.equals(""))
        {
            where.append(" AND CL.SYS_ID IN (SELECT CC.CLIENT_ID FROM CLIENT_CAMPAIGN CC WHERE CC.CAMPAIGN_ID IN (")
                    .append(campaignID).append("))");
        }

        if (employeeID != null && !employeeID.isEmpty())
        {
            where.append(" AND CCT.CURRENT_OWNER_ID = '").append(employeeID).append("'");
        }
        if (type != null && !type.isEmpty())
        {
            where.append(" AND CCT.TYPE_TAG LIKE '").append(type).append("%'");
        }
        if (projectID != null && !projectID.isEmpty() && !projectID.equals("''") && !projectID.equals(""))
        {
            where.append(" AND CL.SYS_ID IN (SELECT CLIENT_ID FROM CLIENT_PROJECTS WHERE PRODUCT_CATEGORY_ID = '").append(projectID).append("' or project_id = '").append(projectID).append("')");
        }

        if ((employeeID == null || employeeID.isEmpty()) && (department != null && !department.isEmpty() && !department.equalsIgnoreCase("all")))
        {
            where.append(" AND CCT.CURRENT_OWNER_ID IN (SELECT USER_ID FROM USERS WHERE USER_ID IN (SELECT EMP_MGR.EMP_ID FROM EMP_MGR WHERE EMP_MGR.MGR_ID = (SELECT PROJECT.OPTION_ONE FROM PROJECT WHERE PROJECT.PROJECT_ID = '").append(department).append("') UNION SELECT PROJECT.OPTION_ONE FROM PROJECT WHERE PROJECT.PROJECT_ID = '").append(department).append("'").append("))");
        }
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("selectUnratedRatedCountCl").replaceAll("whereStatement", where.toString()).trim());
            command.setparams(params);
            result = command.executeQuery();
            WebBusinessObject wbo = new WebBusinessObject();
            for (Row row : result)
            {
                try
                {
                    if (row.getString("TOTAL_RATED") != null)
                    {
                        wbo.setAttribute("totalRated", row.getString("TOTAL_RATED"));
                    }
                    if (row.getString("TOTAL_UNRATED") != null)
                    {
                        wbo.setAttribute("totalUnrated", row.getString("TOTAL_UNRATED"));
                    }
                    return wbo;
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                catch (Exception ex)
                {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            return null;
        }
        catch (UnsupportedTypeException | SQLException ex)
        {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return null;
    }
    
    public ArrayList<WebBusinessObject> selectUnratedRatedCountClForComChan(java.sql.Date fromDate, java.sql.Date toDate, String channelID, String employeeID, String projectID, String type, String department)
    {
        ClientComplaintsMgr clientComplaintsMgr = new ClientComplaintsMgr();
        clientComplaintsMgr = ClientComplaintsMgr.getInstance();
        clientComplaintsMgr.updateClientComplaintsType();

        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector params = new Vector();
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));

        StringBuilder where = new StringBuilder();

        if (channelID != null && !channelID.equals("''") && !channelID.equals(""))
        {
            where.append(" AND CL.OPTION3 IN (").append(channelID).append(")");
        }

        if (employeeID != null && !employeeID.isEmpty())
        {
            where.append(" AND CL.SYS_ID IN (SELECT ISS.URGENCY_ID FROM ISSUE ISS WHERE ISS.ID IN (SELECT CC.ISSUE_ID FROM CLIENT_COMPLAINTS CC WHERE CC.CURRENT_OWNER_ID IN ('").append(employeeID).append("' )))");
        }
        if (type != null && !type.isEmpty())
        {
            where.append(" AND CCT.TYPE_TAG LIKE '").append(type).append("%'");
        }
        if (projectID != null && !projectID.isEmpty() && !projectID.equals("''") && !projectID.equals(""))
        {
            where.append(" AND CL.SYS_ID IN (SELECT CLIENT_ID FROM CLIENT_PROJECTS WHERE PRODUCT_CATEGORY_ID = '").append(projectID).append("' or project_id = '").append(projectID).append("')");
        }

        if ((employeeID == null || employeeID.isEmpty()) && (department != null && !department.isEmpty() && !department.equalsIgnoreCase("all")))
        {
            where.append(" AND CL.SYS_ID IN (SELECT ISS.URGENCY_ID FROM ISSUE ISS WHERE ISS.ID IN (SELECT CC.ISSUE_ID FROM CLIENT_COMPLAINTS CC WHERE CC.CURRENT_OWNER_ID IN (SELECT USER_ID FROM USERS WHERE USER_ID IN (SELECT EMP_MGR.EMP_ID FROM EMP_MGR WHERE EMP_MGR.MGR_ID = (SELECT PROJECT.OPTION_ONE FROM PROJECT WHERE PROJECT.PROJECT_ID = '").append(department).append("') UNION SELECT PROJECT.OPTION_ONE FROM PROJECT WHERE PROJECT.PROJECT_ID = '").append(department).append("'").append("))))");
        }
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getUnratedRatedCountClForComChan").replaceAll("whereStatement", where.toString()).trim());
            command.setparams(params);
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result) {
                wbo = new WebBusinessObject();
                try {
                    if (row.getString("CLIENT_COUNT") != null) {
                        wbo.setAttribute("clientCount", row.getString("CLIENT_COUNT"));
                    }
                    if (row.getString("CHANNEL_NAME") != null) {
                        wbo.setAttribute("channelName", row.getString("CHANNEL_NAME"));
                    } else {
                        wbo.setAttribute("channelName", "No Channel");
                    }
                } catch (NoSuchColumnException | NullPointerException ex) {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;
        }
        catch (UnsupportedTypeException | SQLException ex)
        {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return null;
    }

    public boolean deleteClients(String[] clientId) throws SQLException
    {
        Connection connection = null;
        Vector params = new Vector();
        //params.add(new StringValue(clientId));
        SQLCommandBean forUpdate = new SQLCommandBean();

        StringBuilder clientIDStr = new StringBuilder();

        for (int i = 0; i < clientId.length; i++)
        {
            if (clientIDStr.length() == 0)
            {
                clientIDStr.append("?");
            }
            else
            {
                clientIDStr.append(", ?");
            }

            params.add(new StringValue(clientId[i]));
        }

        int queryResult = -1000;

        try
        {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            // Delete Client
            forUpdate = new SQLCommandBean();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("deleteClients").replaceAll("clientIDStr", clientIDStr.toString()).trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

            connection.commit();
            connection.setAutoCommit(true);
        }
        catch (SQLException se)
        {
            logger.error("database error " + se.getMessage());
            if (connection != null)
            {
                connection.rollback();
            }
            return false;
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.commit();
                    connection.close();
                }
            }
            catch (SQLException sex)
            {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }
        return (queryResult > 0);
    }

    public ArrayList<WebBusinessObject> getClientsByAllProject(java.sql.Date beginDate, java.sql.Date endDate, boolean hasVisits)
    {
        Vector param = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        StringBuilder where = new StringBuilder();
        if (hasVisits) {
            where.append(" AND C.SYS_ID IN (SELECT CLIENT_ID FROM APPOINTMENT WHERE OPTION9 = 'attended') ");
        }
        String query = getQuery("getClientsByAllProject").replaceAll("whereStatement", where.toString()).trim();
        try
        {
            param.addElement(new DateValue(beginDate));
            param.addElement(new DateValue(endDate));
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException se)
        {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
            return null;
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        if (queryResult != null)
        {
            WebBusinessObject wbo;
            Row r;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements())
            {
                r = (Row) e.nextElement();

                wbo = fabricateBusObj(r);

                try
                {
                    if (r.getString("PRODUCT_CATEGORY_ID") != null)
                    {
                        wbo.setAttribute("prjID", r.getString("PRODUCT_CATEGORY_ID"));
                    }
                    else
                    {
                        wbo.setAttribute("prjID", "");
                    }

                    if (r.getString("PROJECT_NAME") != null)
                    {
                        wbo.setAttribute("prjNm", r.getString("PROJECT_NAME"));
                    }
                    else
                    {
                        wbo.setAttribute("prjNm", "");
                    }
                    if (r.getString("interestingTime") != null)
                    {
                        wbo.setAttribute("interestedTime", r.getString("interestingTime"));
                    }
                    else
                    {
                        wbo.setAttribute("interestedTime", "---");
                    }
                    if (r.getString("createdBy") != null)
                    {
                        wbo.setAttribute("createdBy", r.getString("createdBy"));
                    }
                    else
                    {
                        wbo.setAttribute("createdBy", "---");
                    }
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }

                resultBusObjs.add(wbo);
            }
        }
        return resultBusObjs;
    }

    public ArrayList<ArrayList<String>> getRepeatedName()
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;

        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getRepeatedName").trim());
            result = command.executeQuery();
            ArrayList<ArrayList<String>> data = new ArrayList<>();
            for (Row row : result)
            {
                ArrayList<String> object = new ArrayList<>();
                try
                {

                    /*if (row.getString("SYS_ID") != null) {
                     object.add(row.getString("SYS_ID"));
                     }*/
                    if (row.getString("NAME") != null)
                    {
                        object.add(row.getString("NAME"));
                    }

                    if (row.getString("MOBILE") != null)
                    {
                        object.add(row.getString("MOBILE"));
                    }
                    else
                    {
                        object.add("---");
                    }

                    if (row.getString("CLIENT_NO") != null)
                    {
                        object.add(row.getString("CLIENT_NO"));
                    }
                    
                    if (row.getString("INTER_PHONE") != null && !"UL".equals(row.getString("INTER_PHONE"))) {
                        object.add(row.getString("INTER_PHONE"));
                    } else {
                        object.add("---");
                    }

                    if (row.getString("EMAIL") != null) {
                        object.add(row.getString("EMAIL"));
                    } else {
                        object.add("---");
                    }

                    String ViewURL = "<a target='blank' href='ClientServlet?op=clientDetails&clientId=" + row.getString("SYS_ID").toString() + "'><image style='height:25px;' src='images/client_details.jpg' title='View'/></a>";
                    String DeleteURL = "<a target='blank' href='ClientServlet?op=DeleteRepeatedClient&clientID=" + row.getString("SYS_ID").toString() + "&phn=0'><image style='height:25px;' src='images/icons/remove.png' title='Delete'/></a>";

                    object.add(ViewURL);
                    object.add(DeleteURL);

                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                data.add(object);
            }
            return data;

        }
        catch (UnsupportedTypeException | SQLException ex)
        {
            Logger.getLogger(ClientMgr.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }

    public ArrayList<WebBusinessObject> frstLstApp(java.util.Date frmDate, java.util.Date tDate){
        Connection connection = null;
        Vector param = new Vector();
        Vector queryResult = new Vector();

        param.addElement(new DateValue(new java.sql.Date(frmDate.getTime())));
        param.addElement(new DateValue(new java.sql.Date(tDate.getTime())));

        SQLCommandBean forQuery = new SQLCommandBean();
        String query = getQuery("frstLstApp").trim();
       
        
        try{
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        } catch (SQLException | UnsupportedTypeException ex){
            logger.error(ex.getMessage());
        } finally{
            try{
                connection.close();
            } catch (SQLException ex){}
        }

        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()){
            Row r = (Row) e.nextElement();
            WebBusinessObject wbo = new WebBusinessObject();
            try{
                if(r.getString("SYS_ID") != null){
                    wbo.setAttribute("clntID", r.getString("SYS_ID"));
                } else {
                    wbo.setAttribute("clntID", "");
                }
                
                if(r.getString("NAME") != null){
                    wbo.setAttribute("clntNm", r.getString("NAME"));
                } else {
                    wbo.setAttribute("clntNm", "");
                }
                
                if(r.getString("FIRST_CALL_TIME") != null){
                    wbo.setAttribute("frstDt", r.getString("FIRST_CALL_TIME"));
                } else {
                    wbo.setAttribute("frstDt", "");
                }
                
                if(r.getString("LAST_CALL_TIME") != null){
                    wbo.setAttribute("lstDt", r.getString("LAST_CALL_TIME"));
                } else {
                    wbo.setAttribute("lstDt", "");
                }
                
                if(r.getString("LAST_COMMENT") != null){
                wbo.setAttribute("lstCmnt", r.getString("LAST_COMMENT"));
                } else {
                    wbo.setAttribute("lstCmnt", "");
                }
                
                if(r.getString("RATE") != null){
                wbo.setAttribute("rate", r.getString("RATE"));
                } else {
                    wbo.setAttribute("rate", "");
                }
                
                if(r.getString("FULL_NAME") != null){
                wbo.setAttribute("fullNm", r.getString("FULL_NAME"));
                } else {
                    wbo.setAttribute("fullNm", "");
                }
                
                if(r.getString("ENGLISHNAME") != null){
                wbo.setAttribute("englishNm", r.getString("ENGLISHNAME"));
                } else {
                    wbo.setAttribute("englishNm", "");
                }
                
                if(r.getString("CAMPAIGN_TITLE") != null){
                wbo.setAttribute("campaign", r.getString("CAMPAIGN_TITLE"));
                } else {
                    wbo.setAttribute("campaign", "");
                }
                

                SimpleDateFormat frmt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                java.util.Date date1 = new java.util.Date();
                java.util.Date date2 = new java.util.Date();
                try{
                    date1 = frmt.parse(r.getString("FDT"));
                    date2 = frmt.parse(r.getString("LDT"));
                } catch (ParseException ex){
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                long diff = date2.getDate() - date1.getDate();
                wbo.setAttribute("difBtwnDt", diff);
            } catch (NoSuchColumnException ex){
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }
    public ArrayList<WebBusinessObject> frstLstApp1(java.util.Date frmDate, java.util.Date tDate,String userID,String departmentID,String employeeID){
        Connection connection = null;
        Vector param = new Vector();
        Vector queryResult = new Vector();

        param.addElement(new DateValue(new java.sql.Date(frmDate.getTime())));
        param.addElement(new DateValue(new java.sql.Date(tDate.getTime())));

        SQLCommandBean forQuery = new SQLCommandBean();
        String query = getQuery("frstLstApp").trim();
        System.out.println("employeeID -->> (" + employeeID + ")");
        System.out.println("departmentID -->> (" + departmentID + ")");
        System.out.println("userID -->> (" + userID + ")");
        if (employeeID != null && !employeeID.isEmpty()) {
            query = query + " AND IU.CURRENT_OWNER_ID ='" + employeeID + "'";
        System.out.println(" here if ");
        } else if (departmentID == null || departmentID.isEmpty()) {
            query = query + " AND IU.CURRENT_OWNER_ID IN (SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID IN (SELECT DEPARTMENT_ID FROM USER_DEPARTMENT_CONFIG WHERE USER_ID = '"
                    + userID + "') UNION ALL SELECT EMP_ID FROM EMP_MGR WHERE MGR_ID IN (SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID IN (SELECT DEPARTMENT_ID FROM USER_DEPARTMENT_CONFIG WHERE USER_ID = '"
                    + userID + "')))";
        System.out.println(" here else if ");
        } else {
            query = query + " AND IU.CURRENT_OWNER_ID IN (SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID = '" + departmentID
                    + "' UNION ALL SELECT EMP_ID FROM EMP_MGR WHERE MGR_ID IN (SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID = '"
                    + departmentID + "'))";
        System.out.println(" here else ");
        }
        try{
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        } catch (SQLException | UnsupportedTypeException ex){
            logger.error(ex.getMessage());
        } finally{
            try{
                connection.close();
            } catch (SQLException ex){}
        }

        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()){
            Row r = (Row) e.nextElement();
            WebBusinessObject wbo = new WebBusinessObject();
            try{
                if(r.getString("SYS_ID") != null){
                    wbo.setAttribute("clntID", r.getString("SYS_ID"));
                } else {
                    wbo.setAttribute("clntID", "");
                }
                
                if(r.getString("NAME") != null){
                    wbo.setAttribute("clntNm", r.getString("NAME"));
                } else {
                    wbo.setAttribute("clntNm", "");
                }
                
                if(r.getString("FIRST_CALL_TIME") != null){
                    wbo.setAttribute("frstDt", r.getString("FIRST_CALL_TIME"));
                } else {
                    wbo.setAttribute("frstDt", "");
                }
                
                if(r.getString("LAST_CALL_TIME") != null){
                    wbo.setAttribute("lstDt", r.getString("LAST_CALL_TIME"));
                } else {
                    wbo.setAttribute("lstDt", "");
                }
                
                if(r.getString("LAST_COMMENT") != null){
                wbo.setAttribute("lstCmnt", r.getString("LAST_COMMENT"));
                } else {
                    wbo.setAttribute("lstCmnt", "");
                }
                
                if(r.getString("RATE") != null){
                wbo.setAttribute("rate", r.getString("RATE"));
                } else {
                    wbo.setAttribute("rate", "");
                }
                
                if(r.getString("FULL_NAME") != null){
                wbo.setAttribute("fullNm", r.getString("FULL_NAME"));
                } else {
                    wbo.setAttribute("fullNm", "");
                }
                
                if(r.getString("ENGLISHNAME") != null){
                wbo.setAttribute("englishNm", r.getString("ENGLISHNAME"));
                } else {
                    wbo.setAttribute("englishNm", "");
                }
                
                if(r.getString("CAMPAIGN_TITLE") != null){
                wbo.setAttribute("campaign", r.getString("CAMPAIGN_TITLE"));
                } else {
                    wbo.setAttribute("campaign", "");
                }
                

                SimpleDateFormat frmt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                java.util.Date date1 = new java.util.Date();
                java.util.Date date2 = new java.util.Date();
                try{
                    date1 = frmt.parse(r.getString("FDT"));
                    date2 = frmt.parse(r.getString("LDT"));
                } catch (ParseException ex){
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                long diff = date2.getDate() - date1.getDate();
                wbo.setAttribute("difBtwnDt", diff);
            } catch (NoSuchColumnException ex){
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }


    public ArrayList<WebBusinessObject> getClientsCountByAllProjects(java.sql.Date startDate, java.sql.Date endDate, boolean hasVisits)
    {
        WebBusinessObject wbo;
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new DateValue(startDate));
        params.addElement(new DateValue(endDate));
        StringBuilder where = new StringBuilder();
        if (hasVisits) {
            where.append(" AND CLIENT_PROJECTS.CLIENT_ID IN (SELECT CLIENT_ID FROM APPOINTMENT WHERE OPTION9 = 'attended') ");
        }

        StringBuilder sql = null;
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            sql = new StringBuilder(getQuery("getClientsCountByAllProjects").replaceAll("whereStatement", where.toString()).trim());

            forQuery.setSQLQuery(sql.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();

        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());

        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());

        }
        finally
        {
            try
            {
                connection.close();
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }

        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();

        Row r = null;
        Enumeration e = queryResult.elements();
        int C = 0;
        try
        {
            while (e.hasMoreElements())
            {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                if (r.getString("clientsCount") != null)
                {
                    wbo.setAttribute("clientsCount", r.getString("clientsCount"));
                }
                else
                {
                    wbo.setAttribute("clientsCount", "0");
                }

                if (r.getString("PROJECT_NAME") != null)
                {
                    wbo.setAttribute("projectName", r.getString("PROJECT_NAME"));
                }
                else
                {
                    wbo.setAttribute("projectName", "---");
                }

                resultBusObjs.add(wbo);
            }

        }
        catch (NoSuchColumnException ce)
        {
            logger.error(ce);
        }
        return resultBusObjs;
    }

    public String getTotalClientsCount(java.sql.Date startDate, java.sql.Date endDate, boolean hasVisits)
    {

        WebBusinessObject wbo;
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new DateValue(startDate));
        params.addElement(new DateValue(endDate));

        StringBuilder where = new StringBuilder();
        if (hasVisits) {
            where.append(" AND CLIENT_ID IN (SELECT CLIENT_ID FROM APPOINTMENT WHERE OPTION9 = 'attended') ");
        }
        StringBuilder sql = null;
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            sql = new StringBuilder(getQuery("getTotalClientsCount").trim()).append(where.toString());

            forQuery.setSQLQuery(sql.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();

        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());

        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());

        }
        finally
        {
            try
            {
                connection.close();
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }

        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        String count = "0";
        Row r = null;
        Enumeration e = queryResult.elements();
        try
        {
            while (e.hasMoreElements())
            {
                r = (Row) e.nextElement();

                if (r.getString("clientsCount") != null)
                {
                    count = r.getString("clientsCount");
                }
                else
                {
                    count = "0";
                }

            }

        }
        catch (NoSuchColumnException ce)
        {
            logger.error(ce);
        }
        return count;
    }

    public WebBusinessObject getClientFirstAppointment(String clientID)
    {
        Connection connection = null;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(clientID));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        WebBusinessObject wbo = null;
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientFirstAppointment").trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException se)
        {
            logger.error("troubles closing connection " + se.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException sex)
            {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null)
        {
            Enumeration e = queryResult.elements();
            Row r;
            while (e.hasMoreElements())
            {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try
                {
                    if (r.getString("COMMENT") != null)
                    {
                        wbo.setAttribute("comment", r.getString("COMMENT"));
                    }
                    if (r.getString("APPOINTMENT_DATE") != null)
                    {
                        wbo.setAttribute("appointmentDate", r.getString("APPOINTMENT_DATE").substring(0, 16));
                    }
                    if (r.getString("APPOINTMENT_BY") != null)
                    {
                        wbo.setAttribute("appointmentBy", r.getString("APPOINTMENT_BY"));
                    }
                    if (r.getString("APPOINTMENT_TYPE") != null)
                    {
                        wbo.setAttribute("appointmentType", r.getString("APPOINTMENT_TYPE"));
                    }
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                return wbo;
            }
        }
        return null;
    }

    public ArrayList<WebBusinessObject> getClientsWithCampaginChannel(java.sql.Date fromDate, java.sql.Date toDate, String channelID)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector parameters = new Vector();
        String query = getQuery("getClientsWithCampaginChannel").trim();
        StringBuilder where = new StringBuilder();
        parameters.addElement(new DateValue(fromDate));
        parameters.addElement(new DateValue(toDate));
        if (channelID != null && !channelID.isEmpty())
        {
            where.append(" AND ST.ID = ?");
            parameters.addElement(new StringValue(channelID));
        }
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.replaceAll("whereStatement", where.toString()));
            command.setparams(parameters);
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    wbo.setAttribute("clientId", row.getString("SYS_ID") != null ? row.getString("SYS_ID") : "");
                    wbo.setAttribute("creationTime", row.getString("CREATION_TIME") != null ? row.getString("CREATION_TIME").substring(0, 10) : "");
                    wbo.setAttribute("camp", row.getString("CAMPAIGN_TITLE") != null ? row.getString("CAMPAIGN_TITLE") : "None");
                    wbo.setAttribute("comChannel", row.getString("COMMUNICATION_CHANNEL") != null ? row.getString("COMMUNICATION_CHANNEL") : "");
                    wbo.setAttribute("createdBy", row.getString("CREATED_BY_NAME") != null ? row.getString("CREATED_BY_NAME") : "");
                    wbo.setAttribute("mobile", row.getString("MOBILE") != null ? row.getString("MOBILE") : "");
                    wbo.setAttribute("email", row.getString("EMAIL") != null ? row.getString("EMAIL") : "---");
                    wbo.setAttribute("clientNo", row.getString("CLIENT_NO") != null ? row.getString("CLIENT_NO") : "---");
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;
        }
        catch (UnsupportedTypeException | SQLException ex)
        {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }

    public ArrayList<WebBusinessObject> getClosedRatedClients(String fromDate, String toDate)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector parameters = new Vector();
        String query = getQuery("getClosedRatedClients").trim();
        StringBuilder where = new StringBuilder();
        if (fromDate != null && !fromDate.isEmpty())
        {
            where.append(" AND TRUNC(CR.CREATION_TIME) >= TO_DATE(?, 'yyyy-MM-dd')");
            parameters.addElement(new StringValue(fromDate));
        }

        if (toDate != null && !toDate.isEmpty())
        {
            where.append(" AND TRUNC(CR.CREATION_TIME) <= TO_DATE(?, 'yyyy-MM-dd')");
            parameters.addElement(new StringValue(toDate));
        }

        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.replaceAll("whereStatement", where.toString()));
            command.setparams(parameters);
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    wbo.setAttribute("responsibleID", row.getString("OWNER_ID") != null ? row.getString("OWNER_ID") : "");
                    wbo.setAttribute("responsibleName", row.getString("OWNER_NAME") != null ? row.getString("OWNER_NAME") : "");
                    wbo.setAttribute("sourceName", row.getString("SOURCE_NAME") != null ? row.getString("SOURCE_NAME") : "");
                    wbo.setAttribute("issueID", row.getString("ISSUE_ID") != null ? row.getString("ISSUE_ID") : "");
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;
        }
        catch (UnsupportedTypeException | SQLException ex)
        {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }

    public ArrayList<WebBusinessObject> getClassifiedClientsLastComments(String ownerID, Timestamp fromDate, Timestamp toDate, String clientRate, String prjID, String hashTag)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(ownerID));
        StringBuilder query = new StringBuilder(getQuery("getClassifiedClientsLastComments").trim());
        if (fromDate != null)
        {
            query.append(" AND TRUNC(CC.CREATION_TIME) >= TRUNC(?)");
            parameters.addElement(new TimestampValue(fromDate));
        }

        if (toDate != null)
        {
            query.append(" AND TRUNC(CC.CREATION_TIME) <= TRUNC(?)");
            parameters.addElement(new TimestampValue(toDate));
        }

        if (clientRate != null && !clientRate.isEmpty())
        {
            if ("1".equals(clientRate))
            {
                query.append(" AND CR.RATE_ID IS NULL");
            }
            else
            {
                query.append(" AND CR.RATE_ID = ?");
                parameters.addElement(new StringValue(clientRate));
            }
        }

        if (prjID != null && !prjID.isEmpty())
        {
            query.append(" AND CL.SYS_ID IN (SELECT CP.CLIENT_ID FROM CLIENT_PROJECTS CP WHERE CP.PRODUCT_ID = 'interested' AND (CP.PRODUCT_CATEGORY_ID = ? OR CP.PROJECT_ID = ?))");
            parameters.addElement(new StringValue(prjID));
            parameters.addElement(new StringValue(prjID));
        }

        if (hashTag != null && !hashTag.isEmpty())
        {
            query.append("AND IC.CUSTOMER_ID IN (SELECT HASHTAG.BUSNIESS_OBJECT_ID FROM COMMENTS HASHTAG WHERE HASHTAG.CREATED_BY = ? AND LOWER(HASHTAG.COMMENT_DESC) LIKE LOWER('%").append(hashTag).append("%'))");
            parameters.addElement(new StringValue(ownerID));
        }

        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.toString());
            command.setparams(parameters);
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getString("CLASS_TITLE") != null)
                    {
                        wbo.setAttribute("classTitle", row.getString("CLASS_TITLE"));
                    }

                    if (row.getString("IMAGE_NAME") != null)
                    {
                        wbo.setAttribute("imageName", row.getString("IMAGE_NAME"));
                    }

                    if (row.getString("RATE_ID") != null)
                    {
                        wbo.setAttribute("rateID", row.getString("RATE_ID"));
                    }

                    if (row.getString("ENGLISHNAME") != null && !row.getString("ENGLISHNAME").equals("null"))
                    {
                        wbo.setAttribute("seasonName", row.getString("ENGLISHNAME"));
                    }
                    else
                    {
                        wbo.setAttribute("seasonName", "");
                    }

                    if (row.getTimestamp("CMNTDT") != null)
                    {
                        wbo.setAttribute("comDate", row.getTimestamp("CMNTDT"));
                    }
                    else
                    {
                        wbo.setAttribute("comDate", "");
                    }

                    if (row.getString("LSTCMNT") != null)
                    {
                        wbo.setAttribute("lstCom", row.getString("LSTCMNT"));
                    }
                    else
                    {
                        wbo.setAttribute("lstCom", "");

                    }
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                catch (UnsupportedConversionException ex)
                {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;

        }
        catch (UnsupportedTypeException | SQLException ex)
        {
            Logger.getLogger(ClientMgr.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }
 public ArrayList<WebBusinessObject> getClassifiedClientsLastCallComments(String ownerID, Timestamp fromDate, Timestamp toDate, String clientRate, String prjID, String hashTag)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(ownerID));
        StringBuilder query = new StringBuilder(getQuery("getClassifiedClientsLastCallComments").trim());
        if (fromDate != null)
        {
            query.append(" AND TRUNC(CMNT.CREATION_TIME) >= TRUNC(?)");
            parameters.addElement(new TimestampValue(fromDate));
        }

        if (toDate != null)
        {
            query.append(" AND TRUNC(CMNT.CREATION_TIME) <= TRUNC(?)");
            parameters.addElement(new TimestampValue(toDate));
        }

        if (clientRate != null && !clientRate.isEmpty())
        {
            if ("1".equals(clientRate))
            {
                query.append(" AND CR.RATE_ID IS NULL");
            }
            else
            {
                query.append(" AND CR.RATE_ID = ?");
                parameters.addElement(new StringValue(clientRate));
            }
        }

        if (prjID != null && !prjID.isEmpty())
        {
            query.append(" AND CL.SYS_ID IN (SELECT CP.CLIENT_ID FROM CLIENT_PROJECTS CP WHERE CP.PRODUCT_ID = 'interested' AND (CP.PRODUCT_CATEGORY_ID = ? OR CP.PROJECT_ID = ?))");
            parameters.addElement(new StringValue(prjID));
            parameters.addElement(new StringValue(prjID));
        }

        if (hashTag != null && !hashTag.isEmpty())
        {
            query.append("AND IC.CUSTOMER_ID IN (SELECT HASHTAG.CLIENT_ID FROM APPOINTMENT HASHTAG WHERE HASHTAG.USER_ID = ? AND LOWER(HASHTAG.\"COMMENT\") LIKE LOWER('%").append(hashTag).append("%'))");
            parameters.addElement(new StringValue(ownerID));
        }

        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.toString());
            command.setparams(parameters);
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getString("CLASS_TITLE") != null)
                    {
                        wbo.setAttribute("classTitle", row.getString("CLASS_TITLE"));
                    }

                    if (row.getString("IMAGE_NAME") != null)
                    {
                        wbo.setAttribute("imageName", row.getString("IMAGE_NAME"));
                    }

                    if (row.getString("RATE_ID") != null)
                    {
                        wbo.setAttribute("rateID", row.getString("RATE_ID"));
                    }

                    if (row.getString("ENGLISHNAME") != null && !row.getString("ENGLISHNAME").equals("null"))
                    {
                        wbo.setAttribute("seasonName", row.getString("ENGLISHNAME"));
                    }
                    else
                    {
                        wbo.setAttribute("seasonName", "");
                    }

                    if (row.getTimestamp("CMNTDT") != null)
                    {
                        wbo.setAttribute("comDate", row.getTimestamp("CMNTDT"));
                    }
                    else
                    {
                        wbo.setAttribute("comDate", "");
                    }

                    if (row.getString("LSTCMNT") != null)
                    {
                        wbo.setAttribute("lstCom", row.getString("LSTCMNT"));
                    }
                    else
                    {
                        wbo.setAttribute("lstCom", "");

                    }
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                catch (UnsupportedConversionException ex)
                {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;

        }
        catch (UnsupportedTypeException | SQLException ex)
        {
            Logger.getLogger(ClientMgr.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }

    public boolean addFcltyConfg(WebBusinessObject fcltyConfg, String usrID) throws NoUserInSessionException
    {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        SequenceMgr sequenceMgr = SequenceMgr.getInstance();

        sequenceMgr.updateSequence();
        String fcltyConfgID = sequenceMgr.getSequence();

        String WorkerID = UniqueIDGen.getNextID();

        params.addElement(new StringValue(fcltyConfgID));
        params.addElement(new StringValue(fcltyConfg.getAttribute("wrkrID").toString()));
        params.addElement(new StringValue(fcltyConfg.getAttribute("fcltyID").toString()));
        params.addElement(new StringValue(fcltyConfg.getAttribute("wrkrSft").toString()));
        params.addElement(new StringValue(fcltyConfg.getAttribute("wrkrRmrk").toString()));
        params.addElement(new StringValue(usrID));
        //params.addElement(new IntValue(fcltyConfg.getAttribute("wrkrRt") != null && !fcltyConfg.getAttribute("wrkrRt").toString().equals(" ") && !fcltyConfg.getAttribute("wrkrRt").toString().isEmpty() ? Integer.parseInt(fcltyConfg.getAttribute("wrkrRt").toString()) : 0));
        params.addElement(new IntValue(0));

        try
        {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("addFcltyConfg").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0)
            {
                transConnection.rollback();
                return false;
            }
        }
        catch (SQLException se)
        {
            logger.error(se.getMessage());
            return false;
        }
        finally
        {
            endTransaction();
        }
        return true;
    }

    public ArrayList<WebBusinessObject> getClientsWithdraws(String mobileNo, HttpSession s)
    {
        SQLCommandBean command = new SQLCommandBean();
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Connection connection = null;
        Vector<Row> result;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(mobileNo));
        parameters.addElement(new StringValue((String) waUser.getAttribute("userId")));
        StringBuilder query = new StringBuilder(getQuery("getClientsWithdraws").trim());

        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.toString());
            command.setparams(parameters);
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getString("CREATION_TIME") != null)
                    {
                        wbo.setAttribute("wCreationTime", row.getString("CREATION_TIME"));
                    }

                    if (row.getString("CLIENT_ID") != null)
                    {
                        wbo.setAttribute("ClientId", row.getString("CLIENT_ID"));
                    }

                    if (row.getString("CLNT_NAME") != null)
                    {
                        wbo.setAttribute("clientName", row.getString("CLNT_NAME"));
                    }

                    if (row.getString("CLIENT_NO") != null && !row.getString("CLIENT_NO").equals("null"))
                    {
                        wbo.setAttribute("clientNo", row.getString("CLIENT_NO"));
                    }

                    if (row.getString("W_CREATED_BY") != null)
                    {
                        wbo.setAttribute("createdBy", row.getString("W_CREATED_BY"));
                    }

                    if (row.getString("SENDER") != null)
                    {
                        wbo.setAttribute("sender", row.getString("SENDER"));
                    }

                    if (row.getString("RECIPE") != null)
                    {
                        wbo.setAttribute("recipe", row.getString("RECIPE"));
                    }

                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;

        }
        catch (UnsupportedTypeException | SQLException ex)
        {
            Logger.getLogger(ClientMgr.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }

    public boolean addClientInfo(WebBusinessObject clientWbo, HttpSession s) throws NoUserInSessionException
    {
        Vector params = new Vector();
        Vector checkParams = new Vector();
        Vector UpdateParams = new Vector();

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        int updateResult = -1000;
        Vector queryResult2 = new Vector();
        SequenceMgr sequenceMgr = SequenceMgr.getInstance();

        checkParams.addElement(new StringValue(clientWbo.getAttribute("clientId").toString()));
        String marriageDate = (String) clientWbo.getAttribute("marriageD");
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
        java.util.Date date = null;
        java.sql.Date sqlDate = null;
        try {
            date = formatter.parse(marriageDate);
            sqlDate = new java.sql.Date(date.getTime());
        } catch (ParseException ex) {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        String clientID = UniqueIDGen.getNextID();
        //parameters.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue(clientWbo.getAttribute("clientId").toString()));
        params.addElement(new StringValue(clientWbo.getAttribute("clntAge").toString()));
        params.addElement(new StringValue(clientWbo.getAttribute("noOfKids").toString()));
        params.addElement(new StringValue(clientWbo.getAttribute("school").toString()));
        params.addElement(new StringValue(clientWbo.getAttribute("relg").toString()));
        params.addElement(new StringValue(clientWbo.getAttribute("fSport").toString()));
        params.addElement(new StringValue(clientWbo.getAttribute("fMusic").toString()));
        params.addElement(new StringValue(clientWbo.getAttribute("ClubMem").toString()));
        params.addElement(new StringValue(clientWbo.getAttribute("generalDesc").toString()));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new DateValue(sqlDate));

        UpdateParams.addElement(new StringValue(clientWbo.getAttribute("clntAge").toString()));
        UpdateParams.addElement(new StringValue(clientWbo.getAttribute("noOfKids").toString()));
        UpdateParams.addElement(new StringValue(clientWbo.getAttribute("school").toString()));
        UpdateParams.addElement(new StringValue(clientWbo.getAttribute("relg").toString()));
        UpdateParams.addElement(new StringValue(clientWbo.getAttribute("fSport").toString()));
        UpdateParams.addElement(new StringValue(clientWbo.getAttribute("fMusic").toString()));
        UpdateParams.addElement(new StringValue(clientWbo.getAttribute("ClubMem").toString()));
        UpdateParams.addElement(new StringValue(clientWbo.getAttribute("generalDesc").toString()));
        UpdateParams.addElement(new DateValue(sqlDate));
        UpdateParams.addElement(new StringValue(clientWbo.getAttribute("clientId").toString()));

        try
        {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("checkIfClientExist").trim());
            forInsert.setparams(checkParams);
            try
            {
                queryResult2 = forInsert.executeQuery();
            }
            catch (UnsupportedTypeException ex)
            {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            if (queryResult2 != null && !queryResult2.isEmpty())
            {
                try
                {
                    beginTransaction();
                    forInsert.setConnection(transConnection);
                    forInsert.setSQLQuery(getQuery("updateClientExtraInfo").trim());
                    forInsert.setparams(UpdateParams);
                    updateResult = forInsert.executeUpdate();
                    if (updateResult < 0)
                    {
                        transConnection.rollback();
                        return false;
                    }
                }
                catch (SQLException se)
                {
                    logger.error(se.getMessage());
                    return false;
                }
                finally
                {
                    endTransaction();
                }
            }
            else
            {
                try
                {
                    beginTransaction();
                    forInsert.setConnection(transConnection);
                    forInsert.setSQLQuery(getQuery("insertClientEtcInfo").trim());
                    forInsert.setparams(params);
                    queryResult = forInsert.executeUpdate();
                    if (queryResult < 0)
                    {
                        transConnection.rollback();
                        return false;
                    }
                }
                catch (SQLException se)
                {
                    logger.error(se.getMessage());
                    return false;
                }
                finally
                {
                    endTransaction();
                }
            }
        }
        catch (SQLException se)
        {
            logger.error(se.getMessage());
            return false;
        }
        return true;
    }

    public ArrayList<WebBusinessObject> getClientsProfile(String beginDate, String endDate)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(beginDate));
        parameters.addElement(new StringValue(endDate));
        StringBuilder query = new StringBuilder(getQuery("getClientsProfile").trim());

        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.toString());
            command.setparams(parameters);
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getString("TIMESTR") != null)
                    {
                        wbo.setAttribute("cpCreationTime", row.getString("TIMESTR"));
                    }

                    if (row.getString("AGE") != null)
                    {
                        wbo.setAttribute("age", row.getString("AGE"));
                    }
                    else
                    {
                        DateFormat format = new SimpleDateFormat("yyy/MM/dd");
                        java.util.Date date = new java.util.Date();
                        if (row.getString("BIRTH_DATE") == null)
                        {
                            wbo.setAttribute("age", "unKnown");

                        }
                        else if (row.getString("BIRTH_DATE") != null)
                        {
                            Calendar sysDate = Calendar.getInstance();
                            sysDate.setTime(date);

                            Calendar brthDate = Calendar.getInstance();
                            brthDate.setTime(row.getTimestamp("BIRTH_DATE"));

                            wbo.setAttribute("age", (sysDate.get(YEAR) - brthDate.get(YEAR)));
                        }
                    }

                    if (row.getString("NO_OF_KIDS") != null)
                    {
                        wbo.setAttribute("noOfKids", row.getString("NO_OF_KIDS"));
                    }
                    else
                    {
                        wbo.setAttribute("noOfKids", "0");
                    }

                    if (row.getString("SCHOOL") != null)
                    {
                        wbo.setAttribute("school", row.getString("SCHOOL"));
                    }
                    else
                    {
                        wbo.setAttribute("school", "---");
                    }

                    if (row.getString("RELIGION") != null)
                    {
                        wbo.setAttribute("religion", row.getString("RELIGION"));
                    }
                    else
                    {
                        wbo.setAttribute("religion", "---");
                    }

                    if (row.getString("FAV_SPORT") != null)
                    {
                        wbo.setAttribute("favSport", row.getString("FAV_SPORT"));
                    }
                    else
                    {
                        wbo.setAttribute("favSport", "---");
                    }

                    if (row.getString("FAV_MUSIC") != null)
                    {
                        wbo.setAttribute("faMusic", row.getString("FAV_MUSIC"));
                    }
                    else
                    {
                        wbo.setAttribute("faMusic", "---");
                    }

                    if (row.getString("CLUB_MEM") != null)
                    {
                        wbo.setAttribute("clubMem", row.getString("CLUB_MEM"));
                    }
                    else
                    {
                        wbo.setAttribute("clubMem", "---");
                    }

                    if (row.getString("GENERAL_DESC") != null)
                    {
                        wbo.setAttribute("generalDesc", row.getString("GENERAL_DESC"));
                    }
                    else
                    {
                        wbo.setAttribute("generalDesc", "---");
                    }

                    if (row.getString("COMCHANNEL") != null)
                    {
                        wbo.setAttribute("comChannl", row.getString("COMCHANNEL"));
                    }
                    else
                    {
                        wbo.setAttribute("comChannl", "---");
                    }

                    if (row.getString("JOBNM") != null)
                    {
                        wbo.setAttribute("job", row.getString("JOBNM"));
                    }
                    else
                    {
                        wbo.setAttribute("job", "---");
                    }

                    if (row.getString("REGIONnm") != null)
                    {
                        wbo.setAttribute("region", row.getString("REGIONnm"));
                    }
                    else
                    {
                        wbo.setAttribute("region", "---");
                    }

                    if (row.getString("PROJECTNM") != null)
                    {
                        wbo.setAttribute("project", row.getString("PROJECTNM"));
                    }
                    else
                    {
                        wbo.setAttribute("project", "---");
                    }

                    if (row.getString("UNITNM") != null)
                    {
                        wbo.setAttribute("unit", row.getString("UNITNM"));
                    }
                    else
                    {
                        wbo.setAttribute("unit", "---");
                    }

                    if (row.getString("AREA") != null)
                    {
                        wbo.setAttribute("area", row.getString("AREA"));
                    }
                    else
                    {
                        wbo.setAttribute("area", "---");
                    }

                    if (row.getString("PRICE") != null)
                    {
                        wbo.setAttribute("price", row.getString("PRICE"));
                    }
                    else
                    {
                        wbo.setAttribute("price", "---");
                    }

                    if (row.getString("PRICE") != null)
                    {
                        wbo.setAttribute("price", row.getString("PRICE"));
                    }
                    else
                    {
                        wbo.setAttribute("price", "---");
                    }

                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                catch (UnsupportedConversionException ex)
                {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;

        }
        catch (UnsupportedTypeException | SQLException ex)
        {
            Logger.getLogger(ClientMgr.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }
    
    
    public ArrayList<WebBusinessObject> getappOfClientClassOfComChan(String fromDate, String toDate, String sCallTyp, String sRate, String sChannel, String groupID)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(fromDate));
        parameters.addElement(new StringValue(toDate));
        
        StringBuilder query = new StringBuilder(getQuery("getappOfClientClassOfComChan"));
        
        if (groupID != null && !groupID.isEmpty() && !groupID.equals("") && !groupID.equals(" "))
        {
            query.append(" AND AP.USER_ID in (SELECT UG.USER_ID FROM USER_GROUP UG WHERE UG.GROUP_ID = ?)");
            parameters.addElement(new StringValue(groupID));
        }
        
        if (sCallTyp != null && !sCallTyp.isEmpty() && !sCallTyp.equals("") && !sCallTyp.equals(" "))
        {
            query.append(" AND AP.OPTION2 = ? ");
            parameters.addElement(new StringValue(sCallTyp));
        }
        if (sRate != null && !sRate.isEmpty() && !sRate.equals("") && !sRate.equals(" "))
        {
            query.append(" AND CR.RATE_ID = ? ");
            parameters.addElement(new StringValue(sRate));
        }
        if (sChannel != null && !sChannel.isEmpty() && !sChannel.equals("") && !sChannel.equals(" "))
        {
            query.append(" AND CL.OPTION3 = ? ");
            parameters.addElement(new StringValue(sChannel));
        }
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.toString());
            command.setparams(parameters);
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getString("mobile") != null)
                    {
                        wbo.setAttribute("mobile", row.getString("mobile"));
                    } else {
                        wbo.setAttribute("mobile", "---");
                    }
                    
                    if (row.getString("INTER_PHONE") == null)
                    {
                        wbo.setAttribute("interPhone", "---");
                    } else {
                        wbo.setAttribute("interPhone", row.getString("INTER_PHONE"));
                    }
                    
                    if (row.getString("email") != null)
                    {
                        wbo.setAttribute("email", row.getString("email"));
                    } else {
                        wbo.setAttribute("email", "---");
                    }
                    
                    if (row.getString("OPTION2") != null)
                    {
                        wbo.setAttribute("callTyp", row.getString("OPTION2"));
                    }
                    
                    if (row.getString("comChannel") != null)
                    {
                        wbo.setAttribute("comChannel", row.getString("comChannel"));
                    } else {
                        wbo.setAttribute("comChannel", "Unknown");
                    }
                    
                    if (row.getString("rateNm") != null)
                    {
                        wbo.setAttribute("rateNm", row.getString("rateNm"));
                    }
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;

        }
        catch (UnsupportedTypeException | SQLException ex)
        {
            Logger.getLogger(ClientMgr.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }
    
    public ArrayList<WebBusinessObject> getappOfClientClass(String fromDate, String toDate, String callStatus, String sRate, String sChannel, String groupID)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(fromDate));
        parameters.addElement(new StringValue(toDate));
        
        StringBuilder query = new StringBuilder(getQuery("getappOfClientClassOfComChan"));
        
        if (groupID != null && !groupID.isEmpty() && !groupID.equals("") && !groupID.equals(" "))
        {
            query.append(" AND AP.USER_ID in (SELECT UG.USER_ID FROM USER_GROUP UG WHERE UG.GROUP_ID = ?)");
            parameters.addElement(new StringValue(groupID));
        }
        
        if (callStatus != null && !callStatus.isEmpty() && !callStatus.equals("") && !callStatus.equals(" "))
        {
            query.append(" AND AP.OPTION9 = ? ");
            parameters.addElement(new StringValue(callStatus));
        }
        if (sRate != null && !sRate.isEmpty() && !sRate.equals("") && !sRate.equals(" "))
        {
            query.append(" AND CR.RATE_ID = ? ");
            parameters.addElement(new StringValue(sRate));
        }
        if (sChannel != null && !sChannel.isEmpty() && !sChannel.equals("") && !sChannel.equals(" "))
        {
            query.append(" AND CL.OPTION3 = ? ");
            parameters.addElement(new StringValue(sChannel));
        }
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.toString());
            command.setparams(parameters);
            result = command.executeQuery();
            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getString("mobile") != null)
                    {
                        wbo.setAttribute("mobile", row.getString("mobile"));
                    } else {
                        wbo.setAttribute("mobile", "---");
                    }
                    
                    if (row.getString("INTER_PHONE") == null)
                    {
                        wbo.setAttribute("interPhone", "---");
                    } else {
                        wbo.setAttribute("interPhone", row.getString("INTER_PHONE"));
                    }
                    
                    if (row.getString("email") != null)
                    {
                        wbo.setAttribute("email", row.getString("email"));
                    } else {
                        wbo.setAttribute("email", "---");
                    }
                    
                    if (row.getString("OPTION2") != null)
                    {
                        wbo.setAttribute("callTyp", row.getString("OPTION2"));
                    }
                    
                    if (row.getString("comChannel") != null)
                    {
                        wbo.setAttribute("comChannel", row.getString("comChannel"));
                    } else {
                        wbo.setAttribute("comChannel", "Unknown");
                    }
                    
                    if (row.getString("rateNm") != null)
                    {
                        wbo.setAttribute("rateNm", row.getString("rateNm"));
                    }
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;

        }
        catch (UnsupportedTypeException | SQLException ex)
        {
            Logger.getLogger(ClientMgr.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }
    
    public ArrayList<WebBusinessObject> getClientsWithInvalidMobile() {
        Connection connection = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientsWithInvalidMobile").trim());
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
        ArrayList<WebBusinessObject> result = new ArrayList<>();
        Row r;
        Enumeration e = queryResult.elements();
        WebBusinessObject wbo;
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                if(r.getString("CURRENT_OWNER_ID") != null) {
                    wbo.setAttribute("currentOwnerID", r.getString("CURRENT_OWNER_ID"));
                }
                if(r.getString("CURRENT_OWNER_NAME") != null) {
                    wbo.setAttribute("currentOwnerName", r.getString("CURRENT_OWNER_NAME"));
                }
                if(r.getString("CREATED_BY_NAME") != null) {
                    wbo.setAttribute("createdByName", r.getString("CREATED_BY_NAME"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            result.add(wbo);
        }
        return result;
    }
    
    public ArrayList getAllPurchOwnerClient()
    {
        Vector queryResult = new Vector();
        WebBusinessObject wbo = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        try
        {
            //connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("getAllPurchOwnerClient").trim());
            queryResult = forInsert.executeQuery();
            endTransaction();
        }
        catch (SQLException se)
        {
            logger.error(se.getMessage());
        }
        catch (UnsupportedTypeException ex)
        {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        ArrayList resultBusObjs = new ArrayList();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements())
        {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;

    }
    
    public Vector getAllCustomers() throws NoUserInSessionException {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        StringBuilder where = new StringBuilder();
        
        
        try {
            String query = getQuery("getAllCustomers").trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query + where.toString());
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
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        Vector resultBusObjs = new Vector();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }
    
    public Vector getAllCustomersFiltered(String fieldValue) throws NoUserInSessionException {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        StringBuilder where = new StringBuilder();
        
        
        try {
            String query = getQuery("getAllCustomersFiltered").trim().replaceAll("ABC", fieldValue);;
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query + where.toString());
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
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        Vector resultBusObjs = new Vector();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> getJobStatistics(boolean isCustomer) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getJobStatistics").replace("whereSign", isCustomer ? "=" : "!=").trim());
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
        ArrayList<WebBusinessObject> result = new ArrayList<>();
        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                wbo.setAttribute("jobName", r.getString("JOB_NAME") != null ? r.getString("JOB_NAME") : "(No Job)");
                wbo.setAttribute("clientCount", r.getString("CLIENT_COUNT"));
                result.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return result;
    }
    
    public ArrayList<WebBusinessObject> getRegionStatistics(boolean isCustomer) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getRegionStatistics").replace("whereSign", isCustomer ? "=" : "!=").trim());
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
        ArrayList<WebBusinessObject> result = new ArrayList<>();
        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                wbo.setAttribute("regionName", r.getString("REGION_NAME") != null ? r.getString("REGION_NAME") : "(No Region)");
                wbo.setAttribute("clientCount", r.getString("CLIENT_COUNT"));
                result.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return result;
    }
    
    public ArrayList<WebBusinessObject> getRepeatedMeetingsClients(java.sql.Date fromDate, java.sql.Date toDate, boolean isRepeated) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getRepeatedMeetingsClients").replace("whereSign", isRepeated ? ">" : "=").trim());
            forQuery.setparams(params);
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
        ArrayList<WebBusinessObject> result = new ArrayList<>();
        Row r = null;
        Enumeration e = queryResult.elements();
        try {
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
                wbo.setAttribute("meetingsCount", r.getString("MEETING_COUNT"));
                wbo.setAttribute("ratedByName", r.getString("RATED_BY_NAME") != null ? r.getString("RATED_BY_NAME") : "---");
                wbo.setAttribute("rateName", r.getString("RATE_NAME") != null ? r.getString("RATE_NAME") : "---");
                result.add(wbo);
            }
        } catch (NoSuchColumnException ce) {
            logger.error(ce);
        }
        return result;
    }
    
    public ArrayList<WebBusinessObject> getClientsWithoutComChannels(java.util.Date fromDate, java.util.Date toDate, String groupID)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector params = new Vector();
        params.addElement(new DateValue(new java.sql.Date(fromDate.getTime())));
        params.addElement(new DateValue(new java.sql.Date(toDate.getTime())));
        params.addElement(new StringValue(groupID));
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getClientsWithoutComChannels").trim());
            command.setparams(params);
            result = command.executeQuery();

            ArrayList<WebBusinessObject> data = new ArrayList<>();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getString("SYS_ID") != null)
                    {
                        wbo.setAttribute("id", row.getString("SYS_ID"));
                    }
                    if (row.getString("MOBILE") != null)
                    {
                        wbo.setAttribute("mobile", row.getString("MOBILE"));
                    }
                    else
                    {
                        wbo.setAttribute("mobile", "---");
                    }

                    if (row.getString("CLIENT_NO") != null)
                    {
                        wbo.setAttribute("clientNO", row.getString("CLIENT_NO"));
                    }

                    if (row.getString("NAME") != null)
                    {
                        wbo.setAttribute("name", row.getString("NAME"));

                    }
                    
                    if (row.getString("EMAIL") != null)
                    {
                        wbo.setAttribute("email", row.getString("EMAIL"));

                    } else {
                        wbo.setAttribute("email", "---");
                    }
                    
                    if (row.getString("DESCRIPTION") != null)
                    {
                        wbo.setAttribute("notes", row.getString("DESCRIPTION"));
                    } else {
                        wbo.setAttribute("notes", "");
                    }
                    
                    if (row.getString("INTER_PHONE") != null && !row.getString("INTER_PHONE").equalsIgnoreCase("UL"))
                    {
                        wbo.setAttribute("interPhone", row.getString("INTER_PHONE"));

                    } else {
                        wbo.setAttribute("interPhone", "---");
                    }
                    
                    if (row.getString("ENGLISHNAME") != null)
                    {
                        wbo.setAttribute("commChannel", row.getString("ENGLISHNAME"));
                    } else {
                        wbo.setAttribute("commChannel", "---");
                    }
                }
                catch (NoSuchColumnException ex)
                {
                    Logger.getLogger(ClientMgr.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
            return data;

        }
        catch (UnsupportedTypeException | SQLException ex)
        {
            Logger.getLogger(ClientMgr.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            try
            {
                if (connection != null)
                {
                    connection.close();
                }
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
        }
        return new ArrayList<>();
    }
    
    public void chngComChannel(String clients[], String comChannel) {
        Connection connection = null;
        SQLCommandBean forUpdate = new SQLCommandBean();
        Vector params = new Vector();
        int queryResult = -1000;
        
        StringBuilder clientsIDs = new StringBuilder();
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
           
            int counter = 0;
            
            params.addElement(new StringValue(comChannel));
            
            for (int i = 0; i < clients.length; i++) {
                if(i == 0){
                    clientsIDs.append("?");
                } else {
                    clientsIDs.append(", ?");
                }
                
                params.addElement(new StringValue(clients[i]));
            }
            
            String query = getQuery("chngComChannel");
            forUpdate.setSQLQuery(query.replaceAll("clientIds", clientsIDs.toString()));
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
    }
    
    public WebBusinessObject getClientUserLocked(String clientID) {
        Connection connection = null;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(clientID));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        WebBusinessObject wbo = null;
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientUserLocked").trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            Row r;
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    if (r.getString("USER_ID") != null) {
                        wbo.setAttribute("userID", r.getString("USER_ID"));
                    }
                    if (r.getString("LOCKED_TO_NAME") != null) {
                        wbo.setAttribute("lockedToName", r.getString("LOCKED_TO_NAME"));
                    }
                    if (r.getString("LOCKED_BY_NAME") != null) {
                        wbo.setAttribute("lockedByName", r.getString("LOCKED_BY_NAME"));
                    }
                    if (r.getString("LOCK_DATE") != null) {
                        wbo.setAttribute("lockDate", r.getString("LOCK_DATE").substring(0, 16));
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                return wbo;
            }
        }
        return null;
    }
    
    public ArrayList<WebBusinessObject> getClientByNameOrCode(String value) {
        Vector param = new Vector();
        Connection connection = null;
        Vector<Row> rows = null;
        SQLCommandBean command = new SQLCommandBean();
        WebBusinessObject wbo;
        ArrayList<WebBusinessObject> result = new ArrayList<>();
        try {
//            param.addElement(new StringValue(value));
//            param.addElement(new StringValue(value));
            connection = dataSource.getConnection();
            command.setConnection(connection);
          
           // String query="SELECT * FROM CLIENT "
          //  command.setSQLQuery(getQuery("getClientByNameOrCode").replaceAll("@", value).trim());
//            command.setparams(param);
              command.setSQLQuery("SELECT * FROM CLIENT WHERE NAME LIKE '%"+value+"%' OR CLIENT_NO LIKE '%"+value+"%' OR MOBILE LIKE '%"+value+"%'");
            rows = command.executeQuery();
            for (Row row : rows) {
                wbo = fabricateBusObj(row);
                result.add(wbo);
            }
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
        return result;
    }
    
    public String checkClientPhoneExist(String phoneNo) {
        Connection connection = null;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(phoneNo));
        parameters.addElement(new StringValue(phoneNo));
        parameters.addElement(new StringValue(phoneNo));
        parameters.addElement(new StringValue(phoneNo));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("checkClientPhoneExist").trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        try {
            return queryResult != null && !queryResult.isEmpty() ? ((Row) queryResult.firstElement()).getString("SYS_ID") : null;
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
    
    public ArrayList<WebBusinessObject> getClientsWithExtraPhones() {
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientsWithExtraPhones"));
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
        ArrayList<WebBusinessObject> result = new ArrayList<>();
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            result.add(fabricateBusObj((Row) e.nextElement()));
        }
        return result;
    }
    
    public ArrayList<WebBusinessObject> getUserClientsInterLocal(String currentOwnerID, java.util.Date fromDate,
            java.util.Date toDate, String clientType) {
        Connection connection = null;
        Vector queryResult = null;
        Vector params = new Vector();
        params.addElement(new StringValue(currentOwnerID));
        params.addElement(new DateValue(new java.sql.Date(fromDate.getTime())));
        params.addElement(new DateValue(new java.sql.Date(toDate.getTime())));
        params.addElement(new StringValue(clientType));
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getUserClientsInterLocal"));
            forQuery.setparams(params);
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
        ArrayList<WebBusinessObject> result = new ArrayList<>();
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            result.add(fabricateBusObj((Row) e.nextElement()));
        }
        return result;
    }
    
    public boolean updateInterLocalClientsType() {
        Connection connection = null;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("updateInterClientsType").trim());
            forInsert.executeUpdate();
            forInsert.setSQLQuery(getQuery("upsateLocalClientsType").trim());
            forInsert.executeUpdate();
            return true;
        } catch (SQLException ex) {
            logger.error(ex);
            return false;
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException ex) {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
    }
    
    public boolean saveCallDataAutoStatusCust(String clientId, String meetingType) {
        Connection connection = null;
                Vector params = new Vector();
        params.addElement(new StringValue(clientId));
        params.addElement(new StringValue(meetingType));

        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("custStatusType").trim());
            forInsert.setparams(params);
            forInsert.executeUpdate();
            return true;
        } catch (SQLException ex) {
            logger.error(ex);
            return false;
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException ex) {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
    }
    
    public ArrayList<WebBusinessObject> getAverageCustomerPurchaseTime(String campaignID) {
        Connection connection = null;
        Vector queryResult = null;
        Vector params = new Vector();
        params.addElement(new StringValue(campaignID));
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getAverageCustomerPurchaseTime"));
            forQuery.setparams(params);
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
        ArrayList<WebBusinessObject> result = new ArrayList<>();
        Enumeration e = queryResult.elements();
        WebBusinessObject wbo;
        Row r;
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("PURCHASE_DATE") != null) {
                    wbo.setAttribute("purchaseDate", r.getString("PURCHASE_DATE"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            result.add(wbo);
        }
        return result;
    }
    
    public ArrayList<WebBusinessObject> getClientsWithNoWish(java.sql.Date beginDate, java.sql.Date endDate, boolean hasVisits, String groupID) {
        Vector param = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        StringBuilder where = new StringBuilder();
        if (hasVisits) {
            where.append(" AND CL.SYS_ID IN (SELECT CLIENT_ID FROM APPOINTMENT WHERE OPTION9 = 'attended') ");
        }
        String query = getQuery("getClientsWithNoWish").replaceAll("whereStatement", where.toString()).trim();
        try {
            param.addElement(new DateValue(beginDate));
            param.addElement(new DateValue(endDate));
            param.addElement(new StringValue(groupID != null ? groupID : ""));
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }
        ArrayList<WebBusinessObject> results = new ArrayList<>();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            results.add(fabricateBusObj(r));
        }
        return results;
    }
    
    public ArrayList<WebBusinessObject> getMyClientsWithNoWish(java.sql.Date beginDate, java.sql.Date endDate, boolean hasVisits, String userID) {
        Vector param = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        StringBuilder where = new StringBuilder();
        if (hasVisits) {
            where.append(" AND CL.SYS_ID IN (SELECT CLIENT_ID FROM APPOINTMENT WHERE OPTION9 = 'attended') ");
        }
        String query = getQuery("getMyClientsWithNoWish").replaceAll("whereStatement", where.toString()).trim();
        try {
            param.addElement(new DateValue(beginDate));
            param.addElement(new DateValue(endDate));
            param.addElement(new StringValue(userID));
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }
        ArrayList<WebBusinessObject> results = new ArrayList<>();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            results.add(fabricateBusObj(r));
        }
        return results;
    }
    
    public ArrayList<WebBusinessObject> getClientsWithLegalDispute() {
        Vector param = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        StringBuilder where = new StringBuilder();
        
        String query = getQuery("getClientsWithLegalDispute").trim();
        try {
            
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query);
             queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }
        ArrayList<WebBusinessObject> results = new ArrayList<>();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            WebBusinessObject wbo=fabricateBusObj(r);
            try {
                if(r.getString("BEGIN_DATE")!=null)
                    wbo.setAttribute("BEGIN_DATE", r.getString("BEGIN_DATE"));
                else
                    wbo.setAttribute("BEGIN_DATE", "");
                 if(r.getString("STATUS_NOTE")!=null)
                    wbo.setAttribute("STATUS_NOTE", r.getString("STATUS_NOTE"));
                else
                    wbo.setAttribute("STATUS_NOTE", "");
                 if(r.getString("EMAIL")!=null)
                    wbo.setAttribute("EMAIL", r.getString("EMAIL"));
                else
                    wbo.setAttribute("EMAIL", "");
            
            
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            results.add(wbo);
            
            
        }
        return results;
    }
    
    public ArrayList<WebBusinessObject> getClientsWithLegalDisputeForClient(String clientLegal) {
        Vector param = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        param.addElement(new StringValue(clientLegal));
        
        String query = getQuery("getClientsWithLegalDisputeForClient").trim();
        try {
            
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }
        ArrayList<WebBusinessObject> results = new ArrayList<>();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            WebBusinessObject wbo=fabricateBusObj(r);
            try {
                if(r.getString("STATUS_NOTE")!=null)
                    wbo.setAttribute("STATUS_NOTE", r.getString("STATUS_NOTE"));
                else
                    wbo.setAttribute("STATUS_NOTE", "");           
            
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            results.add(wbo);
            
            
        }
        return results;
    }
    
    public ArrayList<WebBusinessObject> getClientsReserve(String clientLegal,String clientTele,String projectDatabase) {
        String userId = (String) projectDatabase;
        String dataBaseRealEstat = null;
        if (userId.equals("3")){
           dataBaseRealEstat = "units_realestate2";
        } else {
            dataBaseRealEstat = "units_realestate";
        }
        Vector param = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        param.addElement(new StringValue(clientLegal));
        param.addElement(new StringValue(clientTele));
        param.addElement(new StringValue(userId));
        
        String query = getQuery("getClientsReserve").replace("datebase", dataBaseRealEstat).trim();
        try {
            
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }
        ArrayList<WebBusinessObject> results = new ArrayList<>();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            WebBusinessObject wbo=fabricateBusObj(r);
            try {
                if(r.getString("STAGE_CODE")!=null)
                    wbo.setAttribute("STAGE_CODE", r.getString("STAGE_CODE"));
                else
                    wbo.setAttribute("STAGE_CODE", "No Data");           
                if(r.getString("STAGE_DESCRIPTION")!=null)
                    wbo.setAttribute("STAGE_DESCRIPTION", r.getString("STAGE_DESCRIPTION"));
                else
                    wbo.setAttribute("STAGE_DESCRIPTION", "No Data");           
                if(r.getString("BUILDING_CODE")!=null)
                    wbo.setAttribute("BUILDING_CODE", r.getString("BUILDING_CODE"));
                else
                    wbo.setAttribute("BUILDING_CODE", "No Data");
                if(r.getString("BUILDING_DESCRIPTION")!=null)
                    wbo.setAttribute("BUILDING_DESCRIPTION", r.getString("BUILDING_DESCRIPTION"));
                else
                    wbo.setAttribute("BUILDING_DESCRIPTION", "No Data");
                if(r.getString("UNIT_NAME")!=null)
                    wbo.setAttribute("UNIT_NAME", r.getString("UNIT_NAME"));
                else
                    wbo.setAttribute("UNIT_NAME", "No Data");
                if(r.getString("DESCDETAILS")!=null)
                    wbo.setAttribute("DESCDETAILS", r.getString("DESCDETAILS"));
                else
                    wbo.setAttribute("DESCDETAILS", "No Data");
                if(r.getString("RESERVED")!=null)
                    wbo.setAttribute("RESERVED", r.getString("RESERVED"));
                else
                    wbo.setAttribute("RESERVED", "No Data");
                
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            results.add(wbo);
            
            
        }
        return results;
    }
    
        public ArrayList<WebBusinessObject> getClientsBuyer(String clientLegal,String clientTele,String projectDatabase) {
        String userId = (String) projectDatabase;
        String dataBaseRealEstat = null;
        if (userId.equals("3")){
           dataBaseRealEstat = "units_realestate2";
        } else {
            dataBaseRealEstat = "units_realestate";
        }
        Vector param = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        param.addElement(new StringValue(clientLegal));
        param.addElement(new StringValue(clientTele));
        param.addElement(new StringValue(userId));
        
        String query = getQuery("getClientsBuyer").replace("datebase", dataBaseRealEstat).trim();
        try {
            
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }
        ArrayList<WebBusinessObject> results = new ArrayList<>();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            WebBusinessObject wbo=fabricateBusObj(r);
            try {
                if(r.getString("STAGE_CODE")!=null)
                    wbo.setAttribute("STAGE_CODE", r.getString("STAGE_CODE"));
                else
                    wbo.setAttribute("STAGE_CODE", "No Data");           
                if(r.getString("STAGE_DESCRIPTION")!=null)
                    wbo.setAttribute("STAGE_DESCRIPTION", r.getString("STAGE_DESCRIPTION"));
                else
                    wbo.setAttribute("STAGE_DESCRIPTION", "No Data");           
                if(r.getString("BUILDING_CODE")!=null)
                    wbo.setAttribute("BUILDING_CODE", r.getString("BUILDING_CODE"));
                else
                    wbo.setAttribute("BUILDING_CODE", "No Data");
                if(r.getString("BUILDING_DESCRIPTION")!=null)
                    wbo.setAttribute("BUILDING_DESCRIPTION", r.getString("BUILDING_DESCRIPTION"));
                else
                    wbo.setAttribute("BUILDING_DESCRIPTION", "No Data");
                if(r.getString("UNIT_NAME")!=null)
                    wbo.setAttribute("UNIT_NAME", r.getString("UNIT_NAME"));
                else
                    wbo.setAttribute("UNIT_NAME", "No Data");
                if(r.getString("DESCDETAILS")!=null)
                    wbo.setAttribute("DESCDETAILS", r.getString("DESCDETAILS"));
                else
                    wbo.setAttribute("DESCDETAILS", "No Data");
                if(r.getString("SOLD")!=null)
                    wbo.setAttribute("SOLD", r.getString("SOLD"));
                else
                    wbo.setAttribute("SOLD", "No Data");
                
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            results.add(wbo);
            
            
        }
        return results;
    }
        
    public ArrayList<WebBusinessObject> getUnitValueFive(String clientUnit) {

        Vector param = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        param.addElement(new StringValue(clientUnit));
        
        String query = getQuery("getUnitValueFive").trim();
        try {
            
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }
        ArrayList<WebBusinessObject> results = new ArrayList<>();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            WebBusinessObject wbo=fabricateBusObj(r);
            try {
                if(r.getString("PRODUCT_CATEGORY_ID")!=null)
                    wbo.setAttribute("PRODUCT_CATEGORY_ID", r.getString("PRODUCT_CATEGORY_ID"));
                else
                    wbo.setAttribute("PRODUCT_CATEGORY_ID", "No Data");
                
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            results.add(wbo);
            
            
        }        return results;
    }    

    public ArrayList<WebBusinessObject> getTypeWifi() {

        Vector param = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        //param.addElement(new StringValue(clientUnit));
        
        String query = getQuery("getTypeWifi").trim();
        try {
            
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }
        ArrayList<WebBusinessObject> results = new ArrayList<>();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            WebBusinessObject wbo=fabricateBusObj(r);
            try {
                if(r.getString("ITEM_CODE")!=null){
                    wbo.setAttribute("ITEM_CODE", r.getString("ITEM_CODE"));
                } else{
                    wbo.setAttribute("ITEM_CODE", "No Data");
                }
                if(r.getString("ITEMNAME")!=null){
                    wbo.setAttribute("ITEMNAME", r.getString("ITEMNAME"));
                } else{
                    wbo.setAttribute("ITEMNAME", "No Data");
                }
                if(r.getString("SALE_PRICE")!=null){
                    wbo.setAttribute("SALE_PRICE", r.getString("SALE_PRICE"));
                } else{
                    wbo.setAttribute("SALE_PRICE", "No Data");
                }
                if(r.getString("GROUPCODE")!=null){
                    wbo.setAttribute("GROUPCODE", r.getString("GROUPCODE"));
                } else{
                    wbo.setAttribute("GROUPCODE", "No Data");
                }
                if(r.getString("GROUPNAME")!=null){
                    wbo.setAttribute("GROUPNAME", r.getString("GROUPNAME"));
                } else{
                    wbo.setAttribute("GROUPNAME", "No Data");
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            results.add(wbo);
            
            
        }        return results;
    }    

    
    public ArrayList<WebBusinessObject> getClientCheck(WebBusinessObject clientInfo, String projectDatabase) throws SQLException {
        String userId = (String) projectDatabase;
        String getAssetErpName = metaDataMgr.getAssetErpName().toString();
        String getAssetErpPassword = metaDataMgr.getAssetErpPassword().toString();
        String dataBaseRealEstat = null;
        if (userId.equals(getAssetErpName)){
            dataBaseRealEstat = metaDataMgr.getStoreErpName().toString();
        } else if (userId.equals(getAssetErpPassword)){
            dataBaseRealEstat = metaDataMgr.getStoreErpPassword().toString();
        }

        String name = (String) clientInfo.getAttribute("mobile");
        
        Vector params = new Vector();
        params.addElement(new StringValue(name));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(sqlMgr.getSql("getClientCheck").replace("datebase", dataBaseRealEstat).trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }
        ArrayList<WebBusinessObject> results = new ArrayList<>();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            WebBusinessObject wbo=fabricateBusObj(r);
            try {
                if(r.getString("CLIENT_CODE")!=null)
                    wbo.setAttribute("CLIENT_CODE", r.getString("CLIENT_CODE"));
                else
                    wbo.setAttribute("CLIENT_CODE", "");           
            
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            results.add(wbo);
            
            
        }
        return results;
    }
    
    public ArrayList<WebBusinessObject> getClientCheckWiFi(WebBusinessObject clientInfo) throws SQLException {
        String getAssetErpName = metaDataMgr.getAssetErpName().toString();
        String name = (String) clientInfo.getAttribute("mobile");
        
        Vector params = new Vector();
        params.addElement(new StringValue(name));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(sqlMgr.getSql("getClientCheckWifi").replace("datebase", getAssetErpName).trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }
        ArrayList<WebBusinessObject> results = new ArrayList<>();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            WebBusinessObject wbo=fabricateBusObj(r);
            try {
                if(r.getString("CLIENT_CODE")!=null)
                    wbo.setAttribute("CLIENT_CODE", r.getString("CLIENT_CODE"));
                else
                    wbo.setAttribute("CLIENT_CODE", "");           
            
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            results.add(wbo);
            
            
        }
        return results;
    }
    
    public boolean removeClientNameWhiteSpace() {
        Connection connection = null;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("removeClientNameWhiteSpace").trim());
            forInsert.executeUpdate();
            return true;
        } catch (SQLException ex) {
            logger.error(ex);
            return false;
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException ex) {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
    }
    
    public boolean updateClientKnownUs(String oldValue, String newValue) {
        Vector param = new Vector();
        Connection connection = null;
        try {
            param.addElement(new StringValue(newValue));
            param.addElement(new StringValue(oldValue));
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("updateClientKnownUs").trim());
            forInsert.setparams(param);
            return forInsert.executeUpdate() > 0;
        } catch (SQLException ex) {
            logger.error(ex);
            return false;
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException ex) {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
    }
    
    public ArrayList<WebBusinessObject> getTradeClients(String tradeID, boolean isCustomer) {
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new StringValue(tradeID));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getTradeClients").replace("whereSign", isCustomer ? "=" : "!=").trim());
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
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("CREATED_BY_NAME") != null) {
                    wbo.setAttribute("createdByName", r.getString("CREATED_BY_NAME"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientMgr.class
                        .getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }
    public ArrayList<WebBusinessObject> getClientByMob(String departmentID,String Mobile,String searchBy){
    
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new StringValue(departmentID));
        params.addElement(new StringValue(departmentID));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientByMob").replace("clientMob", "and cc."+searchBy +" like '%" + Mobile).trim()+ "%'");
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
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("sys_id") != null) {
                    wbo.setAttribute("id", r.getString("sys_id"));
                }
                if (r.getString("client_no") != null) {
                    wbo.setAttribute("client_no", r.getString("client_no"));
                }
                if (r.getString("name") != null) {
                    wbo.setAttribute("name", r.getString("name"));
                }
                if (r.getString("mobile") != null) {
                    wbo.setAttribute("mobile", r.getString("mobile"));
                }
                if (r.getString("email") != null) {
                    wbo.setAttribute("email", r.getString("email"));
                }
                if (r.getString("created_by") != null) {
                    wbo.setAttribute("created_by", r.getString("created_by"));
                } 
                if (r.getString("creation_time") != null) {
                    wbo.setAttribute("creation_time", r.getString("creation_time"));
                } 
                if (r.getString("INTER_PHONE") != null) {
                    wbo.setAttribute("INTER_PHONE", r.getString("INTER_PHONE"));
                } 
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientMgr.class
                        .getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }
        public ArrayList<WebBusinessObject> getClientCustom(){
    
        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientCustom").trim());
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
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("project_id") != null) {
                    wbo.setAttribute("project_id", r.getString("project_id"));
                }
                if (r.getString("project_name") != null) {
                    wbo.setAttribute("project_name", r.getString("project_name"));
                }
                if (r.getString("cust") != null) {
                    wbo.setAttribute("cust", r.getString("cust"));
                }
                if (r.getString("block") != null) {
                    wbo.setAttribute("block", r.getString("block"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientMgr.class
                        .getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

                public String getMaxClientId() throws SQLException, NoSuchColumnException
    {
        String getAssetErpName = metaDataMgr.getAssetErpName().toString();
        Connection connection = null;

        Vector queryResult = new Vector();

        SQLCommandBean forQuery = new SQLCommandBean();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getMaxClientId").replace("datebase", getAssetErpName).trim());
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            connection.close();
        }

        Row row;
        if (!queryResult.isEmpty())
        {
            Enumeration e = queryResult.elements();
            row = (Row) e.nextElement();
            String count = row.getString("codeClient");
            return count;
        }
        else
        {
            return null;
        }
    }

                public String getMaxClientIdStore() throws SQLException, NoSuchColumnException
    {
        String getAssetErpName = metaDataMgr.getAssetErpName().toString();
        Connection connection = null;

        Vector queryResult = new Vector();

        SQLCommandBean forQuery = new SQLCommandBean();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getMaxClientIdStore").replace("datebase", getAssetErpName).trim());
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            connection.close();
        }

        Row row;
        if (!queryResult.isEmpty())
        {
            Enumeration e = queryResult.elements();
            row = (Row) e.nextElement();
            String count = row.getString("storeId");
            return count;
        }
        else
        {
            return null;
        }
    }
                
                public String getMaxtrnsNo() throws SQLException, NoSuchColumnException
    {
        String getAssetErpName = metaDataMgr.getAssetErpName().toString();
        Connection connection = null;

        Vector queryResult = new Vector();

        SQLCommandBean forQuery = new SQLCommandBean();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getMaxtrnsNo").replace("datebase", getAssetErpName).trim());
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            connection.close();
        }

        Row row;
        if (!queryResult.isEmpty())
        {
            Enumeration e = queryResult.elements();
            row = (Row) e.nextElement();
            String count = row.getString("trns_no");
            return count;
        }
        else
        {
            return null;
        }
    }
                
                public String getMaxstoreNo() throws SQLException, NoSuchColumnException
    {
        String getAssetErpName = metaDataMgr.getAssetErpName().toString();
        Connection connection = null;

        Vector queryResult = new Vector();

        SQLCommandBean forQuery = new SQLCommandBean();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getMaxstoreNo").replace("datebase", getAssetErpName).trim());
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            connection.close();
        }

        Row row;
        if (!queryResult.isEmpty())
        {
            Enumeration e = queryResult.elements();
            row = (Row) e.nextElement();
            String count = row.getString("store_no");
            return count;
        }
        else
        {
            return null;
        }
    }
                
                public String getUnitName(String codeUnit) throws SQLException, NoSuchColumnException
    {
        Connection connection = null;
        Vector params = new Vector();
        params.addElement(new StringValue(codeUnit));

        Vector queryResult = new Vector();

        SQLCommandBean forQuery = new SQLCommandBean();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getUnitName").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            connection.close();
        }

        Row row;
        if (!queryResult.isEmpty())
        {
            Enumeration e = queryResult.elements();
            row = (Row) e.nextElement();
            String count = row.getString("PROJECT_NAME");
            return count;
        }
        else
        {
            return null;
        }
    }
                
    public String getUnitId(String codeUnit) throws SQLException, NoSuchColumnException
    {
        Connection connection = null;
        Vector params = new Vector();
        params.addElement(new StringValue(codeUnit));

        Vector queryResult = new Vector();

        SQLCommandBean forQuery = new SQLCommandBean();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getUnitId").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            connection.close();
        }

        Row row;
        if (!queryResult.isEmpty())
        {
            Enumeration e = queryResult.elements();
            row = (Row) e.nextElement();
            String count = row.getString("unitCodeRel");
            return count;
        }
        else
        {
            return null;
        }
    }
    
    public String getUserCode(String codeUnit) throws SQLException, NoSuchColumnException
    {
        Connection connection = null;
        Vector params = new Vector();
        params.addElement(new StringValue(codeUnit));

        Vector queryResult = new Vector();

        SQLCommandBean forQuery = new SQLCommandBean();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getUserCode").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            connection.close();
        }

        Row row;
        if (!queryResult.isEmpty())
        {
            Enumeration e = queryResult.elements();
            row = (Row) e.nextElement();
            String count = row.getString("can_send_email");
            return count;
        }
        else
        {
            return null;
        }
    }
    
                public String getInstProg(String codeUnit) throws SQLException, NoSuchColumnException
    {
        Connection connection = null;
        Vector params = new Vector();
        params.addElement(new StringValue(codeUnit));

        Vector queryResult = new Vector();

        SQLCommandBean forQuery = new SQLCommandBean();
        try
        {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getInstProg").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        }
        catch (SQLException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        catch (UnsupportedTypeException uste)
        {
            logger.error("***** " + uste.getMessage());
        }
        finally
        {
            connection.close();
        }

        Row row;
        if (!queryResult.isEmpty())
        {
            Enumeration e = queryResult.elements();
            row = (Row) e.nextElement();
            String count = row.getString("unit_value");
            return count;
        }
        else
        {
            return null;
        }
    }

    public List<WebBusinessObject> getSource() {
    List<WebBusinessObject> sources = new ArrayList<>();
    Connection connection = null;
    Vector queryResult = new Vector();
    SQLCommandBean forQuery = new SQLCommandBean();

    try {
        connection = dataSource.getConnection();
        forQuery.setConnection(connection);
        forQuery.setSQLQuery(getQuery("getSource").trim());
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
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    if (!queryResult.isEmpty()) {
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            Row r = (Row) e.nextElement();
            WebBusinessObject wbo = fabricateBusObj(r);

            try {
                if (r.getString("ID") != null) {
                    wbo.setAttribute("sourceID", r.getString("ID"));
                }
                if (r.getString("englishname") != null) {
                    wbo.setAttribute("englishname", r.getString("englishname"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            sources.add(wbo);
        }
    }

    return sources;
}
    
    public List<WebBusinessObject> getCampaigns() {
    List<WebBusinessObject> sources = new ArrayList<>();
    Connection connection = null;
    Vector queryResult = new Vector();
    SQLCommandBean forQuery = new SQLCommandBean();

    try {
        connection = dataSource.getConnection();
        forQuery.setConnection(connection);
        forQuery.setSQLQuery(getQuery("getCampaigns").trim());
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
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    if (!queryResult.isEmpty()) {
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            Row r = (Row) e.nextElement();
            WebBusinessObject wbo = fabricateBusObj(r);

            try {
                if (r.getString("ID") != null) {
                    wbo.setAttribute("id", r.getString("ID"));
                }
                if (r.getString("campaign_title") != null) {
                    wbo.setAttribute("campaignTitle", r.getString("campaign_title"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            sources.add(wbo);
        }
    }

    return sources;
}
    
    public List<WebBusinessObject> getBroker() {
    List<WebBusinessObject> sources = new ArrayList<>();
    Connection connection = null;
    Vector queryResult = new Vector();
    SQLCommandBean forQuery = new SQLCommandBean();

    try {
        connection = dataSource.getConnection();
        forQuery.setConnection(connection);
        forQuery.setSQLQuery(getQuery("getBroker").trim());
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
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    if (!queryResult.isEmpty()) {
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            Row r = (Row) e.nextElement();
            WebBusinessObject wbo = fabricateBusObj(r);

            try {
                if (r.getString("ID") != null) {
                    wbo.setAttribute("id", r.getString("ID"));
                }
                if (r.getString("campaign_title") != null) {
                    wbo.setAttribute("campaignTitle", r.getString("campaign_title"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            sources.add(wbo);
        }
    }

    return sources;
}

}
