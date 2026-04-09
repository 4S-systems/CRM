package com.workFlowTasks.servlets;

import com.docviewer.business_objects.Document;
import com.docviewer.servlets.DocViewerFileRenamePolicy;
import com.silkworm.Exceptions.IncorrectFileType;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.db_access.FileMgr;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.servlets.MultipartRequest;
import com.silkworm.util.FileIO;
//import com.tracker.business_objects.ExcelCreator;
import com.workFlowTasks.db_access.WFTaskDocMgr;
import java.awt.image.BufferedImage;
import java.io.*;
import java.util.Vector;
import javax.imageio.ImageIO;

import javax.servlet.*;
import javax.servlet.http.*;


public class WFTaskFilesServlet extends FileHandlerServlet {
    
    private String docImageFilePath = null;
    private String reqOp = null;
    private File usrDir = null;
    private String[] usrDirContents = null;
    
    private WebBusinessObject folder = null;
    private String folderID = null;
    
    private String docID = null;
    private WebBusinessObject document = null;
    private WFTaskDocMgr wFTaskDocMgr= WFTaskDocMgr.getInstance();
    
    private FileMgr fileMgr = FileMgr.getInstance();
    private int numFiles = 0;
    WebBusinessObject fileDescriptor = null;
    
    public String wfTaskId =null;
    public String docType =null;
    
    BufferedInputStream gifData = null;
    BufferedImage myImage = null;
    Document doc = null;
    Vector docsList = null;
    String randFileName = null;
    String randome = null;
    int len = 0;
    
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        
        
    }
    
    public void destroy() {
        
    }
    
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
                    servedPage = "/docs/WorkFlowTasks/attach_files.jsp";
                    
                    request.setAttribute("wfTaskId", request.getParameter("wfTaskId"));
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
                    
                    String wfTaskId  =request.getParameter("wfTaskId");
                    docType=request.getParameter("docType");
                    servedPage = "/docs/WorkFlowTasks/doc_create.jsp";
                    
                    request.setAttribute("allfiles",usrDirContents);
                    request.setAttribute("wfTaskId",wfTaskId );
                    request.setAttribute("docType",docType);
                    request.setAttribute("document",document);
                    request.setAttribute("fileExtension",fileExtension);
                    
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    
                    break;
                } else {
                    request.setAttribute("allfiles",usrDirContents);
                    
                    servedPage = "/docs/WorkFlowTasks/attach_files.jsp";
                    request.setAttribute("fileExtension",fileExtension);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                }
                
            case 2:
                usrDir = new File(userBackendHome);
                usrDirContents = usrDir.list();
                int numFiles = usrDirContents.length;
                for(int i = 0;i< numFiles;i++){
                    File toDel = new File(userBackendHome+usrDirContents[i]);
                    toDel.delete();
                }
                wfTaskId  =request.getParameter("wfTaskId");
                fileExtension =  getExtension(request.getParameter("DocType"));
                docType=getExtension(request.getParameter("DocType"));
                servedPage = "/docs/WorkFlowTasks/attach_files.jsp";
                
                request.setAttribute("wfTaskId", wfTaskId );
                request.setAttribute("fileExtension", fileExtension);
                request.setAttribute("docType", docType);
                
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 3:
                readUserDir();
