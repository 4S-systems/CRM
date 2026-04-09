
package com.silkworm.persistence.relational;

import java.util.*;
import java.sql.*;
import javax.sql.*;
import com.silkworm.business_objects.*;
import java.lang.reflect.*;
import com.silkworm.common.MetaDataMgr;

import com.silkworm.events.*;

/**
 *
 * @author  yasmin abbass
 */

public abstract class SwingRDBGateway {
    
    protected static DataSource dataSource;
    protected BusinessForm supportedForm = null;
    protected Vector cashedTable = null;
    
    protected MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
    private Vector dataUpdatedListeners = new Vector();
    protected Vector businessObjectEventListeners = new Vector();
    
    
    
    protected SwingRDBGateway() {
    }
    
    public abstract boolean saveObject(WebBusinessObject wbo) throws SQLException;
    public abstract boolean updateObject(WebBusinessObject wbo) throws SQLException;
    public abstract boolean deletObject(WebBusinessObject wbo) throws SQLException;
    
    public void setDataSource(DataSource ds) {
        System.out.println("Mgr: " + this.getClass().getName() + "  initializing... ");
        dataSource = ds;
        
        
        System.out.println("initializing supported form ...");
        initSupportedForm();
        
    }
    
    protected abstract void initSupportedForm();
    
    protected WebBusinessObject fabricateBusObj(Row r) {
        
        ListIterator li = supportedForm.getFormElemnts().listIterator();
        FormElement fe = null;
        Hashtable ht = new Hashtable();
        String colName;
        
        while(li.hasNext()) {
            
            try {
                fe = (FormElement) li.next();
                colName = (String) fe.getAttribute("column");
                // needs a case ......
                ht.put(fe.getAttribute("name"),r.getString(colName));
            }
            catch(Exception e) {
                // raise an exception
                
            }
            
        }
        WebBusinessObject wbo = new WebBusinessObject(ht);
        // wbo.printSelf();
        
        return wbo;
    }
    
    
    protected Vector getAllTableRaws() throws SQLException,Exception {
        Vector SQLparams = new  Vector();
        
        
        StringBuffer dq = new StringBuffer("SELECT * FROM ");
        dq.append(supportedForm.getTableSupported().getAttribute("name"));
        
        
        String theQuery = dq.substring(0,(dq.length()));
        
        System.out.println("Query for cashing table " + theQuery);
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        Connection connection = dataSource.getConnection();
        try {
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(theQuery);
            // no params here forQuery.setparams(SQLparams);
            queryResult = forQuery.executeQuery();
        }
        catch(SQLException se) {
            System.out.println(se.getMessage());
            throw se;
        }
        catch(UnsupportedTypeException uste) {
            System.out.println(uste.getMessage());
        }
        finally {
            connection.close();
        }
        
        // process the vector
        // vector of business objects
        Vector reultBusObjs = new Vector();
        
        Row r = null;
        Enumeration e = queryResult.elements();
        
        while(e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObjs.add(fabricateBusObj(r));
        }
        
        return reultBusObjs;
    }
    
    public void  cashData() {
        try {
            cashedTable = getAllTableRaws();
        }
        catch(SQLException se) {
            System.out.println(se.getMessage());
        }
        catch(Exception e) {
            System.out.println(e.getMessage());
        }
        
        
        
    }
    
    public Vector getCashedTable(){
        return cashedTable;
    }
    
    // add a temperature change listener
    public synchronized void addDataUpdatedListener(DataUpdatedListener dul) {
        // add a listener if it is not already registered
        if (!dataUpdatedListeners.contains(dul)) {
            dataUpdatedListeners.addElement(dul);
        }
    }
    
    // remove a temperature change listener
    public synchronized void removeDataUpdatedListener(DataUpdatedListener dul) {
        // remove it if it is registered
        if (dataUpdatedListeners.contains(dul)) {
            dataUpdatedListeners.removeElement(dul);
        }
    }
    
    
      public synchronized void addObjectEventListener(BusinessObjectEventListener oel) {
        // add a listener if it is not already registered
        if (!businessObjectEventListeners.contains(oel)) {
            businessObjectEventListeners.addElement(oel);
        }
    }
    
    // remove a temperature change listener
    public synchronized void removeObjectEventListener(BusinessObjectEventListener oel) {
        // remove it if it is registered
        if (businessObjectEventListeners.contains(oel)) {
            businessObjectEventListeners.removeElement(oel);
        }
    }
    
       
    // notify listening objects of database changes
    protected void notifyDataUpdated() {
        // create the event object
        // java.util.EventObject eo = new  java.util.EventObject("");
        
        DataUpdatedEvent evt = new DataUpdatedEvent("");
        
        // make a copy of the listener object vector so that it cannot
        // be changed while we are firing events
        Vector v;
        synchronized(this) {
            v = (Vector) dataUpdatedListeners.clone();
        }
        
        // fire the event to all listeners
        int cnt = v.size();
        for (int i = 0; i < cnt; i++) {
            DataUpdatedListener client = (DataUpdatedListener)v.elementAt(i);
            client.dataUpdated();
        }
    }
    
    protected abstract void notifyBusinessObjectEvent(WebBusinessObject subject,String eventName); 
    
    public WebBusinessObject getOnSingleKey(String key) {
        
        Connection connection = null;
        
        StringBuffer query = new StringBuffer("SELECT * FROM ");
        query.append(supportedForm.getTableSupported().getAttribute("name"));
        query.append(" WHERE ");
        query.append(supportedForm.getTableSupported().getAttribute("key"));
        query.append(" = ?");
        
        System.out.println(" query :" + query);
        System.out.println(key);
        
        
        Vector SQLparams = new Vector();
        
        
        SQLparams.addElement(new StringValue(key));
        
        Vector queryResult = null;
        SQLCommandBean forQuery = new SQLCommandBean();
        
        try {
            connection= dataSource.getConnection();
            forQuery.setConnection(connection);
            forQuery.setSQLQuery(query.toString());
            forQuery.setparams(SQLparams);
            
            queryResult = forQuery.executeQuery();
            
        }
        catch(SQLException se) {
            System.out.println("troubles closing connection " + se.getMessage());
            return null;
        }
        
        catch(UnsupportedTypeException uste) {
            System.out.println("***** " + uste.getMessage());
            return null;
        }
        finally {
            try {
                connection.close();
            }
            catch(SQLException sex) {
                System.out.println("troubles closing connection " + sex.getMessage());
                return null;
            }
        }
        
        WebBusinessObject reultBusObj = null;
        
        Row r = null;
        Enumeration e = queryResult.elements();
        
        while(e.hasMoreElements()) {
            r = (Row) e.nextElement();
            reultBusObj = fabricateBusObj(r);
        }
        
        
        return reultBusObj;
        
    }
    
}
