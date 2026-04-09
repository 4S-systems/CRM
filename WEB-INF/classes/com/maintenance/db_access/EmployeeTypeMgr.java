package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.util.*;

import java.util.*;
import java.text.*;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class EmployeeTypeMgr extends RDBGateWay {

    private static EmployeeTypeMgr employeeTypeMgr = new EmployeeTypeMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public EmployeeTypeMgr() {
    }

    public static EmployeeTypeMgr getInstance() {
        logger.info("Getting employeeTypeMgr Instance ....");
        return employeeTypeMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("employee_type.xml")));
            } catch (Exception e) {
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

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }

        return cashedData;
    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("enTitle"));
        }

        return cashedData;
    }

    public String getDefaultDepartment() {

        WebBusinessObject wbo = new WebBusinessObject();
        Vector empTypeList = new Vector();
        
        cashData();

        if(cashedData.size() > 0) {
            wbo = (WebBusinessObject) cashedTable.get(0);
        }

        try {
            empTypeList = employeeTypeMgr.getOnArbitraryKey("Technical", "key2");
        } catch(Exception ex) {
            logger.error(ex.getMessage());
        }

        if(empTypeList.size() > 0) {
            wbo = (WebBusinessObject) empTypeList.get(0);
        }

        return (String) wbo.getAttribute("id");
    }

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
}
