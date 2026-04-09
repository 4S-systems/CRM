/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.workFlowTasks.db_access;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.persistence.relational.StringValue;
import java.util.*;
import java.sql.*;
import org.apache.log4j.xml.DOMConfigurator;


/**
 *
 * @author khaled abdo
 */
public class WFTaskCommentsMgr extends RDBGateWay{

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static WFTaskCommentsMgr wfTaskComments = new WFTaskCommentsMgr();

    public static WFTaskCommentsMgr getInstance() {
        logger.error("Getting RegisterMgr Instance ....");
        return wfTaskComments;
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("wf_task_comments.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

/////////////////////////////////////////////////////
    public Vector getAllTaskComments(String businessObjectId,
            String objectType,
            int beginInterval,
            int endInterval) {

        String quary;
        //Vector parameters = new Vector();
        Vector<Row> queryResult = new Vector<Row>();

        Vector result = new Vector();
        /*parameters.add(new StringValue(wfTaskId));
        parameters.add(new IntValue(beginInterval));
        parameters.add(new IntValue(endInterval));*/

        quary = sqlMgr.getSql("getAllTaskComments").trim();


        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = null;
        
        PreparedStatement ps = null;

        try {
            connection = dataSource.getConnection();
            /*forQuery.setConnection(connection);
            forQuery.setSQLQuery(quary);
            forQuery.setparams(parameters);*/

            ps = connection.prepareStatement(quary);
            ps.setString(1, businessObjectId);
            ps.setString(2, objectType);
            ps.setInt(3, beginInterval);
            ps.setInt(4, endInterval);
            //"select tuc.ID,tuc.USECASE_ID, uc.NAME AS USECASE_NAME from TASK_USECASE tuc INNER JOIN USE_CASE uc ON tuc.USECASE_ID = uc.ID WHERE tuc.WF_TASK_ID = " + taskID);

            //select all task usecases by task id

            ResultSet res = ps.executeQuery();

            WebBusinessObject wbo = null;

            while (res.next()) {

                wbo = new WebBusinessObject();
                wbo.setAttribute("id", res.getString("ID"));
                wbo.setAttribute("business_obj_id", res.getString("business_obj_id"));
                wbo.setAttribute("object_type", res.getString("object_type"));
                wbo.setAttribute("descr", res.getString("DESCR"));
                wbo.setAttribute("creation_date", res.getString("CREATION_DATE"));
                wbo.setAttribute("created_by", res.getString("USER_NAME"));
                result.add(wbo);
            }


            //queryResult = forQuery.executeQuery();
            
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } /*catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } */finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        return result;
    }


    public long getTaskCommentsNumber(String businessObjectId,
            String objectType) {
        Connection connection = null;
        String quary;
        Vector parameters = new Vector();
        Vector<Row> rows  = new Vector<Row>();

        parameters.add(new StringValue(businessObjectId));
        parameters.add(new StringValue(objectType));

        quary = sqlMgr.getSql("selectTaskCommentsNumber").trim();

        SQLCommandBean command = new SQLCommandBean();
        try {
            connection = (Connection) dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(quary);
            command.setparams(parameters);

            rows = command.executeQuery();
            if (!rows.isEmpty()) {
                Row row = rows.get(0);
                String count = row.getString("TASK_COMMENTS_NUM");
                return Long.valueOf(count).longValue();
            }
        } catch (SQLException se) {
            System.out.print("SQL Exception  " + se.getMessage());
            logger.error("SQL Exception  " + se.getMessage());
        } catch (NoSuchColumnException se) {
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
        for (Row row : rows) {
            resultBusObjs.add(fabricateBusObj(row));
        }

        return 0;
    }
    
    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
    
}