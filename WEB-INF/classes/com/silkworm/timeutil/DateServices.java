/*
 * DateServices.java
 *
 * Created on November 21, 2005, 5:20 PM
 *
 * To change this template, choose Tools | Options and locate the template under
 * the Source Creation and Management node. Right-click the template and choose
 * Open. You can then make changes to the template in the Source Editor.
 */

package com.silkworm.timeutil;
import java.util.Calendar;

/**
 *
 * @author 1
 */
public class DateServices {
    
    /** Creates a new instance of DateServices */
    public DateServices() {
    }
    
    public long convertMySQLDateToLong(String theDate) {//Format of date '2010-12-31 00:00:00.0'
        Calendar c = Calendar.getInstance();
        if(!theDate.equalsIgnoreCase("2010-12-31 00:00:00.0")) {
            String sTemp=null;
            sTemp=theDate.substring(0, 4);
            Integer iYear=new Integer(sTemp);
            sTemp=theDate.substring(5, 7);
            Integer iMonth = new Integer(sTemp);
            sTemp=theDate.substring(8, 10);
            Integer iDate = new Integer(sTemp);
            sTemp=theDate.substring(11, 13);
            Integer iHour = new Integer(sTemp);
            sTemp=theDate.substring(14, 16);
            Integer iMinute = new Integer(sTemp);
            sTemp = theDate.substring(17, 19);
            Integer iSecond = new Integer(sTemp);
            c.set(iYear.intValue(),iMonth.intValue()-1,iDate.intValue(),iHour.intValue(),iMinute.intValue(), iSecond.intValue());
            System.out.println(c.getTime());
        }
        return c.getTimeInMillis();
    }
    
    public long convertMySQLDate(String theDate) {//Format of date '2010-12-31'
        Calendar c = Calendar.getInstance();
        if(!theDate.equalsIgnoreCase("2010-12-31")) {
            String sTemp=null;
            sTemp=theDate.substring(0, 4);
            Integer iYear=new Integer(sTemp);
            sTemp=theDate.substring(5, 7);
            Integer iMonth = new Integer(sTemp);
            sTemp=theDate.substring(8, 10);
            Integer iDate = new Integer(sTemp);
            c.set(iYear.intValue(),iMonth.intValue()-1,iDate.intValue());//iHour.intValue(),iMinute.intValue(), iSecond.intValue());
            System.out.println(c.getTime());
        }
        return c.getTimeInMillis();
    }
}
