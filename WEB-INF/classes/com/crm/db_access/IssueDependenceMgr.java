package com.crm.db_access;

import com.silkworm.business_objects.*;
import com.silkworm.persistence.relational.*;
import java.sql.*;
import java.util.*;
import org.apache.log4j.xml.DOMConfigurator;

public class IssueDependenceMgr extends RDBGateWay {

    private static final IssueDependenceMgr issueDependenceMgr = new IssueDependenceMgr();

    public static IssueDependenceMgr getInstance() {
        logger.info("Getting IssueDependenceMgr Instance ....");
        return issueDependenceMgr;
    }

    public IssueDependenceMgr() {
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("issue_dependence.xml")));
                logger.debug("supportedForm --> " + supportedForm);
            } catch (Exception e) {
                logger.error("Could not locate XML Document from issueDependenceMgr");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult;
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) wbo.getAttribute("issueID")));
        params.addElement(new StringValue((String) wbo.getAttribute("dependOnID")));
        params.addElement(new StringValue((String) wbo.getAttribute("createdBy")));
        params.addElement(new StringValue((String) wbo.getAttribute("dependType"))); //option 1
        params.addElement(new StringValue("UL")); //option 2
        params.addElement(new StringValue("UL")); //option 3
        params.addElement(new StringValue("UL")); //option 4
        params.addElement(new StringValue("UL")); //option 5
        params.addElement(new StringValue("UL")); //option 6
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertIssueDependence").trim());
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
    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo;
        Iterator it = cashedTable.iterator();
        while (it.hasNext()) {
            wbo = (WebBusinessObject) it.next();

            cashedData.add(wbo);
        }
        return cashedData;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        return null;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }
}
