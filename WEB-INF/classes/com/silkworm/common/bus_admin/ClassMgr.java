/*
 * AccountMgr.java
 *
 * Created on April 1, 2004, 8:19 AM
 */

package com.silkworm.common.bus_admin;




import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import com.silkworm.util.DictionaryItem;
import com.silkworm.util.*;
import java.util.*;
import java.text.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.sql.*;
import com.silkworm.util.*;

/**
 *
 * @author  walid
 */
public class ClassMgr extends RDBGateWay{
    
    /** Creates a new instance of AccountMgr */
    private static ClassMgr classMgr = new ClassMgr();
    
    private static final String insertUserSQL = "INSERT INTO CLASS VALUES (?,?,?,now())";
    
    public static  ClassMgr getInstance() {
        System.out.println("Getting UserMgr Instance ....");
        return classMgr  ;
    }
    
    public java.util.ArrayList getCashedTableAsArrayList() {
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        
        for(int i=0; i<cashedTable.size();i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            // System.out.println("my name is " + (String) wbo.getAttribute("userName"));
            cashedData.add((String) wbo.getAttribute("classTitle"));
        }
        
        return cashedData;
    }
    
    public boolean saveObject(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        
        if(wbo == null) {
            System.out.println("null object is passed");
        }
        else {
            System.out.println("the object is just fine");
        }
        
        
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        
        
        params.addElement(new StringValue((String)wbo.getAttribute("classTitle")));
        params.addElement(new StringValue((String)wbo.getAttribute("classDescription")));
        params.addElement(new StringValue((String)waUser.getAttribute("userId")));
        
        
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            
            forInsert.setConnection(connection);
            
            System.out.println(insertUserSQL);
            forInsert.setSQLQuery(insertUserSQL);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
           
            cashData();
            System.out.println("right insertion");
        }
        catch(SQLException se) {
            
            System.out.println("wronge insertion");
            return false;
        }
        
        return (queryResult > 0);
    }
    protected void initSupportedForm() {
        
        if(supportedForm == null) {
            try {
                System.out.println("IssueMgr ..***********.trying to get the XML file from path:: " +webInfPath);
                //supportedForm  = new BusinessForm(DOMFabricatorBean.getDocument(webInfPath + "\\xml\\class.xml"));
                supportedForm  = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("class.xml")));
            }
            catch(Exception e) {
                System.out.println("Could not locate XML Document for class Mgr");
            }
        }
        
    }
    
    public boolean saveObject(com.silkworm.business_objects.WebBusinessObject wbo) throws java.sql.SQLException {
        return false;
    }

    @Override
    protected void initSupportedQueries() {
      return; //  throw new UnsupportedOperationException("Not supported yet.");
    }
    
}
