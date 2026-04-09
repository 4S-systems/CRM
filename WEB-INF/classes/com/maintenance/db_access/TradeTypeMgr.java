package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import com.silkworm.util.*;
import java.util.*;
import java.text.*;
import java.sql.*;


import com.tracker.common.*;

import com.tracker.business_objects.*;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;
//import org.apache.tools.ant.taskdefs.Sleep;

public class TradeTypeMgr extends RDBGateWay {
    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static TradeTypeMgr toolsMgr = new TradeTypeMgr();
    
    public TradeTypeMgr() {
    }
    
    public static TradeTypeMgr getInstance() {
        logger.info("Getting TradeTypeMgr Instance ....");
        return toolsMgr;
    }
    
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if(supportedForm == null) {
            try {
                supportedForm  = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("trade_type.xml")));
            } catch(Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    
    
    
    
    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        
        for(int i=0; i<cashedTable.size();i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }
        
        return cashedData;
    }
    
    public ArrayList getCashedTableAsArrayList() {
        
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        
        for(int i=0; i<cashedTable.size();i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("id"));
        }
        
        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
    
}
