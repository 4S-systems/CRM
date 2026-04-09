package com.routing;

import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.http.HttpSession;
import java.sql.*;

public class MailGroupMgr extends RDBGateWay{
    
    /** Creates a new instance of GroupMgr */
    private static MailGroupMgr mailGroupMgr = new MailGroupMgr();
    SqlMgr sqlMgr = SqlMgr.getInstance();
    String generatedGroupId=null;
//    private static final String insertGroupSQL = "INSERT INTO TRACKER_GROUP VALUES (?,?,?,?,?,now(),'Update_Later')";
  
    
    public static MailGroupMgr getInstance() {
       
        return mailGroupMgr;
    }
    
    public MailGroupMgr() {
    }
    
    
    
    protected void initSupportedForm() {
        if(supportedForm == null) {
            try {
                System.out.println("IssueMgr ..***********.trying to get the group.XML file from path:: " +webInfPath);
             //   supportedForm  = new BusinessForm(DOMFabricatorBean.getDocument(webInfPath + "\\xml\\group.xml"));
                supportedForm  = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("mail_group.xml")));
            }
            catch(Exception e) {
                System.out.println("Could not locate XML Document");
            }
        }
    }
    
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        return false;
    }
    
    public boolean saveMailGroup(WebBusinessObject wbo, HttpSession s) throws NoUserInSessionException {
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        // waUser.printSelf();
        wbo.printSelf();
        
        if(wbo == null) {
            System.out.println("null object is passed");
        }
        else {
            System.out.println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! the object is just fine");
        }
        
        
        Vector params = new Vector();
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        setGroupID();
        params.addElement(new StringValue(getGroupID()));
        params.addElement(new StringValue((String)wbo.getAttribute("name")));
        params.addElement(new StringValue((String)wbo.getAttribute("code")));
        params.addElement(new StringValue((String)wbo.getAttribute("private")));
        params.addElement(new StringValue((String)waUser.getAttribute("userId")));
        
        System.out.println("print params");
//        for(int i=0;i<params.size();i++)
//            System.out.println(params.elementAt(i).toString());
        //
        Connection connection = null;
        try {
            connection = dataSource.getConnection();
            forInsert.setConnection(connection);
            // System.out.println(insertGroupSQL);
            forInsert.setSQLQuery(getQuery("insertMailGroup").trim());
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            cashData();
            System.out.println("right insertion");
        }
        catch(SQLException se) {
            System.out.println("Exception inserting group: " + se.getMessage());
            return false;
        }
        finally {
            try {
                connection.close();
            }
            catch(SQLException ex) {
                System.out.println("Close Error");
                return false;
            }
        }
        if(queryResult > 0){
           s.setAttribute("mailGroupId", getGroupID());
           s.setAttribute("mailGroupName", wbo.getAttribute("name"));
        }
        return (queryResult > 0);
    }
    
     private void setGroupID() {
        generatedGroupId = UniqueIDGen.getNextID();
    }
    
    private String getGroupID() {
        return generatedGroupId;
    }
    
    public ArrayList getCashedTableAsArrayList() {
        
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        
        for(int i=0; i<cashedTable.size();i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            System.out.println("my name is " + (String) wbo.getAttribute("groupName"));
            cashedData.add((String) wbo.getAttribute("groupName"));
        }
        
        return cashedData;
    }
    
    
    public ArrayList getCashedTableAsBusObjects() {
        
        cashedData = new ArrayList();
        WebBusinessObject wbo = null;
        
        for(int i=0; i<cashedTable.size();i++) {
            wbo = (WebBusinessObject) cashedTable.elementAt(i);
            // System.out.println("my name is " + (String) wbo.getAttribute("groupName"));
            wbo.setObjectKey((String) wbo.getAttribute("groupName"));
            cashedData.add(wbo);
        }
        
        return cashedData;
    }

    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
    return;//    throw new UnsupportedOperationException("Not supported yet.");
    }
    
   
    
}
