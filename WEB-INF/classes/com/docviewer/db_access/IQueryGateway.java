/*
 * IQueryGateway.java
 *
 * Created on May 9, 2004, 8:15 PM
 */

package com.docviewer.db_access;

import com.silkworm.business_objects.WebBusinessObject;

/**
 *
 * @author  walid
 */
public interface IQueryGateway {
    
    /** Creates a new instance of IQueryGateway */
   public String getListAllQuery();
   public String getListOnLikeQuery(String keyValue);
 
    
}
