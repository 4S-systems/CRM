package com.workFlowTasks.servlets;

import com.clients.db_access.ClientMgr;
import com.maintenance.common.DateParser;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.common.UserMgr;
//import com.tracker.business_objects.ExcelCreator;
import com.workFlowTasks.db_access.WFTaskDocMgr;
import com.workFlowTasks.db_access.WFTaskMgr;
import com.workFlowTasks.db_access.WFTaskSequenceMgr;
import com.workFlowTasks.db_access.WFTaskVisitMgr;
import java.io.*;
import java.sql.SQLException;
import java.util.*;

import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.*;
import javax.servlet.http.*;

import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.Exceptions.*;
import com.tracker.servlets.TrackerBaseServlet;

import com.maintenance.db_access.*;

import com.docviewer.servlets.DocViewerFileRenamePolicy;
import com.maintenance.common.Tools;
import com.silkworm.db_access.FileMgr;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.servlets.MultipartRequest;
import com.silkworm.util.EmailSender;
import com.silkworm.util.FileIO;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
//import com.maintenance.db_access.ItemMgr;

public class WFTaskServlet extends TrackerBaseServlet {

    TaskMgr taskMgr = TaskMgr.getInstance();
    UnitMgr unitMgr = UnitMgr.getInstance();
    TaskTypeMgr taskTypeMgr = TaskTypeMgr.getInstance();
    ConfigureMainTypeMgr configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
    TradeMgr tradeMgr = TradeMgr.getInstance();
    FileMgr fileMgr = FileMgr.getInstance();
    WFTaskVisitMgr wFTaskVisitMgr = WFTaskVisitMgr.getInstance();
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    ClientMgr clientMgr = ClientMgr.getInstance();
    String op = null;
    String filterName = null;
    String filterValue = null;
    String categoryId = null;
    Vector unitsList = null;
    ArrayList unitArr;
    ArrayList itemCategory;
    String[] quantityMainType = {"", ""};
    String[] priceMainType = {"", ""};
    String[] idMainType = {"", ""};
    String[] itemIdMainType = {"", ""};
    String[] itemCost = {"", ""};
    //   private ExcelCreator excelCreator;
    private HSSFWorkbook workBook;

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void destroy() {
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");

        switch (operation) {
            case 1:

                servedPage = "/docs/WorkFlowTasks/new_wf_task.jsp";

                WebBusinessObject userWbo = new WebBusinessObject();
                userWbo = (WebBusinessObject) session.getAttribute("loggedUser");

                WFTaskSequenceMgr wFTaskSequenceMgr = WFTaskSequenceMgr.getInstance();
                wFTaskSequenceMgr.updateSequence();
                String sequence = wFTaskSequenceMgr.getSequence();

                request.setAttribute("userWbo", userWbo);
                request.setAttribute("taskNum", sequence);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 2:

                servedPage = "/docs/WorkFlowTasks/new_wf_task.jsp";

                WebBusinessObject wfTaskWbo = new WebBusinessObject();

                String wfTaskName = request.getParameter("wfTaskName");
                String wfTaskDesc = request.getParameter("wfTaskDesc");
                String wfTaskCode = request.getParameter("wfTaskCode");
                String wfTaskType = request.getParameter("taskType");
                String userId = request.getParameter("userId");
                String department = request.getParameter("department");

//                String date[]= request.getParameter("date").split("/");
//                int eYear=Integer.parseInt(date[2]);
//                int eMonth=Integer.parseInt(date[0]);
//                int eDay=Integer.parseInt(date[1]);
//                java.sql.Date dateStr=new java.sql.Date(eYear-1900,eMonth-1,eDay);

                DateParser dateParser = new DateParser();
                java.sql.Date dateStr = dateParser.formatSqlDate(request.getParameter("date"));

                wfTaskWbo.setAttribute("title", wfTaskName);
                wfTaskWbo.setAttribute("desc", wfTaskDesc);
                wfTaskWbo.setAttribute("date", dateStr);
                wfTaskWbo.setAttribute("taskCode", wfTaskCode);
                wfTaskWbo.setAttribute("taskType", wfTaskType);
                wfTaskWbo.setAttribute("userId", userId);
                wfTaskWbo.setAttribute("department", department);

                WFTaskMgr wFTaskMgr = WFTaskMgr.getInstance();
                String wfTaskId = "";
                String wfTaskVisitId = "";

                try {
//                    if(wFTaskMgr.getDoubleName(wFTaskMgr)){
                    if (wFTaskMgr.saveObject(wfTaskWbo, session)) {
                        request.setAttribute("status", "ok");
                        wfTaskId = wFTaskMgr.getWFTaskId();
                        wfTaskVisitId = wFTaskMgr.getWFTaskVisitId();
                    } else {
                        request.setAttribute("status", "fail");
                    }
//                    }else{
//                        request.setAttribute("status","double");
//                    }
                } catch (NoUserInSessionException ex) {
                    ex.printStackTrace();
                }

                userWbo = new WebBusinessObject();
                userWbo = (WebBusinessObject) session.getAttribute("loggedUser");

                wFTaskSequenceMgr = WFTaskSequenceMgr.getInstance();
                wFTaskSequenceMgr.updateSequence();
                sequence = wFTaskSequenceMgr.getSequence();

                request.setAttribute("userWbo", userWbo);
                request.setAttribute("taskNum", sequence);
                request.setAttribute("page", servedPage);

                String url = "/WFTaskServlet?op=viewWFTask&wfTaskId=" + wfTaskId;
                this.forward(url, request, response);

//                this.forwardToServedPage(request, response);
                break;

            case 3:

                Vector wfTasks = new Vector();
                wFTaskMgr = WFTaskMgr.getInstance();
                userWbo = new WebBusinessObject();
                UserMgr userMgr = UserMgr.getInstance();
                wFTaskMgr.cashData();
                wfTaskWbo = new WebBusinessObject();
                WebBusinessObject docWbo = new WebBusinessObject();

                wfTasks = wFTaskMgr.getCashedTable();
                WFTaskDocMgr wFTaskDocMgr = WFTaskDocMgr.getInstance();
                Vector docsList = new Vector();
                Hashtable wfTaskdocs = new Hashtable();

                for (int i = 0; i < wfTasks.size(); i++) {
                    wfTaskWbo = new WebBusinessObject();
                    docsList = new Vector();

                    wfTaskWbo = (WebBusinessObject) wfTasks.get(i);
                    wfTaskId = wfTaskWbo.getAttribute("id").toString();

                    docsList = wFTaskDocMgr.getListOnLIKE(request.getParameter("op"), wfTaskId);

                    for (int c = 0; c < docsList.size(); c++) {
                        docWbo = new WebBusinessObject();
                        userWbo = new WebBusinessObject();

                        docWbo = (WebBusinessObject) docsList.get(c);
                        userWbo = userMgr.getOnSingleKey(docWbo.getAttribute("createdBy").toString());
                        docWbo.setAttribute("userName", userWbo.getAttribute("userName").toString());
                    }
                    wfTaskdocs.put(wfTaskId, docsList);
                }


                servedPage = "/docs/WorkFlowTasks/list_wf_tasks.jsp";

                request.setAttribute("wfTaskdocs", wfTaskdocs);
                request.setAttribute("data", wfTasks);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 4:

                servedPage = "/docs/WorkFlowTasks/update_wf_task.jsp";
                userMgr = UserMgr.getInstance();
                userWbo = new WebBusinessObject();
                wfTaskWbo = new WebBusinessObject();

                wfTaskName = request.getParameter("wfTaskName");
                wfTaskDesc = request.getParameter("wfTaskDesc");
                wfTaskCode = request.getParameter("wfTaskCode");
                wfTaskType = request.getParameter("taskType");
                userId = request.getParameter("userId");
                department = request.getParameter("department");

//                date= request.getParameter("date").replaceAll("-","/").split("/");
//                eYear=Integer.parseInt(date[2]);
//                eMonth=Integer.parseInt(date[0]);
//                eDay=Integer.parseInt(date[1]);
//                dateStr=new java.sql.Date(eYear-1900,eMonth-1,eDay);

                dateParser = new DateParser();
                dateStr = dateParser.formatSqlDate(request.getParameter("date").replaceAll("-", "/"));

                wfTaskWbo.setAttribute("title", wfTaskName);
                wfTaskWbo.setAttribute("desc", wfTaskDesc);
                wfTaskWbo.setAttribute("date", dateStr);
                wfTaskWbo.setAttribute("taskCode", wfTaskCode);
                wfTaskWbo.setAttribute("taskType", wfTaskType);
                wfTaskWbo.setAttribute("userId", userId);
                wfTaskWbo.setAttribute("department", department);
                wfTaskWbo.setAttribute("id", request.getParameter("wfTaskId"));

                wFTaskMgr = WFTaskMgr.getInstance();
                wfTaskId = "";
                wfTaskVisitId = "";

                try {
                    if (wFTaskMgr.updateWFTask(wfTaskWbo, session)) {
                        request.setAttribute("status", "ok");
                        wfTaskId = wFTaskMgr.getWFTaskId();
                    } else {
                        request.setAttribute("status", "fail");
                    }
                } catch (NoUserInSessionException ex) {
                    ex.printStackTrace();
                }
                if (wfTaskId.equalsIgnoreCase("")) {
                    wfTaskWbo = wFTaskMgr.getOnSingleKey(request.getParameter("wfTaskId"));
                } else {
                    wfTaskWbo = wFTaskMgr.getOnSingleKey(wfTaskId);
                }

                String temp = wfTaskWbo.getAttribute("creationDate").toString();
                String[] date = temp.split("-");
                String newDate = date[1] + "/" + date[2] + "/" + date[0];
                wfTaskWbo.setAttribute("creationDate", newDate);

                userWbo = userMgr.getOnSingleKey(wfTaskWbo.getAttribute("createdBy").toString());
                wfTaskWbo.setAttribute("userName", userWbo.getAttribute("userName"));

                request.setAttribute("wfTaskWbo", wfTaskWbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 5:
                wfTaskWbo = new WebBusinessObject();
                wFTaskMgr = WFTaskMgr.getInstance();
                userMgr = UserMgr.getInstance();
                userWbo = new WebBusinessObject();

                servedPage = "/docs/WorkFlowTasks/view_wf_task.jsp";
                wfTaskId = request.getParameter("wfTaskId");

                wfTaskWbo = wFTaskMgr.getOnSingleKey(wfTaskId);
                userWbo = userMgr.getOnSingleKey(wfTaskWbo.getAttribute("createdBy").toString());
                wfTaskWbo.setAttribute("userName", userWbo.getAttribute("userName"));

                request.setAttribute("wfTaskWbo", wfTaskWbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 6:

                wfTaskWbo = new WebBusinessObject();
                wFTaskMgr = WFTaskMgr.getInstance();
                userMgr = UserMgr.getInstance();
                userWbo = new WebBusinessObject();
                servedPage = "/docs/WorkFlowTasks/update_wf_task.jsp";
                wfTaskId = request.getParameter("wfTaskId");

                wfTaskWbo = wFTaskMgr.getOnSingleKey(wfTaskId);

                userWbo = userMgr.getOnSingleKey(wfTaskWbo.getAttribute("createdBy").toString());
                wfTaskWbo.setAttribute("userName", userWbo.getAttribute("userName"));

                temp = wfTaskWbo.getAttribute("creationDate").toString();
                date = temp.split("-");
                newDate = date[1] + "/" + date[2] + "/" + date[0];
                wfTaskWbo.setAttribute("creationDate", newDate);

                request.setAttribute("wfTaskWbo", wfTaskWbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 7:

                wfTasks = new Vector();
                wFTaskMgr = WFTaskMgr.getInstance();
                userMgr = UserMgr.getInstance();

                wfTaskId = request.getParameter("wfTaskId");

                if (wFTaskMgr.deleteWfTask(wfTaskId)) {
                    request.setAttribute("status", "ok");
                } else {
                    request.setAttribute("status", "fail");
                }

                wFTaskMgr.cashData();
                wfTasks = wFTaskMgr.getCashedTable();

                wFTaskDocMgr = WFTaskDocMgr.getInstance();
                docsList = new Vector();
                wfTaskdocs = new Hashtable();

                for (int i = 0; i < wfTasks.size(); i++) {
                    wfTaskWbo = new WebBusinessObject();
                    docsList = new Vector();

                    wfTaskWbo = (WebBusinessObject) wfTasks.get(i);
                    wfTaskId = wfTaskWbo.getAttribute("id").toString();

                    docsList = wFTaskDocMgr.getListOnLIKE(request.getParameter("op"), wfTaskId);

                    for (int c = 0; c < docsList.size(); c++) {
                        docWbo = new WebBusinessObject();
                        userWbo = new WebBusinessObject();

                        docWbo = (WebBusinessObject) docsList.get(c);
                        userWbo = userMgr.getOnSingleKey(docWbo.getAttribute("createdBy").toString());
                        docWbo.setAttribute("userName", userWbo.getAttribute("userName").toString());
                    }

                    wfTaskdocs.put(wfTaskId, docsList);
                }

                servedPage = "/docs/WorkFlowTasks/list_wf_tasks.jsp";

                request.setAttribute("wfTaskdocs", wfTaskdocs);
                request.setAttribute("data", wfTasks);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 8:

                wfTaskWbo = new WebBusinessObject();
                wFTaskMgr = WFTaskMgr.getInstance();
                userMgr = UserMgr.getInstance();
                userWbo = new WebBusinessObject();
                servedPage = "/docs/WorkFlowTasks/add_wfTask_notes.jsp";

                wfTaskId = request.getParameter("wfTaskId");

                wfTaskWbo = wFTaskMgr.getOnSingleKey(wfTaskId);

                userWbo = userMgr.getOnSingleKey(wfTaskWbo.getAttribute("createdBy").toString());
                wfTaskWbo.setAttribute("userName", userWbo.getAttribute("userName"));

                request.setAttribute("wfTaskWbo", wfTaskWbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 9:
                servedPage = "/docs/WorkFlowTasks/add_wfTask_notes.jsp";
                userMgr = UserMgr.getInstance();
                userWbo = new WebBusinessObject();
                wfTaskWbo = new WebBusinessObject();

                userWbo = (WebBusinessObject) session.getAttribute("loggedUser");

                String notes = request.getParameter("notes");

//                date= request.getParameter("date").replaceAll("-","/").split("/");
//                eYear=Integer.parseInt(date[2]);
//                eMonth=Integer.parseInt(date[0]);
//                eDay=Integer.parseInt(date[1]);
//                dateStr=new java.sql.Date(eYear-1900,eMonth-1,eDay);

                dateParser = new DateParser();
                dateStr = dateParser.formatSqlDate(request.getParameter("date").replaceAll("-", "/"));

                wfTaskWbo.setAttribute("notes", notes);
                wfTaskWbo.setAttribute("date", dateStr);
                wfTaskWbo.setAttribute("userId", userWbo.getAttribute("userId").toString());
                wfTaskWbo.setAttribute("id", request.getParameter("wfTaskId"));

                wFTaskMgr = WFTaskMgr.getInstance();
                wfTaskId = "";
                wfTaskVisitId = "";

                try {
                    if (wFTaskMgr.saveNotes(wfTaskWbo, session)) {
                        request.setAttribute("status", "ok");
                    } else {
                        request.setAttribute("status", "fail");
                    }
                } catch (NoUserInSessionException ex) {
                    ex.printStackTrace();
                }

                wfTaskWbo = wFTaskMgr.getOnSingleKey(request.getParameter("wfTaskId"));

                userWbo = userMgr.getOnSingleKey(wfTaskWbo.getAttribute("createdBy").toString());
                wfTaskWbo.setAttribute("userName", userWbo.getAttribute("userName"));

                request.setAttribute("wfTaskWbo", wfTaskWbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 10:

                wfTaskWbo = new WebBusinessObject();
                WebBusinessObject wfTaskVisitWbo = new WebBusinessObject();
                wFTaskMgr = WFTaskMgr.getInstance();
                WFTaskVisitMgr wfTaskVisitMgr = WFTaskVisitMgr.getInstance();
                userMgr = UserMgr.getInstance();
                userWbo = new WebBusinessObject();
                Vector wfTaskNotes = new Vector();
                servedPage = "/docs/WorkFlowTasks/list_wfTask_notes.jsp";

                wfTaskId = request.getParameter("wfTaskId");

                wfTaskWbo = wFTaskMgr.getOnSingleKey(wfTaskId);

                userWbo = userMgr.getOnSingleKey(wfTaskWbo.getAttribute("createdBy").toString());
                wfTaskWbo.setAttribute("userName", userWbo.getAttribute("userName"));

                try {
                    wfTaskNotes = wfTaskVisitMgr.getOnArbitraryKey(wfTaskId, "key1");

                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }

                for (int i = 0; i < wfTaskNotes.size(); i++) {
                    wfTaskVisitWbo = new WebBusinessObject();
                    wfTaskVisitWbo = (WebBusinessObject) wfTaskNotes.get(i);

                    userWbo = userMgr.getOnSingleKey(wfTaskVisitWbo.getAttribute("createdBy").toString());
                    wfTaskVisitWbo.setAttribute("userName", userWbo.getAttribute("userName"));

                }

                request.setAttribute("wfTaskNotes", wfTaskNotes);
                request.setAttribute("wfTaskWbo", wfTaskWbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 11:

                servedPage = "/docs/WorkFlowTasks/close_wfTask.jsp";
                wfTaskWbo = new WebBusinessObject();
                wFTaskMgr = WFTaskMgr.getInstance();
                userMgr = UserMgr.getInstance();

                wfTaskId = request.getParameter("wfTaskId");
                wfTaskWbo = wFTaskMgr.getOnSingleKey(wfTaskId);

                userWbo = userMgr.getOnSingleKey(wfTaskWbo.getAttribute("createdBy").toString());
                wfTaskWbo.setAttribute("userName", userWbo.getAttribute("userName"));

                request.setAttribute("wfTaskWbo", wfTaskWbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 12:

                servedPage = "/docs/WorkFlowTasks/close_wfTask.jsp";
                wfTaskWbo = new WebBusinessObject();
                userWbo = new WebBusinessObject();
                wFTaskMgr = WFTaskMgr.getInstance();
                userMgr = UserMgr.getInstance();
                userWbo = (WebBusinessObject) session.getAttribute("loggedUser");

                wfTaskId = request.getParameter("wfTaskId");
                wfTaskWbo = wFTaskMgr.getOnSingleKey(wfTaskId);

                String endDate = request.getParameter("date");
                java.sql.Date endD = null;
                dateParser = new DateParser();

                if (null != endDate) {
//                    date=endDate.split("/");
//                    int year=Integer.parseInt(date[2]);
//                    int month=Integer.parseInt(date[0]);
//                    int day=Integer.parseInt(date[1]);
//                    endD=new java.sql.Date(year-1900,month-1,day);

                    endD = dateParser.formatSqlDate(endDate);

                }
//                WFTaskStatusMgr wFTaskStatusMgr=WFTaskStatusMgr.getInstance();
//                String lastStatus=wfTaskWbo.getAttribute("lastStatus").toString();
//                WebBusinessObject lastStatusWbo=wFTaskStatusMgr.getLastTaskStatus(wfTaskId,lastStatus);
//                String lastStatusendDate = (String) lastStatusWbo.getAttribute("endDate");

                String closeNotes = request.getParameter("notes");

                WebBusinessObject taskStatusWbo = new WebBusinessObject();

                taskStatusWbo.setAttribute("status", "Finished");
                taskStatusWbo.setAttribute("taskId", wfTaskId);
                taskStatusWbo.setAttribute("taskTitle", wfTaskWbo.getAttribute("title").toString());
                taskStatusWbo.setAttribute("notes", closeNotes);
                taskStatusWbo.setAttribute("endDate", endD);
                taskStatusWbo.setAttribute("beginDate", endD);
                taskStatusWbo.setAttribute("userId", userWbo.getAttribute("userId").toString());

                try {
                    if (wFTaskMgr.changeStatus(taskStatusWbo, session)) {
                        request.setAttribute("status", "ok");
                    } else {
                        request.setAttribute("status", "fail");
                    }

                } catch (NoUserInSessionException ex) {
                    ex.printStackTrace();
                }
                wfTaskWbo = wFTaskMgr.getOnSingleKey(wfTaskId);

                userWbo = userMgr.getOnSingleKey(wfTaskWbo.getAttribute("createdBy").toString());
                wfTaskWbo.setAttribute("userName", userWbo.getAttribute("userName"));

                request.setAttribute("wfTaskWbo", wfTaskWbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 13:
                wfTaskWbo = new WebBusinessObject();
                wFTaskMgr = WFTaskMgr.getInstance();
                userMgr = UserMgr.getInstance();
                ArrayList userList = userMgr.getUserList();
                servedPage = "/docs/WorkFlowTasks/add_wfTask_by_login.jsp";
                String businessObjectId = request.getParameter("businessObjectId");
                String objectType = request.getParameter("objectType");

//                ticketCode = wfTaskWbo.getAttribute("code").toString();

                request.setAttribute("state", "clarify");
                request.setAttribute("businessObjectId", businessObjectId);
                request.setAttribute("objectType", objectType);
                request.setAttribute("userList", userList);
                request.setAttribute("page", servedPage);
//                this.forward(servedPage, request, response);
                this.forwardToServedPage(request, response);
                break;

            case 14:
                servedPage = "/docs/WorkFlowTasks/add_wfTask_by_login.jsp";
                userMgr = UserMgr.getInstance();
                userWbo = new WebBusinessObject();
                wfTaskWbo = new WebBusinessObject();
                MultipartRequest mpr = null;
                businessObjectId = request.getParameter("businessObjectId");
                objectType = request.getParameter("objectType");

                ////////////// attach file///////////
                String docImageFilePath = null;
                String fileType = "";
                String fileTitle = "";
                String fileDesc = "";
                String faceValue = "";
                String configType = "";
                String docDate = "";
//                String arName = request.getParameter("wfTaskName");
//                String enName = request.getParameter("wfTaskNameEn");
//                String taskType = request.getParameter("taskType");
//                department = request.getParameter("department");
                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                userId = loggedUser.getAttribute("userId").toString();
                WebBusinessObject wboMail = (WebBusinessObject) userMgr.getOnSingleKey(userId);
                String userHome = (String) loggedUser.getAttribute("userHome");
                String imageDirPath = getServletContext().getRealPath("/images");
                String userImageDir = imageDirPath + "/" + userHome;
                String randome = UniqueIDGen.getNextID();
                int len = randome.length();
                String randFileName = new String("ran" + randome.substring(5, len) + ".jpeg");
                String RIPath = userImageDir + "/" + randFileName;
                userHome = (String) loggedUser.getAttribute("userHome");
                userImageDir = imageDirPath + "/" + userHome;
                String userBackendHome = web_inf_path + "/usr/" + userHome + "/";
                File usrDir = new File(userBackendHome);
                String[] usrDirContents = usrDir.list();
                DocViewerFileRenamePolicy ourPolicy = new DocViewerFileRenamePolicy();
                String fileExtension = request.getParameter("fileExtension");
                wFTaskMgr = WFTaskMgr.getInstance();
//                    wfTaskWbo = wFTaskMgr.getOnSingleKey(request.getParameter("wfTaskId"));
                if (!fileExtension.equalsIgnoreCase("noFiles")) {
                    WebBusinessObject fileDescriptor = fileMgr.getObjectFromCash(fileExtension);
                    if (fileDescriptor != null && !fileDescriptor.equals("")) {
                        String metaType = (String) fileDescriptor.getAttribute("metaType");
                        ourPolicy.setDesiredFileExt(fileExtension);
                        File oldFile = new File(userBackendHome + ourPolicy.getFileName());
                        oldFile.delete();
                    } else {
                        loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                        wFTaskMgr.setUser(loggedUser);
                        //                userWbo = userMgr.getOnSingleKey(wfTaskWbo.getAttribute("createdBy").toString());
                        //                wfTaskWbo.setAttribute("userName", userWbo.getAttribute("userName"));
                        Vector users = userMgr.getCashedTable();
                        ArrayList usersArr = new ArrayList();
                        for (int i = 0; i < users.size(); i++) {
                            usersArr.add(users.get(i));
                        }

                        request.setAttribute("users", usersArr);
                        request.setAttribute("errorTypeFile", "errorTypeFile");
                        request.setAttribute("status", "fail");
//                            request.setAttribute("wfTaskWbo", wfTaskWbo);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                    }
                }
                try {
                    mpr = new MultipartRequest(request, userBackendHome, 5 * 1024 * 1024, "UTF-8", ourPolicy);
                } catch (IncorrectFileType ex) {
                    Logger.getLogger(WFTaskServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                if (!fileExtension.equalsIgnoreCase("noFiles")) {
                    File newFile = new File(userBackendHome + ourPolicy.getFileName());
                    //                if(newFile.exists()) {
                    usrDir = new File(userBackendHome);
                    usrDirContents = usrDir.list();
                    docImageFilePath = userBackendHome + ourPolicy.getFileName();
                    FileIO.copyFile(docImageFilePath, userImageDir + "\\" + ourPolicy.getFileName());
                }
                fileType = fileExtension;
                fileTitle = mpr.getParameter("docTitle");
                fileDesc = mpr.getParameter("description");
                faceValue = mpr.getParameter("faceValue");
                configType = mpr.getParameter("configType");
                docDate = mpr.getParameter("docDate");
                /**
                 * ******** End File Data ************
                 */
                /////////////// End Attached //////
                userWbo = (WebBusinessObject) session.getAttribute("loggedUser");
                wFTaskMgr = WFTaskMgr.getInstance();


                WebBusinessObject ticketWBO = new WebBusinessObject();

                notes = mpr.getParameter("notes");
                String reviewToId = (String) ticketWBO.getAttribute("createdBy");

                date = mpr.getParameter("date").split("/");
                int eYear = Integer.parseInt(date[2]);
                int eMonth = Integer.parseInt(date[0]);
                int eDay = Integer.parseInt(date[1]);
                dateStr = new java.sql.Date(eYear - 1900, eMonth - 1, eDay);
                wfTaskWbo.setAttribute("notes", notes);
                wfTaskWbo.setAttribute("date", dateStr);
                wfTaskWbo.setAttribute("userId", userWbo.getAttribute("userId").toString());
                wfTaskWbo.setAttribute("businessObjectId", businessObjectId);
                wfTaskWbo.setAttribute("objectType", objectType);
                wfTaskWbo.setAttribute("reviewToId", "");
                wfTaskWbo.setAttribute("qualifcationID", mpr.getParameter("QualificationType"));
                wfTaskWbo.setAttribute("showCustomer", "yes");

                wFTaskMgr = WFTaskMgr.getInstance();
                wfTaskId = "";
                wfTaskVisitId = "";
                try {
                    if (wFTaskVisitMgr.getUpdateTicket(wfTaskWbo, session)) {
                        Vector vecUsers = new Vector();
                        WebBusinessObject clientWbo = null;

                        if (metaMgr.getSendMail().toString().equals("1") && wboMail.getAttribute("canSendEmail").toString().equals("1")) {
                            if (mpr.getParameter("notify") != null || !mpr.getParameter("notify").equals("noUsers")) {
                                if (mpr.getParameter("notify").equals("all")) {
                                    vecUsers = UserMgr.getInstance().getCashedTable();
                                } else if (mpr.getParameter("notify").equals("aUser")) {
                                    if (mpr.getParameterValues("notifyUser") != null) {
                                        String[] mailId = mpr.getParameterValues("notifyUser");
                                        for (int x = 0; x < mailId.length; x++) {
                                            vecUsers.add(UserMgr.getInstance().getOnSingleKey(mailId[x]));
                                        }
                                    }
                                }
                                EmailSender emailSender = new EmailSender();
                                userWbo = (WebBusinessObject) session.getAttribute("loggedUser");
                                clientWbo = clientMgr.getOnSingleKey(request.getParameter("businessObjectId"));
                                emailSender.sendEmail(businessObjectId, vecUsers, userWbo, "opened");
                            }
                        }
                        request.setAttribute("status", "ok");
                        ///////// Save Attached File //////
                        if (!fileExtension.equalsIgnoreCase("noFiles")) {
                            //refer to no documents
                            WebBusinessObject docData = new WebBusinessObject();
                            docData.setAttribute("fileExtension", fileExtension);
                            docData.setAttribute("docType", fileExtension);
                            docData.setAttribute("description", notes);
                            docData.setAttribute("docTitle", fileTitle);
                            docData.setAttribute("configType", configType);
                            docData.setAttribute("faceValue", faceValue);
                            docData.setAttribute("docDate", docDate);
                            docData.setAttribute("businessObjectId", request.getParameter("businessObjectId"));
                            docData.setAttribute("objectType", objectType);

//                                docData.setAttribute("taskVisitId", wFTaskMgr.getWFTaskVisitId());
                            wFTaskDocMgr = new WFTaskDocMgr();
                            int numFiles = usrDirContents.length;
                            boolean result = wFTaskDocMgr.saveDocument(docData, session, docImageFilePath);
                            if (result) {
                                request.setAttribute("status", "ok");
                            } else {
                                request.setAttribute("status", "Database error: please contact administrator");
                            }
                        }
                        //////// End Save//////////////
                    } else {
                        request.setAttribute("status", "fail");
                    }
                } catch (NoUserInSessionException ex) {
                    ex.printStackTrace();
                }

                this.forward("WFTaskServlet?op=getAddCommentForm", request, response);
                break;

            case 15:

                servedPage = "/docs/Selective/select_task_comments.jsp";

                Tools.getTaskComments(request, 1);

                businessObjectId = request.getParameter("businessObjectId");
                objectType = request.getParameter("objectType");

                request.setAttribute("Index", request.getParameter("Index"));
                request.setAttribute("businessObjectId", businessObjectId);
                request.setAttribute("objectType", objectType);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 16:
                wfTaskWbo = new WebBusinessObject();
                wFTaskMgr = WFTaskMgr.getInstance();
                userMgr = UserMgr.getInstance();
                ArrayList userList_ = userMgr.getUserList();
                servedPage = "/docs/WorkFlowTasks/add_wfTask_by_login.jsp";
                String businessObjectId_ = request.getParameter("businessObjectId");
                String objectType_ = request.getParameter("objectType");

//                ticketCode = wfTaskWbo.getAttribute("code").toString();

                request.setAttribute("state", "clarify");
                request.setAttribute("businessObjectId", businessObjectId_);
                request.setAttribute("objectType", objectType_);
                request.setAttribute("userList", userList_);
                request.setAttribute("page", servedPage);
//                this.forward(servedPage, request, response);
                this.forwardToServedPage(request, response);
                break;
                

            default:
                System.out.println("No operation was matched");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    public String getServletInfo() {
        return "Search Servlet";
    }

    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("GetWFTaskForm")) {
            return 1;
        }
        if (opName.equalsIgnoreCase("saveWFTask")) {
            return 2;
        }
        if (opName.equalsIgnoreCase("lisWFTasks")) {
            return 3;
        }
        if (opName.equalsIgnoreCase("updatewfTask")) {
            return 4;
        }
        if (opName.equalsIgnoreCase("viewWFTask")) {
            return 5;
        }
        if (opName.equalsIgnoreCase("GetWFTaskUpdate")) {
            return 6;
        }
        if (opName.equalsIgnoreCase("deletewfTask")) {
            return 7;
        }
        if (opName.equalsIgnoreCase("GetAddNotesForm")) {
            return 8;
        }
        if (opName.equalsIgnoreCase("saveWFTaskNotes")) {
            return 9;
        }
        if (opName.equalsIgnoreCase("listwfTaskNotes")) {
            return 10;
        }
        if (opName.equalsIgnoreCase("getCloseWFTaskForm")) {
            return 11;
        }
        if (opName.equalsIgnoreCase("changeWFTaskStatus")) {
            return 12;
        }
        if (opName.equalsIgnoreCase("getAddCommentForm")) {
            return 13;
        }
        if (opName.equalsIgnoreCase("addComment")) {
            return 14;
        }
        if (opName.equalsIgnoreCase("listComments")) {
            return 15;
        }
        if (opName.equalsIgnoreCase("getAddCommentFormPopup")) {
            return 16;
        }
        return 0;
    }
}
