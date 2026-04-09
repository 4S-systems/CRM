<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="java.util.List"%>
<%@page import="com.tracker.db_access.CampaignMgr"%>
<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page import="com.silkworm.common.SecurityUser"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    int iTotal = 0;
    ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
    Calendar c = Calendar.getInstance();
    SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
    String defaultCampaign = "";
    if (securityUser != null && securityUser.getDefaultCampaign() != null && !securityUser.getDefaultCampaign().isEmpty()) {
        defaultCampaign = securityUser.getDefaultCampaign();
        CampaignMgr campaignMgr = CampaignMgr.getInstance();
        WebBusinessObject campaignWbo = campaignMgr.getOnSingleKey(defaultCampaign);
        if (campaignWbo != null) {
            defaultCampaign = (String) campaignWbo.getAttribute("campaignTitle");
        } else {
            defaultCampaign = "";
        }
    }
    String stat = "Ar";
    String dir = null;
    String customerName;
    String sat, sun, mon, tue, wed, thu, fri, PN;
    String sDate, sTime = null;
    if (stat.equals("En")) {
        dir = "LTR";
        customerName = "Customer name";
        sat = "Sat";
        sun = "Sun";
        mon = "Mon";
        tue = "Tue";
        wed = "Wed";
        thu = "Thu";
        fri = "Fri";
        PN = "Requests No.";
    } else {
        dir = "RTL";
        PN = "عدد الطلبات";
        customerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";
        sat = "&#1575;&#1604;&#1587;&#1576;&#1578;";
        sun = "&#1575;&#1604;&#1575;&#1581;&#1583;";
        mon = "&#1575;&#1604;&#1575;&#1579;&#1606;&#1610;&#1606;";
        tue = "&#1575;&#1604;&#1579;&#1604;&#1575;&#1579;&#1575;&#1569;";
        wed = "&#1575;&#1604;&#1575;&#1585;&#1576;&#1593;&#1575;&#1569;";
        thu = "&#1575;&#1604;&#1582;&#1605;&#1610;&#1587;";
        fri = "&#1575;&#1604;&#1580;&#1605;&#1593;&#1577;";
    }
