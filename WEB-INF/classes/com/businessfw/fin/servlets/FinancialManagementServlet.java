package com.businessfw.fin.servlets;

import com.android.business_objects.LiteWebBusinessObject;
import com.businessfw.fin.db_access.ChannelsExpenseMgr;
import com.businessfw.hrs.db_access.EmployeeFinanceMgr;
import com.businessfw.hrs.db_access.EmployeeMgr;
import com.clients.db_access.ClientMgr;
import com.financials.db_access.ExpenseItemMgr;
import com.maintenance.common.Tools;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.planning.db_access.SeasonMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.db_access.PersistentSessionMgr;
import com.tracker.servlets.TrackerBaseServlet;
import java.sql.Date;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.annotation.MultipartConfig;
import com.android.business_objects.LiteWebBusinessObject;
import com.businessfw.fin.db_access.ChannelsExpenseMgr;
import com.businessfw.hrs.db_access.EmployeeFinanceMgr;
import com.businessfw.hrs.db_access.EmployeeMgr;
import com.businessfw.hrs.db_access.EmployeeSalaryConfigMgr;
import com.businessfw.hrs.db_access.EmployeeTransactionMgr;
import com.businessfw.hrs.financials.Additions;
import com.businessfw.hrs.financials.BasicSalary;
import com.businessfw.hrs.financials.SalaryItem;
import com.clients.db_access.ClientMgr;
import com.financials.db_access.ExpenseItemMgr;
import com.maintenance.common.Tools;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.planning.db_access.SeasonMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.db_access.PersistentSessionMgr;
import com.tracker.servlets.TrackerBaseServlet;
import java.sql.Date;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.annotation.MultipartConfig;
import com.businessfw.hrs.financials.BasicSalary;
import com.businessfw.hrs.financials.Bouns;
import com.businessfw.hrs.financials.Food;
import com.businessfw.hrs.financials.Insurance;
import com.businessfw.hrs.financials.Movments;
import com.businessfw.hrs.financials.Punch;
import com.businessfw.hrs.financials.Visits;
import com.businessfw.hrs.financials.RetirementValue;
import com.businessfw.hrs.financials.HealthInsurance;
import com.businessfw.hrs.financials.Taxes;
import com.tracker.db_access.CampaignMgr;
import java.math.BigDecimal;

