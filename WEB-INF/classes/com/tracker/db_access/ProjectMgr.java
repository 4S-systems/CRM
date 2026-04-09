package com.tracker.db_access;

import com.clients.db_access.ClientComplaintsMgr;
import com.crm.common.CRMConstants;
import com.maintenance.common.Tools;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.common.UserMgr;
import com.silkworm.persistence.relational.StringValue;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*; 
import com.tracker.common.*;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

public class ProjectMgr extends RDBGateWay {

    private static ProjectMgr projectMgr = new ProjectMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    ProjectAccountingMgr projectAccMgr = ProjectAccountingMgr.getInstance();

    public static ProjectMgr getInstance() {
        logger.info("Getting ProjectMgr Instance ....");
        return projectMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("project.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
  public boolean saveTransType(WebBusinessObject project, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String unitId = UniqueIDGen.getNextID();
        params.addElement(new StringValue(unitId));
        params.addElement(new StringValue((String) project.getAttribute("name")));
        params.addElement(new StringValue((String) project.getAttribute("code")));
        params.addElement(new StringValue((String) project.getAttribute("name")));
        
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertTransMovType").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            //
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();
        }

        return true;
    }
  
    public boolean saveObject(WebBusinessObject project, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String unitId = UniqueIDGen.getNextID();
        params.addElement(new StringValue(unitId));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.PROJECT_NAME)));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.EQ_NO)));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.PROJECT_DESC)));

        String mainProjectId = null;
        try {
            mainProjectId = project.getAttribute("mainProjectId").toString();
        } catch (NullPointerException e) {
            mainProjectId = "0";
        }
        
        params.addElement(new StringValue(mainProjectId));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.LOCATION_TYPE)));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.FUTILE)));
//        params.addElement(new StringValue(project.getAttribute("coordinate").toString()));
        params.addElement(new StringValue("UL"));
        if (project.getAttribute("optionOne") != null) {
            params.addElement(new StringValue((String) project.getAttribute("optionOne")));
        } else {
            params.addElement(new StringValue("UL"));
        }
        
        params.addElement(new StringValue(project.getAttribute("option2") != null ? (String) project.getAttribute("option2") : "UL"));
        params.addElement(new StringValue(project.getAttribute("option3") != null ? (String) project.getAttribute("option3") : "UL"));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.IS_TRNSPRT_STN)));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.IS_MNGMNT_STN)));
        params.addElement(new StringValue(project.getAttribute("integratedId") != null ? (String) project.getAttribute("integratedId") : ""));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertProject").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            //
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
            
            cashData();

            params = new Vector();

            String issueStatusId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(issueStatusId));
            // 1 mean received from Issue // 2 mean sent from complaint //
            params.addElement(new StringValue("8"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue(unitId));//clientCompId--business-comp-id
            params.addElement(new StringValue("Housing_Units"));
            params.addElement(new StringValue("0"));//issueId--parent id
            params.addElement(new StringValue((String) waUser.getAttribute("userId")));

            forInsert.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
            
            if (((String) project.getAttribute(ProjectConstants.LOCATION_TYPE)).equals("44")) {
                String projectAccId = UniqueIDGen.getNextID();
                params = new Vector();
                params.addElement(new StringValue(projectAccId));
                params.addElement(new StringValue("0"));
                params.addElement(new StringValue(unitId));
                params.addElement(new StringValue("NILL"));
                params.addElement(new StringValue("NILL"));
                params.addElement(new StringValue("NILL"));
                params.addElement(new StringValue((String) waUser.getAttribute("userId")));
                forInsert.setConnection(transConnection);
                forInsert.setSQLQuery("INSERT INTO PROJECT_ACC VALUES (?, ?, ?, ?, ?, ?,sysdate, ?)");
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                //
                if (queryResult < 0) {
                    transConnection.rollback();
                    return false;
                }
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();
        }

        return (queryResult > 0);
    }

    public boolean saveObject2(WebBusinessObject project, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String unitId = UniqueIDGen.getNextID();
        params.addElement(new StringValue(unitId));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.PROJECT_NAME)));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.EQ_NO)));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.PROJECT_DESC)));

        String mainProjectId = null;
        try {
            mainProjectId = project.getAttribute("mainProjectId").toString();
        } catch (NullPointerException e) {
            mainProjectId = "0";
        }
        
        params.addElement(new StringValue(mainProjectId));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.LOCATION_TYPE)));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.FUTILE)));
