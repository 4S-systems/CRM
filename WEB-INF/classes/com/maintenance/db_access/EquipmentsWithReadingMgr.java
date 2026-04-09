package com.maintenance.db_access;

import com.maintenance.common.DateParser;
import com.maintenance.common.Tools;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;

import com.silkworm.persistence.relational.StringValue;
import java.util.*;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class EquipmentsWithReadingMgr extends RDBGateWay {

    private static EquipmentsWithReadingMgr equipmentsWithReadingMgr = new EquipmentsWithReadingMgr();
    private ParentUnitMgr parentUnitMgr = ParentUnitMgr.getInstance();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public EquipmentsWithReadingMgr() {
    }

    public static EquipmentsWithReadingMgr getInstance() {
        logger.info("Getting EquipmentsWithReadingMgr Instance ....");
        return equipmentsWithReadingMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("equipments_with_reading.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public ArrayList getCashedTableAsBusObjects() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        cashData();
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
            cashedData.add((String) wbo.getAttribute("id"));
        }

        return cashedData;
    }

    public Vector getEquipmentsWithReadingBySites(String[] sites, String[] typeOfRate, String beginDate, String endDate) {
        Connection connection = null;
        Vector sqlParam = new Vector();
        DateParser dateParser = new DateParser();
        java.sql.Date sqlBeginDate,sqlEndDate;

        String query = sqlMgr.getSql("getEquipmentsWithReadingBySites").trim();

        String stringSites = Tools.concatenation(sites, ",");
        String stringTypeOfRate = Tools.concatenation(typeOfRate, ",");
        query = query.replaceAll("xxx", stringSites);
        query = query.replaceAll("yyy", stringTypeOfRate);
        sqlBeginDate = dateParser.formatSqlDate(beginDate);
        sqlEndDate = dateParser.formatSqlDate(endDate);

        // to get result at the same end datte will add end Date one day
        sqlEndDate.setDate(sqlEndDate.getDate() + 1);

        sqlParam.addElement(new StringValue(String.valueOf(sqlBeginDate.getTime())));
        sqlParam.addElement(new StringValue(String.valueOf(sqlEndDate.getTime())));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(sqlParam);
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
        for (int i = 0; i < queryResult.size(); i++) {
            resAsWbo.addElement(fabricateBusObj((Row) queryResult.get(i)));
        }

        return resAsWbo;
    }
     public Vector getEquipmentsWithReadingBySites(String sites, String[] typeOfRate, String beginDate, String endDate) {
        Connection connection = null;
        Vector sqlParam = new Vector();
        DateParser dateParser = new DateParser();
        java.sql.Date sqlBeginDate,sqlEndDate;

        String query = sqlMgr.getSql("getEquipmentsWithReadingBySites").trim();
        String stringTypeOfRate = Tools.concatenation(typeOfRate, ",");
        query = query.replaceAll("xxx", sites);
        query = query.replaceAll("yyy", stringTypeOfRate);
        sqlBeginDate = dateParser.formatSqlDate(beginDate);
        sqlEndDate = dateParser.formatSqlDate(endDate);

        // to get result at the same end datte will add end Date one day
        sqlEndDate.setDate(sqlEndDate.getDate() + 1);

        sqlParam.addElement(new StringValue(String.valueOf(sqlBeginDate.getTime())));
        sqlParam.addElement(new StringValue(String.valueOf(sqlEndDate.getTime())));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(sqlParam);
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
        for (int i = 0; i < queryResult.size(); i++) {
            resAsWbo.addElement(fabricateBusObj((Row) queryResult.get(i)));
        }

        return resAsWbo;
    }

    public Vector getEquipmentsWithReadingByIds(String[] ids, String[] typeOfRate, String beginDate, String endDate) {
        Connection connection = null;
        Vector sqlParam = new Vector();
        DateParser dateParser = new DateParser();
        java.sql.Date sqlBeginDate,sqlEndDate;

        String query = sqlMgr.getSql("getEquipmentsWithReadingByIds").trim();

        String stringIds = Tools.concatenation(ids, ",");
        String stringTypeOfRate = Tools.concatenation(typeOfRate, ",");

        query = query.replaceAll("xxx", stringIds);
        query = query.replaceAll("yyy", stringTypeOfRate);

        sqlBeginDate = dateParser.formatSqlDate(beginDate);
        sqlEndDate = dateParser.formatSqlDate(endDate);

        // to get result at the same end datte will add end Date one day
        sqlEndDate.setDate(sqlEndDate.getDate() + 1);

        sqlParam.addElement(new StringValue(String.valueOf(sqlBeginDate.getTime())));
        sqlParam.addElement(new StringValue(String.valueOf(sqlEndDate.getTime())));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(sqlParam);
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
        for (int i = 0; i < queryResult.size(); i++) {
            resAsWbo.addElement(fabricateBusObj((Row) queryResult.get(i)));
        }

        return resAsWbo;
    }

    public Vector getEquipmentsNotUpdated(String arrSites, int interval,String[] arrTypeOfRate, String[] arrIds, String[] arrMainType, String brand){
        Connection connection = null;
        Vector sqlParam = new Vector();

       
        String typeOfRateValue = Tools.concatenation(arrTypeOfRate, ",");
        String quary;

        java.util.Date dateNow = Calendar.getInstance().getTime();
        //to get resualt on the same date you must decrease interval on day
        if(interval > 0)
            interval = interval - 1;
        dateNow.setDate(dateNow.getDate() - interval);
        long actualTime = dateNow.getTime();

        sqlParam.addElement(new LongValue(actualTime));

        if(arrIds != null){
            quary = sqlMgr.getSql("getEquipmentsWithReadingByUnitIds").trim();

            quary = quary.replaceAll("iii", Tools.concatenation(arrIds, ","));
        }else if(arrMainType != null){
            quary = sqlMgr.getSql("getEquipmentsByMainType").trim();

            quary = quary.replaceAll("mmm", Tools.concatenation(arrMainType, ","));
        }else{
            quary = sqlMgr.getSql("getEquipmentsByBrand").trim();

            if(brand.contains(new StringBuffer("selectAll"))){
                quary = quary.replaceAll("ppp", parentUnitMgr.getSqlStatementSelectParentId());
            }else{
                String[] arrBrand = brand.split(" ");
                quary = quary.replaceAll("ppp", Tools.concatenation(arrBrand, ","));
            }
        }

        quary = quary.replaceAll("sss", arrSites);
        quary = quary.replaceAll("ttt", typeOfRateValue);

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(quary);
            forQuery.setparams(sqlParam);
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
        for (int i = 0; i < queryResult.size(); i++) {
            resAsWbo.addElement(fabricateBusObj((Row) queryResult.get(i)));
        }

        return resAsWbo;
    }

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }

}
