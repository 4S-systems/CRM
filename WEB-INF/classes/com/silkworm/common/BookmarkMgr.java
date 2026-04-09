/*
 * BookmarkMgr.java
 *
 * Created on February 25, 2004, 8:49 AM
 */
package com.silkworm.common;

/**
 *
 * @author walid
 */
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.log4j.xml.DOMConfigurator;

public class BookmarkMgr extends RDBGateWay {

    private static BookmarkMgr bookmarkMgr = new BookmarkMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

//    private static final String insertBookmarkSQL = "INSERT INTO BOOKMARK VALUES (?,?,?,?,?,now())";
    /**
     * Creates a new instance of BookmarkMgr
     */
    public BookmarkMgr() {
    }

    public static BookmarkMgr getInstance() {
        logger.info("Getting BookmarkMgr Instance ....");
        return bookmarkMgr;
    }

    public ArrayList getCashedTableAsArrayList() {
        return null;
    }

    public ArrayList getCashedTableAsBusObjects() {
        return null;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("bookmark.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        wbo.setAttribute("bookmarkId", UniqueIDGen.getNextID());
        params.addElement(new StringValue((String) wbo.getAttribute("bookmarkId")));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) wbo.getAttribute("parentId")));
        params.addElement(new StringValue((String) wbo.getAttribute("parentTitle")));
        params.addElement(new StringValue((String) wbo.getAttribute("bookmarkText")));
        params.addElement(new StringValue((String) wbo.getAttribute("objType")));
        params.addElement(new NullValue());
        //

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertBookmark").trim());
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

    public String saveBookmark(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String bookmarkId = UniqueIDGen.getNextID();
        params.addElement(new StringValue(bookmarkId));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) wbo.getAttribute("compId")));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue((String) wbo.getAttribute("note")));
        params.addElement(new StringValue((String) wbo.getAttribute("type")));
        params.addElement(new StringValue("marked"));
        //

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("insertBookmark").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
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

        return (bookmarkId);
    }

    public boolean deleteBookmark(String id) throws NoUserInSessionException, SQLException {


        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        Connection connection = null;
        try {
            params.addElement(new StringValue(id));
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("deleteBookmark").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {

            connection.close();

        }

        return (queryResult > 0);
    }

    public boolean updateBookmark(WebBusinessObject wbo) throws NoUserInSessionException, SQLException {


        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        Connection connection = null;
        try {
            params.addElement(new StringValue((String) wbo.getAttribute("note")));
            params.addElement(new StringValue((String) wbo.getAttribute("compId")));
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(getQuery("updateBookmark").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {

            connection.close();

        }

        return (queryResult > 0);
    }

    public WebBusinessObject getBookmark(String issueId, WebBusinessObject user) {

        WebBusinessObject wbo = null;
        Connection connection = null;
        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue((String) user.getAttribute("userId")));
        SQLparams.addElement(new StringValue(issueId));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectBookmark").trim());
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }

        // process the vector
        // vector of business objects

        Row r = null;

        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
        }


        return wbo;

        //  return new Bookmark();

    }

    public ArrayList<WebBusinessObject> getAllBookmarks() {
        WebBusinessObject wbo = null;
        Connection connection = null;
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("getAllBookmark").trim());
            queryResult = forQuery.executeQuery();
        } catch (SQLException se) {
            logger.error("troubles closing connection " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                connection.close();
            } catch (SQLException sex) {
                logger.error("troubles closing connection " + sex.getMessage());
            }
        }
        Row r = null;
        ArrayList<WebBusinessObject> result = new ArrayList<>();
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = fabricateBusObj(r);
            try {
                if (r.getString("USER_NAME") != null) {
                    wbo.setAttribute("userName", r.getString("USER_NAME"));
                }
            } catch (NoSuchColumnException ex) {
                Logger.getLogger(BookmarkMgr.class.getName()).log(Level.SEVERE, null, ex);
            }
            result.add(wbo);
        }
        return result;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }
}
