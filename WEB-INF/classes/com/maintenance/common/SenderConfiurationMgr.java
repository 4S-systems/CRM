package com.maintenance.common;

import com.silkworm.common.MetaDataMgr;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.xml.parsers.*;
import org.apache.log4j.Logger;
import org.apache.log4j.xml.DOMConfigurator;
import org.w3c.dom.*;
import org.xml.sax.*;

public class SenderConfiurationMgr {

    private static final SenderConfiurationMgr SENDER_CONFIURATION_MGR = new SenderConfiurationMgr();
    private Document document;
    private final String fileName = "emails_configration.xml";
    private final Logger logger = Logger.getLogger(SenderConfiurationMgr.class);
    private final MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();

    public static SenderConfiurationMgr getCurrentInstance() {
        return SENDER_CONFIURATION_MGR;
    }

    private SenderConfiurationMgr() {
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

    public String getTitleEscalation() {
        Element element = (Element) document.getElementsByTagName("escalation-configration").item(0);
        return getTitle(element);
    }

    public String getBodyEscalation() {
        Element element = (Element) document.getElementsByTagName("escalation-configration").item(0);
        return getBody(element);
    }

    public String getEmailsEscalation() {
        Element element = (Element) document.getElementsByTagName("escalation-configration").item(0);
        return getEmails(element);
    }

    public List<String> getEmailListEscalation() {
        Element element = (Element) document.getElementsByTagName("escalation-configration").item(0);
        return getEmailList(element);
    }
    
    public String getDelayEscalation() {
        Element element = (Element) document.getElementsByTagName("escalation-configration").item(0);
        return getValue(element, "delay-value");
    }
    
    public int getIntervalEscalation() {
        Element element = (Element) document.getElementsByTagName("escalation-configration").item(0);
        return Integer.parseInt(getValue(element, "interval-value"));
    }

    public String getTitleNewClient() {
        Element element = (Element) document.getElementsByTagName("new-client-configration").item(0);
        return getTitle(element);
    }

    public String getBodyNewClient() {
        Element element = (Element) document.getElementsByTagName("new-client-configration").item(0);
        return getBody(element);
    }

    public String getTitleSendImage() {
        Element element = (Element) document.getElementsByTagName("send-image-configuration").item(0);
        return getTitle(element);
    }

    public String getBodySendImage() {
        Element element = (Element) document.getElementsByTagName("send-image-configuration").item(0);
        return getBody(element);
    }

    public String getTitle(Element element) {
        return getValue(element, "title");
    }

    public String getBody(Element element) {
        return getValue(element, "body");
    }

    public String getEmails(Element element) {
        StringBuilder emails = new StringBuilder("");
        List<String> values = getValues(element, "email");
        int length = values.size();
        for (int i = 0; i < length; i++) {
            emails.append(values.get(i));
            if (i < (length - 1)) {
                emails.append(",");
            }
        }

        return emails.toString();
    }

    public List<String> getEmailList(Element element) {
        return getValues(element, "email");
    }

    public String getSmsUserName() {
        Element element = (Element) document.getElementsByTagName("sms-configration").item(0);
        return getValue(element, "username");
    }

    public String getSmsPassword() {
        Element element = (Element) document.getElementsByTagName("sms-configration").item(0);
        return getValue(element, "password");
    }
    
    public String getSmsSender() {
        Element element = (Element) document.getElementsByTagName("sms-configration").item(0);
        return getValue(element, "sender");
    }

    public String getSmsClientMessage() {
        Element element = (Element) document.getElementsByTagName("sms-configration").item(0);
        return getValue(element, "client-message");
    }

    public String getValue(Element element, String tag) {
        Node node = getNode(element, tag);
        if (node != null) {
            return node.getFirstChild().getNodeValue();
        }
        return null;
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
    
    public String getNotificationEmails(){
        Element element = (Element) document.getElementsByTagName("notification-configuration").item(0);
        return getEmails(element);
    }
    
    public String getNotificationInterval() {
        Element element = (Element) document.getElementsByTagName("notification-configuration").item(0);
        return getValue(element, "interval");
    }
    
    public String getNotificationEmailTitle() {
        Element element = (Element) document.getElementsByTagName("notification-configuration").item(0);
        return getValue(element, "email-title");
    }
    
    public String getNotificationEmailBody() {
        Element element = (Element) document.getElementsByTagName("notification-configuration").item(0);
        return getValue(element, "email-body");
    }
    
    public String getClientEmpGroup() {
        Element element = (Element) document.getElementsByTagName("clients-Employee-Configuration").item(0);
        return getValue(element, "group");
    }
    
    public String getClientEmpDaysNo() {
        Element element = (Element) document.getElementsByTagName("clients-Employee-Configuration").item(0);
        return getValue(element, "Days-No");
    }
    
    public String getClientCommentsDaysNo() {
        Element element = (Element) document.getElementsByTagName("clients-comments-Configuration").item(0);
        return getValue(element, "Days-No");
    }
    
    public String getComplaintNotificationInterval() {
        Element element = (Element) document.getElementsByTagName("complaint-notification-configuration").item(0);
        return getValue(element, "interval");
    }
}
