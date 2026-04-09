/*
 * ParseSideMenu.java
 *
 * Created on February 28, 2009, 2:28 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.maintenance.common;

import com.maintenance.common.Store;
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
 * @author Hani
 */
public class ParseSideMenu {
    protected MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
    /** Creates a new instance of ParseSideMenu */
    public ParseSideMenu() {
        
    }
    public Vector parseSideMenu(String mode,String xmlName,String issueType) {
        DocumentBuilderFactory factory=DocumentBuilderFactory.newInstance();
        Document doc=null;
        
        try {
            doc=factory.newDocumentBuilder().parse(metaDataMgr.getMetadata(xmlName));
        } catch(IOException e) {
            System.out.println("Error 1");
            
        } catch(SAXException e) {
            System.out.println("xml file not found");
            
        } catch(ParserConfigurationException e) {
            System.out.println("Problem in loading parser");
        }
        
        Hashtable style=new Hashtable();
        
        Element eDocFile=doc.getDocumentElement();
        Element file=doc.getDocumentElement();
        
        NodeList menustyle=eDocFile.getElementsByTagName("menu_style");
        
        file=doc.getDocumentElement();
        NodeList titleNode=file.getElementsByTagName(mode+"title");
        file=(Element)titleNode.item(0);
        String title=file.getFirstChild().getNodeValue();
        style.put("title",title);
        
        file=doc.getDocumentElement();
        NodeList barNode=file.getElementsByTagName("barText");
        file=(Element)barNode.item(0);
        String bar=file.getFirstChild().getNodeValue();
        style.put("barText",bar);
        
        NodeList elements=eDocFile.getElementsByTagName("elements");
        Element elem=(Element) elements.item(0);
        NodeList item=elem.getElementsByTagName("item");
        
        Vector name=new Vector();
        Vector result=new Vector();
        /* add hash table that contains style and titles in vector*/
        result.add(style);
        
        try {
            for(int i=0;i<item.getLength();i++) {
                name=new Vector();
                Element eitem=(Element) item.item(i);
                NodeList name_1=eitem.getElementsByTagName(mode+"name");
                NodeList link_1=eitem.getElementsByTagName(issueType+"link");
                
                
                Element ename=(Element) name_1.item(0);
                Element elink=(Element) link_1.item(0);
                
                String nameData=ename.getFirstChild().getNodeValue();
                String linkData=elink.getFirstChild().getNodeValue();
                
                name.add(nameData);
                name.add(linkData);
                
                result.add(name);
                
                
            }
            
            
            
            
        } catch(NumberFormatException e) {
            System.out.println("Numbers that you want Not found");
            
        }
        
        
        
        
        
        
        return result;
        
        
    }
    public Vector parseSideMenu2(String mode,String xmlName,String issueType) {
        DocumentBuilderFactory factory=DocumentBuilderFactory.newInstance();
        Document doc=null;
        
        try {
            doc=factory.newDocumentBuilder().parse(metaDataMgr.getMetadata(xmlName));
        } catch(IOException e) {
            System.out.println("Error 1");
            
        } catch(SAXException e) {
            System.out.println("xml file not found");
            
        } catch(ParserConfigurationException e) {
            System.out.println("Problem in loading parser");
        }
        
        Hashtable style=new Hashtable();
        
        Element eDocFile=doc.getDocumentElement();
        Element file=doc.getDocumentElement();
        
        NodeList menustyle=eDocFile.getElementsByTagName("menu_style");
        
        file=doc.getDocumentElement();
        NodeList titleNode=file.getElementsByTagName(mode+"title");
        file=(Element)titleNode.item(0);
        String title=file.getFirstChild().getNodeValue();
        style.put("title",title);
        
        file=doc.getDocumentElement();
        NodeList barNode=file.getElementsByTagName("barText");
        file=(Element)barNode.item(0);
        String bar=file.getFirstChild().getNodeValue();
        style.put("barText",bar);
        
        NodeList elements=eDocFile.getElementsByTagName("elements");
        Element elem=(Element) elements.item(0);
        NodeList item=elem.getElementsByTagName("item");
        
        Vector name=new Vector();
        Vector result=new Vector();
        /* add hash table that contains style and titles in vector*/
        result.add(style);
        
        try {
            for(int i=0;i<item.getLength();i++) {
                name=new Vector();
                Element eitem=(Element) item.item(i);
                NodeList name_1=eitem.getElementsByTagName(mode+"name");
                NodeList link_1=eitem.getElementsByTagName(issueType+"link");
                
                
                Element ename=(Element) name_1.item(0);
                Element elink=(Element) link_1.item(0);
                
                String nameData=ename.getFirstChild().getNodeValue();
                String linkData=elink.getFirstChild().getNodeValue();
                
                name.add(nameData);
                name.add(linkData);
                
                result.add(name);
                
                
            }
            
            
            
            
        } catch(NumberFormatException e) {
            System.out.println("Numbers that you want Not found");
            
        }
        
        
        
        
        
        
        return result;
        
        
    }
    
