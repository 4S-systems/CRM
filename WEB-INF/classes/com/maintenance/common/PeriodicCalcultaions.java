package com.maintenance.common;

import java.lang.*;
import java.sql.*;
import java.util.*;

public class PeriodicCalcultaions {
    
    public PeriodicCalcultaions() {
    }
    
    public Vector CalculteInterval(java.sql.Date beginDate, java.sql.Date endDate, int frequency, int frequencyType) {
        Vector intervalData = new Vector();
        Calendar beginCalendar = Calendar.getInstance();
        Calendar endCalendar = Calendar.getInstance();
        
        beginCalendar.clear();
        beginCalendar.setTimeInMillis(beginDate.getTime());
        
        endCalendar.clear();
        endCalendar.setTimeInMillis(endDate.getTime());
        
        if(frequency > 0){
            while(beginCalendar.compareTo(endCalendar)<0){
                Calendar savedCalendar = Calendar.getInstance();
                savedCalendar = (Calendar) beginCalendar.clone();
                intervalData.addElement(savedCalendar);
                
                if(frequencyType == 1) {
                    beginCalendar.add(beginCalendar.DATE, frequency);
                }
                
                if(frequencyType == 2) {
                    beginCalendar.add(beginCalendar.DATE, frequency*7);
                }
                
                if(frequencyType == 3) {
                    beginCalendar.add(beginCalendar.MONTH, frequency);
                }
                
                if(frequencyType == 4) {
                    beginCalendar.add(beginCalendar.YEAR, frequency);
                }
                
                if(frequencyType == 5) {
                    beginCalendar.add(beginCalendar.DATE, frequency);
                }
                
            }
        } 
        
        return (intervalData);
    }
    
}
