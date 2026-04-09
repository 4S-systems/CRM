package com.silkworm.common;

import com.maintenance.common.DateParser;
import com.maintenance.db_access.TradeMgr;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.db_access.GrantsMgr;
import java.sql.SQLException;
import com.silkworm.util.DictionaryItem;
import com.tracker.db_access.ProjectMgr;
import java.util.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.sql.Connection;
import com.maintenance.db_access.TradeMgr;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;

public class GenericCountMgr extends RDBGateWay {

    private static GenericCountMgr genericCountMgr = new GenericCountMgr();
    private String[] sys_paths = null;
    private String imageDirPath = null;
    SqlMgr sqlMgr = SqlMgr.getInstance();
    String generatedUserId = null;
    String sessionUserId = null;
    
    TradeMgr tradeMgr = TradeMgr.getInstance();

    @Override
    protected void initSupportedForm() {
        if (supportedForm == null) {
            try {
                System.out.println("UserClientsMgr ..***********.trying to get the XML file from path:: " + webInfPath);
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("generic_count.xml")));
            } catch (Exception e) {
                System.out.println("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public static GenericCountMgr getInstance() {
        System.out.println("Getting UserMgr Instance ....");
        return genericCountMgr;
    }

    public void setSysPaths(String[] sys_paths) {
        this.sys_paths = sys_paths;
        imageDirPath = sys_paths[1];

    }

    private String getUserID() {
        return generatedUserId;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }
}
