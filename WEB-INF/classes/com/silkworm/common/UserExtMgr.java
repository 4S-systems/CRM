package com.silkworm.common;

import com.maintenance.common.DateParser;
import com.maintenance.common.Tools;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserExtMgr extends RDBGateWay {

    private static final UserExtMgr userExtMgr = new UserExtMgr();
   
 @Override
    protected void initSupportedForm() {
        if (supportedForm == null) {
            try {
                System.out.println("UserMgr ..***********.trying to get the XML file from path:: " + webInfPath);
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("user_ext.xml")));
            } catch (Exception e) {
                System.out.println("Could not locate XML Document");
            }
        }
    }
    
    
 @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1;
        DateParser dateParser = new DateParser();
        params.addElement(new StringValue((String) wbo.getAttribute("userID")));
        params.addElement(new StringValue((String) wbo.getAttribute("CommercialRegister")));
        params.addElement(new StringValue((String) wbo.getAttribute("TaxCardNumber")));
        params.addElement(new StringValue((String) wbo.getAttribute("AuthorizedPerson")));
        params.addElement(new StringValue((String) wbo.getAttribute("companyAddress")));
        params.addElement(new StringValue((String)wbo.getAttribute("RecordDate")));
      //  params.addElement(new DateValue(dateParser.formatSqlDate(((String) wbo.getAttribute("RecordDate")))));
        params.addElement(new StringValue((String) wbo.getAttribute("createdBy")));
        params.addElement(new StringValue((String) wbo.getAttribute("option1")));
        params.addElement(new StringValue((String) wbo.getAttribute("phoneNumber")));//option 2 in table
        params.addElement(new StringValue((String) wbo.getAttribute("option3")));
        params.addElement(new StringValue((String) wbo.getAttribute("option4")));
        params.addElement(new StringValue((String) wbo.getAttribute("option5")));
        params.addElement(new StringValue((String) wbo.getAttribute("option6")));
         try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            String query="INSERT INTO USERS_EXT ( USER_ID,COMMERCIAL_RECORD,TAX_CARD_NUMBER,AUTHORIZED_PERSON,COMPANY_ADDRESS,RECORD_DATE,CREATION_TIME,CREATED_BY,OPTION1,OPTION2,OPTION3,OPTION4,OPTION5,OPTION6) VALUES (?,?,?,?,?,to_date(?, 'yyyy-mm-dd'),SYSDATE,?,?,?,?,?,?,?)";
            forInsert.setSQLQuery(query);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();
        }
        return (queryResult > 0);
    }
    public boolean isExist(String id) throws SQLException
    {
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1;
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            String query="SELECT * FROM RECORD_SEASON WHERE id = "+id;
            forInsert.setSQLQuery(query);
          
            queryResult = forInsert.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();
        }
        return (queryResult > 0);
    }
    
       public boolean updateBoker(WebBusinessObject wbo) throws SQLException {
        Vector params = new Vector();
        Vector paramsOld = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1;
        DateParser dateParser = new DateParser();
        
        paramsOld.addElement(new StringValue((String) wbo.getAttribute("nameBroker")));
        paramsOld.addElement(new StringValue((String) wbo.getAttribute("nameBrokerOld")));
        
        params.addElement(new StringValue((String) wbo.getAttribute("nameBroker")));
        params.addElement(new StringValue((String) wbo.getAttribute("email")));
        params.addElement(new StringValue((String) wbo.getAttribute("CommercialRegister")));
        params.addElement(new StringValue((String) wbo.getAttribute("TaxCardNumber")));
        params.addElement(new StringValue((String)wbo.getAttribute("RecordDate")));
        params.addElement(new StringValue((String) wbo.getAttribute("AuthorizedPerson")));
        params.addElement(new StringValue((String) wbo.getAttribute("companyAddress")));
        params.addElement(new StringValue((String) wbo.getAttribute("phoneNumber")));
        params.addElement(new StringValue((String) wbo.getAttribute("noSales")));
        params.addElement(new StringValue((String) wbo.getAttribute("userID")));
         try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            
            String query2="UPDATE CAMPAIGN SET CAMPAIGN_TITLE = ? WHERE CAMPAIGN_TITLE=? ";
            forInsert.setSQLQuery(query2);
            forInsert.setparams(paramsOld);
            queryResult = forInsert.executeUpdate();
            
            String query="UPDATE RECORD_SEASON SET ENGLISH_NAME = ?,ARABIC_NAME =?,PRE_SHLDER =?,CL_SHLDER =?,TYPICAL_BEGIN_DATE =?,CODE=?,COST=?,IS_FOREVER=?,NOSALES =? WHERE ID=? ";
            forInsert.setSQLQuery(query);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            
            
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();
        }
        return (queryResult > 0);
    }
    public static UserExtMgr getInstance() {
        System.out.println("Getting UserExtMgr Instance ....");
        return userExtMgr;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        cashData();
        return new ArrayList(cashedData);
    }
    
    public ArrayList<WebBusinessObject> getBrokersStatistics(String[] userCampaigns) throws SQLException {
        Connection connection = null;
        Vector<Row> queryResult = new Vector();
        SQLCommandBean command = new SQLCommandBean();
        StringBuilder where = new StringBuilder();
        if (userCampaigns.length > 0) {
            where.append(" WHERE C.ID IN (").append(Tools.concatenation(userCampaigns, ",")).append(")");
        }
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getBrokersStatistics").trim() + where.toString());
            
            queryResult = command.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            connection.close();
        }
        ArrayList<WebBusinessObject> brokersList = new ArrayList<>();
        for (Row r : queryResult) {
            WebBusinessObject wbo = fabricateBusObj(r);
            try {
                wbo.setAttribute("fullName", r.getString("FULL_NAME") != null ? r.getString("FULL_NAME") : "---");
                wbo.setAttribute("campaignID", r.getString("CAMPAIGN_ID") != null ? r.getString("CAMPAIGN_ID") : "---");
                wbo.setAttribute("campaignTitle", r.getString("CAMPAIGN_TITLE") != null ? r.getString("CAMPAIGN_TITLE") : "---");
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(UserExtMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            brokersList.add(wbo);
        }
        return brokersList;
    }
    public ArrayList<WebBusinessObject> getBrokerReservations(String BokerID) throws SQLException {
        Connection connection = null;
        Vector<Row> queryResult = new Vector();
        SQLCommandBean command = new SQLCommandBean();
        Vector params = new Vector();
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery("SELECT * FROM RESERVATION WHERE  OPTION1=?");
            params.addElement(new StringValue(BokerID));
            command.setparams(params);
            queryResult = command.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            connection.close();
        }
        ArrayList<WebBusinessObject> brokersList = new ArrayList<>();
        for (Row r : queryResult) {
            WebBusinessObject wbo = fabricateBusObj(r);
            brokersList.add(wbo);
        }
        return brokersList;
    }
    
    public Map<String, String> getBrokerClientsCount() throws SQLException {
        Connection connection = null;
        Vector<Row> queryResult = new Vector();
        SQLCommandBean command = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getBrokerClientsCount").trim());
            queryResult = command.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            connection.close();
        }
        Map<String, String> brokersMap = new HashMap<>();
        for (Row r : queryResult) {
            try {
                if(r.getString("CLIENT_NO") != null && r.getString("CAMPAIGN_ID") != null) {
                    brokersMap.put(r.getString("CAMPAIGN_ID"), r.getString("CLIENT_NO"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(UserExtMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return brokersMap;
    }
    
    public Map<String, String> getBrokerSoldCount() throws SQLException {
        Connection connection = null;
        Vector<Row> queryResult = new Vector();
        SQLCommandBean command = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getBrokerSoldCount").trim());
            queryResult = command.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            connection.close();
        }
        Map<String, String> brokersMap = new HashMap<>();
        for (Row r : queryResult) {
            try {
                if(r.getString("CLIENT_NO") != null && r.getString("CAMPAIGN_ID") != null) {
                    brokersMap.put(r.getString("CAMPAIGN_ID"), r.getString("CLIENT_NO"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(UserExtMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return brokersMap;
    }
    
    public boolean deleteBroker(String brokerID, String brokerName) {
        Vector param = new Vector();
        try {
            param.addElement(new StringValue(brokerName));
            SQLCommandBean forInsert = new SQLCommandBean();
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("deleteBrokerCampaign").trim());
            forInsert.setparams(param);
            forInsert.executeUpdate();
            forInsert.setSQLQuery(getQuery("deleteBrokerTool").trim());
            forInsert.executeUpdate();
            param = new Vector();
            param.addElement(new StringValue(brokerID));
            forInsert.setSQLQuery(getQuery("deleteBroker").trim());
            forInsert.setparams(param);
            forInsert.executeUpdate();
            return true;
        } catch (SQLException ex) {
            logger.error(ex);
            try {
                transConnection.rollback();
            } catch (SQLException ex1) {
                Logger.getLogger(UserExtMgr.class.getName()).log(Level.SEVERE, null, ex1);
            }
            return false;
        } finally {
            endTransaction();
        }
    }
    
    public ArrayList<WebBusinessObject> getBrokersList(String[] userCampaigns) throws SQLException {
        Connection connection = null;
        Vector<Row> queryResult = new Vector();
        SQLCommandBean command = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getBrokersList").trim());
            
            queryResult = command.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            connection.close();
        }
        ArrayList<WebBusinessObject> brokersList = new ArrayList<>();
        for (Row r : queryResult) {
            WebBusinessObject wbo = fabricateBusObj(r);
            try {
                wbo.setAttribute("userId", r.getString("ID") != null ? r.getString("ID") : "---");
                wbo.setAttribute("fullName", r.getString("ENGLISH_NAME") != null ? r.getString("ENGLISH_NAME") : "---");
                wbo.setAttribute("CommercialRegister", r.getString("PRE_SHLDER") != null ? r.getString("PRE_SHLDER") : "---");
                wbo.setAttribute("TaxCardNumber", r.getString("CL_SHLDER") != null ? r.getString("CL_SHLDER") : "---");
                wbo.setAttribute("AuthorizedPerson", r.getString("CODE") != null ? r.getString("CODE") : "---");
                wbo.setAttribute("RecordDate", r.getString("TYPICAL_BEGIN_DATE") != null ? r.getString("TYPICAL_BEGIN_DATE") : "---");
                wbo.setAttribute("phoneNumber", r.getString("IS_FOREVER") != null ? r.getString("IS_FOREVER") : "---");
                wbo.setAttribute("NOSALES", r.getString("NOSALES") != null ? r.getString("NOSALES") : "---");
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(UserExtMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            brokersList.add(wbo);
        }
        return brokersList;
    }
}
