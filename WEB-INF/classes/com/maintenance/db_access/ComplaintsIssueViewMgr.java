package com.maintenance.db_access;

import com.docviewer.business_objects.Document;
import com.silkworm.business_objects.*;
import com.silkworm.db_access.FileMgr;
import com.silkworm.persistence.relational.*;
import java.io.InputStream;
import java.sql.*;
import java.util.*;
import org.apache.log4j.xml.DOMConfigurator;

public class ComplaintsIssueViewMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static final ComplaintsIssueViewMgr complaintsIssueViewMgr = new ComplaintsIssueViewMgr();

    public static ComplaintsIssueViewMgr getInstance() {
        logger.info("Getting Compalints Issue View Instance ....");
        return complaintsIssueViewMgr;
    }

    @Override
    public java.util.ArrayList getCashedTableAsArrayList() {
        return null;
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("complaints_issue_view.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws java.sql.SQLException {
        return false;
    }

    public InputStream getImage(String documentId) {
        PreparedStatement prepared;
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            prepared = connection.prepareStatement(sqlMgr.getSql("getIssueDocumentImage").trim());
            prepared.setString(1, documentId);

            ResultSet rs = prepared.executeQuery();
            rs.next();
            return rs.getBinaryStream("image");

        } catch (SQLException se) {
            logger.error(se.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return null;
            }
        }
    }

    public String getDocument(String objectId, String objectType) throws NoSuchColumnException {
        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        Vector params = new Vector();
        params.addElement(new StringValue(objectId));
        params.addElement(new StringValue(objectType));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getIssueDocumentByObject").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (Exception se) {
            logger.error(se.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
            }
        }

        String id = null;
        Row row = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            row = (Row) e.nextElement();
            id = row.getString("DOCUMENT_ID");
            break;
        }
        return id;
    }

    public Vector getDocumentsListForIssue(String issueID) {

        Connection connection = null;
        Document doc = null;

        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(issueID));
        SQLparams.addElement(new StringValue(issueID));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(getQuery("getIssueDocumentByObject").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                return null;
            }
        }
        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();

            doc = (Document) fabricateBusObj(r);
            resultBusObjs.add(doc);
        }

        return resultBusObjs;

    }

    @Override
    public WebBusinessObject fabricateBusObj(Row r) {

        ListIterator li = supportedForm.getFormElemnts().listIterator();
        FormElement fe = null;
        Hashtable ht = new Hashtable();
        String colName;

        while (li.hasNext()) {

            try {
                fe = (FormElement) li.next();
                colName = (String) fe.getAttribute("column");
                ht.put(fe.getAttribute("name"), r.getString(colName));
            } catch (Exception e) {
            }

        }

        Document doc = new Document(ht);

        String date = (String) doc.getAttribute("documentDate");
        String formatedDate = date.substring(0, 10);
        doc.setAttribute("docDate", formatedDate);
        return (WebBusinessObject) doc;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }
}
