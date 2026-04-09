package com.tracker.db_access;

import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.TimestampValue;
import com.silkworm.persistence.relational.UnsupportedConversionException;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class IncentiveMgr extends RDBGateWay {

    public static IncentiveMgr incentiveMgr = new IncentiveMgr();

    public static IncentiveMgr getInstance() {
        logger.info("Getting incentiveMgr Instance ....");
        return incentiveMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("incentive.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }
    
    public ArrayList<WebBusinessObject> getClientIncentives(String[] incentiveTitles, String startDate, String endDate) {

        WebBusinessObject wbo;
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            String sql = getQuery("getClinetIncentives").trim();
            StringBuilder where = new StringBuilder();
            if (startDate != null && !startDate.isEmpty()) {
                where.append("where INCENTIVE_DATE >= ?");
                params.addElement(new TimestampValue(java.sql.Timestamp.valueOf(startDate + " 00:00:01")));
            }
            if (endDate != null && !endDate.isEmpty()) {
                if(where.toString().isEmpty()) {
                    where.append("where ");
                } else {
                    where.append(" and ");
                }
                where.append("INCENTIVE_DATE <= ?");
                params.addElement(new TimestampValue(java.sql.Timestamp.valueOf(endDate + " 23:59:59")));
            }
            String tempSum = ", SUM(Decode(x.incentive_title, 'incentiveTitle', x.total)) \"incentiveTitle\"";
            StringBuilder sumColumn = new StringBuilder();
            for(String incentiveTitle : incentiveTitles) {
                sumColumn.append(tempSum.replaceAll("incentiveTitle", incentiveTitle));
            }
            forQuery.setSQLQuery(sql.replace("sum_of_incentive_title", sumColumn.toString())
                    .replace("where_between_date", where.toString()));
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();

        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());

        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());

        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();

        Row r = null;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();

            try {
                while (e.hasMoreElements()) {
                    r = (Row) e.nextElement();
                    wbo = new WebBusinessObject();
                    if (r.getString("client_id") != null) {
                        wbo.setAttribute("clientId", r.getString("client_id"));
                    }
                    for (String incentiveTitle : incentiveTitles) {
                        if(r.getBigDecimal(incentiveTitle) != null) {
                            wbo.setAttribute(incentiveTitle, r.getBigDecimal(incentiveTitle));
                        }
                    }
                    if (r.getString("name") != null) {
                        wbo.setAttribute("clientName", r.getString("name"));
                    }
                    resultBusObjs.add(wbo);
                }

            } catch (NoSuchColumnException ce) {
                logger.error(ce);
            } catch (UnsupportedConversionException ex) {
                Logger.getLogger(IncentiveMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return resultBusObjs;
    }
}
