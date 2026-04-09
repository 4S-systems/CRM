/*
 * BusinessObjectEventListener.java
 *
 * Created on December 13, 2004, 5:42 AM
 */

package com.silkworm.events;

/**
 *
 * @author  Walid
 */
public interface BusinessObjectEventListener extends java.util.EventListener {
    
    /** Creates a new instance of BusinessObjectEventListener */
   public abstract void businessObjectEvent(BusinessObjectEvent ose);
    
}
