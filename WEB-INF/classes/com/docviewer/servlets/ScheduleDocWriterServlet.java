package com.docviewer.servlets;

import com.docviewer.business_objects.Document;
import com.maintenance.db_access.ScheduleDocMgr;
import com.silkworm.Exceptions.IncorrectFileType;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.db_access.FileMgr;
import com.silkworm.servlets.MultipartRequest;
import com.silkworm.util.FileIO;
//import com.tracker.business_objects.ExcelCreator;
import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;


public class ScheduleDocWriterServlet extends ImageHandlerServlet {
    
    private String docImageFilePath = null;
    private String reqOp = null;
    private File usrDir = null;
    private String[] usrDirContents = null;
//
    private WebBusinessObject folder = null;
//    private String folderName = null;
    private String folderID = null;
//
    private String docID = null;
    private WebBusinessObject document = null;
    private ScheduleDocMgr scheduleDocMgr = ScheduleDocMgr.getInstance();
//    private DocImgMgr diMgr = DocImgMgr.getInstance();
//
    private FileMgr fileMgr = FileMgr.getInstance();
    private int numFiles = 0;
    WebBusinessObject fileDescriptor = null;
//    String absPath = null;
//
    public String scheduleID=null;
    public String docType =null;
//
//    public String filterName =null;
//    public String filterValue =null;
    
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
                servedPage = "/docs/schedule_doc_handling/doc_create.jsp";
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
                    servedPage = "/docs/schedule_doc_handling/attach_files.jsp";
                    request.setAttribute("scheduleID", request.getParameter("scheduleID"));
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
                    
                    scheduleID =request.getParameter("scheduleID");
                    docType=request.getParameter("docType");
                    servedPage = "/docs/schedule_doc_handling/doc_create.jsp";
                    request.setAttribute("allfiles",usrDirContents);
                    request.setAttribute("scheduleID",scheduleID);
                    request.setAttribute("docType",docType);
                    request.setAttribute("document",document);
                    request.setAttribute("fileExtension",fileExtension);
                    
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    
                    break;
                } else {
                    request.setAttribute("allfiles",usrDirContents);
                    request.setAttribute("scheduleID",scheduleID);
                    servedPage = "/docs/schedule_doc_handling/attach_files.jsp";
                    request.setAttribute("fileExtension",fileExtension);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                }
                
            case 3:
//
//                servedPage = "/docs/schedule_doc_handling/attach_file.jsp";
//
//                fileExtension = reqOp.substring(reqOp.length() - 3);
//
                request.setAttribute("page",servedPage);
//                request.setAttribute("fileExtension",fileExtension);
//                request.setAttribute("destServlet","ImageWriterServlet");
//                request.setAttribute("operation","GetDocForm");
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
                scheduleID =request.getParameter("scheduleID");
                fileExtension =  getExtension(request.getParameter("DocType"));
                docType=getExtension(request.getParameter("DocType"));
                servedPage = "/docs/schedule_doc_handling/attach_files.jsp";
                request.setAttribute("scheduleID", scheduleID);
                request.setAttribute("fileExtension", fileExtension);
                request.setAttribute("docType", docType);
                
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 5:
                readUserDir();
//                docID = request.getParameter("docID");
//                folder = scheduleDocMgr.getOnSingleKey(docID);
                fileExtension = request.getParameter("fileExtension");
                docType=request.getParameter("docType");
                
                numFiles = usrDirContents.length;
                boolean result = scheduleDocMgr.saveDocument(request, session,docImageFilePath);
                
                if(result) {
                    
                    request.setAttribute("status", "ok");
                } else {
                    request.setAttribute("status", "Database error: please contact administrator");
                }
                
                scheduleID =request.getParameter("scheduleID");
                servedPage = "/docs/schedule_doc_handling/attach_files.jsp";
                
                request.setAttribute("scheduleID", scheduleID);
                request.setAttribute("fileExtension", fileExtension);
                request.setAttribute("docType", docType);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                
                break;
                
            case 6:
