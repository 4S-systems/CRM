package com.maintenance.common;

import com.silkworm.common.MetaDataMgr;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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

public class AutomationConfigurationMgr {

    private static final AutomationConfigurationMgr AUTOMATION_CONFIGURATION_MGR = new AutomationConfigurationMgr();
    private Document document;
    private final String fileName = "automation_configuration.xml";
    private final Logger logger = Logger.getLogger(AutomationConfigurationMgr.class);
    private final MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();

    public static AutomationConfigurationMgr getCurrentInstance() {
        return AUTOMATION_CONFIGURATION_MGR;
    }

    private AutomationConfigurationMgr() {
        if (metaDataMgr.getWebInfPath() != null) {
            metaDataMgr.setMetaData("xfile.jar");
            DOMConfigurator.configure(metaDataMgr.getWebInfPath() + "/LogConfig.xml");

            // load data
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            try {
                document = factory.newDocumentBuilder().parse(metaDataMgr.getMetadata(fileName));
            } catch (IOException e) {
                logger.error(e.getMessage());
            } catch (SAXException e) {
                logger.error(e.getMessage());
            } catch (ParserConfigurationException e) {
                logger.error(e.getMessage());
            }
        }
    }

    public long getReservationInterval() {
        Element element = (Element) document.getElementsByTagName("reservation-automation").item(0);
        return Long.parseLong(getValue(element, "interval-value"));
    }

    public long getAlarmDelayInterval() {
        Element element = (Element) document.getElementsByTagName("appointment-notification-alarm").item(0);
        return Long.parseLong(getValue(element, "alarm-delay-interval"));
    }

    public String getAlarmDelayType() {
        Element element = (Element) document.getElementsByTagName("appointment-notification-alarm").item(0);
        return getValue(element, "alarm-delay-type");
    }

    public long getAppointmentRemainingTime() {
        Element element = (Element) document.getElementsByTagName("appointment-notification-alarm").item(0);
        return Long.parseLong(getValue(element, "appointment-remaining-time"));
    }

    public String getAppointmentRemainingType() {
        Element element = (Element) document.getElementsByTagName("appointment-notification-alarm").item(0);
        return getValue(element, "appointment-remaining-type");
    }

    public long getSLAAlarmDelayInterval() {
        Element element = (Element) document.getElementsByTagName("sla-notification-alarm").item(0);
        return Long.parseLong(getValue(element, "alarm-delay-interval"));
    }

    public String getSLAAlarmDelayType() {
        Element element = (Element) document.getElementsByTagName("sla-notification-alarm").item(0);
        return getValue(element, "alarm-delay-type");
    }

    public long getSLARemainingTime() {
        Element element = (Element) document.getElementsByTagName("sla-notification-alarm").item(0);
        return Long.parseLong(getValue(element, "sla-remaining-time"));
    }

    public String getSLARemainingType() {
        Element element = (Element) document.getElementsByTagName("sla-notification-alarm").item(0);
        return getValue(element, "sla-remaining-type");
    }

    public long getClosedClientComplaintsInterval() {
        Element element = (Element) document.getElementsByTagName("closed-client-complaints-automation").item(0);
        return Long.parseLong(getValue(element, "interval-value"));
    }

    public long getDefaultRefreshPageInterval() {
        Element element = (Element) document.getElementsByTagName("defualt-refresh-pages").item(0);
        return Long.parseLong(getValue(element, "interval-value"));
    }

    public long getBatchQCInterval() {
        Element element = (Element) document.getElementsByTagName("batchQC-configuration").item(0);
        return Long.parseLong(getValue(element, "interval-value"));
    }

    public long getCallingPlanInterval() {
        Element element = (Element) document.getElementsByTagName("calling-plan-configuration").item(0);
        return Long.parseLong(getValue(element, "interval-value"));
    }

    public long getQualityPlanInterval() {
        Element element = (Element) document.getElementsByTagName("quality-plan-configuration").item(0);
        return Long.parseLong(getValue(element, "interval-value"));
    }

    public long getAuthorizationInterval() {
        Element element = (Element) document.getElementsByTagName("authorization-configuration").item(0);
        return Long.parseLong(getValue(element, "interval-value"));
    }

