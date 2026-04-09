/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.silkworm.email;

import com.email_processing.EmailMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.persistence.relational.UniqueIDGen;
import java.io.FileOutputStream;
import java.sql.SQLException;
import java.util.List;
import java.util.Properties;
import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.Authenticator;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author walid
 */
public class EmailUtility {

    public static boolean sendMessage(String to, String subject, String emailContent) throws Exception {
        return sendMessage(to, subject, emailContent, new String[]{});
    }

    public static boolean sendMessage(String to, String title, String body, String userPath, byte[] bytes) throws Exception {
        FileOutputStream output;
        String[] files = new String[1];
        String randome;
        String fileName;
        String file;
        for (int i = 0; i < files.length; i++) {
            randome = UniqueIDGen.getNextID();
            fileName = "randome_" + randome + ".pdf";
            file = userPath + fileName;
            output = new FileOutputStream(file);
            output.write(bytes);
            files[i] = file;
        }

        return sendMessage(to, title, body, files);
    }

    public static boolean sendMessage(String to, String subject, String emailContent, String... files) throws Exception {
        try {
            String smtp = MetaDataMgr.getInstance().getSMTPServer();
            final String user = MetaDataMgr.getInstance().getEmailAddress();
            final String password = MetaDataMgr.getInstance().getEmailPassword();
            final String port = MetaDataMgr.getInstance().getEmailPort();
            if (smtp == null || smtp.equals("")) {
                smtp = "127.0.0.1";
            }
            Properties properties = System.getProperties();
            //populate the 'Properties' object with the mail
            //server address, so that the default 'Session'
            //instance can use it.
            properties.put("mail.smtp.host", smtp);
            properties.put("mail.smtp.starttls.enable", "true");
            properties.put("mail.smtp.auth", "true");
            properties.put("mail.smtp.port", port);

            Session session = Session.getInstance(properties, new Authenticator() {

                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(user, password);
                }

            });
            Message mailMsg = new MimeMessage(session);//a new email message
            InternetAddress[] addresses;

            Multipart multipart = new MimeMultipart();

            if (to != null) {
                //throws 'AddressException' if the 'to' email address
                //violates RFC822 syntax
                addresses = InternetAddress.parse(to, false);
                mailMsg.setRecipients(Message.RecipientType.TO, addresses);
            }
            if (user != null) {
                mailMsg.setFrom(new InternetAddress(user));
            }
            if (subject != null) {
                mailMsg.setSubject(subject);
            }
            if (emailContent != null) {
                MimeBodyPart messageBodyPart = new MimeBodyPart();
                messageBodyPart.setContent(emailContent, "text/html; charset=utf-8");
                multipart.addBodyPart(messageBodyPart);
            }

            for (String filePath : files) {
                MimeBodyPart attachmentPart = new MimeBodyPart();
                FileDataSource fileDataSource = new FileDataSource(filePath) {
                    @Override
                    public String getContentType() {
                        return "application/octet-stream";
                    }
                };
                attachmentPart.setDataHandler(new DataHandler(fileDataSource));
                attachmentPart.setFileName(fileDataSource.getName());
                multipart.addBodyPart(attachmentPart);
            }
            mailMsg.setContent(multipart);

            //Finally, send the mail message; throws a 'SendFailedException' 
            //if any of the message's recipients have an invalid address
            Transport.send(mailMsg);
            System.out.println("Sent message successfully.... To: " + to);
        } catch (Exception exc) {
            System.out.println("sending auto email error --> " + exc.getMessage());
            return false;
            //throw exc;
        }
        return true;
    }

    public static boolean sendMessageWithoutAttach(String to, String subject, String emailContent) throws Exception {
        String smtp = MetaDataMgr.getInstance().getSMTPServer();
        final String user = MetaDataMgr.getInstance().getEmailAddress();
        final String password = MetaDataMgr.getInstance().getEmailPassword();
        final String port = MetaDataMgr.getInstance().getEmailPort();
        if (smtp == null || smtp.equals("")) {
            smtp = "127.0.0.1";
        }
        Properties properties = System.getProperties();
        properties.put("mail.smtp.host", smtp);
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.port", port);
        MimeBodyPart messageBodyPart = new MimeBodyPart();
        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(user, password);
            }
        });
        Message mailMsg = new MimeMessage(session);
        mailMsg.setHeader("Content-Type", "text/plain; charset=\"utf-8\"");
        mailMsg.setContent(messageBodyPart, "text/plain; charset=utf-8");
        mailMsg.setHeader("Content-Transfer-Encoding", "quoted-printable");
        InternetAddress[] addresses = null;

        Multipart multipart = new MimeMultipart();
        try {
            if (to != null) {
                addresses = InternetAddress.parse(to, false);
                mailMsg.setRecipients(Message.RecipientType.TO, addresses);
            }
            if (user != null) {
                mailMsg.setFrom(new InternetAddress(user));
            }
            if (subject != null) {
                mailMsg.setSubject(subject);
            }

            if (emailContent != null) {
                messageBodyPart.setContent(emailContent, "text/html;charset=utf-8");
                multipart.addBodyPart(messageBodyPart);
            }

            mailMsg.setContent(multipart);
            Transport.send(mailMsg);
            return true;

        } catch (Exception exc) {
            return false;
        }
    }

    public static boolean sendMessageWithImage(String to, String subject, String emailContent) throws Exception {
        String smtp = MetaDataMgr.getInstance().getSMTPServer();
        final String user = MetaDataMgr.getInstance().getEmailAddress();
        final String password = MetaDataMgr.getInstance().getEmailPassword();
        final String port = MetaDataMgr.getInstance().getEmailPort();
        if (smtp == null || smtp.equals("")) {
            smtp = "127.0.0.1";
        }

        Properties properties = System.getProperties();
        properties.put("mail.smtp.host", smtp);
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.port", port);

        MimeBodyPart messageBodyPart = new MimeBodyPart();
        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(user, password);
            }
        });
        Message mailMsg = new MimeMessage(session);
        mailMsg.setHeader("Content-Type", "text/plain; charset=\"utf-8\"");
        mailMsg.setContent(messageBodyPart, "text/plain; charset=utf-8");
        mailMsg.setHeader("Content-Transfer-Encoding", "quoted-printable");

        InternetAddress[] addresses = null;
        Multipart multipart = new MimeMultipart("related");

        try {
            if (to != null) {
                addresses = InternetAddress.parse(to, false);
                mailMsg.setRecipients(Message.RecipientType.TO, addresses);
            }

            if (user != null) {
                mailMsg.setFrom(new InternetAddress(user));
            }

            if (subject != null) {
                mailMsg.setSubject(subject);
            }

            if (emailContent != null) {
                messageBodyPart = new MimeBodyPart();
                String htmlText = "<H1>Yarab</H1><img src=\"cid:image\">";
                messageBodyPart.setContent(htmlText, "text/html");

                multipart.addBodyPart(messageBodyPart);

                // second part (the image)
                messageBodyPart = new MimeBodyPart();
                DataSource fds = new FileDataSource("F:\\projects\\src\\allapps\\crm\\images\\birthdayImage.gif");
                messageBodyPart.setDataHandler(new DataHandler(fds));
                messageBodyPart.setHeader("Content-ID", "<image>");

                // add it
                multipart.addBodyPart(messageBodyPart);

                // put everything together
                mailMsg.setContent(multipart);

                Transport.send(mailMsg);

                System.out.println("Sent message successfully....");
            }

            return true;

        } catch (Exception exc) {
            System.out.println("sending email error --> " + exc.getMessage());
            return false;
            //throw exc;
        }
    }
}
