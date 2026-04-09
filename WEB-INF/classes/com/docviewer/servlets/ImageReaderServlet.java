/*
 * ImageReaderServlet.java
 *
 * Created on March 19, 2004, 2:41 AM
 */

package com.docviewer.servlets;


import java.net.*;

import javax.servlet.*;
import javax.servlet.http.*;

import java.sql.*;
import javax.sql.*;
import java.util.*;
import java.io.*;

import java.awt.image.*;
import javax.imageio.*;
import java.io.*;
import java.awt.*;
import javax.swing.*;

import com.silkworm.servlets.swBaseServlet;
import com.silkworm.business_objects.*;
import com.docviewer.db_access.ImageMgr;
import com.silkworm.Exceptions.*;

import com.docviewer.servlets.DocViewerFileRenamePolicy;
import com.silkworm.util.*;
import java.util.*;
import com.docviewer.business_objects.Document;

import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.common.BookmarkMgr;
import com.silkworm.db_access.FileMgr;
import com.docviewer.rendering.*;
import com.silkworm.db_access.FavoritesMgr;

import com.docviewer.db_access.*;


/**
 *
 * @author  walid
 * @version
 */

public class ImageReaderServlet extends ImageHandlerServlet {
    
    /** Initializes the servlet.
     */
    //  java.sql.Connection conn = null;
    //  HttpSession session = null;
    //  WebBusinessObject loggedUser = null;
    
    //  ServletContext sc = null;
    // String imageDirPath= null;
    String RIPath = null;
    String absPath = null;
    
    String docId = null;
    String filterValue = null;
    String filter = null;
    
    String docType = null;
    
    FileMgr fileMgr = FileMgr.getInstance();
    WebBusinessObject fileDescriptor = null;
    String app = null;
    
    public String filterName = null;
    public String filterBack = null;
    
    //public String filterValue = null;
     
    public String issueid=null;
    
    // managers
    
    ImageMgr imageMgr = ImageMgr.getInstance();
    DocImgMgr diMgr = DocImgMgr.getInstance();
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    BookmarkMgr bmMgr = BookmarkMgr.getInstance();
    FavoritesMgr fvtsMgr = FavoritesMgr.getInstance();
    
    SeparatorMgr sptrMgr = SeparatorMgr.getInstance();
    // File docImage = null;
    
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
        
        super.processRequest(request,response);
        
        String op = (String) request.getParameter("op");
        operation = getOpCode(op);
        
        System.out.println("operation is: " + operation);
        //        System.out.println("Besmllah");
        //        ArrayList requestAsArray = ServletUtils.getRequestParams(request);
        //        System.out.println("Request Array Size is " + requestAsArray.size());
        //        ServletUtils.printRequest(requestAsArray);
        
