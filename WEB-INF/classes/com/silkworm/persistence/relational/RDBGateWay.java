//Title:        web apps
//Version:
//Copyright:    Copyright (c) 1999
//Author:       walid mohamed
//Company:      silkworm
//Description:  Your description
// to-do: move methods to ServletUtil and use them instead
// to-do: filter request
package com.silkworm.persistence.relational;

import java.util.*;
import java.sql.*;
import java.lang.reflect.*;

import javax.servlet.http.HttpServletRequest;
import javax.sql.*;

import com.silkworm.common.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.pagination.FilterCondition;
import com.silkworm.pagination.Filter;
import com.silkworm.pagination.Operations;
import com.silkworm.util.*;
import java.io.File;
import java.math.BigDecimal;

import org.apache.log4j.Logger;
import org.apache.log4j.xml.DOMConfigurator;

// new for reading queries from prop file for each manager
import java.util.Map;
import java.util.HashMap;
import java.io.InputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;

public abstract class RDBGateWay {

    protected static DataSource dataSource;
    protected BusinessForm supportedForm = null;
    protected Vector cashedTable = null;
    protected ArrayList cashedData = null;
    protected HttpServletRequest theRequest = null;
    protected ArrayList queryElements = null;
    protected ArrayList presentQueryParameters = null; // the user has entered some thing in the form field
    protected WebBusinessObject currentUser = null;
    protected Connection transConnection = null;
    protected static Logger logger = Logger.getLogger(RDBGateWay.class);
    protected String webInfPath = null;
    public static String staticWebInfPath = null;
    protected MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
    protected IQueryMgr queryMgr = null;
    //protected SqlMgr sqlMgr = SqlMgr.getInstance();
    // new for reading queries from prop file for each manager
    protected Properties queriesProps = new java.util.Properties();
    protected HashMap<String, String> queriesMap = null;
    protected Set<Map.Entry<String, String>> queriesSet = null;
    protected InputStream queriesIS = null;
    protected String queriesPropFileName = null;

