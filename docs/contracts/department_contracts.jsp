<%@page import="com.maintenance.common.DateParser"%>
<%@page import="com.silkworm.common.SecurityUser"%>
<%@page import="com.clients.db_access.ReservationMgr"%>
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
        Calendar c = Calendar.getInstance();
        String timeFormat = "yyyy/MM/dd";
        SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
        String nowTime = sdf.format(c.getTime());
        String toDateVal = request.getParameter("toDate") != null ? (String) request.getParameter("toDate") : nowTime;
        c.add(Calendar.MONTH, -1);
        nowTime = sdf.format(c.getTime());
        String fromDateVal = request.getParameter("fromDate") != null ? (String) request.getParameter("fromDate") : nowTime;
        DateParser dateParser = new DateParser();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String jsDateFormat = (String) loggedUser.getAttribute("jsDateFormat");
        java.sql.Date fromDateD = dateParser.formatSqlDate(fromDateVal, jsDateFormat);
        java.sql.Date toDateD = dateParser.formatSqlDate(toDateVal, jsDateFormat);
        ReservationMgr reservationMgr = ReservationMgr.getInstance();
        WebBusinessObject departmentInfo = ProjectMgr.getInstance().getManagerByEmployee((String) loggedUser.getAttribute("userId"));
        ArrayList<WebBusinessObject> departmentList = new ArrayList<>(ProjectMgr.getInstance().getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key5"));
        String departmentID = "none";
        if ((departmentInfo != null) && (departmentInfo.getAttribute("projectID") != null)) {
            departmentID = (String) departmentInfo.getAttribute("projectID");
        } else if (departmentList.size() > 0) {
            departmentID = (String) departmentList.get(0).getAttribute("projectID");
        }
        ArrayList<WebBusinessObject> unitsList = reservationMgr.getReservedUnits(fromDateD, toDateD, departmentID, null);
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        String companyID = securityUser.getCompanyId();
        ArrayList<WebBusinessObject> prevType = securityUser.getComplaintMenuBtn();
        ArrayList<String> previlegesList = new ArrayList<>();
        for (WebBusinessObject wboTemp : prevType) {
            if (wboTemp != null && wboTemp.getAttribute("prevCode") != null) {
                previlegesList.add((String) wboTemp.getAttribute("prevCode"));
            }
        }
        String stat = (String) request.getSession().getAttribute("currentMode");
        String dir, style, title, fromDate, toDate, search;
        String cancelButtonLabel;
        if (stat.equals("En")) {
            dir = "LTR";
            style = "text-align:left";
            title = "Sold &amp; Reserved Units";
            cancelButtonLabel = "Cancel ";
            fromDate = "From Date";
            toDate = "To Date";
            search = "Search";
        } else {
            dir = "RTL";
            style = "text-align:Right";
            title = "عرض الحجوزات والمبيعات";
            cancelButtonLabel = "إنهاء ";
            fromDate = "من تاريخ";
            toDate = "إلي تاريخ";
            search = "بحث";
        }
        sdf = new SimpleDateFormat("yyyy-MM-dd");
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
            function navigateToClient(clientId) {
                location.href = "<%=context%>/ClientServlet?op=clientDetails&clientId=" + clientId;
            }
            function changeStatus(id, newStatus, type, unitCurrentStatus) {
                var notes = "UL";
                if (newStatus === '42') {
                    notes = $("#notes").val();
                }
                $.ajax({
                    type: "post",
                    url: "<%=context%>/UnitServlet?op=changeReservationStatusByAjax",
                    data: {
                        id: id,
                        newStatus: newStatus,
                        unitCurrentStatus: unitCurrentStatus,
                        notes: notes
                    }
                    ,
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok') {
                            if (type == 'confirm') {
                                $("#action" + id).html("تم البيع");
                                alert("تم البيع");
                            } else if (type == 'cancel') {
                                $("#action" + id).html("تم ألغاء الحجز");
                                alert("تم ألغاء الحجز");
                            } else if (type == 'retrieve') {
                                $("#action" + id).html("تحت اﻷسترداد");
                                alert("تم ألغاء البيع");
                                $("#retrieve_div").dialog('close');
                            }
                        } else {
                            alert("لم يتم تغيير الحالة");
                        }
                    }
                });
            }
            function openWindow(url) {
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=750, height=500");
            }
            var divTag;
            function deleteReservationDialog(id, unitName, clientName) {
                divTag = $("div[name='divTag']");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/UnitServlet?op=getDeleteReservationDialog',
                    data: {
                        id: id,
                        unitName: unitName,
                        clientName: clientName
                    },
                    success: function (data) {
                        divTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: "حذف الحجز",
                                    show: "fade",
                                    hide: "explode",
                                    width: 400,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    }
                                })
                                .dialog('open');
                    },
                    error: function (data) {
                        alert(data);
                    }
                });
            }
            function retrieveDialog(id, newStatus, type, unitCurrentStatus) {
                $("#retrieve_div").css("display", "block");
                $("#notes").val("");
                $("#retrieve_div").dialog({
                    modal: true,
                    title: "أسترداد",
                    show: "fade",
                    hide: "explode",
                    width: 350,
                    position: {
                        my: 'center',
                        at: 'center'
                    },
                    buttons: {
                        ألغاء: function () {
                            $(this).dialog('close');
                        },
                        أسترداد: function () {
                            changeStatus(id, newStatus, type, unitCurrentStatus);
                        }
                    }
                }).dialog('open');
            }
            function closePopup() {
                divTag.dialog('close');
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
        <div name="divTag"></div>
        <div id="retrieve_div" style="display: none;">
            <table border="0px" style="width:100%;" class="table">
                <tr>
                    <td style="width: 70%;" >
                        <textarea placeholder="سبب الأسترداد" style="width: 100%; height: 100px; <%=style%>;" id="notes" name="notes"></textarea>
                    </td>
                    <td style="font-size: 16px; font-weight: bold; width: 30%; vertical-align: middle;" nowrap>سبب الأسترداد</td>
                </tr> 
            </table>
        </div>
        <FORM NAME="UNIT_LIST_FORM" METHOD="POST">
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
                    <TABLE ALIGN="center" dir="<%=dir%>" id="unitsList" style="width:100%;">
                        <thead>
                            <TR>
                                <Th>
                                    <B>كود الوحدة</B>
                                </Th>
                                <Th>
                                    <B>م. المبيعات</B>
                                </Th>
                                <Th>
                                    <B>العميل</B>
                                </Th>
                                <Th>
                                    <B>مدة الحجز</B>
                                </Th>
                                <th>
                                    <B>
                                        تاريخ الحجز
                                    </B>
                                </th>
                                <th>
                                    <B>
                                        نوع الحجز
                                    </B>
                                </th>
                                <th>
                                    <B>
                                        الوقت المتبقي بالساعة
                                    </B>
                                </th>
                                <th style="width: 80px">
                                    <B>
                                        أستماره الحجز
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
                                        <%=wbo.getAttribute("unitCurrentStatus") != null && wbo.getAttribute("unitCurrentStatus").equals("33") ? "حجز مرتجع" : ""%>
                                        <%=wbo.getAttribute("unitCurrentStatus") != null && wbo.getAttribute("unitCurrentStatus").equals("9") ? "حجز عادي" : ""%>
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
                                        <%if (companyID != null || companyID != "") {%>
                                        <a href="<%=context%>/UnitServlet?op=getCompanyUnitReservationPrint&clientCode=<%=wbo.getAttribute("clientId")%>&unitCode=<%=wbo.getAttribute("projectId")%>&id=<%=wbo.getAttribute("id")%>&companyId=<%=companyID%>">
                                            <img src="images/icons/pdf.png" height="20" title="PDF"/>
                                        </a>
                                        <%} else {%>
                                        <a href="<%=context%>/UnitServlet?op=getUnitReservationPrint&clientCode=<%=wbo.getAttribute("clientId")%>&unitCode=<%=wbo.getAttribute("projectId")%>&id=<%=wbo.getAttribute("id")%> ">
                                            <img src="images/icons/pdf.png" height="20" title="PDF"/>
                                        </a>
                                        <%}%>
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
                                    <% if (wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_CONFIRM)) {%>
                                    تم البيع &nbsp; <input type="button" value="أسترداد" onclick="JavaScript: retrieveDialog('<%=wbo.getAttribute("id")%>', '<%=CRMConstants.RESERVATION_STATUS_UNDER_RETRIEVE%>', 'retrieve', '<%=wbo.getAttribute("unitCurrentStatus")%>')"/>
                                    <% } else if (wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_CANCEL)) {%>
                                    تم ألغاء الحجز&nbsp; <% if (previlegesList.contains("DELETE_RESERVATION")) {%><input type="button" value="حذف" onclick="JavaScript: deleteReservationDialog('<%=wbo.getAttribute("id")%>', '<%=wbo.getAttribute("projectName")%>', '<%=wbo.getAttribute("clientName")%>')"/><% } %>
                                    <% } else if (wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_UNDER_RETRIEVE)) {%>
                                    تحت اﻷسترداد
                                    <% } else if (wbo.getAttribute("currentStatus").equals(CRMConstants.RESERVATION_STATUS_RETRIEVED)) {%>
                                    تم اﻷسترداد
                                    <% } else {%>
                                    <input type="button" value="Edit" onclick="JavaScript: openWindow('<%=context%>/UnitServlet?op=getEditReservationForm&reservationID=<%=wbo.getAttribute("id")%>');"/>
                                    <input type="button" value="Confirm" onclick="JavaScript: changeStatus('<%=wbo.getAttribute("id")%>', '<%=CRMConstants.RESERVATION_STATUS_CONFIRM%>', 'confirm', '<%=wbo.getAttribute("unitCurrentStatus")%>')"/>
                                    <input type="button" value="Cancel" onclick="JavaScript: changeStatus('<%=wbo.getAttribute("id")%>', '<%=CRMConstants.RESERVATION_STATUS_CANCEL%>', 'cancel', '<%=wbo.getAttribute("unitCurrentStatus")%>')"/>
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
</html>