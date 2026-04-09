/*
 * TimeServices.java
 *
 * Created on December 25, 2003, 9:45 AM
 */

package com.silkworm.common;

/**
 *
 * @author  walid
 */
import java.sql.*;
import javax.sql.*;
import java.util.*;
import java.text.*;

public class TimeServices {
    
    /** Creates a new instance of TimeServices */
    
    
    private static Calendar calendar = Calendar.getInstance();
    //   private static java.util.Date today = calendar.getTime();
    private static String months[] = {
        "January", "February", "March",
        "April",   "May",      "June",
        "July",    "August",   "September",
        "October", "November", "December" };
        
        public TimeServices() {
        }
        
        public static String getCurrentMonth() {
            
            return months[calendar.get(Calendar.MONTH)];
        }
        public static String getCurrentYear() {
            Integer year = new Integer(calendar.get(Calendar.YEAR));
            return year.toString();
        }
        
        public static String getCurrentDay() {
            Integer day = new Integer(calendar.get(Calendar.DAY_OF_MONTH));
            String cDay = day.toString();
            if(cDay.length()==1)
                cDay = "0" + cDay;
            
            return cDay;
        }
        
        public static String getCurrentHour() {
            Integer hour = new Integer(calendar.get(Calendar.HOUR));
            return hour.toString();
        }
        public static String getCurrentMinute() {
            Integer minute = new Integer(calendar.get(Calendar.MINUTE));
            return minute.toString();
            
        }
        
        public static String getYesterday() {
            Integer day = new Integer(calendar.get(Calendar.DAY_OF_MONTH));
            int x = day.intValue();
            x--;
            day = new Integer(x);
            return day.toString();
        }
        public static java.sql.Timestamp toTimestamp(String[] multipleValue) {
            
            Calendar c = Calendar.getInstance();
            DateFormat df_us = DateFormat.getDateTimeInstance(DateFormat.MEDIUM, DateFormat.MEDIUM,  new Locale("en", "US"));
            c.set(stringTo_int(multipleValue[0]),stringTo_int(multipleValue[1]),stringTo_int(multipleValue[2]),
            stringTo_int(multipleValue[3]),stringTo_int(multipleValue[4]),stringTo_int(multipleValue[5]));
            java.util.Date d = c.getTime();
            
            long dateAslong = c.getTimeInMillis();
            return new java.sql.Timestamp(dateAslong);
            
        }
        
        private static int stringTo_int(String s) {
            Integer bigInt = new Integer(s);
            return bigInt.intValue();
            
        }
        
         public static java.sql.Date toDate(String[] multipleValue) {
            
            Calendar c = Calendar.getInstance();
            DateFormat df_us = DateFormat.getDateTimeInstance(DateFormat.MEDIUM, DateFormat.MEDIUM,  new Locale("en", "US"));
            c.set(stringTo_int(multipleValue[0]),stringTo_int(multipleValue[1]),stringTo_int(multipleValue[2]),
            stringTo_int(multipleValue[3]),stringTo_int(multipleValue[4]),stringTo_int(multipleValue[5]));
            java.util.Date d = c.getTime();
            
            long dateAslong = c.getTimeInMillis();
            return new java.sql.Date(dateAslong);
            
        }
         
       public static String getDateAsLongString( String[] multipleValue)
       {
             Calendar c = Calendar.getInstance();
            DateFormat df_us = DateFormat.getDateTimeInstance(DateFormat.MEDIUM, DateFormat.MEDIUM,  new Locale("en", "US"));
            c.set(stringTo_int(multipleValue[0]),stringTo_int(multipleValue[1]),stringTo_int(multipleValue[2]),
            stringTo_int(multipleValue[3]),stringTo_int(multipleValue[4]),stringTo_int(multipleValue[5]));
            java.util.Date d = c.getTime();
            
            long dateAslong = c.getTimeInMillis(); 
           Long midway = new Long(dateAslong);
           
           return midway.toString();
       }
       
       public static void setDate(String sDate) {
           java.sql.Date dTemp = new java.sql.Date(10000);
           java.sql.Date dDate = null;
           if(sDate.length() > 10)
           {
               sDate = sDate.substring(0, 9);
           }
           dDate = dTemp.valueOf(sDate);
           calendar.setTime(dDate);
        }
       
       public static void setDate(long lDate) {
           calendar.setTimeInMillis(lDate);
        }
       
       public static long getDate() {
           return calendar.getTimeInMillis();
       }
        
}