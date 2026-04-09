package com.general_industrial.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.persistence.relational.StringValue;
import java.sql.*;
import java.util.ArrayList;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

public class ManufactoryMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static ManufactoryMgr manufactoryMgr = new ManufactoryMgr();

    public ManufactoryMgr() {
    }

    public static ManufactoryMgr getInstance() {
        logger.info("Getting ExternalJobMgr Instance ....");
        return manufactoryMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("ManufactoryMgr.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        Vector params = new Vector();
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) wbo.getAttribute("Ar_Name")));
        params.addElement(new StringValue((String) wbo.getAttribute("EN_Name")));
        params.addElement(new StringValue((String) wbo.getAttribute("Country")));
        params.addElement(new StringValue((String) wbo.getAttribute("ABBREVIATION_NAME")));
        params.addElement(new StringValue((String) wbo.getAttribute("REMARKS")));
        Connection connection = dataSource.getConnection();
        SQLCommandBean forInsert = new SQLCommandBean();
        forInsert.setConnection(connection);
        forInsert.setSQLQuery(sqlMgr.getSql("insertManufactoryMgr"));
        forInsert.setparams(params);
        return forInsert.executeUpdate() > 0;


    }

    public boolean updateManufactoryMgr(WebBusinessObject request) {


        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        Vector params = new Vector();
        params.addElement(new StringValue((String) request.getAttribute("Ar_Name")));
        params.addElement(new StringValue((String) request.getAttribute("EN_Name")));
        params.addElement(new StringValue((String) request.getAttribute("Country")));
        params.addElement(new StringValue((String) request.getAttribute("ABBREVIATION_NAME")));
        params.addElement(new StringValue((String) request.getAttribute("REMARKS")));
        params.addElement(new StringValue((String) request.getAttribute("ID")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateManufactoryMgr").trim());
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

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
}
