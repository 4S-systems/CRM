package com.clients.db_access;

import com.silkworm.business_objects.*;
import com.silkworm.persistence.relational.*;
import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class ClientComplaintsSLAMgr extends RDBGateWay
{

    private static final ClientComplaintsSLAMgr clientComplaintsSLAMgr = new ClientComplaintsSLAMgr();

    public static ClientComplaintsSLAMgr getInstance()
    {
        logger.info("Getting IssueProjectMgr Instance ....");
        return clientComplaintsSLAMgr;
    }

    public ClientComplaintsSLAMgr()
    {
    }

    @Override
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
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("client_complaints_sla.xml")));
                logger.debug("supportedForm --> " + supportedForm);
            }
            catch (Exception e)
            {
                logger.error("Could not locate XML Document from clientComplaintsSLAMgr");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException
    {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult;
        params.addElement(new StringValue((String) wbo.getAttribute("clientComplaintID")));
        params.addElement(new StringValue((String) wbo.getAttribute("executionPeriod")));
        params.addElement(new StringValue((String) wbo.getAttribute("createdBy")));
        params.addElement(new StringValue((String) wbo.getAttribute("option1"))); //option 1
        params.addElement(new StringValue((String) wbo.getAttribute("option2"))); //option 2
        params.addElement(new StringValue("UL")); //option 3
        params.addElement(new StringValue(null)); //actualBeginDate
        params.addElement(new StringValue(null)); //actualEndDate
        params.addElement(new StringValue("UL")); //option 4
        params.addElement(new StringValue(null)); //expectedBeginDate
        params.addElement(new StringValue(null)); //expectedEndDate
        try
        {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertComplaintsSLA").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        }
        catch (SQLException se)
        {
            logger.error(se.getMessage());
            return false;
        }
        return (queryResult > 0);
    }

    public boolean updateObject(WebBusinessObject wbo) throws SQLException
    {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult;
        params.addElement(new StringValue((String) wbo.getAttribute("executionPeriod")));
        params.addElement(new StringValue((String) wbo.getAttribute("clientComplaintID")));
        try
        {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("updateComplaintsSLA").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        }
        catch (SQLException se)
        {
            logger.error(se.getMessage());
            return false;
        }
        return (queryResult > 0);
    }

    public boolean acceptSLA(String id)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        int result;

        parameters.addElement(new StringValue(id));

        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("acceptSLA").trim());
            command.setparams(parameters);
            result = command.executeUpdate();
        }
        catch (SQLException se)
        {
            try
            {
                connection.close();
            }
            catch (SQLException ex)
            {
                logger.error(ex.getMessage());
            }
            logger.error(se.getMessage());
            return false;
        }
        return (result > 0);
    }

    @Override
    public ArrayList getCashedTableAsBusObjects()
    {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        Iterator it = cashedTable.iterator();
        while (it.hasNext())
        {
            wbo = (WebBusinessObject) it.next();

            cashedData.add(wbo);
        }
        return cashedData;
    }

    @Override
    public ArrayList getCashedTableAsArrayList()
    {
        return null;
    }

    @Override
    protected void initSupportedQueries()
    {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    public ArrayList<WebBusinessObject> getNotCompletedComplaintsSLA(String userID)
    {
        String theQuery = getQuery("getNotCompletedComplaintsSLA").trim();
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector<Row> result;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(userID));

        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(theQuery);
            command.setparams(parameters);
            result = command.executeQuery();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getBigDecimal("REMAIN") != null)
                    {
                        wbo.setAttribute("remain", row.getBigDecimal("REMAIN"));
                    }
                    if (row.getString("BUSINESS_ID") != null)
                    {
                        wbo.setAttribute("businessID", row.getString("BUSINESS_ID"));
                    }
                    if (row.getString("BUSINESS_ID_BY_DATE") != null)
                    {
                        wbo.setAttribute("businessIDbyDate", row.getString("BUSINESS_ID_BY_DATE"));
                    }
                    if (row.getString("BUSINESS_COMP_ID") != null)
                    {
                        wbo.setAttribute("businessCompID", row.getString("BUSINESS_COMP_ID"));
                    }
                    if (row.getString("FULL_NAME") != null)
                    {
                        wbo.setAttribute("ownerName", row.getString("FULL_NAME"));
                    }
                    if (row.getString("STATUS_NAME") != null)
                    {
                        wbo.setAttribute("statusName", row.getString("STATUS_NAME"));
                    }
                    if (row.getString("CURRENT_STATUS") != null)
                    {
                        wbo.setAttribute("statusCode", row.getString("CURRENT_STATUS"));
                    }
                    if (row.getString("END_DATE") != null)
                    {
                        wbo.setAttribute("endDate", row.getString("END_DATE"));
                    }
                    if (row.getString("ISSUE_ID") != null)
                    {
                        wbo.setAttribute("issueID", row.getString("ISSUE_ID"));
                    }
                    if (row.getString("ID") != null)
                    {
                        wbo.setAttribute("clientComplaintID", row.getString("ID"));
                    }
                    if (row.getString("CLIENT_ID") != null)
                    {
                        wbo.setAttribute("clientID", row.getString("CLIENT_ID"));
                    }
                    if (row.getString("CLIENT_NAME") != null)
                    {
                        wbo.setAttribute("clientName", row.getString("CLIENT_NAME"));
                    }
                    if (row.getString("END_DATE") != null)
                    {
                        wbo.setAttribute("endDate", row.getString("END_DATE"));
                    }
                }
                catch (NoSuchColumnException ex)
                {
                    logger.error(ex);
                }
                catch (UnsupportedConversionException ex)
                {
                    Logger.getLogger(ClientComplaintsSLAMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        catch (SQLException | UnsupportedTypeException ex)
        {
            logger.error(ex);
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
                logger.error(ex);
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getDelayedComplaintsSLA()
    {
        String theQuery = getQuery("getDelayedComplaintsSLA").trim();
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector<Row> result;
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(theQuery);
            result = command.executeQuery();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getBigDecimal("REMAIN") != null)
                    {
                        wbo.setAttribute("remain", row.getBigDecimal("REMAIN"));
                    }
                    if (row.getString("CLIENT_COMPLAINT_ID") != null)
                    {
                        wbo.setAttribute("clientComplaintID", row.getString("CLIENT_COMPLAINT_ID"));
                    }
                    if (row.getString("COMPLAINT_CREATED_BY") != null)
                    {
                        wbo.setAttribute("createdBy", row.getString("COMPLAINT_CREATED_BY"));
                    }
                    if (row.getString("BUSINESS_ID") != null)
                    {
                        wbo.setAttribute("businessID", row.getString("BUSINESS_ID"));
                    }
                    if (row.getString("BUSINESS_ID_BY_DATE") != null)
                    {
                        wbo.setAttribute("businessIDbyDate", row.getString("BUSINESS_ID_BY_DATE"));
                    }
                    if (row.getString("BUSINESS_COMP_ID") != null)
                    {
                        wbo.setAttribute("businessCompID", row.getString("BUSINESS_COMP_ID"));
                    }
                    if (row.getString("FULL_NAME") != null)
                    {
                        wbo.setAttribute("ownerName", row.getString("FULL_NAME"));
                    }
                    if (row.getString("STATUS_NAME") != null)
                    {
                        wbo.setAttribute("statusName", row.getString("STATUS_NAME"));
                    }
                }
                catch (NoSuchColumnException ex)
                {
                    logger.error(ex);
                }
                catch (UnsupportedConversionException ex)
                {
                    Logger.getLogger(ClientComplaintsSLAMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        catch (SQLException | UnsupportedTypeException ex)
        {
            logger.error(ex);
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
                logger.error(ex);
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getCompletedComplaintsSLA(String userID)
    {
        String theQuery = getQuery("getCompletedComplaintsSLA").trim();
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector<Row> result;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(userID));

        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(theQuery);
            command.setparams(parameters);
            result = command.executeQuery();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getString("BUSINESS_ID") != null)
                    {
                        wbo.setAttribute("businessID", row.getString("BUSINESS_ID"));
                    }
                    if (row.getString("BUSINESS_ID_BY_DATE") != null)
                    {
                        wbo.setAttribute("businessIDbyDate", row.getString("BUSINESS_ID_BY_DATE"));
                    }
                    if (row.getString("BUSINESS_COMP_ID") != null)
                    {
                        wbo.setAttribute("businessCompID", row.getString("BUSINESS_COMP_ID"));
                    }
                    if (row.getString("FULL_NAME") != null)
                    {
                        wbo.setAttribute("ownerName", row.getString("FULL_NAME"));
                    }
                    if (row.getString("STATUS_NAME") != null)
                    {
                        wbo.setAttribute("statusName", row.getString("STATUS_NAME"));
                    }
                    if (row.getString("CURRENT_STATUS") != null)
                    {
                        wbo.setAttribute("statusCode", row.getString("CURRENT_STATUS"));
                    }
                    if (row.getString("END_DATE") != null)
                    {
                        wbo.setAttribute("endDate", row.getString("END_DATE"));
                    }
                    if (row.getString("ISSUE_ID") != null)
                    {
                        wbo.setAttribute("issueID", row.getString("ISSUE_ID"));
                    }
                    if (row.getString("ID") != null)
                    {
                        wbo.setAttribute("clientComplaintID", row.getString("ID"));
                    }
                    if (row.getString("CLIENT_ID") != null)
                    {
                        wbo.setAttribute("clientID", row.getString("CLIENT_ID"));
                    }
                    if (row.getString("CLIENT_NAME") != null)
                    {
                        wbo.setAttribute("clientName", row.getString("CLIENT_NAME"));
                    }
                    if (row.getString("END_DATE") != null)
                    {
                        wbo.setAttribute("endDate", row.getString("END_DATE"));
                    }
                }
                catch (NoSuchColumnException ex)
                {
                    logger.error(ex);
                }
                data.add(wbo);
            }
        }
        catch (SQLException | UnsupportedTypeException ex)
        {
            logger.error(ex);
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
                logger.error(ex);
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getNotCompletedComplaintsGSLA()
    {
        String theQuery = getQuery("getNotCompletedComplaintsGSLA").trim();
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector<Row> result;

        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(theQuery);
            result = command.executeQuery();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getBigDecimal("REMAIN") != null)
                    {
                        wbo.setAttribute("remain", row.getBigDecimal("REMAIN"));
                    }
                    if (row.getString("BUSINESS_ID") != null)
                    {
                        wbo.setAttribute("businessID", row.getString("BUSINESS_ID"));
                    }
                    if (row.getString("BUSINESS_ID_BY_DATE") != null)
                    {
                        wbo.setAttribute("businessIDbyDate", row.getString("BUSINESS_ID_BY_DATE"));
                    }
                    if (row.getString("BUSINESS_COMP_ID") != null)
                    {
                        wbo.setAttribute("businessCompID", row.getString("BUSINESS_COMP_ID"));
                    }
                    if (row.getString("FULL_NAME") != null)
                    {
                        wbo.setAttribute("ownerName", row.getString("FULL_NAME"));
                    }
                    if (row.getString("STATUS_NAME") != null)
                    {
                        wbo.setAttribute("statusName", row.getString("STATUS_NAME"));
                    }
                    if (row.getString("CURRENT_STATUS") != null)
                    {
                        wbo.setAttribute("statusCode", row.getString("CURRENT_STATUS"));
                    }
                    if (row.getString("END_DATE") != null)
                    {
                        wbo.setAttribute("endDate", row.getString("END_DATE"));
                    }
                    if (row.getString("ISSUE_ID") != null)
                    {
                        wbo.setAttribute("issueID", row.getString("ISSUE_ID"));
                    }
                    if (row.getString("ID") != null)
                    {
                        wbo.setAttribute("clientComplaintID", row.getString("ID"));
                    }
                    if (row.getString("CLIENT_ID") != null)
                    {
                        wbo.setAttribute("clientID", row.getString("CLIENT_ID"));
                    }
                    if (row.getString("CLIENT_NAME") != null)
                    {
                        wbo.setAttribute("clientName", row.getString("CLIENT_NAME"));
                    }
                    if (row.getString("END_DATE") != null)
                    {
                        wbo.setAttribute("endDate", row.getString("END_DATE"));
                    }
                }
                catch (NoSuchColumnException ex)
                {
                    logger.error(ex);
                }
                catch (UnsupportedConversionException ex)
                {
                    Logger.getLogger(ClientComplaintsSLAMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                data.add(wbo);
            }
        }
        catch (SQLException | UnsupportedTypeException ex)
        {
            logger.error(ex);
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
                logger.error(ex);
            }
        }
        return data;
    }

    public ArrayList<WebBusinessObject> getCompletedComplaintsGSLA()
    {
        String theQuery = getQuery("getCompletedComplaintsGSLA").trim();
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector<Row> result;

        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(theQuery);
            result = command.executeQuery();
            WebBusinessObject wbo;
            for (Row row : result)
            {
                wbo = fabricateBusObj(row);
                try
                {
                    if (row.getString("BUSINESS_ID") != null)
                    {
                        wbo.setAttribute("businessID", row.getString("BUSINESS_ID"));
                    }
                    if (row.getString("BUSINESS_ID_BY_DATE") != null)
                    {
                        wbo.setAttribute("businessIDbyDate", row.getString("BUSINESS_ID_BY_DATE"));
                    }
                    if (row.getString("BUSINESS_COMP_ID") != null)
                    {
                        wbo.setAttribute("businessCompID", row.getString("BUSINESS_COMP_ID"));
                    }
                    if (row.getString("FULL_NAME") != null)
                    {
                        wbo.setAttribute("ownerName", row.getString("FULL_NAME"));
                    }
                    if (row.getString("STATUS_NAME") != null)
                    {
                        wbo.setAttribute("statusName", row.getString("STATUS_NAME"));
                    }
                    if (row.getString("CURRENT_STATUS") != null)
                    {
                        wbo.setAttribute("statusCode", row.getString("CURRENT_STATUS"));
                    }
                    if (row.getString("END_DATE") != null)
                    {
                        wbo.setAttribute("endDate", row.getString("END_DATE"));
                    }
                    if (row.getString("ISSUE_ID") != null)
                    {
                        wbo.setAttribute("issueID", row.getString("ISSUE_ID"));
                    }
                    if (row.getString("ID") != null)
                    {
                        wbo.setAttribute("clientComplaintID", row.getString("ID"));
                    }
                    if (row.getString("CLIENT_ID") != null)
                    {
                        wbo.setAttribute("clientID", row.getString("CLIENT_ID"));
                    }
                    if (row.getString("CLIENT_NAME") != null)
                    {
                        wbo.setAttribute("clientName", row.getString("CLIENT_NAME"));
                    }
                    if (row.getString("END_DATE") != null)
                    {
                        wbo.setAttribute("endDate", row.getString("END_DATE"));
                    }
                }
                catch (NoSuchColumnException ex)
                {
                    logger.error(ex);
                }
                data.add(wbo);
            }
        }
        catch (SQLException | UnsupportedTypeException ex)
        {
            logger.error(ex);
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
                logger.error(ex);
            }
        }
        return data;
    }
}