    public Hashtable getCompanyLogo(String xmlName) {
        DocumentBuilderFactory factory=DocumentBuilderFactory.newInstance();
        Document doc=null;
        
        try {
            doc=factory.newDocumentBuilder().parse(metaDataMgr.getMetadata(xmlName));
        } catch(IOException e) {
            System.out.println("Error 1");
            
        } catch(SAXException e) {
            System.out.println("xml file not found");
            
        } catch(ParserConfigurationException e) {
            System.out.println("Problem in loading parser");
        }
        
        Element eDocFile=doc.getDocumentElement();
        Element file=doc.getDocumentElement();
        
        NodeList splash=eDocFile.getElementsByTagName("splash");
        
        NodeList indexNode=file.getElementsByTagName("indexLogo");
        file=(Element)indexNode.item(0);
        String indexPic=file.getFirstChild().getNodeValue();

        file=doc.getDocumentElement();
        NodeList weeksNumber=file.getElementsByTagName("weeksNumber");
        file=(Element)weeksNumber.item(0);
        String weeksNo=file.getFirstChild().getNodeValue();


        
        file=doc.getDocumentElement();
        NodeList printEqp=eDocFile.getElementsByTagName("printEqp");
        NodeList logo=file.getElementsByTagName("printEqLogo");
        file=(Element)logo.item(0);
        String logoPic=file.getFirstChild().getNodeValue();
        
        file=doc.getDocumentElement();
        printEqp=eDocFile.getElementsByTagName("printEqp");
        logo=file.getElementsByTagName("printEqLogo2");
        file=(Element)logo.item(0);
        String logoPic2=file.getFirstChild().getNodeValue();
        
        file=doc.getDocumentElement();
        logo=file.getElementsByTagName("printEqLogo3");
        file=(Element)logo.item(0);
        String taskSheet=file.getFirstChild().getNodeValue();
        
        file=doc.getDocumentElement();
        logo=file.getElementsByTagName("headReport1");
        file=(Element)logo.item(0);
        String headReport1=file.getFirstChild().getNodeValue();
        
        file=doc.getDocumentElement();
        logo=file.getElementsByTagName("headReport2");
        file=(Element)logo.item(0);
        String headReport2=file.getFirstChild().getNodeValue();
        
        file=doc.getDocumentElement();
        logo=file.getElementsByTagName("headReport3");
        file=(Element)logo.item(0);
        String headReport3=file.getFirstChild().getNodeValue();
        
        file=doc.getDocumentElement();
        logo=file.getElementsByTagName("ReportTitle");
        file=(Element)logo.item(0);
        String ReportTitle=file.getFirstChild().getNodeValue();
        
        file=doc.getDocumentElement();
        printEqp=eDocFile.getElementsByTagName("printEqp");
        logo=file.getElementsByTagName("primaTitle");
        file=(Element)logo.item(0);
        String primaTitle=file.getFirstChild().getNodeValue();
        
        Hashtable logos=new Hashtable();
        logos.put("indexLogo",indexPic);
        logos.put("comLogo1",logoPic);
        logos.put("comLogo2",logoPic2);
        logos.put("comTitle",primaTitle);
        logos.put("taskSheet",taskSheet);
        logos.put("headReport1",headReport1);
        logos.put("headReport2",headReport2);
        logos.put("headReport3",headReport3);
        logos.put("ReportTitle",ReportTitle);
        logos.put("weeksNo",weeksNo);
        
        return logos;
        
    }
    
