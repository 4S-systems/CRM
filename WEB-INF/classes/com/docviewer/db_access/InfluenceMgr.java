/*F
 * InfluenceMgr.java
 *
 *
 *
 * Created on March 28, 2004, 6:31 AM
 */
package com.docviewer.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import com.silkworm.Exceptions.*;
import java.util.*;
import java.sql.*;
import java.io.*;
import com.docviewer.common.*;
import com.silkworm.util.*;
import java.text.*;
import com.silkworm.common.BookmarkMgr;
import com.silkworm.db_access.FileMgr;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author  walid
 */
public class InfluenceMgr extends RDBGateWay {

    /** Creates a new instance of ImageMgr */
    BookmarkMgr bookmarkMgr = BookmarkMgr.getInstance();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static InfluenceMgr InfluenceMgr = new InfluenceMgr();
    private static AccountItemMgr accntItemMgr = AccountItemMgr.getInstance();
    private FileMgr fileMgr = FileMgr.getInstance();
    private WebBusinessObject fileDescriptor = null;
    private static ImageMgr imageMgr = ImageMgr.getInstance();
    private static DocImgMgr diMgr = DocImgMgr.getInstance();
//    private static final String insertInfluencedSQL = "INSERT INTO INFLUENCE values(?,?,?,?,?,?,?,?,?,?,now())";
    private QueryMgr queryMgr = null;
    private String query = null;
    WebBusinessObject viewOrigin = null;

    public static InfluenceMgr getInstance() {
        logger.info("Getting ImageMgr Instance ....");
        return InfluenceMgr;
    }

    public void setQueryMgr(QueryMgr qm) {
        queryMgr = qm;
    }

    public java.util.ArrayList getCashedTableAsArrayList() {
        return null;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("influence.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(HttpServletRequest request, HttpSession s) throws NoUserInSessionException {

        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        String influencedID = (String) request.getParameter("influencedId");

        WebBusinessObject wbo = imageMgr.getOnSingleKey(influencedID);

        String InfluencedTitle = new String();

        if (null != wbo) {
            InfluencedTitle = (String) wbo.getAttribute("docTitle");

            params.addElement(new StringValue(UniqueIDGen.getNextID()));
            params.addElement(new StringValue(request.getParameter("influenceId")));
            params.addElement(new StringValue(request.getParameter("influencedId")));
            params.addElement(new StringValue(request.getParameter("influenceType")));
            params.addElement(new StringValue(request.getParameter("tracabilityType")));
            params.addElement(new StringValue((String) waUser.getAttribute("groupName")));
            params.addElement(new StringValue((String) waUser.getAttribute("userId")));
            params.addElement(new StringValue((String) waUser.getAttribute("userName")));
            params.addElement(new StringValue(request.getParameter("influenceTitle")));
            params.addElement(new StringValue((InfluencedTitle)));
        } else {
            return false;
        }

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);

            forInsert.setSQLQuery(sqlMgr.getSql("insertInfluencedSQL").trim());
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

    public WebBusinessObject getOnCompoundKey(String key1, String key2) {

        Connection connection = null;

        String query = new String(sqlMgr.getSql("getOnCompoundKey").trim());
        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue(key1));
        SQLparams.addElement(new StringValue(key2));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
            return null;
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
                return null;
            }
        }

        WebBusinessObject resultBusObj = null;
        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            resultBusObj = fabricateBusObj(r);
        }
        return resultBusObj;
    }

    @Override
    protected void initSupportedQueries() {
     return;//   throw new UnsupportedOperationException("Not supported yet.");
    }
}
