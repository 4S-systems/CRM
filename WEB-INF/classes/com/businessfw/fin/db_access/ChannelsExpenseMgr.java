package com.businessfw.fin.db_access;

import com.android.business_objects.LiteBusinessForm;
import com.android.business_objects.LiteWebBusinessObject;
import com.android.db_access.LiteRDBGateWay;
import com.android.exceptions.LiteNoSuchColumnException;
import com.android.exceptions.LiteUnsupportedTypeException;
import com.android.persistence.LiteDateValue;
import com.android.persistence.LiteDoubleValue;
import com.android.persistence.LiteRow;
import com.android.persistence.LiteSQLCommandBean;
import com.android.persistence.LiteStringValue;
import com.android.persistence.LiteUniqueIDGen;
import com.silkworm.business_objects.DOMFabricatorBean;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class ChannelsExpenseMgr extends LiteRDBGateWay {

    private static final ChannelsExpenseMgr channelsExpenseMgr = new ChannelsExpenseMgr();

    public ChannelsExpenseMgr() {
    }

    public static ChannelsExpenseMgr getInstance() {
        logger.info("Getting ChannelsExpenseMgr Instance ....");
        return channelsExpenseMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new LiteBusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("channels_expense.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(LiteWebBusinessObject wbo) throws SQLException {
        Vector params = new Vector();
        LiteSQLCommandBean forInsert = new LiteSQLCommandBean();
        int queryResult;
        params.addElement(new LiteStringValue(LiteUniqueIDGen.getNextID()));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("channelID")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("companyID")));
         params.addElement(new LiteStringValue((String) wbo.getAttribute("expenseDate")));
     //   params.addElement("SYSDATE");
        params.addElement(new LiteDoubleValue((Double) wbo.getAttribute("amount")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("currencyType")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("createdBy")));
        params.addElement(new LiteStringValue((String) wbo.getAttribute("option1"))); //option 1
        params.addElement(new LiteStringValue((String) wbo.getAttribute("option2"))); //option 2
        params.addElement(new LiteStringValue((String) wbo.getAttribute("option3"))); //option 3  will differ campaign vs channel
        params.addElement(new LiteStringValue((String) wbo.getAttribute("option4"))); //option 4
        params.addElement(new LiteStringValue((String) wbo.getAttribute("option5"))); //option 5
        params.addElement(new LiteStringValue((String) wbo.getAttribute("option6"))); //option 6
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
         //   forInsert.setSQLQuery("INSERT INTO CHANNELS_EXPENSE (ID,CHANNEL_ID,COMPANY_ID,EXPENSE_DATE,AMOUNT,CURRENCY_TYPE,CREATED_BY,CREATION_TIME,OPTION1,OPTION2,OPTION3,OPTION4,OPTION5,OPTION6) VALUES (?,?,?,TO_DATE(?, 'YYYY-MM-DD'),?,?,?,SYSDATE,?,?,?,?,?,?)");
           forInsert.setSQLQuery(getQuery("insertChannelsExpense_new"));
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        return (queryResult > 0);
    }

    public ArrayList<LiteWebBusinessObject> getChannelExpenses(String channelID) {
        Vector result = null;
        LiteWebBusinessObject wbo = null;
        Vector params = new Vector();
        params.addElement(new LiteStringValue(channelID));
        LiteSQLCommandBean sqlForSelect = new LiteSQLCommandBean();
        Connection connection = null;
        try {
            result = new Vector();
            connection = dataSource.getConnection();
            sqlForSelect.setSQLQuery(getQuery("getChannelExpenses"));
            sqlForSelect.setConnection(connection);
            sqlForSelect.setparams(params);
            result = sqlForSelect.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return null;
        } catch (LiteUnsupportedTypeException ex) {
            logger.error("General Schedule Relations Saving Exception " + ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return null;
            }
        }
        ArrayList<LiteWebBusinessObject> resultBusObjs = new ArrayList<>();
        LiteRow r = null;
        Enumeration e = result.elements();
        while (e.hasMoreElements()) {
            r = (LiteRow) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("COMPANY_NAME") != null) {
                    wbo.setAttribute("companyName", r.getString("COMPANY_NAME"));
                }
            } catch (LiteNoSuchColumnException ex) {
                Logger.getLogger(ChannelsExpenseMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        cashData();
        return new ArrayList(cashedTable);
    }
}
