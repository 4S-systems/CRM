/*
 * ViewOrigin.java
 *
 * Created on April 10, 2004, 9:22 AM
 */

package com.silkworm.business_objects;

/**
 *
 * @author  walid
 */
public abstract class ViewOrigin extends WebBusinessObject{
    
    /** Creates a new instance of ViewOrigin */
    
    protected String servletTrack = null;
    protected String filters = null;
    protected int numFilters = 1;
    
    public ViewOrigin(String servletTrack,String filters) {
        
        this.servletTrack = servletTrack; 
        this.filters = filters;
    }
    public abstract void  unpackageFilters();
    public abstract int getNumFilters();
    
    public String toString()
    {
     return  servletTrack;   
    }    
    
   
}
