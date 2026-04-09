package com.clients.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.sql.Connection;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.List;
import java.util.Vector;
import org.apache.log4j.xml.DOMConfigurator;

public class SLANotificationMgr extends RDBGateWay
{

    private static final SLANotificationMgr APPOINTMENT_NOTIFICATION_MGR = new SLANotificationMgr();

    public static SLANotificationMgr getInstance()
    {
        logger.info("Getting SLANotificationMgr Instance ....");
        return APPOINTMENT_NOTIFICATION_MGR;
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
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("sla_notification.xml")));
            }
            catch (Exception e)
            {
                logger.error("Could not locate XML Document, " + e);
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException
    {
        return false;
    }

    @Override
    public ArrayList getCashedTableAsArrayList()
    {
        cashedData = new ArrayList();
        WebBusinessObject wbo;

        for (int i = 0; i < cashedTable.size(); i++)
        {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("projectName"));
        }

        return cashedData;
    }

    @Override
    protected void initSupportedQueries()
    {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    public List<WebBusinessObject> getSLANotification(String userId, int remaining)
    {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = new Vector();
        List<WebBusinessObject> data;

        parameters.addElement(new StringValue(userId));
        parameters.addElement(new IntValue(remaining));

        try
        {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getSLANotification"));
            command.setparams(parameters);
            result = command.executeQuery();

            data = new ArrayList<>();
            for (Row row : result)
            {
                data.add(fabricateBusObj(row));
            }

            return data;
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

        return new ArrayList<>();
    }
}
