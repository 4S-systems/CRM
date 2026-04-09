package com.docviewer.servlets;

import javax.servlet.*;
import javax.servlet.http.*;

import java.sql.*;

import java.awt.image.*;
import javax.imageio.*;
import java.io.*;
import com.silkworm.business_objects.*;
import com.docviewer.db_access.ImageMgr;
import java.util.*;
import com.docviewer.business_objects.Document;

import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.common.BookmarkMgr;
import com.silkworm.db_access.FileMgr;
import com.docviewer.rendering.*;
import com.silkworm.db_access.FavoritesMgr;

import com.docviewer.db_access.*;

public class InstReaderServlet extends ImageHandlerServlet {
    String RIPath = null;
    String absPath = null;
    
    String instId = null;
    String filterValue = null;
    String filter = null;
    
    String docType = null;
    
    FileMgr fileMgr = FileMgr.getInstance();
    WebBusinessObject fileDescriptor = null;
    String app = null;
    
    public String filterName = null;
    public String filterBack = null;
    
    public String unitScheduleID=null;
    
    InstMgr instMgr = InstMgr.getInstance();
    DocImgMgr diMgr = DocImgMgr.getInstance();
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    BookmarkMgr bmMgr = BookmarkMgr.getInstance();
    FavoritesMgr fvtsMgr = FavoritesMgr.getInstance();
    
    SeparatorMgr sptrMgr = SeparatorMgr.getInstance();
    
    BufferedInputStream gifData = null;
    BufferedImage myImage = null;
    
    Document doc = null;
    WebBusinessObject VO = new WebBusinessObject();
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
        
