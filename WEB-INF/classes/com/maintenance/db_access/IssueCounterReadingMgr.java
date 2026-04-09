package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.persistence.relational.StringValue;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.*;
import org.apache.log4j.xml.DOMConfigurator;

public class IssueCounterReadingMgr extends RDBGateWay {
    private static IssueCounterReadingMgr issueCounterReadingMgr = new IssueCounterReadingMgr();
    private SqlMgr sqlMgr = SqlMgr.getInstance();

    public static IssueCounterReadingMgr getInstance() {
        logger.info("Getting IssueCounterReadingMgr Instance ....");
        return issueCounterReadingMgr;
    }

    private IssueCounterReadingMgr() { }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("issue_counter_by_unit.xml")));
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
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public boolean mustUpdateCounter(String issueId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector queryResult = null;

        parameters.addElement(new StringValue(issueId));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(sqlMgr.getSql("exsitIssueReading").trim());
            command.setparams(parameters);
            queryResult = command.executeQuery();

            if(queryResult != null && !queryResult.isEmpty()) {
                return false;
            }

        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        return true;
    }


    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
//        this.printMyQueries();
        return;
        }
}