//                docID = request.getParameter("docID");
//                folder = wFTaskDocMgr.getOnSingleKey(docID);
                fileExtension = request.getParameter("fileExtension");
                docType=request.getParameter("docType");
                wfTaskId  =request.getParameter("wfTaskId");
                
                numFiles = usrDirContents.length;
                boolean result = wFTaskDocMgr.saveDocument(request, session,docImageFilePath);
                
                if(result) {
                    
                    request.setAttribute("status", "ok");
                } else {
                    request.setAttribute("status", "Database error: please contact administrator");
                }
                
                
                servedPage = "/docs/WorkFlowTasks/attach_files.jsp";
                
                request.setAttribute("wfTaskId", wfTaskId );
                request.setAttribute("fileExtension", fileExtension);
                request.setAttribute("docType", docType);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                
                break;
                
            case 4:
                
                wfTaskId =request.getParameter("wfTaskId");
                
                servedPage = "/docs/WorkFlowTasks/select_file.jsp";
                
                request.setAttribute("wfTaskId", wfTaskId);
                request.setAttribute("page",servedPage);
                
                this.forwardToServedPage(request, response);
                break;
                
            case 5:
                
                docType = request.getParameter("docType");
                docID = request.getParameter("docID");
                
                fileDescriptor = fileMgr.getObjectFromCash(docType);
                
                String app = (String) fileDescriptor.getAttribute("app");
                
                if(docType.equalsIgnoreCase("jpg")) {
                    servedPage = "/docs/WorkFlowTasks/image_renderer.jsp";
                    request.setAttribute("page",servedPage);
                    randome = UniqueIDGen.getNextID();
                    len = randome.length();
                    
                    randFileName = new String("ran" +  randome.substring(5,len) + ".jpeg");
                    
                    
                    RIPath = userImageDir + "/" + randFileName;
                    
                    
                    absPath = "images/" + userHome + "/" + randFileName;
                    
                    docImage = new File(RIPath);
                    docID = request.getParameter("docID");
                    gifData = new BufferedInputStream(wFTaskDocMgr.getImage(docID));
                    myImage = ImageIO.read(gifData);
                    ImageIO.write(myImage,"jpeg",docImage);
                    request.setAttribute("imagePath", absPath);
                    this.forwardToServedPage(request, response);
                    
                    break;
                } else {
                    randome = UniqueIDGen.getNextID();
                    len = randome.length();
                    
                    randFileName = new String("ran" +  randome.substring(5,len) + docType);
                    
                    RIPath = userImageDir + "/" + randFileName;
                    
                    File PDFDoc = new File(RIPath);
                    
                    BufferedInputStream pdfData =new BufferedInputStream(wFTaskDocMgr.getImage(docID));
                    
                    ServletOutputStream stream = null;
                    try{
                        stream = response.getOutputStream( );
                        response.setContentType("application/" + app);
                        response.addHeader("Content-Disposition","attachment; filename="+"req." + docType );
                        int readBytes = 0;
                        while((readBytes = pdfData.read( )) != -1)
                            stream.write(readBytes);
                    } catch (IOException ioe){
                        throw new ServletException(ioe.getMessage( ));
                    } finally {
                        if (stream != null)
                            stream.close( );
                        if (pdfData != null)
                            pdfData.close( );
                    }
                    
                    break;
                    
                }
                
            case 6:
                servedPage = "/docs/WorkFlowTasks/docs_list.jsp";
                
                wfTaskId =request.getParameter("wfTaskId");
                
                wfTaskId =  wfTaskId.replace('^','&');
                wfTaskId =  wfTaskId.replace('$','#');
                wfTaskId =  wfTaskId.replace('*',';');
                
                docsList = wFTaskDocMgr.getListOnLIKE(request.getParameter("op"),wfTaskId);
                request.setAttribute("data",docsList);
                request.setAttribute("wfTaskId",wfTaskId);
                request.setAttribute("page",servedPage);
                
                this.forwardToServedPage(request, response);
                
                break;
                
            case 7:
                docID = request.getParameter("docID");
                wfTaskId =request.getParameter("wfTaskId");
                
                doc = (Document) wFTaskDocMgr.getOnSingleKey(docID);
                if (null==doc) {
                    servedPage = "/docs/search/id_search.jsp";
                    request.setAttribute("page",servedPage);
                    request.setAttribute("message","nodocument");
                } else {
                    servedPage = "/docs/WorkFlowTasks/doc_details.jsp";
                    randome = UniqueIDGen.getNextID();
                    len = randome.length();
                    
                    randFileName = new String("ran" +  randome.substring(5,len) + ".jpeg");
                    RIPath = userImageDir + "/" + randFileName;
                    absPath = "images/" + userHome + "/" + randFileName;
                    docImage = new File(RIPath);
                    docID = request.getParameter("docID");
                    gifData = new BufferedInputStream(wFTaskDocMgr.getImage(docID));
                    myImage = ImageIO.read(gifData);
                    if(myImage!=null) {
                        ImageIO.write(myImage,"jpeg",docImage);
                        request.setAttribute("imagePath", absPath);
                    }
                    request.setAttribute("page",servedPage);
                    request.setAttribute("wfTaskId",wfTaskId);
                    request.setAttribute("defDocID",docID);
                    request.setAttribute("docObject", doc);
                }
                
                this.forwardToServedPage(request, response);
                break;
                
            case 8:
                docID = request.getParameter("docID");
                Document doc = (Document) wFTaskDocMgr.getOnSingleKey(docID);
                request.setAttribute("docID", request.getParameter("docID"));
                request.setAttribute("docTitle", request.getParameter("docTitle"));
                request.setAttribute("doc",doc);
                wfTaskId =request.getParameter("wfTaskId");
                servedPage = "/docs/WorkFlowTasks/confirm_deletion.jsp";
                request.setAttribute("wfTaskId",wfTaskId);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 9:
                docID = request.getParameter("docID");
                wfTaskId = request.getParameter("wfTaskId");
                doc = (Document) wFTaskDocMgr.getOnSingleKey(docID);
                if (null==doc) {
                    servedPage = "/docs/search/id_search.jsp";
                    request.setAttribute("page",servedPage);
                    request.setAttribute("message","nodocument");
                } else {
                    servedPage = "/docs/WorkFlowTasks/doc_update.jsp";
                    request.setAttribute("page",servedPage);
                    request.setAttribute("defInstID",docID);
                    request.setAttribute("docObject", doc);
                    request.setAttribute("wfTaskId", wfTaskId);
                }
                
                this.forwardToServedPage(request, response);
                break;
                
            case 10:
                docID = request.getParameter("docID");
                wfTaskId = request.getParameter("wfTaskId");
                doc = (Document) wFTaskDocMgr.getOnSingleKey(docID);
                
                if(wFTaskDocMgr.updateDocument(request, session)) {
                    request.setAttribute("Status","OK");
                } else {
                    request.setAttribute("Status","Failed");
                }
                
                servedPage = "/docs/WorkFlowTasks/doc_update.jsp";
                
                request.setAttribute("wfTaskId", wfTaskId);
                request.setAttribute("defInstID",docID);
                request.setAttribute("docObject", doc);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 11:
                docID = request.getParameter("docID");
                wFTaskDocMgr.deleteOnSingleKey(docID);
                wfTaskId = request.getParameter("wfTaskId");
                servedPage = "/docs/WorkFlowTasks/docs_list.jsp";
                
                wfTaskId =  wfTaskId.replace('^','&');
                wfTaskId =  wfTaskId.replace('$','#');
                wfTaskId =  wfTaskId.replace('*',';');
                
                docsList = wFTaskDocMgr.getListOnLIKE(request.getParameter("op"),wfTaskId);
                request.setAttribute("data",docsList);
                request.setAttribute("wfTaskId",wfTaskId);
                request.setAttribute("data", docsList);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            default:
                break;
        }
    }
    
    public void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, java.io.IOException {
        processRequest(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    public String getServletInfo() {
        return "Unit Document Writer Servlet";
    }
    
    
    public int getOpCode(String opName) {
        
        if(opName.equalsIgnoreCase("AttachImage")) {
            return 1;
        }
        if(opName.equalsIgnoreCase("GetDocForm")) {
            return 2;
        }
        if(opName.equalsIgnoreCase("SaveDoc")) {
            return 3;
        }
        if(opName.equalsIgnoreCase("SelectFile")) {
            return 4;
        }
        if(opName.equalsIgnoreCase("ViewDocument")) {
            return 5;
        }
        if(opName.equalsIgnoreCase("ListDoc")) {
            return 6;
        }
        if(opName.equalsIgnoreCase("DocDetails"))
            return 7;
        if(opName.equalsIgnoreCase("ConfirmDelete"))
            return 8;
        if(opName.equalsIgnoreCase("GetEditForm"))
            return 9;
        if(opName.equalsIgnoreCase("Update"))
            return 10;
        if(opName.equalsIgnoreCase("Delete"))
            return 11;
        
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