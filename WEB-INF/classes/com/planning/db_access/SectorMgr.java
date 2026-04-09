/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.planning.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.jsptags.DropdownDate;
import com.silkworm.persistence.relational.DateValue;
import com.silkworm.persistence.relational.IntValue;
import com.silkworm.persistence.relational.LongValue;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.TimestampValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author Waled
 */
public class SectorMgr extends RDBGateWay {

    public static SectorMgr seasonMgr = new SectorMgr();

    public static SectorMgr getInstance() {
        //  logger.info("Getting SectorMgr Instance ....");
        System.out.println("Getting SectorMgr Instance ....");
        return seasonMgr;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("sector.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public ArrayList getAllSeasonCodes() {
        Vector queryResult = new Vector();
        SQLCommandBean getCodes = new SQLCommandBean();
        try {
            //connection = dataSource.getConnection();
            beginTransaction();
            getCodes.setConnection(transConnection);
            getCodes.setSQLQuery(getQuery("getAllSeasoncodes").trim());
            queryResult = getCodes.executeQuery();
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());

        } catch (UnsupportedTypeException utb) {
            logger.error(utb.getMessage());
        }
        ArrayList reultBusObjs = new ArrayList();
        Row r = null;
        Enumeration e = queryResult.elements();
        WebBusinessObject wbo = null;
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            reultBusObjs.add(wbo);
        }
        return reultBusObjs;
    }

    public boolean saveObject(WebBusinessObject sector, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Connection connection = null;
        Vector params = new Vector();

        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) sector.getAttribute("planCode")));
        params.addElement(new StringValue((String) sector.getAttribute("sectorName")));
        params.addElement(new StringValue((String) sector.getAttribute("planDesc")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));

        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            String q = "INSERT INTO sector VALUES (?,?,?,?,SYSDATE,?)";
            forInsert.setSQLQuery(q);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();


        } catch (SQLException se) {
            System.out.println(se.getMessage());
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }

        }
        return true;
    }
    
    public boolean updateSector(WebBusinessObject wbo ) throws NoUserInSessionException {

        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue((String) wbo.getAttribute("sectorCode")));
        params.addElement(new StringValue((String) wbo.getAttribute("sectorArDesc")));
        params.addElement(new StringValue((String) wbo.getAttribute("sectorEnDesc")));
        params.addElement(new StringValue((String) wbo.getAttribute("id")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            String q = "UPDATE  sector set sector_code=?,sector_ar_desc=?,sector_en_des=? where sector_id=? ";
            forUpdate.setSQLQuery(q);
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

            cashData();
        } catch (SQLException se) {
            logger.error("Exception updating project: " + se.getMessage());
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

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        cashData();
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add(wbo);
        }

        return cashedData;
    }
   
}
