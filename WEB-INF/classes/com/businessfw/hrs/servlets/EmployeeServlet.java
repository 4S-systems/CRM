package com.businessfw.hrs.servlets;

import com.android.business_objects.LiteWebBusinessObject;
import com.android.exceptions.LiteUnsupportedTypeException;
import com.businessfw.fin.db_access.ChannelsExpenseMgr;
import com.businessfw.hrs.db_access.EmployeeLoginMgr;
import com.businessfw.hrs.db_access.EmployeeProfileMgr;
import com.businessfw.hrs.db_access.EmployeeMgr;
import com.businessfw.hrs.db_access.EmployeeSalaryConfigMgr;
import com.clients.db_access.ClientMgr;
import com.docviewer.servlets.DocViewerFileRenamePolicy;
import com.silkworm.servlets.MultipartRequest;
import java.io.*;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.*;
import javax.servlet.http.*;

import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.Exceptions.*;

import com.maintenance.db_access.*;

import com.contractor.db_access.MaintainableMgr;
import com.crm.common.CRMConstants;
import com.crm.common.PDFTools;
import com.crm.servlets.CalendarServlet;
import com.docviewer.servlets.ImageHandlerServlet;
import com.financials.db_access.ExpenseItemMgr;
import com.maintenance.common.Tools;
import com.maintenance.common.UserDepartmentConfigMgr;
import com.silkworm.common.EmpRelationMgr;
import com.silkworm.common.UserMgr;
import com.silkworm.db_access.PersistentSessionMgr;
import com.silkworm.logger.db_access.LoggerMgr;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.uploader.FileMeta;
import com.silkworm.uploader.MultipartRequestHandler;
import com.tracker.db_access.CampaignMgr;
import com.tracker.db_access.DepartmentMgr;
import com.tracker.db_access.IssueStatusMgr;
import com.tracker.db_access.ProjectMgr;
import com.tracker.servlets.CampaignServlet;
import com.tracker.servlets.SearchServlet;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import javax.servlet.annotation.MultipartConfig;

@MultipartConfig
public class EmployeeServlet extends ImageHandlerServlet {

    MaintainableMgr unit = MaintainableMgr.getInstance();
    ItemCatsMgr itemCatsMgr = ItemCatsMgr.getInstance();
    CategoryMgr categoryMgr = CategoryMgr.getInstance();
    ItemMgr itemMgr = ItemMgr.getInstance();
    EmployeeMgr employeeMgr = EmployeeMgr.getInstance();
    LoggerMgr loggerMgr = LoggerMgr.getInstance();
    WebBusinessObject loggerWbo = new WebBusinessObject();
    String op = null;
    String categoryId = null;
    Vector unitsList = null;
    ArrayList unitArr;
    ArrayList itemCategory;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    @Override
    public void destroy() {
    }

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        UserMgr userMgr = UserMgr.getInstance();
        PrintWriter out;
        operation = getOpCode(request.getParameter("op"));

