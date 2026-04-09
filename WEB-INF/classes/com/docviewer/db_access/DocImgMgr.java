/*
 * DocImgMgr.java
 *
 * Created on April 2, 2005, 12:49 PM
 */
package com.docviewer.db_access;

/**
 *
 * @author Walid
 */
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;

import com.silkworm.Exceptions.*;

import java.util.*;
import java.sql.*;
import java.io.File;
import java.io.*;

import com.docviewer.common.*;
import com.silkworm.util.*;
import java.text.*;
import org.apache.log4j.xml.DOMConfigurator;

public class DocImgMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static DocImgMgr diMgr = new DocImgMgr();

//    private static final String insertImageSQL = "INSERT INTO DOC_IMAGE values(?,?,?)";
//    private static final String getImageSQL = "SELECT IMAGE FROM DOC_IMAGE WHERE IMAGE_ID = ?";
    public static DocImgMgr getInstance() {
        logger.info("Getting Doc DocImgMgr Instance ....");
        return diMgr;
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
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("docimage.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(com.silkworm.business_objects.WebBusinessObject wbo) throws java.sql.SQLException {
        return false;
    }

    public boolean saveDocImage(String parentDocID, String filePath) {

        File dispose = null;

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(UniqueIDGen.getNextID()));
        params.addElement(new StringValue(parentDocID));
        params.addElement(new ImageValue(new File(filePath)));

        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertDocImageSQL").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            try {
                dispose = new File(filePath);
                dispose.delete();
                connection.close();
            } catch (SQLException ex) {
                logger.error("Close Error");
                return false;
            }
        }

        return (queryResult > 0);
    }

    public Vector getOnRefInteg(String refKey) throws SQLException, Exception {


        Vector SQLparams = new Vector();
        WebBusinessObject wbo = null;

        StringBuffer dq = new StringBuffer("SELECT IMAGE_ID FROM DOC_IMAGE");
        dq.append(" WHERE ");
        dq.append(supportedForm.getTableSupported().getAttribute("refintegkey"));
        dq.append(" = ? ");
        String theQuery = dq.toString();


        if (supportedForm == null) {

            initSupportedForm();
        }


        SQLparams.add(new StringValue(refKey));


        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {

            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            forQuery.setparams(SQLparams);

            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            throw se;
        } catch (UnsupportedTypeException uste) {
            logger.error("Persistence Error " + uste.getMessage());
        } finally {
            connection.close();
        }

        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();

        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }


        return reultBusObjs;


    }

    public InputStream getImage(String docId) {


        PreparedStatement ps = null;
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            ps = connection.prepareStatement(sqlMgr.getSql("getDocImageSQL").trim());
            ps.setString(1, docId);

            ResultSet rs = ps.executeQuery();
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

    @Override
    protected void initSupportedQueries() {
    return; //    throw new UnsupportedOperationException("Not supported yet.");
    }
}
