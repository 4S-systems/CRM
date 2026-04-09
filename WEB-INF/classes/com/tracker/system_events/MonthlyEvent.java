/*
 * MonthlyEvent.java
 *
 * Created on December 24, 2003, 11:25 PM
 */

package com.tracker.system_events;

/**
 *
 * @author  walid
 */

import com.maintenance.servlets.AverageUnitServlet;
import com.silkworm.system_events.*;
import com.silkworm.common.*;
import java.io.*;
import java.text.*;
import java.util.*;
import com.maintenance.servlets.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.omg.CORBA.Request;

public class MonthlyEvent implements  TimerListener{
    
   
  
     
    /** Creates a new instance of MonthlyEvent */
    int currentMonth,nextMonth;
    
    
    public MonthlyEvent() {
        Calendar calendar = Calendar.getInstance();
        currentMonth = calendar.get(Calendar.MONTH);
        System.out.println("Current Month is: " + currentMonth);
    }
    
     public void onTime (java.awt.event.ActionEvent event)
     {
        System.out.println("Monthly timer.............Waiting for month end");
        
        handleEvent();
        String i="1";
        
//        Calendar calendar = Calendar.getInstance();
//        int nextMonth = calendar.get(Calendar.MONTH);
//        
//        if(nextMonth==currentMonth)
//            return;
//        else
//        {
//         currentMonth=nextMonth;   
//         handleEvent();
//        }    
     } 
     
     public void handleEvent() {

         System.out.print("timer is working");
     }     
     
    
}
