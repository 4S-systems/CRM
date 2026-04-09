<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.crm.db_access.AlertMgr"%>
<%@page import="java.util.Map"%>
<%@page import="com.silkworm.common.SecurityUser"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String stat = (String) request.getSession().getAttribute("currentMode");
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        Map<String, String> withinIntervals = securityUser.getWithinIntervals();
        Calendar cal = Calendar.getInstance();
        String timeFormat = "yyyy/MM/dd";
        SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
        String nowTime = sdf.format(cal.getTime());
        String toDateVal = nowTime;
        if (request.getParameter("toDateActive") != null) {
            toDateVal = request.getParameter("toDateActive");
            withinIntervals.put("toDateActive", "" + toDateVal);
        } else if (withinIntervals.containsKey("toDateActive")) {
            toDateVal = withinIntervals.get("toDateActive");
        }
        cal.add(Calendar.DAY_OF_MONTH, -1);
        nowTime = sdf.format(cal.getTime());
        String fromDateVal = nowTime;
        if (request.getParameter("fromDateActive") != null) {
            fromDateVal = request.getParameter("fromDateActive");
            withinIntervals.put("fromDateActive", "" + fromDateVal);
        } else if (withinIntervals.containsKey("fromDateActive")) {
            fromDateVal = withinIntervals.get("fromDateActive");
        }

        AlertMgr alertMgr = AlertMgr.getInstance();
        ArrayList<WebBusinessObject> notifications = alertMgr.getContractsAlert(new java.sql.Date(sdf.parse(fromDateVal).getTime()), new java.sql.Date(sdf.parse(toDateVal).getTime()));
        String align = null;
        String dir = null;

        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
        } else {
            align = "center";
            dir = "RTL";
        }
    %>
    <head>
        <script type="text/javascript">

            var oTable;
            var users = new Array();
            $(document).ready(function () {
                $("#notifications").css("display", "none");
                oTable = $('#notifications').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[6, "desc"]]

                }).fadeIn(2000);

            });
            function changeStatus(status, type, id, note, actionCode) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/IssueServlet?op=changeNotificationStatusAjax",
                    data: {
                        id: id,
                        status: status,
                        note: note,
                        actionCode: actionCode
                    }
                    ,
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'Ok') {
                            $("#currentStatus" + id).html(info.currentStatusName);
                            if (type === 'read') {
                                $("#read" + id).parent().parent().toggleClass("unreadRow");
                                $("#read" + id).parent().parent().toggleClass("readRow");
                                $("#read" + id).css("display", "none");
                                $("#unread" + id).css("display", "");
                            } else if (type === 'unread') {
                                $("#read" + id).parent().parent().toggleClass("unreadRow");
                                $("#read" + id).parent().parent().toggleClass("readRow");
                                $("#read" + id).css("display", "");
                                $("#unread" + id).css("display", "none");
                            } else if (type === 'action') {
                                $("#read" + id).parent().parent().removeClass("actionRow");
                                $("#read" + id).parent().parent().addClass("actionRow");
                                $("#read" + id).css("display", "none");
                                $("#unread" + id).css("display", "none");
                                $("#actionRead" + id).css("display", "");
                                $("#add_action").bPopup().close();
                            }
                        } else if (info.status === 'failed') {
                            alert("لم يتم تغيير الحالة");
                        }
                    }
                });
            }
            function submitWithInForm() {
                document.within_notification_form.submit();
            }
        </script>
        <style>
            #row:hover{
                background-color: #EEEEEE;
            }

            #row.unreadRow {
                background-color: #FFDDED;
            }

            #row.readRow {
                background-color: #FFFFFF;
            }

            #row.actionRow {
                background-color: #C3CFB7;
            }

        </style>
    </head>
    <body>
        <fieldset class="set" style="width:96%;">
            <form name="within_notification_form">
                <table class="blueBorder" id="code2" align="center" dir="<%=dir%>" width="650" cellspacing="2" cellpadding="1"
                       style="border-width:1px;border-color:white;display: block;">
                    <tr class="head">
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white">من تاريخ</font></b>
                        </td>
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white">إلي تاريخ</font></b>
                        </td>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 250px;" bgcolor="#EEEEEE" valign="middle" rowspan="2">
                            <button type="submit" class="button" style="width: 170px;">بحث<img height="15" src="images/search.gif"/></button>
                            <br/>
                            <br/>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" valign="middle">
                            <input class="fromToDate" id="fromDateActive" name="fromDateActive" type="text" value="<%=fromDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" style="text-align:right" valign="middle">
                            <input class="fromToDate" id="toDateActive" name="toDateActive" type="text" value="<%=toDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                    </tr>
                </table>
            </form>
            <form name="NOTIFICATION_FORM" method="POST">
                <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
                    <table align="<%=align%>" dir="<%=dir%>" width="100%" id="notifications">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;">رقم العقد</th>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;">اسم العميل</th>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;">تاريخ بداية العقد</th>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;">تاريخ أنتهاء العقد</th>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;">تاريخ الأشعار</th>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;" width="5px"></th>
                            </tr>
                        </thead>
                        <%if (notifications != null && !notifications.isEmpty()) {%>
                        <tbody>
                            <%
                                for (WebBusinessObject wbo : notifications) {
                                    String className = "";
                                    String statusCode = wbo.getAttribute("statusCode") != null ? (String) wbo.getAttribute("statusCode") : "";
                                    if (statusCode.equals("37")) {
                                        className = "unreadRow";
                                    } else if (statusCode.equals("38")) {
                                        className = "readRow";
                                    } else if (statusCode.equals("39")) {
                                        className = "actionRow";
                                    }
                                    String alertID = (String) wbo.getAttribute("alertID");
                            %>
                            <tr style="cursor: pointer" id="row" class="<%=className%>">
                                <td>
                                    <font color="red"><%=wbo.getAttribute("contractNumber")%></font>
                                </td>
                                <td>
                                    <b><%=wbo.getAttribute("clientName")%></b>
                                    <a href="#" onclick="JavaScript: openInNewWindow('<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("clientID")%>');">
                                        <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"/>
                                    </a>
                                </td>
                                <td>
                                    <b><%=wbo.getAttribute("beginDate") != null ? ((String) wbo.getAttribute("beginDate")).substring(0, 10) : "---"%></b>
                                </td>
                                <td>
                                    <b><%=wbo.getAttribute("endDate") != null ? ((String) wbo.getAttribute("endDate")).substring(0, 10) : "---"%></b>
                                </td>
                                <td>
                                    <%
                                        if (wbo.getAttribute("alertCreationDate") != null) {
                                            WebBusinessObject fomatted = DateAndTimeControl.getFormattedDateTime(wbo.getAttribute("alertCreationDate").toString(), stat);
                                    %>
                                    <font color="red"><%=fomatted.getAttribute("day")%> - </font><b><%=fomatted.getAttribute("time")%></b>
                                        <%
                                            }
                                        %>
                                </td>
                                <td>
                                    <img src="images/green.gif" style="display: <%=statusCode.equals("37") ? "" : "none"%>; cursor: hand;" width="20px"
                                         id="read<%=alertID%>" onclick="JavaScript: changeStatus('38', 'read', '<%=alertID%>',
                                                         'UL', 'UL');" title="علم"/>
                                    <img src="images/red.gif" style="display: <%=statusCode.equals("38") ? "" : "none"%>; cursor: hand;" width="20px"
                                         id="unread<%=alertID%>" onclick="JavaScript: changeStatus('37', 'unread', '<%=alertID%>',
                                                         'UL', 'UL');" title="لم تقروء"/>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                        <%
                            }
                        %>
                    </table>
                    <br />
                </div>
            </form>
        </fieldset>
    </body>
</html>