package com.docviewer.servlets;

import com.clients.db_access.ClientComplaintsMgr;
import com.clients.db_access.ClientMgr;
import com.contractor.db_access.MaintainableMgr;
import com.docviewer.business_objects.Document;
import com.maintenance.common.Tools;
import com.maintenance.db_access.ScheduleMgr;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import com.maintenance.db_access.ComplaintsIssueViewMgr;
import com.maintenance.db_access.IssueDocumentMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.EmpRelationMgr;
import com.silkworm.common.UserMgr;
import com.silkworm.db_access.FileMgr;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.tracker.db_access.DepDocPrevMgr;
import com.tracker.db_access.IssueMgr;
import com.tracker.db_access.ProjectMgr;
import java.awt.image.BufferedImage;
import java.util.ArrayList;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.imageio.ImageIO;

public class IssueDocServlet extends ImageHandlerServlet {

    String documentID = null;
    String docType = null;
    FileMgr fileMgr = FileMgr.getInstance();
    ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
    WebBusinessObject fileDescriptor = null;
    String app = null;
    ComplaintsIssueViewMgr complaintsIssueMgr = ComplaintsIssueViewMgr.getInstance();
    BufferedInputStream gifData = null;
    BufferedImage myImage = null;
    WebBusinessObject doc = null;
    Vector docsList = null;
    String randFileName = null;
    String random = null;
    int len = 0;

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

        String op = (String) request.getParameter("op");
        operation = getOpCode(op);

