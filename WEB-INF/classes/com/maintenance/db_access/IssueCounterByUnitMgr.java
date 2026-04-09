package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.persistence.relational.StringValue;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.*;
import org.apache.log4j.xml.DOMConfigurator;

public class IssueCounterByUnitMgr extends RDBGateWay {
    private static IssueCounterByUnitMgr issueCounterByUnitMgr = new IssueCounterByUnitMgr();
    private SqlMgr sqlMgr = SqlMgr.getInstance();

    public static IssueCounterByUnitMgr getInstance() {
        logger.info("Getting issueCounterByUnitMgr Instance ....");
        return issueCounterByUnitMgr;
    }

    private IssueCounterByUnitMgr() { }

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


    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
//        this.printMyQueries();
        return;
        }
}
