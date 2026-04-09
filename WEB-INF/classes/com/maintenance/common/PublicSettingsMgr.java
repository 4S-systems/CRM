package com.maintenance.common;

import com.silkworm.common.MetaDataMgr;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import javax.xml.parsers.*;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.apache.log4j.Logger;
import org.apache.log4j.xml.DOMConfigurator;
import org.w3c.dom.*;
import org.xml.sax.*;

public class PublicSettingsMgr {

    private static final PublicSettingsMgr PUBLIC_SETTINGS_MGR = new PublicSettingsMgr();
    private Document document;
    private final String fileName = "/webapps/crm/xml/public_settings.xml";
    private final Logger logger = Logger.getLogger(PublicSettingsMgr.class);
    private final MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();

    public static PublicSettingsMgr getCurrentInstance() {
        return PUBLIC_SETTINGS_MGR;
    }

    private PublicSettingsMgr() {
        if (metaDataMgr.getWebInfPath() != null) {
            DOMConfigurator.configure(metaDataMgr.getWebInfPath() + "/LogConfig.xml");
            // load data
            loadData();
        }
    }

    private void loadData() {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        try {
            document = factory.newDocumentBuilder().parse(new File(System.getProperty("catalina.base") + fileName));
        } catch (IOException | SAXException | ParserConfigurationException e) {
            logger.error(e.getMessage());
        }
    }

    public String getReservationDefaultPeriod() {
        if (document != null) {
            Element element = (Element) document.getElementsByTagName("reservation-default-period").item(0);
            return getValue(element, "value");
        }
        return "1";
    }

    public String getValue(Element element, String tag) {
        Node node = getNode(element, tag);
        if (node != null) {
            return node.getFirstChild().getNodeValue();
        }
        return null;
    }

    public void setValue(String elementName, String tag, String value) {
        if (document != null) {
            Element element = (Element) document.getElementsByTagName(elementName).item(0);
            Node node = getNode(element, tag);
            if (node != null) {
                node.getFirstChild().setNodeValue(value);
            }
        }
    }

    public List<String> getValues(Element element, String tag) {
        List<String> values = new ArrayList<>();
        NodeList nodes = getNodeList(element, tag);
        Element subElement;
        String value;
        for (int i = 0; i < nodes.getLength(); i++) {
            subElement = (Element) nodes.item(i);
            value = subElement.getTextContent();
            values.add(value);
        }
        return values;
    }

    public NodeList getNodeList(Element element, String tag) {
        return element.getElementsByTagName(tag);
    }

    public Node getNode(Element element, String tag) {
        return element.getElementsByTagName(tag).item(0);
    }

    public String getElementTitle(String elementName) {
        if (document != null) {
            Element element = (Element) document.getElementsByTagName(elementName).item(0);
            return getValue(element, "title");
        }
        return "";
    }

    public String getElementDescription(String elementName) {
        if (document != null) {
            Element element = (Element) document.getElementsByTagName(elementName).item(0);
            return getValue(element, "description");
        }
        return "";
    }

    public String getElementType(String elementName) {
        if (document != null) {
            Element element = (Element) document.getElementsByTagName(elementName).item(0);
            return getValue(element, "type");
        }
        return "";
    }

    public String getElementValue(String elementName) {
        if (document != null) {
            Element element = (Element) document.getElementsByTagName(elementName).item(0);
            return getValue(element, "value");
        }
        return "";
    }

    public boolean saveDocument() {
        try {
            Transformer transformer = TransformerFactory.newInstance().newTransformer();
            Result output = new StreamResult(new File(System.getProperty("catalina.base") + fileName));
            Source input = new DOMSource(document);
            transformer.transform(input, output);
            loadData();
            metaDataMgr.setReservationDefaultPeriod(PublicSettingsMgr.getCurrentInstance().getReservationDefaultPeriod());
            return true;
        } catch (TransformerConfigurationException ex) {
            java.util.logging.Logger.getLogger(PublicSettingsMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (TransformerException ex) {
            java.util.logging.Logger.getLogger(PublicSettingsMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
}
