/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.Erp.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;

import java.util.*;
import java.sql.*;

import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author khaled abdo
 */
public class CostCentersMgr extends RDBGateWay {

    private static CostCentersMgr costCentersMgr = new CostCentersMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static CostCentersMgr getInstance() {
        logger.info("Getting IssueMgr Instance ....");
        return costCentersMgr;
    }

    public CostCentersMgr() {
    }


    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("cost_centers.xml")));
                logger.debug("supportedForm --> " + supportedForm);
            } catch (Exception e) {
                logger.error("Could not locate XML Document from issueMgr");
            }
        }
    }

    public String getCostCenterNameByCode(String code, String lang){

        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> rows = new Vector<Row>();

        String costName = "COSTNAME";
        if(lang.equals("En")){
            costName = "LATIN_NAME";
        }
        String query = getQuery("getCostCenterNameByCode").trim();
        query = query.replaceAll("costName", costName);
        parameters.addElement(new StringValue(code));

        try {
            beginTransaction();
            command.setConnection(transConnection);
            command.setparams(parameters);
            command.setSQLQuery(query);
            
            rows = command.executeQuery();
            endTransaction();
            if(!rows.isEmpty()) {
                return rows.get(0).getString(costName);
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch(UnsupportedTypeException ex) {
            logger.error(ex.getMessage());
        } catch(NoSuchColumnException ex) {
            logger.error(ex.getMessage());
        }  finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
           
            return "***";
    }
    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    return; //    throw new UnsupportedOperationException("Not supported yet.");
    }
}
