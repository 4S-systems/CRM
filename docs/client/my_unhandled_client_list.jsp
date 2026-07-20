<%-- Document: Unhandled_Client_List --%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    List<WebBusinessObject> clients = (List<WebBusinessObject>) request.getAttribute("clients");
  if (clients == null) {
        clients = new ArrayList<WebBusinessObject>();
    }
    List<WebBusinessObject> distributionsList = (List<WebBusinessObject>) request.getAttribute("distributionsList");
    if (distributionsList == null) {
        distributionsList = new ArrayList<WebBusinessObject>();
    }
    List<WebBusinessObject> salesEmployees = (List<WebBusinessObject>) request.getAttribute("salesEmployees");
    if (salesEmployees == null) {
        salesEmployees = new ArrayList<WebBusinessObject>();
    }
    ArrayList<WebBusinessObject> requestTypes = (ArrayList<WebBusinessObject>) request.getAttribute("requestTypes");
    if (requestTypes == null) {
        requestTypes = new ArrayList<WebBusinessObject>();
    }
    List<String> usersIDsList = (List<String>) request.getAttribute("usersIDsList");
    if (usersIDsList == null) {
        usersIDsList = new ArrayList<String>();
    }

    String beginDate = request.getAttribute("beginDate") != null ? (String) request.getAttribute("beginDate") : "";
    String endDate = request.getAttribute("endDate") != null ? (String) request.getAttribute("endDate") : "";
    String description = request.getAttribute("description") != null ? (String) request.getAttribute("description") : "";
    String clientTyp = request.getAttribute("clientTyp") != null ? (String) request.getAttribute("clientTyp") : "";
    String phoneNo = request.getAttribute("phoneNo") != null ? (String) request.getAttribute("phoneNo") : "";
    String status = (String) request.getAttribute("status");

    String stat = (String) request.getSession().getAttribute("currentMode");
    if (stat == null) {
        stat = "Ar";
    }

    String style, dir, client_ssn, fStatus, sStatus, msgErrorExtConn;
    String search, fromDate, toDate, clientNo, clientName, clientStatus, total;
    String hashTag, clientsType, dateCol, selectLabel, salesLabel, noClients;

    if ("En".equalsIgnoreCase(stat)) {
        style = "left";
        dir = "LTR";
        client_ssn = "UnDistributed Clients";
        fromDate = "From Date";
        toDate = "To Date";
        hashTag = "Hash Tag";
        clientsType = "Clients Type";
        dateCol = "Date";
        sStatus = "Client Saved Successfully";
        fStatus = "Please, Select Type Request";
        msgErrorExtConn = "Phone Number";
        search = "Search";
        clientNo = "Client Number";
        clientName = "Client Name";
        clientStatus = "Client Status";
        total = "Total";
        selectLabel = "Select";
        salesLabel = "Sales";
        noClients = "No clients found";
    } else {
        style = "right";
        dir = "RTL";
        client_ssn = "عملاء غير موزعين";
        fromDate = "من تاريخ";
        toDate = "إلى تاريخ";
        hashTag = "الوسم";
        clientsType = "نوع العميل";
        dateCol = "التاريخ";
        sStatus = "تم تسجيل العميل بنجاح";
        fStatus = "من فضلك اختار نوع الطلب";
        msgErrorExtConn = "رقم الهاتف";
        search = "بحث";
        clientNo = "رقم العميل";
        clientName = "اسم العميل";
        clientStatus = "حالة العميل";
        total = "العدد الكلي";
        selectLabel = "اختر";
        salesLabel = "المبيعات";
        noClients = "لا يوجد عملاء";
    }
