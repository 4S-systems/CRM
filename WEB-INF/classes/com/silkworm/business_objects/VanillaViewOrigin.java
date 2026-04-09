/*
 * VanillaViewOrigin.java
 *
 * Created on April 10, 2004, 9:39 AM
 */

package com.silkworm.business_objects;

/**
 *
 * @author  walid
 */
public class VanillaViewOrigin extends ViewOrigin{
    
    /** Creates a new instance of VanillaViewOrigin */
    public VanillaViewOrigin(String servletTrack,String filters) {
        super(servletTrack,filters);
    }
    
    public int getNumFilters() {
        return numFilters;
    }
    
    public void unpackageFilters() {
    }
    
    public String toString()
    {
        
     return "&filterSize=" + getNumFilters() + "&filter=" + servletTrack + "&filterValue1=" + filters;   
    }    
}
