package com.workFlowTasks.db_access;

import com.docviewer.business_objects.Document;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import java.io.File;
import java.sql.SQLException;
import java.util.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

public class WFTaskVisitMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static WFTaskVisitMgr wfTaskVisitMgr = new WFTaskVisitMgr();
    private String wfTaskId = "";
    private String wfTaskVisitId = "";

    public WFTaskVisitMgr() {
    }

    public static WFTaskVisitMgr getInstance() {
        logger.info("Getting wfTaskVisitMgr Instance ....");
        return wfTaskVisitMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("wf_task_visit.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public Vector getTaskReqReview(String wfTaskId) throws SQLException {

        Vector SQLparams = new Vector();

        String query = "select * from wf_task_visit where replay_on_id ='req' and task_id= ? and WF_TASK_VISIT.id not in (select replay_on_id from WF_TASK_VISIT)";

        SQLparams.addElement(new StringValue(wfTaskId));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception" + se.getMessage());
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("UnspportedTypeException " + uste.getMessage());
        } catch (Exception ex) {
            logger.error("UNKNOWN Exception" + ex.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        WebBusinessObject reqWbo = null;
        while (e.hasMoreElements()) {

            reqWbo = new WebBusinessObject();
            r = (Row) e.nextElement();

            reqWbo = fabricateBusObj(r);

            reultBusObjs.add(reqWbo);
        }

        return reultBusObjs;

    }

    public ArrayList getCashedTableAsBusObjects() {
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
            cashedData.add((String) wbo.getAttribute("title"));
        }

        return cashedData;
    }

    public Vector getListUpdateOnLIKE(String keyValue) {

        Connection connection = null;
        Document doc = null;

        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(keyValue));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getListUpdateOnLIKE").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception" + se.getMessage());

        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                return null;
            }
        }
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();

            doc = (Document) fabricateBusObj(r);
            reultBusObjs.add(doc);
        }

        return reultBusObjs;

    }

    public WebBusinessObject fabricateBusObj(Row r) {

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

        Document doc = new Document(ht);

//        String date = (String) doc.getAttribute("docDate");
//        String formatedDate = date.substring(0, 10);
//        doc.setAttribute("docDate", formatedDate);
        return (WebBusinessObject) doc;
    }

    public Vector getMyAssignTicket(String userId) {

        Connection connection = null;
        Document doc = null;

        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(userId));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getMyAssignTicket").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception" + se.getMessage());

        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                return null;
            }
        }
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();

            doc = (Document) fabricateBusObj(r);
            reultBusObjs.add(doc);
        }

        return reultBusObjs;

    }

    public String getVisitQualificationByID(String updateID) {
        Connection connection = null;
        Document doc = null;

        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(updateID));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getVisitQualificationByID").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception" + se.getMessage());

        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                return null;
            }
        }
        Vector reultBusObjs = new Vector();

        String visitQual = "";
        WebBusinessObject wbo = new WebBusinessObject();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();

            wbo = (WebBusinessObject) fabricateBusObj(r);
            reultBusObjs.add(wbo);
        }
        try {
            wbo = (WebBusinessObject) reultBusObjs.get(0);
            visitQual = (String) wbo.getAttribute("qual_id");
        } catch (Exception E) {
            visitQual = "";
        }

        return visitQual;
    }

    public Vector getVisitByTask(String taskId) {
        Connection connection = null;
        Document doc = null;

        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(taskId));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectVisitByTask").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("SQL Exception" + se.getMessage());

        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                return null;
            }
        }
        Vector reultBusObjs = new Vector();

        WebBusinessObject wbo = new WebBusinessObject();
        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = super.fabricateBusObj(r);
            reultBusObjs.add(wbo);
        }

        return reultBusObjs;
    }
    
    public boolean getUpdateTicket(WebBusinessObject criteriaWbo, HttpSession s) throws NoUserInSessionException {

        Vector taskVisitparams = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String wfTaskVisitId = UniqueIDGen.getNextID();

        taskVisitparams.addElement(new StringValue(wfTaskVisitId));
        taskVisitparams.addElement(new StringValue((String) criteriaWbo.getAttribute("businessObjectId")));
        taskVisitparams.addElement(new StringValue("update"));
        taskVisitparams.addElement(new StringValue((String) criteriaWbo.getAttribute("notes")));
        taskVisitparams.addElement(new StringValue((String) criteriaWbo.getAttribute("userId")));
        taskVisitparams.addElement(new StringValue((String) criteriaWbo.getAttribute("userId")));
        taskVisitparams.addElement(new StringValue((String) criteriaWbo.getAttribute("reviewToId")));
        taskVisitparams.addElement(new DateValue((java.sql.Date) criteriaWbo.getAttribute("date")));
        taskVisitparams.addElement(new StringValue((String) criteriaWbo.getAttribute("replayOnId")));
        
        taskVisitparams.addElement(new StringValue((String) criteriaWbo.getAttribute("qualifcationID")));
        taskVisitparams.addElement(new StringValue((String) criteriaWbo.getAttribute("showCustomer")));

        taskVisitparams.addElement(new StringValue((String) criteriaWbo.getAttribute("objectType")));
        taskVisitparams.addElement(new StringValue((String) criteriaWbo.getAttribute("0")));
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            forInsert.setConnection(connection);

            forInsert.setSQLQuery(sqlMgr.getSql("visitTask").trim());
            forInsert.setparams(taskVisitparams);
            queryResult = forInsert.executeUpdate();
//
            connection.commit();
            
        } catch (SQLException se) {
            logger.error(se.getMessage());
            try {
                connection.rollback();
            } catch (SQLException ex) {
                Logger.getLogger(WFTaskVisitMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            System.out.print("save...." + se.getMessage());
            return false;
        } finally {
            try {
//                if(!criteriaWbo.getAttribute("fileExtension").toString().equals("noFiles")){
//                dispose = new File(filePath);
//                dispose.delete();
//                }
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
                System.out.print("save...." + ex.getMessage());
                return false;
            }
        }

        return (queryResult > 0);
    }
    
    @Override
    protected void initSupportedQueries() {
       return; // throw new UnsupportedOperationException("Not supported yet.");
    }
    
}
