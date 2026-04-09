/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.eqp_operation.db_access;

import com.maintenance.common.Tools;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.util.*;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.*;
import java.text.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;
import org.jfree.data.time.Millisecond;

/**
 *
 * @author Administrator
 */
public class EqpOperationMgr extends com.silkworm.persistence.relational.RDBGateWay {

    private static EqpOperationMgr equOperationMgr = new EqpOperationMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public static EqpOperationMgr getInstance() {
        // logger.info("Getting EquipByIssueMgr Instance ....");
        System.out.println("getting Ahmad manager .......");
        return equOperationMgr;
    }
    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("equipment_status.xml")));
                System.out.println("reading Successfully xml files....!");
            } catch (Exception e) {
                System.out.println("Error in reading xml files....!");
            }
        }
    }

    public List getAllEquipByID(String EquipID) throws UnsupportedConversionException {
        WebBusinessObject  wbo = null;
        Vector params = new Vector();
        params.addElement(new StringValue(EquipID));
        Vector queryResult = null;
        Vector<Row> getDateQuery = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
           beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(getQuery("Get_Equip_Details").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
            
        } catch (SQLException se) {
            System.out.println("Error In executing Query.............!" + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            System.out.println("***** " + uste.getMessage());
        }
        params.clear();
        Vector resultBusObjs = new Vector();
        Row r = null;
        Enumeration e = queryResult.elements();
        Date  EntyDate, today;
        Row getDate = null;
        List list = new ArrayList();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
           wbo = new WebBusinessObject();
            try {
                String machibeId = r.getString("ID");
                params.addElement(new StringValue(machibeId));
                forQuery.setConnection(transConnection);
                forQuery.setparams(params);
                forQuery.setSQLQuery(getQuery("Get_Date").trim());
                getDateQuery = forQuery.executeQuery();
                if(!getDateQuery.isEmpty()){
                int getDateIndex = 0 ;
                double convert = 0.0;
                String Datecheck= null;
                while(getDateIndex<getDateQuery.size()){
                   getDate =getDateQuery.get(getDateIndex);
                   Datecheck= getDate.getString("GET_DIFFRENECE");
                   convert += Double.parseDouble(Datecheck);
                   getDateIndex++;
                }
                int DateTotal = (int)convert ;
                EntyDate = r.getDate("ENTRY_TIME");
                int entryToday =  calculateDaysFromNow(EntyDate);
                String ave = r.getString("AVERAGE");
                int average = Integer.parseInt(ave);
                int dayWorks =entryToday- DateTotal ;
                if (dayWorks != 0 && dayWorks >0) {
                int averageWorking =dayWorks*average;
                String currentReading = r.getString("CURRENT_READING");
                int curReading = Integer.parseInt(currentReading);
                int newCurrentReading =averageWorking+curReading;
                String unitTime = r.getString("UNIT_NAME");
                wbo.setAttribute("unitID",machibeId);
                wbo.setAttribute("Machine",unitTime);
                wbo.setAttribute("Entry_time",EntyDate );
                wbo.setAttribute("Current_Reading", newCurrentReading);
                wbo.setAttribute("oldCurrentReading", currentReading);
                wbo.setAttribute("Interval_working", entryToday);
                wbo.setAttribute("averageWorking", averageWorking);
                wbo.setAttribute("Out_of_working", DateTotal);
                wbo.setAttribute("working_days", dayWorks);
                wbo.setAttribute("average", average);
                list.add(wbo);
                    }
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(EqpOperationMgr.class.getName()).log(Level.SEVERE, null, ex);
            } catch (SQLException se) {
                System.out.println("Error In executing Query.............!" + se.getMessage());
            } catch (UnsupportedTypeException uste) {
                System.out.println("***** " + uste.getMessage());
            }
            params.clear();
        }
         endTransaction();
         
        return list;
    }
    public int calculateDaysFromNow(Date a) { 
        Date toDay = new Date();
        long endDate = a.getTime();
        long today = toDay.getTime();
        int MilliinDays = 1000 * 60 * 60 * 24;
        long diffFromNow =  today - endDate;
        return (int)Math.round(diffFromNow / MilliinDays);
    }
    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;


    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        ArrayList al = null;
        return al;
        //    throw new UnsupportedOperationException("Not supported yet.");

    }
}
