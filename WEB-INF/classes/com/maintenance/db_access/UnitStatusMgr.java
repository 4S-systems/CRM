package com.maintenance.db_access;

import com.silkworm.xml.DOMFabricatorBean;
import com.silkworm.business_objects.*;
import java.util.*;
import com.silkworm.persistence.relational.*;
import com.silkworm.events.*;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class UnitStatusMgr extends RDBGateWay {

    Vector businessObjectEventListeners = null;
    UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static UnitStatusMgr unitStatusMgr = new UnitStatusMgr();

    private UnitStatusMgr() {
    }

    public static UnitStatusMgr getInstance() {
        logger.info("Getting UnitMgr Instance ....");
        return unitStatusMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("unit_status.xml")));//"C:\\temp\\maintainableUnit.xml"));
                System.out.println(" unit_status  done");
            } catch (Exception e) {
                logger.error(e.getMessage());
            }
        }
    }

    protected WebBusinessObject fabricateBusObj(Row r) {

        ListIterator li = supportedForm.getFormElemnts().listIterator();
        FormElement fe = null;
        Hashtable ht = new Hashtable();
        String colName;
        String state = null;
        String docOwnerId = null;



        while (li.hasNext()) {

            try {
                fe = (FormElement) li.next();
                colName = (String) fe.getAttribute("column");
                // needs a case ......
                ht.put(fe.getAttribute("name"), r.getString(colName));
            } catch (Exception e) {
            }

        }

        MaintainableUnit expense = new MaintainableUnit(ht);
        return (WebBusinessObject) expense;
    }

    public Vector getChildren(String parentId) {
        MaintainableUnit expense = null;
        Connection connection = null;
//        String query = "SELECT * FROM maintainable_unit WHERE PARENT_ID = ? ORDER BY UNIT_NAME";

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(parentId));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {

            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectMaintainableUnit").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            expense = (MaintainableUnit) fabricateBusObj(r);
            reultBusObjs.add(expense);
        }

        return reultBusObjs;


    }

    public Vector getUnit(String text, String id) throws SQLException {
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        String query = null;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector param = new Vector();
        param.add(new StringValue(id));

        query = getQuery("getUnit").trim();
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

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("UNIT_NAME"));
        }

        return cashedData;
    }

    public Vector getUnitWithoutParent(String text) throws SQLException {
        WebBusinessObject wbo;
        Connection connection = null;
        String query;
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector param = new Vector();

        query = getQuery("getUnitWithoutParent").trim();
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
        Row row;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            wbo = fabricateBusObj(row);
            reultBusObjs.add(wbo);
        }

        return reultBusObjs;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }
}
