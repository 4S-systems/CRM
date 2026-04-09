package com.financials.servlets;

import com.DatabaseController.db_access.DBTablesConfigMgr;
import com.android.business_objects.LiteWebBusinessObject;
import com.android.exceptions.LiteNoSuchColumnException;
import com.businessfw.hrs.db_access.EmployeeMgr;
import com.businessfw.hrs.financials.UnitPaymentDetails;
import com.clients.db_access.ClientMgr;
import com.crm.common.CRMConstants;
import com.financials.db_access.AccountsMgr;
import com.financials.db_access.ClientInvoiceMgr;
import com.financials.db_access.ExpenseItemMgr;
import com.financials.db_access.ExpenseItemRelativeMgr;
import com.financials.db_access.FinancialDocumentMgr;
import com.financials.db_access.FinancialTransactionMgr;
import com.financials.db_access.InvoiceMgr;
import com.maintenance.common.DateParser;
import com.maintenance.common.Tools;
import com.planning.db_access.PaymentPlanMgr;
import com.planning.db_access.StandardPaymentPlanMgr;
import com.silkworm.Exceptions.NoUserInSessionException;

import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.db_access.PersistentSessionMgr;
import com.tracker.db_access.LocationTypeMgr;
import com.tracker.db_access.ProjectMgr;
import com.tracker.db_access.SequenceMgr;

