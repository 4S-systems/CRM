/*
 * ConfigurationServlet.java
 *
 * Created on March 19, 2004, 2:41 AM
 */

package com.docviewer.servlets;

import com.tracker.db_access.*;
import com.tracker.business_objects.*;

import javax.servlet.*;
import javax.servlet.http.*;

import java.sql.*;
import java.util.*;
import java.io.*;

import java.awt.image.*;
import com.silkworm.business_objects.*;
import com.docviewer.db_access.ImageMgr;
import com.silkworm.Exceptions.*;

import com.docviewer.business_objects.Document;

import com.silkworm.common.MetaDataMgr;
import com.silkworm.common.BookmarkMgr;
import com.silkworm.db_access.FileMgr;
import com.docviewer.rendering.*;
import com.silkworm.db_access.FavoritesMgr;

import com.docviewer.db_access.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;

/**
 *
 * @author  Yasmeen
 * @version
 */

public class ConfigurationServlet extends ImageHandlerServlet {
    
    /** Initializes the servlet.
     */
    
    String RIPath = null;
    String absPath = null;
    
    String docId = null;
    String filterValue = null;
    String filter = null;
    
    String docType = null;
    
    FileMgr fileMgr = FileMgr.getInstance();
    WebBusinessObject fileDescriptor = null;
    String app = null;
    
    // managers
    InfluenceMgr influenceMgr = InfluenceMgr.getInstance();
    ImageMgr imageMgr = ImageMgr.getInstance();
    DocImgMgr diMgr = DocImgMgr.getInstance();
    ChangeRequestMgr changeRequestMgr = ChangeRequestMgr.getInstance();
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    BookmarkMgr bmMgr = BookmarkMgr.getInstance();
    FavoritesMgr fvtsMgr = FavoritesMgr.getInstance();
    SeparatorMgr sptrMgr = SeparatorMgr.getInstance();
    IssueMgr issueMgr = IssueMgr.getInstance();
    // File docImage = null;
    
    BufferedInputStream gifData = null;
    BufferedImage myImage = null;
    
    Document doc = null;
    WebBusinessObject VO = new WebBusinessObject();
    Vector docsList = null;
    
    String randFileName = null;
    String randome = null;
    WebIssue wIssue = new WebIssue();
    boolean saveStatus = false;
    
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
        HttpSession session = request.getSession();
        
        String op = (String) request.getParameter("op");
        operation = getOpCode(op);
        
        System.out.println("operation is: " + operation);
        