    protected RDBGateWay() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        try {
            logger = Logger.getLogger(this.getClass());
        } catch (Exception ex) {
            System.err.println("Can't Inti. Logger, " + ex);
        }
    }

    public void setQueryMgr(IQueryMgr iQueryMgr) {
        queryMgr = iQueryMgr;
    }

    public void setUser(WebBusinessObject user) {
        currentUser = user;
    }

    protected Connection getConnection() {
        Connection connection = null;

        try {
            connection = dataSource.getConnection();
        } catch (SQLException sqlEx) {
            logger.error("Unable to get connection to dataBase " + sqlEx.getMessage());
        }

        return connection;
    }

    protected void beginTransaction() {

        try {
            transConnection = dataSource.getConnection();
            transConnection.setAutoCommit(true);
        } catch (SQLException e) {
            logger.error("Unable to get Transaction connection for database " + e.getMessage());
        }
    }

    protected void endTransaction() {
        try {
            transConnection.commit();
            transConnection.setAutoCommit(true);
            transConnection.close();
        } catch (SQLException e) {
            logger.error("Unable to commit transaction" + e.getMessage());
        }
    }
    
    protected void rollbackTransaction() {
        try {
            transConnection.rollback();
            transConnection.close();
        } catch (SQLException e) {
            logger.error("Unable to rollback transaction" + e.getMessage());
        }
    }

    public void setDataSource(DataSource ds) {
        // all to do with database connectivity is here

        Class c = getClass();
        String cn = c.getSimpleName();

        queriesPropFileName = cn + "." + "properties";
        dataSource = ds;

        initSupportedForm();
        initSupportedQueries();
        stramQueries();
    }

    public DataSource getDataSource() {
        return dataSource;
    }

    public abstract boolean saveObject(WebBusinessObject wbo) throws SQLException;

    protected abstract void initSupportedForm();

    protected abstract void initSupportedQueries();

    public Vector getSearchQueryResult(HttpServletRequest req) throws SQLException, Exception {
        // class variables setting
        this.theRequest = req;
        this.presentQueryParameters = ServletUtils.getRequestParams(theRequest);

        Vector SQLparams = new Vector();
        Object[] objectParams = new Object[1];
        Class[] classParams = new Class[1];

        StringBuffer dq = new StringBuffer("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");

        if (supportedForm == null) {

            initSupportedForm();
        }

        // BUILD THE SEARCH QUERY
        DictionaryItem di = null;
        FormElement fe = null;
        initQueryElemnts();
        ListIterator li = queryElements.listIterator();
        while (li.hasNext()) {

            di = (DictionaryItem) li.next();

            fe = (FormElement) supportedForm.getBusinessObjet(di.getItemName());

            if (fe != null) {

                dq.append((String) fe.getAttribute("column"));
                dq.append(" ");

                String matchCriteria = (String) fe.getAttribute("matchon");
                String classType = (String) fe.getAttribute("class");
                if (matchCriteria.equals("NOTEQUAL")) {
                    dq.append("!=");
                } else if (matchCriteria.equals("LESS")) {
                    dq.append("<");
                    objectParams[0] = di.getItemValue(classType);
                } else {
                    dq.append(matchCriteria);
                    objectParams[0] = di.getItemValue(classType);

                }
                dq.append(" ? AND ");
                try {

                    classParams[0] = Class.forName((String) fe.getAttribute("jclass"));

                    Class c = Class.forName((String) fe.getAttribute("class"));
                    Constructor cons = c.getConstructor(classParams);
                    Object param = cons.newInstance(objectParams);

                    if (cons != null) {
                        SQLparams.add(cons.newInstance(objectParams));
                    }
                } catch (Exception e) {

                    logger.error("Exception ..." + e.getMessage());
                } finally {
                    logger.error(dq);
                }
            }

        }

        String theQuery = dq.substring(0, (dq.length() - 4));
        logger.info("the query " + theQuery);

        // finally do the query
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;
    }

    protected ArrayList getRequestParams(HttpServletRequest request) {
        String param;
        String value;
        ArrayList requestParams = new ArrayList();

        // clear the existing requestParameter
        Enumeration e = request.getParameterNames();

        while (e.hasMoreElements()) {
            param = (String) e.nextElement();
            value = (String) request.getParameter(param);

            if (!value.equals("")) {

                requestParams.add(new DictionaryItem(param, value));
            }
        }
        return requestParams;

    }

    // debug method
    protected void printRequest(ArrayList reqParams) {
        DictionaryItem di = null;
        ListIterator li = reqParams.listIterator();

        while (li.hasNext()) {
            di = (DictionaryItem) li.next();
            logger.info("P NAME: " + di.getItemName() + "P VALUE: " + di.getItemValue());
        }

    }

    protected WebBusinessObject fabricateBusObj(Row row) {

        ListIterator li = supportedForm.getFormElemnts().listIterator();
        FormElement fe = null;
        Hashtable ht = new Hashtable();
        String colName;

        while (li.hasNext()) {
            try {
                fe = (FormElement) li.next();
                colName = (String) fe.getAttribute("column");
                // needs a case ......
                ht.put(fe.getAttribute("name"), row.getString(colName));
            } catch (Exception e) { /* raise an exception */ }
        }

        WebBusinessObject wbo = new WebBusinessObject(ht);
        return wbo;
    }
    
    protected ArrayList fabricateArrayListObj(Row row) {

        ListIterator li = supportedForm.getFormElemnts().listIterator();
        FormElement fe = null;
        Hashtable ht = new Hashtable();
        String colName;
        ArrayList result = new ArrayList();

        while (li.hasNext()) {
            try {
                fe = (FormElement) li.next();
                colName = (String) fe.getAttribute("column");
                // needs a case ......
                result.add(row.getString(colName));
            } catch (Exception e) { /* raise an exception */ }
        }
        return result;
    }

    public void deleteRecord(HttpServletRequest request) throws SQLException {
        Vector SQLparams = new Vector();
        Object[] objectParams = new Object[1];
        Class[] classParams = new Class[1];

        String supportedTable = (String) supportedForm.getTableSupported().getAttribute("name");
        StringBuilder dq = new StringBuilder("DELETE FROM ");
        dq.append(supportedTable).append(" WHERE ");

        // BUILD THE SEARCH QUERY
        DictionaryItem di = null;
        FormElement fe = null;
        ListIterator li = getRequestParams(request).listIterator();

        while (li.hasNext()) {
            di = (DictionaryItem) li.next();
            fe = (FormElement) supportedForm.getBusinessObjet(di.getItemName());
            dq.append((String) fe.getAttribute("column"));
            dq.append(" = ? AND ");

            try {
                objectParams[0] = di.getItemValue();
                classParams[0] = Class.forName((String) fe.getAttribute("jclass"));

                Class c = Class.forName((String) fe.getAttribute("class"));
                Constructor cons = c.getConstructor(classParams);

                if (cons != null) {
                    SQLparams.add(cons.newInstance(objectParams));
                }
            } catch (Exception e) {
                logger.error("Exception ..." + e.getMessage());
            }
        }

        String theQuery;
        theQuery = dq.substring(0, (dq.length() - 4));

        logger.info("the query " + theQuery);

        SQLCommandBean forDelete = new SQLCommandBean();
        try {
            forDelete.setConnection(dataSource.getConnection());
            forDelete.setSQLQuery(theQuery);
            forDelete.setparams(SQLparams);
            forDelete.executeUpdate();

        } catch (SQLException se) {
            throw se;
        } finally {
        }
    }

    protected StringValue getSingleParamValue(HttpServletRequest req) throws EmptyRequestException {
        StringValue id = null;
        DictionaryItem di = null;
        int reqParamsNo = getRequestParams(req).size();
        ListIterator li = getRequestParams(req).listIterator();

        if (reqParamsNo == 0) {
            throw new EmptyRequestException("No Parameters Pased in Request");
        }

        while (li.hasNext()) {
            di = (DictionaryItem) li.next();
            id = new StringValue(di.getItemValue());
        }

        return id;
    }

    protected java.sql.Timestamp extractDate2FromRequest() {
        DictionaryItem tsItem = null;
        String[] timeStamp = new String[6];
        String month = (String) theRequest.getParameter("month2");
        month = DateAndTimeConstants.getMonthAsNumberString(month);

        timeStamp[0] = new String((String) theRequest.getParameter("year2"));
        timeStamp[1] = new String(month);
        timeStamp[2] = new String((String) theRequest.getParameter("day2"));
        timeStamp[3] = new String("00");
        timeStamp[4] = new String("00");
        timeStamp[5] = new String("00");

        return TimeServices.toTimestamp(timeStamp);
    }

    protected String getSingleParamString(HttpServletRequest req) throws EmptyRequestException {

        String id = null;
        DictionaryItem di = null;
        int reqParamsNo = getRequestParams(req).size();
        ListIterator li = getRequestParams(req).listIterator();

        if (reqParamsNo == 0) {
            throw new EmptyRequestException("No Parameters Pased in Request");
        }

        while (li.hasNext()) {
            di = (DictionaryItem) li.next();
            id = new String(di.getItemValue());
        }

        return id;
    }
    // default

    protected void initQueryElemnts() throws EmptyRequestException {
        if (null == theRequest) {
            throw new EmptyRequestException("request has not been initialized");
        } else {
            queryElements = getRequestParams(theRequest);
        }
    }

    protected DictionaryItem getRequestParamAsDictionaryItem(String paramName) throws EmptyRequestException {

        String param;
        String value;
        DictionaryItem resultItem = null;
        int index = 0;
        // the request has not been initilaized
        if (null == theRequest) {
            throw new EmptyRequestException("request has not been initialized");
        } else {

            ListIterator li = this.presentQueryParameters.listIterator();

            while (li.hasNext()) {
                resultItem = (DictionaryItem) li.next();
                if (resultItem.getItemName().equals(paramName)) {
                    return resultItem;
                }

            }
        }

        return null;
    }

    public void setWebInfPath(String path) {
        staticWebInfPath = path;
        webInfPath = path;
        staticWebInfPath = path;
    }

    public long countAll() {
        StringBuilder stringBuilder = new StringBuilder("SELECT COUNT(*) AS NUMBER_ROWS FROM ");
        stringBuilder.append(supportedForm.getTableSupported().getAttribute("name"));

        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> queryResult = null;
        String NUMBER_ROWS = null;

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(stringBuilder.toString());

            queryResult = command.executeQuery();

            for (Row row : queryResult) {
                NUMBER_ROWS = row.getString("NUMBER_ROWS");
            }

            return Long.valueOf(NUMBER_ROWS).longValue();
        } catch (SQLException sQLException) {
            logger.error(sQLException.getMessage());
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        return 0;
    }

    public Vector getAllRowByIndex() {
        StringBuilder stringBuilder = new StringBuilder("SELECT USERS.*, ROW_NUMBER() OVER (ORDER BY USERS.USER_NAME) AS INDICES FROM ");
        stringBuilder.append(supportedForm.getTableSupported().getAttribute("name"));

        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> queryResult = null;
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(stringBuilder.toString());

            queryResult = command.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error(uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        // process the vector
        // vector of business objects
        WebBusinessObject wbo;
        Vector reultBusObjs = new Vector();

        for (Row row : queryResult) {
            wbo = fabricateBusObj(row);

            try {
                wbo.setAttribute("index", row.getString("INDICES"));
            } catch (Exception ex) {
            }

            reultBusObjs.add(wbo);
        }

        return reultBusObjs;
    }

    public String getIdRecordByIndex(int index) {
        String id = (String) supportedForm.getTableSupported().getAttribute("key");

        StringBuilder stringBuilder = new StringBuilder("SELECT * FROM (SELECT ");
        stringBuilder.append(id);
        stringBuilder.append(", ROW_NUMBER() OVER (ORDER BY ");
        stringBuilder.append(supportedForm.getTableSupported().getAttribute("orderby"));
        stringBuilder.append(") AS INDICES FROM ");
        stringBuilder.append(supportedForm.getTableSupported().getAttribute("name"));
        stringBuilder.append(") WHERE INDICES = ?");

        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> queryResult = null;
        Vector parameters = new Vector();

        parameters.addElement(new IntValue(index));
        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(stringBuilder.toString());
            command.setparams(parameters);

            queryResult = command.executeQuery();
            for (Row row : queryResult) {
                try {
                    return row.getString(id);
                } catch (Exception ex) {
                }
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error(uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        return "";
    }

    protected Vector getAllTableRaws() throws SQLException, Exception {
        StringBuilder dq = new StringBuilder("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name"));
        String theQuery = dq.substring(0, (dq.length()));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
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

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;
    }

    public void cashData() {
        logger.info("Cashing table data ......");
        try {
            cashedTable = getAllTableRaws();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
    }

    public Vector getCashedTable() {
        cashData();
        return cashedTable;
    }

    public WebBusinessObjectsContainer getCashedTableAsContainer() {
        if (null != cashedTable) {
            return new WebBusinessObjectsContainer(cashedTable);
        } else {
            return null;
        }

    }

    public Vector getSearchOnStatus(String status) throws SQLException, Exception {
        Vector SQLparams = new Vector();

        StringBuilder dq = new StringBuilder("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");
        dq.append("CURRENT_STATUS = ?");
        String theQuery = dq.toString();

        if (supportedForm == null) {
            initSupportedForm();
        }

        logger.info("the query " + theQuery);

        // finally do the query
        SQLparams.add(new StringValue(status));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;
    }

    public boolean deleteOnSingleKey(String key) {

        Connection connection = null;

        StringBuffer query = new StringBuffer("DELETE FROM ");
        query.append(supportedForm.getTableSupported().getAttribute("name"));
        query.append(" WHERE ");
        query.append(supportedForm.getTableSupported().getAttribute("key"));
        query.append(" = ?");

        Vector SQLparams = new Vector();
        logger.info("the query " + query.toString());

        SQLparams.addElement(new StringValue(key));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

            forQuery.executeUpdate();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }
        return true;
    }

    public boolean deleteRefIntegKey(String key) {

        Connection connection = null;

        StringBuffer query = new StringBuffer("DELETE FROM ");
        query.append(supportedForm.getTableSupported().getAttribute("name"));
        query.append(" WHERE ");
        query.append(supportedForm.getTableSupported().getAttribute("refintegkey"));
        query.append(" = ?");

        Vector SQLparams = new Vector();
        logger.info("the query " + query.toString());

        SQLparams.addElement(new StringValue(key));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

            forQuery.executeUpdate();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return false;
        }

        return true;
    }

    public boolean deleteSecondRefIntegKey(String key) {

        Connection connection = null;

        StringBuffer query = new StringBuffer("DELETE FROM ");
        query.append(supportedForm.getTableSupported().getAttribute("name"));
        query.append(" WHERE ");
        query.append(supportedForm.getTableSupported().getAttribute("srefintegkey"));
        query.append(" = ?");

        Vector SQLparams = new Vector();
        logger.info("the query " + query.toString());

        SQLparams.addElement(new StringValue(key));

        // Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

            forQuery.executeUpdate();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }
        return true;
    }

    public boolean updateOnSingleKey(String key, String[] updatedKeys, String[] updatedValues) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector result = null;

        StringBuilder query = new StringBuilder("UPDATE ");
        query.append(supportedForm.getTableSupported().getAttribute("name"));
        query.append(" SET ");
        for (int i = 0; i < updatedValues.length; i++) {
            query.append(supportedForm.getTableSupported().getAttribute(updatedKeys[i]));
            query.append(" = ?");
            if (i < (updatedValues.length - 1)) {
                query.append(", ");
            }
        }
        query.append(" WHERE ");
        query.append(supportedForm.getTableSupported().getAttribute("key"));
        query.append(" = ?");

        Vector parameters = new Vector();
        logger.info("the query " + query.toString());

        for (int i = 0; i < updatedValues.length; i++) {
            parameters.addElement(new StringValue(updatedValues[i]));
        }
        parameters.addElement(new StringValue(key));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.toString());
            command.setparams(parameters);
            command.executeUpdate();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }

        return true;
    }
    
    public boolean updateOnSingleKeyB(String key, String[] updatedKeys, String[] updatedValues) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector result = null;

        StringBuilder query = new StringBuilder("UPDATE ");
        query.append(supportedForm.getTableSupported().getAttribute("name"));
        query.append(" SET ");
        for (int i = 0; i < updatedValues.length; i++) {
            query.append(supportedForm.getTableSupported().getAttribute(updatedKeys[i]));
            query.append(" = ?");
            if (i < (updatedValues.length - 1)) {
                query.append(", ");
            }
        }
        query.append(" WHERE ");
        query.append(supportedForm.getTableSupported().getAttribute("key2"));
        query.append(" = ?");

        Vector parameters = new Vector();
        logger.info("the query " + query.toString());

        for (int i = 0; i < updatedValues.length; i++) {
            parameters.addElement(new StringValue(updatedValues[i]));
        }
        parameters.addElement(new StringValue(key));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.toString());
            command.setparams(parameters);
            command.executeUpdate();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }

        return true;
    }

    public boolean updateOnSingleKeyClose(String key, String updatedValues, String checkKeys, String updatedKeys) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector result = null;

        StringBuilder query = new StringBuilder("UPDATE ");
        query.append(supportedForm.getTableSupported().getAttribute("name"));
        query.append(" SET ");
        query.append(supportedForm.getTableSupported().getAttribute(key));
        query.append(" = ?");
        query.append(" WHERE ");
        query.append(supportedForm.getTableSupported().getAttribute(updatedValues));
        query.append(" = ?");

        Vector parameters = new Vector();
        logger.info("the query " + query.toString());

        parameters.addElement(new StringValue(checkKeys));
        parameters.addElement(new StringValue(updatedKeys));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(query.toString());
            command.setparams(parameters);
            command.executeUpdate();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return false;
            }
        }

        return true;
    }
    
    public WebBusinessObject getOnSingleKey(String key) {

        Connection connection = null;

        StringBuffer query = new StringBuffer("SELECT * FROM ");
        query.append(supportedForm.getTableSupported().getAttribute("name"));
        query.append(" WHERE ");
        query.append(supportedForm.getTableSupported().getAttribute("key"));
        query.append(" = ?");

        Vector SQLparams = new Vector();
        logger.info("the query " + query.toString());

        SQLparams.addElement(new StringValue(key));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

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

        WebBusinessObject reultBusObj = null;

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObj = fabricateBusObj(r);
        }

        return reultBusObj;

    }

    public WebBusinessObject getOnSingleKey(String key, String value) {
        Connection connection = null;
        StringBuffer query = new StringBuffer("SELECT * FROM ");
        query.append(supportedForm.getTableSupported().getAttribute("name"));
        query.append(" WHERE ");
        query.append(supportedForm.getTableSupported().getAttribute(key));
        query.append(" = ?");
        Vector SQLparams = new Vector();
        logger.info("the query " + query.toString());
        SQLparams.addElement(new StringValue(value));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

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
        WebBusinessObject reultBusObj = null;
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObj = fabricateBusObj(r);
        }
        return reultBusObj;
    }

    public WebBusinessObject getOnDoubleKey(String key1, String key2) {

        Connection connection = null;

        StringBuffer query = new StringBuffer("SELECT * FROM ");
        query.append(supportedForm.getTableSupported().getAttribute("name"));
        query.append(" WHERE ");
        query.append(supportedForm.getTableSupported().getAttribute("key"));
        query.append(" = ?");

        Vector SQLparams = new Vector();

        logger.info("the query " + query.toString());

        SQLparams.addElement(new StringValue(key1));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

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

        WebBusinessObject reultBusObj = null;

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObj = fabricateBusObj(r);
        }

        return reultBusObj;

    }

    public WebBusinessObject getOnSingleKey1(String key1) {

        Connection connection = null;

        StringBuffer query = new StringBuffer("SELECT * FROM ");
        query.append(supportedForm.getTableSupported().getAttribute("name"));
        query.append(" WHERE ");
        query.append(supportedForm.getTableSupported().getAttribute("key1"));
        query.append(" = ?");

        Vector SQLparams = new Vector();
        logger.info("the query " + query.toString());

        SQLparams.addElement(new StringValue(key1));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

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

        WebBusinessObject reultBusObj = null;

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObj = fabricateBusObj(r);
        }

        return reultBusObj;

    }

    public ArrayList filterOnRefInteg(String filterOption) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;

        StringBuffer dq = new StringBuffer("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");
        dq.append(supportedForm.getTableSupported().getAttribute("refintegkey"));
        dq.append(" = ? ");
        String theQuery = dq.toString();

        if (supportedForm == null) {

            initSupportedForm();
        }
        logger.info("the query " + theQuery);

        // finally do the query
        SQLparams.add(new StringValue(filterOption));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        ArrayList reultBusObjs = new ArrayList();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;

    }

    public Vector getOnRefInteg(String filterOption) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;

        StringBuffer dq = new StringBuffer("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");
        dq.append(supportedForm.getTableSupported().getAttribute("refintegkey"));
        dq.append(" = ? ");
        String theQuery = dq.toString();

        if (supportedForm == null) {

            initSupportedForm();
        }
        logger.info("the query " + theQuery);

        // finally do the query
        SQLparams.add(new StringValue(filterOption));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;

    }

    public Vector getOnArbitraryKey(String keyValue, String keyIndex) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;

        StringBuffer dq = new StringBuffer("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");
        dq.append(supportedForm.getTableSupported().getAttribute(keyIndex));
        dq.append(" = ? ");
        String theQuery = dq.toString();

        if (supportedForm == null) {

            initSupportedForm();
        }

        logger.info("the query " + theQuery);
        logger.info("param Value Key " + keyValue);

        // finally do the query
        SQLparams.add(new StringValue(keyValue));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;

    }

    public Vector getComments(String keyValue, String objectType, String keyIndex) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;

        StringBuffer dq = new StringBuffer("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");
        dq.append(supportedForm.getTableSupported().getAttribute(keyIndex));
        dq.append(" = ? and OBJECT_TYPE= ?");

        dq.append(" order by creation_time desc");
        String theQuery = dq.toString();

        if (supportedForm == null) {

            initSupportedForm();
        }

        logger.info("the query " + theQuery);
        logger.info("param Value Key " + keyValue);

        // finally do the query
        SQLparams.add(new StringValue(keyValue));
        SQLparams.add(new StringValue(objectType));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;

    }

    public ArrayList getOnArbitraryKey2(String keyValue, String keyIndex) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;

        StringBuffer dq = new StringBuffer("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");
        dq.append(supportedForm.getTableSupported().getAttribute(keyIndex));
        dq.append(" = ? ");
        String theQuery = dq.toString();

        if (supportedForm == null) {

            initSupportedForm();
        }

        logger.info("the query " + theQuery);
        logger.info("param Value Key " + keyValue);

        // finally do the query
        SQLparams.add(new StringValue(keyValue));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        ArrayList reultBusObj = new ArrayList();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObj.add(fabricateBusObj(r));

        }

        return reultBusObj;

    }

    public Vector getOnArbitraryKeyOrdered(String keyValue, String keyIndex, String orderIndex) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;

        StringBuffer dq = new StringBuffer("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");
        dq.append(supportedForm.getTableSupported().getAttribute(keyIndex));
        dq.append(" = ? ");
        dq.append(" ORDER BY ");
        dq.append(supportedForm.getTableSupported().getAttribute(orderIndex));
        String theQuery = dq.toString();

        if (supportedForm == null) {

            initSupportedForm();
        }

        logger.info("the query " + theQuery);

        // finally do the query
        SQLparams.add(new StringValue(keyValue));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;

    }

    public Vector getOnArbitraryKeyOracle(String keyValue, String keyIndex) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;

        StringBuffer dq = new StringBuffer("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");
        dq.append(supportedForm.getTableSupported().getAttribute(keyIndex));
        if (keyValue == null) {
            dq.append(" is null ");
        } else {
            dq.append(" = ? ");
        }
        String theQuery = dq.toString();

        if (supportedForm == null) {

            initSupportedForm();
        }

        logger.info("the query " + theQuery);

        // finally do the query
        if (keyValue != null) {
            SQLparams.add(new StringValue(keyValue));
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;

    }

    public Vector getOnArbitraryDoubleKey(String key1Value, String key1Index, String key2Value, String key2Index) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;

        StringBuffer dq = new StringBuffer("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");
        dq.append(supportedForm.getTableSupported().getAttribute(key1Index));
        dq.append(" = ? ");
        dq.append("AND ");
        dq.append(supportedForm.getTableSupported().getAttribute(key2Index));
        dq.append(" = ? ");
        String theQuery = dq.toString();

        if (supportedForm == null) {

            initSupportedForm();
        }
        logger.info("the query " + theQuery);

        // finally do the query
        SQLparams.add(new StringValue(key1Value));
        SQLparams.add(new StringValue(key2Value));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;

    }

    /**
     * **********By Ibrahim******************
     */
    public Vector getOnArbitraryNumberKey(int numOfKeys, String[] keysValue, String[] keysIndex) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;
        String theQuery = "";
        StringBuffer dq = new StringBuffer("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");

        if (keysIndex.length == keysValue.length) {
            if (keysIndex.length == numOfKeys) {
                for (int i = 0; i < numOfKeys - 1; i++) {
                    dq.append(supportedForm.getTableSupported().getAttribute(keysIndex[i]));
                    dq.append(" = ? ");
                    dq.append("AND ");
                }
                dq.append(supportedForm.getTableSupported().getAttribute(keysIndex[keysIndex.length - 1]));
                dq.append(" = ? ");
                theQuery = dq.toString();
            }
        }

        if (supportedForm == null) {

            initSupportedForm();
        }
        logger.info("the query " + theQuery);

        // finally do the query
        if (keysIndex.length == keysValue.length) {
            if (keysIndex.length == numOfKeys) {
                for (int i = 0; i < numOfKeys; i++) {
                    SQLparams.add(new StringValue(keysValue[i]));
                }
            }
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;

    }

    public Vector getComplaintsWithEntryDate(int numOfKeys, String[] keysValue, String[] keysIndex, String orderIndex, String beginDate, String endDate, String resp) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;
        String theQuery = "";
        StringBuffer dq = new StringBuffer("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");

        if (keysIndex.length == keysValue.length) {
            if (keysIndex.length == numOfKeys) {
                for (int i = 0; i < numOfKeys - 1; i++) {
                    dq.append(supportedForm.getTableSupported().getAttribute(keysIndex[i]));
                    dq.append(" = ? ");
                    dq.append("AND ");
                }
                dq.append(supportedForm.getTableSupported().getAttribute(keysIndex[keysIndex.length - 1]));
                dq.append(" = ? ");
                dq.append("AND entry_date between to_date(" + "'" + beginDate + "'" + ",'DD-MM-YY') and to_date(" + "'" + endDate + "'" + ",'DD-MM-YY') and resp= " + "'" + resp + "'");
                dq.append(" ORDER BY ");
                dq.append(supportedForm.getTableSupported().getAttribute(orderIndex));
                dq.append(" DESC");
                theQuery = dq.toString();
            }
        }

        if (supportedForm == null) {

            initSupportedForm();
        }
        logger.info("the query " + theQuery);

        // finally do the query
        if (keysIndex.length == keysValue.length) {
            if (keysIndex.length == numOfKeys) {
                for (int i = 0; i < numOfKeys; i++) {
                    SQLparams.add(new StringValue(keysValue[i]));
                }
            }
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;
    }

    public Vector getComplaintsWithoutDate(int numOfKeys, String[] keysValue, String[] keysIndex, String orderIndex, String resp, Integer within, java.sql.Date fromDate, java.sql.Date toDate) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;
        String theQuery = "";
        StringBuffer dq = new StringBuffer("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");

        if (keysIndex.length == keysValue.length) {
            if (keysIndex.length == numOfKeys) {
                for (int i = 0; i < numOfKeys - 1; i++) {
                    dq.append(supportedForm.getTableSupported().getAttribute(keysIndex[i]));
                    dq.append(" = ? ");
                    dq.append("AND ");
                }
                dq.append(supportedForm.getTableSupported().getAttribute(keysIndex[keysIndex.length - 1]));
                dq.append(" = ? ");
                dq.append("and resp= " + "'" + resp + "'");
                if (within != null) {
                    dq.append("  and entry_date between SYSDATE - ").append(within).append("/24 and SYSDATE ");
                } else if (fromDate != null && toDate != null) {
                    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-YYYY");
                    dq.append("  and trunc(entry_date) between to_date('").append(sdf.format(fromDate)).append("', 'DD-MM-YYYY')").append(" and ")
                            .append("to_date('").append(sdf.format(toDate)).append("', 'DD-MM-YYYY')");
                }
                dq.append(" ORDER BY ");
                dq.append(supportedForm.getTableSupported().getAttribute(orderIndex));
                dq.append(" DESC");
                theQuery = dq.toString();
            }
        }

        if (supportedForm == null) {

            initSupportedForm();
        }
        logger.info("the query " + theQuery);

        // finally do the query
        if (keysIndex.length == keysValue.length) {
            if (keysIndex.length == numOfKeys) {
                for (int i = 0; i < numOfKeys; i++) {
                    SQLparams.add(new StringValue(keysValue[i]));
                }
            }
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
            if (r.getString("client_phone") != null) {
                wbo.setAttribute("phone", r.getString("client_phone"));
            }
            } catch(Exception ex){}
            try {
            if (r.getString("client_mobile") != null) {
                wbo.setAttribute("mobile", r.getString("client_mobile"));
            }
            } catch(Exception ex){}
            try {
            if (r.getString("client_other") != null) {
                wbo.setAttribute("other", r.getString("client_other"));
            }
            } catch(Exception ex){}
            reultBusObjs.add(wbo);
        }

        return reultBusObjs;
    }

    public Vector getComplaintsWithEntryDate2(int numOfKeys, String[] keysValue, String[] keysIndex, String orderIndex, String beginDate, String endDate, String resp) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;
        String theQuery = "";
        StringBuffer dq = new StringBuffer("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");

        if (keysIndex.length == keysValue.length) {
            if (keysIndex.length == numOfKeys) {
                for (int i = 0; i < numOfKeys - 2; i++) {
                    dq.append(supportedForm.getTableSupported().getAttribute(keysIndex[i]));
                    dq.append(" = ? ");
                    dq.append("AND ");
                }
                dq.append("( ");
                dq.append(supportedForm.getTableSupported().getAttribute(keysIndex[keysIndex.length - 2]));
                dq.append(" = ? or ");
                dq.append(supportedForm.getTableSupported().getAttribute(keysIndex[keysIndex.length - 2]));
                dq.append(" =? ) ");
                dq.append("AND entry_date between to_date(" + "'" + beginDate + "'" + ",'DD-MM-YY') and to_date(" + "'" + endDate + "'" + ",'DD-MM-YY') and resp= " + "'" + resp + "'");
                dq.append(" ORDER BY ");
                dq.append(supportedForm.getTableSupported().getAttribute(orderIndex));
                dq.append(" DESC");
                theQuery = dq.toString();
            }
        }

        if (supportedForm == null) {

            initSupportedForm();
        }
        logger.info("the query " + theQuery);

        // finally do the query
        if (keysIndex.length == keysValue.length) {
            if (keysIndex.length == numOfKeys) {
                for (int i = 0; i < numOfKeys; i++) {
                    SQLparams.add(new StringValue(keysValue[i]));
                }
            }
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;
    }

      public Vector getComplaintsForClient (int numOfKeys, String[] keysValue, String[] keysIndex, String orderIndex, String resp, String CustomerId) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        String theQuery = "";
        StringBuilder dq = new StringBuilder("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");

        if (keysIndex.length == keysValue.length) {
            if (keysIndex.length == numOfKeys) {
                for (int i = 0; i < numOfKeys - 2; i++) {
                    dq.append(supportedForm.getTableSupported().getAttribute(keysIndex[i]));
                    dq.append(" = ? ");
                    dq.append("AND ");
                }
                dq.append("( ");
                dq.append(supportedForm.getTableSupported().getAttribute(keysIndex[keysIndex.length - 2]));
                dq.append(" = ? or ");
                dq.append(supportedForm.getTableSupported().getAttribute(keysIndex[keysIndex.length - 2]));
                dq.append(" =? ) ");
                dq.append(" and resp= '").append(resp).append("'");
                dq.append(" and CUSTOMER_ID= '").append(CustomerId).append("'");
             
                dq.append(" ORDER BY ");
                dq.append(supportedForm.getTableSupported().getAttribute(orderIndex));
                dq.append(" DESC");
                theQuery = dq.toString();
            }
        }

        if (supportedForm == null) {

            initSupportedForm();
        }
        logger.info("the query " + theQuery);

        // finally do the query
        if (keysIndex.length == keysValue.length) {
            if (keysIndex.length == numOfKeys) {
                for (int i = 0; i < numOfKeys; i++) {
                    SQLparams.add(new StringValue(keysValue[i]));
                }
            }
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;
    }

    
    public Vector getComplaintsWithoutDate2(int numOfKeys, String[] keysValue, String[] keysIndex, String orderIndex, String resp, Integer within, java.sql.Date fromDate, java.sql.Date toDate) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        String theQuery = "";
        StringBuilder dq = new StringBuilder("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");

        if (keysIndex.length == keysValue.length) {
            if (keysIndex.length == numOfKeys) {
                for (int i = 0; i < numOfKeys - 2; i++) {
                    dq.append(supportedForm.getTableSupported().getAttribute(keysIndex[i]));
                    dq.append(" = ? ");
                    dq.append("AND ");
                }
                dq.append("( ");
                dq.append(supportedForm.getTableSupported().getAttribute(keysIndex[keysIndex.length - 2]));
                dq.append(" = ? or ");
                dq.append(supportedForm.getTableSupported().getAttribute(keysIndex[keysIndex.length - 2]));
                dq.append(" =? ) ");
                dq.append(" and resp= '").append(resp).append("'");
                if (within != null) {
                    dq.append("  and entry_date between SYSDATE - ").append(within).append("/24 and SYSDATE ");
                } else if (fromDate != null && toDate != null) {
                    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-YYYY");
                    dq.append("  and trunc(entry_date) between to_date('").append(sdf.format(fromDate)).append("', 'DD-MM-YYYY')").append(" and ")
                            .append("to_date('").append(sdf.format(toDate)).append("', 'DD-MM-YYYY')");
                }
                dq.append(" ORDER BY ");
                dq.append(supportedForm.getTableSupported().getAttribute(orderIndex));
                dq.append(" DESC");
                theQuery = dq.toString();
            }
        }

        if (supportedForm == null) {

            initSupportedForm();
        }
        logger.info("the query " + theQuery);

        // finally do the query
        if (keysIndex.length == keysValue.length) {
            if (keysIndex.length == numOfKeys) {
                for (int i = 0; i < numOfKeys; i++) {
                    SQLparams.add(new StringValue(keysValue[i]));
                }
            }
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;
    }

    public Vector getOnArbitraryNumberKeyOrdered(int numOfKeys, String[] keysValue, String[] keysIndex, String orderIndex) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;
        String theQuery = "";
        StringBuffer dq = new StringBuffer("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");

        if (keysIndex.length == keysValue.length) {
            if (keysIndex.length == numOfKeys) {
                for (int i = 0; i < numOfKeys - 1; i++) {
                    dq.append(supportedForm.getTableSupported().getAttribute(keysIndex[i]));
                    dq.append(" = ? ");
                    dq.append("AND ");
                }
                dq.append(supportedForm.getTableSupported().getAttribute(keysIndex[keysIndex.length - 1]));
                dq.append(" = ? ");
                dq.append(" ORDER BY ");
                dq.append(supportedForm.getTableSupported().getAttribute(orderIndex));
                theQuery = dq.toString();
            }
        }

        if (supportedForm == null) {

            initSupportedForm();
        }
        logger.info("the query " + theQuery);

        // finally do the query
        if (keysIndex.length == keysValue.length) {
            if (keysIndex.length == numOfKeys) {
                for (int i = 0; i < numOfKeys; i++) {
                    SQLparams.add(new StringValue(keysValue[i]));
                }
            }
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;

    }
    /////////get closed complaint

    public Vector getOnArbitraryNumberKeyOrdered2(int numOfKeys, String[] keysValue, String[] keysIndex, String orderIndex) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;
        String theQuery = "";
        StringBuffer dq = new StringBuffer("SELECT  * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");

        if (keysIndex.length == keysValue.length) {
            if (keysIndex.length == numOfKeys) {
//                for (int i = 0; i < numOfKeys - 1; i++) {
//                    dq.append(supportedForm.getTableSupported().getAttribute(keysIndex[i]));
//                    dq.append(" = ? ");
//                    dq.append("AND ");
//                }
                dq.append(supportedForm.getTableSupported().getAttribute(keysIndex[keysIndex.length - 1]));
                dq.append(" = ? ");
                dq.append(" ORDER BY ");
                dq.append(supportedForm.getTableSupported().getAttribute(orderIndex));
                theQuery = dq.toString();
            }
        }

        if (supportedForm == null) {

            initSupportedForm();
        }
        logger.info("the query " + theQuery);

        // finally do the query
        if (keysIndex.length == keysValue.length) {
            if (keysIndex.length == numOfKeys) {
//                for (int i = 0; i < numOfKeys; i++) {
                SQLparams.add(new StringValue("7"));
//                }
            }
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;

    }

    /**
     * ************End***********************
     */
    public Vector getOnArbitraryDoubleKeyOracle(String key1Value, String key1Index, String key2Value, String key2Index) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;

        StringBuffer dq = new StringBuffer("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");
        dq.append(supportedForm.getTableSupported().getAttribute(key1Index));
        if (key1Value == null) {
            dq.append(" is null ");
        } else {
            dq.append(" = ? ");
        }
        dq.append("AND ");
        dq.append(supportedForm.getTableSupported().getAttribute(key2Index));
        if (key2Value == null) {
            dq.append(" is null ");
        } else {
            dq.append(" = ? ");
        }
        String theQuery = dq.toString();

        if (supportedForm == null) {

            initSupportedForm();
        }
        logger.info("the query " + theQuery);

        // finally do the query
        if (key1Value != null) {
            SQLparams.add(new StringValue(key1Value));
        }

        if (key2Value != null) {
            SQLparams.add(new StringValue(key2Value));
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;

    }

    public int getCount() {

        Connection connection = null;
        int count = 0;

        StringBuffer query = new StringBuffer("SELECT count(*) FROM ");
        query.append(supportedForm.getTableSupported().getAttribute("name"));
        logger.info("the query " + query.toString());
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());

            queryResult = forQuery.executeQuery();

            Row r = null;
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                count = r.getInt(1);
            }

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return -1;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return -1;
        } catch (NoSuchColumnException nosuch) {
            logger.error("***** " + nosuch.getMessage());
            return -1;
        } catch (UnsupportedConversionException uscex) {
            logger.error("***** " + uscex.getMessage());
            return -1;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return -1;
            }
        }

        return count;

    }

    public abstract ArrayList getCashedTableAsArrayList();

    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }

        return cashedData;
    }

    protected java.sql.Timestamp extractDateFromRequest() {
        DictionaryItem tsItem = null;
        String[] timeStamp = new String[6];
        String month = (String) theRequest.getParameter("month");
        month = new String(DateAndTimeConstants.getMonthAsNumberString(month));

        timeStamp[0] = new String((String) theRequest.getParameter("year"));
        timeStamp[1] = new String(month);
        timeStamp[2] = new String((String) theRequest.getParameter("day"));
        timeStamp[3] = new String("00");
        timeStamp[4] = new String("00");
        timeStamp[5] = new String("00");

        return TimeServices.toTimestamp(timeStamp);
    }

    public void printCashedTable() {

        WebBusinessObject wbo = null;
        Enumeration e = cashedTable.elements();

        while (e.hasMoreElements()) {
            wbo = (WebBusinessObject) e.nextElement();
            wbo.printSelf();
        }

    }

    public WebBusinessObject getObjectFromCash(String key) {

        WebBusinessObject table = supportedForm.getTableSupported();
        String objectKey = (String) table.getAttribute("ObjectKey");
        String currentKey = null;

        WebBusinessObject wbo = null;
        Enumeration e = cashedTable.elements();

        while (e.hasMoreElements()) {
            wbo = (WebBusinessObject) e.nextElement();

            currentKey = (String) wbo.getAttribute(objectKey);

            if (currentKey.equalsIgnoreCase(key)) {
                return wbo;

            }
        }

        return wbo;
    }

    public WebBusinessObject getIt(String s) {

        return null;

    }

    public int deleteOnArbitraryKey(String keyValue, String keyIndex) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;

        StringBuffer dq = new StringBuffer("DELETE FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");
        dq.append(supportedForm.getTableSupported().getAttribute(keyIndex));
        dq.append(" = ? ");
        String theQuery = dq.toString();

        if (supportedForm == null) {

            initSupportedForm();
        }

        logger.info("the query " + theQuery);
        // finally do the query
        SQLparams.add(new StringValue(keyValue));

        int result = 0;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            result = forQuery.executeUpdate();

        } catch (SQLException se) {
            throw se;
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        return result;

    }

    public int deleteOnArbitraryDoubleKey(String key1Value, String key1Index, String key2Value, String key2Index) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;

        StringBuffer dq = new StringBuffer("DELETE FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");
        dq.append(supportedForm.getTableSupported().getAttribute(key1Index));
        dq.append(" = ? ");
        dq.append(" AND ");
        dq.append(supportedForm.getTableSupported().getAttribute(key2Index));
        dq.append(" = ? ");
        String theQuery = dq.toString();

        if (supportedForm == null) {

            initSupportedForm();
        }

        logger.info("the query " + theQuery);
        // finally do the query
        SQLparams.add(new StringValue(key1Value));
        SQLparams.add(new StringValue(key2Value));

        int result = 0;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            result = forQuery.executeUpdate();

        } catch (SQLException se) {
            throw se;
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        return result;

    }

    protected java.sql.Timestamp extractFromDateFromRequest() {
        DictionaryItem tsItem = null;
        String[] timeStamp = new String[6];
        String month = (String) theRequest.getParameter("beginMonth");
        month = new String(DateAndTimeConstants.getMonthAsNumberString(month));

        timeStamp[0] = new String((String) theRequest.getParameter("beginYear"));
        timeStamp[1] = new String(month);
        timeStamp[2] = new String((String) theRequest.getParameter("beginDay"));
        timeStamp[3] = new String("00");
        timeStamp[4] = new String("00");
        timeStamp[5] = new String("00");

        return TimeServices.toTimestamp(timeStamp);
    }

    protected java.sql.Timestamp extractToDateFromRequest() {
        DictionaryItem tsItem = null;
        String[] timeStamp = new String[6];
        String month = (String) theRequest.getParameter("endMonth");
        month = new String(DateAndTimeConstants.getMonthAsNumberString(month));

        timeStamp[0] = new String((String) theRequest.getParameter("endYear"));
        timeStamp[1] = new String(month);
        timeStamp[2] = new String((String) theRequest.getParameter("endDay"));
        timeStamp[3] = new String("00");
        timeStamp[4] = new String("00");
        timeStamp[5] = new String("00");

        return TimeServices.toTimestamp(timeStamp);
    }

    public boolean getDoubleName(String keyname) throws Exception {

        Connection connection = null;

        StringBuffer query = new StringBuffer("SELECT * FROM ");
        query.append(supportedForm.getTableSupported().getAttribute("name"));
        query.append(" WHERE ");
        query.append(supportedForm.getTableSupported().getAttribute("keyname"));
        query.append(" = ?");

        logger.info("del query " + query);

        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(keyname));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return false;
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

    public boolean getDoubleName(String value, String keyname) throws Exception {

        Connection connection = null;

        StringBuffer query = new StringBuffer("SELECT * FROM ");
        query.append(supportedForm.getTableSupported().getAttribute("name"));
        query.append(" WHERE ");
        query.append(supportedForm.getTableSupported().getAttribute(keyname));
        query.append(" = ?");

        logger.info("del query " + query);

        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(value));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return false;
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

    public boolean getDoubleNameEquip(String keyname) throws Exception {

        Connection connection = null;

        StringBuffer query = new StringBuffer("SELECT * FROM ");
        query.append(supportedForm.getTableSupported().getAttribute("name"));
        query.append(" WHERE ");
        query.append(supportedForm.getTableSupported().getAttribute("keyname"));
        query.append(" = ? and ");
        query.append(supportedForm.getTableSupported().getAttribute("key5"));
        query.append(" = '0'");

        logger.info("del query " + query);

        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(keyname));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return false;
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

    public boolean getDoubleNameforUpdate(String key, String keyname) throws Exception {

        Connection connection = null;

        StringBuffer query = new StringBuffer("SELECT * FROM ");
        query.append(supportedForm.getTableSupported().getAttribute("name"));
        query.append(" WHERE ");
        query.append(supportedForm.getTableSupported().getAttribute("key"));
        query.append(" != ? and ");
        query.append(supportedForm.getTableSupported().getAttribute("keyname"));
        query.append(" = ?");

        logger.info("del query " + query);

        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(key));
        SQLparams.addElement(new StringValue(keyname));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return false;
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

    protected Vector setParameter(Vector parameters, Object value) throws Exception {
        if (value instanceof String) {
            parameters.add(new StringValue((String) value));
        } else if (value instanceof java.sql.Date) {
            parameters.add(new DateValue((java.sql.Date) value));
        } else if (value instanceof Double) {
            parameters.add(new DoubleValue((Double) value));
        } else if (value instanceof Float) {
            parameters.add(new FloatValue((Float) value));
        } else if (value instanceof Integer) {
            parameters.add(new IntValue((Integer) value));
        } else if (value instanceof Long) {
            parameters.add(new LongValue((Long) value));
        } else if (value instanceof Short) {
            parameters.add(new ShortValue((Short) value));
        } else if (value instanceof BigDecimal) {
            parameters.add((BigDecimal) value);
        } else if (value instanceof Boolean) {
            parameters.add(new BooleanValue((Boolean) value));
        } else if (value instanceof Byte) {
            parameters.add(new ByteValue((Byte) value));
        } else if (value instanceof Byte[]) {
            parameters.add(new BytesValue((byte[]) value));
        } else if (value instanceof Time) {
            parameters.add(new TimeValue((Time) value));
        } else if (value instanceof Timestamp) {
            parameters.add(new TimestampValue((Timestamp) value));
        } else if (value instanceof java.util.Date) {
            parameters.add(new TimestampValue(new Timestamp(((java.util.Date) value).getTime())));
        } else if (value instanceof File) {
            parameters.add(new ImageValue(((File) value)));
        } else {
            parameters.add(new ObjectValue(value));
        }

        return parameters;
    }

    protected Collection<Row> listAsRows(String queryName, Vector<Object> parameters) throws Exception {
        return listAsRows(queryName, parameters, dataSource.getConnection());
    }

    protected Collection<Row> listAsRows(String queryName, Vector<Object> parameters, Connection connection) throws Exception {
        SQLCommandBean command = new SQLCommandBean();
        String queryString;

        try {
            //queryString = sqlMgr.getSql(queryName);
            queryString = queryName;
        } catch (Exception ex) {
            queryString = queryName;
        }

        try {
            command.setConnection(connection);
            command.setSQLQuery(queryString.trim());
            command.setparams(parameters);

            return command.executeQuery();
        } catch (SQLException sql) {
            throw sql;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                throw ex;
            }
        }
    }

    public List<WebBusinessObject> paginationEntity(Filter filter) throws Exception {
        Vector parameters = new Vector();

        StringBuilder builder = new StringBuilder("SELECT * FROM (");
        builder.append("SELECT ");
        builder.append(supportedForm.getTableSupported().getAttribute("name").toString().toUpperCase());
        builder.append(".*, ROWNUM AS INDCIES FROM ");
        builder.append(supportedForm.getTableSupported().getAttribute("name").toString().toUpperCase());
        builder.append(" WHERE ");

        Vector countParameters = new Vector();
        StringBuilder builderCountAll = new StringBuilder("SELECT COUNT(*) AS NUMBER_ROWS FROM ");
        builderCountAll.append(supportedForm.getTableSupported().getAttribute("name").toString().toUpperCase());
        builderCountAll.append(" WHERE ");

        int countCodition = 0;
        for (FilterCondition condition : filter.getConditions()) {

            if (countCodition > 0) {
                builder.append(" AND ");
                builderCountAll.append(" AND ");
            }
            if (condition.getOperation() != Operations.IS_NULL
                    && condition.getOperation() != Operations.IS_NOT_NULL
                    && condition.getOperation() != Operations.END_WITH
                    && condition.getOperation() != Operations.START_WITH
                    && condition.getOperation() != Operations.LIKE
                    && condition.getOperation() != Operations.CONTAIN
                    && condition.getOperation() != Operations.IN
                    && condition.getOperation() != Operations.NOTIN) {

                builder.append(condition.getFieldName()).append(" ");
                builder.append(condition.getOperation().getOperation()).append(" '");
                builder.append(condition.getValue()).append("' ");
                //parameters = setParameter(parameters, condition.getValue());

                builderCountAll.append(condition.getFieldName()).append(" ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" '");
                builderCountAll.append(condition.getValue()).append("' ");
                //countParameters = setParameter(countParameters, condition.getValue());

            } else if (condition.getOperation() == Operations.IS_NULL) {
                builder.append(condition.getFieldName()).append(" ");
                builder.append(condition.getOperation().getOperation()).append(" ");

                builderCountAll.append(condition.getFieldName()).append(" ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" ");

            } else if (condition.getOperation() == Operations.IS_NOT_NULL) {
                builder.append(condition.getFieldName()).append(" ");
                builder.append(condition.getOperation().getOperation()).append(" ");

                builderCountAll.append(condition.getFieldName()).append(" ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" ");

            } else if (condition.getOperation() == Operations.END_WITH) {
                builder.append("LOWER(");
                builder.append(condition.getFieldName()).append(") ");
                builder.append(condition.getOperation().getOperation()).append(" '%");
                builder.append(condition.getValue()).append("'");

                builderCountAll.append("LOWER(");
                builderCountAll.append(condition.getFieldName()).append(") ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" LOWER('%");
                builderCountAll.append(condition.getValue()).append("')");

            } else if (condition.getOperation() == Operations.START_WITH) {
                builder.append("LOWER(");
                builder.append(condition.getFieldName()).append(") ");
                builder.append(condition.getOperation().getOperation()).append(" LOWER('");
                builder.append(condition.getValue()).append("%')");

                builderCountAll.append("LOWER(");
                builderCountAll.append(condition.getFieldName()).append(") ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" LOWER('");
                builderCountAll.append(condition.getValue()).append("%')");

            } else if (condition.getOperation() == Operations.LIKE) {
                builder.append("LOWER(");
                builder.append(condition.getFieldName()).append(") ");
                builder.append(condition.getOperation().getOperation()).append(" LOWER('%");
                builder.append(condition.getValue()).append("%')");

                builderCountAll.append("LOWER(");
                builderCountAll.append(condition.getFieldName()).append(") ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" LOWER('%");
                builderCountAll.append(condition.getValue()).append("%')");

            } else if (condition.getOperation() == Operations.CONTAIN) {
                builder.append("LOWER(");
                builder.append(condition.getFieldName()).append(") ");
                builder.append(condition.getOperation().getOperation()).append(" LOWER('%");
                builder.append(condition.getValue()).append("%')");

                builderCountAll.append("LOWER(");
                builderCountAll.append(condition.getFieldName()).append(") ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" LOWER('%");
                builderCountAll.append(condition.getValue()).append("%')");

            } else if (condition.getOperation() == Operations.IN) {
                builder.append(condition.getFieldName()).append(" ");
                builder.append(condition.getOperation().getOperation()).append(" (");
                builder.append(condition.getValue()).append(")");

                builderCountAll.append("");
                builderCountAll.append(condition.getFieldName()).append(" ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" (");
                builderCountAll.append(condition.getValue()).append(")");

            } else if (condition.getOperation() == Operations.NOTIN) {
                builder.append(condition.getFieldName()).append(" ");
                builder.append(condition.getOperation().getOperation()).append(" (");
                builder.append(condition.getValue()).append(")");

                builderCountAll.append("");
                builderCountAll.append(condition.getFieldName()).append(" ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" (");
                builderCountAll.append(condition.getValue()).append(")");

            }
            countCodition++;
        }

        builder.append(") WHERE INDCIES BETWEEN ? AND ?");
        parameters = setParameter(parameters, filter.getStartIndex());
        parameters = setParameter(parameters, filter.getEndIndex());

        String query = builder.toString();
        String queryCountAll = builderCountAll.toString();

        Collection<Row> rowsCount = listAsRows(queryCountAll, countParameters);

        for (Row row : rowsCount) {
            try {
                String stringCount = row.getString("NUMBER_ROWS");
                Long longCount = new Long(stringCount);
                filter.setCountResult(longCount.longValue());
            } catch (Exception ex) {
                System.out.println(ex);
            }
        }

        Collection<Row> rows = listAsRows(query, parameters);
        List<WebBusinessObject> result = new ArrayList<WebBusinessObject>(0);
        WebBusinessObject wbo;

        for (Row row : rows) {
            wbo = fabricateBusObj(row);
            try {
                wbo.setAttribute("index", wbo.getAttribute("INDCIES"));
            } catch (Exception ex) {
                System.out.println(ex);
            }

            result.add(wbo);
        }

        return result;
    }

    public List<WebBusinessObject> paginationEntityByOR2(Filter filter, String joinStr) throws Exception {
        Vector parameters = new Vector();

        StringBuilder builder = new StringBuilder("SELECT distinct(user_id), USER_Name, PASSWORD, USER_HOME, EMAIL, FULL_NAME, IS_SUPER_USER,CREATION_TIME FROM (");
        builder.append("SELECT u.*");
        builder.append(", ROWNUM AS INDCIES FROM USERS u, complaint_employee ce");
        builder.append("" + joinStr);
        // builder.append(" WHERE ");

        Vector countParameters = new Vector();
        StringBuilder builderCountAll = new StringBuilder("SELECT COUNT(*) AS NUMBER_ROWS FROM users u, complaint_employee ce");
        builderCountAll.append(" " + joinStr);
        // builderCountAll.append(" WHERE ");

        int countCodition = 0;
        for (FilterCondition condition : filter.getConditions()) {

            if (countCodition > 0) {
                builder.append(" OR ");
                builderCountAll.append(" OR ");
            }
            if (condition.getOperation() != Operations.IS_NULL
                    && condition.getOperation() != Operations.END_WITH
                    && condition.getOperation() != Operations.START_WITH
                    && condition.getOperation() != Operations.LIKE
                    && condition.getOperation() != Operations.CONTAIN
                    && condition.getOperation() != Operations.IN) {
                builder.append(" WHERE ");
                builder.append(condition.getFieldName()).append(" ");
                builder.append(condition.getOperation().getOperation()).append(" ");
                builder.append(condition.getValue()).append(" ");
                //parameters = setParameter(parameters, condition.getValue());
                builderCountAll.append(" WHERE ");
                builderCountAll.append(condition.getFieldName()).append(" ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" ");
                builderCountAll.append(condition.getValue()).append(" ");
                //countParameters = setParameter(countParameters, condition.getValue());

            } else if (condition.getOperation() == Operations.IS_NULL) {
                builder.append(" WHERE ");
                builder.append(condition.getFieldName()).append(" ");
                builder.append(condition.getOperation().getOperation()).append(" ");
                builderCountAll.append(" WHERE ");
                builderCountAll.append(condition.getFieldName()).append(" ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" ");

            } else if (condition.getOperation() == Operations.END_WITH) {
                builder.append(" WHERE ");
                builder.append("LOWER(");
                builder.append(condition.getFieldName()).append(") ");
                builder.append(condition.getOperation().getOperation()).append(" '%");
                builder.append(condition.getValue()).append("'");
                builderCountAll.append(" WHERE ");
                builderCountAll.append("LOWER(");
                builderCountAll.append(condition.getFieldName()).append(") ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" LOWER('%");
                builderCountAll.append(condition.getValue()).append("')");

            } else if (condition.getOperation() == Operations.START_WITH) {
                builder.append(" WHERE ");
                builder.append("LOWER(");
                builder.append(condition.getFieldName()).append(") ");
                builder.append(condition.getOperation().getOperation()).append(" LOWER('");
                builder.append(condition.getValue()).append("%')");
                builderCountAll.append(" WHERE ");
                builderCountAll.append("LOWER(");
                builderCountAll.append(condition.getFieldName()).append(") ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" LOWER('");
                builderCountAll.append(condition.getValue()).append("%')");

            } else if (condition.getOperation() == Operations.LIKE) {
                builder.append(" WHERE ");
                builder.append("LOWER(");
                builder.append(condition.getFieldName()).append(") ");
                builder.append(condition.getOperation().getOperation()).append(" LOWER('%");
                builder.append(condition.getValue()).append("%')");
                builderCountAll.append(" WHERE ");
                builderCountAll.append("LOWER(");
                builderCountAll.append(condition.getFieldName()).append(") ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" LOWER('%");
                builderCountAll.append(condition.getValue()).append("%')");

            } else if (condition.getOperation() == Operations.CONTAIN) {
                builder.append(" WHERE ");
                builder.append("LOWER(");
                builder.append(condition.getFieldName()).append(") ");
                builder.append(condition.getOperation().getOperation()).append(" LOWER('%");
                builder.append(condition.getValue()).append("%')");
                builderCountAll.append(" WHERE ");
                builderCountAll.append("LOWER(");
                builderCountAll.append(condition.getFieldName()).append(") ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" LOWER('%");
                builderCountAll.append(condition.getValue()).append("%')");

            } else if (condition.getOperation() == Operations.IN) {
                builder.append(" WHERE ");
                builder.append(condition.getFieldName()).append(" ");
                builder.append(condition.getOperation().getOperation()).append(" (");
                builder.append(condition.getValue()).append(")");
                builderCountAll.append(" WHERE ");
                builderCountAll.append("");
                builderCountAll.append(condition.getFieldName()).append(" ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" (");
                builderCountAll.append(condition.getValue()).append(")");

            }
            countCodition++;
        }

        builder.append(") WHERE INDCIES BETWEEN ? AND ?");
        parameters = setParameter(parameters, filter.getStartIndex());
        parameters = setParameter(parameters, filter.getEndIndex());

        String query = builder.toString();
        String queryCountAll = builderCountAll.toString();

        Collection<Row> rowsCount = listAsRows(queryCountAll, countParameters);

        for (Row row : rowsCount) {
            try {
                String stringCount = row.getString("NUMBER_ROWS");
                Long longCount = new Long(stringCount);
                filter.setCountResult(longCount.longValue());
            } catch (Exception ex) {
                System.out.println(ex);
            }
        }

        Collection<Row> rows = listAsRows(query, parameters);
        List<WebBusinessObject> result = new ArrayList<WebBusinessObject>(0);
        WebBusinessObject wbo;

        for (Row row : rows) {
            wbo = fabricateBusObj(row);
            try {
                wbo.setAttribute("index", wbo.getAttribute("INDCIES"));
            } catch (Exception ex) {
                System.out.println(ex);
            }

            result.add(wbo);
        }

        return result;
    }

    public List<WebBusinessObject> paginationEntityByOR(Filter filter, String joinStr) throws Exception {
        Vector parameters = new Vector();

        StringBuilder builder = new StringBuilder("SELECT * FROM (");
        builder.append("SELECT ");
        builder.append(supportedForm.getTableSupported().getAttribute("name").toString().toUpperCase());
        builder.append(".*, ROWNUM AS INDCIES FROM ");
        builder.append(supportedForm.getTableSupported().getAttribute("name").toString().toUpperCase());
        builder.append("" + joinStr);
        // builder.append(" WHERE ");

        Vector countParameters = new Vector();
        StringBuilder builderCountAll = new StringBuilder("SELECT COUNT(*) AS NUMBER_ROWS FROM ");
        builderCountAll.append(supportedForm.getTableSupported().getAttribute("name").toString().toUpperCase());
        builderCountAll.append(" " + joinStr);
        // builderCountAll.append(" WHERE ");

        int countCodition = 0;
        for (FilterCondition condition : filter.getConditions()) {

            if (countCodition > 0) {
                builder.append(" OR ");
                builderCountAll.append(" OR ");
            }
            if (condition.getOperation() != Operations.IS_NULL
                    && condition.getOperation() != Operations.END_WITH
                    && condition.getOperation() != Operations.START_WITH
                    && condition.getOperation() != Operations.LIKE
                    && condition.getOperation() != Operations.CONTAIN
                    && condition.getOperation() != Operations.IN) {
                builder.append(" WHERE ");
                builder.append(condition.getFieldName()).append(" ");
                builder.append(condition.getOperation().getOperation()).append(" '");
                builder.append(condition.getValue()).append("' ");
                //parameters = setParameter(parameters, condition.getValue());
                builderCountAll.append(" WHERE ");
                builderCountAll.append(condition.getFieldName()).append(" ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" '");
                builderCountAll.append(condition.getValue()).append("' ");
                //countParameters = setParameter(countParameters, condition.getValue());

            } else if (condition.getOperation() == Operations.IS_NULL) {
                builder.append(" WHERE ");
                builder.append(condition.getFieldName()).append(" ");
                builder.append(condition.getOperation().getOperation()).append(" ");
                builderCountAll.append(" WHERE ");
                builderCountAll.append(condition.getFieldName()).append(" ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" ");

            } else if (condition.getOperation() == Operations.END_WITH) {
                builder.append(" WHERE ");
                builder.append("LOWER(");
                builder.append(condition.getFieldName()).append(") ");
                builder.append(condition.getOperation().getOperation()).append(" '%");
                builder.append(condition.getValue()).append("'");
                builderCountAll.append(" WHERE ");
                builderCountAll.append("LOWER(");
                builderCountAll.append(condition.getFieldName()).append(") ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" LOWER('%");
                builderCountAll.append(condition.getValue()).append("')");

            } else if (condition.getOperation() == Operations.START_WITH) {
                builder.append(" WHERE ");
                builder.append("LOWER(");
                builder.append(condition.getFieldName()).append(") ");
                builder.append(condition.getOperation().getOperation()).append(" LOWER('");
                builder.append(condition.getValue()).append("%')");
                builderCountAll.append(" WHERE ");
                builderCountAll.append("LOWER(");
                builderCountAll.append(condition.getFieldName()).append(") ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" LOWER('");
                builderCountAll.append(condition.getValue()).append("%')");

            } else if (condition.getOperation() == Operations.LIKE) {
                builder.append(" WHERE ");
                builder.append("LOWER(");
                builder.append(condition.getFieldName()).append(") ");
                builder.append(condition.getOperation().getOperation()).append(" LOWER('%");
                builder.append(condition.getValue()).append("%')");
                builderCountAll.append(" WHERE ");
                builderCountAll.append("LOWER(");
                builderCountAll.append(condition.getFieldName()).append(") ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" LOWER('%");
                builderCountAll.append(condition.getValue()).append("%')");

            } else if (condition.getOperation() == Operations.CONTAIN) {
                builder.append(" WHERE ");
                builder.append("LOWER(");
                builder.append(condition.getFieldName()).append(") ");
                builder.append(condition.getOperation().getOperation()).append(" LOWER('%");
                builder.append(condition.getValue()).append("%')");
                builderCountAll.append(" WHERE ");
                builderCountAll.append("LOWER(");
                builderCountAll.append(condition.getFieldName()).append(") ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" LOWER('%");
                builderCountAll.append(condition.getValue()).append("%')");

            } else if (condition.getOperation() == Operations.IN) {
                builder.append(" WHERE ");
                builder.append(condition.getFieldName()).append(" ");
                builder.append(condition.getOperation().getOperation()).append(" (");
                builder.append(condition.getValue()).append(")");
                builderCountAll.append(" WHERE ");
                builderCountAll.append("");
                builderCountAll.append(condition.getFieldName()).append(" ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" (");
                builderCountAll.append(condition.getValue()).append(")");

            }
            countCodition++;
        }

        builder.append(") WHERE INDCIES BETWEEN ? AND ?");
        parameters = setParameter(parameters, filter.getStartIndex());
        parameters = setParameter(parameters, filter.getEndIndex());

        String query = builder.toString();
        String queryCountAll = builderCountAll.toString();

        Collection<Row> rowsCount = listAsRows(queryCountAll, countParameters);

        for (Row row : rowsCount) {
            try {
                String stringCount = row.getString("NUMBER_ROWS");
                Long longCount = new Long(stringCount);
                filter.setCountResult(longCount.longValue());
            } catch (Exception ex) {
                System.out.println(ex);
            }
        }

        Collection<Row> rows = listAsRows(query, parameters);
        List<WebBusinessObject> result = new ArrayList<WebBusinessObject>(0);
        WebBusinessObject wbo;

        for (Row row : rows) {
            wbo = fabricateBusObj(row);
            try {
                wbo.setAttribute("index", wbo.getAttribute("INDCIES"));
            } catch (Exception ex) {
                System.out.println(ex);
            }

            result.add(wbo);
        }

        return result;
    }

    public List<WebBusinessObject> paginationEntityByDate(Filter filter, String dateFormate) throws Exception {
        Vector parameters = new Vector();

        StringBuilder builder = new StringBuilder("SELECT * FROM (");
        builder.append("SELECT ");
        builder.append(supportedForm.getTableSupported().getAttribute("name").toString().toUpperCase());
        builder.append(".*, ROWNUM AS INDCIES FROM ");
        builder.append(supportedForm.getTableSupported().getAttribute("name").toString().toUpperCase());
        builder.append(" WHERE ");

        Vector countParameters = new Vector();
        StringBuilder builderCountAll = new StringBuilder("SELECT COUNT(*) AS NUMBER_ROWS FROM ");
        builderCountAll.append(supportedForm.getTableSupported().getAttribute("name").toString().toUpperCase());
        builderCountAll.append(" WHERE ");

        int countCodition = 0;
        for (FilterCondition condition : filter.getConditions()) {

            if (countCodition == 0) {
                builder.append("LOWER(");
                builder.append(condition.getFieldName()).append(") BETWEEN ");
                builder.append("TO_DATE('").append(condition.getValue()).append("', '").append(dateFormate).append("') AND ");

                builderCountAll.append("LOWER(");
                builderCountAll.append(condition.getFieldName()).append(") BETWEEN ");
                builderCountAll.append("TO_DATE('").append(condition.getValue()).append("', '").append(dateFormate).append("') AND ");
            } else {
                builder.append("TO_DATE('").append(condition.getValue()).append("', '").append(dateFormate).append("')");

                builderCountAll.append("TO_DATE('").append(condition.getValue()).append("', '").append(dateFormate).append("')");
            }
            countCodition++;
        }

        builder.append(") WHERE INDCIES BETWEEN ? AND ?");
        parameters = setParameter(parameters, filter.getStartIndex());
        parameters = setParameter(parameters, filter.getEndIndex());

        String query = builder.toString();
        String queryCountAll = builderCountAll.toString();

        Collection<Row> rowsCount = listAsRows(queryCountAll, countParameters);

        for (Row row : rowsCount) {
            try {
                String stringCount = row.getString("NUMBER_ROWS");
                Long longCount = new Long(stringCount);
                filter.setCountResult(longCount.longValue());
            } catch (Exception ex) {
                System.out.println(ex);
            }
        }

        Collection<Row> rows = listAsRows(query, parameters);
        List<WebBusinessObject> result = new ArrayList<WebBusinessObject>(0);
        WebBusinessObject wbo;

        for (Row row : rows) {
            wbo = fabricateBusObj(row);
            try {
                wbo.setAttribute("index", wbo.getAttribute("INDCIES"));
            } catch (Exception ex) {
                System.out.println(ex);
            }

            result.add(wbo);
        }

        return result;
    }

    protected void stramQueries() {

        if (queriesIS != null) {
            try {

                queriesProps.load(queriesIS);

                queriesMap = new HashMap<String, String>((Map) queriesProps);

                queriesSet = queriesMap.entrySet();

                // System.out.println(props.getProperty("message"));
            } catch (IOException ioex) {
                logger.error("unable to read from " + queriesPropFileName);
            }

        }

    }

    protected String getQuery(String qTag) {
        return queriesMap.get(qTag);
    }

    protected void printMyQueries() {

        for (Map.Entry<String, String> me : queriesSet) {
            System.out.print(me.getKey() + ": ");
            System.out.println(me.getValue());
        }
        return;
    }

    /**
     * **********************************************************************
     ***********************************************************************
     */
    /*public boolean deleteOnForeignKey(Object value) throws Exception {
     SQLCommandBean command = new SQLCommandBean();
     Connection connection = null;
     Vector parameters = new Vector();

     StringBuilder query = new StringBuilder("DELETE FROM ");
     query.append(supportedForm.getTableSupported().getAttribute("name"));
     query.append(" WHERE ");
     query.append(supportedForm.getTableSupported().getAttribute("foreignkey"));
     if(value == null) {
     query.append(" is null");
     } else {
     query.append(" = ?");
     parameters = setParameter(parameters, value);
     }

     try {
     connection = dataSource.getConnection();
     command.setConnection(connection);
     command.setSQLQuery(query.toString());
     command.setparams(parameters);

     command.executeUpdate();

     } catch (SQLException se) {
     logger.error("troubles closing connection " + se.getMessage());
     throw new Exception("troubles closing connection " + se.getMessage());
     } finally {
     try {
     connection.close();
     } catch (SQLException sex) {
     logger.error("troubles closing connection " + sex.getMessage());
     throw new Exception("troubles closing connection " + sex.getMessage());
     }
     }

     return true;
     }

     public boolean isDoubleName(String key, Object value) throws Exception {

     StringBuilder query = new StringBuilder("SELECT * FROM ");
     query.append(supportedForm.getTableSupported().getAttribute("name"));
     query.append(" WHERE ");
     query.append(supportedForm.getTableSupported().getAttribute(key));
     query.append(" = ?");

     Vector parameters = new Vector();

     parameters = setParameter(parameters, value);

     return !listResult(query.toString().trim(), parameters).isEmpty();
     }

     protected WebBusinessObject uniqueResult(String queryName, Vector<Object> parameters) throws Exception {
     return uniqueResult(queryName, parameters, dataSource.getConnection());
     }

     protected WebBusinessObject uniqueResult(String queryName, Vector<Object> parameters, Connection connection) throws Exception {
     List<WebBusinessObject> result = listResult(queryName, parameters, connection);
     return (!result.isEmpty()) ? result.get(0) : null;
     }

     protected List<WebBusinessObject> listResult(String queryName, Vector<Object> parameters) throws Exception {
     return listResult(queryName, parameters, dataSource.getConnection());
     }

     protected List<WebBusinessObject> listResult(String queryName, Vector<Object> parameters, Connection connection) throws Exception {
     List<WebBusinessObject> result = new ArrayList<WebBusinessObject>(0);

     SQLCommandBean command = new SQLCommandBean();
     String queryString;

     try {
     queryString = sqlMgr.getSql(queryName);
     } catch(Exception ex) {
     queryString = queryName;
     }

     try {
     command.setConnection(connection);
     command.setSQLQuery(queryString.trim());
     command.setparams(parameters);

     Vector<Row> rows = command.executeQuery();

     for (Row row : rows) {
     result.add(fabricateBusObj(row));
     }

     return result;
     } catch (SQLException sql) {
     throw sql;
     } catch (UnsupportedTypeException ex) {
     throw ex;
     } finally {
     try {
     connection.close();
     } catch (SQLException ex) {
     throw ex;
     }
     }
     }

     protected boolean executeStatement(String statement, Vector<Object> parameters) throws Exception {
     Connection connection = dataSource.getConnection();

     return executeStatement(statement, parameters, connection);
     }

     protected boolean executeStatement(String statement, Vector<Object> parameters, Connection connection) throws Exception {
     SQLCommandBean command = new SQLCommandBean();

     try {
     command.setConnection(connection);
     command.setSQLQuery(statement);
     command.setparams(parameters);

     return command.execute();
     } catch (SQLException sql) {
     throw sql;
     } catch (UnsupportedTypeException ex) {
     throw ex;
     } finally {
     try {
     connection.close();
     } catch (SQLException ex) {
     throw ex;
     }
     }
     }*/
    /**
     * **********************************************************************
     ************************************************************************
     */
    public List<WebBusinessObject> paginationEntity(Filter filter, String joinStr) throws Exception {
        Vector parameters = new Vector();

        StringBuilder builder = new StringBuilder("SELECT * FROM (");
        builder.append("SELECT ");
        builder.append(supportedForm.getTableSupported().getAttribute("name").toString().toUpperCase());
        builder.append(".*, ROWNUM AS INDCIES FROM ");
        builder.append(supportedForm.getTableSupported().getAttribute("name").toString().toUpperCase());
        builder.append("" + joinStr);
        builder.append(" WHERE ");

        Vector countParameters = new Vector();
        StringBuilder builderCountAll = new StringBuilder("SELECT COUNT(*) AS NUMBER_ROWS FROM ");
        builderCountAll.append(supportedForm.getTableSupported().getAttribute("name").toString().toUpperCase());
        builderCountAll.append(" " + joinStr);
        builderCountAll.append(" WHERE ");

        int countCodition = 0;
        for (FilterCondition condition : filter.getConditions()) {

            if (countCodition > 0) {
                builder.append(" AND ");
                builderCountAll.append(" AND ");
            }
            if (condition.getOperation() != Operations.IS_NULL
                    && condition.getOperation() != Operations.IS_NOT_NULL
                    && condition.getOperation() != Operations.END_WITH
                    && condition.getOperation() != Operations.START_WITH
                    && condition.getOperation() != Operations.LIKE
                    && condition.getOperation() != Operations.CONTAIN
                    && condition.getOperation() != Operations.IN
                    && condition.getOperation() != Operations.NOTIN) {

                builder.append(condition.getFieldName()).append(" ");
                builder.append(condition.getOperation().getOperation()).append(" '");
                builder.append(condition.getValue()).append("' ");
                //parameters = setParameter(parameters, condition.getValue());

                builderCountAll.append(condition.getFieldName()).append(" ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" '");
                builderCountAll.append(condition.getValue()).append("' ");
                //countParameters = setParameter(countParameters, condition.getValue());

            } else if (condition.getOperation() == Operations.IS_NULL) {
                builder.append(condition.getFieldName()).append(" ");
                builder.append(condition.getOperation().getOperation()).append(" ");

                builderCountAll.append(condition.getFieldName()).append(" ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" ");

            } else if (condition.getOperation() == Operations.IS_NOT_NULL) {
                builder.append(condition.getFieldName()).append(" ");
                builder.append(condition.getOperation().getOperation()).append(" ");

                builderCountAll.append(condition.getFieldName()).append(" ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" ");

            } else if (condition.getOperation() == Operations.END_WITH) {
                builder.append("LOWER(");
                builder.append(condition.getFieldName()).append(") ");
                builder.append(condition.getOperation().getOperation()).append(" '%");
                builder.append(condition.getValue()).append("'");

                builderCountAll.append("LOWER(");
                builderCountAll.append(condition.getFieldName()).append(") ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" LOWER('%");
                builderCountAll.append(condition.getValue()).append("')");

            } else if (condition.getOperation() == Operations.START_WITH) {
                builder.append("LOWER(");
                builder.append(condition.getFieldName()).append(") ");
                builder.append(condition.getOperation().getOperation()).append(" LOWER('");
                builder.append(condition.getValue()).append("%')");

                builderCountAll.append("LOWER(");
                builderCountAll.append(condition.getFieldName()).append(") ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" LOWER('");
                builderCountAll.append(condition.getValue()).append("%')");

            } else if (condition.getOperation() == Operations.LIKE) {
                builder.append("LOWER(");
                builder.append(condition.getFieldName()).append(") ");
                builder.append(condition.getOperation().getOperation()).append(" LOWER('%");
                builder.append(condition.getValue()).append("%')");

                builderCountAll.append("LOWER(");
                builderCountAll.append(condition.getFieldName()).append(") ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" LOWER('%");
                builderCountAll.append(condition.getValue()).append("%')");

            } else if (condition.getOperation() == Operations.CONTAIN) {
                builder.append("LOWER(");
                builder.append(condition.getFieldName()).append(") ");
                builder.append(condition.getOperation().getOperation()).append(" LOWER('%");
                builder.append(condition.getValue()).append("%')");

                builderCountAll.append("LOWER(");
                builderCountAll.append(condition.getFieldName()).append(") ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" LOWER('%");
                builderCountAll.append(condition.getValue()).append("%')");

            } else if (condition.getOperation() == Operations.IN) {
                builder.append(condition.getFieldName()).append(" ");
                builder.append(condition.getOperation().getOperation()).append(" (");
                builder.append(condition.getValue()).append(")");

                builderCountAll.append("");
                builderCountAll.append(condition.getFieldName()).append(" ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" (");
                builderCountAll.append(condition.getValue()).append(")");

            } else if (condition.getOperation() == Operations.NOTIN) {
                builder.append(condition.getFieldName()).append(" ");
                builder.append(condition.getOperation().getOperation()).append(" (");
                builder.append(condition.getValue()).append(")");

                builderCountAll.append("");
                builderCountAll.append(condition.getFieldName()).append(" ");
                builderCountAll.append(condition.getOperation().getOperation()).append(" (");
                builderCountAll.append(condition.getValue()).append(")");

            }
            countCodition++;
        }

        builder.append(") WHERE INDCIES BETWEEN ? AND ?");
        parameters = setParameter(parameters, filter.getStartIndex());
        parameters = setParameter(parameters, filter.getEndIndex());

        String query = builder.toString();
        String queryCountAll = builderCountAll.toString();

        Collection<Row> rowsCount = listAsRows(queryCountAll, countParameters);

        for (Row row : rowsCount) {
            try {
                String stringCount = row.getString("NUMBER_ROWS");
                Long longCount = new Long(stringCount);
                filter.setCountResult(longCount.longValue());
            } catch (Exception ex) {
                System.out.println(ex);
            }
        }

        Collection<Row> rows = listAsRows(query, parameters);
        List<WebBusinessObject> result = new ArrayList<WebBusinessObject>(0);
        WebBusinessObject wbo;

        for (Row row : rows) {
            wbo = fabricateBusObj(row);
            try {
                wbo.setAttribute("index", wbo.getAttribute("INDCIES"));
            } catch (Exception ex) {
                System.out.println(ex);
            }

            result.add(wbo);
        }

        return result;
    }

    public String getColumnDateTime(String key, String column) {
        Connection connection = null;

        StringBuffer query = new StringBuffer("SELECT TO_CHAR(");
        query.append(column);
        query.append(",'yyyy-mm-dd hh:mi:ss')");
        query.append("AS ");
        query.append("DATE_TIME FROM ");
        query.append(supportedForm.getTableSupported().getAttribute("name"));
        query.append(" WHERE ");
        query.append(supportedForm.getTableSupported().getAttribute("key"));
        query.append(" = ?");

        Vector SQLparams = new Vector();
        logger.info("the query " + query.toString());

        SQLparams.addElement(new StringValue(key));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);

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

        String value = null;
        Row row;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            try {
                value = row.getString("DATE_TIME");
            } catch (Exception ex) {
                logger.error(ex);
            }
        }

        return value;
    }

    public String getByKeyColumnValue(String keyValue, String columnKey) {
        return getByKeyColumnValue("key", keyValue, columnKey);
    }

    public String getByKeyColumnValue(String key, String keyValue, String columnKey) {
        Connection connection = null;

        StringBuilder query = new StringBuilder("SELECT ");
        query.append(supportedForm.getTableSupported().getAttribute(columnKey));
        query.append(" ");
        query.append(" FROM ");
        query.append(supportedForm.getTableSupported().getAttribute("name"));
        query.append(" WHERE ");
        query.append(supportedForm.getTableSupported().getAttribute(key));
        query.append(" = ?");

        Vector parameters = new Vector();
        logger.info("the query " + query.toString());

        parameters.addElement(new StringValue(keyValue));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(parameters);

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

        String value = null;
        Row row;
        if (!queryResult.isEmpty()) {
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                try {
                    value = row.getString((String) supportedForm.getTableSupported().getAttribute(columnKey));
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                }
            }
        }

        return value;
    }
    
    public String getByKeyColumnValueFour(String key, String keyValue, String columnKey, String columnKeyFour, String columnKeyFive) {
        Connection connection = null;

        StringBuilder query = new StringBuilder("SELECT ");
        query.append(supportedForm.getTableSupported().getAttribute(columnKey));
        query.append(" ");
        query.append(" FROM ");
        query.append(supportedForm.getTableSupported().getAttribute("name"));
        query.append(" WHERE ");
        query.append(supportedForm.getTableSupported().getAttribute(key));
        query.append(" = ?");
        query.append(" AND ");
        query.append(supportedForm.getTableSupported().getAttribute(columnKeyFour));
        query.append(" = ?");

        Vector parameters = new Vector();
        logger.info("the query " + query.toString());

        parameters.addElement(new StringValue(keyValue));
        parameters.addElement(new StringValue(columnKeyFive));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(parameters);

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

        String value = null;
        Row row;
        if (!queryResult.isEmpty()) {
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                try {
                    value = row.getString((String) supportedForm.getTableSupported().getAttribute(columnKey));
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                }
            }
        }

        return value;
    }
    
    public Timestamp getByKeyColumnTimestamp(String keyValue, String columnKey) {
        return getByKeyColumnTimestamp("key", keyValue, columnKey);
    }

    public Timestamp getByKeyColumnTimestamp(String key, String keyValue, String columnKey) {
        Connection connection = null;

        StringBuilder query = new StringBuilder("SELECT CAST(");
        query.append(supportedForm.getTableSupported().getAttribute(columnKey));
        query.append(" AS TIMESTAMP) ");
        query.append(supportedForm.getTableSupported().getAttribute(columnKey));
        query.append(" FROM ");
        query.append(supportedForm.getTableSupported().getAttribute("name"));
        query.append(" WHERE ");
        query.append(supportedForm.getTableSupported().getAttribute(key));
        query.append(" = ?");

        Vector parameters = new Vector();
        logger.info("the query " + query.toString());

        parameters.addElement(new StringValue(keyValue));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(parameters);

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

        Timestamp value = null;
        Row row;
        if (!queryResult.isEmpty()) {
            Enumeration e = queryResult.elements();

            while (e.hasMoreElements()) {
                row = (Row) e.nextElement();
                try {
                    value = row.getTimestamp((String) supportedForm.getTableSupported().getAttribute(columnKey));
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                } catch (UnsupportedConversionException ex) {
                    logger.error(ex);
                }
            }
        }

        return value;
    }

    public boolean isValueAlreadyExist(String keyValue, String keyIndex, String id) {
        Connection connection = null;

        StringBuilder query = new StringBuilder("SELECT COUNT(*) FROM ");
        query.append(supportedForm.getTableSupported().getAttribute("name"));
        query.append(" WHERE ");
        query.append(supportedForm.getTableSupported().getAttribute("KEY"));
        query.append(" != ? AND ");
        query.append(supportedForm.getTableSupported().getAttribute(keyIndex));
        query.append(" = ?");

        Vector parameters = new Vector();
        logger.info("the query " + query.toString());

        parameters.addElement(new StringValue(id));
        parameters.addElement(new StringValue(keyValue));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(parameters);

            queryResult = forQuery.executeQuery();
            return queryResult.isEmpty();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        return true;
    }

    protected String prepareInParameter(String... values) {
        StringBuilder builder = new StringBuilder("(");

        for (int i = 0; i < values.length; i++) {
            builder.append(values[i]);
            if (i < (values.length - 1)) {
                builder.append(", ");
            }
        }

        builder.append(")");
        return builder.toString();
    }
    
    public Vector getOnArbitraryDoubleKeyOracleOrderBy(String key1Value, String key1Index, String key2Value, String key2Index, String orderIndex) throws SQLException, Exception {

        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;

        StringBuffer dq = new StringBuffer("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name")).append(" WHERE ");
        dq.append(supportedForm.getTableSupported().getAttribute(key1Index));
        if (key1Value == null) {
            dq.append(" is null ");
        } else {
            dq.append(" = ? ");
        }
        dq.append("AND ");
        dq.append(supportedForm.getTableSupported().getAttribute(key2Index));
        if (key2Value == null) {
            dq.append(" is null ");
        } else {
            dq.append(" = ? ");
        }
        dq.append(" ORDER BY ");
        dq.append(supportedForm.getTableSupported().getAttribute(orderIndex));
        String theQuery = dq.toString();

        if (supportedForm == null) {

            initSupportedForm();
        }
        logger.info("the query " + theQuery);

        // finally do the query
        if (key1Value != null) {
            SQLparams.add(new StringValue(key1Value));
        }

        if (key2Value != null) {
            SQLparams.add(new StringValue(key2Value));
        }

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }

        return reultBusObjs;

    }
}
