package com.silkworm.util;

import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.common.UserMgr;
import com.silkworm.common.bus_admin.Users;
import java.io.File;
import java.io.IOException;
import java.util.Properties;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class EmailSender {

    private final static String DEFAULT_SERVER = "127.0.0.1";
    UserMgr userMgr = UserMgr.getInstance();
    private String SMTPServer;
    private String from;
    private String ip;
    private String port;

    public EmailSender() {
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        SMTPServer = metaMgr.getSMTPServer();
        from = metaMgr.getEmailAddress();
        ip = metaMgr.getLocalHostInternal();
        port = metaMgr.getPortServer();
    }

    public void sendEmail(String businessObjectId, Vector vecUsers, WebBusinessObject userObj, String sStatus) throws ServletException {
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String smtpServ = metaMgr.getSMTPServer();
        String context = metaMgr.getContext();
        Vector userMailVec = userMgr.getCashedTable();
        String from = metaMgr.getEmailAddress();
        String ip = null;
        String portServer = null;
//         for(int i = 0; i < userMailVec.size(); i++){
//           WebBusinessObject wboUserMail = (WebBusinessObject) userMailVec.get(i);
//           if(wboUserMail.getAttribute("userId").equals(userObj.getAttribute("userId"))){
//               from = wboUserMail.getAttribute("email").toString();
//           }
//
//        }
        if (smtpServ == null || smtpServ.equals("")) {
            smtpServ = DEFAULT_SERVER;
        }
        from = metaMgr.getEmailAddress();
        ip = metaMgr.getLocalHost();
        String to = new String("");
        WebBusinessObject wbo;
        for (int i = 0; i < vecUsers.size(); i++) {
            wbo = (WebBusinessObject) vecUsers.get(i);
            to = to + (String) wbo.getAttribute("email") + ",";
            if (!wbo.getAttribute("userType").equals(Users.getCustomerID())) {
                ip = metaMgr.getLocalHostInternal();
            }
        }
        String stateTicket = null;
        portServer = metaMgr.getPortServer();
//        if (wfTaskMailWbo.getAttribute("currentStatus").equals("Approved")) {
//            stateTicket = "Open";
//        } else {
//            stateTicket = "Closed";
//        }

        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String path = metaMgr.getWebInfPath();
        Document doc = null;

        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuilder = factory.newDocumentBuilder();
            doc = docBuilder.parse(new File(path + "/workFlowVariables.xml"));
            doc.getDocumentElement().normalize();
        } catch (IOException e) {
            System.out.println("Error 1");
        } catch (SAXException e) {
            System.out.println("xml file not found");
        } catch (ParserConfigurationException e) {
            System.out.println("Problem in loading parser");
        }

        Element xmlfile = doc.getDocumentElement();
        NodeList mailContents = xmlfile.getElementsByTagName("customerMailContent");

        String subject = "", mailHead = "", mailBody = "", mailFoot = "", emailContent = "";

        NodeList mainTag = doc.getElementsByTagName("customerMailContent");
        Node tagNode = mainTag.item(0);

        Element firstElement = (Element) tagNode;
        NodeList title = firstElement.getElementsByTagName("mailSubject");
        Element titleElement = (Element) title.item(0);
        NodeList titleElementTxt = titleElement.getChildNodes();

        subject = ((Node) titleElementTxt.item(0)).getNodeValue().toString();

        NodeList mailHeadList = firstElement.getElementsByTagName("mailHead");
        Element mailHeadElement = (Element) mailHeadList.item(0);
        NodeList mailHeadListElementTxt = mailHeadElement.getChildNodes();

        mailHead = ((Node) mailHeadListElementTxt.item(0)).getNodeValue().toString();


        NodeList mailBodyList = firstElement.getElementsByTagName("mailBody");
        Element mailBodyElement = (Element) mailBodyList.item(0);
        NodeList mailBodyTxt = mailBodyElement.getChildNodes();

        mailBody = ((Node) mailBodyTxt.item(0)).getNodeValue().toString();
        emailContent = emailContent + mailBody;

        NodeList mailFootList = firstElement.getElementsByTagName("mailFoot");
        Element mailFootElement = (Element) mailFootList.item(0);
        NodeList mailFootTxt = mailFootElement.getChildNodes();

        mailFoot = ((Node) mailFootTxt.item(0)).getNodeValue().toString();


        emailContent = mailHead + " " + businessObjectId + "\n" + emailContent + "\n" + mailFoot;
//        emailContent = emailContent + " Status : " + stateTicket + "\n";
        emailContent = emailContent + "\n" + " http://" + ip + ":" + portServer + "/CustomerService" + "?ticketCode=" + businessObjectId + "\n";

        // System.out.println("I'm here in the sendder");
        try {
            sendMessage(smtpServ, to, from, subject, emailContent);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e.getMessage());
        }
    }

    public void sendEmailToClients(WebBusinessObject clientData, Vector vecUsers, WebBusinessObject customerData, String ticketCode) throws ServletException {
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String smtpServ = metaMgr.getSMTPServer();
        String context = metaMgr.getContext();
        Vector userMailVec = userMgr.getCashedTable();
        String from = metaMgr.getEmailAddress();
        String ip = null;
        String portServer = null;




//         for(int i = 0; i < userMailVec.size(); i++){
//           WebBusinessObject wboUserMail = (WebBusinessObject) userMailVec.get(i);
//           if(wboUserMail.getAttribute("userId").equals(userObj.getAttribute("userId"))){
//               from = wboUserMail.getAttribute("email").toString();
//           }
//
//        }
        if (smtpServ == null || smtpServ.equals("")) {
            smtpServ = DEFAULT_SERVER;
        }
        from = metaMgr.getEmailAddress();
        ip = metaMgr.getLocalHost();
        String to = new String("");
        WebBusinessObject wbo;
        for (int i = 0; i < vecUsers.size(); i++) {
            wbo = (WebBusinessObject) vecUsers.get(i);
            to = to + (String) wbo.getAttribute("email") + ",";
            if (!wbo.getAttribute("userType").equals(Users.getCustomerID())) {
                ip = metaMgr.getLocalHostInternal();
            }
        }
        //to = to + (String) clientData.getAttribute("email") ;

        String stateTicket = null;

        portServer = metaMgr.getPortServer();

        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String path = metaMgr.getWebInfPath();
        Document doc = null;

        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuilder = factory.newDocumentBuilder();
            doc = docBuilder.parse(new File(path + "/workFlowVariables.xml"));
            doc.getDocumentElement().normalize();
        } catch (IOException e) {
            System.out.println("Error 1");
        } catch (SAXException e) {
            System.out.println("xml file not found");
        } catch (ParserConfigurationException e) {
            System.out.println("Problem in loading parser");
        }

        Element xmlfile = doc.getDocumentElement();
        NodeList mailContents = xmlfile.getElementsByTagName("customerMailContent");

        String subject = "", mailHead = "", mailBody = "", mailFoot = "", emailContent = "";

        try {
            subject = "Ticket from " + customerData.getAttribute("company");
        } catch (Exception E) {
            subject = "Ticket from 4S Tech";
        }
        mailHead = "Dear " + clientData.getAttribute("userName");
        try {
            mailBody = "A new ticket has been sent by " + customerData.getAttribute("fullName") + " from " + customerData.getAttribute("company") + " .";
        } catch (Exception E) {
            mailBody = "A new ticket has been sent by 4s Tech from 4S Tech Inner User .";
        }
        mailFoot = "Please follow this link in order to see it.";

        emailContent = mailHead + "\n" + mailBody + "\n" + mailFoot;
        emailContent = emailContent + "\n" + " http://" + ip + ":" + portServer + "/TQM" + "?ticketCode=" + ticketCode + "\n";

        try {
            sendMessage(smtpServ, to, from, subject, emailContent);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e.getMessage());
        }
    }

    public void sendFinishingMail(WebBusinessObject developerData, Vector vecUsers, WebBusinessObject customerData, String ticketCode, WebBusinessObject technicalData) throws ServletException {
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String smtpServ = metaMgr.getSMTPServer();
        String context = metaMgr.getContext();
        Vector userMailVec = userMgr.getCashedTable();
        String from = metaMgr.getEmailAddress();
        String ip = null;
        String portServer = null;

        if (smtpServ == null || smtpServ.equals("")) {
            smtpServ = DEFAULT_SERVER;
        }
        from = metaMgr.getEmailAddress();
        ip = metaMgr.getLocalHost();
        String to = new String("");
        WebBusinessObject wbo;
        for (int i = 0; i < vecUsers.size(); i++) {
            wbo = (WebBusinessObject) vecUsers.get(i);
            to = to + (String) wbo.getAttribute("email") + ",";
            if (!wbo.getAttribute("userType").equals(Users.getCustomerID())) {
                ip = metaMgr.getLocalHostInternal();
            }
        }

        String stateTicket = null;

        portServer = metaMgr.getPortServer();
        ip = metaMgr.getLocalHost();

        String subject = "", mailHead = "", mailBody = "", mailFoot = "", emailContent = "";

        subject = "Finished Ticket";
        mailHead = "Dear " + technicalData.getAttribute("userName");
        mailBody = developerData.getAttribute("userName") + " has finished the ticket no " + ticketCode + " that was sent by " + customerData.getAttribute("fullName") + " from " + customerData.getAttribute("company") + " .";
        mailFoot = "Please follow this link in order to see details.";

        emailContent = mailHead + "\n" + mailBody + "\n" + mailFoot;
        emailContent = emailContent + "\n" + " http://" + ip + ":" + portServer + "/TQM" + "?ticketCode=" + ticketCode + "\n";

        try {
            sendMessage(smtpServ, to, from, subject, emailContent);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e.getMessage());
        }
    }

    public void sendRejectionMail(WebBusinessObject developerData, Vector vecUsers, WebBusinessObject customerData, String ticketCode, WebBusinessObject technicalData) throws ServletException {
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String smtpServ = metaMgr.getSMTPServer();
        String context = metaMgr.getContext();
        Vector userMailVec = userMgr.getCashedTable();
        String from = metaMgr.getEmailAddress();
        String ip = null;
        String portServer = null;

        if (smtpServ == null || smtpServ.equals("")) {
            smtpServ = DEFAULT_SERVER;
        }
        from = metaMgr.getEmailAddress();
        ip = metaMgr.getLocalHost();
        String to = new String("");
        WebBusinessObject wbo;
        for (int i = 0; i < vecUsers.size(); i++) {
            wbo = (WebBusinessObject) vecUsers.get(i);
            to = to + (String) wbo.getAttribute("email") + ",";
            if (!wbo.getAttribute("userType").equals(Users.getCustomerID())) {
                ip = metaMgr.getLocalHostInternal();
            }
        }

        String stateTicket = null;

        portServer = metaMgr.getPortServer();

        String subject = "", mailHead = "", mailBody = "", mailFoot = "", emailContent = "";

        subject = "Rejected Ticket";
        mailHead = "Dear " + technicalData.getAttribute("userName");
        mailBody = developerData.getAttribute("userName") + " has rejected the ticket no " + ticketCode + " that was sent by " + customerData.getAttribute("fullName") + " from " + customerData.getAttribute("company") + " .";
        mailFoot = "Please follow this link in order to see why.";

        emailContent = mailHead + "\n" + mailBody + "\n" + mailFoot;
        emailContent = emailContent + "\n" + " http://" + ip + ":" + portServer + "/TQM" + "?ticketCode=" + ticketCode + "\n";

        try {
            sendMessage(smtpServ, to, from, subject, emailContent);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e.getMessage());
        }
    }

    public void sendAcceptanceMail(WebBusinessObject developerData, Vector vecUsers, WebBusinessObject customerData, String ticketCode, WebBusinessObject technicalData) throws ServletException {
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String smtpServ = metaMgr.getSMTPServer();
        String context = metaMgr.getContext();
        Vector userMailVec = userMgr.getCashedTable();
        String from = metaMgr.getEmailAddress();
        String ip = null;
        String portServer = null;


        if (smtpServ == null || smtpServ.equals("")) {
            smtpServ = DEFAULT_SERVER;
        }
        from = metaMgr.getEmailAddress();
        ip = metaMgr.getLocalHost();
        String to = new String("");
        WebBusinessObject wbo;
        for (int i = 0; i < vecUsers.size(); i++) {
            wbo = (WebBusinessObject) vecUsers.get(i);
            to = to + (String) wbo.getAttribute("email") + ",";
            if (!wbo.getAttribute("userType").equals(Users.getCustomerID())) {
                ip = metaMgr.getLocalHostInternal();
            }
        }

        String stateTicket = null;

        portServer = metaMgr.getPortServer();

        String subject = "", mailHead = "", mailBody = "", mailFoot = "", emailContent = "";

        subject = "Accepted Ticket";
        mailHead = "Dear " + technicalData.getAttribute("userName");
        mailBody = developerData.getAttribute("userName") + " has accepted the ticket no " + ticketCode + " that was sent by " + customerData.getAttribute("fullName") + " from " + customerData.getAttribute("company") + " .";
        mailFoot = "If you want any details please follow this link .";

        emailContent = mailHead + "\n" + mailBody + "\n" + mailFoot;
        emailContent = emailContent + "\n" + " http://" + ip + ":" + portServer + "/TQM" + "?ticketCode=" + ticketCode + "\n";

        try {
            sendMessage(smtpServ, to, from, subject, emailContent);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e.getMessage());
        }
    }

    public void sendRefuseMail(Vector vecUsers, WebBusinessObject customerData, String ticketCode) throws ServletException {
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String smtpServ = metaMgr.getSMTPServer();
        String context = metaMgr.getContext();
        Vector userMailVec = userMgr.getCashedTable();
        String from = metaMgr.getEmailAddress();
        String ip = null;
        String portServer = null;

        if (smtpServ == null || smtpServ.equals("")) {
            smtpServ = DEFAULT_SERVER;
        }
        from = metaMgr.getEmailAddress();
        ip = metaMgr.getLocalHost();
        String to = new String("");
        WebBusinessObject wbo;
        for (int i = 0; i < vecUsers.size(); i++) {
            wbo = (WebBusinessObject) vecUsers.get(i);
            to = to + (String) wbo.getAttribute("email") + ",";
            if (!wbo.getAttribute("userType").equals(Users.getCustomerID())) {
                ip = metaMgr.getLocalHostInternal();
            }
        }

        String stateTicket = null;

        portServer = metaMgr.getPortServer();

        String subject = "", mailHead = "", mailBody = "", mailFoot = "", emailContent = "";

        subject = "Refused Ticket";
        mailHead = "Dear " + customerData.getAttribute("fullName");
        mailBody = "The request in your ticket no " + ticketCode + " already exists or is impossible .";
        mailFoot = "Please follow this link in order to see details.";

        emailContent = mailHead + "\n" + mailBody + "\n" + mailFoot;
        emailContent = emailContent + "\n" + " http://" + ip + ":" + portServer + "/CustomerService" + "?ticketCode=" + ticketCode + "\n";

        try {
            sendMessage(smtpServ, to, from, subject, emailContent);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e.getMessage());
        }
    }

    public void sendtestedMail(Vector vecUsers, WebBusinessObject customerData, String ticketCode) throws ServletException {
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String smtpServ = metaMgr.getSMTPServer();
        String context = metaMgr.getContext();
        Vector userMailVec = userMgr.getCashedTable();
        String from = metaMgr.getEmailAddress();
        String ip = null;
        String portServer = null;

        if (smtpServ == null || smtpServ.equals("")) {
            smtpServ = DEFAULT_SERVER;
        }
        from = metaMgr.getEmailAddress();
        ip = metaMgr.getLocalHost();
        String to = new String("");
        WebBusinessObject wbo;
        for (int i = 0; i < vecUsers.size(); i++) {
            wbo = (WebBusinessObject) vecUsers.get(i);
            to = to + (String) wbo.getAttribute("email") + ",";
            if (!wbo.getAttribute("userType").equals(Users.getCustomerID())) {
                ip = metaMgr.getLocalHostInternal();
            }
        }

        String stateTicket = null;

        portServer = metaMgr.getPortServer();

        String subject = "", mailHead = "", mailBody = "", mailFoot = "", emailContent = "";

        subject = "Finished Ticket";
        mailHead = "Dear " + customerData.getAttribute("fullName");
        mailBody = "The request in ticket no " + ticketCode + " has been finished and tested .";
        mailFoot = "Please follow this link in order to see details.";
        mailFoot = mailFoot + "\n" + "Note: if you dont have any comments , please close the ticket";

        emailContent = mailHead + "\n" + mailBody + "\n" + mailFoot;
        emailContent = emailContent + "\n" + " http://" + ip + ":" + portServer + "/CustomerService" + "?ticketCode=" + ticketCode + "\n";

        try {
            sendMessage(smtpServ, to, from, subject, emailContent);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e.getMessage());
        }
    }

    public void informStakeholders(WebBusinessObject userWbo, Vector<WebBusinessObject> toList, String actionName, String content, String ticketCode) {
        String to = new String();
        String emailContent = actionName + " by : "
                + userWbo.getAttribute("realName")
                + "\n Notes : \n"
                + content + "\n"
                + "You can visit ticket from : \n"
                + "http://" + ip + ":" + port + "/TQM" + "?ticketCode=" + ticketCode + "\n";
        for (WebBusinessObject webBusinessObject : toList) {
            to += webBusinessObject.getAttribute("email") + ",";
        }
        try {
            sendMessage(SMTPServer, to, from, actionName, emailContent);
        } catch (Exception ex) {
            Logger.getLogger(EmailSender.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private void sendMessage(String smtpServer, String to, String from,
            String subject, String emailContent) throws Exception {

        Properties properties = System.getProperties();
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        // String[] fromUser=metaMgr.getEmailAddress().split("@");

        properties.put("mail.smtp.host", smtpServer);

        properties.put("mail.from", from);
        properties.put("mail.password", metaMgr.getEmailPassword());
        Session session = Session.getDefaultInstance(properties);
        MimeMessage mailMsg = new MimeMessage(session);
        mailMsg.setHeader("Content-Type", "text/plain; charset=UTF-8");
        InternetAddress[] addresses = null;
        System.out.println("I'm here inside send message");
        try {
            if (to != null) {
                addresses = InternetAddress.parse(to, false);
                mailMsg.setRecipients(Message.RecipientType.TO, addresses);
            }
            if (from != null) {
                mailMsg.setFrom(new InternetAddress(from));
            }
            if (subject != null) {
                mailMsg.setSubject(subject, "UTF-8");
            }

            if (emailContent != null) {
                mailMsg.setText(emailContent, "UTF-8");
            }
            Transport.send(mailMsg);

        } catch (Exception exc) {
            exc.printStackTrace();
        }
    }
}
