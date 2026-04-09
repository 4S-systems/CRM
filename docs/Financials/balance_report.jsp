<%@page import="java.text.DecimalFormat"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    String fromDateVal = (String) request.getAttribute("fromDate");
    String toDateVal = (String) request.getAttribute("toDate");
    String accountID = request.getAttribute("accountID") != null ? (String) request.getAttribute("accountID") : "";
    String accountType = request.getAttribute("accountType") != null ? (String) request.getAttribute("accountType") : "";
    WebBusinessObject openBalanceWbo = request.getAttribute("openBalanceWbo") != null ? (WebBusinessObject) request.getAttribute("openBalanceWbo") : new WebBusinessObject();
    ArrayList<WebBusinessObject> balanceList = request.getAttribute("balanceList") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("balanceList") : new ArrayList<WebBusinessObject>();
    ArrayList<WebBusinessObject> accountTypesList = request.getAttribute("accountTypesList") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("accountTypesList") : new ArrayList<WebBusinessObject>();

    String stat = (String) request.getSession().getAttribute("currentMode");
    String dir, title,excel, fromDate, toDate, search,total, credit, debit, type, account, openingBalance, balance, note, operationType, recipient, date;
    if (stat.equals("En")) {
        dir = "ltr";
        title = "Balance Report ";
        fromDate = " From Date ";
        toDate = " To Date ";
        search = " Search ";
        credit = "Credit";
        debit = "Debit";
        excel="Excel";
        type = "Type";
        account = "Account";
        openingBalance = "Period Opening Balance";
        balance = "Transaction Balance";
        note = "Note";
        operationType = "Operation Type";
        recipient = "Transaction Operand";
        total="Total";
        date = "Date";
    } else {
        dir = "rtl";
        title = "تقرير الأرصدة";
        fromDate = " من تاريخ ";
        toDate = " إلى تاريخ ";
        search = " بحث ";
        credit = "دائن";
        debit = "مدين";
        type = "النوع";
        account = "الحساب";
        openingBalance = "رصيد أول المدة";
        balance = "رصيد الحركه";
        excel="اكسيل";
        note = "البيان";
        operationType = "نوع العملية";
        recipient = "طرف الحركه";
        date = "التاريخ";
        total="الأجمالي";
    }

    double amount = 0, netAmount = 0,totalCredit=0,totalDebit=0;
    DecimalFormat formatter = new DecimalFormat("#,###.###");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery-ui-timepicker-addon.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
               <script type="text/javascript" src="js/jquery.dataTables.js"></script>

        <script type="text/javascript" src="js/buttons.flash.min.js"></script>

        <style>
            .button2{
                font-size: 15px;
                font-style: normal;
                font-variant: normal;
                font-weight: bold;
                line-height: 20px;
                width: 150px;
                height: 30px;
                text-decoration: none;
                display: inline-block;
                margin: 4px 2px;
                -webkit-transition-duration: 0.4s;
                transition-duration: 0.8s;
                cursor: pointer;
                border-radius: 12px;
                border: 1px solid #008CBA;
                padding-left:2%;
                text-align: center;
            }

            .button2:hover {
                background-color: #afdded;
                padding-top: 0px;
            }

            *>*{
                vertical-align: middle;
            }
        </style>

        <script language="JavaScript" type="text/javascript">
            $(document).ready(function () {
                $("#fromDate, #toDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: "D",
                    dateFormat: "yy/mm/dd"
                });
                  $('#resultTable').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                    iDisplayLength: 10,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[0, "asc"]]
                    

                })
            });
            function exportToExcel() {
                var fromDate = $("#fromDate").val();
                var toDate = $("#toDate").val();
                var accountID=$("#accountID").val();
                var accountName=$("#accountID").text();
                var url = "<%=context%>/FinancialServlet?op=balanceReportToExcel&fromDate="+ fromDate + "&toDate="+ toDate+"&accountID="+accountID+"&accountName="+accountName;
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=700, height=700");
            }
            function getAccountList(obj, accountID) {
                var accountType = $(obj).val();
                $("#accountID").removeAttr("disabled");
                $("#accountID").html("");
                $.ajax({
                    type: "post",
                    url: "<%=context%>/FinancialServlet?op=getKindsList",
                    data: {
                        kindId: accountType
                    },
                    success: function (jsonString) {
                        var data = $.parseJSON(jsonString);
                        var rowData;
                        if (data !== null && data.length > 0) {
                            var len = data.length;
                            for (var i = 0; i < len; i++) {
                                rowData = data[i];
                                if (accountType !== null && (accountType === "FIN_CNTRCT" || accountType === "FIN_CLNT")) {
                                    $("#accountID").html($("#accountID").html() + "<option value='" + rowData.id + "'>" + rowData.name + "</option>");
                                } else if (accountType === "FIN_EMP") {
                                    $("#accountID").html($("#accountID").html() + "<option value='" + rowData.empId + "'>" + rowData.empName + "</option>");
                                } else {
                                    $("#accountID").html($("#accountID").html() + "<option value='" + rowData.projectID + "'>" + rowData.projectName + "</option>");
                                }
                            }
                            if (accountID !== '') {
                                $("#accountID").val(accountID);
                            }
                        } else {
                            $("#accountID").attr("disabled", "disabled");
                            $("#accountID").html("<option>لايوجد</option>");
                        }
                    }
                });
            }
        </script>
    </head>
    <body>
        <form NAME="BALANCE_REPORT_FORM" METHOD="POST" action="<%=context%>/FinancialServlet?op=balanceReport">
            <fieldset class="set" style="width: 95%; padding-bottom: 20px;">
                <legend align="center">
                    <font color="blue" size="6">
                    <%=title%>
                    </font>
                </legend>

                <table align="center" style="direction: <%=dir%>; width: 50%;">
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size: 15px; font-weight:bold; width: 33%;">
                            <font size=3 color="white">
                            <%=fromDate%>
                            </font>
                        </td>

                        <td class="blueBorder blueHeaderTD" style="font-size: 15px; font-weight:bold; width: 33%;">
                            <font size=3 color="white">
                            <%=toDate%>
                            </font>
                        </td>

                        <td bgcolor="#F7F6F6" style="width: 34%; border: none;" valign="middle" rowspan="4">
                            <button class="button" style="width: 50%; font-size: 15px; font-weight:bold;">
                                <%=search%>
                                <img height="15" src="images/search.gif" />
                            </button>
                                <br/>
                                 <br/>
                              <button class="button" type="button" style="width: 50%; font-size: 15px; font-weight:bold;"
                                onclick="exportToExcel()">
                                 <%=excel%> 
                            </button>
                        </td>
                    </tr>

                    <tr>
                        <td style="text-align: center; border: none;" bgcolor="#F7F6F6" valign="middle" >
                            <input id="fromDate" name="fromDate" type="text" value="<%=fromDateVal%>" style="width: 75%;" readonly />
                            <img src="images/showcalendar.gif" > 
                        </td>

                        <td bgcolor="#F7F6F6" style="text-align: center; border: none;" valign="middle">
                            <input id="toDate" name="toDate" type="text" value="<%=toDateVal%>" style="width: 75%;" readonly />
                            <img src="images/showcalendar.gif" >
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size: 15px; font-weight:bold; width: 33%;">
                            <font size=3 color="white"><%=type%></font>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size: 15px; font-weight:bold; width: 33%;">
                            <font size=3 color="white"><%=account%></font>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center; border: none;" bgcolor="#F7F6F6" valign="middle" >
                            <select style="width: 150px;height: 30px; font-weight: bold; font-size: 13px;" id="accountType" name="accountType" onchange="getAccountList(this, '')">
                                <option></option>
                                <sw:WBOOptionList displayAttribute="arDesc" valueAttribute="typeCode" wboList="<%=accountTypesList%>" scrollToValue="<%=accountType%>"/>
                            </select>
                        </td>
                        <td bgcolor="#F7F6F6" style="text-align: center; border: none;" valign="middle">
                            <select style="width: 322px;height: 30px; font-weight: bold; font-size: 13px;" id="accountID" name="accountID">
                                <option></option>
                            </select>
                        </td>
                    </tr>
                </table>

                <div style="width: 95%; padding-top: 2%;" class="tabsS" id="sentJO">
                    <table class="display" id="resultTable" align="center" cellpadding="0" cellspacing="0" style="direction: <%=dir%>;">
                        <thead>
                            <tr>
                                   <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; width: 7%;">
                                    <b>
                                        <%=date%>
                                    </b>
                                </th>
                                   <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; width: 7%;">
                                    <b>
                                        <%=recipient%> 
                                    </b>
                                </th>
                                    <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; width: 7%;">
                                    <b>
                                        <%=operationType%>
                                    </b>
                                </th>
                             
                                    <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; width: 16%;">
                                    <b>
                                        <%=note%> 
                                    </b>
                                </th>
                             <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; width: 7%;">
                                    <b>
                                        <%=credit%>
                                    </b>
                                </th>
                                  <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; width: 7%;">
                                    <b>
                                        <%=debit%>
                                    </b>
                                </th>
                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; width: 7%;">
                                    <b>
                                        <%=balance%> 
                                    </b>
                                </th>
                              
                               
                          
                            </tr>
                        </thead>
                        <tbody id="">
                            <%
                                if (openBalanceWbo.getAttribute("balance") != null) {
                                    netAmount += Double.valueOf((String) openBalanceWbo.getAttribute("balance"));
                            %>
                            <tr style="padding: 1px;">
                                  <td>
                                    &nbsp;
                                </td>
                                <td>
                                    &nbsp;
                                </td>
                                <td>
                               &nbsp;

                                </td>
                                <td>
                                    <%=openingBalance%>
                                </td>
                                
                                <td>
                                    &nbsp;
                                </td>
                                <td>
                                    &nbsp;
                                </td>
                                <td>
                                    <%=openBalanceWbo.getAttribute("balance")%>
                                </td>
                              
                            </tr>
                            <%
                                }
                                for (WebBusinessObject balanceWbo : balanceList) {
                                    netAmount=0;
                                    totalCredit+=Double.valueOf((String) balanceWbo.getAttribute("creditValue"));
                                    totalDebit+= Double.valueOf((String) balanceWbo.getAttribute("debitValue"));
                                     netAmount += Double.valueOf((String) balanceWbo.getAttribute("debitValue"));
                                    netAmount -= Double.valueOf((String) balanceWbo.getAttribute("creditValue"));
                            %>
                            <tr style="padding: 1px;">
                                <td>
                                    <%=balanceWbo.getAttribute("documentDate") != null ? ((String) balanceWbo.getAttribute("documentDate")).substring(0, 10) : ""%>
                                </td>
                             <td>
                                    <%="0".equals(balanceWbo.getAttribute("creditValue")) ? balanceWbo.getAttribute("creditName") : balanceWbo.getAttribute("debitName")%>
                                </td>
                                  <td>
                                    <%=balanceWbo.getAttribute("transactionType") != null ? balanceWbo.getAttribute("transactionType") : ""%>
                                </td>
                                    <td>
                                    <%=balanceWbo.getAttribute("note") != null ? balanceWbo.getAttribute("note") : ""%>
                                </td>
                               <td>
                                    <%
                                        amount = Double.parseDouble(balanceWbo.getAttribute("creditValue").toString());
                                    %>
                                    <%=balanceWbo.getAttribute("creditValue") != null ? formatter.format(amount) : ""%>
                                </td>
                                   <td>
                                    <%
                                        amount = Double.parseDouble(balanceWbo.getAttribute("debitValue").toString());
                                    %>
                                    <%=balanceWbo.getAttribute("debitValue") != null ? formatter.format(amount) : ""%>
                                </td>
                                <td>
                                    <%=formatter.format(netAmount)%>
                                </td>
                             
                               
                             
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                        <tfoot>
                            <tr>
                                <th colspan="2">
                               </th>
                               <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold;" colspan="2">
                                    <%=total%>
                                </th>
                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold;">
                                    <%=formatter.format(totalCredit)%>
                                </th>
                                 <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold;">
                                    <%=formatter.format(totalDebit)%>
                                </th>
                                 <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold;">
                                    <% double initBalance=0;
                                     try{
                                         initBalance=Double.parseDouble(openBalanceWbo.getAttribute("balance").toString());
                                     }
                                     catch(Exception e7){
                                     }
                                        %>
   
                                     <%=formatter.format(-totalCredit+totalDebit+initBalance)%>
                                </th>
                                
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </fieldset>
        </form>
        <script language="JavaScript" type="text/javascript">
            getAccountList("#accountType", '<%=accountID%>');
        </script>
    </body>
</html>
