/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.categoryEngineering.db_access;

/**
 *
 * @author khaled abdo
 */

import com.maintenance.common.Tools;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.persistence.relational.StringValue;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class JspTypesMgr extends RDBGateWay {

    private static JspTypesMgr jspTypesMgr = new JspTypesMgr();
    //SqlMgr sqlMgr = SqlMgr.getInstance();

    public static JspTypesMgr getInstance() {
        logger.info("Getting JspTypesMgr Instance ....");
        return jspTypesMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("jsp_types.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(WebBusinessObject wbo, HttpSession session) {
        WebBusinessObject waUser = (WebBusinessObject) session.getAttribute("loggedUser");
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(wbo.getAttribute("jspName").toString()));
        params.addElement(new StringValue(wbo.getAttribute("labelType").toString()));
        params.addElement(new StringValue(wbo.getAttribute("jspMode").toString()));
        params.addElement(new StringValue(wbo.getAttribute("departType").toString()));
        params.addElement(new StringValue(waUser.getAttribute("userId").toString()));

        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertJspType").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            return (queryResult > 0);
        }
    }

    /*public ArrayList getCashedTableAsBusObjects() {
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
            cashedData.add(wbo);
        }

        return cashedData;
    }

    public boolean updateObject(WebBusinessObject wbo, HttpSession s) {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(wbo.getAttribute("").toString()));
        params.addElement(new StringValue(wbo.getAttribute("").toString()));
        params.addElement(new StringValue(wbo.getAttribute("").toString()));
        params.addElement(new StringValue(wbo.getAttribute("").toString()));
        params.addElement(new StringValue(wbo.getAttribute("").toString()));
        params.addElement(new StringValue(wbo.getAttribute("").toString()));
        params.addElement(new StringValue(wbo.getAttribute("").toString()));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("updatemaintainableunittype").trim());
//            forInsert.setSQLQuery("update MAINTAINABLE_TYPE");
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

    public Vector getAllJspTypesBySorting() {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuilder query = new StringBuilder(sqlMgr.getSql("getAllBasictypeBySorting").trim());

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

    public Vector getAllJspTypesBySortingByID() {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        StringBuffer query = new StringBuffer(sqlMgr.getSql("getAllBasicTypeBySortingByID").trim());

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
    public ArrayList getAllAsArrayList(){
        ArrayList allAsArrayList = new ArrayList();

        Vector allAsVector = getAllJspTypesBySorting();

        for (int i = 0; i < allAsVector.size(); i++) {
            allAsArrayList.add((WebBusinessObject) allAsVector.get(i));
        }

        return allAsArrayList;
    }

    public boolean saveAssetsGroup(String groupId,String typeName,String notes,String apprivation,String isAgroupEq,String standAlone, String departType ,HttpSession s) {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(groupId));
        params.addElement(new StringValue(typeName));
        params.addElement(new StringValue(notes));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue(apprivation));
        params.addElement(new StringValue(isAgroupEq));
        params.addElement(new StringValue(standAlone));
        params.addElement(new StringValue(departType));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertmaintainableunittype").trim());
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
    public Vector getMainTypeName(String[] parenId){
        Connection connection = null;

        String quary = sqlMgr.getSql("selectMainTypeByIds").trim();

        quary = quary.replaceAll("iii", Tools.concatenation(parenId, ","));

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
                resAsWbo.addElement(row.getString("type_name"));
            } catch (NoSuchColumnException ex) {
                logger.error(ex.getMessage());
            }
        }

        return resAsWbo;
    }



     public String getMainType(String parenId){
        Connection connection = null;

        String quary = sqlMgr.getSql("selectMainTypeById").trim();
        Vector param  = new Vector() ;
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
                resAsWbo=row.getString("type_name");
            } catch (NoSuchColumnException ex) {
                logger.error(ex.getMessage());
            }
        }

        return resAsWbo;
    }


    public boolean deleteMainCategoryWithAccessories(String mainCategoryId) {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();

        params.addElement(new StringValue(mainCategoryId));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);

            forInsert.setSQLQuery("{ CALL DELETE_MAIN_CATEGORY(?) }");
            forInsert.setparams(params);

            forInsert.executeUpdate();

            try {
                Thread.sleep(3000);
            } catch(InterruptedException ex) { logger.error(ex.getMessage()); }
        } catch (SQLException se) {
            try {
                connection.rollback();
            } catch (SQLException ex) { logger.error("Close Error"); }
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                connection.commit();
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (true);
    }

    public String getMainTypeNameById(String parentId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> rows = new Vector<Row>();

        parameters.addElement(new StringValue(parentId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(sqlMgr.getSql("getMainTypeNameById").trim());

            rows = command.executeQuery();
            if(!rows.isEmpty()) {
                return rows.get(0).getString("TYPE_NAME");
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch(UnsupportedTypeException ex) {
            logger.error(ex.getMessage());
        } catch(NoSuchColumnException ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error " + ex.getMessage());
            }
        }

        return "***";
    }

    public String[] getAllMainTypeIds() {

        Connection connection = null;
        SQLCommandBean forSelect = new SQLCommandBean();
        Vector result = new Vector();

        try {
            connection = dataSource.getConnection();
            forSelect.setConnection(connection);
            forSelect.setSQLQuery(sqlMgr.getSql("getAllMainTypeIds").trim());
            result = forSelect.executeQuery();

        } catch (SQLException ex) {
            Logger.getLogger(JspTypesMgr.class.getName()).log(Level.SEVERE, null, ex);

        } catch (UnsupportedTypeException ex) {
            Logger.getLogger(JspTypesMgr.class.getName()).log(Level.SEVERE, null, ex);

        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(JspTypesMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        // convert site vector to array //
        String[] mainTypeArr = new String[result.size()];
        try {
            int index = 0;
            for (Object row : result) {
                mainTypeArr[index] = ((Row) row).getString("id");
                index++;
            }

        } catch (Exception e) { // raise an exception // }
        // -convert site vector to array //

        return mainTypeArr;
    }

    public String getTypeOfMainTypeNameById(String parentId) {
        SQLCommandBean command = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> rows = new Vector<Row>();

        parameters.addElement(new StringValue(parentId));

        try {
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setparams(parameters);
            command.setSQLQuery(sqlMgr.getSql("getTypeOfMainTypeNameById").trim());

            rows = command.executeQuery();
            if(!rows.isEmpty()) {
                return rows.get(0).getString("BASIC_COUNTER");
            }
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch(UnsupportedTypeException ex) {
            logger.error(ex.getMessage());
        } catch(NoSuchColumnException ex) {
            logger.error(ex.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error " + ex.getMessage());
            }
        }

        return "***";
    }
    */
    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
//        this.printMyQueries();
        return;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

}
