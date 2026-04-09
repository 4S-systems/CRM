
package com.Item_Type.db_access;

import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.FormElement;
import com.silkworm.business_objects.SqlMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.common.SecurityUser;
import com.silkworm.persistence.relational.IntValue;
import com.silkworm.persistence.relational.LongValue;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;
import org.apache.log4j.xml.DOMConfigurator;
import java.sql.*;
import java.util.Calendar;
import java.util.Enumeration;

public class ItemTypeMgr  extends RDBGateWay {

    private static ItemTypeMgr itemtypeMgr = new ItemTypeMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public ItemTypeMgr() {
    }

    public static ItemTypeMgr getInstance() {
        logger.info("Getting itemtypeMgr Instance ....");
        System.out.println("Getting itemtypeMgr Instance ....");
        return itemtypeMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("item_type.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public ArrayList getAllAsArrayList() {
        super.cashData();
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
            cashedData.add((String) wbo.getAttribute("id"));
            cashedData.add((String) wbo.getAttribute("nameAr"));
            cashedData.add((String) wbo.getAttribute("nameEn"));
        }

        return cashedData;
    }

    @Override
    public ArrayList getCashedTableAsBusObjects() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("id"));
            cashedData.add((String) wbo.getAttribute("nameAr"));
            cashedData.add((String) wbo.getAttribute("nameEn"));
            cashedData.add(wbo);
        }

        return cashedData;
    }
    
    public boolean saveObject(WebBusinessObject itemWbo) throws SQLException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;


        String id=UniqueIDGen.getNextID();

         params.addElement(new StringValue(id));
        params.addElement(new StringValue((String) itemWbo.getAttribute("arname")));
        params.addElement(new StringValue((String) itemWbo.getAttribute("enname")));



        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
        //    forInsert.setSQLQuery(sqlMgr.getSql("insertItem").trim());
           // String qur = getQuery("insert").trim();
            forInsert.setSQLQuery(getQuery("insert").trim());

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

    public boolean saveItem(WebBusinessObject itemWbo , String user) {

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;


        String id=UniqueIDGen.getNextID();
     
         params.addElement(new StringValue(id));
        params.addElement(new StringValue((String) itemWbo.getAttribute("arname")));
        params.addElement(new StringValue((String) itemWbo.getAttribute("enname")));
       


        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
        //    forInsert.setSQLQuery(sqlMgr.getSql("insertItem").trim());
           // String qur = getQuery("insert").trim();
            forInsert.setSQLQuery(getQuery("insert").trim());

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

   public WebBusinessObject getItems(String manufactoryNo) {

        Connection connection = null;

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(manufactoryNo));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("GetItemsByManufactoryNo").trim());
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

        WebBusinessObject reultBusObjs = null;
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs=fabricateBusObj(r);
         }
       return reultBusObjs;
  }

   public boolean update(WebBusinessObject itemWbo) throws SQLException {
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;


        
        params.addElement(new StringValue((String) itemWbo.getAttribute("arname")));
        params.addElement(new StringValue((String) itemWbo.getAttribute("enname")));
         params.addElement(new StringValue((String) itemWbo.getAttribute("id")));



        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
        //    forInsert.setSQLQuery(sqlMgr.getSql("insertItem").trim());
           // String qur = getQuery("insert").trim();
            forInsert.setSQLQuery(getQuery("update").trim());

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



   public long timenow() {

        Date d = (Date) Calendar.getInstance().getTime();

        long nowTime = d.getTime();
        return nowTime;
    }

    @Override
    protected void initSupportedQueries() {


         queriesIS = metaDataMgr.getQueries(queriesPropFileName);
         return;

}

 //   }
}