%>
<html>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <META HTTP-EQUIV="Expires" CONTENT="0"/>   

        <LINK REL="stylesheet" type="text/css" href="css/CSS.css"/>
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
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery-ui-timepicker-addon.css"/>

        <SCRIPT LANGUAGE="JavaScript" type="text/javascript">
            $(document).ready(function () {
                $('#indextable').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[20, 40, 70, 100, -1], [20, 40, 70, 100, "All"]],
                    iDisplayLength: 20,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[0, "asc"]]
                }).show();
                $(".dataTables_length, .dataTables_info").css("float", "left");
                $(".dataTables_filter, .dataTables_paginate").css("float", "right");
            });
        </script>
        <style>
            .login {
                direction: rtl;
                margin: 20px auto;
                padding: 10px 5px;
                background: #3f65b7;
                background-clip: padding-box;
                border: 1px solid #ffffff;
                border-bottom-color: #ffffff;
                border-radius: 5px;
                color: #ffffff;

                background: #7abcff; /* Old browsers */
                /* IE9 SVG, needs conditional override of 'filter' to 'none' */
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
            }
            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
                margin-bottom: 30px;
            }
            .titleRow {
                background-color: orange;
            }
            .login  h1 {
                font-size: 16px;
                font-weight: bold;
                padding-top: 10px;
                padding-bottom: 10px;
                text-shadow: 0 -1px rgba(0, 0, 0, 0.4);
                text-align: center;
                width: 96%;
                margin-left: auto;
                margin-right: auto;
                text-height: 30px;
                color: black;
                text-shadow: 0 1px rgba(255, 255, 255, 0.3);
                background: #FFBB00;
                /*background: #cc0000;*/
                background-clip: padding-box;
                border: 1px solid #284473;
                border-bottom-color: #223b66;
                border-radius: 4px;
                cursor: pointer;
            }
            .num{background: #ffc578; /* Old browsers */
                 background: -moz-linear-gradient(top,  #ffc578 0%, #fb9d23 100%); /* FF3.6+ */
                 background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#ffc578), color-stop(100%,#fb9d23)); /* Chrome,Safari4+ */
                 background: -webkit-linear-gradient(top,  #ffc578 0%,#fb9d23 100%); /* Chrome10+,Safari5.1+ */
                 background: -o-linear-gradient(top,  #ffc578 0%,#fb9d23 100%); /* Opera 11.10+ */
                 background: -ms-linear-gradient(top,  #ffc578 0%,#fb9d23 100%); /* IE10+ */
                 background: linear-gradient(to bottom,  #ffc578 0%,#fb9d23 100%); /* W3C */
                 filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ffc578', endColorstr='#fb9d23',GradientType=0 ); /* IE6-9 */
                 font-weight: bold
            }
        </style>
    </head>
    <body>
        <% if (data != null && !data.isEmpty()) {%>
        <div style="width: 100%; text-align: center;"> <b> <font size="3" color="red"> <%=PN%> : <%=data.size()%> </font></b></div> 
        <br/>
        <div align="left" STYLE="color:blue; margin-left: 50px;">
            <input type="button"  value="عودة"  onclick="history.go(-1);" class="button"/>
        </div>
        <br/><br/>
        <div style="width: 80%">
            <table class="display" id="indextable" align="center" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0">
                <thead>
                    <tr>
                        <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="4%"><b>#</b></th>
                        <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><b>رقم الطلب</b></th>
                        <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><img src="images/icons/client.png" width="20" height="20" /><b> <%=customerName%></b></th>
                        <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="7%"><b>رقم التليفون</b></th>
                        <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="7%"><b>الموبايل</b></th>
                        <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="7%"><b>الرقم الطالب</b></th>
                        <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="7%"><b>الرقم الدولي</b></th>
                        <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="8%"><b>المسؤول</b></th>
                        <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="8%"><b>المصدر</b></th>
                        <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><b>تاريخ الطلب</b></th>
                        <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><b>تقييم العميل</b></th>
                    </tr>
                </thead> 
                <tbody  id="planetData2">  
                    <%
                        String clientDescription, num = "", href;
                        for (WebBusinessObject wbo : data) {
                            iTotal++;
                            clientDescription = (String) wbo.getAttribute("description");
                            if (clientDescription == null || clientDescription.equalsIgnoreCase("UL")) {
                                clientDescription = "";
                            }
                            if (wbo.getAttribute("phone") != null && !((String) wbo.getAttribute("phone")).equalsIgnoreCase("UL")
                                    && !((String) wbo.getAttribute("phone")).trim().isEmpty()) {
                                num = (String) wbo.getAttribute("phone");
                            } else if (wbo.getAttribute("mobile") != null && !((String) wbo.getAttribute("mobile")).equalsIgnoreCase("UL")
                                    && !((String) wbo.getAttribute("mobile")).trim().isEmpty()) {
                                num = (String) wbo.getAttribute("mobile");
                            } else if (wbo.getAttribute("option3") != null && !((String) wbo.getAttribute("option3")).equalsIgnoreCase("UL")
                                    && !((String) wbo.getAttribute("option3")).trim().isEmpty()) {
                                num = (String) wbo.getAttribute("option3");
                            } else {
                                num = (String) wbo.getAttribute("interPhone");
                            }
                            if (num == null || num.isEmpty()) {
                                href = "JavaScript: alert('لا يمكن تفاصيل عميل ليس له رقم تليفون واحد علي اﻷقل')";
                            } else {
                                href = context + "/ClientServlet?op=showClientHistory&amp;num=" + num;
                            }
                    %>
                    <tr style="padding: 1px;">
                        <td>
                            <%=iTotal%>
                        </td>
                        <td>
                            <b style="cursor: hand;"><%=wbo.getAttribute("businessID")%></b>
                        </td>
                        <td>
                            <%if (wbo.getAttribute("name") != null) {%>
                            <a href="<%=href%>"><b title="<%=clientDescription%>" style="cursor: hand"><%=wbo.getAttribute("name")%></b></a>
                                <%}%>
                        </td>
                        <td>
                            <%if (wbo.getAttribute("phone") != null && !((String) wbo.getAttribute("phone")).equalsIgnoreCase("UL")) {%>
                            <b><%=wbo.getAttribute("phone")%></b>
                            <%}%>
                        </td>
                        <td>
                            <%if (wbo.getAttribute("mobile") != null && !((String) wbo.getAttribute("mobile")).equalsIgnoreCase("UL")) {%>
                            <b><%=wbo.getAttribute("mobile")%></b>
                            <%}%>
                        </td>
                        <td>
                            <%if (wbo.getAttribute("option3") != null && !((String) wbo.getAttribute("option3")).equalsIgnoreCase("UL")) {%>
                            <b><%=wbo.getAttribute("option3")%></b>
                            <%}%>
                        </td>
                        <td>
                            <%if (wbo.getAttribute("interPhone") != null && !wbo.getAttribute("interPhone").equals("UL")) {%>
                            <b><%=wbo.getAttribute("interPhone")%></b>
                            <%}%>
                        </td>
                        <td>
                            <%if (wbo.getAttribute("currentOwnerName") != null) {%>
                            <b><%=wbo.getAttribute("currentOwnerName")%></b>
                            <%}%>
                        </td>
                        <td>
                            <%if (wbo.getAttribute("createdByName") != null) {%>
                            <b><%=wbo.getAttribute("createdByName")%></b>
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
                        <%if (currentDate.equals(sDate)) {%>
                        <td nowrap  ><font color="red">Today - </font><b><%=sTime%></b></td>
                                <%} else {%>
                        <td nowrap  ><font color="red"><%=sDay%> - </font><b><%=sDate + " " + sTime%></b></td>
                                <%}%>
                        <td>
                            <b><%=wbo.getAttribute("clientRate") != null ? wbo.getAttribute("clientRate") : "Not Rated"%></b>
                        </td>
                    </tr>
                    <%
                        }
                    } else if (data != null && data.isEmpty()) {
                    %>
                    <tr style="padding: 1px;">
                        <td>
                            <b style="color: red; font-size: x-large;">لا يوجد نتائج للبحث</b>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
        <input type="hidden" id="clientId" value="1"/>
    </body>
</html>     