%>
<link rel="stylesheet" href="css/chosen.css"/>
<style type="text/css">
    .bb-page {
        width: 95%;
        max-width: 100%;
        box-sizing: border-box;
        margin: 0 auto;
    }
    .bb-page fieldset.set {
        width: 100% !important;
        max-width: 100%;
        box-sizing: border-box;
        border-color: #006699;
        margin-top: 10px;
        border-radius: 5px;
    }
    .bb-page .titlebar {
        background: #ccc url(images/title_bar.png) repeat-x center;
    }
    .bb-page .bb-table {
        width: 100%;
        border-collapse: collapse;
        table-layout: fixed;
    }
    .bb-page .bb-table th,
    .bb-page .bb-table td {
        border: 1px solid #333;
        padding: 6px 4px;
        font-size: 13px;
        vertical-align: middle;
        word-wrap: break-word;
    }
    .bb-page .bb-table thead th {
        background-color: #bababa;
        color: #fff;
        text-align: center;
        font-weight: bold;
    }
    .bb-page .bb-search-table td {
        border: 1px solid #99c1d6;
    }
    .bb-page .bb-actions-table td {
        border: 1px solid #d3d5d4;
    }
    .bb-page .silver_footer {
        background-color: #808080;
        color: #fff;
        font-weight: bold;
    }
    .bb-page .bb-empty {
        text-align: center;
        padding: 16px;
        color: #666;
        font-size: 14px;
    }
    .bb-page .bb-search-btn {
        color: #27272A;
        font-size: 15px;
        font-weight: bold;
        width: 70%;
        margin-top: 20px;
    }
</style>

