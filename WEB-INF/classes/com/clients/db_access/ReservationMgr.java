package com.clients.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.db_access.PersistentSessionMgr;
import com.tracker.db_access.ProjectMgr;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Enumeration;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class ReservationMgr extends RDBGateWay {

    private static final ReservationMgr reservationMgr = new ReservationMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static ReservationMgr getInstance() {

        logger.info("Getting ReservationMgr Instance ....");
        return reservationMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("reservation.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        return new ArrayList(cashedTable);
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    public boolean saveObject(WebBusinessObject reservationWbo) throws SQLException {
    return true;
    }
    
    public WebBusinessObject saveObjectRes(WebBusinessObject reservationWbo) throws SQLException {
        WebBusinessObject wbo = new WebBusinessObject();
        String id = UniqueIDGen.getNextID();
        DateParser dateParser = new DateParser();
        java.sql.Date reservationDate;
        if(reservationWbo.getAttribute("reservationDate") != null && reservationWbo.getAttribute("reservationDate").equals("UL")){
            reservationDate = new java.sql.Date(Calendar.getInstance().getTime().getTime());
        } else {
            reservationDate = dateParser.formatSqlDate(((String) reservationWbo.getAttribute("reservationDate")).replaceAll("-", "/"), "y/m/d");
        }
        
        Vector params = new Vector();

        wbo.setAttribute("reservationID", id);
                
        params.addElement(new StringValue(id));
        params.addElement(new StringValue((String) reservationWbo.getAttribute("clientID")));
        params.addElement(new StringValue((String) reservationWbo.getAttribute("projectID")));
        params.addElement(new StringValue((String) reservationWbo.getAttribute("userId")));

        params.addElement(new StringValue((String) reservationWbo.getAttribute("projectCategoryId")));
        params.addElement(new StringValue((String) reservationWbo.getAttribute("budget")));
        params.addElement(new StringValue((String) reservationWbo.getAttribute("period")));
        params.addElement(new StringValue((String) reservationWbo.getAttribute("paymentType")));
        params.addElement(new StringValue((String) reservationWbo.getAttribute("comments")));
        params.addElement(new StringValue("30")); //current status "Pending"

        params.addElement(new StringValue((String) reservationWbo.getAttribute("floorNumber"))); //option1
        params.addElement(new StringValue((String) reservationWbo.getAttribute("modelNo"))); //option2
        params.addElement(new StringValue((String) reservationWbo.getAttribute("receiptNo"))); //option3
        params.addElement(new DateValue(reservationDate));

        params.addElement(new StringValue((String) reservationWbo.getAttribute("unitValueText"))); //option4
        params.addElement(new StringValue((String) reservationWbo.getAttribute("beforeDiscountText"))); //option5
        params.addElement(new StringValue((String) reservationWbo.getAttribute("reservationValueText"))); //option6
        params.addElement(new StringValue((String) reservationWbo.getAttribute("contractValueText"))); //option7

        int queryResult = -1000;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertReservation").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }
            params = new Vector();
            String issueStatusId = UniqueIDGen.getNextID();
            
            wbo.setAttribute("issueStatusID", issueStatusId);
            params.addElement(new StringValue(issueStatusId));
            params.addElement(new StringValue("30"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue(id));
            params.addElement(new StringValue("RESERVATION"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue((String) reservationWbo.getAttribute("userId")));
            forInsert.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult < 0) {
                transConnection.rollback();
                return null;
            }
        } catch (SQLException se) {
            System.out.println("DataBase Error = " + se.getMessage());
            logger.error(se.getMessage());
            return null;
        } finally {
            endTransaction();
        }
        return wbo;
    }

    public boolean updateStatus(String newStatus, String reservationID) throws SQLException {
        Vector params = new Vector();
        params.addElement(new StringValue(newStatus));
        params.addElement(new StringValue(reservationID));
        Connection connection;
        int queryResult;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("updateReservationStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }
        return (queryResult > 0);
    }

    public ArrayList<WebBusinessObject> getReservedUnits(Date fromDate, Date toDate, String departmentID, String userID) throws NoUserInSessionException {
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        Vector params = new Vector();
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        StringBuilder where = new StringBuilder();
        if(userID != null && !userID.isEmpty() && !userID.equalsIgnoreCase("all")) {
            where.append(" AND rs.CREATED_BY = ? ");
            params.addElement(new StringValue(userID));
        } else if(departmentID != null && !departmentID.isEmpty()) {
            where.append(" AND rs.CREATED_BY IN (SELECT USER_ID FROM USERS WHERE USER_ID IN (SELECT EMP_ID FROM EMP_MGR WHERE MGR_ID IN");
            where.append(" (SELECT OPTION_ONE FROM PROJECT WHERE PROJECT_ID = '").append(departmentID);
            where.append("')) UNION SELECT OPTION_ONE USER_ID FROM PROJECT WHERE PROJECT_ID = '").append(departmentID).append("')");
        }
        try {
            String query = getQuery("getAllReservation").trim();
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
        ArrayList<WebBusinessObject> resultBusObjs = new ArrayList<>();
        Row r;
        WebBusinessObject wbo;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("PROJECT_NAME") != null) {
                    wbo.setAttribute("projectName", r.getString("PROJECT_NAME"));
                }
                if (r.getString("CLIENT_ID") != null) {
                    wbo.setAttribute("clientId", r.getString("CLIENT_ID"));
                }
                if (r.getString("CLIENT_NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("CLIENT_NAME"));
                }
                if (r.getString("CREATED_BY_NAME") != null) {
                    wbo.setAttribute("createdByName", r.getString("CREATED_BY_NAME"));
                }
                if (r.getBigDecimal("REMAINING_HOURS") != null) {
                    wbo.setAttribute("remainingHours", r.getBigDecimal("REMAINING_HOURS"));
                }
                if (r.getString("UNIT_CURRENT_STATUS") != null) {
                    wbo.setAttribute("unitCurrentStatus", r.getString("UNIT_CURRENT_STATUS"));
                }
                if (r.getString("project_id") != null) {
                    wbo.setAttribute("projectId", r.getString("project_id"));
                }
                if (r.getString("ACTION_TAKEN") != null) {
                    wbo.setAttribute("actionTaken", r.getString("ACTION_TAKEN"));
                }
                if (r.getString("ACTION_BY_NAME") != null) {
                    wbo.setAttribute("actionByName", r.getString("ACTION_BY_NAME"));
                }
                if (r.getString("payment_place") != null) {
                    wbo.setAttribute("paymentPlace", r.getString("payment_place"));
                } else {
                    wbo.setAttribute("paymentPlace", "non");
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            } catch (UnsupportedConversionException ex) {
                Logger.getLogger(ReservationMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getAllSoldUnits() throws NoUserInSessionException {
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        try {
            String query = getQuery("getAllSoldUnits").trim();
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
            try {
                if (r.getString("PROJECT_NAME") != null) {
                    wbo.setAttribute("projectName", r.getString("PROJECT_NAME"));
                }
                if (r.getString("CLIENT_NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("CLIENT_NAME"));
                }
                if (r.getString("CREATED_BY_NAME") != null) {
                    wbo.setAttribute("createdByName", r.getString("CREATED_BY_NAME"));
                }
                if (r.getBigDecimal("REMAINING_HOURS") != null) {
                    wbo.setAttribute("remainingHours", r.getBigDecimal("REMAINING_HOURS"));
                }
                if (r.getString("UNIT_CURRENT_STATUS") != null) {
                    wbo.setAttribute("unitCurrentStatus", r.getString("UNIT_CURRENT_STATUS"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            } catch (UnsupportedConversionException ex) {
                Logger.getLogger(ReservationMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getProjectsSoldUnits(HttpSession session) {
        PersistentSessionMgr persistentSessionMgr = PersistentSessionMgr.getInstance();

        String remoteAccess = session.getId();

        WebBusinessObject persistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
        String persistentUserId = (String) persistentUser.getAttribute("userId");

        Vector queryResult = new Vector();
        Vector params = new Vector();

        params.addElement(new StringValue((String) persistentUserId));

        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;

        try {
            String query = getQuery("getProjectsSoldUnits").trim();
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
            try {
                if (r.getString("PROJECT_NAME") != null) {
                    wbo.setAttribute("projectName", r.getString("PROJECT_NAME"));
                }
                if (r.getString("CLIENT_NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("CLIENT_NAME"));
                }
                if (r.getString("CREATED_BY_NAME") != null) {
                    wbo.setAttribute("createdByName", r.getString("CREATED_BY_NAME"));
                }
                if (r.getBigDecimal("REMAINING_HOURS") != null) {
                    wbo.setAttribute("remainingHours", r.getBigDecimal("REMAINING_HOURS"));
                }
                if (r.getString("UNIT_CURRENT_STATUS") != null) {
                    wbo.setAttribute("unitCurrentStatus", r.getString("UNIT_CURRENT_STATUS"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            } catch (UnsupportedConversionException ex) {
                Logger.getLogger(ReservationMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public boolean updateReservation(WebBusinessObject reservationWbo) {
        DateParser dateParser = new DateParser();
        java.sql.Date reservationDate = dateParser.formatSqlDate(((String) reservationWbo.getAttribute("reservationDate")).replaceAll("-", "/"), "y/m/d");
        String id = UniqueIDGen.getNextID();
        Vector params = new Vector();
        //params.addElement(new StringValue((String) reservationWbo.getAttribute("budget")));
        params.addElement(new StringValue((String) reservationWbo.getAttribute("period")));
        params.addElement(new StringValue((String) reservationWbo.getAttribute("paymentSystem")));
        params.addElement(new StringValue((String) reservationWbo.getAttribute("paymentPlace")));
        params.addElement(new DateValue(reservationDate));
        params.addElement(new StringValue((String) reservationWbo.getAttribute("floorNo")));
        params.addElement(new StringValue((String) reservationWbo.getAttribute("modelNo")));
        params.addElement(new StringValue((String) reservationWbo.getAttribute("receiptNo")));
        params.addElement(new StringValue((String) reservationWbo.getAttribute("unitValueText")));
        params.addElement(new StringValue((String) reservationWbo.getAttribute("beforeDiscountText")));
        params.addElement(new StringValue((String) reservationWbo.getAttribute("reservationValueText")));
        params.addElement(new StringValue((String) reservationWbo.getAttribute("contractValueText")));
        params.addElement(new StringValue((String) reservationWbo.getAttribute("reservationID")));
        int queryResult = -1000;
        try {
            SQLCommandBean forInsert = new SQLCommandBean();
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("updateReservation").trim());
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

    public ArrayList<WebBusinessObject> getAllMyReservedUnits(HttpSession session, Date fromDate, Date toDate) {
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        Vector queryResult = new Vector();
        Vector params = new Vector();
        params.addElement(new StringValue((String) loggedUser.getAttribute("userId")));
        params.addElement(new DateValue(fromDate));
        params.addElement(new DateValue(toDate));
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        try {
            String query = getQuery("getMyAllReservation").trim();
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
            try {
                if (r.getString("PROJECT_NAME") != null) {
                    wbo.setAttribute("projectName", r.getString("PROJECT_NAME"));
                }
                if (r.getString("CLIENT_NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("CLIENT_NAME"));
                }
                if (r.getString("CREATED_BY_NAME") != null) {
                    wbo.setAttribute("createdByName", r.getString("CREATED_BY_NAME"));
                }
                if (r.getBigDecimal("REMAINING_HOURS") != null) {
                    wbo.setAttribute("remainingHours", r.getBigDecimal("REMAINING_HOURS"));
                }
                if (r.getString("UNIT_CURRENT_STATUS") != null) {
                    wbo.setAttribute("unitCurrentStatus", r.getString("UNIT_CURRENT_STATUS"));
                }
                if (r.getString("ACTION_TAKEN") != null) {
                    wbo.setAttribute("actionTaken", r.getString("ACTION_TAKEN"));
                }
                if (r.getString("ACTION_BY_NAME") != null) {
                    wbo.setAttribute("actionByName", r.getString("ACTION_BY_NAME"));
                }
                if (r.getString("PRICE") != null) {
                    wbo.setAttribute("price", r.getString("PRICE"));
                }
                if (r.getString("ADDON_PRICE") != null) {
                    wbo.setAttribute("addonPrice", r.getString("ADDON_PRICE"));
                }
                if (r.getString("MOBILE") != null) {
                    wbo.setAttribute("mobile", r.getString("MOBILE"));
                }
                if (r.getString("INTER_PHONE") != null) {
                    wbo.setAttribute("interPhone", r.getString("INTER_PHONE"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            } catch (UnsupportedConversionException ex) {
                Logger.getLogger(ReservationMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getSalesReport(Date fromDate, Date toDate) {
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        Vector params = new Vector();
        StringBuilder where = new StringBuilder();
        if (fromDate != null) {
            params.addElement(new DateValue(fromDate));
            where.append("AND TRUNC(RS.RESERVATION_DATE) >= ? ");
        }
        if (toDate != null) {
            params.addElement(new DateValue(toDate));
            where.append("AND TRUNC(RS.RESERVATION_DATE) <= ? ");
        }
        try {
            String query = getQuery("getSalesReport").trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.replaceFirst("whereStatement", where.toString()));
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
            try {
                if (r.getString("PROJECT_NAME") != null) {
                    wbo.setAttribute("projectName", r.getString("PROJECT_NAME"));
                }
                if (r.getString("CLIENT_NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("CLIENT_NAME"));
                }
                if (r.getString("CREATED_BY_NAME") != null) {
                    wbo.setAttribute("createdByName", r.getString("CREATED_BY_NAME"));
                }
                if (r.getString("UNIT_CURRENT_STATUS") != null) {
                    wbo.setAttribute("unitCurrentStatus", r.getString("UNIT_CURRENT_STATUS"));
                }
                if (r.getBigDecimal("UNIT_VALUE") != null) {
                    wbo.setAttribute("unitValue", r.getBigDecimal("UNIT_VALUE") + "");
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            } catch (UnsupportedConversionException ex) {
                Logger.getLogger(ReservationMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getSalesTotalAmount(Date fromDate, Date toDate) {
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        Vector params = new Vector();
        StringBuilder where = new StringBuilder();
        if (fromDate != null) {
            params.addElement(new DateValue(fromDate));
            where.append("AND TRUNC(RS.RESERVATION_DATE) >= ? ");
        }
        if (toDate != null) {
            params.addElement(new DateValue(toDate));
            where.append("AND TRUNC(RS.RESERVATION_DATE) <= ? ");
        }
        try {
            String query = getQuery("getSalesTotalAmount").trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.replaceFirst("whereStatement", where.toString()));
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
            try {
                if (r.getString("EMPLOYEE_NAME") != null) {
                    wbo.setAttribute("employeeName", r.getString("EMPLOYEE_NAME"));
                }
                if (r.getBigDecimal("TOTAL_VALUE") != null) {
                    wbo.setAttribute("totalValue", r.getBigDecimal("TOTAL_VALUE") + "");
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            } catch (UnsupportedConversionException ex) {
                Logger.getLogger(ReservationMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }

    public ArrayList<WebBusinessObject> getSalesTotalCount(Date fromDate, Date toDate) {
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        Vector params = new Vector();
        StringBuilder where = new StringBuilder();
        if (fromDate != null) {
            params.addElement(new DateValue(fromDate));
            where.append("AND TRUNC(RS.RESERVATION_DATE) >= ? ");
        }
        if (toDate != null) {
            params.addElement(new DateValue(toDate));
            where.append("AND TRUNC(RS.RESERVATION_DATE) <= ? ");
        }
        try {
            String query = getQuery("getSalesTotalCount").trim();
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.replaceFirst("whereStatement", where.toString()));
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
            try {
                if (r.getString("EMPLOYEE_NAME") != null) {
                    wbo.setAttribute("employeeName", r.getString("EMPLOYEE_NAME"));
                }
                if (r.getBigDecimal("TOTAL_NO") != null) {
                    wbo.setAttribute("totalNo", r.getBigDecimal("TOTAL_NO") + "");
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            } catch (UnsupportedConversionException ex) {
                Logger.getLogger(ReservationMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }
    
    public ArrayList<WebBusinessObject> getCampaignSoldClients(String campaignID, Date fromDate, Date toDate) {
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        Vector params = new Vector();
        try {
            params.addElement(new StringValue(campaignID));
            String query = getQuery("getCampaignSoldClients").trim();
            if (fromDate != null) {
                query += " AND TRUNC(CC.CREATION_TIME) >= ?";
                params.addElement(new DateValue(fromDate));
            }
            if (toDate != null) {
                query += " AND TRUNC(CC.CREATION_TIME) <= ?";
                params.addElement(new DateValue(toDate));
            }
            forQuery.setparams(params);
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
            try {
                if (r.getString("PROJECT_NAME") != null) {
                    wbo.setAttribute("projectName", r.getString("PROJECT_NAME"));
                }
                if (r.getString("CLIENT_NAME") != null) {
                    wbo.setAttribute("clientName", r.getString("CLIENT_NAME"));
                }
                if (r.getString("CREATED_BY_NAME") != null) {
                    wbo.setAttribute("createdByName", r.getString("CREATED_BY_NAME"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ProjectMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            resultBusObjs.add(wbo);
        }
        return resultBusObjs;
    }
}
