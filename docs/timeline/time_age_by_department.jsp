<%@page import="com.silkworm.util.DateAndTimeControl.TimeType"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="java.util.List"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page pageEncoding="UTF-8"%>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    List<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
    ArrayList<WebBusinessObject> departmentsList = (ArrayList<WebBusinessObject>) request.getAttribute("departmentsList");
    String type = request.getAttribute("type") != null ? (String) request.getAttribute("type") : "";
    String departmentID = request.getAttribute("departmentID") != null ? (String) request.getAttribute("departmentID") : "";
    String since = request.getAttribute("since") != null ? (String) request.getAttribute("since") : "";

    String stat = "Ar";
    String dir = null;
    String title, view;
    if (stat.equals("En")) {
        dir = "LTR";
        title = "Time Age Report";
        view = "View Report";
    } else {
        dir = "RTL";
        title = "Time Age Report";
        view = "مشاهدة التقرير";
    }
%>
<HTML>
    <head>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>

        <script LANGUAGE="JavaScript" TYPE="text/javascript">
            $(document).ready(function () {
                $("#requests").dataTable({
                    "language": {
                        "url": "js/datatable/Arabic.json"
                    },
                    "destroy": true
                }).fadeIn(2000);
            });
            function submitForm()
            {
                document.COMP_FORM.action = "<%=context%>/TimeLineServlet?op=getTimeAgeByDepartment";
                document.COMP_FORM.submit();
            }
        </script>

        <style type="text/css">
            .canceled {
                background-color: rgba(255, 0, 0, 0.5);
                color: #004276;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .confirmed {
                background-color: #459E00;
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
            #row:hover{
                cursor: pointer;
                background-color: #D3E3EB !important;
            }
        </style>
    </head>
    <body>
        <form name="COMP_FORM" method="post">
            <table align="center" width="98%">
                <tr>
                    <td class="td">
                        <fieldset class="set" style="width:98%;border-color: #006699">
                            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                                <tr>
                                    <td width="100%" class="titlebar">
                                        <font color="#005599" size="4"><%=title%></font>
                                    </td>
                                </tr>
                            </table>
                            <br/>
                            <table ALIGN="center" DIR="RTL" WIDTH="60%" CELLSPACING=2 CELLPADDING=1>
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="40%">
                                        <b><font size=3 color="white">اﻷدارة</b>
                                    </td>
                                    <td   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="40%">
                                        <b> <font size=3 color="white">منذ</b>
                                    </td>
                                    <td STYLE="text-align:center" bgcolor="#dedede" rowspan="4" WIDTH="20%">  
                                        <button onclick="JavaScript: submitForm();" style="color: #27272A; font-size:15px; font-weight:bold; height: 35px;"><%=view%> <img height="15" src="images/search.gif"/></button>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" bgcolor="#dedede"  valign="middle">
                                        <select id="departmentID" name="departmentID" style="width: 180px; font-size: 12px;">
                                            <sw:WBOOptionList wboList="<%=departmentsList%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=departmentID%>"/>
                                        </select>
                                        <br/><br/>
                                    </td>
                                    <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                                        <select id="since" name="since" style="width: 180px; font-size: 12px;">
                                            <option value="1" <%=since.equals("1") ? "selected" : ""%>>1</option>
                                            <option value="2" <%=since.equals("2") ? "selected" : ""%>>2</option>
                                            <option value="3" <%=since.equals("3") ? "selected" : ""%>>3</option>
                                            <option value="4" <%=since.equals("4") ? "selected" : ""%>>4</option>
                                            <option value="5" <%=since.equals("5") ? "selected" : ""%>>5</option>
                                            <option value="6" <%=since.equals("6") ? "selected" : ""%>>6</option>
                                            <option value="7" <%=since.equals("7") ? "selected" : ""%>>7</option>
                                            <option value="8" <%=since.equals("8") ? "selected" : ""%>>8</option>
                                            <option value="9" <%=since.equals("9") ? "selected" : ""%>>9</option>
                                            <option value="10" <%=since.equals("10") ? "selected" : ""%>>10</option>
                                            <option value="11" <%=since.equals("11") ? "selected" : ""%>>11</option>
                                            <option value="12" <%=since.equals("12") ? "selected" : ""%>>12</option>
                                        </select> يوم
                                        <br/><br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                                        <b><font size=3 color="white">الحالة</b>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" bgcolor="#dedede" valign="middle" colspan="2">
                                        <select id="type" name="type" style="width: 180px; font-size: 12px;">
                                            <option value="acknow" <%=type.equals("acknow") ? "selected" : ""%>>لم يعلم</option>
                                            <option value="finish" <%=type.equals("finish") ? "selected" : ""%>>لم ينتهي</option>
                                            <option value="close" <%=type.equals("close") ? "selected" : ""%>>لم يغلق</option>
                                        </select>
                                        <br/><br/>
                                    </td>
                                </tr>
                            </table>
                            <br/>
                            <% if (data != null) {%>
                            <center>
                                <div style="width: 97%">
                                    <table class="display" id="requests" align="center" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0">
                                        <thead>
                                            <tr> 
                                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="10%"><b>رقم المتابعة</b></th>
                                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="9%"><b>نوع الطلب</b></th>
                                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="10%"><b>رقم الطلب</b></th>
                                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="15%"><b>تاريخ الطلب</b></th>
                                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="18%"><b>المسئول</b></th>
                                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="20%"><b>المصدر</b></th>
                                            </tr>
                                        </thead> 
                                        <tbody>
                                            <%
                                                WebBusinessObject formatted;
                                                String className = "", businessID, businessIDbyDate, senderName, businessComplaintId, entryDate, typeName, ownerName;
                                                for (WebBusinessObject wbo : data) {
                                                    businessID = (String) wbo.getAttribute("businessID");
                                                    businessIDbyDate = (String) wbo.getAttribute("businessIDbyDate");
                                                    senderName = (String) wbo.getAttribute("senderName");
                                                    ownerName = (String) wbo.getAttribute("userName");
                                                    businessComplaintId = (String) wbo.getAttribute("businessCompId");
                                                    entryDate = (String) wbo.getAttribute("entryDate");
                                                    typeName = (String) wbo.getAttribute("typeName");
                                                    formatted = DateAndTimeControl.getFormattedDateTime(entryDate, stat);
                                                    className = "confirmed";
                                            %>
                                            <tr id="row">
                                                <td  style="cursor: pointer" onmouseover="this.className = '<%=className%>'" onmouseout="this.className = ''">
                                                    <font color="red"><%=businessID%></font><font color="blue">/<%=businessIDbyDate%></font>
                                                </td>
                                                <td><b><%=typeName%></b></td>
                                                <td><b><%=businessComplaintId%></b></td>                                     
                                                <td nowrap><font color="red"><%=formatted.getAttribute("day")%> - </font><b><%=formatted.getAttribute("time")%></b></td>
                                                <td><b><%=ownerName%></b></td>
                                                <td><b><%=senderName%></b></td>
                                            </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            </center>
                            <br/>
                            <br/>
                            <% }%>
                        </fieldset>
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>     
