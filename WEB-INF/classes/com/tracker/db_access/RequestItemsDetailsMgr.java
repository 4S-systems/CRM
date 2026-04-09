package com.tracker.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class RequestItemsDetailsMgr extends RDBGateWay
{

    private static final RequestItemsDetailsMgr REQUEST_ITEMS_DETAILS_MGR = new RequestItemsDetailsMgr();

    public static RequestItemsDetailsMgr getInstance()
    {
        logger.info("Getting RequestItemsDetailsMgr Instance ....");
        return REQUEST_ITEMS_DETAILS_MGR;
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
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("request_items_details.xml")));
            }
            catch (Exception e)
            {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException
    {
        return false;
    }

    @Override
    protected void initSupportedQueries()
    {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList()
    {
        cashedData = new ArrayList();
        for (Object object : cashedTable)
        {
            cashedData.add(object);
        }
        return cashedData;
    }

    public List<WebBusinessObject> getByIssueId(String issueId)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result;
        List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();

        parameters.addElement(new StringValue(issueId));

        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getByIssueId"));
            command.setparams(parameters);
            result = command.executeQuery();

            for (Row row : result)
            {
                data.add(fabricateBusObj(row));
            }
        }
        catch (SQLException se)
        {
            logger.error(se.getMessage());
        }
        catch (UnsupportedTypeException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        finally
        {
            try
            {
                connection.close();
            }
            catch (SQLException ex)
            {
                logger.error("Close Error, " + ex);
            }
        }

        return data;
    }
    public List<WebBusinessObject> getRequistItemsByIssueId(String issueId)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result;
        List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();

        parameters.addElement(new StringValue(issueId));

        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery("SELECT * FROM REQUEST_ITEMS WHERE ISSUE_ID = ?");
            command.setparams(parameters);
            result = command.executeQuery();

            for (Row row : result)
            {
                data.add(fabricateBusObj(row));
            }
        }
        catch (SQLException se)
        {
            logger.error(se.getMessage());
        }
        catch (UnsupportedTypeException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        finally
        {
            try
            {
                connection.close();
            }
            catch (SQLException ex)
            {
                logger.error("Close Error, " + ex);
            }
        }

        return data;
    }

    public void updateIssueWorkItems(String id,String value,String valid,String comment,int sqlTybe)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            switch(sqlTybe)
            {
                case 1:
                {
                    command.setSQLQuery("UPDATE REQUEST_ITEMS set QUANTITY='"+value+"' , VALID='"+valid+"',NOTE='"+comment+"' WHERE ID='"+id+"'");
                }
                case 2:
                {
                    command.setSQLQuery("UPDATE REQUEST_ITEMS set OPTION1='"+value+"' , VALID='"+valid+"',NOTE='"+comment+"' WHERE ID='"+id+"'");
                }
            }
            command.executeQuery();
        }
        catch (SQLException se)
        {
            logger.error(se.getMessage());
        }
        catch (UnsupportedTypeException ex)
        {
            logger.error("SQL Exception  " + ex.getMessage());
        }
        finally
        {
            try
            {
                connection.close();
            }
            catch (SQLException ex)
            {
                logger.error("Close Error, " + ex);
            }
        }
    }
    
    public boolean updateRequestItems(Object[] id, Object[] quantity, Object[] price, Object[] discount, Object[] total) {
        Connection connection = null;
        try {
            int queryResult = 0;
            Vector params;
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("updateRequestItems").trim());
            for (int i = 0; i < id.length; i++) {
                params = new Vector();
                params.addElement(new StringValue((String) quantity[i]));
                params.addElement(new StringValue((String) price[i])); // OPTION4
                params.addElement(new StringValue((String) discount[i])); // OPTION5
                params.addElement(new StringValue((String) total[i])); // OPTION6
                params.addElement(new StringValue((String) id[i]));
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
            }
            return queryResult > 0;
        } catch (SQLException ex) {
            logger.error(ex);
            return false;
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException ex) {
                    Logger.getLogger(RequestItemsDetailsMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
    }
}