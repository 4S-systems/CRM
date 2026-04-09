<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page pageEncoding="UTF-8"%>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    int iTotal = 0;
    ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
    String status = (String) request.getAttribute("status");
    String beDate = (String) request.getAttribute("beginDate");
    String eDate = (String) request.getAttribute("endDate");
    String issueType = "";
    if (request.getAttribute("issueType") != null) {
        issueType = (String) request.getAttribute("issueType");
    }
    Calendar cal = Calendar.getInstance();
    String jDateFormat = "yyyy/MM/dd";
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowTime = sdf.format(cal.getTime());
    cal = Calendar.getInstance();
    cal.add(Calendar.MONTH, -1);
    int a = cal.get(Calendar.YEAR);
    int b = (cal.get(Calendar.MONTH)) + 1;
    int d = cal.get(Calendar.DATE);
    String prev = a + "/" + b + "/" + d;
    String stat = "Ar";
    String align = "center";
    String dir = null;
    String style = null, beginDate, endDate, print;
    String complaintNo, customerName;
    String sat, sun, mon, tue, wed, thu, fri, successMsg, failMsg;
    if (stat.equals("En")) {
        align = "left";
        dir = "LTR";
        style = "text-align:right";
        beginDate = "From Date";
        endDate = "To Date";
        print = "Print";
        complaintNo = "Order No.";
        customerName = "Customer name";
        sat = "Sat";
        sun = "Sun";
        mon = "Mon";
        tue = "Tue";
        wed = "Wed";
        thu = "Thu";
        fri = "Fri";
        successMsg = "Task deleted successfully";
        failMsg = "Fail to delete Task";
    } else {
        dir = "RTL";
        align = "right";
        style = "text-align:Right";
        beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
        endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        print = "&#1591;&#1576;&#1575;&#1593;&#1577; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
        complaintNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1578;&#1575;&#1576;&#1593;&#1577;";
        customerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";
        sat = "&#1575;&#1604;&#1587;&#1576;&#1578;";
        sun = "&#1575;&#1604;&#1575;&#1581;&#1583;";
        mon = "&#1575;&#1604;&#1575;&#1579;&#1606;&#1610;&#1606;";
        tue = "&#1575;&#1604;&#1579;&#1604;&#1575;&#1579;&#1575;&#1569;";
        wed = "&#1575;&#1604;&#1575;&#1585;&#1576;&#1593;&#1575;&#1569;";
        thu = "&#1575;&#1604;&#1582;&#1605;&#1610;&#1587;";
        fri = "&#1575;&#1604;&#1580;&#1605;&#1593;&#1577;";
        successMsg = "تم الحذف بنجاح";
        failMsg = "لم يتم الحذف";
    }
    String sDate, sTime = null;
