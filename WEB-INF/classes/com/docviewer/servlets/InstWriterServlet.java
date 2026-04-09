package com.docviewer.servlets;

import javax.servlet.*;
import javax.servlet.http.*;
import com.silkworm.servlets.MultipartRequest;
import java.io.*;
import com.silkworm.business_objects.WebBusinessObject;
import com.docviewer.db_access.InstMgr;
import com.docviewer.db_access.DocImgMgr;
import com.silkworm.Exceptions.*;
import com.silkworm.db_access.FileMgr;
import com.docviewer.business_objects.Document;
import com.silkworm.util.FileIO;

public class InstWriterServlet extends ImageHandlerServlet {
    
    private String docImageFilePath = null;
    private String reqOp = null;
    private File usrDir = null;
    private String[] usrDirContents = null;
    
    private WebBusinessObject folder = null;
    private String folderName = null;
    private String folderID = null;
    
    private String docID = null;
    private WebBusinessObject document = null;
    
    
    private InstMgr instMgr = InstMgr.getInstance();
    private DocImgMgr diMgr = DocImgMgr.getInstance();
    
    private FileMgr fileMgr = FileMgr.getInstance();
    private int numFiles = 0;
    WebBusinessObject fileDescriptor = null;
    String absPath = null;
    
    public String unitScheduleID=null;
    public String docType =null;
    
