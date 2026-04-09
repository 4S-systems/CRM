/*
 * DateParser.java
 *
 * Created on June 3, 2009, 5:21 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.maintenance.common;

import com.silkworm.common.MetaDataMgr;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Vector;
import javax.xml.parsers.*;
import org.xml.sax.*;
import org.w3c.dom.*;

/**
 *
 * @author Administrator
 */
public class DateParser {
    
    protected MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
    
    /** Creates a new instance of DateParser */
    public DateParser() {
    }
    
    public java.sql.Date formatSqlDate(String date){
        java.sql.Date sqlDate=null;
        
        /************ Read Date format from configration.XML file *************/
        DateParser dateParser=new DateParser();
        Hashtable formats=dateParser.getDateFormat();
        /********** End Of reading Date Format **********/
        
        String jsDateFormat=(String)formats.get("jsDateFormat");
        
        String dateAtt[]=date.split("/");
        String formatAtt[]=jsDateFormat.split("/");
        
        if(formatAtt.length<3)
            return null;
        else{
            String temp=jsDateFormat.replaceAll("/","");
            int yearIndex=temp.indexOf("y");
            int monthIndex=temp.indexOf("m");
            int dayIndex=temp.indexOf("d");
            
            int year=Integer.parseInt(dateAtt[yearIndex]);
            int month=Integer.parseInt(dateAtt[monthIndex]);
            int day=Integer.parseInt(dateAtt[dayIndex]);
            
            sqlDate = new java.sql.Date(year-1900,month-1,day);
        }
        
        
        
        return sqlDate;
    }
    
    public java.sql.Date formatSqlDate(String date,String dateFormat){
        java.sql.Date sqlDate=null;
        
        String jsDateFormat=dateFormat;
        
        String dateAtt[]=date.split("/");
        String formatAtt[]=jsDateFormat.split("/");
        
        if(formatAtt.length<3)
            return null;
        else{
            String temp=jsDateFormat.replaceAll("/","");
            int yearIndex=temp.indexOf("y");
            int monthIndex=temp.indexOf("m");
            int dayIndex=temp.indexOf("d");
            
            int year=Integer.parseInt(dateAtt[yearIndex]);
            int month=Integer.parseInt(dateAtt[monthIndex]);
            int day=Integer.parseInt(dateAtt[dayIndex]);
            
            sqlDate = new java.sql.Date(year-1900,month-1,day);
        }
        
        
        
        return sqlDate;
    }
    
    public java.sql.Timestamp getSqlTimeStampDate(String date,String jsDateFormat){
        java.sql.Timestamp sqlTimeDate=null;
        date = date.replaceAll("-", "/");
        String dateAtt[]=date.split("/");
        String formatAtt[]=jsDateFormat.split("/");
        
        if(formatAtt.length<3)
            return null;
        else{
            String temp=jsDateFormat.replaceAll("/","");
            int yearIndex=temp.indexOf("y");
            int monthIndex=temp.indexOf("m");
            int dayIndex=temp.indexOf("d");
            
            int year=Integer.parseInt(dateAtt[yearIndex]);
            int month=Integer.parseInt(dateAtt[monthIndex]);
            int day=Integer.parseInt(dateAtt[dayIndex]);
            
            java.sql.Date sqlDate = new java.sql.Date(year-1900,month-1,day);
            sqlTimeDate=new java.sql.Timestamp(sqlDate.getTime());
        }
        
        return sqlTimeDate;
    }
    
