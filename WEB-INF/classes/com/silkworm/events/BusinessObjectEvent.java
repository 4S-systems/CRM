/*
 * ObjectInsertedEvent.java
 *
 * Created on December 13, 2004, 5:01 AM
 */

package com.silkworm.events;

/**
 *
 * @author  Walid
 */


import com.silkworm.business_objects.*;

public class BusinessObjectEvent extends java.util.EventObject{
    
    /** Creates a new instance of ObjectInsertedEvent */
    
    private  WebBusinessObject  subject = null;
    private String intendedAction = null;
    private String eventName = null;
    
    public BusinessObjectEvent(Object source) {
        super(source);
    }
    
    public BusinessObjectEvent(Object source,WebBusinessObject eventSubject,String eventName) {
        super(source);
        subject = eventSubject;
        this.eventName = eventName;
    }
    
    
    public WebBusinessObject getEventSubject() {
        
        return null==subject?null:subject;
    }
    
    public String getIntendedAction() {
        return null==intendedAction?null:intendedAction;
    }
    
    public String getEventName() {
        return null==eventName?null:eventName;
        
    }
    
}
