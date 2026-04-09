<%@page import="java.math.MathContext"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.clients.db_access.ClientComplaintsSLAMgr"%>
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
        ClientComplaintsSLAMgr clientComplaintsSLAMgr = ClientComplaintsSLAMgr.getInstance();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String userID = "";
        if (loggedUser != null) {
            userID = (String) loggedUser.getAttribute("userId");
        }
        ArrayList<WebBusinessObject> complaintsList = clientComplaintsSLAMgr.getNotCompletedComplaintsSLA(userID);
        String stat = (String) request.getSession().getAttribute("currentMode");
        String dir, style;
        if (stat.equals("En")) {
            dir = "LTR";
            style = "text-align:left";
        } else {
            dir = "RTL";
            style = "text-align:Right";
        }
    %>
    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
        <link rel="stylesheet" href="css/CSS.css"/>
        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/loading/loading.js"></script>
        <script type="text/javascript" src="js/loading/spin.js"></script>
        <script type="text/javascript" src="js/loading/spin.min.js"></script>
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            var oTable;
            var users = new Array();
            $(document).ready(function () {
                oTable = $('#complaintsList').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).fadeIn(2000);
            });
            
            function getUnitsList(clientId, obj) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=getUnitsListAjax",
                    data: {
                        clientId: clientId
                    }
                    ,
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        $(obj).attr("title", "الوحدات: " + info.unitsCodes);
                    }
                });
            }
        </SCRIPT>
        <style>  
            .severe {
                background-color: #FF5C5C;
                color: black;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .danger {
                background-color: #FFFF5C;
                color: black;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .good {
                background-color: #82CD82;
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
                <div style="width: 99%; margin-right: auto; margin-left: auto; ">
                    <br/>
                    <br/>
                    <table align="center" dir="<%=dir%>" id="complaintsList" style="width:100%;">
                        <thead>
                            <tr>
                                <th>
                                    <b>الحالة</b>
                                </th>
                                <th>
                                    <b>رقم المتابعة</b>
                                </th>
                                <th>
                                    <b>كود الطلب</b>
                                </th>
                                <th>
                                    <b>اسم العميل</b>
                                </th>
                                <th>
                                    <b>المسؤول</b>
                                </th>
                                <th>
                                    <b>مدة التنفيذ</b>
                                </th>
                                <th>
                                    <b>تاريخ التنفيذ</b>
                                </th>
                                <th>
                                    <b>
                                        الباقي (ساعة:يوم)
                                    </b>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                String className, endDate;
                                BigDecimal remain;
                                long remainLong, remainingHours;
                                double temp;
                                for (WebBusinessObject wbo : complaintsList) {
                                    remain = (BigDecimal) wbo.getAttribute("remain");
                                    remainLong = remain.toBigInteger().longValue();
                                    temp =  (remain.doubleValue() - remainLong) * 24;
                                    remainingHours = Double.valueOf(temp).longValue();
                                    className = "";
                                    if (remainLong > 2) {
                                        className = "good";
                                    } else if (remainLong > 0) {
                                        className = "danger";
                                    } else {
                                        className = "severe";
                                    }
                                    endDate = (String) wbo.getAttribute("endDate");
                                    if(endDate != null && endDate.contains(" ")) {
                                        endDate = endDate.split(" ")[0];
                                    }
                            %>
                            <tr>
                                <td class="<%=className%>">
                                    <b><%=wbo.getAttribute("statusName")%></b>
                                </td>
                                <td class="<%=className%>" nowrap>
                                    <a href="<%=context%>/IssueServlet?op=getCompl&issueId=<%=wbo.getAttribute("issueID")%>&compId=<%=wbo.getAttribute("clientComplaintID")%>&statusCode=<%=wbo.getAttribute("statusCode")%>&clientType=30-40"><b><font color="red"><%=wbo.getAttribute("businessID")%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate")%></font></b></a>
                                    <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("clientID")%>" target="_blank">
                                        <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل" onmouseover="JavaScript: changeCommentCounts('6194', this);"/>
                                    </a>
                                </td>
                                <td class="<%=className%>">
                                    <b onmouseover="JavaScript: getUnitsList('<%=wbo.getAttribute("clientID")%>', this)"><%=wbo.getAttribute("businessCompID")%></b>
                                </td>
                                <td class="<%=className%>" nowrap>
                                    <b><%=wbo.getAttribute("clientName")%></b>
                                </td>
                                <td class="<%=className%>">
                                    <b><%=wbo.getAttribute("ownerName") != null ? wbo.getAttribute("ownerName") : ""%></b>
                                </td>
                                <td class="<%=className%>" nowrap>
                                    <b><%=wbo.getAttribute("executionPeriod")%></b>
                                </td>
                                <td class="<%=className%>" nowrap>
                                    <b><%=endDate%></b>
                                </td>
                                <td class="<%=className%>" nowrap>
                                    <b>
                                        <table dir="<%=dir%>" align="center" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td class="td"><%=remainingHours%></td><td class="td">:</td><td class="td"><%=remainLong%></td>
                                            </tr>
                                        </table>
                                    </b>
                                </td>
                            </tr>
                            <% }%>
                        </tbody>
                    </table>
                    <br/>
                    <br/>
                </div>
                <br/>
            </fieldset>
        </form>
    </body>
</html>