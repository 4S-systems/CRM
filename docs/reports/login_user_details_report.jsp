<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.List"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
        WebBusinessObject userWbo = (WebBusinessObject) request.getAttribute("userWbo");
        WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");
        Calendar cal = Calendar.getInstance();
        String jDateFormat = user.getAttribute("javaDateFormat").toString();
        SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
        String fromDateVal = (String) request.getAttribute("fromDate");
        String toDateVal = (String) request.getAttribute("toDate");
        String groupID = request.getAttribute("groupID") != null ? (String) request.getAttribute("groupID") : "";
        String userID = request.getAttribute("userID") != null ? (String) request.getAttribute("userID") : "";

        if (toDateVal == null || toDateVal.isEmpty()) {
            toDateVal = sdf.format(cal.getTime());
        }
        if (fromDateVal == null || fromDateVal.isEmpty()) {
            cal.add(Calendar.MONTH, -1);
            fromDateVal = sdf.format(cal.getTime());
        }
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir, style, title, fromDate, toDate, back, date, noOfEntry, activities;
        if (stat.equals("En")) {
            align = "center";
            dir = "ltr";
            style = "text-align:left";
            title = "Attendance Details Report for ";
            fromDate = "From Date";
            toDate = "To Date";
            back = "Back";
            date = "Date";
            noOfEntry = "No. of Entry";
            activities = "Activities";
        } else {
            align = "center";
            dir = "rtl";
            style = "text-align:Right";
            title = "تقرير تفصيلي لحضور ";
            fromDate = "من تاريخ";
            toDate = "الى تاريخ";
            back = "عودة";
            date = "التاريخ";
            noOfEntry = "عدد مرات الدخول";
            activities = "الأنشطة";
        }
    %>
    <head> 
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript">
        </script>
        <style>
        </style>
    </head>
    <body>
        <form name="USER_ATTENDANCE_FORM" method="post">
            <div align="left" style="color:blue; margin-left: 50px;">
                <input type="button" value="<%=back%>" onclick="history.go(-1);" class="button"/>
            </div>
            <br/>
            <fieldset class="set" style="width:85%;border-color: #006699">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4"><%=title%><%=userWbo != null ? userWbo.getAttribute("fullName") : ""%></font>
                        </td>
                    </tr>
                </table>
                <br/>
                <table align="center" dir="<%=dir%>" width="40%" cellspacing="2" cellpadding="1">
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white"><%=fromDate%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b> <font size=3 color="white"><%=toDate%></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" valign="middle">
                            <b><%=fromDateVal%></b> 
                            <br/><br/>
                        </td>
                        <td bgcolor="#dedede" style="text-align:center" valign="middle">
                            <b><%=toDateVal%></b> 
                            <br/><br/>
                        </td>
                    </tr>
                </table>
                <br/>
                <div style="width: 40%; margin-left: auto; margin-right: auto;">
                    <table class="blueBorder" id="clients" align="center" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0">
                        <tr>
                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; color:white; font-size:14px"><b>#</b></td>
                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; color:white; font-size:14px"><b><%=date%></b></td>
                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; color:white; font-size:14px"><b>&nbsp;</b></td>
                        </tr>
                        <%
                            int index = 0, rowCount = 0;
                            String tempDate = "";
                            String[] dateTimeArr;
                            for (WebBusinessObject wbo : data) {
                                dateTimeArr = ((String) wbo.getAttribute("loginTime")).replaceAll("-", "/").split(" ");
                                if (tempDate.equals(dateTimeArr[0])) {
                                    rowCount++;
                        %>
                        <tr>
                            <td colspan="2"></td>
                            <td><%=dateTimeArr[1].substring(0, 8)%></td>
                        </tr>
                        <%
                        } else {
                            tempDate = dateTimeArr[0];
                            index++;
                            if (rowCount > 0) {
                        %>
                        <tr>
                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; color:white; font-size:14px"><b></b></td>
                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; color:white; font-size:14px"><b><%=noOfEntry%></b></td>
                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; color:white; font-size:14px"><b><%=rowCount%></b></td>
                        </tr>
                        <tr>
                            <td colspan="3" style="border-right: 0px; border-left: 0px; height: 3px;">&nbsp;</td>
                        </tr>
                        <%
                            }
                        %>
                        <tr>
                            <td style="text-align:center" bgcolor="#dedede" valign="middle"><%=index%></td>
                            <td style="text-align:center" bgcolor="#dedede" valign="middle"><%=tempDate%></td>
                            <td style="text-align:center" bgcolor="#dedede" valign="middle">
                                <a href="<%=context%>/ReportsServletThree?op=consolidatedActivitiesReport&fromDate=<%=tempDate%>&createdBy=<%=userID%>"><%=activities%> <img src="images/icons/activity.png" width="22px" height="22px"/></a>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2"></td>
                            <td><%=dateTimeArr[1].substring(0, 8)%></td>
                        </tr>
                        <%
                                    rowCount = 1;
                                }
                            }
                        %>
                    </table>
                    <br/>
                    <br/>
                </div>
            </fieldset>
        </form>
    </body>
</html>
