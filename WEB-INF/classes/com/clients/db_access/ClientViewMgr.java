/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.clients.db_access;

import com.maintenance.common.Tools;
import com.maintenance.db_access.ExternalJobMgr;
import com.maintenance.db_access.TradeMgr;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.common.MetaDataMgr;
import com.tracker.db_access.SequenceMgr;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;
import org.omg.CORBA.Request;

/**
 *
 * @author Waled
 */
public class ClientViewMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static ClientViewMgr clientViewMgr = new ClientViewMgr();

    public static ClientViewMgr getInstance() {
        logger.info("Getting ClientViewMgr Instance ....");
        return clientViewMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("client_view.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public ArrayList getClientName(String equipmentID) {
        Vector prm = new Vector();
        prm.addElement(new StringValue(equipmentID));
        SQLCommandBean executeQuery = new SQLCommandBean();
        Vector resultQuery = new Vector();
        try {
            beginTransaction();
            executeQuery.setConnection(transConnection);
            executeQuery.setSQLQuery(getQuery("selectClient").trim());
            executeQuery.setparams(prm);
            resultQuery = executeQuery.executeQuery();
            endTransaction();
        } catch (Exception e) {
            logger.error("Could not execute Query");
        }
        ArrayList newData = new ArrayList();
        Row r = null;
        Enumeration e = resultQuery.elements();
        while (e.hasMoreElements()) {
            WebBusinessObject wbo = null;
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            newData.add(wbo);
        }
        return newData;
    }

    public ArrayList getAllClient() {
        Vector queryResult = new Vector();
        WebBusinessObject wbo = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        try {
            //connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("selectAllClientsName").trim());
            queryResult = forInsert.executeQuery();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
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
//**
    public Vector selectAllDataForClient(String clientId) {
        Vector queryResult = new Vector();
        Vector params= new Vector();
        params.addElement(new StringValue(clientId));
        WebBusinessObject wbo = null;
        SQLCommandBean forInsert = new SQLCommandBean();
        try {
            //connection = dataSource.getConnection();
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("selectAllDataForClient").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeQuery();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
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

    public Vector clientByName(String clientName) throws SQLException {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        String query = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();

        query = getQuery("getClientByName").trim();
        query = query.replaceAll("clientName", clientName);

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

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveClient(HttpServletRequest request, HttpSession s) throws NoUserInSessionException, SQLException {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String connectByRealEstate = metaDataMgr.getConnectByRealEstate();
        String code = null;
        String userName = null;
        String password = null;
        String driver = null;
        String URL = null;
        Connection conn = null;
        String clientNo = null;
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String clientStatus = null;
        SequenceMgr sequenceMgr = SequenceMgr.getInstance();
        /////////// Get Client date from Real Estate ////////////
        if (connectByRealEstate != null && !connectByRealEstate.equals("")
                && connectByRealEstate.equals("1")) {
            userName = metaDataMgr.getRealEstateName();
            password = metaDataMgr.getRealEstatePassword();
            driver = metaDataMgr.getDriverErp();
            URL = metaDataMgr.getDataBaseErpUrl();
            Vector queryRsult = new Vector();
            SQLCommandBean forQuery = new SQLCommandBean();
            try {
                Class.forName(driver);
                conn = DriverManager.getConnection(URL, userName, password);
                conn.setAutoCommit(false);
                forQuery.setConnection(conn);
                String myQuery = getQuery("getMaxCodeOfClient").trim();
                forQuery.setSQLQuery(myQuery);
                queryRsult = forQuery.executeQuery();
            } catch (Exception se) {
                logger.error("database error " + se.getMessage());
            } finally {
                try {
                    conn.commit();
                    conn.close();
                } catch (SQLException sex) {
                    logger.error("troubles closing connection " + sex.getMessage());
                    return false;
                }
            }

            Vector resultBusObjs = new Vector();
            WebBusinessObject wbo2;
            Row r = null;
            Enumeration e = queryRsult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                try {
                    if(r.getString("code")!=null){
                      code = r.getString("code"); 
                    }
                } catch (NullPointerException exm){
                    code = "0";
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                    return false;
                }
            }
            Integer iCode = new Integer(code) + 1;
            String str0 = "";
            for (int x = iCode.toString().length(); x < 8; x++) {
                str0 = str0 + "0";
            }
            code = str0 + iCode.toString();
            sequenceMgr.updateSequence();
            clientNo = sequenceMgr.getSequence();
            request.setAttribute("clientNo", clientNo);
        } else {
            String automatedClientNo = request.getParameter("automatedClientNo");


            if (automatedClientNo == null || automatedClientNo == "") {
                clientNo = request.getParameter("clientNO");

            } else {
                sequenceMgr.updateSequence();
                clientNo = sequenceMgr.getSequence();
            }
            request.setAttribute("clientNo", clientNo);
        }
        ///////////////////////////////////////////




        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String clientNoByDate = null;

        String id = UniqueIDGen.getNextID();
        params.addElement(new StringValue(id));
        params.addElement(new StringValue(clientNo));
        params.addElement(new StringValue(request.getParameter("clientName")));
        params.addElement(new StringValue(request.getParameter("gender")));
        params.addElement(new StringValue(request.getParameter("matiralStatus")));

        if (request.getParameter("clientMobile") != null && !request.getParameter("clientMobile").isEmpty()) {
            String mobile = request.getParameter("clientMobile");
            if (request.getParameter("internationalM") != null && !request.getParameter("internationalM").isEmpty()) {
                mobile = request.getParameter("internationalM") + "-" + mobile;
            }
            params.addElement(new StringValue(mobile));
        } else {
            params.addElement(new StringValue(" "));
        }
//        params.addElement(new StringValue("xxxxxxxxx"));
        if (request.getParameter("phone") != null && !request.getParameter("phone").isEmpty()) {
            String phone = request.getParameter("phone");
            if (request.getParameter("internationalP") != null && !request.getParameter("internationalP").isEmpty()) {
                phone = request.getParameter("internationalP") + "-" + phone;
            }
            params.addElement(new StringValue(phone));
        } else {
            params.addElement(new StringValue(" "));
        }
        if (request.getParameter("clientSalary") != null && !request.getParameter("clientSalary").isEmpty()) {
            params.addElement(new StringValue(request.getParameter("clientSalary")));
        } else {
            params.addElement(new StringValue(""));
        }
        if (request.getParameter("address") != null && !request.getParameter("address").isEmpty()) {
            params.addElement(new StringValue(request.getParameter("address")));
        } else {
            params.addElement(new StringValue(""));
        }
        if (request.getParameter("email") != null && !request.getParameter("email").isEmpty()) {
            params.addElement(new StringValue(request.getParameter("email")));
        } else {
            params.addElement(new StringValue(""));
        }

        if (request.getParameter("isActive") != null) {
            params.addElement(new StringValue("1"));
            clientStatus = "1";

        } else {
            params.addElement(new StringValue("0"));
            clientStatus = "0";
        }
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
//        params.addElement(new StringValue("1"));
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new java.util.Date());
        clientNoByDate = (calendar.get(Calendar.MONTH) + 1) + "/" + calendar.get(Calendar.YEAR);
        params.addElement(new StringValue(clientNoByDate));

        if (request.getParameter("clientSsn") != null && !request.getParameter("clientSsn").isEmpty()) {
            params.addElement(new StringValue(request.getParameter("clientSsn")));
        } else {
            params.addElement(new StringValue(""));
        }
        if (request.getParameter("age") != null && !request.getParameter("age").isEmpty()) {
            params.addElement(new StringValue(request.getParameter("age")));
        } else {
            params.addElement(new StringValue("20-30"));
        }
        if (request.getParameter("partner") != null && !request.getParameter("partner").isEmpty()) {
            params.addElement(new StringValue(request.getParameter("partner")));
        } else {
            params.addElement(new StringValue("  "));
        }

        params.addElement(new StringValue((String) request.getAttribute("jobTitle")));

        params.addElement(new StringValue(request.getParameter("workOut")));//option1
        params.addElement(new StringValue(request.getParameter("kindred")));//option2
        params.addElement(new StringValue(""));//option3


        if (connectByRealEstate != null && !connectByRealEstate.equals("")
                && connectByRealEstate.equals("1")) {
            params.addElement(new StringValue(code));
            request.setAttribute("code", code);
        } else {
            params.addElement(new StringValue(clientNo));
            request.setAttribute("code", clientNoByDate);
        }
        if (request.getParameter("nationality") != null && !request.getParameter("nationality").equals("")) {
            params.addElement(new StringValue(request.getParameter("nationality")));
        } else {
            params.addElement(new StringValue(""));
        }
        params.addElement(new StringValue((String) request.getAttribute("regionTitle")));
        request.setAttribute("clientId", id);

//        Connection connection = null;
        try {
//            connection = dataSource.getConnection();
            beginTransaction();
//            connection.setAutoCommit(true);
            forInsert.setConnection(transConnection);
            String myQuery = getQuery("insertClient").trim();
            forInsert.setSQLQuery(myQuery);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();


            if (queryResult < 0) {
                transConnection.rollback();
                return false;

            }
            if (clientStatus.equals("1")) {
                params = new Vector();

                queryResult = -1000;

                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue("New"));
                params.addElement(new StringValue(id));
                params.addElement(new StringValue("No Description"));
                forInsert.setConnection(transConnection);
                forInsert.setSQLQuery(getQuery("insertInitialClientStatus").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();

                if (queryResult < 0) {
                    transConnection.rollback();
                    return false;
                }
            }

        } catch (SQLException se) {
            logger.error(se.getMessage());
            transConnection.rollback();
            return false;
//
        } finally {
            endTransaction();
        }

        //////////// Insert Client In Real Estate  //////
        if (connectByRealEstate != null && !connectByRealEstate.equals("")
                && connectByRealEstate.equals("1")) {   
            int qryResult = -1000;
            if (queryResult > 0) {
                Vector SQLparams = new Vector();
                SQLparams.addElement(new StringValue(code));
                SQLparams.addElement(new StringValue(request.getParameter("clientName")));
                SQLparams.addElement(new StringValue(request.getParameter("clientName")));
                try {
                    Class.forName(driver);
                    conn = DriverManager.getConnection(URL, userName, password);
                    conn.setAutoCommit(false);
                    forInsert.setConnection(conn);
                    forInsert.setparams(SQLparams);
                    String myQuery = getQuery("saveClientInRealEstate").trim();
                    forInsert.setSQLQuery(myQuery);
                    qryResult = forInsert.executeUpdate();
                } catch (Exception se) {
                    logger.error("database error " + se.getMessage());
                } finally {
                    try {
                        conn.commit();
                        conn.close();
                    } catch (SQLException sex) {
                        logger.error("troubles closing connection " + sex.getMessage());
                        return false;
                    }
                }
            }
        }
        //////////////////////////////////////////////////

        return (queryResult > 0);

    }

    public boolean saveClientData(HttpServletRequest request, HttpSession s) throws NoUserInSessionException, SQLException {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String connectByRealEstate = metaDataMgr.getConnectByRealEstate();
        String code = null;
        String userName = null;
        String password = null;
        String driver = null;
        String URL = null;
        Connection conn = null;
        String clientNo = null;
        String clientStatus = null;
        SequenceMgr sequenceMgr = SequenceMgr.getInstance();
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        /////////// Get Client date from Real Estate ////////////
        if (connectByRealEstate != null && !connectByRealEstate.equals("")
                && connectByRealEstate.equals("1")) {
            userName = metaDataMgr.getRealEstateName();
            password = metaDataMgr.getRealEstatePassword();
            driver = metaDataMgr.getDriverErp();
            URL = metaDataMgr.getDataBaseErpUrl();

            Vector queryRsult = new Vector();
            SQLCommandBean forQuery = new SQLCommandBean();
            try {
                Class.forName(driver);
                conn = DriverManager.getConnection(URL, userName, password);
                conn.setAutoCommit(false);
                forQuery.setConnection(conn);
                String myQuery = getQuery("getMaxCodeOfClient").trim();
                forQuery.setSQLQuery(myQuery);
                queryRsult = forQuery.executeQuery();
            } catch (Exception se) {
                logger.error("database error " + se.getMessage());
                return false;
            } finally {
                try {
                    conn.commit();
                    conn.close();
                } catch (SQLException sex) {
                    logger.error("troubles closing connection " + sex.getMessage());
                    return false;
                }
            }

            Vector resultBusObjs = new Vector();
            WebBusinessObject wbo2;
            Row r = null;
            Enumeration e = queryRsult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                try {
                    if(r.getString("code")!=null){
                      code = r.getString("code"); 
                    }
                } catch (NullPointerException exm){
                    code = "0";
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                    return false;
                }
            }
            Integer iCode = new Integer(code) + 1;
            String str0 = "";
            for (int x = iCode.toString().length(); x < 8; x++) {
                str0 = str0 + "0";
            }
            code = str0 + iCode.toString();
            sequenceMgr.updateSequence();
            clientNo = sequenceMgr.getSequence();

        } else {

            String automatedClientNo = request.getParameter("automatedClientNo");


            if (automatedClientNo == null || automatedClientNo == "") {
                clientNo = request.getParameter("clientNO");

            } else {
                sequenceMgr.updateSequence();
                clientNo = sequenceMgr.getSequence();
            }

        }
        request.setAttribute("clientNo", clientNo);
        ///////////////////////////////////////////








        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String clientNoByDate = null;
        String id = UniqueIDGen.getNextID();
        params.addElement(new StringValue(id));
        params.addElement(new StringValue(clientNo));
        params.addElement(new StringValue(request.getParameter("clientName")));
        params.addElement(new StringValue(request.getParameter("gender")));
        params.addElement(new StringValue(request.getParameter("matiralStatus")));
        if (request.getParameter("clientMobile") != null && !request.getParameter("clientMobile").isEmpty()) {
            String mobile = request.getParameter("clientMobile");
            if (request.getParameter("internationalM") != null && !request.getParameter("internationalM").isEmpty()) {
                mobile = request.getParameter("internationalM") + "-" + mobile;
            }
            params.addElement(new StringValue(mobile));
        } else {
            params.addElement(new StringValue(" "));
        }
        if (request.getParameter("phone") != null && !request.getParameter("phone").isEmpty()) {
            String phone = request.getParameter("phone");
            if (request.getParameter("internationalP") != null && !request.getParameter("internationalP").isEmpty()) {
                phone = request.getParameter("internationalP") + "-" + phone;
            }
            params.addElement(new StringValue(phone));
        } else {
            params.addElement(new StringValue(" "));
        }
        params.addElement(new StringValue(request.getParameter("clientSalary")));

        params.addElement(new StringValue(request.getParameter("address")));

        if (request.getParameter("email") != null && !request.getParameter("email").isEmpty()) {
            params.addElement(new StringValue(request.getParameter("email")));
        } else {
            params.addElement(new StringValue(""));
        }
        if (request.getParameter("isActive") != null) {
            params.addElement(new StringValue("1"));
            clientStatus = "1";

        } else {
            params.addElement(new StringValue("0"));
            clientStatus = "0";
        }
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
//        params.addElement(new StringValue("1"));
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new java.util.Date());
        clientNoByDate = (calendar.get(Calendar.MONTH) + 1) + "/" + calendar.get(Calendar.YEAR);
        params.addElement(new StringValue(clientNoByDate));



        params.addElement(new StringValue(request.getParameter("clientSsn")));
        params.addElement(new StringValue(request.getParameter("age")));
        if (request.getParameter("partner") != null && !request.getParameter("partner").isEmpty()) {
            params.addElement(new StringValue(request.getParameter("partner")));
        } else {
            params.addElement(new StringValue("  "));
        }

        TradeMgr tradeMgr = TradeMgr.getInstance();
        WebBusinessObject wbo = new WebBusinessObject();
        wbo = tradeMgr.getOnSingleKey("key2", request.getParameter("job"));
        if (wbo != null) {
            params.addElement(new StringValue((String) wbo.getAttribute("tradeName")));
        } else {
            params.addElement(new StringValue(" "));
        }
        params.addElement(new StringValue(request.getParameter("workOut")));//option1
        params.addElement(new StringValue(request.getParameter("kindred")));//option2
        params.addElement(new StringValue(request.getParameter("company")));//option3

        if (connectByRealEstate != null && !connectByRealEstate.equals("")
                && connectByRealEstate.equals("1")) {
            params.addElement(new StringValue(code));
            request.setAttribute("code", code);
        } else {
            params.addElement(new StringValue(clientNo));
            request.setAttribute("code", clientNoByDate);
        }
        if (request.getParameter("nationality") != null && !request.getParameter("nationality").equals("")) {
            params.addElement(new StringValue(request.getParameter("nationality")));
        } else {
            params.addElement(new StringValue(""));
        }
        params.addElement(new StringValue((String) request.getAttribute("regionTitle")));
        request.setAttribute("clientId", id);

//        Connection connection = null;
        try {
//            connection = dataSource.getConnection();
            beginTransaction();
//            connection.setAutoCommit(true);
            forInsert.setConnection(transConnection);
            String myQuery = getQuery("insertClient").trim();
            forInsert.setSQLQuery(myQuery);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return false;

            }
            if (clientStatus.equals("1")) {
                params = new Vector();

                queryResult = -1000;

                params.addElement(new StringValue(UniqueIDGen.getNextID()));
                params.addElement(new StringValue("New"));
                params.addElement(new StringValue(id));
                params.addElement(new StringValue("No Description"));

                forInsert.setConnection(transConnection);
                forInsert.setSQLQuery(getQuery("insertInitialClientStatus").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();

                if (queryResult < 0) {
                    transConnection.rollback();
                    return false;

                }
            }

        } catch (SQLException se) {
            logger.error(se.getMessage());
            transConnection.rollback();
            return false;

        } finally {
            endTransaction();
        }

        //////////// Insert Client In Real Estate  //////
        if (connectByRealEstate != null && !connectByRealEstate.equals("")
                && connectByRealEstate.equals("1")) {
            int qryResult = -1000;
            if (queryResult > 0) {
                Vector SQLparams = new Vector();
                SQLparams.addElement(new StringValue(code));
                SQLparams.addElement(new StringValue(request.getParameter("clientName")));
                SQLparams.addElement(new StringValue(request.getParameter("clientName")));
                try {
                    Class.forName(driver);
                    conn = DriverManager.getConnection(URL, userName, password);
                    conn.setAutoCommit(false);
                    forInsert.setConnection(conn);
                    forInsert.setparams(SQLparams);
                    String myQuery = getQuery("saveClientInRealEstate").trim();
                    forInsert.setSQLQuery(myQuery);
                    qryResult = forInsert.executeUpdate();
                } catch (Exception se) {
                    logger.error("database error " + se.getMessage());
                } finally {
                    try {
                        conn.commit();
                        conn.close();
                    } catch (SQLException sex) {
                        logger.error("troubles closing connection " + sex.getMessage());
                        return false;
                    }
                }
            }
        }
        //////////////////////////////////////////////////

        return (queryResult > 0);

    }
    ////////////////////////////////////////////////////////////////

    public boolean saveClientRealState(HttpServletRequest request, HttpSession s) throws NoUserInSessionException, SQLException {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String connectByRealEstate = metaDataMgr.getConnectByRealEstate();
        String code = null;
        String userName = null;
        String password = null;
        String driver = null;
        String URL = null;
        Connection conn = null;
        String clientNo = null;
        String clientNoRealState = null;
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String clientStatus = null;
        boolean excuteQuery = false;
        SequenceMgr sequenceMgr = SequenceMgr.getInstance();
        /////////// Get Client date from Real Estate ////////////

        userName = metaDataMgr.getRealEstateName();
        password = metaDataMgr.getRealEstatePassword();
        driver = metaDataMgr.getDriverErp();
        URL = metaDataMgr.getDataBaseErpUrl();
        Vector queryRsult = new Vector();
        Vector parameter = new Vector();


        SQLCommandBean forQuery = new SQLCommandBean();

        String automatedClientNo = request.getParameter("automatedClientNo");


        if (automatedClientNo == null || automatedClientNo == "") {
            clientNoRealState = (String) request.getParameter("clientNO");



            try {
                parameter.add(new StringValue(clientNoRealState));
                Class.forName(driver);
                conn = DriverManager.getConnection(URL, userName, password);
                conn.setAutoCommit(false);
                forQuery.setConnection(conn);
                forQuery.setparams(parameter);
                String myQuery = getQuery("checkCodeUnique").trim();
                forQuery.setSQLQuery(myQuery);
                queryRsult = forQuery.executeQuery();

                if (queryRsult.size() > 0) {
                    excuteQuery = false;


                } else {
                    excuteQuery = true;

                    String str0 = "";
                    for (int x = clientNoRealState.length(); x < 8; x++) {
                        str0 = str0 + "0";
                    }
                    code = str0 + clientNoRealState;

                    sequenceMgr.updateSequence();
                    clientNo = sequenceMgr.getSequence();
                    Vector params = new Vector();
                    SQLCommandBean forInsert = new SQLCommandBean();
                    int queryResult = -1000;
                    String clientNoByDate = null;

                    String id = UniqueIDGen.getNextID();
                    params.addElement(new StringValue(id));
                    params.addElement(new StringValue(clientNo));
                    params.addElement(new StringValue(request.getParameter("clientName")));
                    params.addElement(new StringValue(request.getParameter("gender")));
                    params.addElement(new StringValue(request.getParameter("matiralStatus")));

                    if (request.getParameter("clientMobile") != null && !request.getParameter("clientMobile").isEmpty()) {
                        params.addElement(new StringValue(request.getParameter("clientMobile")));
                    } else {
                        params.addElement(new StringValue(" "));
                    }
//        params.addElement(new StringValue("xxxxxxxxx"));
                    if (request.getParameter("phone") != null && !request.getParameter("phone").isEmpty()) {
                        params.addElement(new StringValue(request.getParameter("phone")));
                    } else {
                        params.addElement(new StringValue(" "));
                    }
                    if (request.getParameter("clientSalary") != null && !request.getParameter("clientSalary").isEmpty()) {
                        params.addElement(new StringValue(request.getParameter("clientSalary")));
                    } else {
                        params.addElement(new StringValue(""));
                    }
                    if (request.getParameter("address") != null && !request.getParameter("address").isEmpty()) {
                        params.addElement(new StringValue(request.getParameter("address")));
                    } else {
                        params.addElement(new StringValue(""));
                    }
                    if (request.getParameter("email") != null && !request.getParameter("email").isEmpty()) {
                        params.addElement(new StringValue(request.getParameter("email")));
                    } else {
                        params.addElement(new StringValue(""));
                    }

                    if (request.getParameter("isActive") != null) {
                        params.addElement(new StringValue("1"));
                        clientStatus = "1";

                    } else {
                        params.addElement(new StringValue("0"));
                        clientStatus = "0";
                    }
                    params.addElement(new StringValue((String) waUser.getAttribute("userId")));
//        params.addElement(new StringValue("1"));
                    Calendar calendar = Calendar.getInstance();
                    calendar.setTime(new java.util.Date());
                    clientNoByDate = (calendar.get(Calendar.MONTH) + 1) + "/" + calendar.get(Calendar.YEAR);
                    params.addElement(new StringValue(clientNoByDate));

                    if (request.getParameter("clientSsn") != null && !request.getParameter("clientSsn").isEmpty()) {
                        params.addElement(new StringValue(request.getParameter("clientSsn")));
                    } else {
                        params.addElement(new StringValue(""));
                    }
                    if (request.getParameter("age") != null && !request.getParameter("age").isEmpty()) {
                        params.addElement(new StringValue(request.getParameter("age")));
                    } else {
                        params.addElement(new StringValue("20-30"));
                    }
                    if (request.getParameter("partner") != null && !request.getParameter("partner").isEmpty()) {
                        params.addElement(new StringValue(request.getParameter("partner")));
                    } else {
                        params.addElement(new StringValue("  "));
                    }

                    params.addElement(new StringValue((String) request.getAttribute("jobTitle")));

                    params.addElement(new StringValue(request.getParameter("workOut")));//option1
                    params.addElement(new StringValue(request.getParameter("kindred")));//option2
                    params.addElement(new StringValue(""));//option3


                    if (connectByRealEstate != null && !connectByRealEstate.equals("")
                            && connectByRealEstate.equals("1")) {
                        params.addElement(new StringValue(code));
                        request.setAttribute("code", code);
                    } else {
                        params.addElement(new StringValue(clientNo));
                        request.setAttribute("code", clientNoByDate);
                    }


                    request.setAttribute("clientId", id);

//        Connection connection = null;
                    try {
//            connection = dataSource.getConnection();
                        beginTransaction();
//            connection.setAutoCommit(true);
                        forInsert.setConnection(transConnection);
                        myQuery = getQuery("insertClient").trim();
                        forInsert.setSQLQuery(myQuery);
                        forInsert.setparams(params);
                        queryResult = forInsert.executeUpdate();


                        if (queryResult < 0) {
                            transConnection.rollback();
                            return false;

                        }
                        if (clientStatus.equals("1")) {
                            params = new Vector();

                            queryResult = -1000;

                            params.addElement(new StringValue(UniqueIDGen.getNextID()));
                            params.addElement(new StringValue("New"));
                            params.addElement(new StringValue(id));
                            params.addElement(new StringValue("No Description"));
                            forInsert.setConnection(transConnection);
                            forInsert.setSQLQuery(getQuery("insertInitialClientStatus").trim());
                            forInsert.setparams(params);
                            queryResult = forInsert.executeUpdate();

                            if (queryResult < 0) {
                                transConnection.rollback();
                                return false;
                            }
                        }

                    } catch (SQLException se) {
                        logger.error(se.getMessage());
                        transConnection.rollback();
                        return false;
//
                    } finally {
                        endTransaction();
                    }

                    //////////// Insert Client In Real Estate  //////
                    if (connectByRealEstate != null && !connectByRealEstate.equals("")
                            && connectByRealEstate.equals("1")) {
                        int qryResult = -1000;
                        if (queryResult > 0) {
                            Vector SQLparams = new Vector();
                            SQLparams.addElement(new StringValue(code));
                            SQLparams.addElement(new StringValue(request.getParameter("clientName")));
                            SQLparams.addElement(new StringValue(request.getParameter("clientName")));
                            try {
                                Class.forName(driver);
                                conn = DriverManager.getConnection(URL, userName, password);
                                conn.setAutoCommit(false);
                                forInsert.setConnection(conn);
                                forInsert.setparams(SQLparams);
                                myQuery = getQuery("saveClientInRealEstate").trim();
                                forInsert.setSQLQuery(myQuery);
                                qryResult = forInsert.executeUpdate();
                            } catch (Exception se) {
                                logger.error("database error " + se.getMessage());
                            } finally {
                                try {
                                    conn.commit();
                                    conn.close();
                                } catch (SQLException sex) {
                                    logger.error("troubles closing connection " + sex.getMessage());
                                    return false;
                                }
                            }
                        }
                    }
                }

            } catch (Exception se) {

                logger.error("database error " + se.getMessage());
                return false;
            }
            return excuteQuery;
        } else {
            return saveClient(request, s);
        }

    }
    ////////////////////////////////////////////////////////////////

    public boolean saveClientRealState2(HttpServletRequest request, HttpSession s) throws NoUserInSessionException, SQLException {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String connectByRealEstate = metaDataMgr.getConnectByRealEstate();
        String code = null;
        String userName = null;
        String password = null;
        String driver = null;
        String URL = null;
        Connection conn = null;
        String clientNo = null;
        String clientNoRealState = null;
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String clientStatus = null;
        boolean excuteQuery = false;
        SequenceMgr sequenceMgr = SequenceMgr.getInstance();
        /////////// Get Client date from Real Estate ////////////

        userName = metaDataMgr.getRealEstateName();
        password = metaDataMgr.getRealEstatePassword();
        driver = metaDataMgr.getDriverErp();
        URL = metaDataMgr.getDataBaseErpUrl();
        Vector queryRsult = new Vector();
        Vector parameter = new Vector();


        SQLCommandBean forQuery = new SQLCommandBean();

        String automatedClientNo = request.getParameter("automatedClientNo");


        if (automatedClientNo == null || automatedClientNo == "") {
            clientNoRealState = (String) request.getParameter("clientNO");



            try {
                parameter.add(new StringValue(clientNoRealState));
                Class.forName(driver);
                conn = DriverManager.getConnection(URL, userName, password);
                conn.setAutoCommit(false);
                forQuery.setConnection(conn);
                forQuery.setparams(parameter);
                String myQuery = getQuery("checkCodeUnique").trim();
                forQuery.setSQLQuery(myQuery);
                queryRsult = forQuery.executeQuery();

                if (queryRsult.size() > 0) {
                    excuteQuery = false;


                } else {
                    excuteQuery = true;

                    String str0 = "";
                    for (int x = clientNoRealState.length(); x < 8; x++) {
                        str0 = str0 + "0";
                    }
                    code = str0 + clientNoRealState;

                    sequenceMgr.updateSequence();
                    clientNo = sequenceMgr.getSequence();
                    Vector params = new Vector();
                    SQLCommandBean forInsert = new SQLCommandBean();
                    int queryResult = -1000;
                    String clientNoByDate = null;
                    String id = UniqueIDGen.getNextID();
                    params.addElement(new StringValue(id));
                    params.addElement(new StringValue(clientNo));
                    params.addElement(new StringValue(request.getParameter("clientName")));
                    params.addElement(new StringValue(request.getParameter("gender")));
                    params.addElement(new StringValue(request.getParameter("matiralStatus")));
                    if (request.getParameter("clientMobile") != null && !request.getParameter("clientMobile").isEmpty()) {
                        params.addElement(new StringValue(request.getParameter("clientMobile")));
                    } else {
                        params.addElement(new StringValue(" "));
                    }
                    if (request.getParameter("phone") != null && !request.getParameter("phone").isEmpty()) {
                        params.addElement(new StringValue(request.getParameter("phone")));
                    } else {
                        params.addElement(new StringValue(" "));
                    }
                    params.addElement(new StringValue(request.getParameter("clientSalary")));

                    params.addElement(new StringValue(request.getParameter("address")));

                    if (request.getParameter("email") != null && !request.getParameter("email").isEmpty()) {
                        params.addElement(new StringValue(request.getParameter("email")));
                    } else {
                        params.addElement(new StringValue(""));
                    }
                    if (request.getParameter("isActive") != null) {
                        params.addElement(new StringValue("1"));
                        clientStatus = "1";

                    } else {
                        params.addElement(new StringValue("0"));
                        clientStatus = "0";
                    }
                    params.addElement(new StringValue((String) waUser.getAttribute("userId")));
//        params.addElement(new StringValue("1"));
                    Calendar calendar = Calendar.getInstance();
                    calendar.setTime(new java.util.Date());
                    clientNoByDate = (calendar.get(Calendar.MONTH) + 1) + "/" + calendar.get(Calendar.YEAR);
                    params.addElement(new StringValue(clientNoByDate));



                    params.addElement(new StringValue(request.getParameter("clientSsn")));
                    params.addElement(new StringValue(request.getParameter("age")));
                    if (request.getParameter("partner") != null && !request.getParameter("partner").isEmpty()) {
                        params.addElement(new StringValue(request.getParameter("partner")));
                    } else {
                        params.addElement(new StringValue("  "));
                    }

                    TradeMgr tradeMgr = TradeMgr.getInstance();
                    WebBusinessObject wbo = new WebBusinessObject();
                    wbo = tradeMgr.getOnSingleKey("key2", request.getParameter("job"));
                    if (wbo != null) {
                        params.addElement(new StringValue((String) wbo.getAttribute("tradeName")));
                    } else {
                        params.addElement(new StringValue(" "));
                    }
                    params.addElement(new StringValue(request.getParameter("workOut")));//option1
                    params.addElement(new StringValue(request.getParameter("kindred")));//option2
                    params.addElement(new StringValue(request.getParameter("company")));//option3

                    if (connectByRealEstate != null && !connectByRealEstate.equals("")
                            && connectByRealEstate.equals("1")) {
                        params.addElement(new StringValue(code));
                        request.setAttribute("code", code);
                    } else {
                        params.addElement(new StringValue(clientNo));
                        request.setAttribute("code", clientNoByDate);
                    }

                    request.setAttribute("clientId", id);

//        Connection connection = null;
                    try {
//            connection = dataSource.getConnection();
                        beginTransaction();
//            connection.setAutoCommit(true);
                        forInsert.setConnection(transConnection);
                        myQuery = getQuery("insertClient").trim();
                        forInsert.setSQLQuery(myQuery);
                        forInsert.setparams(params);
                        queryResult = forInsert.executeUpdate();

                        if (queryResult < 0) {
                            transConnection.rollback();
                            return false;

                        }
                        if (clientStatus.equals("1")) {
                            params = new Vector();

                            queryResult = -1000;

                            params.addElement(new StringValue(UniqueIDGen.getNextID()));
                            params.addElement(new StringValue("New"));
                            params.addElement(new StringValue(id));
                            params.addElement(new StringValue("No Description"));

                            forInsert.setConnection(transConnection);
                            forInsert.setSQLQuery(getQuery("insertInitialClientStatus").trim());
                            forInsert.setparams(params);
                            queryResult = forInsert.executeUpdate();

                            if (queryResult < 0) {
                                transConnection.rollback();
                                return false;

                            }
                        }

                    } catch (SQLException se) {
                        logger.error(se.getMessage());
                        transConnection.rollback();
                        return false;

                    } finally {
                        endTransaction();
                    }

                    //////////// Insert Client In Real Estate  //////
                    if (connectByRealEstate != null && !connectByRealEstate.equals("")
                            && connectByRealEstate.equals("1")) {
                        int qryResult = -1000;
                        if (queryResult > 0) {
                            Vector SQLparams = new Vector();
                            SQLparams.addElement(new StringValue(code));
                            SQLparams.addElement(new StringValue(request.getParameter("clientName")));
                            SQLparams.addElement(new StringValue(request.getParameter("clientName")));
                            try {
                                Class.forName(driver);
                                conn = DriverManager.getConnection(URL, userName, password);
                                conn.setAutoCommit(false);
                                forInsert.setConnection(conn);
                                forInsert.setparams(SQLparams);
                                myQuery = getQuery("saveClientInRealEstate").trim();
                                forInsert.setSQLQuery(myQuery);
                                qryResult = forInsert.executeUpdate();
                            } catch (Exception se) {
                                logger.error("database error " + se.getMessage());
                            } finally {
                                try {
                                    conn.commit();
                                    conn.close();
                                } catch (SQLException sex) {
                                    logger.error("troubles closing connection " + sex.getMessage());
                                    return false;
                                }
                            }
                        }
                    }
                }
            } catch (Exception se) {

                logger.error("database error " + se.getMessage());
                return false;
            }
            return excuteQuery;
        } else {
            return saveClientData(request, s);
        }

    }
    ////////////////////////////////////////////////////////////////

    public boolean updateClient(HttpServletRequest request) throws NoUserInSessionException, SQLException {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String connectByRealEstate = metaDataMgr.getConnectByRealEstate();
        String code = null;
        String userName = null;
        String password = null;
        String driver = null;
        String URL = null;
        Connection conn = null;
        String clientId = null;
        Vector SQLparams = new Vector();
        /////////// Get Client date from Real Estate ////////////
        if (connectByRealEstate != null && !connectByRealEstate.equals("")
                && connectByRealEstate.equals("1")) {
            userName = metaDataMgr.getRealEstateName();
            password = metaDataMgr.getRealEstatePassword();
            driver = metaDataMgr.getDriverErp();
            URL = metaDataMgr.getDataBaseErpUrl();
            Vector queryRsult = new Vector();
            SQLparams = new Vector();
            SQLCommandBean forQuery = new SQLCommandBean();
            SQLparams.addElement(new StringValue(request.getParameter("code")));
            try {
                Class.forName(driver);
                conn = DriverManager.getConnection(URL, userName, password);
                conn.setAutoCommit(false);
                forQuery.setConnection(conn);
                forQuery.setparams(SQLparams);
                String myQuery = getQuery("getClientInRealEstate").trim();
                forQuery.setSQLQuery(myQuery);
                queryRsult = forQuery.executeQuery();
            } catch (Exception se) {
                logger.error("database error " + se.getMessage());
            } finally {
                try {
                    conn.commit();
                    conn.close();
                } catch (SQLException sex) {
                    logger.error("troubles closing connection " + sex.getMessage());
                    return false;
                }
            }

            Vector resultBusObjs = new Vector();
            WebBusinessObject wbo2;
            Row r = null;
            Enumeration e = queryRsult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                try {
                    clientId = r.getString("clientId");
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        ///////////////////////////////////////////

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue(request.getParameter("clientNO")));
        params.addElement(new StringValue(request.getParameter("name")));
        params.addElement(new StringValue(request.getParameter("gender")));
        params.addElement(new StringValue(request.getParameter("matiral_status")));
        params.addElement(new StringValue(request.getParameter("mobile")));
        if (request.getParameter("phone") != null && !request.getParameter("phone").isEmpty()) {
            params.addElement(new StringValue(request.getParameter("phone")));
        } else {
            params.addElement(new StringValue(" "));
        }
        if (request.getParameter("salary") != null && !request.getParameter("salary").isEmpty()) {
            params.addElement(new StringValue(request.getParameter("salary")));
        } else {
            params.addElement(new StringValue("0"));
        }

        params.addElement(new StringValue(request.getParameter("address")));
        params.addElement(new StringValue(request.getParameter("email")));

        if (request.getParameter("clientSsn") != null && !request.getParameter("clientSsn").isEmpty()) {
            params.addElement(new StringValue(request.getParameter("clientSsn")));
        } else {
            params.addElement(new StringValue("  "));
        }
        params.addElement(new StringValue(request.getParameter("age")));
        if (request.getParameter("partner") != null && !request.getParameter("partner").isEmpty()) {
            params.addElement(new StringValue(request.getParameter("partner")));
        } else {
            params.addElement(new StringValue("  "));
        }
        if (request.getParameter("isActive") != null) {
            params.addElement(new StringValue("1"));
        } else {
            params.addElement(new StringValue("0"));
        }
        if (request.getParameter("workOut") != null) {
            params.addElement(new StringValue(request.getParameter("workOut")));
        } else {
            params.addElement(new StringValue("0"));
        }
        if (request.getParameter("kindred") != null) {
            params.addElement(new StringValue(request.getParameter("kindred")));
        } else {
            params.addElement(new StringValue("0"));
        }
        if (request.getParameter("clientJob") != null) {
            params.addElement(new StringValue(request.getParameter("clientJob")));
        } else {
            params.addElement(new StringValue("not selected"));
        }
        params.addElement(new StringValue(request.getParameter("clientID")));


        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(true);
//            beginTransaction();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("updateClient").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
//            return true;
//            endTransaction();


        } catch (SQLException se) {
            logger.error("Exception updating project: " + se.getMessage());
            return false;
        } finally {
            connection.close();

        }

        if (queryResult > 0) {
            //////////// Update Client In Real Estate  //////
            if (connectByRealEstate != null && !connectByRealEstate.equals("")
                    && connectByRealEstate.equals("1")) {
                int qryResult = -1000;
                if (queryResult > 0) {
                    SQLparams = new Vector();
                    SQLparams.addElement(new StringValue(request.getParameter("name")));
                    SQLparams.addElement(new StringValue(request.getParameter("name")));
                    SQLparams.addElement(new StringValue(clientId));
                    try {
                        Class.forName(driver);
                        conn = DriverManager.getConnection(URL, userName, password);
                        conn.setAutoCommit(false);
                        forUpdate.setConnection(conn);
                        forUpdate.setparams(SQLparams);
                        String myQuery = getQuery("updateClientInRealEstate").trim();
                        forUpdate.setSQLQuery(myQuery);
                        qryResult = forUpdate.executeUpdate();
                    } catch (Exception se) {
                        logger.error("database error " + se.getMessage());
                    } finally {
                        try {
                            conn.commit();
                            conn.close();
                        } catch (SQLException sex) {
                            logger.error("troubles closing connection " + sex.getMessage());
                            return false;
                        }
                    }
                }
            }
            //////////////////////////////////////////////////
        }

        return (queryResult > 0);
    }

    public boolean updateCounter(HttpServletRequest request) throws NoUserInSessionException, SQLException {


        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue(request.getParameter("count")));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(true);
//            beginTransaction();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(getQuery("updateCounter").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();
            return true;
//            endTransaction();


        } catch (SQLException se) {
            logger.error("Exception updating project: " + se.getMessage());
            return false;
        } finally {
            connection.close();

        }

//        return (queryResult > 0);
    }

    public ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        if (cashedTable != null) {
            for (int i = 0; i < cashedTable.size(); i++) {
                wbo = (WebBusinessObject) cashedTable.elementAt(i);
                cashedData.add((String) wbo.getAttribute("name"));
            }
        }

        return cashedData;
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

    public String getAllSuppNo() {
        Connection connection = null;
        ResultSet result = null;
        StringBuffer returnSB = null;

        try {
            connection = dataSource.getConnection();
            Statement select = connection.createStatement();
            result = select.executeQuery(sqlMgr.getSql("getAllSuppNo").trim());
            returnSB = new StringBuffer();
            while (result.next()) {
                returnSB.append(result.getString("SUPPLIER_NO") + ",");
            }
            returnSB.deleteCharAt(returnSB.length() - 1);
        } catch (SQLException e) {
            logger.error("error ================ > " + e.toString());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        return returnSB.toString();
    }

    public Vector getAllSuppliersByEquipment(HttpServletRequest request) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector params = new Vector();
        params.addElement(new StringValue(request.getParameter("equipmentID")));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();


        try {
            forQuery.setparams(params);
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectAllSuppliersSQL").trim());
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
        } catch (Exception e) {
            logger.error("Exception  " + e.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
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

    public Vector getClientReportByDate(String date) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector params = new Vector();
        params.addElement(new StringValue(date));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();


        try {
            forQuery.setparams(params);
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientReportByDate"));
            queryResult = forQuery.executeQuery();


        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
        } catch (Exception e) {
            logger.error("Exception  " + e.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
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

    public Vector getClientReportByAgeGroup(String age) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector params = new Vector();
        params.addElement(new StringValue(age));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();


        try {
            forQuery.setparams(params);
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientReportByAgeGroup"));
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
        } catch (Exception e) {
            logger.error("Exception  " + e.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
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

    public Vector getClientReportByJob(String job) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector params = new Vector();
        params.addElement(new StringValue(job));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();


        try {
            forQuery.setparams(params);
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            if (job.equalsIgnoreCase("all")) {
                forQuery.setSQLQuery(getQuery("clients"));
            } else {
                forQuery.setSQLQuery(getQuery("getClientReportByjob"));
            }
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
        } catch (Exception e) {
            logger.error("Exception  " + e.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
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

    public ArrayList getAllSuppliers() {
        WebBusinessObject wbo = new WebBusinessObject();
        Tools tools = new Tools();
        Connection connection = null;
        Vector params = new Vector();
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        forQuery.setparams(params);
        try {
            connection = dataSource.getConnection();
        } catch (SQLException ex) {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        forQuery.setConnection(connection);
        forQuery.setSQLQuery(sqlMgr.getSql("selectAllSuppliers").trim());
        try {
            queryResult = forQuery.executeQuery();
        } catch (SQLException ex) {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
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

    public boolean canDelete(String clientId) {
        boolean canDelete = false;
        ExternalJobMgr externalJobMgr = ExternalJobMgr.getInstance();
        Vector externalJobOrderVec = new Vector();

        try {
            externalJobOrderVec = externalJobMgr.getOnArbitraryKey(clientId, "key1");

            if (externalJobOrderVec.isEmpty()) {
                canDelete = true;
            }
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        return canDelete;
    }

    public WebBusinessObject getClientByCall(String callId) throws SQLException {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = new Vector();

        SQLparams.addElement(new StringValue(callId));

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getClientByCall").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();



        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());

        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {

            connection.close();
        }
        Row r;

        if (!queryResult.isEmpty()) {
            Enumeration e = queryResult.elements();
            r = (Row) e.nextElement();

            wbo = fabricateBusObj(r);
            return wbo;
        } else {
            return null;
        }





    }

    public String getCounter() throws SQLException, NoSuchColumnException {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;

        Vector SQLparams = new Vector();
        Vector queryResult = new Vector();

        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getCounter").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();



        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());

        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {

            connection.close();
        }
        Row r;

        if (!queryResult.isEmpty()) {
            Enumeration e = queryResult.elements();
            r = (Row) e.nextElement();
            String count = r.getString("option3");

            return count;
        } else {
            return null;
        }





    }

    public boolean deleteClientInRealEstate(HttpServletRequest request) throws NoUserInSessionException, SQLException {

        /////////// Get Client date from Real Estate ////////////
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String userName = metaDataMgr.getRealEstateName();
        String password = metaDataMgr.getRealEstatePassword();
        String driver = metaDataMgr.getDriverErp();
        String URL = metaDataMgr.getDataBaseErpUrl();
        Connection conn = null;
        Vector queryRsult = new Vector();
        Vector SQLparams = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        SQLparams.addElement(new StringValue(request.getParameter("code")));
        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(URL, userName, password);
            conn.setAutoCommit(false);
            forQuery.setConnection(conn);
            forQuery.setparams(SQLparams);
            String myQuery = getQuery("getClientInRealEstate").trim();
            forQuery.setSQLQuery(myQuery);
            queryRsult = forQuery.executeQuery();
        } catch (Exception se) {
            logger.error("database error " + se.getMessage());
        } finally {
            try {
                conn.commit();
                conn.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }

        Vector resultBusObjs = new Vector();
        WebBusinessObject wbo2;
        Row r = null;
        Enumeration e = queryRsult.elements();
        String clientId = null;
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            try {
                clientId = r.getString("clientId");
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(ClientMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        ///////////////////////////////////////////

        SQLCommandBean forUpdate = new SQLCommandBean();

        //////////// Update Client In Real Estate  //////
        int qryResult = -1000;

        SQLparams = new Vector();
        SQLparams.addElement(new StringValue(clientId));
        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(URL, userName, password);
            conn.setAutoCommit(false);
            forUpdate.setConnection(conn);
            forUpdate.setparams(SQLparams);
            String myQuery = getQuery("deleteClientInRealEstate").trim();
            forUpdate.setSQLQuery(myQuery);
            qryResult = forUpdate.executeUpdate();
        } catch (Exception se) {
            logger.error("database error " + se.getMessage());
        } finally {
            try {
                conn.commit();
                conn.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }

        //////////////////////////////////////////////////
        return (qryResult > 0);
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }
}
