
//Title:        Your Product Name
//Version:
//Copyright:    Copyright (c) 1999
//Author:       walid mohamed
//Company:      silkworm
//Description:  Your description
package com.silkworm.util;

import java.sql.*;
import java.util.*;
import java.text.*;

public class DictionaryItem {

  protected String itemName = null;
  protected String itemValue= null;
  private String[] multipleValue = null;

  public DictionaryItem() {
  }

  public DictionaryItem(String name,String value)
  {
 
   itemName = name;
   itemValue = value;
  }
  
  public DictionaryItem(String name,String[] multipleValueParam)
  {
  
   itemName = name;
   this.multipleValue = multipleValueParam;
   //for(int i = 0;i<multipleValue.length;i++)
   //    System.out.println(multipleValue[i]);
  
  }

  public String getItemName()
  {
   return itemName;
  }

  public Object getItemValue( String targetClass)
  {
      if (targetClass.equals("com.silkworm.persistence.relational.StringValue" ))
            return itemValue;
      else if (targetClass.equals( "com.silkworm.persistence.relational.IntValue" ))
            return new Integer(itemValue);
      else if (targetClass.equals( "com.silkworm.persistence.relational.TimestampValue" ))
           return getDateTime();
      else if (targetClass.equals( "com.silkworm.persistence.relational.BooleanValue" ))
           return new Boolean(itemValue); 
      else
            return itemValue;
  }
  public String getItemValue()
  {
   return itemValue;
  }
  public void setItemName(String name)
  {
   itemName = name;

  }

  public void setItemValue(String value)
  {
   itemValue = value;

  }

  public Integer getItemIntegerValue()
  {
  return new Integer(itemValue);
  }
  
  private int stringTo_int(String s)
  {
    Integer bigInt = new Integer(s);
    return bigInt.intValue();
  }   
  private java.sql.Timestamp getDateTime()
  {
    Calendar c = Calendar.getInstance();
    DateFormat df_us = DateFormat.getDateTimeInstance(DateFormat.MEDIUM, DateFormat.MEDIUM,  new Locale("en", "US"));
    c.set(stringTo_int(multipleValue[0]),stringTo_int(multipleValue[1]),stringTo_int(multipleValue[2]),
           stringTo_int(multipleValue[3]),stringTo_int(multipleValue[4]),stringTo_int(multipleValue[5]));
    java.util.Date d = c.getTime();
    //System.out.println("Date d for US is " + df_us.format(d));
    
    long dateAslong = c.getTimeInMillis();
    return new java.sql.Timestamp(dateAslong);
  }    
}