%>
<HTML>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <META HTTP-EQUIV="Expires" CONTENT="0"/>   
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css"/>
        <script src='ChangeLang.js' type='text/javascript'></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            $(function() {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    minDate: "+d",
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });
            $(document).ready(function() {
                $('#indextable').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[20, 40, 70, 100, -1], [20, 40, 70, 100, "All"]],
                    iDisplayLength: 20,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[1, "asc"]]
                }).show();
            });
            function getComplaints() {
                var beginDate = $("#beginDate").val();
                var endDate = $("#endDate").val();
                if ((beginDate = null || beginDate == "")) {
                    alert("من فضلك أدخل تاريخ البداية");
                }
                else if ((endDate = null || endDate == "")) {
                    alert("من فضلك أدخل تاريخ النهاية");
                } else {
                    beginDate = $("#beginDate").val();
                    endDate = $("#endDate").val();
                    var issueType = $("#issueType").val();
                    document.COMP_FORM.action = "<%=context%>/DatabaseControllerServlet?op=clearErrorTasks&beginDate=" + beginDate + "&endDate=" + endDate + "&issueType=" + issueType;
                    document.COMP_FORM.submit();
                }
            }
            function deleteTask(issueId) {
                var r = confirm("Are You Sure You want to delete task and all its data.");

                if (r == true)
                {
                    document.COMP_FORM.action = "<%=context%>/DatabaseControllerServlet?op=deleteTask&issueId=" + issueId + "&beginDate=<%=beDate%>&endDate=<%=eDate%>&issueType=<%=issueType%>";
                    document.COMP_FORM.submit();
                }
            }
        </script>
    </head>
    <body>
        <form name="COMP_FORM" method="POST">
            <%
                if (status != null) {
                    if (status.equalsIgnoreCase("ok")) {
            %>
            <div style="width: 100%; text-align: center;"> <b> <font size="3" color="blue"><%=successMsg%></font></b></div> 
                    <%
                    } else {
                    %>
            <div style="width: 100%; text-align: center;"> <b> <font size="3" color="red"><%=failMsg%></font></b></div> 
                    <%
                            }
                        }
                    %>
            <table align="center" width="80%">
                <tr>
                    <td class="td">
                        <fieldset >
                            <legend align="center">
                                <font color="blue" size="6">&nbsp;Clear Error Tasks&nbsp;
                                </font>
                            </legend>
                            <table align="center" dir="RTL" with="570" cellspacing="2" cellpadding="1">
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" with="50%">
                                        <b><font size=3 color="white"> <%=beginDate%></b>
                                    </td>
                                    <td   class="blueBorder blueHeaderTD" style="font-size:18px;"with="50%">
                                        <b> <font size=3 color="white"> <%=endDate%> </b>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                                        <%
                                            Calendar c = Calendar.getInstance();
                                        %>
                                        <% if (beDate != null && !beDate.isEmpty()) {%>
                                        <input id="beginDate" name="beginDate" type="text" value="<%=beDate%>" /><img src="images/showcalendar.gif" > 
                                        <%} else {%>
                                        <input id="beginDate" name="beginDate" type="text" value="<%=prev%>" ><img src="images/showcalendar.gif" > 
                                        <%}%>
                                        <br><br>
                                    </td>
                                    <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                                        <% if (eDate != null && !eDate.isEmpty()) {%>
                                        <input id="endDate" name="endDate" type="text" value="<%=eDate%>" ><img src="images/showcalendar.gif" > 
                                        <%} else {%>
                                        <input id="endDate" name="endDate" type="text" value="<%=nowTime%>" ><img src="images/showcalendar.gif" > 
                                        <%}%>
                                        <br><br>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                                        <b><font size=3 color="white">نوع الطلب</b>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <select style="font-size: 14px;font-weight: bold; width: 100px;" id="issueType" name="issueType">
                                            <option value="call" <%=issueType.equalsIgnoreCase("call") ? "selected" : ""%>>مكالمة</option>
                                            <option value="meeting" <%=issueType.equalsIgnoreCase("meeting") ? "selected" : ""%>>مقابلة</option>
                                            <option value="internet" <%=issueType.equalsIgnoreCase("internet") ? "selected" : ""%>>أنترنت</option>
                                            <option value="client_complaint" <%=issueType.equalsIgnoreCase("client_complaint") ? "selected" : ""%>>مستخلص</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                <br><br>
                                <td STYLE="text-align:center" CLASS="td" colspan="3">  
                                    <button  onclick="JavaScript: getComplaints();"   STYLE="color: #000;font-size:15;margin-top: 20px;font-weight:bold; ">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                                </td>
                                </tr>
                            </table>
                        </fieldset>
                    </td>
                </tr>
            </table>
        </form>
        <% if (data != null && !data.isEmpty()) {%>
        <div style="width: 100%; text-align: center;"> <b> <font size="3" color="red"> Tasks No. : <%=data.size()%> </font></b></div> 
        <table class="blueBorder" id="indextable" align="center" dir="<%=dir%>" width="70%" cellpadding="0" cellspacing="0" style="display: none;">
            <thead>
                <tr>
                    <th CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%"><span><b>#</b></span></th>
                    <th CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="32%"><span><img src="images/icons/Numbers.png" width="20" height="20" /><b> <%=complaintNo%></b></span></th>
                    <th CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="32%"><span><img src="images/icons/client.png" width="20" height="20" /><b> <%=customerName%></b></span></th>
                    <th CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="31%"><b>تاريخ اﻷدخال</b></th>
                    <th CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="31%">&nbsp;</th>
                </tr>
            </thead> 
            <tbody id="planetData2">  
                <%
                    String compStyle = "";
                    for (WebBusinessObject wbo : data) {
                        iTotal++;
                %>
                <tr style="padding: 1px;">
                    <td>
                        <div>
                            <b> <%=iTotal%> </b>
                        </div>
                    </td>
                    <td onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                        <%if (wbo.getAttribute("id") != null) {%>
                        <font color="red"><%=wbo.getAttribute("businessID")%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate")%></font>
                        <%}
                        %>
                    </td>
                    <td>
                        <%if (wbo.getAttribute("clientName") != null) {%>
                        <b><%=wbo.getAttribute("clientName")%></b>
                        <%}%>
                    </td>
                    <%  c = Calendar.getInstance();
                        DateFormat formatter;
                        formatter = new SimpleDateFormat("dd/MM/yyyy");
                        String[] arrDate = wbo.getAttribute("creationTime").toString().split(" ");
                        Date date = new Date();
                        sDate = arrDate[0];
                        sTime = arrDate[1];
                        String[] arrTime = sTime.split(":");
                        sTime = arrTime[0] + ":" + arrTime[1];
                        sDate = sDate.replace("-", "/");
                        arrDate = sDate.split("/");
                        sDate = arrDate[2] + "/" + arrDate[1] + "/" + arrDate[0];
                        c.setTime((Date) formatter.parse(sDate));
                        int dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
                        String currentDate = formatter.format(date);
                        String sDay = null;
                        if (dayOfWeek == 7) {
                            sDay = sat;
                        } else if (dayOfWeek == 1) {
                            sDay = sun;
                        } else if (dayOfWeek == 2) {
                            sDay = mon;
                        } else if (dayOfWeek == 3) {
                            sDay = tue;
                        } else if (dayOfWeek == 4) {
                            sDay = wed;
                        } else if (dayOfWeek == 5) {
                            sDay = thu;
                        } else if (dayOfWeek == 6) {
                            sDay = fri;
                        }
                    %>
                    <td nowrap  >
                        <%
                            if (currentDate.equals(sDate)) {
                        %>
                        <font color="red">Today - </font><b><%=sTime%></b>
                            <%
                            } else {
                            %>
                        <font color="red"><%=sDay%> - </font><b><%=sDate + " " + sTime%></b>
                            <%
                                }
                            %>
                    </td>
                    <td>
                        <a href="JavaScript: deleteTask('<%=wbo.getAttribute("id")%>');"><b>حذف</b></a>
                    </td>
                </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>
    </BODY>
</HTML>     