<div class="bb-page" dir="<%=dir%>">
    <fieldset class="set">
        <form name="SEARCH_CLIENT_FORM" action="<%=context%>/ClientServlet?op=myUnhandledClients" method="POST">
            <table class="bb-table" align="center" cellpadding="0" cellspacing="0">
                <tr>
                    <td colspan="6" class="titlebar">
                        <font color="#005599" size="4"><%=client_ssn%></font>
                    </td>
                </tr>
            </table>
            <br/>
            <% if ("saved".equalsIgnoreCase(status)) { %>
            <p style="color: green; font-size: 16px; font-weight: bold;"><%=sStatus%></p>
            <br/>
            <% } %>
            <table class="bb-table bb-search-table" align="center" dir="<%=dir%>" cellspacing="2" cellpadding="4">
                <tr>
                    <th style="width:15%;"><%=fromDate%></th>
                    <th style="width:15%;"><%=toDate%></th>
                    <th style="width:15%;"><%=hashTag%></th>
                    <th style="width:22%;"><%=msgErrorExtConn%></th>
                    <th style="width:15%;"><%=clientsType%></th>
                    <th style="width:18%;" rowspan="2" bgcolor="#dedede">
                        <button type="submit" class="bb-search-btn"><%=search%> <img height="15" src="images/search.gif" alt=""/></button>
                    </th>
                </tr>
                <tr bgcolor="#dedede">
                    <td style="text-align:center;">
                        <input id="beginDate" name="beginDate" type="text" value="<%=beginDate%>" style="width:95%;"/>
                    </td>
                    <td style="text-align:center;">
                        <input id="endDate" name="endDate" type="text" value="<%=endDate%>" style="width:95%;"/>
                    </td>
                    <td style="text-align:center;">
                        <input id="description" name="description" type="text" value="<%=description%>" style="width:95%;"/>
                    </td>
                    <td style="text-align:center;">
                        <input id="phoneNo" name="phoneNo" type="text" value="<%=phoneNo%>" style="width:95%;"/>
                    </td>
                    <td style="text-align:center;">
                        <select name="clientTyp" id="clientTyp" style="font-size:14px;font-weight:bold;width:95%;height:28px;">
                            <option value="cust" <%= "cust".equals(clientTyp) ? "selected" : "" %>>Customer</option>
                            <option value="lead" <%= clientTyp.isEmpty() || "lead".equals(clientTyp) ? "selected" : "" %>>Lead</option>
                        </select>
                    </td>
                </tr>
            </table>
        </form>
        <br/>

        <form name="UNHANDLED_CLIENT_FORM" method="POST">
            <% if (!clients.isEmpty()) { %>
            <table class="bb-table bb-actions-table" align="center" dir="<%=dir%>" bgcolor="#dedede" cellspacing="2" cellpadding="4">
                <tr>
                    <td style="width:30%; text-align:<%=style%>;">
                        <button id="autoBtn" type="button" onclick="bbDistribution('auto');" style="width:150px;font-size:16px;color:blue;font-weight:bold;display:none;">
                            Auto-Pilot
                            <img src="images/icons/plane_icon.png" height="24" width="24" alt="" style="vertical-align:middle"/>
                        </button>
                        <input type="checkbox" id="loggedOnly" value="1" style="display:none;"/>
                    </td>
                    <td style="width:20%; text-align:<%=style%>;">
                        <select name="requestType" id="requestType" style="width:100%;max-width:220px;font-size:16px;">
                            <option value=""><%=selectLabel%></option>
                            <sw:WBOOptionList wboList="<%=requestTypes%>" displayAttribute="projectName" valueAttribute="projectName"/>
                        </select>
                    </td>
                    <td style="width:20%; text-align:<%=style%>;">
                        <button id="manualBtn" type="button" onclick="bbDistribution('manual');" style="width:150px;font-size:16px;color:blue;font-weight:bold;">
                            Manual
                            <img src="images/icons/manual_pilot.png" height="24" width="24" alt="" style="vertical-align:middle"/>
                        </button>
                    </td>
                    <td style="width:20%; text-align:<%=style%>;">
                        <select name="employeeId" id="employeeId" class="chosen-select-employee" multiple style="width:100%;max-width:220px;font-size:14px;font-weight:bold;">
                            <% for (WebBusinessObject userWboo : distributionsList) {
                                String uid = String.valueOf(userWboo.getAttribute("userId"));
                            %>
                            <option value="<%=uid%>" <%= usersIDsList.contains(uid) ? "style=\"color:red;font-weight:bold;\"" : "" %>><%=userWboo.getAttribute("fullName")%></option>
                            <% } %>
                        </select>
                        <select name="salesEmployeeId" id="salesEmployeeId" style="width:100%;font-size:14px;font-weight:bold;display:none;">
                            <sw:WBOOptionList wboList="<%=salesEmployees%>" displayAttribute="fullName" valueAttribute="userId"/>
                        </select>
                    </td>
                    <td style="width:10%; text-align:<%=style%>;">
                        <label>
                            <input type="checkbox" id="salesEmployee" name="salesEmployee" value="1" onchange="bbSalesEmployeeBox();"/>
                            <%=salesLabel%>
                        </label>
                    </td>
                </tr>
            </table>
            <br/>
            <% } %>

            <table class="bb-table" align="center" dir="<%=dir%>" cellpadding="0" cellspacing="0">
                <thead>
                    <tr>
                        <th style="width:5%;"><input type="checkbox" name="checkAll" onchange="bbSelectAll(this);"/></th>
                        <th style="width:5%;">#</th>
                        <th style="width:12%;"><%=clientNo%></th>
                        <th style="width:22%;"><%=clientName%></th>
                        <th style="width:14%;"><%=clientStatus%></th>
                        <th style="width:18%;"><%=msgErrorExtConn%></th>
                        <th style="width:14%;"><%=dateCol%></th>
                    </tr>
                </thead>
                <tbody>
                    <% if (clients.isEmpty()) { %>
                    <tr>
                        <td colspan="7" class="bb-empty"><%=noClients%></td>
                    </tr>
                    <% } else {
                        int counter = 0;
                        for (WebBusinessObject wbo : clients) {
                            counter++;
                            boolean isMobileValid = false;
                            String mobile = (String) wbo.getAttribute("mobile");
                            if (mobile != null && mobile.length() == 11) {
                                try {
                                    if (Long.parseLong(mobile) > 0) {
                                        isMobileValid = true;
                                    }
                                } catch (NumberFormatException nfe) { }
                            }
                    %>
                    <tr style="cursor:pointer; background-color:<%= isMobileValid ? "#fff" : "#fed8d6" %>;">
                        <td style="text-align:center;">
                            <input type="checkbox" name="customerId" value="<%= wbo.getAttribute("id") %>"/>
                        </td>
                        <td style="text-align:center;"><b><%=counter%></b></td>
                        <td style="text-align:center;"><b><%=wbo.getAttribute("clientNO")%></b></td>
                        <td style="text-align:center;">
                            <b><%=wbo.getAttribute("name")%></b>
                            <% if (!isMobileValid) { %>
                            <img src="images/user_male_edit.png" style="width:20px;vertical-align:middle;cursor:pointer;"
                                 title="تعديل بيانات العميل"
                                 onclick="bbUpdateClient('<%= wbo.getAttribute("id") %>');"/>
                            <% } %>
                        </td>
                        <td style="text-align:center;">
                            <b style="color:<%= "lead".equals(wbo.getAttribute("statusNameEn")) ? "red" : "black" %>;">
                                <%=wbo.getAttribute("statusNameEn")%>
                            </b>
                        </td>
                        <td style="text-align:center;">
                            <b><%= mobile != null ? mobile : "" %></b>
                        </td>
                        <td style="text-align:center;">
                            <b><%=wbo.getAttribute("creationTime")%></b>
                        </td>
                    </tr>
                    <%   }
                    } %>
                    <tr>
                        <td class="silver_footer" colspan="6" style="text-align:center;"><%=total%> :</td>
                        <td class="silver_footer" style="text-align:center;"><b><%=clients.size()%></b></td>
                    </tr>
                </tbody>
            </table>
            <br/>
        </form>
    </fieldset>
