package com.silkworm.uploader;

import com.clients.db_access.ClientComplaintsMgr;
import com.crm.common.CRMConstants;
import com.docviewer.db_access.DocTypeMgr;
import com.docviewer.servlets.ImageHandlerServlet;
import com.maintenance.common.Tools;
import com.maintenance.db_access.ComplaintsIssueViewMgr;
import com.maintenance.db_access.IssueDocumentMgr;
import com.silkworm.business_objects.WebBusinessObject;
import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

//this to be used with Java Servlet 3.0 API
@MultipartConfig
public class FileUploadServlet extends ImageHandlerServlet {

    private static final long serialVersionUID = 1L;
    private IssueDocumentMgr documentMgr;
    private List<FileMeta> files;
    private List<WebBusinessObject> documents;
    private List<WebBusinessObject> images;
    private BufferedInputStream buffered;
    private String documentId;
    private String documentName;
    private String documentType;
    private String businessObjectId;
    private String objectType;

    /**
     * Destroys the servlet.
     */
    @Override
    public void destroy() {
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws javax.servlet.ServletException
     * @throws java.io.IOException
     */
    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String loggegUserId = (String) loggedUser.getAttribute("userId");

        documentMgr = IssueDocumentMgr.getInstance();
        operation = getOpCode(request.getParameter("op"));
        switch (operation) {
            case 1:
                servedPage = "/docs/upload/upload.jsp";
                DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
                request.setAttribute("docTypesList", new ArrayList<>(docTypeMgr.getCashedTable()));
                this.forward(servedPage, request, response);
                break;

            case 2:
                PrintWriter out = response.getWriter();
                businessObjectId = request.getParameter("businessObjectId");
                objectType = request.getParameter("objectType");
                String documentType = request.getParameter("documentType");
                files = MultipartRequestHandler.uploadByJavaServletAPI(request);
                WebBusinessObject data = new WebBusinessObject();
                boolean status=documentMgr.saveDocuments(files, businessObjectId, objectType, loggegUserId, documentType);
                data.setAttribute("documentID", documentMgr.getDocumentID());
                docTypeMgr = DocTypeMgr.getInstance();
                //request.setAttribute("docTypesList", new ArrayList<>(docTypeMgr.getCashedTable()));
                
                out.write(Tools.getJSONObjectAsString(data));
                break;

            case 3:
                servedPage = "/docs/calendar/demo.jsp";
                businessObjectId = request.getParameter("businessObjectId");
                objectType = request.getParameter("objectType");

                documents = documentMgr.getImagesList(businessObjectId, objectType);
                images = new ArrayList<>();
                DocumentInfo info;
                for (WebBusinessObject document : documents) {
                    documentId = (String) document.getAttribute("documentID");
                    documentName = (String) document.getAttribute("documentTitle");
                    documentType = (String) document.getAttribute("documentType");
                    buffered = new BufferedInputStream(documentMgr.getImage(documentId));

                    info = getDocumentInfo(buffered, documentName, documentType, loggedUser);
                    if (info != null) {
                        document.setAttribute("imagePath", info.getPath());
                        document.setAttribute("imageWidth", info.getWidth());
                        document.setAttribute("imageHeight", info.getHeight());
                        images.add(document);
                    }
                }
                request.setAttribute("images", images);
                this.forward(servedPage, request, response);
                break;
            case 4:
                servedPage = "/docs/calendar/demo.jsp";
                businessObjectId = request.getParameter("businessObjectId");

                documents = documentMgr.getImagesList(businessObjectId, CRMConstants.OBJECT_TYPE_ISSUE);
                ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                try {
                    ArrayList<WebBusinessObject> clientComplaintsList = clientComplaintsMgr.getOnArbitraryKey2(businessObjectId, "key1");
                    for(WebBusinessObject clientComplaintsWbo : clientComplaintsList) {
                        documents.addAll(documentMgr.getAllImagesList((String) clientComplaintsWbo.getAttribute("id")));
                    }
                } catch (Exception ex) {
                    Logger.getLogger(FileUploadServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                images = new ArrayList<WebBusinessObject>();
                for (WebBusinessObject document : documents) {
                    documentId = (String) document.getAttribute("documentID");
                    documentName = (String) document.getAttribute("documentTitle");
                    documentType = (String) document.getAttribute("documentType");
                    buffered = new BufferedInputStream(documentMgr.getImage(documentId));

                    info = getDocumentInfo(buffered, documentName, documentType, loggedUser);
                    if (info != null) {
                        document.setAttribute("imagePath", info.getPath());
                        document.setAttribute("imageWidth", info.getWidth());
                        document.setAttribute("imageHeight", info.getHeight());
                        images.add(document);
                    }
                }
                request.setAttribute("images", images);
                this.forward(servedPage, request, response);
                break;
            case 5:
                servedPage = "/docs/upload/view_documents.jsp";
                ComplaintsIssueViewMgr complaintsIssueMgr = ComplaintsIssueViewMgr.getInstance();
                try {
                    request.setAttribute("data", new ArrayList<>(complaintsIssueMgr.getOnArbitraryKeyOracle(request.getParameter("businessObjectId"), "key3")));
                } catch (Exception ex) {
                    request.setAttribute("data", new ArrayList<>());
                }
                this.forward(servedPage, request, response);
                break;

            default:
                break;
        }
    }

    /**
     * *************************************************
     * URL: /upload doPost(): upload the files and other parameters
     *
     * ************************************************** @param request
     * @param request
     * @param response
     * @throws javax.servlet.ServletException
     * @throws java.io.IOException
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * *************************************************
     * URL: /upload?f=value doGet(): get file of index "f" from List<FileMeta>
     * as an attachment
     *
     **************************************************
     * @param request
     * @param response
     * @throws javax.servlet.ServletException
     * @throws java.io.IOException
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return
     */
    @Override
    public String getServletInfo() {
        return "FileUploadServlet Servlet";
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("getUploadDialog")) {
            return 1;
        }
        if (opName.equalsIgnoreCase("upload")) {
            return 2;
        }
        if (opName.equalsIgnoreCase("getGalleryDialog")) {
            return 3;
        }
        if (opName.equalsIgnoreCase("getAllIssueGallaryDialog")) {
            return 4;
        }
        if (opName.equalsIgnoreCase("viewDocuments")) {
            return 5;
        }

        return 0;
    }

    private DocumentInfo getDocumentInfo(InputStream stream, String name, String type, WebBusinessObject loggedUser) {
        try {
            String fileName = name + "_" + System.currentTimeMillis() + "." + type;
            String home = (String) loggedUser.getAttribute("userHome");
            String path = "images/" + home + "/";
            File file = new File(userImageDir + File.separator + fileName);

            BufferedImage image = ImageIO.read(stream);
            ImageIO.write(image, type, file);

            return new DocumentInfo(path + fileName, image.getWidth(), image.getHeight());
        } catch (IOException ex) {
            logger.error(ex);
        } catch (Exception ex) {
            logger.error(ex);
        }

        return null;
    }
    
    private class DocumentInfo {
        private final String path;
        private final int width;
        private final int height;

        public DocumentInfo(String path, int width, int height) {
            this.path = path;
            this.width = width;
            this.height = height;
        }

        public String getPath() {
            return path;
        }

        public int getWidth() {
            return width;
        }

        public int getHeight() {
            return height;
        }
        
        
    }
}
