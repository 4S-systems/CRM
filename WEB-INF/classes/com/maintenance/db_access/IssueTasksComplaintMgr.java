package com.maintenance.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.jsptags.DropdownDate;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

public class IssueTasksComplaintMgr extends RDBGateWay {

    private static IssueTasksComplaintMgr issueTasksComplaintMgr = new IssueTasksComplaintMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();

//    private static final String insertIssueSQL = "INSERT INTO ISSUE_TYPE VALUES (?,?,now(),?)";
    public static IssueTasksComplaintMgr getInstance() {
        logger.info("Getting issueTasksComplaintMgr Instance ....");
        return issueTasksComplaintMgr;
    }

    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("issueTask_compalints.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {
//        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
//        WebIssueType issueType = (WebIssueType)wbo;
//        Vector params = new Vector();
//        SQLCommandBean forInsert = new SQLCommandBean();
//        int queryResult = -1000;
//
//        //params.addElement(new StringValue(UniqueIDGen.getNextID()));
//        params.addElement(new StringValue(issueType.getIssueName()));
//        params.addElement(new StringValue(issueType.getIssueDesc()));
//        params.addElement(new StringValue((String)waUser.getAttribute("userId")));
//
//        Connection connection = null;
//        try
//        {
//            connection = dataSource.getConnection();
//            forInsert.setConnection(connection);
//            forInsert.setSQLQuery(insertIssueSQL);
//            forInsert.setparams(params);
//            queryResult = forInsert.executeUpdate();
//
//            //
//            cashData();
//        }
//        catch(SQLException se)
//        {
//            logger.error(se.getMessage());
//            return false;
//        }
//        finally
//        {
//            try
//            {
//                connection.close();
//            }
//            catch(SQLException ex)
//            {
//                logger.error("Close Error");
//                return false;
//            }
//        }
//
//        return (queryResult > 0);
        return false;
    }

    

    public ArrayList getCashedTableAsArrayList() {

        cashedData = new ArrayList();
        WebBusinessObject wbo = null;

        for (int i = 0; i < cashedTable.size(); i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            cashedData.add((String) wbo.getAttribute("id"));
        }

        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
     return; //   throw new UnsupportedOperationException("Not supported yet.");
    }
}
