/*
 * DateAndTimeConstants.java
 *
 * Created on October 28, 2003, 11:09 AM
 */

package com.silkworm.util;

import java.util.*;
import java.util.ArrayList;
/**
 *
 * @author  walid
 */
public class DateAndTimeConstants {
    
    public static String[] months = {"January","February","March","April","May","June","July","August","September",
    "October","November","December"};
    
    public static ArrayList getYearList() {
        ArrayList years = new ArrayList();
        
        years.add("2004");
        years.add("2003");
        years.add("2002");
        years.add("2001");
        
        
        return years;
    }
    
    
    public static ArrayList getNumberSequenceListList(int limit) {
        ArrayList sequence = new ArrayList();
        Integer insert = null;
        int start = 0;
        
        if(limit==31)
            start++;
        
        for(int i = start;i<=limit;i++) {
            insert = new Integer(i);
            if(i<10) {
                sequence.add("0"+insert.toString());
            }
            else {
                sequence.add(insert.toString());
            }
        }
        
        
        return sequence;
    }

    
    public static ArrayList getMonthsList() {
        ArrayList months = new ArrayList();
        
        
        
        months.add("January");
        months.add("February");
        months.add("March");
        months.add("April");
        months.add("May");
        months.add("June");
        months.add("July");
        months.add("August");
        months.add("September");
        months.add("October");
        months.add("November");
        months.add("December");
        
        
        
        return months;
    }
    public static String getMonthAsNumberString(String month) {
        Integer monthRank = null;
        int i = 0;
        
        for(i = 0;i<months.length;i++) {
            if(months[i].equals(month)) {
                monthRank = new Integer(i);
                break;
            }
        }
        
        if(i<10)
            return "0" + monthRank.toString();
        else
            return monthRank.toString();
        
    }

    

    

}