        try {
            switch (operation) {
                case 1:
                    
                    servedPage = "/docs/doc_handling/docs_list.jsp";
                    
                    docsList = imageMgr.getDocsList(request.getParameter("op"),"");
                    
                    request.setAttribute("data", docsList);
                    
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 2:
                    
                    docType = request.getParameter("docType");
                    docId = request.getParameter("docId");
                    
                    fileDescriptor = fileMgr.getObjectFromCash(docType);
                    
                    app = (String) fileDescriptor.getAttribute("app");
                    
                    if(docType.equalsIgnoreCase("jpg")) {
                        
                        // check if there are more docs
                        
                        
                        //Vector otherImages = diMgr.getOnRefInteg(docId);
                        //
                        
//                        randome = UniqueIDGen.getNextID();
//                        len = randome.length();
//                        
//                        randFileName = new String("ran" +  randome.substring(5,len) + ".jpeg");
//                        
//                        RIPath = userImageDir + "/" + randFileName;
//                        
//                        absPath = "images/" + userHome + "/" + randFileName;
//                        docImage = new File(RIPath);
//                        
                        servedPage = "/docs/doc_handling/image_renderer.jsp";
                        request.setAttribute("page",servedPage);
//                        docId = request.getParameter("docId");
//                        // get the document - it may have sound --
//                        
//                        Document doc = (Document) imageMgr.getOnSingleKey(docId);
//                        
//                        String audio = (String) doc.getAttribute("sound");
//                        
//                        if(!audio.equalsIgnoreCase("NONE")) {
//                            request.setAttribute("audioPath", getAudioPath(audio));
//                            
//                        }
//                        
//                        VO.setAttribute("filter",(String) request.getParameter("filter"));
//                        VO.setAttribute("filterValue",(String) request.getParameter("filterValue"));
//                        request.setAttribute("viewOrigin", VO);
//                        
//                        // put more images here
//                        //request.setAttribute("moreimages", otherImages);
//                        
//                        BufferedInputStream gifData =
//                                new BufferedInputStream(imageMgr.getImage(docId));
//                        
//                        BufferedImage myImage = ImageIO.read(gifData);
//                        
//                        ImageIO.write(myImage,"jpeg",docImage);
//                        
//                        request.setAttribute("docId", docId);
//                        request.setAttribute("imagePath", absPath);
//                        request.setAttribute("page", servedPage);
//                        this.forwardToServedPage(request, response);
                        
                            randome = UniqueIDGen.getNextID();
                            len = randome.length();
                       
                        randFileName = new String("ran" +  randome.substring(5,len) + ".jpeg");
                    
                    
                    RIPath = userImageDir + "/" + randFileName;
                    
                    
                    absPath = "images/" + userHome + "/" + randFileName;
                    
                    docImage = new File(RIPath);
                    docId = request.getParameter("docId");
                    gifData = new BufferedInputStream(imageMgr.getImage(docId));
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
                                new BufferedInputStream(imageMgr.getImage(docId));
                        
                        // ------------------------
                        
                        ServletOutputStream stream = null;
                        
                        
                        try{
                            
                            stream = response.getOutputStream( );
                            // File pdf = new File(pdfData);
                            
                            //set response headers
                            response.setContentType("application/" + app);
                            
                            response.addHeader("Content-Disposition","attachment; filename="+"req." + docType );
                            
                            //    response.setContentLength( (int) pdfData.length( ) );
                            
                            // FileInputStream input = new FileInputStream(pdf);
                            // buf = new BufferedInputStream(input);
                            int readBytes = 0;
                            
                            //read from the file; write to the ServletOutputStream
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
                    docId = request.getParameter("docId");
                    Document doc = (Document) imageMgr.getOnSingleKey(docId);
                    
                    request.setAttribute("docId", request.getParameter("docId"));
                    request.setAttribute("docTitle", request.getParameter("docTitle"));
                    request.setAttribute("doc",doc);
                    
//                    VO.setAttribute("filter",(String) request.getParameter("filter"));
//                    VO.setAttribute("filterValue",(String) request.getParameter("filterValue"));
                    request.setAttribute("viewOrigin", VO);
                    
                    filterBack = request.getParameter("filterBack");
                    filter = request.getParameter("filter");
                    filterValue = request.getParameter("filterValue");
                    issueid =request.getParameter("issueid");
                    servedPage = "/docs/doc_handling/confirm_deletion.jsp";
                    
                    request.setAttribute("issueid",issueid);
                    request.setAttribute("fName",filter);
                    request.setAttribute("filterBack",filterBack);
                    request.setAttribute("filterValue",filterValue);
                    request.setAttribute("page",servedPage);
                    
                    this.forwardToServedPage(request, response);
                    
                    
                    break;
                    
                case 4:
                  //  BookmarkMgr bookmarkMgr = BookmarkMgr.getInstance();
                    docId = request.getParameter("docId");
                    //bookmarkMgr.deleteRefIntegKey(docId);
                    imageMgr.deleteOnSingleKey(docId);
                    
                    filter = request.getParameter("filterName");
                    filterBack = request.getParameter("filterBack");
                    filterValue = request.getParameter("filterValue");
                    issueid = request.getParameter("issueid");
                    
                    filterValue =  filterValue.replace('^','&');
                    filterValue =  filterValue.replace('$','#');
                    
                    if(filterBack.equalsIgnoreCase("GetLastTransaction")) {
                        servedPage = "/main";
                        this.forwardToServedPage(request, response);
                        break;
                    }
                    
                    servedPage = "/docs/doc_handling/docs_list.jsp";
                    
                    if(filterBack.indexOf("DBSearch") == 0)
                        docsList = imageMgr.getListOnLIKE(filterBack,filterValue);
                    
                    
                    else if (filterBack.indexOf("ListDocsInSpan") == 0)
                        docsList = imageMgr.getDocsInRange(filterBack, filterValue);
                    
                    else if (filterBack.indexOf("ListTitlesLike") == 0)
                        docsList = imageMgr.getListOnLIKE(filterBack, filterValue);
                    
                    else if (filterBack.indexOf("ListAccount") == 0)
                        docsList = imageMgr.getAccountDocsInRange(filterBack,filterValue);
                    
                    else if (filterBack.indexOf("ListSptr") == 0)
                        docsList = imageMgr.getListOnLIKE(filterBack,filterValue);
                    else if (filterBack.indexOf("ListDoc") == 0)
                        docsList = imageMgr.getListOnLIKE(filterBack,issueid);
                    
                    request.setAttribute("issueid",issueid);
                    request.setAttribute("fName",filter);
                    request.setAttribute("filterBack",filterBack);
                    request.setAttribute("fValue",filterValue);
                    request.setAttribute("data", docsList);
                    
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    
                    
                    break;
                case 5:
                  String  projectname = request.getParameter("projectName");
                    servedPage = "/docs/doc_handling/doc_details.jsp";
                    request.setAttribute("page",servedPage);
                    
                    docId = request.getParameter("docId");
                    // ------------------------------------------
                    
                    
                    randome = UniqueIDGen.getNextID();
                    len = randome.length();
                    
                    randFileName = new String("ran" +  randome.substring(5,len) + ".jpeg");
                    
                    
                    RIPath = userImageDir + "/" + randFileName;
                    
                    
                    absPath = "images/" + userHome + "/" + randFileName;
                    
                    docImage = new File(RIPath);
                    docId = request.getParameter("docId");
                    gifData = new BufferedInputStream(imageMgr.getImage(docId));
                    myImage = ImageIO.read(gifData);
                    ImageIO.write(myImage,"jpeg",docImage);
                    request.setAttribute("imagePath", absPath);
                    
                    // --------------------------------------------
                    
                    doc = (Document) imageMgr.getOnSingleKey(docId);
                    // doc.printSelf();
                    
                    VO.setAttribute("filter",(String) request.getParameter("filter"));
                    VO.setAttribute("filterValue",(String) request.getParameter("filterValue"));
                    
                    // doc.setAttribute("filter",(String) request.getParameter("filter"));
                    // doc.setViewOrigin(VO);
                    request.setAttribute("projectName", projectname);
                    request.setAttribute("defDocID",docId);
                    request.setAttribute("docObject", doc);
                    request.setAttribute("viewOrigin", VO);
                    
                    this.forwardToServedPage(request, response);
                    
                    break;
                case 6:
                    
                    servedPage = "/docs/doc_handling/client_interval_search.jsp";
                    String context = op.substring(op.length() - 3);
                    String nextTarget = "ListAccount" + context;
                    request.setAttribute("op", nextTarget);
                    request.setAttribute("ts", "ImageReaderServlet");
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 7:
                    
                    //                    servedPage = "/docs/doc_handling/docs_list.jsp";
                    //                    request.setAttribute("page",servedPage);
                    //
                    //                    String accountId = request.getParameter("filterValue");
                    //
                    //
                    //                    docsList = imageMgr.getListOnSecondKey(accountId);
                    //                    request.setAttribute("data",docsList);
                    //
                    //                    this.forwardToServedPage(request, response);
                    //                    break;
                    
                    
                    String filterValue = request.getParameter("filterValue");
                    
                    if (null==filterValue)
                        filterValue = buildFromDate(request) + ":" + buildToDate(request)+ ">" + request.getParameter("account");
                    
                    try {
                        servedPage = "/docs/doc_handling/docs_list.jsp";
                        docsList = imageMgr.getAccountDocsInRange(request.getParameter("op"),filterValue);
                        
                        request.setAttribute("data", docsList);
                        
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                        
                    } catch(SQLException sqlEx) {
                        System.out.println(sqlEx.getMessage());
                    } catch(Exception e) {
                        System.out.println(e.getMessage());
                    }
                    
                    break;
                    
                case 8:
                    
                    //                    servedPage = "/docs/doc_handling/like_form.jsp";
                    //                    request.setAttribute("page",servedPage);
                    //                    request.setAttribute("operation", "ListByLIKE");
                    //
                    //                    this.forwardToServedPage(request, response);
                    //                    break;
                    
                    servedPage = "/docs/doc_handling/like_form.jsp";
                    request.setAttribute("page",servedPage);
                    
                    String likeContext = op.substring(op.length() - 3);
                    String likeTarget = "ListTitlesLike" + likeContext;
                    
                    
                    
                    request.setAttribute("operation", likeTarget);
                    
                    this.forwardToServedPage(request, response);
                    break;
                    
                    
                case 9:
                    
                    servedPage = "/docs/doc_handling/docs_list.jsp";
                    request.setAttribute("page",servedPage);
                    
                    filterValue = request.getParameter("filterValue");
                    
                    docsList = imageMgr.getListOnLIKE(request.getParameter("op"),filterValue);
                    request.setAttribute("data",docsList);
                    
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 11:
                    
                     projectname = request.getParameter("projectName");
                    docId = request.getParameter("docId");
                    issueid =request.getParameter("issueId");
                    String filter = request.getParameter("filter");
                    filterValue = request.getParameter("filterValue");
                    
                    if (filter==null|| filterValue ==null) {
                        filter=new String("");
                        filterValue=new String("");
                    }
                    doc = (Document) imageMgr.getOnSingleKey(docId);
                    if (null==doc) {
                        servedPage = "/docs/search/id_search.jsp";
                        request.setAttribute("page",servedPage);
                        request.setAttribute("message","nodocument");
                    } else {
                        servedPage = "/docs/doc_handling/doc_details.jsp";
                        request.setAttribute("page",servedPage);
                        VO.setAttribute("filter",filter);
                        VO.setAttribute("filterValue",filterValue);
                        doc.setViewOrigin(VO);
                        
                        request.setAttribute("issueid",issueid);
                        request.setAttribute("defDocID",docId);
                        request.setAttribute("projectName", projectname);
                        request.setAttribute("docObject", doc);
                        request.setAttribute("viewOrigin", VO);
                    }
                    
                    this.forwardToServedPage(request, response);
                    break;
                    
                    
                case 13:
                    
                    docId = request.getParameter("docId");
                    BufferedInputStream xlsData = new BufferedInputStream(imageMgr.getImage(docId));
                    
                    
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
                    
                    docId = request.getParameter("docId");
                    BufferedInputStream htmlData = new BufferedInputStream(imageMgr.getImage(docId));
                    
                    
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
                        
                        docId = request.getParameter("docId");
                        doc = (Document) imageMgr.getOnSingleKey(docId);
                        
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
                            
                            //close the input/output streams
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
                        docId = request.getParameter("docId");
                        doc = (Document) imageMgr.getOnSingleKey(docId);
                        
                        ServletOutputStream movieStream = null;
                        BufferedInputStream buf = null;
                        try{
                            
                            movieStream = response.getOutputStream( );
                            File mp3 = new File(edatabase + doc.getAttribute("fileName"));
                            
                            //set response headers
                            response.setContentType("audio/mpeg");
                            
                            response.addHeader( "Content-Disposition","attachment; filename="+ doc.getAttribute("fileName"));
                            
                            response.setContentLength( (int) mp3.length( ) );
                            
                            FileInputStream input = new FileInputStream(mp3);
                            buf = new BufferedInputStream(input);
                            int readBytes = 0;
                            
                            //read from the file; write to the ServletOutputStream
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
                    
                case 17:
                    
                    servedPage = "/docs/doc_handling/docs_list.jsp";
                    
                    docsList = imageMgr.getDocsList(request.getParameter("op"),"");
                    
                    request.setAttribute("data", docsList);
                    
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 19:
                    
                    servedPage = "/docs/doc_handling/docs_list.jsp";
                    request.setAttribute("page",servedPage);
                    
                    filterValue = request.getParameter("filterValue");
                    
                    filterValue =  filterValue.replace('^','&');
                    filterValue =  filterValue.replace('$','#');
                    filterValue =  filterValue.replace('*',';');
                    
                    
                    
                    
                    System.out.println("Filter Value is" + filterValue);
                    
                    docsList = imageMgr.getListOnLIKE(request.getParameter("op"),filterValue);
                    request.setAttribute("data",docsList);
                    
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 20:
                    docId = request.getParameter("docId");
                    
                    
                    
                    BufferedInputStream emlData =
                            new BufferedInputStream(imageMgr.getImage(docId));
                    
                    
                    ServletOutputStream emlStream = null;
                    
                    
                    try{
                        
                        emlStream = response.getOutputStream( );
                        
                        response.setContentType("application/msimn");
                        
                        response.addHeader("Content-Disposition","attachment; filename="+"req.eml" );
                        
                        
                        int readBytes = 0;
                        
                        
                        while((readBytes = emlData.read( )) != -1)
                            emlStream.write(readBytes);
                        
                    } catch (IOException ioe){
                        
                        throw new ServletException(ioe.getMessage( ));
                        
                    } finally {
                        
                        //close the input/output streams
                        if (emlStream != null)
                            emlStream.close( );
                        if (emlData != null)
                            emlData.close( );
                    }
                    
                    
                    break;
                    
                case 21:
                    
                    servedPage = "/docs/doc_handling/searchdoc_form.jsp";
                    request.setAttribute("page",servedPage);
                    request.setAttribute("operation", "SearchAllDocsBody");
                    
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 22:
                    
                    servedPage = "/docs/doc_handling/docs_list.jsp";
                    request.setAttribute("page",servedPage);
                    
                    filterValue = request.getParameter("filterValue");
                    
                    
                    docsList = imageMgr.getListOnLIKE(request.getParameter("op"),filterValue);
                    request.setAttribute("data",docsList);
                    
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 23:
                    
                    servedPage = "/docs/doc_handling/searchdoc_form.jsp";
                    request.setAttribute("page",servedPage);
                    
                    
                    String BSCContext = op.substring(op.length() - 3);
                    String BSTarget = "DBSearch" + BSCContext;
                    
                    request.setAttribute("operation", BSTarget);
                    
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 24:
                    
                    servedPage = "/docs/doc_handling/docs_list.jsp";
                    request.setAttribute("page",servedPage);
                    
                    filterValue = request.getParameter("filterValue");
                    
                    docsList = imageMgr.getListOnLIKE(request.getParameter("op"),filterValue);
                    request.setAttribute("data",docsList);
                    
                    this.forwardToServedPage(request, response);
                    break;
                    
                    
                    
                case 25:
                    
                    servedPage = "/docs/doc_handling/interval_search.jsp";
                    String context1 = op.substring(op.length() - 3);
                    String nextTarget1 = "ListDocsInSpan" + context1;
                    request.setAttribute("op", nextTarget1);
                    
                    request.setAttribute("page",servedPage);
                    request.setAttribute("operation", nextTarget1);
                    
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 26:
                    
                    // System.out.println("in the right case..... ");
                    //                    System.out.println("To date = " + this.buildToDate(request));
                    String filterValue3 = request.getParameter("filterValue");
                    String objType=request.getParameter("objType");
                    
                    if (null==filterValue3)
                        filterValue3 = buildFromDate(request) + ":" + buildToDate(request);
                    
                    try {
//                        if (objType.equalsIgnoreCase("FLDR_TYPE")) {
//                            servedPage = "/docs/bus_admin/accnt_list.jsp";
//                            request.setAttribute("page",servedPage);
//                            this.forwardToServedPage(request, response);
//                        } else {
                        servedPage = "/docs/doc_handling/docs_list.jsp";
                        docsList = imageMgr.getDocsInRange(request.getParameter("op"),filterValue3);
                        
                        request.setAttribute("data", docsList);
                        
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
//                        }
                        break;
                        
                    } catch(SQLException sqlEx) {
                        System.out.println(sqlEx.getMessage());
                    } catch(Exception e) {
                        System.out.println(e.getMessage());
                    }
                    
                    break;
                    
                case 27:
                    
                    servedPage = "/docs/doc_handling/latest_trans.jsp";
                    request.setAttribute("page",servedPage);
                    request.setAttribute("operation", "GetLastTransaction");
                    
                    this.forwardToServedPage(request, response);
                    break;
                    
                    
                case 28:
                    
                    Document latest = null;
                    servedPage = "/docs/doc_handling/docs_list.jsp";
                    String docId = null;
                    Vector oneDoc = new Vector(1);
                    
                    String account = request.getParameter("clientName");
                    if(null!=account) {
                        docId= imageMgr.getLatestForClient(account);
                    } else {
                        docId= request.getParameter("filterValue");
                    }
                    
                    //    String op = request.getParameter("op");
                    System.out.println("doc Id " + docId);
                    
                    if(null!=docId) {
                        latest = (Document)  imageMgr.getLatestTransactionDoc(op,docId);
                        oneDoc.add(latest);
                        latest.printSelf();
                        request.setAttribute("data",oneDoc);
                        request.setAttribute("page",servedPage);
                        
                    } else {
                        servedPage = "/main";
                    }
                    
                    forwardToServedPage(request, response);
                    
                    break;
                    
                case 29:
                    
                    servedPage = "/docs/doc_handling/docs_list.jsp";
                    request.setAttribute("data",fvtsMgr.buildUserFavorits());
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 30:
                    servedPage = "/docs/explorer/doc_explorer2.jsp";
                    //   Vector vvv = fvtsMgr.buildFavoritsTree();
                    //    System.out.println("SSSSSSSSS " + vvv.size());
                    
                    // Vector sptr = sptrMgr.getListByFileType("FilterOnType","sptr");
                    request.setAttribute("page",servedPage);
                    //        request.setAttribute("data",vvv);
                    this.forwardToServedPage(request, response);
                    
                    break;
                    
                    
                case 33:
                    
                    docId = request.getParameter("docId");
                    String reqImageID = request.getParameter("nextImID");
                    String imRank = request.getParameter("imRank");
                    
                    Integer bigI = new Integer(imRank);
                    int sint = bigI.intValue();
                    sint++;
                    
                    bigI = new Integer(sint);
                    
                    String nextImId = bigI.toString();
                    
                    Vector otherImages = diMgr.getOnRefInteg(docId);
                    
                    randome = UniqueIDGen.getNextID();
                    len = randome.length();
                    
                    randFileName = new String("ran" +  randome.substring(5,len) + ".jpeg");
                    
                    
                    RIPath = userImageDir + "/" + randFileName;
                    
                    absPath = "images/" + userHome + "/" + randFileName;
                    docImage = new File(RIPath);
                    
                    servedPage = "/docs/doc_handling/image_renderer.jsp";
                    
                    VO.setAttribute("filter",(String) request.getParameter("filter"));
                    VO.setAttribute("filterValue",(String) request.getParameter("filterValue"));
                    request.setAttribute("viewOrigin", VO);
                    
                    // put more images here
                    request.setAttribute("moreimages", otherImages);
                    request.setAttribute("imagerank",nextImId);
                    
                    BufferedInputStream gifData =
                            new BufferedInputStream(diMgr.getImage(reqImageID));
                    
                    BufferedImage myImage = ImageIO.read(gifData);
                    
                    
                    
                    ImageIO.write(myImage,"jpeg",docImage);
                    
                    request.setAttribute("docId", docId);
                    request.setAttribute("imagePath", absPath);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 34:
                    WebBusinessObject wUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
                    servedPage = "/docs/doc_handling/docs_list.jsp";
                    docId = request.getParameter("filterValue");
                    
                    if(wUser != null && wUser.getAttribute("groupName").toString().equalsIgnoreCase("administrator")) {
                        docsList = imageMgr.getListOnLIKE(request.getParameter("op"),docId);
                    } else {
                        docsList = imageMgr.getListOnLIKE("ListSptrUser", docId);
                    }
                    
                    request.setAttribute("data", docsList);
                    request.setAttribute("filterValue",docId);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    
                default:
                    
                    break;
                    
                case 35:
                    servedPage = "/docs/search/id_search.jsp";
                    request.setAttribute("page",servedPage);
                    request.setAttribute("message", "");
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 36:
                    
                    
                     projectname = request.getParameter("projectName");
                    filterBack = request.getParameter("filterBack");
                    filterName =request.getParameter("fName");
                    filterValue =request.getParameter("fValue");
                    servedPage = "/docs/doc_handling/docs_list.jsp";
                    
                    issueid =request.getParameter("issueId");
                    
                    issueid =  issueid.replace('^','&');
                    issueid =  issueid.replace('$','#');
                    issueid =  issueid.replace('*',';');
                    
                    System.out.println("Issue ID is" + issueid);
                    
                    docsList = imageMgr.getListOnLIKE(request.getParameter("op"),issueid);
                    request.setAttribute("data",docsList);
                    request.setAttribute("fName",filterName);
                    request.setAttribute("filterBack",filterBack);
                    request.setAttribute("fValue",filterValue);
                    request.setAttribute("issueid",issueid);
                    request.setAttribute("projectName", projectname);
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
            docId = request.getParameter("docId");
            doc = (Document) imageMgr.getOnSingleKey(docId);
            
            
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
            
            
            
            
            servedPage = "/docs/doc_handling/audio_renderer.jsp";
            VO.setAttribute("filter",(String) request.getParameter("filter"));
            VO.setAttribute("filterValue",(String) request.getParameter("filterValue"));
            
            IRenderAudioDocument ar = AudioDocRendererFactory.getRenderer(doc.getDocumentType());
            
            request.setAttribute("render", ar);
            request.setAttribute("viewOrigin", VO);
            request.setAttribute("docId", docId);
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