//        params.addElement(new StringValue(project.getAttribute("coordinate").toString()));
        params.addElement(new StringValue("UL"));
        if (project.getAttribute("optionOne") != null) {
            params.addElement(new StringValue((String) project.getAttribute("optionOne")));
        } else {
            params.addElement(new StringValue("UL"));
        }
        
        params.addElement(new StringValue(project.getAttribute("option2") != null ? (String) project.getAttribute("option2") : "UL"));
        params.addElement(new StringValue(project.getAttribute("option3") != null ? (String) project.getAttribute("option3") : "UL"));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.IS_TRNSPRT_STN)));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.IS_MNGMNT_STN)));
        params.addElement(new StringValue(project.getAttribute("integratedId") != null ? (String) project.getAttribute("integratedId") : ""));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertProject").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            //
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
            

            params = new Vector();

            String issueStatusId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(issueStatusId));
            // 1 mean received from Issue // 2 mean sent from complaint //
            params.addElement(new StringValue("8"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue(unitId));//clientCompId--business-comp-id
            params.addElement(new StringValue("Housing_Units"));
            params.addElement(new StringValue("0"));//issueId--parent id
            params.addElement(new StringValue((String) waUser.getAttribute("userId")));

            forInsert.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
            
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();
        }

        return (queryResult > 0);
    }

        public boolean saveObject3(WebBusinessObject project2, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String unitId = UniqueIDGen.getNextID();
        params.addElement(new StringValue(unitId));
        params.addElement(new StringValue((String) project2.getAttribute("clientId")));
        params.addElement(new StringValue((String) project2.getAttribute("STAGE_CODE")));
        params.addElement(new StringValue((String) project2.getAttribute("SECTION_CODE")));
        params.addElement(new StringValue((String) project2.getAttribute("SUBSTAGE_CODE")));
        params.addElement(new StringValue((String) project2.getAttribute("SAMPLE_CODE")));
        params.addElement(new StringValue((String) project2.getAttribute("BUILDING_CODE")));
        params.addElement(new StringValue((String) project2.getAttribute("BUILDING_TYPE")));
        params.addElement(new StringValue((String) project2.getAttribute("UNIT_CODE")));
        params.addElement(new StringValue((String) project2.getAttribute("installment")));
        params.addElement(new StringValue((String) project2.getAttribute("budget")));
        params.addElement(new StringValue((String) project2.getAttribute("unitNotes")));
        params.addElement(new StringValue((String) project2.getAttribute("paymentSystem")));
        params.addElement(new StringValue((String) project2.getAttribute("sourceID")));
        params.addElement(new StringValue((String) project2.getAttribute("unitId")));
        params.addElement(new StringValue((String) project2.getAttribute("clientNORe")));
        params.addElement(new StringValue((String) project2.getAttribute("mainBuilding")));
        params.addElement(new StringValue((String) project2.getAttribute("projectDatabase")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) project2.getAttribute("UNIT_TOTAL_PRICE")));
        params.addElement(new StringValue((String) project2.getAttribute("UNIT_BUILDINGS_AREA")));
      
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertProjectRealEstateRes").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            //
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }

         } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();
        }

        return (queryResult > 0);
    }
       public boolean saveObject4(WebBusinessObject project3, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String userIdSchema = (String) project3.getAttribute("PROJECT");
        String getAssetErpNameSchema = metaDataMgr.getAssetErpName().toString();
        String getAssetErpPasswordSchema = metaDataMgr.getAssetErpPassword().toString();
        String dataBaseSchema = null;
        if (userIdSchema.equals(getAssetErpNameSchema)){
           dataBaseSchema = metaDataMgr.getStoreErpName().toString();
        } else if (userIdSchema.equals(getAssetErpPasswordSchema)){
           dataBaseSchema = metaDataMgr.getStoreErpPassword().toString();
        } 

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) project3.getAttribute("ReservCard_Code")));
        params.addElement(new StringValue((String) project3.getAttribute("CLIENT_CODE")));
        params.addElement(new StringValue((String) project3.getAttribute("STAGE_CODE")));
        params.addElement(new StringValue((String) project3.getAttribute("SECTION_CODE")));
        params.addElement(new StringValue((String) project3.getAttribute("SUBSTAGE_CODE")));
        params.addElement(new StringValue((String) project3.getAttribute("SAMPLE_CODE")));
        params.addElement(new StringValue((String) project3.getAttribute("BUILDING_CODE")));
        params.addElement(new StringValue((String) project3.getAttribute("BUILDING_TYPE")));
        params.addElement(new StringValue((String) project3.getAttribute("UNIT_CODE")));
        params.addElement(new StringValue((String) project3.getAttribute("INSTALMENT_TYPE_CODE")));
        params.addElement(new StringValue((String) project3.getAttribute("DOWN_PAYMENT")));
        params.addElement(new StringValue((String) project3.getAttribute("RECEIPT_NO")));
        params.addElement(new StringValue((String) project3.getAttribute("PAYMENT_METHOD")));
        params.addElement(new StringValue((String) project3.getAttribute("SOURCE")));
        params.addElement(new StringValue((String) project3.getAttribute("brokerInfName")));
        params.addElement(new StringValue((String) project3.getAttribute("UNIT_TYPE")));
        params.addElement(new StringValue((String) project3.getAttribute("STAGE_CODE")));
        params.addElement(new StringValue((String) project3.getAttribute("mainBuilding")));
        params.addElement(new StringValue((String) project3.getAttribute("UNIT_TOTAL")));
        params.addElement(new StringValue((String) project3.getAttribute("AREA")));
      
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertProjectRealEstateResSchema").trim().replace("ppp", dataBaseSchema));
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            //
            try {
                Thread.sleep(100);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }

         } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();
        }

        return (queryResult > 0);
    }

        
    public Vector getJoinTable() throws SQLException, Exception {
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getJoinTable").trim());
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error(uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row row;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            WebBusinessObject wboTemp = fabricateBusObj(row);
            if (row.getString("AR_DESC") != null) {
                wboTemp.setAttribute("ar", row.getString("AR_DESC"));
            }
            
            reultBusObjs.add(wboTemp);
        }
        
        return reultBusObjs;
    }
    
        public Vector getJoinTableUnitType() throws SQLException, Exception {
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getJoinTableUnitType").trim());
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error(uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row row;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            WebBusinessObject wboTemp = fabricateBusObj(row);
            if (row.getString("CODE") != null) {
                wboTemp.setAttribute("CODE", row.getString("CODE"));
            }
            if (row.getString("DESCRIPTION") != null) {
                wboTemp.setAttribute("DESCRIPTION", row.getString("DESCRIPTION"));
            }
            
            reultBusObjs.add(wboTemp);
        }
        
        return reultBusObjs;
    }
        
        public Vector getmainEOI(String eoiId) throws SQLException, Exception {
        Vector queryResult = null;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(eoiId));
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getJoinTableUnitTypeEOI").trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error(uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row row;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            WebBusinessObject wboTemp = fabricateBusObj(row);
            if (row.getString("UNIT_VALUE") != null) {
                wboTemp.setAttribute("UNIT_VALUE", row.getString("UNIT_VALUE"));
            }
            
            reultBusObjs.add(wboTemp);
        }
        
        return reultBusObjs;
    }
        
    public Vector getmainEoiName(String eoiName) throws SQLException, Exception {
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        
        
        try {
            forQuery.setConnection(connection);
            if(eoiName.equals("1")){
            forQuery.setSQLQuery(getQuery("getmainEoiName").trim());
            } else if(eoiName.equals("2")){
            forQuery.setSQLQuery(getQuery("getmainEoiName2").trim());
            } else if(eoiName.equals("3")){
            forQuery.setSQLQuery(getQuery("getmainEoiName3").trim());
            } else if(eoiName.equals("4")){
            forQuery.setSQLQuery(getQuery("getmainEoiName4").trim());
            }
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error(uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row row;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            WebBusinessObject wboTemp = fabricateBusObj(row);
            if (row.getString("NAME_VALUE") != null) {
                wboTemp.setAttribute("NAME_VALUE", row.getString("NAME_VALUE"));
            }
            
            reultBusObjs.add(wboTemp);
        }
        
        return reultBusObjs;
    }  
                
                
      public Vector getJoinTableUnitTypeCampaign(String camId) throws SQLException, Exception {
            Vector queryResult = null;
            Vector parameters = new Vector();
            parameters.addElement(new StringValue(camId));
            SQLCommandBean forQuery = new SQLCommandBean();
            Connection connection = dataSource.getConnection();

            try {
                forQuery.setConnection(connection);
                forQuery.setSQLQuery(getQuery("getJoinTableUnitTypeCampaign").trim());
                forQuery.setparams(parameters);
                queryResult = forQuery.executeQuery();
            } catch (SQLException se) {
                logger.error(se.getMessage());
                throw se;
            } catch (UnsupportedTypeException uste) {
                logger.error(uste.getMessage());
            } finally {
                connection.close();
            }

            // process the vector
            // vector of business objects
            Vector reultBusObjs = new Vector();

            Row row;
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                WebBusinessObject wboTemp = fabricateBusObj(row);
                if (row.getString("campaign_title") != null) {
                    wboTemp.setAttribute("campaign_title", row.getString("campaign_title"));
                }
                if (row.getString("partner") != null) {
                    wboTemp.setAttribute("partner", row.getString("partner"));
                }
            if (row.getString("matiral_status") != null) {
                wboTemp.setAttribute("matiral_status", row.getString("matiral_status"));
            }

                reultBusObjs.add(wboTemp);
            }

            return reultBusObjs;
        }
        public Vector getInstalmet(String userUnitType) throws SQLException, Exception {
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getInstalmet").trim().replace("ppp", userUnitType));
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error(uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row row;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            WebBusinessObject wboTemp = fabricateBusObj(row);
            if (row.getString("INSTALMENT_TYPE_CODE") != null) {
                wboTemp.setAttribute("CODE", row.getString("INSTALMENT_TYPE_CODE"));
            }
            if (row.getString("INSTALMENT_DESCRIPTION") != null) {
                wboTemp.setAttribute("DESCRIPTION", row.getString("INSTALMENT_DESCRIPTION"));
            }
            
            reultBusObjs.add(wboTemp);
        }
        
        return reultBusObjs;
    }
        
        public Vector getInstalmetWeb() throws SQLException, Exception {
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getInstalmetWeb").trim());
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error(uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row row;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            WebBusinessObject wboTemp = fabricateBusObj(row);
            if (row.getString("CODE") != null) {
                wboTemp.setAttribute("CODE", row.getString("CODE"));
            }
            if (row.getString("DESCRIPTION") != null) {
                wboTemp.setAttribute("DESCRIPTION", row.getString("DESCRIPTION"));
            }
            
            reultBusObjs.add(wboTemp);
        }
        
        return reultBusObjs;
    }

    public Vector getDepartmentsWithManager(String excludeMangerId) throws Exception {
        Vector parameters = new Vector();
        Vector queryResult = null;
        WebBusinessObject wbo;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();

        parameters.addElement(new StringValue(excludeMangerId));
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getDepartmentsWithManager").trim());
            forQuery.setparams(parameters);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error(uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row row;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            wbo = fabricateBusObj(row);
            if (row.getString("USER_ID") != null) {
                wbo.setAttribute("userId", row.getString("USER_ID"));
            }
            
            if (row.getString("FULL_NAME") != null) {
                wbo.setAttribute("userName", row.getString("FULL_NAME"));
            }
            
            reultBusObjs.add(wbo);
        }
        
        return reultBusObjs;
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

    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("projectName"));
        }

        return cashedData;
    }

    public String getAllSites() {
        cashData();
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < cashedTable.size(); i++) {
            sb.append(((WebBusinessObject) cashedTable.get(i)).getAttribute("projectID").toString() + " ");
        }

        return sb.toString();
    }

    public boolean updateProject(WebBusinessObject wbo) throws NoUserInSessionException {
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        if (wbo.getAttribute("mainProjectId") != null) {
            params.addElement(new StringValue((String) wbo.getAttribute("mainProjectId")));

        }

        params.addElement(new StringValue((String) wbo.getAttribute("projectName")));
        params.addElement(new StringValue((String) wbo.getAttribute("eqNO")));
        params.addElement(new StringValue((String) wbo.getAttribute("futile")));
        params.addElement(new StringValue((String) wbo.getAttribute("location_type")));
        params.addElement(new StringValue((String) wbo.getAttribute("projectDesc")));
        params.addElement(new StringValue((String) wbo.getAttribute("isMngmntStn")));
        params.addElement(new StringValue((String) wbo.getAttribute("isTrnsprtStn")));
        params.addElement(new StringValue((String) wbo.getAttribute("projectID")));
        try {
            beginTransaction();
            forUpdate.setConnection(transConnection);
            if (wbo.getAttribute("mainProjectId") == null) { // update main project
                forUpdate.setSQLQuery(getQuery("update").trim());
            } else {    // update sub project
                forUpdate.setSQLQuery(getQuery("updateSubProject").trim());
            }

            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

            cashData();
            endTransaction();
        } catch (SQLException se) {
            logger.error("Exception updating project: " + se.getMessage());
            return false;
        }

        return (queryResult > 0);
    }

    public boolean updateDepartmentManager(WebBusinessObject wbo) throws NoUserInSessionException {
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        String managerId = (String) wbo.getAttribute("managerId");
        String derpartmentId = (String) wbo.getAttribute("departmentId");
        if (managerId != null & derpartmentId != null) {
            params.addElement(new StringValue(managerId));
            params.addElement(new StringValue(derpartmentId));
        }
        
        try {
            beginTransaction();
            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(getQuery("updateDepartmentManager").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error("Exception updating project: " + se.getMessage());
            return false;
        }

        return (queryResult > 0);
    }

    public boolean getActiveSite(String projectName) throws Exception {
        Vector SQLparams = new Vector();
        Connection connection = null;
        Vector queryResult = null;
        SQLparams.addElement(new StringValue(projectName));
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectProjectMaintainableUnit").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("database error from getListOnSecondKey: ImageMgr " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }

        return queryResult.size() > 0;
    }

    public void UpdateOldProjectNameforUnit(String ProjectName, String OldProjectName) {
        Vector projectnameParams = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();

        projectnameParams.addElement(new StringValue(ProjectName));
        projectnameParams.addElement(new StringValue(OldProjectName));//Total Time
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateProjectMaintainableUnit").trim());
            forUpdate.setparams(projectnameParams);
            int queryResult = forUpdate.executeUpdate();
        } catch (SQLException sex) {
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
    }

    public void UpdateOldProjectNameforIssue(String ProjectName, String OldProjectName) {
        Vector projectnameParams = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();

        projectnameParams.addElement(new StringValue(ProjectName));
        projectnameParams.addElement(new StringValue(OldProjectName));//Total Time
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateProjectIssue").trim());
            forUpdate.setparams(projectnameParams);
            int queryResult = forUpdate.executeUpdate();
        } catch (SQLException sex) {
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
    }

    public Vector getSitesBySubName(String name) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        String query = sqlMgr.getSql("getSitesBySubName").trim().replaceAll("ppp", name);

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public Vector getSitesBySort() {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getSitesBySort").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public ArrayList getAllAsArrayList() {
        ArrayList allAsArrayList = new ArrayList();

        Vector allAsVector = getSitesBySort();
        for (int i = 0; i < allAsVector.size(); i++) {
            allAsArrayList.add((WebBusinessObject) allAsVector.get(i));
        }

        return allAsArrayList;
    }

    public Vector getProjectsName(String[] projectIds) {
        Connection connection = null;

        String quary = sqlMgr.getSql("selectSitesByIds").trim();

        quary = quary.replaceAll("iii", Tools.concatenation(projectIds, ","));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(quary);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        
        Vector resAsWbo = new Vector();
        Row row;
        for (int i = 0; i < queryResult.size(); i++) {
            row = (Row) queryResult.get(i);
            try {
                resAsWbo.addElement(row.getString("PROJECT_NAME"));
            } catch (NoSuchColumnException ex) {
                logger.error(ex.getMessage());
            }
        }

        return resAsWbo;
    }

    public Vector getProjectsName(String projectIds) {
        Connection connection = null;

        String quary = sqlMgr.getSql("selectSitesByIds").trim();

        quary = quary.replaceAll("iii", projectIds);

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(quary);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        
        Vector resAsWbo = new Vector();
        Row row;
        for (int i = 0; i < queryResult.size(); i++) {
            row = (Row) queryResult.get(i);
            try {
                resAsWbo.addElement(row.getString("PROJECT_NAME"));
            } catch (NoSuchColumnException ex) {
                logger.error(ex.getMessage());
            }
        }

        return resAsWbo;
    }

    public void updateWorkItems(String[] projectID, String[] unitID, String[] unitValue, String[] workItemsIndex, String[] equipTypes, String[] sprPrtcheckQuantity, String[] minValues, String[] maxValues) {
        Connection connection = null;
        String query = getQuery("updateWorkItems");
        SQLCommandBean forUpdate = new SQLCommandBean();
        Vector params;
        int queryResult = -1000;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(query);
            int counter = 0;
            for (int i = 0; i < workItemsIndex.length; i++) {
                if (workItemsIndex[i].equals("1")) {
                    params = new Vector();
                    if (unitID != null) {
                        params.addElement(new StringValue(unitID[i]));
                    } else {
                        params.addElement(new StringValue("null"));
                    }
                    
                    params.addElement(new StringValue(unitValue[i]));
                    if (sprPrtcheckQuantity != null) {
                        params.addElement(new StringValue(sprPrtcheckQuantity[i]));
                    } else {
                        params.addElement(new StringValue("null"));
                    }
                    
                    if (equipTypes != null) {
                        params.addElement(new StringValue(equipTypes[i])); //Kareem
                    } else {
                        params.addElement(new StringValue("null"));
                    }
                    
                    if (minValues != null) {
                        params.addElement(new StringValue(minValues[counter]));
                    } else {
                        params.addElement(new StringValue("0"));
                    }
                    if (maxValues != null) {
                        params.addElement(new StringValue(maxValues[counter]));
                    } else {
                        params.addElement(new StringValue("0"));
                    }
                    params.addElement(new StringValue(projectID[counter]));
                    forUpdate.setparams(params);
                    queryResult = forUpdate.executeUpdate();
                    counter++;
                }
            }
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
    }

    public List<WebBusinessObject> getAllWorkItems() {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;
        String query = getQuery("getAllWorkItems");
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        
        List<WebBusinessObject> resultObjs = new ArrayList<WebBusinessObject>();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultObjs.add(wbo);
        }
        
        return resultObjs;
    }

    
     public ArrayList<WebBusinessObject> getAllNodes() {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;
        String query = getQuery("getAllNodes");
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        
        ArrayList<WebBusinessObject> resultObjs = new ArrayList<WebBusinessObject>();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultObjs.add(wbo);
            
        }
        
        return resultObjs;
    }
     
    public ArrayList<WebBusinessObject> getAllNodeChild( String nodeID) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;
        Vector Params=new Vector();
        Params.add(new StringValue(nodeID));
        String query = getQuery("getAllNodeChild").replace("NODEID", nodeID).trim();
        
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(Params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        
        ArrayList<WebBusinessObject> resultObjs = new ArrayList<WebBusinessObject>();
        ArrayList<WebBusinessObject> sortedResult = new ArrayList<WebBusinessObject>();
        Row r = null;
      
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
              String  TreeMEM="";
             r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultObjs.add(wbo);
            try {
                
                if(r.getString("type")!=null)
                    wbo.setAttribute("type", r.getString("type"));   
                else 
                    wbo.setAttribute("type", "UL");  
                
                wbo.setAttribute("optionThree", r.getString("OPTION_THREE"));
                TreeMEM= r.getString("OPTION_THREE");
                String Mem[]=TreeMEM.split("-");
               int level=Mem.length-2;
               wbo.setAttribute("level", level);
               wbo.setAttribute("DirectParent", Mem[Mem.length-2]);
              
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
        }
        return resultObjs;
    }

    public ArrayList<WebBusinessObject> getAllFinTreeItem( ) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;
        Vector Params=new Vector();
         String query = getQuery("getAllFinTreeItem").trim();
        
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
             queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        
        ArrayList<WebBusinessObject> resultObjs = new ArrayList<WebBusinessObject>();
        ArrayList<WebBusinessObject> sortedResult = new ArrayList<WebBusinessObject>();
        Row r = null;
      
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
              String  TreeMEM="";
             r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultObjs.add(wbo);
            try {
                
                if(r.getString("type")!=null)
                    wbo.setAttribute("type", r.getString("type"));   
                else 
                    wbo.setAttribute("type", "UL"); 
                
                
                 if(r.getString("OPTION_TWO")!=null)
                    wbo.setAttribute("code", r.getString("OPTION_TWO"));   
                else 
                    wbo.setAttribute("code", " ");  
                
                wbo.setAttribute("optionThree", r.getString("OPTION_THREE"));
                TreeMEM= r.getString("OPTION_THREE");
                String Mem[]=TreeMEM.split("-");
               int level=Mem.length-2;
               wbo.setAttribute("level", level);
               wbo.setAttribute("DirectParent", Mem[Mem.length-2]);
              
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
        }
        return resultObjs;
    }

    public Vector getAllEquipClass() { //Kareem 
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;
        String query = getQuery("getAllEquipClass");
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        
        Vector resultObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultObjs.add(wbo);
        }
        
        return resultObjs;
    } //Kareem end

    
    public List<WebBusinessObject> getAllMaintenanceItems() { //Kareem 
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;
        String query = getQuery("getAllMaintenanceItems");
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        
        List<WebBusinessObject> resultObjs = new ArrayList<WebBusinessObject>();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultObjs.add(wbo);
        }
        
        return resultObjs;
    } //Kareem end

    public List<WebBusinessObject> getAllParents() {
        WebBusinessObject wbo = new WebBusinessObject();

        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        String query = "select * from project where MAIN_PROJ_ID = '0'";

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        List<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public List<WebBusinessObject> getAllLocation() {
        WebBusinessObject wbo = new WebBusinessObject();

        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        String query = "select * from project where location_type='GEOLOCGRP'";

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        List<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public String getSiteNameById(String siteId) {
        Connection connection = null;

        String quary = sqlMgr.getSql("selectSiteNameById").trim();

        Vector param = new Vector();
        param.addElement(new StringValue(siteId));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(quary);
            forQuery.setparams(param);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        
        //Vector resAsWbo = new Vector();
        String siteName = "";
        Row row;
        for (int i = 0; i < queryResult.size(); i++) {
            row = (Row) queryResult.get(i);
            try {
                siteName = row.getString("PROJECT_NAME");
            } catch (NoSuchColumnException ex) {
                logger.error(ex.getMessage());
            }
        }

        return siteName;
    }
    
    public String QUESTIONNAIRE_CODE(String siteId) {
        Connection connection = null;
        String userId = (String) siteId;
        String getAssetErpName = metaDataMgr.getAssetErpName().toString();
        String getAssetErpPassword = metaDataMgr.getAssetErpPassword().toString();
        String dataBaseRealEstat = null;
        if (userId.equals(getAssetErpName)){
           dataBaseRealEstat = metaDataMgr.getStoreErpName().toString();
        } else if (userId.equals(getAssetErpPassword)){
           dataBaseRealEstat = metaDataMgr.getStoreErpPassword().toString();
        } 

        String quary = getQuery("getSiteNameByIdQa").trim();

        //Vector param = new Vector();
        //param.addElement(new StringValue(siteId));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(quary.replace("ppp", dataBaseRealEstat));
            //forQuery.setparams(param);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        
        //Vector resAsWbo = new Vector();
        String siteName = "";
        Row row;
        for (int i = 0; i < queryResult.size(); i++) {
            row = (Row) queryResult.get(i);
            try {
                siteName = row.getString("no_code");
            } catch (NoSuchColumnException ex) {
                logger.error(ex.getMessage());
            }
        }

        return siteName;
    }

    public String ReservCard_Code(String siteId) {
        Connection connection = null;
        String userId = (String) siteId;
        String getAssetErpName = metaDataMgr.getAssetErpName().toString();
        String getAssetErpPassword = metaDataMgr.getAssetErpPassword().toString();
        String dataBaseRealEstat = null;
        if (userId.equals(getAssetErpName)){
           dataBaseRealEstat = metaDataMgr.getStoreErpName().toString();
        } else if (userId.equals(getAssetErpPassword)){
           dataBaseRealEstat = metaDataMgr.getStoreErpPassword().toString();
        } 

        String quary = getQuery("getReservCard_Code").trim();

        //Vector param = new Vector();
        //param.addElement(new StringValue(siteId));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(quary.replace("ppp", dataBaseRealEstat));
            //forQuery.setparams(param);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        
        //Vector resAsWbo = new Vector();
        String siteName = "";
        Row row;
        for (int i = 0; i < queryResult.size(); i++) {
            row = (Row) queryResult.get(i);
            try {
                siteName = row.getString("no_code");
            } catch (NoSuchColumnException ex) {
                logger.error(ex.getMessage());
            }
        }

        return siteName;
    }
    
    public String ReservCard_CodeClient(String siteId) {
        Connection connection = null;
        String userId = (String) siteId;
        String getAssetErpName = metaDataMgr.getAssetErpName().toString();
        String getAssetErpPassword = metaDataMgr.getAssetErpPassword().toString();
        String dataBaseRealEstat = null;
        if (userId.equals(getAssetErpName)){
           dataBaseRealEstat = metaDataMgr.getStoreErpName().toString();
        } else if (userId.equals(getAssetErpPassword)){
           dataBaseRealEstat = metaDataMgr.getStoreErpPassword().toString();
        } 

        String quary = getQuery("getReservCard_CodeClient").trim();

        //Vector param = new Vector();
        //param.addElement(new StringValue(siteId));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(quary.replace("ppp", dataBaseRealEstat));
            //forQuery.setparams(param);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        
        //Vector resAsWbo = new Vector();
        String siteName = "";
        Row row;
        for (int i = 0; i < queryResult.size(); i++) {
            row = (Row) queryResult.get(i);
            try {
                siteName = row.getString("no_code");
            } catch (NoSuchColumnException ex) {
                logger.error(ex.getMessage());
            }
        }

        return siteName;
    }

    public Vector getMainProjectsByUser(String userId) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        String query = getQuery("getMainProjectsByUser").trim();

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            SQLparams.addElement(new StringValue(userId));
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();
        Row row;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            try {
                row = (Row) e.nextElement();
                wbo = fabricateBusObj(row);
                wbo.setAttribute("isDefault", row.getString("IS_DEFAULT"));
                resultBusObjs.add(wbo);
            } catch (NoSuchColumnException ex) {
                logger.error(ex);
            }
        }
        
        return resultBusObjs;
    }

    public ArrayList getSubProjectsById(String mainProjectId) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        String query = getQuery("getSubProjectsById").trim();

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            SQLparams.addElement(new StringValue(mainProjectId));
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        ArrayList resultBusObjs = new ArrayList();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public ArrayList getSubProjectsByCode(String mainProjectCode) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        String query = getQuery("getSubProjectsByCode").trim();

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            SQLparams.addElement(new StringValue(mainProjectCode));
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        ArrayList resultBusObjs = new ArrayList();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public String getMainProjectsStrByUser(String userId) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector resultVec = new Vector();
        String projectsStr = "";
        Vector SQLparams = new Vector();
        Vector queryResult = null;

        String query = getQuery("getMainProjectsByUser").trim();

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            SQLparams.addElement(new StringValue(userId));
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            try {
                r = (Row) e.nextElement();
                resultVec.add(r.getString("project_id"));
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        projectsStr = resultVec.toString();

        return projectsStr.substring(1, projectsStr.length() - 1);
    }

    public Vector getAllMainProjects() {
        String quary = getQuery("getAllMainProjects").trim();

        Vector param = new Vector();

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(quary);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }
        
        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo = new WebBusinessObject();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public Vector getSubProjectItems(String Id) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(getQuery("getSubProjectItems").trim());

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(Id));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public String getMainType(String parenId) {
        Connection connection = null;

        String quary = sqlMgr.getSql("selectMainTypeById").trim();
        Vector param = new Vector();
        Vector queryResult = null;
        param.addElement(new StringValue(parenId));
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(param);
            forQuery.setSQLQuery(quary);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        
        String resAsWbo = "";
        Row row;
        for (int i = 0; i < queryResult.size(); i++) {
            row = (Row) queryResult.get(i);
            try {
                resAsWbo = row.getString("type_name");
            } catch (NoSuchColumnException ex) {
                logger.error(ex.getMessage());
            }
        }

        return resAsWbo;
    }

    public Vector getAllProjects(String parentId) {
        String quary = getQuery("getAllProjects").trim();

        Vector param = new Vector();

        param.addElement(new StringValue(parentId));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setparams(param);
            forQuery.setSQLQuery(quary);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }
        
        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo = new WebBusinessObject();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public ArrayList getAllMngmntProjects() {
        String quary = getQuery("getAllMngmntProjects").trim();

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(quary);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }
        
        ArrayList resultBusObjs = new ArrayList();
        WebBusinessObject wbo = new WebBusinessObject();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public boolean updateProjectMapData(String coordinate, String id) {
        Vector supEquipParams = new Vector();

        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        supEquipParams.addElement(new StringValue(coordinate));
        supEquipParams.addElement(new StringValue(id));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);

            forInsert.setSQLQuery(getQuery("updateProjectMap").trim());
            forInsert.setparams(supEquipParams);
            queryResult = forInsert.executeUpdate();

            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        
        return true;
    }

    public boolean deleteProjectTree(String id) {
        ArrayList<WebBusinessObject> childNode = new ArrayList<WebBusinessObject>();
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        WebBusinessObject childWbo = new WebBusinessObject();
        Vector childIdAndParent = new Vector();
        boolean isDeleted = false;
        try {
            isDeleted = projectMgr.deleteOnSingleKey(id);
            childNode = projectMgr.getOnArbitraryKey2(id, "key2");
            if (childNode.size() > 0) {
                for (int j = 0; j < childNode.size(); j++) {
                    childWbo = (WebBusinessObject) childNode.get(j);
                    isDeleted = projectMgr.deleteOnSingleKey(childWbo.getAttribute("projectID").toString());

                    childWbo = (WebBusinessObject) childNode.get(j);
                    //childWbo.setAttribute("size", size);
                    //list.add(childWbo);
                    childIdAndParent.add(j, childWbo);
                }
                
                for (int j = 0; j < childIdAndParent.size(); j++) {
                    deleteProjectTree(((WebBusinessObject) childIdAndParent.get(j)).getAttribute("projectID").toString());
                }
            } else {
                System.out.println("Not Have Sites");
            }
        } catch (Exception exc) {
            System.out.println(exc.getMessage());
        }
        
        return isDeleted;
    }

    public ArrayList getAllNotFutileProjects() {
        String quary = getQuery("getAllNotFutileProjects").trim();

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(quary);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }
        
        ArrayList resultBusObjs = new ArrayList();
        WebBusinessObject wbo = new WebBusinessObject();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    public Vector getAllCompDeaprtments(String name) {
        Vector param = new Vector();

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        String query = sqlMgr.getSql("getAllCompDeaprtments").trim().replaceAll("ppp", name);
        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }
        
        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo = new WebBusinessObject();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public Vector getAllDepartments() {
        Vector param = new Vector();

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        String query = sqlMgr.getSql("getAllProjects").trim();
        param.addElement(new StringValue("1363695825692"));
        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setparams(param);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            endTransaction();
        }
        
        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo = new WebBusinessObject();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public Vector getUnitDetails(String text, String id) throws SQLException {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        String query = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector param = new Vector();
        param.add(new StringValue(id));

        query = getQuery("getUnitDetails").trim();
        query = query.replaceAll("text", text);
        forQuery.setparams(param);
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            connection.close();
        }
        
        Vector reultBusObjs = new Vector();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            reultBusObjs.add(wbo);
        }

        return reultBusObjs;
    }

    public Vector getModels(String id) throws SQLException {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        String query = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            Vector param = new Vector();
            param.add(new StringValue(id));
            param.add(new StringValue("RES-MODEL"));
            query = getQuery("getModels").trim();
            forQuery.setparams(param);
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            connection.close();
        }
        
        Vector reultBusObjs = new Vector();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            reultBusObjs.add(wbo);
        }

        return reultBusObjs;
    }

    public String getSubProjectsByMainProjectAsJSON(String mainProjectId) {
        WebBusinessObject wbo = new WebBusinessObject();
        Row row = null;
        Connection connection = null;
        Vector queryResult = null;
        Vector params = new Vector();

        params.addElement(new StringValue(mainProjectId));
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);

            forQuery.setSQLQuery(getQuery("getSubProjectsByMainProject").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        if (queryResult.isEmpty()) {
            wbo.setAttribute("", "--");
        } else {
            for (int i = 0; i < queryResult.size(); i++) {
                row = (Row) queryResult.get(i);
                try {
                    wbo.setAttribute(row.getString("project_id"), row.getString("project_name"));
                } catch (NoSuchColumnException ex) {
                    logger.error(ex.getMessage());
                }
            }
        }

        return Tools.getJSONObjectAsString(wbo);
    }

    public String getOption() {
        WebBusinessObject wbo = new WebBusinessObject();
        Row row = null;
        Connection connection = null;
        Vector queryResult = null;
        Vector params = new Vector();

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);

            forQuery.setSQLQuery(getQuery("getOtption").trim());

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        if (queryResult.isEmpty()) {
            wbo.setAttribute("", "--");
        } else {
            for (int i = 0; i < queryResult.size(); i++) {
                row = (Row) queryResult.get(i);
                try {
//                    wbo.setAttribute(row.getString("option_one"), row.getString("option_two"));
                    wbo.setAttribute("option_one", row.getString("option_one"));
                    wbo.setAttribute("option_two", row.getString("option_two"));
                } catch (NoSuchColumnException ex) {
                    logger.error(ex.getMessage());
                }
            }
        }
        
        System.out.println(Tools.getJSONObjectAsString(wbo));
        return Tools.getJSONObjectAsString(wbo);
    }

    public String saveAvailableUnit(HttpServletRequest request, HttpSession s) throws NoUserInSessionException, SQLException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Vector queryResultV = null;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        projectMgr = ProjectMgr.getInstance();
        WebBusinessObject wbo = new WebBusinessObject();
        wbo = projectMgr.getOnSingleKey(request.getParameter("unitId"));
        String unitName = (String) wbo.getAttribute("projectName");
        wbo = new WebBusinessObject();
        wbo = projectMgr.getOnSingleKey(request.getParameter("unitCategoryId"));
        String unitCategoryName = (String) wbo.getAttribute("projectName");

        String id = UniqueIDGen.getNextID();
        params.addElement(new StringValue(id));
        params.addElement(new StringValue(request.getParameter("clientId")));
        params.addElement(new StringValue(request.getParameter("unitId")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue("reserved"));
        params.addElement(new StringValue(request.getParameter("unitCategoryId")));
        //params.addElement(new StringValue(request.getParameter("budget")));
        params.addElement(new StringValue("000"));
        params.addElement(new StringValue(request.getParameter("period")));
        params.addElement(new StringValue(request.getParameter("paymentSystem")));
        //params.addElement(new StringValue(request.getParameter("paymentPlace")));
        params.addElement(new StringValue("canceled"));
        params.addElement(new StringValue(unitName));
        params.addElement(new StringValue(unitCategoryName));
        params.addElement(new StringValue(request.getParameter("unitValue")));
        params.addElement(new StringValue(request.getParameter("reservationValue")));
        params.addElement(new StringValue(request.getParameter("contractValue")));
        params.addElement(new StringValue(request.getParameter("plotArea")));
        params.addElement(new StringValue(request.getParameter("buildingArea")));
        params.addElement(new StringValue(request.getParameter("beforeDiscount")));

//        Connection connection = null;
//            connection = dataSource.getConnection();
        try {
            beginTransaction();
//            connection.setAutoCommit(true);
            forInsert.setConnection(transConnection);
            String myQuery = getQuery("insertClientProducts").trim();
            forInsert.setSQLQuery(myQuery);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }

            params = new Vector();
            params.addElement(new StringValue((String) request.getParameter("unitId")));
            forInsert.setSQLQuery(sqlMgr.getSql("getCompStatusByUser2").trim());
            forInsert.setparams(params);
            try {
                queryResultV = forInsert.executeQuery();
            } catch (UnsupportedTypeException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            Row r = null;
            Enumeration e = queryResultV.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                
                try {
                    id = r.getString("STATUS_ID").toString();
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            if (id != null && !id.equals("")) {
                params = new Vector();
                params.addElement(new StringValue(id));
                beginTransaction();
                forInsert.setConnection(transConnection);
                forInsert.setSQLQuery(sqlMgr.getSql("updateStatusByUser").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                if (queryResult < 0) {
                    transConnection.rollback();
                    return null;
                }
                
                try {
                    Thread.sleep(50);
                } catch (InterruptedException ex) {
                    Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
                } finally {
                    endTransaction();
                }
            }

            params = new Vector();
            String issueStatusId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(issueStatusId));
            params.addElement(new StringValue("9"));
            params.addElement(new StringValue((String) request.getParameter("period")));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue((String) request.getParameter("unitId")));
            params.addElement(new StringValue("Housing_Units"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue((String) waUser.getAttribute("userId")));
//            params.addElement(new StringValue(" "));
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }

            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                endTransaction();
            }

            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            transConnection.rollback();
            return null;
//
        } finally {

            endTransaction();
        }
        
        return id;
    }
    
    public String saveFastAvailableUnit(HttpServletRequest request, HttpSession s) throws NoUserInSessionException, SQLException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Vector queryResultV = null;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        projectMgr = ProjectMgr.getInstance();
        WebBusinessObject wbo = new WebBusinessObject();
        wbo = projectMgr.getOnSingleKey(request.getParameter("unitId"));
        String unitName = (String) wbo.getAttribute("projectName");
        wbo = new WebBusinessObject();
        wbo = projectMgr.getOnSingleKey(request.getParameter("unitCategoryId"));
        String unitCategoryName = (String) wbo.getAttribute("projectName");

        String id = UniqueIDGen.getNextID();
        params.addElement(new StringValue(id));
        params.addElement(new StringValue(request.getParameter("clientId")));
        params.addElement(new StringValue(request.getParameter("unitId")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue("reserved"));
        params.addElement(new StringValue(request.getParameter("unitCategoryId")));
        params.addElement(new StringValue(request.getParameter("budget")));
        params.addElement(new StringValue(request.getParameter("period")));
        params.addElement(new StringValue(request.getParameter("paymentSystem")));
        //params.addElement(new StringValue(request.getParameter("paymentPlace")));
        params.addElement(new StringValue("Fast"));
        params.addElement(new StringValue(unitName));
        params.addElement(new StringValue(unitCategoryName));
        params.addElement(new StringValue(request.getParameter("brokerID")));
        params.addElement(new StringValue(request.getParameter("reservationValue")));
        params.addElement(new StringValue(request.getParameter("contractValue")));
        params.addElement(new StringValue(request.getParameter("plotArea")));
        params.addElement(new StringValue(request.getParameter("buildingArea")));
        params.addElement(new StringValue(request.getParameter("beforeDiscount")));

//        Connection connection = null;
//            connection = dataSource.getConnection();
        try {
            beginTransaction();
//            connection.setAutoCommit(true);
            forInsert.setConnection(transConnection);
            String myQuery = getQuery("insertClientProducts").trim();
            forInsert.setSQLQuery(myQuery);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }

            params = new Vector();
            params.addElement(new StringValue((String) request.getParameter("unitId")));
            forInsert.setSQLQuery(sqlMgr.getSql("getCompStatusByUser2").trim());
            forInsert.setparams(params);
            try {
                queryResultV = forInsert.executeQuery();
            } catch (UnsupportedTypeException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            Row r = null;
            Enumeration e = queryResultV.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                
                try {
                    id = r.getString("STATUS_ID").toString();
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            if (id != null && !id.equals("")) {
                params = new Vector();
                params.addElement(new StringValue(id));
                beginTransaction();
                forInsert.setConnection(transConnection);
                forInsert.setSQLQuery(sqlMgr.getSql("updateStatusByUser").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                if (queryResult < 0) {
                    transConnection.rollback();
                    return null;
                }
                
                try {
                    Thread.sleep(50);
                } catch (InterruptedException ex) {
                    Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
                } finally {
                    endTransaction();
                }
            }

            params = new Vector();
            String issueStatusId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(issueStatusId));
            params.addElement(new StringValue("9"));
            params.addElement(new StringValue((String) request.getParameter("period")));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue((String) request.getParameter("unitId")));
            params.addElement(new StringValue("Housing_Units"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue((String) waUser.getAttribute("userId")));
//            params.addElement(new StringValue(" "));
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }

            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                endTransaction();
            }

            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            transConnection.rollback();
            return null;
//
        } finally {

            endTransaction();
        }
        
        return id;
    }
    
    
    public boolean updateParentOfProject(WebBusinessObject wbo) throws NoUserInSessionException {
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue((String) wbo.getAttribute("mainProjectId")));
        params.addElement(new StringValue((String) wbo.getAttribute("projectID")));
        try {
            beginTransaction();
            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(getQuery("updateParentOfProject").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

            cashData();
            endTransaction();
        } catch (SQLException se) {
            logger.error("Exception updating project: " + se.getMessage());
            return false;
        }

        return (queryResult > 0);
    }

    public Vector getUnitsFromProject(String type,String unitName, String departmentID, String unitTypeID, String area, String unitStatus, String unitUser) throws NoUserInSessionException {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        params.addElement(new StringValue(departmentID));
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        StringBuilder where = new StringBuilder();
        String qText="getUnitsFromProjectLike";
        if (type.equalsIgnoreCase("2")){
            qText="getSoldUnitFromProjLike";
        }
        
        if (unitTypeID != null && !unitTypeID.isEmpty()) {
            where.append("AND u.INTEGRATED_ID = '").append(unitTypeID).append("'");
        }
        
        if (unitStatus != null && !unitStatus.isEmpty()) {
            if (unitStatus.equals("10")){
            where.append("AND STATUS_NAME = '").append(unitStatus).append("' AND i.created_by = '").append(unitUser).append("'");
            }else {
            where.append("AND STATUS_NAME = '").append(unitStatus).append("'"); 
            }
       }
        
        try {
            String query = new String();
            if(unitName != null){
                query = getQuery(qText).trim().replaceAll("uuu", "AND LOWER(u.PROJECT_NAME) like '%" + unitName.toLowerCase() + "%'");
            } else {
                query = getQuery(qText).trim().replaceAll("uuu", " ");
            }
	    
	    if(area != null && !area.equals("") && !area.equals("All")){
                int check=0;
                try{

                Integer.parseInt(area);
                params.addElement(new IntValue(Integer.parseInt(area)));
                check=1;
                }catch(NumberFormatException e1){
                    //not int
                }
                //check if float
                if(check==0){
                try{
                Float.parseFloat(area);
                params.addElement(new DoubleValue(Double.valueOf(area)));

                }catch(NumberFormatException e1){
                    //not float
                }
                }
                query += " AND u.PROJECT_ID IN (SELECT UP.UNIT_ID FROM UNIT_PRICE UP WHERE UP.MAX_PRICE = ?) ";
	    }
	    
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query + where.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        Vector resultBusObjs = new Vector();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("NAME") != null) {
                    if(r.getString("STATUS_NAME").equalsIgnoreCase("9") || r.getString("STATUS_NAME").equalsIgnoreCase("10")){
                        wbo.setAttribute("clientName", r.getString("NAME"));
                    } else {
                        wbo.setAttribute("clientName", "");
                    }
                } else {
                    wbo.setAttribute("clientName", "");
                }
                
                if (r.getString("AGE_GROUP") != null) {
                    wbo.setAttribute("clientType", r.getString("AGE_GROUP"));
                } else {
                    wbo.setAttribute("clientType", "");
                }
                
                if (r.getString("SYS_ID") != null) {
                    wbo.setAttribute("clientId", r.getString("SYS_ID"));
                } else {
                    wbo.setAttribute("clientId", "");
                }
                
                if (r.getString("PARENT_NAME") != null) {
                    wbo.setAttribute("parentName", r.getString("PARENT_NAME"));
                } else {
                    wbo.setAttribute("parentName", "");
                }
                
                if (r.getString("MODEL_NAME") != null) {
                    wbo.setAttribute("modelName", r.getString("MODEL_NAME"));
                } else {
                    wbo.setAttribute("modelName", "");
                }if (r.getString("OPTION_THREE") != null) {
                    wbo.setAttribute("OPTION3", r.getString("OPTION_THREE"));
                }
                
                if (r.getString("STATUS_NAME") != null) {
                    wbo.setAttribute("statusName", r.getString("STATUS_NAME"));
                    if (r.getString("STATUS_NAME").equalsIgnoreCase("8")) {
                        wbo.setAttribute("statusNameStr", "متاحة");
                    } else if (r.getString("STATUS_NAME").equalsIgnoreCase("9")) {
                        wbo.setAttribute("statusNameStr", "محجوزة");
                    } else if (r.getString("STATUS_NAME").equalsIgnoreCase("10")) {
                        wbo.setAttribute("statusNameStr", "مباعة");
                    } else if (r.getString("STATUS_NAME").equalsIgnoreCase("33")) {
                        wbo.setAttribute("statusNameStr", "حجز مرتجع");
                    } else {
                        wbo.setAttribute("statusNameStr", "");
                    }
                } else {
                    wbo.setAttribute("statusName", "");
                }
                
                if (r.getString("MAIN_PROJ_ID") != null) {
                    wbo.setAttribute("mainProjId", r.getString("MAIN_PROJ_ID"));
                } else {
                    wbo.setAttribute("mainProjId", "");
                }
                
                if (r.getString("EQ_NO") != null) {
                    wbo.setAttribute("Model_Code", r.getString("EQ_NO"));
                } else {
                    wbo.setAttribute("Model_Code","");
                }
                
                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("fullName", r.getString("FULL_NAME"));
                } else {
                    wbo.setAttribute("fullName", "");
                }
                
                if (r.getString("OWNER_ID") != null) {
                    wbo.setAttribute("ownerID", r.getString("OWNER_ID"));
                } else {
                    wbo.setAttribute("ownerID", "");
                }
                
                if (r.getString("PRICE") != null) {
                    wbo.setAttribute("price", r.getString("PRICE"));
                } else {
		    wbo.setAttribute("price", "0");
		}
                
		if (r.getString("TOTAL_AREA") != null) {
                    wbo.setAttribute("totalArea", r.getString("TOTAL_AREA"));
                } else {
                    wbo.setAttribute("totalArea", "");
                }
                
		if (r.getString("AREA") != null) {
                    wbo.setAttribute("area", r.getString("AREA"));
                } else {
		     wbo.setAttribute("area", "0");
		}
                
		if (r.getString("DOC_ID") != null) {
                    wbo.setAttribute("documentID", r.getString("DOC_ID"));
                }
                wbo.setAttribute("addonPrice", r.getString("ADDON_PRICE") != null ? r.getString("ADDON_PRICE") + "" : "0");
                if (type.equalsIgnoreCase("2")){
                if (r.getString("MOBILE") != null) {
                    wbo.setAttribute("mobile", r.getString("MOBILE"));
                } else {
                    wbo.setAttribute("MOBILE", "---");
                }
                if (r.getString("EMAIL") != null) {
                    wbo.setAttribute("EMAIL", r.getString("EMAIL"));
                } else {
                    wbo.setAttribute("EMAIL", "---");
                }
                if (r.getString("KNOWUSFROM") != null) {
                    wbo.setAttribute("knowUsFrom", r.getString("KNOWUSFROM"));
                } else {
                    wbo.setAttribute("knowUsFrom", "---");
                }
                if (r.getString("timeBefPurch") != null) {
                    wbo.setAttribute("timeBefPurch", r.getString("timeBefPurch"));
                } else {
                    wbo.setAttribute("timeBefPurch", "---");
                }
                if (r.getString("clientCreTime") != null) {
                    wbo.setAttribute("clientCreTime", r.getString("clientCreTime"));
                } else {
                    wbo.setAttribute("clientCreTime", "---");
                }
                if (r.getString("purchaseTime") != null) {
                    wbo.setAttribute("purchaseTime", r.getString("purchaseTime"));
                } else {
                    wbo.setAttribute("purchaseTime", "---");
                }
                }
        
            } catch (Exception ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }
    
    public Vector getUnitsBetweenTwoDates(String beDate, String enDate, String departmentID, String unitStatus, String minArea, String maxArea) throws NoUserInSessionException {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        params.addElement(new StringValue(departmentID));
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        StringBuilder where = new StringBuilder();
        
        
        try {
            String query = new String();
            query = getQuery("getUnitsFromProjectLike").trim().replaceAll("uuu", " ");
	    
	    if(beDate != null && !beDate.equals("") && enDate != null && !enDate.equals("")){
		params.addElement(new StringValue(beDate));
                params.addElement(new StringValue(enDate));
                query += " AND TRUNC(u.CREATION_TIME) BETWEEN to_date(?,'yyyy/mm/dd') AND to_date(?,'yyyy/mm/dd') ";
	    }
            
            if (unitStatus != null && !unitStatus.isEmpty()) {
                where.append("AND STATUS_NAME = '").append(unitStatus).append("'");
            }
            if (minArea != null && !minArea.isEmpty()) {
                where.append(" AND UP.MAX_PRICE >= '").append(minArea).append("'");
            }
            if (maxArea != null && !maxArea.isEmpty()) {
                where.append(" AND UP.MAX_PRICE <= '").append(maxArea).append("'");
            }
	    
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query + where.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        Vector resultBusObjs = new Vector();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("NAME") != null) {
                    if(r.getString("STATUS_NAME").equalsIgnoreCase("9") || r.getString("STATUS_NAME").equalsIgnoreCase("10")){
                        wbo.setAttribute("clientName", r.getString("NAME"));
                    } else {
                        wbo.setAttribute("clientName", "");
                    }
                } else {
                    wbo.setAttribute("clientName", "");
                }
                
                if (r.getString("AGE_GROUP") != null) {
                    wbo.setAttribute("clientType", r.getString("AGE_GROUP"));
                } else {
                    wbo.setAttribute("clientType", "");
                }
                
                if (r.getString("SYS_ID") != null) {
                    wbo.setAttribute("clientId", r.getString("SYS_ID"));
                } else {
                    wbo.setAttribute("clientId", "");
                }
                
                if (r.getString("PARENT_NAME") != null) {
                    wbo.setAttribute("parentName", r.getString("PARENT_NAME"));
                } else {
                    wbo.setAttribute("parentName", "");
                }
                
                if (r.getString("MODEL_NAME") != null) {
                    wbo.setAttribute("modelName", r.getString("MODEL_NAME"));
                } else {
                    wbo.setAttribute("modelName", "");
                }
                
                if (r.getString("STATUS_NAME") != null) {
                    wbo.setAttribute("statusName", r.getString("STATUS_NAME"));
                    if (r.getString("STATUS_NAME").equalsIgnoreCase("8")) {
                        wbo.setAttribute("statusNameStr", "متاحة");
                    } else if (r.getString("STATUS_NAME").equalsIgnoreCase("9")) {
                        wbo.setAttribute("statusNameStr", "محجوزة");
                    } else if (r.getString("STATUS_NAME").equalsIgnoreCase("10")) {
                        wbo.setAttribute("statusNameStr", "مباعة");
                    } else if (r.getString("STATUS_NAME").equalsIgnoreCase("33")) {
                        wbo.setAttribute("statusNameStr", "حجز مرتجع");
                    } else {
                        wbo.setAttribute("statusNameStr", "");
                    }
                } else {
                    wbo.setAttribute("statusName", "");
                }
                
                if (r.getString("MAIN_PROJ_ID") != null) {
                    wbo.setAttribute("mainProjId", r.getString("MAIN_PROJ_ID"));
                } else {
                    wbo.setAttribute("mainProjId", "");
                }
                
                if (r.getString("EQ_NO") != null) {
                    wbo.setAttribute("Model_Code", r.getString("EQ_NO"));
                } else {
                    wbo.setAttribute("Model_Code","");
                }
                
                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("fullName", r.getString("FULL_NAME"));
                } else {
                    wbo.setAttribute("fullName", "");
                }
                
                if (r.getString("OWNER_ID") != null) {
                    wbo.setAttribute("ownerID", r.getString("OWNER_ID"));
                } else {
                    wbo.setAttribute("ownerID", "");
                }
                
                if (r.getString("PRICE") != null) {
                    wbo.setAttribute("price", r.getString("PRICE"));
                } else {
		    wbo.setAttribute("price", "0");
		}
                
		if (r.getString("TOTAL_AREA") != null) {
                    wbo.setAttribute("totalArea", r.getString("TOTAL_AREA"));
                } else {
                    wbo.setAttribute("totalArea", "");
                }
                
		if (r.getString("AREA") != null) {
                    wbo.setAttribute("area", r.getString("AREA"));
                } else {
		     wbo.setAttribute("area", "0");
		}
                
		if (r.getString("DOC_ID") != null) {
                    wbo.setAttribute("documentID", r.getString("DOC_ID"));
                }
            } catch (Exception ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }
    
    public Vector getUnitsFromProject(String unitName, String unitTypeID, String area, String unitStatus) throws NoUserInSessionException {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        StringBuilder where = new StringBuilder();
        if (unitTypeID != null && !unitTypeID.isEmpty()) {
            where.append("AND u.INTEGRATED_ID = '").append(unitTypeID).append("'");
        }
        
        if (unitStatus != null && !unitStatus.isEmpty()) {
            where.append("AND STATUS_NAME = '").append(unitStatus).append("'");
        }
        
        try {
            String query = new String();
            String q="select unique u.*,USERS.FULL_NAME ,cp.CLIENT_ID as OWNER_ID, t.NAME, t.AGE_GROUP, t.AGE_GROUP, t.SYS_ID, p.PROJECT_NAME PARENT_NAME, i.STATUS_NAME STATUS_NAME, m.PROJECT_NAME MODEL_NAME, UP.OPTION1 PRICE, UP.MAX_PRICE AREA , AD.TOTAL_AREA from PROJECT u left join CLIENT_PROJECTS cp on  u.PROJECT_ID=cp.PROJECT_ID and cp.product_id = 'main owner' left join USERS on u.CREATED_BY = USERS.USER_ID left join (SELECT CLIENT.NAME, CLIENT_PROJECTS.PROJECT_ID, CLIENT.AGE_GROUP, CLIENT.SYS_ID FROM CLIENT_PROJECTS INNER JOIN CLIENT ON CLIENT.SYS_ID = CLIENT_PROJECTS.CLIENT_ID) t on u.PROJECT_ID = t.PROJECT_ID left join PROJECT p on u.MAIN_PROJ_ID = p.PROJECT_ID left join issue_status i on u.PROJECT_ID = i.BUSINESS_OBJ_ID and i.END_DATE is null LEFT JOIN PROJECT M ON U.EQ_NO = M.PROJECT_ID LEFT JOIN UNIT_PRICE UP ON U.PROJECT_ID = UP.UNIT_ID LEFT JOIN ARCH_DETAILS AD ON M.PROJECT_ID = AD.UNIT_ID where u.LOCATION_TYPE != 'ENG-UNIT'  AND u.PROJECTFLAG = '0' and STATUS_NAME in (select APARTMENT_STATUS from APARTMENT_RULE ) AND STATUS_NAME != '28' uuu";
            if(unitName != null){
                query = q.trim().replaceAll("uuu", "AND LOWER(u.PROJECT_NAME) like '%" + unitName.toLowerCase() + "%'");
            } else {
                query = q.trim().replaceAll("uuu", " ");
            }
	    
	    if(area != null && !area.equals("") && !area.equals("All")){
		params.addElement(new IntValue(Integer.parseInt(area)));
                query += " AND u.PROJECT_ID IN (SELECT UP.UNIT_ID FROM UNIT_PRICE UP WHERE UP.MAX_PRICE = ?) ";
	    }
	    
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query + where.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        Vector resultBusObjs = new Vector();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("NAME"));
                } else {
                    wbo.setAttribute("clientName", "");
                }
                
                if (r.getString("AGE_GROUP") != null) {
                    wbo.setAttribute("clientType", r.getString("AGE_GROUP"));
                } else {
                    wbo.setAttribute("clientType", "");
                }
                
                if (r.getString("SYS_ID") != null) {
                    wbo.setAttribute("clientId", r.getString("SYS_ID"));
                } else {
                    wbo.setAttribute("clientId", "");
                }
                
                if (r.getString("PARENT_NAME") != null) {
                    wbo.setAttribute("parentName", r.getString("PARENT_NAME"));
                } else {
                    wbo.setAttribute("parentName", "");
                }
                
                if (r.getString("MODEL_NAME") != null) {
                    wbo.setAttribute("modelName", r.getString("MODEL_NAME"));
                } else {
                    wbo.setAttribute("modelName", "");
                }
                
                if (r.getString("STATUS_NAME") != null) {
                    wbo.setAttribute("statusName", r.getString("STATUS_NAME"));
                    if (r.getString("STATUS_NAME").equalsIgnoreCase("8")) {
                        wbo.setAttribute("statusNameStr", "متاحة");
                    } else if (r.getString("STATUS_NAME").equalsIgnoreCase("9")) {
                        wbo.setAttribute("statusNameStr", "محجوزة");
                    } else if (r.getString("STATUS_NAME").equalsIgnoreCase("10")) {
                        wbo.setAttribute("statusNameStr", "مباعة");
                    } else if (r.getString("STATUS_NAME").equalsIgnoreCase("33")) {
                        wbo.setAttribute("statusNameStr", "حجز مرتجع");
                    } else {
                        wbo.setAttribute("statusNameStr", "");
                    }
                } else {
                    wbo.setAttribute("statusName", "");
                }
                
                if (r.getString("MAIN_PROJ_ID") != null) {
                    wbo.setAttribute("mainProjId", r.getString("MAIN_PROJ_ID"));
                } else {
                    wbo.setAttribute("mainProjId", "");
                }
                
                if (r.getString("EQ_NO") != null) {
                    wbo.setAttribute("Model_Code", r.getString("EQ_NO"));
                } else {
                    wbo.setAttribute("Model_Code","");
                }
                
                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("fullName", r.getString("FULL_NAME"));
                } else {
                    wbo.setAttribute("fullName", "");
                }
                
                if (r.getString("OWNER_ID") != null) {
                    wbo.setAttribute("ownerID", r.getString("OWNER_ID"));
                } else {
                    wbo.setAttribute("ownerID", "");
                }
                
                if (r.getString("PRICE") != null) {
                    wbo.setAttribute("price", r.getString("PRICE"));
                } else {
		    wbo.setAttribute("price", "0");
		}
                
		if (r.getString("TOTAL_AREA") != null) {
                    wbo.setAttribute("totalArea", r.getString("TOTAL_AREA"));
                } else {
                    wbo.setAttribute("totalArea", "");
                }
                
		if (r.getString("AREA") != null) {
                    wbo.setAttribute("area", r.getString("AREA"));
                } else {
		     wbo.setAttribute("area", "0");
		}
            } catch (Exception ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public Vector getUnitsForProjects(String type,String unitName, String departmentID, String[] projectID, String unitTypeID, String area, String unitStatus) throws NoUserInSessionException {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        params.addElement(new StringValue(departmentID));

        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        StringBuilder where = new StringBuilder();
        String qText="getUnitsFromProjectLike";
        if (type.equalsIgnoreCase("2")){
            qText="getSoldUnitFromProjLike";
        }
        if (unitTypeID != null && !unitTypeID.isEmpty()) {
            where.append("AND u.INTEGRATED_ID = '").append(unitTypeID).append("'");
        }

        if (unitStatus != null && !unitStatus.isEmpty()) {
            where.append("AND STATUS_NAME = '").append(unitStatus).append("'");
        }
        
        try {
            String query = new String();
            if(unitName != null && !unitName.equals("") && !unitName.equals(" ") && !unitName.equals("null")){
                query = getQuery(qText).trim().replaceAll("uuu", "AND LOWER(u.PROJECT_NAME) like '%" + unitName.toLowerCase() + "%'");
            } else {
                query = getQuery(qText).trim().replaceAll("uuu", " ");
            }
            
            query += "and(";
            params.addElement(new StringValue(projectID[0]));
            query += "(u.MAIN_PROJ_ID = ?)";
            for (int i = 1; i < projectID.length; i++) {
                params.addElement(new StringValue(projectID[i]));
                query += "OR (u.MAIN_PROJ_ID = ?)";
            }
            
            query += ")";
	    
	    if(area != null && !area.equals("") && !area.equals("All")){
                  int check=0;
                try{

                Integer.parseInt(area);
                params.addElement(new IntValue(Integer.parseInt(area)));
                check=1;
                }catch(NumberFormatException e1){
                    //not int
                }
                //check if float
                if(check==0){
                try{
                Float.parseFloat(area);
                params.addElement(new DoubleValue(Double.valueOf(area)));

                }catch(NumberFormatException e1){
                    //not float
                }
                }
                query += " AND u.PROJECT_ID IN (SELECT UP.UNIT_ID FROM UNIT_PRICE UP WHERE UP.MAX_PRICE = ?) ";
	    }

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query + where.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        Vector resultBusObjs = new Vector();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("NAME"));
                } else {
                    wbo.setAttribute("clientName", "");
                }
                
                if (r.getString("AGE_GROUP") != null) {
                    wbo.setAttribute("clientType", r.getString("AGE_GROUP"));
                } else {
                    wbo.setAttribute("clientType", "");
                }
                
                if (r.getString("SYS_ID") != null) {
                    wbo.setAttribute("clientId", r.getString("SYS_ID"));
                } else {
                    wbo.setAttribute("clientId", "");
                }
                
                if (r.getString("PARENT_NAME") != null) {
                    wbo.setAttribute("parentName", r.getString("PARENT_NAME"));
                } else {
                    wbo.setAttribute("parentName", "");
                }
                
                if (r.getString("MODEL_NAME") != null) {
                    wbo.setAttribute("modelName", r.getString("MODEL_NAME"));
                } else {
                    wbo.setAttribute("modelName", "");
                }if (r.getString("OPTION_THREE") != null) {
                    wbo.setAttribute("OPTION3", r.getString("OPTION_THREE"));
                }
                
                if (r.getString("STATUS_NAME") != null) {
                    wbo.setAttribute("statusName", r.getString("STATUS_NAME"));
                    if (r.getString("STATUS_NAME").equalsIgnoreCase("8")) {
                        wbo.setAttribute("statusNameStr", "متاحة");
                    } else if (r.getString("STATUS_NAME").equalsIgnoreCase("9")) {
                        wbo.setAttribute("statusNameStr", "محجوزة");
                    } else if (r.getString("STATUS_NAME").equalsIgnoreCase("10")) {
                        wbo.setAttribute("statusNameStr", "مباعة");
                    } else if (r.getString("STATUS_NAME").equalsIgnoreCase("33")) {
                        wbo.setAttribute("statusNameStr", "حجز مرتجع");
                    } else {
                        wbo.setAttribute("statusNameStr", "");
                    }
                } else {
                    wbo.setAttribute("statusName", "");
                }
                
                if (r.getString("MAIN_PROJ_ID") != null) {
                    wbo.setAttribute("mainProjId", r.getString("MAIN_PROJ_ID")); 
                } else {
                    wbo.setAttribute("mainProjId", ""); 
                }
                
                if (r.getString("EQ_NO") != null) {
                    wbo.setAttribute("Model_Code", r.getString("EQ_NO"));
                } else {
                    wbo.setAttribute("Model_Code", "");
                }
                
                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("fullName", r.getString("FULL_NAME"));
                } else {
                    wbo.setAttribute("fullName", "");
                }
                
                if (r.getString("OWNER_ID") != null) {
                    wbo.setAttribute("ownerID", r.getString("OWNER_ID"));
                } else {
                    wbo.setAttribute("ownerID", "");
                }
                
                if (r.getString("AREA") != null) {
                    wbo.setAttribute("area", r.getString("AREA"));
                } else {
                    wbo.setAttribute("area", "");
                }
                
                if (r.getString("PRICE") != null) {
                    wbo.setAttribute("price", r.getString("PRICE"));
                } else {
                    wbo.setAttribute("price", "");
                }
		if (r.getString("DOC_ID") != null) {
                    wbo.setAttribute("documentID", r.getString("DOC_ID"));
                }
                wbo.setAttribute("addonPrice", r.getString("ADDON_PRICE") != null ? r.getString("ADDON_PRICE") + "" : "0");
                
                if (r.getString("UNIT_NOTE") != null) {
                    wbo.setAttribute("unitNote", r.getString("UNIT_NOTE"));
                } else {
                    wbo.setAttribute("unitNote", "---");
                }
                if (type.equalsIgnoreCase("2")){
                if (r.getString("MOBILE") != null) {
                    wbo.setAttribute("mobile", r.getString("MOBILE"));
                } else {
                    wbo.setAttribute("MOBILE", "---");
                }
                if (r.getString("EMAIL") != null) {
                    wbo.setAttribute("EMAIL", r.getString("EMAIL"));
                } else {
                    wbo.setAttribute("EMAIL", "---");
                }
                if (r.getString("KNOWUSFROM") != null) {
                    wbo.setAttribute("knowUsFrom", r.getString("KNOWUSFROM"));
                } else {
                    wbo.setAttribute("knowUsFrom", "---");
                }
                if (r.getString("timeBefPurch") != null) {
                    wbo.setAttribute("timeBefPurch", r.getString("timeBefPurch"));
                } else {
                    wbo.setAttribute("timeBefPurch", "---");
                }
                if (r.getString("clientCreTime") != null) {
                    wbo.setAttribute("clientCreTime", r.getString("clientCreTime"));
                } else {
                    wbo.setAttribute("clientCreTime", "---");
                }
                if (r.getString("purchaseTime") != null) {
                    wbo.setAttribute("purchaseTime", r.getString("purchaseTime"));
                } else {
                    wbo.setAttribute("purchaseTime", "---");
                }
                }
            } catch (Exception ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }
    
    
    
    public Vector getUnitsForSpecificProject(String[] projectID) throws NoUserInSessionException {
        Vector queryResult = new Vector();
        Vector params = new Vector();

        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        StringBuilder where = new StringBuilder();
        
        
        try {
            String query = new String();
            query = getQuery("getUnitsForSpecificProject").trim().replaceAll("uuu", " ");
            query += "and ";
            params.addElement(new StringValue(projectID[0]));
            query += "u.MAIN_PROJ_ID = ?";
            
            
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query + where.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        Vector resultBusObjs = new Vector();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("NAME"));
                } else {
                    wbo.setAttribute("clientName", "");
                }
                
                if (r.getString("AGE_GROUP") != null) {
                    wbo.setAttribute("clientType", r.getString("AGE_GROUP"));
                } else {
                    wbo.setAttribute("clientType", "");
                }
                
                if (r.getString("SYS_ID") != null) {
                    wbo.setAttribute("clientId", r.getString("SYS_ID"));
                } else {
                    wbo.setAttribute("clientId", "");
                }
                
                if (r.getString("PARENT_NAME") != null) {
                    wbo.setAttribute("parentName", r.getString("PARENT_NAME"));
                } else {
                    wbo.setAttribute("parentName", "");
                }
                
                if (r.getString("MODEL_NAME") != null) {
                    wbo.setAttribute("modelName", r.getString("MODEL_NAME"));
                } else {
                    wbo.setAttribute("modelName", "");
                }
                
                if (r.getString("STATUS_NAME") != null) {
                    wbo.setAttribute("statusName", r.getString("STATUS_NAME"));
                    if (r.getString("STATUS_NAME").equalsIgnoreCase("8")) {
                        wbo.setAttribute("statusNameStr", "متاحة");
                    } else if (r.getString("STATUS_NAME").equalsIgnoreCase("9")) {
                        wbo.setAttribute("statusNameStr", "محجوزة");
                    } else if (r.getString("STATUS_NAME").equalsIgnoreCase("10")) {
                        wbo.setAttribute("statusNameStr", "مباعة");
                    } else if (r.getString("STATUS_NAME").equalsIgnoreCase("33")) {
                        wbo.setAttribute("statusNameStr", "حجز مرتجع");
                    } else {
                        wbo.setAttribute("statusNameStr", "");
                    }
                } else {
                    wbo.setAttribute("statusName", "");
                }
                
                if (r.getString("MAIN_PROJ_ID") != null) {
                    wbo.setAttribute("mainProjId", r.getString("MAIN_PROJ_ID")); 
                } else {
                    wbo.setAttribute("mainProjId", ""); 
                }
                
                if (r.getString("EQ_NO") != null) {
                    wbo.setAttribute("Model_Code", r.getString("EQ_NO"));
                } else {
                    wbo.setAttribute("Model_Code", "");
                }
                
                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("fullName", r.getString("FULL_NAME"));
                } else {
                    wbo.setAttribute("fullName", "");
                }
                
                if (r.getString("OWNER_ID") != null) {
                    wbo.setAttribute("ownerID", r.getString("OWNER_ID"));
                } else {
                    wbo.setAttribute("ownerID", "");
                }
                
                if (r.getString("AREA") != null) {
                    wbo.setAttribute("area", r.getString("AREA"));
                } else {
                    wbo.setAttribute("area", "");
                }
                
                if (r.getString("PRICE") != null) {
                    wbo.setAttribute("price", r.getString("PRICE"));
                } else {
                    wbo.setAttribute("price", "0");
                }
		if (r.getString("DOC_ID") != null) {
                    wbo.setAttribute("documentID", r.getString("DOC_ID"));
                }
            } catch (Exception ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }
   public Vector getAllUnitsFromProject(String departmentID, String unitStatus ) throws NoUserInSessionException {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        params.addElement(new StringValue(departmentID));
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        StringBuilder where = new StringBuilder();
        
        if (unitStatus != null && !unitStatus.isEmpty()) {
            where.append("AND STATUS_NAME = '").append(unitStatus).append("'");
        }
        
        try {
            String query = getQuery("getUnitsFromProject").trim() + where.toString();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        Vector resultBusObjs = new Vector();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("NAME") != null) {
                    if(r.getString("STATUS_NAME").equalsIgnoreCase("9") || r.getString("STATUS_NAME").equalsIgnoreCase("10") || r.getString("STATUS_NAME").equalsIgnoreCase("61")){
                        wbo.setAttribute("clientName", r.getString("NAME"));
                    } else {
                        wbo.setAttribute("clientName", "");
                    }
                }
                
                if (r.getString("AGE_GROUP") != null) {
                    wbo.setAttribute("clientType", r.getString("AGE_GROUP"));
                }
                
                if (r.getString("SYS_ID") != null) {
                    wbo.setAttribute("clientId", r.getString("SYS_ID"));
                }
                
                if (r.getString("PARENT_NAME") != null) {
                    wbo.setAttribute("parentName", r.getString("PARENT_NAME"));
                }
                
                if (r.getString("STATUS_NAME") != null) {
                    wbo.setAttribute("statusName", r.getString("STATUS_NAME"));
                }
                
                if (r.getString("MAIN_PROJ_ID") != null) {
                    wbo.setAttribute("mainProjId", r.getString("MAIN_PROJ_ID"));
                }
                
                if (r.getString("EQ_NO") != null) {
                    wbo.setAttribute("Model_Code", r.getString("EQ_NO"));
                }
                
                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("fullName", r.getString("FULL_NAME"));
                }
                
                if (r.getString("OWNER_ID") != null) {
                    wbo.setAttribute("ownerID", r.getString("OWNER_ID"));
                }
                
                if (r.getString("AREA") != null) {
                    wbo.setAttribute("area", r.getString("AREA"));
                }
                
                if (r.getString("PRICE") != null) {
                    wbo.setAttribute("price", r.getString("PRICE"));
                }
                
		if (r.getString("MODEL_NAME") != null) {
                    wbo.setAttribute("modelName", r.getString("MODEL_NAME"));
                }
		
		if (r.getString("TOTAL_AREA") != null) {
                    wbo.setAttribute("totalArea", r.getString("TOTAL_AREA"));
                }
            } catch (Exception ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }
   
    public Vector getAllUnitsFromProjectByBoker(String departmentID, String unitStatus ,String boker_id ) throws NoUserInSessionException {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        params.addElement(new StringValue(departmentID));
        params.addElement(new StringValue(boker_id));
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        StringBuilder where = new StringBuilder();
        
        if (unitStatus != null && !unitStatus.isEmpty()) {
            where.append("AND STATUS_NAME = '").append(unitStatus).append("'");
        }
        
        try {
          //  String query = "select unique u.*,USERS.FULL_NAME, cp.CLIENT_ID as OWNER_ID, t.NAME, t.AGE_GROUP, t.AGE_GROUP, t.SYS_ID, p.PROJECT_NAME PARENT_NAME, i.STATUS_NAME STATUS_NAME, m.PROJECT_NAME MODEL_NAME, UP.OPTION1 PRICE, UP.MAX_PRICE AREA, AD.TOTAL_AREA from PROJECT u left join CLIENT_PROJECTS cp on  u.PROJECT_ID=cp.PROJECT_ID and cp.product_id = 'main owner' left join USERS on u.CREATED_BY = USERS.USER_ID left join (SELECT CLIENT.NAME, CLIENT_PROJECTS.PROJECT_ID, CLIENT.AGE_GROUP, CLIENT.SYS_ID FROM CLIENT_PROJECTS INNER JOIN CLIENT ON CLIENT.SYS_ID = CLIENT_PROJECTS.CLIENT_ID) t on u.PROJECT_ID = t.PROJECT_ID left join PROJECT p on u.MAIN_PROJ_ID = p.PROJECT_ID left join issue_status i on u.PROJECT_ID = i.BUSINESS_OBJ_ID and i.END_DATE is null LEFT JOIN PROJECT M ON U.EQ_NO = M.PROJECT_ID LEFT JOIN UNIT_PRICE UP ON U.PROJECT_ID = UP.UNIT_ID LEFT JOIN ARCH_DETAILS AD ON M.PROJECT_ID = AD.UNIT_ID LEFT JOIN RESERVATION on t.SYS_ID = RESERVATION.CLIENT_ID  where u.LOCATION_TYPE != 'ENG-UNIT' and u.PROJECTFLAG = '0' and STATUS_NAME in (select APARTMENT_STATUS from APARTMENT_RULE where DEPARTMENT_ID = '1472297193074') AND RESERVATION.OPTION1 ='31751' ";
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery("select unique u.*,USERS.FULL_NAME, cp.CLIENT_ID as OWNER_ID, t.NAME, t.AGE_GROUP, t.AGE_GROUP, t.SYS_ID, p.PROJECT_NAME PARENT_NAME, i.STATUS_NAME STATUS_NAME, m.PROJECT_NAME MODEL_NAME, UP.OPTION1 PRICE, UP.MAX_PRICE AREA, AD.TOTAL_AREA from PROJECT u left join CLIENT_PROJECTS cp on  u.PROJECT_ID=cp.PROJECT_ID and cp.product_id = 'main owner' left join USERS on u.CREATED_BY = USERS.USER_ID left join (SELECT CLIENT.NAME, CLIENT_PROJECTS.PROJECT_ID, CLIENT.AGE_GROUP, CLIENT.SYS_ID FROM CLIENT_PROJECTS INNER JOIN CLIENT ON CLIENT.SYS_ID = CLIENT_PROJECTS.CLIENT_ID) t on u.PROJECT_ID = t.PROJECT_ID left join PROJECT p on u.MAIN_PROJ_ID = p.PROJECT_ID left join issue_status i on u.PROJECT_ID = i.BUSINESS_OBJ_ID and i.END_DATE is null LEFT JOIN PROJECT M ON U.EQ_NO = M.PROJECT_ID LEFT JOIN UNIT_PRICE UP ON U.PROJECT_ID = UP.UNIT_ID LEFT JOIN ARCH_DETAILS AD ON M.PROJECT_ID = AD.UNIT_ID LEFT JOIN RESERVATION on t.SYS_ID = RESERVATION.CLIENT_ID  where u.LOCATION_TYPE != 'ENG-UNIT' and u.PROJECTFLAG = '0' and STATUS_NAME in (select APARTMENT_STATUS from APARTMENT_RULE where DEPARTMENT_ID = ?) AND RESERVATION.OPTION1 = ? ");
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        Vector resultBusObjs = new Vector();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("NAME") != null) {
                    if(r.getString("STATUS_NAME").equalsIgnoreCase("9") || r.getString("STATUS_NAME").equalsIgnoreCase("10") || r.getString("STATUS_NAME").equalsIgnoreCase("61")){
                        wbo.setAttribute("clientName", r.getString("NAME"));
                    } else {
                        wbo.setAttribute("clientName", "");
                    }
                }
                
                if (r.getString("AGE_GROUP") != null) {
                    wbo.setAttribute("clientType", r.getString("AGE_GROUP"));
                }
                
                if (r.getString("SYS_ID") != null) {
                    wbo.setAttribute("clientId", r.getString("SYS_ID"));
                }
                
                if (r.getString("PARENT_NAME") != null) {
                    wbo.setAttribute("parentName", r.getString("PARENT_NAME"));
                }
                
                if (r.getString("STATUS_NAME") != null) {
                    wbo.setAttribute("statusName", r.getString("STATUS_NAME"));
                }
                
                if (r.getString("MAIN_PROJ_ID") != null) {
                    wbo.setAttribute("mainProjId", r.getString("MAIN_PROJ_ID"));
                }
                
                if (r.getString("EQ_NO") != null) {
                    wbo.setAttribute("Model_Code", r.getString("EQ_NO"));
                }
                
                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("fullName", r.getString("FULL_NAME"));
                }
                
                if (r.getString("OWNER_ID") != null) {
                    wbo.setAttribute("ownerID", r.getString("OWNER_ID"));
                }
                
                if (r.getString("AREA") != null) {
                    wbo.setAttribute("area", r.getString("AREA"));
                }
                
                if (r.getString("PRICE") != null) {
                    wbo.setAttribute("price", r.getString("PRICE"));
                }
                
		if (r.getString("MODEL_NAME") != null) {
                    wbo.setAttribute("modelName", r.getString("MODEL_NAME"));
                }
		
		if (r.getString("TOTAL_AREA") != null) {
                    wbo.setAttribute("totalArea", r.getString("TOTAL_AREA"));
                }
            } catch (Exception ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public Vector getAllUnitsForProjects(String departmentID, String[] projectID) throws NoUserInSessionException {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        params.addElement(new StringValue(departmentID));
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        String projectIDStr = "\'";
        try {
            String query = getQuery("getUnitsFromProject").trim();
            if (projectID.length > 0) {
                projectIDStr += projectID[0];
                for (int i = 1; i < projectID.length; i++) {
                    projectIDStr += "\', \'" + projectID[i];
                }
                
                projectIDStr += "\'";
                query += " and (u.MAIN_PROJ_ID IN (" + projectIDStr + ")";
                query += " or u.COORDINATE IN (" + projectIDStr + "))";
            }
            
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        Vector resultBusObjs = new Vector();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("NAME"));
                }
                
                if (r.getString("AGE_GROUP") != null) {
                    wbo.setAttribute("clientType", r.getString("AGE_GROUP"));
                }
                
                if (r.getString("SYS_ID") != null) {
                    wbo.setAttribute("clientId", r.getString("SYS_ID"));
                }
                
                if (r.getString("PARENT_NAME") != null) {
                    wbo.setAttribute("parentName", r.getString("PARENT_NAME"));
                }
                
                if (r.getString("STATUS_NAME") != null) {
                    wbo.setAttribute("statusName", r.getString("STATUS_NAME"));
                }
                
                if (r.getString("MAIN_PROJ_ID") != null) {
                    wbo.setAttribute("mainProjId", r.getString("MAIN_PROJ_ID"));
                }
                
                if (r.getString("EQ_NO") != null) {
                    wbo.setAttribute("Model_Code", r.getString("EQ_NO"));
                }
                
                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("fullName", r.getString("FULL_NAME"));
                }
            } catch (Exception ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public Vector getRealProject() {
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        try {
            String query = getQuery("getRealProject").trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("***** " + ex.getMessage());
            }
        }
        
        Vector resultBusObjs = new Vector();
        Row row;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            resultBusObjs.add(fabricateBusObj(row));
        }
        
        return resultBusObjs;
    }

    public WebBusinessObject getManagerByEmployee(String employeeId) {
        Vector queryResult = new Vector();
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();

        parameters.addElement(new StringValue(employeeId));
        try {
            String query = getQuery("getManagerByEmployee").trim();
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(query);
            queryResult = command.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("***** " + ex.getMessage());
            }
        }

        Row row;
        WebBusinessObject wbo = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            wbo = fabricateBusObj(row);
            break;
        }
        
        return wbo;
    }

    public List<WebBusinessObject> getProjectsByMainProject(String mainProjectId, String locationType) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result = new Vector();

        parameters.addElement(new StringValue(mainProjectId));
        parameters.addElement(new StringValue(locationType));
        try {
            String query = getQuery("getSubProjectsByMainProject").trim();
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(query);
            result = command.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("***** " + ex.getMessage());
            }
        }

        List<WebBusinessObject> list = new ArrayList<WebBusinessObject>();
        for (Row row : result) {
            list.add(fabricateBusObj(row));
        }
        
        return list;
    }

    public List<WebBusinessObject> getCallResultsProjects() {
        return getProjectsByMainProject(CRMConstants.PROJECT_CALL_RESULTS_ID, CRMConstants.PROJECT_CALL_RESULTS_LOCATION_TYPE);
    }

    public List<WebBusinessObject> getMeetingProjects() {
        return getProjectsByMainProject(CRMConstants.PROJECT_METTING_ID, CRMConstants.PROJECT_METTING_LOCATION_TYPE);
    }

    public String getManagerByDepartment(String departmentId) {
        Vector queryResult = new Vector();
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();

        parameters.addElement(new StringValue(departmentId));
        try {
            String query = getQuery("getManagerByDepartment").trim();
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(query);
            queryResult = command.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("***** " + ex.getMessage());
            }
        }

        String managerId = null;
        Row row;
        if (!queryResult.isEmpty()) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                try {
                    managerId = row.getString("OPTION_ONE");
                } catch (NoSuchColumnException ex) {
                    logger.error("***** " + ex.getMessage());
                }
                
                break;
            }
        }
        
        return managerId;
    }

    public String getManagerOfQualityManagementDepartment() {
        return getManagerByDepartment(CRMConstants.DEPARTMENT_QUALITY_MANAGEMENT_ID);
    }

    public String getManagerOfProjectManagerDepartment() {
        return getManagerByDepartment(CRMConstants.DEPARTMENT_PROJECT_MANAGER_ID);
    }

    public String getManagerOfSalesDepartment() {
        return getManagerByDepartment(CRMConstants.DEPARTMENT_SALES_ID);
    }

    public String getManagerOfFinancesDepartment() {
        return getManagerByDepartment(CRMConstants.DEPARTMENT_FINANCES_ID);
    }

    public Vector getUnitsWithParentName(String parentName, String departmentID, String unitTypeID, String unitStatus) throws NoUserInSessionException {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        params.addElement(new StringValue(departmentID));
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        StringBuilder where = new StringBuilder();
        if (unitTypeID != null && !unitTypeID.isEmpty()) {
            where.append("AND u.INTEGRATED_ID = '").append(unitTypeID).append("'");
        }

        if (unitStatus != null && !unitStatus.isEmpty()) {
            where.append("AND STATUS_NAME = '").append(unitStatus).append("'");
        }
        
        try {
            String query = getQuery("getUnitsWithParentLike").trim().replaceAll("uuu", parentName);
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query + where.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        Vector resultBusObjs = new Vector();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("NAME"));
                } else {
                    wbo.setAttribute("clientName", "");
                }
                
                if (r.getString("AGE_GROUP") != null) {
                    wbo.setAttribute("clientType", r.getString("AGE_GROUP"));
                } else {
                    wbo.setAttribute("clientType", "");
                }
                
                if (r.getString("SYS_ID") != null) {
                    wbo.setAttribute("clientId", r.getString("SYS_ID"));
                } else {
                    wbo.setAttribute("clientId", "");
                }
                
                if (r.getString("PARENT_NAME") != null) {
                    wbo.setAttribute("parentName", r.getString("PARENT_NAME"));
                } else {
                    wbo.setAttribute("parentName", "");
                }
                
                if (r.getString("STATUS_NAME") != null) {
                    wbo.setAttribute("statusName", r.getString("STATUS_NAME"));
                    if (r.getString("STATUS_NAME").equalsIgnoreCase("8")) {
                        wbo.setAttribute("statusNameStr", "متاحة");
                    } else if (r.getString("STATUS_NAME").equalsIgnoreCase("9")) {
                        wbo.setAttribute("statusNameStr", "محجوزة");
                    } else if (r.getString("STATUS_NAME").equalsIgnoreCase("10")) {
                        wbo.setAttribute("statusNameStr", "مباعة");
                    } else if (r.getString("STATUS_NAME").equalsIgnoreCase("33")) {
                        wbo.setAttribute("statusNameStr", "حجز مرتجع");
                    } else {
                        wbo.setAttribute("statusNameStr", "");
                    }
                } else {
                    wbo.setAttribute("statusName", "");
                }
                
                if (r.getString("MAIN_PROJ_ID") != null) {
                    wbo.setAttribute("mainProjId", r.getString("MAIN_PROJ_ID"));
                } else {
                    wbo.setAttribute("mainProjId", "");
                }
                
                if (r.getString("EQ_NO") != null) {
                    wbo.setAttribute("Model_Code", r.getString("EQ_NO"));
                } else {
                    wbo.setAttribute("Model_Code", "");
                }
                
                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("fullName", r.getString("FULL_NAME"));
                } else {
                    wbo.setAttribute("fullName", "");
                }
                
		if (r.getString("MODEL_NAME") != null) {
                    wbo.setAttribute("modelName", r.getString("MODEL_NAME"));
                } else {
                    wbo.setAttribute("modelName", "");
                }
                
		if (r.getString("TOTAL_AREA") != null) {
                    wbo.setAttribute("totalArea", r.getString("TOTAL_AREA"));
                } else {
                    wbo.setAttribute("totalArea", "");
                }
            } catch (Exception ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public Vector getUnitsWithParentNameForProjs(String parentName, String departmentID, String[] projectID, String unitTypeID, String unitStatus) throws NoUserInSessionException {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        params.addElement(new StringValue(departmentID));
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        StringBuilder where = new StringBuilder();
        if (unitTypeID != null && !unitTypeID.isEmpty()) {
            where.append("AND u.INTEGRATED_ID = '").append(unitTypeID).append("'");
        }

        if (unitStatus != null && !unitStatus.isEmpty()) {
            where.append("AND STATUS_NAME = '").append(unitStatus).append("'");
        }
        
        try {
            String query = getQuery("getUnitsWithParentLike").trim().replaceAll("uuu", parentName);
            query += "and(";
            params.addElement(new StringValue(projectID[0]));
            query += "(u.MAIN_PROJ_ID = ?)";
            for (int i = 1; i < projectID.length; i++) {
                params.addElement(new StringValue(projectID[i]));
                query += "OR (u.MAIN_PROJ_ID = ?)";
            }
            
            query += ")";
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query + where.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        Vector resultBusObjs = new Vector();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("NAME"));
                } else {
                    wbo.setAttribute("clientName", "");
                }
                
                if (r.getString("AGE_GROUP") != null) {
                    wbo.setAttribute("clientType", r.getString("AGE_GROUP"));
                } else {
                    wbo.setAttribute("clientType", "");
                }
                
                if (r.getString("SYS_ID") != null) {
                    wbo.setAttribute("clientId", r.getString("SYS_ID"));
                } else {
                    wbo.setAttribute("clientId", "");
                }
                
                if (r.getString("PARENT_NAME") != null) {
                    wbo.setAttribute("parentName", r.getString("PARENT_NAME"));
                } else {
                    wbo.setAttribute("parentName", "");
                }
                
                if (r.getString("STATUS_NAME") != null) {
                    wbo.setAttribute("statusName", r.getString("STATUS_NAME"));
                    if (r.getString("STATUS_NAME").equalsIgnoreCase("8")) {
                        wbo.setAttribute("statusNameStr", "متاحة");
                    } else if (r.getString("STATUS_NAME").equalsIgnoreCase("9")) {
                        wbo.setAttribute("statusNameStr", "محجوزة");
                    } else if (r.getString("STATUS_NAME").equalsIgnoreCase("10")) {
                        wbo.setAttribute("statusNameStr", "مباعة");
                    } else if (r.getString("STATUS_NAME").equalsIgnoreCase("33")) {
                        wbo.setAttribute("statusNameStr", "حجز مرتجع");
                    } else {
                        wbo.setAttribute("statusNameStr", "");
                    }
                } else {
                    wbo.setAttribute("statusName", "");
                }
                
                if (r.getString("MAIN_PROJ_ID") != null) {
                    wbo.setAttribute("mainProjId", r.getString("MAIN_PROJ_ID"));
                } else {
                    wbo.setAttribute("mainProjId", "");
                }
                
                if (r.getString("EQ_NO") != null) {
                    wbo.setAttribute("Model_Code", r.getString("EQ_NO"));
                } else {
                    wbo.setAttribute("Model_Code", "");
                }
                
                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("fullName", r.getString("Full_name"));
                } else {
                    wbo.setAttribute("fullName", "");
                }
            } catch (Exception ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public String getProjectCode(String projectId) {
        return getByKeyColumnValue(projectId, "key3");
    }

    public String getProjectCodeByManager(String managerId) {
        return getByKeyColumnValue("key5", managerId, "key3");
    }

    public boolean isManager(String managerId) {
        return getByKeyColumnValue("key5", managerId, "key3") != null;
    }

    public String saveBuilding(WebBusinessObject project, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        //WebBusinessObject project = (WebBusinessObject) wbo;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String unitId = UniqueIDGen.getNextID();
        s.setAttribute("projId", unitId);
        //params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(unitId));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.PROJECT_NAME)));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.EQ_NO)));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.PROJECT_DESC)));

        String mainProjectId = null;
        try {
            mainProjectId = project.getAttribute("mainProjectId").toString();
        } catch (NullPointerException e) {
            mainProjectId = "0";
        }
        
        params.addElement(new StringValue(mainProjectId));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.LOCATION_TYPE)));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.FUTILE)));
