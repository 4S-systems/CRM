package com.docviewer.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.sql.*;
import java.io.Serializable;
import org.apache.log4j.xml.DOMConfigurator;

public class DocTypeMgr extends RDBGateWay implements Serializable {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static DocTypeMgr docTypeMgr = new DocTypeMgr();

//    private static final String insertDocTypeSQL = "INSERT INTO doc_type VALUES (?,?,?,?)";
    public static DocTypeMgr getInstance() {
        logger.info("Getting Doc DocTypeMgr Instance ....");
        return docTypeMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("doc_type.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("typeName"));
        }

        return cashedData;
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(HttpServletRequest request, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(request.getParameter("docType")));
        params.addElement(new StringValue(request.getParameter("desc")));
        params.addElement(new StringValue("conticon.gif"));


        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);

            forInsert.setSQLQuery(sqlMgr.getSql("insertDocTypeSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            cashData();
        } catch (SQLException se) {
            logger.error("Exception inserting file descriptor: " + se.getMessage());
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

    public ArrayList getCashedTableAsBusObjects() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            wbo.setObjectKey((String) wbo.getAttribute("typeName"));
            cashedData.add(wbo);
        }

        return cashedData;
    }

    public WebBusinessObject getObjectFromCash(String key) {


        return super.getObjectFromCash(key);
    }

    public boolean updateDocType(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {



        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
//        StringBuffer query = new StringBuffer("UPDATE ");
//        query.append(supportedForm.getTableSupported().getAttribute("name"));
//        query.append(" SET TYPE_NAME = ?,DESCRIPTION= ? ");
//        query.append(" WHERE ");
//        query.append(supportedForm.getTableSupported().getAttribute("key"));
//        query.append(" = ?");


        Vector params = new Vector();
        SQLCommandBean forUpdate = new SQLCommandBean();
        int queryResult = -1000;


        params.addElement(new StringValue((String) wbo.getAttribute("typeName")));
        params.addElement(new StringValue((String) wbo.getAttribute("desc")));
        params.addElement(new StringValue((String) wbo.getAttribute("typeID")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forUpdate.setConnection(connection);
            forUpdate.setSQLQuery(sqlMgr.getSql("updateDocType").trim());
            forUpdate.setparams(params);
            queryResult = forUpdate.executeUpdate();

            cashData();
        } catch (SQLException se) {
            logger.error("Exception inserting group: " + se.getMessage());
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

    public String getDocTypeIcon(String docTypeName) {
//        StringBuffer query = new StringBuffer("SELECT * FROM ");
//        query.append(supportedForm.getTableSupported().getAttribute("name"));
//        query.append(" WHERE TYPE_NAME = ?");

        Vector params = new Vector();
        SQLCommandBean forSelect = new SQLCommandBean();
        Vector queryResult = new Vector();
        params.addElement(new StringValue(docTypeName));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forSelect.setConnection(connection);
            forSelect.setSQLQuery(sqlMgr.getSql("selectDocTypeIcon").trim());
            forSelect.setparams(params);
            queryResult = forSelect.executeQuery();
        } catch (SQLException se) {
            logger.error("Exception inserting group: " + se.getMessage());
            return "";
        } catch (UnsupportedTypeException ue) {

        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return "";
            }
        }

        WebBusinessObject wbo = null;
        Row r = null;
        if (queryResult.size() > 0) {
            Enumeration e = queryResult.elements();
            while (e.hasMoreElements()) {
                r = (Row) e.nextElement();
                wbo = fabricateBusObj(r);
            }
            if (wbo != null) {
                return wbo.getAttribute("iconFile").toString();
            } else {
                return "conticon.gif";
            }
        } else {
            return "conticon.gif";
        }
    }

    public String getIconFile(String type) {
        Vector docType = null;
        try {
            docType = getOnArbitraryKey(type, "key1");
        } catch (Exception se) {

        }
        if (docType == null || docType.size() < 1) {
            return "";
        } else {
            WebBusinessObject wbo = (WebBusinessObject) docType.elementAt(0);
            return wbo.getAttribute("iconFile").toString();
        }
    }

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
}
