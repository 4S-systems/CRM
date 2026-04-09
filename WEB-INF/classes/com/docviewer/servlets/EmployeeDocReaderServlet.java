package com.docviewer.servlets;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import com.docviewer.business_objects.Document;
import com.businessfw.hrs.db_access.EmployeeDocMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.db_access.FileMgr;
import com.silkworm.persistence.relational.UniqueIDGen;
import java.awt.image.BufferedImage;
import java.util.Vector;
import javax.imageio.ImageIO;

public class EmployeeDocReaderServlet extends ImageHandlerServlet {
    String RIPath = null;
    String docID = null;
    String docType = null;
    FileMgr fileMgr = FileMgr.getInstance();
    WebBusinessObject fileDescriptor = null;
    String app = null;
    public String empID = null;
    EmployeeDocMgr employeeDocMgr = EmployeeDocMgr.getInstance();
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
        
        super.processRequest(request,response);
        
        String op = (String) request.getParameter("op");
        operation = getOpCode(op);
        
        try {
            switch (operation) {
                case 1:
//
//                    servedPage = "/docs/employee_doc_handling/docs_list.jsp";
//
//                    docsList = employeeDocMgr.getDocsList(request.getParameter("op"),"");
//
//                    request.setAttribute("data", docsList);
//
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 2:
                    
                    docType = request.getParameter("docType");
                    docID = request.getParameter("docID");
                    
                    fileDescriptor = fileMgr.getObjectFromCash(docType);
                    
                    app = (String) fileDescriptor.getAttribute("app");
                    
                    if(docType.equalsIgnoreCase("jpg")) {
                        servedPage = "/docs/employee_doc_handling/image_renderer.jsp";
                        request.setAttribute("page",servedPage);
                        randome = UniqueIDGen.getNextID();
                        len = randome.length();
                        
                        randFileName = new String("ran" +  randome.substring(5,len) + ".jpeg");
                        
                        
                        RIPath = userImageDir + "/" + randFileName;
                        
                        
                        absPath = "images/" + userHome + "/" + randFileName;
                        
                        docImage = new File(RIPath);
                        docID = request.getParameter("docID");
                        gifData = new BufferedInputStream(employeeDocMgr.getImage(docID));
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
                        
                        BufferedInputStream pdfData =
                                new BufferedInputStream(employeeDocMgr.getImage(docID));
                        
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
                    
                case 3:
                    docID = request.getParameter("docID");
                    Document doc = (Document) employeeDocMgr.getOnSingleKey(docID);
                    request.setAttribute("docID", request.getParameter("docID"));
                    request.setAttribute("docTitle", request.getParameter("docTitle"));
                    request.setAttribute("doc",doc);
                    empID =request.getParameter("empID");
                    servedPage = "/docs/employee_doc_handling/confirm_deletion.jsp";
                    request.setAttribute("empID",empID);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 4:
                    docID = request.getParameter("docID");
                    employeeDocMgr.deleteOnSingleKey(docID);
                    empID = request.getParameter("empID");
                    servedPage = "/docs/employee_doc_handling/docs_list.jsp";
                    
                    empID =  empID.replace('^','&');
                    empID =  empID.replace('$','#');
                    empID =  empID.replace('*',';');
                    
                    docsList = employeeDocMgr.getListOnLIKE(request.getParameter("op"),empID);
                    request.setAttribute("data",docsList);
                    request.setAttribute("empID",empID);
                    request.setAttribute("data", docsList);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 5:
//                    String  projectname = request.getParameter("projectName");
//                    servedPage = "/docs/employee_doc_handling/doc_details.jsp";
//                    request.setAttribute("page",servedPage);
//
//                    docID = request.getParameter("docID");
//                    // ------------------------------------------
//
//
//                    randome = UniqueIDGen.getNextID();
//                    len = randome.length();
//
//                    randFileName = new String("ran" +  randome.substring(5,len) + ".jpeg");
//
//
//                    RIPath = userImageDir + "/" + randFileName;
//
//
//                    absPath = "images/" + userHome + "/" + randFileName;
//
//                    docImage = new File(RIPath);
//                    docID = request.getParameter("docID");
//                    gifData = new BufferedInputStream(employeeDocMgr.getImage(docID));
//                    myImage = ImageIO.read(gifData);
//                    ImageIO.write(myImage,"jpeg",docImage);
//                    request.setAttribute("imagePath", absPath);
//
//                    // --------------------------------------------
//
//                    doc = (Document) employeeDocMgr.getOnSingleKey(docID);
//
//                    VO.setAttribute("filter",(String) request.getParameter("filter"));
//                    VO.setAttribute("filterValue",(String) request.getParameter("filterValue"));
//
//                    request.setAttribute("projectName", projectname);
//                    request.setAttribute("defDocID",docID);
//                    request.setAttribute("docObject", doc);
//                    request.setAttribute("viewOrigin", VO);
//
                    this.forwardToServedPage(request, response);
                    
                    break;
                case 6:
                    
//                    servedPage = "/docs/employee_doc_handling/client_interval_search.jsp";
//                    String context = op.substring(op.length() - 3);
//                    String nextTarget = "ListAccount" + context;
//                    request.setAttribute("op", nextTarget);
//                    request.setAttribute("ts", "ImageReaderServlet");
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 7:
//                    String filterValue = request.getParameter("filterValue");
//
//                    if (null==filterValue)
//                        filterValue = buildFromDate(request) + ":" + buildToDate(request)+ ">" + request.getParameter("account");
//
//                    try {
//                        servedPage = "/docs/employee_doc_handling/docs_list.jsp";
//                        docsList = employeeDocMgr.getAccountDocsInRange(request.getParameter("op"),filterValue);
//
//                        request.setAttribute("data", docsList);
//
//                        request.setAttribute("page",servedPage);
//                        this.forwardToServedPage(request, response);
//                        break;
//
//                    } catch(SQLException sqlEx) {
//                        System.out.println(sqlEx.getMessage());
//                    } catch(Exception e) {
//                        System.out.println(e.getMessage());
//                    }
//
                    break;
                    
                case 8:
//
//                    servedPage = "/docs/employee_doc_handling/like_form.jsp";
                    request.setAttribute("page",servedPage);
//
//                    String likeContext = op.substring(op.length() - 3);
//                    String likeTarget = "ListTitlesLike" + likeContext;
//
//
//
//                    request.setAttribute("operation", likeTarget);
//
                    this.forwardToServedPage(request, response);
                    break;
                    
                    
                case 9:
//
//                    servedPage = "/docs/employee_doc_handling/docs_list.jsp";
                    request.setAttribute("page",servedPage);
//
//                    filterValue = request.getParameter("filterValue");
//
//                    docsList = employeeDocMgr.getListOnLIKE(request.getParameter("op"),filterValue);
//                    request.setAttribute("data",docsList);
//
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 11:
                    docID = request.getParameter("docID");
                    empID =request.getParameter("empID");
                    
                    doc = (Document) employeeDocMgr.getOnSingleKey(docID);
                    if (null==doc) {
                        servedPage = "/docs/search/id_search.jsp";
                        request.setAttribute("page",servedPage);
                        request.setAttribute("message","nodocument");
                    } else {
                        if(doc.getAttribute("docType").toString().equalsIgnoreCase("jpg")) {
                            servedPage = "/docs/unit_doc_handling/image_renderer.jsp";
                            request.setAttribute("page",servedPage);
                            randome = UniqueIDGen.getNextID();
                            len = randome.length();
                            
                            randFileName = new String("ran" +  randome.substring(5,len) + ".jpeg");
                            
                            
                            RIPath = userImageDir + "/" + randFileName;
                            
                            
                            absPath = "images/" + userHome + "/" + randFileName;
                            
                            docImage = new File(RIPath);
                            docID = request.getParameter("docID");
                            gifData = new BufferedInputStream(employeeDocMgr.getImage(docID));
                            myImage = ImageIO.read(gifData);
                            ImageIO.write(myImage,"jpeg",docImage);
                            request.setAttribute("imagePath", absPath);
                        }
                        servedPage = "/docs/employee_doc_handling/doc_details.jsp";
                        request.setAttribute("page",servedPage);
                        request.setAttribute("empID",empID);
                        request.setAttribute("defDocID",docID);
                        request.setAttribute("docObject", doc);
                    }
                    
                    this.forwardToServedPage(request, response);
                    break;
                    
                    
                case 13:
//
//                    docID = request.getParameter("docID");
//                    BufferedInputStream xlsData = new BufferedInputStream(employeeDocMgr.getImage(docID));
//
//
//                    // ------------------------
//
//                    ServletOutputStream xlsStream = null;
//
//
//                    try{
//
//                        xlsStream = response.getOutputStream( );
//
//                        response.setContentType("application/excel");
//
//                        response.addHeader("Content-Disposition","attachment; filename="+"xuplod.xls" );
//
//
//                        int readBytes = 0;
//
//
//                        while((readBytes = xlsData.read()) != -1)
//                            xlsStream.write(readBytes);
//
//                    } catch (IOException ioe){
//
//                        throw new ServletException(ioe.getMessage( ));
//
//                    } finally {
//
//                        //close the input/output streams
//                        if (xlsStream != null)
//                            xlsStream.close( );
//                        if (xlsData != null)
//                            xlsData.close( );
//                    }
//
//
                    break;
                    
                case 14:
//
//                    docID = request.getParameter("docID");
//                    BufferedInputStream htmlData = new BufferedInputStream(employeeDocMgr.getImage(docID));
//
//
//                    // ------------------------
//
//                    ServletOutputStream htmlStream = null;
//
//
//                    try{
//
//                        htmlStream = response.getOutputStream( );
//
//                        response.setContentType("application/html");
//
//                        //    response.addHeader("Content-Disposition","attachment; filename="+"htmuplod.htm" );
//                        response.addHeader("Content-Disposition","attachment; filename="+"htmuplod.html" );
//
//                        int readBytes = 0;
//
//
//                        while((readBytes = htmlData.read()) != -1)
//                            htmlStream.write(readBytes);
//
//                    } catch (IOException ioe){
//
//                        throw new ServletException(ioe.getMessage( ));
//
//                    } finally {
//
//                        //close the input/output streams
//                        if (htmlStream != null)
//                            htmlStream.close( );
//                        if (htmlData != null)
//                            htmlData.close( );
//                    }
//
//
                    break;
                    
                case 15:
//
//                    if(!metaMgr.appletRender()) {
//
//                        docID = request.getParameter("docID");
//                        doc = (Document) employeeDocMgr.getOnSingleKey(docID);
//
//                        ServletOutputStream soundStream = null;
//                        BufferedInputStream soundBuffer = null;
//
//
//
//                        try{
//
//                            soundStream = response.getOutputStream( );
//                            File soundFile = new File(edatabase + doc.getAttribute("fileName"));
//
//
//                            response.setContentType("audio/mpeg");
//
//                            response.addHeader("Content-Disposition","attachment; filename="+doc.getAttribute("fileName") );
//                            response.setContentLength( (int) soundFile.length( ) );
//                            FileInputStream input = new FileInputStream(soundFile);
//                            soundBuffer = new BufferedInputStream(input);
//                            int readBytes = 0;
//
//
//                            while((readBytes = soundBuffer.read()) != -1)
//                                soundStream.write(readBytes);
//
//                        } catch (IOException ioe){
//
//                            throw new ServletException(ioe.getMessage( ));
//
//                        } finally {
//
//                            if (soundStream != null)
//                                soundStream.close( );
//                            if (soundBuffer != null)
//                                soundBuffer.close( );
//                        }
//
//
//                        break;
//                    } else {
//                        handleRequest(request,response);
                    break;
//                    }
                case 16:
//                    if(!metaMgr.appletRender()) {
//                        docID = request.getParameter("docID");
//                        doc = (Document) employeeDocMgr.getOnSingleKey(docID);
//
//                        ServletOutputStream movieStream = null;
//                        BufferedInputStream buf = null;
//                        try{
//
//                            movieStream = response.getOutputStream( );
//                            File mp3 = new File(edatabase + doc.getAttribute("fileName"));
//
//                            response.setContentType("audio/mpeg");
//
//                            response.addHeader( "Content-Disposition","attachment; filename="+ doc.getAttribute("fileName"));
//
//                            response.setContentLength( (int) mp3.length( ) );
//
//                            FileInputStream input = new FileInputStream(mp3);
//                            buf = new BufferedInputStream(input);
//                            int readBytes = 0;
//
//                            while((readBytes = buf.read( )) != -1)
//                                movieStream.write(readBytes);
//
//                        } catch (IOException ioe){
//
//                            throw new ServletException(ioe.getMessage( ));
//
//                        } finally {
//
//                            //close the input/output streams
//                            if(movieStream != null)
//                                movieStream.close( );
//
//                            if(buf != null)
//                                buf.close( );
//
//                        }
//
//
//                        break;
//                    } else {
//                        handleRequest(request,response);
                    break;
//                    }
                    
                case 17:
                    
//                    servedPage = "/docs/employee_doc_handling/docs_list.jsp";
//
//                    docsList = employeeDocMgr.getDocsList(request.getParameter("op"),"");
//
//                    request.setAttribute("data", docsList);
//
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 19:
                    
//                    servedPage = "/docs/employee_doc_handling/docs_list.jsp";
                    request.setAttribute("page",servedPage);
//
//                    filterValue = request.getParameter("filterValue");
//
//                    filterValue =  filterValue.replace('^','&');
//                    filterValue =  filterValue.replace('$','#');
//                    filterValue =  filterValue.replace('*',';');
//
//
//
//
//                    System.out.println("Filter Value is" + filterValue);
//
//                    docsList = employeeDocMgr.getListOnLIKE(request.getParameter("op"),filterValue);
//                    request.setAttribute("data",docsList);
//
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 20:
//                    docID = request.getParameter("docID");
//
//
//
//                    BufferedInputStream emlData =
//                            new BufferedInputStream(employeeDocMgr.getImage(docID));
//
//
//                    ServletOutputStream emlStream = null;
//
//
//                    try{
//
//                        emlStream = response.getOutputStream( );
//
//                        response.setContentType("application/msimn");
//
//                        response.addHeader("Content-Disposition","attachment; filename="+"req.eml" );
//
//
//                        int readBytes = 0;
//
//
//                        while((readBytes = emlData.read( )) != -1)
//                            emlStream.write(readBytes);
//
//                    } catch (IOException ioe){
//
//                        throw new ServletException(ioe.getMessage( ));
//
//                    } finally {
//
//                        if (emlStream != null)
//                            emlStream.close( );
//                        if (emlData != null)
//                            emlData.close( );
//                    }
//
//
                    break;
                    
                case 21:
                    
//                    servedPage = "/docs/employee_doc_handling/searchdoc_form.jsp";
                    request.setAttribute("page",servedPage);
//                    request.setAttribute("operation", "SearchAllDocsBody");
//
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 22:
                    
//                    servedPage = "/docs/employee_doc_handling/docs_list.jsp";
                    request.setAttribute("page",servedPage);
//
//                    filterValue = request.getParameter("filterValue");
//
//
//                    docsList = employeeDocMgr.getListOnLIKE(request.getParameter("op"),filterValue);
//                    request.setAttribute("data",docsList);
//
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 23:
                    
//                    servedPage = "/docs/employee_doc_handling/searchdoc_form.jsp";
                    request.setAttribute("page",servedPage);
//
//
//                    String BSCContext = op.substring(op.length() - 3);
//                    String BSTarget = "DBSearch" + BSCContext;
//
//                    request.setAttribute("operation", BSTarget);
//
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 24:
                    
//                    servedPage = "/docs/employee_doc_handling/docs_list.jsp";
                    request.setAttribute("page",servedPage);
//
//                    filterValue = request.getParameter("filterValue");
//
//                    docsList = employeeDocMgr.getListOnLIKE(request.getParameter("op"),filterValue);
//                    request.setAttribute("data",docsList);
//
                    this.forwardToServedPage(request, response);
                    break;
                    
                    
                    
                case 25:
//
//                    servedPage = "/docs/employee_doc_handling/interval_search.jsp";
//                    String context1 = op.substring(op.length() - 3);
//                    String nextTarget1 = "ListDocsInSpan" + context1;
//                    request.setAttribute("op", nextTarget1);
//
                    request.setAttribute("page",servedPage);
//                    request.setAttribute("operation", nextTarget1);
                    
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 26:
//                    String filterValue3 = request.getParameter("filterValue");
//                    String objType=request.getParameter("objType");
//
//                    if (null==filterValue3)
//                        filterValue3 = buildFromDate(request) + ":" + buildToDate(request);
//
//                    try {
//                        servedPage = "/docs/employee_doc_handling/docs_list.jsp";
//                        docsList = employeeDocMgr.getDocsInRange(request.getParameter("op"),filterValue3);
//
//                        request.setAttribute("data", docsList);
//
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
//                        break;
//
//                    } catch(SQLException sqlEx) {
//                        System.out.println(sqlEx.getMessage());
//                    } catch(Exception e) {
//                        System.out.println(e.getMessage());
//                    }
                    
                    break;
                    
                case 27:
//
//                    servedPage = "/docs/employee_doc_handling/latest_trans.jsp";
                    request.setAttribute("page",servedPage);
//                    request.setAttribute("operation", "GetLastTransaction");
//
                    this.forwardToServedPage(request, response);
                    break;
                    
                    
                case 28:
//
//                    Document latest = null;
//                    servedPage = "/docs/employee_doc_handling/docs_list.jsp";
//                    String docID = null;
//                    Vector oneDoc = new Vector(1);
//
//                    String account = request.getParameter("clientName");
//                    if(null!=account) {
//                        docID= employeeDocMgr.getLatestForClient(account);
//                    } else {
//                        docID= request.getParameter("filterValue");
//                    }
//
//                    System.out.println("doc Id " + docID);
//
//                    if(null!=docID) {
//                        latest = (Document)  employeeDocMgr.getLatestTransactionDoc(op,docID);
//                        oneDoc.add(latest);
//                        latest.printSelf();
//                        request.setAttribute("data",oneDoc);
//                        request.setAttribute("page",servedPage);
//
//                    } else {
//                        servedPage = "/main";
//                    }
                    
                    forwardToServedPage(request, response);
                    
                    break;
                    
                case 29:
                    
//                    servedPage = "/docs/employee_doc_handling/docs_list.jsp";
//                    request.setAttribute("data",fvtsMgr.buildUserFavorits());
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 30:
                    servedPage = "/docs/explorer/doc_explorer2.jsp";
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    
                    break;
                    
                    
                case 33:
//
//                    docID = request.getParameter("docID");
//                    String reqImageID = request.getParameter("nextImID");
//                    String imRank = request.getParameter("imRank");
//
//                    Integer bigI = new Integer(imRank);
//                    int sint = bigI.intValue();
//                    sint++;
//
//                    bigI = new Integer(sint);
//
//                    String nextImId = bigI.toString();
//
//                    Vector otherImages = diMgr.getOnRefInteg(docID);
//
//                    randome = UniqueIDGen.getNextID();
//                    len = randome.length();
//
//                    randFileName = new String("ran" +  randome.substring(5,len) + ".jpeg");
//
//
//                    RIPath = userImageDir + "/" + randFileName;
//
//                    absPath = "images/" + userHome + "/" + randFileName;
//                    docImage = new File(RIPath);
//
//                    servedPage = "/docs/employee_doc_handling/image_renderer.jsp";
//
//                    VO.setAttribute("filter",(String) request.getParameter("filter"));
//                    VO.setAttribute("filterValue",(String) request.getParameter("filterValue"));
//                    request.setAttribute("viewOrigin", VO);
//
//                    // put more images here
//                    request.setAttribute("moreimages", otherImages);
//                    request.setAttribute("imagerank",nextImId);
//
//                    BufferedInputStream gifData =
//                            new BufferedInputStream(diMgr.getImage(reqImageID));
//
//                    BufferedImage myImage = ImageIO.read(gifData);
//
//
//
//                    ImageIO.write(myImage,"jpeg",docImage);
//
//                    request.setAttribute("docID", docID);
//                    request.setAttribute("imagePath", absPath);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 34:
//                    WebBusinessObject wUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
//                    servedPage = "/docs/employee_doc_handling/docs_list.jsp";
//                    docID = request.getParameter("filterValue");
//
//                    if(wUser != null && wUser.getAttribute("groupName").toString().equalsIgnoreCase("administrator")) {
//                        docsList = employeeDocMgr.getListOnLIKE(request.getParameter("op"),docID);
//                    } else {
//                        docsList = employeeDocMgr.getListOnLIKE("ListSptrUser", docID);
//                    }
//
//                    request.setAttribute("data", docsList);
//                    request.setAttribute("filterValue",docID);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 35:
//                    servedPage = "/docs/search/id_search.jsp";
                    request.setAttribute("page",servedPage);
//                    request.setAttribute("message", "");
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 36:
                    servedPage = "/docs/employee_doc_handling/docs_list.jsp";
                    
                    empID =request.getParameter("empID");
                    
                    empID =  empID.replace('^','&');
                    empID =  empID.replace('$','#');
                    empID =  empID.replace('*',';');
                    
                    docsList = employeeDocMgr.getListOnLIKE(request.getParameter("op"),empID);
                    request.setAttribute("data",docsList);
                    request.setAttribute("empID",empID);
                    request.setAttribute("page",servedPage);
                    
                    this.forwardToServedPage(request, response);
                    
                    break;
                    
                case 37:
//                    docType = request.getParameter("docType");
//                    docID = request.getParameter("docID");
//
//                    fileDescriptor = fileMgr.getObjectFromCash(docType);
//
//                    app = (String) fileDescriptor.getAttribute("app");
//
                    employeeDocMgr = employeeDocMgr.getInstance();
                    Vector imageList = employeeDocMgr.getImagesList(request.getParameter("empID"));
                    Vector imagesPath = new Vector();
                    servedPage = "/docs/employee_doc_handling/view_images.jsp";
                    request.setAttribute("page",servedPage);
                    for(int i = 0; i < imageList.size(); i++){
                        randome = UniqueIDGen.getNextID();
                        len = randome.length();
                        docID = ((WebBusinessObject) imageList.get(i)).getAttribute("docID").toString();
                        randFileName = new String("ran" +  randome.substring(5,len) + ".jpeg");
                        
                        
                        RIPath = userImageDir + "/" + randFileName;
                        
                        
                        absPath = "images/" + userHome + "/" + randFileName;
                        
                        docImage = new File(RIPath);
                        
                        gifData = new BufferedInputStream(employeeDocMgr.getImage(docID));
                        myImage = ImageIO.read(gifData);
                        ImageIO.write(myImage,"jpeg",docImage);
                        imagesPath.add(absPath);
                    }
                    request.setAttribute("imagePath", imagesPath);
                    this.forwardToServedPage(request, response);
                    
                    break;
                    
                default:
                    
                    break;
            }
            
        } catch(Exception e) {
            System.out.println("Image Reader sevlet exception " + e.getMessage());
        }
    }
    
    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
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
        return "SA DOc Reaer";
    }
    
    protected int getOpCode(String opName) {
        if(opName.equalsIgnoreCase("ListAll"))
            return 1;
        
        if(opName.equalsIgnoreCase("ViewDocument"))
            return 2;
        
        if(opName.equalsIgnoreCase("ConfirmDelete"))
            return 3;
        
        if(opName.equalsIgnoreCase("Delete"))
            return 4;
        
        if(opName.equalsIgnoreCase("ViewDetailsImage"))
            return 5;
        
        
        
        if(opName.indexOf("SelectClient") == 0)
            return 6;
        
        
        if(opName.indexOf("ListAccount") == 0)
            return 7;
        
        if(opName.indexOf("LIKESearch")==0)
            return 8;
        
        
        
        if(opName.equalsIgnoreCase("DocDetails"))
            return 11;
        
        
        
        
        if(opName.equalsIgnoreCase("GetXLS"))
            return 13;
        
        if(opName.equalsIgnoreCase("GetHTML"))
            return 14;
        
        if(opName.equalsIgnoreCase("GetAudio"))
            return 15;
        
        if(opName.equalsIgnoreCase("GetMovie"))
            return 16;
        
        if(opName.equalsIgnoreCase("ListAllContext"))
            return 17;
        
        
        
        if(opName.indexOf("ListTitlesLike")==0)
            return 19;
        
        
        if(opName.equalsIgnoreCase("GetEmail"))
            return 20;
        
        if(opName.equalsIgnoreCase("GetSearchForm"))
            return 21;
        
        if(opName.equalsIgnoreCase("SearchAllDocsBody"))
            return 22;
        
        
        if(opName.indexOf("DocBodySearch")==0)
            return 23;
        
        
        if(opName.indexOf("DBSearch")== 0)
            return 24;
        
        
        if(opName.indexOf("IntervalSearch")== 0)
            return 25;
        
        
        if(opName.indexOf("ListDocsInSpan")==0)
            return 26;
        
        if(opName.equalsIgnoreCase("GetAccountsList"))
            return 27;
        
        if(opName.equalsIgnoreCase("GetLastTransaction"))
            return 28;
        
        if(opName.indexOf("MyFavorits")==0)
            return 29;
        
        if(opName.equalsIgnoreCase("SeparatorView"))
            return 30;
        
        if(opName.equalsIgnoreCase("FolderView"))
            return 31;
        
        if(opName.equalsIgnoreCase("CabinetView"))
            return 32;
        
        if(opName.equalsIgnoreCase("GetNextImage"))
            return 33;
        
        if(opName.equalsIgnoreCase("ListSptr"))
            return 34;
        
        if(opName.indexOf("IDSearch")==0)
            return 35;
        if(opName.equalsIgnoreCase("ListDoc"))
            return 36;
        
        if(opName.equalsIgnoreCase("ViewImages"))
            return 37;
        
        return 0;
    }
    
    
}