//        params.addElement(new StringValue(project.getAttribute("coordinate").toString()));
        params.addElement(new StringValue("UL"));
//        params.addElement(new StringValue(project.getAttribute("option_one").toString()));
        params.addElement(new StringValue((String) project.getAttribute("option_one")));
//        params.addElement(new StringValue(project.getAttribute("option_two").toString()));
        params.addElement(new StringValue((String) project.getAttribute("option_two")));
//        params.addElement(new StringValue(project.getAttribute("option_three").toString()));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.IS_TRNSPRT_STN)));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.IS_MNGMNT_STN)));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertBuilding").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            //
            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }
            
            cashData();

            params = new Vector();

            String issueStatusId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(issueStatusId));
            // 1 mean received from Issue // 2 mean sent from complaint //
            params.addElement(new StringValue("8"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue(unitId));//clientCompId--business-comp-id
            params.addElement(new StringValue("Housing_Units"));
            params.addElement(new StringValue("0"));//issueId--parent id
            params.addElement(new StringValue((String) waUser.getAttribute("userId")));

            forInsert.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return null;
        } finally {
            endTransaction();
        }

        return unitId;
    }

    public boolean saveAppartment(WebBusinessObject project, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        //WebBusinessObject project = (WebBusinessObject) wbo;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String unitId = UniqueIDGen.getNextID();
        s.setAttribute("projId", unitId);
        //params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(unitId));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.PROJECT_NAME)));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.EQ_NO)));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.PROJECT_DESC)));

        String mainProjectId = null;
        try {
            mainProjectId = project.getAttribute("mainProjectId").toString();
        } catch (NullPointerException e) {
            mainProjectId = "0";
        }
        
        params.addElement(new StringValue(mainProjectId));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.LOCATION_TYPE)));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.FUTILE)));
