package com.maintenance.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.jsptags.DropdownDate;

import java.util.*;
import java.sql.*;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

public class EqChangesMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static EqChangesMgr eqChangesMgr = new EqChangesMgr();

    public EqChangesMgr() {
    }

    public static EqChangesMgr getInstance() {
        logger.info("Getting EqChangesMgr Instance ....");
        return eqChangesMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("eqChanges.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(HttpServletRequest request, String equipmentID) throws SQLException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        DropdownDate dropdownDate = new DropdownDate();
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertEqChangesSql").trim());
            params = new Vector();
            params.addElement(new StringValue(UniqueIDGen.getNextID()));
            params.addElement(new StringValue(equipmentID));
            params.addElement(new StringValue(request.getParameter("change")));
            
            DateParser dateParser=new DateParser();
            java.sql.Date sqlDate=dateParser.formatSqlDate(request.getParameter("changeDate"));
            java.sql.Timestamp date=new java.sql.Timestamp(sqlDate.getTime());
            
            params.addElement(new TimestampValue(date));
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            try {
                Thread.sleep(200);
            } catch (InterruptedException ex) {
                logger.error(ex.getMessage());
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public boolean updateObject(WebBusinessObject wbo) {

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) wbo.getAttribute("codeTask")));
        params.addElement(new StringValue((String) wbo.getAttribute("descEn")));
        params.addElement(new StringValue((String) wbo.getAttribute("descAr")));
        params.addElement(new StringValue((String) wbo.getAttribute("taskID")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateIssueTasksSQL").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

            cashData();
        } catch (SQLException se) {

            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("maintenanceTitle"));
        }

        return cashedData;
    }

    public ArrayList getCashedTableAsBusObjects() {
        return null;
    }

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
}
