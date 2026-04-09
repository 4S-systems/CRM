package com.maintenance.db_access;

import com.maintenance.common.DateParser;
import com.maintenance.common.Tools;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class TransInfoItemMgr extends RDBGateWay {

    private static TransInfoItemMgr TransInfoItemMgr = new TransInfoItemMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    public static TransInfoItemMgr getInstance() {
        logger.info("Getting TransInfoItemMgr Instance ....");
        return TransInfoItemMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("trans_info_item.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(Hashtable hash) throws SQLException {
        return false;
    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("itemID"));
        }

        return cashedData;
    }

    public Vector getAllInfoBySparePart(String itemId, String bDate, String eDate, WebBusinessObject wbo2) {
        String mainType = "";
        String brand = "";
        String unitId = wbo2.getAttribute("unitId").toString();
        String[] mainType_ = (String[]) wbo2.getAttribute("mainType");
        String[] brand_ = (String[]) wbo2.getAttribute("brand");
        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        DateParser parser = new DateParser();
        String query = "";
        Vector SQLparams = new Vector();
        Vector queryResult = null;
        java.sql.Date sqlStartDate, sqlEndDate;
        sqlStartDate = parser.formatSqlDate(bDate);
        sqlEndDate = parser.formatSqlDate(eDate);

        // to get resualt at the same day from end day add one day to end date
        sqlEndDate.setDate(sqlEndDate.getDate() + 1);

        SQLparams.addElement(new StringValue(itemId));
        SQLparams.addElement(new DateValue(sqlStartDate));
        SQLparams.addElement(new DateValue(sqlEndDate));

        if ((unitId != null && !unitId.equals("unitId"))) {
            query = getQuery("getSparePartsByEquipment").trim();

            SQLparams.addElement(new StringValue(unitId));
        } else if (mainType_ != null && !mainType_[0].equals("mainType")) {
            
            query = getQuery("getSparePartsByMainType").trim();
            mainType = Tools.concatenation((String[]) wbo2.getAttribute("mainType"), ",");
            query = query.replaceAll("mmm", mainType);
        } else if (brand_ != null && !brand_[0].equals("brand")) {

            query = getQuery("getSparePartsByBrand").trim();
            brand = Tools.concatenation((String[]) wbo2.getAttribute("brand"), ",");
            query = query.replaceAll("bbb", brand);
        }

        String site = Tools.concatenation((String[]) wbo2.getAttribute("site"), ",");
        query = query.replaceAll("sss", site);
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error(uste.getMessage());
        } finally {
            endTransaction();
        }

        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        WebBusinessObject businessObject = new WebBusinessObject();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            businessObject = fabricateBusObj(r);
           /* try {
                businessObject.setAttribute("modelId", r.getString("parent_id").toString());
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(TransInfoItemMgr.class.getName()).log(Level.SEVERE, null, ex);
            }*/
            reultBusObjs.add(businessObject);
        }

        return reultBusObjs;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }
}
