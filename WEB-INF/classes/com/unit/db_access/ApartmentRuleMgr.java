package com.unit.db_access;

import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Vector;
import org.apache.log4j.xml.DOMConfigurator;

public class ApartmentRuleMgr extends RDBGateWay {

    public static ApartmentRuleMgr apartmentRuleMgr = new ApartmentRuleMgr();

    public static ApartmentRuleMgr getInstance() {
        logger.info("Getting ApartmentRuleMgr Instance ....");
        return apartmentRuleMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("apartment_rule.xml")));
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

    public ArrayList<WebBusinessObject> getApartmentsRules(String[] statusTitles) {

        WebBusinessObject wbo;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            String sql = getQuery("getApartmentsRules").trim();
            String tempSum = ", MAX(Decode(x.apartment_status, 'statusTitle', x.is_checked)) \"statusTitle\"";
            StringBuilder sumColumn = new StringBuilder();
            for (String statusTitle : statusTitles) {
                sumColumn.append(tempSum.replaceAll("statusTitle", statusTitle));
            }
            forQuery.setSQLQuery(sql.replace("status_titles", sumColumn.toString()));
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
                    wbo.setAttribute("departmentID", r.getString("department_id"));
                    for (String statusTitle : statusTitles) {
                        if (r.getString(statusTitle) != null) {
                            wbo.setAttribute(statusTitle, r.getString(statusTitle));
                        }
                    }
                    wbo.setAttribute("departmentName", r.getString("department_name"));
                    resultBusObjs.add(wbo);
                }
            } catch (NoSuchColumnException ce) {
                logger.error(ce);
            }
        }
        return resultBusObjs;
    }
    
    public boolean saveObject(WebBusinessObject apartmentRuleWbo, WebBusinessObject loggedUser) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult;
        String Id = UniqueIDGen.getNextID();
        params.addElement(new StringValue(Id));
        params.addElement(new StringValue((String) apartmentRuleWbo.getAttribute("departmentID")));
        params.addElement(new StringValue((String) apartmentRuleWbo.getAttribute("apartmentStatus")));
        params.addElement(new StringValue("1"));
        params.addElement(new StringValue((String) loggedUser.getAttribute("userId")));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertApartmentRule").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        return (queryResult > 0);
    }
    
    public boolean deleteAllRules() {
        SQLCommandBean forDelete = new SQLCommandBean();
        int queryResult;
        try {
            beginTransaction();
            forDelete.setConnection(transConnection);
            forDelete.setSQLQuery(getQuery("deleteAllRules").trim());
            queryResult = forDelete.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        return (queryResult > 0);
    }
}
