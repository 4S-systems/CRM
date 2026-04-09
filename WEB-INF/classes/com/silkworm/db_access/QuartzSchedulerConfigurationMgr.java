package com.silkworm.db_access;

import com.silkworm.automation.CustomScheduler;
import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.IntValue;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;
import org.apache.log4j.xml.DOMConfigurator;
import org.quartz.SchedulerException;

public class QuartzSchedulerConfigurationMgr extends RDBGateWay {

    private final static QuartzSchedulerConfigurationMgr QUARTZ_SCHEDULER_CONFIGURATION_MGR = new QuartzSchedulerConfigurationMgr();
    private final static List<CustomScheduler> schedulers = new ArrayList<CustomScheduler>();

    public static QuartzSchedulerConfigurationMgr getInstance() {
        logger.info("Getting QuartzSchedulerConfigurationMgr Instance ....");
        return QUARTZ_SCHEDULER_CONFIGURATION_MGR;
    }

    private QuartzSchedulerConfigurationMgr() {
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("quartz_scheduler_configuration.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public synchronized void addScheduler(CustomScheduler scheduler) {
        synchronized (schedulers) {
            CustomScheduler custom = getScheduler(scheduler.getId());
            if (custom == null) {
                schedulers.add(scheduler);
            }
        }
    }

    public synchronized void removeScheduler(String id) {
        synchronized (schedulers) {
            CustomScheduler scheduler = getScheduler(id);
            if (scheduler != null) {
                try {
                    if (scheduler.getScheduler().isStarted()) {
                        scheduler.getScheduler().shutdown();
                    }
                    schedulers.remove(scheduler);
                } catch (SchedulerException ex) {
                    logger.error(ex);
                }
            }
        }
    }

    public synchronized CustomScheduler getScheduler(String id) {
        synchronized (schedulers) {
            for (CustomScheduler scheduler : schedulers) {
                if (scheduler.getId().equalsIgnoreCase(id)) {
                    return scheduler;
                }
            }
        }
        return null;
    }

    public synchronized boolean isSchedulerExist(String id) {
        return getScheduler(id) != null;
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public String saveObject(String objectId, String objectType, String action, String interval, String runWhen, String running, String createdBy) {
        return saveObject(objectId, objectType, action, Integer.parseInt(interval), Integer.parseInt(runWhen), true, createdBy);
    }

    public String saveObject(String objectId, String objectType, String action, int interval, int runWhen, boolean running, String createdBy) {
        SQLCommandBean commad = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        int result = -1000;

        String id = UniqueIDGen.getNextID();
        parameters.addElement(new StringValue(id));
        parameters.addElement(new StringValue(objectId));
        parameters.addElement(new StringValue(objectType));
        parameters.addElement(new StringValue(action));
        parameters.addElement(new IntValue(interval));
        parameters.addElement(new IntValue(runWhen));
        parameters.addElement(new StringValue(running ? "1" : "0"));
        parameters.addElement(new StringValue(createdBy));
        parameters.addElement(new StringValue("UL"));
        parameters.addElement(new StringValue("UL"));
        parameters.addElement(new StringValue("UL"));

        try {
            connection = dataSource.getConnection();
            commad.setConnection(connection);
            commad.setSQLQuery(getQuery("insert").trim());
            commad.setparams(parameters);
            result = commad.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException se) {
                logger.error(se.getMessage());
            }
        }
        return (result > 0) ? id : null;
    }

    public boolean delete(String id) {
        SQLCommandBean commad = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        int result = -1000;

        parameters.addElement(new StringValue(id));

        try {
            connection = dataSource.getConnection();
            commad.setConnection(connection);
            commad.setSQLQuery(getQuery("delete").trim());
            commad.setparams(parameters);
            result = commad.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException se) {
                logger.error(se.getMessage());
            }
        }
        return (result > 0);
    }

    public boolean updateInterval(String id, int interval) {
        SQLCommandBean commad = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        int result = -1000;

        parameters.addElement(new IntValue(interval));
        parameters.addElement(new StringValue(id));

        try {
            connection = dataSource.getConnection();
            commad.setConnection(connection);
            commad.setSQLQuery(getQuery("updateInterval").trim());
            commad.setparams(parameters);
            result = commad.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException se) {
                logger.error(se.getMessage());
            }
        }
        return (result > 0);
    }

    public boolean updateRunning(String id, String running) {
        SQLCommandBean commad = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        int result = -1000;

        parameters.addElement(new StringValue(running));
        parameters.addElement(new StringValue(id));

        try {
            connection = dataSource.getConnection();
            commad.setConnection(connection);
            commad.setSQLQuery(getQuery("updateRunning").trim());
            commad.setparams(parameters);
            result = commad.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException se) {
                logger.error(se.getMessage());
            }
        }
        return (result > 0);
    }

    public List<WebBusinessObject> getByObjectTypeAndAction(String objectType, String action) {
        SQLCommandBean commad = new SQLCommandBean();
        Connection connection = null;
        Vector parameters = new Vector();
        Vector<Row> result;

        parameters.addElement(new StringValue(objectType));
        parameters.addElement(new StringValue(action));

        try {
            connection = dataSource.getConnection();
            commad.setConnection(connection);
            commad.setSQLQuery(getQuery("getByObjectTypeAndAction").trim());
            commad.setparams(parameters);
            result = commad.executeQuery();

            List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
            for (Row row : result) {
                data.add(fabricateBusObj(row));
            }

            return data;
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException se) {
                logger.error(se.getMessage());
            }
        }

        return new ArrayList<WebBusinessObject>();
    }

    public List<WebBusinessObject> getAllDepartments() {
        SQLCommandBean commad = new SQLCommandBean();
        Connection connection = null;
        Vector<Row> result;

        try {
            connection = dataSource.getConnection();
            commad.setConnection(connection);
            commad.setSQLQuery(getQuery("getAllDepartments").trim());
            result = commad.executeQuery();

            List<WebBusinessObject> data = new ArrayList<WebBusinessObject>();
            WebBusinessObject wbo;
            for (Row row : result) {
                try {
                    wbo = fabricateBusObj(row);
                    wbo.setAttribute("departmentId", row.getString("DEPARTMENT_ID"));
                    wbo.setAttribute("departmentName", row.getString("DEPARTMENT_NAME"));
                    data.add(wbo);
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                }
            }

            return data;
        } catch (SQLException se) {
            logger.error(se.getMessage());
        } catch (UnsupportedTypeException se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException se) {
                logger.error(se.getMessage());
            }
        }

        return new ArrayList<WebBusinessObject>();
    }
}