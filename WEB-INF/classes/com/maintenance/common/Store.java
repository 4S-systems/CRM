/*
 * Store.java
 *
 * Created on May 20, 2009, 12:06 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.maintenance.common;

/**
 *
 * @author Administrator
 */
public class Store {
    
    /** Creates a new instance of Store */
    
    public  String id=null;
    public  String name=null;
    public  String isDefult=null;
    
    public Store(String sid,String sName,String sIsDefult) {
        id=sid;
        name=sName;
        isDefult=sIsDefult;
    }
    
}
