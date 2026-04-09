package com.silkworm.common;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.persistence.relational.StringValue;
import java.util.*;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class ExtDbConnectionMgr extends RDBGateWay {

    private static ExtDbConnectionMgr extDbConnectionMgr = new ExtDbConnectionMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public ExtDbConnectionMgr() {
    }

    public static ExtDbConnectionMgr getInstance() {
        logger.info("Getting extDbConnectionMgr Instance ....");
        return extDbConnectionMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("ext_db_connection.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String)wbo.getAttribute("host")));
        params.addElement(new StringValue((String)wbo.getAttribute("service")));
        params.addElement(new StringValue((String)wbo.getAttribute("user")));
        params.addElement(new StringValue((String)wbo.getAttribute("password")));
        params.addElement(new StringValue((String)wbo.getAttribute("dbType")));
        Connection connection = null;
        try {
            beginTransaction();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("setExtDB").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            
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

    public ArrayList getCashedTableAsBusObjects() {
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
            cashedData.add((String) wbo.getAttribute("id"));
        }

        return cashedData;
    }

  

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }

}