    public Hashtable getSiteData(String xmlName) {
        
        Hashtable siteData=new Hashtable();
        
        //open Jar File
        MetaDataMgr metaMgr=MetaDataMgr.getInstance();
        metaMgr.setMetaData("xfile.jar");
        
        DocumentBuilderFactory factory=DocumentBuilderFactory.newInstance();
        Document doc=null;
        
        try {
            doc=factory.newDocumentBuilder().parse(metaDataMgr.getMetadata(xmlName));
        } catch(IOException e) {
            System.out.println("Error 1");
            
        } catch(SAXException e) {
            System.out.println("xml file not found");
            
        } catch(ParserConfigurationException e) {
            System.out.println("Problem in loading parser");
        }
        
        String siteName="";
        Element eDocFile=doc.getDocumentElement();
        Element file=doc.getDocumentElement();
        
        file=doc.getDocumentElement();
        NodeList userTypeTage=file.getElementsByTagName("userType");
        file=(Element)userTypeTage.item(0);
        String userType=file.getFirstChild().getNodeValue();
        
        if(userType.equalsIgnoreCase("single")){
            file=doc.getDocumentElement();
            NodeList siteNameTage=file.getElementsByTagName("siteName");
            file=(Element)siteNameTage.item(0);
            siteName=file.getFirstChild().getNodeValue();
        }
        
        siteData.put("siteName",siteName);
        siteData.put("userType",userType);
        
        metaMgr.closeDataSource();
        
        return siteData;
        
    }
    
    public Hashtable getCompanyPages(){
        Hashtable pages=new Hashtable();
        MetaDataMgr metaMgr=MetaDataMgr.getInstance();
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
        NodeList equipment=eDocFile.getElementsByTagName("equipment");
        NodeList eqpPage=file.getElementsByTagName("newEqpPage");
        file=(Element)eqpPage.item(0);
        String page=file.getFirstChild().getNodeValue();
        
        pages.put("equipmentPage",page);
        
        return pages;
    }
    
    public Vector getSiteStores(String siteId){
        
        Vector stores=new Vector();
        Hashtable siteStores=new Hashtable();
        MetaDataMgr metaMgr=MetaDataMgr.getInstance();
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
        
        NodeList elements=doc.getElementsByTagName("site");
        
        for(int n=0;n<elements.getLength();n++){
            
            Element elem=(Element) elements.item(n);
            
            NodeList siteInfo=elem.getElementsByTagName("siteInfo");
            
            Element siteData=(Element) siteInfo.item(0);
            
            NodeList sId=siteData.getElementsByTagName("id");
            NodeList sName=siteData.getElementsByTagName("name");
            
            Element elemId=(Element) sId.item(0);
            Element elemName=(Element) sName.item(0);
            
            String siteIdValue=elemId.getFirstChild().getNodeValue();
            String siteNameValue=elemName.getFirstChild().getNodeValue();
            
            stores=new Vector();
            
            if(siteIdValue.equalsIgnoreCase(siteId)){
                
                NodeList item=elem.getElementsByTagName("store");
                
                for(int i=0;i<item.getLength();i++) {
                    
                    Element eitem=(Element) item.item(i);
                    
                    NodeList id_1=eitem.getElementsByTagName("id");
                    NodeList name_1=eitem.getElementsByTagName("name");
                    NodeList isDef=eitem.getElementsByTagName("isDefult");
                    
                    Element eId=(Element) id_1.item(0);
                    Element eName=(Element) name_1.item(0);
                    Element elemIsDef=(Element) isDef.item(0);
                    
                    String sIdValue=eId.getFirstChild().getNodeValue();
                    String sNameValue=eName.getFirstChild().getNodeValue();
                    String sIsDefValue=elemIsDef.getFirstChild().getNodeValue();
                    
                    Store storeObj=new Store(sIdValue,sNameValue,sIsDefValue);
                    
                    stores.add(storeObj);
                    storeObj=null;
                    
                }
                break;
            }
            
        }
        
        return stores;
    }
    
