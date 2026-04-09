/*
 * SQLTimeInterval.java
 *
 * Created on February 18, 2004, 1:40 AM
 */

package com.silkworm.common;

/**
 *
 * @author  walid
 */
import java.text.*;
import java.util.*;
import javax.servlet.http.HttpServletRequest;
import com.silkworm.util.*;

public class SQLTimeInterval {
    
    /** Creates a new instance of SQLTimeInterval */
    
    private java.sql.Timestamp fromDate = null;
    private java.sql.Timestamp toDate = null;
    private HttpServletRequest timeBoundRequest = null;
    
    private static String FROM_ONLY = "FROM_ONLY";
    
    public SQLTimeInterval() {
    }
    public SQLTimeInterval(HttpServletRequest r,String fromOnly) {
        
        System.out.println("building date .......");
        timeBoundRequest = r;
        
        if(fromOnly.equalsIgnoreCase(FROM_ONLY))
        {
               System.out.println("building date ......2.");
            buildFromDate();
            
        }    
        
    }
    
    public boolean isOpenEnded() {
        return false;
    }
    
    public java.sql.Timestamp getFromDate() {
        return fromDate;
    }
    
    public java.sql.Timestamp getToDate() {
        return toDate;
    }
    
    
    private long fabricateSQLTimeStamp(String[] multipleValue) {
        Calendar c = Calendar.getInstance();
        DateFormat df_us = DateFormat.getDateTimeInstance(DateFormat.MEDIUM, DateFormat.MEDIUM,  new Locale("en", "US"));
        c.set(stringTo_int(multipleValue[0]),stringTo_int(multipleValue[1]),stringTo_int(multipleValue[2]),
        stringTo_int(multipleValue[3]),stringTo_int(multipleValue[4]),stringTo_int(multipleValue[5]));
        java.util.Date d = c.getTime();
        System.out.println("Date d for US is " + df_us.format(d));
        
        long dateAslong = c.getTimeInMillis();
        return dateAslong;
    }
    
    private int stringTo_int(String s) {
        Integer bigInt = new Integer(s);
        return bigInt.intValue();
    }
    private void buildFromDate() {
        
        String[] timeStamp = new String[6];
        String startMonth = (String) timeBoundRequest.getParameter("startMonth");
        startMonth = new String(DateAndTimeConstants.getMonthAsNumberString(startMonth));
        //System.out.println("" + startMonth);
        
        timeStamp[0] = new String((String) timeBoundRequest.getParameter("startYear"));
        timeStamp[1] = new String(startMonth);
        timeStamp[2] = new String((String) timeBoundRequest.getParameter("startDay"));
        timeStamp[3] = new String("00");
        timeStamp[4] = new String("00");
        timeStamp[5] = new String("00");
        
        fromDate = new java.sql.Timestamp(fabricateSQLTimeStamp(timeStamp));
        
        
    }
    
    private void buildToDate() {
        
        String endMonth = (String) timeBoundRequest.getParameter("endMonth");
        endMonth = new String(DateAndTimeConstants.getMonthAsNumberString(endMonth));
        //System.out.println(" Building to time stamp .......................is");
        String[] timeStamp = new String[6];
        
        timeStamp[0] = new String((String) timeBoundRequest.getParameter("endYear"));
        timeStamp[1] = new String(endMonth);
        timeStamp[2] = new String((String) timeBoundRequest.getParameter("endDay"));
        timeStamp[3] = new String("00");
        timeStamp[4] = new String("00");
        timeStamp[5] = new String("00");
        
        toDate = new java.sql.Timestamp(fabricateSQLTimeStamp(timeStamp));
    }
}