</motion>

<script src="js/chosen.jquery.js" type="text/javascript"></script>
<script type="text/javascript">
(function ($) {
    if (!$) return;

    function bbSelectAll(obj) {
        $("input[name='customerId']").prop("checked", $(obj).is(":checked"));
    }
    window.bbSelectAll = bbSelectAll;

    function bbSalesEmployeeBox() {
        var sales = document.getElementById("salesEmployee").checked;
        document.getElementById("salesEmployeeId").style.display = sales ? "block" : "none";
        document.getElementById("employeeId").style.display = sales ? "none" : "block";
    }
    window.bbSalesEmployeeBox = bbSalesEmployeeBox;

    function bbOpenWindow(url) {
        window.open(url, "_blank", "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=no,width=700,height=600");
    }

    function bbUpdateClient(clientID) {
        bbOpenWindow("<%=context%>/ClientServlet?op=getUpdateClientForm&clientId=" + clientID);
    }
    window.bbUpdateClient = bbUpdateClient;

    function bbDistribution(mode) {
        var form = document.UNHANDLED_CLIENT_FORM;
        if (typeof validateData === "function") {
            if (!validateData("req", form.requestType, "<%=fStatus%>...")) {
                $("#requestType").focus();
                return;
            }
        } else if (!form.requestType.value) {
            alert("<%=fStatus%>");
            form.requestType.focus();
            return;
        }
        $("#manualBtn, #autoBtn").attr("disabled", "disabled");
        var loggedOnly = $("#loggedOnly").is(":checked");
        form.action = "<%=context%>/AutoPilotModeServlet?op=distributeLeadCustomers&mode=" + mode
                + "&fromURL=myUnhandledClients&loggedOnly=" + loggedOnly
                + "&requestType=" + encodeURIComponent($("#requestType").val());
        form.submit();
    }
    window.bbDistribution = bbDistribution;

    $(function () {
        if ($.fn.datepicker) {
            $("#beginDate, #endDate").datepicker({
                changeMonth: true,
                changeYear: true,
                maxDate: 0,
                dateFormat: "yy/mm/dd"
            });
        }
        if ($.fn.chosen) {
            $(".chosen-select-employee").chosen({no_results_text: "No employee found with this name!"});
        }
    });
})(window.jQuery);
</script>
