/*
 * BookmarkMgr.java
 *
 * Created on February 25, 2004, 8:49 AM
 */
package com.docviewer.db_access;

/**
 *
 * @author  walid
 */
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;

public class LockMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static LockMgr lockMgr = new LockMgr();

//    private static final String insertLockSQL = "INSERT INTO LOCKED VALUES (?,?,?,?,?,?,now())";
    public static LockMgr getInstance() {
        logger.info("Getting LockMgr Instance ....");
        return lockMgr;
    }

    public ArrayList getCashedTableAsArrayList() {
        return null;
    }

    public ArrayList getCashedTableAsBusObjects() {
        return null;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("locked.xml")));
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

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) wbo.getAttribute("docId")));
        params.addElement(new StringValue((String) wbo.getAttribute("docTitle")));
        params.addElement(new StringValue((String) wbo.getAttribute("lockType")));
        params.addElement(new StringValue((String) wbo.getAttribute("lockNote")));


        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertLockSQL").trim());
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

    public WebBusinessObject getLock(String docId, WebBusinessObject user) {

        WebBusinessObject wbo = null;
        Connection connection = null;
        Vector SQLparams = new Vector();

        SQLparams.addElement(new StringValue((String) user.getAttribute("userId")));
        SQLparams.addElement(new StringValue(docId));

        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(sqlMgr.getSql("selectLockSQL").trim());
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



    }

    public String isLocked(String docID) {
        try {
            Vector locked = getOnArbitraryKey(docID, "key2");
            WebBusinessObject wbo = null;
            if (locked.size() > 0) {
                wbo = (WebBusinessObject) locked.elementAt(0);
            }
            if (wbo != null) {
                return wbo.getAttribute("lockType").toString();
            } else {
                return "none";
            }
        } catch (SQLException se) {

        } catch (Exception ex) {

        }
        return "none";
    }

    public boolean isOwner(String lockID, String userID) {
        WebBusinessObject wbo = getOnSingleKey(lockID);
        if (wbo != null) {
            if (wbo.getAttribute("userId").toString().equalsIgnoreCase(userID)) {
                return true;
            } else {
                return false;
            }
        }
        return false;
    }

    @Override
    protected void initSupportedQueries() {
   return; //     throw new UnsupportedOperationException("Not supported yet.");
    }
}

