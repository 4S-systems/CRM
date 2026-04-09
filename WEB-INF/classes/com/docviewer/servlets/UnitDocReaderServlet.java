package com.docviewer.servlets;

import com.clients.db_access.ClientMgr;
import com.clients.db_access.ClientProductMgr;
import com.contractor.db_access.MaintainableMgr;
import com.crm.common.CRMConstants;
import com.maintenance.common.ParseSideMenu;
import com.maintenance.db_access.EquipmentMaintenanceMgr;
import com.maintenance.db_access.ScheduleMgr;
import com.silkworm.common.MetaDataMgr;
import java.util.ArrayList;
import java.util.Hashtable;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import com.docviewer.business_objects.Document;
import com.docviewer.db_access.DocTypeMgr;
import com.maintenance.common.SenderConfiurationMgr;
import com.maintenance.common.Tools;
import com.maintenance.db_access.IssueDocumentMgr;
import com.maintenance.db_access.SupplementMgr;
import com.maintenance.db_access.UnitDocMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.SecurityUser;
import com.silkworm.db_access.FileMgr;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.tracker.db_access.IssueStatusMgr;
import com.tracker.db_access.ProjectMgr;
import java.awt.image.BufferedImage;
import java.util.List;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.imageio.ImageIO;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class UnitDocReaderServlet extends ImageHandlerServlet {

    String RIPath = null;
    String docID = null;
    String docType = null;
    FileMgr fileMgr = FileMgr.getInstance();
    ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
    WebBusinessObject fileDescriptor = null;
    String app = null;
    public String equipmentID = null;
    UnitDocMgr unitDocMgr = UnitDocMgr.getInstance();
    BufferedInputStream gifData = null;
    BufferedImage myImage = null;
    Document doc = null;
    Vector docsList = null;
    String randFileName = null;
    String randome = null;
    int len = 0;
    ProjectMgr projectMgr = ProjectMgr.getInstance();

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

    }

    @Override
    public void destroy() {
    }

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        super.processRequest(request, response);
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");

        String op = (String) request.getParameter("op");
        operation = getOpCode(op);

        try {
            switch (operation) {
                case 1:
//
//                    servedPage = "/docs/unit_doc_handling/docs_list.jsp";
//
//                    docsList = unitDocMgr.getDocsList(request.getParameter("op"),"");
//
//                    request.setAttribute("data", docsList);
//
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 2:

                    docType = request.getParameter("docType");
                    docID = request.getParameter("docID");

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
                        gifData = new BufferedInputStream(unitDocMgr.getImage(docID));
                        myImage = ImageIO.read(gifData);
                        ImageIO.write(myImage, "jpeg", docImage);
                        request.setAttribute("imagePath", absPath);
//                        this.forwardToServedPage(request, response);
                        this.forward(servedPage, request, response);
                        break;
                    } else {
                        randome = UniqueIDGen.getNextID();
                        len = randome.length();

                        randFileName = new String("ran" + randome.substring(5, len) + docType);

                        RIPath = userImageDir + "/" + randFileName;

                        File PDFDoc = new File(RIPath);

                        BufferedInputStream pdfData
                                = new BufferedInputStream(unitDocMgr.getImage(docID));

                        ServletOutputStream stream = null;
                        try {
                            stream = response.getOutputStream();
                            response.setContentType("application/" + app);
                            response.addHeader("Content-Disposition", "attachment; filename=" + "req." + docType);
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

                case 3:
                    docID = request.getParameter("docID");
                    Document doc = (Document) unitDocMgr.getOnSingleKey(docID);
                    request.setAttribute("docID", request.getParameter("docID"));
                    request.setAttribute("docTitle", request.getParameter("docTitle"));
                    request.setAttribute("doc", doc);
                    equipmentID = request.getParameter("equipmentID");
                    servedPage = "/docs/unit_doc_handling/confirm_deletion.jsp";
                    request.setAttribute("equipmentID", equipmentID);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 4:
                    docID = request.getParameter("docID");
                    unitDocMgr.deleteOnSingleKey(docID);
                    equipmentID = request.getParameter("equipmentID");
                    servedPage = "/docs/unit_doc_handling/docs_list.jsp";

                    equipmentID = equipmentID.replace('^', '&');
                    equipmentID = equipmentID.replace('$', '#');
                    equipmentID = equipmentID.replace('*', ';');

                    docsList = unitDocMgr.getListOnLIKE(request.getParameter("op"), equipmentID);
                    request.setAttribute("data", docsList);
                    request.setAttribute("equipmentID", equipmentID);
                    request.setAttribute("data", docsList);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 5:
//                    String  projectname = request.getParameter("projectName");
//                    servedPage = "/docs/unit_doc_handling/doc_details.jsp";
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
//                    gifData = new BufferedInputStream(unitDocMgr.getImage(docID));
//                    myImage = ImageIO.read(gifData);
//                    ImageIO.write(myImage,"jpeg",docImage);
//                    request.setAttribute("imagePath", absPath);
//
//                    // --------------------------------------------
//
//                    doc = (Document) unitDocMgr.getOnSingleKey(docID);
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

//                    servedPage = "/docs/unit_doc_handling/client_interval_search.jsp";
//                    String context = op.substring(op.length() - 3);
//                    String nextTarget = "ListAccount" + context;
//                    request.setAttribute("op", nextTarget);
//                    request.setAttribute("ts", "ImageReaderServlet");
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 7:
//                    String filterValue = request.getParameter("filterValue");
//
//                    if (null==filterValue)
//                        filterValue = buildFromDate(request) + ":" + buildToDate(request)+ ">" + request.getParameter("account");
//
//                    try {
//                        servedPage = "/docs/unit_doc_handling/docs_list.jsp";
//                        docsList = unitDocMgr.getAccountDocsInRange(request.getParameter("op"),filterValue);
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
//                    servedPage = "/docs/unit_doc_handling/like_form.jsp";
                    request.setAttribute("page", servedPage);
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
//                    servedPage = "/docs/unit_doc_handling/docs_list.jsp";
                    request.setAttribute("page", servedPage);
//
//                    filterValue = request.getParameter("filterValue");
//
//                    docsList = unitDocMgr.getListOnLIKE(request.getParameter("op"),filterValue);
//                    request.setAttribute("data",docsList);
//
                    this.forwardToServedPage(request, response);
                    break;

                case 11:
                    docID = request.getParameter("docID");
                    equipmentID = request.getParameter("equipmentID");

                    doc = (Document) unitDocMgr.getOnSingleKey(docID);
                    if (null == doc) {
                        servedPage = "/docs/search/id_search.jsp";
                        request.setAttribute("page", servedPage);
                        request.setAttribute("message", "nodocument");
                    } else {
                        servedPage = "/docs/unit_doc_handling/doc_details.jsp";
                        randome = UniqueIDGen.getNextID();
                        len = randome.length();

                        randFileName = new String("ran" + randome.substring(5, len) + ".jpeg");
                        RIPath = userImageDir + "/" + randFileName;
                        absPath = "images/" + userHome + "/" + randFileName;
                        docImage = new File(RIPath);
                        docID = request.getParameter("docID");
                        gifData = new BufferedInputStream(unitDocMgr.getImage(docID));
                        myImage = ImageIO.read(gifData);
                        if (myImage != null) {
                            ImageIO.write(myImage, "jpeg", docImage);
                            request.setAttribute("imagePath", absPath);
                        }
                        request.setAttribute("page", servedPage);
                        request.setAttribute("equipmentID", equipmentID);
                        request.setAttribute("defDocID", docID);
                        request.setAttribute("docObject", doc);
                    }

                    this.forwardToServedPage(request, response);
                    break;

                case 13:
//
//                    docID = request.getParameter("docID");
//                    BufferedInputStream xlsData = new BufferedInputStream(unitDocMgr.getImage(docID));
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
//                    BufferedInputStream htmlData = new BufferedInputStream(unitDocMgr.getImage(docID));
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
//                        doc = (Document) unitDocMgr.getOnSingleKey(docID);
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
//                        doc = (Document) unitDocMgr.getOnSingleKey(docID);
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

//                    servedPage = "/docs/unit_doc_handling/docs_list.jsp";
//
//                    docsList = unitDocMgr.getDocsList(request.getParameter("op"),"");
//
//                    request.setAttribute("data", docsList);
//
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 19:

//                    servedPage = "/docs/unit_doc_handling/docs_list.jsp";
                    request.setAttribute("page", servedPage);
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
//                    docsList = unitDocMgr.getListOnLIKE(request.getParameter("op"),filterValue);
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
//                            new BufferedInputStream(unitDocMgr.getImage(docID));
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

//                    servedPage = "/docs/unit_doc_handling/searchdoc_form.jsp";
                    request.setAttribute("page", servedPage);
//                    request.setAttribute("operation", "SearchAllDocsBody");
//
                    this.forwardToServedPage(request, response);
                    break;

                case 22:

//                    servedPage = "/docs/unit_doc_handling/docs_list.jsp";
                    request.setAttribute("page", servedPage);
//
//                    filterValue = request.getParameter("filterValue");
//
//
//                    docsList = unitDocMgr.getListOnLIKE(request.getParameter("op"),filterValue);
//                    request.setAttribute("data",docsList);
//
                    this.forwardToServedPage(request, response);
                    break;

                case 23:

//                    servedPage = "/docs/unit_doc_handling/searchdoc_form.jsp";
                    request.setAttribute("page", servedPage);
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

//                    servedPage = "/docs/unit_doc_handling/docs_list.jsp";
                    request.setAttribute("page", servedPage);
//
//                    filterValue = request.getParameter("filterValue");
//
//                    docsList = unitDocMgr.getListOnLIKE(request.getParameter("op"),filterValue);
//                    request.setAttribute("data",docsList);
//
                    this.forwardToServedPage(request, response);
                    break;

                case 25:
//
//                    servedPage = "/docs/unit_doc_handling/interval_search.jsp";
//                    String context1 = op.substring(op.length() - 3);
//                    String nextTarget1 = "ListDocsInSpan" + context1;
//                    request.setAttribute("op", nextTarget1);
//
                    request.setAttribute("page", servedPage);
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
//                        servedPage = "/docs/unit_doc_handling/docs_list.jsp";
//                        docsList = unitDocMgr.getDocsInRange(request.getParameter("op"),filterValue3);
//
//                        request.setAttribute("data", docsList);
//
                    request.setAttribute("page", servedPage);
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
//                    servedPage = "/docs/unit_doc_handling/latest_trans.jsp";
                    request.setAttribute("page", servedPage);
//                    request.setAttribute("operation", "GetLastTransaction");
//
                    this.forwardToServedPage(request, response);
                    break;

                case 28:
//
//                    Document latest = null;
//                    servedPage = "/docs/unit_doc_handling/docs_list.jsp";
//                    String docID = null;
//                    Vector oneDoc = new Vector(1);
//
//                    String account = request.getParameter("clientName");
//                    if(null!=account) {
//                        docID= unitDocMgr.getLatestForClient(account);
//                    } else {
//                        docID= request.getParameter("filterValue");
//                    }
//
//                    System.out.println("doc Id " + docID);
//
//                    if(null!=docID) {
//                        latest = (Document)  unitDocMgr.getLatestTransactionDoc(op,docID);
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

//                    servedPage = "/docs/unit_doc_handling/docs_list.jsp";
//                    request.setAttribute("data",fvtsMgr.buildUserFavorits());
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 30:
                    servedPage = "/docs/explorer/doc_explorer2.jsp";
                    request.setAttribute("page", servedPage);
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
//                    servedPage = "/docs/unit_doc_handling/image_renderer.jsp";
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
//                    servedPage = "/docs/unit_doc_handling/docs_list.jsp";
//                    docID = request.getParameter("filterValue");
//
//                    if(wUser != null && wUser.getAttribute("groupName").toString().equalsIgnoreCase("administrator")) {
//                        docsList = unitDocMgr.getListOnLIKE(request.getParameter("op"),docID);
//                    } else {
//                        docsList = unitDocMgr.getListOnLIKE("ListSptrUser", docID);
//                    }
//
//                    request.setAttribute("data", docsList);
//                    request.setAttribute("filterValue",docID);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 35:
//                    servedPage = "/docs/search/id_search.jsp";
                    request.setAttribute("page", servedPage);
//                    request.setAttribute("message", "");
                    this.forwardToServedPage(request, response);
                    break;

                case 36:
                    servedPage = "/docs/unit_doc_handling/docs_list.jsp";

                    equipmentID = request.getParameter("equipmentID");

                    equipmentID = equipmentID.replace('^', '&');
                    equipmentID = equipmentID.replace('$', '#');
                    equipmentID = equipmentID.replace('*', ';');
                    docType = request.getParameter("docType");
                    String docId = request.getParameter("docId");
                    if ((docType != null && !docType.equals("")) && (docId != null && !docId.equals(""))) {
                        docsList = unitDocMgr.getUnitDocsByDocType(equipmentID, docType, docId);
                    } else {
                        docsList = unitDocMgr.getListOnLIKE(request.getParameter("op"), equipmentID);
                    }
                    String type = (String) request.getParameter("type");

                    request.setAttribute("data", docsList);
                    request.setAttribute("equipmentID", equipmentID);
                    request.setAttribute("page", servedPage);
                    request.setAttribute("type", type);

                    this.forwardToServedPage(request, response);

                    break;

                case 37:
                    Vector schedulesVec = new Vector();
                    Vector schedulesVecByCategory = new Vector();
                    WebBusinessObject wboCategoryUnit = new WebBusinessObject();
//                    docType = request.getParameter("docType");
//                    docID = request.getParameter("docID");
//
//                    fileDescriptor = fileMgr.getObjectFromCash(docType);
//
//                    app = (String) fileDescriptor.getAttribute("app");
//
                    EquipmentMaintenanceMgr equipmentMaintenanceMgr = EquipmentMaintenanceMgr.getInstance();
                    Vector vecIssues = equipmentMaintenanceMgr.getFutureMaintenace(request.getParameter("equipmentID"));
                    request.setAttribute("vecIssuesFuture", vecIssues);
                    equipmentMaintenanceMgr = EquipmentMaintenanceMgr.getInstance();
                    vecIssues = equipmentMaintenanceMgr.getLastMaintenace(request.getParameter("equipmentID"));
                    request.setAttribute("vecIssuesLast", vecIssues);
                    //begin
                    equipmentID = request.getParameter("equipmentID");

                    equipmentID = equipmentID.replace('^', '&');
                    equipmentID = equipmentID.replace('$', '#');
                    equipmentID = equipmentID.replace('*', ';');

                    docsList = unitDocMgr.getListOnLIKE("ListDoc", equipmentID);
                    request.setAttribute("data", docsList);
                    schedulesVec = scheduleMgr.getOnArbitraryDoubleKey(request.getParameter("equipmentID"), "key2", "Eqp", "key5");
                    request.setAttribute("equipSchedules", schedulesVec);
                    wboCategoryUnit = maintainableMgr.getOnSingleKey(request.getParameter("equipmentID").toString());
                    schedulesVecByCategory = scheduleMgr.getOnArbitraryDoubleKey(wboCategoryUnit.getAttribute("parentId").toString(), "key2", "Cat", "key5");
                    request.setAttribute("schedulesVecByCategory", schedulesVecByCategory);
                    //end

                    ClientMgr clientMgr = ClientMgr.getInstance();
                    ArrayList listOfClients = clientMgr.getClientName(equipmentID);

                    /**
                     * ****Create Dynamic contenet of Issue menu ******
                     */
                    //open Jar File
                    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
                    metaMgr.setMetaData("xfile.jar");
                    ParseSideMenu parseSideMenu = new ParseSideMenu();
                    Vector eqpMenu = new Vector();
                    String mode = (String) request.getSession().getAttribute("currentMode");
                    eqpMenu = parseSideMenu.parseSideMenu(mode, "equipment_menu.xml", "");

                    metaMgr.closeDataSource();

                    /* Add ids for links*/
                    Vector linkVec = new Vector();
                    String link = "";

                    Hashtable style = new Hashtable();
                    style = (Hashtable) eqpMenu.get(0);
                    String title = style.get("title").toString();
                    title += "<br>" + wboCategoryUnit.getAttribute("unitName").toString();
                    style.remove("title");
                    style.put("title", title);

                    for (int i = 1; i < eqpMenu.size() - 1; i++) {
                        linkVec = new Vector();
                        link = "";
                        linkVec = (Vector) eqpMenu.get(i);
                        link = (String) linkVec.get(1);

                        link += wboCategoryUnit.getAttribute("id").toString();

                        linkVec.remove(1);
                        linkVec.add(link);
                    }

                    Hashtable topMenu = new Hashtable();
                    Vector tempVec = new Vector();
                    topMenu = (Hashtable) request.getSession().getAttribute("topMenu");

                    if (topMenu != null && topMenu.size() > 0) {

                        /* 1- Get the current Side menu
                         * 2- Check Menu Type
                         * 3- insert menu object to top menu accordding to it's type
                         */
                        Vector menuType = new Vector();
                        Vector currentSideMenu = (Vector) request.getSession().getAttribute("sideMenuVec");
                        if (currentSideMenu != null && currentSideMenu.size() > 0) {
                            linkVec = new Vector();

                            // the element # 1 in menu is to view the object
                            linkVec = (Vector) currentSideMenu.get(1);

                            // size-1 becouse the menu type is the last element in vector
                            menuType = (Vector) currentSideMenu.get(currentSideMenu.size() - 1);

                            if (menuType != null && menuType.size() > 0) {
                                topMenu.put((String) menuType.get(1), linkVec);
                            }

                        }

                        request.getSession().setAttribute("topMenu", topMenu);
                    }

                    request.getSession().setAttribute("sideMenuVec", eqpMenu);
                    /*End of Menu*/

                    /**
                     * *************************************************
                     */
                    unitDocMgr = unitDocMgr.getInstance();
                    Vector imageList = unitDocMgr.getImagesList(request.getParameter("equipmentID"));
                    Vector imagesPath = new Vector();
                    String single = request.getParameter("single");
                    if (single != null) {
                        servedPage = "/docs/unit_doc_handling/view_images1.jsp";
                    } else {
                        servedPage = "/docs/unit_doc_handling/view_images.jsp";
                    }
                    request.setAttribute("page", servedPage);
                    for (int i = 0; i < imageList.size(); i++) {
                        randome = UniqueIDGen.getNextID();
                        len = randome.length();
                        docID = ((WebBusinessObject) imageList.get(i)).getAttribute("docID").toString();
                        randFileName = new String("ran" + randome.substring(5, len) + ".jpeg");
                        RIPath = userImageDir + "/" + randFileName;

                        absPath = "images/" + userHome + "/" + randFileName;

                        docImage = new File(RIPath);

                        gifData = new BufferedInputStream(unitDocMgr.getImage(docID));
                        myImage = ImageIO.read(gifData);
                        ImageIO.write(myImage, "jpeg", docImage);
                        imagesPath.add(absPath);
                    }
                    SupplementMgr supplementMgr = SupplementMgr.getInstance();
                    Vector vecSupplement = supplementMgr.getOnArbitraryKey(request.getParameter("equipmentID"), "key1");
                    String sAttachedEquipmentID = new String("");
                    if (vecSupplement.size() > 0) {
                        WebBusinessObject wboTemp = (WebBusinessObject) vecSupplement.get(0);
                        sAttachedEquipmentID = (String) wboTemp.getAttribute("supplementEqpID");
                        request.setAttribute("sAttachedEquipmentID", sAttachedEquipmentID);
                    }

                    request.setAttribute("equipID", request.getParameter("equipmentID"));
                    request.setAttribute("imagePath", imagesPath);
                    request.setAttribute("clientName", listOfClients);
                    if (single != null) {
                        request.setAttribute("imageshow", single);
                        this.forward(servedPage, request, response);
                    } else {
                        this.forwardToServedPage(request, response);
                    }

                    break;

                case 38:
//                    Vector eqpSchedules = new Vector();
//                    Vector schedVec = new Vector();
//                    WebBusinessObject eqpWbo = null;
//                    
//                    String source = request.getParameter("source");
//                    String equipment = request.getParameter("equipment");
//                    String equipmentName = null;
//                    
//                    ArrayList equipmentsList = new ArrayList();
//                    MaintainableMgr maintainableMgr =  MaintainableMgr.getInstance();
//                    try{
//                        if(equipment == null){
//                            eqpWbo = (WebBusinessObject) equipmentsList.get(0);
//                        } else {
//                            eqpWbo = maintainableMgr.getOnSingleKey(equipment);
//                        }
//                        
//                        ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
//                        UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
//                        scheduleMgr.cashData();
//                        schedVec =  scheduleMgr.getCashedTable();
//                        
//                        if(schedVec.size() > 0){
//                            for(int i=0; i<schedVec.size(); i++){
//                                WebBusinessObject wbo = new WebBusinessObject();
//                                WebBusinessObject schedWbo = (WebBusinessObject) schedVec.elementAt(i);
//                                
//                                Vector eqpSched = new Vector();
//                                eqpSched = unitScheduleMgr.getOnArbitraryDoubleKey(eqpWbo.getAttribute("id").toString(),"key1", schedWbo.getAttribute("periodicID").toString(), "key2");
//                                
//                                if(eqpSched.size() > 0){
//                                    WebBusinessObject usFirstWbo = (WebBusinessObject) eqpSched.elementAt(0);
//                                    WebBusinessObject usLastWbo = (WebBusinessObject) eqpSched.elementAt(eqpSched.size()-1);
//                                    WebBusinessObject scheduleWbo = scheduleMgr.getOnSingleKey((String) usFirstWbo.getAttribute("periodicId"));
//                                    if(scheduleWbo.getAttribute("scheduleType").toString().equalsIgnoreCase("0")){
//                                        wbo.setAttribute("typeName", "Emergency");
//                                    }
//                                    if(scheduleWbo.getAttribute("scheduleType").toString().equalsIgnoreCase("1")){
//                                        wbo.setAttribute("typeName", "Time Base");
//                                    }
//                                    if(scheduleWbo.getAttribute("scheduleType").toString().equalsIgnoreCase("2")){
//                                        wbo.setAttribute("typeName", "Hour Base");
//                                    }
//                                    if(scheduleWbo.getAttribute("scheduleType").toString().equalsIgnoreCase("3")){
//                                        wbo.setAttribute("typeName", "External");
//                                    }
//                                    wbo.setAttribute("periodicId", usFirstWbo.getAttribute("periodicId").toString());
//                                    wbo.setAttribute("maintenanceTitle", usFirstWbo.getAttribute("maintenanceTitle").toString());
//                                    wbo.setAttribute("beginDate", usFirstWbo.getAttribute("beginDate").toString());
//                                    wbo.setAttribute("endDate", usLastWbo.getAttribute("endDate").toString());
//                                    wbo.setAttribute("isConfigured", usFirstWbo.getAttribute("isConfigured").toString());
//                                    
//                                    eqpSchedules.addElement(wbo);
//                                }
//                                
//                            }
//                        }
//                        
//                        equipmentName = eqpWbo.getAttribute("unitName").toString();
//                    } catch(SQLException sqlEx){
//                        System.out.println("Get Equipment Schedules SQL Exception "+sqlEx.getMessage());
//                    } catch(Exception ex){
//                        System.out.println("Get Equipment Schedules General Exception "+ex.getMessage());
//                    }
//                    
//                    ExcelCreator excelCreator = new ExcelCreator();
//                    String[] header= {"Task Name","Task Type","Task Begin Date","Task End Date","Is Configured"};
//                    String[] attribute = {"maintenanceTitle","typeName","beginDate","endDate","isConfigured"};
//                    String[] dataType = {"String","String","String","String","String"};
//                    
//                    HSSFWorkbook workBook = excelCreator.createExcelFile(header, attribute, dataType, eqpSchedules, 0);
//                    
//                    
//                    response.setHeader("Content-Disposition",
//                            "attachment; filename=\""+"Equipment_Tasks .xls");
//                    
//                    workBook.write(response.getOutputStream());
//                    
//                    response.getOutputStream().flush();
//                    response.getOutputStream().close();
//                    break;

                case 39:
                    schedulesVec = new Vector();
                    schedulesVecByCategory = new Vector();
                    wboCategoryUnit = new WebBusinessObject();
//                    docType = request.getParameter("docType");
//                    docID = request.getParameter("docID");
//
//                    fileDescriptor = fileMgr.getObjectFromCash(docType);
//
//                    app = (String) fileDescriptor.getAttribute("app");
//
                    equipmentMaintenanceMgr = EquipmentMaintenanceMgr.getInstance();
                    vecIssues = equipmentMaintenanceMgr.getFutureMaintenace(request.getParameter("equipmentID"));
                    request.setAttribute("vecIssuesFuture", vecIssues);
                    equipmentMaintenanceMgr = EquipmentMaintenanceMgr.getInstance();
                    vecIssues = equipmentMaintenanceMgr.getLastMaintenace(request.getParameter("equipmentID"));
                    request.setAttribute("vecIssuesLast", vecIssues);
                    //begin
                    equipmentID = request.getParameter("equipmentID");

                    equipmentID = equipmentID.replace('^', '&');
                    equipmentID = equipmentID.replace('$', '#');
                    equipmentID = equipmentID.replace('*', ';');

                    docsList = unitDocMgr.getListOnLIKE("ListDoc", equipmentID);
                    request.setAttribute("data", docsList);
                    schedulesVec = scheduleMgr.getOnArbitraryDoubleKey(request.getParameter("equipmentID"), "key2", "Eqp", "key5");
                    request.setAttribute("equipSchedules", schedulesVec);
                    maintainableMgr = MaintainableMgr.getInstance();
                    wboCategoryUnit = maintainableMgr.getOnSingleKey(request.getParameter("equipmentID").toString());
                    schedulesVecByCategory = scheduleMgr.getOnArbitraryDoubleKey(wboCategoryUnit.getAttribute("parentId").toString(), "key2", "Cat", "key5");
                    request.setAttribute("schedulesVecByCategory", schedulesVecByCategory);
                    //end

                    unitDocMgr = unitDocMgr.getInstance();
                    imageList = unitDocMgr.getImagesList(request.getParameter("equipmentID"));
                    imagesPath = new Vector();

                    servedPage = "/docs/unit_doc_handling/view_simple_Equipment.jsp";
                    request.setAttribute("page", servedPage);
                    for (int i = 0; i < imageList.size(); i++) {
                        randome = UniqueIDGen.getNextID();
                        len = randome.length();
                        docID = ((WebBusinessObject) imageList.get(i)).getAttribute("docID").toString();
                        randFileName = new String("ran" + randome.substring(5, len) + ".jpeg");

                        RIPath = userImageDir + "/" + randFileName;

                        absPath = "images/" + userHome + "/" + randFileName;

                        docImage = new File(RIPath);

                        gifData = new BufferedInputStream(unitDocMgr.getImage(docID));
                        myImage = ImageIO.read(gifData);
                        ImageIO.write(myImage, "jpeg", docImage);
                        imagesPath.add(absPath);
                    }
                    supplementMgr = SupplementMgr.getInstance();
                    vecSupplement = supplementMgr.getOnArbitraryKey(request.getParameter("equipmentID"), "key1");
                    sAttachedEquipmentID = new String("");
                    if (vecSupplement.size() > 0) {
                        WebBusinessObject wboTemp = (WebBusinessObject) vecSupplement.get(0);
                        sAttachedEquipmentID = (String) wboTemp.getAttribute("supplementEqpID");
                        request.setAttribute("sAttachedEquipmentID", sAttachedEquipmentID);
                    }

                    request.setAttribute("equipID", request.getParameter("equipmentID"));
                    request.setAttribute("imagePath", imagesPath);
                    this.forwardToServedPage(request, response);

                    break;

                case 40:
                    String projectId = request.getParameter("projectId");
                    servedPage = "/docs/Adminstration/view_unit_images.jsp";
                    equipmentID = request.getParameter("equipmentID");
                    unitDocMgr = unitDocMgr.getInstance();
                    imageList = unitDocMgr.getImagesList(request.getParameter("projectId"));
                    imagesPath = new Vector();

                    for (int i = 0; i < imageList.size(); i++) {
                        randome = UniqueIDGen.getNextID();
                        len = randome.length();
                        docID = ((WebBusinessObject) imageList.get(i)).getAttribute("docID").toString();
                        randFileName = new String("ran" + randome.substring(5, len) + ".jpeg");

                        RIPath = userImageDir + "/" + randFileName;

                        absPath = "images/" + userHome + "/" + randFileName;

                        docImage = new File(RIPath);

                        gifData = new BufferedInputStream(unitDocMgr.getImage(docID));
                        myImage = ImageIO.read(gifData);
                        ImageIO.write(myImage, "jpeg", docImage);
                        imagesPath.add(absPath);
                    }

                    request.setAttribute("equipmentID", projectId);
                    request.setAttribute("imagePath", imagesPath);
                    request.setAttribute("page", servedPage);
                    this.forward(servedPage, request, response);
//                    this.forwardToServedPage(request, response);
                    break;

                case 41:
                    servedPage = "/docs/unit_doc_handling/attached_docs_list.jsp";

                    String projId = request.getParameter("projId");

                    projId = projId.replace('^', '&');
                    projId = projId.replace('$', '#');
                    projId = projId.replace('*', ';');

                    docsList = unitDocMgr.getListOnLIKE(request.getParameter("op"), projId);
                    type = (String) request.getParameter("type");

                    WebBusinessObject projectWbo = projectMgr.getOnSingleKey(request.getParameter("projId"));
                    if (projectWbo != null) {
                        request.setAttribute("projectName", projectWbo.getAttribute("projectName"));
                    }
                    request.setAttribute("data", docsList);
                    request.setAttribute("projId", projId);
                    request.setAttribute("page", servedPage);
                    request.setAttribute("type", type);

                    this.forward(servedPage, request, response);

                    break;

                case 42:
                    docID = request.getParameter("docID");
                    projId = request.getParameter("projId");

                    doc = (Document) unitDocMgr.getOnSingleKey(docID);
                    if (null == doc) {
                        servedPage = "/docs/search/id_search.jsp";
                        request.setAttribute("page", servedPage);
                        request.setAttribute("message", "nodocument");
                    } else {
                        servedPage = "/docs/unit_doc_handling/attach_doc_details.jsp";
                        randome = UniqueIDGen.getNextID();
                        len = randome.length();

                        randFileName = new String("ran" + randome.substring(5, len) + ".jpeg");
                        RIPath = userImageDir + "/" + randFileName;
                        absPath = "images/" + userHome + "/" + randFileName;
                        docImage = new File(RIPath);
                        docID = request.getParameter("docID");
                        gifData = new BufferedInputStream(unitDocMgr.getImage(docID));
                        myImage = ImageIO.read(gifData);
                        if (myImage != null) {
                            ImageIO.write(myImage, "jpeg", docImage);
                            request.setAttribute("imagePath", absPath);
                        }
                        request.setAttribute("page", servedPage);
                        request.setAttribute("projId", projId);
                        request.setAttribute("defDocID", docID);
                        request.setAttribute("docObject", doc);
                    }

                    this.forward(servedPage, request, response);
                    break;

                case 43:
                    docID = request.getParameter("docID");
                    doc = (Document) unitDocMgr.getOnSingleKey(docID);
                    request.setAttribute("docID", request.getParameter("docID"));
                    request.setAttribute("docTitle", request.getParameter("docTitle"));
                    request.setAttribute("doc", doc);
                    projId = request.getParameter("projId");
                    servedPage = "/docs/unit_doc_handling/confirm_deletion_attached.jsp";
                    request.setAttribute("projId", projId);
                    request.setAttribute("page", servedPage);
                    this.forward(servedPage, request, response);
                    break;

                case 44:
                    docID = request.getParameter("docID");
                    unitDocMgr.deleteOnSingleKey(docID);
                    projId = request.getParameter("projId");
                    servedPage = "/docs/unit_doc_handling/attached_docs_list.jsp";

                    projId = projId.replace('^', '&');
                    projId = projId.replace('$', '#');
                    projId = projId.replace('*', ';');

                    docsList = unitDocMgr.getListOnLIKE(request.getParameter("op"), projId);
                    request.setAttribute("data", docsList);
                    request.setAttribute("projId", projId);
                    request.setAttribute("data", docsList);
                    request.setAttribute("page", servedPage);
                    this.forward(servedPage, request, response);
                    break;
                case 45:
                    PrintWriter out = response.getWriter();
                    WebBusinessObject wbo = new WebBusinessObject();

                    docID = request.getParameter("selectedId");

                    docID = docID.substring(0, docID.length() - 1);
                    unitDocMgr = unitDocMgr.getInstance();
                    if (unitDocMgr.deleteSelectedFile(docID)) {
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "error");
                    }

                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                case 46:
                    out = response.getWriter();
                    wbo = new WebBusinessObject();

                    docID = request.getParameter("docId");
                    unitDocMgr = unitDocMgr.getInstance();
                    if (unitDocMgr.deleteOnSingleKey(docID)) {
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "error");
                    }

                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                case 47:
                    out = response.getWriter();
                    wbo = new WebBusinessObject();

                    docID = request.getParameter("docId");
                    String mainProjectId = request.getParameter("mainProjectId");
                    unitDocMgr = unitDocMgr.getInstance();
                    if (unitDocMgr.updateDocumentParent(docID, mainProjectId)) {
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "error");
                    }

                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                case 48:
                    out = response.getWriter();
                    wbo = new WebBusinessObject();

                    String docsId = request.getParameter("docId");
                    mainProjectId = request.getParameter("mainProjectId");
                    docsId = docsId.substring(0, docsId.length() - 1);
                    unitDocMgr = unitDocMgr.getInstance();
                    if (unitDocMgr.updateSelectedFile(docsId, mainProjectId)) {
                        wbo.setAttribute("status", "ok");
                    } else {
                        wbo.setAttribute("status", "error");
                    }

                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                case 49:

                    docType = request.getParameter("docType");
                    docID = request.getParameter("docID");

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
                        gifData = new BufferedInputStream(unitDocMgr.getImage(docID));
                        myImage = ImageIO.read(gifData);
                        ImageIO.write(myImage, "jpeg", docImage);
                        wbo = new WebBusinessObject();
                        out = response.getWriter();
                        wbo.setAttribute("status", "ok");
                        wbo.setAttribute("imagePath", absPath);
                        out.write(Tools.getJSONObjectAsString(wbo));

                        break;
                    } else {
                        String docName = request.getParameter("docName");
                        randome = UniqueIDGen.getNextID();
                        len = randome.length();

                        randFileName = new String("ran" + randome.substring(5, len) + docType);

                        RIPath = userImageDir + "/" + randFileName;

                        File PDFDoc = new File(RIPath);

                        BufferedInputStream pdfData
                                = new BufferedInputStream(unitDocMgr.getImage(docID));

                        ServletOutputStream stream = null;
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
                case 50:
                    servedPage = "/docs/units/view_unit_images.jsp";
                    unitDocMgr = unitDocMgr.getInstance();
                    // For unit images
                    imageList = unitDocMgr.getImagesList(request.getParameter("unitID"));
                    imagesPath = new Vector();
                    ArrayList<String> imageWidth = new ArrayList<String>();
                    ArrayList<String> imageHeight = new ArrayList<String>();
                    int tempWidth,
                     tempHeight;
                    // For email
                    SenderConfiurationMgr mailConfigurationMgr = SenderConfiurationMgr.getCurrentInstance();
                    request.setAttribute("emailTitle", mailConfigurationMgr.getTitleSendImage());
                    request.setAttribute("emailBody", mailConfigurationMgr.getBodySendImage());
                    //
                    for (int i = 0; i < imageList.size(); i++) {
                        randome = UniqueIDGen.getNextID();
                        len = randome.length();
                        docID = ((WebBusinessObject) imageList.get(i)).getAttribute("docID").toString();
                        randFileName = new String("ran" + randome.substring(5, len) + ".jpeg");

                        RIPath = userImageDir + "/" + randFileName;

                        absPath = "images/" + userHome + "/" + randFileName;

                        docImage = new File(RIPath);

                        gifData = new BufferedInputStream(unitDocMgr.getImage(docID));
                        myImage = ImageIO.read(gifData);
                        tempWidth = myImage.getWidth(null);
                        tempHeight = myImage.getHeight(null);
                        tempHeight = (750 * tempHeight) / tempWidth;
                        tempWidth = 750;
                        if (tempHeight > 1000) {
                            tempWidth = (1000 * tempWidth) / tempHeight;
                            tempHeight = 1000;
                        }
                        imageWidth.add(tempWidth + "px");
                        imageHeight.add(tempHeight + "px");
                        ImageIO.write(myImage, "jpeg", docImage);
                        imagesPath.add(absPath);
                    }
                    // For model images
                    imageList = unitDocMgr.getImagesList(request.getParameter("modelID"));
                    for (int i = 0; i < imageList.size(); i++) {
                        randome = UniqueIDGen.getNextID();
                        len = randome.length();
                        docID = ((WebBusinessObject) imageList.get(i)).getAttribute("docID").toString();
                        randFileName = new String("ran" + randome.substring(5, len) + ".jpeg");

                        RIPath = userImageDir + "/" + randFileName;

                        absPath = "images/" + userHome + "/" + randFileName;

                        docImage = new File(RIPath);

                        gifData = new BufferedInputStream(unitDocMgr.getImage(docID));
                        myImage = ImageIO.read(gifData);
                        tempWidth = myImage.getWidth(null);
                        tempHeight = myImage.getHeight(null);
                        tempHeight = (750 * tempHeight) / tempWidth;
                        tempWidth = 750;
                        if (tempHeight > 1000) {
                            tempWidth = (1000 * tempWidth) / tempHeight;
                            tempHeight = 1000;
                        }
                        imageWidth.add(tempWidth + "px");
                        imageHeight.add(tempHeight + "px");
                        ImageIO.write(myImage, "jpeg", docImage);
                        imagesPath.add(absPath);
                    }
                    projectMgr = ProjectMgr.getInstance();
                    projectWbo = projectMgr.getOnSingleKey(request.getParameter("unitID"));
                    if (projectWbo != null) {
                        request.setAttribute("projectName", projectWbo.getAttribute("projectName"));
                    }
                    request.setAttribute("imagePath", imagesPath);
                    request.setAttribute("imageWidth", imageWidth);
                    request.setAttribute("imageHeight", imageHeight);
                    request.setAttribute("page", servedPage);
                    this.forward(servedPage, request, response);
                    break;
                case 51:
                    String projectID = request.getParameter("projectId");
                    projectMgr = ProjectMgr.getInstance();
                    projectWbo = projectMgr.getOnSingleKey(projectID);
                    unitDocMgr = UnitDocMgr.getInstance();
                    ArrayList<WebBusinessObject> imagesList = unitDocMgr.getLogosWithProjectID((String) projectWbo.getAttribute("mainProjId"));
                    if (!imagesList.isEmpty()) {
                        String random = UniqueIDGen.getNextID();
                        len = random.length();

                        randFileName = "ran" + random.substring(5, len) + ".jpeg";

                        RIPath = userImageDir + "/" + randFileName;

                        absPath = "images/" + userHome + "/" + randFileName;

                        docImage = new File(RIPath);
                        docID = request.getParameter("docID");
                        gifData = new BufferedInputStream(unitDocMgr.getImage((String) imagesList.get(0).getAttribute("docID")));
                        myImage = ImageIO.read(gifData);
                        ImageIO.write(myImage, "jpeg", docImage);
                        request.setAttribute("imagePath", absPath);
                    }
                    String clientCode = request.getParameter("clientCode");
                    projectMgr = ProjectMgr.getInstance();
                    wbo = new WebBusinessObject();
                    ArrayList<WebBusinessObject> arrayOfItem = projectMgr.getReservedUnitsByUnitCodeAndClientCode(projectID, clientCode);
                    wbo.setAttribute("clientName", arrayOfItem.get(0).getAttribute("clientName"));
                    wbo.setAttribute("clientAddress", arrayOfItem.get(0).getAttribute("address") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("address"));
                    wbo.setAttribute("clientJob", arrayOfItem.get(0).getAttribute("job") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("job"));
                    wbo.setAttribute("clientEmail", arrayOfItem.get(0).getAttribute("email") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("email"));
                    wbo.setAttribute("clientPhone", arrayOfItem.get(0).getAttribute("mobile") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("mobile"));
                    wbo.setAttribute("clientPhone2", arrayOfItem.get(0).getAttribute("phone") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("phone"));
                    wbo.setAttribute("clientNationalID", arrayOfItem.get(0).getAttribute("nationalID") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("nationalID"));
                    wbo.setAttribute("clientNO", arrayOfItem.get(0).getAttribute("unitCode") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("unitCode"));
                    wbo.setAttribute("downPayment", arrayOfItem.get(0).getAttribute("budget") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("budget"));
                    wbo.setAttribute("period", arrayOfItem.get(0).getAttribute("period") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("period"));
                    wbo.setAttribute("projectName", arrayOfItem.get(0).getAttribute("projectName") == null ? "لا يوجد" : arrayOfItem.get(0).getAttribute("projectName"));
                    wbo.setAttribute("unitValue", arrayOfItem.get(0).getAttribute("unitValue") == null ? "" : arrayOfItem.get(0).getAttribute("unitValue"));
                    wbo.setAttribute("reservationValue", arrayOfItem.get(0).getAttribute("reservationValue") == null ? "" : arrayOfItem.get(0).getAttribute("reservationValue"));
                    wbo.setAttribute("contractValue", arrayOfItem.get(0).getAttribute("contractValue") == null ? "" : arrayOfItem.get(0).getAttribute("contractValue"));
                    wbo.setAttribute("plotArea", arrayOfItem.get(0).getAttribute("plotArea") == null ? "" : arrayOfItem.get(0).getAttribute("plotArea"));
                    wbo.setAttribute("buildingArea", arrayOfItem.get(0).getAttribute("buildingArea") == null ? "" : arrayOfItem.get(0).getAttribute("buildingArea"));
                    wbo.setAttribute("paymentSystem", arrayOfItem.get(0).getAttribute("paymentSystem") == null ? "" : arrayOfItem.get(0).getAttribute("paymentSystem"));
                    wbo.setAttribute("beforeDiscount", arrayOfItem.get(0).getAttribute("beforeDiscount") == null ? "" : arrayOfItem.get(0).getAttribute("beforeDiscount"));
                    String[] isBuildingOrVila = ((String) wbo.getAttribute("clientNO")).split("-");
                    String buildingNumber,
                     unitNumber;
                    if (isBuildingOrVila.length > 1) {
                        buildingNumber = isBuildingOrVila[3];
                        unitNumber = isBuildingOrVila[4];
                    } else {
                        String number = isBuildingOrVila[0].substring(isBuildingOrVila[0].length() - 4, isBuildingOrVila[0].length());
                        unitNumber = number.substring(0, 2);
                        buildingNumber = number.substring(2, 4);
                    }
                    wbo.setAttribute("buildingNumber", buildingNumber);
                    wbo.setAttribute("unitNumber", unitNumber);
                    request.setAttribute("reservationWbo", wbo);
                    servedPage = "/docs/units/reservation_form.jsp";
                    this.forward(servedPage, request, response);
                    break;

                case 52:
                    servedPage = "/docs/units/units_tree.jsp";
                    randFileName = securityUser.getUserName() + "_tree" + ".json";
                    RIPath = userImageDir + "/" + randFileName;
                    absPath = "images/" + userHome + "/" + randFileName;

                    List<WebBusinessObject> buildings;
                    List<WebBusinessObject> units;
                    JSONObject object = new JSONObject();
                    JSONObject sub;
                    JSONObject subsub;
                    JSONArray array;
                    JSONArray subArray;
                    WebBusinessObject projects = projectMgr.getOnSingleKey(CRMConstants.PROJECTS_ID);
                    if (projects != null && projects.getAttribute("mainProjId") != null) {
                        object.put("name", (String) projects.getAttribute("projectName"));

                        array = new JSONArray();
                        buildings = projectMgr.getOnArbitraryKey((String) projects.getAttribute("projectID"), "key2");
                        for (WebBusinessObject building : buildings) {
                            if (building != null && building.getAttribute("mainProjId") != null) {
                                units = projectMgr.getOnArbitraryKey((String) building.getAttribute("projectID"), "key2");

                                sub = new JSONObject();
                                subArray = new JSONArray();
                                for (WebBusinessObject unit : units) {
                                    subsub = new JSONObject();
                                    subsub.put("name", (String) unit.getAttribute("projectName"));
                                    subsub.put("size", "100");
                                    subArray.add(subsub);
                                }
                                sub.put("name", (String) building.getAttribute("projectName"));
                                sub.put("children", subArray);
                                array.add(sub);
                            }
                        }
                        object.put("name", (String) projects.getAttribute("projectName"));
                        object.put("children", array);
                    }

                    FileWriter file = new FileWriter(RIPath);
                    try {
                        file.write(object.toJSONString());
                        logger.info("Successfully Copied JSON Object to File...");
                        logger.info("\nJSON Object: " + object);
                    } catch (IOException e) {
                        logger.error(e);
                    } finally {
                        file.flush();
                        file.close();
                    }
                    request.setAttribute("json", absPath);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 53:
                    projectId = request.getParameter("projectId");
                    servedPage = "/docs/Adminstration/view_unit_images.jsp";
                    equipmentID = request.getParameter("equipmentID");
                    imageList = unitDocMgr.getImagesList(request.getParameter("projectId"));
                    imagesPath = new Vector();
                    
                    try {
                        for (Object image : imageList) {
                            randome = UniqueIDGen.getNextID();
                            len = randome.length();
                            docID = ((WebBusinessObject) image).getAttribute("docID").toString();
                            randFileName = "ran" + randome.substring(5, len) + ".jpeg";
                            RIPath = userImageDir + "/" + randFileName;
                            absPath = "images/" + userHome + "/" + randFileName;
                            docImage = new File(RIPath);
                            gifData = new BufferedInputStream(unitDocMgr.getImage(docID));
                            myImage = ImageIO.read(gifData);
                            ImageIO.write(myImage, "jpeg", docImage);
                            imagesPath.add(absPath);
                        }
                    } catch (Exception ex) {
                        Logger.getLogger(this.getClass().getName()).log(Level.SEVERE, null, ex);
                    }

                    

                    request.setAttribute("equipmentID", projectId);
                    request.setAttribute("imagePath", imagesPath);
                    request.setAttribute("page", servedPage);
                    this.forward(servedPage, request, response);
                    break;
                case 54:
                    projectId = request.getParameter("projectId");
                    servedPage = "/docs/Adminstration/view_unit_images.jsp";
                    equipmentID = request.getParameter("equipmentID");
                    imageList = unitDocMgr.getImagesList(request.getParameter("projectId"));
                    imagesPath = new Vector();
                    
                    try {
                        ArrayList<WebBusinessObject> docTypeList = new ArrayList<WebBusinessObject>(DocTypeMgr.getInstance().getOnArbitraryKeyOracle("Position in Map", "key1"));
                        if (!docTypeList.isEmpty()) {
                            WebBusinessObject docTypeWbo = docTypeList.get(0);
                            String docTypeID = (String) docTypeWbo.getAttribute("typeID");
                            for (Object image : imageList) {
                                if (docTypeID.equals(((WebBusinessObject) image).getAttribute("configItemType"))) {
                                    randome = UniqueIDGen.getNextID();
                                    len = randome.length();
                                    docID = ((WebBusinessObject) image).getAttribute("docID").toString();
                                    randFileName = "ran" + randome.substring(5, len) + ".jpeg";
                                    RIPath = userImageDir + "/" + randFileName;
                                    absPath = "images/" + userHome + "/" + randFileName;
                                    docImage = new File(RIPath);
                                    gifData = new BufferedInputStream(unitDocMgr.getImage(docID));
                                    myImage = ImageIO.read(gifData);
                                    ImageIO.write(myImage, "jpeg", docImage);
                                    imagesPath.add(absPath);
                                }
                            }
                        }
                    } catch (Exception ex) {
                        Logger.getLogger(this.getClass().getName()).log(Level.SEVERE, null, ex);
                    }
                    request.setAttribute("equipmentID", projectId);
                    request.setAttribute("imagePath", imagesPath);
                    request.setAttribute("page", servedPage);
                    this.forward(servedPage, request, response);
                    break;
                case 55:
                    String buildingID = request.getParameter("buildingID");
                    servedPage = "/docs/projects/view_building_details.jsp";
                    projectMgr = ProjectMgr.getInstance();
                    WebBusinessObject buildingWbo = projectMgr.getOnSingleKey(buildingID);
                    String random;
                    unitDocMgr = UnitDocMgr.getInstance();
                    imageList = unitDocMgr.getImagesList(buildingID);
                    imagesPath = new Vector();

                    userHome = (String) loggedUser.getAttribute("userHome");
                    for (int i = 0; i < imageList.size(); i++) {
                        random = UniqueIDGen.getNextID();
                        len = random.length();
                        docID = (String) ((WebBusinessObject) imageList.get(i)).getAttribute("docID");
                        randFileName = "ran" + random.substring(5, len) + ".jpeg";

                        RIPath = userImageDir + "/" + randFileName;

                        absPath = "images/" + userHome + "/" + randFileName;

                        docImage = new File(RIPath);

                        gifData = new BufferedInputStream(unitDocMgr.getImage(docID));
                        myImage = ImageIO.read(gifData);
                        ImageIO.write(myImage, "jpeg", docImage);
                        imagesPath.add(absPath);
                    }
                    request.setAttribute("imagePath", imagesPath);

                    request.setAttribute("buildingWbo", buildingWbo);
                    if (buildingWbo != null && buildingWbo.getAttribute("mainProjId") != null) {
                        WebBusinessObject parentWbo = projectMgr.getOnSingleKey((String) buildingWbo.getAttribute("mainProjId"));
                        request.setAttribute("projectWbo", parentWbo);
                    }
                    
                    ArrayList<WebBusinessObject> garagesList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryDoubleKeyOracle(buildingID, "key2", "GRG-UNIT", "key6"));
                    IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
                    ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
                    clientMgr = ClientMgr.getInstance();
                    for (WebBusinessObject garageWbo : garagesList) {
                        WebBusinessObject temp = issueStatusMgr.getLastStatusForObject((String) garageWbo.getAttribute("projectID"));
                        if (temp != null) {
                            garageWbo.setAttribute("currentStatus", temp.getAttribute("statusName"));
                            if ("10".equals((String) temp.getAttribute("statusName"))) {
                                ArrayList<WebBusinessObject> tempClientsProduct = new ArrayList<WebBusinessObject>(clientProductMgr.getOnArbitraryDoubleKeyOracle((String) garageWbo.getAttribute("projectID"), "key2", "purche", "key4"));
                                if (!tempClientsProduct.isEmpty()) {
                                    WebBusinessObject clientWbo = clientMgr.getOnSingleKey((String) tempClientsProduct.get(tempClientsProduct.size() - 1).getAttribute("clientId"));
                                    garageWbo.setAttribute("clientName", clientWbo.getAttribute("name"));
                                }
                            }
                        }
                    }
                    
                    request.setAttribute("unitsList", new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryDoubleKeyOracle(buildingID, "key2", "RES-UNIT", "key6")));
                    request.setAttribute("garagesList", garagesList);
                    request.setAttribute("customersList", ClientMgr.getInstance().getBuildingCustomers(buildingID));
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 56:
                    docType = request.getParameter("docType");
                    docID = request.getParameter("docID");
                    fileDescriptor = fileMgr.getObjectFromCash(docType);
                    app = (String) fileDescriptor.getAttribute("app");
                    IssueDocumentMgr issueDocumentMgr = IssueDocumentMgr.getInstance();
                if (docType.equalsIgnoreCase("jpg")) {
                        servedPage = "/docs/unit_doc_handling/image_renderer.jsp";
                    request.setAttribute("page", servedPage);
                    String randome = UniqueIDGen.getNextID();
                    int len = randome.length();
                    String randFileName = "ran" + randome.substring(5, len) + ".jpeg";
                    String RIPath = userImageDir + "/" + randFileName;
                    String absPath = "images/" + userHome + "/" + randFileName;
                    File docImage = new File(RIPath);

                    try (BufferedInputStream gifData = new BufferedInputStream(IssueDocumentMgr.getInstance().getImage(docID))) {
                        BufferedImage myImage = ImageIO.read(gifData);
                        ImageIO.write(myImage, "jpeg", docImage);
                        request.setAttribute("imagePath", absPath);
                    }

                    this.forward(servedPage, request, response);
                } else {
                    String randome = UniqueIDGen.getNextID();
                    int len = randome.length();
                    String randFileName = "ran" + randome.substring(5, len) + docType;
                    String RIPath = userImageDir + "/" + randFileName;

                    try (BufferedInputStream docData = new BufferedInputStream(IssueDocumentMgr.getInstance().getImage(docID));
                         ServletOutputStream stream = response.getOutputStream()) {

                        response.setContentType("application/" + app);

                        if (docType.equalsIgnoreCase("pdf")) {
                            response.setHeader("Content-Disposition", "inline; filename=\"document.pdf\"");
                        } else {
                            response.setHeader("Content-Disposition", "attachment; filename=\"req." + docType + "\"");
                        }

                        byte[] buffer = new byte[4096];
                        int bytesRead;
                        while ((bytesRead = docData.read(buffer)) != -1) {
                            stream.write(buffer, 0, bytesRead);
                        }
                    } catch (IOException ioe) {
                        throw new ServletException(ioe.getMessage());
                    }
                }
                break;

                case 57:
                    servedPage = "/docs/calendar/demo.jsp";
                    String businessObjectId = request.getParameter("businessObjectId");
                    List<WebBusinessObject> documents = unitDocMgr.getImagesList(businessObjectId);
                    ArrayList<WebBusinessObject> images = new ArrayList<>();
                    DocumentInfo info;
                    BufferedInputStream buffered;
                    String documentId, documentName, documentType;
                    for (WebBusinessObject document : documents) {
                        documentId = (String) document.getAttribute("docID");
                        documentName = (String) document.getAttribute("docTitle");
                        documentType = (String) document.getAttribute("docType");
                        buffered = new BufferedInputStream(unitDocMgr.getImage(documentId));

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

                default:

                    break;
            }

        } catch (Exception e) {
            System.out.println("Image Reader sevlet exception " + e.getMessage());
        }
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws javax.servlet.ServletException
     * @throws java.io.IOException
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws javax.servlet.ServletException
     * @throws java.io.IOException
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return
     */
    @Override
    public String getServletInfo() {
        return "SA DOc Reaer";
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return
     */
    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("ListAll")) {
            return 1;
        }

        if (opName.equalsIgnoreCase("ViewDocument")) {
            return 2;
        }

        if (opName.equalsIgnoreCase("ConfirmDelete")) {
            return 3;
        }

        if (opName.equalsIgnoreCase("Delete")) {
            return 4;
        }

        if (opName.equalsIgnoreCase("ViewDetailsImage")) {
            return 5;
        }

        if (opName.indexOf("SelectClient") == 0) {
            return 6;
        }

        if (opName.indexOf("ListAccount") == 0) {
            return 7;
        }

        if (opName.indexOf("LIKESearch") == 0) {
            return 8;
        }

        if (opName.equalsIgnoreCase("DocDetails")) {
            return 11;
        }

        if (opName.equalsIgnoreCase("GetXLS")) {
            return 13;
        }

        if (opName.equalsIgnoreCase("GetHTML")) {
            return 14;
        }

        if (opName.equalsIgnoreCase("GetAudio")) {
            return 15;
        }

        if (opName.equalsIgnoreCase("GetMovie")) {
            return 16;
        }

        if (opName.equalsIgnoreCase("ListAllContext")) {
            return 17;
        }

        if (opName.indexOf("ListTitlesLike") == 0) {
            return 19;
        }

        if (opName.equalsIgnoreCase("GetEmail")) {
            return 20;
        }

        if (opName.equalsIgnoreCase("GetSearchForm")) {
            return 21;
        }

        if (opName.equalsIgnoreCase("SearchAllDocsBody")) {
            return 22;
        }

        if (opName.indexOf("DocBodySearch") == 0) {
            return 23;
        }

        if (opName.indexOf("DBSearch") == 0) {
            return 24;
        }

        if (opName.indexOf("IntervalSearch") == 0) {
            return 25;
        }

        if (opName.indexOf("ListDocsInSpan") == 0) {
            return 26;
        }

        if (opName.equalsIgnoreCase("GetAccountsList")) {
            return 27;
        }

        if (opName.equalsIgnoreCase("GetLastTransaction")) {
            return 28;
        }

        if (opName.indexOf("MyFavorits") == 0) {
            return 29;
        }

        if (opName.equalsIgnoreCase("SeparatorView")) {
            return 30;
        }

        if (opName.equalsIgnoreCase("FolderView")) {
            return 31;
        }

        if (opName.equalsIgnoreCase("CabinetView")) {
            return 32;
        }

        if (opName.equalsIgnoreCase("GetNextImage")) {
            return 33;
        }

        if (opName.equalsIgnoreCase("ListSptr")) {
            return 34;
        }

        if (opName.indexOf("IDSearch") == 0) {
            return 35;
        }
        if (opName.equalsIgnoreCase("ListDoc")) {
            return 36;
        }

        if (opName.equalsIgnoreCase("ViewImages")) {
            return 37;
        }

        if (opName.equalsIgnoreCase("ViewEqSchedulesExcel")) {
            return 38;
        }

        if (opName.equalsIgnoreCase("viewSimpleImages")) {
            return 39;
        }

        if (opName.equalsIgnoreCase("viewUnitImages")) {
            return 40;
        }

        if (opName.indexOf("ListAttachedDocs") == 0) {
            return 41;
        }

        if (opName.indexOf("AttachedDocsDetails") == 0) {
            return 42;
        }

        if (opName.equalsIgnoreCase("ConfirmDeleteAttachFile")) {
            return 43;
        }
        if (opName.equalsIgnoreCase("DeleteAttachFile")) {
            return 44;
        }
        if (opName.equalsIgnoreCase("DeleteSelectedAttachFile")) {
            return 45;
        }
        if (opName.equalsIgnoreCase("DeleteFileAjax")) {
            return 46;
        }
        if (opName.equalsIgnoreCase("updateFileParent")) {
            return 47;
        }
        if (opName.equalsIgnoreCase("updateSelectedAttachFile")) {
            return 48;
        }
        if (opName.equalsIgnoreCase("viewDocuments")) {
            return 49;
        }
        if (opName.equalsIgnoreCase("unitDocGallery")) {
            return 50;
        }
        if (opName.equalsIgnoreCase("getUnitReservationPopup")) {
            return 51;
        }
        if (opName.equalsIgnoreCase("buidUnitsTree")) {
            return 52;
        }
        if (opName.equalsIgnoreCase("viewProjectMasterPlan")) {
            return 53;
        }
        if (opName.equalsIgnoreCase("viewBuildingMapPosition")) {
            return 54;
        }
        if (opName.equalsIgnoreCase("viewBuildingDetails")) {
            return 55;
        }
        if (opName.equalsIgnoreCase("viewIssueDocFile")) {
            return 56;
        }
        if (opName.equalsIgnoreCase("getGallery")) {
            return 57;
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