//                usrDir = new File(userBackendHome);
//                usrDirContents = usrDir.list();
//                numFiles = usrDirContents.length;
//
//
//
//                folderID = request.getParameter("folderID");
//                //Get Client Name
//                folder = scheduleDocMgr.getOnSingleKey(folderID);
//                // folder.printSelf();
//                folderName = (String) folder.getAttribute("docTitle");
//
//                fileExtension =  request.getParameter("fileExtension");
//                absPath = "images/" + userHome + "/";
//                if(numFiles==0) {
//                    servedPage = "/docs/schedule_doc_handling/attach_files.jsp";
//                    request.setAttribute("status",tGuide.getMessage("noattachement"));
//                    request.setAttribute("folder",folder);
//
//                    request.setAttribute("fileExtension", fileExtension);
//                    request.setAttribute("page",servedPage);
//                    this.forwardToServedPage(request, response);
//                    break;
//
//                } else {
//                    servedPage = "/docs/schedule_doc_handling/doc_create.jsp";
//                    request.setAttribute("imagePath",absPath);
//                    request.setAttribute("allfiles",usrDirContents);
//                    request.setAttribute("folder",folder);
//                    request.setAttribute("fileExtension", fileExtension);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
//                }
                
            case 7:
//                usrDir = new File(userBackendHome);
//                usrDirContents = usrDir.list();
//                numFiles = usrDirContents.length;
//                for(int i = 0;i <numFiles;i++){
//                    File toDel = new File(userBackendHome+usrDirContents[i]);
//                    toDel.delete();
//                }
//
                this.forward("/main.jsp",request,response);
                break;
                
                
            case 8:
//
//                String fileToDel = request.getParameter("fileName");
//                folderID = request.getParameter("folderID");
//                folder = scheduleDocMgr.getOnSingleKey(folderID);
//
//
//                fileExtension =  request.getParameter("fileExtension");
//
//
//                String lfName = null;
//
//                usrDir = new File(userBackendHome);
//                usrDirContents = usrDir.list();
//                numFiles = usrDirContents.length;
//                for(int i = 0;i <numFiles;i++){
//                    File toDel = new File(userBackendHome+usrDirContents[i]);
//                    lfName = toDel.getName();
//
//                    if(lfName.equalsIgnoreCase(fileToDel)) {
//                        toDel.delete();
//                    }
//                }
//
//
//                usrDir = new File(userBackendHome);
//                usrDirContents = usrDir.list();
//
//                if(usrDirContents.length==0) {
//                    servedPage = "/docs/schedule_doc_handling/attach_files.jsp";
//
//                    request.setAttribute("folder",folder);
//                    request.setAttribute("fileExtension", fileExtension);
//                    request.setAttribute("page",servedPage);
//                    this.forwardToServedPage(request, response);
//                    break;
//
//                } else {
//
//                    servedPage = "/docs/schedule_doc_handling/doc_create.jsp";
//                    request.setAttribute("imagePath",absPath);
//                    request.setAttribute("allfiles",usrDirContents);
//                    request.setAttribute("folder",folder);
//                    request.setAttribute("fileExtension", fileExtension);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
//                }
                
            case 9:
//
//                String filter = request.getParameter("filter");
//                String filterValue = request.getParameter("filterValue");
//                String objType=request.getParameter("objType");
//                String grandParent = request.getParameter("grandParent");
//                if (null==filterValue) {
//                    filterValue="";
//                }
//                String instId = request.getParameter("docId");
//                //docTitle = request.getParameter("docTitle");
//
//                Document doc = (Document) scheduleDocMgr.getOnSingleKey(instId);
//
//                servedPage = "/docs/add_features/new_bookmark.jsp";
                request.setAttribute("page",servedPage);
