package com.tracker.servlets;

import com.clients.db_access.ClientComplaintsMgr;
import com.clients.db_access.ClientMgr;
import com.crm.db_access.CommentsMgr;
import com.docviewer.servlets.DocViewerFileRenamePolicy;
import com.docviewer.servlets.ImageHandlerServlet;
import com.email_processing.EmailMgr;
import com.maintenance.common.SenderConfiurationMgr;
import com.maintenance.common.Tools;
import com.maintenance.common.UserGroupConfigMgr;
import com.maintenance.db_access.UnitDocMgr;
import com.silkworm.Exceptions.IncorrectFileType;
import com.silkworm.Exceptions.NoUserInSessionException;
import java.io.*;
import java.util.Properties;

import javax.mail.*;
import javax.mail.internet.*;
import javax.activation.*;
import com.silkworm.business_objects.*;
import com.silkworm.common.*;
import com.silkworm.db_access.FileMgr;
import com.silkworm.db_access.PersistentSessionMgr;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.servlets.MultipartRequest;
import com.tracker.db_access.IssueMgr;
import com.tracker.db_access.ProjectMgr;
import java.awt.image.BufferedImage;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Enumeration;
import java.util.List;
import java.util.Map;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.imageio.ImageIO;
import javax.mail.search.AndTerm;
import javax.mail.search.ComparisonTerm;
import javax.mail.search.FlagTerm;
import javax.mail.search.ReceivedDateTerm;
import javax.mail.search.SearchTerm;

import javax.servlet.*;
import javax.servlet.http.*;
//import org.apache.tomcat.util.http.fileupload.FileItem;
//import org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory;
//import org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload;

public class EmailServlet extends ImageHandlerServlet {