        try {
            switch (operation) {

                case 1:
                    servedPage = "/docs/issue_doc_handling/attached_docs_list.jsp";

                    String issueId = request.getParameter("issueId");
                    
                    WebBusinessObject issue = IssueMgr.getInstance().getOnSingleKey(issueId);
                    docsList = filterDocs(issueId, session);

                    String type = (String) request.getParameter("type");

                    request.setAttribute("issue", issue);
                    request.setAttribute("data", docsList);
                    request.setAttribute("issueId", issueId);
                    request.setAttribute("page", servedPage);
                    request.setAttribute("type", type);

                    this.forward(servedPage, request, response);

                    break;

                case 2:
                    documentID = request.getParameter("docID");
                    issueId = request.getParameter("issueId");

                    doc = complaintsIssueMgr.getOnSingleKey(documentID);
                    if (null == doc) {
                        servedPage = "/docs/search/id_search.jsp";
                        request.setAttribute("page", servedPage);
                        request.setAttribute("message", "nodocument");
                    } else {
                        servedPage = "/docs/issue_doc_handling/attach_doc_details.jsp";
                        random = UniqueIDGen.getNextID();
                        len = random.length();

                        randFileName = "ran" + random.substring(5, len) + ".jpeg";
                        RIPath = userImageDir + "/" + randFileName;
                        absPath = "images/" + userHome + "/" + randFileName;
                        docImage = new File(RIPath);
                        gifData = new BufferedInputStream(complaintsIssueMgr.getImage(documentID));
                        myImage = ImageIO.read(gifData);
                        if (myImage != null) {
                            ImageIO.write(myImage, "jpeg", docImage);
                            request.setAttribute("imagePath", absPath);
                        }
                        request.setAttribute("page", servedPage);
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("defDocID", documentID);
                        request.setAttribute("docObject", doc);
                    }

                    this.forward(servedPage, request, response);
                    break;

                case 3:

                    docType = request.getParameter("docType");
                    documentID = request.getParameter("docID");

                    fileDescriptor = fileMgr.getObjectFromCash(docType);

                    app = (String) fileDescriptor.getAttribute("app");

                    String documentName = request.getParameter("docName");
                    random = UniqueIDGen.getNextID();
                    len = random.length();

                    randFileName = "ran" + random.substring(5, len) + docType;

                    RIPath = userImageDir + "/" + randFileName;

                    BufferedInputStream pdfData
                            = new BufferedInputStream(complaintsIssueMgr.getImage(documentID));

                    ServletOutputStream stream = null;
                    try {
                        stream = response.getOutputStream();
                        response.setContentType("application/" + app);
                        response.addHeader("Content-Disposition", "attachment; filename=" + documentName + "." + docType);
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
                case 4:
                    String docID = request.getParameter("docID");
                    IssueDocumentMgr issueDocumentMgr = IssueDocumentMgr.getInstance();
                    doc = (Document) issueDocumentMgr.getOnSingleKey(docID);
                    request.setAttribute("docID", request.getParameter("docID"));
                    request.setAttribute("docTitle", request.getParameter("docTitle"));
                    request.setAttribute("doc", doc);
                    issueId = request.getParameter("issueId");
                    servedPage = "/docs/issue_doc_handling/confirm_deletion_attached.jsp";
                    request.setAttribute("issueId", issueId);
                    request.setAttribute("page", servedPage);
                    this.forward(servedPage, request, response);

                case 5:
                    docID = request.getParameter("docID");
                    issueDocumentMgr = IssueDocumentMgr.getInstance();
                    issueDocumentMgr.deleteOnSingleKey(docID);
                    issueId = request.getParameter("issueId");
                    servedPage = "/docs/issue_doc_handling/attached_docs_list.jsp";

                    issueId = issueId.replace('^', '&');
                    issueId = issueId.replace('$', '#');
                    issueId = issueId.replace('*', ';');

                    docsList = docsList = filterDocs(issueId, session);

                    type = (String) request.getParameter("type");

                    request.setAttribute("data", docsList);
                    request.setAttribute("issueId", issueId);
                    request.setAttribute("page", servedPage);
                    request.setAttribute("type", type);
                    
                    this.forward(servedPage, request, response);

                    break;
                case 6:
                    issueId = request.getParameter("issueId");
                    servedPage = "/docs/issue_doc_handling/view_issue_images.jsp";
                    issueDocumentMgr = IssueDocumentMgr.getInstance();
                    Vector imageList = issueDocumentMgr.getImagesList(issueId);
                    Vector imagesPath = new Vector();
                    issue = IssueMgr.getInstance().getOnSingleKey(issueId);

                    for (int i = 0; i < imageList.size(); i++) {
                        random = UniqueIDGen.getNextID();
                        len = random.length();
                        docID = (String) ((WebBusinessObject) imageList.get(i)).getAttribute("documentID");
                        randFileName = "ran" + random.substring(5, len) + ".jpeg";


                        RIPath = userImageDir + "/" + randFileName;


                        absPath = "images/" + userHome + "/" + randFileName;

                        docImage = new File(RIPath);

                        gifData = new BufferedInputStream(issueDocumentMgr.getImage(docID));
                        myImage = ImageIO.read(gifData);
                        ImageIO.write(myImage, "jpeg", docImage);
                        imagesPath.add(absPath);
                    }

                    request.setAttribute("issue", issue);
                    request.setAttribute("issueId", issueId);
                    request.setAttribute("imagePath", imagesPath);
                    request.setAttribute("page", servedPage);
                    this.forward(servedPage, request, response);
                    break;
                    
                case 7:
                    documentID = request.getParameter("docID");
                    issueId = request.getParameter("issueId");

                    doc = complaintsIssueMgr.getOnSingleKey(documentID);
                    if (null != doc) {
                        servedPage = "/docs/issue_doc_handling/update_document.jsp";
                        random = UniqueIDGen.getNextID();
                        len = random.length();

                        randFileName = "ran" + random.substring(5, len) + ".jpeg";
                        RIPath = userImageDir + "/" + randFileName;
                        absPath = "images/" + userHome + "/" + randFileName;
                        docImage = new File(RIPath);
                        gifData = new BufferedInputStream(complaintsIssueMgr.getImage(documentID));
                        myImage = ImageIO.read(gifData);
                        if (myImage != null) {
                            ImageIO.write(myImage, "jpeg", docImage);
                            request.setAttribute("imagePath", absPath);
                        }
                        request.setAttribute("page", servedPage);
                        request.setAttribute("issueId", issueId);
                        request.setAttribute("defDocID", documentID);
                        request.setAttribute("docObject", doc);
                    }

                    this.forward(servedPage, request, response);
                    break;
                    
                case 8:
                    issueDocumentMgr = IssueDocumentMgr.getInstance();
                    issueDocumentMgr.updateDocument(request, session);
                    servedPage = "/docs/issue_doc_handling/attached_docs_list.jsp";

                    issueId = request.getParameter("issueId");

                    issue = IssueMgr.getInstance().getOnSingleKey(issueId);
                    docsList = docsList = filterDocs(issueId, session);

                    type = (String) request.getParameter("type");

                    request.setAttribute("issue", issue);
                    request.setAttribute("data", docsList);
                    request.setAttribute("issueId", issueId);
                    request.setAttribute("page", servedPage);
                    request.setAttribute("type", type);

                    this.forward(servedPage, request, response);

                    break;
                case 9:
                    servedPage = "/docs/issue_doc_handling/search_document.jsp";
                    String num = request.getParameter("num");
                    if (num != null && !num.isEmpty()) {
                        issueDocumentMgr = IssueDocumentMgr.getInstance();
                        ClientMgr clientMgr = ClientMgr.getInstance();
                        IssueMgr issueMgr = IssueMgr.getInstance();
                        ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                        UserMgr userMgr = UserMgr.getInstance();
                        WebBusinessObject issueWbo = issueMgr.getOnSingleKey("key6", num);
                        if (issueWbo != null) {
                            if (issueWbo.getAttribute("clientId") != null) {
                                WebBusinessObject clientWbo = clientMgr.getOnSingleKey((String) issueWbo.getAttribute("clientId"));
                                issueWbo.setAttribute("contractorName", (String) clientWbo.getAttribute("name"));
                            }
                            ArrayList<WebBusinessObject> clientComplaints = new ArrayList<WebBusinessObject>(clientComplaintsMgr.getOnArbitraryKeyOracle((String) issueWbo.getAttribute("id"), "key1"));
                            for (WebBusinessObject clientComplaint : clientComplaints) {
                                ArrayList<WebBusinessObject> docList = new ArrayList<WebBusinessObject>(issueDocumentMgr.getOnArbitraryDoubleKeyOracle((String) clientComplaint.getAttribute("id"), "key5", "1401286126376", "key4"));
                                if (docList.size() > 0) {
                                    request.setAttribute("docWbo", docList.get(0));
                                    break;
                                }
                            }
                            WebBusinessObject userWbo =userMgr.getOnSingleKey((String) issueWbo.getAttribute("userId"));
                            if(userWbo != null) {
                                issueWbo.setAttribute("createdByName", userWbo.getAttribute("fullName"));
                            }
                        }
                        request.setAttribute("issueWbo", issueWbo);
                        request.setAttribute("num", num);
                    }
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 10:
                    PrintWriter out = response.getWriter();
                    issueDocumentMgr = IssueDocumentMgr.getInstance();
                    WebBusinessObject wbo = new WebBusinessObject();
                    if (request.getParameter("issueID") != null) {
                        wbo.setAttribute("documentsNo", issueDocumentMgr.getDocumentCountForIssue(request.getParameter("issueID")));
                    } else {
                        wbo.setAttribute("documentsNo", "0");
                    }
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;

                default:

                    break;
            }

        } catch (Exception e) {
            System.out.println("Image Reader sevlet exception " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Issue Document Servlet";
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.indexOf("ListAttachedDocs") == 0) {
            return 1;
        }

        if (opName.indexOf("AttachedDocsDetails") == 0) {
            return 2;
        }

        if (opName.equalsIgnoreCase("ViewDocument")) {
            return 3;
        }

        if (opName.equalsIgnoreCase("ConfirmDeleteAttachFile")) {
            return 4;
        }

        if (opName.equalsIgnoreCase("DeleteAttachFile")) {
            return 5;
        }
        
        if (opName.equalsIgnoreCase("ViewIssueImages")) {
            return 6;
        }
        
        if (opName.equalsIgnoreCase("UpdateDocumentDetails")) {
            return 7;
        }
                
        if (opName.equalsIgnoreCase("UpdateDocument")) {
            return 8;
        }
        
        if (opName.equals("searchForDocument")) {
            return 9;
        }
        
        if (opName.equals("getDocumentsCount")) {
            return 10;
        }

        return 0;
    }
    
    private Vector filterDocs(String issueId, HttpSession session) {
        Vector docsList = new Vector();
        try {
            // Begin for documents security
            WebBusinessObject userWbo = (WebBusinessObject) session.getAttribute("loggedUser");
            ArrayList<String> managersIDs = new ArrayList<String>();
            managersIDs.add((String) userWbo.getAttribute("userId"));
            EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
            Vector<WebBusinessObject> managerList = empRelationMgr.getOnArbitraryKeyOracle((String) userWbo.getAttribute("userId"), "key2");
            if (managerList != null) {
                for (WebBusinessObject managerWbo : managerList) {
                    if (!managersIDs.contains((String) managerWbo.getAttribute("mgrId"))) {
                        managersIDs.add((String) managerWbo.getAttribute("mgrId"));
                    }
                }
            }
            ProjectMgr projectMgr = ProjectMgr.getInstance();
            Vector<WebBusinessObject> projectsVector = new Vector<WebBusinessObject>();
            for (String managerID : managersIDs) {
                projectsVector.addAll(projectMgr.getOnArbitraryKeyOracle(managerID, "key5"));
            }
            ArrayList<String> projectsIDs = new ArrayList<String>();
            for (WebBusinessObject projectWbo : projectsVector) {
                if (!projectsIDs.contains((String) projectWbo.getAttribute("projectID"))) {
                    projectsIDs.add((String) projectWbo.getAttribute("projectID"));
                }
            }
            DepDocPrevMgr depDocPrevMgr = DepDocPrevMgr.getInstance();
            Vector<WebBusinessObject> depDocPrevsVector = new Vector<WebBusinessObject>();
            for (String projectID : projectsIDs) {
                depDocPrevsVector.addAll(depDocPrevMgr.getOnArbitraryKeyOracle(projectID, "key"));
            }
            // End

            
            Vector<Document> docsListTemp = complaintsIssueMgr.getDocumentsListForIssue(issueId);
            
            // Filter for document type
            for (WebBusinessObject depDocPrevWbo : depDocPrevsVector) {
                Vector<WebBusinessObject> docWithSameType = new Vector<WebBusinessObject>();
                for (Document docObj : docsListTemp) {
                    if (((String) docObj.getAttribute("configItemType")).equalsIgnoreCase(((String) depDocPrevWbo.getAttribute("docTypeID")))) {
                        if (((String) depDocPrevWbo.getAttribute("lastVersion")).equalsIgnoreCase("0")) {
                            docsList.add(docObj);
                        } else {
                            docWithSameType.add(docObj);
                        }
                    }
                }
                if (docWithSameType.size() > 0) {
                    docsList.add(docWithSameType.get(docWithSameType.size() - 1));
                }
            }
        } catch (Exception ex) {
            Logger.getLogger(IssueDocServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        return docsList;
    }
}
