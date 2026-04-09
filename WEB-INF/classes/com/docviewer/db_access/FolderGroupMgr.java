package com.docviewer.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import com.silkworm.Exceptions.*;
import java.util.*;
import java.sql.*;
import java.io.*;

import com.docviewer.business_objects.*;
import org.apache.log4j.xml.DOMConfigurator;

public class FolderGroupMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static FolderGroupMgr fldrGroupMgr = new FolderGroupMgr();
//    private static final String insertFldrGroupSQL = "INSERT INTO FOLDER_GROUP values(?,?,?,?)";
//    private static final String selectFolderGroupSQL = "SELECT * FROM FOLDER_GROUP WHERE FOLDER_ID = ? AND GROUP_ID = ?";
    public static FolderGroupMgr getInstance() {
        logger.info("Getting FolderMgr Instance ....");
        return fldrGroupMgr;
    }

    public java.util.ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("folderName"));
        }

        return cashedData;
    }

    public Vector getCashedTableAsBusObjVector() {

        Vector filteredTable = new Vector();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);

            filteredTable.addElement(wbo);
        }

        return filteredTable;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("folder_group.xml")));
            } catch (Exception e) {
                logger.error("FolderGroupMgr :: Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(HttpServletRequest request, HttpSession session, Vector vGroups, String folderID) throws NoUserInSessionException {
        Vector params = new Vector();

        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        WebBusinessObject wbo = null;
        if (vGroups.size() > 0) {
            wbo = (WebBusinessObject) vGroups.elementAt(0);
        } else {
            return false;
        }

        params.addElement(new StringValue((String) wbo.getAttribute("groupID")));
        params.addElement(new StringValue(folderID));
        params.addElement(new StringValue((String) wbo.getAttribute("groupName")));
        if (request.getParameter("accTitle") != null && !request.getParameter("accTitle").equalsIgnoreCase("")) {
            params.addElement(new StringValue(request.getParameter("accTitle")));
        } else {
            params.addElement(new StringValue(request.getParameter("fldrName")));
        }

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertFldrGroupSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
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

    public WebBusinessObject fabricateBusObj(Row r) {
        initSupportedForm();
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
            // raise an exception
            }
        }


        WebBusinessObject folder = new WebBusinessObject(ht);
        return folder;
    }

    public boolean isOwner(String folderID, String groupID) {
        Vector params = new Vector();

        SQLCommandBean forSelect = new SQLCommandBean();
        Vector queryResult = new Vector();
        params.addElement(new StringValue(folderID));
        params.addElement(new StringValue(groupID));
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forSelect.setConnection(connection);
            forSelect.setSQLQuery(sqlMgr.getSql("selectFolderGroupSQL").trim());
            forSelect.setparams(params);
            queryResult = forSelect.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } catch (UnsupportedTypeException ue) {

        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }
        return queryResult.size() > 0;
    }

    @Override
    protected void initSupportedQueries() {
    return; //    throw new UnsupportedOperationException("Not supported yet.");
    }
}