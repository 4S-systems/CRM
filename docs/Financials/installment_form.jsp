
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    String stat = (String) request.getSession().getAttribute("currentMode");
    ArrayList<WebBusinessObject> installmentsList = (ArrayList<WebBusinessObject>) request.getAttribute("installmentsList");
    ArrayList<WebBusinessObject> paymentPlansList = (ArrayList<WebBusinessObject>) request.getAttribute("paymentPlansList");
    String paymentPlanID = request.getAttribute("paymentPlanID") != null ? (String) request.getAttribute("paymentPlanID") : "";
    String startDateVal = request.getAttribute("startDate") != null ? (String) request.getAttribute("startDate") : "";
    WebBusinessObject activeClientWbo = (WebBusinessObject) request.getAttribute("activeClientWbo");
    String projectID = request.getAttribute("projectID") != null ? (String) request.getAttribute("projectID") : "";
    String projectName = request.getAttribute("projectName") != null ? (String) request.getAttribute("projectName") : "";
    String price = request.getAttribute("price") != null ? (String) request.getAttribute("price") : "";
    String addonPrice = request.getAttribute("addonPrice") != null ? (String) request.getAttribute("addonPrice") : "";
    DecimalFormat df = new DecimalFormat("#,###.00");
    String align = null, alignX;
    String dir = null;
    String style = null;
    String installment, percent, totalAmount, maintenance, month, date, total, noPaymentPlanMsg, paymentPlan, clientName, none, startDate,
            amount, addon, search;
    if (stat.equals("En")) {
        align = "center";
        alignX = "right";
        dir = "LTR";
        style = "text-align:left";
        installment = "Installment";
        percent = "Percent";
        totalAmount = "Total Amount";
        maintenance = "Maintenance";
        month = "Month";
        date = "Date";
        total = "Total";
        noPaymentPlanMsg = "There is no Payment Plan Available for This Project";
        paymentPlan = "Payment Plan";
        clientName = "Client Name";
        none = "None";
        startDate = "Start Date";
        amount = "Amount";
        addon = "Add Ons";
        search = "Search";
    } else {
        align = "center";
        alignX = "left";
        dir = "RTL";
        style = "text-align:Right";
        installment = "القسط";
        percent = "النسبة";
        totalAmount = "المبلغ الكلي";
        maintenance = "الصيانة";
        month = "الشهر";
        date = "التاريخ";
        total = "أجمالي";
        noPaymentPlanMsg = "لا يوجد خطط دفع لهذا المشروع";
        paymentPlan = "خطة الدفع";
        clientName = "اسم العميل";
        none = "لا يوجد";
        startDate = "تاريخ البداية";
        amount = "المبلغ";
        addon = "الأضافات";
        search = "بحث";
    }