    public Hashtable getDateFormat(){
        Hashtable formats=new Hashtable();
        
        //open Jar File
        MetaDataMgr metaMgr=MetaDataMgr.getInstance();
        metaMgr.setMetaData("xfile.jar");
        
        DocumentBuilderFactory factory=DocumentBuilderFactory.newInstance();
        Document doc=null;
        
        try {
            doc=factory.newDocumentBuilder().parse(metaDataMgr.getMetadata("configration"+metaMgr.getCompanyName()+".xml"));
        } catch(IOException e) {
            System.out.println("Error 1");
            
        } catch(SAXException e) {
            System.out.println("xml file not found");
            
        } catch(ParserConfigurationException e) {
            System.out.println("Problem in loading parser");
        }
        
        Element eDocFile=doc.getDocumentElement();
        Element file=doc.getDocumentElement();
        
        file=doc.getDocumentElement();
        NodeList dateFormat=eDocFile.getElementsByTagName("dateFormat");
        NodeList jsFormat=file.getElementsByTagName("jsDateFormat");
        file=(Element)jsFormat.item(0);
        String jsDateFormat=file.getFirstChild().getNodeValue();
        
        file=doc.getDocumentElement();
        NodeList javaFormat=file.getElementsByTagName("javaDateFormat");
        file=(Element)javaFormat.item(0);
        String javaDateFormat=file.getFirstChild().getNodeValue();
        
        formats.put("jsDateFormat",jsDateFormat);
        formats.put("javaDateFormat",javaDateFormat);
        
        metaMgr.closeDataSource();
        
        return formats;
    }
    
    public java.sql.Date getVirtalEndDate(){
        
        //open Jar File
        MetaDataMgr metaMgr=MetaDataMgr.getInstance();
        metaMgr.setMetaData("xfile.jar");
        
        DocumentBuilderFactory factory=DocumentBuilderFactory.newInstance();
        Document doc=null;
        
        try {
            doc=factory.newDocumentBuilder().parse(metaDataMgr.getMetadata("configration"+metaMgr.getCompanyName()+".xml"));
        } catch(IOException e) {
            System.out.println("Error 1");
            
        } catch(SAXException e) {
            System.out.println("xml file not found");
            
        } catch(ParserConfigurationException e) {
            System.out.println("Problem in loading parser");
        }
        
        Element eDocFile=doc.getDocumentElement();
        Element file=doc.getDocumentElement();
        
        file=doc.getDocumentElement();
        NodeList dateFormat=eDocFile.getElementsByTagName("dateFormat");
        NodeList virtualEndDate=file.getElementsByTagName("virtualEndDate");
        file=(Element)virtualEndDate.item(0);
        String virtualEDate=file.getFirstChild().getNodeValue();
        
        file=doc.getDocumentElement();
        dateFormat=eDocFile.getElementsByTagName("dateFormat");
        NodeList jsFormat=file.getElementsByTagName("jsDateFormat");
        file=(Element)jsFormat.item(0);
        String jsDateFormat=file.getFirstChild().getNodeValue();
        
        metaMgr.closeDataSource();
        
        java.sql.Date sqlDate=null;
        
        String dateAtt[]=virtualEDate.split("/");
        String formatAtt[]=jsDateFormat.split("/");
        
        if(formatAtt.length<3)
            return null;
        else{
            String temp=jsDateFormat.replaceAll("/","");
            int yearIndex=temp.indexOf("y");
            int monthIndex=temp.indexOf("m");
            int dayIndex=temp.indexOf("d");
            
            int year=Integer.parseInt(dateAtt[yearIndex]);
            int month=Integer.parseInt(dateAtt[monthIndex]);
            int day=Integer.parseInt(dateAtt[dayIndex]);
            
            sqlDate = new java.sql.Date(year-1900,month-1,day);
        }
        
        
        
        return sqlDate;

    }
    
