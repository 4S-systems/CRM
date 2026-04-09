package com.docviewer.servlets;

import com.clients.db_access.ClientMgr;
import com.docviewer.business_objects.Document;
import com.docviewer.db_access.DocTypeMgr;
import com.maintenance.common.Tools;
import com.maintenance.db_access.UnitDocMgr;
import com.silkworm.Exceptions.IncorrectFileType;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.db_access.FileMgr;
import com.silkworm.db_access.PersistentSessionMgr;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.servlets.MultipartRequest;
import com.silkworm.util.FileIO;
import com.tracker.common.ProjectConstants;
import com.tracker.db_access.IssueStatusMgr;
import com.tracker.db_access.ProjectMgr;
import com.tracker.db_access.UnitAddonDetailsMgr;
import com.unit.db_access.ArchDetailsMgr;
import com.unit.db_access.UnitPriceMgr;
import com.unit.db_access.UnitTimelineMgr;
import com.unit.servlets.UnitServlet;
import java.awt.image.BufferedImage;
//import com.tracker.business_objects.ExcelCreator;
import java.io.*;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.imageio.ImageIO;

import javax.servlet.*;
import javax.servlet.http.*;

public class UnitDocWriterServlet extends ImageHandlerServlet {
    
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
    private UnitDocMgr unitDocMgr = UnitDocMgr.getInstance();
//    private DocImgMgr diMgr = DocImgMgr.getInstance();
//
    private FileMgr fileMgr = FileMgr.getInstance();
    private int numFiles = 0;
    WebBusinessObject fileDescriptor = null;
//    String absPath = null;
//
    public String equipmentID=null;
    public String docType =null;
//
//    public String filterName =null;
//    public String filterValue =null;
    WebBusinessObject userObj = null;
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        
        
    }
    
    public void destroy() {
        
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        userObj = (WebBusinessObject) session.getAttribute("loggedUser");
        String remoteAccess = session.getId();
        WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);
        
        String clientName = null;
        String fileExtension = null;
        reqOp = request.getParameter("op");
        operation =  getOpCode( reqOp);
        switch (operation) {
            case 1:
                servedPage = "/docs/unit_doc_handling/doc_create.jsp";
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 2:
                usrDir = new File(userBackendHome);
                usrDirContents = usrDir.list();
                DocViewerFileRenamePolicy ourPolicy = new DocViewerFileRenamePolicy();
                
                fileExtension = request.getParameter("fileExtension");
                String type = (String) request.getParameter("type");
                fileDescriptor = fileMgr.getObjectFromCash(fileExtension);
                String metaType = (String) fileDescriptor.getAttribute("metaType");
                
                ourPolicy.setDesiredFileExt(fileExtension);
                
                File oldFile = new File(userBackendHome + ourPolicy.getFileName());
                oldFile.delete();
                
                //file limit size of five megabytes
                try {
                    mpr = new  MultipartRequest(request,userBackendHome,(70 * 1024 * 1024),ourPolicy);
                    
                } catch(IncorrectFileType e) {
                    servedPage = "/docs/unit_doc_handling/attach_files.jsp";
                    request.setAttribute("equipmentID", request.getParameter("equipmentID"));
                    request.setAttribute("status",tGuide.getMessage("notok"));
                    request.setAttribute("fileExtension",fileExtension);
                    request.setAttribute("document",document);
                    request.setAttribute("docType",docType);
                    request.setAttribute("type",type);
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
                    
                    equipmentID =request.getParameter("equipmentID");
                    docType=request.getParameter("docType");
                    servedPage = "/docs/unit_doc_handling/doc_create.jsp";
                    request.setAttribute("allfiles",usrDirContents);
                    request.setAttribute("equipmentID",equipmentID);
                    request.setAttribute("docType",docType);
                    request.setAttribute("document",document);
                    request.setAttribute("fileExtension",fileExtension);
                    request.setAttribute("type",type);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    
                    break;
                } else {
                    request.setAttribute("allfiles",usrDirContents);
                    
                    servedPage = "/docs/unit_doc_handling/attach_files.jsp";
                    request.setAttribute("fileExtension",fileExtension);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                }
                
            case 3:
//
//                servedPage = "/docs/unit_doc_handling/attach_file.jsp";
//
//                fileExtension = reqOp.substring(reqOp.length() - 3);
//
                request.setAttribute("page",servedPage);
//                request.setAttribute("fileExtension",fileExtension);
//                request.setAttribute("destServlet","ImageWriterServlet");
//                request.setAttribute("operation","GetDocForm");
                this.forwardToServedPage(request, response);
                break;
                
            case 4: //222
                usrDir = new File(userBackendHome);
                usrDirContents = usrDir.list();
                int numFiles = usrDirContents.length;
                for(int i = 0;i< numFiles;i++){
                    File toDel = new File(userBackendHome+usrDirContents[i]);
                    toDel.delete();
                }
                equipmentID =request.getParameter("equipmentID");
                fileExtension =  getExtension(request.getParameter("DocType"));
                docType=getExtension(request.getParameter("DocType"));
                servedPage = "/docs/unit_doc_handling/attach_files.jsp";
                type = (String) request.getParameter("type");
                request.setAttribute("type",type);
                request.setAttribute("equipmentID", equipmentID);
                request.setAttribute("fileExtension", fileExtension);
                request.setAttribute("docType", docType);
                
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 5:
                readUserDir();
//                docID = request.getParameter("docID");
//                folder = unitDocMgr.getOnSingleKey(docID);
                fileExtension = request.getParameter("fileExtension");
                docType=request.getParameter("docType");
                type = (String) request.getParameter("type");
                numFiles = usrDirContents.length;
                boolean result = unitDocMgr.saveDocument(request, session,docImageFilePath);
                
                if(result) {
                    
                    request.setAttribute("status", "ok");
                } else {
                    request.setAttribute("status", "Database error: please contact administrator");
                }
                
                equipmentID =request.getParameter("equipmentID");
                servedPage = "/docs/unit_doc_handling/attach_files.jsp";
                
                request.setAttribute("equipmentID", equipmentID);
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
//                folder = unitDocMgr.getOnSingleKey(folderID);
//                // folder.printSelf();
//                folderName = (String) folder.getAttribute("docTitle");
//
//                fileExtension =  request.getParameter("fileExtension");
//                absPath = "images/" + userHome + "/";
//                if(numFiles==0) {
//                    servedPage = "/docs/unit_doc_handling/attach_files.jsp";
//                    request.setAttribute("status",tGuide.getMessage("noattachement"));
//                    request.setAttribute("folder",folder);
//
//                    request.setAttribute("fileExtension", fileExtension);
//                    request.setAttribute("page",servedPage);
//                    this.forwardToServedPage(request, response);
//                    break;
//
//                } else {
//                    servedPage = "/docs/unit_doc_handling/doc_create.jsp";
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
//                folder = unitDocMgr.getOnSingleKey(folderID);
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
//                    servedPage = "/docs/unit_doc_handling/attach_files.jsp";
//
//                    request.setAttribute("folder",folder);
//                    request.setAttribute("fileExtension", fileExtension);
//                    request.setAttribute("page",servedPage);
//                    this.forwardToServedPage(request, response);
//                    break;
//
//                } else {
//
//                    servedPage = "/docs/unit_doc_handling/doc_create.jsp";
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
//                Document doc = (Document) unitDocMgr.getOnSingleKey(instId);
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
                equipmentID = request.getParameter("equipmentID");
                Document doc = (Document) unitDocMgr.getOnSingleKey(docID);
                if (null==doc) {
                    servedPage = "/docs/search/id_search.jsp";
                    request.setAttribute("page",servedPage);
                    request.setAttribute("message","nodocument");
                } else {
                    servedPage = "/docs/unit_doc_handling/doc_update.jsp";
                    request.setAttribute("page",servedPage);
                    request.setAttribute("defInstID",docID);
                    request.setAttribute("docObject", doc);
                    request.setAttribute("equipmentID", equipmentID);
                }
                
                this.forwardToServedPage(request, response);
                break;
            case 11:
                if(unitDocMgr.updateDocument(request, session)) {
                    request.setAttribute("Status","OK");
                } else {
                    request.setAttribute("Status","Failed");
                }
                equipmentID = request.getParameter("equipmentID");
                servedPage = "/docs/unit_doc_handling/doc_update.jsp";
                request.setAttribute("equipmentID", equipmentID);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 12:
               //1111 
                equipmentID =request.getParameter("equipmentID");
                
                servedPage = "/docs/unit_doc_handling/select_file.jsp";
                type = (String) request.getParameter("type");
                request.setAttribute("equipmentID", equipmentID);
                request.setAttribute("type",type);
                request.setAttribute("page",servedPage);
                
                this.forwardToServedPage(request, response);
                break;
                
            case 13:
                
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
//                String[] header= {"equipmentID","Maintenance Title","Finish Time","Created By","Assign By Name","Failure Code","Urgency Level","Site Name"};
//                String[] attribute = {"equipmentID","MaintenanceTitle","FinishTime","createdBy","AssignByName","FailureCode","UrgencyLevel","SiteName"};
//                String[] dataType = {"String","String","String","String","String","String","String","String","String"};
//                //   "Equipment ID","Project Name","Maintenance Title",
//                //"equipmentID", "projectName","mainTitle",
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
                
               
               case 15:
                    servedPage = "/docs/unit_doc_handling/add_attach_files.jsp";
                    request.setAttribute("page", servedPage);
                    String projId = request.getParameter("projId");
                    ProjectMgr projectMgr = ProjectMgr.getInstance();
                    request.setAttribute("project", projectMgr.getOnSingleKey(projId));
                    type = request.getParameter("type");
                    request.setAttribute("projId", projId);
                    request.setAttribute("type", type);
                    if (type != null && type.equalsIgnoreCase("tree")) {
                        this.forward(servedPage, request, response);
                    } else {
                        this.forwardToServedPage(request, response);
                    }
                    break;
                   
               case 16:
                        String userHome = (String) userObj.getAttribute("userHome");
                        String userBackEndHome = web_inf_path + "/usr/" + userHome + "/";
                        MultipartRequest multipartRequest = null;
                        unitDocMgr = UnitDocMgr.getInstance();
                        try {
                            multipartRequest = new MultipartRequest(request, userBackEndHome, "UTF-8");
                        } catch (IncorrectFileType ex) {
                            Logger.getLogger(UnitDocWriterServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        try {
                            if (unitDocMgr.saveDocumentByTree(multipartRequest, session)) {
                                request.setAttribute("Status", "OK");
                            } else {
                                request.setAttribute("Status", "Failed");
                            }
                        } catch (NoUserInSessionException ex) {
                            Logger.getLogger(UnitDocWriterServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        type = request.getParameter("type");
                        
                        projId = multipartRequest.getParameter("projId");
                        projectMgr = ProjectMgr.getInstance();
                        if(projId != null) {
                            request.setAttribute("project", projectMgr.getOnSingleKey(projId));
                        } else {
                            request.setAttribute("project", new WebBusinessObject());
                        }
                        WebBusinessObject waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
                        String userID = waUser.getAttribute("userId").toString();
                        request.setAttribute("projId", projId);
                        servedPage = "/docs/unit_doc_handling/add_attach_files.jsp";
                        request.setAttribute("page", servedPage);
                        request.setAttribute("type", type);
                        if (type != null && type.equalsIgnoreCase("tree")) {
                            this.forward(servedPage, request, response);
                        } else {
                            this.forwardToServedPage(request, response);
                        }
                        break;                    
               case 17:
                    servedPage = "/docs/unit_doc_handling/add_attach_files_for_customer.jsp";
                    request.setAttribute("page", servedPage);
                    projId = request.getParameter("equipmentID");
                    request.setAttribute("projId", projId);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);              
                    break;
                   
               case 18:
                        userHome = (String) userObj.getAttribute("userHome");
                        userBackEndHome = web_inf_path + "/usr/" + userHome + "/";
                        multipartRequest = null;
                        unitDocMgr = UnitDocMgr.getInstance();
                        try {
                            multipartRequest = new MultipartRequest(request, userBackEndHome, "UTF-8");
                        } catch (IncorrectFileType ex) {
                            Logger.getLogger(UnitDocWriterServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        try {
                            if (unitDocMgr.saveDocumentByTree(multipartRequest, session)) {
                                request.setAttribute("Status", "OK");
                            } else {
                                request.setAttribute("Status", "Failed");
                            }
                        } catch (NoUserInSessionException ex) {
                            Logger.getLogger(UnitDocWriterServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }

                        projId = multipartRequest.getParameter("projId");
                        waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
                        userID = waUser.getAttribute("userId").toString();
                        request.setAttribute("projId", projId);
                        servedPage = "ClientServlet?op=ListClients";
                        request.setAttribute("page", servedPage);
                        this.forward(servedPage, request, response);
                        break;

            case 19:
                WebBusinessObject wbo = new WebBusinessObject();
                PrintWriter out = response.getWriter();
                try {
                    mpr = new MultipartRequest(request, userBackendHome, (600 * 1024 * 1024), "UTF-8");
                    unitDocMgr = UnitDocMgr.getInstance();
                    if (unitDocMgr.saveMultiDocument(mpr, persistentUser)) {
                        wbo.setAttribute("status", "success");
                    } else {
                        wbo.setAttribute("status", "failed");
                    }
                    out.write(Tools.getJSONObjectAsString(wbo));
                } catch (IncorrectFileType ex) {
                    Logger.getLogger(UnitDocWriterServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (NoUserInSessionException ex) {
                    Logger.getLogger(UnitDocWriterServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (SQLException ex) {
                    Logger.getLogger(UnitDocWriterServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                break;
                
            case 20:
                String projectId = request.getParameter("projectId");
                String fromPage = request.getParameter("fromPage");
                servedPage = "/docs/projects/view_unit_details.jsp";
                projectMgr = ProjectMgr.getInstance();
                
                WebBusinessObject unitWbo = projectMgr.getOnSingleKey(projectId);
                String random, randFileName;
                unitDocMgr = UnitDocMgr.getInstance();
                Vector imageList = unitDocMgr.getImagesList(projectId);
                Vector imagesPath = new Vector();
                int len = 0;
                BufferedInputStream gifData;
                BufferedImage myImage;
                
                userHome = (String) userObj.getAttribute("userHome");
                for (int i = 0; i < imageList.size(); i++) {
                    random = UniqueIDGen.getNextID();
                    len = random.length();
                    docID = (String) ((WebBusinessObject) imageList.get(i)).getAttribute("docID");
                    docType = (String) ((WebBusinessObject) imageList.get(i)).getAttribute("docType");
                    randFileName = "ran" + random.substring(5, len) + "." + docType;

                    RIPath = userImageDir + "/" + randFileName;

                    absPath = "images/" + userHome + "/" + randFileName;

                    docImage = new File(RIPath);

                    gifData = new BufferedInputStream(unitDocMgr.getImage(docID));
                    myImage = ImageIO.read(gifData);
                    ImageIO.write(myImage, docType, docImage);
                    imagesPath.add(absPath);
                }
                if (unitWbo!=null)
                {
                    
                    WebBusinessObject levl=projectMgr.getOnSingleKey((String) unitWbo.getAttribute("optionThree"));
                    if (levl!=null){
                    String levelN= (String) levl.getAttribute("projectName");
                    request.setAttribute("levelN", levelN);
                    }
                } 
        {
            try {
                request.setAttribute("levelsList", new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("LVL", "key6")));
            } catch (Exception ex) {
                Logger.getLogger(UnitDocWriterServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
                request.setAttribute("ownerID", request.getParameter("ownerID"));
                request.setAttribute("projectID", request.getParameter("projectId"));
                request.setAttribute("searchBy", request.getParameter("searchBy"));
                request.setAttribute("searchValue", request.getParameter("searchValue"));
                request.setAttribute("imagePath", imagesPath);
                request.setAttribute("fromPage", fromPage);
                
                request.setAttribute("unitWbo", unitWbo);
                request.setAttribute("statusWbo", IssueStatusMgr.getInstance().getLastStatusForObject(projectId));
                request.setAttribute("unitPriceWbo", UnitPriceMgr.getInstance().getLastPriceForUnit(projectId));
                UnitTimelineMgr unitTimelineMgr = UnitTimelineMgr.getInstance();
                ArrayList<WebBusinessObject> timeLine = new ArrayList<WebBusinessObject>();
                try {
                    timeLine = new ArrayList<WebBusinessObject>(unitTimelineMgr.getOnArbitraryKey(projectId, "key1"));
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("timeLine", timeLine);
                
                //-----------------------------
                UnitAddonDetailsMgr unitAddonDetailsMgr = UnitAddonDetailsMgr.getInstance();
                ArrayList<WebBusinessObject> AddOnsVector = new ArrayList<WebBusinessObject>();
                try {
                    AddOnsVector = new ArrayList<WebBusinessObject>(unitAddonDetailsMgr.getOnArbitraryKey(projectId, "key2"));
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(UnitServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                ArrayList<String>AddOnsType =new ArrayList<>();
                 Vector unitDet=new Vector();
                 String AddType;
                if (AddOnsVector !=null)
                {
                    for(int i=0;i<AddOnsVector.size();i++){
                    try {
                         unitDet=projectMgr.getOnArbitraryKey((String)AddOnsVector.get(i).getAttribute("type"), "key");
                        WebBusinessObject tt= (WebBusinessObject) unitDet.get(0);
                         AddType=(String)tt.getAttribute("projectName");
                         AddOnsType.add(AddType);
                    } catch (Exception ex) {
                        Logger.getLogger(UnitDocWriterServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    }
                }
                request.setAttribute("AddOnsVector", AddOnsVector);
                request.setAttribute("AddOnsType", AddOnsType);

                try {
                    request.setAttribute("modelsList", new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("RES-MODEL", "key6")));
                } catch (Exception ex) {
                    Logger.getLogger(UnitDocWriterServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                if (unitWbo != null && unitWbo.getAttribute("eqNO") != null) {
                    request.setAttribute("modelWbo", projectMgr.getOnSingleKey((String) unitWbo.getAttribute("eqNO")));
                    WebBusinessObject archDetailsWbo = ArchDetailsMgr.getInstance().getOnSingleKey((String) unitWbo.getAttribute("eqNO"));
                    request.setAttribute("archDetailsWbo", archDetailsWbo);
                    Vector imageListModel = unitDocMgr.getImagesList((String) unitWbo.getAttribute("eqNO"));
                    Vector imagesPathModel = new Vector();
                    len = 0;

                    userHome = (String) userObj.getAttribute("userHome");
                    for (int i = 0; i < imageListModel.size(); i++) {
                        random = UniqueIDGen.getNextID();
                        len = random.length();
                        docID = (String) ((WebBusinessObject) imageListModel.get(i)).getAttribute("docID");
                        randFileName = "ran" + random.substring(5, len) + ".jpeg";

                        RIPath = userImageDir + "/" + randFileName;

                        absPath = "images/" + userHome + "/" + randFileName;

                        docImage = new File(RIPath);

                        gifData = new BufferedInputStream(unitDocMgr.getImage(docID));
                        myImage = ImageIO.read(gifData);
                        ImageIO.write(myImage, "jpeg", docImage);
                        imagesPathModel.add(absPath);
                    }
                    request.setAttribute("imagesPathModel", imagesPathModel);
                }
                if (unitWbo != null && unitWbo.getAttribute("mainProjId") != null) {
                    WebBusinessObject parentWbo = projectMgr.getOnSingleKey((String) unitWbo.getAttribute("mainProjId"));
                    if (parentWbo != null && parentWbo.getAttribute("location_type").equals("44")) {
                        request.setAttribute("projectWbo", parentWbo);
                    } else if (parentWbo != null) {
                        request.setAttribute("buildingWbo", parentWbo);
                        request.setAttribute("projectWbo", projectMgr.getOnSingleKey((String) parentWbo.getAttribute("mainProjId")));
                    }
                }
                if (projectId != null) {
                    try {
                        request.setAttribute("clientWbo", ClientMgr.getInstance().getClientByUnitID(projectId));
                    } catch (SQLException ex) {
                        Logger.getLogger(UnitDocWriterServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                
                try {
                    request.setAttribute("dateTypes", new ArrayList<>(ProjectMgr.getInstance().getOnArbitraryKey("udate", "key4")));
                } catch (Exception ex) {
                    request.setAttribute("dateTypes", new ArrayList<>());
                }
                ArrayList<WebBusinessObject> unitAddonsList = new ArrayList<>();
                try {
                    ArrayList<WebBusinessObject> tempList = new ArrayList<>(projectMgr.getOnArbitraryDoubleKeyOracle("0", "key2", "ARCHADDON", "key6"));
                    if(!tempList.isEmpty()) {
                        unitAddonsList = new ArrayList<>(projectMgr.getOnArbitraryDoubleKeyOracle((String) tempList.get(0).getAttribute("projectID"),
                                "key2", "ARCHADDON", "key6"));
                    }
                } catch (Exception ex) {
                    Logger.getLogger(UnitDocWriterServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("unitAddonsList", unitAddonsList);
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 21:
                servedPage = "/docs/units/new_tree_model.jsp";
                request.setAttribute("page", servedPage);
                projId = request.getParameter("projId");
                projectMgr = ProjectMgr.getInstance();
                request.setAttribute("project", projectMgr.getOnSingleKey(projId));
                request.setAttribute("projId", projId);
                this.forward(servedPage, request, response);
                break;
            case 22:
                projectMgr = ProjectMgr.getInstance();
                userHome = (String) userObj.getAttribute("userHome");
                userBackEndHome = web_inf_path + "/usr/" + userHome + "/";
                multipartRequest = null;
                try {
                    multipartRequest = new MultipartRequest(request, userBackEndHome, "UTF-8");
                    String pName = multipartRequest.getParameter("title");
                    String eqNO = UniqueIDGen.getNextID();
                    String pDescription = multipartRequest.getParameter("description");
                    String isMngmntStn = multipartRequest.getParameter(ProjectConstants.IS_MNGMNT_STN);
                    String isTrnsprtStn = multipartRequest.getParameter(ProjectConstants.IS_TRNSPRT_STN);

                    isMngmntStn = (isMngmntStn != null) ? "1" : "0";
                    isTrnsprtStn = (isTrnsprtStn != null) ? "1" : "0";

                    WebBusinessObject project = new WebBusinessObject();
                    String mainProjectId = multipartRequest.getParameter("projId");
                    project.setAttribute(ProjectConstants.PROJECT_NAME, pName);
                    project.setAttribute(ProjectConstants.EQ_NO, eqNO);
                    project.setAttribute(ProjectConstants.PROJECT_DESC, pDescription);
                    project.setAttribute(ProjectConstants.IS_MNGMNT_STN, isMngmntStn);
                    project.setAttribute(ProjectConstants.IS_TRNSPRT_STN, isTrnsprtStn);
                    if (mainProjectId == null) {
                        project.setAttribute("mainProjectId", "0");
                    } else {
                        project.setAttribute("mainProjectId", mainProjectId);
                    }
                    project.setAttribute("futile", multipartRequest.getParameter("futile"));
                    project.setAttribute("location_type", multipartRequest.getParameter("location_type"));
                    // for ArchDetails
                    project.setAttribute("category", multipartRequest.getParameter("category"));
                    project.setAttribute("rooms_no", multipartRequest.getParameter("rooms_no"));
                    project.setAttribute("kitchens_no", multipartRequest.getParameter("kitchens_no"));
                    project.setAttribute("pathroom_no", multipartRequest.getParameter("pathroom_no"));
                    project.setAttribute("balcony_no", multipartRequest.getParameter("balcony_no"));
                    project.setAttribute("total_area", multipartRequest.getParameter("total_area"));
                    project.setAttribute("net_area", multipartRequest.getParameter("net_area"));

                    String garageString = null;
                    if (((String) multipartRequest.getParameter("garage")) == null) {
                        garageString = "0";
                    } else if (((String) multipartRequest.getParameter("garage")).equals("on")) {
                        garageString = "1";
                    }

                    String elevatorString = null;
                    if (((String) multipartRequest.getParameter("elevator")) == null) {
                        elevatorString = "0";
                    } else if (((String) multipartRequest.getParameter("elevator")).equals("on")) {
                        elevatorString = "1";
                    }

                    String storageString = null;
                    if (((String) multipartRequest.getParameter("storage")) == null) {
                        storageString = "0";
                    } else if (((String) multipartRequest.getParameter("storage")).equals("on")) {
                        storageString = "1";
                    }

                    String clubString = null;
                    if (((String) multipartRequest.getParameter("club")) == null) {
                        clubString = "0";
                    } else if (((String) multipartRequest.getParameter("club")).equals("on")) {
                        clubString = "1";
                    }
                    project.setAttribute("garage", garageString);
                    project.setAttribute("elevator", elevatorString);
                    project.setAttribute("storage", storageString);
                    project.setAttribute("club", clubString);
                    project.setAttribute("min_price", "0");
                    project.setAttribute("max_price", "0");

                    ArchDetailsMgr archDetailsMgr = ArchDetailsMgr.getInstance();
                    try {
                        if (!projectMgr.getDoubleName(pName, "key1") && !projectMgr.getDoubleName(eqNO, "key3")) {
                            if (archDetailsMgr.saveObject(project, session)) {
                                request.setAttribute("Status", "Ok");
                            } else {
                                request.setAttribute("Status", "Failed");
                            }
                        } else {
                            request.setAttribute("Status", "No");
                            request.setAttribute("name", "Duplicate Name");
                        }
                    } catch (NoUserInSessionException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                    unitDocMgr = UnitDocMgr.getInstance();
                    try {
                        if (project.getAttribute("modelID") != null) {
                            if (unitDocMgr.saveDocumentForModel(multipartRequest, (String) project.getAttribute("modelID"), session)) {
                                request.setAttribute("Status", "OK");
                            } else {
                                request.setAttribute("Status", "Failed");
                            }
                        }
                    } catch (NoUserInSessionException ex) {
                        Logger.getLogger(UnitDocWriterServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                } catch (IncorrectFileType ex) {
                    Logger.getLogger(UnitDocWriterServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                projId = multipartRequest != null ? multipartRequest.getParameter("projId") : null;
                projectMgr = ProjectMgr.getInstance();
                if (projId != null) {
                    request.setAttribute("project", projectMgr.getOnSingleKey(projId));
                } else {
                    request.setAttribute("project", new WebBusinessObject());
                }
                waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
                userID = waUser.getAttribute("userId").toString();
                request.setAttribute("projId", projId);
                servedPage = "/docs/units/new_tree_model.jsp";
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;
            case 23:
                servedPage = "/docs/unit_doc_handling/attach_master_plan.jsp";
                request.setAttribute("page", servedPage);
                projId = request.getParameter("projId");
                projectMgr = ProjectMgr.getInstance();
                request.setAttribute("project", projectMgr.getOnSingleKey(projId));
                request.setAttribute("projId", projId);
                try {
                    ArrayList<WebBusinessObject> docTypeList = new ArrayList<WebBusinessObject>(DocTypeMgr.getInstance().getOnArbitraryKeyOracle("Master Plan", "key1"));
                    if (!docTypeList.isEmpty()) {
                        request.setAttribute("docTypeWbo", docTypeList.get(0));
                    }
                } catch (Exception ex) {
                    Logger.getLogger(UnitDocWriterServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                this.forward(servedPage, request, response);
                break;
            case 24:
                userHome = (String) userObj.getAttribute("userHome");
                userBackEndHome = web_inf_path + "/usr/" + userHome + "/";
                multipartRequest = null;
                unitDocMgr = UnitDocMgr.getInstance();
                try {
                    multipartRequest = new MultipartRequest(request, userBackEndHome, "UTF-8");
                } catch (IncorrectFileType ex) {
                    Logger.getLogger(UnitDocWriterServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                try {
                    if (unitDocMgr.saveDocumentByTree(multipartRequest, session)) {
                        request.setAttribute("Status", "OK");
                    } else {
                        request.setAttribute("Status", "Failed");
                    }
                } catch (NoUserInSessionException ex) {
                    Logger.getLogger(UnitDocWriterServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                projId = multipartRequest != null ? multipartRequest.getParameter("projId") : null;
                projectMgr = ProjectMgr.getInstance();
                if (projId != null) {
                    request.setAttribute("project", projectMgr.getOnSingleKey(projId));
                } else {
                    request.setAttribute("project", new WebBusinessObject());
                }
                waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
                userID = waUser.getAttribute("userId").toString();
                request.setAttribute("projId", projId);
                servedPage = "/docs/unit_doc_handling/attach_master_plan.jsp";
                try {
                    ArrayList<WebBusinessObject> docTypeList = new ArrayList<WebBusinessObject>(DocTypeMgr.getInstance().getOnArbitraryKeyOracle("Master Plan", "key1"));
                    if (!docTypeList.isEmpty()) {
                        request.setAttribute("docTypeWbo", docTypeList.get(0));
                    }
                } catch (Exception ex) {
                    Logger.getLogger(UnitDocWriterServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;
            case 25:
                servedPage = "/docs/unit_doc_handling/attach_map_position.jsp";
                request.setAttribute("page", servedPage);
                projId = request.getParameter("projId");
                projectMgr = ProjectMgr.getInstance();
                request.setAttribute("project", projectMgr.getOnSingleKey(projId));
                request.setAttribute("projId", projId);
                try {
                    ArrayList<WebBusinessObject> docTypeList = new ArrayList<WebBusinessObject>(DocTypeMgr.getInstance().getOnArbitraryKeyOracle("Position in Map", "key1"));
                    if (!docTypeList.isEmpty()) {
                        request.setAttribute("docTypeWbo", docTypeList.get(0));
                    }
                } catch (Exception ex) {
                    Logger.getLogger(UnitDocWriterServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                this.forward(servedPage, request, response);
                break;
            case 26:
                userHome = (String) userObj.getAttribute("userHome");
                userBackEndHome = web_inf_path + "/usr/" + userHome + "/";
                multipartRequest = null;
                unitDocMgr = UnitDocMgr.getInstance();
                try {
                    multipartRequest = new MultipartRequest(request, userBackEndHome, "UTF-8");
                } catch (IncorrectFileType ex) {
                    Logger.getLogger(UnitDocWriterServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                try {
                    if (unitDocMgr.saveDocumentByTree(multipartRequest, session)) {
                        request.setAttribute("Status", "OK");
                    } else {
                        request.setAttribute("Status", "Failed");
                    }
                } catch (NoUserInSessionException ex) {
                    Logger.getLogger(UnitDocWriterServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                projId = multipartRequest != null ? multipartRequest.getParameter("projId") : null;
                projectMgr = ProjectMgr.getInstance();
                if (projId != null) {
                    request.setAttribute("project", projectMgr.getOnSingleKey(projId));
                } else {
                    request.setAttribute("project", new WebBusinessObject());
                }
                waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
                userID = waUser.getAttribute("userId").toString();
                request.setAttribute("projId", projId);
                servedPage = "/docs/unit_doc_handling/attach_map_position.jsp";
                try {
                    ArrayList<WebBusinessObject> docTypeList = new ArrayList<WebBusinessObject>(DocTypeMgr.getInstance().getOnArbitraryKeyOracle("Position in Map", "key1"));
                    if (!docTypeList.isEmpty()) {
                        request.setAttribute("docTypeWbo", docTypeList.get(0));
                    }
                } catch (Exception ex) {
                    Logger.getLogger(UnitDocWriterServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
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
        if(opName.equalsIgnoreCase("attach")) {
            return 15;
        }
        
        if(opName.equalsIgnoreCase("SaveDocByTree")){
            return 16;
        }
        
        if(opName.equalsIgnoreCase("attachCustomerFile")){
            return 17;
        }
        
        if(opName.equalsIgnoreCase("SaveCustomerFile")){
            return 18;
        }
             
        if (opName.equalsIgnoreCase("saveMultiFiles")) {
            return 19;
        }
        
        if (opName.equals("viewUnitData")) {
            return 20;
        }
        
        if (opName.equals("getNewModelForm")) {
            return 21;
        }
        
        if (opName.equals("saveNewModel")) {
            return 22;
        }
        
        if (opName.equals("attachMasterPlan")) {
            return 23;
        }
        
        if (opName.equals("saveMasterPlan")) {
            return 24;
        }
        
        if (opName.equals("attachMapPosition")) {
            return 25;
        }
        
        if (opName.equals("saveMapPosition")) {
            return 26;
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
        }else if(type.indexOf("Rar") >= 0){
            return new String("rar");
        }
        
        
        return null;
    }
    
}