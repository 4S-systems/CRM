<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="java.util.Date"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@ page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        String reserv = request.getAttribute("reserv") != null ? (String) request.getAttribute("reserv") : "";
        ArrayList<WebBusinessObject> reservationsList = (ArrayList<WebBusinessObject>) request.getAttribute("reservationsList");
        ArrayList<WebBusinessObject> departments = (ArrayList<WebBusinessObject>) request.getAttribute("departments");
        String fromDateVal = (String) request.getAttribute("fromDate");
        String toDateVal = (String) request.getAttribute("toDate");
        String userID = request.getAttribute("userID") != null ? (String) request.getAttribute("userID") : "";
        String departmentID = request.getAttribute("departmentID") != null ? (String) request.getAttribute("departmentID") : "";
        String stat = (String) request.getSession().getAttribute("currentMode");
        String dir, style, title, fromDate, toDate, search, employee, department;
        if (stat.equals("En")) {
            dir = "LTR";
            style = "text-align:left";
            title = "Employee Reserved Units";
            fromDate = "From Date";
            toDate = "To Date";
            search = "Search";
            employee = "Employee";
            department = "Department";
        } else {
            dir = "RTL";
            style = "text-align:Right";
            title = "عرض حجوزات موظف";
            fromDate = "من تاريخ";
            toDate = "إلي تاريخ";
            search = "بحث";
            employee = "الموظف";
            department = "الأدارة";
        }
    %>
    <head>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>

        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script language="JavaScript" type="text/javascript">
            var oTable;
            var users = new Array();
            $(document).ready(function () {
                $("#fromDate,#toDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy/mm/dd'
                });
                oTable = $('#reservationsList').dataTable({
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
            });
            function navigateToClient(clientId) {
                location.href = "<%=context%>/ClientServlet?op=clientDetails&clientId=" + clientId;
            }
            function getEmployees(obj, afterLoad) {
                var departmentID = $(obj).val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/CommentsServlet?op=getEmployeesList",
                    data: {
                        departmentID: departmentID
                    },
                    success: function (jsonString) {
                        try {
                            var output = [];
                            output.push('<option value="all">' + "الكل" + '</option>');
                            var userID = $("#userID");
                            $(userID).html("");
                            var info = $.parseJSON(jsonString);
                            for (i = 0; i < info.length; i++) {
                                var item = info[i];
                                output.push('<option value="' + item.userId + '">' + item.fullName + '</option>');
                            }
                            userID.html(output.join(''));
                            if (afterLoad) {
                                selectedUser();
                            }
                        } catch (err) {
                        }
                    }
                });
            }
            function selectedUser() {
                $("#userID").val('<%=userID%>');
            }
        </script>
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
        </style>
    </head>
    <body>
        <form name="UNIT_LIST_FORM" method="post">
            <fieldset class="set" style="width:98%;border-color: #006699">
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
                    <tr class="head">
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white"><%=department%></font></b>
                        </td>
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white"><%=employee%></font></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" valign="middle">
                            <select id="departmentID" name="departmentID" style="font-size: 14px; width: 140px" onchange="JavaScript: getEmployees(this, false);">
                                <sw:WBOOptionList wboList="<%=departments%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=departmentID%>" />
                            </select>
                        </td>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" style="text-align:right" valign="middle">
                            <select style="font-size: 14px;font-weight: bold; width: 170px;" name="userID" id="userID">
                            </select>
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
                    <table align="center" dir="<%=dir%>" id="reservationsList" style="width:100%;">
                        <thead>
                            <tr>
                                <th>
                                    <b>كود الوحدة</b>
                                </th>
                                <th>
                                    <b>م. المبيعات</b>
                                </th>
                                <th>
                                    <b>العميل</b>
                                </th>
                                <th>
                                    <b>
                                        تاريخ الحجز
                                    </b>
                                </th>
                                <th style="" id="loader">
                                    <b>
                                        الحالة
                                    </b>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Date date;
                                String className;
                                for (WebBusinessObject wbo : reservationsList) {
                                    date = sdf.parse((String) wbo.getAttribute("reservationDate"));
                                    className = "";
                                    if (wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_CANCEL)) {
                                        className = "canceled";
                                    } else if (wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_CONFIRM)) {
                                        className = "confirmed";
                                    } else if (wbo.getAttribute("unitCurrentStatus") != null && wbo.getAttribute("unitCurrentStatus").equals(CRMConstants.UNIT_STATUS_ONHOLD)) {
                                        className = "onhold";
                                    }
                            %>
                            <tr>
                                <td id="1<%=wbo.getAttribute("id")%>" class="<%=className%>">
                                    <a href="<%=context%>/UnitDocWriterServlet?op=viewUnitData&projectId=<%=wbo.getAttribute("projectId")%>&searchBy=<%=request.getAttribute("searchBy")%>&searchValue=<%=request.getAttribute("searchValue")%>&ownerID=<%=wbo.getAttribute("ownerID")%>">
                                        <b><%=wbo.getAttribute("projectName")%></b>
                                    </a>
                                </td>
                                <td id="2<%=wbo.getAttribute("id")%>" class="<%=className%>" nowrap>
                                    <b><%=wbo.getAttribute("createdByName")%></b>
                                </td>
                                <td id="3<%=wbo.getAttribute("id")%>" class="<%=className%>" style="cursor: pointer" onclick="JavaScript : navigateToClient('<%=wbo.getAttribute("clientId")%>')" nowrap>
                                    <table width="100%" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class="td" nowrap>
                                                <b><%=wbo.getAttribute("clientName")%></b>
                                            </td>
                                            <td class="td">
                                                <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td id="7<%=wbo.getAttribute("id")%>" class="<%=className%>" nowrap>
                                    <b>
                                        <%=sdf.format(date)%>
                                    </b>
                                </td>
                                <td id="action<%=wbo.getAttribute("id")%>" class="<%=className%>" nowrap>
                                    <input type="hidden" id="currentStatus<%=wbo.getAttribute("id")%>" value="<%=wbo.getAttribute("currentStatus")%>" />
                                    <% if (wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_CONFIRM)) { %>
                                    تم البيع
                                    <% } else if (wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_CANCEL)) {%>
                                    تم ألغاء الحجز
                                    <% } else {%>
                                    محجوزة
                                    <% } %>
                                </td>
                            </tr>
                            <% }%>
                        <tfoot>
                            <tr class="titlebar"style="font-size: 16px; font-weight: bold">
                                <td colspan="5">
                                    &nbsp;
                                </td>
                            </tr>
                        </tfoot>
                        </tbody>
                    </table>
                </div>
                <br/>
            </fieldset>
        </form>
        <script language="JavaScript" type="text/javascript">
            getEmployees($("#departmentID"), true);
        </script>
    </body>
</html>