        try {
            switch (operation) {
                case 1:
                    
                    servedPage = "/docs/doc_handling/docs_list.jsp";
                    
                    String docId = (String) request.getParameter("docId");
                    WebBusinessObject doc = imageMgr.getOnSingleKey(docId);
                    String parentSptrID = (String) doc.getAttribute("parentID");
                    doc.printSelf();
                    try {
                        if(imageMgr.checkBaseline(doc,session)) {
                            System.out.println("there's baseline");
                            
                            WebBusinessObject lastBaseline = imageMgr.lastBaselineVersion(doc,session);
                            String lastVersion = (String) lastBaseline.getAttribute("versionNumber");
                            String stringVersion = new String();
                            
                            try{
                                Integer integerVersion = new Integer(lastVersion);
                                int intVersion = integerVersion.intValue();
                                intVersion = intVersion + 1;
                                stringVersion = integerVersion.toString(intVersion);
                                System.out.println("******* " +stringVersion);
                            } catch (NumberFormatException nfex) {
                                System.out.println(nfex.getMessage());
                            }
                            
                            boolean result2 = imageMgr.clearBaseline(doc,session);
                            System.out.println("baseline cleared?"+ result2);
                            if(imageMgr.UpdateSeparator(parentSptrID, stringVersion, session)){
                                System.out.println("Sep version updated ok **********");
                            }
                            else
                                System.out.println("error updating sep version ************");
                            boolean result3 = imageMgr.makeBaseline(doc,stringVersion,session);
                            System.out.println("new baseline added?"+ result3);
                        } else {
                            System.out.println("there's no baseline");
                            boolean result3 = imageMgr.makeBaseline(doc,"1",session);
                            System.out.println("new baseline added? "+ result3);
                        }
                        
                    } catch (NoUserInSessionException nuse) {
                        System.out.println(" " + nuse.getMessage());
                    }
                    request.setAttribute("docObj", doc);
                    request.setAttribute("page",servedPage);
                    String destination = context + "/ImageReaderServlet?op=ListSptr&docType=sptr&docId="+parentSptrID+ "&metaType=cntr&filter=ListSptr&filterValue="+parentSptrID;
                    this.forward(destination, request, response);
                    break;
                    
                case 2:
                    docId = (String) request.getParameter("docId");
                    doc = imageMgr.getOnSingleKey(docId);
                    
                    doc.printSelf();
                    try{
                        if (imageMgr.sepAllBaseline(doc, session)){
                            System.out.println("1st step showing all OK ***");
                            if (imageMgr.allowShowAllBaseline(doc, session)){
                                System.out.println("Show all allowed****");
                            }
                        } else{
                            System.out.println("Show all allowing failed****");
                        }
                    } catch (NoUserInSessionException nuse) {
                        System.out.println(" " + nuse.getMessage());
                    }
                    
                    String folderID = (String) doc.getAttribute("parentID");
                    destination = context + "/AccntItemServlet?op=ListAccntItems&folderID="+folderID;
                    request.setAttribute("folderID",folderID);
                    this.forward(destination, request, response);
                    break;
                case 3:
                    
                    docId = (String) request.getParameter("docId");
                    doc = imageMgr.getOnSingleKey(docId);
                    
                    try{
                        if (imageMgr.showOnlyLastBaseline(doc, session) && imageMgr.sepOnlyLastBaseline(doc, session)){
                            System.out.println("Show last allowed****");
                        } else{
                            System.out.println("Show last allowing failed****");
                        }
                    } catch (NoUserInSessionException nuse) {
                        System.out.println(" " + nuse.getMessage());
                    }
                    
                    folderID = (String) doc.getAttribute("parentID");
                    destination = context + "/AccntItemServlet?op=ListAccntItems&folderID="+folderID;
                    request.setAttribute("folderID",folderID);
                    this.forward(destination, request, response);
                    break;
                    
                case 4:
                    
                    servedPage = "/docs/bus_admin/select_CI_type.jsp";
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 5:
                    
                    String documentType = (String) request.getParameter("publishType");
                    
                    String targetServlet = (String) request.getParameter("targetServlet");
                    try{
                        
                        docsList = imageMgr.publishDocument(documentType,session);
                        
                        if (null!=docsList) {
                            System.out.println("not null*****");
                        } else{
                            System.out.println("null*********");
                        }
                    } catch (NoUserInSessionException nousr){
                        System.out.println("-----"+nousr.getMessage());
                    } catch (Exception ex) {
                        System.out.println("****"+ex.getMessage());
                    }
                    
                    servedPage = "/docs/doc_handling/docs_list.jsp";
                    request.setAttribute("data", docsList);
                    request.setAttribute("page",servedPage);
                    
                    this.forwardToServedPage(request, response);
                    break;
                case 6:
                    
                    String sepId = (String) request.getParameter("docId");
                    String fldrId = (String) request.getParameter("parentID");
                    String sepTitle = (String) request.getParameter("docTitle");
                    servedPage = "/docs/doc_handling/make_influence.jsp";
                    
                    request.setAttribute("page", servedPage);
                    request.setAttribute("sepId", sepId);
                    request.setAttribute("sepTitle", sepTitle);
                    request.setAttribute("fldrId", fldrId);
                    this.forwardToServedPage(request, response);
                    
                    break;
                    
                case 7:
                    
                    sepId = (String) request.getParameter("docId");
                    sepTitle = (String) request.getParameter("docTitle");
                    fldrId = (String) request.getParameter("fldrId");
                    
                    try {
                        saveStatus = influenceMgr.saveObject(request,session);
                        if(saveStatus) {
                            System.out.println("OK ******");
                            request.setAttribute("status", "OK");
                        } else {
                            System.out.println("NOT OK ******");
                            request.setAttribute("status", "Invalid Influenced ID");
                        }
                    } catch(Exception ex) {
                        ;
                    }
                    
                    servedPage = "/docs/doc_handling/make_influence.jsp";
                    request.setAttribute("sepTitle", sepTitle);
                    request.setAttribute("sepId", sepId);
                    request.setAttribute("fldrId", fldrId);
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 8:
                    String docID = request.getParameter("docId");
                    WebBusinessObject wbo = new WebBusinessObject();
                    wbo = null;
                    
                    try {
                        Vector data = influenceMgr.getOnArbitraryKey(docID, "key1");
                        if(null==data) {
                            System.out.println("IS NULLLLLLLLLLLLLLLL");
                        } else{
                            Enumeration e = data.elements();
                            while(e.hasMoreElements()) {
                                wbo = (WebBusinessObject) e.nextElement();
                                wbo.printSelf();
                            }
                        }
                        
                        servedPage = "/docs/bus_admin/traceability_list.jsp";
                        
                        request.setAttribute("docID",docID);
                        request.setAttribute("data", data);
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
                    } catch(SQLException sex) {
                        
                        servedPage = "/docs/exception/database_error.jsp";
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
                    } catch(Exception ex) {
                        servedPage = "/docs/exception/database_error.jsp";
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
                        
                    }
                    break;
                    
                case 9:
                    
                    String influencedId =(String) request.getParameter("influencedId");
                    String influenceId =(String) request.getParameter("influenceId");
                    
                    WebBusinessObject influencedObj = influenceMgr.getOnCompoundKey(influenceId, influencedId);
                    
                    servedPage = "/docs/bus_admin/view_traceability.jsp";
                    
                    if(null!= influencedObj) {
                        request.setAttribute("influenceId", influenceId);
                        request.setAttribute("sepObj", influencedObj);
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request,response);
                    } else{
                        System.out.println("InfluencedObj is null ******* ");
                    }
                    break;
                    
                case 10:
                    
                    break;
                    
                case 11:
                    
                    docID = (String) request.getParameter("docId");
                    
                    servedPage = "/docs/issue/change_request.jsp";
                    request.setAttribute("page",servedPage);
                    request.setAttribute("docID",docID);
                    this.forwardToServedPage(request,response);
                    break;
                    
//                case 12:
//
//                    docID = (String) request.getParameter("docID");
//                    //System.out.print
//                    String requiredChange = (String) request.getParameter("requiredChange");
//                    WebBusinessObject changeRequestObj = null;
//                    changeRequestObj.setAttribute("docID", docID);
//                    changeRequestObj.setAttribute("requiredChange", requiredChange);
//
//                    if( changeRequestMgr.saveObject(changeRequestObj, session)) {
//                        request.setAttribute("Status","OK");
//                        System.out.println("save OK ****");
//                    } else{
//                        request.setAttribute("Status","Failed");
//                        System.out.println("save NOT OK ****");
//                    }
//
//                    servedPage = "/docs/issue/change_request.jsp";
//                    request.setAttribute("page",servedPage);
//                    this.forwardToServedPage(request,response);
//                    break;
                    
                case 12:
                    
                    servedPage = "/docs/issue/new_change_request.jsp";
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request,response);
                    
