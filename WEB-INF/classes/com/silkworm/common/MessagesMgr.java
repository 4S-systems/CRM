package com.silkworm.common;

import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.TimestampValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class MessagesMgr extends RDBGateWay {

    public static MessagesMgr messagesMgr = new MessagesMgr();

    public static MessagesMgr getInstance() {
        logger.info("Getting MessagesMgr Instance ....");
        return messagesMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("messages.xml")));
                System.out.println("reading Successfully xml files....!");
            } catch (Exception e) {
                System.out.println("Error in reading xml files....!");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
        String Id = UniqueIDGen.getNextID();
        wbo.setAttribute("id", Id);
        params.addElement(new StringValue(Id));
        params.addElement(new StringValue((String) wbo.getAttribute("message")));
        try {
            params.addElement(new TimestampValue(new Timestamp(sdf.parse((String) wbo.getAttribute("onDate")).getTime())));
        } catch (ParseException ex) {
            params.addElement(new TimestampValue(new Timestamp(new java.util.Date().getTime())));
        }
        params.addElement(new StringValue((String) wbo.getAttribute("frequency")));
        params.addElement(new StringValue((String) wbo.getAttribute("status")));
        params.addElement(new StringValue((String) wbo.getAttribute("period")));
        params.addElement(new StringValue((String) wbo.getAttribute("option1")));
        params.addElement(new StringValue((String) wbo.getAttribute("option2")));
        params.addElement(new StringValue((String) wbo.getAttribute("option3")));
        params.addElement(new StringValue((String) wbo.getAttribute("option4")));
        params.addElement(new StringValue((String) wbo.getAttribute("option5")));
        params.addElement(new StringValue((String) wbo.getAttribute("option6")));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertMessage").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            rollbackTransaction();
            return false;
        }
        return (queryResult > 0);
    }

    public boolean updateObject(WebBusinessObject wbo) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
        params.addElement(new StringValue((String) wbo.getAttribute("message")));
        try {
            params.addElement(new TimestampValue(new Timestamp(sdf.parse((String) wbo.getAttribute("onDate")).getTime())));
        } catch (ParseException ex) {
            params.addElement(new TimestampValue(new Timestamp(new java.util.Date().getTime())));
        }
        params.addElement(new StringValue((String) wbo.getAttribute("frequency")));
        params.addElement(new StringValue((String) wbo.getAttribute("status")));
        params.addElement(new StringValue((String) wbo.getAttribute("period")));
        params.addElement(new StringValue((String) wbo.getAttribute("option1")));
        params.addElement(new StringValue((String) wbo.getAttribute("option2")));
        params.addElement(new StringValue((String) wbo.getAttribute("option3")));
        params.addElement(new StringValue((String) wbo.getAttribute("option4")));
        params.addElement(new StringValue((String) wbo.getAttribute("option5")));
        params.addElement(new StringValue((String) wbo.getAttribute("option6")));
        params.addElement(new StringValue((String) wbo.getAttribute("id")));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("updateMessage").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            rollbackTransaction();
            return false;
        }
        return (queryResult > 0);
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        return new ArrayList(getCashedTable());
    }

    public ArrayList<WebBusinessObject> getAllActiveMessages() {
        Connection connection = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getAllActiveMessages").trim());
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        Row r;
        Enumeration e = queryResult.elements();
        WebBusinessObject wbo;
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("UPTO_DATE") != null) {
                    wbo.setAttribute("uptoDate", r.getString("UPTO_DATE"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(MessagesMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }
}
