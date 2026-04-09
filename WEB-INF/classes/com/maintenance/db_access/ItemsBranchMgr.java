/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.maintenance.db_access;

import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.SqlMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.UnsupportedConversionException;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author Msaudi
 */
public class ItemsBranchMgr extends RDBGateWay {

    private static ItemsBranchMgr itemsBranchMgr = new ItemsBranchMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

//    private static final String insertIssueSQL = "INSERT INTO ISSUE_TYPE VALUES (?,?,now(),?)";
    public static ItemsBranchMgr getInstance() {
        logger.info("Getting ItemsMgr Instance ....");
        return itemsBranchMgr;
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
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("items_branch.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public int getQuantity(String itemForm, String itemCode, String branch) throws SQLException {
        Vector result = new Vector();
        Connection connection = dataSource.getConnection();
        SQLCommandBean forSelect = new SQLCommandBean();
        forSelect.setConnection(connection);
        Vector params = new Vector();

        params.addElement(new StringValue(itemForm));
        params.addElement(new StringValue(itemCode));

        forSelect.setSQLQuery(sqlMgr.getSql("quantityForItem").trim().replace("BB", branch));
        forSelect.setparams(params);
        try {
            result = forSelect.executeQuery();
        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(ItemsBranchMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        connection.close();
        int quantity = 0;
        if (result.size() > 0) {
            Row r = (Row) result.get(0);
            try {
                quantity = r.getBigDecimal("ITEM_QUANNTITY").intValue();
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ItemsBranchMgr.class.getName()).log(Level.SEVERE, null, ex);
            } catch (UnsupportedConversionException ex) {
                Logger.getLogger(ItemsBranchMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return quantity;
    }

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
}
