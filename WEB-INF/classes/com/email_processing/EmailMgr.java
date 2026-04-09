/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.email_processing;


/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


import com.maintenance.common.Tools;
import com.maintenance.db_access.ExternalJobMgr;
import com.maintenance.db_access.TradeMgr;
import com.silkworm.persistence.relational.*;
import com.silkworm.business_objects.*;
import com.silkworm.Exceptions.*;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.common.UserMgr;
import com.tracker.db_access.SequenceMgr;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import org.apache.log4j.xml.DOMConfigurator;

/**
 *
 * @author Waled
 */
public class EmailMgr extends RDBGateWay {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    private static EmailMgr emailMgr = new EmailMgr();

    public static EmailMgr getInstance() {
        logger.info("Getting EmailMgr Instance ....");
        return emailMgr;
    }

    protected void initSupportedForm() {
        if (webInfPath != null) {
            DOMConfigurator.configure(webInfPath + "/LogConfig.xml");
        }
        if (supportedForm == null) {
            try {
                supportedForm = new BusinessForm(DOMFabricatorBean.getDocument(metaDataMgr.getMetadata("email.xml")));
            } catch (Exception e) {
                logger.error("Could not locate XML Document");
            }
        }
    }

    public boolean saveEmail(String to, String from, String subject, String emailContent, String loggedUser, MimeMessage message, boolean isReply) throws SQLException {

        Connection connection = null;
        boolean result = false;
        SQLCommandBean forInsert = new SQLCommandBean();
        int queryResult = -1000;
        Vector params = new Vector();
        String myQuery = "Insert into CLIENT_EMAILS (ID, MESSAGE_ID,CLIENT_EMAIL,LABEL_IDS,TO_EMAILS,FROM_EMAIL,SUBJECT,PLAINTEXT,IS_SENT_REC_DRAFT,CREATEBY,DATE_EMAIL,CREATION_DATE)  values (?,?,?,?,?,?,?,?,?,?,?,?)";
        String id = UniqueIDGen.getNextID();
        params.addElement(new StringValue(id));
        try {
            params.addElement(new StringValue(message.getMessageID()));
        } catch (MessagingException | NullPointerException ex) {
            params.addElement(new StringValue(""));
        }
        params.addElement(new StringValue(isReply ? from : to)); //CLIENT_EMAIL
        params.addElement(new StringValue(isReply ? "RECEIVED" : "SENT")); //LABEL_IDS 
        params.addElement(new StringValue(to)); //TO_EMAILS
        params.addElement(new StringValue(from)); //FROM_EMAIL
        params.addElement(new StringValue(subject)); //SUBJECT
        params.addElement(new StringValue(emailContent)); //PLAINTEXT
        params.addElement(new StringValue("SENT")); //IS_SENT_REC_DRAFT
        params.addElement(new StringValue(loggedUser)); //CREATEBY
        java.util.Date today = new java.util.Date();
        java.sql.Timestamp sqltime = new java.sql.Timestamp(today.getTime());
        params.add(new TimestampValue(sqltime)); ///DATE_EMAIL
        params.add(new TimestampValue(sqltime)); //CREATION_DATE
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(true);
            forInsert.setConnection(connection);
            //forInsert.setSQLQuery(getQuery("InsertEmail"));
            forInsert.setSQLQuery(myQuery);
            forInsert.setparams(params);
            queryResult = forInsert.executeUpdate();
            if (queryResult > 0) {
                result = true;
            }
            System.out.println("Saved Successfully");
        } catch (SQLException se) {
            logger.error("Exception insert mail: " + se.getMessage());

        } catch (Exception ex) {
            logger.error("Exception insert mail : " + ex.getMessage());
        } finally {
            connection.close();
        }
        return result;
    }
    
    
    public  List<WebBusinessObject> getClientMailBox(String clientemail,String clientname) throws SQLException
     {
         
           Connection connection = null;
            
            List<WebBusinessObject> result= new ArrayList<>();
              Vector<Row> rows;
           SQLCommandBean forselect = new SQLCommandBean();
           int queryResult = -1000;
            Vector params = new Vector();
             params.addElement(new StringValue(clientemail)); 
             try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(true);
            forselect.setConnection(connection);
            forselect.setSQLQuery(getQuery("getClientMailBox"));
            // forInsert.setSQLQuery(myQuery);
            forselect.setparams(params);
             final String system_mail = MetaDataMgr.getInstance().getEmailAddress();
            rows = forselect.executeQuery();
             for (Row row : rows){
                  WebBusinessObject wbo;
             try
                {
                    wbo = new WebBusinessObject();
                    
                    wbo.setAttribute("client_no", row.getString("CLIENT_NO"));
                    wbo.setAttribute("name", String.valueOf(row.getString("NAME")));
                    wbo.setAttribute("email", String.valueOf(row.getString("EMAIL")));
                    wbo.setAttribute("thread_id", String.valueOf(row.getString("THREAD_ID")));
                   wbo.setAttribute("message_id", String.valueOf(row.getString("MESSAGE_ID")));
                     String from_email_db=String.valueOf(row.getString("FROM_EMAIL"));
                    wbo.setAttribute("from_email", from_email_db);
                    String to_email_db=String.valueOf(row.getString("TO_EMAILS"));
                    wbo.setAttribute("to_email", to_email_db);
                    
                    String label_ids= String.valueOf(row.getString("LABEL_IDS"));
                    wbo.setAttribute("label_ids",label_ids);
                    if (label_ids.toLowerCase().contains("sent")) {
                        wbo.setAttribute("from_email_name", "Me");
                        wbo.setAttribute("to_email_name", clientname);
                    } else {
                        wbo.setAttribute("from_email_name", clientname);
                        wbo.setAttribute("to_email_name", "Me");
                    }
                    
                   
                    
                    wbo.setAttribute("cc_emails", String.valueOf(row.getString("CC_EMAILS")));
                    wbo.setAttribute("bcc_emails", String.valueOf(row.getString("BCC_EMAILS")));
                   // wbo.setAttribute("date_email", String.valueOf(row.getTimestamp("DATE_EMAIL")));
                  wbo.setAttribute("date_email", new SimpleDateFormat("yyyy-MM-dd h:m:s.S").parse((String.valueOf(row.getTimestamp("DATE_EMAIL")))));
                    wbo.setAttribute("subject", String.valueOf(row.getString("SUBJECT")));
                    wbo.setAttribute("plaintext", String.valueOf(row.getString("PLAINTEXT")));
                    wbo.setAttribute("attachments", String.valueOf(row.getString("ATTACHMENTS")));
                    wbo.setAttribute("to_ip", String.valueOf(row.getString("TO_IP")));
                    wbo.setAttribute("from_ip", String.valueOf(row.getString("FROM_IP")));
                    wbo.setAttribute("is_sent_rec_draft", String.valueOf(row.getString("IS_SENT_REC_DRAFT")));
                    wbo.setAttribute("snippet", String.valueOf(row.getString("SNIPPET")));
                    result.add(wbo);
                }
                catch (NoSuchColumnException ex)
                {
                    logger.error("SQL Exception  " + ex.getMessage());
                }
                
             }
            
        }
              catch (SQLException se) {
            logger.error("Exception get client  mails : " + se.getMessage());
             
        }
          catch (Exception ex)
          {
               logger.error("Exception get client  mails : " + ex.getMessage());
          }
          finally {
            connection.close();
            return result;
        }
    }
    @Override
    protected void initSupportedQueries() {
        queriesIS = metaDataMgr.getQueries(queriesPropFileName);
        return;
    }

    @Override
    public ArrayList getCashedTableAsArrayList() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public boolean saveObject(WebBusinessObject wbo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
    public ArrayList<WebBusinessObject> getEmailsInPeriod(java.sql.Date fromDate, java.sql.Date toDate, String type) {
        Vector param = new Vector();
        Connection connection = null;
        Vector<Row> rows = null;
        SQLCommandBean command = new SQLCommandBean();
        WebBusinessObject wbo;
        ArrayList<WebBusinessObject> result = new ArrayList<>();
        try {
            param.addElement(new DateValue(fromDate));
            param.addElement(new DateValue(toDate));
            param.addElement(new StringValue(type));
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getEmailsInPeriod").trim());
            command.setparams(param);
            rows = command.executeQuery();
            for (Row row : rows) {
                wbo = fabricateBusObj(row);
                try {
                    if(row.getString("NAME") != null) {
                        wbo.setAttribute("clientName", row.getString("NAME"));
                    }
                    if(row.getString("SYS_ID") != null) {
                        wbo.setAttribute("clientID", row.getString("SYS_ID"));
                    }
                    if(row.getString("MOBILE") != null) {
                        wbo.setAttribute("mobile", row.getString("MOBILE"));
                    }
                    if(row.getString("PHONE") != null) {
                        wbo.setAttribute("phone", row.getString("PHONE"));
                    }
                    if(row.getString("INTER_PHONE") != null) {
                        wbo.setAttribute("interPhone", row.getString("INTER_PHONE"));
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(EmailMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                result.add(wbo);
            }
        } catch (SQLException ex) {
            logger.error("SQL Exception  " + ex.getMessage());
        } catch (UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        return result;
    }
    
    public ArrayList<WebBusinessObject> getAllEmails(String fromDate, String toDate, String loggedUserID, String groupID, String userID) {
        Vector param = new Vector();
        Connection connection = null;
        Vector<Row> rows = null;
        SQLCommandBean command = new SQLCommandBean();
        WebBusinessObject wbo;
        ArrayList<WebBusinessObject> result = new ArrayList<>();
	StringBuilder where = new StringBuilder();
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
            try {
                param.addElement(new DateValue(new java.sql.Date(sdf.parse(fromDate).getTime())));
                param.addElement(new DateValue(new java.sql.Date(sdf.parse(toDate).getTime())));
            } catch (ParseException ex) {
                param.addElement(new DateValue(new java.sql.Date(Calendar.getInstance().getTimeInMillis())));
                param.addElement(new DateValue(new java.sql.Date(Calendar.getInstance().getTimeInMillis())));
            }
	    if(userID != null && !userID.isEmpty()){
                where.append(" AND ");
		where.append(" CE.CREATEBY = ?");
		param.addElement(new StringValue(userID));
	    } else if (groupID != null && !groupID.isEmpty()) {
                where.append(" AND ");
                where.append(" CE.CREATEBY IN (SELECT US.USER_ID FROM USER_GROUP UG WHERE UG.GROUP_ID IN (SELECT GROUP_ID FROM USER_GROUP_CONFIG WHERE USER_ID = ?))");
		param.addElement(new StringValue(loggedUserID));
            }
            connection = dataSource.getConnection();
            command.setConnection(connection);
            command.setSQLQuery(getQuery("getAllEmails").trim() + where.toString());
            command.setparams(param);
            rows = command.executeQuery();
            for (Row row : rows) {
                wbo = fabricateBusObj(row);
                try {
                    if(row.getString("ID") != null) {
                        wbo.setAttribute("emailID", row.getString("ID"));
                    }
		    
                    if(row.getString("CLIENT_EMAIL") != null) {
                        wbo.setAttribute("clntEmail", row.getString("CLIENT_EMAIL"));
                    }
		    
                    if(row.getString("DATE_EMAIL") != null) {
                        wbo.setAttribute("sentTime", row.getString("DATE_EMAIL"));
                    }
		    
                    if(row.getString("SUBJECT") != null) {
                        wbo.setAttribute("subject", row.getString("SUBJECT"));
                    }
		    
		    if(row.getString("PLAINTEXT") != null) {
                        wbo.setAttribute("body", row.getString("PLAINTEXT"));
                    }
		    
		    if(row.getString("CLIENT_NO") != null) {
                        wbo.setAttribute("clntNo", row.getString("CLIENT_NO"));
                    }
		    
                    if(row.getString("NAME") != null) {
                        wbo.setAttribute("clntName", row.getString("NAME"));
                    }
		    
		    if(row.getString("FULL_NAME") != null) {
                        wbo.setAttribute("sentBy", row.getString("FULL_NAME"));
                    }
                } catch (NoSuchColumnException ex) {
                    Logger.getLogger(EmailMgr.class.getName()).log(Level.SEVERE, null, ex);
                }
                result.add(wbo);
            }
        } catch (SQLException | UnsupportedTypeException uste) {
            logger.error("***** " + uste.getMessage());
        } finally {
            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException ex) {
                logger.error(ex.getMessage());
            }
        }
        return result;
    }
}
   