        System.out.println("operation is: " + operation);
        try {
            switch (operation) {
                case 1:
                    
                    servedPage = "/docs/inst_handling/docs_list.jsp";
                    
                    docsList = instMgr.getDocsList(request.getParameter("op"),"");
                    
                    request.setAttribute("data", docsList);
                    
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 2:
                    
                    docType = request.getParameter("docType");
                    instId = request.getParameter("instId");
                    
                    fileDescriptor = fileMgr.getObjectFromCash(docType);
                    
                    app = (String) fileDescriptor.getAttribute("app");
                    
                    if(docType.equalsIgnoreCase("jpg")) {
                        servedPage = "/docs/inst_handling/image_renderer.jsp";
                        request.setAttribute("page",servedPage);
                        randome = UniqueIDGen.getNextID();
                        len = randome.length();
                        
                        randFileName = new String("ran" +  randome.substring(5,len) + ".jpeg");
                        
                        
                        RIPath = userImageDir + "/" + randFileName;
                        
                        
                        absPath = "images/" + userHome + "/" + randFileName;
                        
                        docImage = new File(RIPath);
                        instId = request.getParameter("instId");
                        gifData = new BufferedInputStream(instMgr.getImage(instId));
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
                                new BufferedInputStream(instMgr.getImage(instId));
                        
                        // ------------------------
                        
                        ServletOutputStream stream = null;
                        
                        
                        try{
                            
                            stream = response.getOutputStream( );
                            // File pdf = new File(pdfData);
                            
                            //set response headers
                            response.setContentType("application/" + app);
                            
                            response.addHeader("Content-Disposition","attachment; filename="+"req." + docType );
                            
                            int readBytes = 0;
                            
                            while((readBytes = pdfData.read( )) != -1)
                                stream.write(readBytes);
                            
                        } catch (IOException ioe){
                            
                            throw new ServletException(ioe.getMessage( ));
                            
                        } finally {
                            
                            //close the input/output streams
                            if (stream != null)
                                stream.close( );
                            if (pdfData != null)
                                pdfData.close( );
                        }
                        
                        break;
                        
                    }
                    
                case 3:
                    instId = request.getParameter("instId");
                    Document doc = (Document) instMgr.getOnSingleKey(instId);
                    
                    request.setAttribute("instId", request.getParameter("instId"));
                    request.setAttribute("instTitle", request.getParameter("instTitle"));
                    request.setAttribute("doc",doc);
                    
//                    VO.setAttribute("filter",(String) request.getParameter("filter"));
//                    VO.setAttribute("filterValue",(String) request.getParameter("filterValue"));
                    request.setAttribute("viewOrigin", VO);
                    
                    filterBack = request.getParameter("filterBack");
                    filter = request.getParameter("filter");
                    filterValue = request.getParameter("filterValue");
                    unitScheduleID =request.getParameter("unitScheduleID");
                    servedPage = "/docs/inst_handling/confirm_deletion.jsp";
                    
                    request.setAttribute("unitScheduleID",unitScheduleID);
                    request.setAttribute("fName",filter);
                    request.setAttribute("filterBack",filterBack);
                    request.setAttribute("filterValue",filterValue);
                    request.setAttribute("page",servedPage);
                    
                    this.forwardToServedPage(request, response);
                    
                    
                    break;
                    
                case 4:
                    //  BookmarkMgr bookmarkMgr = BookmarkMgr.getInstance();
                    instId = request.getParameter("instId");
                    //bookmarkMgr.deleteRefIntegKey(instId);
                    instMgr.deleteOnSingleKey(instId);
                    
                    filter = request.getParameter("filterName");
                    filterBack = request.getParameter("filterBack");
                    filterValue = request.getParameter("filterValue");
                    unitScheduleID = request.getParameter("unitScheduleID");
                    
                    filterValue =  filterValue.replace('^','&');
                    filterValue =  filterValue.replace('$','#');
                    
                    if(filterBack.equalsIgnoreCase("GetLastTransaction")) {
                        servedPage = "/main";
                        this.forwardToServedPage(request, response);
                        break;
                    }
                    
                    servedPage = "/docs/inst_handling/docs_list.jsp";
                    docsList = instMgr.getListOnLIKE("ListDoc",unitScheduleID);
//                    
//                    if(filterBack.indexOf("DBSearch") == 0)
//                        docsList = instMgr.getListOnLIKE(filterBack,filterValue);
//                    
//                    
//                    else if (filterBack.indexOf("ListDocsInSpan") == 0)
//                        docsList = instMgr.getDocsInRange(filterBack, filterValue);
//                    
//                    else if (filterBack.indexOf("ListTitlesLike") == 0)
//                        docsList = instMgr.getListOnLIKE(filterBack, filterValue);
//                    
//                    else if (filterBack.indexOf("ListAccount") == 0)
//                        docsList = instMgr.getAccountDocsInRange(filterBack,filterValue);
//                    
//                    else if (filterBack.indexOf("ListSptr") == 0)
//                        docsList = instMgr.getListOnLIKE(filterBack,filterValue);
//                    else if (filterBack.indexOf("ListDoc") == 0)
                        docsList = instMgr.getListOnLIKE(filterBack,unitScheduleID);
                    
                    request.setAttribute("unitScheduleID",unitScheduleID);
                    request.setAttribute("fName",filter);
                    request.setAttribute("filterBack",filterBack);
                    request.setAttribute("fValue",filterValue);
                    request.setAttribute("data", docsList);
                    
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    
                    
                    break;
                case 5:
                    String  projectname = request.getParameter("projectName");
                    servedPage = "/docs/inst_handling/doc_details.jsp";
                    request.setAttribute("page",servedPage);
                    
                    instId = request.getParameter("instId");
                    // ------------------------------------------
                    
                    
                    randome = UniqueIDGen.getNextID();
                    len = randome.length();
                    
                    randFileName = new String("ran" +  randome.substring(5,len) + ".jpeg");
                    
                    
                    RIPath = userImageDir + "/" + randFileName;
                    
                    
                    absPath = "images/" + userHome + "/" + randFileName;
                    
                    docImage = new File(RIPath);
                    instId = request.getParameter("instId");
                    gifData = new BufferedInputStream(instMgr.getImage(instId));
                    myImage = ImageIO.read(gifData);
                    ImageIO.write(myImage,"jpeg",docImage);
                    request.setAttribute("imagePath", absPath);
                    
                    // --------------------------------------------
                    
                    doc = (Document) instMgr.getOnSingleKey(instId);
                    
                    VO.setAttribute("filter",(String) request.getParameter("filter"));
                    VO.setAttribute("filterValue",(String) request.getParameter("filterValue"));
                    
                    request.setAttribute("projectName", projectname);
                    request.setAttribute("defDocID",instId);
                    request.setAttribute("docObject", doc);
                    request.setAttribute("viewOrigin", VO);
                    
                    this.forwardToServedPage(request, response);
                    
                    break;
                case 6:
                    
                    servedPage = "/docs/inst_handling/client_interval_search.jsp";
                    String context = op.substring(op.length() - 3);
                    String nextTarget = "ListAccount" + context;
                    request.setAttribute("op", nextTarget);
                    request.setAttribute("ts", "ImageReaderServlet");
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
//                case 7:
//                    String filterValue = request.getParameter("filterValue");
//                    
//                    if (null==filterValue)
//                        filterValue = buildFromDate(request) + ":" + buildToDate(request)+ ">" + request.getParameter("account");
//                    
//                    try {
//                        servedPage = "/docs/inst_handling/docs_list.jsp";
//                        docsList = instMgr.getAccountDocsInRange(request.getParameter("op"),filterValue);
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
//                    break;
//                    
                case 8:
                    
                    servedPage = "/docs/inst_handling/like_form.jsp";
                    request.setAttribute("page",servedPage);
                    
                    String likeContext = op.substring(op.length() - 3);
                    String likeTarget = "ListTitlesLike" + likeContext;
                    
                    
                    
                    request.setAttribute("operation", likeTarget);
                    
                    this.forwardToServedPage(request, response);
                    break;
                    
                    
                case 9:
                    
                    servedPage = "/docs/inst_handling/docs_list.jsp";
                    request.setAttribute("page",servedPage);
                    
                    filterValue = request.getParameter("filterValue");
                    
                    docsList = instMgr.getListOnLIKE(request.getParameter("op"),filterValue);
                    request.setAttribute("data",docsList);
                    
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 11:
                    
                    projectname = request.getParameter("projectName");
                    instId = request.getParameter("instId");
                    unitScheduleID =request.getParameter("unitScheduleID");
                    String filter = request.getParameter("filter");
                    filterValue = request.getParameter("filterValue");
                    
                    if (filter==null|| filterValue ==null) {
                        filter=new String("");
                        filterValue=new String("");
                    }
                    doc = (Document) instMgr.getOnSingleKey(instId);
                    if (null==doc) {
                        servedPage = "/docs/search/id_search.jsp";
                        request.setAttribute("page",servedPage);
                        request.setAttribute("message","nodocument");
                    } else {
                        servedPage = "/docs/inst_handling/doc_details.jsp";
                        request.setAttribute("page",servedPage);
                        request.setAttribute("unitScheduleID",unitScheduleID);
                        request.setAttribute("defDocID",instId);
                        request.setAttribute("docObject", doc);
                        request.setAttribute("viewOrigin", VO);
                    }
                    
                    this.forwardToServedPage(request, response);
                    break;
                    
                    
                case 13:
                    
                    instId = request.getParameter("instId");
                    BufferedInputStream xlsData = new BufferedInputStream(instMgr.getImage(instId));
                    
                    
                    // ------------------------
                    
                    ServletOutputStream xlsStream = null;
                    
                    
                    try{
                        
                        xlsStream = response.getOutputStream( );
                        
                        response.setContentType("application/excel");
                        
                        response.addHeader("Content-Disposition","attachment; filename="+"xuplod.xls" );
                        
                        
                        int readBytes = 0;
                        
                        
                        while((readBytes = xlsData.read()) != -1)
                            xlsStream.write(readBytes);
                        
                    } catch (IOException ioe){
                        
                        throw new ServletException(ioe.getMessage( ));
                        
                    } finally {
                        
                        //close the input/output streams
                        if (xlsStream != null)
                            xlsStream.close( );
                        if (xlsData != null)
                            xlsData.close( );
                    }
                    
                    
                    break;
                    
                case 14:
                    
                    instId = request.getParameter("instId");
                    BufferedInputStream htmlData = new BufferedInputStream(instMgr.getImage(instId));
                    
                    
                    // ------------------------
                    
                    ServletOutputStream htmlStream = null;
                    
                    
                    try{
                        
                        htmlStream = response.getOutputStream( );
                        
                        response.setContentType("application/html");
                        
                        //    response.addHeader("Content-Disposition","attachment; filename="+"htmuplod.htm" );
                        response.addHeader("Content-Disposition","attachment; filename="+"htmuplod.html" );
                        
                        int readBytes = 0;
                        
                        
                        while((readBytes = htmlData.read()) != -1)
                            htmlStream.write(readBytes);
                        
                    } catch (IOException ioe){
                        
                        throw new ServletException(ioe.getMessage( ));
                        
                    } finally {
                        
                        //close the input/output streams
                        if (htmlStream != null)
                            htmlStream.close( );
                        if (htmlData != null)
                            htmlData.close( );
                    }
                    
                    
                    break;
                    
                case 15:
                    
                    if(!metaMgr.appletRender()) {
                        
                        instId = request.getParameter("instId");
                        doc = (Document) instMgr.getOnSingleKey(instId);
                        
                        ServletOutputStream soundStream = null;
                        BufferedInputStream soundBuffer = null;
                        
                        
                        
                        try{
                            
                            soundStream = response.getOutputStream( );
                            File soundFile = new File(edatabase + doc.getAttribute("fileName"));
                            
                            
                            response.setContentType("audio/mpeg");
                            
                            response.addHeader("Content-Disposition","attachment; filename="+doc.getAttribute("fileName") );
                            response.setContentLength( (int) soundFile.length( ) );
                            FileInputStream input = new FileInputStream(soundFile);
                            soundBuffer = new BufferedInputStream(input);
                            int readBytes = 0;
                            
                            
                            while((readBytes = soundBuffer.read()) != -1)
                                soundStream.write(readBytes);
                            
                        } catch (IOException ioe){
                            
                            throw new ServletException(ioe.getMessage( ));
                            
                        } finally {
                            
                            if (soundStream != null)
                                soundStream.close( );
                            if (soundBuffer != null)
                                soundBuffer.close( );
                        }
                        
                        
                        break;
                    } else {
                        handleRequest(request,response);
                        break;
                    }
                case 16:
                    if(!metaMgr.appletRender()) {
                        instId = request.getParameter("instId");
                        doc = (Document) instMgr.getOnSingleKey(instId);
                        
                        ServletOutputStream movieStream = null;
                        BufferedInputStream buf = null;
                        try{
                            
                            movieStream = response.getOutputStream( );
                            File mp3 = new File(edatabase + doc.getAttribute("fileName"));
                            
                            response.setContentType("audio/mpeg");
                            
                            response.addHeader( "Content-Disposition","attachment; filename="+ doc.getAttribute("fileName"));
                            
                            response.setContentLength( (int) mp3.length( ) );
                            
                            FileInputStream input = new FileInputStream(mp3);
                            buf = new BufferedInputStream(input);
                            int readBytes = 0;
                            
                            while((readBytes = buf.read( )) != -1)
                                movieStream.write(readBytes);
                            
                        } catch (IOException ioe){
                            
                            throw new ServletException(ioe.getMessage( ));
                            
                        } finally {
                            
                            //close the input/output streams
                            if(movieStream != null)
                                movieStream.close( );
                            
                            if(buf != null)
                                buf.close( );
                            
                        }
                        
                        
                        break;
                    } else {
                        handleRequest(request,response);
                        break;
                    }
                    
//                case 17:
//                    
//                    servedPage = "/docs/inst_handling/docs_list.jsp";
//                    
//                    docsList = instMgr.getDocsList(request.getParameter("op"),"");
//                    
//                    request.setAttribute("data", docsList);
//                    
//                    request.setAttribute("page",servedPage);
//                    this.forwardToServedPage(request, response);
//                    break;
//                    
//                case 19:
//                    
//                    servedPage = "/docs/inst_handling/docs_list.jsp";
//                    request.setAttribute("page",servedPage);
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
//                    docsList = instMgr.getListOnLIKE(request.getParameter("op"),filterValue);
//                    request.setAttribute("data",docsList);
//                    
//                    this.forwardToServedPage(request, response);
//                    break;
//                    
//                case 20:
//                    instId = request.getParameter("instId");
//                    
//                    
//                    
//                    BufferedInputStream emlData =
//                            new BufferedInputStream(instMgr.getImage(instId));
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
//                    break;
//                    
//                case 21:
//                    
//                    servedPage = "/docs/inst_handling/searchdoc_form.jsp";
//                    request.setAttribute("page",servedPage);
//                    request.setAttribute("operation", "SearchAllDocsBody");
//                    
//                    this.forwardToServedPage(request, response);
//                    break;
//                    
//                case 22:
//                    
//                    servedPage = "/docs/inst_handling/docs_list.jsp";
//                    request.setAttribute("page",servedPage);
//                    
//                    filterValue = request.getParameter("filterValue");
//                    
//                    
//                    docsList = instMgr.getListOnLIKE(request.getParameter("op"),filterValue);
//                    request.setAttribute("data",docsList);
//                    
//                    this.forwardToServedPage(request, response);
//                    break;
//                    
//                case 23:
//                    
//                    servedPage = "/docs/inst_handling/searchdoc_form.jsp";
//                    request.setAttribute("page",servedPage);
//                    
//                    
//                    String BSCContext = op.substring(op.length() - 3);
//                    String BSTarget = "DBSearch" + BSCContext;
//                    
//                    request.setAttribute("operation", BSTarget);
//                    
//                    this.forwardToServedPage(request, response);
//                    break;
//                    
//                case 24:
//                    
//                    servedPage = "/docs/inst_handling/docs_list.jsp";
//                    request.setAttribute("page",servedPage);
//                    
//                    filterValue = request.getParameter("filterValue");
//                    
//                    docsList = instMgr.getListOnLIKE(request.getParameter("op"),filterValue);
//                    request.setAttribute("data",docsList);
//                    
//                    this.forwardToServedPage(request, response);
//                    break;
//                    
//                    
//                    
//                case 25:
//                    
//                    servedPage = "/docs/inst_handling/interval_search.jsp";
//                    String context1 = op.substring(op.length() - 3);
//                    String nextTarget1 = "ListDocsInSpan" + context1;
//                    request.setAttribute("op", nextTarget1);
//                    
//                    request.setAttribute("page",servedPage);
//                    request.setAttribute("operation", nextTarget1);
//                    
//                    this.forwardToServedPage(request, response);
//                    break;
//                    
//                case 26:
//                    String filterValue3 = request.getParameter("filterValue");
//                    String objType=request.getParameter("objType");
//                    
//                    if (null==filterValue3)
//                        filterValue3 = buildFromDate(request) + ":" + buildToDate(request);
//                    
//                    try {
//                        servedPage = "/docs/inst_handling/docs_list.jsp";
//                        docsList = instMgr.getDocsInRange(request.getParameter("op"),filterValue3);
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
//                    break;
//                    
//                case 27:
//                    
//                    servedPage = "/docs/inst_handling/latest_trans.jsp";
//                    request.setAttribute("page",servedPage);
//                    request.setAttribute("operation", "GetLastTransaction");
//                    
//                    this.forwardToServedPage(request, response);
//                    break;
//                    
//                    
//                case 28:
//                    
//                    Document latest = null;
//                    servedPage = "/docs/inst_handling/docs_list.jsp";
//                    String instId = null;
//                    Vector oneDoc = new Vector(1);
//                    
//                    String account = request.getParameter("clientName");
//                    if(null!=account) {
//                        instId= instMgr.getLatestForClient(account);
//                    } else {
//                        instId= request.getParameter("filterValue");
//                    }
//                    
//                    System.out.println("doc Id " + instId);
//                    
//                    if(null!=instId) {
//                        latest = (Document)  instMgr.getLatestTransactionDoc(op,instId);
//                        oneDoc.add(latest);
//                        latest.printSelf();
//                        request.setAttribute("data",oneDoc);
//                        request.setAttribute("page",servedPage);
//                        
//                    } else {
//                        servedPage = "/main";
//                    }
//                    
//                    forwardToServedPage(request, response);
//                    
//                    break;
//                    
//                case 29:
//                    
//                    servedPage = "/docs/inst_handling/docs_list.jsp";
//                    request.setAttribute("data",fvtsMgr.buildUserFavorits());
//                    request.setAttribute("page",servedPage);
//                    this.forwardToServedPage(request, response);
//                    break;
//                    
//                case 30:
//                    servedPage = "/docs/explorer/doc_explorer2.jsp";
//                    request.setAttribute("page",servedPage);
//                    this.forwardToServedPage(request, response);
//                    
//                    break;
//                    
//                    
//                case 33:
//                    
//                    instId = request.getParameter("instId");
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
//                    Vector otherImages = diMgr.getOnRefInteg(instId);
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
//                    servedPage = "/docs/inst_handling/image_renderer.jsp";
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
//                    request.setAttribute("instId", instId);
//                    request.setAttribute("imagePath", absPath);
//                    request.setAttribute("page", servedPage);
//                    this.forwardToServedPage(request, response);
//                    break;
//                    
//                case 34:
//                    WebBusinessObject wUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
//                    servedPage = "/docs/inst_handling/docs_list.jsp";
//                    instId = request.getParameter("filterValue");
//                    
//                    if(wUser != null && wUser.getAttribute("groupName").toString().equalsIgnoreCase("administrator")) {
//                        docsList = instMgr.getListOnLIKE(request.getParameter("op"),instId);
//                    } else {
//                        docsList = instMgr.getListOnLIKE("ListSptrUser", instId);
//                    }
//                    
//                    request.setAttribute("data", docsList);
//                    request.setAttribute("filterValue",instId);
//                    request.setAttribute("page",servedPage);
//                    this.forwardToServedPage(request, response);
//                    break;
//                    
//                default:
//                    
//                    break;
//                    
//                case 35:
//                    servedPage = "/docs/search/id_search.jsp";
//                    request.setAttribute("page",servedPage);
//                    request.setAttribute("message", "");
//                    this.forwardToServedPage(request, response);
//                    break;
                    
                case 36:
                    servedPage = "/docs/inst_handling/docs_list.jsp";
                    
                    unitScheduleID =request.getParameter("unitScheduleID");
                    
                    unitScheduleID =  unitScheduleID.replace('^','&');
                    unitScheduleID =  unitScheduleID.replace('$','#');
                    unitScheduleID =  unitScheduleID.replace('*',';');
                    
                    System.out.println("Issue ID is" + unitScheduleID);
                    
                    docsList = instMgr.getListOnLIKE(request.getParameter("op"),unitScheduleID);
                    request.setAttribute("data",docsList);
                    request.setAttribute("unitScheduleID",unitScheduleID);
                    request.setAttribute("page",servedPage);
                    
                    this.forwardToServedPage(request, response);
                    
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
    
    private void handleRequest(HttpServletRequest request,HttpServletResponse response ) {
        
        FileInputStream from = null;  // Stream to read from source
        FileOutputStream to = null;   // Stream to write to destination
        try {
            instId = request.getParameter("instId");
            doc = (Document) instMgr.getOnSingleKey(instId);
            
            
            File source = new File(edatabase + doc.getAttribute("fileName"));
            File dest = new File(userAudioDir);
            
            
            if (dest.isDirectory())
                dest = new File(dest, source.getName());
            
            
            
            from = new FileInputStream(source);  // Create input stream
            to = new FileOutputStream(dest);     // Create output stream
            byte[] buffer = new byte[4096];         // To hold file contents
            int bytes_read;                         // How many bytes in buffer
            
            // Read a chunk of bytes into the buffer, then write them out,
            // looping until we reach the end of the file (when read() returns
            // -1).  Note the combination of assignment and comparison in this
            // while loop.  This is a common I/O programming idiom.
            while((bytes_read = from.read(buffer)) != -1) // Read until EOF
                to.write(buffer, 0, bytes_read);            // write
            
            
            
            
            servedPage = "/docs/inst_handling/audio_renderer.jsp";
            VO.setAttribute("filter",(String) request.getParameter("filter"));
            VO.setAttribute("filterValue",(String) request.getParameter("filterValue"));
            
            IRenderAudioDocument ar = AudioDocRendererFactory.getRenderer(doc.getDocumentType());
            
            request.setAttribute("render", ar);
            request.setAttribute("viewOrigin", VO);
            request.setAttribute("instId", instId);
            request.setAttribute("document", doc);
            request.setAttribute("audioPath", "audio" + "/" + userName + "/" + dest.getName());
            request.setAttribute("page", servedPage);
            this.forwardToServedPage(request, response);
        } catch(IOException ioex) {
            
            ;
            
        } finally {
            if (from != null) try { from.close(); } catch (IOException e) { ; }
            if (to != null) try { to.close(); } catch (IOException e) { ; }
            
            
        }
        
        
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
        
        return 0;
    }
    
    
}