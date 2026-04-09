/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.out_ofstore_parts.db_access;


import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.SqlMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.*;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author khaled abdo
 */
public class ItemBalanceMgr extends RDBGateWay {

    private static ItemBalanceMgr itemBalanceMgr = new ItemBalanceMgr();
    //SqlMgr sqlMgr = SqlMgr.getInstance();

    public static ItemBalanceMgr getInstance() {
        logger.info("Getting ItemBalanceMgr Instance ....");
        return itemBalanceMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("item_balance.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public ArrayList getAllAsArrayList() {
        super.cashData();
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }

        return cashedData;

    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("projectName"));
        }

        return cashedData;
    }
    
    public boolean saveItem(HttpServletRequest request) {

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;


        String id = UniqueIDGen.getNextID();
        params.addElement(new StringValue(id));
        params.addElement(new StringValue((String) request.getAttribute("itemId")));
        params.addElement(new IntValue((Integer) request.getAttribute("incrementBalance")));
        params.addElement(new IntValue((Integer) request.getAttribute("currentBalance")));
        params.addElement(new IntValue((Integer) request.getAttribute("preBalance")));
        params.addElement(new FloatValue((Float) request.getAttribute("price")));

        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insert").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();

        }
        return (queryResult > 0);
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }
}
