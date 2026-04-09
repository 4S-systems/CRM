<%@page import="com.tracker.db_access.CampaignMgr"%>
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

<%@ taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/tr/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html>

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String reserv = request.getAttribute("reserv") != null ? (String) request.getAttribute("reserv") : "";

        AutomationConfigurationMgr automation = AutomationConfigurationMgr.getCurrentInstance();
        long interval = automation.getDefaultRefreshPageInterval();
        ArrayList<WebBusinessObject> unitsList = (ArrayList<WebBusinessObject>) request.getAttribute("unitsList");
        String fromDateVal = (String) request.getAttribute("fromDate");
        ArrayList<WebBusinessObject> usrs = request.getAttribute("usrs") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("usrs") : new ArrayList<WebBusinessObject>();
        Vector<WebBusinessObject> campaigne = CampaignMgr.getInstance().getCashedTable();

        String toDateVal = (String) request.getAttribute("toDate");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String dir, style, title, fromDate, toDate, search;
        String cancelButtonLabel, addPrtnr, prtnrMsg, nPrtnrMsg, canceledMsg, soldMsg, codeUnit,
                salesName, clientNa, durationRe, dateRe, typeRe,typeRePhone,typeReName, formRe, pay, timeRe, StatusRe;
        if (stat.equals("En")) {
            dir = "LTR";
            style = "text-align:left";
            title = "Reserved Units";
            cancelButtonLabel = "Cancel ";
            fromDate = "From Date";
            toDate = "To Date";
            search = "Search";
            addPrtnr = " Add Partner ";
            prtnrMsg = " Partners Was Added Successfully ";
            nPrtnrMsg = " No Partners Added ";
            canceledMsg = "Reservation Canceled";
            soldMsg = "Reserve Done";
            codeUnit = "Unit Number";
            salesName = "Sales Man";
            clientNa = "Client Name";
            durationRe = "Duration of Reserved";
            dateRe = "Date of Reserved";
            typeRe = "Broker Company";
            typeReName = "Broker Name";
            typeRePhone = "Broker Phone";
            timeRe = "Time Remaining";
            formRe = "Form of Reserved";
            pay = "Pay Plan";
            StatusRe = "EOI";
        } else {
            dir = "RTL";
            style = "text-align:Right";
            title = "عرض الحجوزات";
            cancelButtonLabel = "إنهاء ";
            fromDate = "من تاريخ";
            toDate = "إلي تاريخ";
            search = "بحث";
            addPrtnr = " إضافة شريك ";
            prtnrMsg = " تم إضافة الشركاء ";
            nPrtnrMsg = " لم تتم إضافة شركاء ";
            canceledMsg = "تم ألغاء الحجز";
            soldMsg = "Reserve Done";
            codeUnit = "كود الوحدة";
            salesName = "م. المبيعات";
            clientNa = "العميل";
            durationRe = "مدة الحجز";
            dateRe = "تاريخ الحجز";
            typeRe = "اسم الشركة الوسيط";
            typeReName = "اسم الوسيط";
            typeRePhone = "هاتف الوسيط";
            timeRe = "الوقت المتبقي بالساعة";
            formRe = "استمارة الحجز";
            pay = "خطة الدفع";
            StatusRe = "EOI";
        }
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    %>
    <head>
  <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>

        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            var oTable;
            var users = new Array();
            $(document).ready(function () {
                oTable = $('#unitsList').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).fadeIn(2000);
                $("#fromDate,#toDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy/mm/dd'
                });
            });
            function cancelForm()
            {
                document.url = "<%=context%>/main.jsp";
            }
            function navigateToClient(clientId) {
                location.href = "<%=context%>/ClientServlet?op=clientDetails&clientId=" + clientId;
            }
            function changeStatus(id, newStatus, type, unitCurrentStatus,campId) {
        // 🟢 إخفاء الزر اللي ضغط عليه المستخدم
    event.target.style.display = 'none';        
        
        var mainBuilding = $('#mainBuilding').val();
                var brokerInfName = $('#brokerInfName').val();
                var brokerInfPhone = $('#brokerInfPhone').val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/UnitServlet?op=changeReservationStatusByAjax",
                    data: {
                        id: id,
                        newStatus: newStatus,
                        unitCurrentStatus: unitCurrentStatus,
                        mainBuilding: mainBuilding,
                        brokerInf: campId,
                        brokerInfName: brokerInfName,
                        brokerInfPhone: brokerInfPhone
                    }
                    ,
                    success: function (jsonString) {
                        console.log("Response from servlet:", jsonString);
                        var info = $.parseJSON(jsonString);
                        console.log("Parsed JSON:", info);
            if (info.status === 'Ok' && info.eventName === 'confirm') {
                $("#action" + id).html("Reserve Done");
                alert("Reserve Done");
                    location.reload();

                            } else if (type == 'cancel') {
                                $("#action" + id).html("Reserve Cancel");
                                alert("Reserve Cancel");
                                    location.reload();

                            }
                         else {
                            alert("لم يتم تغيير الحالة");
                        }
                    }
                });
            }
            function planPDF(clientID, unitID) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/UnitServlet?op=getPlanAjax",
                    data: {
                        unitID: unitID,
                        clientID: clientID
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'ok') {
                            openWindow('<%=context%>/UnitServlet?op=showPaymentPlanPDF&planID=' + info.planID);
                        } else {
                            alert("لا يوجد خطة دفع");
                        }
                    }
                });
            }
            function openWindow(url) {
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=750, height=500");
            }
            function openLink(url) {
                location.href = url;
            }
            function showSelectUsrs(id)
            {

                $("#selectUsr" + id).show();
                $("#currentUsr" + id).hide();

            }
            function showSelectUsrsB(id)
            {

                $("#selectUsrB" + id).show();
                $("#currentUsrB" + id).hide();

            }
            function updateSaleReps(id)
            {
                var newUsr = $("#usrID" + id).val();
                var usrName = $("#usrID" + id).children("option").filter(":selected").text();


                $.ajax({
                    type: "post",
                    url: "<%=context%>/UnitServlet?op=updateSaleRepForUnitRes",
                    data: {
                        newUsr: newUsr,
                        resID: id,
                    }, success: function (jsonString) {
                        var eqpEmpInfo = $.parseJSON(jsonString);
                        if (eqpEmpInfo.status == 'ok') {
                            alert('saved');
                            // alert(usrName);
                            $("#usrName" + id).html(usrName);

                        }
                    }
                });
                 $("#selectUsr"+id).hide();
                $("#currentUsr"+id).show();
                }
            function updateSaleRepsB(id)
            {
                var newBUsr = $("#usrBID" + id).val();
                //var usrBName = $("#usrBID" + id).children("option").filter(":selected").text();


                $.ajax({
                    type: "post",
                    url: "<%=context%>/UnitServlet?op=updateSaleRepForUnitResB",
                    data: {
                        newBUsr: newBUsr,
                        resBID: id,
                    }, success: function (jsonString) {
                        var eqpEmpInfo = $.parseJSON(jsonString);
                        if (eqpEmpInfo.status == 'ok') {
                            alert('saved');
                            // alert(usrName);
                            location.reload(); // إعادة تحميل الصفحة بعد إنهاء العملية بنجاح
                        }
                    }
                });
                $("#selectUsrB" + id).hide();
                $("#currentUsrB" + id).show();
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
            .chosen-container{
             width: 165px !important;   
            }
        </style>
    </head>


    <BODY>
        <FORM NAME="UNIT_LIST_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue; margin-left: 1%">
                <img style="width: 80px; height: 80px; cursor: hand;" src="images/icons/sales.png" title="تقرير المبيعات"
                     onclick="JavaScript: openWindow('<%=context%>/UnitServlet?op=getSalesReport');"/>
                <img style="width: 80px; height: 80px; cursor: hand;" src="images/pie-chart.png" title="تقرير المبيعات"
                     onclick="JavaScript: openLink('<%=context%>/ReportsServletThree?op=getSalesChartReport');"/>
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
                <br/>
                <div style="width:99%;margin-right: auto;margin-left: auto;">
                    <%
                        if (reserv != null && reserv.equals("yes")) {
                    %>
                    <font color="green" size="4">
                        <%=prtnrMsg%>
                    </font>
                    <%
                    } else if (reserv != null && reserv.equals("no")) {
                    %>
                    <font color="red" size="4">
                        <%=nPrtnrMsg%>
                    </font>
                    <%
                        }
                    %>
                </div>

                <div style="width:99%;margin-right: auto;margin-left: auto;">
                    <TABLE ALIGN="center" dir="<%=dir%>" id="unitsList" style="width:100%;">
                        <thead>
                            <TR>
                                <Th>
                                    <B><%=codeUnit%></B>
                                </Th>
                                <Th>
                                    <B><%=salesName%></B>
                                </Th>
                                <Th>
                                    <B><%=clientNa%></B>
                                </Th>
                                <Th>
                                    <B><%=durationRe%></B>
                                </Th>
                                <th>
                                    <B><%=dateRe%></B>
                                </th>
                                <th>
                                    <B><%=typeRe%></B>
                                </th>
                                <th>
                                    <B><%=typeReName%></B>
                                </th>
                                <th>
                                    <B><%=typeRePhone%></B>
                                </th>
                                <th>
                                    <B><%=StatusRe%></B>
                                </th>
                                <th>
                                    <B><%=timeRe%></B>
                                </th>
                                <!--th style="width: 80px">
                                    <B><1%=formRe%></B>
                                </th-->
                                <!--th style="width: 80px">
                                    <!--B><1%=pay%></B>
                                </th-->
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
                                    if (wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_CANCEL)) {
                                        className = "canceled";
                                    } else if (wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_CONFIRM)) {
                                        className = "confirmed";
                                    } else if (wbo.getAttribute("unitCurrentStatus") != null && wbo.getAttribute("unitCurrentStatus").equals(CRMConstants.UNIT_STATUS_ONHOLD)) {
                                        className = "onhold";
                                    }
                                    if (wbo.getAttribute("projectName") != null && wbo.getAttribute("clientName") != null) {
                            %>
                            <TR>
                                <TD id="1<%=wbo.getAttribute("id")%>" class="<%=className%>">
                                    <a href="<%=context%>/UnitDocWriterServlet?op=viewUnitData&projectId=<%=wbo.getAttribute("projectId")%>&searchBy=<%=request.getAttribute("searchBy")%>&searchValue=<%=request.getAttribute("searchValue")%>&ownerID=<%=wbo.getAttribute("ownerID")%>">
                                        <b><%=wbo.getAttribute("projectName")%></b>
                                    </a>
                                </TD>
                                <TD id="2<%=wbo.getAttribute("id")%>" class="<%=className%>"style="background-color: white;width:20%;" nowrap>
                                    <table width="100%" cellpadding="0" cellspacing="0">
                                        <tr  id="currentUsr<%=wbo.getAttribute("id")%>">
                                            <td style="border: none">
                                                <span id="usrName<%=wbo.getAttribute("id")%>"><B><%=wbo.getAttribute("createdByName")%></B></span>

                                            </td>
                                            <td style="border: none">
                                                <img src="images/user_red_edit.png" onclick="javascript:showSelectUsrs('<%=wbo.getAttribute("id")%>');" width="20px" style="float: left;cursor: hand" title="تغير مسئول المبيعات" />

                                            </td>
                                        </tr>
                                        <tr style="display: none" id="selectUsr<%=wbo.getAttribute("id")%>">
                                            <td class="td" style="width:70%" nowrap > 
                                                <select style="width:100%" id="usrID<%=wbo.getAttribute("id")%>" name="usrID<%=wbo.getAttribute("id")%>">
                                                    <sw:WBOOptionList wboList="<%=usrs%>" displayAttribute="fullName" valueAttribute="userId"/>
                                                </select>
                                            </td>
                                            <td  style="width:30%" class="td">
                                                <input type="button"  style="width:100%" class="button" onclick="javascript:updateSaleReps('<%=wbo.getAttribute("id")%>');" value=" حفظ"/>
                                            </td>
                                        </tr>
                                    </table>

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
                                <TD id="5<%=wbo.getAttribute("id")%>" class="<%=className%>">
                                    <B><%=wbo.getAttribute("period") != null ? wbo.getAttribute("period") : ""%></B>
                                </TD>
                                <td id="7<%=wbo.getAttribute("id")%>" class="<%=className%>" nowrap>
                                    <B>
                                        <%=sdf.format(date)%>
                                    </B>
                                </td>
                                <td class="<%=className%>" nowrap>
                                    <table width="100%" cellpadding="0" cellspacing="0">
                                        <tr  id="currentUsrB<%=wbo.getAttribute("id")%>">
                                        <td style="border: none">
                                    <%
                                            Vector<WebBusinessObject> mainCamp = new Vector();
                                            mainCamp = ProjectMgr.getInstance().getJoinTableUnitTypeCampaign((String) wbo.getAttribute("clientId"));
                                            String campId = "";
                                            if (mainCamp != null && !mainCamp.isEmpty()) {
                                                for (WebBusinessObject WboMainCamp : mainCamp) {
                                                    if((String) WboMainCamp.getAttribute("campaign_title") == null){
                                                        campId = "";%>
                                                        <input style="width: 100px" type="text" name="brokerInf" id="BrokerInf" value="" readonly/>
                                                        <%
                                                    } else {
                                                        campId = (String) WboMainCamp.getAttribute("campaign_title");%>
                                                        <input style="width: 100px" type="text" name="brokerInf" id="BrokerInf" value="<%=campId%>" readonly/>
                                                  <%
                                                    }
                                                  %>

                                        <%}
                                }%>
                                    <!--%if (stat.equals("En")) {%>
                                    <B>
                                        <1%=wbo.getAttribute("unitCurrentStatus") != null && wbo.getAttribute("unitCurrentStatus").equals("33") ? "Refused Reserved" : ""%>
                                        <%=wbo.getAttribute("unitCurrentStatus") != null && wbo.getAttribute("unitCurrentStatus").equals("9") ? "Normal Reserved" : ""%>
                                    </B>
                                    <1%} else {%>
                                    <B>
                                        <1%=wbo.getAttribute("unitCurrentStatus") != null && wbo.getAttribute("unitCurrentStatus").equals("33") ? "حجز مرتجع" : ""%>
                                        <1%=wbo.getAttribute("unitCurrentStatus") != null && wbo.getAttribute("unitCurrentStatus").equals("9") ? "حجز عادي" : ""%>
                                    </B>
                                    <1%}%-->
                                     </td>
                                    <td style="border: none">
                                                <img src="images/user_red_edit.png" onclick="javascript:showSelectUsrsB('<%=wbo.getAttribute("id")%>');" width="20px" style="float: left;cursor: hand" title="تغير مسئول المبيعات" />
                                            </td>
                                        </tr>
                                    <tr style="display: none" id="selectUsrB<%=wbo.getAttribute("id")%>">
                                            <td class="td" style="width:70%" nowrap > 
                                                <select class="chosen-select-campaign" style="width:300%" id="usrBID<%=wbo.getAttribute("clientId")%>" name="usrBID<%=wbo.getAttribute("clientId")%>">
                                                    <sw:WBOOptionList wboList="<%=campaigne%>" displayAttribute="campaignTitle" valueAttribute="id"/>
                                                </select>
                                            </td>
                                            <td  style="width:30%" class="td">
                                                <input type="button"  style="width:100%" class="button" onclick="javascript:updateSaleRepsB('<%=wbo.getAttribute("clientId")%>');" value=" حفظ"/>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                    <td class="<%=className%>" nowrap>
                                    <%
                                            mainCamp = ProjectMgr.getInstance().getJoinTableUnitTypeCampaign((String) wbo.getAttribute("clientId"));
                                            String campIdName = "";
                                            if (mainCamp != null && !mainCamp.isEmpty()) {
                                                for (WebBusinessObject WboMainCamp : mainCamp) {
                                                    if((String) WboMainCamp.getAttribute("partner") == null){
                                                        campIdName = "";%>
                                                        <input style="width: 100px" type="text" name="brokerInfName" id="brokerInfName" value="" readonly/>
                                                        <%
                                                    } else {
                                                        campIdName = (String) WboMainCamp.getAttribute("partner");%>
                                                        <input style="width: 100px" type="text" name="brokerInfName" id="brokerInfName" value="<%=campIdName%>" readonly/>
                                                  <%
                                                    }
                                                  %>

                                        <%}
                                }%>
                                </td>
                                    <td class="<%=className%>"  nowrap>
                                    <%
                                            mainCamp = ProjectMgr.getInstance().getJoinTableUnitTypeCampaign((String) wbo.getAttribute("clientId"));
                                            String campIdPhone = "";
                                            if (mainCamp != null && !mainCamp.isEmpty()) {
                                                for (WebBusinessObject WboMainCamp : mainCamp) {
                                                    if((String) WboMainCamp.getAttribute("matiral_status") == null){
                                                        campIdPhone = "";%>
                                                        <input style="width: 100px" type="text" name="brokerInfPhone" id="brokerInfPhone" value="" readonly/>
                                                        <%
                                                    } else {
                                                        campIdPhone = (String) WboMainCamp.getAttribute("matiral_status");%>
                                                        <input style="width: 100px" type="text" name="brokerInfPhone" id="brokerInfPhone" value="<%=campIdPhone%>" readonly/>
                                                  <%
                                                    }
                                                  %>

                                        <%}
                                }%>
                                </td>
                                <td width="70%" style="<%=style%>;">
                                    <SELECT name='mainBuilding' id='mainBuilding' style='width:170px;font-size:16px;'>
                                        <option>----</option>
                                        <%
                                            Vector<WebBusinessObject> mainEOI = new Vector();
                                            mainEOI = ProjectMgr.getInstance().getmainEOI((String) wbo.getAttribute("clientId"));
                                            String productId = "";
                                            if (mainEOI != null && !mainEOI.isEmpty()) {
                                                for (WebBusinessObject WboBuilding : mainEOI) {
                                                    if((String) WboBuilding.getAttribute("UNIT_VALUE") == null){
                                                        productId = "";
                                                    } else {
                                                        productId = (String) WboBuilding.getAttribute("UNIT_VALUE");%>
                                                    <option value='<%=productId%>'><%=productId%></option>
                                                  <%
                                                    }
                                                  %>

                                        <%}
                                }%>
                                    </select>
                                    <!--<1%
                                        if (wbo.getAttribute("paymentPlace").equals("Fast")) {
                                    %>
                                    حجز سريع
                                    <1%
                                    } else {
                                    %>
                                    حجز  رسمي
                                    <1%
                                        }
                                    %>-->
                                </td>
                                <td id="timeRemaining<%=wbo.getAttribute("id")%>" class="<%=className%>" nowrap>
                                    <B>
                                        <%=wbo.getAttribute("currentStatus").equals("30") && wbo.getAttribute("remainingHours") != null ? wbo.getAttribute("remainingHours") : "---"%>
                                    </B>
                                </td>
                                <!--td id="8<1%=wbo.getAttribute("id")%>" class="<%=className%>">
                                    <1%
                                        if (wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_CANCEL)) {
                                    %>
                                    ---
                                    <1%
                                    } else {
                                    %>
                                    <B>
                                        <a href="<1%=context%>/UnitServlet?op=getUnitReservationPrint&clientCode=<1%=wbo.getAttribute("clientId")%>&unitCode=<1%=wbo.getAttribute("projectId")%>&id=<1%=wbo.getAttribute("id")%>">
                                            <img src="images/icons/pdf.png" height="20" title="PDF"/>
                                        </a>
                                        <!--a href="#" onclick="JavaScript: openWindow('<!%=context%>/UnitDocReaderServlet?op=getUnitReservationPopup&clientCode=<!%=wbo.getAttribute("clientId")%>&projectId=<!%=wbo.getAttribute("projectId")%>');">
                                            <img src="images/htmlicon.gif" title="HTML"/>
                                        </a>
                                    </B>
                                    <1%
                                        }
                                    %>
                                </td>
                                <td id="8<1%=wbo.getAttribute("id")%>" class="<1%=className%>">
                                    <1%
                                        if (wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_CANCEL)) {
                                    %>
                                    ---
                                    <1%
                                    } else {
                                    %>
                                    <B>
                                        <a href="JavaScript: planPDF('<1%=wbo.getAttribute("clientId")%>', '<1%=wbo.getAttribute("projectId")%>');">
                                            <img src="images/icons/pdf.png" height="20" title="Payment Plan"/>
                                        </a>
                                    </B>
                                    <1%
                                        }
                                    %>
                                </td-->
                                <td id="action<%=wbo.getAttribute("id")%>" class="<%=className%>" nowrap>
                                    <input type="hidden" id="currentStatus<%=wbo.getAttribute("id")%>" value="<%=wbo.getAttribute("currentStatus")%>" />
                                    <% if (wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_CONFIRM)) {%>
                                    <%=soldMsg%>
                                    <% } else if (wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_CANCEL)) {%>
                                    <%=canceledMsg%> <%="Auto".equalsIgnoreCase((String) wbo.getAttribute("actionTaken")) ? "(Auto)" : wbo.getAttribute("actionByName") != null ? "(" + wbo.getAttribute("actionByName") + ")" : ""%>
                                    <% } else {%>
                                    <!--input type="button" value="Edit" onclick="JavaScript: openWindow('<1%=context%>/UnitServlet?op=getEditReservationForm&reservationID=<1%=wbo.getAttribute("id")%>');"/-->
                                    <input type="button" id="btnConfirm" value="Confirm" onclick="JavaScript: changeStatus('<%=wbo.getAttribute("id")%>', '<%=CRMConstants.RESERVATION_STATUS_CONFIRM%>', 'confirm', '<%=wbo.getAttribute("unitCurrentStatus")%>','<%=campId%>')"/>
                                    <%-- <input type="button" value="Cancel" onclick="JavaScript: changeStatus('<%=wbo.getAttribute("id")%>', '<%=CRMConstants.RESERVATION_STATUS_CANCEL%>', 'cancel', '<%=wbo.getAttribute("unitCurrentStatus")%>')"/> --%>
                                    <img src="images/user.ico" width="35" style="float: left;" title=" <%=addPrtnr%> " onclick="openWindow('<%=context%>/UnitServlet?op=addPartner&oClntID=<%=wbo.getAttribute("clientId")%>&unitCode=<%=wbo.getAttribute("projectId")%>');"/>
                                    <% } %>
                                </td>
                            </TR>
                            <%
                                    }
                                }
                            %>
                            <tfoot>
                                <TR class="titlebar"style="font-size: 16px; font-weight: bold">
                                    <TD colspan="10">
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
                            <!-- Custom Theme Scripts -->
       
    <script type="text/javascript">
        setInterval(checkReservation, <%=interval%>);
        function checkReservation() {
            showLoading('loader');
            $.ajax({
                type: "POST",
                url: "<%=context%>/UnitServlet?op=checkReservationByAjax",
                success: function (data) {
                    doCheckReservation(data);
                    stopLoading();
                },
                error: function (data) {
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
                                actionTD.html("<%=canceledMsg%>");
                                changeRowStyle(id, "canceled", true);
                                timeRemainingTD.html("---");
                            } else if (currentStatus === '<%=CRMConstants.RESERVATION_STATUS_CONFIRM%>') {
                                actionTD.html("<%=soldMsg%>");
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
        
            var config = {
                '.chosen-select-campaign': {no_results_text: 'No campaign found with this name!'},
                '.chosen-select-rate': {no_results_text: 'No classification found with this name!'}
            };
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
            getEmployees($("#departmentID"), true);
    </script>
</html>