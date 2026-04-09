<%@page import="com.maintenance.common.AutomationConfigurationMgr"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="com.silkworm.business_objects.WebBusinessObject,java.util.Vector,com.tracker.db_access.ProjectMgr"%>
<%@ page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/tr/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html>

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        AutomationConfigurationMgr automation = AutomationConfigurationMgr.getCurrentInstance();
        long interval = automation.getDefaultRefreshPageInterval();
        ArrayList<WebBusinessObject> unitsList = (ArrayList<WebBusinessObject>) request.getAttribute("unitsList");
        String fromDateVal = (String) request.getAttribute("fromDate");
        String toDateVal = (String) request.getAttribute("toDate");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String dir, style,title, fromDate,ReservationForm,TheRemainingTime,TypeOfReservation,DateReservation,DurationOfReservation,Client,Mobile,PhoneRoaming,unitcode,SalesMang, toDate, search, paymentPlans, successMsg, failMsg, clientRequiredMsg;
        String cancelButtonLabel;
        if (stat.equals("En")) {
            dir = "LTR";
            style = "text-align:left";
            title = "My Reserved Units";
            cancelButtonLabel = "Cancel ";
            fromDate = "From Date";
            toDate = "To Date";
            search = "Search";
            paymentPlans = "Unit's Payment Plans";
            successMsg = "Save Successfully";
            failMsg = "Fail to Save";
            clientRequiredMsg = "You must select client to save";
            unitcode = "unit code";
            SalesMang = "Sales Mang.";
            ReservationForm = "Reservation Form";
            TheRemainingTime = "The Remaining Time";
            TypeOfReservation = "Type Of Reservation";
            DateReservation = "Date Reservation";
            DurationOfReservation = "Duration Of Reservation";
            Client = "Client";
            Mobile = "Mobile";
            PhoneRoaming = "Phone Roaming";
            
            
            
        } else {
            dir = "RTL";
            style = "text-align:Right";
            title = "عرض حجوزاتي";
            cancelButtonLabel = "إنهاء ";
            fromDate = "من تاريخ";
            toDate = "إلي تاريخ";
            search = "بحث";
            paymentPlans = "خطط الدفع للوحدة";
            successMsg = "تم الحفظ بنجاح";
            failMsg = "لم يتم الحفظ";
            clientRequiredMsg = "يجب أختيار عميل للحفظ";
            unitcode = "كود الوحده";
            SalesMang = "م.المبيعات";
            ReservationForm = "استماره الحجز";
            TheRemainingTime = "الوقت المتبقى";
            TypeOfReservation = "نوع الحجز";
            DateReservation = "تاريخ الحجز";
            DurationOfReservation = "مده الحجز";
            Client = "العميل";
            Mobile = "المحمول";
            PhoneRoaming = "الدولى";
        }
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    %>
    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
	
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            var oTable;
            var users = new Array();
            $(document).ready(function() {
                oTable = $('#unitsList').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).fadeIn(2000);
		
		$("#fromDate, #toDate").datepicker({
		    changeMonth: true,
		    changeYear: true,
		    maxDate: 0,
		    dateFormat: "yy/mm/dd"
		});
	    });
	
            function cancelForm()
            {
                document.url = "<%=context%>/main.jsp";
            }
            function navigateToClient(clientId) {
                location.href = "<%=context%>/ClientServlet?op=clientDetails&clientId=" + clientId;
            }
            function openWindow(url) {
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=750, height=500");
            }
            function changeStatus(id, newStatus, type, unitCurrentStatus) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/UnitServlet?op=changeReservationStatusByAjax",
                    data: {
                        id: id,
                        newStatus: newStatus,
                        unitCurrentStatus: unitCurrentStatus
                    }
                    ,
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'Ok') {
                            if (type === 'cancel') {
                                $("#action" + id).html("تم ألغاء الحجز");
                                alert("تم ألغاء الحجز");
                            }
                        } else {
                            alert("لم يتم تغيير الحالة");
                        }
                    }
                });
            }
        function viewPaymentPlan(projectID, projectName, price, addonPrice, paymentPlanID, startDate, clientID) {
            var divTag = $("#installmentDiv");
            $.ajax({
                    type: "post",
                    url: '<%=context%>/FinancialServlet?op=getInstallmentsForm',
                    data: {
                        projectID: projectID,
                        price: price,
                        addonPrice: addonPrice,
                        paymentPlanID: paymentPlanID,
                        startDate: startDate,
                        clientID: clientID
                    }, success: function (data) {
                        divTag.html(data).dialog({
                            modal: true,
                            title: "<%=paymentPlans%> " + projectName,
                            show: "fade",
                            hide: "explode",
                            width: 950,
                            closeOnEscape: false,
                            position: {
                                my: 'center',
                                at: 'center'
                            }, buttons: {
                                'Close': function () {
                                    $(this).dialog('close').dialog('destroy');
                                    divTag.html("");
                                },
                                'Save': function () {
                                    saveInstallments();
                                }
                            }
                        }).dialog('open');
                    }, error: function (data) {
                        alert(data);
                    }
            });
            function saveInstallments() {
                if($("#clientID").val() === '') {
                    alert("<%=clientRequiredMsg%>");
                } else {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/FinancialServlet?op=saveInstallmentsAjax",
                        data: $("#INSTALLMENT_FORM").serialize(),
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'ok') {
                                alert("<%=successMsg%>");
                                var divTag = $("#installmentDiv");
                                divTag.dialog('close').dialog('destroy');
                                divTag.html("");
                            } else {
                                alert("<%=failMsg%>");
                            }
                        }
                    });
                }
            }
        }
        </SCRIPT>
        <style>  
            .canceled {
                background-color: #ffa722;
                color: black;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .confirmed {
                background-color: #e1efbb;
                color: black;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .onhold {
                background-color: #369bd7;
                color: black;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }

            .titlebar {
                height: 30px;
                background-image: url(images/title_bar.png);
                background-position-x: 50%;
                background-position-y: 50%;
                background-size: initial;
                background-repeat-x: repeat;
                background-repeat-y: no-repeat;
                background-attachment: initial;
                background-origin: initial;
                background-clip: initial;
                background-color: rgb(204, 204, 204);
            }
            #products
            {
                direction: rtl;
                margin-left: auto;
                margin-right: auto;
            }
            #products tr
            {
                padding: 5px;
            }
            #products td
            {  
                font-size: 12px;
                font-weight: bold;
            }
            #products select
            {                
                font-size: 12px;
                font-weight: bold;
            }

        </style>
    </head>
                    
                    
    <BODY>
        <div id="installmentDiv"></div>
        <FORM NAME="UNIT_LIST_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue; margin-left: 1%">
                <button onclick="JavaScript: cancelForm();" class="button"><%=cancelButtonLabel%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
            </DIV>
            <br />
            <FIELDSET class="set" style="width:98%;border-color: #006699">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td class="titlebar" style="text-align: center">
                            <font color="#005599" size="4"><%=title%></font>
                        </td>
                    </tr>
                </table>
                <br/>
                <form name="UNIT_LIST_FORM" method="post">
                    <table class="blueBorder" id="code2" align="center" dir="<%=dir%>" width="650" cellspacing="2" cellpadding="1"
                           style="border-width:1px;border-color:white;display: block; margin-left: auto; margin-right: auto;">
                        <tr class="head">
                            <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                                <b><font size=3 color="white"><%=fromDate%></font></b>
                            </td>
                            <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                                <b><font size=3 color="white"><%=toDate%></font></b>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" valign="middle">
                                <input id="fromDate" name="fromDate" type="text" value="<%=fromDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                                <br/><br/>
                            </td>
                            <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" style="text-align:right" valign="middle">
                                <input id="toDate" name="toDate" type="text" value="<%=toDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                                <br/><br/>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" valign="middle" colspan="2">
                                <button type="submit" class="button"><%=search%><img height="15" src="images/search.gif"/></button>
                                <br/>
                                <br/>
                            </td>
                        </tr>
                    </table>
                </form>
                <br/>
                <div style="width:99%;margin-right: auto;margin-left: auto;">
                    <TABLE ALIGN="center" dir="<%=dir%>" id="unitsList" style="width:100%;">
                        <thead>
                            <TR>
                                <Th>
                                    <%=unitcode%>
                                </Th>
                                <Th>
                                    <%=SalesMang%>
                                </Th>
                                <Th>
                                    <%=Client%>
                                </Th>
                                <th>
                                    <%=Mobile%>
                                </th>
                                <th>
                                    <%=PhoneRoaming%>
                                </th>
                                <Th>
                                    <%=DurationOfReservation%>
                                </Th>
                                <th>
                                    <B>
                                        <%=DateReservation%>
                                    </B>
                                </th>
                                <th>
                                    <B>
                                        <%=TypeOfReservation%>
                                    </B>
                                </th>
                                <th>
                                    <B>
                                        <%=TheRemainingTime%>
                                    </B>
                                </th>
                                <th style="width: 80px">
                                    <B>
                                        <%=ReservationForm%>
                                    </B>
                                </th>
                                <th style="" id="loader">
                                </th>
                            </TR>
                        </thead>
                        <tbody>
                            <%
                                Date date;
                                String className;
                                float total = 0;
                                for (WebBusinessObject wbo : unitsList) {
                                    try {
                                        if (wbo.getAttribute("budget") != null) {
                                            total += Float.parseFloat((String) wbo.getAttribute("budget"));
                                        }
                                    } catch (NumberFormatException ne) {
                                    }
                                    date = sdf.parse((String) wbo.getAttribute("reservationDate"));

                                    className = "";
                                    if (wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_CANCEL)
                                            || wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_UNDER_RETRIEVE)
                                            || wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_RETRIEVED)) {
                                        className = "canceled";
                                    } else if (wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_CONFIRM)) {
                                        className = "confirmed";
                                    } else if (wbo.getAttribute("unitCurrentStatus") != null && wbo.getAttribute("unitCurrentStatus").equals(CRMConstants.UNIT_STATUS_ONHOLD)) {
                                        className = "onhold";
                                    }
                            %>
                            <TR>
                                <TD id="1<%=wbo.getAttribute("id")%>" class="<%=className%>">
                                    <B><%=wbo.getAttribute("projectName")%></B>
                                </TD>
                                <TD id="2<%=wbo.getAttribute("id")%>" class="<%=className%>" nowrap>
                                    <B><%=wbo.getAttribute("createdByName")%></B>
                                </TD>
                                <td id="3<%=wbo.getAttribute("id")%>" class="<%=className%>" style="cursor: pointer" onclick="JavaScript : navigateToClient('<%=wbo.getAttribute("clientId")%>')" nowrap>
                                    <table width="100%" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class="td" nowrap>
                                                <B><%=wbo.getAttribute("clientName")%></B>
                                            </td>
                                            <td class="td">
                                                <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                    <b><%=wbo.getAttribute("mobile") != null ? wbo.getAttribute("mobile") : ""%></b>
                                </td>
                                <td>
                                    <b><%=wbo.getAttribute("interPhone") != null ? wbo.getAttribute("interPhone") : ""%></b>
                                </td>
                                <TD id="5<%=wbo.getAttribute("id")%>" class="<%=className%>">
                                    <B><%=wbo.getAttribute("period") != null ? wbo.getAttribute("period") : ""%></B>
                                </TD>
                                <td id="7<%=wbo.getAttribute("id")%>" class="<%=className%>" nowrap>
                                    <B>
                                        <%=sdf.format(date)%>
                                    </B>
                                </td>
                                <td class="<%=className%>" nowrap>
                                    <B>
                                        <%if(stat.equals("En")){%>
                                        <%=wbo.getAttribute("unitCurrentStatus") != null && wbo.getAttribute("unitCurrentStatus").equals("33") ? "Normal Reservation" : ""%>
                                        <%=wbo.getAttribute("unitCurrentStatus") != null && wbo.getAttribute("unitCurrentStatus").equals("9") ? "Normal Reservation" : ""%>
                                        <%}else{%>
                                        <%=wbo.getAttribute("unitCurrentStatus") != null && wbo.getAttribute("unitCurrentStatus").equals("33") ? "حجز مرتجع" : ""%>
                                        <%=wbo.getAttribute("unitCurrentStatus") != null && wbo.getAttribute("unitCurrentStatus").equals("9") ? "حجز عادي" : ""%>
                                        <%}%>
                                    </B>
                                </td>
                                <td id="timeRemaining<%=wbo.getAttribute("id")%>" class="<%=className%>" nowrap>
                                    <B>
                                        <%=wbo.getAttribute("currentStatus").equals("30") ? wbo.getAttribute("remainingHours") : "---"%>
                                    </B>
                                </td>
                                <td id="8<%=wbo.getAttribute("id")%>" class="<%=className%>">
                                    <%
                                        if (wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_CANCEL)
                                                || wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_UNDER_RETRIEVE)
                                                || wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_RETRIEVED)) {
                                    %>
                                        ---
                                    <%
                                    } else {
                                    %>
                                    <B>
                                        <a href="<%=context%>/UnitServlet?op=getUnitReservationPrint&clientCode=<%=wbo.getAttribute("clientId")%>&unitCode=<%=wbo.getAttribute("projectId")%>&id=<%=wbo.getAttribute("id")%>  ">
                                            <img src="images/icons/pdf.png" height="20" title="PDF"/>
                                        </a>
                                        <!--a href="#" onclick="JavaScript: openWindow('<!%=context%>/UnitDocReaderServlet?op=getUnitReservationPopup&clientCode=<!%=wbo.getAttribute("clientId")%>&projectId=<!%=wbo.getAttribute("projectId")%>');">
                                            <img src="images/htmlicon.gif" title="HTML"/>
                                        </a-->
                                    </B>
                                    <%
                                        }
                                    %>
                                </td>
                                <td id="action<%=wbo.getAttribute("id")%>" class="<%=className%>" nowrap>
                                    <input type="hidden" id="currentStatus<%=wbo.getAttribute("id")%>" value="<%=wbo.getAttribute("currentStatus")%>" />
                                    <% if (wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_CONFIRM)) { %>
                                    تم البيع 
                                    <% } else if (wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_CANCEL)) {%>
                                    <%if(stat.equals("En")){%>
                                    Cancel Reservation <%="Auto".equalsIgnoreCase((String) wbo.getAttribute("actionTaken")) ? "(Auto)" : wbo.getAttribute("actionByName") != null ? "(" + wbo.getAttribute("actionByName") + ")" : ""%>
                                    <%}else{%>
                                    تم ألغاء الحجز <%="Auto".equalsIgnoreCase((String) wbo.getAttribute("actionTaken")) ? "(Auto)" : wbo.getAttribute("actionByName") != null ? "(" + wbo.getAttribute("actionByName") + ")" : ""%>
                                    <%}%>
                                    <% } else if (wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_UNDER_RETRIEVE)) {%>
                                    تحت اﻷسترداد
                                    <% } else if (wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_RETRIEVED)) {%>
                                    تم اﻷسترداد
                                    <% } else {%>
                                    <input type="button" value="Edit" onclick="JavaScript: openWindow('<%=context%>/UnitServlet?op=getEditReservationForm&reservationID=<%=wbo.getAttribute("id")%>');"/>
                                    <input type="button" value="Cancel" onclick="JavaScript: changeStatus('<%=wbo.getAttribute("id")%>', '<%=CRMConstants.RESERVATION_STATUS_CANCEL%>', 'cancel', '<%=wbo.getAttribute("unitCurrentStatus")%>')"/>
                                    <a href="JavaScript: viewPaymentPlan('<%=wbo.getAttribute("projectId")%>', '<%=wbo.getAttribute("projectName")%>', '<%=wbo.getAttribute("price")%>', '<%=wbo.getAttribute("addonPrice")%>', '', '', '<%=wbo.getAttribute("clientId")%>');">
                                        <img src="images/finical-rebort.png" style="height: 25px" title="<%=paymentPlans%>"/>
                                    </a>
                                    <% } %>
                                </td>
                            </TR>
                            <% }%>
                            <tfoot>
                                <TR class="titlebar"style="font-size: 16px; font-weight: bold">
                                    <TD colspan="9">
                                        &nbsp;
                                    </TD>
                                </TR>
                            </tfoot>
                        </tbody>
                    </TABLE>
                </div>
                <br/>
            </fieldset>
        </FORM>
    </BODY>
    <script type="text/javascript">
        setInterval(checkReservation, <%=interval%>);
        function checkReservation() {
            showLoading('loader');
            $.ajax({
                type: "POST",
                url: "<%=context%>/UnitServlet?op=checkReservationByAjax",
                success: function(data) {
                    doCheckReservation(data);
                    stopLoading();
                },
                error: function(data) {
                    alert(data.toString());
                    stopLoading();
                }
            });
        }

        function doCheckReservation(data) {
            var reservations = $.parseJSON(data);
            var reservation, id, currentStatus, timeRemainingSeconds;
            var timeRemainingTD, actionTD;
            if (reservations !== null) {

                for (var i = 0; i < reservations.length; i++) {
                    reservation = reservations[i];
                    id = reservation.id;
                    currentStatus = reservation.currentStatus;
                    timeRemainingSeconds = reservation.timeRemainingSeconds;
                    actionTD = $("#action" + id);
                    timeRemainingTD = $("#timeRemaining" + id);
                    if ($("#currentStatus" + id).val() !== currentStatus) {
                        if (actionTD !== null && timeRemainingTD !== null) {
                            if (currentStatus === '<%=CRMConstants.RESERVATION_STATUS_CANCEL%>') {
                                actionTD.html("تم ألغاء الحجز");
                                changeRowStyle(id, "canceled", true);
                                timeRemainingTD.html("---");
                            } else if (currentStatus === '<%=CRMConstants.RESERVATION_STATUS_CONFIRM%>') {
                                actionTD.html("تم البيع");
                                changeRowStyle(id, "confirmed", false);
                                timeRemainingTD.html("---");
                            } else {
                                actionTD.html("<input type=\"button\" value=\"Confirm\" onclick=\"JavaScript: changeStatus('" + id + "', '<%=CRMConstants.RESERVATION_STATUS_CONFIRM%>', 'confirm')\"/><input type=\"button\" value=\"Cancel\" onclick=\"JavaScript: changeStatus('" + id + "', '<%=CRMConstants.RESERVATION_STATUS_CANCEL%>', 'cancel')\"/>");
                            }
                            if (currentStatus === '<%=CRMConstants.RESERVATION_STATUS_PENDING%>') {
                                timeRemainingTD.html(Math.round(timeRemainingSeconds / 3600));
                            }
                        } else {
                            alert("Missing: " + id + ", " + currentStatus + ", " + timeRemainingSeconds);
                        }
                        $("#currentStatus" + id).val(currentStatus);
                    }
                }
            }
        }

        function changeRowStyle(id, className, effect) {
            for (var i = 1; i <= 8; i++) {
                $(i + "" + id).addClass(className);
            }
            $("#timeRemaining" + id).addClass(className);
            if (effect) {
                $("#action" + id).addClass(className).fadeOut("fast");
                $("#action" + id).addClass(className).fadeIn(2000);
            } else {
                $("#action" + id).addClass(className);
            }
        }
    </script>
</html>