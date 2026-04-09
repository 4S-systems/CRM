package com.maintenance.common;

import com.silkworm.common.MetaDataMgr;
import java.io.IOException;
import java.util.Hashtable;
import javax.xml.parsers.*;
import org.apache.log4j.Logger;
import org.apache.log4j.xml.DOMConfigurator;
import org.xml.sax.*;
import org.w3c.dom.*;

public class ConfigFileMgr {

    MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
    private static String currentlanguage = "Ar";
    protected static Logger logger = Logger.getLogger(ConfigFileMgr.class);

    public ConfigFileMgr(){
        if (metaDataMgr.getWebInfPath() != null) {
            metaDataMgr.setMetaData("xfile.jar");
            DOMConfigurator.configure(metaDataMgr.getWebInfPath() + "/LogConfig.xml");
        }
    }

    public Hashtable getJobOrderStatus(String jobOrderStatus){
        return getObject(jobOrderStatus, "configration.xml");
    }
    
    public String getJobOrderType(String jobOrderType){
        Hashtable htJobOrderType = getObject(jobOrderType, "configration" + metaDataMgr.getCompanyName() +".xml");
        if(getCurrentlanguage().equalsIgnoreCase("Ar"))
            return (String)htJobOrderType.get("DescAr");
        else
            return (String)htJobOrderType.get("DescEn");
    }

    public String getJobOrderTypeByCurrentLanguage(String jobOrderStatus){
        Hashtable htJobOrderType = getObject(jobOrderStatus, "configration.xml");
        if(getCurrentlanguage().equalsIgnoreCase("Ar"))
            return (String)htJobOrderType.get("DescAr");
        else
            return (String)htJobOrderType.get("DescEn");
    }

    public Hashtable getCallType(String callType){
        return getObject(callType, "configration.xml");
    }
    
    public String getNotEndYet(){
        return getString("NotEndYet");
    }
    
    public String getMaintenanceNotEnd(){
        return getString("MaintenanceNotEndYet");
    }
    
    public String getMaintenanceFinish(){
        return getString("MaintenanceFinish");
    }

    public String getWorkingNotStartYet(){
        return getString("WorkingNotStartYet");
    }
    
    public String getString(String nameTage){
        Hashtable temp = getObject(nameTage, "configration.xml");
        if(getCurrentlanguage().equalsIgnoreCase("Ar"))
            return (String)temp.get("DescAr");
        else
            return (String)temp.get("DescEn");
    }

    public String getUpdateEquipmentSince(){
        String day = null;
        Document doc = getDocument("configration" + metaDataMgr.getCompanyName() +".xml");
        NodeList elements=doc.getElementsByTagName("updateEquipmentsSince");


       for(int n=0;n<elements.getLength();n++){

            Element elem=(Element) elements.item(n);

            NodeList descArNode=elem.getElementsByTagName("day");


            Element descar=(Element) descArNode.item(0);

            day = descar.getFirstChild().getNodeValue();

        }
        return day;
    }

    private Hashtable getObject(String nameTag, String fileName){
        Hashtable jobOrderStatus=new Hashtable();

        Document doc = getDocument(fileName);

        String descAr = null;
        String descEn = null;

        NodeList elements=doc.getElementsByTagName(nameTag);


       for(int n=0;n<elements.getLength();n++){

            Element elem=(Element) elements.item(n);

            NodeList descArNode=elem.getElementsByTagName("DescAr");
            NodeList descEnNode=elem.getElementsByTagName("DescEn");


            Element descar=(Element) descArNode.item(0);
            Element descen=(Element) descEnNode.item(0);

            descAr=descar.getFirstChild().getNodeValue();
            descEn=descen.getFirstChild().getNodeValue();

        }

        jobOrderStatus.put("DescAr", descAr);
        jobOrderStatus.put("DescEn", descEn);

        return jobOrderStatus;
    }

    private Document getDocument(String fileName){
        DocumentBuilderFactory factory=DocumentBuilderFactory.newInstance();

        Document doc=null;

        try {
            doc=factory.newDocumentBuilder().parse(metaDataMgr.getMetadata(fileName));
        } catch(IOException e) {
            logger.error(e.getMessage());
        } catch(SAXException e) {
            logger.error(e.getMessage());
        } catch(ParserConfigurationException e) {
            logger.error(e.getMessage());
        }catch(Exception e){
            logger.error(e.getMessage());
        }

        return doc;
    }
    
    public static String getCurrentlanguage() {
        return currentlanguage;
    }
    
    public static void setCurrentlanguage(String aCurrentlanguage) {
        currentlanguage = aCurrentlanguage;
    }
}
