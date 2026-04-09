/*
 * ImageMgr.java
 *
 * Created on March 28, 2004, 6:31 AM
 */
package com.docviewer.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import javax.servlet.http.HttpSession;
import com.silkworm.Exceptions.*;
import java.util.*;
import java.sql.*;
import java.io.*;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author  walid
 */
public class AccountItemMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    /** Creates a new instance of AccountItemMgr */
    private static AccountItemMgr accntItemMgr = new AccountItemMgr();
//    private static final String insertAccntItemSQL = "INSERT INTO ACCOUNT_ITEM VALUES(?,?,?,?,?,?,now())";
    public static AccountItemMgr getInstance() {
        logger.info("Getting AccountItemMgr Instance ....");
        return accntItemMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("account_item.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(com.silkworm.business_objects.WebBusinessObject wbo) throws java.sql.SQLException {
        return false;
    }

    public boolean saveObject(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue((String) wbo.getAttribute("itemTitle")));
        params.addElement(new StringValue((String) wbo.getAttribute("title")));
        params.addElement(new StringValue((String) wbo.getAttribute("accntItemName")));
        params.addElement(new StringValue((String) wbo.getAttribute("description")));

        params.addElement(new StringValue((String) waUser.getAttribute("userId")));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertAccntItemSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            logger.error("Saving error");
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

    public java.util.ArrayList getCashedTableAsArrayList() {
        return null;
    }

    @Override
    protected void initSupportedQueries() {
       return; // throw new UnsupportedOperationException("Not supported yet.");
    }
}
