package com.clients.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.persistence.relational.StringValue;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

public class ClientContractsMgr extends RDBGateWay {

    private static final ClientContractsMgr clientContractsMgr = new ClientContractsMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static ClientContractsMgr getInstance() {

        logger.info("Getting ClientContractMgr Instance ....");
        return clientContractsMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("client_contract.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }

        return cashedData;
    }

    
    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }
    
    public Vector selectAllClientsContracts() {
        Vector queryResult = new Vector();
        WebBusinessObject wbo = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery("select distinct SYS_ID, CLIENT_NO, NAME, MOBILE, EMAIL from client_contract");
            queryResult = forInsert.executeQuery();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        Vector resultBusObjs = new Vector();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }
}