    public String getElementTitle(String elementName) {
        Element element = (Element) document.getElementsByTagName(elementName).item(0);
        return getValue(element, "title");
    }

    public String getElementDescription(String elementName) {
        Element element = (Element) document.getElementsByTagName(elementName).item(0);
        return getValue(element, "description");
    }

    public String getElementType(String elementName) {
        Element element = (Element) document.getElementsByTagName(elementName).item(0);
        return getValue(element, "type");
    }

    public long getElementInterval(String elementName) {
        Element element = (Element) document.getElementsByTagName(elementName).item(0);
        return Long.parseLong(getValue(element, "interval-value"));
    }

    public long getSessionKillInterval() {
        Element element = (Element) document.getElementsByTagName("session-kill-automation").item(0);
        return Long.parseLong(getValue(element, "interval-value"));
    }

    public long getContractNotifcationInterval() {
        Element element = (Element) document.getElementsByTagName("contract-expire-notification").item(0);
        return Long.parseLong(getValue(element, "interval-value"));
    }

    public long getClosedAutoWithdrawInterval() {
        Element element = (Element) document.getElementsByTagName("closed-auto-withdraw").item(0);
        return Long.parseLong(getValue(element, "interval-value"));
    }

    public long getInterLocalAutoUpdateInterval() {
        Element element = (Element) document.getElementsByTagName("inter-local-auto-update").item(0);
        return Long.parseLong(getValue(element, "interval-value"));
    }
    
    public ArrayList<Map<String, String>> getAutoClosureDepartmentsData() {
        ArrayList<Map<String, String>> autoClosureDepartmentsData = new ArrayList<>();

        Element element = (Element) document.getElementsByTagName("auto-closure-configuration").item(0);
        NodeList departmentsList = element.getElementsByTagName("department");
        Map<String, String> departmentMap;
        for (int i = 0; i < departmentsList.getLength(); i++) {
            Element departmentElement = (Element) departmentsList.item(i);
            String departmentID = departmentElement.getElementsByTagName("department_id").item(0).getTextContent();
            NodeList complaintTypesList = ((Element) departmentElement.getElementsByTagName("complaint-type-list").item(0)).getElementsByTagName("complaint-type");
            for (int j = 0; j < complaintTypesList.getLength(); j++) {
                Element complaintTypeElement = (Element) complaintTypesList.item(j);
                departmentMap = new HashMap<>();
                departmentMap.put("departmentID", departmentID);
                departmentMap.put("type", complaintTypeElement.getElementsByTagName("type").item(0).getTextContent());
                departmentMap.put("actionID", complaintTypeElement.getElementsByTagName("action-id").item(0).getTextContent());
                departmentMap.put("intervalValue", complaintTypeElement.getElementsByTagName("interval-value").item(0).getTextContent());
                departmentMap.put("closureInterval", complaintTypeElement.getElementsByTagName("closure-interval").item(0).getTextContent());
                autoClosureDepartmentsData.add(departmentMap);
            }
        }
        return autoClosureDepartmentsData;
    }

    public String getValue(Element element, String tag) {
        Node node = getNode(element, tag);
        if (node != null) {
            return node.getFirstChild().getNodeValue();
        }
        return null;
    }

    public void setValue(String elementName, String tag, String value) {
        Element element = (Element) document.getElementsByTagName(elementName).item(0);
        Node node = getNode(element, tag);
        if (node != null) {
            node.getFirstChild().setNodeValue(value);
        }
    }

    public List<String> getValues(Element element, String tag) {
        List<String> values = new ArrayList<String>();
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

    public boolean saveDocument() {
        try {
            Transformer transformer = TransformerFactory.newInstance().newTransformer();
            Result output = new StreamResult(new File(System.getProperty("catalina.base") + "/webapps/crm/xml/automation_configuration.xml"));
            Source input = new DOMSource(document);
            transformer.transform(input, output);
            return true;
        } catch (TransformerConfigurationException ex) {
            java.util.logging.Logger.getLogger(AutomationConfigurationMgr.class.getName()).log(Level.SEVERE, null, ex);
        } catch (TransformerException ex) {
            java.util.logging.Logger.getLogger(AutomationConfigurationMgr.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
}
