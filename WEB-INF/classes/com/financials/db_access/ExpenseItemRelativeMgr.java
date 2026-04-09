/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.financials.db_access;

import com.android.business_objects.LiteBusinessForm;
import com.android.business_objects.LiteWebBusinessObject;
import com.android.db_access.LiteRDBGateWay;
import com.android.persistence.LiteIntValue;
import com.android.persistence.LiteSQLCommandBean;
import com.android.persistence.LiteStringValue;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.SqlMgr;
import com.silkworm.persistence.relational.UniqueIDGen;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author java
 */
public class ExpenseItemRelativeMgr extends LiteRDBGateWay{

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static ExpenseItemRelativeMgr expenseItemRelativeMgr = new ExpenseItemRelativeMgr();

    public ExpenseItemRelativeMgr(){}
    
    public static ExpenseItemRelativeMgr getInstance(){
        System.out.println("Getting ExpenseItemRelativeMgr Instance ....");
        return expenseItemRelativeMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        
        if (supportedForm == null){
            try{
                supportedForm = new LiteBusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("ExpenseItemRelative.xml")));
            } catch (Exception e){
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        ArrayList al = null;
        return al;
    }
    
    @Override
    public boolean saveObject(LiteWebBusinessObject wbo) throws SQLException{
        Vector params = new Vector();
        String query = "";
        if (wbo.getAttribute("factorId") == null){
            params.addElement(new LiteStringValue(UniqueIDGen.getNextID()));
            query = getQuery("insertExpenseItemRelative").trim();
        }
        params.addElement(new LiteStringValue((String) wbo.getAttribute("expenseId")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("bussType")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("bussId")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("acountMood")));
        params.addElement(new LiteIntValue(new Integer((String) wbo.getAttribute("percentage"))));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("clientId")));
        if (wbo.getAttribute("factorId") != null && !wbo.getAttribute("factorId").equals("")){
            params.addElement(new LiteStringValue((String) wbo.getAttribute("factorId")));
            query = getQuery("updateExpenseItemRelative").trim();
        }

        int queryResult = -1;
        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        try{
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query.trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeUpdate();
        } catch (SQLException se){
            System.out.println("Error In executing Query.............!" + se.getMessage());
        } finally {
            endTransaction();
        }
        
        return (queryResult > 0);
    }
}