    public Store getDefultStore(String siteId){
        
        Vector stores=new Vector();
        Hashtable siteStores=new Hashtable();
        MetaDataMgr metaMgr=MetaDataMgr.getInstance();
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
        
        NodeList elements=doc.getElementsByTagName("site");
        
        for(int n=0;n<elements.getLength();n++){
            
            Element elem=(Element) elements.item(n);
            
            NodeList siteInfo=elem.getElementsByTagName("siteInfo");
            
            Element siteData=(Element) siteInfo.item(0);
            
            NodeList sId=siteData.getElementsByTagName("id");
            NodeList sName=siteData.getElementsByTagName("name");
            
            Element elemId=(Element) sId.item(0);
            Element elemName=(Element) sName.item(0);
            
            String siteIdValue=elemId.getFirstChild().getNodeValue();
            String siteNameValue=elemName.getFirstChild().getNodeValue();
            
            stores=new Vector();
            
            if(siteIdValue.equalsIgnoreCase(siteId)){
                
                NodeList item=elem.getElementsByTagName("store");
                
                for(int i=0;i<item.getLength();i++) {
                    
                    Element eitem=(Element) item.item(i);
                    
                    NodeList id_1=eitem.getElementsByTagName("id");
                    NodeList name_1=eitem.getElementsByTagName("name");
                    NodeList isDef=eitem.getElementsByTagName("isDefult");
                    
                    Element eId=(Element) id_1.item(0);
                    Element eName=(Element) name_1.item(0);
                    Element elemIsDef=(Element) isDef.item(0);
                    
                    String sIdValue=eId.getFirstChild().getNodeValue();
                    String sNameValue=eName.getFirstChild().getNodeValue();
                    String sIsDefValue=elemIsDef.getFirstChild().getNodeValue();
                    
                    if(sIsDefValue.equalsIgnoreCase("1")){
                        
                        Store storeObj=new Store(sIdValue,sNameValue,sIsDefValue);
                        
                        return storeObj;
                    }
                    
                }
                break;
            }
        }
        
        return null;
    }
    
    public int getAvrgWorkOfKmEqps(){
        
        DocumentBuilderFactory factory=DocumentBuilderFactory.newInstance();
        Document doc=null;
        //open Jar File
        MetaDataMgr metaMgr=MetaDataMgr.getInstance();
        metaMgr.setMetaData("xfile.jar");
        
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
        NodeList scheduleConstants=eDocFile.getElementsByTagName("scheduleConstants");
        NodeList averageWork=file.getElementsByTagName("averageKmEqp");
        file=(Element)averageWork.item(0);
        String average=file.getFirstChild().getNodeValue();
        
        int absAverage=0;
        absAverage=Integer.parseInt(average);
        
        metaMgr.closeDataSource();
        
        return absAverage;
    }

    public Hashtable getJobOrderType(String xmlName){

        //Vector jOrderType=new Vector();
        Hashtable jobOrderType=new Hashtable();
        MetaDataMgr metaMgr=MetaDataMgr.getInstance();
        DocumentBuilderFactory factory=DocumentBuilderFactory.newInstance();
        Document doc=null;

        String sEmgTypeArValue = null;
        String sEmgTypeEnValue = null;
        String sPlannedTypeArValue = null;
        String sPlannedTypeEnValue = null;

        try {
            doc=factory.newDocumentBuilder().parse(metaDataMgr.getMetadata("configration"+metaMgr.getCompanyName()+".xml"));
        } catch(IOException e) {
            System.out.println("Error 1");

        } catch(SAXException e) {
            System.out.println("xml file not found");

        } catch(ParserConfigurationException e) {
            System.out.println("Problem in loading parser");
        }

        NodeList elements=doc.getElementsByTagName("jobOrderType");


       for(int n=0;n<elements.getLength();n++){

            Element elem=(Element) elements.item(n);

            NodeList emgTypeAr=elem.getElementsByTagName("emgTypeAr");
            NodeList emgTypeEn=elem.getElementsByTagName("emgTypeEn");
            NodeList plannedTypeAr=elem.getElementsByTagName("plannedTypeAr");
            NodeList plannedTypeEn=elem.getElementsByTagName("plannedTypeEn");


            Element elemEmgTypeAr=(Element) emgTypeAr.item(0);
            Element elemEmgTypeEn=(Element) emgTypeEn.item(0);
            Element elemPlannedTypeAr=(Element) plannedTypeAr.item(0);
            Element elemPlannedTypeEn=(Element) plannedTypeEn.item(0);

            sEmgTypeArValue=elemEmgTypeAr.getFirstChild().getNodeValue();
            sEmgTypeEnValue=elemEmgTypeEn.getFirstChild().getNodeValue();
            sPlannedTypeArValue=elemPlannedTypeAr.getFirstChild().getNodeValue();
            sPlannedTypeEnValue=elemPlannedTypeEn.getFirstChild().getNodeValue();

        }

        jobOrderType.put("sEmgTypeArValue", sEmgTypeArValue);
        jobOrderType.put("sEmgTypeEnValue", sEmgTypeEnValue);
        jobOrderType.put("sPlannedTypeArValue", sPlannedTypeArValue);
        jobOrderType.put("sPlannedTypeEnValue", sPlannedTypeEnValue);

        return jobOrderType;
    }
    
}