        String remoteAccess = session.getId();
        WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);
        switch (operation) {
            case 1:
                servedPage = "/docs/Adminstration/new_Employee.jsp";

                try {
                    request.setAttribute("workType", ProjectMgr.getInstance().getOnArbitraryKey2("EMPCLAS", "key4"));
                    request.setAttribute("depratments", ProjectMgr.getInstance().getOnArbitraryKey2("div", "key4"));
                } catch (Exception ex) {
                    System.out.println("Getting work type exception:" + ex.getMessage());
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 2:
                servedPage = "/docs/Adminstration/new_Employee.jsp";

                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");

                LiteWebBusinessObject employee = new LiteWebBusinessObject();
                LiteWebBusinessObject statusWbo = new LiteWebBusinessObject();

                Calendar c = Calendar.getInstance();
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");

//                File oldFile = new File(userBackendHome + ourPolicy.getFileName());
//                oldFile.delete();
//                try {
//                    mpr = new MultipartRequest(request, userBackendHome, (5 * 1024 * 1024), "UTF-8", ourPolicy);
//
//                } catch (IncorrectFileType e) {
//                }
                String employeeID = request.getParameter("empID");

                try {
                    employee.setAttribute("empID", employeeID);
                    employee.setAttribute("empNO", request.getParameter("empNO"));
                    employee.setAttribute("empName", request.getParameter("empName"));
                    employee.setAttribute("Address", request.getParameter("Address"));
                    employee.setAttribute("mobile", request.getParameter("mobile"));
                    employee.setAttribute("Email", request.getParameter("Email"));
                    employee.setAttribute("Note", request.getParameter("Note"));
                    employee.setAttribute("gender", request.getParameter("gender"));
                    employee.setAttribute("matiralStatus", request.getParameter("matiralStatus"));
                    employee.setAttribute("workingType", request.getParameter("workingType"));
                    employee.setAttribute("empSocialNO", request.getParameter("empSocialNO"));
                    employee.setAttribute("empSalary", request.getParameter("emp_salary"));
                    employee.setAttribute("department", request.getParameter("depts"));
                    employee.setAttribute("education", request.getParameter("education"));
                    employee.setAttribute("workType", request.getParameter("workType"));
                    employee.setAttribute("birthDate", request.getParameter("birthDate"));
                    if (request.getParameter("gender").equals("ذكر")) {
                        employee.setAttribute("melatryStatus", request.getParameter("melatryStatus"));
                    } else {
                        employee.setAttribute("melatryStatus", "لا يوجد");
                    }

                    employee.setAttribute("beginWorkFrom", request.getParameter("beginWorkFrom"));
                    employee.setAttribute("empInsuranceNO", request.getParameter("empInsuranceNO"));

                    String newStatusCode = request.getParameter("newStatus");

                    statusWbo.setAttribute("statusCode", newStatusCode);
                    statusWbo.setAttribute("date", sdf.format(c.getTime()));
                    statusWbo.setAttribute("businessObjectId", employeeID);
                    statusWbo.setAttribute("statusNote", "UL");
                    statusWbo.setAttribute("objectType", "employee");
                    statusWbo.setAttribute("parentId", "UL");
                    statusWbo.setAttribute("issueTitle", "UL");
                    statusWbo.setAttribute("cuseDescription", "UL");
                    statusWbo.setAttribute("actionTaken", "UL");
                    statusWbo.setAttribute("preventionTaken", "UL");

                    IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
                    if (employeeMgr.saveEmp(employee, session)) {
                        try {
                            if (issueStatusMgr.changeStatus1(statusWbo, persistentUser, null)) {
                                request.setAttribute("Status", "Ok");
                            }
                        } catch (SQLException ex) {
                            Logger.getLogger(EmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    } else {
                        request.setAttribute("Status", "No");
                    }

                    String imageName = request.getParameter("imageName");
                    if (imageName != null) {
                        IssueDocumentMgr documentMgr = IssueDocumentMgr.getInstance();
                        List<FileMeta> files = MultipartRequestHandler.uploadByJavaServletAPI(request);
                        documentMgr.saveDocuments(files, employeeID, request.getParameter("configType"),
                                (String) loggedUser.getAttribute("userId"), request.getParameter("docType"));
                    }
                } catch (NoUserInSessionException noUser) {
                    request.setAttribute("Status", "No");
                    logger.error("Place Servlet: save place " + noUser);
                } catch (Exception ex) {
                    request.setAttribute("Status", "No");
                    logger.error("Place Servlet: save place " + ex.getMessage());
                }

                try {
                    request.setAttribute("workType", ProjectMgr.getInstance().getOnArbitraryKey2("EMPCLAS", "key4"));
                    request.setAttribute("depratments", ProjectMgr.getInstance().getOnArbitraryKey2("div", "key4"));
                } catch (Exception ex) {
                    System.out.println("Getting work type exception:" + ex.getMessage());
                }

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 3:
                Vector Employees = new Vector();

                 {
                    try {
                        Employees = employeeMgr.getAllItems();
                    } catch (LiteUnsupportedTypeException ex) {
                        Logger.getLogger(EmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                servedPage = "/docs/Adminstration/Employee_List.jsp";

                request.setAttribute("data", Employees);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 4:
                String employeeId = null;

                try {
                    employeeId = request.getParameter("empId");
                    if (employeeId == null) {
                        employeeId = (String) request.getAttribute("empId");
                    }

                    LiteWebBusinessObject empWbo = employeeMgr.getOnSingleKey(employeeId);

                    request.setAttribute("employeeWbo", empWbo);
                } catch (Exception ex) {
                    logger.error(ex);
                }

                servedPage = "/docs/Adminstration/view_Employee.jsp";

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
//                String employeeId = null;
//                servedPage = "/docs/Adminstration/view_Employee.jsp";
//                employeeId = request.getParameter("employeeId");
//                departmentId = request.getParameter("departmentId");
//                employee = employeeMgr.getOnSingleKey(employeeId);
//                //
//                EmployeeDocMgr employeeDocMgr = EmployeeDocMgr.getInstance();
//                Vector imageList = employeeDocMgr.getImagesList(employeeId);
//                Vector imagesPath = new Vector();
//                for (int i = 0; i < imageList.size(); i++) {
//                    randome = UniqueIDGen.getNextID();
//                    len = randome.length();
//                    String docID = ((WebBusinessObject) imageList.get(i)).getAttribute("docID").toString();
//                    randFileName = new String("ran" + randome.substring(5, len) + ".jpeg");
//                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
//                    userHome = (String) loggedUser.getAttribute("userHome");
//                    imageDirPath = getServletContext().getRealPath("/images");
//                    userImageDir = imageDirPath + "/" + userHome;
//
//                    RIPath = userImageDir + "/" + randFileName;
//
//                    String absPath = "images/" + userHome + "/" + randFileName;
//
//                    File docImage = new File(RIPath);
//
//                    BufferedInputStream gifData = new BufferedInputStream(employeeDocMgr.getImage(docID));
//                    BufferedImage myImage = ImageIO.read(gifData);
//                    ImageIO.write(myImage, "jpeg", docImage);
//                    imagesPath.add(absPath);
//                }
//                request.setAttribute("imagePath", imagesPath);
//                //
//                request.setAttribute("departmentId", departmentId);
//                request.setAttribute("employee", employee);
//                request.setAttribute("page", servedPage);
//                this.forwardToServedPage(request, response);

                break;

            case 5:
//                departmentId = request.getParameter("departmentId");
//                employeeId = request.getParameter("employeeId");
//                employee = employeeMgr.getOnSingleKey(employeeId);
//
//                servedPage = "/docs/Adminstration/update_Employee.jsp";
//
//                request.setAttribute("employee", employee);
//                request.setAttribute("employeeId", employeeId);
//                request.setAttribute("departmentId", departmentId);
//                request.setAttribute("page", servedPage);
//                this.forwardToServedPage(request, response);
                break;

            case 6:
                servedPage = "/docs/Adminstration/update_Employee.jsp";

                LiteWebBusinessObject empWBO = EmployeeMgr.getInstance().getOnSingleKey(request.getParameter("empId"));
                request.setAttribute("empWBO", empWBO);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
//
//                if (null != request.getParameter("isActive")) {
//                    active = "1";
//                } else {
//                    active = "0";
//                }
//
//                if (request.getParameter("overTime2") != "") {
//                    overtime2 = request.getParameter("overTime2");
//                } else {
//                    overtime2 = "0";
//                }
//
//                if (request.getParameter("overTime3") != "") {
//                    overtime3 = request.getParameter("overTime3");
//                } else {
//                    overtime3 = "0";
//                }
//
//                employee = new WebBusinessObject();
//
//                departmentId = employeeMgr.getDepartmentId(request.getParameter("departmentName").toString());
//                employee.setAttribute("empNO", request.getParameter("empNO").toString());
//                employee.setAttribute("empName", request.getParameter("empName").toString());
//                employee.setAttribute("Address", request.getParameter("Address").toString());
//                employee.setAttribute("Designation", request.getParameter("Designation").toString());
//                employee.setAttribute("workPhone", request.getParameter("workPhone").toString());
//                employee.setAttribute("Extension", request.getParameter("Extension").toString());
//                employee.setAttribute("homePhone", request.getParameter("homePhone").toString());
//                employee.setAttribute("fax", request.getParameter("fax").toString());
//                employee.setAttribute("Email", request.getParameter("Email").toString());
//                employee.setAttribute("departmentName", departmentId);
//                employee.setAttribute("houreSalary", request.getParameter("houreSalary").toString());
//                employee.setAttribute("overTime1", request.getParameter("overTime1").toString());
//                employee.setAttribute("overTime2", overtime2);
//                employee.setAttribute("overTime3", overtime3);
//                employee.setAttribute("Note", request.getParameter("Note").toString());
//                employee.setAttribute("isActive", active);
//                employee.setAttribute("employeeId", request.getParameter("employeeId").toString());
//
//                if (employeeMgr.updateEmployee(employee)) {
//                    request.setAttribute("Status", "Ok");
//                } else {
//                    request.setAttribute("Status", "No");
//
//                }
//
//                employee = employeeMgr.getOnSingleKey(request.getParameter("employeeId"));
//                request.setAttribute("employee", employee);
//                request.setAttribute("departmentId", departmentId);
                break;

            case 7:
//                String employeeName = request.getParameter("employeeName");
//                employeeId = request.getParameter("employeeId");
//
//                employeeName = Tools.getRealChar(employeeName);
//
//                servedPage = "/docs/Adminstration/confirm_delEmployee.jsp";
//                request.setAttribute("employeeName", employeeName);
//                request.setAttribute("canDelete", employeeMgr.canDelete(employeeId));
//                request.setAttribute("employeeId", employeeId);
//                request.setAttribute("page", servedPage);
//                this.forwardToServedPage(request, response);
                break;

            case 8:
                loggerWbo = new WebBusinessObject();
                fillLoggerWbo(request, loggerWbo);
                if (employeeMgr.deleteOnSingleKey(request.getParameter("employeeId"))) {
                    try {
                        loggerMgr.saveObject(loggerWbo);
                    } catch (SQLException ex) {
                        Logger.getLogger(EmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                Employees = employeeMgr.getCashedTable();
                servedPage = "/docs/Adminstration/Employee_List.jsp";

                request.setAttribute("data", Employees);
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);

                break;

            case 9:
                employeeMgr = EmployeeMgr.getInstance();
                String responseString = employeeMgr.getAllEmployeeNames();
                if (responseString != null) {
                    response.setContentType("text/xml");
                    response.setHeader("Cache-Control", "no-cache");
                    response.getWriter().write(responseString);
                } else {
                    // If key comes back as a null, return a question mark.
                    response.setContentType("text/xml");
                    response.setHeader("Cache-Control", "no-cache");
                    response.getWriter().write("?");
                }
                break;

            case 10:
                String mgrCode = request.getParameter("managerID");
                boolean deleted = employeeMgr.disJoinMgr(mgrCode);

                response.getWriter().write(String.valueOf(deleted));
                break;

            case 11:
                String key = request.getParameter("empID");
                // delete from two tables
                boolean deleted1 = userMgr.deleteOnSingleKey(key);
                boolean deleted2 = employeeMgr.disJoinEmp(key);

                if (deleted1 == true && deleted2 == true) {
                    response.getWriter().write(String.valueOf(true));
                } else {
                    response.getWriter().write(String.valueOf(false));
                }
                break;

            case 12:
                servedPage = "/show_employee_names_by_managerCode.jsp";
                key = request.getParameter("managerID");
                ArrayList<LiteWebBusinessObject> arrayOfEmployeesUnderManager = employeeMgr.getEmployeeByManagerCode(key);

                request.setAttribute("employees", arrayOfEmployeesUnderManager);
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;
            case 13:
                servedPage = "/docs/user_security/manage_user_manager.jsp";
                try {
                    request.setAttribute("managersList", new ArrayList<>(userMgr.getOnArbitraryKeyOracle("1", "key2"))); // get all managers
                } catch (Exception ex) {
                    Logger.getLogger(EmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("page", request.getParameter("page"));
                request.setAttribute("userID", request.getParameter("userID"));
                this.forward(servedPage, request, response);
                break;
            case 14:
                out = response.getWriter();
                WebBusinessObject wbo = new WebBusinessObject();
                String userID = request.getParameter("userID");
                String managerID = request.getParameter("managerID");
                wbo.setAttribute("status", "fail");
                if (managerID != null) {
                    if (DistributionListMgr.getInstance().changeUserManager(managerID, userID)) {
                        wbo.setAttribute("status", "ok");
                    }
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 15:
                out = response.getWriter();
                LiteWebBusinessObject liteWbo = new LiteWebBusinessObject();
                WebBusinessObject data = new WebBusinessObject();
                String empNumber = request.getParameter("empNumber");
                liteWbo = EmployeeMgr.getInstance().getOnSingleKey("key2", empNumber);

                if (liteWbo != null) {
                    data.setAttribute("status", "Ok");
                } else {
                    data.setAttribute("status", "No");
                }

                out.write(Tools.getJSONObjectAsString(data));

                break;

            case 16:
                servedPage = "/docs/Adminstration/employee_communications.jsp";
                String empId = request.getParameter("empId");
                try {
                    request.setAttribute("emailsList", new ArrayList<LiteWebBusinessObject>());
                    request.setAttribute("phonesList", new ArrayList<LiteWebBusinessObject>());
                    request.setAttribute("EmployeeWbo", employeeMgr.getOnSingleKey(empId));
                } catch (Exception ex) {
                    Logger.getLogger(ex.getMessage());
                }

                this.forward(servedPage, request, response);
                break;

            case 17:
                servedPage = "/docs/Adminstration/employee_education.jsp";
                empId = request.getParameter("empId");
                try {
                    request.setAttribute("educationList", new ArrayList<LiteWebBusinessObject>());
                    request.setAttribute("EmployeeWbo", employeeMgr.getOnSingleKey(empId));
                } catch (Exception ex) {
                    Logger.getLogger(ex.getMessage());
                }

                this.forward(servedPage, request, response);
                break;

            case 18:
                servedPage = "/docs/Adminstration/employee_dates.jsp";
                empId = request.getParameter("empId");
                try {
                    request.setAttribute("datesList", new ArrayList<WebBusinessObject>());
                    request.setAttribute("EmployeeWbo", employeeMgr.getOnSingleKey(empId));
                } catch (Exception ex) {
                    Logger.getLogger(ex.getMessage());
                }

                this.forward(servedPage, request, response);
                break;

            case 19:
                servedPage = "/docs/Adminstration/employee_profile.jsp";
                empId = request.getParameter("empId");
                try {
                    request.setAttribute("profileList", new ArrayList<WebBusinessObject>());
                    request.setAttribute("EmployeeWbo", employeeMgr.getOnSingleKey(empId));
                } catch (Exception ex) {
                    Logger.getLogger(ex.getMessage());
                }

                this.forward(servedPage, request, response);
                break;

            case 20:
                servedPage = "/docs/Adminstration/update_Employee.jsp";

                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");

                employee = new LiteWebBusinessObject();

                try {
                    employee.setAttribute("empID", request.getParameter("empID"));
                    employee.setAttribute("empName", request.getParameter("empName"));
                    employee.setAttribute("Address", request.getParameter("Address"));
                    employee.setAttribute("mobile", request.getParameter("mobile"));
                    employee.setAttribute("Email", request.getParameter("Email"));
                    employee.setAttribute("Note", request.getParameter("Note"));
                    employee.setAttribute("gender", request.getParameter("gender"));
                    employee.setAttribute("matiralStatus", request.getParameter("matiralStatus"));
                    employee.setAttribute("workingType", request.getParameter("workingType"));

                    if (employeeMgr.updateEmp(employee, session)) {
                        request.setAttribute("Status", "Ok");
                    } else {
                        request.setAttribute("Status", "No");
                    }
                } catch (NoUserInSessionException noUser) {
                    request.setAttribute("Status", "No");
                    logger.error("Place Servlet: save place " + noUser);
                }

                empWBO = EmployeeMgr.getInstance().getOnSingleKey(request.getParameter("empID"));
                request.setAttribute("empWBO", empWBO);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 21:
                servedPage = "/docs/EmpReqs/holidayRequest.jsp";
                ProjectMgr projectMgr = ProjectMgr.getInstance();
                ArrayList<WebBusinessObject> reqTypLst = new ArrayList<WebBusinessObject>();
                 {
                    try {
                        reqTypLst = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("ERQ", "key4"));
                    } catch (Exception ex) {
                        Logger.getLogger(EmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }

                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                String empID = request.getParameter("empID") != null && !request.getParameter("empID").equalsIgnoreCase("null") ? request.getParameter("empID") : (String) loggedUser.getAttribute("userId");
                request.setAttribute("empID", empID);
                request.setAttribute("reqTypLst", reqTypLst);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 22:
                String fDate = request.getParameter("fDate");
                String tDate = request.getParameter("tDate");
                String notes = request.getParameter("notes");
                String reqTyp = request.getParameter("reqTyp");
                empID = request.getParameter("empID");

                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");

                projectMgr = ProjectMgr.getInstance();
                /*WebBusinessObject reqTypWbo = new WebBusinessObject();
                try {
                    if(reqTyp != null && reqTyp.equalsIgnoreCase("Choliday")){
                        reqTypWbo = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("CASUALH", "key3")).get(0);
                    } else if(reqTyp != null && reqTyp.equalsIgnoreCase("Sholiday")){
                        reqTypWbo = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("STANDARDH", "key3")).get(0);
                    } else if(reqTyp != null && reqTyp.equalsIgnoreCase("per")){
                        reqTypWbo = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("EDEP", "key3")).get(0);
                    } else if(reqTyp != null && reqTyp.equalsIgnoreCase("half")){
                        reqTypWbo = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("LATT", "key3")).get(0);
                    }
                } catch (Exception ex) {
                    Logger.getLogger(EmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                }*/
                wbo = new WebBusinessObject();

                EmployeeMgr employeeMgr = EmployeeMgr.getInstance();
                 {
                    try {
                        boolean reslut = employeeMgr.saveEmpReq(reqTyp, fDate, tDate, notes, session, empID);
                        if (reslut) {
                            wbo.setAttribute("status", "OK");
                        } else {
                            wbo.setAttribute("status", "NO");
                        }
                    } catch (NoUserInSessionException ex) {
                        Logger.getLogger(EmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 23:
                servedPage = "/docs/Adminstration/emp_profile.jsp";
                DepartmentMgr deptMgr = DepartmentMgr.getInstance();
                employeeMgr = EmployeeMgr.getInstance();
                ArrayList depts = new ArrayList();
                empID = request.getParameter("businessObjectId");
                WebBusinessObject empProfileWbo = new WebBusinessObject();
                empProfileWbo = employeeMgr.getEmployeeProfile(empID);
                depts = DepartmentMgr.getInstance().getCashedTableAsBusObjects();

                request.setAttribute("empProfileWbo", empProfileWbo);
                request.setAttribute("deptsList", depts);
                request.setAttribute("empID", request.getParameter("businessObjectId"));
                this.forward(servedPage, request, response);
                break;

            case 24:
                out = response.getWriter();

                wbo = new WebBusinessObject();
                WebBusinessObject empProfile = new WebBusinessObject();

                try {
                    empProfile.setAttribute("profID", request.getParameter("profID"));
                    empProfile.setAttribute("empID", request.getParameter("empID"));
                    empProfile.setAttribute("deptID", request.getParameter("depts"));
                    empProfile.setAttribute("vacationNo", request.getParameter("vacationsNo"));
                    empProfile.setAttribute("tempVacationsNo", request.getParameter("tempVacationsNo"));
                    empProfile.setAttribute("tempLeavesNo", request.getParameter("tempLeaveNo"));
                    empProfile.setAttribute("WorkingHours", request.getParameter("workingHours"));
                    empProfile.setAttribute("workType", request.getParameter("empStatus"));
                    empProfile.setAttribute("salary", request.getParameter("salary"));

                    if (EmployeeProfileMgr.getInstance().saveEmpProfile(empProfile, session)) {
                        wbo.setAttribute("status", "OK");
                    } else {
                        wbo.setAttribute("status", "No");
                    }
                } catch (Exception ex) {
                    wbo.setAttribute("status", "No");
                }

                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 25:
                String parentSites = request.getParameter("clientId");
                String branchID = request.getParameter("branchID");
                String fcltyID = request.getParameter("fcltyID");
                projectMgr = ProjectMgr.getInstance();
                String json = new String();
                ClientMgr clientMgr = ClientMgr.getInstance();
                ArrayList clientsList = new ArrayList<>();
                employeeMgr = EmployeeMgr.getInstance();

                if (branchID != null && !branchID.equals("") && request.getParameter("gtFclt") == null && request.getParameter("myOp") == null) {
                    ArrayList clientsLst = new ArrayList<>();
                    String prjID = null;
                    ArrayList projectList = new ArrayList<>();
                    String prjIDRes = request.getParameter("prjIDRes");

                    try {
                        clientsLst = projectMgr.getAllCliensForBranch(branchID);
                    } catch (Exception ex) {
                        java.util.logging.Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    out = response.getWriter();
                    out.write(Tools.getJSONArrayAsString(clientsLst));
                } else if (parentSites != null && !parentSites.equals("") && request.getParameter("gtFclt") == null && request.getParameter("myOp") == null) {
                    ArrayList projectLst = new ArrayList<>();
                    String prjID = null;
                    ArrayList projectList = new ArrayList<>();
                    String prjIDRes = request.getParameter("prjIDRes");

                    try {
                        projectLst = projectMgr.getAllProjectForClient(parentSites);
                    } catch (Exception ex) {
                        java.util.logging.Logger.getLogger(SearchServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    out = response.getWriter();
                    out.write(Tools.getJSONArrayAsString(projectLst));
                } else if (request.getParameter("gtFclt") != null && ((request.getParameter("gtFclt")).toString()).equals("1")) {
                    parentSites = request.getParameter("clientId");
                    fcltyID = request.getParameter("fcltyID");
                    branchID = request.getParameter("branchID");
                    ArrayList<WebBusinessObject> fcltyWrkrLst = (ArrayList<WebBusinessObject>) projectMgr.getFcltyWrkrLst(parentSites, fcltyID, branchID);

                    out = response.getWriter();
                    out.write(Tools.getJSONArrayAsString(fcltyWrkrLst));
                } else if (request.getParameter("myOp") != null && request.getParameter("myOp").equals("de")) {
                    wbo = new WebBusinessObject();
                    String row_id = request.getParameter("id");
                    String comment = request.getParameter("comment");
                    String reason = request.getParameter("reason");

                    projectMgr = ProjectMgr.getInstance();
                    boolean isdel = projectMgr.delfacilityworker(row_id, comment, reason);
                    WebBusinessObject status1 = new WebBusinessObject();
                    if (isdel) {
                        status1.setAttribute("status", "ok");
                    } else {
                        status1.setAttribute("status", "no");
                    }
                    out = response.getWriter();
                    json = Tools.getJSONObjectAsString(status1);
                    out.write(json);
                } else if (request.getParameter("myOp") != null && request.getParameter("myOp").equals("upBranch")) {
                    parentSites = request.getParameter("clientId");
                    String branchId = request.getParameter("branchId");

                    request.setAttribute("clientId", parentSites);
                    request.setAttribute("branchId", branchId);

                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    String loggegUserId = (String) loggedUser.getAttribute("userId");

                    wbo = new WebBusinessObject();
                    String row_id = request.getParameter("id");
                    String branch = request.getParameter("bbrr");
                    String Wid = request.getParameter("Wid");
                    String Rid = request.getParameter("Rid");
                    String Sid = request.getParameter("Sid");

                    projectMgr = ProjectMgr.getInstance();
                    boolean isupdate = projectMgr.updateFacilityWorkers(branch, null, row_id, Wid, Rid, Sid, loggegUserId);

                } else if (request.getParameter("myOp") != null && request.getParameter("myOp").equals("upShift")) {
                    parentSites = request.getParameter("clientId");
                    String branchId = request.getParameter("branchId");

                    request.setAttribute("clientId", parentSites);
                    request.setAttribute("branchId", branchId);

                    wbo = new WebBusinessObject();
                    String row_id = request.getParameter("id");
                    String shift = request.getParameter("bbrr");

                    projectMgr = ProjectMgr.getInstance();
                    boolean isupdate = projectMgr.updateFacilityWorkers(null, shift, row_id, null, null, null, null);

                } else {
                    if (fcltyID != null && !fcltyID.equals("") && request.getParameter("wrkrID") != null) {
                        WebBusinessObject fcltyConfg = new WebBusinessObject();

                        loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                        String loggegUserId = (String) loggedUser.getAttribute("userId");

                        String wrkrID[] = ((request.getParameter("wrkrID")).toString()).split(",");
                        String wrkrSft[] = ((request.getParameter("wrkrSft")).toString()).split(",");
                        String wrkrRmrk[] = ((request.getParameter("wrkrRmrk")).toString()).split(",");
                        //String wrkrRt[] = ((request.getParameter("wrkrRt")).toString()).split(",");

                        for (int i = 0; i < wrkrID.length; i++) {
                            fcltyConfg = new WebBusinessObject();
                            fcltyConfg.setAttribute("fcltyID", fcltyID);
                            fcltyConfg.setAttribute("wrkrID", wrkrID[i]);
                            fcltyConfg.setAttribute("wrkrSft", wrkrSft[i]);
                            fcltyConfg.setAttribute("wrkrRmrk", wrkrRmrk[i]);
                            //fcltyConfg.setAttribute("wrkrRt", wrkrRt[i]);

                            try {
                                if (clientMgr.addFcltyConfg(fcltyConfg, loggegUserId)) {
                                    request.setAttribute("afc", "1");
                                } else {
                                    request.setAttribute("afc", "0");
                                    break;
                                }
                            } catch (NoUserInSessionException ex) {
                                Logger.getLogger(EmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                            }
                        }
                    }
                    servedPage = "/docs/facilitytManagement/projectEmpAss.jsp";

                    try {
                        clientsList = projectMgr.getOnArbitraryKey2("1523775629309", "key2");
                    } catch (Exception ex) {
                        clientsList = new ArrayList<>();
                    }

                    //ArrayList<WebBusinessObject> wrkrLst = (ArrayList<WebBusinessObject>) projectMgr.getWorkersReport(null);
                    ArrayList<LiteWebBusinessObject> wrkrLst = new ArrayList<LiteWebBusinessObject>();
                    try {
                        wrkrLst = new ArrayList<LiteWebBusinessObject>(employeeMgr.getAllEmployees());
                    } catch (LiteUnsupportedTypeException ex) {
                        Logger.getLogger(EmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    ArrayList<WebBusinessObject> fcltyWrkrLst = (ArrayList<WebBusinessObject>) projectMgr.getFcltyWrkrLst(parentSites, fcltyID, branchID);

                    request.setAttribute("wrkrLst", wrkrLst);
                    request.setAttribute("clientsList", clientsList);
                    request.setAttribute("fcltyWrkrLst", fcltyWrkrLst);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                }
                break;

            case 26:
                BufferedOutputStream output = new BufferedOutputStream(response.getOutputStream());
                employeeID = request.getParameter("employeeID");
                IssueDocumentMgr issueDocumentMgr = IssueDocumentMgr.getInstance();
                try {
                    List<WebBusinessObject> imageList = new ArrayList<>(issueDocumentMgr.getOnArbitraryDoubleKeyOracle(employeeID, "key5",
                            CRMConstants.DOCUMENT_TYPE_PERSONAL_PHOTO_ID, "key4"));
                    boolean personalExists = false;
                    if (!imageList.isEmpty()) {
                        for (WebBusinessObject image : imageList) {
                            if (((String) image.getAttribute("metaType")).contains("image")) {
                                InputStream input = issueDocumentMgr.getImage((String) image.getAttribute("documentID"));
                                try {
                                    byte[] buffer = new byte[8192];
                                    int length = 0;
                                    while ((length = input.read(buffer)) > 0) {
                                        output.write(buffer, 0, length);
                                    }
                                } finally {
                                    if (output != null) {
                                        try {
                                            output.close();
                                        } catch (IOException logOrIgnore) {
                                        }
                                    }
                                    if (input != null) {
                                        try {
                                            input.close();
                                        } catch (IOException logOrIgnore) {
                                        }
                                    }
                                }
                                personalExists = true;
                                break;
                            }
                        }
                    }
                    if (!personalExists) {
                        servletContext = getServletContext();
                        InputStream input = new FileInputStream(servletContext.getRealPath("/") + "/images/unknown-person.jpg");
                        try {
                            byte[] buffer = new byte[8192];
                            int length = 0;
                            while ((length = input.read(buffer)) > 0) {
                                output.write(buffer, 0, length);
                            }
                        } finally {
                            if (output != null) {
                                try {
                                    output.close();
                                } catch (IOException logOrIgnore) {
                                }
                            }
                            if (input != null) {
                                try {
                                    input.close();
                                } catch (IOException logOrIgnore) {
                                }
                            }
                        }
                    }
                } catch (Exception ex) {
                    Logger.getLogger(EmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                break;

            case 27:
                out = response.getWriter();
                out.write(Tools.getJSONArrayAsString(EmployeeMgr.getInstance().getManagerEmployees(request.getParameter("managerID"))));
                break;

            case 28:

                out = response.getWriter();
                statusWbo = new LiteWebBusinessObject();
                LiteWebBusinessObject employeeWbo = new LiteWebBusinessObject();
                statusWbo.setAttribute("status", "faild");
                CampaignMgr campaignMgr = CampaignMgr.getInstance();
                c = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy-MM-dd");
                employeeMgr = EmployeeMgr.getInstance();
                employeeWbo = employeeMgr.getOnSingleKey(request.getParameter("id"));
                if (employeeWbo != null) {
                    //Date fromDate = sdf.parse((String) employeeWbo.getAttribute("fromDate"));
                    //Date toDate = sdf.parse((String) employeeWbo.getAttribute("toDate"));
                    String newStatusCode = request.getParameter("newStatus");
                    String cause_notes = request.getParameter("notes");
                    statusWbo.setAttribute("statusCode", newStatusCode);
                    statusWbo.setAttribute("date", sdf.format(c.getTime()));
                    statusWbo.setAttribute("businessObjectId", request.getParameter("id"));
                    statusWbo.setAttribute("statusNote", cause_notes);
                    statusWbo.setAttribute("objectType", "employee");
                    statusWbo.setAttribute("parentId", "UL");
                    statusWbo.setAttribute("issueTitle", "UL");
                    statusWbo.setAttribute("cuseDescription", "UL");
                    statusWbo.setAttribute("actionTaken", "UL");
                    statusWbo.setAttribute("preventionTaken", "UL");
                    IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
                    try {
                        if (issueStatusMgr.changeStatus1(statusWbo, persistentUser, null)) {
                            statusWbo.setAttribute("status", "Ok");
                            statusWbo.setAttribute("currentStatusName",
                                    campaignMgr.getCampaignStatusName((String) statusWbo.getAttribute("statusCode"), "en"));
                        }
                    } catch (SQLException ex) {
                        Logger.getLogger(CampaignServlet.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (NoSuchColumnException ex) {
                        Logger.getLogger(CampaignServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                out.write(Tools.getJSONObjectAsString(statusWbo));
                break;

            case 29:
                PDFTools pdfTolls = new PDFTools();

                StringBuilder whereClause = new StringBuilder();
                whereClause.append("BUSINESS_OBJ_ID = '" + request.getParameter("empId") + "'");

                HashMap parameters = new HashMap();
                parameters.put("whereClause", whereClause);

                pdfTolls.generatePdfReport("EmployeeSheet", parameters, getServletContext(), response);
                break;

            case 30:
                servedPage = "/docs/Emp_Finance/emp_monthly_salary.jsp";

                try {
                    LiteWebBusinessObject empWbo = EmployeeMgr.getInstance().getOnSingleKey("key2", request.getParameter("empNumber"));

                    request.setAttribute("salaryItems", ExpenseItemMgr.getInstance().getOnArbitraryKey2("Salary", "key1"));
                    request.setAttribute("empNumber", request.getParameter("empNumber"));
                    request.setAttribute("empWbo", empWbo);
                    request.setAttribute("turn", "second");

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                } catch (Exception ex) {
                    System.out.println("Exception ex=" + ex.getMessage());
                }
                break;

            case 31:
                servedPage = "/docs/Adminstration/emp_salary_config.jsp";
                EmployeeSalaryConfigMgr empSalaryConfigMgr = EmployeeSalaryConfigMgr.getInstance();
                request.setAttribute("salaryItems", ExpenseItemMgr.getInstance().getEmployeeExpensItems(request.getParameter("empID")));
                request.setAttribute("empID", request.getParameter("empID"));

                this.forward(servedPage, request, response);
                break;

            case 32:
                servedPage = "/docs/Adminstration/emp_salary_config.jsp";

                empSalaryConfigMgr = EmployeeSalaryConfigMgr.getInstance();

                empID = request.getParameter("empID");
                try {
                    empSalaryConfigMgr.deleteOnArbitraryKey(empID, "key1");
                } catch (Exception ex) {
                    Logger.getLogger(EmployeeServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                String[] salaryItemIdArr = request.getParameter("salaryItemIdArr").split(",");
                String[] salaryItemValue = request.getParameter("salaryItemValue").split(",");
                String[] salaryPersent = request.getParameter("salaryPersent").split(",");
                String[] salaryType = request.getParameter("salaryType").split(",");

                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");

                for (int i = 0; i < salaryItemIdArr.length; i++) {
                    LiteWebBusinessObject salConfig = new LiteWebBusinessObject();
                    salConfig.setAttribute("empID", empID);
                    salConfig.setAttribute("ExpenseItemID", salaryItemIdArr[i]);
                    salConfig.setAttribute("createdBy", (String) loggedUser.getAttribute("userId"));
                    salConfig.setAttribute("configValue", salaryItemValue[i]);
                    salConfig.setAttribute("salaryPersent", salaryPersent[i]);
                    salConfig.setAttribute("salaryType", salaryType[i]);
                    empSalaryConfigMgr.saveEmpSalaryConfig(salConfig);
                }

                request.setAttribute("salaryItems", ExpenseItemMgr.getInstance().getEmployeeExpensItems(empID));
                request.setAttribute("empID", empID);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 33:
                servedPage = "/EmployeeSheet.jsp";
                empID = request.getParameter("empID");

                request.setAttribute("empID", empID);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 34:
                servedPage = "/docs/employee_doc_handling/upload_employee_logins.jsp";
                EmployeeLoginMgr employeeLoginMgr = EmployeeLoginMgr.getInstance();
                String imageName = request.getParameter("imageName");
                if (imageName != null) {
                    List<FileMeta> files = MultipartRequestHandler.uploadByJavaServletAPI(request);
                    if (files != null && !files.isEmpty()) {
                        ArrayList<LiteWebBusinessObject> list = Tools.createWboForEmployeeLoginFromExcel(files.get(0).getContent(), (String) persistentUser.getAttribute("userId"));
                        request.setAttribute("status", employeeLoginMgr.insertEmployeeLogin(list) + "");
                        request.setAttribute("list", list);
                    }
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 35:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                userID = request.getParameter("userID");
                managerID = request.getParameter("managerID");
                wbo.setAttribute("status", "fail");
                if (managerID != null) {
                    if (DistributionListMgr.getInstance().changeUserManagerN(managerID, userID)) {
                        wbo.setAttribute("status", "ok");
                    } else {
                        WebBusinessObject userManagerWbo = new WebBusinessObject();
                        userManagerWbo.setAttribute("firstEmpId", managerID);
                        userManagerWbo.setAttribute("secondEmpId", userID);
                        userManagerWbo.setAttribute("comments", "---");
                        if (EmpRelationMgr.getInstance().upsertEmpRelation(userManagerWbo)) {
                            wbo.setAttribute("status", "ok");
                        }
                    }
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 36:
                servedPage = "/docs/Adminstration/emp_vac_statistic.jsp";

                projectMgr = ProjectMgr.getInstance();

                String selectedDepartment = request.getParameter("departmentID");

                try {
                    UserDepartmentConfigMgr userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                    ArrayList<WebBusinessObject> userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                    ArrayList<WebBusinessObject> departments = new ArrayList<>();

                    for (WebBusinessObject userDepartmentWbo : userDepartments) {
                        departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                    }

                    if (departments.isEmpty()) {
                        WebBusinessObject wboTemp = new WebBusinessObject();
                        wboTemp.setAttribute("projectName", "لا يوجد");
                        wboTemp.setAttribute("projectID", "none");
                        departments.add(wboTemp);
                    } else {
                        if (selectedDepartment == null) {
                            selectedDepartment = (String) departments.get(0).getAttribute("projectID");
                        }
                    }

                    request.setAttribute("departments", departments);
                } catch (Exception ex) {
                    Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("departmentID", selectedDepartment);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 37:
                servedPage = "/docs/Adminstration/emp_vac_statistic.jsp";

                projectMgr = ProjectMgr.getInstance();
                employeeMgr = EmployeeMgr.getInstance();

                selectedDepartment = request.getParameter("departmentID");

                try {
                    ArrayList<WebBusinessObject> userStatList = employeeMgr.getEmpVacStatistic(request.getParameter("depratmentID"), request.getParameter("beginDate"), request.getParameter("endDate"));

                    UserDepartmentConfigMgr userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                    ArrayList<WebBusinessObject> userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                    ArrayList<WebBusinessObject> departments = new ArrayList<>();

                    for (WebBusinessObject userDepartmentWbo : userDepartments) {
                        departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                    }

                    if (departments.isEmpty()) {
                        WebBusinessObject wboTemp = new WebBusinessObject();
                        wboTemp.setAttribute("projectName", "لا يوجد");
                        wboTemp.setAttribute("projectID", "none");
                        departments.add(wboTemp);
                    } else {
                        if (selectedDepartment == null) {
                            selectedDepartment = (String) departments.get(0).getAttribute("projectID");
                        }
                    }

                    request.setAttribute("departments", departments);
                    request.setAttribute("beginDate", request.getParameter("beginDate"));
                    request.setAttribute("endDate", request.getParameter("endDate"));
                    request.setAttribute("data", userStatList);
                } catch (Exception ex) {
                    Logger.getLogger(CalendarServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("departmentID", selectedDepartment);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            default:
                logger.info("No operation was matched");
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
        return "Search Servlet";
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.indexOf("GetEmployee") == 0) {
            return 1;
        }

        if (opName.indexOf("SaveEmployee") == 0) {
            return 2;
        }

        if (opName.equals("ListEmployee")) {
            return 3;
        }

        if (opName.equals("ViewEmployee")) {
            return 4;
        }

        if (opName.equals("GetUpdateEmployee")) {
            return 5;
        }

        if (opName.equals("UpdateEmployee")) {
            return 6;
        }

        if (opName.equals("ConfirmDeleteEmployee")) {
            return 7;
        }

        if (opName.equals("Delete")) {
            return 8;
        }

        if (opName.indexOf("EmployeeList") == 0) {
            return 9;
        }
        if (opName.equals("disjoinMgr")) {
            return 10;
        }
        if (opName.equals("disjoinEmp")) {
            return 11;
        }
        if (opName.equals("getEmployeeUnderManager")) {
            return 12;
        }
        if (opName.equals("changeManager")) {
            return 13;
        }
        if (opName.equals("changeUserManagerAjax")) {
            return 14;
        }
        if (opName.equals("getEmployeeNumber")) {
            return 15;
        }
        if (opName.equals("viewEmployeeCommunications")) {
            return 16;
        }
        if (opName.equals("viewEmployeeEducation")) {
            return 17;
        }
        if (opName.equals("viewEmployeeDates")) {
            return 18;
        }
        if (opName.equals("viewEmployeeProfile")) {
            return 19;
        }
        if (opName.equals("Update")) {
            return 20;
        }
        if (opName.equals("holidayRequest")) {
            return 21;
        }
        if (opName.equals("submitHolidayRequest")) {
            return 22;
        }
        if (opName.equals("getEmpProfile")) {
            return 23;
        }
        if (opName.equals("savePofile")) {
            return 24;
        }
        if (opName.equals("projectEmpAss")) {
            return 25;
        }

        if (opName.equals("viewPersonalPhoto")) {
            return 26;
        }
        if (opName.equals("getManagerEmployeesAjax")) {
            return 27;
        }
        if (opName.equals("changeEmployeeStatus")) {
            return 28;
        }
        if (opName.equals("employeeSheetPDF")) {
            return 29;
        }
        if (opName.equals("getEmployee")) {
            return 30;
        }
        if (opName.equals("getEmpSalaryConfig")) {
            return 31;
        }
        if (opName.equals("saveEmpSalaryConfig")) {
            return 32;
        }
        if (opName.equals("ViewAsEmployee")) {
            return 33;
        }
        if (opName.equals("uploadEmployeeLogins")) {
            return 34;
        }
        if (opName.equals("changeUserManagerNAjax")) {
            return 35;
        }
        if (opName.equals("empVacStat")) {
            return 36;
        }
        if (opName.equals("viewEmpVacStat")) {
            return 37;
        }

        return 0;
    }

    private void fillLoggerWbo(HttpServletRequest request, WebBusinessObject loggerWbo) {
        WebBusinessObject loggedUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        LiteWebBusinessObject objectXml = employeeMgr.getOnSingleKey(request.getParameter("employeeId"));
        loggerWbo.setAttribute("objectXml", objectXml.getObjectAsXML());
        loggerWbo.setAttribute("realObjectId", request.getParameter("employeeId"));
        loggerWbo.setAttribute("userId", loggedUser.getAttribute("userId"));
        loggerWbo.setAttribute("objectName", "Employee");
        loggerWbo.setAttribute("loggerMessage", "Employee Deleted");
        loggerWbo.setAttribute("eventName", "Delete");
        loggerWbo.setAttribute("objectTypeId", "6");
        loggerWbo.setAttribute("eventTypeId", "2");
        loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
    }
}
