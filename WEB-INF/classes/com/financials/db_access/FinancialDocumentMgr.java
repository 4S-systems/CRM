package com.financials.db_access;

import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.FloatValue;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.TimestampValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Vector;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class FinancialDocumentMgr extends RDBGateWay { 
    private static FinancialDocumentMgr FinanceDocMgr = new FinancialDocumentMgr();

    public static FinancialDocumentMgr getInstance() {
        logger.info("Getting FFinancialDocumentMgr Instance ....");
        return FinanceDocMgr;
    }

    public FinancialDocumentMgr() {
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }

        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("FinancialDocument.xml")));
                logger.debug("supportedForm --> " + supportedForm);
            } catch (Exception e) {
                logger.error("Could not locate XML Document from FinancialTransaction");
            }
        }
    }
    
    public String saveFinDocument(WebBusinessObject docWbo, WebBusinessObject persistentUser) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new java.util.Date());

        DateFormat df = new SimpleDateFormat("yyyy/MM/dd");
        java.sql.Timestamp entryTime = null;
        String finDocDate = docWbo.getAttribute("docDate").toString();
        try {
            entryTime = new java.sql.Timestamp(df.parse(finDocDate).getTime());
        } catch (ParseException ex) {
            logger.error(ex);
        }

        Vector parameters = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String docId = UniqueIDGen.getNextID();
        Connection connection = null;
        try {
            // setup Finicial Transaction data
            parameters.addElement(new StringValue(docId));
            parameters.addElement(new StringValue(docWbo.getAttribute("documentTitle").toString()));
            parameters.addElement(new StringValue(docWbo.getAttribute("documentNumber").toString()));
            parameters.addElement(new StringValue(docWbo.getAttribute("DocType").toString()));
            parameters.addElement(new FloatValue(new Float(docWbo.getAttribute("docValue").toString())));
            parameters.addElement(new StringValue(docWbo.getAttribute("source").toString()));
            parameters.addElement(new StringValue(docWbo.getAttribute("destination").toString()));
            parameters.addElement(new TimestampValue(entryTime));
            parameters.addElement(new StringValue((String) persistentUser.getAttribute("userId")));
            parameters.addElement(new StringValue(docWbo.getAttribute("notes") != null ? docWbo.getAttribute("notes").toString() : "UL"));

            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);

            // saving transaction data
            forInsert.setSQLQuery(getQuery("insertFinDoc").trim());
            forInsert.setparams(parameters);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                connection.rollback();
                return null;
            }
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
            try {
                connection.rollback();
            } catch (SQLException ex1) {
                Logger.getLogger("Saving Financial Document Exception = " + ex1);
            }

            return null;
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger("Saving Financial Transaction Exception = " + ex);
            }
        }

        if (queryResult > 0) {
            return "ok";
        } else {
            return "no";
        }
    }
    
    
    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
}
