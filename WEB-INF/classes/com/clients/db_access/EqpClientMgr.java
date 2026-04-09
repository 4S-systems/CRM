/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.clients.db_access;


import com.silkworm.business_objects.BusinessForm;
import com.silkworm.business_objects.DOMFabricatorBean;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.SQLCommandBean;
import com.silkworm.persistence.relational.StringValue;
import com.silkworm.persistence.relational.UniqueIDGen;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Vector;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author Administrator
 */
public class EqpClientMgr extends RDBGateWay{

    public static EqpClientMgr eqpClientMgr = new EqpClientMgr();

    public static EqpClientMgr getInstance(){
        logger.info("Getting ERPDistNamesMgr Instance ....");
        return eqpClientMgr;
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
        if(supportedForm == null) {
            try {
                supportedForm  = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("eqp_client.xml")));
            } catch(Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }
    
     public boolean saveClient(String clientID , String equipmentID){
       Vector parameters =new Vector();
       String Id = UniqueIDGen.getNextID();
       parameters.addElement(new StringValue(Id));
       parameters.addElement(new StringValue(clientID));
       parameters.addElement(new StringValue(equipmentID));
       SQLCommandBean getInfo = new SQLCommandBean();
       int executeQuery =0;
       try{
       beginTransaction();
       getInfo.setConnection(transConnection);
       getInfo.setSQLQuery(getQuery("insertClientEqp").trim());
       getInfo.setparams(parameters);
       executeQuery = getInfo.executeUpdate();
       endTransaction();
         }catch(Exception e){
             logger.error("Could not Get Data");
         }
        return (executeQuery > 0) ;
    }
    @Override
    protected void initSupportedQueries() {
         queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
         ArrayList al = null;
         return al;
    }

}
