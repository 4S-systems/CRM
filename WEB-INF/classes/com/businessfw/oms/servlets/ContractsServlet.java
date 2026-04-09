package com.businessfw.oms.servlets;

import com.android.business_objects.LiteWebBusinessObject;
import com.businessfw.hrs.db_access.EmployeeMgr;
import com.businessfw.oms.db_access.ContractMgr;
import com.businessfw.oms.db_access.ContractScheduleMgr;
import com.clients.db_access.ClientMgr;
import com.maintenance.common.Tools;
import com.maintenance.db_access.MainCategoryTypeMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.uploader.FileMeta;
import com.tracker.db_access.ProjectMgr;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import com.businessfw.oms.db_access.DocumentMgr;
import com.clients.db_access.AppointmentMgr;
import com.crm.common.CRMConstants;
import com.silkworm.Exceptions.NoUserInSessionException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.util.Calendar;

public class ContractsServlet extends TrackerBaseServlet {

    private ClientMgr clientMgr;
    private MainCategoryTypeMgr mainCategoryTypeMgr;
    private EmployeeMgr employeeMgr;
    private ProjectMgr projectMgr;
    private ContractMgr contractMgr;
    private DocumentMgr documentMgr;

    private static final int MEMORY_THRESHOLD = 1024 * 1024 * 3;  // 3MB
    private static final int MAX_FILE_SIZE = 1024 * 1024 * 40; // 40MB
    private static final int MAX_REQUEST_SIZE = 1024 * 1024 * 50; // 50MB

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        clientMgr = ClientMgr.getInstance();
        mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
        employeeMgr = EmployeeMgr.getInstance();
        projectMgr = ProjectMgr.getInstance();
        contractMgr = ContractMgr.getInstance();
        documentMgr = DocumentMgr.getInstance();
    }

    @Override
    public void destroy() {
    }

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String loggegUserId = (String) loggedUser.getAttribute("userId");
        String remoteAccess = request.getSession().getId();
        WebBusinessObject persistentUser = (WebBusinessObject) persistentSessionMgr.getOnSingleKey(remoteAccess);
        String persistentUserId = persistentUser != null ? (String) persistentUser.getAttribute("userId") : null;

        List<WebBusinessObject> clients;
        List<LiteWebBusinessObject> employee;
        List<WebBusinessObject> workTypes;

        PrintWriter out;
        SimpleDateFormat formatter;
        String status;

        try {
            switch (operation) {
                case 1:
                    servedPage = "/docs/OMS/Contracts/residenceContract.jsp";

                    try {
                        clients = clientMgr.getOnArbitraryKey2("100", "key11");
                        employee = new ArrayList<LiteWebBusinessObject>(employeeMgr.getCashedTable());
                        workTypes = projectMgr.getOnArbitraryKey2("BFtypes", "key6");

                        request.setAttribute("clients", clients);
                        request.setAttribute("employees", employee);
                        request.setAttribute("workTypes", workTypes);
                    } catch (Exception ex) {
                        employee = new ArrayList<LiteWebBusinessObject>();
                    }

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 2:
                    status = "no";

                    List<FileMeta> files = new ArrayList<>();
                    WebBusinessObject fieldsWbo = new WebBusinessObject();

                    String userID = (String) persistentUser.getAttribute("userId");
                    String contractId = null;

                    try {
                        DiskFileItemFactory factory = new DiskFileItemFactory();
                        factory.setSizeThreshold(MEMORY_THRESHOLD);
                        factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
                        ServletFileUpload upload = new ServletFileUpload(factory);
                        upload.setFileSizeMax(MAX_FILE_SIZE);
                        upload.setSizeMax(MAX_REQUEST_SIZE);
                        List<FileItem> formItems = upload.parseRequest(request);
                        if (formItems.size() > 0) {
                            for (FileItem fileItem : formItems) {
                                if (fileItem.isFormField()) {
                                    if (fieldsWbo.getAttribute(fileItem.getFieldName()) != null) {
                                        fieldsWbo.setAttribute(fileItem.getFieldName(), fieldsWbo.getAttribute(fileItem.getFieldName()) + "," + fileItem.getString("UTF-8"));
                                    } else {
                                        fieldsWbo.setAttribute(fileItem.getFieldName(), fileItem.getString("UTF-8"));
                                    }
                                } else {
                                    if (fileItem.getSize() > 0) {
                                        FileMeta meta = new FileMeta();
                                        meta.setFileName(fileItem.getName());
                                        meta.setFileSize((int) fileItem.getSize());
                                        meta.setFileType(fileItem.getContentType());
                                        meta.setContent(fileItem.getInputStream());
                                        files.add(meta);
                                    }
                                }
                            }
                        }

                        String clientId = (String) fieldsWbo.getAttribute("client");
                        String employeeId = (String) fieldsWbo.getAttribute("employee");

                        String contractNo = (String) fieldsWbo.getAttribute("contractNo");
                        String contractName = (String) fieldsWbo.getAttribute("contractName");
                        String contractType = (String) fieldsWbo.getAttribute("contractType");

                        String contractValue = (String) fieldsWbo.getAttribute("contractValue");
                        String paymentType = (String) fieldsWbo.getAttribute("paymentType");

                        String beginInterval = (String) fieldsWbo.getAttribute("beginInterval");
                        String endInterval = (String) fieldsWbo.getAttribute("endInterval");

                        String notes = (String) fieldsWbo.getAttribute("notes");

                        String period = (String) fieldsWbo.getAttribute("period");
                        String shiftNo = (String) fieldsWbo.getAttribute("shiftNo");
                        String workType = (String) fieldsWbo.getAttribute("workType");
                        String otherReq = (String) fieldsWbo.getAttribute("otherReq");

                        String automatedID = (String) fieldsWbo.getAttribute("automated");

                        formatter = new SimpleDateFormat("yyyy/MM/dd");
                        java.sql.Date beginDate = new Date(formatter.parse(beginInterval).getTime());
                        java.sql.Date endDate = new Date(formatter.parse(endInterval).getTime());

                        ArrayList<WebBusinessObject> contractsList = new ArrayList<>(contractMgr.getOnArbitraryKeyOracle(contractNo, "key2"));

                        if (contractNo != null && !contractsList.isEmpty()) {
                            status = "duplicated";
                        } else if ((contractId = contractMgr.saveResidenceContract(clientId, employeeId, contractNo, contractName, contractType, contractValue, paymentType, beginDate, endDate, notes, (String) persistentUser.getAttribute("userId"), period, shiftNo, workType, otherReq, null, automatedID)) != null) {
                            status = "ok";
                            documentMgr.saveDocuments(files, contractId, "contract", userID);
                        }
                    } catch (Exception ex) {
                        logger.error(ex);
                    }

                    out = response.getWriter();
                    WebBusinessObject wbo = new WebBusinessObject();
                    wbo.setAttribute("status", status);
                    if (contractId != null) {
                        LiteWebBusinessObject contractWbo = contractMgr.getOnSingleKey(contractId);
                        if (contractWbo != null) {       
                            wbo.setAttribute("contractNo", contractWbo.getAttribute("contractNumber"));
                        }
                    }
                    wbo.setAttribute("contractId", (contractId != null) ? contractId : "");
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;

                case 3:
                    servedPage = "/docs/OMS/Contracts/visitContract.jsp";

                    try {
                        clients = clientMgr.getOnArbitraryKey2("100", "key11");
                        employee = new ArrayList<LiteWebBusinessObject>(employeeMgr.getCashedTable());
                        workTypes = projectMgr.getOnArbitraryKey2("BFtypes", "key6");

                        request.setAttribute("clients", clients);
                        request.setAttribute("employees", employee);
                        request.setAttribute("workTypes", workTypes);
                    } catch (Exception ex) {
                        employee = new ArrayList<LiteWebBusinessObject>();
                    }

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 4:
                    status = "no";

                    files = new ArrayList<>();
                    fieldsWbo = new WebBusinessObject();

                    userID = (String) persistentUser.getAttribute("userId");
                    contractId = null;

                    try {
                        DiskFileItemFactory factory = new DiskFileItemFactory();
                        factory.setSizeThreshold(MEMORY_THRESHOLD);
                        factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
                        ServletFileUpload upload = new ServletFileUpload(factory);
                        upload.setFileSizeMax(MAX_FILE_SIZE);
                        upload.setSizeMax(MAX_REQUEST_SIZE);
                        List<FileItem> formItems = upload.parseRequest(request);
                        if (formItems.size() > 0) {
                            for (FileItem fileItem : formItems) {
                                if (fileItem.isFormField()) {
                                    if (fieldsWbo.getAttribute(fileItem.getFieldName()) != null) {
                                        fieldsWbo.setAttribute(fileItem.getFieldName(), fieldsWbo.getAttribute(fileItem.getFieldName()) + "," + fileItem.getString("UTF-8"));
                                    } else {
                                        fieldsWbo.setAttribute(fileItem.getFieldName(), fileItem.getString("UTF-8"));
                                    }
                                } else {
                                    if (fileItem.getSize() > 0) {
                                        FileMeta meta = new FileMeta();
                                        meta.setFileName(fileItem.getName());
                                        meta.setFileSize((int) fileItem.getSize());
                                        meta.setFileType(fileItem.getContentType());
                                        meta.setContent(fileItem.getInputStream());
                                        files.add(meta);
                                    }
                                }
                            }
                        }

                        String clientId = (String) fieldsWbo.getAttribute("client");
                        String employeeId = (String) fieldsWbo.getAttribute("employee");

                        String contractNo = (String) fieldsWbo.getAttribute("contractNo");
                        String contractName = (String) fieldsWbo.getAttribute("contractName");
                        String contractType = (String) fieldsWbo.getAttribute("contractType");

                        String contractValue = (String) fieldsWbo.getAttribute("contractValue");
                        String paymentType = (String) fieldsWbo.getAttribute("paymentType");

                        String beginInterval = (String) fieldsWbo.getAttribute("beginInterval");
                        String endInterval = (String) fieldsWbo.getAttribute("endInterval");

                        String notes = (String) fieldsWbo.getAttribute("notes");

                        String visitNo = (String) fieldsWbo.getAttribute("visitNo");
                        String visitPeriodType = (String) fieldsWbo.getAttribute("visitPeriodType");
                        String visitPrice = (String) fieldsWbo.getAttribute("visitPrice");
                        String workType = (String) fieldsWbo.getAttribute("workType");
                        String otherReq = (String) fieldsWbo.getAttribute("otherReq");

                        String automatedID = (String) fieldsWbo.getAttribute("automated");

                        formatter = new SimpleDateFormat("yyyy/MM/dd");
                        java.sql.Date beginDate = new Date(formatter.parse(beginInterval).getTime());
                        java.sql.Date endDate = new Date(formatter.parse(endInterval).getTime());

                        ArrayList<WebBusinessObject> contractsList = new ArrayList<>(contractMgr.getOnArbitraryKeyOracle(contractNo, "key2"));

                        if (contractNo != null && !contractsList.isEmpty()) {
                            status = "duplicated";
                        } else if ((contractId = contractMgr.saveResidenceContract(clientId, employeeId, contractNo, contractName, contractType, contractValue, paymentType, beginDate, endDate, notes, (String) persistentUser.getAttribute("userId"), visitNo, visitPrice, workType, otherReq, visitPeriodType, automatedID)) != null) {
                            status = "ok";
                            documentMgr.saveDocuments(files, contractId, "contract", userID);
                            generateSchedule(contractId, beginDate, endDate, Integer.valueOf(visitNo), Integer.valueOf(visitPeriodType),
                                    workType, userID);
                        }
                    } catch (Exception ex) {
                        logger.error(ex);
                    }

                    out = response.getWriter();
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("status", status);
                    if (contractId != null) {
                        LiteWebBusinessObject contractWbo = contractMgr.getOnSingleKey(contractId);
                        if (contractWbo != null) {
                            wbo.setAttribute("contractNo", contractWbo.getAttribute("contractNumber"));
                        }
                    }
                    wbo.setAttribute("contractId", (contractId != null) ? contractId : "");
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                case 5:
                    servedPage = "/docs/OMS/Contracts/contract_schedules_list.jsp";
                    ContractScheduleMgr contractScheduleMgr = ContractScheduleMgr.getInstance();
                    request.setAttribute("contractSchedulesList", contractScheduleMgr.getContractSchedulesList());
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 6:
                    servedPage = "/docs/OMS/Contracts/update_contract_schedule.jsp";
                    contractId = request.getParameter("contractID");
                    String scheduleTitle = request.getParameter("scheduleTitle");
                    contractScheduleMgr = ContractScheduleMgr.getInstance();
                    if (scheduleTitle != null && !scheduleTitle.isEmpty()) { // saving
                        try {
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
                            LiteWebBusinessObject scheduleWbo = new LiteWebBusinessObject();
                            scheduleWbo.setAttribute("id", request.getParameter("scheduleID"));
                            scheduleWbo.setAttribute("contractID", contractId);
                            scheduleWbo.setAttribute("scheduleTitle", request.getParameter("scheduleTitle"));
                            scheduleWbo.setAttribute("frequencyRate", request.getParameter("frequencyRate"));
                            scheduleWbo.setAttribute("frequencyType", request.getParameter("frequencyType"));
                            scheduleWbo.setAttribute("fromDate", sdf.parse(request.getParameter("fromDate")).getTime());
                            scheduleWbo.setAttribute("toDate", sdf.parse(request.getParameter("toDate")).getTime());
                            scheduleWbo.setAttribute("scheduleType", request.getParameter("scheduleType"));
                            if (contractScheduleMgr.updateContractSchedule(scheduleWbo) != null) {
                                request.setAttribute("Status", "OK");
                            } else {
                                request.setAttribute("Status", "No");
                            }
                        } catch (ParseException ex) {
                            request.setAttribute("Status", "No");
                        }
                    }
                    request.setAttribute("scheduleWbo", contractScheduleMgr.getOnSingleKey(request.getParameter("scheduleID")));
                    request.setAttribute("contractWbo", contractMgr.getOnSingleKey(contractId));
                    try {
                        request.setAttribute("typesList", projectMgr.getOnArbitraryKey2("BFtypes", "key6"));
                    } catch (Exception ex) {
                        request.setAttribute("typesList", new ArrayList<>());
                    }
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 7:
                    out = response.getWriter();
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("status", "faild");
                    contractScheduleMgr = ContractScheduleMgr.getInstance();
                    if (contractScheduleMgr.updateContractScheduleStatus(CRMConstants.SCHEDULE_STATUS_CANCELED, request.getParameter("scheduleID"))) {
                        wbo.setAttribute("status", "Ok");
                    }
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;
                case 8:
                    out = response.getWriter();
                    contractScheduleMgr = ContractScheduleMgr.getInstance();
                    wbo = new WebBusinessObject();
                    if (executeSchedule(request.getParameter("scheduleID"), (String) persistentUser.getAttribute("userId"))) {
                        contractScheduleMgr.updateContractScheduleStatus(CRMConstants.SCHEDULE_STATUS_DONE, request.getParameter("scheduleID"));
                        wbo.setAttribute("status", "Ok");
                    } else {
                        wbo.setAttribute("status", "faild");
                    }
                    out.write(Tools.getJSONObjectAsString(wbo));
                    break;

                default:
                    System.out.println("No operation was matched");
            }

        } catch (NumberFormatException ex) {
            System.out.println("Error Msg = " + ex.getMessage());
            logger.error(ex.getMessage());
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
    protected int getOpCode(String opName
    ) {
        if (opName.equalsIgnoreCase("residenceContract")) {
            return 1;
        }

        if (opName.equalsIgnoreCase("saveContract")) {
            return 2;
        }

        if (opName.equalsIgnoreCase("visitContract")) {
            return 3;
        }

        if (opName.equalsIgnoreCase("saveVisitContract")) {
            return 4;
        }

        if (opName.equalsIgnoreCase("viewContractSchedules")) {
            return 5;
        }

        if (opName.equalsIgnoreCase("updateContractSchedule")) {
            return 6;
        }

        if (opName.equalsIgnoreCase("cancelContractScheduleAjax")) {
            return 7;
        }

        if (opName.equalsIgnoreCase("executeContractScheduleAjax")) {
            return 8;
        }

        return 0;
    }
    
    private void generateSchedule(String contractID, Date fromDate, Date toDate, int frequencyRate, int frequencyType,
            String scheduleType, String userID) {
        ContractScheduleMgr contractScheduleMgr = ContractScheduleMgr.getInstance();
        LiteWebBusinessObject scheduleWbo = new LiteWebBusinessObject();
        scheduleWbo.setAttribute("contractID", contractID);
        scheduleWbo.setAttribute("scheduleTitle", "Auto Generated Schedule");
        scheduleWbo.setAttribute("frequencyRate", frequencyRate);
        scheduleWbo.setAttribute("frequencyType", frequencyType);
        scheduleWbo.setAttribute("scheduleStatus", "76"); // scheduled status
        scheduleWbo.setAttribute("scheduleType", scheduleType);
        scheduleWbo.setAttribute("userID", userID);
        scheduleWbo.setAttribute("option1", "UL");
        scheduleWbo.setAttribute("option2", "UL");
        scheduleWbo.setAttribute("option3", "UL");
        scheduleWbo.setAttribute("option4", "UL");
        scheduleWbo.setAttribute("option5", "UL");
        scheduleWbo.setAttribute("option6", "UL");
        Calendar c = Calendar.getInstance();
        c.set(Calendar.HOUR_OF_DAY, 0);
        c.set(Calendar.MINUTE, 0);
        c.setTimeInMillis(fromDate.getTime());
        boolean isLast = false;
        do {
            scheduleWbo.setAttribute("fromDate", fromDate);
            c.add(Calendar.MONTH, 3);
            c.add(Calendar.DATE, -1);
            if (c.getTime().before(toDate)) {
                scheduleWbo.setAttribute("toDate", new Date(c.getTimeInMillis()));
                c.add(Calendar.DATE, 1);
                fromDate = new Date(c.getTimeInMillis());
            } else {
                scheduleWbo.setAttribute("toDate", toDate);
                isLast = true;
            }
            contractScheduleMgr.insertContractSchedule(scheduleWbo);
        } while (!isLast);
    }
    
    public boolean executeSchedule(String scheduleID, String userID) {
        ContractScheduleMgr contractScheduleMgr = ContractScheduleMgr.getInstance();
        AppointmentMgr appointmentMgr = AppointmentMgr.getInstance();
        LiteWebBusinessObject scheduleWbo = contractScheduleMgr.getOnSingleKey(scheduleID);
        boolean executed = false;
        if (scheduleWbo != null && CRMConstants.SCHEDULE_STATUS_SCHEDULED.equals(scheduleWbo.getAttribute("scheduleStatus"))) {
            int frequencyRateVal = Integer.parseInt((String) scheduleWbo.getAttribute("frequencyRate"));
            int frequencyTypeVal = Integer.parseInt((String) scheduleWbo.getAttribute("frequencyType"));
            int type = Calendar.DATE;
            int value = 1;
            int reminType = Calendar.HOUR;
            int reminValue = 0;
            switch (frequencyTypeVal) {
                case 1:
                    type = Calendar.HOUR;
                    value = 24;
                    reminType = Calendar.MINUTE;
                    reminValue = value - ((value / frequencyRateVal)) * frequencyRateVal;
                    reminValue = reminValue != 0 ? (60 * reminValue) / frequencyRateVal : 0;
                    break;
                case 2:
                    type = Calendar.DATE;
                    value = 7;
                    reminType = Calendar.HOUR;
                    reminValue = value - ((value / frequencyRateVal)) * frequencyRateVal;
                    reminValue = reminValue != 0 ? (24 * reminValue) / frequencyRateVal : 0;
                    break;
                case 3:
                    type = Calendar.DATE;
                    value = 30;
                    reminType = Calendar.HOUR;
                    reminValue = value - ((value / frequencyRateVal)) * frequencyRateVal;
                    reminValue = (24 * reminValue) / frequencyRateVal;
                    break;
                case 4:
                    type = Calendar.DATE;
                    value = 365;
                    reminType = Calendar.HOUR;
                    reminValue = value - ((value / frequencyRateVal)) * frequencyRateVal;
                    reminValue = (24 * reminValue) / frequencyRateVal;
                    break;
            }
            String lastAppointmentDate = appointmentMgr.getScheduleLastAppointment((String) scheduleWbo.getAttribute("contractID"));
            Timestamp fromDateTime = (Timestamp.valueOf((String) scheduleWbo.getAttribute("fromDate")));
            Timestamp toDateTime = (Timestamp.valueOf((String) scheduleWbo.getAttribute("toDate")));
            Calendar c = Calendar.getInstance();
            if (lastAppointmentDate != null) {
                c.setTimeInMillis(Timestamp.valueOf(lastAppointmentDate).getTime());
                c.add(type, value / frequencyRateVal);
                if (c.getTime().after(fromDateTime)) {
                    fromDateTime = (new Timestamp(c.getTimeInMillis()));
                }
            }
            c.setTimeInMillis(fromDateTime.getTime());
            while (toDateTime.after(fromDateTime)) {
                try {
                    if (appointmentMgr.saveAppointment(userID, scheduleID, "Schedule", fromDateTime, "Auto generated schedule",
                            "schedule", null, scheduleID, (String) scheduleWbo.getAttribute("contractID"), "Auto generated", CRMConstants.APPOINTMENT_STATUS_OPEN, null, "UL", "UL", 0, null, null, "UL", null)) {
                        executed = true;
                    }
                } catch (NoUserInSessionException | SQLException ex) {
                    Logger.getLogger(ContractsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                c.add(type, value / frequencyRateVal);
                c.add(reminType, reminValue);
                fromDateTime.setTime(c.getTimeInMillis());
            }
        }
        return executed;
    }
}
