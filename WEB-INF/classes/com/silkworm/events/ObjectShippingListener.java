/*
 * ObjectShippingListener.java
 *
 * Created on December 5, 2004, 7:31 AM
 */

package com.silkworm.events;

/**
 *
 * @author  Walid
 */
public interface ObjectShippingListener extends java.util.EventListener {
    
    public void objectShipped(ObjectShippingEvent ose);
}