@MultipartConfig
public class FinancialManagementServlet extends TrackerBaseServlet {

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
        PrintWriter out;
        String remoteAccess = session.getId();
        WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);
        SeasonMgr seasonMgr = SeasonMgr.getInstance();
        ClientMgr clientMgr = ClientMgr.getInstance();
        ChannelsExpenseMgr channelsExpenseMgr = ChannelsExpenseMgr.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        operation = getOpCode(request.getParameter("op"));
        CampaignMgr campaignMgr=CampaignMgr.getInstance();
        switch (operation) {
            case 1:
                servedPage = "/docs/financial/new_expense.jsp";
               
                request.setAttribute("channelWbo", seasonMgr.getOnSingleKey(request.getParameter("id")));
                try {
                    request.setAttribute("companiesList", new ArrayList<>(clientMgr.getOnArbitraryKeyOrdered("100", "key11", "key5")));
                } catch (Exception ex) {
                    request.setAttribute("companiesList", new ArrayList<>());
                }
                this.forward(servedPage, request, response);
                break;
            case 2:
                out = response.getWriter();
                LiteWebBusinessObject wbo = new LiteWebBusinessObject();
                LiteWebBusinessObject result = new LiteWebBusinessObject();
                wbo.setAttribute("channelID", request.getParameter("channelID"));
                wbo.setAttribute("companyID", request.getParameter("companyID"));
               
                wbo.setAttribute("expenseDate",  request.getParameter("expenseDate"));
                wbo.setAttribute("amount", Double.valueOf((String) request.getParameter("amount")));
                wbo.setAttribute("currencyType", request.getParameter("currencyType"));
                wbo.setAttribute("createdBy", persistentUser.getAttribute("userId"));
                wbo.setAttribute("option1", request.getParameter("exchangeRate"));
                wbo.setAttribute("option2", request.getParameter("paidAmount"));
                if(request.getParameter("objectType")!=null)
                {
                     wbo.setAttribute("option3", request.getParameter("objectType"));
                }
                else
                {
                     wbo.setAttribute("option3", "UL");
                }
               
                wbo.setAttribute("option4", "UL");
                wbo.setAttribute("option5", "UL");
                wbo.setAttribute("option6", "UL");
                result.setAttribute("status", "failed");
                try {
                    if (channelsExpenseMgr.saveObject(wbo)) {
                        result.setAttribute("status", "ok");
                    }
                } catch (SQLException ex) {
                    Logger.getLogger(FinancialManagementServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                out.write(Tools.getJSONObjectAsString(result));
                break;
            case 3:
                servedPage = "/docs/financial/list_expenses.jsp";
                request.setAttribute("data", channelsExpenseMgr.getChannelExpenses(request.getParameter("channelID")));
                this.forward(servedPage, request, response);
                break;

            case 4:
                servedPage = "/docs/Emp_Finance/emp_monthly_salary.jsp";

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 5:
                String status = "";

                try {
                    ArrayList<LiteWebBusinessObject> expItmes = ExpenseItemMgr.getInstance().getOnArbitraryKey2("Salary", "key1");

                    for (int i = 0; i < expItmes.size(); i++) {
                        wbo = new LiteWebBusinessObject();
                        LiteWebBusinessObject expneseWbo = (LiteWebBusinessObject) expItmes.get(i);
                        wbo.setAttribute("empID", request.getParameter("empID"));
                        wbo.setAttribute("expnseId", expneseWbo.getAttribute("id"));
                        wbo.setAttribute("year", request.getParameter("year"));
                        wbo.setAttribute("month", request.getParameter("month"));
                        String item = request.getParameter(expneseWbo.getAttribute("enName").toString());
                        wbo.setAttribute("salaryItem", item);

                        if (EmployeeFinanceMgr.getInstance().saveSalary(wbo, session)) {
                            status = "true";
                        } else {
                            status = "false";
                        }

                    }

                    LiteWebBusinessObject empWbo = EmployeeMgr.getInstance().getOnSingleKey("key2", request.getParameter("empNumber"));

                    request.setAttribute("salaryItems", ExpenseItemMgr.getInstance().getOnArbitraryKey2("Salary", "key1"));
                    request.setAttribute("empNumber", request.getParameter("empNumber"));
                    request.setAttribute("empWbo", empWbo);
                    request.setAttribute("status", status);

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);

                } catch (Exception ex) {
                    System.out.println("Exception in getting Expenses Items = " + ex.getMessage());
                }
                break;
            case 6:
                wbo = new LiteWebBusinessObject();
                wbo.setAttribute("status", channelsExpenseMgr.deleteOnSingleKey(request.getParameter("id")) ? "ok" : "fail");
                out = response.getWriter();
                out.write(Tools.getJSONObjectAsString(wbo));
                break;

            case 7:
                servedPage = "/docs/Emp_Finance/salary_form.jsp";

                try {
                    EmployeeSalaryConfigMgr salConfigMgr = EmployeeSalaryConfigMgr.getInstance();
                    EmployeeTransactionMgr empTransactionMgr = EmployeeTransactionMgr.getInstance();

                    ArrayList<LiteWebBusinessObject> salaryItems = salConfigMgr.getSalaryConfigByEmp(request.getParameter("empID"));

                    SalaryItem salaryItem = null;

                    Float basicSalary = salConfigMgr.getEmpBasicSalary(request.getParameter("empID"));

                    for (LiteWebBusinessObject salItemWbo : salaryItems) {
                        switch ((String) salItemWbo.getAttribute("expenseCode")) {
                            case "1":
                                salaryItem = new BasicSalary(request.getParameter("empID"), new BigDecimal(basicSalary));

                                if (salItemWbo.getAttribute("ConfigPersent").toString().equals("persentage")) {
                                    salaryItem.setIsPersent(true);
                                    salaryItem.setPersentValue(new BigDecimal(salItemWbo.getAttribute("configValue").toString()));
                                } else {
                                    salaryItem.setIsPersent(false);
                                }

                                if (salItemWbo.getAttribute("ConfigType").toString().equals("credit")) {
                                    salaryItem.setIsDebtItem(false);
                                } else {
                                    salaryItem.setIsPersent(true);
                                }
                                break;

                            case "2":
                                salaryItem = new Additions(request.getParameter("empID"), new BigDecimal(basicSalary));

                                if (salItemWbo.getAttribute("ConfigPersent").toString().equals("persentage")) {
                                    salaryItem.setIsPersent(true);
                                    salaryItem.setPersentValue(new BigDecimal(salItemWbo.getAttribute("configValue").toString()));
                                } else {
                                    salaryItem.setIsPersent(false);
                                }

                                if (salItemWbo.getAttribute("ConfigType").toString().equals("credit")) {
                                    salaryItem.setIsDebtItem(false);
                                } else {
                                    salaryItem.setIsPersent(true);
                                }

                                salaryItem.setSalaryItemValue(new BigDecimal(salItemWbo.getAttribute("configValue").toString()));
                                break;

                            case "3":
                                salaryItem = new Movments(request.getParameter("empID"), new BigDecimal(basicSalary));

                                if (salItemWbo.getAttribute("ConfigPersent").toString().equals("persentage")) {
                                    salaryItem.setIsPersent(true);
                                    salaryItem.setPersentValue(new BigDecimal(salItemWbo.getAttribute("configValue").toString()));
                                } else {
                                    salaryItem.setIsPersent(false);
                                }

                                if (salItemWbo.getAttribute("ConfigType").toString().equals("credit")) {
                                    salaryItem.setIsDebtItem(false);
                                } else {
                                    salaryItem.setIsPersent(true);
                                }

                                salaryItem.setSalaryItemValue(new BigDecimal(salItemWbo.getAttribute("configValue").toString()));
                                break;

                            case "4":
                                salaryItem = new Food(request.getParameter("empID"), new BigDecimal(basicSalary));

                                if (salItemWbo.getAttribute("ConfigPersent").toString().equals("persentage")) {
                                    salaryItem.setIsPersent(true);
                                    salaryItem.setPersentValue(new BigDecimal(salItemWbo.getAttribute("configValue").toString()));
                                } else {
                                    salaryItem.setIsPersent(false);
                                }

                                if (salItemWbo.getAttribute("ConfigType").toString().equals("credit")) {
                                    salaryItem.setIsDebtItem(false);
                                } else {
                                    salaryItem.setIsPersent(true);
                                }

                                salaryItem.setSalaryItemValue(new BigDecimal(salItemWbo.getAttribute("configValue").toString()));
                                break;

                            case "5":
                                salaryItem = new Visits(request.getParameter("empID"), new BigDecimal(basicSalary));

                                if (salItemWbo.getAttribute("ConfigPersent").toString().equals("persentage")) {
                                    salaryItem.setIsPersent(true);
                                    salaryItem.setPersentValue(new BigDecimal(salItemWbo.getAttribute("configValue").toString()));
                                } else {
                                    salaryItem.setIsPersent(false);
                                }

                                if (salItemWbo.getAttribute("ConfigType").toString().equals("credit")) {
                                    salaryItem.setIsDebtItem(false);
                                } else {
                                    salaryItem.setIsPersent(true);
                                }

                                salaryItem.setSalaryItemValue(new BigDecimal(salItemWbo.getAttribute("configValue").toString()));
                                break;

                            case "6":
                                salaryItem = new Bouns(request.getParameter("empID"), new BigDecimal(basicSalary));

                                if (salItemWbo.getAttribute("ConfigPersent").toString().equals("persentage")) {
                                    salaryItem.setIsPersent(true);
                                    salaryItem.setPersentValue(new BigDecimal(salItemWbo.getAttribute("configValue").toString()));
                                } else {
                                    salaryItem.setIsPersent(false);
                                }

                                if (salItemWbo.getAttribute("ConfigType").toString().equals("credit")) {
                                    salaryItem.setIsDebtItem(false);
                                } else {
                                    salaryItem.setIsPersent(true);
                                }

                                salaryItem.setSalaryItemValue(new BigDecimal(salItemWbo.getAttribute("configValue").toString()));
                                break;

                            case "7":
                                salaryItem = new Punch(request.getParameter("empID"), new BigDecimal(basicSalary));

                                if (salItemWbo.getAttribute("ConfigPersent").toString().equals("persentage")) {
                                    salaryItem.setIsPersent(true);
                                    salaryItem.setPersentValue(new BigDecimal(salItemWbo.getAttribute("configValue").toString()));
                                } else {
                                    salaryItem.setIsPersent(false);
                                }

                                if (salItemWbo.getAttribute("ConfigType").toString().equals("credit")) {
                                    salaryItem.setIsDebtItem(false);
                                } else {
                                    salaryItem.setIsPersent(true);
                                }

                                salaryItem.setSalaryItemValue(new BigDecimal(salItemWbo.getAttribute("configValue").toString()));
                                break;

                            case "8":
                                salaryItem = new Insurance(request.getParameter("empID"), new BigDecimal(basicSalary));

                                if (salItemWbo.getAttribute("ConfigPersent").toString().equals("persentage")) {
                                    salaryItem.setIsPersent(true);
                                    salaryItem.setPersentValue(new BigDecimal(salItemWbo.getAttribute("configValue").toString()));
                                } else {
                                    salaryItem.setIsPersent(false);
                                }

                                if (salItemWbo.getAttribute("ConfigType").toString().equals("credit")) {
                                    salaryItem.setIsDebtItem(false);
                                } else {
                                    salaryItem.setIsPersent(true);
                                }

                                salaryItem.setSalaryItemValue(new BigDecimal(salItemWbo.getAttribute("configValue").toString()));
                                break;

                            case "9":
                                salaryItem = new HealthInsurance(request.getParameter("empID"), new BigDecimal(basicSalary));

                                if (salItemWbo.getAttribute("ConfigPersent").toString().equals("persentage")) {
                                    salaryItem.setIsPersent(true);
                                    salaryItem.setPersentValue(new BigDecimal(salItemWbo.getAttribute("configValue").toString()));
                                } else {
                                    salaryItem.setIsPersent(false);
                                }

                                if (salItemWbo.getAttribute("ConfigType").toString().equals("credit")) {
                                    salaryItem.setIsDebtItem(false);
                                } else {
                                    salaryItem.setIsPersent(true);
                                }

                                salaryItem.setSalaryItemValue(new BigDecimal(salItemWbo.getAttribute("configValue").toString()));
                                break;

                            case "10":
                                salaryItem = new RetirementValue(request.getParameter("empID"), new BigDecimal(basicSalary));

                                if (salItemWbo.getAttribute("ConfigPersent").toString().equals("persentage")) {
                                    salaryItem.setIsPersent(true);
                                    salaryItem.setPersentValue(new BigDecimal(salItemWbo.getAttribute("configValue").toString()));
                                } else {
                                    salaryItem.setIsPersent(false);
                                }

                                if (salItemWbo.getAttribute("ConfigType").toString().equals("credit")) {
                                    salaryItem.setIsDebtItem(false);
                                } else {
                                    salaryItem.setIsPersent(true);
                                }

                                salaryItem.setSalaryItemValue(new BigDecimal(salItemWbo.getAttribute("configValue").toString()));
                                break;

                            case "11":
                                salaryItem = new Taxes(request.getParameter("empID"), new BigDecimal(basicSalary));

                                if (salItemWbo.getAttribute("ConfigPersent").toString().equals("persentage")) {
                                    salaryItem.setIsPersent(true);
                                    salaryItem.setPersentValue(new BigDecimal(salItemWbo.getAttribute("configValue").toString()));
                                } else {
                                    salaryItem.setIsPersent(false);
                                }

                                if (salItemWbo.getAttribute("ConfigType").toString().equals("credit")) {
                                    salaryItem.setIsDebtItem(false);
                                } else {
                                    salaryItem.setIsPersent(true);
                                }

                                salaryItem.setSalaryItemValue(new BigDecimal(salItemWbo.getAttribute("configValue").toString()));
                                break;

                        }

                        salaryItem.calculateSalary();
                        salItemWbo.setAttribute("salaryItem", salaryItem);
                        empTransactionMgr.saveEmpSalTransaction(session, salItemWbo.getAttribute("expenseID").toString(), request.getParameter("empID"), salaryItem.getTotalSlaryItem().toString(), salItemWbo.getAttribute("ConfigType").toString());
                    }

                    request.setAttribute("salaryItems", salaryItems);

                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ex.getMessage());
                }

                request.setAttribute("empID", request.getParameter("empID"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 8:

                break;
            case 9:
                servedPage = "/docs/Financials/new_campaign_expense.jsp";
                String id=request.getParameter("id");
                WebBusinessObject web1=(WebBusinessObject)campaignMgr.getOnSingleKey(request.getParameter("id"));
                request.setAttribute("channelWbo", campaignMgr.getOnSingleKey(request.getParameter("id")));
                try {
                    request.setAttribute("companiesList", new ArrayList<>(clientMgr.getOnArbitraryKeyOrdered("100", "key11", "key5")));
                } catch (Exception ex) {
                    request.setAttribute("companiesList", new ArrayList<>());
                }
                this.forward(servedPage, request, response);
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
        if (opName.indexOf("getNewExpenseForm") == 0) {
            return 1;
        }
        if (opName.indexOf("saveNewExpenseAjax") == 0) {
            return 2;
        }
        if (opName.indexOf("getChannelExpenses") == 0) {
            return 3;
        }
        if (opName.indexOf("setEmployeeSalary") == 0) {
            return 4;
        }
        if (opName.indexOf("saveEmployeeSalary") == 0) {
            return 5;
        }
        if (opName.indexOf("deleteExpenseAjax") == 0) {
            return 6;
        }

        if (opName.indexOf("getEmpMonthlySalary") == 0) {
            return 7;
        }

        if (opName.indexOf("saveEmpSalTrans") == 0) {
            return 8;
        }
         if (opName.indexOf("getNewExpenseCampaignForm") == 0) {
            return 9;
        }
        return 0;
    }

}
