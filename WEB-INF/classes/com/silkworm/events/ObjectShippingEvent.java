/*
 * ObjectShippingEvent.java
 *
 * Created on December 5, 2004, 7:28 AM
 */

package com.silkworm.events;

/**
 *
 * @author  Walid
 */
import com.silkworm.business_objects.*;

public class ObjectShippingEvent extends java.util.EventObject{
    
    /** Creates a new instance of ObjectShippingEvent */
    WebBusinessObject  subject = null;
    String intendedAction = null;
    public ObjectShippingEvent(Object source) {
        super(source);
    }
    
    public ObjectShippingEvent(Object source,WebBusinessObject eventSubject,String whatToDo) {
        super(source);
        subject = eventSubject;
        intendedAction = whatToDo;
    }
    
    public WebBusinessObject getEventSubject() {
        
        return null==subject?null:subject;
    }
    
    public String getIntendedAction()
    {
     return null==intendedAction?null:intendedAction;   
    }    
    
    
}
