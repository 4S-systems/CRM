/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.unit.db_access;

import com.silkworm.Exceptions.NoUserInSessionException;
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
import com.tracker.common.ProjectConstants;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Vector;
import javax.servlet.http.HttpSession;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author walid
 */
public class ArchDetailsMgr extends RDBGateWay{
 private static ArchDetailsMgr archDetailsMgr = new ArchDetailsMgr();
  SqlMgr sqlMgr = SqlMgr.getInstance();
 
  public static ArchDetailsMgr getInstance() {
        logger.info("Getting ArchDetailsMgr Instance ....");
        return archDetailsMgr;
    }
  
    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }

    public boolean saveObject(WebBusinessObject project, HttpSession s) throws NoUserInSessionException {
         WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");

        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        String unitId = UniqueIDGen.getNextID();
        project.setAttribute("modelID", unitId);
        params.addElement(new StringValue(unitId));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.PROJECT_NAME)));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.EQ_NO)));
        params.addElement(new StringValue((String) waUser.getAttribute("userId")));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.PROJECT_DESC)));

        String mainProjectId = null;
        try {
            mainProjectId = project.getAttribute("mainProjectId").toString();
        } catch (NullPointerException e) {
            mainProjectId = "0";
        }
        params.addElement(new StringValue(mainProjectId));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.LOCATION_TYPE)));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.FUTILE)));
//        params.addElement(new StringValue(project.getAttribute("coordinate").toString()));
        params.addElement(new StringValue("UL"));
//        params.addElement(new StringValue(project.getAttribute("option_one").toString()));
        params.addElement(new StringValue("UL"));
//        params.addElement(new StringValue(project.getAttribute("option_two").toString()));
        params.addElement(new StringValue("UL"));
//        params.addElement(new StringValue(project.getAttribute("option_three").toString()));
        params.addElement(new StringValue("UL"));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.IS_TRNSPRT_STN)));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.IS_MNGMNT_STN)));

        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
            forInsert.setSQLQuery(getQuery("insertProject").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            //
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
            cashData();

            params = new Vector();
            
            String issueStatusId = UniqueIDGen.getNextID();
            params.addElement(new StringValue(issueStatusId));
            // 1 mean received from Issue // 2 mean sent from complaint //
            params.addElement(new StringValue("8"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("0"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue(unitId));//clientCompId--business-comp-id
            params.addElement(new StringValue("Housing_Units"));
            params.addElement(new StringValue("0"));//issueId--parent id
            params.addElement(new StringValue((String) waUser.getAttribute("userId")));

            forInsert.setSQLQuery(sqlMgr.getSql("saveCompStatus").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();

            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
            params = new Vector();
            
            params.addElement(new StringValue(unitId));
            params.addElement(new StringValue((String) project.getAttribute("category")));
            params.addElement(new StringValue((String) waUser.getAttribute("userId")));
            params.addElement(new StringValue((String) project.getAttribute("rooms_no")));
            params.addElement(new StringValue((String) project.getAttribute("kitchens_no")));
            params.addElement(new StringValue((String) project.getAttribute("pathroom_no")));
            params.addElement(new StringValue((String) project.getAttribute("balcony_no")));
            params.addElement(new StringValue((String) project.getAttribute("total_area")));
            params.addElement(new StringValue((String) project.getAttribute("net_area")));
            params.addElement(new StringValue((String) project.getAttribute("garage")));
            params.addElement(new StringValue((String) project.getAttribute("elevator")));
            params.addElement(new StringValue((String) project.getAttribute("storage")));
            params.addElement(new StringValue((String) project.getAttribute("club")));
            params.addElement(new StringValue((String) project.getAttribute("min_price")));
            params.addElement(new StringValue((String) project.getAttribute("max_price")));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
             queryResult = -1000 ;  
             
            forInsert.setSQLQuery(getQuery("insertData").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
            
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();
        }

        return (queryResult > 0);
    }
    public boolean updateObject(WebBusinessObject project, HttpSession s) throws NoUserInSessionException {
         WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String unitId = (String) project.getAttribute("projectID");
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.PROJECT_NAME)));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.EQ_NO)));
        params.addElement(new StringValue((String) project.getAttribute(ProjectConstants.PROJECT_DESC)));
        params.addElement(new StringValue(unitId)); 

        try {
            beginTransaction();
            forInsert.setConnection(transConnection);
//            String query = null;
//            query= getQuery("updateProject").trim() ; 
            forInsert.setSQLQuery("UPDATE PROJECT SET PROJECT_NAME=?,EQ_NO =?,PROJECT_DESCRIPTION =? where PROJECT_ID=?");
//            forInsert.setSQLQuery(getQuery("updateProject").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            // 
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
            cashData();
            params = new Vector();
            
            params.addElement(new StringValue((String) project.getAttribute("category")));
            params.addElement(new StringValue((String) project.getAttribute("rooms_no")));
            params.addElement(new StringValue((String) project.getAttribute("kitchens_no")));
            params.addElement(new StringValue((String) project.getAttribute("pathroom_no")));
            params.addElement(new StringValue((String) project.getAttribute("balcony_no")));
            params.addElement(new StringValue((String) project.getAttribute("total_area")));
            params.addElement(new StringValue((String) project.getAttribute("net_area")));
            params.addElement(new StringValue((String) project.getAttribute("garage")));
            params.addElement(new StringValue((String) project.getAttribute("elevator")));
            params.addElement(new StringValue((String) project.getAttribute("storage")));
            params.addElement(new StringValue((String) project.getAttribute("club")));
            params.addElement(new StringValue((String) project.getAttribute("min_price")));
            params.addElement(new StringValue((String) project.getAttribute("max_price")));
            params.addElement(new StringValue(unitId));
             queryResult = -1000 ;  
             
            forInsert.setSQLQuery(getQuery("updateData").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            
            if (queryResult < 0) {
                transConnection.rollback();
                return false;
            }
            
            if(queryResult == 0){
                
            params = new Vector();
            params.addElement(new StringValue(unitId));
            params.addElement(new StringValue((String) project.getAttribute("category")));
            params.addElement(new StringValue((String) waUser.getAttribute("userId")));
            params.addElement(new StringValue((String) project.getAttribute("rooms_no")));
            params.addElement(new StringValue((String) project.getAttribute("kitchens_no")));
            params.addElement(new StringValue((String) project.getAttribute("pathroom_no")));
            params.addElement(new StringValue((String) project.getAttribute("balcony_no")));
            params.addElement(new StringValue((String) project.getAttribute("total_area")));
            params.addElement(new StringValue((String) project.getAttribute("net_area")));
            params.addElement(new StringValue((String) project.getAttribute("garage")));
            params.addElement(new StringValue((String) project.getAttribute("elevator")));
            params.addElement(new StringValue((String) project.getAttribute("storage")));
            params.addElement(new StringValue((String) project.getAttribute("club")));
            params.addElement(new StringValue((String) project.getAttribute("min_price")));
            params.addElement(new StringValue((String) project.getAttribute("max_price")));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
            params.addElement(new StringValue("UL"));
             queryResult = -1000 ;  
             
            forInsert.setSQLQuery(getQuery("insertData").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
                
            }
            
        } catch (SQLException se) {
            logger.error(se.getMessage());
            return false;
        } finally {
            endTransaction();
        }

        return (queryResult > 0);
    }

    
    @Override
    protected void initSupportedForm() {
    if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("arch_detail.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
}
