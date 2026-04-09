package com.silkworm.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import java.util.*;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class GrantUserMgr extends RDBGateWay {

    private static GrantUserMgr grantUserMgr = new GrantUserMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public GrantUserMgr() {
    }

    public static GrantUserMgr getInstance() {
        logger.info("Getting GrantUserMgr Instance ....");
        return grantUserMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("grantUser.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public ArrayList getCashedTableAsArrayList() {
        return null;
    }

    public ArrayList getCashedTableAsBusObjects() {
        return null;
    }

    @Override
    protected void initSupportedQueries() {
      return;//  throw new UnsupportedOperationException("Not supported yet.");
    }
}