                    break;
                    
                case 13:
                    
                    System.out.println("in the right case------------------");
                    docID = request.getParameter("docId");
                    wbo = null;
                    
                    try {
                        Vector data = influenceMgr.getOnArbitraryKey(docID, "key1");
                        if(data.size()==0) {
                            System.out.println("vector size "+ data.size());
                            servedPage = "/docs/issue/new_change_request.jsp";
                            System.out.println("EMPTY**************");
                        } else{
                            servedPage = "/docs/bus_admin/affected_docs_list.jsp";
                            request.setAttribute("docID",docID);
                            request.setAttribute("data", data);
                        }
                    } catch(SQLException sex) {
                        
                        servedPage = "/docs/exception/database_error.jsp";
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
                    } catch(Exception ex) {
                        servedPage = "/docs/exception/database_error.jsp";
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
                        
                    }
                    
                    
                    
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request,response);
                    break;
                    
                case 14:
                    
                    refineForm(request);
                    if(issueMgr.saveObject(request, wIssue, session, ""))
                        request.setAttribute("Status","Ok");
                    else
                        request.setAttribute("Status", "No");
                    
                    servedPage = "/docs/issue/new_change_request.jsp";
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    
                    break;
                default:
                    
            }
            
        } catch(Exception e) {
            System.out.println("Configuration servlet exception " + e.getMessage());
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
        if(opName.equalsIgnoreCase("MakeBaseline"))
            return 1;
        if(opName.equalsIgnoreCase("ShowAllBaselines"))
            return 2;
        if(opName.equalsIgnoreCase("ShowLastBaseline"))
            return 3;
        if(opName.equalsIgnoreCase("Publish"))
            return 4;
        if(opName.equalsIgnoreCase("PublishDocument"))
            return 5;
        if(opName.equalsIgnoreCase("AddInfluence"))
            return 6;
        if(opName.equalsIgnoreCase("ConfirmInfluence"))
            return 7;
        if(opName.equalsIgnoreCase("showTraceability"))
            return 8;
        if(opName.equalsIgnoreCase("ViewDetailsTreacability"))
            return 9;
        if(opName.equalsIgnoreCase("openTreacability"))
            return 10;
        if(opName.equalsIgnoreCase("newChangeRequest"))
            return 11;
        if(opName.equalsIgnoreCase("continueChangeRequest"))
            return 12;
        if(opName.equalsIgnoreCase("addChangeRequest"))
            return 13;
        if(opName.equalsIgnoreCase("saveChangeRequest"))
            return 14;
        
        
        return 0;
    }
    
    private void refineForm(HttpServletRequest request) {
        WebBusinessObject wbo = new WebBusinessObject();
        
        wIssue.setFAID((String)request.getParameter("FAName"));
        wIssue.setIssueTitle((String) request.getParameter("issueTitle"));
        wIssue.setAttribute("project_name","none");
        
        wIssue.setIssueID((String)request.getParameter("typeName"));
        wIssue.setUrgencyID((String)request.getParameter("urgencyName"));
        wIssue.setIssueDesc((String)request.getParameter("issueDesc"));
    }
    
}
