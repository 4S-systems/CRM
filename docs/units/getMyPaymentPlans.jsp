<%-- 
    Document   : approvePaymentPlans
    Created on : Jul 25, 2018, 12:59:04 PM
    Author     : walid
--%>

<%@page import="com.silkworm.common.SecurityUser"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>

    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Units.Units"  />
    <head>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
        <link rel="stylesheet" href="css/CSS.css"/>
        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/loading/loading.js"></script>
        <script type="text/javascript" src="js/loading/spin.js"></script>
        <script type="text/javascript" src="js/loading/spin.min.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        <script type="text/javascript" src="js/Tafqeet.js"></script>
	<script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>

        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            ArrayList<WebBusinessObject> planLst = (ArrayList<WebBusinessObject>) request.getAttribute("planLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("planLst") : null;
            ArrayList<WebBusinessObject> unitLst = (ArrayList<WebBusinessObject>) request.getAttribute("unitLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("unitLst") : null;
            Calendar cal = Calendar.getInstance();
            WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");
            String timeFormat = "yyyy/MM/dd HH:mm";
            SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
            String nowTime = sdf.format(cal.getTime());
            String reservationDateStr = nowTime.substring(0, nowTime.indexOf(" ")).replaceAll("/", "-");
            String jDateFormat = user.getAttribute("javaDateFormat").toString();
            sdf.applyPattern(jDateFormat);

            SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
            ArrayList<WebBusinessObject> prvType = new ArrayList();
            prvType = securityUser.getComplaintMenuBtn();
            ArrayList<String> privilegesList = new ArrayList<>();
            for (WebBusinessObject wboTemp : prvType) {
                if (wboTemp != null && wboTemp.getAttribute("prevCode") != null) {
                    privilegesList.add((String) wboTemp.getAttribute("prevCode"));
                }
            }

            String fromDate = (String) request.getAttribute("fromDate");
            String toDate = (String) request.getAttribute("toDate");

            String startDate = null;
            String toDateValue = null;
            if (fromDate != null && !fromDate.equals("")) {
                toDateValue = fromDate;
            } else {
                toDateValue = sdf.format(cal.getTime());
            }
            if (toDate != null && !toDate.equals("")) {
                startDate = toDate;
            } else {
                cal.add(Calendar.MONTH, -1);
                startDate = sdf.format(cal.getTime());
            }
            String requestTyp = (String) request.getAttribute("reqTyp");
            String clientID = (String) request.getAttribute("clientID") != null ? (String) request.getAttribute("clientID") : null;

            String stat = (String) request.getSession().getAttribute("currentMode");
            String dir, align, search, fromDatetit, toDatetit, ReqTyp, paymentP;

            if (stat.equals("En")) {
                dir = "LTR";
                align = "center";
                search = "Search";
                fromDatetit = "From Date";
                toDatetit = "To Date";
                ReqTyp = "Request Status";
                paymentP = "My Payment Plans";
            } else {
                dir = "RTL";
                align = "center";
                search = "بحث";
                fromDatetit = "من تاريخ";
                toDatetit = "إلى تاريخ";
                ReqTyp = "حالة الطلب";
                paymentP = "خطط الدفع";
            }
        %>

        <script  type="text/javascript">
            jQuery.browser = {};
            (function () {
                jQuery.browser.msie = false;
                jQuery.browser.version = 0;
                if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
                    jQuery.browser.msie = true;
                    jQuery.browser.version = RegExp.$1;
                }
            })();
            $(document).ready(function () {
                $('#payPlans').dataTable({
                    "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    "order": [[4, "asc"]],
                    "columnDefs": [
                        {
                            "targets": 4,
                            "visible": false
                        }], "drawCallback": function (settings) {
                        var api = this.api();
                        var rows = api.rows({page: 'current'}).nodes();
                        var last = null;
                        api.column(4, {page: 'current'}).data().each(function (group, i) {
                            if (last !== group) {
                                $(rows).eq(i).before(
                                        '<tr class="group"><td class="blueBorder blueBodyTD" style="font-size: 16px; background-color: lightgray; color: #a41111; text-align: <%=dir%>;" colspan="3"><fmt:message key="client" /></td> <td class="" style="font-size: 16px; color: #a41111; text-align: <%=dir%>;" colspan="3"> <b style="color: black;">' + group + ' </b> </td> <td class="" style="font-size: 16px; color: #a41111; text-align: <%=dir%>;" colspan="5" >&nbsp;</td></tr>'
                                        );
                                last = group;
                            }
                        });
                    }
                }).fadeIn(2000);

                $("#fromDate, #toDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });

            function deletePlan(planID, clientID){
                var url = "<%=context%>/UnitServlet?op=cancelPlan&planID=" + planID + "&clientID=" + clientID;
                window.location.href = url;
            }

            function requestApproval(planID, clientID){
                var url = "<%=context%>/UnitServlet?op=requestApproval&planID=" + planID + "&clientID=" + clientID;
                window.location.href = url;
            }

            function submitForm() {
                var fromD = $("#fromDate").val();
                var toD = $("#toDate").val();
                var reqTyp = $("#reqTyp option:selected").val();
                document.EmployeesLoads.action = "<%=context%>/UnitServlet?op=getMyPaymentPlans&fromD="+fromD + "&toD=" + toD + "&reqTyp=" + reqTyp;
                document.EmployeesLoads.submit();
            }
            function popupClientReservation(issueId, clientComplaintId, clientId, unitId, unitName, beforeDiscount, reservationValue,
                    contractValue, parentId, paymentSystem) {
                $("#issueId").val(issueId);
                $("#clientComplaintId").val(clientComplaintId);
                $("#clientId").val(clientId);
                $("#unitId").val(unitId);
                $("#unitCode").val(unitName);
                $("#parentId").val(parentId);
                $("#period").val("<%=metaMgr.getReservationDefaultPeriod() != null && !"".equals(metaMgr.getReservationDefaultPeriod()) && !"0".equals(metaMgr.getReservationDefaultPeriod()) ? metaMgr.getReservationDefaultPeriod() : ""%>");
                $("#unitValue").val(beforeDiscount);
                $("#reservationValue").val(reservationValue);
                $("#contractValue").val(contractValue);
                tafqeetVal("unitValue");
                tafqeetVal("beforeDiscount");
                tafqeetVal("reservationValue");
                tafqeetVal("contractValue");
                $("#plotArea").val("");
                $("#paymentSystem").val(paymentSystem);
                getUnitPrice(unitId);
                $("#reservationDate").val("<%=reservationDateStr%>");
                $("#floorNumber").val("");
                $("#modelNo").val("");
                $("#receiptNo").val("");
                $("#addtions").val("");
                $("#reservationBtn").show();
                $("#changeStatus").val('true');
                $('#reserveDialog').find("#clientStatusNotes").val("");
                $('#reserveDialog').css("display", "block");
                $('#reserveDialog').css("opacity", "100");
                $('#reserveDialog').bPopup({easing: 'easeInOutSine',
                    speed: 400,
                    transition: 'slideDown'});
            }
            async function reservedUnit() {
                var issueId = $("#issueId").val();
                var clientComplaintId = $("#clientComplaintId").val();
                var clientId = $("#clientId").val();
                var unitId = $("#unitId").val();
                var parentId = $("#parentId").val();
                var period = $("#period").val();
                var changeStatus = $("#changeStatus").val();
                var unitValue = $("#unitValue").val();
                var unitValueText = $("#unitValueText").val();
                var beforeDiscount = $("#beforeDiscount").val();
                var beforeDiscountText = $("#beforeDiscountText").val();
                var reservationValue = $("#reservationValue").val();
                var reservationValueText = $("#reservationValueText").val();
                var contractValue = $("#contractValue").val();
                var contractValueText = $("#contractValueText").val();
                var plotArea = $("#plotArea").val();
                var buildingArea = $("#buildingArea").val();
                var reservationDate = $("#reservationDate").val();
                var paymentSystem = $("#paymentSystem").val();
                var floorNumber = $("#floorNumber").val();
                var modelNo = $("#modelNo").val();
                var receiptNo = $("#receiptNo").val();
                var comments = $("#addtions").val();
                if (unitId === "") {
                    alert("من فضلك ادخل الوحدة");
                    return false;
                } else if (unitValue === "") {
                    alert("من فضلك ادخل قيمة الوحده بعد الخصم");
                    return false;
                } else if (beforeDiscount === "") {
                    alert("من فضلك ادخل قيمة الوحدة فبل الخصم");
                    return false;
                } else if (reservationValue === "") {
                    alert("من فضلك ادخل دفعة الحجز");
                    return false;
                } else if (contractValue === "") {
                    alert("من فضلك ادخل دفعة التعاقد");
                    return false;
                } else if (buildingArea === "") {
                    alert("من فضلك ادخل مساحة الوحدة");
                    return false;
//                } else if (receiptNo === "") {
//                    alert("من فضلك ادخل رقم الايصال");
//                    return false;
                }
                if (period === "") {
                    period = '7';
                }
                $('input[name="reserveUnit"]').attr('disabled', true);
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ProjectServlet?op=saveAvailableUnits&changeStatus=" + changeStatus,
                    data: {
                        issueId: issueId,
                        clientComplaintId: clientComplaintId,
                        clientId: clientId,
                        unitId: unitId,
                        unitCategoryId: parentId,
                        period: period,
                        unitValue: unitValue,
                        unitValueText: unitValueText,
                        beforeDiscount: beforeDiscount,
                        beforeDiscountText: beforeDiscountText,
                        reservationValue: reservationValue,
                        reservationValueText: reservationValueText,
                        contractValue: contractValue,
                        contractValueText: contractValueText,
                        plotArea: plotArea,
                        buildingArea: buildingArea,
                        reservationDate: reservationDate,
                        paymentSystem: paymentSystem,
                        floorNumber: floorNumber,
                        modelNo: modelNo,
                        receiptNo: receiptNo,
                        comments: comments
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'ok') {
                            location.reload();
                        } else if (info.status === 'no') {
                            alert("لم يتم الحجز");
                            $('input[name="reserveUnit"]').attr('disabled', false);
                        }
                    }
                });
            }
            
            function getUnitPrice(unitId) {
                $.ajax({
                    type: "post",
                        url: "<%=context%>/ProjectServlet?op=getUnitPrice",
                        data: {
                        unitId: unitId
                        },
                        success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (jsonString !== ''){
                            $("#beforeDiscount").val(info.option1);
                            tafqeetVal("beforeDiscount");
                            $("#unitValue").val(info.option1);
                            tafqeetVal("unitValue");
                            $("#buildingArea").val(info.maxPrice);
                            $("#modelNo").val(info.modelName);
                            $("#floorNumber").val(info.floorName);
                        } else {
                            $("#beforeDiscount").val("");
                            $("#buildingArea").val("");
                        }
                    }
                });
            }
            function tafqeetVal (obj) {
                var text = " جنيها مصريا";
                if($("#" + obj).val() !== '') {
                    $("#" + obj + "Text").val(tafqeet($("#" + obj).val()) + text);
                }
            }
            function calculatePayments () {
                if ($("#unitValue").val() !== '') {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/UnitServlet?op=getPaymentPercentsAjax",
                        data: {
                            paymentPlanID: $("#paymentSystem").val()
                        },
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            try {
                                var totalPrice = parseInt($("#unitValue").val());
                                if (info.id !== ''){
                                    $("#contractValue").val((info.downAMT * totalPrice / (100 * 100)).toFixed(0) * 100);
                                    tafqeetVal("contractValue");
                                    $("#reservationValue").val((info.reservation * totalPrice / (100 * 100)).toFixed(0) * 100);
                                    tafqeetVal("reservationValue");
                                } else {
                                    $("#contractValue").val("");
                                    $("#contractValueText").val("");
                                    $("#reservationValue").val("");
                                    $("#reservationValueText").val("");
                                }
                            } catch (err) {
                                $("#contractValue").val("");
                                $("#contractValueText").val("");
                                $("#reservationValue").val("");
                                $("#reservationValueText").val("");
                            }
                        }
                    });
                }
            }
        </script>
    </head>
    <body>
        <fieldset>
            <legend>
                <font style="color: blue;font-size: 17px; font-weight: bold"/> <fmt:message key="paymentP" />
            </legend>
            <form name="EmployeesLoads" method="post"> 
                <table ALIGN="center" DIR="RTL" WIDTH="60%" CELLSPACING=2 CELLPADDING=1 style="margin-bottom: 20px;">
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="40%">
                            <b><font size=3 color="white"><%=fromDatetit%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="40%">
                            <b> <font size=3 color="white"><%=toDatetit%></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" valign="middle">
                            <input id="fromDate" name="fromDate" type="text" readonly value="<%=startDate%>"/><img src="images/showcalendar.gif"/> 
                            <br/><br/>
                        </td>
                        <td bgcolor="#dedede" style="text-align:center" valign="middle">
                            <input id="toDate" name="toDate" type="text" readonly value="<%=toDateValue%>"/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                    </tr>

                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="40%" colspan="2">
                            <b><font size=3 color="white"><%=ReqTyp%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" style="text-align:center" valign="middle" colspan="2">
                            <SELECT id="reqTyp" name="reqTyp" style="width: 50%">
                                <option value="">All</option>
                                <option value="Approval Requested" <%=requestTyp != null && requestTyp.equals("Approval Requested") ? "selected" : ""%>>Approval Requested</option>
                                <option value="Approved" <%=requestTyp != null && requestTyp.equals("Approved") ? "selected" : ""%>>Approved</option>
                                <option value="Rejected" <%=requestTyp != null && requestTyp.equals("Rejected") ? "selected" : ""%>>Rejected</option>
                                <option value="Proposed" <%=requestTyp != null && requestTyp.equals("Proposed") ? "selected" : ""%>>Proposed</option>
                            </SELECT>
                        </td>
                    </tr>

                    <tr>
                        <td STYLE="text-align:center" bgcolor="#dedede" rowspan="2" WIDTH="20%" colspan="2">
                            <button onclick="JavaScript: submitForm();" STYLE="color: #27272A;font-size:15px;font-weight:bold;height: 35px"><%=search%> <IMG HEIGHT="15" SRC="images/search.gif"/> </button>
                        </td>
                    </tr>
                </table>

                <div style="width: 90%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                    <TABLE ALIGN="center" dir='<fmt:message key="direction" />' id="payPlans" style="width:100%;">
                        <thead>
                            <tr>
                                <th style="width: 2%;"><B></B></th>

                                <th style="width: 24%;">
                                    <B>
                                        <fmt:message key="unit" />
                                    </B>
                                </th>

                                <th style="width: 24%;">
                                    <B>
                                        <fmt:message key="payPlan" />
                                    </B>
                                </th>

                                <th style="width: 24%;">
                                    <B>
                                        <fmt:message key="statusTit" />
                                    </B>
                                </th>

                                <th style="width: 24%;">
                                    <B>
                                        <fmt:message key="client" />
                                    </B>
                                </th>
                                <th style="width: 24%;">
                                    <b>
                                        <fmt:message key="clientMob" />
                                    </b>
                                </th>
                                <th style="width: 24%;">
                                    <b>
                                        <fmt:message key="clientIntNo" />
                                    </b>
                                </th>

                                <th style="width: 24%;">
                                    <B>
                                        <fmt:message key="employee" />
                                    </B>
                                </th>

                                <th style="width: 24%;">
                                    <B>
                                        <fmt:message key="creationTime" />
                                    </B>
                                </th>

                                <th style="width: 5%;"><B></B></th>

                                <th style="width: 5%;"><B></B></th>

                                <th style="width: 5%;"><B></B></th>

                                <th style="width: 5%;"><B></B></th>

                                <th style="width: 5%;"><B></B></th>
                            </tr>
                        </thead>
                        <%
                            if(planLst !=null && planLst.size() != 0){
                        %>
                        <tbody>
                            <% int counter = 1;
                                for (WebBusinessObject planWbo : planLst) {
                                    String color = null;
                                if(planWbo.getAttribute("statusTit") != null && planWbo.getAttribute("statusTit").equals("Approved")){
                                   color = "#b9dfc7"; 
                                } else if(planWbo.getAttribute("statusTit") != null && planWbo.getAttribute("statusTit").equals("Approval Requested")){
                                   color = "#d6e2fd "; 
                                } else if(planWbo.getAttribute("statusTit") != null && planWbo.getAttribute("statusTit").equals("Rejected")){
                                   color = "#f2d1bf"; 
                                } else if(planWbo.getAttribute("statusTit") != null && planWbo.getAttribute("statusTit").equals("Proposed")){
                                   color = "#fdf5b6"; 
                                } else if(planWbo.getAttribute("statusTit") != null && planWbo.getAttribute("statusTit").equals("Canceled")){
                                   color = "#c0c0c0"; 
                                    }
                            %>
                                <tr style="background-color: <%=color%>">
                                <td style="width: 2%;">
                                    <%=counter%>
                                </td>

                                <% for (WebBusinessObject unitWbo : unitLst) {
                                        if(unitWbo.getAttribute("projectID").equals(planWbo.getAttribute("unitID"))) { %>
                                <td style="width: 24%;">
                                    <%=unitWbo.getAttribute("projectName")%>
                                </td>
                                    <% break; } } %>

                                <td style="width: 24%;">
                                    <%=planWbo.getAttribute("planTitle")%>
                                </td>

                                <td style="width: 24%;">
                                    <font style=""/> <%=planWbo.getAttribute("statusTit")%>
                                </td>

                                <td style="width: 24%;">
                                    <%=planWbo.getAttribute("clientName")%>
                                </td>
                                <td style="width: 24%;">
                                    <%=planWbo.getAttribute("mobile") != null ? planWbo.getAttribute("mobile") : ""%>
                                </td>
                                <td style="width: 24%;">
                                    <%=planWbo.getAttribute("interPhone") != null ? planWbo.getAttribute("interPhone") : ""%>
                                </td>

                                <td style="width: 24%;">
                                    <%=planWbo.getAttribute("employeeName")%>
                                </td>

                                <td style="width: 24%;">
                                        <%=planWbo.getAttribute("CreationTime").toString().substring(0,10)%>
                                </td>

                                <td style="width: 5%;">
                                    <a title=" View Plan " style="color:black;" href="<%=context%>/UnitServlet?op=showPaymentPlan&planID=<%=planWbo.getAttribute("ID")%>&clientID=<%=planWbo.getAttribute("clientID")%>"> View </a>
                                </td>

                                <td style="width: 5%;">
                                    <%
                                        if ("Approved".equals(planWbo.getAttribute("statusTit"))) {
                                            if (planWbo.getAttribute("reservationID") == null) {
                                    %>
                                    <a title="Reserve Unit" style="color:black;" href="JavaScript: popupClientReservation('<%=planWbo.getAttribute("issueID")%>', '<%=planWbo.getAttribute("complaintID")%>', '<%=planWbo.getAttribute("clientID")%>', '<%=planWbo.getAttribute("unitID")%>', '<%=planWbo.getAttribute("unitName")%>', '<%=planWbo.getAttribute("paymentAmount")%>', '<%=planWbo.getAttribute("reservationAmount")%>', '<%=planWbo.getAttribute("downPaymentAmount")%>', '<%=planWbo.getAttribute("parentID")%>', '<%=planWbo.getAttribute("planTitle")%>');"> Reserve </a>
                                    <%
                                    } else {
                                    %>
                                    <a title="Reserve Unit" style="color:black;" href="JavaScript: alert('تم الحجز مسبقا');"> Reserve </a>
                                    <%
                                            }
                                        }
                                    %>
                                </td>

                                <td style="width: 5%;">
                                    <a title=" View Plan PDF " target="blank" href="<%=context%>/UnitServlet?op=showPaymentPlanPDF&planID=<%=planWbo.getAttribute("ID")%>"><img style="margin: 3px" src="images/icons/pdf.png" width="24" height="24"/></a>
                                </td>
                                
                                <td style="width: 5%;">
                                    <!--<a onclick="deletePlan('<%=planWbo.getAttribute("ID")%>', '<%=clientID%>');" title=" Cancel Plan "> <img src="images/icons/clear.png" width="20" height="20"/></a>-->
                                        <input type="button" value="Cancel" onclick="deletePlan('<%=planWbo.getAttribute("ID")%>', '<%=clientID%>');" <%=planWbo.getAttribute("statusTit") != null && (planWbo.getAttribute("statusTit").equals("Canceled") || planWbo.getAttribute("statusTit").equals("Approved") || planWbo.getAttribute("statusTit").equals("Rejected")) ? "disabled" : "" %>/>
                                </td>

                                <td style="width: 5%;">
                                        <input type="button" value="Request Approval" onclick="requestApproval('<%=planWbo.getAttribute("ID")%>', '<%=clientID%>');" <%=planWbo.getAttribute("statusTit") != null && (planWbo.getAttribute("statusTit").equals("Canceled") || planWbo.getAttribute("statusTit").equals("Approval Requested") || planWbo.getAttribute("statusTit").equals("Approved") || planWbo.getAttribute("statusTit").equals("Rejected")) ? "disabled" : "" %>/>
                                </td>
                            </tr>
                            <%counter++;}}%>
                        </tbody>
                    </table>
                </div>
            </form>
        </fieldset>
        <div id="reserveDialog" style="display: none;width: 70%;position: fixed; z-index: 1000;" >
            <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 20px;
                     -moz-border-radius: 20px;
                     border-radius: 20px;" onclick="closePopupDialog('reserveDialog')"/>
            </div>
            <div class="backgroundTable" style="text-align: center; width: 100%">
                <table  width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td>
                            <input type="hidden" id="clientId" name="clientId"/>
                            <input type="hidden" id="issueID" name="issueID"/>
                            <input type="hidden" id="clientComplaintId" name="clientComplaintId"/>
                            <input name="reserveUnit" type="submit" value="<fmt:message key="followw5" />" onclick="javascript: reservedUnit(this)"/>
                        </td>
                        <th class="titlebar">
                            <font color="#005599" size="4"><b><fmt:message key="followa5" /></font>
                        </th>
                    </tr>
                </table>
                <table class="backgroundTable" width="100%" cellpadding="0" cellspacing="8" align="center" dir="<%=dir%>">
                    <tr>
                        <td width="2%" class="backgroundHeader" nowrap><b><fmt:message key="followx5" /></td>
                        <td width="5%" style="color:blue; font-size: 16px;font-weight: bold; text-align: right;" class="backgroundHeader">
                            <%=user.getAttribute("userName")%>
                        </td>
                    </tr>
                    <tr>
                        <td class="titlebar" colspan="4">
                            <font color="red" size="3"><b><fmt:message key="followb5" /></font>
                        </td>
                    </tr>
                    <tr>
                        <td width="20%"  style="text-align: right;" class="backgroundHeader" nowrap><b><fmt:message key="followk5" /></td>
                        <td width="30%" style="text-align: right;"class="backgroundHeader">
                            <table class="hidex" style="display: block;" ALIGN="Right"  dir="RTL" border="0" id="regionTable">
                                <tr>
                                    <td class="td2">
                                        <input class="hidex" type="text" readonly id="unitCode" name="unitCode" value="" style='width:170px;' />
                                        <input type="hidden" id="unitId" name="unitId"/>
                                        <input type="hidden" id="parentId" name="parentId"/>
                                        <input type="hidden" id="changeStatus" name="changeStatus"/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>   
                        <td width="20%" style="text-align: right;" class="backgroundHeader" nowrap><b><fmt:message key="followj5" /></td>
                        <td width="30%"style="text-align:right;" class="backgroundHeader">
                            <input type="number" size="7" maxlength="7" id="buildingArea" name="buildingArea" style='width:170px;'/>
                        </td>
                        <td width="20%" style="text-align: right;" class="backgroundHeader" nowrap><b><fmt:message key="followc5" /></td>
                        <td width="30%"style="text-align:right;" class="backgroundHeader">
                            <input type="number" size="7" maxlength="7" id="plotArea" name="plotArea" style='width:170px;'/>
                        </td>
                    </tr>
                    <tr>
                        <td width="20%"  style="text-align: right;" class="backgroundHeader" nowrap><b><fmt:message key="followi5" /></td>
                        <td width="30%"style="text-align:right;" class="backgroundHeader">
                            <input type="text" size="7" maxlength="40" name="floorNumber" id="floorNumber" style='width:170px;'/>
                        </td>
                        <td width="20%"  style="text-align: right;" class="backgroundHeader" nowrap><b><fmt:message key="followd5" /></td>
                        <td width="30%"style="text-align:right;" class="backgroundHeader">
                            <input type="text" size="7" maxlength="7" name="modelNo" id="modelNo" style='width:170px;'/>
                        </td>
                    </tr>
                    <tr>
                        <td width="20%" style="text-align: right;" class="backgroundHeader" nowrap><b><fmt:message key="followh5" /></td>
                        <td width="30%"style="text-align:right;" class="backgroundHeader">
                            <input type="number" size="7" maxlength="7" id="beforeDiscount" name="beforeDiscount" style='width:170px;'
                                   onchange="JavaScript: tafqeetVal('beforeDiscount');"/>
                        </td>

                        <td width="2%" style="text-align: right;" class="backgroundHeader" nowrap><b><fmt:message key="followe5" /></td>
                        <td width="48%"style="text-align:right;" class="backgroundHeader">
                            <textarea name="beforeDiscountText" id="beforeDiscountText" style='width:250px; height: 50px; background: #FFFF99'></textarea>
                        </td> 
                    </tr>
                    <tr align="left">
                        <td width="20%" style="text-align: right;" class="backgroundHeader" nowrap><b><fmt:message key="followg5" /></td>
                        <td width="30%"style="text-align:right;" class="backgroundHeader">
                            <input type="number" size="7" maxlength="7" id="unitValue" name="unitValue" style='width:170px;'
                                   onchange="JavaScript: tafqeetVal('unitValue');"/>
                        </td>
                        <td width="20%" style="text-align: right;" class="backgroundHeader" nowrap><b><fmt:message key="followe5" /></td>
                        <td width="40%"style="text-align:right;" class="backgroundHeader">
                            <textarea name="unitValueText" id="unitValueText" style='width:250px; height: 50px; background: #FFFF99'></textarea>
                        </td> 
                    </tr>
                    <tr>
                        <td class="titlebar" colspan="4">
                            <font color="red" size="3"><b><fmt:message key="followv5" /></font>
                        </td>
                    </tr>
                    <tr>
                        <td width="25%" style="text-align: right;" class="backgroundHeader" nowrap><b><fmt:message key="followu5" /></td>
                        <td width="25%"style="text-align:right;" class="backgroundHeader">
                            <input type="text" size="7" maxlength="7" readonly id="reservationDate" name="reservationDate"
                                   style='width:170px;' value="<%=reservationDateStr%>"/>
                        </td>
                        <td width="25%" style="text-align: right;" class="backgroundHeader" nowrap><b><fmt:message key="followm5" /></td>
                        <td width="25%"style="text-align:right;" class="backgroundHeader">
                            <input type="number" size="7" maxlength="7" id="period" name="period" style='width:170px;'
                                   <%=metaMgr.getReservationDefaultPeriod() != null && !"".equals(metaMgr.getReservationDefaultPeriod()) && !"0".equals(metaMgr.getReservationDefaultPeriod()) && !privilegesList.contains("EDIT_RESERVE_PERIOD") ? "readonly" : ""%>
                                   value="<%=metaMgr.getReservationDefaultPeriod() != null && !"".equals(metaMgr.getReservationDefaultPeriod()) && !"0".equals(metaMgr.getReservationDefaultPeriod()) ? metaMgr.getReservationDefaultPeriod() : ""%>"/>
                        </td>
                    </tr>
                    <tr>
                        <td width="25%" style="text-align: right;" class="backgroundHeader" nowrap><b><fmt:message key="followt5" /></td>
                        <td width="25%"style="text-align:right;" class="backgroundHeader">
                            <input type="number" size="7" maxlength="7" id="contractValue" name="contractValue" style='width:170px;'
                                   onchange="JavaScript: tafqeetVal('contractValue');"/>
                        </td>
                        <td width="20px" style="text-align: right;" class="backgroundHeader" nowrap><b><fmt:message key="followe5" /></td>
                        <td width="40%"style="text-align:right;" class="backgroundHeader">
                            <textarea id="contractValueText" name="contractValueText" style='width:250px; height: 50px; background: #FFFF99'></textarea>
                        </td> 
                    </tr>
                    <tr> 
                        <td width="25%" style="text-align: right;" class="backgroundHeader" nowrap><b><fmt:message key="follows5" /></td>
                        <td width="25%"style="text-align:right;" class="backgroundHeader">
                            <input type="number" size="7" maxlength="7" id="reservationValue" name="reservationValue" style='width:170px;'
                                   onchange="JavaScript: tafqeetVal('reservationValue');"/>
                        </td>

                        <td width="20%" style="text-align: right;" class="backgroundHeader" nowrap><b><fmt:message key="followe5" /></td>
                        <td width="40%"style="text-align:right;" class="backgroundHeader">
                            <textarea name="reservationValueText" id="reservationValueText" style='width:250px; height: 50px; background: #FFFF99'></textarea>
                        </td> 
                    </tr>
                    <tr>
                        <td width="25%" style="text-align: right;" class="backgroundHeader" nowrap><b><fmt:message key="followr5" /></td>
                        <td width="25%"style="text-align:right;" class="backgroundHeader">
                            <input type="text" name="paymentSystem" id="paymentSystem" style='width:170px;font-size:16px;' readonly/>
                        </td>
                        <td width="20%" style="text-align: right;" class="backgroundHeader" nowrap><b><fmt:message key="followp5" /></td>
                        <td width="30%"style="text-align:right;" class="backgroundHeader">
                            <input type="text" size="7" maxlength="7" name="receiptNo" id="receiptNo" style='width:170px;'/>
                        </td>
                    </tr>
                    <tr>
                        <td width="25%" style="text-align: right;" class="backgroundHeader" nowrap><b><fmt:message key="followq5" /></td>
                        <td style="text-align:right;" class="backgroundHeader" colspan="3"><TEXTAREA cols="75" rows="2" name="addtions" id="addtions"></TEXTAREA></td>
                    </tr>
                    <tr>
                        <td colspan="4" class="backgroundHeader" nowrap> 
                            <input type="hidden" id="clientId" name="clientId"/>
                            <input name="reserveUnit" type="submit" value="<fmt:message key="followw5" />" onclick="javascript: reservedUnit(this)"/>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </body>
</html>