    public String filterName =null;
    public String filterValue =null;
    
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        
        
    }
    /** Destroys the servlet.
     */
    public void destroy() {
        
    }
    
    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
        
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        
        String clientName = null;
        String fileExtension = null;
        reqOp = request.getParameter("op");
        operation =  getOpCode( reqOp);
        switch (operation) {
            case 1:
                
                servedPage = "/docs/inst_handling/doc_create.jsp";
                
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
                
                
            case 2:
                
                usrDir = new File(userBackendHome);
                usrDirContents = usrDir.list();
                
                
                DocViewerFileRenamePolicy ourPolicy = new DocViewerFileRenamePolicy();
                
                fileExtension = request.getParameter("fileExtension");
                
                fileDescriptor = fileMgr.getObjectFromCash(fileExtension);
                String metaType = (String) fileDescriptor.getAttribute("metaType");
                
                ourPolicy.setDesiredFileExt(fileExtension);
                
                File oldFile = new File(userBackendHome + ourPolicy.getFileName());
                oldFile.delete();
                
                //file limit size of five megabytes
                try {
                    mpr = new  MultipartRequest(request,userBackendHome,(5 * 1024 * 1024),ourPolicy);
                    
                } catch(IncorrectFileType e) {
                    servedPage = "/docs/inst_handling/attach_files.jsp";
                    request.setAttribute("unitScheduleID", request.getParameter("unitScheduleID"));
                    request.setAttribute("status",tGuide.getMessage("notok"));
                    request.setAttribute("fileExtension",fileExtension);
                    request.setAttribute("document",document);
                    request.setAttribute("docType",docType);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                }
                
                File newFile = new File(userBackendHome + ourPolicy.getFileName());
                
                if(newFile.exists()) {
                    
                    usrDir = new File(userBackendHome);
                    usrDirContents = usrDir.list();
                    
                    docImageFilePath =  userBackendHome + ourPolicy.getFileName();
                    
                    FileIO.copyFile(docImageFilePath,userImageDir + "\\" + ourPolicy.getFileName());
                    
                    unitScheduleID =request.getParameter("unitScheduleID");
                    docType=request.getParameter("docType");
                    servedPage = "/docs/inst_handling/doc_create.jsp";
                    request.setAttribute("allfiles",usrDirContents);
                    request.setAttribute("unitScheduleID",unitScheduleID);
                    request.setAttribute("docType",docType);
                    request.setAttribute("document",document);
                    request.setAttribute("fileExtension",fileExtension);
                    
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    
                    break;
                } else {
                    // servedPage = "/docs/inst_handling/doc_create.jsp";
                    request.setAttribute("allfiles",usrDirContents);
                    
                    servedPage = "/docs/inst_handling/attach_files.jsp";
//                    request.setAttribute("folder",folder);
                    request.setAttribute("fileExtension",fileExtension);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                }
                
            case 3:
                
                
//                usrDir = new File(userBackendHome);
//                usrDirContents = usrDir.list();
//                int numFiles = usrDirContents.length;
//                for(int i = 0;i< numFiles;i++){
//                    File toDel = new File(userBackendHome+usrDirContents[i]);
//                    toDel.delete();
//                }
                
                servedPage = "/docs/inst_handling/attach_file.jsp";
                
                fileExtension = reqOp.substring(reqOp.length() - 3);
                
                request.setAttribute("page",servedPage);
                request.setAttribute("fileExtension",fileExtension);
                request.setAttribute("destServlet","ImageWriterServlet");
                request.setAttribute("operation","GetDocForm");
                this.forwardToServedPage(request, response);
                break;
                
            case 4:
                
                usrDir = new File(userBackendHome);
                usrDirContents = usrDir.list();
                int numFiles = usrDirContents.length;
                for(int i = 0;i< numFiles;i++){
                    File toDel = new File(userBackendHome+usrDirContents[i]);
                    toDel.delete();
                }
                unitScheduleID =request.getParameter("unitScheduleID");
                fileExtension =  getExtension(request.getParameter("DocType"));
                docType=getExtension(request.getParameter("DocType"));
                System.out.println(fileExtension);
                
                servedPage = "/docs/inst_handling/attach_files.jsp";
                request.setAttribute("unitScheduleID", unitScheduleID);
                request.setAttribute("fileExtension", fileExtension);
                request.setAttribute("docType", docType);
                
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 5:
                
                readUserDir();
                
                folderID = request.getParameter("docID");
                folder = instMgr.getOnSingleKey(docID);
                
                // System.out.println("Folder ------------ ID "+folderID+" Folder Name -------------"+folderName);
                fileExtension = request.getParameter("fileExtension");
                docType=request.getParameter("docType");
                
                numFiles = usrDirContents.length;
//                if(numFiles==1) {
                    
                    boolean result = instMgr.saveDocument(request, session,docImageFilePath);
                    
                    if(result) {
                        
                        request.setAttribute("status", "ok");
                    } else {
                        request.setAttribute("status", "Database error: please contact administrator");
                    }
                    
                    filterName =request.getParameter("fName");
                    filterValue = request.getParameter("filterValue");
                    unitScheduleID =request.getParameter("unitScheduleID");
                    servedPage = "/docs/inst_handling/attach_files.jsp";
                    
                    request.setAttribute("unitScheduleID", unitScheduleID);
                    request.setAttribute("fileExtension", fileExtension);
                    request.setAttribute("docType", docType);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    
                    break;
//                } else {
//                    
//                    String coverPageFile = web_inf_path + "\\" + "CoverPage.jpg";
//                    
//                    // begin transaction
//                    String cpID = instMgr.saveDocumentCoverPage(request,session, coverPageFile);
//                    
//                    int lp  = usrDirContents.length;
//                    for(int i = 0;i<lp;i++) {
//                        diMgr.saveDocImage(cpID,userBackendHome+usrDirContents[i]);
//                        
//                    }
//                    // end transaction
//                    
//                    servedPage = "/docs/inst_handling/attach_files.jsp";
//                    
//                    // System.out.println("FILE EXT IS " + fileExtension);
////                    request.setAttribute("folder",folder);
//                    request.setAttribute("fileExtension", fileExtension);
//                    
//                    request.setAttribute("status", "ok");
//                    request.setAttribute("page",servedPage);
//                    this.forwardToServedPage(request, response);
//                    
//                    break;
//                    
//                }
                
                
            case 6:
                usrDir = new File(userBackendHome);
                usrDirContents = usrDir.list();
                numFiles = usrDirContents.length;
                
                
                
                folderID = request.getParameter("folderID");
                //Get Client Name
                folder = instMgr.getOnSingleKey(folderID);
                // folder.printSelf();
                folderName = (String) folder.getAttribute("docTitle");
                
                fileExtension =  request.getParameter("fileExtension");
                absPath = "images/" + userHome + "/";
                if(numFiles==0) {
                    servedPage = "/docs/inst_handling/attach_files.jsp";
                    request.setAttribute("status",tGuide.getMessage("noattachement"));
                    request.setAttribute("folder",folder);
                    
                    request.setAttribute("fileExtension", fileExtension);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    
                } else {
                    servedPage = "/docs/inst_handling/doc_create.jsp";
                    request.setAttribute("imagePath",absPath);
                    request.setAttribute("allfiles",usrDirContents);
                    request.setAttribute("folder",folder);
                    request.setAttribute("fileExtension", fileExtension);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                }
                
            case 7:
                usrDir = new File(userBackendHome);
                usrDirContents = usrDir.list();
                numFiles = usrDirContents.length;
                for(int i = 0;i <numFiles;i++){
                    File toDel = new File(userBackendHome+usrDirContents[i]);
                    toDel.delete();
                }
                
                this.forward("/main.jsp",request,response);
                break;
                
                
            case 8:
                
                String fileToDel = request.getParameter("fileName");
                folderID = request.getParameter("folderID");
                folder = instMgr.getOnSingleKey(folderID);
                
                
                fileExtension =  request.getParameter("fileExtension");
                
                
                String lfName = null;
                
                usrDir = new File(userBackendHome);
                usrDirContents = usrDir.list();
                numFiles = usrDirContents.length;
                for(int i = 0;i <numFiles;i++){
                    File toDel = new File(userBackendHome+usrDirContents[i]);
                    lfName = toDel.getName();
                    
                    if(lfName.equalsIgnoreCase(fileToDel)) {
                        toDel.delete();
                    }
                }
                
                
                usrDir = new File(userBackendHome);
                usrDirContents = usrDir.list();
                
                if(usrDirContents.length==0) {
                    servedPage = "/docs/inst_handling/attach_files.jsp";
                    
                    request.setAttribute("folder",folder);
                    request.setAttribute("fileExtension", fileExtension);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    
                } else {
                    
                    servedPage = "/docs/inst_handling/doc_create.jsp";
                    request.setAttribute("imagePath",absPath);
                    request.setAttribute("allfiles",usrDirContents);
                    request.setAttribute("folder",folder);
                    request.setAttribute("fileExtension", fileExtension);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                }
                
            case 9:
                
                String filter = request.getParameter("filter");
                String filterValue = request.getParameter("filterValue");
                String objType=request.getParameter("objType");
                String grandParent = request.getParameter("grandParent");
                if (null==filterValue) {
                    filterValue="";
                }
                String instId = request.getParameter("docId");
                //docTitle = request.getParameter("docTitle");
                
                Document doc = (Document) instMgr.getOnSingleKey(instId);
                
                servedPage = "/docs/add_features/new_bookmark.jsp";
                request.setAttribute("page",servedPage);
                request.setAttribute("objType",objType);
                request.setAttribute("grandParent",grandParent);
                request.setAttribute("doc",doc);
                request.setAttribute("filter", filter);
                request.setAttribute("filterValue", filterValue);
                request.setAttribute("docId", instId);
                
                this.forwardToServedPage(request, response);
                //
                //
                //                    viewOrigin = request.getParameter("viewOrigin");
                //                    ais.setCentralViewLink(AppConstants.getFullLink(viewOrigin));
                //                    ais.setViewOrigin(viewOrigin);
                //
                //                    servedPage = "/docs/issue/new_bookmark.jsp";
                //                    request.setAttribute("issueState", issueStatus);
                //                    request.setAttribute("state",ais);
                //                    request.setAttribute("issueId", request.getParameter("issueId"));
                //                    request.setAttribute("issueTitle", request.getParameter("issueTitle"));
                //                    request.setAttribute("page",servedPage);
                //                    this.forwardToServedPage(request, response);
                break;
            case 10:
                instId = request.getParameter("instId");
                
                filter = request.getParameter("filter");
                filterValue = request.getParameter("filterValue");
                
                if (filter==null || filterValue ==null) {
                    filter=new String("");
                    filterValue=new String("");
                }
                doc = (Document) instMgr.getOnSingleKey(instId);
                if (null==doc) {
                    servedPage = "/docs/search/id_search.jsp";
                    request.setAttribute("page",servedPage);
                    request.setAttribute("message","nodocument");
                } else {
                    servedPage = "/docs/inst_handling/doc_update.jsp";
                    request.setAttribute("page",servedPage);
//                        VO.setAttribute("filter",filter);
//                        VO.setAttribute("filterValue",filterValue);
//                        doc.setViewOrigin(VO);
                    request.setAttribute("defInstID",instId);
                    request.setAttribute("docObject", doc);
//                        request.setAttribute("viewOrigin", VO);
                }
                
                this.forwardToServedPage(request, response);
                break;
            case 11:
                if(instMgr.updateDocument(request, session)) {
                    request.setAttribute("Status","OK");
                } else {
                    request.setAttribute("Status","Failed");
                }
                servedPage = "/docs/inst_handling/doc_update.jsp";
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 12:
                
                unitScheduleID =request.getParameter("unitScheduleID");
                
                servedPage = "/docs/inst_handling/select_file.jsp";
                
                request.setAttribute("unitScheduleID", unitScheduleID);
                request.setAttribute("page",servedPage);
                
                this.forwardToServedPage(request, response);
                break;
            default:
                break;
        }
        
        
        
        
    }
    
    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    public void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, java.io.IOException {
        
        // throw new ServletException("GET method used with " + getClass().getName()+": POST method required.");
        processRequest(request, response);
    }
    
    
    /** Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    /** Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Image Writer Servlet";
    }
    
    
    public int getOpCode(String opName) {
        
        if(opName.equalsIgnoreCase("CreateDoc")) {
            return 1;
        }
        
        if(opName.equalsIgnoreCase("AttachImage")) {
            return 2;
        }
        
        //        if(opName.equalsIgnoreCase("SelectClient")) {
        //            return 3;
        //        }
        
        if(opName.indexOf("SelectAccount") == 0) {
            return 3;
        }
        
        if(opName.equalsIgnoreCase("GetDocForm")) {
            return 4;
        }
        if(opName.equalsIgnoreCase("SaveDoc")) {
            return 5;
        }
        if(opName.equalsIgnoreCase("DoneAttach")) {
            return 6;
        }
        
        if(opName.equalsIgnoreCase("CancelDC")) {
            return 7;
        }
        
        if(opName.equalsIgnoreCase("DelImg")) {
            return 8;
        }
        if(opName.equalsIgnoreCase("GetBMForm")) {
            return 9;
        }
        if(opName.equalsIgnoreCase("GetEditForm")) {
            return 10;
        }
        if(opName.equalsIgnoreCase("Update")) {
            return 11;
        }
        if(opName.equalsIgnoreCase("SelectFile")) {
            return 12;
        }
        return 0;
    }
    private void readUserDir() {
        
        usrDir = new File(userBackendHome);
        usrDirContents = usrDir.list();
        numFiles = usrDirContents.length;
        
        
    }
    
    private String getExtension(String type){
        if(type.indexOf("Word") >= 0){
            return new String("doc");
        } else if(type.indexOf("Exel") >= 0){
            return new String("xls");
        } else if(type.indexOf("PowerPoint") >= 0){
            return new String("ppt");
        } else if(type.indexOf("AdobAcrobat") >= 0){
            return new String("pdf");
        } else if(type.indexOf("Html") >= 0){
            return new String("htm");
        }else if(type.indexOf("Text") >= 0){
            return new String("txt");
        }else if(type.indexOf("MSP") >= 0){
            return new String("mpp");
        } else if(type.indexOf("Visio") >= 0){
            return new String("vsd");
        }else if(type.indexOf("WinAce") >= 0){
            return new String("ace");
        }else if(type.indexOf("IMG") >= 0){
            return new String("jpg");
        }else if(type.indexOf("OutLook") >= 0){
            return new String("eml");
        }
        
        
        return null;
    }
    
}