%>
<html>
    <head>
        <style>
        </style>
        <script src="js/Tafqeet.js"></script>
        <script language="JavaScript" type="text/javascript">
            var table;
            $(function () {
                table = $("#installments").DataTable({
                    "language": {
                        "url": "js/jquery/datatable/Arabic.json"
                    },
                    "destroy": true,
                    "stateSave": true,
                    "aLengthMenu": [[-1], ["All"]],
                    "ordering": false,
                    searching: false,
                    paging: false,
                    info: false
                });
                $("#startDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    minDate: new Date(),
                    dateFormat: "yy/mm/dd"
                });
            });
            function openSearchPayment() {
                $('#treatType').val("5");
                getDataInPopup('ClientServlet?op=getClientsPopup&value=');
            }
        </script>
    </head>
    <body>
        <form name="INSTALLMENT_FORM" id="INSTALLMENT_FORM" method="post">
            <div style="width: 90%; margin-left: auto; margin-right: auto;">
                <%
                    if (paymentPlansList != null) {
                %>
                <div style="margin-left: auto; margin-right: auto; width: 570px;">
                    <table algin="center" dir="rtl" width="570" cellpadding="2" cellspacing="1">
                        <tr>
                            <td class="blueBorder blueHeaderTD" style="font-size: 18px;" colspan="2">
                                <b>
                                    <font size=3 color="white">
                                    <%=paymentPlan%> 
                                    </font>
                                </b>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align:center" bgcolor="#dedede" valign="middle" colspan="2">
                                <select name="paymentPlanID" id="paymentPlanID"
                                        onchange="JavaScript: viewPaymentPlan('<%=projectID%>', '<%=projectName%>', <%=price%>, <%=addonPrice%>, $(this).val(), $('#startDate').val());">
                                    <sw:WBOOptionList wboList='<%=paymentPlansList%>' displayAttribute="planTitle" valueAttribute="id" scrollToValue="<%=paymentPlanID%>"/>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="blueBorder blueHeaderTD" style="font-size: 18px; width: 50%;">
                                <b>
                                    <font size=3 color="white">
                                    <%=clientName%> 
                                    </font>
                                </b>
                            </td>
                            <td class="blueBorder blueHeaderTD" style="font-size: 18px; width: 50%;">
                                <b>
                                    <font size=3 color="white">
                                    <%=startDate%> 
                                    </font>
                                </b>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align:center" bgcolor="#dedede" valign="middle">
                                <b id="clientNamePayment"><%=activeClientWbo != null ? activeClientWbo.getAttribute("name") : none%></b>
                                <input type="hidden" name="clientID" id="clientIDPayment"
                                       value="<%=activeClientWbo != null ? activeClientWbo.getAttribute("id") : ""%>"/>
                                <input type="hidden" name="unitID" id="unitID" value="<%=projectID%>" />
                                <input type="button" onclick="JavaScript: openSearchPayment(this);" value="<%=search%>" id="search" name="search"
                                       style="float: <%=alignX%>; margin-<%=alignX%>: 10px;"/>
                            </td>
                            <td style="text-align:center" bgcolor="#dedede" valign="middle">
                                <input type="text" name="startDate" id="startDate" value="<%=startDateVal%>" readonly
                                       onchange="JavaScript: viewPaymentPlan('<%=projectID%>', '<%=projectName%>', <%=price%>, <%=addonPrice%>, $('#paymentPlanID').val(), $(this).val());"/>
                            </td>
                        </tr>
                    </table>
                    <br/>
                </div>
                <br />
                <table id="installments" class="display" id="pathPrice" align="center" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0">
                    <thead>
                        <tr>
                            <th style="font-weight: bolder;"><%=installment%></th>
                            <th style="font-weight: bolder;"><%=percent%></th>
                            <th style="font-weight: bolder;"><%=amount%></th>
                            <th style="font-weight: bolder;"><%=addon%></th>
                            <th style="font-weight: bolder;"><%=totalAmount%></th>
                            <th style="font-weight: bolder;"><%=maintenance%></th>
                            <th style="font-weight: bolder;"><%=month%></th>
                            <th style="font-weight: bolder;"><%=date%></th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int index = 1;
                            double totalPrice = 0, maintenanceVal = 0, percentVal = 0, totalAddonPrice = 0;
                            for (WebBusinessObject installmentWbo : installmentsList) {
                                totalPrice += Double.parseDouble((String) installmentWbo.getAttribute("amount"));
                                if (installmentWbo.getAttribute("maintenance") != null) {
                                    maintenanceVal += Double.parseDouble((String) installmentWbo.getAttribute("maintenance"));
                                }
                                if (installmentWbo.getAttribute("addon") != null) {
                                    totalAddonPrice += Double.parseDouble((String) installmentWbo.getAttribute("addon"));
                                }
                                percentVal += Double.parseDouble((String) installmentWbo.getAttribute("percent"));
                        %>
                        <tr>
                            <th style="font-weight: bolder;"><%=index%></th>
                            <th style="font-weight: bolder;"><%=installmentWbo.getAttribute("percent")%> %</th>
                            <th style="font-weight: bolder;">
                                <%=df.format(Double.parseDouble((String) installmentWbo.getAttribute("amount")))%>
                            </th>
                            <th style="font-weight: bolder;">
                                <%=installmentWbo.getAttribute("addon") != null ? df.format(Double.parseDouble((String) installmentWbo.getAttribute("addon"))) : ""%>
                            </th>
                            <th style="font-weight: bolder;">
                                <%=df.format(Double.parseDouble((String) installmentWbo.getAttribute("totalAmount")))%>
                                <input type="hidden" name="paymentAmount" value="<%=installmentWbo.getAttribute("totalAmount")%>" />
                                <input type="hidden" name="paymentType" value="<%=index == 1 ? "reservarion" : index == 2 ? "downPayment" : "installment"%>" />
                            </th>
                            <th style="font-weight: bolder;"><%=installmentWbo.getAttribute("maintenance") != null ? df.format(Double.parseDouble((String) installmentWbo.getAttribute("maintenance"))) : ""%></th>
                            <th style="font-weight: bolder;"><%=installmentWbo.getAttribute("month")%></th>
                            <th style="font-weight: bolder;">
                                <%=installmentWbo.getAttribute("date")%>
                                <input type="hidden" name="paymentDate" id="paymentDate" value="<%=installmentWbo.getAttribute("date")%>" />
                            </th>
                        </tr>
                        <%
                                index++;
                            }
                        %>
                    </tbody>
                    <tfoot>
                        <tr>
                            <th style="font-weight: bolder;">&nbsp;
                                <input type="hidden" name="totalPrice" id="totalPrice" value="<%=totalPrice%>" />
                            </th>
                            <th style="font-weight: bolder;"><%=df.format(Math.round(percentVal))%> %</th>
                            <th style="font-weight: bolder;"><%=df.format(totalPrice)%></th>
                            <th style="font-weight: bolder;"><%=df.format(totalAddonPrice)%></th>
                            <th style="font-weight: bolder;"><%=df.format(totalPrice + totalAddonPrice)%></th>
                            <th style="font-weight: bolder;"><%=df.format(maintenanceVal)%></th>
                            <th style="font-weight: bolder;">&nbsp;</th>
                            <th style="font-weight: bolder;">&nbsp;</th>
                        </tr>
                    </tfoot>
                </table>
                <%
                } else {
                %>
                <%=noPaymentPlanMsg%>
                <%
                    }
                %>
            </div>
        </form>
    </body>
</html>