    public java.util.Date formatUtilDate(String date,int hour,int minutes){
        java.util.Date utilDate=null;
        
        /************ Read Date format from configration.XML file *************/
        DateParser dateParser=new DateParser();
        Hashtable formats=dateParser.getDateFormat();
        /********** End Of reading Date Format **********/
        
        String jsDateFormat=(String)formats.get("jsDateFormat");
        
        String dateAtt[]=date.split("/");
        String formatAtt[]=jsDateFormat.split("/");
        
        if(formatAtt.length<3)
            return null;
        else{
            String temp=jsDateFormat.replaceAll("/","");
            int yearIndex=temp.indexOf("y");
            int monthIndex=temp.indexOf("m");
            int dayIndex=temp.indexOf("d");
            
            int year=Integer.parseInt(dateAtt[yearIndex]);
            int month=Integer.parseInt(dateAtt[monthIndex]);
            int day=Integer.parseInt(dateAtt[dayIndex]);
            
            utilDate = new java.util.Date(year-1900,month-1,day,hour,minutes);
        }
        
        return utilDate;
    }
    
    public java.util.Date formatUtilDate(String date,int hour,int minutes,String dateFormat){
        java.util.Date utilDate=null;
        
        String jsDateFormat=dateFormat;
        
        String dateAtt[]=date.split("/");
        String formatAtt[]=jsDateFormat.split("/");
        
        if(formatAtt.length<3)
            return null;
        else{
            String temp=jsDateFormat.replaceAll("/","");
            int yearIndex=temp.indexOf("y");
            int monthIndex=temp.indexOf("m");
            int dayIndex=temp.indexOf("d");
            
            int year=Integer.parseInt(dateAtt[yearIndex]);
            int month=Integer.parseInt(dateAtt[monthIndex]);
            int day=Integer.parseInt(dateAtt[dayIndex]);
            
            utilDate = new java.util.Date(year-1900,month-1,day,hour,minutes);
        }
        
        return utilDate;
    }
    
    public int getDay(String date){
        
        int day=-100;
        int year=-100;
        int month=-100;
        /************ Read Date format from configration.XML file *************/
        DateParser dateParser=new DateParser();
        Hashtable formats=dateParser.getDateFormat();
        /********** End Of reading Date Format **********/
        
        String jsDateFormat=(String)formats.get("jsDateFormat");
        
        String dateAtt[]=date.split("/");
        String formatAtt[]=jsDateFormat.split("/");
        
        if(formatAtt.length<3)
            return day;
        else{
            String temp=jsDateFormat.replaceAll("/","");
            int yearIndex=temp.indexOf("y");
            int monthIndex=temp.indexOf("m");
            int dayIndex=temp.indexOf("d");
            
            year=Integer.parseInt(dateAtt[yearIndex]);
            month=Integer.parseInt(dateAtt[monthIndex]);
            day=Integer.parseInt(dateAtt[dayIndex]);
            
        }
        
        return day;
    }
    
    public int getMonth(String date){
        
        int month=-100;
        /************ Read Date format from configration.XML file *************/
        DateParser dateParser=new DateParser();
        Hashtable formats=dateParser.getDateFormat();
        /********** End Of reading Date Format **********/
        
        String jsDateFormat=(String)formats.get("jsDateFormat");
        
        String dateAtt[]=date.split("/");
        String formatAtt[]=jsDateFormat.split("/");
        
        if(formatAtt.length<3)
            return month;
        else{
            String temp=jsDateFormat.replaceAll("/","");
            int monthIndex=temp.indexOf("m");
            
            month=Integer.parseInt(dateAtt[monthIndex]);
            
        }
        
        return month;
    }
    
    public int getyear(String date){
        
        int year=-100;
        
        /************ Read Date format from configration.XML file *************/
        DateParser dateParser=new DateParser();
        Hashtable formats=dateParser.getDateFormat();
        /********** End Of reading Date Format **********/
        
        String jsDateFormat=(String)formats.get("jsDateFormat");
        
        String dateAtt[]=date.split("/");
        String formatAtt[]=jsDateFormat.split("/");
        
        if(formatAtt.length<3)
            return year;
        else{
            String temp=jsDateFormat.replaceAll("/","");
            int yearIndex=temp.indexOf("y");
            
            year=Integer.parseInt(dateAtt[yearIndex]);
            
        }
        
        return year;
    }
    
}
