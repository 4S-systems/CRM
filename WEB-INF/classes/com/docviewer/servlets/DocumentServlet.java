package com.docviewer.servlets;

import com.clients.db_access.ClientComplaintsMgr;
import com.clients.servlets.ClientServlet;
import com.maintenance.common.Tools;
import com.maintenance.db_access.IssueDocumentMgr;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.common.UserMgr;
import com.silkworm.db_access.FileMgr;
import com.silkworm.email.EmailUtility;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.servlets.MultipartRequest;
import java.awt.image.BufferedImage;
import java.sql.SQLException;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.imageio.ImageIO;

public class DocumentServlet extends ImageHandlerServlet {

    private String documentId = null;
    private WebBusinessObject document;
    private String documentType = null;
    private String metaType = null;
    private IssueDocumentMgr issueDocumentMgr = IssueDocumentMgr.getInstance();
    private String randomFileName = null;
    private String random = null;
    FileMgr fileMgr = FileMgr.getInstance();
    WebBusinessObject fileDescriptor = null;
    BufferedInputStream gifData = null;
    BufferedImage myImage = null;
    String app = null;
    String randFileName = null;
    String randome = null;
    int len = 0;
    private int length = 0;
    private PrintWriter out;

    ;
    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

    }

    @Override
    public void destroy() {
    }

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        super.processRequest(request, response);
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");

        String op = (String) request.getParameter("op");
        operation = getOpCode(op);

        try {
            switch (operation) {
                case 49:
                    documentId = request.getParameter("documentId");
                    document = issueDocumentMgr.getOnSingleKey(documentId);
                    documentType = (String) document.getAttribute("documentType");
                    metaType = (String) document.getAttribute("metaType");
                    random = UniqueIDGen.getNextID();
                    length = random.length();

                    if(document.getAttribute("option1") == null || document.getAttribute("option1").equals("UL")) {
                        randomFileName = "random_" + random.substring(5, length) + "." + documentType;
                    } else {
                        randomFileName = (String) document.getAttribute("option1");
                    }

                    BufferedInputStream data = new BufferedInputStream(issueDocumentMgr.getImage(documentId));

                    ServletOutputStream stream = null;
                    try {
                        stream = response.getOutputStream();
                        response.setContentType("application/" + metaType);
                        response.addHeader("Content-Disposition", "attachment; filename=" + randomFileName);
                        int readBytes = 0;
                        while ((readBytes = data.read()) != -1) {
                            stream.write(readBytes);
                        }
                    } catch (IOException ioe) {
                        throw new ServletException(ioe.getMessage());
                    } finally {
                        if (stream != null) {
                            stream.close();
                        }
                        if (data != null) {
                            data.close();
                        }
                    }
                    break;
                case 50:
                    WebBusinessObject wbo = new WebBusinessObject();
                    out = response.getWriter();
                    mpr = new MultipartRequest(request, userBackendHome, (600 * 1024 * 1024), "UTF-8");
                    if (issueDocumentMgr.saveMultiDocument(mpr, session)) {
                        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
                        UserMgr userMgr = UserMgr.getInstance();
                        ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                        WebBusinessObject clientComplaintsWbo = clientComplaintsMgr.getOnSingleKey(mpr.getParameter("compId"));
                        if (loggedUser != null && clientComplaintsWbo != null && clientComplaintsWbo.getAttribute("createdBy") != null) {
                            WebBusinessObject sourceUserWbo = userMgr.getOnSingleKey((String) clientComplaintsWbo.getAttribute("createdBy"));
                            WebBusinessObject attachUserWbo = userMgr.getOnSingleKey((String) loggedUser.getAttribute("userId"));
                            if (metaDataMgr.getSendMail() != null && metaDataMgr.getSendMail().equals("1")
                                    && sourceUserWbo != null && sourceUserWbo.getAttribute("email") != null
                                    && attachUserWbo != null && attachUserWbo.getAttribute("fullName") != null) {
                                String toEmail = (String) sourceUserWbo.getAttribute("email");
                                String subject = "تم أرفاق ملف للطلب " + clientComplaintsWbo.getAttribute("businessCompID") + " بواسطة " + attachUserWbo.getAttribute("fullName");
                                String content = "";
                                try {
                                    EmailUtility.sendMessage(toEmail, subject, content);
                                } catch (Exception ex) {
                                    Logger.getLogger(this.getClass().getName()).log(Level.SEVERE, null, ex);
                                }
                            }
                        }
                        wbo.setAttribute("status", "success");
                    } else {
                        wbo.setAttribute("status", "failed");
                    }

                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                case 51:

                    servedPage = "/show_attached_files.jsp";
                    String compId = (String) request.getParameter("compId");

                    issueDocumentMgr = IssueDocumentMgr.getInstance();
                    Vector documents = new Vector();
                    try {
                        documents = issueDocumentMgr.getOnArbitraryKey(compId, "key5");
                    } catch (SQLException ex) {
                    } catch (Exception ex) {
                        Logger.getLogger(ClientServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    request.setAttribute("page", servedPage);
                    request.setAttribute("documents", documents);
                    this.forward(servedPage, request, response);
                    break;
                case 52:

                    String docType = request.getParameter("docType");
                    String docID = request.getParameter("docID");

                    fileDescriptor = fileMgr.getObjectFromCash(docType);

                    app = (String) fileDescriptor.getAttribute("app");

                    if (docType.equalsIgnoreCase("jpg")) {
                        servedPage = "/docs/unit_doc_handling/image_renderer.jsp";
                        request.setAttribute("page", servedPage);
                        randome = UniqueIDGen.getNextID();
                        len = randome.length();

                        randFileName = new String("ran" + randome.substring(5, len) + ".jpeg");


                        RIPath = userImageDir + "/" + randFileName;


                        absPath = "images/" + userHome + "/" + randFileName;

                        docImage = new File(RIPath);
                        docID = request.getParameter("docID");
                        gifData = new BufferedInputStream(issueDocumentMgr.getImage(docID));
                        myImage = ImageIO.read(gifData);
                        ImageIO.write(myImage, "jpeg", docImage);
                        wbo = new WebBusinessObject();
                        out = response.getWriter();
                        wbo.setAttribute("status", "ok");
                        wbo.setAttribute("imagePath", absPath);
                        out.write(Tools.getJSONObjectAsString(wbo));

                        break;
                    }
                    else {
                        String docName = request.getParameter("docID");
                        randome = UniqueIDGen.getNextID();
                        len = randome.length();
                        stream = null;

                        randFileName = "ran" + randome.substring(5, len) + docType;

                        RIPath = userImageDir + "/" + randFileName;
                        BufferedInputStream pdfData
                                = new BufferedInputStream(issueDocumentMgr.getImage(docID));
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
                default:


            }

        } catch (Exception e) {
            System.out.println("Image Reader sevlet exception " + e.getMessage());
        }
    }

    /**
     * Handles the HTTP
     * <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP
     * <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     */
    @Override
    public String getServletInfo() {
        return "Document Reaer";
    }

    @Override
    protected int getOpCode(String operation) {
        if (operation.equalsIgnoreCase("downloadDocument")) {
            return 49;
        }
        if (operation.equalsIgnoreCase("saveMultiFiles")) {
            return 50;
        }
        if (operation.equalsIgnoreCase("showAttachedFiles")) {
            return 51;
        }
        if (operation.equalsIgnoreCase("viewDocument")) {
            return 52;
        }
        return 0;
    }
}