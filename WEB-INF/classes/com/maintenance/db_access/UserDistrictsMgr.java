package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.SecurityUser;
import com.silkworm.persistence.relational.StringValue;
import java.util.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class UserDistrictsMgr extends RDBGateWay {

    private final static UserDistrictsMgr USER_DISTRICTS_MGR = new UserDistrictsMgr();
    private final SqlMgr sqlMgr = SqlMgr.getInstance();
    SecurityUser securityUser = new SecurityUser();

    public UserDistrictsMgr() {
    }

    public static UserDistrictsMgr getInstance() {
        logger.info("Getting UserDistrictsMgr Instance ....");
        return USER_DISTRICTS_MGR;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("user_district.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean updateUserDistrict(String userID, String projectID, String projectName, String loggedUser) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        Connection connection = null;

        String ID = UniqueIDGen.getNextID();
        
        params.addElement(new StringValue(ID));
        params.addElement(new StringValue(userID));
        params.addElement(new StringValue(projectID));
        params.addElement(new StringValue(projectName));
        params.addElement(new StringValue(loggedUser));

        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertUserDistrict").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            System.out.println("reight insertion");
        } catch (SQLException se) {
            System.out.println(se.getMessage());
            return false;
        }

        return (queryResult > 0);
    }

    @Override
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
    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }
}
