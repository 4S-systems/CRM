/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.tracker.db_access;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.*;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author Waled
 */
public class PreviligesTypeMgr extends RDBGateWay{
    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static PreviligesTypeMgr previligesTypeMgr = new PreviligesTypeMgr();

    public static PreviligesTypeMgr getInstance() {
        logger.info("Getting previligesTypeMgr Instance ....");
        return previligesTypeMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("previliges_type.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    

    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        if (cashedTable != null) {
            for (int i = 0; i < cashedTable.size(); i++) {
                wbo = (WebBusinessObject) cashedTable.elementAt(i);
                cashedData.add((String) wbo.getAttribute("name"));
            }
        }

        return cashedData;
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

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
         return;
    }
    
}
