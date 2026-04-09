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
        ArrayList<WebBusinessObject> notifications = alertMgr.getMyClientLastCommentsAlert((String) loggedUser.getAttribute("userId"), 3);
        String align = null;
        String dir = null, title, clientName, clientNo, date, employeeName;

        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            title = "Last 3 Days Comments";
            clientName = "Client Name";
            clientNo = "Client No.";
            date = "Date";
            employeeName = "Employee Name";
        } else {
            align = "center";
            dir = "RTL";
            title = "تعليقات أخر 3 أيام";
            clientName = "اسم العميل";
            clientNo = "رقم العميل";
            date = "التاريخ";
            employeeName = "الموظف";
        }
    %>
    <head>
        <script type="text/javascript">

            var oTable;
            var users = new Array();
            $(document).ready(function () {
                $("#clientComments").css("display", "none");
                oTable = $('#clientComments').dataTable({
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
            <br/>
            <h5 style="color: red;"><%=title%></h5>
            <br/>
            <form name="NOTIFICATION_FORM" method="POST">
                <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
                    <table align="<%=align%>" dir="<%=dir%>" width="100%" id="clientComments">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;"><%=clientNo%></th>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;"><%=clientName%></th>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;"><%=employeeName%></th>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;"><%=date%></th>
                            </tr>
                        <thead>
                            <%if (notifications != null && !notifications.isEmpty()) {%>
                        <tbody >  
                            <%
                                for (WebBusinessObject wbo : notifications) {
                                    String className = "readRow";
                            %>
                            <tr style="cursor: pointer" id="row" class="<%=className%>">
                                <td>
                                    <font color="red"><%=wbo.getAttribute("clientNo")%></font>
                                </td>
                                <td>
                                    <b><%=wbo.getAttribute("clientName")%></b>
                                    <a href="#" onclick="JavaScript: openInNewWindow('<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("clientID")%>');">
                                        <img src="images/client_details.jpg" width="30" style="float: left;" title="Details"/>
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
