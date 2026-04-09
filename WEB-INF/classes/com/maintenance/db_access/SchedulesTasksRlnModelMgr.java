/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.maintenance.db_access;

import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author khaled abdo
 */
public class SchedulesTasksRlnModelMgr extends RDBGateWay {

    private static SchedulesTasksRlnModelMgr rlnModelMgr = new SchedulesTasksRlnModelMgr();

    public SchedulesTasksRlnModelMgr() {
    }

    public static SchedulesTasksRlnModelMgr getInstance() {
        logger.info("Getting ItemMgr Instance ....");
        return rlnModelMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("schedules_tasks_rln_model.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    protected void initSupportedQueries() {
        //throw new UnsupportedOperationException("Not supported yet.");
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public List<WebBusinessObject> selectAllByModelId(String modelID) {

        Vector params = new Vector();
        SQLCommandBean forSelect = new SQLCommandBean();
        Vector queryResult = null;

        //Vector schTasks = selectAllByModeslId(modelID);
        params.add(new StringValue(modelID));
        try {
            beginTransaction();
            forSelect.setConnection(transConnection);
            forSelect.setSQLQuery(getQuery("selectAllByModelId").trim());
            forSelect.setparams(params);
            try {
                queryResult = forSelect.executeQuery();
            } catch (UnsupportedTypeException ex) {
                Logger.getLogger(SchedulesTasksRlnModelMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } finally {
            
        }

        WebBusinessObject reultBusObjs = null;
        List<WebBusinessObject> res = new ArrayList<WebBusinessObject>();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs=fabricateBusObj(r);
            res.add(reultBusObjs);
         }
        return res;
    }

    public List<WebBusinessObject> selectAllByModelAndTask(String modelID, String taskID) {

        Vector params = new Vector();
        SQLCommandBean forSelect = new SQLCommandBean();
        Vector queryResult = null;

        //Vector schTasks = selectAllByModeslId(modelID);
        params.add(new StringValue(modelID));
        params.add(new StringValue(taskID));
        try {
            beginTransaction();
            forSelect.setConnection(transConnection);
            forSelect.setSQLQuery(getQuery("selectAllByModelAndTask").trim());
            forSelect.setparams(params);
            try {
                queryResult = forSelect.executeQuery();
            } catch (UnsupportedTypeException ex) {
                Logger.getLogger(SchedulesTasksRlnModelMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } finally {

        }

        WebBusinessObject reultBusObjs = null;
        List<WebBusinessObject> res = new ArrayList<WebBusinessObject>();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs=fabricateBusObj(r);
            res.add(reultBusObjs);
         }
        return res;
    }

    public String selectScheduleCountByModelId(String modelID) {

        Vector params = new Vector();
        SQLCommandBean forSelect = new SQLCommandBean();
        Vector queryResult = null;

        params.add(new StringValue(modelID));
        try {
            beginTransaction();
            forSelect.setConnection(transConnection);
            forSelect.setSQLQuery(getQuery("selectScheduleCountByModelId").trim());
            forSelect.setparams(params);
            try {
                queryResult = forSelect.executeQuery();
            } catch (UnsupportedTypeException ex) {
                Logger.getLogger(SchedulesTasksRlnModelMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            endTransaction();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } finally {

        }

        Row r = null;
        Enumeration e = queryResult.elements();
        String countSchedule = null;

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            try {
                countSchedule = r.getString("countSchedule");
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(SchedulesTasksRlnModelMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return countSchedule;
    }
}
