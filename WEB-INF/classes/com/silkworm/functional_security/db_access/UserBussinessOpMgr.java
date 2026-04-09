
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.silkworm.functional_security.db_access;

import com.silkworm.Exceptions.EmptyRequestException;
import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.SqlMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import com.silkworm.util.DictionaryItem;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author sohair
 */
public class UserBussinessOpMgr extends RDBGateWay {

    private static UserBussinessOpMgr bussinessOpMgr = new UserBussinessOpMgr();
//    private String[] sys_paths = null;
//    private String imageDirPath = null;
    SqlMgr sqlMgr = SqlMgr.getInstance();
    String generatedUserId = null;
    String sessionUserId = null;

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    protected void initSupportedForm() {
        if (supportedForm == null) {
            try {
                System.out.println("UserMgr ..***********.trying to get the XML file from path:: " + webInfPath);
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("user_bussiness_op.xml")));
            } catch (Exception e) {
                System.out.println("Could not locate XML Document");
            }
        }
    }

    public static UserBussinessOpMgr getInstance() {
        System.out.println("Getting UserUserBussinessOpMgr  Instance ....");
        return bussinessOpMgr;
    }
//  public void setSysPaths(String[] sys_paths) {
//        this.sys_paths = sys_paths;
//        imageDirPath = sys_paths[1];
//
//    }

    @Override
    public Vector getSearchQueryResult(HttpServletRequest request) throws SQLException, Exception {
        String userName = request.getParameter("userName");
        String password = request.getParameter("password");


        if (userName.equals("") || password.equals("")) {
            return null;
        } else {
            return super.getSearchQueryResult(request);
        }
    }

    @Override
    protected void initQueryElemnts() throws EmptyRequestException {
        String[] fishingFor = {"userName", "password"};

        if (null == theRequest) {
            throw new EmptyRequestException("request has not been initialized");
        } else {
            DictionaryItem existingParam = null;
            queryElements = new ArrayList(1);

            for (int i = 0; i < fishingFor.length; i++) {
                existingParam = getRequestParamAsDictionaryItem(fishingFor[i]);
                if (null != existingParam) {
                    queryElements.add(existingParam);
                } else {
                    System.out.println("the following string bound elemrnt is null " + fishingFor[i]);
                }
            }
        }
    }

    @Override
    protected void initSupportedQueries() {
//        throw new UnsupportedOperationException("Not supported yet.");
    return;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public boolean saveObject(String userId, String bussId) throws SQLException {
        generatedUserId = UniqueIDGen.getNextID();
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;

        params.addElement(new StringValue(generatedUserId));
        params.addElement(new StringValue(userId));
        params.addElement(new StringValue(bussId));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue("UL"));
        Connection connection = null;
        connection = dataSource.getConnection();

        try {

            forInsert.setConnection(connection);
            forInsert.setSQLQuery(sqlMgr.getSql("insertUserBussOp").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            System.out.println("reight insertion");
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        }



        return (queryResult > 0);
    }

    public Vector getOpListById(String userId) {

        WebBusinessObject wbo = new WebBusinessObject();
        Connection connection = null;
        Vector queryResult = null;
        Vector params = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();
        params.addElement(new StringValue(userId));
        try {
            connection = dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setparams(params);
            forQuery.setSQLQuery(sqlMgr.getSql("getOpById").trim());
            queryResult = forQuery.executeQuery();

        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());

        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());

        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }

        Vector resultBusObjs = new Vector();

        Row r = null;
        Enumeration e = queryResult.elements();
        while (e.hasMoreElements()) {
            r = (Row) e.nextElement();
            wbo = new WebBusinessObject();
            wbo = fabricateBusObj(r);
            resultBusObjs.add(wbo);
        }

        return resultBusObjs;
    }
}