    private final static String DEFAULT_SERVER = "127.0.0.1";
    UserMgr userMgr = UserMgr.getInstance();
    protected MultipartRequest mpr = null;
    private String reqOp = null;
    private UnitDocMgr unitDocMgr = UnitDocMgr.getInstance();
//
    private final FileMgr fileMgr = FileMgr.getInstance();
    WebBusinessObject fileDescriptor = null;
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    public String equipmentID = null;
    public String docType = null;
    MetaDataMgr dataMgr = MetaDataMgr.getInstance();

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

    }

    @Override
    public void destroy() {
    }

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            response.setContentType("text/html;charset=UTF-8");

            super.processRequest(request, response);
            HttpSession session = request.getSession();
            String remoteAccess = session.getId();
            WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);

            String clientName = null;
            String fileExtension = null;
            reqOp = request.getParameter("op");
            operation = getOpCode(reqOp);
            switch (operation) {
                case 1:
                    if (request.getParameter("mails") != null) {
			WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
			request.setAttribute("email", loggedUser.getAttribute("email"));
		    
                        servedPage = "/docs/call_center/salesMails.jsp";
                    } else if (request.getParameter("smails") != null) {
                        servedPage = "/docs/call_center/special_emails.jsp";
                    } else {
                        servedPage = "/docs/call_center/emails.jsp";
                        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
			request.setAttribute("email", loggedUser.getAttribute("email"));
                    }
                    String web_inf_path = dataMgr.getWebInfPath();
                    WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    String userHome = (String) loggedUser.getAttribute("userHome");
                    String imageDirPath = getServletContext().getRealPath("/images");
                    String userImageDir = imageDirPath + "/" + userHome;
                    String randome = UniqueIDGen.getNextID();
                    int len = randome.length();
                    String randFileName = "ran" + randome.substring(5, len) + ".jpeg";
                    String RIPath = userImageDir + "/" + randFileName;
                    userHome = (String) loggedUser.getAttribute("userHome");
                    userImageDir = imageDirPath + "/" + userHome;
                    String userBackendHome = web_inf_path + "/usr/" + userHome + "/";
//                String to = "m.tarek.badr@gmail.com";

                    String status = "error";
                    metaMgr = MetaDataMgr.getInstance();
                    HttpSession s = request.getSession();
                    WebBusinessObject userObj = null;
                    userObj = (WebBusinessObject) s.getAttribute("loggedUser");
                    String smtpServ = metaMgr.getSMTPServer();//request.getParameter("smtp");
                    if (smtpServ == null || smtpServ.equals("")) {
                        smtpServ = DEFAULT_SERVER;
                    }
		    
		    String from = new String();
		    String usrPassword = new String();
		    if(request.getParameter("fromTyp") != null && request.getParameter("fromTyp").equals("usrEmail")){
			loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
			from = (String) loggedUser.getAttribute("email");
			usrPassword = (String) request.getParameter("pass");
		    } else {
			from = metaMgr.getEmailAddress();
		    }
                    String subject = null;
                    String message = null;
                    String to = null;
                    String forType = null;
                    String[] toMails = null;
                    DocViewerFileRenamePolicy ourPolicy = new DocViewerFileRenamePolicy();
                    File f1 = null;
                    File f2 = null;
                    File f3 = null;

                    fileExtension = request.getParameter("fileExtension");

                    String file = "";
                    if (!fileExtension.equals("null")) {
                        if (!fileExtension.equalsIgnoreCase("noFiles")) {

                            fileDescriptor = fileMgr.getObjectFromCash(fileExtension);
                            if (fileDescriptor != null) {
                                String metaType = (String) fileDescriptor.getAttribute("metaType");

                                ourPolicy.setDesiredFileExt(fileExtension);

                                File oldFile = new File(userBackendHome + ourPolicy.getFileName());
                                oldFile.delete();
                            }
                        }
                    }

                    WebBusinessObject wbo = new WebBusinessObject();

                    try {
                        mpr = new MultipartRequest(request, userBackendHome, (600 * 1024 * 1024), "UTF-8");
                        to = mpr.getParameter("to");
                        forType = mpr.getParameter("for");

                        if (mpr.getParameter("mails") != null) {
                            toMails = mpr.getParameter("mails").split(",");
                        } else {
                            toMails = mpr.getParameterValues("toMails");
                        }

                        subject = mpr.getParameter("subject");
                        message = mpr.getParameter("message");
                        Enumeration files;
                        files = mpr.getFileNames();
                        if (mpr != null) {

                            f1 = mpr.getFile("file1");
                            f2 = mpr.getFile("file2");
                            f3 = mpr.getFile("file3");

                        }
                    } catch (IncorrectFileType ex) {
                        Logger.getLogger(EmailServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    String f1_path = null,
                     f2_path = null,
                     f3_path = null;
//                file = userBackendHome + ourPolicy.getFileName();
                    if (f1 != null) {
                        f1_path = f1.getPath();
                    }
                    if (f2 != null) {
                        f2_path = f2.getPath();
                    }
                    if (f3 != null) {
                        f3_path = f3.getPath();
                    }
                    ClientMgr clientMgr = ClientMgr.getInstance();
                    try {
                        if (forType != null && forType.equalsIgnoreCase("allClient")) {
                            if (mpr.getParameter("mails") != null) {
                                for (int i = 0; i < toMails.length; i++) {
                                    if (toMails[i] != null && !(toMails[i]).isEmpty()) {
                                        if (sendMessage(smtpServ, toMails[i], from, usrPassword, subject, message, f1_path, f2_path, f3_path, request)) {
                                            status = "ok";
                                        } else {
                                            status = "error";
                                        }
                                    }
                                }
                            } else {
                                clientMgr.cashData();
                                ArrayList<WebBusinessObject> clientsList = new ArrayList<>(clientMgr.getCashedTable());
                                for (WebBusinessObject client : clientsList) {
                                    if (client.getAttribute("email") != null && !((String) client.getAttribute("email")).isEmpty()) {
                                        if (sendMessage(smtpServ, (String) client.getAttribute("email"), from, null, subject, message, f1_path, f2_path, f3_path, request)) {
                                            status = "ok";
                                        } else {
                                            status = "error";
                                        }
                                    }
                                }
                            }
                        } else if (forType != null && forType.equalsIgnoreCase("searchClient")) {
                            if (toMails != null) {
                                for (String toMail : toMails) {
                                    if (sendMessage(smtpServ, toMail, from, null, subject, message, f1_path, f2_path, f3_path, request)) {
                                        status = "ok";
                                    } else {
                                        status = "error";
                                    }
                                }
                            }
                        } else {
                            if (sendMessage(smtpServ, to, from, null, subject, message, f1_path, f2_path, f3_path, request)) {
                                status = "ok";
                            } else {
                                status = "error";
                            }
                        }
                    } catch (Exception ex) {
                        Logger.getLogger(EmailServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    request.setAttribute("page", servedPage);
                    request.setAttribute("status", status);
                    this.forwardToServedPage(request, response);
                    break;
                case 2:
                    PrintWriter out = response.getWriter();
                    servedPage = "/docs/call_center/emails.jsp";
                    web_inf_path = dataMgr.getWebInfPath();
                    session = request.getSession();
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    userHome = (String) loggedUser.getAttribute("userHome");
                    imageDirPath = getServletContext().getRealPath("/images");
                    userImageDir = imageDirPath + "/" + userHome;
                    randome = UniqueIDGen.getNextID();
                    len = randome.length();
                    randFileName = "ran" + randome.substring(5, len) + ".jpeg";
                    RIPath = userImageDir + "/" + randFileName;
                    userHome = (String) loggedUser.getAttribute("userHome");
                    userImageDir = imageDirPath + "/" + userHome;
                    userBackendHome = web_inf_path + "/usr/" + userHome + "/";
//                String to = "m.tarek.badr@gmail.com";

                    status = null;
                    metaMgr = MetaDataMgr.getInstance();
                    s = request.getSession();
                    userObj = null;
                    userObj = (WebBusinessObject) s.getAttribute("loggedUser");
                    smtpServ = metaMgr.getSMTPServer();//request.getParameter("smtp");
                    if (smtpServ == null || smtpServ.equals("")) {
                        smtpServ = DEFAULT_SERVER;
                    }
                    from = metaMgr.getEmailAddress();
                    subject = request.getParameter("subject");
                    message = request.getParameter("msgContent");
                    to = request.getParameter("to");
                    wbo = new WebBusinessObject();
                    try {
                        if (sendMessage(smtpServ, to, from, null, subject, message, request)) {
                            wbo.setAttribute("status", "ok");
                        } else {
                            wbo.setAttribute("status", "error");
                        }
                    } catch (Exception ex) {
                        Logger.getLogger(EmailServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    request.setAttribute("page", servedPage);
                    request.setAttribute("status", status);
                    out = response.getWriter();
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                case 3:
                    out = response.getWriter();
                    web_inf_path = dataMgr.getWebInfPath();
                    session = request.getSession();
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    userHome = (String) loggedUser.getAttribute("userHome");
                    imageDirPath = getServletContext().getRealPath("/images");
                    userImageDir = imageDirPath + "/" + userHome;
                    randome = UniqueIDGen.getNextID();
                    len = randome.length();
                    randFileName = "ran" + randome.substring(5, len) + ".jpeg";
                    RIPath = userImageDir + "/" + randFileName;
                    userHome = (String) loggedUser.getAttribute("userHome");
                    userImageDir = imageDirPath + "/" + userHome;
                    userBackendHome = web_inf_path + "/usr/" + userHome + "/";
                    status = null;
                    metaMgr = MetaDataMgr.getInstance();
                    s = request.getSession();
                    userObj = null;
                    userObj = (WebBusinessObject) s.getAttribute("loggedUser");
                    smtpServ = metaMgr.getSMTPServer();//request.getParameter("smtp");
                    if (smtpServ == null || smtpServ.equals("")) {
                        smtpServ = DEFAULT_SERVER;
                    }
                    from = metaMgr.getEmailAddress();
                    subject = null;
                    message = null;
                    to = null;

                    wbo = new WebBusinessObject();

                    try {
                        mpr = new MultipartRequest(request, userBackendHome, (600 * 1024 * 1024), "UTF-8");

                        to = mpr.getParameter("to");
//                    to = "m.tarek.badr@gmail.com";
                        subject = mpr.getParameter("subject");
                        message = mpr.getParameter("message");
                        String counter = mpr.getParameter("counter");
                        int count = Integer.parseInt(counter);
                        Enumeration files;
                        files = mpr.getFileNames();
                        if (count > 0 & files.hasMoreElements()) {

                            File filess[] = new File[count];
                            String file_path[] = new String[count];
                            int a = 1;

                            if (mpr != null) {

                                for (int i = 0; i < count; i++) {

                                    filess[i] = mpr.getFile("file" + a);
                                    String path = filess[i].getPath();
                                    file_path[i] = path;
                                    a++;
                                }

                            }
                            try {
                                if (sendMessageArrayOfFiles(smtpServ, to, from, subject, message, file_path, request)) {

                                    wbo.setAttribute("status", "ok");

                                } else {
                                    wbo.setAttribute("status", "error");
                                }
                            } catch (Exception ex) {
                                Logger.getLogger(EmailServlet.class.getName()).log(Level.SEVERE, null, ex);
                            }

                        } else {
                            try {
                                if (sendMessage(smtpServ, to, from, null, subject, message, null, null, null, request)) {
                                    wbo.setAttribute("status", "ok");
                                } else {
                                    wbo.setAttribute("status", "error");
                                }
                            } catch (Exception ex) {
                                Logger.getLogger(EmailServlet.class.getName()).log(Level.SEVERE, null, ex);
                            }

                        }
                    } catch (IncorrectFileType ex) {
                        Logger.getLogger(EmailServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                case 4:
                    wbo = new WebBusinessObject();
                    out = response.getWriter();
                    web_inf_path = dataMgr.getWebInfPath();
                    session = request.getSession();
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    userHome = (String) loggedUser.getAttribute("userHome");
                    userBackendHome = web_inf_path + "/usr/" + userHome + "/";
                    mpr = new MultipartRequest(request, userBackendHome, (600 * 1024 * 1024), "UTF-8");
                    if (unitDocMgr.saveMultiDocument(mpr, persistentUser)) {
                        wbo.setAttribute("status", "success");
                    } else {
                        wbo.setAttribute("status", "failed");
                    }

                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                case 5:

                    servedPage = "/show_client_files.jsp";
                    String clientID = (String) request.getParameter("clientID");

                    unitDocMgr = UnitDocMgr.getInstance();
                    Vector documents = new Vector();
                    documents = unitDocMgr.getListOnLIKE(request.getParameter("op"), clientID);
                    request.setAttribute("page", servedPage);
                    request.setAttribute("documents", documents);
                    this.forward(servedPage, request, response);
                    break;
                case 6:

                    String docType = request.getParameter("docType");
                    String docID = request.getParameter("docID");

                    fileDescriptor = fileMgr.getObjectFromCash(docType);

                    String app = (String) fileDescriptor.getAttribute("app");
                    session = request.getSession();
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    userHome = (String) loggedUser.getAttribute("userHome");
                    imageDirPath = getServletContext().getRealPath("/images");
                    userImageDir = imageDirPath + "/" + userHome;
                    if (docType.equalsIgnoreCase("jpg")) {
                        servedPage = "/docs/unit_doc_handling/image_renderer.jsp";
                        request.setAttribute("page", servedPage);
                        randome = UniqueIDGen.getNextID();
                        len = randome.length();

                        randFileName = "ran" + randome.substring(5, len) + ".jpeg";

                        RIPath = userImageDir + "/" + randFileName;

                        String absPath = "images/" + userHome + "/" + randFileName;

                        File docImage = new File(RIPath);
                        docID = request.getParameter("docID");
                        BufferedInputStream gifData = new BufferedInputStream(unitDocMgr.getImage(docID));
                        BufferedImage myImage = ImageIO.read(gifData);
                        ImageIO.write(myImage, "jpeg", docImage);
                        wbo = new WebBusinessObject();
                        out = response.getWriter();
                        wbo.setAttribute("status", "ok");
                        wbo.setAttribute("imagePath", absPath);
                        out.write(Tools.getJSONObjectAsString(wbo));

                        break;
                    } else {
                        String docName = request.getParameter("docID");
                        randome = UniqueIDGen.getNextID();
                        len = randome.length();
                        ServletOutputStream stream = null;

                        randFileName = "ran" + randome.substring(5, len) + docType;

                        RIPath = userImageDir + "/" + randFileName;
                        BufferedInputStream pdfData
                                = new BufferedInputStream(unitDocMgr.getImage(docID));
                        try {
                            stream = response.getOutputStream();
                            response.setContentType("application/" + app);
                            response.addHeader("Content-Disposition", "attachment; filename=" + docName + "." + docType);
                            int readBytes = 0;
                            while ((readBytes = pdfData.read()) != -1) {
                                stream.write(readBytes);
                            }
                        } catch (IOException ioe) {
                            throw new ServletException(ioe.getMessage());
                        } finally {
                            if (stream != null) {
                                stream.close();
                            }
                            if (pdfData != null) {
                                pdfData.close();
                            }
                        }
                        break;
                    }
                case 7:
                    clientID = request.getParameter("clientID");
                    docID = unitDocMgr.getPdfContract(clientID);
                    request.setAttribute("pdfContract", docID);
                    response.getWriter().write(docID);
                    break;
                case 8:
                    wbo = new WebBusinessObject();
                    out = response.getWriter();
                    String email = (String) request.getParameter("email");
                    String imageSrc = (String) request.getParameter("imageSrc");
                    subject = (String) request.getParameter("subject");
                    String body = (String) request.getParameter("body");
                    SenderConfiurationMgr configurationMgr = SenderConfiurationMgr.getCurrentInstance();
                    if (subject == null || subject.isEmpty()) {
                        subject = configurationMgr.getTitleSendImage();
                    }
                    if (body == null || body.isEmpty()) {
                        body = configurationMgr.getBodySendImage();
                    }
                    if (email != null && !email.isEmpty()) {
                        web_inf_path = dataMgr.getWebInfPath();
                        session = request.getSession();
                        loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                        userHome = (String) loggedUser.getAttribute("userHome");
                        userBackendHome = web_inf_path + "/usr/" + userHome + "/";
                        metaMgr = MetaDataMgr.getInstance();
                        s = request.getSession();
                        userObj = null;
                        userObj = (WebBusinessObject) s.getAttribute("loggedUser");
                        smtpServ = metaMgr.getSMTPServer();
                        if (smtpServ == null || smtpServ.equals("")) {
                            smtpServ = DEFAULT_SERVER;
                        }
                        from = metaMgr.getEmailAddress();
                        wbo = new WebBusinessObject();
                        String tempPath = web_inf_path.substring(0, web_inf_path.indexOf("WEB-INF"));
                        String file_path[] = null;
                        if (imageSrc != null && !imageSrc.isEmpty()) {
                            String[] images = imageSrc.split(",");
                            file_path = new String[images.length];
                            for (int i = 0; i < images.length; i++) {
                                file_path[i] = tempPath + images[i];
                            }
                        }
                        try {
                            if (sendMessageArrayOfFiles(smtpServ, email, from, subject, body, file_path, request)) {
                                wbo.setAttribute("status", "ok");
                            } else {
                                wbo.setAttribute("status", "error");
                            }
                        } catch (Exception ex) {
                            Logger.getLogger(EmailServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                case 9:
                    servedPage = "/docs/issue/email_popup.jsp";
                    IssueMgr issueMgr = IssueMgr.getInstance();
                    WebBusinessObject issueWbo = issueMgr.getOnSingleKey(request.getParameter("issueID"));
                    clientMgr = ClientMgr.getInstance();
                    WebBusinessObject clientWbo = clientMgr.getOnSingleKey((String) issueWbo.getAttribute("clientId"));
                    ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                    WebBusinessObject clientComplaintWbo = clientComplaintsMgr.getOnSingleKey(request.getParameter("clientComplaintID"));
                    StringBuilder titleStr = new StringBuilder();
                    if (clientComplaintWbo != null) {
                        titleStr.append(request.getParameter("typeName")).append(": ").append((String) clientWbo.getAttribute("name"));
                        titleStr.append(" No.: ").append((String) issueWbo.getAttribute("businessID"));
                    }
                    ArrayList<WebBusinessObject> unitsList = ProjectMgr.getInstance().getAllUnitsForClient((String) issueWbo.getAttribute("clientId"));
                    StringBuilder bodyStr = new StringBuilder();
                    bodyStr.append("<br/>Units:");
                    for (WebBusinessObject unitWbo : unitsList) {
                        bodyStr.append("<blockquote style=\"margin: 0 0 0 40px; border: none; padding: 0px;\">").append((String) unitWbo.getAttribute("projectName")).append("</blockquote>");
                    }
                    bodyStr.append("<br/>Comments:");
                    for (WebBusinessObject commentWbo : CommentsMgr.getInstance().getCommentsByObjectId(request.getParameter("clientComplaintID"))) {
                        bodyStr.append("<blockquote style=\"margin: 0 0 0 40px; border: none; padding: 0px;\">").append("On ").append((String) commentWbo.getAttribute("creationTime"))
                                .append(" ").append((String) commentWbo.getAttribute("createdByName")).append(" said ")
                                .append(":</blockquote> <blockquote style=\"margin: 0 0 0 80px; border: none; padding: 0px;\">").append((String) commentWbo.getAttribute("comment")).append("</blockquote>");
                    }
                    ArrayList<WebBusinessObject> managersList = userMgr.getAllUpperManagers();
                    if (clientWbo != null && clientWbo.getAttribute("email") != null) {
                        WebBusinessObject tempWbo = new WebBusinessObject();
                        tempWbo.setAttribute("email", clientWbo.getAttribute("email"));
                        tempWbo.setAttribute("fullName", clientWbo.getAttribute("name"));
                        managersList.add(0, tempWbo);
                    }
                    request.setAttribute("managersList", managersList);
                    request.setAttribute("titleStr", titleStr.toString());
                    request.setAttribute("bodyStr", bodyStr.toString());
                    this.forward(servedPage, request, response);
                    break;

                case 10:
                    wbo = new WebBusinessObject();
                    out = response.getWriter();
                    email = (String) request.getParameter("email");
                    subject = (String) request.getParameter("subject");
                    body = (String) request.getParameter("body");
                    String clientNo = (String) request.getParameter("clientNo");
                    clientName = (String) request.getParameter("clientName");
                    String clientMob = (String) request.getParameter("clientMob");
                    configurationMgr = SenderConfiurationMgr.getCurrentInstance();

                    if (subject == null || subject.isEmpty()) {
                        subject = " Client Alert ";
                    }

                    if (body == null || body.isEmpty()) {
                        body = " This Client Came Again Please Check Him. \n"
                                + " Client No: " + clientNo + ". \n"
                                + " Client Name: " + clientName + ". \n"
                                + " Client Mobile No.: " + clientMob + ".";
                    }

                    if (email != null && !email.isEmpty()) {
                        web_inf_path = dataMgr.getWebInfPath();
                        session = request.getSession();
                        loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                        userHome = (String) loggedUser.getAttribute("userHome");
                        userBackendHome = web_inf_path + "/usr/" + userHome + "/";
                        metaMgr = MetaDataMgr.getInstance();
                        s = request.getSession();
                        userObj = null;
                        userObj = (WebBusinessObject) s.getAttribute("loggedUser");
                        smtpServ = metaMgr.getSMTPServer();
                        if (smtpServ == null || smtpServ.equals("")) {
                            smtpServ = DEFAULT_SERVER;
                        }
                        from = metaMgr.getEmailAddress();
                        wbo = new WebBusinessObject();
                        try {
                            if (sendMessage(smtpServ, email, from, null, subject, body, null, null, null, request)) {
                                wbo.setAttribute("status", "ok");
                            } else {
                                wbo.setAttribute("status", "error");
                            }
                        } catch (Exception ex) {
                            Logger.getLogger(EmailServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                case 11:
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("status", "fail");
                    out = response.getWriter();
                    readMail(request, wbo);
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;

                case 12:
                    servedPage = "/docs/call_center/special_emails.jsp";

                    web_inf_path = dataMgr.getWebInfPath();
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");

                    userHome = (String) loggedUser.getAttribute("userHome");
                    imageDirPath = getServletContext().getRealPath("/images");
                    userImageDir = imageDirPath + "/" + userHome;
                    randome = UniqueIDGen.getNextID();
                    len = randome.length();
                    randFileName = "ran" + randome.substring(5, len) + ".jpeg";
                    RIPath = userImageDir + "/" + randFileName;
                    userHome = (String) loggedUser.getAttribute("userHome");
                    userImageDir = imageDirPath + "/" + userHome;
                    userBackendHome = web_inf_path + "/usr/" + userHome + "/";

                    status = null;
                    metaMgr = MetaDataMgr.getInstance();
                    s = request.getSession();
                    userObj = null;
                    userObj = (WebBusinessObject) s.getAttribute("loggedUser");

                    smtpServ = metaMgr.getSMTPServer();//request.getParameter("smtp");
                    if (smtpServ == null || smtpServ.equals("")) {
                        smtpServ = DEFAULT_SERVER;
                    }

                    from = metaMgr.getEmailAddress();
                    subject = null;
                    message = null;
                    to = null;
                    forType = null;
                    toMails = null;
                    ourPolicy = new DocViewerFileRenamePolicy();
                    f1 = null;

                    fileExtension = request.getParameter("fileExtension");

                    file = "";
                    if (!fileExtension.equals("null")) {
                        fileDescriptor = fileMgr.getObjectFromCash(fileExtension);
                        if (fileDescriptor != null) {
                            String metaType = (String) fileDescriptor.getAttribute("metaType");
                            ourPolicy.setDesiredFileExt(fileExtension);
                            File oldFile = new File(userBackendHome + ourPolicy.getFileName());
                            oldFile.delete();
                        }
                    }

                    wbo = new WebBusinessObject();

                    try {
                        mpr = new MultipartRequest(request, userBackendHome, (600 * 1024 * 1024), "UTF-8");
                        toMails = mpr.getParameterValues("toMails");
			if (toMails == null) {
                            toMails = mpr.getParameter("toMails").split(",");
			}
			
                        //to = mpr.getParameter("to");
                        subject = mpr.getParameter("subject");
                        message = mpr.getParameter("message");
                        Enumeration files;
                        files = mpr.getFileNames();
                        if (mpr != null) {
                            f1 = mpr.getFile("file1");
                        }
                    } catch (IncorrectFileType ex) {
                        Logger.getLogger(EmailServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    f1_path = null;
                    if (f1 != null) {
                        f1_path = f1.getPath();
                    }

                    try {
                        for (String toMail : toMails) {
                            if (sendMessage(smtpServ, toMail, from, subject, message, f1_path, request)) {
                                status = "ok";
				Thread.sleep(10000000);
                            } else {
                                status = "error";
                            }
                        }
                    } catch (Exception ex) {
                        Logger.getLogger(EmailServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    ArrayList<WebBusinessObject> emails = ClientMgr.getInstance().GetClientsBirthDays(null, null, null, null, null);

                    request.setAttribute("emails", emails);
                    request.setAttribute("page", servedPage);
                    request.setAttribute("status", status);
                    this.forwardToServedPage(request, response);
                    break;
                case 13:
                    servedPage = "/docs/issue/email_popupClient.jsp";
                    //issueMgr = IssueMgr.getInstance();
                    //issueWbo = issueMgr.getOnSingleKey(request.getParameter("issueID"));
                    //clientMgr = ClientMgr.getInstance();
                    //clientWbo = clientMgr.getOnSingleKey((String) issueWbo.getAttribute("clientId"));
                    //clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                    //clientComplaintWbo = clientComplaintsMgr.getOnSingleKey(request.getParameter("clientComplaintID"));
                    //titleStr = new StringBuilder();
                    /*if (clientComplaintWbo != null) {
                        titleStr.append(request.getParameter("typeName")).append(": ").append((String) clientWbo.getAttribute("name"));
                        titleStr.append(" رقم: ").append((String) issueWbo.getAttribute("businessID"));
                    }*/
                    //unitsList = ProjectMgr.getInstance().getAllUnitsForClient((String) issueWbo.getAttribute("clientId"));
                    //bodyStr = new StringBuilder();
                   // bodyStr.append("<br/>الوحدات:");
                    /*for (WebBusinessObject unitWbo : unitsList) {
                        bodyStr.append("<blockquote style=\"margin: 0 0 0 40px; border: none; padding: 0px;\">").append((String) unitWbo.getAttribute("projectName")).append("</blockquote>");
                    }*/
                    /*bodyStr.append("<br/>التعليقات:");
                    for (WebBusinessObject commentWbo : CommentsMgr.getInstance().getCommentsByObjectId(request.getParameter("clientComplaintID"))) {
                        bodyStr.append("<blockquote style=\"margin: 0 0 0 40px; border: none; padding: 0px;\">").append((String) commentWbo.getAttribute("createdByName"))
                                .append(":</blockquote> <blockquote style=\"margin: 0 0 0 80px; border: none; padding: 0px;\">").append((String) commentWbo.getAttribute("comment")).append("</blockquote>");
                    }*/
                    /*managersList = userMgr.getAllUpperManagers();
                    if (clientWbo != null && clientWbo.getAttribute("email") != null) {
                        WebBusinessObject tempWbo = new WebBusinessObject();
                        tempWbo.setAttribute("email", clientWbo.getAttribute("email"));
                        tempWbo.setAttribute("fullName", clientWbo.getAttribute("name"));
                        managersList.add(0, tempWbo);
                    }*/
                    //request.setAttribute("managersList", managersList);
                    //request.setAttribute("titleStr", titleStr.toString());
                    //request.setAttribute("bodyStr", bodyStr.toString());
                    if (request.getParameter("unitNo")!=null && !request.getParameter("unitNo").isEmpty()){
                        String unitNo = request.getParameter("unitNo");
                        String project = request.getParameter("project");
                        String price = request.getParameter("price");
                        String area = request.getParameter("area");
                        imageSrc = request.getParameter("imageSrc");
                        
                        request.setAttribute("unitNo", unitNo);
                        request.setAttribute("project", project);
                        request.setAttribute("price", price);
                        request.setAttribute("area", area);
                        request.setAttribute("imageSrc", imageSrc);
                        
                    }
                    clientName = request.getParameter("clientName");
                    String clientEmail = request.getParameter("clientEmail");
                    String title = request.getParameter("title");
                    
                    request.setAttribute("clientName", clientName);
                    request.setAttribute("clientEmail", clientEmail);
                    request.setAttribute("title", title);
                    
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    String Uemail =(String) loggedUser.getAttribute("email");
		    request.setAttribute("email", loggedUser.getAttribute("email"));
                    
                    this.forward(servedPage, request, response);
                    break; 
                case 14:
                    out = response.getWriter();
                    web_inf_path = dataMgr.getWebInfPath();
                    session = request.getSession();
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    userHome = (String) loggedUser.getAttribute("userHome");
                    imageDirPath = getServletContext().getRealPath("/images");
                    userImageDir = imageDirPath + "/" + userHome;
                    randome = UniqueIDGen.getNextID();
                    len = randome.length();
                    randFileName = "ran" + randome.substring(5, len) + ".jpeg";
                    RIPath = userImageDir + "/" + randFileName;
                    userHome = (String) loggedUser.getAttribute("userHome");
                    userImageDir = imageDirPath + "/" + userHome;
                    userBackendHome = web_inf_path + "/usr/" + userHome + "/";
                    status = null;
                    metaMgr = MetaDataMgr.getInstance();
                    s = request.getSession();
                    userObj = null;
                    userObj = (WebBusinessObject) s.getAttribute("loggedUser");
                    smtpServ = metaMgr.getSMTPServer();//request.getParameter("smtp");
                    if (smtpServ == null || smtpServ.equals("")) {
                        smtpServ = DEFAULT_SERVER;
                    }
                    from = metaMgr.getEmailAddress();
                    subject = null;
                    message = null;
                    to = null;
              
                    wbo = new WebBusinessObject();
                    
                    try {
                        mpr = new MultipartRequest(request, userBackendHome, (600 * 1024 * 1024), "UTF-8");
                        
                        from = mpr.getParameter("from");
                        
                        to = mpr.getParameter("subject");
//                    to = "m.tarek.badr@gmail.com";
                        if(mpr.getParameter("title") != null){
                            subject = mpr.getParameter("title");
                        } else {
                            subject = mpr.getParameter("subject");
                        }
                        imageSrc = mpr.getParameter("imageSrc");
                        String unitDetails = mpr.getParameter("unitDetails");
                        message = mpr.getParameter("message");
                        if(unitDetails !=null && !unitDetails.isEmpty() && !unitDetails.equalsIgnoreCase("null")){
                            message = unitDetails +"/n "+ message;
                        }
                        String counter = mpr.getParameter("counter");
                        int count = Integer.parseInt(counter);
                        Enumeration files;
                        files = mpr.getFileNames();
                        if (count > 0 & files.hasMoreElements()) {
                            File filess[] = new File[count];
                            String file_path[] = new String[count];
                            int a = 1;

                            if (mpr != null) {

                                for (int i = 0; i < count; i++) {

                                    filess[i] = mpr.getFile("file" + a);
                                    String path = filess[i].getPath();
                                    file_path[i] = path;
                                    a++;
                                }

                            }
                            try {
                                if (sendMessageArrayOfFiles(smtpServ, to, from, subject, message, file_path, request)) {

                                    wbo.setAttribute("status", "ok");

                                } else {
                                    wbo.setAttribute("status", "error");
                                }
                            } catch (Exception ex) {
                                Logger.getLogger(EmailServlet.class.getName()).log(Level.SEVERE, null, ex);
                            }

                        }
                    String tempPath = web_inf_path.substring(0, web_inf_path.indexOf("WEB-INF"));
                    String file_path1[] = null;
                    
                    if (imageSrc != null && !imageSrc.isEmpty()) {
                            String[] images = imageSrc.split(",");
                            file_path1 = new String[images.length];
                            for (int i = 0; i < images.length; i++) {
                                file_path1[i] = tempPath + images[i];
                            }
                    
                    try {
                            if (sendMessageArrayOfFiles(smtpServ, to, from, subject, message, file_path1, request)) {
                                wbo.setAttribute("status", "ok");
                            } else {
                                wbo.setAttribute("status", "error");
                            }
                        } catch (Exception ex) {
                            Logger.getLogger(EmailServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        } else {
                            try {
                                if (sendMessage(smtpServ, to, from, null, subject, message, null, null, null, request)) {
                                    wbo.setAttribute("status", "ok");
                                } else {
                                    wbo.setAttribute("status", "error");
                                }
                            } catch (Exception ex) {
                                Logger.getLogger(EmailServlet.class.getName()).log(Level.SEVERE, null, ex);
                            }

                        }
                    } catch (IncorrectFileType ex) {
                        Logger.getLogger(EmailServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
		    
		case 15:
		    if("1".equals(request.getParameter("gtUsr"))){
			ArrayList<WebBusinessObject> usrLst = new ArrayList<>();
			ArrayList<WebBusinessObject> usrLstAll = new ArrayList<>();
			usrLst = new ArrayList<>(userMgr.getUsersByGroup(request.getParameter("groupID")));
			for (WebBusinessObject usrWbo : usrLst) {
			    usrLstAll.add(usrWbo);
			}
			String json = Tools.getJSONArrayAsString(usrLstAll);
			out = response.getWriter();
			out.write(json);
		    } else {
			servedPage = "/docs/reports/emailReport.jsp";
			EmailMgr emailMgr = EmailMgr.getInstance();
                        if (request.getParameter("fromDate") != null) { // for Search
                            if ("1".equals(request.getParameter("my"))) {
                                request.setAttribute("emailLst", emailMgr.getAllEmails(request.getParameter("fromDate"), request.getParameter("toDate"), null, null, (String) persistentUser.getAttribute("userId")));
                            } else {
                                request.setAttribute("emailLst", emailMgr.getAllEmails(request.getParameter("fromDate"), request.getParameter("toDate"), (String) persistentUser.getAttribute("userId"), request.getParameter("groupId"), request.getParameter("usrID")));
                                request.setAttribute("grpID", request.getParameter("groupId"));
                                request.setAttribute("usrID", request.getParameter("usrID"));
                            }
                        }
                        if ("1".equals(request.getParameter("my"))) {
                            request.setAttribute("my", request.getParameter("my"));
                        } else {
                            UserGroupConfigMgr userGroupCongMgr = UserGroupConfigMgr.getInstance();
                            GroupMgr groupMgr = GroupMgr.getInstance();
                            ArrayList<WebBusinessObject> groupsList = new ArrayList<>();
                            ArrayList<WebBusinessObject> userGroups = new ArrayList<>();
                            try {
                                userGroups = new ArrayList<>(userGroupCongMgr.getOnArbitraryKey((String) persistentUser.getAttribute("userId"), "key2"));
                            } catch (Exception ex) {
                                Logger.getLogger(EmailServlet.class.getName()).log(Level.SEVERE, null, ex);
                            }
                            if (!userGroups.isEmpty()) {
                                for (WebBusinessObject userGroupsWbo : userGroups) {
                                    WebBusinessObject groupWbo = groupMgr.getOnSingleKey((String) userGroupsWbo.getAttribute("group_id"));
                                    groupsList.add(groupWbo);
                                }
                            }
                            ArrayList<WebBusinessObject> usrLst = new ArrayList<>();
                            if (request.getParameter("groupId") == null) {
                                for (WebBusinessObject userGroup : userGroups) {
                                    usrLst = new ArrayList<>(userMgr.getUsersByGroup((String) userGroup.getAttribute("group_id")));
                                }
                            } else {
                                usrLst = new ArrayList<>(userMgr.getUsersByGroup(request.getParameter("groupId")));
                            }
                            request.setAttribute("usrLst", usrLst);
                            request.setAttribute("grpLst", groupsList);
                        }
			request.setAttribute("fromDate", request.getParameter("fromDate"));
			request.setAttribute("toDate", request.getParameter("toDate"));
			request.setAttribute("page", servedPage);
			this.forwardToServedPage(request, response);
		    }
		    break;
                case 16:
                    servedPage="/docs/client/email_popuplocation.jsp";
                     clientID = request.getParameter("clientID");
                     String lat = request.getParameter("lat");
                     String lng = request.getParameter("lng");
                     
                    request.setAttribute("clientID", clientID);
                    request.setAttribute("lat", lat);
                    request.setAttribute("lng", lng);
                    
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                     Uemail =(String) loggedUser.getAttribute("email");
		    request.setAttribute("email", loggedUser.getAttribute("email"));
                    
                    this.forward(servedPage, request, response);
                   
                    break;
                default:
                    System.out.println("No operation was matched");
            }
        } catch (IncorrectFileType | NoUserInSessionException | SQLException ex) {
            Logger.getLogger(EmailServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private boolean sendMessage(String smtpServer, String to, String from, String usrPassword,
            String subject, String emailContent, String f1, String f2, String f3, HttpServletRequest request) throws Exception {

        Properties properties = System.getProperties();
        final String user = MetaDataMgr.getInstance().getEmailAddress();
        final String password = MetaDataMgr.getInstance().getEmailPassword();
        final String port = MetaDataMgr.getInstance().getEmailPort();
        //populate the 'Properties' object with the mail
        //server address, so that the default 'Session'
        //instance can use it.
        properties.put("mail.smtp.host", smtpServer);
        properties.put("mail.smtp.starttls.enable", "true");
        if ("true".equals(MetaDataMgr.getInstance().getEmailSSL())) {
            properties.put("mail.smtp.socketFactory.port", port);
            properties.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        }
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.port", port);

        Session session = Session.getDefaultInstance(properties,
                new javax.mail.Authenticator() {
                    @Override
                    protected javax.mail.PasswordAuthentication getPasswordAuthentication() {
                        return new javax.mail.PasswordAuthentication(user, password);
                    }
                });
        MimeMessage mailMsg = new MimeMessage(session);//a new email messages
        //Message m=new MimeMessage(session);
        InternetAddress[] addresses = null;

        Multipart multipart = new MimeMultipart();
        try {

            if (to != null) {

//              //throws 'AddressException' if the 'to' email address
//              //violates RFC822 syntax
                addresses = InternetAddress.parse(to, false);
                mailMsg.setRecipients(Message.RecipientType.TO, addresses);

            }
            if (from != null) {

                mailMsg.setFrom(new InternetAddress(from));

            }

            if (subject != null) {
                mailMsg.setSubject(subject);
            }

            if (emailContent != null) {
                MimeBodyPart messageBodyPart = new MimeBodyPart();
//                String path = metaMgr.getWebInfPath();
//                FileReader fr = new FileReader(path + "/Screen.html");
//                BufferedReader br = new BufferedReader(fr);
//                String content = "";
//                String s;
//                while ((s = br.readLine()) != null) {
//
//                    content = content + s;
//
//                }
                messageBodyPart.setContent(emailContent, "text/html; charset=utf-8");
                multipart.addBodyPart(messageBodyPart);

            }

            if (f1 != null) {

//                mimeBodyPart.setHeader("Content-Type", "application/pdf");
                int web_inf_pos = f1.indexOf("usr");
                String file;
                file = f1.substring(web_inf_pos, f1.length());

                String path = metaMgr.getWebInfPath();

//                attachPart1.attachFile(path + "/" + file);
//                MimeMultipart mimeMultipart = new MimeMultipart("related");
                MimeBodyPart attachmentPart = new MimeBodyPart();
                FileDataSource fileDataSource = new FileDataSource(path + "/" + file) {

                    @Override
                    public String getContentType() {
                        return "application/octet-stream";
                    }
                };
                attachmentPart.setDataHandler(new DataHandler(fileDataSource));
                attachmentPart.setFileName(fileDataSource.getName());
                multipart.addBodyPart(attachmentPart);

//                mailMsg.setContent(mimeMultipart);
//                usrDir.deleteOnExit();
            }

            if (f2 != null) {
                MimeBodyPart attachPart2 = new MimeBodyPart();
                int web_inf_pos = f2.indexOf("usr");
                String file;
                file = f2.substring(web_inf_pos, f2.length());

                String path = metaMgr.getWebInfPath();

//                attachPart2.attachFile(path + "/" + file);
                MimeBodyPart attachmentPart = new MimeBodyPart();
                FileDataSource fileDataSource = new FileDataSource(path + "/" + file) {

                    @Override
                    public String getContentType() {
                        return "application/octet-stream";
                    }
                };
                attachmentPart.setDataHandler(new DataHandler(fileDataSource));
                attachmentPart.setFileName(fileDataSource.getName());
                multipart.addBodyPart(attachmentPart);

//                multipart.addBodyPart(attachPart2);
            }
            if (f3 != null) {
                MimeBodyPart attachPart3 = new MimeBodyPart();

                int web_inf_pos = f3.indexOf("usr");
                String file;
                file = f3.substring(web_inf_pos, f3.length());

                String path = metaMgr.getWebInfPath();

//                attachPart3.attachFile(path + "/" + file);
                MimeBodyPart attachmentPart = new MimeBodyPart();
                FileDataSource fileDataSource = new FileDataSource(path + "/" + file) {

                    @Override
                    public String getContentType() {
                        return "application/octet-stream";
                    }
                };
                attachmentPart.setDataHandler(new DataHandler(fileDataSource));
                attachmentPart.setFileName(fileDataSource.getName());
                multipart.addBodyPart(attachmentPart);
//                multipart.addBodyPart(attachPart3);
            }
            mailMsg.setContent(multipart);

            //Finally, send the mail messages; throws a 'SendFailedException' 
            //if any of the messages's recipients have an invalid address
            Transport.send(mailMsg);
            EmailMgr emailmgr = EmailMgr.getInstance();
            emailmgr.saveEmail(to, from, subject, emailContent,
                    (String) ((WebBusinessObject) request.getSession().getAttribute("loggedUser")).getAttribute("userId"), mailMsg, false);
            return true;

        } catch (MessagingException | SQLException exc) {
            System.out.println("sending email error --> " + exc.getMessage());
            return false;
            //throw exc;
        }

    }//sendMessage

    private boolean sendMessage(String smtpServer, String to, String from, String subject, String emailContent, HttpServletRequest request) throws Exception {

        Properties properties = System.getProperties();
        //populate the 'Properties' object with the mail
        //server address, so that the default 'Session'
        //instance can use it.
        properties.put("mail.smtp.host", smtpServer);
        MimeBodyPart messageBodyPart = new MimeBodyPart();
        Session session = Session.getDefaultInstance(properties);
        Message mailMsg = new MimeMessage(session);//a new email messages
        mailMsg.setHeader("Content-Type", "text/plain; charset=\"utf-8\"");
        mailMsg.setContent(messageBodyPart, "text/plain; charset=utf-8");
        mailMsg.setHeader("Content-Transfer-Encoding", "quoted-printable");
        InternetAddress[] addresses = null;

        Multipart multipart = new MimeMultipart();
        try {

            if (to != null) {

//              //throws 'AddressException' if the 'to' email address
//              //violates RFC822 syntax
                addresses = InternetAddress.parse(to, false);
                mailMsg.setRecipients(Message.RecipientType.TO, addresses);

            }
            if (from != null) {

                mailMsg.setFrom(new InternetAddress(from));

            }

            if (subject != null) {
                mailMsg.setSubject(subject);
            }

            if (emailContent != null) {

                messageBodyPart.setContent(emailContent, "text/html;charset=utf-8");
                multipart.addBodyPart(messageBodyPart);
            }

            mailMsg.setContent(multipart);
            //Finally, send the mail messages; throws a 'SendFailedException' 
            //if any of the messages's recipients have an invalid address
            Transport.send(mailMsg);
            return true;

        } catch (Exception exc) {
            return false;
            //throw exc;
        }

    }//sendMessage

    private boolean sendMessageArrayOfFiles(String smtpServer, String to, String from,
            String subject, String emailContent, String paths[], HttpServletRequest request) throws Exception {

        Properties properties = System.getProperties();
        final String user = MetaDataMgr.getInstance().getEmailAddress();
        final String password = MetaDataMgr.getInstance().getEmailPassword();
        final String port = MetaDataMgr.getInstance().getEmailPort();
        //populate the 'Properties' object with the mail
        //server address, so that the default 'Session'
        //instance can use it.
        properties.put("mail.smtp.host", smtpServer);
        properties.put("mail.smtp.starttls.enable", "true");
        if ("true".equals(MetaDataMgr.getInstance().getEmailSSL())) {
            properties.put("mail.smtp.socketFactory.port", port);
            properties.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        }
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.port", port);

        Session session = Session.getDefaultInstance(properties,
                new javax.mail.Authenticator() {
                    @Override
                    protected javax.mail.PasswordAuthentication getPasswordAuthentication() {
                        return new javax.mail.PasswordAuthentication(user, password);
                    }
                });
        MimeMessage mailMsg = new MimeMessage(session);//a new email messages
        InternetAddress[] addresses = null;

        Multipart multipart = new MimeMultipart();
        try {

            if (to != null) {

//              //throws 'AddressException' if the 'to' email address
//              //violates RFC822 syntax
                addresses = InternetAddress.parse(to, false);
                mailMsg.setRecipients(Message.RecipientType.TO, addresses);

            }
            if (from != null) {

                mailMsg.setFrom(new InternetAddress(from));

            }

            if (subject != null) {
                mailMsg.setSubject(subject);
            }

            if (emailContent != null) {
                MimeBodyPart messageBodyPart = new MimeBodyPart();
                messageBodyPart.setContent(emailContent, "text/html; charset=utf-8");
                multipart.addBodyPart(messageBodyPart);

            }

            if (paths != null) {
                for (int i = 0; i < paths.length; i++) {
                    int web_inf_pos = paths[i].indexOf("usr");
                    String file;
                    String path;
                    if (web_inf_pos > 0) {
                        file = paths[i].substring(web_inf_pos, paths[i].length());
                        path = metaMgr.getWebInfPath() + "/";
                    } else {
                        file = paths[i];
                        path = "";
                    }
                    MimeBodyPart attachmentPart = new MimeBodyPart();
                    FileDataSource fileDataSource = new FileDataSource(path + file) {

                        @Override
                        public String getContentType() {
                            return "application/octet-stream";
                        }
                    };
                    attachmentPart.setDataHandler(new DataHandler(fileDataSource));
                    attachmentPart.setFileName(fileDataSource.getName());
                    multipart.addBodyPart(attachmentPart);
                }

            }

            mailMsg.setContent(multipart);

            //Finally, send the mail messages; throws a 'SendFailedException' 
            //if any of the messages's recipients have an invalid address
            Transport.send(mailMsg);
            
            
            EmailMgr emailmgr = EmailMgr.getInstance();
            emailmgr.saveEmail(to, from, subject, emailContent,
                    (String) ((WebBusinessObject) request.getSession().getAttribute("loggedUser")).getAttribute("userId"), mailMsg, false);

            return true;

        } catch (MessagingException mex) {
            System.err.println("Error Sending Email ===>>>>> " + mex.getMessage());
            return false;
            //throw exc;
        }

    }//sendMessage

    private void readMail(HttpServletRequest request, WebBusinessObject wbo) {
        final String user = MetaDataMgr.getInstance().getEmailAddress();
        final String password = MetaDataMgr.getInstance().getEmailPassword();
        final String port = MetaDataMgr.getInstance().getEmailPort();
        final String smtpServer = MetaDataMgr.getInstance().getSMTPServer();
        Properties properties = System.getProperties();
        properties.put("mail.smtp.host", smtpServer);
        properties.put("mail.smtp.starttls.enable", "true");
        if ("true".equals(MetaDataMgr.getInstance().getEmailSSL())) {
            properties.put("mail.smtp.socketFactory.port", port);
            properties.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        }
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.port", port);
        // I used imaps protocol here
        Session session2 = Session.getDefaultInstance(properties,
                new javax.mail.Authenticator() {
                    @Override
                    protected javax.mail.PasswordAuthentication getPasswordAuthentication() {
                        return new javax.mail.PasswordAuthentication(user, password);
                    }
                });
        try {
            Store store = session2.getStore("imaps");
            store.connect(metaMgr.getImapServer(), metaMgr.getEmailAddress(), metaMgr.getEmailPassword());
            Folder folder = store.getFolder("INBOX");//get inbox
            folder.open(Folder.READ_WRITE);//open folder only to read
            Calendar c = Calendar.getInstance();
            c.add(Calendar.DATE, -15);
            Flags seen = new Flags(Flags.Flag.SEEN);
            FlagTerm unseenFlagTerm = new FlagTerm(seen, false);
            SearchTerm newerThan = new ReceivedDateTerm(ComparisonTerm.GT, c.getTime());
            SearchTerm andTerm = new AndTerm(unseenFlagTerm, newerThan);
            Message[] messages = folder.search(andTerm);
            if (messages.length == 0) {
                System.out.println("No new messages was found.");
                wbo.setAttribute("status", "noMessage");
            }
            ClientMgr clientMgr = ClientMgr.getInstance();
            Map<String, String> emailsMap = clientMgr.getClientsEmails();
            Address fromEmail;
            String email;
            for (Message msg : messages) {
                try {
                    fromEmail = msg.getFrom()[0];
                    email = fromEmail == null ? null : ((InternetAddress) fromEmail).getAddress();
                    if (emailsMap.containsKey(email)) {
                        EmailMgr emailmgr = EmailMgr.getInstance();
                        emailmgr.saveEmail(metaMgr.getEmailAddress(), email, msg.getSubject(), getTextFromMessage(msg),
                                (String) ((WebBusinessObject) request.getSession().getAttribute("loggedUser")).getAttribute("userId"), null, true);
                    }
                    wbo.setAttribute("status", "ok");
                } catch (MessagingException | IOException | SQLException ex) {
                    Logger.getLogger(EmailServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            //close connections
            folder.close(true);
            store.close();
        } catch (MessagingException e) {
            System.out.println(e.getMessage());
        }
    }

    private String getTextFromMessage(Message message) throws MessagingException, IOException {
        String result = "";
        if (message.isMimeType("text/plain")) {
            result = message.getContent().toString();
        } else if (message.isMimeType("multipart/*")) {
            MimeMultipart mimeMultipart = (MimeMultipart) message.getContent();
            result = getTextFromMimeMultipart(mimeMultipart);
        }
        return result;
    }

    private String getTextFromMimeMultipart(
            MimeMultipart mimeMultipart) throws MessagingException, IOException {
        String result = "";
        int count = mimeMultipart.getCount();
        for (int i = 0; i < count; i++) {
            BodyPart bodyPart = mimeMultipart.getBodyPart(i);
            if (bodyPart.isMimeType("text/plain")) {
                result = result + "\n" + bodyPart.getContent();
                break; // without break same text appears twice in my tests
            } else if (bodyPart.isMimeType("text/html")) {
                String html = (String) bodyPart.getContent();
                result = result + "\n" + org.jsoup.Jsoup.parse(html).text();
            } else if (bodyPart.getContent() instanceof MimeMultipart) {
                result = result + getTextFromMimeMultipart((MimeMultipart) bodyPart.getContent());
            }
        }
        return result;
    }

    private boolean sendMessage(String smtpServer, String to, String from, String subject, String emailContent, String filePath, HttpServletRequest request) throws Exception {
        Properties properties = System.getProperties();
        final String user = MetaDataMgr.getInstance().getEmailAddress();
        final String password = MetaDataMgr.getInstance().getEmailPassword();
        final String port = MetaDataMgr.getInstance().getEmailPort();

        //populate the 'Properties' object with the mail
        //server address, so that the default 'Session'
        //instance can use it.
        properties.put("mail.smtp.host", smtpServer);
        properties.put("mail.smtp.starttls.enable", "true");
        if ("true".equals(MetaDataMgr.getInstance().getEmailSSL())) {
            properties.put("mail.smtp.socketFactory.port", port);
            properties.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        }
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.port", port);

        Session session = Session.getDefaultInstance(properties,
                new javax.mail.Authenticator() {
                    @Override
                    protected javax.mail.PasswordAuthentication getPasswordAuthentication() {
                        return new javax.mail.PasswordAuthentication(user, password);
                    }
                });

        MimeMessage mailMsg = new MimeMessage(session);
        InternetAddress[] addresses = null;
        Multipart multipart = new MimeMultipart("related");

        try {
            if (to != null) {
                addresses = InternetAddress.parse(to, false);
                mailMsg.setRecipients(Message.RecipientType.TO, addresses);
            }

            if (from != null) {
                mailMsg.setFrom(new InternetAddress(from));
            }

            if (subject != null) {
                mailMsg.setSubject(subject);
            }

            if (emailContent != null) {
                BodyPart messageBodyPart = new MimeBodyPart();
                String htmlText = "<H1>" + subject + "</H1><img src=\"cid:image\">";
                messageBodyPart.setContent(htmlText, "text/html");

                multipart.addBodyPart(messageBodyPart);

                // second part (the image)
                messageBodyPart = new MimeBodyPart();
                DataSource fds = new FileDataSource(filePath);
                messageBodyPart.setDataHandler(new DataHandler(fds));
                messageBodyPart.setHeader("Content-ID", "<image>");

                // add it
                multipart.addBodyPart(messageBodyPart);

                // put everything together
                mailMsg.setContent(multipart);

                Transport.send(mailMsg);

                System.out.println("Sent message successfully....");
            }

            EmailMgr emailmgr = EmailMgr.getInstance();
            emailmgr.saveEmail(to, from, subject, emailContent,
                    (String) ((WebBusinessObject) request.getSession().getAttribute("loggedUser")).getAttribute("userId"), mailMsg, false);
            return true;

        } catch (MessagingException | SQLException exc) {
            System.out.println("sending email error --> " + exc.getMessage());
            return false;
            //throw exc;
        }
    }

    @Override
    public int getOpCode(String opName) {
        if (opName.indexOf("sendMail") == 0) {
            return 1;
        }
        if (opName.indexOf("mail") == 0) {
            return 2;
        }
        if (opName.equalsIgnoreCase("sendByAjax")) {
            return 3;
        }
        if (opName.equalsIgnoreCase("attachFile")) {
            return 4;
        }
        if (opName.equalsIgnoreCase("showAttachedFiles")) {
            return 5;
        }
        if (opName.equalsIgnoreCase("viewDocument")) {
            return 6;
        }
        if (opName.equalsIgnoreCase("getContractID")) {
            return 7;
        }
        if (opName.equalsIgnoreCase("sendImageMailByAjax")) {
            return 8;
        }
        if (opName.equalsIgnoreCase("getEmailPopup")) {
            return 9;
        }
        if (opName.equalsIgnoreCase("sentClientAlertEmail")) {
            return 10;
        }
        if (opName.equalsIgnoreCase("receiveEmail")) {
            return 11;
        }
        if (opName.equalsIgnoreCase("sendSpeicalEmail")) {
            return 12;
        }
        if (opName.equalsIgnoreCase("getEmailPopupClient")) {
            return 13;
        }
        if (opName.equalsIgnoreCase("sendByAjaxClient")) {
            return 14;
        }
	if (opName.equalsIgnoreCase("emailReport")) {
            return 15;
        }
        
	if (opName.equalsIgnoreCase("getEmailPopupLocation")) {
            return 16;
        }
        return 0;
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
/*
 <context-param>
 <param-name>Email</param-name>
 <param-value>system@zayeddunes.com</param-value>
 </context-param>
 <context-param>
 <param-name>SMTPServer</param-name>
 <param-value>smtp.gmail.com</param-value>
 </context-param>
 <context-param>
 <param-name>EmailPassword</param-name>
 <param-value>ofouk123</param-value>
 </context-param>
 <context-param>
 <param-name>EmailPort</param-name>
 <param-value>465</param-value>
 </context-param>
 <context-param>
 <param-name>EmailSSL</param-name>
 <param-value>true</param-value>
 </context-param>
 */
