/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.silkworm.logger.db_access;

import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.RDBGateWay;
import java.sql.SQLException;
import java.util.ArrayList;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author MSaudi
 */
public class EventTypeMgr extends RDBGateWay {

    private static EventTypeMgr eventTyeMgr = new EventTypeMgr();

    public static EventTypeMgr getInstance() {
        return eventTyeMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("event_type.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        return new ArrayList(getCashedTable());
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
