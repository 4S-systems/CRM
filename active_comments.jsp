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
        AlertMgr alertMgr = AlertMgr.getInstance();
        WebBusinessObject loggedUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        ArrayList<WebBusinessObject> notifications = alertMgr.getActiveCommentsAlert((String) loggedUser.getAttribute("userId"));
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
                $("#activeComments").css("display", "none");
                oTable = $('#activeComments').dataTable({
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
            function changeActiveStatus(status, type, id, note, actionCode) {
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
                            if (type === 'readActive') {
                                $("#readActive" + id).parent().parent().toggleClass("unreadRow");
                                $("#readActive" + id).parent().parent().toggleClass("readRow");
                                $("#readActive" + id).css("display", "none");
                                $("#unreadActive" + id).css("display", "");
                            } else if (type === 'unreadActive') {
                                $("#readActive" + id).parent().parent().toggleClass("unreadRow");
                                $("#readActive" + id).parent().parent().toggleClass("readRow");
                                $("#readActive" + id).css("display", "");
                                $("#unreadActive" + id).css("display", "none");
                            } else if (type === 'action') {
                                $("#readActive" + id).parent().parent().removeClass("actionRow");
                                $("#readActive" + id).parent().parent().addClass("actionRow");
                                $("#readActive" + id).css("display", "none");
                                $("#unreadActive" + id).css("display", "none");
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
        <fieldset class="set" style="width:96%;" >
            <form name="NOTIFICATION_FORM" method="POST">
                <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
                    <table align="<%=align%>" dir="<%=dir%>" width="100%" id="activeComments">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;">رقم العميل</th>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;">اسم العميل</th>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;">الموظف</th>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;">التاريخ</th>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;" width="5px"></th>
                            </tr>
                        <thead>
                            <%if (notifications != null && !notifications.isEmpty()) {%>
                        <tbody >  
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
                                    <font color="red"><%=wbo.getAttribute("clientNo")%></font>
                                </td>
                                <td>
                                    <b><%=wbo.getAttribute("clientName")%></b>
                                    <a href="#" onclick="JavaScript: openInNewWindow('<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("clientID")%>');">
                                        <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"/>
                                    </a>
                                </td>
                                <td >
                                    <b><%=wbo.getAttribute("commentBy") != null ? wbo.getAttribute("commentBy") : "---"%></b>
                                </td>
                                <td >
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
                                         id="readActive<%=alertID%>" onclick="JavaScript: changeActiveStatus('38', 'readActive', '<%=alertID%>',
                                                         'UL', 'UL');" title="علم"/>
                                    <img src="images/red.gif" style="display: <%=statusCode.equals("38") ? "" : "none"%>; cursor: hand;" width="20px"
                                         id="unreadActive<%=alertID%>" onclick="JavaScript: changeActiveStatus('37', 'unreadActive', '<%=alertID%>',
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
