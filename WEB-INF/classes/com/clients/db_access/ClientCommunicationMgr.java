package com.clients.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.DateValue;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;
import org.apache.log4j.xml.DOMConfigurator;

public class ClientCommunicationMgr extends RDBGateWay {

    public static ClientCommunicationMgr clientCommunicationMgr = new ClientCommunicationMgr();

    public static ClientCommunicationMgr getInstance() {
        logger.info("Getting clientCommunicationMgr Instance ....");
        return clientCommunicationMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("client_communication.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject clientCommunicationWbo, WebBusinessObject loggedUser) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult;
        String Id = UniqueIDGen.getNextID();
        params.addElement(new StringValue(Id));
        params.addElement(new StringValue((String) clientCommunicationWbo.getAttribute("clientId")));
        params.addElement(new StringValue((String) clientCommunicationWbo.getAttribute("communicationValue")));
        params.addElement(new StringValue((String) clientCommunicationWbo.getAttribute("communicationType")));
        params.addElement(new StringValue((String) loggedUser.getAttribute("userId")));
        params.addElement(new StringValue((String) clientCommunicationWbo.getAttribute("option1")));
        params.addElement(new StringValue(""));
        params.addElement(new StringValue(""));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertCommunication").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        return (queryResult > 0);
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
}
