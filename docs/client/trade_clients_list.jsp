<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
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
    WebBusinessObject tradeWbo = (WebBusinessObject) request.getAttribute("tradeWbo");
    Calendar c = Calendar.getInstance();
    String stat = "Ar";
    String dir = null, xAlign;
    String customerName, mobile, interPhone, source, registrationDate;
    String sat, sun, mon, tue, wed, thu, fri, PN, trade;
    String sDate, sTime = null;
    if (stat.equals("En")) {
        dir = "LTR";
        xAlign = "right";
        customerName = "Customer name";
        sat = "Sat";
        sun = "Sun";
        mon = "Mon";
        tue = "Tue";
        wed = "Wed";
        thu = "Thu";
        fri = "Fri";
        PN = "Clients No.";
        trade = "Job";
        mobile = "Mobile";
        interPhone = "Inter. Phone";
        source = "Source";
        registrationDate = "Reg. Date";
    } else {
        dir = "RTL";
        xAlign = "left";
        PN = "عدد العملاء";
        customerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";
        sat = "&#1575;&#1604;&#1587;&#1576;&#1578;";
        sun = "&#1575;&#1604;&#1575;&#1581;&#1583;";
        mon = "&#1575;&#1604;&#1575;&#1579;&#1606;&#1610;&#1606;";
        tue = "&#1575;&#1604;&#1579;&#1604;&#1575;&#1579;&#1575;&#1569;";
        wed = "&#1575;&#1604;&#1575;&#1585;&#1576;&#1593;&#1575;&#1569;";
        thu = "&#1575;&#1604;&#1582;&#1605;&#1610;&#1587;";
        fri = "&#1575;&#1604;&#1580;&#1605;&#1593;&#1577;";
        trade = "المهنة";
        mobile = "الموبايل";
        interPhone = "الرقم الدولي";
        source = "المصدر";
        registrationDate = "تاريخ التسجيل";
    }
%>
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="css/CSS.css"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery-ui-timepicker-addon.css"/>

        <script src='ChangeLang.js' type='text/javascript'></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
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
        <script language="JavaScript" type="text/javascript">
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
    </head>
    <body>
        <%
            if (data != null && !data.isEmpty()) {
        %>
        <div style="width: 100%; text-align: center;"> <b> <font size="3" color="red"> <%=PN%> : <%=data.size()%><br/><font size="3" color="blue"> <%=trade%> : <%=tradeWbo != null ? tradeWbo.getAttribute("tradeName") : ""%> </font></b></div> 
        <br/>
        <div style="width: 80%">
            <table class="display" id="indextable" align="center" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0">
                <thead>
                    <tr>
                        <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="4%"><b>#</b></th>
                        <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><img src="images/icons/client.png" width="20" height="20" /><b><%=customerName%></b></th>
                        <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="7%"><b><%=mobile%></b></th>
                        <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="7%"><b><%=interPhone%></b></th>
                        <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="8%"><b><%=source%></b></th>
                        <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><b><%=registrationDate%></b></th>
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
                            if (wbo.getAttribute("mobile") != null && !((String) wbo.getAttribute("mobile")).equalsIgnoreCase("UL")
                                    && !((String) wbo.getAttribute("mobile")).trim().isEmpty()) {
                                num = (String) wbo.getAttribute("mobile");
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
                        <td nowrap>
                            <%if (wbo.getAttribute("name") != null) {%>
                            <a href="<%=href%>"><b title="<%=clientDescription%>" style="cursor: hand;"><%=wbo.getAttribute("name")%></b>
                                <img src="images/icons/history.png" width="30" style="float: <%=xAlign%>"/>
                            </a>
                            <%}%>
                        </td>
                        <td>
                            <%if (wbo.getAttribute("mobile") != null && !((String) wbo.getAttribute("mobile")).equalsIgnoreCase("UL")) {%>
                            <b><%=wbo.getAttribute("mobile")%></b>
                            <%}%>
                        </td>
                        <td>
                            <%if (wbo.getAttribute("interPhone") != null) {%>
                            <b><%=wbo.getAttribute("interPhone")%></b>
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
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
        <br/>
        <br/>
    </body>
</html>     
