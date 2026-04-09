package com.tracker.db_access;

import com.silkworm.business_objects.*;
import com.silkworm.persistence.relational.*;
import java.sql.*;
import java.util.*;
import org.apache.log4j.xml.DOMConfigurator;

public class IssueProjectMgr extends RDBGateWay {

    private static IssueProjectMgr issueProjectMgr = new IssueProjectMgr();

    public static IssueProjectMgr getInstance() {
        logger.info("Getting IssueProjectMgr Instance ....");
        return issueProjectMgr;
    }

    public IssueProjectMgr() {
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("issue_project.xml")));
                logger.debug("supportedForm --> " + supportedForm);
            } catch (Exception e) {
                logger.error("Could not locate XML Document from issueProjectMgr");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult;
        params.addElement(new StringValue((String) wbo.getAttribute("issueID")));
        params.addElement(new StringValue((String) wbo.getAttribute("projectID")));
        params.addElement(new StringValue(wbo.getAttribute("engineerID") != null ? (String) wbo.getAttribute("engineerID") : "UL")); //option 1
        params.addElement(new StringValue(wbo.getAttribute("option2") != null ? (String) wbo.getAttribute("option2") : "UL")); //option 2
        params.addElement(new StringValue("UL")); //option 3
        params.addElement(new StringValue(null));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertIssueProject").trim());
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
        WebBusinessObject wbo = null;
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