//                request.setAttribute("objType",objType);
//                request.setAttribute("grandParent",grandParent);
//                request.setAttribute("doc",doc);
//                request.setAttribute("filter", filter);
//                request.setAttribute("filterValue", filterValue);
//                request.setAttribute("docId", instId);
//
                this.forwardToServedPage(request, response);
                break;
            case 10:
                docID = request.getParameter("docID");
                scheduleID = request.getParameter("scheduleID");
                Document doc = (Document) scheduleDocMgr.getOnSingleKey(docID);
                if (null==doc) {
                    servedPage = "/docs/search/id_search.jsp";
                    request.setAttribute("page",servedPage);
                    request.setAttribute("message","nodocument");
                } else {
                    servedPage = "/docs/schedule_doc_handling/doc_update.jsp";
                    request.setAttribute("page",servedPage);
                    request.setAttribute("defInstID",docID);
                    request.setAttribute("docObject", doc);
                    request.setAttribute("scheduleID", scheduleID);
                }
                
                this.forwardToServedPage(request, response);
                break;
            case 11:
                if(scheduleDocMgr.updateDocument(request, session)) {
                    request.setAttribute("Status","OK");
                } else {
                    request.setAttribute("Status","Failed");
                }
                scheduleID = request.getParameter("scheduleID");
                servedPage = "/docs/schedule_doc_handling/doc_update.jsp";
                request.setAttribute("scheduleID", scheduleID);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 12:
                
                scheduleID =request.getParameter("scheduleID");
                
                servedPage = "/docs/schedule_doc_handling/select_file.jsp";
                
                request.setAttribute("scheduleID", scheduleID);
                request.setAttribute("page",servedPage);
                
                this.forwardToServedPage(request, response);
                break;
                
            case 13:
                
//                ExcelCreator excelCreator = new ExcelCreator();
//                ExcelCreator excelCreator = new ExcelCreator();
//                ExcelCreator excelCreator = new ExcelCreator();
//                Vector project = new Vector();
//                project = (Vector) request.getSession().getAttribute("info");
//                
//                
//                int size = project.size() + 1;
//                for(int i = 0; i < project.size(); i++){
//                    int j = i + 2;
//                    ((WebBusinessObject) project.get(i)).setAttribute("equipID", "ROUND(B" + j +"/SUM(B2:B" + size + ") * 100,0)");
//                }
//                
//                excelCreator = new ExcelCreator();
//                String[] header3 = {"unitNo","unitName","Manufacturer","Model Number","Serial Number","status","Description"};
//                String[] attribute3 = {"unitNo", "unitName","manufacturer","modelNo","serialNo","status","desc"};
//                String[] dataType3 = {"String", "String", "String","String","String","String","String"};
//                
//                
//                
//                HSSFWorkbook workBook = excelCreator.createExcelFile(header3, attribute3, dataType3, project,0);
//                
//                
//                response.setHeader("Content-Disposition",
//                        "attachment; filename=\""+"Equipment_Details.xls");
//                
//                workBook.write(response.getOutputStream());
//                
//                response.getOutputStream().flush();
//                response.getOutputStream().close();
                break;
            case 14:
                
                
//                project = new Vector();
//                project = (Vector) request.getSession().getAttribute("infor");
//                
//                
//                int size2 = project.size() + 1;
//                for(int i = 0; i < project.size(); i++){
//                    int j = i + 2;
//                    ((WebBusinessObject) project.get(i)).setAttribute("ID", "ROUND(B" + j +"/SUM(B2:B" + size2 + ") * 100,0)");
//                }
//                
//                excelCreator = new ExcelCreator();
//                String[] header= {"scheduleID","Maintenance Title","Finish Time","Created By","Assign By Name","Failure Code","Urgency Level","Site Name"};
//                String[] attribute = {"scheduleID","MaintenanceTitle","FinishTime","createdBy","AssignByName","FailureCode","UrgencyLevel","SiteName"};
//                String[] dataType = {"String","String","String","String","String","String","String","String","String"};
//                //   "Equipment ID","Project Name","Maintenance Title",
//                //"scheduleID", "projectName","mainTitle",
//                //"String", "String", "String",
//                
//                
//                workBook = excelCreator.createExcelFile(header, attribute, dataType, project,0);
//                
//                
//                response.setHeader("Content-Disposition",
//                        "attachment; filename=\""+"task_Details.xls");
//                
//                workBook.write(response.getOutputStream());
//                
//                response.getOutputStream().flush();
//                response.getOutputStream().close();
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
        return "Schedule Document Writer Servlet";
    }
    
    
    public int getOpCode(String opName) {
        
        if(opName.equalsIgnoreCase("CreateDoc")) {
            return 1;
        }
        
        if(opName.equalsIgnoreCase("AttachImage")) {
            return 2;
        }
        
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
        if(opName.equalsIgnoreCase("excel")) {
            return 13;
        }
        if(opName.equalsIgnoreCase("excel2")) {
            return 14;
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