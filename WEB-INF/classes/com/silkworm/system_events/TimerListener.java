/*
 *                 Sun Public License Notice
 * 
 * The contents of this file are subject to the Sun Public License
 * Version 1.0 (the "License"). You may not use this file except in
 * compliance with the License. A copy of the License is available at
 * http://www.sun.com/
 */

package com.silkworm.system_events;

/** The TimerListener interface must be implemented by
* a class that wants to be notified about time events.
*
* @version  1.00, Jul 20, 1998
*/
public interface TimerListener extends java.util.EventListener {

    /** Called when a new timer event occurs */
    public void onTime (java.awt.event.ActionEvent event);
    

}
