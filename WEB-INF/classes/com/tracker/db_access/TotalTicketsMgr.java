/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tracker.db_access;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.*;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author Waled
 */
public class TotalTicketsMgr extends RDBGateWay{
    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static TotalTicketsMgr totalTicketsMgr = new TotalTicketsMgr();

    public static TotalTicketsMgr getInstance() {
        logger.info("Getting TotalTicketsMgr Instance ....");
        return totalTicketsMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("total_tickets.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public int getUserTotalTicketsCount(String userId) {

        Connection connection = null;
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(userId));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getUserTotalTicketsCount").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }
        if (queryResult.size() > 0) {
            Row r = (Row) queryResult.get(0);
            
            try {
                return r.getBigDecimal("total_tickets").intValue();
            
            } catch (NoSuchColumnException ex) {
                logger.error(ex.getMessage());
            
            } catch (UnsupportedConversionException ex) {
                logger.error(ex.getMessage());
            
            }
        }
        
        return 0;
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

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
         return;
    }
    
}