import com.tracker.servlets.TrackerBaseServlet;
import java.io.ByteArrayOutputStream;
import java.io.FileReader;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Vector;
import java.util.logging.Level;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public class FinancialServlet extends TrackerBaseServlet {

    MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
    AccountsMgr accountsMgr = AccountsMgr.getInstance();
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    ClientMgr clientMgr = ClientMgr.getInstance();
    SequenceMgr sequenceMgr = SequenceMgr.getInstance();
    FinancialTransactionMgr finTransaction = FinancialTransactionMgr.getInstance();

    ArrayList<WebBusinessObject> accountsList = null;
    ArrayList FAccountType = null;
    ArrayList purposeArrayList = null;
    ArrayList clientsList = null;
    ArrayList kindsList = null;
    ArrayList CostCenterList = null;

    WebBusinessObject accountWbo = null;
    Vector accountsVec = null;

    String icon;
    String accountId;
    String kindId;
    String businessID;

    JSONObject main = null;
    JSONObject menu = null;
    JSONObject jsonMenu = null;

    JSONArray menuItems = null;
    JSONArray JsonList = null;

    JSONParser parser = null;

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        logger = Logger.getLogger(FinancialServlet.class);
    }

    public void destroy() {
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        super.processRequest(request, response);
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String remoteAccess = session.getId();
        WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);
        WebBusinessObject wbo;
        String lang = (String) session.getAttribute("currentMode");

        // issueMgr.setUser(userObj);
        String page = null;

        operation = getOpCode((String) request.getParameter("op"));

        switch (operation) {
            case 1:
                servedPage = "/docs/UnitFinance/finance_tree.jsp";

                projectMgr = ProjectMgr.getInstance();

                ArrayList projectsList = new ArrayList();
                try {
                    projectsList = new ArrayList<WebBusinessObject>();
                    ArrayList<WebBusinessObject> mainproject = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("الشجرة المالية", "key1"));
                    Vector projects = projectMgr.getOnArbitraryKey(mainproject.get(0).getAttribute("projectID").toString(), "key2");
                    request.setAttribute("finProjID", mainproject.get(0).getAttribute("projectID").toString());
                    //Vector projects = projectMgr.getOnArbitraryKey("1537789934360", "key2");

                    for (int i = 0; i < projects.size(); i++) {
                        wbo = (WebBusinessObject) projects.get(i);
                        projectsList.add(wbo);
                    }
                } catch (Exception exc) {
                    System.out.println(exc.getMessage());
                }
                request.setAttribute("page", servedPage);
                request.setAttribute("prjects", projectsList);
                this.forwardToServedPage(request, response);
                break;

            case 2:
                projectMgr = ProjectMgr.getInstance();

                //define the json 
                main = new JSONObject();
                menu = new JSONObject();
                menuItems = new JSONArray();

                this.jsonMenu = new JSONObject();
                this.JsonList = new JSONArray();

                //Define menu JSON Reader
                JSONParser parser = new JSONParser();
                try {
                    String path = getServletContext().getRealPath("/json");
                    FileReader fileReader = new FileReader(getServletContext().getRealPath("/json") + "/financeContextMenu.json");
                    this.jsonMenu = (JSONObject) parser.parse(fileReader);
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                //get Project  Tree
                String projectId = request.getParameter("projectId");
                WebBusinessObject project = projectMgr.getOnSingleKey(projectId);

                //Add main object to json
                String projectName = "";
                if (project.getAttribute("location_type").equals("VG")) {
                    menu = (JSONObject) this.jsonMenu.get("VG");
                    projectName = project.getAttribute("projectName").toString();
                } else if (project.getAttribute("location_type").equals("ACCTM")) {
                    menu = (JSONObject) this.jsonMenu.get("ACCTM");
                    projectName = project.getAttribute("projectName").toString();
                } else if (project.getAttribute("location_type").equals("ACCTB")) {
                    menu = (JSONObject) this.jsonMenu.get("ACCTB");
                    projectName = project.getAttribute("projectName").toString();
                }

                String icon = (String) menu.get("icon");
                menuItems = (JSONArray) menu.get("menuItem");

                int currentID = this.JsonList.size();
                main.put("id", "0");
                main.put("projectID", projectId);
                main.put("parentid", "-1");
                main.put("text", projectName);
                main.put("icon", icon);
                main.put("type", project.getAttribute("location_type").toString());
                main.put("contextMenu", menuItems);
                JsonList.add(main);

                getChilds(projectId, currentID);

                PrintWriter out = response.getWriter();
                out.write(JsonList.toJSONString());
                break;

            case 3:
                servedPage = "/docs/Financials/New_Financial_Transaction.jsp";
                projectMgr = ProjectMgr.getInstance();
                sequenceMgr = SequenceMgr.getInstance();
                String  docNo="";
                ArrayList sourceDestinationLst = new ArrayList<WebBusinessObject>();
                try {
                    sequenceMgr.updateSequence();
                    businessID = sequenceMgr.getSequence();
                    sequenceMgr.updateSequence();
                    docNo = sequenceMgr.getSequence();
                    FAccountType = projectMgr.getOnArbitraryKey2("ACC_ITM", "key4");
                    // walid - replace 
                    //    purposeArrayList = projectMgr.getOnArbitraryKey2("1476595759310", "key2");
                    CostCenterList = projectMgr.getOnArbitraryKey2("1475660555820", "key2");
                    purposeArrayList = projectMgr.getOnArbitraryKey2("1476862041589", "key2");
                    sourceDestinationLst = LocationTypeMgr.getInstance().getLocationTypeUsingLike("FIN_");
                } catch (Exception ex) {
                    System.out.println("Exception : " + ex.getMessage());
                }

                ArrayList<WebBusinessObject> arrayOfContractors = clientMgr.getListOfContractors();
                request.setAttribute("clientsList", arrayOfContractors);

                request.setAttribute("FAccountType", FAccountType);
                request.setAttribute("purposeArrayList", purposeArrayList);
                request.setAttribute("CostCenterList", CostCenterList);
                request.setAttribute("docNo", docNo);
                request.setAttribute("businessID", businessID);
                request.setAttribute("sourceDestinationLst", sourceDestinationLst);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 4:
                kindId = request.getParameter("kindId");

                kindsList = new ArrayList();
                if (kindId != null && kindId.equals("FIN_CLNT")) {
                    kindsList = clientMgr.getAllPurchOwnerClient();
                } else if (kindId != null && kindId.equals("FIN_CNTRCT")) {
                    kindsList = clientMgr.getListOfContractors();
                } else if (kindId != null && kindId.equals("FIN_SAFE")) {
                    try {
                        kindsList = projectMgr.getOnArbitraryKey2("FIN_SAFE", "key4");
                    } catch (Exception ex) {
                        java.util.logging.Logger.getLogger(FinancialServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                } else if (kindId != null && kindId.equals("FIN_BNK")) {
                    try {
                        kindsList = projectMgr.getOnArbitraryKey2("FIN_BNK", "key4");
                    } catch (Exception ex) {
                        java.util.logging.Logger.getLogger(FinancialServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                } else if ("FIN_EMP".equals(kindId)) {
                    try {
                        ArrayList<LiteWebBusinessObject> tempList = new ArrayList(EmployeeMgr.getInstance().getCashedTable());
                        tempList.stream().forEach(tempWbo -> {
                            kindsList.add(new WebBusinessObject(tempWbo.getContents()));
                        });
                    } catch (Exception ex) {
                        java.util.logging.Logger.getLogger(FinancialServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                } else {
                    try {
                        LocationTypeMgr locationTypeMgr = LocationTypeMgr.getInstance();
                        WebBusinessObject lctnTypWbo = locationTypeMgr.getLocationTypeByID(kindId);

                        DBTablesConfigMgr dBTablesConfigMgr = DBTablesConfigMgr.getInstance();
                        LiteWebBusinessObject queryLiteWbo = dBTablesConfigMgr.getLctnTypTbl(lctnTypWbo.getAttribute("typeCode").toString());

                        kindsList = dBTablesConfigMgr.getselectedLst(queryLiteWbo);
                    } catch (Exception ex) {
                        System.out.println("Exception : " + ex.getMessage());
                    }
                }
                out = response.getWriter();
                out.write(Tools.getJSONArrayAsString(kindsList));
                break;

            case 5:
                projectMgr = ProjectMgr.getInstance();
                clientMgr = ClientMgr.getInstance();
                sequenceMgr = SequenceMgr.getInstance();
                finTransaction = FinancialTransactionMgr.getInstance();

                WebBusinessObject savedWBO = new WebBusinessObject();
                savedWBO.setAttribute("businessID", request.getParameter("businessID"));
                savedWBO.setAttribute("docNumber", request.getParameter("documentNumber"));
                savedWBO.setAttribute("docDate", request.getParameter("documentDate"));
                savedWBO.setAttribute("accountCode", request.getParameter("accountCode"));
                savedWBO.setAttribute("FTypeID", request.getParameter("FTypeID"));
                savedWBO.setAttribute("purposeID", request.getParameter("purposeID"));
                savedWBO.setAttribute("sourceKind", request.getParameter("sourceKind"));
                savedWBO.setAttribute("source", request.getParameter("source"));
                savedWBO.setAttribute("destinationKind", request.getParameter("destinationKind"));
                savedWBO.setAttribute("destination", request.getParameter("destination"));
                savedWBO.setAttribute("transValue", request.getParameter("transValue"));
                savedWBO.setAttribute("transNetValue", request.getParameter("transNetValue"));
                savedWBO.setAttribute("notes", request.getParameter("notes"));
                String invoID1 = request.getParameter("invoID");
                InvoiceMgr invoiceMgr = InvoiceMgr.getInstnace();

                String status = finTransaction.saveFinTrnsaction(savedWBO, persistentUser);

                if (status.equalsIgnoreCase("ok")) {
                    request.setAttribute("status", "ok");
                    if (invoID1 != null && !invoID1.equals("")) {
                        LiteWebBusinessObject invoiceWbo =invoiceMgr.getOnSingleKey( invoID1);
                        invoiceWbo.setAttribute("option4", "paid");
                        invoiceWbo.setAttribute("clientComplaintID", invoID1);
                        
                       
                    }
                } else {
                    request.setAttribute("status", "no");
                }

                sourceDestinationLst = new ArrayList<WebBusinessObject>();
                try {
                    sequenceMgr.updateSequence();
                    businessID = sequenceMgr.getSequence();
                    sequenceMgr.updateSequence();
                    request.setAttribute("docNo", sequenceMgr.getSequence());
                    FAccountType = projectMgr.getOnArbitraryKey2("ACC_ITM", "key4");
                    // walid - replace 
                    //    purposeArrayList = projectMgr.getOnArbitraryKey2("1476595759310", "key2");
                    CostCenterList = projectMgr.getOnArbitraryKey2("1475660555820", "key2");

                    purposeArrayList = projectMgr.getOnArbitraryKey2("1476862041589", "key2");
                    sourceDestinationLst = LocationTypeMgr.getInstance().getLocationTypeUsingLike("FIN_");
                } catch (Exception ex) {
                    System.out.println("Exception : " + ex.getMessage());
                }

                arrayOfContractors = clientMgr.getListOfContractors();
                request.setAttribute("clientsList", arrayOfContractors);

                request.setAttribute("FAccountType", FAccountType);
                request.setAttribute("purposeArrayList", purposeArrayList);
                request.setAttribute("CostCenterList", CostCenterList);
                request.setAttribute("businessID", businessID);
                request.setAttribute("sourceDestinationLst", sourceDestinationLst);

                servedPage = "/docs/Financials/New_Financial_Transaction.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 6:
                projectName = "";
                projectId = request.getParameter("projectId");

                servedPage = "/docs/UnitFinance/delete_account.jsp";

                try {
                    if (projectName == null || projectName.equals("")) {
                        projectName = ((WebBusinessObject) projectMgr.getOnSingleKey(projectId)).getAttribute("projectName").toString();
                    }
                } catch (Exception e) {
                    projectName = ((WebBusinessObject) projectMgr.getOnSingleKey(projectId)).getAttribute("projectName").toString();
                }

                request.setAttribute("projectName", projectName);
                request.setAttribute("projectId", projectId);

                try {
                    if (request.getParameter("type").equals("tree")) {
                        request.setAttribute("type", "tree");
                        this.forward(servedPage, request, response);
                    }
                } catch (Exception ex) {
                    request.setAttribute("page", servedPage);
                    request.setAttribute("type", "");
                    this.forwardToServedPage(request, response);
                }
                break;

            case 7:
                servedPage = "/docs/UnitFinance/selected_item_finance_tree.jsp";

                projectMgr = ProjectMgr.getInstance();

                projectsList = new ArrayList();
                try {
                    projectsList = new ArrayList<WebBusinessObject>();
                    Vector projects = projectMgr.getOnArbitraryKey("1475870638176", "key2");

                    for (int i = 0; i < projects.size(); i++) {
                        wbo = (WebBusinessObject) projects.get(i);
                        projectsList.add(wbo);
                    }
                } catch (Exception exc) {
                    System.out.println(exc.getMessage());
                }
                request.setAttribute("page", servedPage);
                request.setAttribute("prjects", projectsList);
                this.forwardToServedPage(request, response);
                break;

            case 8:
                servedPage = "/docs/UnitFinance/CostCenter_tree.jsp";

                projectMgr = ProjectMgr.getInstance();

                projectsList = new ArrayList();
                try {
                    projectsList = new ArrayList<WebBusinessObject>();
                    Vector projects = projectMgr.getOnArbitraryKey("1475660555820", "key2");

                    for (int i = 0; i < projects.size(); i++) {
                        wbo = (WebBusinessObject) projects.get(i);
                        projectsList.add(wbo);
                    }
                } catch (Exception exc) {
                    System.out.println(exc.getMessage());
                }
                request.setAttribute("page", servedPage);
                request.setAttribute("prjects", projectsList);
                this.forwardToServedPage(request, response);
                break;

            case 9:
                projectMgr = ProjectMgr.getInstance();

                //define the json 
                main = new JSONObject();
                menu = new JSONObject();
                menuItems = new JSONArray();

                this.jsonMenu = new JSONObject();
                this.JsonList = new JSONArray();

                //Define menu JSON Reader
                parser = new JSONParser();
                try {
                    String path = getServletContext().getRealPath("/json");
                    FileReader fileReader = new FileReader(getServletContext().getRealPath("/json") + "/CostCenterContextMenu.json");
                    this.jsonMenu = (JSONObject) parser.parse(fileReader);
                } catch (Exception ex) {
                    System.out.println("Parsing Error : " + ex.getMessage());
                    logger.error(ex.getMessage());
                }

                //get Project  Tree
                projectId = request.getParameter("projectId");
                project = projectMgr.getOnSingleKey(projectId);

                //Add main object to json
                projectName = "";
                if (project.getAttribute("location_type").equals("VG")) {
                    menu = (JSONObject) this.jsonMenu.get("VG");
                    projectName = project.getAttribute("projectName").toString();
                }

                icon = (String) menu.get("icon");
                menuItems = (JSONArray) menu.get("menuItem");

                currentID = this.JsonList.size();
                main.put("id", "0");
                main.put("projectID", projectId);
                main.put("parentid", "-1");
                main.put("text", projectName);
                main.put("icon", icon);
                main.put("type", project.getAttribute("location_type").toString());
                main.put("contextMenu", menuItems);
                JsonList.add(main);

                getCostCenterChilds(projectId, currentID);

                try {
                } catch (Exception exc) {
                    System.out.println(exc.getMessage());
                }

                out = response.getWriter();
                out.write(JsonList.toJSONString());
                break;

            case 10:
                servedPage = "/docs/Financials/new_expense_item.jsp";
                ExpenseItemMgr expenseItemMgr = ExpenseItemMgr.getInstance();
                List measurementUnits = expenseItemMgr.getMeasurementUnits("time");
                String costItemId = (String) request.getParameter("costItemId");
                LiteWebBusinessObject costItemWbo = null;

                if (costItemId != null) {
                    costItemWbo = expenseItemMgr.getOnSingleKey(costItemId);
                }

                request.setAttribute("costItemWbo", costItemWbo);
                request.setAttribute("units", measurementUnits);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 11:
                LiteWebBusinessObject liteWbo = new LiteWebBusinessObject();
                costItemId = null;
                costItemId = (String) request.getParameter("costItemId");
                liteWbo.setAttribute("code", request.getParameter("code") != null ? request.getParameter("code") : "");
                liteWbo.setAttribute("arName", request.getParameter("Ar_Name") != null ? request.getParameter("Ar_Name") : "");
                liteWbo.setAttribute("enName", request.getParameter("EN_Name") != null ? request.getParameter("EN_Name") : "");
                liteWbo.setAttribute("transType", request.getParameter("trans_type") != null ? request.getParameter("trans_type") : "");
//                wbo.setAttribute("indriveCalc", request.getParameter("indrive_calc"));
                loggedUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
                liteWbo.setAttribute("userId", loggedUser.getAttribute("userId") != null ? loggedUser.getAttribute("userId") : "");
                liteWbo.setAttribute("measure_unit", request.getParameter("measure_unit") != null ? request.getParameter("measure_unit") : "");
                liteWbo.setAttribute("unit_price", request.getParameter("unit_price") != null ? request.getParameter("unit_price") : "");
                liteWbo.setAttribute("accountType", request.getParameter("accountType") != null ? request.getParameter("accountType") : "");
                liteWbo.setAttribute("itemType", request.getParameter("itemType") != null ? request.getParameter("itemType") : "");
                liteWbo.setAttribute("calc_type", request.getParameter("calc_type") != null ? request.getParameter("calc_type") : "");
                if (request.getParameter("costItemId") != null && !request.getParameter("costItemId").equals("")) {
                    liteWbo.setAttribute("costItemId", request.getParameter("costItemId") != null ? request.getParameter("costItemId") : "");
                } else {
                    liteWbo.setAttribute("costItemId", "0");
                }

                expenseItemMgr = ExpenseItemMgr.getInstance();
                try {
                    costItemId = expenseItemMgr.saveObject2(liteWbo, request);
                    costItemWbo = new LiteWebBusinessObject();
                    costItemWbo = expenseItemMgr.getOnSingleKey(costItemId);
                    measurementUnits = expenseItemMgr.getMeasurementUnits("time");
                    request.setAttribute("costItemWbo", costItemWbo);
                    request.setAttribute("units", measurementUnits);
                } catch (SQLException ex) {
                    java.util.logging.Logger.getLogger(FinancialServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                if (costItemId != null) {
                    ExpenseItemRelativeMgr expenseItemRelativeMgr = ExpenseItemRelativeMgr.getInstance();
                    LiteWebBusinessObject expenseWbo = new LiteWebBusinessObject();
                    HashMap types = new HashMap();
                    String driver = (String) request.getParameter("driver");
                    String journey = (String) request.getParameter("journey");
                    String client = (String) request.getParameter("client");
                    String agent = (String) request.getParameter("agent");
                    String fDriverId = (String) request.getParameter("fDriverId");
                    String fJourneyId = (String) request.getParameter("fJourneyId");
                    String fClientId = (String) request.getParameter("fClientId");
                    String fAgentId = (String) request.getParameter("fAgentId");
                    expenseWbo.setAttribute("expenseId", costItemId);
                    expenseWbo.setAttribute("clientId", "ul");

                    if (driver != null && !driver.equals("-1")) {
                        if (fDriverId != null && !fDriverId.equals("")) {
                            expenseWbo.setAttribute("factorId", fDriverId);
                        }

                        expenseWbo.setAttribute("bussType", "driver");
                        expenseWbo.setAttribute("acountMood", driver);
                        if (request.getParameter("driverP") != null && !request.getParameter("driverP").equals("")) {
                            expenseWbo.setAttribute("percentage", request.getParameter("driverP"));
                        } else {
                            expenseWbo.setAttribute("percentage", "0");
                        }

                        try {
                            expenseItemRelativeMgr.saveObject(expenseWbo);
                        } catch (SQLException ex) {
                            java.util.logging.Logger.getLogger(FinancialServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }

                    if (journey != null && !journey.equals("-1")) {
                        if (fJourneyId != null && !fJourneyId.equals("")) {
                            expenseWbo.setAttribute("factorId", fJourneyId);
                        }

                        expenseWbo.setAttribute("bussType", "journey");
                        expenseWbo.setAttribute("acountMood", journey);
                        if (request.getParameter("journeyP") != null && !request.getParameter("journeyP").equals("")) {
                            expenseWbo.setAttribute("percentage", request.getParameter("journeyP"));
                        } else {
                            expenseWbo.setAttribute("percentage", "0");
                        }

                        try {
                            expenseItemRelativeMgr.saveObject(expenseWbo);
                        } catch (SQLException ex) {
                            java.util.logging.Logger.getLogger(FinancialServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }

                    if (client != null && !client.equals("-1")) {
                        if (fClientId != null && !fClientId.equals("")) {
                            expenseWbo.setAttribute("factorId", fClientId);
                        }

                        expenseWbo.setAttribute("bussType", "client");
                        expenseWbo.setAttribute("acountMood", client);
                        if (request.getParameter("clientP") != null && !request.getParameter("clientP").equals("")) {
                            expenseWbo.setAttribute("percentage", request.getParameter("clientP"));
                        } else {
                            expenseWbo.setAttribute("percentage", "0");
                        }

                        try {
                            expenseItemRelativeMgr.saveObject(expenseWbo);
                        } catch (SQLException ex) {
                            java.util.logging.Logger.getLogger(FinancialServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }

                    if (agent != null && !agent.equals("-1")) {
                        if (fAgentId != null && !fAgentId.equals("")) {
                            expenseWbo.setAttribute("factorId", fAgentId);
                        }

                        expenseWbo.setAttribute("bussType", "agent");
                        expenseWbo.setAttribute("acountMood", agent);
                        if (request.getParameter("agentP") != null && !request.getParameter("agentP").equals("")) {
                            expenseWbo.setAttribute("percentage", request.getParameter("agentP"));
                        } else {
                            expenseWbo.setAttribute("percentage", "0");
                        }

                        try {
                            expenseItemRelativeMgr.saveObject(expenseWbo);
                        } catch (SQLException ex) {
                            java.util.logging.Logger.getLogger(FinancialServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                    request.setAttribute("status", "Success");
                } else {
                    request.setAttribute("status", "Fail");
                }

                this.forward("FinancialServlet?op=newExpenseItem", request, response);
                break;

            case 12:
                ArrayList<LiteWebBusinessObject> expenseItemsList = new ArrayList<LiteWebBusinessObject>();
                expenseItemMgr = ExpenseItemMgr.getInstance();
                expenseItemsList = expenseItemMgr.getExpensItem();
                request.setAttribute("itemsList", expenseItemsList);
                servedPage = "/docs/Financials/list_expense_items.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 13:
                servedPage = "/docs/Financials/view_expense_item.jsp";
                expenseItemMgr = ExpenseItemMgr.getInstance();
                costItemId = (String) request.getParameter("costItemId");
                costItemWbo = new LiteWebBusinessObject();
                costItemWbo = expenseItemMgr.getOnSingleKey(costItemId);
                measurementUnits = expenseItemMgr.getMeasurementUnits("time");

                request.setAttribute("units", measurementUnits);
                request.setAttribute("costItemWbo", costItemWbo);
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 14:
                wbo = new WebBusinessObject();
                String expenseItemId = request.getParameter("expenseItemId");
                wbo.setAttribute("expenseItemId", expenseItemId);
                expenseItemMgr = ExpenseItemMgr.getInstance();
                if (expenseItemMgr.deleteOnSingleKey(expenseItemId)) {
                    wbo.setAttribute("status", "Ok");
                } else {
                    wbo.setAttribute("status", "No");
                }

                this.forward("FinancialServlet?op=viewExpenseItem", request, response);
                break;

            case 15:
                servedPage = "/docs/Financials/units_finan_tran_rprt.jsp";
                String unitID = request.getParameter("unit");
                String clientID = request.getParameter("client");
                FinancialTransactionMgr financialTransactionMgr = FinancialTransactionMgr.getInstance();

                if (unitID != null || clientID != null) {
                    ArrayList<WebBusinessObject> finanTransLst = new ArrayList<WebBusinessObject>();
                    {
                        try {
                            finanTransLst = new ArrayList<WebBusinessObject>(financialTransactionMgr.getAllFinancialTransaction(unitID, clientID));
                        } catch (NoUserInSessionException ex) {
                            java.util.logging.Logger.getLogger(FinancialServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                    request.setAttribute("finanTransLst", finanTransLst);
                    request.setAttribute("unit", projectMgr.getOnSingleKey(unitID).getAttribute("projectName"));
                    if (clientID != null && clientID != "" && !clientID.isEmpty()) {
                        request.setAttribute("client", clientMgr.getOnSingleKey(clientID).getAttribute("name"));
                    }
                }

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 16:
                servedPage = "/docs/Financials/unit_payment_plan_details.jsp";
                ArrayList<WebBusinessObject> planDetailsList = PaymentPlanMgr.getInstance().getApprovedPlanDetails(request.getParameter("clientID"),
                        request.getParameter("unitID"));
                double total = FinancialTransactionMgr.getInstance().getClientUnitTotal(request.getParameter("clientID"), request.getParameter("unitID"));
                ArrayList<UnitPaymentDetails> detailsList = new ArrayList<>();
                UnitPaymentDetails unitPaymentDetails;
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                for (WebBusinessObject detailsWbo : planDetailsList) {
                    try {
                        unitPaymentDetails = new UnitPaymentDetails();
                        unitPaymentDetails.setPlanDetailsID((String) detailsWbo.getAttribute("paymentID"));
                        unitPaymentDetails.setPaymentAmount(Double.valueOf((String) detailsWbo.getAttribute("paymentAmount")));
                        unitPaymentDetails.setPaymentDate(sdf.parse((String) detailsWbo.getAttribute("paymentDate")));
                        unitPaymentDetails.setPaymentType((String) detailsWbo.getAttribute("paymentType"));
                        if (total > 0) {
                            if (unitPaymentDetails.getPaymentAmount() <= total) {
                                unitPaymentDetails.setPaidAmount(unitPaymentDetails.getPaymentAmount());
                                total -= unitPaymentDetails.getPaymentAmount();
                                unitPaymentDetails.setStatusName(CRMConstants.PAYMENT_DETAILS_DONE);
                            } else {
                                unitPaymentDetails.setPaidAmount(total);
                                total = 0.0;
                                unitPaymentDetails.setStatusName(CRMConstants.PAYMENT_DETAILS_PARTIAL);
                            }
                        } else {
                            if (unitPaymentDetails.getPaymentDate().before(new Date())) {
                                unitPaymentDetails.setStatusName(CRMConstants.PAYMENT_DETAILS_DELAYED);
                            } else {
                                unitPaymentDetails.setStatusName(CRMConstants.PAYMENT_DETAILS_PENDING);
                            }
                        }
                        detailsList.add(unitPaymentDetails);
                    } catch (ParseException ex) {
                        java.util.logging.Logger.getLogger(FinancialServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                request.setAttribute("detailsList", detailsList);
                this.forward(servedPage, request, response);
                break;
            case 17:
                servedPage = "/docs/Financials/installmentToBeColRprt.jsp";
                String fromD = (String) request.getParameter("fromD");
                SimpleDateFormat dateFormat = new SimpleDateFormat("MM-yy");
                Date convertedDate;
                String date = null;
                if (fromD != null) {
                    try {
                        convertedDate = dateFormat.parse(fromD);
                        Calendar c = Calendar.getInstance();
                        c.setTime(convertedDate);
                        c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
                        Date lastDayOfMonth = c.getTime();
                        sdf = new SimpleDateFormat("dd-MMMM-yyyy");
                        date = sdf.format(lastDayOfMonth);
                        String fromDM = date.split("-")[1];
                        String fromDY = date.split("-")[2];
                        String fromDN = "1-" + fromDM + "-" + fromDY;
                        String toD = date;

                        ArrayList<WebBusinessObject> resultLst = new ArrayList<WebBusinessObject>();
                        PaymentPlanMgr paymentPlanMgr = PaymentPlanMgr.getInstance();
                        resultLst = paymentPlanMgr.getIntallmentsToBeCollected(fromDN, toD);

                        request.setAttribute("resultLst", resultLst);
                    } catch (ParseException ex) {
                        java.util.logging.Logger.getLogger(FinancialServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }

                request.setAttribute("fromD", fromD);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 18:
                servedPage = "/docs/Financials/FinancialTransactionRprt.jsp";
                String fromDate = request.getParameter("fromDate");
                String toDate = request.getParameter("toDate");
                DateParser dateParser = new DateParser();
                String jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                Calendar c = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (toDate == null) {
                    toDate = sdf.format(c.getTime());
                }

                if (fromDate == null) {
                    c.add(Calendar.MONTH, -1);
                    fromDate = sdf.format(c.getTime());
                }
                financialTransactionMgr = FinancialTransactionMgr.getInstance();
                if (fromDate != null && toDate != null) {
                    ArrayList<WebBusinessObject> finanTransLst = new ArrayList<WebBusinessObject>();
                    {
                        try {
                            finanTransLst = new ArrayList<WebBusinessObject>(financialTransactionMgr.getFinancialTransactionByDates(fromDate, toDate));
                        } catch (NoUserInSessionException ex) {
                            java.util.logging.Logger.getLogger(FinancialServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                    request.setAttribute("finanTransLst", finanTransLst);
                }

                request.setAttribute("fromDate", fromDate);
                request.setAttribute("toDate", toDate);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 19:
                servedPage = "/docs/Financials/invoices_details.jsp";
                String kind = request.getParameter("kind");
                ArrayList<LiteWebBusinessObject> invoicesList =new ArrayList<LiteWebBusinessObject>();
                ArrayList<WebBusinessObject> transactionsList;
                financialTransactionMgr = FinancialTransactionMgr.getInstance();
                if (kind.equals("FIN_CNTRCT")) {
                     invoiceMgr = InvoiceMgr.getInstnace();
                try {
                     invoicesList = invoiceMgr.getContractorApprovedInvoices(request.getParameter("clientID"));
                    } catch (LiteNoSuchColumnException ex) {
                        java.util.logging.Logger.getLogger(FinancialServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    try {
                        transactionsList = new ArrayList<>(financialTransactionMgr.getOnArbitraryKeyOrdered(request.getParameter("clientID"), "key1", "key2"));
                    } catch (Exception ex) {
                        transactionsList = new ArrayList<>();
                    }
                } else {
                    PaymentPlanMgr paymentPlanMgr = PaymentPlanMgr.getInstance();
                    invoicesList = paymentPlanMgr.getClientInstallments(request.getParameter("clientID"));
                    try {
                        transactionsList = new ArrayList<>(financialTransactionMgr.getOnArbitraryKeyOrdered(request.getParameter("clientID"), "key3", "key2"));
                    } catch (Exception ex) {
                        transactionsList = new ArrayList<>();
                    }
                }
                request.setAttribute("transactionsList", transactionsList);
                request.setAttribute("invoicesList", invoicesList);
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;
            case 20:
                servedPage = "/docs/Financials/New_Financial_Document.jsp";

                projectMgr = ProjectMgr.getInstance();

                sourceDestinationLst = new ArrayList<WebBusinessObject>();
                try {
                    CostCenterList = projectMgr.getOnArbitraryKey2("1475660555820", "key2");
                    purposeArrayList = projectMgr.getOnArbitraryKey2("1476862041589", "key2");
                    sourceDestinationLst = LocationTypeMgr.getInstance().getLocationTypeUsingLike("FIN_");
                } catch (Exception ex) {
                    System.out.println("Exception : " + ex.getMessage());
                }
                
                arrayOfContractors = clientMgr.getListOfContractors();

                request.setAttribute("clientsList", arrayOfContractors);
                request.setAttribute("purposeArrayList", purposeArrayList);
                request.setAttribute("CostCenterList", CostCenterList);
                request.setAttribute("sourceDestinationLst", sourceDestinationLst);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 21:
                projectMgr = ProjectMgr.getInstance();
                clientMgr = ClientMgr.getInstance();
                sequenceMgr = SequenceMgr.getInstance();
                finTransaction = FinancialTransactionMgr.getInstance();

                savedWBO = new WebBusinessObject();
                savedWBO.setAttribute("documentTitle", request.getParameter("documentTitle"));
                savedWBO.setAttribute("documentNumber", request.getParameter("documentNumber"));
                savedWBO.setAttribute("DocType", request.getParameter("DocType"));
                savedWBO.setAttribute("docValue", request.getParameter("docValue"));
                savedWBO.setAttribute("source", request.getParameter("source"));
                savedWBO.setAttribute("destination", request.getParameter("destination"));
                savedWBO.setAttribute("docDate", request.getParameter("documentDate"));
                savedWBO.setAttribute("notes", request.getParameter("notes"));

                status = FinancialDocumentMgr.getInstance().saveFinDocument(savedWBO, persistentUser);

                if (status.equalsIgnoreCase("ok")) {
                    request.setAttribute("status", "ok");
                } else {
                    request.setAttribute("status", "no");
                }

                sourceDestinationLst = new ArrayList<WebBusinessObject>();
                try {
                    CostCenterList = projectMgr.getOnArbitraryKey2("1475660555820", "key2");
                    purposeArrayList = projectMgr.getOnArbitraryKey2("1476862041589", "key2");
                    sourceDestinationLst = LocationTypeMgr.getInstance().getLocationTypeUsingLike("FIN_");
                } catch (Exception ex) {
                    System.out.println("Exception : " + ex.getMessage());
                }

                arrayOfContractors = clientMgr.getListOfContractors();

                request.setAttribute("clientsList", arrayOfContractors);
                request.setAttribute("purposeArrayList", purposeArrayList);
                request.setAttribute("CostCenterList", CostCenterList);
                request.setAttribute("sourceDestinationLst", sourceDestinationLst);

                servedPage = "/docs/Financials/New_Financial_Document.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 22:
                servedPage = "/docs/Financials/installment_form.jsp";
                WebBusinessObject unitWbo = projectMgr.getOnSingleKey(request.getParameter("projectID"));
                ArrayList<WebBusinessObject> paymentPlansList = new ArrayList<>();
                StandardPaymentPlanMgr standardPaymentPlanMgr = StandardPaymentPlanMgr.getInstance();
                double totalPrice = Double.valueOf(request.getParameter("price"));
                double addonPrice = Double.valueOf(request.getParameter("addonPrice"));
                WebBusinessObject selectedPlanWbo = null;
                try {
                    paymentPlansList = new ArrayList<>(standardPaymentPlanMgr.getOnArbitraryKeyOracle((String) unitWbo.getAttribute("mainProjId"), "key2"));
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(FinancialServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                if (request.getParameter("paymentPlanID") != null && !request.getParameter("paymentPlanID").isEmpty()) {
                    selectedPlanWbo = standardPaymentPlanMgr.getOnSingleKey(request.getParameter("paymentPlanID"));
                } else if (!paymentPlansList.isEmpty()) {
                    selectedPlanWbo = paymentPlansList.get(0);
                }
                if (request.getParameter("clientID") != null && request.getSession().getAttribute("activeClientID") == null) {
                    request.getSession().setAttribute("activeClientID", request.getParameter("clientID"));
                }
                if (selectedPlanWbo != null) {
                    double reservation = Double.parseDouble((String) selectedPlanWbo.getAttribute("reservation"));
                    double downPayment = Double.parseDouble((String) selectedPlanWbo.getAttribute("downAMT"));
                    double maintenance = Math.round((totalPrice * 0.05) / 12 / 100) * 100;
                    int installmentsNo = Integer.parseInt((String) selectedPlanWbo.getAttribute("installmentAmt"));
                    int downPaymentAfter = Integer.parseInt((String) selectedPlanWbo.getAttribute("downDate"));
                    int firstAfter = Integer.parseInt((String) selectedPlanWbo.getAttribute("fristInstallDate"));
                    double tempVal, tempAddonVal;
                    double totalCalculate = 0, addonCalculate = 0;
                    DecimalFormat df = new DecimalFormat("#.00");
                    ArrayList<WebBusinessObject> installmentsList = new ArrayList<>();
                    c = Calendar.getInstance();
                    String startDate = request.getParameter("startDate");
                    sdf = new SimpleDateFormat("yyyy/MM/dd");
                    if(startDate != null && !startDate.isEmpty()) {
                        try {
                            c.setTime(sdf.parse(startDate));
                        } catch (ParseException ex) {
                            java.util.logging.Logger.getLogger(FinancialServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    } else {
                        startDate = sdf.format(c.getTime());
                    }
                    sdf.applyPattern("dd-MMM-yy");
                    WebBusinessObject installmentWbo = new WebBusinessObject();
                    installmentWbo.setAttribute("percent", df.format(reservation) + "");
                    tempVal = Math.round((totalPrice * reservation / 100) / 100) * 100;
                    totalCalculate += tempVal;
                    installmentWbo.setAttribute("amount", df.format(tempVal) + "");
                    installmentWbo.setAttribute("totalAmount", df.format(tempVal) + "");
                    installmentWbo.setAttribute("month", "0");
                    installmentWbo.setAttribute("date", sdf.format(c.getTime()));
                    installmentsList.add(installmentWbo);
                    installmentWbo = new WebBusinessObject();
                    installmentWbo.setAttribute("percent", df.format(downPayment) + "");
                    tempVal = Math.round((totalPrice * downPayment / 100) / 100) * 100;
                    totalCalculate += tempVal;
                    installmentWbo.setAttribute("amount", df.format(tempVal));
                    installmentWbo.setAttribute("totalAmount", df.format(tempVal));
                    installmentWbo.setAttribute("month", downPaymentAfter + "");
                    c.add(Calendar.MONTH, downPaymentAfter);
                    installmentWbo.setAttribute("date", sdf.format(c.getTime()));
                    installmentsList.add(installmentWbo);
                    double installmentPercent = (100 - reservation - downPayment) / installmentsNo;
                    for (int i = 0; i < installmentsNo; i++) {
                        installmentWbo = new WebBusinessObject();
                        installmentWbo.setAttribute("percent", df.format(installmentPercent) + "");
                        if(i == installmentsNo - 1) {
                            tempVal = totalPrice - totalCalculate;
                            tempAddonVal = addonPrice - addonCalculate;
                        } else {
                            tempVal = Math.round((totalPrice * installmentPercent / 100) / 100) * 100;
                            tempAddonVal = Math.round((addonPrice / installmentsNo) / 100) * 100;
                        }
                        totalCalculate += tempVal;
                        addonCalculate += tempAddonVal;
                        installmentWbo.setAttribute("amount", df.format(tempVal));
                        installmentWbo.setAttribute("addon", df.format(tempAddonVal));
                        installmentWbo.setAttribute("totalAmount", df.format(tempVal + tempAddonVal));
                        installmentWbo.setAttribute("month", (firstAfter * (i + 1) + downPaymentAfter) + "");
                        c.add(Calendar.MONTH, firstAfter);
                        installmentWbo.setAttribute("date", sdf.format(c.getTime()));
                        if(i < 12) {
                            if(i == 11) {
                                maintenance = (totalPrice * 0.05) - (11 * maintenance);
                            }
                            installmentWbo.setAttribute("maintenance", df.format(maintenance));
                        }
                        installmentsList.add(installmentWbo);
                    }
                    request.setAttribute("installmentsList", installmentsList);
                    request.setAttribute("paymentPlansList", paymentPlansList);
                    request.setAttribute("paymentPlanID", selectedPlanWbo.getAttribute("id"));
                    request.setAttribute("startDate", startDate);
                }
                request.setAttribute("projectID", request.getParameter("projectID"));
                request.setAttribute("projectName", unitWbo.getAttribute("projectName"));
                request.setAttribute("price", totalPrice + "");
                request.setAttribute("addonPrice", addonPrice + "");
                request.setAttribute("activeClientWbo", request.getSession().getAttribute("activeClientID") != null
                        ? clientMgr.getOnSingleKey((String) request.getSession().getAttribute("activeClientID")) : null);
                this.forward(servedPage, request, response);
                break;
            case 23:
                wbo = new WebBusinessObject();
                wbo.setAttribute("status", "fail");
                try {
                    String[] paymentType = request.getParameterValues("paymentType");
                    String[] paymentAmount = request.getParameterValues("paymentAmount");
                    String[] paymentDate = request.getParameterValues("paymentDate");
                    String paymentPlanID = request.getParameter("paymentPlanID");
                    standardPaymentPlanMgr = StandardPaymentPlanMgr.getInstance();
                    WebBusinessObject paymentPlanWbo = standardPaymentPlanMgr.getOnSingleKey(paymentPlanID);
                    SimpleDateFormat inFormat = new SimpleDateFormat("dd-MMM-yy");
                    SimpleDateFormat outFormat = new SimpleDateFormat("yyyy/MM/dd");
                    String downDate = outFormat.format(inFormat.parse(paymentDate[0]));
                    String insDate = outFormat.format(inFormat.parse(paymentDate[1]));
                    PaymentPlanMgr paymentPlanMgr = PaymentPlanMgr.getInstance();
                    String planID = null;
                    try {
                        planID = paymentPlanMgr.saveObject(request.getParameter("unitID"), request.getParameter("clientID"),
                                (String) paymentPlanWbo.getAttribute("planTitle"), (String) paymentPlanWbo.getAttribute("reservation"),
                                (String) paymentPlanWbo.getAttribute("downAMT"), downDate, "", insDate,
                                (String) paymentPlanWbo.getAttribute("installmentAmt"), "0",
                                (String) persistentUser.getAttribute("userId"), request.getParameter("totalPrice"),
                                "", paymentPlanID, "spp");
                        if (paymentPlanMgr.saveInstallments(planID, paymentDate, (String) paymentPlanWbo.getAttribute("planTitle"),
                                paymentAmount, (String) persistentUser.getAttribute("userId"), paymentType)
                                && paymentPlanMgr.approvePaymentPlan(planID, session)) {
                            wbo.setAttribute("status", "ok");
                        }
                    } catch (SQLException ex) {
                        java.util.logging.Logger.getLogger(FinancialServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                } catch (ParseException ex) {
                    java.util.logging.Logger.getLogger(FinancialServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
                
            case 24:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                WebBusinessObject projectD = new WebBusinessObject();
                projectD.setAttribute("code", request.getParameter("code"));
                projectD.setAttribute("name", request.getParameter("arabic_name"));

                try {
                    if (projectMgr.saveTransType(projectD, session)) {
                        wbo.setAttribute("status", "ok");
                        wbo.setAttribute("code", request.getParameter("code"));
                        wbo.setAttribute("name", request.getParameter("arabic_name"));
                    } else {
                        wbo.setAttribute("status", "fail");
                    }
                } catch (NoUserInSessionException ex) {
                    java.util.logging.Logger.getLogger(FinancialServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                out.write(Tools.getJSONObjectAsString(wbo));
                break;
                
            case 25:
                servedPage = "/docs/Financials/financialTransactionSearchByDocNumber.jsp";
                fromDate = request.getParameter("fromDate");
                toDate = request.getParameter("toDate");
                String type= request.getParameter("smry");
                String SearchNum=request.getParameter("SearchNum");
                financialTransactionMgr=FinancialTransactionMgr.getInstance();
                ArrayList<WebBusinessObject> datalist=null;
                String code="";
                if(type!=null){
                if(type.equals("1"))
                    code="DOCUMENT_CODE";
                else if(type.equals("0"))
                    code="TRANSACTION_CODE";
                }
                if (fromDate != null && toDate != null) {
                 datalist= financialTransactionMgr.getFinancialTransactionsBycolumnName(fromDate,toDate,SearchNum,code);
                }
                 dateParser = new DateParser();
                jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                c = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (toDate == null) {
                    toDate = sdf.format(c.getTime());
                }

                if (fromDate == null) {
                    c.add(Calendar.MONTH, -1);
                    fromDate = sdf.format(c.getTime());
                }
                request.setAttribute("dataLst", datalist);
                request.setAttribute("SearchNum", SearchNum);
                request.setAttribute("smry", type);
                request.setAttribute("fromDate", fromDate);
                request.setAttribute("toDate", toDate);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 26:
                servedPage = "/docs/Financials/financialTransactionSearchValue.jsp";
                fromDate = request.getParameter("fromDate");
                toDate = request.getParameter("toDate");
                 SearchNum=request.getParameter("SearchNum");
                financialTransactionMgr=FinancialTransactionMgr.getInstance();
                  datalist=null;
                 code="TRANSACTION_NET_VALUE";
                 if (fromDate != null && toDate != null) {
                 datalist= financialTransactionMgr.getFinancialTransactionsBycolumnName(fromDate,toDate,SearchNum,code);
                }
                 dateParser = new DateParser();
                jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                c = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (toDate == null) {
                    toDate = sdf.format(c.getTime());
                }

                if (fromDate == null) {
                    c.add(Calendar.MONTH, -1);
                    fromDate = sdf.format(c.getTime());
                }
                request.setAttribute("dataLst", datalist);
                request.setAttribute("SearchNum", SearchNum);
                 request.setAttribute("fromDate", fromDate);
                request.setAttribute("toDate", toDate);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 27:
                servedPage = "/docs/Financials/financialTransactionSearchByRecipient.jsp";
                fromDate = request.getParameter("fromDate");
                toDate = request.getParameter("toDate");
                 financialTransactionMgr=FinancialTransactionMgr.getInstance();
                  datalist=null;
                  String recepients[]=request.getParameterValues("contractorList");
                  if (fromDate != null && toDate != null &&recepients!=null) {
                 datalist= financialTransactionMgr.getFinancialTransactionsByRecipient(fromDate,toDate,recepients);
                }
                 dateParser = new DateParser();
                jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                c = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (toDate == null) {
                    toDate = sdf.format(c.getTime());
                }

                if (fromDate == null) {
                    c.add(Calendar.MONTH, -1);
                    fromDate = sdf.format(c.getTime());
                }
                ArrayList<WebBusinessObject> RecipientList=financialTransactionMgr.getAllRecipients();
                request.setAttribute("recepients", recepients);
                 request.setAttribute("RecipientList", RecipientList);
                request.setAttribute("dataLst", datalist);
                  request.setAttribute("fromDate", fromDate);
                request.setAttribute("toDate", toDate);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 28:
                servedPage = "/docs/Financials/search_transaction_by_type.jsp";
                financialTransactionMgr = FinancialTransactionMgr.getInstance();
                
                try {
                    FAccountType = projectMgr.getOnArbitraryKey2("ACC_ITM", "key4");
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(FinancialServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("FAccountType",FAccountType);
                Calendar    cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                fromDate = request.getParameter("fromDate") != null ? request.getParameter("fromDate") : sdf.format(cal.getTime());
                toDate = request.getParameter("toDate") != null ? request.getParameter("toDate") : sdf.format(cal.getTime());
                String accountID = request.getParameter("accountID");
                 String TransactionType=request.getParameter("transactionType");
                 request.setAttribute("TransactionType", TransactionType);
                java.sql.Date fromD9;
                java.sql.Date toD9;
                try {
                    fromD9 = new java.sql.Date(sdf.parse(fromDate).getTime());
                    toD9 = new java.sql.Date(sdf.parse(toDate).getTime());
                } catch (ParseException ex) {
                    fromD9 = new java.sql.Date(cal.getTimeInMillis());
                    toD9 = new java.sql.Date(cal.getTimeInMillis());
                }
                if (accountID != null) {
                   WebBusinessObject  openBalanceWbo = financialTransactionMgr.getAccountOpeningBalance(accountID, fromD9);
                    ArrayList<WebBusinessObject> balanceList = financialTransactionMgr.searchTransactionByType(accountID, fromD9, toD9,TransactionType);
                    request.setAttribute("openBalanceWbo", openBalanceWbo);
                    request.setAttribute("balanceList", balanceList);
                    request.setAttribute("accountType", request.getParameter("accountType"));
                }
                request.setAttribute("fromDate", fromDate);
                request.setAttribute("toDate", toDate);
                request.setAttribute("accountID", accountID);
                request.setAttribute("accountTypesList", LocationTypeMgr.getInstance().getLocationTypeUsingLike("FIN_"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
             case 29:
                servedPage = "/docs/Financials/financialTransactionsReport.jsp";

                cal = Calendar.getInstance();
                String jDateFormat = "yyyy/MM/dd";
                 sdf = new SimpleDateFormat(jDateFormat);

               String beginDate = request.getParameter("beginDate") != null ? request.getParameter("beginDate") : sdf.format(cal.getTime());
               String  endDate = request.getParameter("endDate") != null ? request.getParameter("endDate") : sdf.format(cal.getTime());

                 financialTransactionMgr = FinancialTransactionMgr.getInstance();
                ArrayList<WebBusinessObject> finTrnsLst = financialTransactionMgr.getFinancialTransactions(beginDate, endDate);

                request.setAttribute("beginDate", beginDate);
                request.setAttribute("endDate", endDate);
                request.setAttribute("finTrnsLst", finTrnsLst);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
             case 30:
                cal = Calendar.getInstance();
                jDateFormat = "yyyy/MM/dd";
                sdf = new SimpleDateFormat(jDateFormat);
                beginDate = request.getParameter("beginDate") != null ? request.getParameter("beginDate") : sdf.format(cal.getTime());
                endDate = request.getParameter("endDate") != null ? request.getParameter("endDate") : sdf.format(cal.getTime());
                financialTransactionMgr = FinancialTransactionMgr.getInstance();
                finTrnsLst = financialTransactionMgr.getFinancialTransactions(beginDate, endDate);

                String headers2[] = {"#", "Document Series", "Document No", "Document Date", "Accounting entry", "Transaction Type", "Purpose", "Transaction value", "Net Value", "The Creditor", "Creditor Type", "Debtor type", "The Debtor", "Notes"};
                String attributes2[] = {"", "documentNo", "documentCode", "documentDate", "transactionCode", "finTrnsTyp", "purpose", "transValue", "transNetValue", "srcEnDesc", "srcNm", "dstEnDsc", "dstNm", "note"};
                String dataTypes2[] = {"", "String", "String", "String", "String", "String", "String", "String", "String", "String", "String", "String", "String", "String"};
                 HSSFWorkbook  workBook = Tools.createExcelReport("Financial_transaction_report", "Financial Transaction  Report", headers2, attributes2, dataTypes2, new ArrayList(finTrnsLst));

                c = Calendar.getInstance();
                java.util.Date  fileDate = c.getTime();
                SimpleDateFormat    df = new SimpleDateFormat("dd-MM-yyyy");
                String  reportDate = df.format(fileDate);
                String filename = "Financial_transaction_report" + reportDate;

                ServletOutputStream servletOutputStream = response.getOutputStream();
                 ByteArrayOutputStream   bos = new ByteArrayOutputStream();
                try {
                    workBook.write(bos);
                } finally {
                    bos.close();
                }
                byte[] bytes = bos.toByteArray();
                System.out.println(bytes.length);
//                bytes = bos.toByteArray();

                response.setContentType("application/vnd.ms-excel");
                response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + ".xls\"");
                response.setContentLength(bytes.length);
                servletOutputStream.write(bytes, 0, bytes.length);

                servletOutputStream.flush();
                servletOutputStream.close();

                break;
             case 31:
                servedPage = "/docs/Financials/balance_report.jsp";
                financialTransactionMgr = FinancialTransactionMgr.getInstance();
                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                fromDate = request.getParameter("fromDate") != null ? request.getParameter("fromDate") : sdf.format(cal.getTime());
                toDate = request.getParameter("toDate") != null ? request.getParameter("toDate") : sdf.format(cal.getTime());
                 accountID = request.getParameter("accountID");
                java.sql.Date fromD1;
                java.sql.Date toD1;
                try {
                    fromD1 = new java.sql.Date(sdf.parse(fromDate).getTime());
                    toD1 = new java.sql.Date(sdf.parse(toDate).getTime());
                } catch (ParseException ex) {
                    fromD1 = new java.sql.Date(cal.getTimeInMillis());
                    toD1 = new java.sql.Date(cal.getTimeInMillis());
                }
                if (accountID != null) {
                    WebBusinessObject openBalanceWbo = financialTransactionMgr.getAccountOpeningBalance(accountID, fromD1);
                    
                    ArrayList<WebBusinessObject> balanceList = financialTransactionMgr.getBalanceReport(accountID, fromD1, toD1);
                    request.setAttribute("openBalanceWbo", openBalanceWbo);
                    request.setAttribute("balanceList", balanceList);
                    request.setAttribute("accountType", request.getParameter("accountType"));
                }
                request.setAttribute("fromDate", fromDate);
                request.setAttribute("toDate", toDate);
                request.setAttribute("accountID", accountID);
                request.setAttribute("accountTypesList", LocationTypeMgr.getInstance().getLocationTypeUsingLike("FIN_"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 32:
                fromDate = request.getParameter("fromDate");
                toDate = request.getParameter("toDate");

                ArrayList<WebBusinessObject> Data = new ArrayList<WebBusinessObject>();
                financialTransactionMgr = FinancialTransactionMgr.getInstance();
                java.sql.Date fromD2;
                java.sql.Date toD2;
                cal = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                accountID = request.getParameter("accountID");
                String accountName = request.getParameter("accountName");
                try {
                    fromD2 = new java.sql.Date(sdf.parse(fromDate).getTime());
                    toD2 = new java.sql.Date(sdf.parse(toDate).getTime());
                } catch (ParseException ex) {
                    fromD2 = new java.sql.Date(cal.getTimeInMillis());
                    toD2 = new java.sql.Date(cal.getTimeInMillis());
                }
                Data = financialTransactionMgr.getBalanceReport(accountID, fromD2, toD2);

                WebBusinessObject openBalanceWbo = financialTransactionMgr.getAccountOpeningBalance(accountID, fromD2);
                if (openBalanceWbo != null) {
                    WebBusinessObject openBalanceWbo1 = new WebBusinessObject();
                    openBalanceWbo1.setAttribute("note", "Period Opening Balance");
                    openBalanceWbo1.setAttribute("netAmount", openBalanceWbo.getAttribute("balance"));
                    openBalanceWbo1.setAttribute("debitValue", "0");
                    openBalanceWbo1.setAttribute("creditValue", "0");
                    openBalanceWbo1.setAttribute("transactionType", " ");
                    openBalanceWbo1.setAttribute("creditName", " ");
                    openBalanceWbo1.setAttribute("documentDate", " ");
                    openBalanceWbo1.setAttribute("documentCode", " ");
                    openBalanceWbo1.setAttribute("transactionCode", " ");
                    Data.add(0,openBalanceWbo1);
                }
                double netAmount = 0;
                double totalCredit1=0;
                double totalDebit=0;
                for (WebBusinessObject dataWbo : Data) {
                     netAmount = 0;
                    netAmount += Double.valueOf((String) dataWbo.getAttribute("debitValue"));
                    netAmount -= Double.valueOf((String) dataWbo.getAttribute("creditValue"));
                    totalCredit1+= Double.valueOf((String) dataWbo.getAttribute("creditValue"));
                    totalDebit+=Double.valueOf((String) dataWbo.getAttribute("debitValue"));
                    dataWbo.setAttribute("netAmount", netAmount);
                }
                WebBusinessObject openBalanceWbo1 = new WebBusinessObject();
                    openBalanceWbo1.setAttribute("note", "total");
                    openBalanceWbo1.setAttribute("netAmount", totalDebit- totalCredit1);
                    openBalanceWbo1.setAttribute("debitValue",totalDebit);
                    openBalanceWbo1.setAttribute("creditValue",totalCredit1);
                    openBalanceWbo1.setAttribute("transactionType", " ");
                    openBalanceWbo1.setAttribute("creditName", " ");
                    openBalanceWbo1.setAttribute("documentDate", " ");
                    openBalanceWbo1.setAttribute("documentCode", " ");
                    openBalanceWbo1.setAttribute("transactionCode", " ");
                    Data.add(openBalanceWbo1);
                String headers1[] = {"#", "Document Code","Transaction Code","Balance", "Debit", "Credit", "Note", "Operation Type", "receiving from ", "dispensing to", "Date"};
                String attributes1[] = {"","documentCode","transactionCode", "netAmount", "debitValue", "creditValue", "note", "transactionType", "creditName", "debitName", "documentDate"};
                String dataTypes1[] = {"","String","String", "String", "String", "String", "String", "String", "String", "String", "String"};
                workBook = Tools.createExcelReport("Balance_report", "Balance Report for " + accountName, headers1, attributes1, dataTypes1, new ArrayList(Data));

                c = Calendar.getInstance();
                 fileDate = c.getTime();
                 df = new SimpleDateFormat("dd-MM-yyyy");
                 reportDate = df.format(fileDate);
                 filename = "Balance_report" + reportDate;

                 servletOutputStream = response.getOutputStream();
                 bos = new ByteArrayOutputStream();
                try {
                    workBook.write(bos);
                } finally {
                    bos.close();
                }
               bytes = bos.toByteArray();
                System.out.println(bytes.length);
//                bytes = bos.toByteArray();

                response.setContentType("application/vnd.ms-excel");
                response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + ".xls\"");
                response.setContentLength(bytes.length);
                servletOutputStream.write(bytes, 0, bytes.length);

                servletOutputStream.flush();
                servletOutputStream.close();

                break;

            case 33:
                servedPage = "/docs/Financials/mapFinTreeWithFinTransaction.jsp";
                String RootID=request.getParameter("rootID");
                String ids[]=request.getParameterValues("ids");
                String transType=request.getParameter("transType");
                request.setAttribute("transType", transType);
                ArrayList<WebBusinessObject> nodes=null;
                try{
                    FAccountType = projectMgr.getOnArbitraryKey2("ACC_ITM", "key4");
                    nodes=projectMgr.getAllNodes();
                    request.setAttribute("FAccountType",FAccountType);
                    request.setAttribute("nodes",nodes);
                }catch(Exception SE)
                {
                   
                }
                if(request.getParameter("save")!=null&&request.getParameter("save").equals("true")&&ids!=null &&ids.length>0 )//map item to transaction type
                {
                    for(int i=0;i<ids.length;i++)
                    {
                        WebBusinessObject recordWbo=new WebBusinessObject();
                        recordWbo.setAttribute("TypeID", transType);
                        recordWbo.setAttribute("itemID", ids[i]);
                      String status1= finTransaction.insertTreeTransactionTypeRel(recordWbo);
                      request.setAttribute("status", status1);
                    }
                }
                
                if(RootID!=null)                     //get root child
                {
                  ArrayList<WebBusinessObject>childList=  projectMgr.getAllNodeChild(RootID);
                  request.setAttribute("childList", childList);
                  request.setAttribute("nodeID", RootID);
                }
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                
                break;

            case 34: 
                 out = response.getWriter();
                 wbo = new WebBusinessObject();
                 String itemId=request.getParameter("itemID");
                 String status1= finTransaction.detechTreeItem(itemId);
                 wbo.setAttribute("status", status1);
                 out.write(Tools.getJSONObjectAsString(wbo));
                break;
                
            case 35:
                servedPage = "/docs/Financials/ViewFinanceTree.jsp";
                ArrayList<WebBusinessObject>TreeItems=  projectMgr.getAllFinTreeItem();
                request.setAttribute("TreeItems", TreeItems);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 36:
                servedPage = "/docs/Financials/clientsFinancialTransactionRprt.jsp";
                fromDate = request.getParameter("fromDate");
                toDate = request.getParameter("toDate");
                String contractor = request.getParameter("contractor");

                financialTransactionMgr = FinancialTransactionMgr.getInstance();
                  PaymentPlanMgr paymentPlanMgr = PaymentPlanMgr.getInstance();
                if (fromDate != null && toDate != null) {
                    invoiceMgr = InvoiceMgr.getInstnace();
                     invoicesList=paymentPlanMgr.getClientInstallments(contractor,fromDate,toDate);
                    try {
                        transactionsList = new ArrayList<>(financialTransactionMgr.getTransactionsList(request.getParameter("contractor"), fromDate, toDate));
                    } catch (Exception ex) {
                        transactionsList = new ArrayList<>();
                    }
                    request.setAttribute("invoicesList", invoicesList);
                    request.setAttribute("transactionsList", transactionsList);
                }
                
                kindsList = clientMgr.getAllPurchOwnerClient();
                dateParser = new DateParser();
                jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
                c = Calendar.getInstance();
                sdf = new SimpleDateFormat("yyyy/MM/dd");
                if (toDate == null) {
                    toDate = sdf.format(c.getTime());
                }

                if (fromDate == null) {
                    c.add(Calendar.MONTH, -1);
                    fromDate = sdf.format(c.getTime());
                }

                request.setAttribute("contractor", contractor);
                request.setAttribute("kindsList", kindsList);
                request.setAttribute("fromDate", fromDate);
                request.setAttribute("toDate", toDate);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

                
        }
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Financial Servlet";
    }

    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("getFinanceTree")) {
            return 1;
        } else if (opName.equalsIgnoreCase("buildFinanceTree")) {
            return 2;
        } else if (opName.equalsIgnoreCase("newFinancialTransAction")) {
            return 3;
        } else if (opName.equalsIgnoreCase("getKindsList")) {
            return 4;
        } else if (opName.equalsIgnoreCase("saveFinTransaction")) {
            return 5;
        } else if (opName.equalsIgnoreCase("deleteAccount")) {
            return 6;
        } else if (opName.equalsIgnoreCase("selectFinanaceTreeItem")) {
            return 7;
        } else if (opName.equalsIgnoreCase("getCostCenterTree")) {
            return 8;
        } else if (opName.equalsIgnoreCase("buildCostCenterTree")) {
            return 9;
        } else if (opName.equals("newExpenseItem")) {
            return 10;
        } else if (opName.equals("saveExpenseItem")) {
            return 11;
        } else if (opName.equals("viewExpenseItem")) {
            return 12;
        } else if (opName.equals("viewCostItem")) {
            return 13;
        } else if (opName.equals("deleteExpenseItem")) {
            return 14;
        } else if (opName.equals("unitsFinancialTransactionRprt")) {
            return 15;
        } else if (opName.equalsIgnoreCase("getUnitPlanDetails")) {
            return 16;
        } else if (opName.equalsIgnoreCase("installmentToBeColRprt")) {
            return 17;
        } else if (opName.equalsIgnoreCase("FinancialTransactionRprt")) {
            return 18;
        } else if (opName.equals("getVendorDetails")) {
            return 19;
        } else if (opName.equals("getNewFinancialDocument")) {
            return 20;
        } else if (opName.equals("saveFinDocument")) {
            return 21;
        } else if (opName.equals("getInstallmentsForm")) {
            return 22;
        } else if (opName.equals("saveInstallmentsAjax")) {
            return 23;
        } else if (opName.equals("saveSeason")) {
            return 24;
        }else if (opName.equals("financialTransactionSearchByDocNumber")) {
            return 25;
        }else if (opName.equals("financialTransactionSearchValue")) {
            return 26;
        }else if (opName.equals("financialTransactionSearchByRecipient")) {
            return 27;
        }else if (opName.equals("financialTransactionSearchByType")) {
            return 28;
        }else if (opName.equals("financialTransactionsReport")) {
            return 29;
        }else if (opName.equals("financialTransactionReport")) {
            return 30;
        } else if (opName.equals("balanceReport")) {
            return 31;
        } else if (opName.equals("balanceReportToExcel")) {
            return 32;
        }else if (opName.equals("AttachTreeWithTransaction")) {
            return 33;
        }else if (opName.equals("detechItemTree")) {
            return 34;
        }
        else if (opName.equals("ViewFinanceTree")) {
            return 35;
        }else if (opName.equals("clientStatOfAcc")) {
            return 36;
        }
        

        return 0;
    }

    private void getChilds(String projectParentID, int parentID) {
        try {
            String icon = "";
            String projectName = "";
            Vector childVec = new Vector();
            WebBusinessObject treeNodeWBO = new WebBusinessObject();

            JSONObject contextMenu = new JSONObject();
            JSONArray menuElements = new JSONArray();
            childVec = projectMgr.getOnArbitraryKey(projectParentID, "key2");
            if (childVec.size() > 0) {
                for (int i = 0; i < childVec.size(); i++) {
                    int currentID = this.JsonList.size();
                    JSONObject josnObj = new JSONObject();
                    treeNodeWBO = (WebBusinessObject) childVec.get(i);

                    if (treeNodeWBO.getAttribute("eqNO").toString().equals("BANKS")) {
                        contextMenu = (JSONObject) this.jsonMenu.get((String) treeNodeWBO.getAttribute("eqNO"));
                    } else if (treeNodeWBO.getAttribute("eqNO").toString().equals("SAFS")) {
                        contextMenu = (JSONObject) this.jsonMenu.get((String) treeNodeWBO.getAttribute("eqNO"));
                    } else {
                        contextMenu = (JSONObject) this.jsonMenu.get((String) treeNodeWBO.getAttribute("location_type"));
                    }
                    icon = (String) contextMenu.get("icon");
                    menuElements = (JSONArray) contextMenu.get("menuItem");
                    if (treeNodeWBO.getAttribute("location_type").toString().equals("ACCTM")) {
                        projectName = (String) treeNodeWBO.getAttribute("projectName");
                    } else if (treeNodeWBO.getAttribute("location_type").toString().equals("ACCTB")) {
                        projectName = (String) treeNodeWBO.getAttribute("projectName");
                    } else if (treeNodeWBO.getAttribute("eqNO").toString().equals("SAFS")) {
                        projectName = (String) treeNodeWBO.getAttribute("projectName");
                    } else if (treeNodeWBO.getAttribute("eqNO").toString().equals("BANKS")) {
                        projectName = (String) treeNodeWBO.getAttribute("projectName");
                    } else if (treeNodeWBO.getAttribute("location_type").toString().equals("FIN_BNK")) {
                        projectName = (String) treeNodeWBO.getAttribute("projectName");
                    } else if (treeNodeWBO.getAttribute("location_type").toString().equals("FIN_SAFE")) {
                        projectName = (String) treeNodeWBO.getAttribute("projectName");
                    }

                    josnObj.put("id", new Integer(currentID).toString());
                    josnObj.put("projectID", (String) treeNodeWBO.getAttribute("projectID"));
                    josnObj.put("parentid", parentID);
                    josnObj.put("text", projectName);
                    josnObj.put("icon", icon);
                    josnObj.put("type", (String) treeNodeWBO.getAttribute("location_type"));
                    josnObj.put("contextMenu", menuElements);
                    this.JsonList.add(josnObj);

                    getChilds((String) treeNodeWBO.getAttribute("projectID"), currentID);
                }
            }
        } catch (Exception ex) {
            System.out.println("Error:" + ex.getMessage());
        }
    }

    private void getCostCenterChilds(String projectParentID, int parentID) {
        try {
            String icon = "";
            String projectName = "";
            Vector childVec = new Vector();
            WebBusinessObject treeNodeWBO = new WebBusinessObject();

            JSONObject contextMenu = new JSONObject();
            JSONArray menuElements = new JSONArray();
            childVec = projectMgr.getOnArbitraryKey(projectParentID, "key2");

            if (childVec.size() > 0) {
                for (int i = 0; i < childVec.size(); i++) {
                    int currentID = this.JsonList.size();
                    JSONObject josnObj = new JSONObject();
                    treeNodeWBO = (WebBusinessObject) childVec.get(i);

                    contextMenu = (JSONObject) this.jsonMenu.get((String) treeNodeWBO.getAttribute("location_type"));
                    icon = (String) contextMenu.get("icon");
                    menuElements = (JSONArray) contextMenu.get("menuItem");
                    projectName = (String) treeNodeWBO.getAttribute("projectName");

                    josnObj.put("id", new Integer(currentID).toString());
                    josnObj.put("projectID", (String) treeNodeWBO.getAttribute("projectID"));
                    josnObj.put("parentid", parentID);
                    josnObj.put("text", projectName);
                    josnObj.put("icon", icon);
                    josnObj.put("type", (String) treeNodeWBO.getAttribute("location_type"));
                    josnObj.put("contextMenu", menuElements);
                    this.JsonList.add(josnObj);

                    getCostCenterChilds((String) treeNodeWBO.getAttribute("projectID"), currentID);
                }
            }
        } catch (Exception ex) {
            System.out.println("Error:" + ex.getMessage());
        }
    }
}
