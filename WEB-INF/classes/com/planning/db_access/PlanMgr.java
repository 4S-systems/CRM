package com.planning.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import org.apache.log4j.xml.DOMConfigurator;

public class PlanMgr extends RDBGateWay {

    private static PlanMgr planMgr = new PlanMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static PlanMgr getInstance() {
        logger.info("Getting PlanMgr Instance ....");
        return planMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("plan.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(WebBusinessObject plan, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Connection connection = null;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) plan.getAttribute("planCode")));
        params.addElement(new StringValue((String) plan.getAttribute("planName")));
        params.addElement(new StringValue((String) plan.getAttribute("planDesc")));
        params.addElement(new StringValue((String) plan.getAttribute("planType")));
        params.addElement(new DateValue((java.sql.Date) plan.getAttribute("beginDate")));
        params.addElement(new DateValue((java.sql.Date) plan.getAttribute("endDate")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insertPlan").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            cashData();
            
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
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
            cashedData.add((String) wbo.getAttribute("planName"));
        }

        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return; //   throw new UnsupportedOperationException("Not supported yet.");
    }

}
