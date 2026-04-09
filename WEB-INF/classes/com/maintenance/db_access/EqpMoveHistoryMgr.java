/*
 * EqpMoveHistoryMgr.java
 *
 * Created on March 15, 2011, 11:15 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package com.maintenance.db_access;

import com.contractor.db_access.MaintainableMgr;
import com.maintenance.common.Tools;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.persistence.relational.StringValue;
import java.util.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class EqpMoveHistoryMgr extends RDBGateWay {

    private static EqpMoveHistoryMgr eqpMoveHistoryMgr = new EqpMoveHistoryMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public EqpMoveHistoryMgr() {
    }

    public static EqpMoveHistoryMgr getInstance() {
        logger.info("Getting EqpMoveHistoryMgr Instance ....");
        return eqpMoveHistoryMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("eqp_move_history.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        Connection connection = null;
        int result = -1000;
        Vector oldHistory = new Vector();
        Vector newHistoryParams = new Vector();
        Vector updateLocationParams = new Vector();
        Vector updateOldHistoryParams = new Vector();
        try {
            oldHistory = getOnArbitraryKeyOrdered(wbo.getAttribute("equipmentID").toString(), "key1", "order");
        } catch (Exception ex) {
            Logger.getLogger(EqpMoveHistoryMgr.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (oldHistory.size() > 0) {
            WebBusinessObject temp = new WebBusinessObject();
            temp = (WebBusinessObject) oldHistory.get(0);
            updateOldHistoryParams.add(new DateValue(Tools.getSqlDate(wbo.getAttribute("beginDate").toString())));
            updateOldHistoryParams.add(new StringValue(temp.getAttribute("id").toString()));
        }


        newHistoryParams.add(new StringValue(UniqueIDGen.getNextID()));
        newHistoryParams.add(new StringValue(wbo.getAttribute("equipmentID").toString()));
        newHistoryParams.add(new DateValue(Tools.getSqlDate(wbo.getAttribute("beginDate").toString())));
        newHistoryParams.add(new StringValue(wbo.getAttribute("reason").toString()));
        newHistoryParams.add(new StringValue(wbo.getAttribute("location").toString()));

        updateLocationParams.add(new StringValue(wbo.getAttribute("location").toString()));
        updateLocationParams.add(new StringValue(wbo.getAttribute("equipmentID").toString()));

        SQLCommandBean forInsert = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);

            if (oldHistory.size() > 0) {
                forInsert.setSQLQuery(sqlMgr.getSql("updateHistoryEndDate").trim());
                forInsert.setparams(updateOldHistoryParams);
                result = forInsert.executeUpdate();
            }

            forInsert.setSQLQuery(sqlMgr.getSql("insertMove").trim());
            forInsert.setparams(newHistoryParams);
            result = forInsert.executeUpdate();

            forInsert.setSQLQuery(sqlMgr.getSql("updateEQPLocation").trim());
            forInsert.setparams(updateLocationParams);
            result = forInsert.executeUpdate();

            connection.commit();
        } catch (Exception ex) {
            connection.rollback();
            Logger.getLogger(EqpMoveHistoryMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            connection.close();
        }
        return (result > 0);
    }
    
    public Vector getMovementHistoryForModelChildren(String parentId) {
        Connection connection = null;
        
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        Vector reultBusObjs = new Vector();
        
        SQLCommandBean forQuery = new SQLCommandBean();
        WebBusinessObject tempWbo = null;
        Row row = null;
        Enumeration e = null;
        
        SQLparams.addElement(new StringValue(parentId));
        
        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getMovementHistoryForModelChildren").trim());
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
        
        e = queryResult.elements();
        
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            
            try {
                tempWbo = new WebBusinessObject();
                
                tempWbo.setAttribute("movementHistoryId", row.getString("id"));
                tempWbo.setAttribute("equipId", row.getString("eqp_id"));
                tempWbo.setAttribute("equipName", row.getString("unit_name"));
                tempWbo.setAttribute("siteId", row.getString("location_id"));
                tempWbo.setAttribute("siteName", row.getString("project_name"));
                tempWbo.setAttribute("beginDate", row.getDate("begin_date"));
                
                if(row.getString("reason") != null) {
                    tempWbo.setAttribute("reason", row.getString("reason"));
                    
                } else {
                    tempWbo.setAttribute("reason", "");
                    
                }
                                
                reultBusObjs.addElement(tempWbo);
                
            } catch (UnsupportedConversionException ex) {
                Logger.getLogger(EqpMoveHistoryMgr.class.getName()).log(Level.SEVERE, null, ex);
            } catch (NoSuchColumnException ex) {
                logger.error(ex.getMessage());
            }
        }

        return reultBusObjs;

    }

    public ArrayList getCashedTableAsArrayList() {
        return null;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
    
}
