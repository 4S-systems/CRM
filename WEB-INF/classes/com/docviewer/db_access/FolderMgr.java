/*
 * FolderMgr.java
 *
 * Created on March 30, 2005, 1:40 AM
 */
package com.docviewer.db_access;

/**
 *
 * @author Walid
 */
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.GroupMgr;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.silkworm.Exceptions.*;
import java.util.*;
import java.sql.*;
import java.io.File;
import java.math.BigDecimal;

import com.docviewer.business_objects.*;
import com.silkworm.common.BookmarkMgr;
import org.apache.log4j.xml.DOMConfigurator;

public class FolderMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static FolderMgr fldrMgr = new FolderMgr();
    private Vector sysFolders = null;
    private ImageMgr imageMgr = ImageMgr.getInstance();
    private BookmarkMgr bookmarkMgr = BookmarkMgr.getInstance();

    public static FolderMgr getInstance() {
        logger.info("Getting FolderMgr Instance ....");
        return fldrMgr;
    }

    public java.util.ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);

            cashedData.add((String) wbo.getAttribute("docTitle"));
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
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("document.xml")));
            } catch (Exception e) {
                logger.error("FolderMgr :: Could not locate XML Document");
            }
        }


    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(HttpServletRequest request, HttpSession session) throws NoUserInSessionException {
        theRequest = request;
        File dispose = null;
        WebBusinessObject waUser = (WebBusinessObject) session.getAttribute("loggedUser");

        BigDecimal totalValue = new BigDecimal(0);
        String docTitle = (String) request.getParameter("accTitle");
        String description = (String) request.getParameter("accDesc");
//        String version = (String) request.getParameter("version");

        if (description == null || description.equals("")) {
            description = "Description is Empty";
        }

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String folderID = UniqueIDGen.getNextID();
        params.addElement(new StringValue(folderID));
        params.addElement(new StringValue(docTitle));
        params.addElement(new StringValue("system"));
        params.addElement(new StringValue("system"));
        params.addElement(new StringValue("00"));
        params.addElement(new StringValue(description));
        params.addElement(new BigDecimalValue(totalValue));
        params.addElement(new StringValue("INTERNAL"));
        params.addElement(new StringValue("INTERNAL"));
        params.addElement(new StringValue("NONE"));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) waUser.getAttribute("userName")));
        params.addElement(new StringValue((String) waUser.getAttribute("groupName")));
        params.addElement(new StringValue("fldr"));
        params.addElement(new StringValue("cbnt"));
        params.addElement(new StringValue("700"));
        params.addElement(new StringValue("FALSE"));
        params.addElement(new StringValue("FALSE"));
        params.addElement(new StringValue("FALSE"));
        params.addElement(new StringValue("NONE"));
        params.addElement(new StringValue("NONE"));
        params.addElement(new StringValue("Volatile"));
        params.addElement(new StringValue((String) waUser.getAttribute("userName")));
        params.addElement(new StringValue((String) waUser.getAttribute("userName")));
        params.addElement(new StringValue((String) waUser.getAttribute("userName")));
        params.addElement(new StringValue("FALSE"));

        Connection connection = null;
        try {
            FolderGroupMgr folderGroupMgr = FolderGroupMgr.getInstance();
            GroupMgr groupMgr = GroupMgr.getInstance();
            String[] folderGroups = null;
            folderGroups = (String[]) request.getParameterValues("userGroups");
            Vector vTemp = new Vector();
            for (int i = 0; i < folderGroups.length; i++) {
                vTemp = groupMgr.getOnArbitraryKey(folderGroups[i], "key2");
                if (!folderGroupMgr.saveObject(request, session, vTemp, folderID)) {
                    return false;
                }
            }
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertFldrSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } catch (Exception ex) {

        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        return (queryResult > 0);
    }

    public void cashData() {
        try {
            cashedTable = imageMgr.getListByFileType("FilterOnType", "fldr");

        } catch (Exception e) {
            logger.error(e.getMessage());
        }
    }

    public void buildSysFoldersData(HttpSession session) {


        if (null != sysFolders) {
            sysFolders.clear();
        }
        Vector params = new Vector();
        WebBusinessObject waUser = (WebBusinessObject) session.getAttribute("loggedUser");
        params.addElement(new StringValue((String) waUser.getAttribute("groupID")));
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("cashFldrSQL").trim());
            forQuery.setparams(params);
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error(se.getMessage());

        } catch (UnsupportedTypeException uste) {
            logger.error(uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException se) {
                logger.error("trouble closing connection while building system folders: " + se.getMessage());
            }
        }

        sysFolders = new Vector();
        FolderGroupMgr folderGroupMgr = FolderGroupMgr.getInstance();
        Row r = null;
        Enumeration e = queryResult.elements();

        WebBusinessObject wbo = null;
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = folderGroupMgr.fabricateBusObj(r);
            sysFolders.add(wbo);
        }
    }

    public Vector getSystemFolders(HttpSession session) {
        buildSysFoldersData(session);
        return sysFolders;
    }

    protected WebBusinessObject fabricateBusObj(Row r) {

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

        Folder folder = new Folder(ht);
        return (WebBusinessObject) folder;
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
