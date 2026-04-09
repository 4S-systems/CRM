package com.businessfw.oms.db_access;

import com.android.business_objects.LiteBusinessForm;
import com.android.business_objects.LiteWebBusinessObject;
import com.android.db_access.LiteRDBGateWay;
import com.android.exceptions.LiteNoSuchColumnException;
import com.android.exceptions.LiteUnsupportedConversionException;
import com.android.exceptions.LiteUnsupportedTypeException;
import com.android.persistence.LiteDateValue;
import com.android.persistence.LiteIntValue;
import com.android.persistence.LiteRow;
import com.android.persistence.LiteSQLCommandBean;
import com.android.persistence.LiteStringValue;
import com.android.persistence.LiteUniqueIDGen;
import com.silkworm.business_objects.DOMFabricatorBean;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Vector;
import org.apache.log4j.xml.DOMConfigurator;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ClientSurveyMgr extends LiteRDBGateWay {

    public static ClientSurveyMgr clientSurveyMgr = new ClientSurveyMgr();

    public static ClientSurveyMgr getInstance() {
        logger.info("Getting ClientSurveyMgr Instance ....");
        return clientSurveyMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new LiteBusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("client_survey.xml")));
                System.out.println("reading Successfully xml files....!");
            } catch (Exception e) {
                System.out.println("Error in reading xml files....!");
            }
        }
    }

    @Override
    public boolean saveObject(LiteWebBusinessObject wbo) throws SQLException {
        return false;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        return new ArrayList<>(cashedTable);
    }

    public Boolean insertClientSurveyList(ArrayList<LiteWebBusinessObject> surveyList) {
        Vector params;
        String id;
        int queryResult = -1;
        LiteSQLCommandBean forInsert = new LiteSQLCommandBean();
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertClientSurvey").trim());
            for (LiteWebBusinessObject wbo : surveyList) {
                params = new Vector();
                id = LiteUniqueIDGen.getNextID();
                params.addElement(new LiteStringValue(id));
                params.addElement(new LiteStringValue((String) wbo.getAttribute("clientID")));
                params.addElement(new LiteStringValue((String) wbo.getAttribute("questionID")));
                params.addElement(new LiteIntValue((Integer) wbo.getAttribute("rate")));
                params.addElement(new LiteStringValue((String) wbo.getAttribute("userID")));
                params.addElement(new LiteStringValue((String) wbo.getAttribute("option1")));
                params.addElement(new LiteStringValue((String) wbo.getAttribute("option2")));
                params.addElement(new LiteStringValue((String) wbo.getAttribute("option3")));
                params.addElement(new LiteStringValue((String) wbo.getAttribute("option4")));
                params.addElement(new LiteStringValue((String) wbo.getAttribute("option5")));
                params.addElement(new LiteStringValue((String) wbo.getAttribute("option6")));
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
            }
        } catch (SQLException se) {
            System.out.println("Error in saving Contract Schedule .............!" + se.getMessage());
            return false;
        } finally {
            endTransaction();
        }
        return true;
    }
    
    public ArrayList<LiteWebBusinessObject> getClientSurvey() {
        Connection connection = null;
        Vector queryResult = null;
        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientSurvey").trim());
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (LiteUnsupportedTypeException ex) {
            Logger.getLogger(ClientSurveyMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<LiteWebBusinessObject> result = new ArrayList<>();
        LiteWebBusinessObject wbo;
        LiteRow r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            DecimalFormat df = new DecimalFormat("#.##");
            while (e.hasMoreElements()) {
                r = (LiteRow) e.nextElement();
                wbo = fabricateBusObj(r);
                try {
                    if (r.getBigDecimal("AVERAGE") != null) {
                        wbo.setAttribute("average", df.format(r.getBigDecimal("AVERAGE")));
                    }
                    if (r.getString("QUESTION") != null) {
                        wbo.setAttribute("question", r.getString("QUESTION"));
                    }
                } catch (LiteNoSuchColumnException | LiteUnsupportedConversionException ex) {
                    Logger.getLogger(ClientSurveyMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                result.add(wbo);
            }
        }
        return result;
    }
    
    public ArrayList<LiteWebBusinessObject> getSurveyQuestionRates(String questionID, long fromDate, long toDate) {
        Connection connection = null;
        Vector queryResult = null;
        Vector params= new Vector();
        
        params.addElement(new LiteStringValue((String) questionID));
        params.addElement(new LiteDateValue(new java.sql.Date(fromDate)));
        params.addElement(new LiteDateValue(new java.sql.Date(toDate)));
        
        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getSurveyQuesRates").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (LiteUnsupportedTypeException ex) {
            Logger.getLogger(ClientSurveyMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<LiteWebBusinessObject> result = new ArrayList<>();
        LiteWebBusinessObject wbo;
        LiteRow r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (LiteRow) e.nextElement();
                wbo = fabricateBusObj(r);
                try {               
                    if (r.getString("sys_id") != null) {
                        wbo.setAttribute("clientID", r.getString("sys_id"));
                    }
                    
                    if (r.getString("name") != null) {
                        wbo.setAttribute("clientName", r.getString("name"));
                    }
                    
                    if (r.getString("mobile") != null) {
                        wbo.setAttribute("clientMobile", r.getString("mobile"));
                    }

                    if (r.getString("project_id") != null) {
                        wbo.setAttribute("questionID", r.getString("project_id"));
                    }
                    
                    if (r.getString("project_name") != null) {
                        wbo.setAttribute("question", r.getString("project_name"));
                    }
                    
                    if (r.getString("rate") != null) {
                        wbo.setAttribute("rate", r.getString("rate"));
                    }
                    
                    if (r.getString("simple_rate") != null) {
                        wbo.setAttribute("simple_rate", r.getString("simple_rate"));
                    }
                    
                } catch (LiteNoSuchColumnException ex) {
                    Logger.getLogger(ClientSurveyMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                result.add(wbo);
            }
        }
        return result;
    }
    
    public ArrayList<LiteWebBusinessObject> getSurveyQuestionRatesDetails(long fromDate, long toDate) {
        Connection connection = null;
        Vector queryResult = null;
        Vector params= new Vector();
        
        params.addElement(new LiteDateValue(new java.sql.Date(fromDate)));
        params.addElement(new LiteDateValue(new java.sql.Date(toDate)));
        
        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getSurveyQuesRatesDet").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (LiteUnsupportedTypeException ex) {
            Logger.getLogger(ClientSurveyMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        ArrayList<LiteWebBusinessObject> result = new ArrayList<>();
        LiteWebBusinessObject wbo;
        LiteRow r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (LiteRow) e.nextElement();
                wbo = fabricateBusObj(r);
                try {               
                    if (r.getString("sys_id") != null) {
                        wbo.setAttribute("clientID", r.getString("sys_id"));
                    }
                    
                    if (r.getString("name") != null) {
                        wbo.setAttribute("clientName", r.getString("name"));
                    }
                    
                    if (r.getString("mobile") != null) {
                        wbo.setAttribute("clientMobile", r.getString("mobile"));
                    }

                    if (r.getString("project_id") != null) {
                        wbo.setAttribute("questionID", r.getString("project_id"));
                    }
                    
                    if (r.getString("project_name") != null) {
                        wbo.setAttribute("question", r.getString("project_name"));
                    }
                    
                    if (r.getString("rate") != null) {
                        wbo.setAttribute("rate", r.getString("rate"));
                    }
                    
                    if (r.getString("simple_rate") != null) {
                        wbo.setAttribute("simple_rate", r.getString("simple_rate"));
                    }
                    
                } catch (LiteNoSuchColumnException ex) {
                    Logger.getLogger(ClientSurveyMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                result.add(wbo);
            }
        }
        return result;
    }
    
    public ArrayList<LiteWebBusinessObject> getSurveyStatsByQues(long fromDate, long toDate) {
        Connection connection = null;
        Vector queryResult = null;
        Vector params= new Vector();

        params.addElement(new LiteDateValue(new java.sql.Date(fromDate)));
        params.addElement(new LiteDateValue(new java.sql.Date(toDate)));
        
        LiteSQLCommandBean forQuery = new LiteSQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getSurveyStatByQues").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (LiteUnsupportedTypeException ex) {
            Logger.getLogger(ClientSurveyMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        
        ArrayList<LiteWebBusinessObject> result = new ArrayList<>();
        LiteWebBusinessObject wbo;
        LiteRow r;
        if (queryResult != null) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (LiteRow) e.nextElement();
                wbo = fabricateBusObj(r);
                try {               
                    if (r.getString("project_id") != null) {
                        wbo.setAttribute("questionID", r.getString("project_id"));
                    }
                    
                    if (r.getString("project_name") != null) {
                        wbo.setAttribute("question", r.getString("project_name"));
                    }
                    
                    if (r.getBigDecimal("disSats") != null) {
                        wbo.setAttribute("disSats", r.getBigDecimal("disSats"));
                    }

                    if (r.getBigDecimal("someSats") != null) {
                        wbo.setAttribute("someSats", r.getBigDecimal("someSats"));
                    }

                    if (r.getBigDecimal("sats") != null) {
                        wbo.setAttribute("sats", r.getBigDecimal("sats"));
                    }
                } catch (LiteNoSuchColumnException ex) {
                    Logger.getLogger(ClientSurveyMgr.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex){
                    Logger.getLogger(ClientSurveyMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                result.add(wbo);
            }
        }
        return result;
    }
}
