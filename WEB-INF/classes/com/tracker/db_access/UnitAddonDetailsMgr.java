package com.tracker.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.persistence.relational.StringValue;
import java.sql.SQLException;
import java.util.*;
import java.util.ArrayList;
import org.apache.log4j.xml.DOMConfigurator;

public class UnitAddonDetailsMgr extends RDBGateWay {

    private static final UnitAddonDetailsMgr unitAddonDetailsMgr = new UnitAddonDetailsMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    ProjectAccountingMgr projectAccMgr = ProjectAccountingMgr.getInstance();

    public static UnitAddonDetailsMgr getInstance() {
        logger.info("Getting UnitAddonDetailsMgr Instance ....");
        return unitAddonDetailsMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("unit_addon_details.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) wbo.getAttribute("unitID")));
        params.addElement(new StringValue((String) wbo.getAttribute("type")));
        params.addElement(new StringValue((String) wbo.getAttribute("area")));
        params.addElement(new StringValue((String) wbo.getAttribute("price")));
        params.addElement(new StringValue((String) wbo.getAttribute("meterPrice")));
        params.addElement(new StringValue((String) wbo.getAttribute("optionOne")));
        params.addElement(new StringValue((String) wbo.getAttribute("optionTwo")));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertUnitAddonDetails").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();
        }
        return (queryResult > 0);
    }

    @Override
    public ArrayList getCashedTableAsBusObjects() {
        return new ArrayList(cashedTable);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        return new ArrayList(cashedTable);
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

}
