package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import java.util.*;
import java.sql.*;
import com.tracker.common.*;
import org.apache.log4j.xml.DOMConfigurator;

public class SupplierEquipmentMgr extends RDBGateWay {

    private static SupplierEquipmentMgr equipSupMgr = new SupplierEquipmentMgr();

    public SupplierEquipmentMgr() {
    }

    public static SupplierEquipmentMgr getInstance() {
        logger.info("Getting EquipmentSupplierMgr Instance ....");
        return equipSupMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("supplier_equipment.xml")));
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

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("note"));
        }

        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
