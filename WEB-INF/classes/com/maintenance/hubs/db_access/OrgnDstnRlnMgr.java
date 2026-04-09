/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.hubs.db_access;

import com.maintenance.common.DateParser;
import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.SqlMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.DateValue;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Vector;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author khaled abdo
 */
public class OrgnDstnRlnMgr extends RDBGateWay {

    private static OrgnDstnRlnMgr orgnDstnRlnMgr = new OrgnDstnRlnMgr();

    SqlMgr sqlMgr = SqlMgr.getInstance();
    //constractore
    public OrgnDstnRlnMgr() {
    }

    //get instance
    public static OrgnDstnRlnMgr getInstance(){
        return orgnDstnRlnMgr;
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    protected void initSupportedForm() {
        if(webInfPath != null){
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("orgn_dstn_rln.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
       
         return;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    //all my functions
    public boolean saveSiteRelation(WebBusinessObject wbo) {

        DateParser parser = new DateParser();
        String startDate = (String) wbo.getAttribute("beginDate");
        String endDate = (String) wbo.getAttribute("endDate");
        java.sql.Date sqlStartDate, sqlEndDate;
        sqlStartDate = parser.formatSqlDate(startDate);
        sqlEndDate = parser.formatSqlDate(endDate);

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(UniqueIDGen.getNextID()));
        SQLparams.addElement(new StringValue(wbo.getAttribute("siteOne").toString()));
        SQLparams.addElement(new StringValue(wbo.getAttribute("siteTwo").toString()));
        SQLparams.addElement(new StringValue(wbo.getAttribute("cost").toString()));
        SQLparams.addElement(new StringValue(wbo.getAttribute("distance").toString()));
        SQLparams.addElement(new StringValue(wbo.getAttribute("access").toString()));
        SQLparams.addElement(new StringValue("1"));
        SQLparams.addElement(new DateValue(sqlStartDate));
        SQLparams.addElement(new DateValue(sqlEndDate));

        boolean queryResult = false;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(getQuery("saveSiteRelation").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.execute();

            endTransaction();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {
            
        }
       return queryResult;
  }

    //all my functions
    public String addProjectsRelation(WebBusinessObject wbo) {

       DateParser parser = new DateParser();
        String startDate = (String) wbo.getAttribute("beginDate");
        String endDate = (String) wbo.getAttribute("endDate");
        java.sql.Date sqlStartDate, sqlEndDate;
        sqlStartDate = parser.formatSqlDate(startDate);
        sqlEndDate = parser.formatSqlDate(endDate);

        String id = UniqueIDGen.getNextID();
        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(id));
        SQLparams.addElement(new StringValue(wbo.getAttribute("siteOne").toString()));
        SQLparams.addElement(new StringValue(wbo.getAttribute("siteTwo").toString()));
        SQLparams.addElement(new StringValue(wbo.getAttribute("cost").toString()));
        SQLparams.addElement(new StringValue(wbo.getAttribute("distance").toString()));
        SQLparams.addElement(new StringValue(wbo.getAttribute("access").toString()));
        SQLparams.addElement(new StringValue("1"));
        SQLparams.addElement(new DateValue(sqlStartDate));
        SQLparams.addElement(new DateValue(sqlEndDate));


        int queryResult = -1000;
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(getQuery("saveSiteRelation").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeUpdate();

            endTransaction();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {

        }
       if(queryResult > 0)
           return id;
       else
           return "";
  }

  public Vector getTwoProjectsRelation(String projOne, String projTwo){
      Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(projOne));
        SQLparams.addElement(new StringValue(projTwo));

        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(getQuery("getTwoProjectsRelation").trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();

            endTransaction();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {

        }

        Vector resultBusObj = null;
        Enumeration e = queryResult.elements();
        WebBusinessObject wbo = new WebBusinessObject();
        Row r = null;
        while (e.hasMoreElements()) {
          r = (Row) e.nextElement();
          wbo = fabricateBusObj(r);
          resultBusObj.add(wbo);
      }
       return resultBusObj;
  }

    public Vector getDistinctProjectsTwo(){

        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(getQuery("getDistinctProjectsTwo").trim());
            queryResult = forQuery.executeQuery();

            endTransaction();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {

        }

        Vector resultBusObj = new Vector();
        Enumeration e = queryResult.elements();
        WebBusinessObject wbo = new WebBusinessObject();
        Row r = null;
        while (e.hasMoreElements()) {
          r = (Row) e.nextElement();
          wbo = fabricateBusObj(r);
          resultBusObj.add(wbo);
      }
       return resultBusObj;
  }


  //all my functions
    public boolean updateProjectsRelation(WebBusinessObject wbo) {

        Vector SQLparams = new Vector();
        String saveType = wbo.getAttribute("type").toString();
        String value = wbo.getAttribute("value").toString();
        SQLparams.addElement(new StringValue(value));
        SQLparams.addElement(new StringValue(wbo.getAttribute("id").toString()));

        int queryResult = -1000;
        SQLCommandBean forQuery = new SQLCommandBean();

        String query = "";

        if(saveType.equalsIgnoreCase("dist")){
            query = "updateProjectsDist";
        } else if(saveType.equalsIgnoreCase("cost")){
            query = "updateProjectsCost";
        } else if(saveType.equalsIgnoreCase("access")){
            if(value.equals("0")){
                query = "updateDelProjectsAccess";
            } else {
                query = "updateProjectsAccess";
            }
        }

        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(getQuery(query).trim());
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeUpdate();

            endTransaction();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {

        }
       return (queryResult > 0);
  }

    //all my functions
    public boolean updateProjRelations(WebBusinessObject wbo) throws ParseException {

        DateParser parser = new DateParser();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-mm-dd");
        String startDate = (String) wbo.getAttribute("beginDate");
        String endDate = (String) wbo.getAttribute("endDate");
        java.sql.Date sqlStartDate, sqlEndDate;
        sqlStartDate = parser.formatSqlDate(startDate);
        sqlEndDate = parser.formatSqlDate(endDate);

        startDate = sdf.format(sqlStartDate);
        endDate = sdf.format(sqlEndDate);

        Vector SQLparams = new Vector();
        SQLparams.addElement(new StringValue(wbo.getAttribute("cost").toString()));
        SQLparams.addElement(new StringValue(wbo.getAttribute("distance").toString()));
        SQLparams.addElement(new StringValue(wbo.getAttribute("access").toString()));
        SQLparams.addElement(new DateValue(sqlStartDate));
        SQLparams.addElement(new DateValue(sqlEndDate));
        SQLparams.addElement(new StringValue(wbo.getAttribute("id").toString()));
        int queryResult = -1000;
        SQLCommandBean forQuery = new SQLCommandBean();
        String query = getQuery("updateProjRelations").trim();

        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(query);
            forQuery.setparams(SQLparams);
            queryResult = forQuery.executeUpdate();

            endTransaction();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {

        }
       return (queryResult > 0);
  }

    public Vector getAllProjectsRelations(){

        Vector queryResult = new Vector();
        SQLCommandBean forQuery = new SQLCommandBean();

        try {
            beginTransaction();
            forQuery.setConnection(transConnection);
            forQuery.setSQLQuery(getQuery("getAllProjectsRelations").trim());
            queryResult = forQuery.executeQuery();

            endTransaction();
        } catch (SQLException se) {
            logger.error("SQL Exception  " + se.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } catch (Exception exception) {
            logger.error("An exception has been thrown " + exception.getMessage());
        } finally {

        }

        Vector resultBusObj = new Vector();
        Enumeration e = queryResult.elements();
        WebBusinessObject wbo = new WebBusinessObject();
        Row r = null;
        while (e.hasMoreElements()) {
          r = (Row) e.nextElement();
          wbo = fabricateBusObj(r);
          resultBusObj.add(wbo);
      }
       return resultBusObj;
  }

}
