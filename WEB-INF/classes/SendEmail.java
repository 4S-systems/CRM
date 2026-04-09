
import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;

public class SendEmail {

    public static void main(String[] args) {
        // Recipient's email ID needs to be mentioned.
        String to = "mfarahat@4s-systems.com";

        // Sender's email ID needs to be mentioned
        String from = "wmohamed@4s-systems.com";

        // Assuming you are sending email from localhost
        String host = "smtp.tedata.net";

        // Get system properties
        Properties properties = System.getProperties();

        // Setup mail server
        properties.setProperty("mail.smtp.host", host);
        properties.put("mail.smtp.auth", true);
        properties.setProperty("mail.smtp.starttls.enable", "true");

        //Bypass the SSL authentication
        properties.put("mail.smtp.ssl.enable", false);
        properties.put("mail.smtp.starttls.enable", false);

        // Get the default Session object.
        Session session = Session.getInstance(properties, new Authenticator() {

            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication("wmohamed@4s-systems.com", "Modk9648%()");
            }
            
        });
        session.setDebug(true);
        try {
            // Create a default MimeMessage object.
            MimeMessage message = new MimeMessage(session);

            // Set From: header field of the header.
            message.setFrom(new InternetAddress(from));

            // Set To: header field of the header.
            message.addRecipient(Message.RecipientType.TO,
                    new InternetAddress(to));

            // Set Subject: header field
            message.setSubject("This is the Subject Line!");

            // Now set the actual message
            message.setText("This is actual message");

            // Send message
            Transport.send(message);
            System.out.println("Sent message successfully....");
        } catch (MessagingException mex) {
            mex.printStackTrace();
        }
    }
}