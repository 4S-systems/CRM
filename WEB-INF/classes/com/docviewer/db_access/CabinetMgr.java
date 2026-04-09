/*
 * CabinetMgr.java
 *
 * Created on March 30, 2005, 1:27 AM
 */
package com.docviewer.db_access;

/**
 *
 * @author Walid
 */
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.util.*;
import java.sql.*;
import java.io.*;
import org.apache.log4j.xml.DOMConfigurator;

public class CabinetMgr extends RDBGateWay {

    private static CabinetMgr cbntMgr = new CabinetMgr();
    private static final String insertCbntSQL = "INSERT INTO CABINET VALUES(?,?,?,?,?,?,now())";
    private ImageMgr imageMgr = ImageMgr.getInstance();

    public static CabinetMgr getInstance() {
        logger.info("Getting CabinetMgr Instance ....");
        return cbntMgr;


    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("cabinet.xml")));
            } catch (Exception e) {
                logger.error("CabinetMgr :: Could not locate XML Document");
            }
        }


    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("cabinetName"));
        }

        return cashedData;
    }

    public ArrayList getCashedTableAsBusObjects() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            wbo.setObjectKey((String) wbo.getAttribute("cabinetName"));
            cashedData.add(wbo);
        }

        return cashedData;
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public void cashData() {
        try {
            cashedTable = imageMgr.getListByFileType("FilterOnType", "cbnt");

        } catch (Exception e) {
            logger.error(e.getMessage());
        }
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
