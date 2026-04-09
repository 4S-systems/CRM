package com.maintenance.common;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.util.*;

import java.util.*;
import java.text.*;
import java.sql.*;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class ClosureConfigMgr extends RDBGateWay {
    
    private static ClosureConfigMgr closureConfigMgr = new ClosureConfigMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    
    public static ClosureConfigMgr getInstance() {
        logger.info("Getting ClosureConfigMgr Instance ....");
        return closureConfigMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("closure_config.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public ArrayList getClosuresByUser(String userId) throws Exception {
        Vector parameters = new Vector();
        Vector queryResult = null;
        WebBusinessObject wbo;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();

        parameters.addElement(new StringValue(userId));

        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery("select CLOSURE_CONFIG.* from USER_CLOSURE_CONFIG, CLOSURE_CONFIG where USER_CLOSURE_CONFIG.CLOSURE_ID = CLOSURE_CONFIG.ID And user_id = ?");
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error(uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        ArrayList resultBusObjs = new ArrayList();
        
        Row row;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            wbo = fabricateBusObj(row);
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public ArrayList getCashedTableAsArrayList() {
        return null;
    }
    
    @Override
    protected void initSupportedQueries() {
        return; //throw new UnsupportedOperationException("Not supported yet.");
    }
}
