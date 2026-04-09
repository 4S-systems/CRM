package com.customization.common;

import com.customization.model.Customization;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.MetaDataMgr;
import java.io.File;
import java.io.IOException;

import java.util.ArrayList;
import java.util.Hashtable;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.log4j.Logger;

import org.xml.sax.*;
import org.w3c.dom.*;

public abstract class CustomizeMgr {

    public CustomizeMgr(String xmlPath){
        this.xmlPath = xmlPath;
        init();
    }

    public Customization getCustomization(String customizationName){
        if(customizationExist(customizationName)){
            return (Customization)contentXML.get(customizationName);
        }
        return new Customization();
    }

    public void updateCustomization(ArrayList allCustomization){
        Document doc = getDocument();
        WebBusinessObject wbo;
        String tagName;
        Customization customization,customizationXML;
        for (int i = 0; i < allCustomization.size(); i++) {
            wbo = (WebBusinessObject) allCustomization.get(i);
            tagName = (String) wbo.getAttribute(TAG_NAME_ATTRIBUTE);
            customization = (Customization) wbo.getAttribute(CUSTOMIZATION_ATTRIBUTE);

            NodeList customizeNode = doc.getElementsByTagName(tagName);

            Element element = (Element) customizeNode.item(0);

            NodeList displayList = element.getElementsByTagName(DISPLAY_ATTRIBUTE);

            Element displayElement = (Element) displayList.item(0);

            // set dispaly value
            displayElement.getFirstChild().setNodeValue(customization.getDisplay());

            // update hashtable contentXML
            customizationXML = (Customization) contentXML.get(tagName);
            customizationXML.setDisplay(customization.getDisplay());
        }
        
        try {
            Transformer transformer = TransformerFactory.newInstance().newTransformer();
            Result result = new StreamResult(new File(path + "/" + xmlPath));
            Source source = new DOMSource(doc);

            transformer.transform(source, result);
        } catch(TransformerConfigurationException ex) {
            logger.error(ex.getMessage());
        } catch(TransformerException ex) {
            logger.error(ex.getMessage());
        }
    }

    public boolean customizationExist(String customizationName){
        return contentXML.get(customizationName) != null;
    }

    public final void init(){
        if (contentXML == null) {
            intiContentXML();
        }
    }

    public void intiContentXML(){

        Hashtable hashtable = new Hashtable();
        Customization customization;
        Document doc=null;
        String display = null;
        String defualt = null;
        String name;

        doc = getDocument();

        NodeList elements = doc.getElementsByTagName("element");
        Element element,displayElement,defualtElement;
        NodeList displayList,defualtList;

        for (int i = 0; i < elements.getLength(); i++) {
            try{
            element = (Element) elements.item(i);

            displayList = element.getElementsByTagName("display");
            defualtList = element.getElementsByTagName("default");

            displayElement = (Element) displayList.item(0);
            defualtElement = (Element) defualtList.item(0);

            name = displayElement.getParentNode().getNodeName();

            display = displayElement.getFirstChild().getNodeValue();
            defualt = defualtElement.getFirstChild().getNodeValue();

            customization = new Customization(display, defualt);

            hashtable.put(name, customization);
            }catch(Exception ex){
                logger.error(ex.getMessage());
            }
        }

        this.contentXML = hashtable;
    }

    private Document getDocument(){
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        Document doc = null;
        try {
            doc = factory.newDocumentBuilder().parse(new File(path + FILE_SEPARATOR + xmlPath));
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

    protected MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
    protected String path = metaDataMgr.getWebInfPath();
    public String xmlPath;
    protected static final String FILE_SEPARATOR = System.getProperty("file.separator");
    public static final String CUSTOMIZATION_ATTRIBUTE = "customization";
    public static final String DISPLAY_ATTRIBUTE = "display";
    public static final String TAG_NAME_ATTRIBUTE = "tagName";
    protected Hashtable contentXML = null;
    protected static Logger logger = Logger.getLogger(CustomizeJOMgr.class);
}
