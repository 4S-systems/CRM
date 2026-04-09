package com.out_ofstore_parts.db_access;

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
import javax.servlet.http.HttpServletRequest;

public class OutOfStorePartsMgr extends RDBGateWay {

    private static OutOfStorePartsMgr outOfStorePartsMgr = new OutOfStorePartsMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public OutOfStorePartsMgr() {
    }

    public static OutOfStorePartsMgr getInstance() {
        logger.info("Getting OutOfStorePartsMgr Instance ....");
        System.out.println("Getting OutOfStorePartsMgr Instance ....");
        return outOfStorePartsMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("out_store_parts.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public boolean saveItem(WebBusinessObject itemWbo, String user) {

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;


        String id = UniqueIDGen.getNextID();
        String model_id = (String) itemWbo.getAttribute("model_id");
        params.addElement(new StringValue(id));
        params.addElement(new StringValue((String) itemWbo.getAttribute("nameAr")));
        params.addElement(new StringValue((String) itemWbo.getAttribute("nameEn")));
        params.addElement(new StringValue((String) itemWbo.getAttribute("pageNo")));
        params.addElement(new StringValue((String) itemWbo.getAttribute("itemNoPic")));
        params.addElement(new StringValue((String) itemWbo.getAttribute("manufactoryNo")));
        params.addElement(new IntValue((new Integer(itemWbo.getAttribute("expectedPrice").toString())).intValue()));
        params.addElement(new StringValue((String) itemWbo.getAttribute("storeId")));
        params.addElement(new StringValue((String) itemWbo.getAttribute("notes")));
        params.addElement(new StringValue(user));
        params.addElement(new StringValue((String) itemWbo.getAttribute("partType")));


        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            //    forInsert.setSQLQuery(sqlMgr.getSql("insertItem").trim());
            // String qur = getQuery("insert").trim();
            forInsert.setSQLQuery(getQuery("insert").trim());

            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            params = new Vector();
            params.addElement(new StringValue(id));
            params.addElement(new StringValue(model_id));

            forInsert.setSQLQuery(getQuery("insertPartsModel").trim());

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

    public boolean saveSpareParts(HttpServletRequest request, String user) {

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String saveType = (String) request.getParameter("saveType");


        String id = "";
        String[] modelIds = (String[]) request.getParameterValues("modelIds");
        if (saveType.equalsIgnoreCase("newSparePart")) {
            id = UniqueIDGen.getNextID();
            params.addElement(new StringValue(id));
            params.addElement(new StringValue((String) request.getParameter("nameAr")));
            params.addElement(new StringValue((String) request.getParameter("nameEn")));
            params.addElement(new StringValue((String) request.getParameter("pageNo")));
            params.addElement(new StringValue((String) request.getParameter("itemNoPic")));
            params.addElement(new StringValue((String) request.getParameter("codeNo")));
            params.addElement(new IntValue((new Integer(request.getParameter("expectedPrice").toString())).intValue()));
            params.addElement(new StringValue((String) request.getParameter("storeId")));
            params.addElement(new StringValue((String) request.getParameter("notes")));
            params.addElement(new StringValue(user));
            params.addElement(new StringValue((String) request.getParameter("partType")));

        } else {
            id = (String) request.getParameter("sparePartId");
        }
        try {
            beginTransaction();
            forInsert.setConnection(transConnection);

            if (saveType.equalsIgnoreCase("newSparePart")) {
                forInsert.setSQLQuery(getQuery("insert").trim());
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
            }
            forInsert.setSQLQuery(getQuery("insertPartsModel").trim());
            for (int i = 0; i < modelIds.length; i++) {

                params = new Vector();
                queryResult = -1000;
                params.addElement(new StringValue(id));
                params.addElement(new StringValue(modelIds[i]));
                forInsert.setparams(params);
                queryResult = forInsert.executeUpdate();
            }

        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();
        }
        return (queryResult > 0);
    }

    public boolean update(WebBusinessObject itemWbo) {

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;



        // String model_id=(String) itemWbo.getAttribute("model_id");

        params.addElement(new StringValue((String) itemWbo.getAttribute("arname")));
        params.addElement(new StringValue((String) itemWbo.getAttribute("enname")));
        params.addElement(new StringValue((String) itemWbo.getAttribute("page_no")));
        params.addElement(new StringValue((String) itemWbo.getAttribute("item_no")));
        params.addElement(new StringValue((String) itemWbo.getAttribute("manfuactory_no")));
        params.addElement(new IntValue((new Integer(itemWbo.getAttribute("expected_price").toString())).intValue()));
        params.addElement(new StringValue((String) itemWbo.getAttribute("comment")));
        params.addElement(new StringValue((String) itemWbo.getAttribute("item_type")));
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
            reultBusObjs = fabricateBusObj(r);
        }
        return reultBusObjs;
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
