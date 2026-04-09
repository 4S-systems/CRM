/*
 * SeparatorMgr.java
 *
 * Created on March 30, 2005, 1:45 AM
 */
package com.docviewer.db_access;

/**
 *
 * @author Walid
 */
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.silkworm.Exceptions.*;
import java.util.*;
import java.sql.*;
import java.io.File;
import java.io.*;
import com.docviewer.business_objects.*;
import com.silkworm.common.BookmarkMgr;
import java.math.BigDecimal;
import org.apache.log4j.xml.DOMConfigurator;

public class SeparatorMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static SeparatorMgr sprtrMgr = new SeparatorMgr();
//    private static final String insertSptrSQL = "INSERT INTO document values(?,?,?,?,?,?,?,null,?,?,?,now(),?,?,?,'cntr',?,?,?,\"SPTR_TYPE\",\"FALSE\",\"FALSE\",\"FALSE\",\"NONE\",?,?,?,?,?,?,now(),now(),\"FALSE\",\"FALSE\")";
    private BookmarkMgr bookmarkMgr = BookmarkMgr.getInstance();
    private ImageMgr imageMgr = ImageMgr.getInstance();
    WebBusinessObject viewOrigin = null;

    public static SeparatorMgr getInstance() {
        logger.error("Getting SeparatorMgr Instance ....");
        return sprtrMgr;


    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("document.xml")));
            } catch (Exception e) {
                logger.error("SeparatorMgr :: Could not locate XML Document");
            }
        }


    }

    public java.util.ArrayList getCashedTableAsArrayList() {
        return null;
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public Vector getListByFileType(String forOperation, String keyValue) {

        Connection connection = null;
        Document doc = null;

        String query = queryMgr.getQuery(forOperation, keyValue);
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);


            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("database error from getListOnSecondKey: SeparatorMgr " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        WebBusinessObject wbo = null;
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();


            doc = (Document) fabricateBusObj(r);

            viewOrigin = new WebBusinessObject();
            viewOrigin.setAttribute("filter", forOperation);
            viewOrigin.setAttribute("filterValue", keyValue);
            doc.setViewOrigin(viewOrigin);

            reultBusObjs.add(doc);
        }


        return reultBusObjs;

    }

    public boolean saveObject(HttpServletRequest request, HttpSession session) throws NoUserInSessionException {
        theRequest = request;
        File dispose = null;
        Document sptrParent = null;
        WebBusinessObject waUser = (WebBusinessObject) session.getAttribute("loggedUser");

        BigDecimal totalValue = new BigDecimal(0);
        String docTitle = (String) request.getParameter("itemTitle");
        String description = (String) request.getParameter("description");
        String parentID = (String) request.getParameter("title");
        String configType = (String) request.getParameter("configType");

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
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
        params.addElement(new StringValue("sptr"));
        params.addElement(new StringValue("fldr"));
        params.addElement(new StringValue(parentID));
        params.addElement(new StringValue("NONE"));
        params.addElement(new StringValue(configType));
        params.addElement(new StringValue("Volatile"));
        params.addElement(new StringValue((String) waUser.getAttribute("userName")));
        params.addElement(new StringValue((String) waUser.getAttribute("userName")));
        params.addElement(new StringValue((String) waUser.getAttribute("userName")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertSptrSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
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
            cashedTable = imageMgr.getListByFileType("FilterOnType", "sptr");

        } catch (Exception e) {
            logger.error(e.getMessage());
        }
    }

    @Override
    protected void initSupportedQueries() {
      return;//  throw new UnsupportedOperationException("Not supported yet.");
    }
}