//        params.addElement(new StringValue(project.getAttribute("coordinate").toString()));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.COORDINATE)));
//        params.addElement(new StringValue(project.getAttribute("option_one").toString()));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue("UL"));
//        params.addElement(new StringValue(project.getAttribute("option_two").toString()));
        params.addElement(new StringValue((String) project.getAttribute("option_three")));
//        params.addElement(new StringValue(project.getAttribute("option_three").toString()));

        params.addElement(new StringValue("0"));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue((String) project.getAttribute("unitTypeID")));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertUnit").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            //
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
            
            String unitPriceID = UniqueIDGen.getNextID();
            params = new Vector();
            params.addElement(new StringValue(unitPriceID));
            params.addElement(new StringValue(unitId));
            params.addElement(new StringValue(project.getAttribute("unitArea") != null ? (String) project.getAttribute("unitArea") : "0"));
            params.addElement(new StringValue((String) waUser.getAttribute("userId")));
            params.addElement(new StringValue(project.getAttribute("unitPrice") != null ? (String) project.getAttribute("unitPrice") : "0"));
            
            forInsert.setSQLQuery(getQuery("insertUnitPrice").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            //
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
            
//            cashData();

            params = new Vector();

            String issueStatusId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(issueStatusId));
            // 1 mean received from Issue // 2 mean sent from complaint //
            params.addElement(new StringValue("8"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue(unitId));//clientCompId--business-comp-id
            params.addElement(new StringValue("Housing_Units"));
            params.addElement(new StringValue("0"));//issueId--parent id
            params.addElement(new StringValue((String) waUser.getAttribute("userId")));

            forInsert.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();
        }

        return (queryResult > 0);
    }

    public boolean deleteBuilding(String id) {
        ArrayList<WebBusinessObject> childNode = new ArrayList<WebBusinessObject>();
        WebBusinessObject childWbo;
        ArrayList<WebBusinessObject> childIdAndParent = new ArrayList<WebBusinessObject>();
        boolean isDeleted = false;
        try {
            isDeleted = projectMgr.deleteOnSingleKey(id);
            childNode = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle(id, "key2"));
            if (childNode.size() > 0) {
                for (int j = 0; j < childNode.size(); j++) {
                    childWbo = (WebBusinessObject) childNode.get(j);
                    isDeleted = projectMgr.deleteOnSingleKey(childWbo.getAttribute("projectID").toString());
                    childWbo = (WebBusinessObject) childNode.get(j);
                    childIdAndParent.add(j, childWbo);
                }
                
                for (WebBusinessObject wboTemp : childIdAndParent) {
                    deleteBuilding(wboTemp.getAttribute("projectID").toString());
                }
            }
        } catch (Exception exc) {}
        
        return isDeleted;
    }

    public ArrayList<WebBusinessObject> getUnitsStatusByParent(String parentID, String departmentID) throws NoUserInSessionException {
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        Vector params = new Vector();

        params.addElement(new StringValue(parentID));
        String[] statusTitles = new String[5];
        statusTitles[0] = "8";
        statusTitles[1] = "9";
        statusTitles[2] = "10";
        statusTitles[3] = "28";
        statusTitles[4] = "33";
        StringBuilder statusQuery = new StringBuilder(" and  i.STATUS_NAME in (");
        int i = 0;
        for (String statusTitle : statusTitles) {
            statusQuery.append("select MAX(DECODE(apartment_status,'").append(statusTitle).append("','").append(statusTitle).append("')) as apartment_status ");
            statusQuery.append("from apartment_rule where department_id = '").append(departmentID).append("'");
            if (i < statusTitles.length - 1) {
                statusQuery.append(" union ");
            }
            i++;
        }
        
        statusQuery.append(")");
        try {
            String query = getQuery("getUnitsStatusByParent").replace("filter_by_rules", statusQuery.toString()).trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("STATUS_NAME") != null) {
                    wbo.setAttribute("statusName", r.getString("STATUS_NAME"));
                }
                
                if (r.getTimestamp("PRICE_DATE") != null) {
                    wbo.setAttribute("priceDate", r.getString("PRICE_DATE"));
                }
                
                if (r.getBigDecimal("MAX_PRICE") != null) {
                    wbo.setAttribute("maxPrice", r.getBigDecimal("MAX_PRICE"));
                }
                
                if (r.getBigDecimal("MIN_PRICE") != null) {
                    wbo.setAttribute("minPrice", r.getBigDecimal("MIN_PRICE"));
                }
                
                if (r.getString("TOTAL_PRICE") != null) {
                    wbo.setAttribute("totalPrice", r.getString("TOTAL_PRICE"));
                }
            } catch (Exception ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public boolean updateUnitModel(String modelId, String unitId) throws NoUserInSessionException {
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(modelId));
        params.addElement(new StringValue(unitId));
        try {
            beginTransaction();
            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(getQuery("updateUnitModel").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

            cashData();
            endTransaction();
        } catch (SQLException se) {
            logger.error("Exception updating unit model: " + se.getMessage());
            return false;
        }

        return (queryResult > 0);
    }

    public ArrayList<WebBusinessObject> getReservedUnits() throws NoUserInSessionException {
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        try {
            String query = getQuery("getReservedUnits").trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("PROJECT_ID") != null) {
                    wbo.setAttribute("projectID", r.getString("PROJECT_ID"));
                }
                
                if (r.getString("PROJECT_NAME") != null) {
                    wbo.setAttribute("unitCode", r.getString("PROJECT_NAME"));
                }
                
                if (r.getString("MAIN_PROJ_ID") != null) {
                    wbo.setAttribute("parentID", r.getString("MAIN_PROJ_ID"));
                }
                
                if (r.getString("NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("NAME"));
                }
                
                if (r.getString("CLIENT_ID") != null) {
                    wbo.setAttribute("clientID", r.getString("CLIENT_ID"));
                }
                
                if (r.getString("CREATED_BY") != null) {
                    wbo.setAttribute("createdByID", r.getString("CREATED_BY"));
                }
                
                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("createdByName", r.getString("FULL_NAME"));
                }
                
                if (r.getString("BUDGET") != null) {
                    wbo.setAttribute("budget", r.getString("BUDGET"));
                }
                
                if (r.getString("PERIOD") != null) {
                    wbo.setAttribute("period", r.getString("PERIOD"));
                }
                
                if (r.getString("NOTE") != null) {
                    wbo.setAttribute("paymentPlace", r.getString("NOTE"));
                }
                
                if (r.getString("AGE_GROUP") != null) {
                    wbo.setAttribute("age", r.getString("AGE_GROUP"));
                }
                
                if (r.getString("CREATION_TIME") != null) {
                    wbo.setAttribute("creationTime", r.getString("CREATION_TIME"));
                }
            } catch (Exception ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getReservedUnitsByUnitCodeAndClientCode(String unitCode, String clientCode) {
        Vector params = new Vector();
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        try {
            params.addElement(new StringValue(unitCode));
            params.addElement(new StringValue(clientCode));
            String query = getQuery("getReservedUnitsByClientAndUnit").trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(params);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("PROJECT_NAME") != null) {
                    wbo.setAttribute("unitCode", r.getString("PROJECT_NAME"));
                }
                
                if (r.getString("NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("NAME"));
                }
                
                if (r.getString("ADDRESS") != null) {
                    wbo.setAttribute("address", r.getString("ADDRESS"));
                }
                
                if (r.getString("BUDGET") != null) {
                    wbo.setAttribute("budget", r.getString("BUDGET"));
                }
                
                if (r.getString("PERIOD") != null) {
                    wbo.setAttribute("period", r.getString("PERIOD"));
                }
                
                if (r.getString("NOTE") != null) {
                    wbo.setAttribute("paymentPlace", r.getString("NOTE"));
                }
                
                if (r.getString("JOB") != null) {
                    wbo.setAttribute("job", r.getString("JOB"));
                }
                
                if (r.getString("PHONE") != null) {
                    wbo.setAttribute("phone", r.getString("PHONE"));
                }
                
                if (r.getString("MOBILE") != null) {
                    wbo.setAttribute("mobile", r.getString("MOBILE"));
                }
                
                if (r.getString("OPTION3") != null) {
                    wbo.setAttribute("mobile2", r.getString("OPTION3"));
                }
                
                if (r.getString("EMAIL") != null) {
                    wbo.setAttribute("email", r.getString("EMAIL"));
                }
                
                if (r.getString("CLIENTSSN") != null) {
                    wbo.setAttribute("nationalID", r.getString("CLIENTSSN"));
                }
                
                if (r.getString("PRODUCT_CATEGORY_NAME") != null) {
                    wbo.setAttribute("projectName", r.getString("PRODUCT_CATEGORY_NAME"));
                }
                
                if (r.getString("MAIN_PROJ_ID") != null) {
                    wbo.setAttribute("mainProjectId", r.getString("MAIN_PROJ_ID"));
                }
                
                if (r.getString("BEFORE_DISCOUNT") != null) {
                    wbo.setAttribute("beforeDis", r.getString("BEFORE_DISCOUNT"));
                }
                
                if (r.getString("PAYMENT_PLACE") != null) {
                    wbo.setAttribute("comments", r.getString("PAYMENT_PLACE"));
                }
                
                if (r.getString("FLOOR_NO") != null) {
                    wbo.setAttribute("floorNo", r.getString("FLOOR_NO"));
                }
                
                if (r.getString("MODEL_NO") != null) {
                    wbo.setAttribute("modelNo", r.getString("MODEL_NO"));
                }
                
                if (r.getString("RECEIPT_NO") != null) {
                    wbo.setAttribute("receiptNo", r.getString("RECEIPT_NO"));
                }
                
                if (r.getString("RESERVATION_DATE") != null) {
                    wbo.setAttribute("reservationDate", r.getString("RESERVATION_DATE"));
                }
                
                if (r.getString("unitValueText") != null) {
                    wbo.setAttribute("unitValueText", r.getString("unitValueText"));
                }
                
                if (r.getString("beforeDiscountText") != null) {
                    wbo.setAttribute("beforeDiscountText", r.getString("beforeDiscountText"));
                }
                
                if (r.getString("reservationValueText") != null) {
                    wbo.setAttribute("reservationValueText", r.getString("reservationValueText"));
                }
                
                if (r.getString("contractValueText") != null) {
                    wbo.setAttribute("contractValueText", r.getString("contractValueText"));
                }
                
                if (r.getString("CREATED_BY") != null) {
                    UserMgr userMgr = UserMgr.getInstance();
                    WebBusinessObject userWbo = userMgr.getOnSingleKey(r.getString("CREATED_BY"));
                    wbo.setAttribute("employee", userWbo.getAttribute("userName"));
                }
                
                try {
                    if (r.getString("UNIT_VALUE") != null) {
                        wbo.setAttribute("unitValue", r.getString("UNIT_VALUE"));
                    }
                } catch (Exception ex) {}
                
                try {
                    if (r.getString("RESERVATION_VALUE") != null) {
                        wbo.setAttribute("reservationValue", r.getString("RESERVATION_VALUE"));
                    }
                } catch (Exception ex) {}
                
                try {
                    if (r.getString("CONTRACT_VALUE") != null) {
                        wbo.setAttribute("contractValue", r.getString("CONTRACT_VALUE"));
                    }
                } catch (Exception ex) {}
                
                try {
                    if (r.getString("PLOT_AREA") != null) {
                        wbo.setAttribute("plotArea", r.getString("PLOT_AREA"));
                    }
                } catch (Exception ex) {}
                
                try {
                    if (r.getString("BUILDING_AREA") != null) {
                        wbo.setAttribute("buildingArea", r.getString("BUILDING_AREA"));
                    }
                } catch (Exception ex) {}
                
                try {
                    if (r.getString("PAYMENT_SYSTEM") != null) {
                        wbo.setAttribute("paymentSystem", r.getString("PAYMENT_SYSTEM"));
                    }
                } catch (Exception ex) {}
                
                if (r.getString("BEFORE_DISCOUNT") != null) {
                    wbo.setAttribute("beforeDiscount", r.getString("BEFORE_DISCOUNT"));
                }
            } catch (Exception ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getReservedUnitByUnitCodeAndClientCodeAndId(String unitCode, String clientCode, String id) {
        Vector params = new Vector();
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        try {
            params.addElement(new StringValue(unitCode));
            params.addElement(new StringValue(clientCode));
            params.addElement(new StringValue(id));
            String query = getQuery("getReservedUnitsByClient").trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(params);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("PROJECT_NAME") != null) {
                    wbo.setAttribute("unitCode", r.getString("PROJECT_NAME"));
                }
                
                if (r.getString("NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("NAME"));
                }
                
                if (r.getString("ADDRESS") != null) {
                    wbo.setAttribute("address", r.getString("ADDRESS"));
                }
                
                if (r.getString("BUDGET") != null) {
                    wbo.setAttribute("budget", r.getString("BUDGET"));
                }
                
                if (r.getString("PERIOD") != null) {
                    wbo.setAttribute("period", r.getString("PERIOD"));
                }
                
                if (r.getString("NOTE") != null) {
                    wbo.setAttribute("paymentPlace", r.getString("NOTE"));
                }
                
                if (r.getString("JOB") != null) {
                    wbo.setAttribute("job", r.getString("JOB"));
                }
                
                if (r.getString("PHONE") != null) {
                    wbo.setAttribute("phone", r.getString("PHONE"));
                }
                
                if (r.getString("MOBILE") != null) {
                    wbo.setAttribute("mobile", r.getString("MOBILE"));
                }
                
                if (r.getString("OPTION3") != null) {
                    wbo.setAttribute("mobile2", r.getString("OPTION3"));
                }
                
                if (r.getString("EMAIL") != null) {
                    wbo.setAttribute("email", r.getString("EMAIL"));
                }
                
                if (r.getString("CLIENTSSN") != null) {
                    wbo.setAttribute("nationalID", r.getString("CLIENTSSN"));
                }
                
                if (r.getString("PRODUCT_CATEGORY_NAME") != null) {
                    wbo.setAttribute("projectName", r.getString("PRODUCT_CATEGORY_NAME"));
                }
                
                if (r.getString("MAIN_PROJ_ID") != null) {
                    wbo.setAttribute("mainProjectId", r.getString("MAIN_PROJ_ID"));
                }
                
                if (r.getString("BEFORE_DISCOUNT") != null) {
                    wbo.setAttribute("beforeDis", r.getString("BEFORE_DISCOUNT"));
                }
                
                if (r.getString("PAYMENT_PLACE") != null) {
                    wbo.setAttribute("comments", r.getString("PAYMENT_PLACE"));
                }
                
                if (r.getString("FLOOR_NO") != null) {
                    wbo.setAttribute("floorNo", r.getString("FLOOR_NO"));
                }
                
                if (r.getString("MODEL_NO") != null) {
                    wbo.setAttribute("modelNo", r.getString("MODEL_NO"));
                }
                
                if (r.getString("RECEIPT_NO") != null) {
                    wbo.setAttribute("receiptNo", r.getString("RECEIPT_NO"));
                }
                
                if (r.getString("RESERVATION_DATE") != null) {
                    wbo.setAttribute("reservationDate", r.getString("RESERVATION_DATE"));
                }
                
                if (r.getString("unitValueText") != null) {
                    wbo.setAttribute("unitValueText", r.getString("unitValueText"));
                }
                
                if (r.getString("beforeDiscountText") != null) {
                    wbo.setAttribute("beforeDiscountText", r.getString("beforeDiscountText"));
                }
                
                if (r.getString("reservationValueText") != null) {
                    wbo.setAttribute("reservationValueText", r.getString("reservationValueText"));
                }
                
                if (r.getString("contractValueText") != null) {
                    wbo.setAttribute("contractValueText", r.getString("contractValueText"));
                }
                
                if (r.getString("CREATED_BY") != null) {
                    UserMgr userMgr = UserMgr.getInstance();
                    WebBusinessObject userWbo = userMgr.getOnSingleKey(r.getString("CREATED_BY"));
                    wbo.setAttribute("employee", userWbo.getAttribute("userName"));
                }
                
                try {
                    if (r.getString("UNIT_VALUE") != null) {
                        wbo.setAttribute("unitValue", r.getString("UNIT_VALUE"));
                    }
                } catch (Exception ex) {}
                
                try {
                    if (r.getString("RESERVATION_VALUE") != null) {
                        wbo.setAttribute("reservationValue", r.getString("RESERVATION_VALUE"));
                    }
                } catch (Exception ex) {}
                
                try {
                    if (r.getString("CONTRACT_VALUE") != null) {
                        wbo.setAttribute("contractValue", r.getString("CONTRACT_VALUE"));
                    }
                } catch (Exception ex) {}
                
                try {
                    if (r.getString("PLOT_AREA") != null) {
                        wbo.setAttribute("plotArea", r.getString("PLOT_AREA"));
                    }
                } catch (Exception ex) {}
                
                try {
                    if (r.getString("BUILDING_AREA") != null) {
                        wbo.setAttribute("buildingArea", r.getString("BUILDING_AREA"));
                    }
                } catch (Exception ex) {}
                
                try {
                    if (r.getString("PAYMENT_SYSTEM") != null) {
                        wbo.setAttribute("paymentSystem", r.getString("PAYMENT_SYSTEM"));
                    }
                } catch (Exception ex) {}
                
                if (r.getString("BEFORE_DISCOUNT") != null) {
                    wbo.setAttribute("beforeDiscount", r.getString("BEFORE_DISCOUNT"));
                }
            } catch (Exception ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    /**
     *
     * @return @throws NoUserInSessionException
     */
    public ArrayList<WebBusinessObject> getResidentialModelList() throws NoUserInSessionException {
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        try {
            String query = getQuery("getResidentialModelList").trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("Model_Code") != null) {
                    wbo.setAttribute("Model_Code", r.getString("Model_Code"));
                }
                
                if (r.getString("Model_Name") != null) {
                    wbo.setAttribute("Model_Name", r.getString("Model_Name"));
                }
                
                if (r.getString("Project_Code") != null) {
                    wbo.setAttribute("Project_Code", r.getString("Project_Code"));
                }
                
                if (r.getString("Project_Name") != null) {
                    wbo.setAttribute("Project_Name", r.getString("Project_Name"));
                }
                
                if (r.getString("Model_ID") != null) {
                    wbo.setAttribute("Model_ID", r.getString("Model_ID"));
                }
                
                if (r.getString("TOTAL_AREA") != null) {
                    wbo.setAttribute("totalArea", r.getString("TOTAL_AREA"));
                }
                
                if (r.getBigDecimal("TOTAL_COUNT") != null) {
                    wbo.setAttribute("totalCount", r.getBigDecimal("TOTAL_COUNT"));
                }
                
                if (r.getBigDecimal("AVAILABLE_COUNT") != null) {
                    wbo.setAttribute("availableCount", r.getBigDecimal("AVAILABLE_COUNT"));
                }
                
                if (r.getBigDecimal("RESERVED_COUNT") != null) {
                    wbo.setAttribute("reservedCount", r.getBigDecimal("RESERVED_COUNT"));
                }
                
                if (r.getBigDecimal("SOLD_COUNT") != null) {
                    wbo.setAttribute("soldCount", r.getBigDecimal("SOLD_COUNT"));
                }
            } catch (Exception ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public boolean saveSellUnit(HttpServletRequest request, HttpSession s) throws NoUserInSessionException, SQLException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Vector queryResultV = null;
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        projectMgr = ProjectMgr.getInstance();
        WebBusinessObject wbo = projectMgr.getOnSingleKey(request.getParameter("unitId"));
        String unitName = (String) wbo.getAttribute("projectName");
        wbo = projectMgr.getOnSingleKey(request.getParameter("unitCategoryId"));
        String unitCategoryName = (String) wbo.getAttribute("projectName");
        String id = UniqueIDGen.getNextID();
        request.setAttribute("clientProjectID", id);
        params.addElement(new StringValue(id));
        params.addElement(new StringValue(request.getParameter("clientId")));
        params.addElement(new StringValue(request.getParameter("unitId")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue("purche"));
        params.addElement(new StringValue(request.getParameter("unitCategoryId")));
        params.addElement(new StringValue(request.getParameter("notes") != null ? request.getParameter("notes") : request.getParameter("budget")));
        params.addElement(new StringValue(request.getParameter("period")));
        params.addElement(new StringValue(request.getParameter("paymentSystem")));
        params.addElement(new StringValue(request.getParameter("paymentPlace")));
        params.addElement(new StringValue(unitName));
        params.addElement(new StringValue(unitCategoryName));
        params.addElement(new StringValue(request.getParameter("unitValue")));
        params.addElement(new StringValue(request.getParameter("reservationValue")));
        params.addElement(new StringValue(request.getParameter("contractValue")));
        params.addElement(new StringValue(request.getParameter("plotArea")));
        params.addElement(new StringValue(request.getParameter("buildingArea")));
        params.addElement(new StringValue(request.getParameter("beforeDiscount")));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            String myQuery = getQuery("insertClientProducts").trim();
            forInsert.setSQLQuery(myQuery);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
            
            params = new Vector();
            params.addElement(new StringValue((String) request.getParameter("unitId")));
            forInsert.setSQLQuery(sqlMgr.getSql("getCompStatusByUser2").trim());
            forInsert.setparams(params);
            try {
                queryResultV = forInsert.executeQuery();
            } catch (UnsupportedTypeException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            Row r;
            Enumeration e = queryResultV.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                try {
                    id = r.getString("STATUS_ID").toString();
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            if (id != null && !id.equals("")) {
                params = new Vector();
                params.addElement(new StringValue(id));
                beginTransaction();
                forInsert.setConnection(transConnection);
                forInsert.setSQLQuery(sqlMgr.getSql("updateStatusByUser").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                if (queryResult < 0) {
                    transConnection.rollback();
                    return false;
                }
                
                try {
                    Thread.sleep(50);
                } catch (InterruptedException ex) {
                    Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
                } finally {
                    endTransaction();
                }
            }
            
            params = new Vector();
            String issueStatusId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(issueStatusId));
            params.addElement(new StringValue("10"));
            params.addElement(new StringValue((String) request.getParameter("period")));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue((String) request.getParameter("unitId")));
            params.addElement(new StringValue("Housing_Units"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue((String) waUser.getAttribute("userId")));
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
            
            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                endTransaction();
            }
            
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            transConnection.rollback();
            return false;
        } finally {
            endTransaction();
        }
        
        return (queryResult > 0);
    }

    public boolean saveRentUnit(HttpServletRequest request, HttpSession s) throws NoUserInSessionException, SQLException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        projectMgr = ProjectMgr.getInstance();
        WebBusinessObject wbo = projectMgr.getOnSingleKey(request.getParameter("unitId"));
        String unitName = (String) wbo.getAttribute("projectName");
        wbo = projectMgr.getOnSingleKey(request.getParameter("unitCategoryId"));
        String unitCategoryName = (String) wbo.getAttribute("projectName");
        String id = UniqueIDGen.getNextID();
        request.setAttribute("clientProjectID", id);
        params.addElement(new StringValue(id));
        params.addElement(new StringValue(request.getParameter("clientId")));
        params.addElement(new StringValue(request.getParameter("unitId")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue("rent"));
        params.addElement(new StringValue(request.getParameter("unitCategoryId")));
        params.addElement(new StringValue(request.getParameter("budget")));
        params.addElement(new StringValue(request.getParameter("period")));
        params.addElement(new StringValue(request.getParameter("paymentSystem")));
        params.addElement(new StringValue(request.getParameter("paymentPlace")));
        params.addElement(new StringValue(unitName));
        params.addElement(new StringValue(unitCategoryName));
        params.addElement(new StringValue(request.getParameter("unitValue")));
        params.addElement(new StringValue(request.getParameter("reservationValue")));
        params.addElement(new StringValue(request.getParameter("contractValue")));
        params.addElement(new StringValue(request.getParameter("plotArea")));
        params.addElement(new StringValue(request.getParameter("buildingArea")));
        params.addElement(new StringValue(request.getParameter("beforeDiscount")));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            String myQuery = getQuery("insertClientProducts").trim();
            forInsert.setSQLQuery(myQuery);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            transConnection.rollback();
            return false;
        } finally {
            endTransaction();
        }
        
        return (queryResult > 0);
    }

    public boolean deleteSellUnit(String unit_id, HttpSession s) throws NoUserInSessionException, SQLException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Vector queryResultV = new Vector();
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params = new Vector();

        String id = null;
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);

            params.addElement(new StringValue(unit_id));
            forInsert.setSQLQuery(sqlMgr.getSql("getCompStatusByUser2").trim());
            forInsert.setparams(params);
            try {
                queryResultV = forInsert.executeQuery();
            } catch (UnsupportedTypeException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            Row r;
            Enumeration e = queryResultV.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                try {
                    id = r.getString("STATUS_ID").toString();
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            params = new Vector();
            String issueStatusId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(issueStatusId));
            params.addElement(new StringValue("8"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue(unit_id));
            params.addElement(new StringValue("Housing_Units"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue((String) waUser.getAttribute("userId")));
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
            
            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                endTransaction();
            }
            
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }

            if (id != null && !id.equals("")) {
                params = new Vector();
                params.addElement(new StringValue(id));
                beginTransaction();
                forInsert.setConnection(transConnection);
                forInsert.setSQLQuery(sqlMgr.getSql("updateStatusByUser").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                if (queryResult < 0) {
                    transConnection.rollback();
                    return false;
                }
                
                try {
                    Thread.sleep(50);
                } catch (InterruptedException ex) {
                    Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
                } finally {
                    endTransaction();
                }
            }

            params = new Vector();

            params.addElement(new StringValue(unit_id));
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("deleteClientProduct").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
            
            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                endTransaction();
            }
            
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            transConnection.rollback();
            return false;
        } finally {
            endTransaction();
        }
        
        return (queryResult > 0);
    }

    public boolean updateProject(String projectId, String updateType, String updateValue) {
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        String query = "";
        boolean hasChild = true;
        if (updateType.equalsIgnoreCase("name")) {
            query = "updateProjectName";
            params.addElement(new StringValue(updateValue));
        } else if (updateType.equalsIgnoreCase("desc")) {
            query = "updateProjectDesc";
            params.addElement(new StringValue(updateValue));
        }
        else if (updateType.equalsIgnoreCase("unitlevel")) {
            query = "updateProjectOptionThree";
            params.addElement(new StringValue(updateValue));
        }

        params.addElement(new StringValue(projectId));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(true);
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery(query).trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
        } catch (SQLException se) {
            logger.error("Exception updating project (unit): " + se.getMessage());
            return false;
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(CampaignMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        try {
            Vector params1 = new Vector();
            params1.addElement(new StringValue(projectId));
            query = "getClientProjectsCount";
            connection = dataSource.getConnection();
            connection.setAutoCommit(true);
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery(query).trim());
            forUpdate.setparams(params1);
            Vector results = forUpdate.executeQuery();
//            queryResult = forUpdate.executeUpdate();
            Row row;
            WebBusinessObject wbo = null;
            Enumeration e = results.elements();
            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                if (row.getString(1).equals("0")) {
                    hasChild = false;
                }
            }
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
        
        if (hasChild) {

            // For update Client Projects
            if (updateType.equalsIgnoreCase("name")) {
                query = "updateClientProjectName";

                try {
                    connection = dataSource.getConnection();
                    connection.setAutoCommit(true);
                    forUpdate.setConnection(connection);
                    forUpdate.setSQLQuery(getQuery(query).trim());
                    forUpdate.setparams(params);
                    queryResult = forUpdate.executeUpdate();
                } catch (SQLException se) {
                    logger.error("Exception updating project (unit): " + se.getMessage());
                    return false;
                } finally {
                    try {
                        if (connection != null) {
                            connection.close();
                        }
                    } catch (SQLException ex) {
                        Logger.getLogger(CampaignMgr.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            }
        }
        
        return (queryResult > 0);
    }

    public WebBusinessObject getProjectForClient(String clientID) {
        Vector queryResult = new Vector();
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        parameters.addElement(new StringValue(clientID));
        try {
            String query = getQuery("getProjectByClient").trim();
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(query);
            queryResult = command.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("***** " + ex.getMessage());
            }
        }
        
        Row row;
        WebBusinessObject wbo = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            wbo = fabricateBusObj(row);
            break;
        }
        return wbo;
    }

    public ArrayList<String> getProjectsIdByIds(ArrayList<String> projectIds) {
        Vector queryResult = new Vector();
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        ArrayList<String> arrayOfNames = new ArrayList<String>();
        for (int i = 0; i < projectIds.size(); i++) {

            Vector parameters = new Vector();

            parameters.addElement(new StringValue(projectIds.get(i)));
            try {
                String query = getQuery("getProjectCodeByName").trim();
                connection = dataSource.getConnection();
                command.setConnection(connection);
                command.setparams(parameters);
                command.setSQLQuery(query);
                queryResult = command.executeQuery();
            } catch (SQLException ex) {
                logger.error("SQL Exception  " + ex.getMessage());
            } catch (UnsupportedTypeException uste) {
                logger.error("***** " + uste.getMessage());
            } finally {
                try {
                    if (connection != null) {
                        connection.close();
                    }
                } catch (SQLException ex) {
                    logger.error("***** " + ex.getMessage());
                }
            }

            String projectName = null;
            Row row;
            if (!queryResult.isEmpty()) {
                Enumeration e = queryResult.elements();
                while (e.hasMoreElements()) {
                    row = (Row) e.nextElement();
                    try {
                        projectName = row.getString("PROJECT_NAME");
                        arrayOfNames.add(projectName);
                    } catch (NoSuchColumnException ex) {
                        logger.error("***** " + ex.getMessage());
                    }
                    
                    break;
                }
            }
        }
        
        return arrayOfNames;
    }

    public ArrayList<WebBusinessObject> getProjectWithUserCreated(String userID) {
        Vector queryResult = new Vector();
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        ArrayList<WebBusinessObject> projects = new ArrayList<WebBusinessObject>();

        Vector parameters = new Vector();
        parameters.addElement(new StringValue(userID));
        try {
            String query = getQuery("selectProjectByFldrAndCreatedBy").trim();
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(query);
            queryResult = command.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("***** " + ex.getMessage());
            }
        }
        
        WebBusinessObject wbo;
        Row row;
        if (!queryResult.isEmpty()) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                try {
                    row = (Row) e.nextElement();
                    String count = row.getString("count");
                    wbo = fabricateBusObj(row);
                    wbo.setAttribute("count", count);
                    projects.add(wbo);
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }

        return projects;
    }

    public WebBusinessObject getArbitraryProduct() {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        try {
            String query = getQuery("getArbitraryProduct").trim();
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query);
            result = command.executeQuery();
            for (Row row : result) {
                return fabricateBusObj(row);
            }
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("***** " + ex.getMessage());
            }
        }

        return null;
    }

    public ArrayList<WebBusinessObject> getDocumentInFolder(String folderID) {
        Vector queryResult = new Vector();
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        ArrayList<WebBusinessObject> projects = new ArrayList<WebBusinessObject>();

        Vector parameters = new Vector();
        parameters.addElement(new StringValue(folderID));
        try {
            String query = getQuery("getDocumentsInFolderProject").trim();
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(query);
            queryResult = command.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("***** " + ex.getMessage());
            }
        }
        
        WebBusinessObject wbo;
        Row row;
        if (!queryResult.isEmpty()) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                wbo = new WebBusinessObject();
                row = (Row) e.nextElement();
                try {
                    if (row.getString("CLIENT_NAME") != null) {
                        wbo.setAttribute("clientName", row.getString("CLIENT_NAME"));
                    } else {
                        wbo.setAttribute("clientName", "");
                    }
                    
                    if (row.getString("STATUS_AR_NAME") != null) {
                        wbo.setAttribute("statusArName", row.getString("STATUS_AR_NAME"));
                    } else {
                        wbo.setAttribute("statusArName", "");
                    }
                    
                    if (row.getString("STATUS_EN_NAME") != null) {
                        wbo.setAttribute("statusEnName", row.getString("STATUS_EN_NAME"));
                    } else {
                        wbo.setAttribute("statusEnName", "");
                    }
                    
                    if (row.getString("CREATED_BY") != null) {
                        wbo.setAttribute("createdByID", row.getString("CREATED_BY"));
                    } else {
                        wbo.setAttribute("createdByID", "");
                    }
                    
                    if (row.getString("CREATED_BY_NAME") != null) {
                        wbo.setAttribute("createdByName", row.getString("CREATED_BY_NAME"));
                    } else {
                        wbo.setAttribute("createdByName", "");
                    }
                    
                    if (row.getString("CREATION_TIME") != null) {
                        wbo.setAttribute("creationTime", row.getString("CREATION_TIME"));
                    } else {
                        wbo.setAttribute("creationTime", "");
                    }
                    
                    if (row.getString("BUSINESS_ID") != null) {
                        wbo.setAttribute("businessID", row.getString("BUSINESS_ID"));
                    } else {
                        wbo.setAttribute("businessID", "");
                    }
                    
                    if (row.getString("BUSINESS_ID_BY_DATE") != null) {
                        wbo.setAttribute("businessIDByDate", row.getString("BUSINESS_ID_BY_DATE"));
                    } else {
                        wbo.setAttribute("businessIDByDate", "");
                    }
                    
                    if (row.getString("ISSUE_ID") != null) {
                        wbo.setAttribute("issueId", row.getString("ISSUE_ID"));
                    } else {
                        wbo.setAttribute("issueId", "");
                    }

                    projects.add(wbo);
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
                } catch (NullPointerException ne) {
                    Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ne);
                }
            }
        }

        return projects;
    }

    public ArrayList<WebBusinessObject> getAllUnitsUnderProject(String projectID) {
        Vector queryResult = new Vector();
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        ArrayList<WebBusinessObject> projects = new ArrayList<WebBusinessObject>();

        Vector parameters = new Vector();
        parameters.addElement(new StringValue(projectID));
        try {
            String query = getQuery("getUnitsUnderBuilding").trim();
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(query);
            queryResult = command.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("***** " + ex.getMessage());
            }
        }
        
        WebBusinessObject wbo;
        Row row;
        if (!queryResult.isEmpty()) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                wbo = fabricateBusObj(row);
                projects.add(wbo);
            }
        }

        return projects;
    }

    public boolean deleteModel(String modelID) {
        boolean isDeleted = false;
        isDeleted = projectMgr.deleteOnSingleKey(modelID);
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        params.addElement(new StringValue(modelID));
        try {
            beginTransaction();
            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(getQuery("updateModelOfUnit").trim());
            forUpdate.setparams(params);
            forUpdate.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error("Exception updating project: " + se.getMessage());
            return false;
        }
        
        return isDeleted;
    }

    public boolean saveOnholdUnit(HttpServletRequest request, HttpSession s) throws NoUserInSessionException, SQLException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Vector queryResultV = new Vector();
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        projectMgr = ProjectMgr.getInstance();
        WebBusinessObject wbo = projectMgr.getOnSingleKey(request.getParameter("unitId"));
        String unitName = (String) wbo.getAttribute("projectName");
        wbo = projectMgr.getOnSingleKey(request.getParameter("unitCategoryId"));
        String unitCategoryName = (String) wbo.getAttribute("projectName");
        String id = UniqueIDGen.getNextID();
        params.addElement(new StringValue(id));
        params.addElement(new StringValue(request.getParameter("clientId")));
        params.addElement(new StringValue(request.getParameter("unitId")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue("onhold"));
        params.addElement(new StringValue(request.getParameter("unitCategoryId")));
        params.addElement(new StringValue(request.getParameter("budget")));
        params.addElement(new StringValue(request.getParameter("period")));
        params.addElement(new StringValue(request.getParameter("paymentSystem")));
        params.addElement(new StringValue(request.getParameter("paymentPlace")));
        params.addElement(new StringValue(unitName));
        params.addElement(new StringValue(unitCategoryName));
        params.addElement(new StringValue(request.getParameter("unitValue")));
        params.addElement(new StringValue(request.getParameter("reservationValue")));
        params.addElement(new StringValue(request.getParameter("contractValue")));
        params.addElement(new StringValue(request.getParameter("plotArea")));
        params.addElement(new StringValue(request.getParameter("buildingArea")));
        params.addElement(new StringValue(request.getParameter("beforeDiscount")));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            String myQuery = getQuery("insertClientProducts").trim();
            forInsert.setSQLQuery(myQuery);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
            
            params = new Vector();
            params.addElement(new StringValue((String) request.getParameter("unitId")));
            forInsert.setSQLQuery(sqlMgr.getSql("getCompStatusByUser2").trim());
            forInsert.setparams(params);
            try {
                queryResultV = forInsert.executeQuery();
            } catch (UnsupportedTypeException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            Row r;
            Enumeration e = queryResultV.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                try {
                    id = r.getString("STATUS_ID").toString();
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            
            if (id != null && !id.equals("")) {
                params = new Vector();
                params.addElement(new StringValue(id));
                beginTransaction();
                forInsert.setConnection(transConnection);
                forInsert.setSQLQuery(sqlMgr.getSql("updateStatusByUser").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
                if (queryResult < 0) {
                    transConnection.rollback();
                    return false;
                }
                
                try {
                    Thread.sleep(50);
                } catch (InterruptedException ex) {
                    Logger.getLogger(ClientComplaintsMgr.class.getName()).log(Level.SEVERE, null, ex);
                } finally {
                    endTransaction();
                }
            }
            
            params = new Vector();
            String issueStatusId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(issueStatusId));
            params.addElement(new StringValue("33"));
            params.addElement(new StringValue((String) request.getParameter("period")));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue((String) request.getParameter("unitId")));
            params.addElement(new StringValue("Housing_Units"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue((String) waUser.getAttribute("userId")));
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
            
            try {
                Thread.sleep(50);
            } catch (InterruptedException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                endTransaction();
            }
            
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            transConnection.rollback();
            return false;
        } finally {
            endTransaction();
        }
        
        return (queryResult > 0);
    }

    public ArrayList<WebBusinessObject> getAllRequestItemsParent() {
        Vector queryResult = new Vector();
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        ArrayList<WebBusinessObject> projects = new ArrayList<WebBusinessObject>();
        try {
            String query = getQuery("getAllRequestItemsParent").trim();
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query);
            queryResult = command.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("***** " + ex.getMessage());
            }
        }
        
        WebBusinessObject wbo;
        Row row;
        if (!queryResult.isEmpty()) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                wbo = fabricateBusObj(row);
                wbo.setAttribute("childs", getAllRequestItemsChilds((String) wbo.getAttribute("projectID")));
                projects.add(wbo);
            }
        }

        return projects;
    }

    public ArrayList<WebBusinessObject> getAllRequestItemsChilds(String parentID) {
        Vector queryResult = new Vector();
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        ArrayList<WebBusinessObject> projects = new ArrayList<WebBusinessObject>();
        Vector params = new Vector();
        params.addElement(new StringValue(parentID));
        try {
            String query = getQuery("getAllRequestItemsChilds").trim();
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query);
            command.setparams(params);
            queryResult = command.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("***** " + ex.getMessage());
            }
        }
        
        WebBusinessObject wbo;
        Row row;
        if (!queryResult.isEmpty()) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                wbo = fabricateBusObj(row);
                projects.add(wbo);
            }
        }

        return projects;
    }

    public List<WebBusinessObject> getRequestsItems(String excludedIds) {
        return getProjectByLocationItem(CRMConstants.PROJECT_LOCATION_TYPE_REQUEST_ITEM, excludedIds);
    }

    public List<WebBusinessObject> getProjectByLocationItem(String locationType, String excludedIds) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        Vector parameters = new Vector();
        List<WebBusinessObject> projects = new ArrayList<WebBusinessObject>();

        parameters.addElement(new StringValue(locationType));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getProjectByLocationItem").trim().replaceAll("IDS", excludedIds));
            command.setparams(parameters);
            result = command.executeQuery();

            for (Row row : result) {
                projects.add(fabricateBusObj(row));
            }
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("***** " + ex.getMessage());
            }
        }

        return projects;
    }

    public List<WebBusinessObject> getAllProjectsOrderedByName() {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;
        List<WebBusinessObject> projects = new ArrayList<WebBusinessObject>();
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getAllProjectsOrderedByName"));
            result = command.executeQuery();
            for (Row row : result) {
                projects.add(fabricateBusObj(row));
            }
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error("***** " + ex.getMessage());
            }
        }
        
        return projects;
    }

    public Vector getAllUnitsWithPrice(String departmentID, String unitStatus, String projectID) throws NoUserInSessionException {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        params.addElement(new StringValue(departmentID));
        params.addElement(new StringValue(unitStatus));
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;

        StringBuilder whrStmnt = new StringBuilder();
        if(projectID != null && !projectID.isEmpty()){
            whrStmnt.append(" AND U.MAIN_PROJ_ID = ? ");
            params.addElement(new StringValue(projectID));
        }
        
        try {
            String query = getQuery("getAllUnitsWithPrice").replaceAll("whrStmnt", whrStmnt.toString()).trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        Vector resultBusObjs = new Vector();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("NAME"));
                }
                
                if (r.getString("AGE_GROUP") != null) {
                    wbo.setAttribute("clientType", r.getString("AGE_GROUP"));
                }
                
                if (r.getString("SYS_ID") != null) {
                    wbo.setAttribute("clientId", r.getString("SYS_ID"));
                }
                
                if (r.getString("PARENT_NAME") != null) {
                    wbo.setAttribute("parentName", r.getString("PARENT_NAME"));
                }
                
                if (r.getString("STATUS_NAME") != null) {
                    wbo.setAttribute("statusName", r.getString("STATUS_NAME"));
                }
                
                if (r.getString("MAIN_PROJ_ID") != null) {
                    wbo.setAttribute("mainProjId", r.getString("MAIN_PROJ_ID"));
                }
                
                if (r.getString("EQ_NO") != null) {
                    wbo.setAttribute("Model_Code", r.getString("EQ_NO"));
                }
                
                if (r.getString("AREA") != null) {
                    wbo.setAttribute("area", r.getString("AREA"));
                }
                
                if (r.getString("PRICE") != null) {
                    wbo.setAttribute("price", r.getString("PRICE"));
                }
                
                if (r.getString("METER_PRICE") != null) {
                    wbo.setAttribute("meterPrice", r.getString("METER_PRICE"));
                }
            } catch (Exception ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public Vector getAllPricedUnits(String clientID, String departmentID, java.sql.Date fromDate, java.sql.Date toDate, String area, String projectID, boolean allProject, String userID) throws NoUserInSessionException {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        params.addElement(new StringValue(clientID));
        params.addElement(new StringValue(departmentID));
        //params.addElement(new DateValue(fromDate));
        //params.addElement(new DateValue(toDate));
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        try {
            String query = getQuery("getAllPricedUnits").trim();
	    
	    if(area != null && !area.equals("All") && !area.equals("")){
		params.addElement(new IntValue(Integer.parseInt(area)));
		query += " AND U.PROJECT_ID IN (SELECT UP.UNIT_ID FROM UNIT_PRICE UP WHERE UP.MAX_PRICE = ?) ";
	    }
            
            if(projectID != null && !projectID.equals("All") && !projectID.equals("")){
		params.addElement(new StringValue(projectID));
		query += " AND p.PROJECT_ID = ?";
	    } else {
                if(allProject) {
                    query += " AND P.PROJECT_ID IN (SELECT PROJECT_ID FROM PROJECT WHERE LOCATION_TYPE = '44')";
                } else {
                    params.addElement(new StringValue(userID));
                    query += " AND P.PROJECT_ID IN (SELECT PROJECT_ID FROM USER_COMPANY_PROJECTS WHERE USER_ID = ?)";
                }
            }
	    
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        Vector resultBusObjs = new Vector();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("NAME"));
                } 
                
                if (r.getString("AGE_GROUP") != null) {
                    wbo.setAttribute("clientType", r.getString("AGE_GROUP"));
                }
                
                if (r.getString("SYS_ID") != null) {
                    wbo.setAttribute("clientId", r.getString("SYS_ID"));
                }
                
                if (r.getString("PARENT_NAME") != null) {
                    wbo.setAttribute("parentName", r.getString("PARENT_NAME"));
                }
                
                if (r.getString("STATUS_NAME") != null) {
                    wbo.setAttribute("statusName", r.getString("STATUS_NAME"));
                }
                
                if (r.getString("MAIN_PROJ_ID") != null) {
                    wbo.setAttribute("mainProjId", r.getString("MAIN_PROJ_ID"));
                }
                
                if (r.getString("EQ_NO") != null) {
                    wbo.setAttribute("Model_Code", r.getString("EQ_NO"));
                }
                
                if (r.getString("AREA") != null) {
                    wbo.setAttribute("area", r.getString("AREA"));
                }
                
                if (r.getString("PRICE") != null) {
                    wbo.setAttribute("price", r.getString("PRICE"));
                }
                
                if (r.getString("CREATION_TIME") != null) { //Kareem rent task start
                    wbo.setAttribute("creationTime", r.getString("CREATION_TIME"));
                }
                
                if (r.getString("NEW_CODE") != null) {
                    wbo.setAttribute("newCode", r.getString("NEW_CODE"));
                }//Kareem rent task end
                
                if (r.getString("PARENT_NAME") != null) {
                    wbo.setAttribute("parentName", r.getString("PARENT_NAME"));
                }
                
                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("fullName", r.getString("FULL_NAME"));
                }
                
                if (r.getString("MODEL_NAME") != null) {
                    wbo.setAttribute("modelName", r.getString("MODEL_NAME"));
                }
                
                if (r.getString("PROJECT_ID") != null) {
                    String cpID = checkShopCart(r.getString("PROJECT_ID"), clientID);
                    if(cpID != null){
                       wbo.setAttribute("shopCart", "true"); 
                    } else {
                        wbo.setAttribute("shopCart", "false"); 
                    }
                    
                }
            } catch (Exception ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }
    
    public String checkShopCart(String projectID , String clientID){
        Vector params = new Vector();
        Vector queryResult = new Vector();
        params.addElement(new StringValue(projectID));
        params.addElement(new StringValue(clientID));
        String mainProjectId = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        
        try {
            String query = getQuery("checkShopCart").trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        Vector resultBusObjs = new Vector();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("ID") != null) {
                    return r.getString("ID");
                } else {
                    return null;
                }
            } catch (Exception ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        return null;
    }
    public boolean saveEngUnit(WebBusinessObject project, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String unitId = UniqueIDGen.getNextID();
        s.setAttribute("projId", unitId);
        project.setAttribute("id", unitId);
        params.addElement(new StringValue(unitId));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.PROJECT_NAME)));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.EQ_NO)));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.PROJECT_DESC)));
        String mainProjectId = null;
        try {
            mainProjectId = project.getAttribute("mainProjectId").toString();
        } catch (NullPointerException e) {
            mainProjectId = "0";
        }
        
        params.addElement(new StringValue(mainProjectId));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.LOCATION_TYPE)));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.FUTILE)));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue((String) project.getAttribute("option_three")));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue("UL"));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertUnit").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
            
            cashData();
            params = new Vector();
            String issueStatusId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(issueStatusId));
            params.addElement(new StringValue("28"));//hide
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue(unitId));//clientCompId--business-comp-id
            params.addElement(new StringValue("Housing_Units"));
            params.addElement(new StringValue("0"));//issueId--parent id
            params.addElement(new StringValue((String) waUser.getAttribute("userId")));
            forInsert.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();
        }
        
        return (queryResult > 0);
    }

    public Vector getAllAvailableUnits() throws NoUserInSessionException {
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        try {
            String query = getQuery("getAllAvailableUnits").trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        
        Vector resultBusObjs = new Vector();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("NAME"));
                }
                
                if (r.getString("AGE_GROUP") != null) {
                    wbo.setAttribute("clientType", r.getString("AGE_GROUP"));
                }
                
                if (r.getString("SYS_ID") != null) {
                    wbo.setAttribute("clientId", r.getString("SYS_ID"));
                }
                
                if (r.getString("PARENT_NAME") != null) {
                    wbo.setAttribute("parentName", r.getString("PARENT_NAME"));
                }
                
                if (r.getString("STATUS_NAME") != null) {
                    wbo.setAttribute("statusName", r.getString("STATUS_NAME"));
                }
                
                if (r.getString("MAIN_PROJ_ID") != null) {
                    wbo.setAttribute("mainProjId", r.getString("MAIN_PROJ_ID"));
                }
                
                if (r.getString("EQ_NO") != null) {
                    wbo.setAttribute("Model_Code", r.getString("EQ_NO"));
                }
                
                if (r.getString("AREA") != null) {
                    wbo.setAttribute("area", r.getString("AREA"));
                }
                
                if (r.getString("PRICE") != null) {
                    wbo.setAttribute("price", r.getString("PRICE"));
                }
            } catch (Exception ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public List<WebBusinessObject> getAllAvailableUnitsList() throws NoUserInSessionException {
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        try {
            String query = getQuery("getAllAvailableUnits").trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        List<WebBusinessObject> resultBusObjs = new Vector<WebBusinessObject>();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("NAME"));
                }
                
                if (r.getString("AGE_GROUP") != null) {
                    wbo.setAttribute("clientType", r.getString("AGE_GROUP"));
                }
                
                if (r.getString("SYS_ID") != null) {
                    wbo.setAttribute("clientId", r.getString("SYS_ID"));
                }
                
                if (r.getString("PARENT_NAME") != null) {
                    wbo.setAttribute("parentName", r.getString("PARENT_NAME"));
                }
                
                if (r.getString("STATUS_NAME") != null) {
                    wbo.setAttribute("statusName", r.getString("STATUS_NAME"));
                }
                
                if (r.getString("MAIN_PROJ_ID") != null) {
                    wbo.setAttribute("mainProjId", r.getString("MAIN_PROJ_ID"));
                }
                
                if (r.getString("EQ_NO") != null) {
                    wbo.setAttribute("Model_Code", r.getString("EQ_NO"));
                }
                
                if (r.getString("AREA") != null) {
                    wbo.setAttribute("area", r.getString("AREA"));
                }
                
                if (r.getString("PRICE") != null) {
                    wbo.setAttribute("price", r.getString("PRICE"));
                }
            } catch (Exception ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getAllUnitsForClient(String clientID) throws NoUserInSessionException {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        params.addElement(new StringValue(clientID));
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        try {
            String query = getQuery("getAllUnitsForClient").trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        Row r;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }
    
    
    public  WebBusinessObject  getUnitResValusForClient(String reservationID) {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        params.addElement(new StringValue(reservationID));
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        try {
            String query = getQuery("getUnitResValusForClient").trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<WebBusinessObject>();
        Row r;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
            try {
                if(r.getString("RESERVATION_VALUE")!=null)
                    wbo.setAttribute("reservationV", r.getString("RESERVATION_VALUE"));
                else   
                    wbo.setAttribute("reservationV", "0");
                 if(r.getString("CONTRACT_VALUE")!=null)
                    wbo.setAttribute("contractV", r.getString("CONTRACT_VALUE"));
                else   
                    wbo.setAttribute("contractV", "0");
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        return resultBusObjs.get(0);
    }

    
    public ArrayList<WebBusinessObject> getSiteTechOfficeProjects(String userID) throws NoUserInSessionException {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        params.addElement(new StringValue(userID));
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        try {
            String query = getQuery("getSiteTechOfficeProjects").trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        Row r;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public Vector getAvailableUnitsFromProject(String departmentID) throws NoUserInSessionException {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        params.addElement(new StringValue(departmentID));
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        try {
            String query = getQuery("getAvailableUnitsFromProject").trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        Vector resultBusObjs = new Vector();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("NAME"));
                }
                
                if (r.getString("AGE_GROUP") != null) {
                    wbo.setAttribute("clientType", r.getString("AGE_GROUP"));
                }
                
                if (r.getString("SYS_ID") != null) {
                    wbo.setAttribute("clientId", r.getString("SYS_ID"));
                }
                
                if (r.getString("PARENT_NAME") != null) {
                    wbo.setAttribute("parentName", r.getString("PARENT_NAME"));
                }
                
                if (r.getString("STATUS_NAME") != null) {
                    wbo.setAttribute("statusName", r.getString("STATUS_NAME"));
                }
                
                if (r.getString("MAIN_PROJ_ID") != null) {
                    wbo.setAttribute("mainProjId", r.getString("MAIN_PROJ_ID"));
                }
                
                if (r.getString("EQ_NO") != null) {
                    wbo.setAttribute("Model_Code", r.getString("EQ_NO"));
                }
            } catch (Exception ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public boolean saveAccount(WebBusinessObject account, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String projectId = UniqueIDGen.getNextID();
        params.addElement(new StringValue(projectId));
        params.addElement(new StringValue((String) account.getAttribute("accountName")));
        params.addElement(new StringValue("ACCNTS"));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue("No Description"));
        params.addElement(new StringValue((String) account.getAttribute("projectId")));
        if (account.getAttribute("projectRank").equals("UL") || account.getAttribute("creationType").equals("main")) {
            if("BANKS".equals(account.getAttribute("eqNO"))) {
                params.addElement(new StringValue("FIN_BNK"));
            } else if("SAFS".equals(account.getAttribute("eqNO"))) {
                params.addElement(new StringValue("FIN_SAFE"));
            } else {
                params.addElement(new StringValue("ACCTM"));
            }
        } else {
            params.addElement(new StringValue("ACCTB"));
        }

        if (account.getAttribute("projectRank").equals("UL") || account.getAttribute("creationType").equals("main")) {
            params.addElement(new StringValue("1"));
        } else {
            params.addElement(new StringValue("0"));
        }

        if (account.getAttribute("projectRank").equals("UL")) {
            params.addElement(new StringValue("1"));
        } else {
            int rank = new Integer(account.getAttribute("projectRank").toString());
            params.addElement(new StringValue(new Integer(rank + 1).toString()));
        }
        params.addElement(new StringValue((String) account.getAttribute("accountCode")));
        params.addElement(new StringValue((String) account.getAttribute("projectIdChain") + "-" + projectId));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertProjectForAccount").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }

            params = new Vector();

            DateFormat df = new SimpleDateFormat("yyyy/MM/dd");
            java.sql.Timestamp entryTime = null;
            String transDate = account.getAttribute("deliveryDate").toString();
            try {
                entryTime = new java.sql.Timestamp(df.parse(transDate).getTime());
            } catch (ParseException ex) {
                logger.error(ex);
            }

            //Prepare account params
            String accountId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(accountId));
            params.addElement(new StringValue(projectId));
            params.addElement(new StringValue((String) account.getAttribute("accountName")));
            params.addElement(new StringValue((String) account.getAttribute("finalDestination")));
            params.addElement(new StringValue((String) account.getAttribute("accountType")));
            params.addElement(new StringValue((String) account.getAttribute("costCenter")));
            params.addElement(new TimestampValue(entryTime));
            params.addElement(new StringValue((String) account.getAttribute("accountCurency")));
            params.addElement(new StringValue((String) waUser.getAttribute("userId")));
            params.addElement(new StringValue((String) waUser.getAttribute("accountCode")));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));

            forInsert.setSQLQuery(getQuery("insertAccount").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }

            //Prepare Balanace_AS_OF params
            params = new Vector();
            String balanceId = UniqueIDGen.getNextID();

            params.addElement(new StringValue(balanceId));
            params.addElement(new StringValue(projectId));
            params.addElement(new StringValue("Account"));
            params.addElement(new FloatValue(new Float(account.getAttribute("creditor").toString())));
            params.addElement(new StringValue("Statring Account"));
            params.addElement(new TimestampValue(entryTime));
            params.addElement(new TimestampValue(entryTime));
            params.addElement(new TimestampValue(entryTime));
            params.addElement(new FloatValue(new Float(account.getAttribute("debit").toString())));
            params.addElement(new FloatValue(new Float(account.getAttribute("creditor").toString())));
            params.addElement(new StringValue((String) waUser.getAttribute("userId")));

            forInsert.setSQLQuery(getQuery("insertBalancAsOF").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();
        }

        return (queryResult > 0);
    }

    public boolean saveCostCenter(WebBusinessObject account, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String projectId = UniqueIDGen.getNextID();
        params.addElement(new StringValue(projectId));
        params.addElement(new StringValue((String) account.getAttribute("accountName")));
        params.addElement(new StringValue("CSTCNTR"));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue("No Description"));
        params.addElement(new StringValue((String) account.getAttribute("projectId")));
        params.addElement(new StringValue("CSTCNTR"));
        params.addElement(new StringValue("0"));
        params.addElement(new StringValue("1"));
        params.addElement(new StringValue((String) account.getAttribute("projectIdChain") + "-" + projectId));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertProjectForAccount").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }

            params = new Vector();

            DateFormat df = new SimpleDateFormat("yyyy/MM/dd");
            java.sql.Timestamp entryTime = null;
            String transDate = account.getAttribute("deliveryDate").toString();
            try {
                entryTime = new java.sql.Timestamp(df.parse(transDate).getTime());
            } catch (ParseException ex) {
                logger.error(ex);
            }

            //Prepare Balanace_AS_OF params
            params = new Vector();
            String balanceId = UniqueIDGen.getNextID();

            params.addElement(new StringValue(balanceId));
            params.addElement(new StringValue(projectId));
            params.addElement(new StringValue("CostCenter"));
            params.addElement(new FloatValue(new Float(account.getAttribute("creditor").toString())));
            params.addElement(new StringValue("Statring Account"));
            params.addElement(new TimestampValue(entryTime));
            params.addElement(new TimestampValue(entryTime));
            params.addElement(new TimestampValue(entryTime));
            params.addElement(new FloatValue(new Float(account.getAttribute("debit").toString())));
            params.addElement(new FloatValue(new Float(account.getAttribute("creditor").toString())));
            params.addElement(new StringValue((String) waUser.getAttribute("userId")));

            forInsert.setSQLQuery(getQuery("insertBalancAsOF").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();
        }

        return (queryResult > 0);
    }
//Kareem

    public boolean updateRentType(WebBusinessObject unitPriceWbo) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult;
        params.addElement(new StringValue(unitPriceWbo.getAttribute("newCode") != null ? (String) unitPriceWbo.getAttribute("newCode") : "UL"));
        params.addElement(new StringValue((String) unitPriceWbo.getAttribute("projectID")));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            // forInsert.setSQLQuery("UPDATE UNIT_PRICE SET OPTION2 =? WHERE UNIT_ID=?");
            forInsert.setSQLQuery("UPDATE PROJECT SET NEW_CODE =? WHERE PROJECT_ID=?");
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        
        return (queryResult > 0);
    } //Kareem end

    public ArrayList getEmpClientsRates(String userID, String fromDate, String toDate) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        String query = getQuery("getClientsProjectByEmp").trim();

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            SQLparams.addElement(new StringValue(userID));
            SQLparams.addElement(new StringValue(fromDate));
            SQLparams.addElement(new StringValue(toDate));
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        ArrayList resultBusObjs = new ArrayList();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            try {
                if (r.getString("total_clients") != null) {
                    resultBusObjs.add(new Integer(r.getString("total_clients").toString()));
                } else {
                    resultBusObjs.add(0);
                }
            } catch (Exception ex) {
                resultBusObjs.add(0);
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        return resultBusObjs;
    }

    public boolean updateUnitCode(String unitID, String unitCode) {
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue(unitCode));
        params.addElement(new StringValue(unitID));
        try {
            beginTransaction();
            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(getQuery("updateUnitCode").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            cashData();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();
        }
        
        return (queryResult > 0);
    }

    public boolean addPrjArea(String areaId, String prjId, String usrID) throws NoUserInSessionException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String prjAreaID = UniqueIDGen.getNextID();

        params.addElement(new StringValue(prjAreaID));
        params.addElement(new StringValue(areaId));
        params.addElement(new StringValue(prjId));
        params.addElement(new StringValue("project"));
        params.addElement(new StringValue("UL"));
        params.addElement(new TimestampValue(new Timestamp(System.currentTimeMillis())));
        params.addElement(new StringValue(usrID));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("addPrjArea").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();
        }
        
        return (queryResult > 0);
    }

    public WebBusinessObject getorderdetals(String id) {
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        String query = getQuery("getjobdetails").trim();

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            SQLparams.addElement(new StringValue(id));

            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        WebBusinessObject wbo = new WebBusinessObject();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            try {
                if (r.getString("PROJECT_NAME") != null) {
                    wbo.setAttribute("eqpName", r.getString("PROJECT_NAME"));
                } else {
                    wbo.setAttribute("eqpInfo", "");
                }

                if (r.getString("OPTION_ONE") != null) {
                    wbo.setAttribute("eqpInfo", r.getString("OPTION_ONE"));
                } else {
                    wbo.setAttribute("eqpInfo", "");
                }
            } catch (Exception ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        return wbo;
    }

    public ArrayList getPrjArea(String areaID) {
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = null;

        String query = getQuery("getPrjArea").trim();

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            SQLparams.addElement(new StringValue(areaID));
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        ArrayList resultBusObjs = new ArrayList();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            try {
                if (r.getString("PROJECTID") != null) {
                    resultBusObjs.add(new Integer(r.getString("PROJECTID").toString()));
                } else {
                    resultBusObjs.add(0);
                }
            } catch (Exception ex) {
                resultBusObjs.add(0);
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getPrj(List projectLstID) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector params = new Vector();
        WebBusinessObject wbo;
        Connection connection = null;
        StringBuilder wherestmt = new StringBuilder();
        if (!projectLstID.isEmpty()) {
            wherestmt.append("WHERE");
            for (int i = 0; i < projectLstID.size(); i++) {
                wherestmt.append(" PROJECT_ID = '").append(projectLstID.get(i)).append("'");
                if (i != (projectLstID.size() - 1)) {
                    wherestmt.append(" OR");
                }
            }
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getPrj").replaceAll("wherestmt", wherestmt.toString()).trim());
            forQuery.setparams(params);

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        
        Row r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    wbo.setAttribute("projectID", r.getString("PROJECT_ID"));
                    wbo.setAttribute("projectName", r.getString("PROJECT_NAME"));

                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        
        return data;
    }

    public ArrayList<WebBusinessObject> getUnitByDetails(String[] prjlstID, String area, String price) {
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        Vector params = new Vector();
        StringBuilder priceStmt = new StringBuilder();
        StringBuilder whereStmt = new StringBuilder();

        whereStmt.append(" WHERE (");
        for (int i = 0; i < prjlstID.length; i++) {
            whereStmt.append(" MAIN_PROJ_ID = '").append(prjlstID[i]).append("'");
            if (i != (prjlstID.length - 1)) {
                whereStmt.append(" OR");
            } else {
                whereStmt.append(" ) AND");
            }
        }

        if (!area.equals("any")) {
            priceStmt.append(" WHERE");
            if (area.equals("80")) {
                priceStmt.append(" ( MAX_PRICE BETWEEN ").append(area).append(" AND 100)");
            } else if (area.equals("100")) {
                priceStmt.append(" ( MAX_PRICE BETWEEN ").append(area).append(" AND 120)");
            } else if (area.equals("120")) {
                priceStmt.append(" ( MAX_PRICE BETWEEN ").append(area).append(" AND 160)");
            } else if (area.equals("160")) {
                priceStmt.append(" ( MAX_PRICE BETWEEN ").append(area).append(" AND 220)");
            }
        }

        if (!price.equals("any")) {
            if (priceStmt.length() > 0) {
                priceStmt.append(" AND");
            } else {
                priceStmt.append(" WHERE");
            }

            if (price.equals("250000")) {
                priceStmt.append(" ( OPTION1 BETWEEN ").append(price).append(" AND 300000)");
            } else if (price.equals("300000")) {
                priceStmt.append(" ( OPTION1 BETWEEN ").append(price).append(" AND 350000)");
            } else if (price.equals("350000")) {
                priceStmt.append(" ( OPTION1 BETWEEN ").append(price).append(" AND 400000 )");
            } else if (price.equals("400000")) {
                priceStmt.append("( OPTION1 BETWEEN ").append(price).append(" AND 450000 )");
            }
        }

        try {
            String query = getQuery("getUnitDetails").replaceAll("whereStmt", whereStmt.toString()).replaceAll("priceStmt", priceStmt.toString()).trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        ArrayList<WebBusinessObject> unitsRes = new ArrayList<>();
        Row r = null;
        WebBusinessObject unitWbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            unitWbo = new WebBusinessObject();
            unitWbo = fabricateBusObj(r);
            try {
                if (r.getString("PROJECT_NAME") != null) {
                    unitWbo.setAttribute("projectName", r.getString("PROJECT_NAME"));
                }
                
                if (r.getString("PROJECT_ID") != null) {
                    unitWbo.setAttribute("projectID", r.getString("PROJECT_ID"));
                }
                
                if (r.getString("AREA") != null) {
                    unitWbo.setAttribute("AREA", r.getString("AREA"));
                }
                
                if (r.getString("PRICE") != null) {
                    unitWbo.setAttribute("PRICE", r.getString("PRICE"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            unitsRes.add(unitWbo);
        }
        
        return unitsRes;
    }

    public boolean updateProjectStatus(String projectID, String statusID) {
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue(statusID));
        params.addElement(new StringValue(projectID));
        try {
            beginTransaction();
            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(getQuery("updateProjectStatus").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            cashData();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();
        }
        
        return (queryResult > 0);
    }

    public boolean addPrjPaySys(String planID, String prjId, String usrID) throws NoUserInSessionException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String prjPlanID = UniqueIDGen.getNextID();

        params.addElement(new StringValue(prjPlanID));
        params.addElement(new StringValue(planID));
        params.addElement(new StringValue(prjId));
        params.addElement(new StringValue(usrID));
        params.addElement(new TimestampValue(new Timestamp(System.currentTimeMillis())));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("addPrjPlan").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();
        }
        
        return (queryResult > 0);
    }

    public ArrayList<WebBusinessObject> getPrjRegions(String prjID) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector params = new Vector();
        WebBusinessObject wbo;
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        params.addElement(new StringValue(prjID));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getPrjRegions").trim());
            forQuery.setparams(params);

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        
        Row r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    wbo.setAttribute("NBID", r.getString("NBID"));

                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        
        return data;
    }

    public ArrayList<WebBusinessObject> getRegionsInfo(ArrayList<WebBusinessObject> NBIDLst) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector params = new Vector();
        WebBusinessObject wbo;
        Connection connection = null;
        StringBuilder wherestmt = new StringBuilder();
        if (!NBIDLst.isEmpty()) {
            wherestmt.append("WHERE");
            for (int i = 0; i < NBIDLst.size(); i++) {
                wherestmt.append(" PROJECT_ID = '").append(NBIDLst.get(i).getAttribute("NBID")).append("'");
                if (i != (NBIDLst.size() - 1)) {
                    wherestmt.append(" OR");
                }
            }
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getPrj").replaceAll("wherestmt", wherestmt.toString()).trim());
            forQuery.setparams(params);

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        
        Row r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    wbo.setAttribute("regionID", r.getString("PROJECT_ID"));
                    wbo.setAttribute("regionName", r.getString("PROJECT_NAME"));

                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        
        return data;
    }

    public boolean addPrjZone(String zoneId, String prjId, String usrID) throws NoUserInSessionException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String prjZoneID = UniqueIDGen.getNextID();

        params.addElement(new StringValue(prjZoneID));
        params.addElement(new StringValue(prjId));
        params.addElement(new StringValue(zoneId));
        params.addElement(new StringValue(usrID));
        params.addElement(new TimestampValue(new Timestamp(System.currentTimeMillis())));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("addPrjZone").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();
        }
        
        return (queryResult > 0);
    }

    public ArrayList<WebBusinessObject> getPrjZone(String prjID) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector params = new Vector();
        WebBusinessObject wbo;
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        params.addElement(new StringValue(prjID));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getPrjZone").trim());
            forQuery.setparams(params);

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        
        Row r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    wbo.setAttribute("zoneID", r.getString("ZONE_ID"));

                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        
        return data;
    }

    public ArrayList<WebBusinessObject> getUnitsArea() {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        WebBusinessObject wbo;
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery("SELECT UNIQUE MAX_PRICE AREA FROM UNIT_PRICE order by MAX_PRICE");

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        
        Row r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    wbo.setAttribute("AREA", r.getString("AREA") != null ? r.getString("AREA") : "");

                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        
        return data;
    }

    public ArrayList<WebBusinessObject> getPrjZoneName(String zoneID) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector params = new Vector();
        WebBusinessObject wbo;
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        params.addElement(new StringValue(zoneID));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getPrjZoneName").trim());
            forQuery.setparams(params);

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        
        Row r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    wbo.setAttribute("zoneName", r.getString("PROJECT_NAME"));

                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        
        return data;
    }

    public ArrayList<WebBusinessObject> getAllProjectForClient(String clientID) {
        Vector param = new Vector();
        Connection connection = null;
        Vector<Row> rows = null;
        SQLCommandBean command = new SQLCommandBean();
        WebBusinessObject wbo;
        ArrayList<WebBusinessObject> result = new ArrayList<>();
        try {
            param.addElement(new StringValue(clientID));
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getProjectByClient").trim());
            command.setparams(param);
            rows = command.executeQuery();
            for (Row row : rows) {
                wbo = fabricateBusObj(row);
                result.add(wbo);
            }
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        
        return result;
    }
    
    public ArrayList<WebBusinessObject> getAllCliensForBranch(String branchID) {
        Vector param = new Vector();
        Connection connection = null;
        Vector<Row> rows = null;
        SQLCommandBean command = new SQLCommandBean();
        WebBusinessObject wbo;
        ArrayList<WebBusinessObject> result = new ArrayList<>();
        try {
            param.addElement(new StringValue(branchID));
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getProjectByClient").trim());
            command.setparams(param);
            rows = command.executeQuery();
            for (Row row : rows) {
                wbo = fabricateBusObj(row);
                result.add(wbo);
            }
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        
        return result;
    }

    public boolean addAsset(WebBusinessObject asset, String usrID) throws NoUserInSessionException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String assetID = UniqueIDGen.getNextID();

        params.addElement(new StringValue(assetID));
        params.addElement(new StringValue(asset.getAttribute("projectName").toString()));
        params.addElement(new StringValue("UL"));
        params.addElement(new TimestampValue(new Timestamp(System.currentTimeMillis())));
        params.addElement(new StringValue(usrID));
        params.addElement(new StringValue(asset.getAttribute("projectDesc").toString()));
        params.addElement(new StringValue(asset.getAttribute("mainPrjID").toString()));
        params.addElement(new StringValue("ASSET"));
        params.addElement(new StringValue(asset.getAttribute("optionOne").toString()));
        params.addElement(new StringValue(asset.getAttribute("equClassID").toString()));
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("addAsset").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();
        }
        
        return (queryResult > 0);
    }

    public ArrayList<WebBusinessObject> getZonePrj(String zoneID) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector params = new Vector();
        WebBusinessObject wbo;
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        params.addElement(new StringValue(zoneID));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getZonePrj").trim());
            forQuery.setparams(params);

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        
        Row r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    wbo.setAttribute("prjID", r.getString("PROJECT_ID"));
                    wbo.setAttribute("prjName", r.getString("PROJECT_NAME"));
                    wbo.setAttribute("location_type", r.getString("LOCATION_TYPE"));

                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        
        return data;
    }

    public ArrayList<WebBusinessObject> getProjectsSales(java.sql.Date fromDate, java.sql.Date toDate) {
        Vector param = new Vector();
        Connection connection = null;
        Vector<Row> rows = null;
        SQLCommandBean command = new SQLCommandBean();
        WebBusinessObject wbo;
        ArrayList<WebBusinessObject> result = new ArrayList<>();
        StringBuilder where = new StringBuilder();
        if (fromDate != null) {
            where.append(" AND TRUNC(P.CREATION_TIME) >= ?");
            param.addElement(new DateValue(fromDate));
        }
        
        if (toDate != null) {
            where.append(" AND TRUNC(P.CREATION_TIME) <= ?");
            param.addElement(new DateValue(toDate));
        }
        
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getProjectsSales").replaceFirst("whereStatement", where.toString()).trim());
            command.setparams(param);
            rows = command.executeQuery();
            for (Row row : rows) {
                wbo = fabricateBusObj(row);
                if (row.getString("AVAILABLE") != null) {
                    wbo.setAttribute("available", row.getString("AVAILABLE"));
                }
                
                if (row.getString("RESERVED") != null) {
                    wbo.setAttribute("reserved", row.getString("RESERVED"));
                }
                
                if (row.getString("SOLD") != null) {
                    wbo.setAttribute("sold", row.getString("SOLD"));
                }
                
                if (row.getString("HIDE") != null) {
                    wbo.setAttribute("hide", row.getString("HIDE"));
                }
                
                if (row.getString("TOTAL") != null) {
                    wbo.setAttribute("total", row.getString("TOTAL"));
                }
                
                result.add(wbo);
            }
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        
        return result;
    }

    public ArrayList<WebBusinessObject> getEquipmentInfo(String prjIDRes) {
        ArrayList<WebBusinessObject> data = new ArrayList<>();
        Vector params = new Vector();
        WebBusinessObject wbo;
        Connection connection = null;

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        params.addElement(new StringValue(prjIDRes));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getEquipmentInfo").trim());
            forQuery.setparams(params);

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        
        Row r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = new WebBusinessObject();
                try {
                    if (r.getString("EQID") != null) {
                        wbo.setAttribute("EqID", r.getString("EQID"));
                    }
                    
                    if (r.getString("EQNAME") != null) {
                        wbo.setAttribute("EqName", r.getString("EQNAME"));
                    }

                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        
        return data;
    }

    public List<WebBusinessObject> getBusinessItems(String locType) {
        Vector params = new Vector();
        params.addElement(new StringValue(locType));

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;
        String query = getQuery("getBusinessItems");
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        
        List<WebBusinessObject> resultObjs = new ArrayList<WebBusinessObject>();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultObjs.add(wbo);
        }
        
        return resultObjs;
    }

    public List<WebBusinessObject> getassetreports() {
        Vector params = new Vector();
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;
        //String que = getQuery("getassetreport");
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getassetreportnew").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            System.out.print("SQL Exception  " + ex.getMessage());
            logger.error("SQL Exception  " + ex.getMessage());
            Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException sq) {
                logger.error(sq.getMessage());
            }
        }
        
        ArrayList<WebBusinessObject> rowobject = new ArrayList<WebBusinessObject>();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("assetName") != null) {
                    wbo.setAttribute("assetName", r.getString("assetName"));
                } else {
                    wbo.setAttribute("assetName", "");
                }

                if (r.getString("assetClass") != null) {
                    wbo.setAttribute("assetClass", r.getString("assetClass"));
                } else {
                    wbo.setAttribute("assetClass", "");
                }

                if (r.getString("branch") != null) {
                    wbo.setAttribute("branch", r.getString("branch"));
                } else {
                    wbo.setAttribute("branch", "");
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            rowobject.add(wbo);
        }

        return rowobject;
    }

    public boolean delasset(String id) {
        boolean isDeleted = false;
        Vector params = new Vector();
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        //String que = getQuery("getassetreport");
        SQLCommandBean forQuery = new SQLCommandBean();
        params.addElement(new StringValue(id));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("deleteasset").trim());
            forQuery.setparams(params);
            forQuery.executeUpdate();
            endTransaction();
        } catch (Exception EX) {
            isDeleted = false;
        }
        
        return isDeleted;
    }

    public boolean updateassets(String optionone, String optiontwo, String classs, String assetId) {
        boolean isupdated = false;
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult;
        Connection connection = null;
        WebBusinessObject wbo = new WebBusinessObject();

        StringBuilder where = new StringBuilder();
        if (optionone != null && !optionone.equals("")) {
            where.append("OPTION_ONE= ?");
            params.addElement(new StringValue(optionone));
        }

        if (classs != null && !classs.equals("")) {
            if (where.length() > 0) {
                where.append(", ");
            }
            where.append("OPTION_TWO= ?");

            params.addElement(new StringValue(classs));
        }
        
        if (optiontwo != null && !optiontwo.equals("")) {
            if (where.length() > 0) {
                where.append(", ");
            }
            where.append("MAIN_PROJ_ID= ?");
            params.addElement(new StringValue(optiontwo));
        }

        params.addElement(new StringValue(assetId));
        try {
            connection = dataSource.getConnection();
            beginTransaction();
            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(getQuery("updateasset").replaceFirst("whereStatement", where.toString()).trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            cashData();
            isupdated = true;
        } catch (SQLException ex) {
            Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            isupdated = false;
        } finally {
            endTransaction();
        }
        
        return isupdated;
    }

    public ArrayList<WebBusinessObject> getProjectsInRegion(String regionID) {
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        try {
            String query = getQuery("getProjectsInRegion").trim().replace("regionID", regionID);
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        Row r;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> accurateUnitSearch(String regionID, String projectID, String unitArea, String description) {
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        StringBuilder query = new StringBuilder(getQuery("accurateUnitSearch").trim());
        if (regionID != null && !regionID.isEmpty() && !regionID.equals("all")) {
            query.append(" AND PZ.ZONE_ID = '").append(regionID).append("'");
        }
        
        if (projectID != null && !projectID.isEmpty() && !projectID.equals("all")) {
            query.append(" AND PZ.PROJECT_ID = '").append(projectID).append("'");
        }
        
        if (unitArea != null && !unitArea.isEmpty() && !unitArea.equals("all")) {
            if ("100".equals(unitArea)) {
                query.append(" AND UP.MAX_PRICE < 100");
            } else if ("220".equals(unitArea)) {
                query.append(" AND UP.MAX_PRICE > 220");
            } else if (unitArea.contains("-")) {
                String[] areas = unitArea.split("-");
                if (areas.length == 2) {
                    query.append(" AND UP.MAX_PRICE >= ").append(areas[0]);
                    query.append(" AND UP.MAX_PRICE <= ").append(areas[1]);
                }
            }
        }
        
        if (description != null) {
            query.append(" AND P.PROJECT_DESCRIPTION LIKE '%").append(description).append("%'");
        }
        
        try {
            printMyQueries();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        Row r;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("NAME"));
                }
                
                if (r.getString("MOBILE") != null) {
                    wbo.setAttribute("clientMobile", r.getString("MOBILE"));
                }
                
                if (r.getString("UNIT_ID") != null) {
                    wbo.setAttribute("unitID", r.getString("UNIT_ID"));
                }
                
                if (r.getString("UNIT_NAME") != null) {
                    wbo.setAttribute("unitName", r.getString("UNIT_NAME"));
                }
                
                if (r.getString("REGION_ID") != null) {
                    wbo.setAttribute("regionID", r.getString("REGION_ID"));
                }
                
                if (r.getString("REGION_NAME") != null) {
                    wbo.setAttribute("regionName", r.getString("REGION_NAME"));
                }
                
                if (r.getString("AREA") != null) {
                    wbo.setAttribute("area", r.getString("AREA"));
                }
                
                if (r.getString("PRICE") != null) {
                    wbo.setAttribute("price", r.getString("PRICE"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> getAreasSales(java.sql.Date fromDate, java.sql.Date toDate) {
        Vector param = new Vector();
        Connection connection = null;
        Vector<Row> rows = null;
        SQLCommandBean command = new SQLCommandBean();
        WebBusinessObject wbo;
        ArrayList<WebBusinessObject> result = new ArrayList<>();
        StringBuilder where = new StringBuilder();
        if (fromDate != null) {
            where.append(" AND TRUNC(P.CREATION_TIME) >= ?");
            param.addElement(new DateValue(fromDate));
        }
        
        if (toDate != null) {
            where.append(" AND TRUNC(P.CREATION_TIME) <= ?");
            param.addElement(new DateValue(toDate));
        }
        
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getAreasSales").replaceFirst("whereStatement", where.toString()).trim());
            command.setparams(param);
            rows = command.executeQuery();
            for (Row row : rows) {
                wbo = fabricateBusObj(row);
                if (row.getString("AVAILABLE") != null) {
                    wbo.setAttribute("available", row.getString("AVAILABLE"));
                }
                
                if (row.getString("RESERVED") != null) {
                    wbo.setAttribute("reserved", row.getString("RESERVED"));
                }
                
                if (row.getString("SOLD") != null) {
                    wbo.setAttribute("sold", row.getString("SOLD"));
                }
                
                if (row.getString("HIDE") != null) {
                    wbo.setAttribute("hide", row.getString("HIDE"));
                }
                
                if (row.getString("TOTAL") != null) {
                    wbo.setAttribute("total", row.getString("TOTAL"));
                }
                
                if (row.getString("AREA") != null) {
                    wbo.setAttribute("area", row.getString("AREA"));
                }
                
                result.add(wbo);
            }
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        
        return result;
    }
    
     public ArrayList<WebBusinessObject> getAllUnitInfo(String mainPrj) {
        Vector param = new Vector();
        Connection connection = null;
        Vector<Row> rows = null;
        SQLCommandBean command = new SQLCommandBean();
        WebBusinessObject wbo;
        ArrayList<WebBusinessObject> result = new ArrayList<>();
	
	String query = getQuery("getAllUnitInfo");
	if(mainPrj != null && !mainPrj.isEmpty() && mainPrj!= ""){
	    param.addElement(new StringValue(mainPrj));
	    query += " AND PRJ.PROJECT_ID = ? ";
	}
         
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.trim());
            command.setparams(param);
            rows = command.executeQuery();
            for (Row row : rows) {
                wbo = fabricateBusObj(row);
                if (row.getString("PROJECT_ID") != null) {
                    wbo.setAttribute("projectID", row.getString("PROJECT_ID"));
                }
		
                if (row.getString("PROJECT_NAME") != null) {
                    wbo.setAttribute("projectName", row.getString("PROJECT_NAME"));
                }
                
                if (row.getString("NEW_CODE") != null) {
                    wbo.setAttribute("newCode", row.getString("NEW_CODE"));
                }
		
                if (row.getString("STATUS_NAME") != null) {
                    wbo.setAttribute("statusID", row.getString("STATUS_NAME"));
                }
		
                if (row.getString("CASE_AR") != null) {
                    wbo.setAttribute("statusNameAr", row.getString("CASE_AR"));
                }
		
                if (row.getString("CASE_EN") != null) {
                    wbo.setAttribute("statusNameEn", row.getString("CASE_EN"));
                }
		
		if (row.getString("FULL_NAME") != null) {
                    wbo.setAttribute("createdBy", row.getString("FULL_NAME"));
                }
		
		if (row.getString("CREATION_TIME") != null) {
                    wbo.setAttribute("creationTime", row.getString("CREATION_TIME"));
                }
		
		if (row.getString("PRJNM") != null) {
                    wbo.setAttribute("prjNm", row.getString("PRJNM"));
                }
                
                result.add(wbo);
            } 
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        
        return result;
    }
    
    public String getActionRate(String actionValue) {
        Vector param = new Vector();
        Connection connection = null;
        Vector<Row> rows = null;
        SQLCommandBean command = new SQLCommandBean();
        String query = getQuery("getActionRate");
        param.addElement(new StringValue(actionValue));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.trim());
            command.setparams(param);
            rows = command.executeQuery();
            for (Row row : rows) {
                if (row.getString("RATE_ID") != null) {
                    return row.getString("RATE_ID");
                }
            }
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (NoSuchColumnException ex) {
            Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        
        return null;
    }
    
    public Vector getBuildingUnits(String type,String buildingCode, String departmentID, String projectsIDs) {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        params.addElement(new StringValue(departmentID));
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        StringBuilder where = new StringBuilder();
        String qText="getUnitsFromProjectLike";
        if (type.equalsIgnoreCase("2")){
            qText="getSoldUnitFromProjLike";
        }
        
        if (projectsIDs != null && !projectsIDs.isEmpty()) {
            where.append(" AND P.PROJECT_ID IN ('").append(projectsIDs).append("') ");
        }
        try {
            String query = new String();
            query = getQuery(qText).trim().replaceAll("uuu", "AND LOWER(u.PROJECT_NAME) like '%" + buildingCode.toLowerCase() + "%'");
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query + where.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        Vector resultBusObjs = new Vector();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("NAME") != null) {
                    if(r.getString("STATUS_NAME").equalsIgnoreCase("9") || r.getString("STATUS_NAME").equalsIgnoreCase("10")){
                        wbo.setAttribute("clientName", r.getString("NAME"));
                    } else {
                        wbo.setAttribute("clientName", "");
                    }
                } else {
                    wbo.setAttribute("clientName", "");
                }
                
                if (r.getString("AGE_GROUP") != null) {
                    wbo.setAttribute("clientType", r.getString("AGE_GROUP"));
                }
                
                if (r.getString("SYS_ID") != null) {
                    wbo.setAttribute("clientId", r.getString("SYS_ID"));
                }
                
                if (r.getString("PARENT_NAME") != null) {
                    wbo.setAttribute("parentName", r.getString("PARENT_NAME"));
                }
                
                if (r.getString("MODEL_NAME") != null) {
                    wbo.setAttribute("modelName", r.getString("MODEL_NAME"));
                }
                
                if (r.getString("STATUS_NAME") != null) {
                    wbo.setAttribute("statusName", r.getString("STATUS_NAME"));
                }
                
                if (r.getString("MAIN_PROJ_ID") != null) {
                    wbo.setAttribute("mainProjId", r.getString("MAIN_PROJ_ID"));
                }
                
                if (r.getString("EQ_NO") != null) {
                    wbo.setAttribute("Model_Code", r.getString("EQ_NO"));
                }
                
                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("fullName", r.getString("FULL_NAME"));
                }
                
                if (r.getString("OWNER_ID") != null) {
                    wbo.setAttribute("ownerID", r.getString("OWNER_ID"));
                }
                
                if (r.getString("PRICE") != null) {
                    wbo.setAttribute("price", r.getString("PRICE"));
                } else {
		    wbo.setAttribute("price", "0");
		}
                
		if (r.getString("TOTAL_AREA") != null) {
                    wbo.setAttribute("totalArea", r.getString("TOTAL_AREA"));
                }
                
		if (r.getString("AREA") != null) {
                    wbo.setAttribute("area", r.getString("AREA"));
                } else {
		     wbo.setAttribute("area", "0");
		}
		if (r.getString("DOC_ID") != null) {
                    wbo.setAttribute("documentID", r.getString("DOC_ID"));
                }if (r.getString("OPTION_THREE") != null) {
                    wbo.setAttribute("OPTION3", r.getString("OPTION_THREE"));
                }
                if (type.equalsIgnoreCase("2")){
                if (r.getString("MOBILE") != null) {
                    wbo.setAttribute("mobile", r.getString("MOBILE"));
                } else {
                    wbo.setAttribute("MOBILE", "---");
                }
                if (r.getString("EMAIL") != null) {
                    wbo.setAttribute("EMAIL", r.getString("EMAIL"));
                } else {
                    wbo.setAttribute("EMAIL", "---");
                }
                if (r.getString("KNOWUSFROM") != null) {
                    wbo.setAttribute("knowUsFrom", r.getString("KNOWUSFROM"));
                } else {
                    wbo.setAttribute("knowUsFrom", "---");
                }
                if (r.getString("timeBefPurch") != null) {
                    wbo.setAttribute("timeBefPurch", r.getString("timeBefPurch"));
                } else {
                    wbo.setAttribute("timeBefPurch", "---");
                }
                if (r.getString("clientCreTime") != null) {
                    wbo.setAttribute("clientCreTime", r.getString("clientCreTime"));
                } else {
                    wbo.setAttribute("clientCreTime", "---");
                }
                if (r.getString("purchaseTime") != null) {
                    wbo.setAttribute("purchaseTime", r.getString("purchaseTime"));
                } else {
                    wbo.setAttribute("purchaseTime", "---");
                }
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }
    
    public List<WebBusinessObject> getFcltyWrkrLst(String clientID, String fcltyID, String branchID) {
        Vector params = new Vector();
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        if (clientID != null && (fcltyID == null || fcltyID.isEmpty()) && (branchID == null || branchID.isEmpty())) {
            params.addElement(new StringValue(clientID));
        } else if (fcltyID != null && (branchID == null || branchID.isEmpty())) {
            params.addElement(new StringValue(fcltyID));
        } else if (branchID != null) {
            params.addElement(new StringValue(branchID));
        }

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            if (clientID != null && (fcltyID == null || fcltyID.isEmpty()) && (branchID == null || branchID.isEmpty())) {
                forQuery.setSQLQuery(getQuery("getClntWrkrLst").trim());
            } else if (fcltyID != null && (branchID == null || branchID.isEmpty())) {
                forQuery.setSQLQuery(getQuery("getFcltyWrkrLst").trim());
            } else if (branchID != null) {
                forQuery.setSQLQuery(getQuery("getClntFcltyWrkrLst").trim());
            } else {
                forQuery.setSQLQuery(getQuery("getAllFcltyWrkrLst").trim());
            }
            
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
            Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException sq) {
                logger.error(sq.getMessage());
            }
        }
        
        ArrayList<WebBusinessObject> rowobject = new ArrayList<WebBusinessObject>();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            //wbo = fabricateBusObj(r);
            try {
                if (r.getString("EMP_ID") != null) {
                    wbo.setAttribute("wrkrID", r.getString("EMP_ID"));
                } else {
                    wbo.setAttribute("wrkrID", "");
                }

                if (r.getString("EMP_NO") != null) {
                    wbo.setAttribute("wrkrNo", r.getString("EMP_NO"));
                } else {
                    wbo.setAttribute("wrkrNo", "");
                }

                if (r.getString("EMP_NAME") != null) {
                    wbo.setAttribute("wrkrNm", r.getString("EMP_NAME"));
                } else {
                    wbo.setAttribute("wrkrNm", "");
                }

                if (r.getString("WORK_PHONE") != null) {
                    wbo.setAttribute("wrkrMbl", r.getString("WORK_PHONE"));
                } else {
                    wbo.setAttribute("wrkrMbl", "");
                }

                if (r.getString("EMAIL") != null) {
                    wbo.setAttribute("wrkrMl", r.getString("EMAIL"));
                } else {
                    wbo.setAttribute("wrkrMl", "");
                }

                if (r.getString("SHFT_ID") != null) {
                    wbo.setAttribute("wrkrSft", r.getString("SHFT_ID"));
                } else {
                    wbo.setAttribute("wrkrShft", "");
                }
                
                if (r.getString("RATE") != null) {
                    wbo.setAttribute("wrkrRt", r.getString("RATE"));
                } else {
                    wbo.setAttribute("wrkrRt", "");
                }

                if (r.getString("CREATION_TIME") != null) {
                    wbo.setAttribute("creationTime", r.getString("CREATION_TIME"));
                } else {
                    wbo.setAttribute("creationTime", "");
                }

                if (r.getString("FULL_NAME") != null) {
                    wbo.setAttribute("createdBy", r.getString("FULL_NAME"));
                } else {
                    wbo.setAttribute("createdBy", "");
                }
                
                if (r.getString("CLINTNM") != null) {
                    wbo.setAttribute("Branch", r.getString("CLINTNM"));
                } else {
                    wbo.setAttribute("Branch", "");
                }
                
                if (r.getString("CLINTId") != null) {
                    wbo.setAttribute("brunch_id", r.getString("CLINTId"));
                } else {
                    wbo.setAttribute("brunch_id", "");
                }
                
                if (r.getString("row_id") != null) {
                    wbo.setAttribute("row_id", r.getString("row_id"));
                } else {
                    wbo.setAttribute("row_id", "");
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            rowobject.add(wbo);
        }

        return rowobject;
    }
    
     public ArrayList<WebBusinessObject> getInforationProj(String projectName,String projectDatabase) {
        String userId = (String) projectDatabase;
        String getAssetErpName = metaDataMgr.getAssetErpName().toString();
        String getAssetErpPassword = metaDataMgr.getAssetErpPassword().toString();
        String dataBaseRealEstat = null;
        Vector params = new Vector();
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        params.addElement(new StringValue(projectName));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            if (userId.equals(getAssetErpName)){
               forQuery.setSQLQuery(getQuery("getProjectForRealEstate").trim());            
            } else if (userId.equals(getAssetErpPassword)){
               forQuery.setSQLQuery(getQuery("getProjectForRealEstate2").trim());            
            } 
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
            Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException sq) {
                logger.error(sq.getMessage());
            }
        }
        
        ArrayList<WebBusinessObject> rowobject = new ArrayList<WebBusinessObject>();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            //wbo = fabricateBusObj(r);
            try {
                if (r.getString("STAGE_CODE") != null) {
                    wbo.setAttribute("STAGE_CODE", r.getString("STAGE_CODE"));
                } else {
                    wbo.setAttribute("STAGE_CODE", "");
                }

                if (r.getString("SECTION_CODE") != null) {
                    wbo.setAttribute("SECTION_CODE", r.getString("SECTION_CODE"));
                } else {
                    wbo.setAttribute("SECTION_CODE", "");
                }

                if (r.getString("SUBSTAGE_CODE") != null) {
                    wbo.setAttribute("SUBSTAGE_CODE", r.getString("SUBSTAGE_CODE"));
                } else {
                    wbo.setAttribute("SUBSTAGE_CODE", "");
                }

                if (r.getString("SAMPLE_CODE") != null) {
                    wbo.setAttribute("SAMPLE_CODE", r.getString("SAMPLE_CODE"));
                } else {
                    wbo.setAttribute("SAMPLE_CODE", "");
                }

                if (r.getString("BUILDING_CODE") != null) {
                    wbo.setAttribute("BUILDING_CODE", r.getString("BUILDING_CODE"));
                } else {
                    wbo.setAttribute("BUILDING_CODE", "");
                }

                if (r.getString("BUILDING_TYPE") != null) {
                    wbo.setAttribute("BUILDING_TYPE", r.getString("BUILDING_TYPE"));
                } else {
                    wbo.setAttribute("BUILDING_TYPE", "");
                }
                
                if (r.getString("UNIT_CODE") != null) {
                    wbo.setAttribute("UNIT_CODE", r.getString("UNIT_CODE"));
                } else {
                    wbo.setAttribute("UNIT_CODE", "");
                }

                if (r.getString("UNIT_TOTAL_PRICE") != null) {
                    wbo.setAttribute("UNIT_TOTAL_PRICE", r.getString("UNIT_TOTAL_PRICE"));
                } else {
                    wbo.setAttribute("UNIT_TOTAL_PRICE", "");
                }

                if (r.getString("UNIT_BUILDINGS_AREA") != null) {
                    wbo.setAttribute("UNIT_BUILDINGS_AREA", r.getString("UNIT_BUILDINGS_AREA"));
                } else {
                    wbo.setAttribute("UNIT_BUILDINGS_AREA", "");
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            rowobject.add(wbo);
        }

        return rowobject;
    }
    
     
        public ArrayList<WebBusinessObject> getTempForm(String clientNameCard,String projectNameCard) {
        Vector params = new Vector();
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        params.addElement(new StringValue(clientNameCard));
        params.addElement(new StringValue(projectNameCard));

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getReservClientCard").trim());            
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
            Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException sq) {
                logger.error(sq.getMessage());
            }
        }
        
        ArrayList<WebBusinessObject> rowobject = new ArrayList<WebBusinessObject>();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            //wbo = fabricateBusObj(r);
            try {
                if (r.getString("RESERVE_FORM_DATE") != null) {
                    wbo.setAttribute("RESERVE_FORM_DATE", r.getString("RESERVE_FORM_DATE"));
                } else {
                    wbo.setAttribute("RESERVE_FORM_DATE", "");
                }

                if (r.getString("DEPOSIT_RETURNED") != null) {
                    wbo.setAttribute("CLIENT_CODE", r.getString("DEPOSIT_RETURNED"));
                } else {
                    wbo.setAttribute("CLIENT_CODE", "");
                }

                if (r.getString("STAGE_CODE") != null) {
                    wbo.setAttribute("STAGE_CODE", r.getString("STAGE_CODE"));
                } else {
                    wbo.setAttribute("STAGE_CODE", "");
                }

                if (r.getString("SECTION_CODE") != null) {
                    wbo.setAttribute("SECTION_CODE", r.getString("SECTION_CODE"));
                } else {
                    wbo.setAttribute("SECTION_CODE", "");
                }

                if (r.getString("SUBSTAGE_CODE") != null) {
                    wbo.setAttribute("SUBSTAGE_CODE", r.getString("SUBSTAGE_CODE"));
                } else {
                    wbo.setAttribute("SUBSTAGE_CODE", "");
                }

                if (r.getString("SAMPLE_CODE") != null) {
                    wbo.setAttribute("SAMPLE_CODE", r.getString("SAMPLE_CODE"));
                } else {
                    wbo.setAttribute("SAMPLE_CODE", "");
                }
                
                if (r.getString("BUILDING_CODE") != null) {
                    wbo.setAttribute("BUILDING_CODE", r.getString("BUILDING_CODE"));
                } else {
                    wbo.setAttribute("BUILDING_CODE", "");
                }

                if (r.getString("BUILDING_TYPE") != null) {
                    wbo.setAttribute("BUILDING_TYPE", r.getString("BUILDING_TYPE"));
                } else {
                    wbo.setAttribute("BUILDING_TYPE", "");
                }

                if (r.getString("UNIT_CODE") != null) {
                    wbo.setAttribute("UNIT_CODE", r.getString("UNIT_CODE"));
                } else {
                    wbo.setAttribute("UNIT_CODE", "");
                }
                if (r.getString("INSTALMENT_TYPE_CODE") != null) {
                    wbo.setAttribute("INSTALMENT_TYPE_CODE", r.getString("INSTALMENT_TYPE_CODE"));
                } else {
                    wbo.setAttribute("INSTALMENT_TYPE_CODE", "");
                }
                if (r.getString("DOWN_PAYMENT") != null) {
                    wbo.setAttribute("DOWN_PAYMENT", r.getString("DOWN_PAYMENT"));
                } else {
                    wbo.setAttribute("DOWN_PAYMENT", "");
                }
                if (r.getString("RECEIPT_NO") != null) {
                    wbo.setAttribute("RECEIPT_NO", r.getString("RECEIPT_NO"));
                } else {
                    wbo.setAttribute("RECEIPT_NO", "");
                }
                if (r.getString("PAYMENT_METHOD") != null) {
                    wbo.setAttribute("PAYMENT_METHOD", r.getString("PAYMENT_METHOD"));
                } else {
                    wbo.setAttribute("PAYMENT_METHOD", "");
                }
                if (r.getString("SOURCE") != null) {
                    wbo.setAttribute("SOURCE", r.getString("SOURCE"));
                } else {
                    wbo.setAttribute("SOURCE", "");
                }
                if (r.getString("EXPIRATION_DATE") != null) {
                    wbo.setAttribute("EXPIRATION_DATE", r.getString("EXPIRATION_DATE"));
                } else {
                    wbo.setAttribute("EXPIRATION_DATE", "");
                }
                if (r.getString("UNIT_TYPE") != null) {
                    wbo.setAttribute("UNIT_TYPE", r.getString("UNIT_TYPE"));
                } else {
                    wbo.setAttribute("EXPIRATION_DATE", "");
                }
                if (r.getString("UNIT_TYPE") != null) {
                    wbo.setAttribute("UNIT_TYPE", r.getString("UNIT_TYPE"));
                } else {
                    wbo.setAttribute("UNIT_TYPE", "");
                }
                if (r.getString("PROJECT") != null) {
                    wbo.setAttribute("PROJECT", r.getString("PROJECT"));
                } else {
                    wbo.setAttribute("PROJECT", "");
                }
                if (r.getString("UNIT_TOTAL") != null) {
                    wbo.setAttribute("UNIT_TOTAL", r.getString("UNIT_TOTAL"));
                } else {
                    wbo.setAttribute("UNIT_TOTAL", "");
                }
                if (r.getString("AREA") != null) {
                    wbo.setAttribute("AREA", r.getString("AREA"));
                } else {
                    wbo.setAttribute("AREA", "");
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }

            rowobject.add(wbo);
        }

        return rowobject;
    }
    
    public boolean delfacilityworker(String id, String comment, String reason) {
        boolean isDeleted = false;
        Vector params = new Vector();
        int queryResult;
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        SQLCommandBean forUpdate = new SQLCommandBean();
        params.addElement(new StringValue(comment));
        params.addElement(new StringValue(reason));
        params.addElement(new StringValue(id));
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("delfacilityworker").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            isDeleted = true;
        } catch (Exception EX) {
            isDeleted = false;
        }
        
        return isDeleted;
    }
    
    public boolean updateFacilityWorkers(String branch,String shift , String row_id, String Wid, String Rid, String Sid, String loggegUserId) {
        boolean isupdated = false;
        if(shift != null && !shift.equals("")){
            Vector params = new Vector();
            SQLCommandBean forUpdate = new SQLCommandBean();
            int queryResult;
            Connection connection = null;
            WebBusinessObject wbo = new WebBusinessObject();

            StringBuilder where = new StringBuilder();

            params.addElement(new StringValue(shift));
            params.addElement(new StringValue(row_id));
            try {
                connection = dataSource.getConnection();
                beginTransaction();
                forUpdate.setConnection(transConnection);
                forUpdate.setSQLQuery(getQuery("updateshift"));
                forUpdate.setparams(params);
                queryResult = forUpdate.executeUpdate();
                cashData();
                isupdated = true;
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
                isupdated = false;
            } finally {
                endTransaction();
            }
        } else {
            Vector params = new Vector();
            Vector params1 = new Vector();
            SQLCommandBean forUpdate = new SQLCommandBean();
            int queryResult;
            Connection connection = null;
            WebBusinessObject wbo = new WebBusinessObject();

            StringBuilder where = new StringBuilder();
            
            String facilityId = UniqueIDGen.getNextID();
            
            params1.addElement(new StringValue(facilityId));
            params1.addElement(new StringValue(Wid));
            params1.addElement(new StringValue(branch));
            params1.addElement(new StringValue(Sid));
            params1.addElement(new StringValue(loggegUserId));
            params1.addElement(new StringValue(Rid != null && !Rid.isEmpty() ? Rid : "0"));
            
            params.addElement(new StringValue(row_id));
            try {
                connection = dataSource.getConnection();
                beginTransaction();
                forUpdate.setConnection(transConnection);
                forUpdate.setSQLQuery(getQuery("updatefacilityworker"));
                forUpdate.setparams(params);
                queryResult = forUpdate.executeUpdate();
                isupdated = true;
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
                isupdated = false;
            }
            
            try {
                connection = dataSource.getConnection();
                beginTransaction();
                forUpdate.setConnection(transConnection);
                forUpdate.setSQLQuery(getQuery("insertfacilityworker"));
                forUpdate.setparams(params1);
                queryResult = forUpdate.executeUpdate();
                isupdated = true;
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
                isupdated = false;
            }
            
            finally {
                endTransaction();
            }
        }
        
        return isupdated;
    }
    
    public List<WebBusinessObject> getWorkersReport(String availableTypStr) {
        Vector params = new Vector();
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
	StringBuilder availableTyp = new StringBuilder();
	
	if(availableTypStr != null && availableTypStr.equals("android")){
	    availableTyp.append(" AND ( CLIENT.SYS_ID NOT IN (SELECT AD.VEHICLE_ID FROM ANDROID_DEVICES AD) )");
	} else {
	    availableTyp.append(" AND (CLIENT.SYS_ID NOT IN (SELECT CNFG_ID FROM FCLTY_CNFG WHERE ASS_END_DATE IS NULL)) ");
	}
	
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getworkersreport").trim() + availableTyp.toString());
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
            Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException sq) {
                logger.error(sq.getMessage());
            }
        }
        
        ArrayList<WebBusinessObject> rowobject = new ArrayList<WebBusinessObject>();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            try {
                if (r.getString("SYS_ID") != null) {
                    wbo.setAttribute("id", r.getString("SYS_ID"));
                } else {
                    wbo.setAttribute("id", "");
                }

                if (r.getString("CLIENT_NO") != null) {
                    wbo.setAttribute("no", r.getString("CLIENT_NO"));
                } else {
                    wbo.setAttribute("no", "");
                }

                if (r.getString("NAME") != null) {
                    wbo.setAttribute("name", r.getString("NAME"));
                } else {
                    wbo.setAttribute("name", "");
                }

                if (r.getString("MOBILE") != null) {
                    wbo.setAttribute("mobile", r.getString("MOBILE"));
                } else {
                    wbo.setAttribute("mobile", "");
                }

                if (r.getString("EMAIL") != null) {
                    wbo.setAttribute("email", r.getString("EMAIL"));
                } else {
                    wbo.setAttribute("email", "");
                }
                
                if (r.getString("CREATION_TIME") != null) {
                    wbo.setAttribute("creationTime", r.getString("CREATION_TIME"));
                } else {
                    wbo.setAttribute("creationTime", "");
                }
                
                if (r.getString("job") != null) {
                    wbo.setAttribute("job", r.getString("job"));
                } else {
                    wbo.setAttribute("job", "");
                }
                
                if (r.getString("specialization") != null) {
                    wbo.setAttribute("specialization", r.getString("specialization"));
                } else {
                    wbo.setAttribute("specialization", "");
                }

                if (r.getString("RATE") != null) {
                    wbo.setAttribute("rate", r.getString("RATE"));
                } else {
                    wbo.setAttribute("rate", "");
                }

                if (r.getString("UNIT") != null) {
                    wbo.setAttribute("unit", r.getString("UNIT"));
                } else {
                    wbo.setAttribute("unit", "");
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            rowobject.add(wbo);
        }
        
        return rowobject;
    }
    
    public Vector getSoldUnitsLstFiltered(String fieldValue) throws NoUserInSessionException {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        StringBuilder where = new StringBuilder();
        
        
        try {
            String query = getQuery("getSoldUnitsLstFiltered").trim().replaceAll("ABC", fieldValue);;
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query + where.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        Vector resultBusObjs = new Vector();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }
    
    public Vector getSoldUnitsLst() throws NoUserInSessionException {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        StringBuilder where = new StringBuilder();
        
        
        try {
            String query = getQuery("getSoldUnitsLst").trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query + where.toString());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        Vector resultBusObjs = new Vector();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }
        
        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> getUnitDelivery(String departmentID, String projectID) {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        params.addElement(new StringValue("تاريخ التسليم"));
        params.addElement(new StringValue(departmentID));
        params.addElement(new StringValue(projectID));
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        try {
            String query = getQuery("getUnitDelivery").trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        ArrayList<WebBusinessObject> results = new ArrayList<>();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                wbo.setAttribute("clientName", r.getString("NAME") != null ? r.getString("NAME") : "");
                wbo.setAttribute("parentName", r.getString("PARENT_NAME") != null ? r.getString("PARENT_NAME") : "");
                wbo.setAttribute("ownerID", r.getString("OWNER_ID") != null ? r.getString("OWNER_ID") : "");
                if (r.getString("DOC_ID") != null) {
                    wbo.setAttribute("documentID", r.getString("DOC_ID"));
                }
                if (r.getString("DELIVERY_DATE") != null) {
                    wbo.setAttribute("deliveryDate", r.getString("DELIVERY_DATE"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            results.add(wbo);
        }
        return results;
    }//
    
    public boolean updateProjectNameAndCode(String projectID, String name, String code) {
        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue(name));
        params.addElement(new StringValue(code));
        params.addElement(new StringValue(projectID));
        try {
            beginTransaction();
            forUpdate.setConnection(transConnection);
            forUpdate.setSQLQuery(getQuery("updateProjectNameAndCode").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();
        }
        return (queryResult > 0);
    }
    
    public Vector getAllUnitsWithPriceAndDetails(String departmentID, String unitStatus, String projectID) {
        Vector queryResult = new Vector();
        Vector params = new Vector();
        params.addElement(new StringValue(departmentID));
        params.addElement(new StringValue(unitStatus));
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        StringBuilder where = new StringBuilder();
        if(projectID != null && !projectID.isEmpty()){
            where.append(" AND U.MAIN_PROJ_ID = ? ");
            params.addElement(new StringValue(projectID));
        }
        try {
            String query = getQuery("getAllUnitsWithPriceAndDetails").replaceAll("whereStatement", where.toString()).trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        Vector resultBusObjs = new Vector();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("NAME"));
                }
                if (r.getString("AGE_GROUP") != null) {
                    wbo.setAttribute("clientType", r.getString("AGE_GROUP"));
                }
                if (r.getString("SYS_ID") != null) {
                    wbo.setAttribute("clientId", r.getString("SYS_ID"));
                }
                if (r.getString("PARENT_NAME") != null) {
                    wbo.setAttribute("parentName", r.getString("PARENT_NAME"));
                }
                if (r.getString("STATUS_NAME") != null) {
                    wbo.setAttribute("statusName", r.getString("STATUS_NAME"));
                }
                if (r.getString("MAIN_PROJ_ID") != null) {
                    wbo.setAttribute("mainProjId", r.getString("MAIN_PROJ_ID"));
                }
                if (r.getString("EQ_NO") != null) {
                    wbo.setAttribute("Model_Code", r.getString("EQ_NO"));
                }
                if (r.getString("AREA") != null) {
                    wbo.setAttribute("area", r.getString("AREA"));
                }
                if (r.getString("PRICE") != null) {
                    wbo.setAttribute("price", r.getString("PRICE"));
                }
                if (r.getString("METER_PRICE") != null) {
                    wbo.setAttribute("meterPrice", r.getString("METER_PRICE"));
                }
                if (r.getString("ADDON_NAME") != null) {
                    wbo.setAttribute("addonName", r.getString("ADDON_NAME"));
                }
                if (r.getString("ADDON_PRICE") != null) {
                    wbo.setAttribute("addonPrice", r.getString("ADDON_PRICE"));
                }
                if (r.getString("ADDON_AREA") != null) {
                    wbo.setAttribute("addonArea", r.getString("ADDON_AREA"));
                }
                if (r.getString("LEVEL_NAME") != null) {
                    wbo.setAttribute("levelName", r.getString("LEVEL_NAME"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> getVirtualBuildingsNo() {
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        try {
            String query = getQuery("getVirtualBuildingsNo").trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        ArrayList<WebBusinessObject> results = new ArrayList<>();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("BUILDING_NO") != null) {
                    wbo.setAttribute("buildingNo", r.getString("BUILDING_NO"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            results.add(wbo);
        }
        return results;
    }
    
    public ArrayList<WebBusinessObject> getAllStages(String projectID) {
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        Vector params = new Vector();
        params.addElement(new StringValue(projectID));
        try {
            String query = getQuery("getAllStages").trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        ArrayList<WebBusinessObject> results = new ArrayList<>();
        Row r = null;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("ESTIMATED_FINISH_DATE") != null) {
                    wbo.setAttribute("estimatedFinishDate", r.getString("ESTIMATED_FINISH_DATE"));
                }
                if (r.getString("ESTIMATED_COST") != null) {
                    wbo.setAttribute("estimatedCost", r.getString("ESTIMATED_COST"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            results.add(wbo);
        }
        return results;
    }
    
    public ArrayList<WebBusinessObject> getAreasForProject(String ProjectId) {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;
        String query = getQuery("getAreasForProject");
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
         ArrayList<WebBusinessObject> defaultAreas=new  ArrayList<WebBusinessObject>();
        WebBusinessObject areaWbo= new WebBusinessObject();
        areaWbo.setAttribute("area", "120");
        defaultAreas.add(areaWbo);
        areaWbo= new WebBusinessObject();
        areaWbo.setAttribute("area", "140");
        defaultAreas.add(areaWbo);
        areaWbo= new WebBusinessObject();
        areaWbo.setAttribute("area", "160");
        defaultAreas.add(areaWbo);
        areaWbo= new WebBusinessObject();
        areaWbo.setAttribute("area", "180");
        defaultAreas.add(areaWbo);
        areaWbo= new WebBusinessObject();
        areaWbo.setAttribute("area", "200");
        defaultAreas.add(areaWbo);
        areaWbo= new WebBusinessObject();
        areaWbo.setAttribute("area", "220");
        defaultAreas.add(areaWbo);
        areaWbo= new WebBusinessObject();
        areaWbo.setAttribute("area", "240");
        defaultAreas.add(areaWbo);
        
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            params.addElement(new StringValue(ProjectId));
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        
        ArrayList<WebBusinessObject> resultObjs = new ArrayList<WebBusinessObject>();
        if(queryResult.size()<= 0)
            return defaultAreas;
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            try{
            if(r.getString("MAX_PRICE")!=null) 
                wbo.setAttribute("area",r.getString("MAX_PRICE") );
            else
                wbo.setAttribute("area",r.getString("0") );
            }catch(Exception e1)
            {
                
            }
         resultObjs.add(wbo);

        }
        
        return resultObjs;
    }
    
    public String getLastReq() {
        Connection connection = null;

        String quary = sqlMgr.getSql("getLastReq").trim();

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(quary);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        
        //Vector resAsWbo = new Vector();
        String eq_no = "";
        Row row;
        for (int i = 0; i < queryResult.size(); i++) {
            row = (Row) queryResult.get(i);
            try {
                eq_no = row.getString("eq_no");
            } catch (NoSuchColumnException ex) {
                logger.error(ex.getMessage());
            }
        }

        return eq_no;
    }
    
    public String getLastReq2() {
        Connection connection = null;

        String quary = sqlMgr.getSql("getLastReq2").trim();

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(quary);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        
        //Vector resAsWbo = new Vector();
        String eq_no2 = "";
        Row row;
        for (int i = 0; i < queryResult.size(); i++) {
            row = (Row) queryResult.get(i);
            try {
                eq_no2 = row.getString("eq_no");
            } catch (NoSuchColumnException ex) {
                logger.error(ex.getMessage());
            }
        }

        return eq_no2;
    }
    
    public String getLastReq3() {
        Connection connection = null;

        String quary = sqlMgr.getSql("getLastReq3").trim();

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(quary);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        
        //Vector resAsWbo = new Vector();
        String eq_no3 = "";
        Row row;
        for (int i = 0; i < queryResult.size(); i++) {
            row = (Row) queryResult.get(i);
            try {
                eq_no3 = row.getString("eq_no");
            } catch (NoSuchColumnException ex) {
                logger.error(ex.getMessage());
            }
        }

        return eq_no3;
    }
    

}
