<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>

<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String beginDate = (String) request.getParameter("beginDate");
        String endDate = (String) request.getParameter("endDate");
        String userName = (String) request.getParameter("userName");

        ArrayList<WebBusinessObject> callResult = (ArrayList) request.getAttribute("data");

        int iTotal = 0;

        String stat = "Ar";
        String dir = null;

        if (stat.equals("En")) {
            dir = "LTR";
        } else {
            dir = "RTL";
        }
    %>

    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <META HTTP-EQUIV="Expires" CONTENT="0"/>   

        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <SCRIPT type="text/javascript" src="js/json2.js"></SCRIPT>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
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
    </head>

    <body>
        <div align="left" STYLE="color:blue; margin-left: 50px;">
            <input type="button"  value="عودة"  onclick="history.go(-1);" class="button"/>
        </div>

        <br/><br/>

        <div style="width: 100%; text-align: center; direction: rtl">
            <font size="3">مكالمات الموظف : </font><b><font size="3" color="red"><%=userName%></font></b>
            <br>
            <br>
            <font size="3"> في الفترة من </font><b><font size="3" color="red"><%=beginDate%></font></b><font size="3">الى  </font><b><font size="3" color="red"><%=endDate%></font></b>
        </div> 
        <br/>
        <br/>

        <% if (callResult != null && !callResult.isEmpty()) {%>
        <div style="width: 90%">
            <table class="display" id="indextable" align="center" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0">
                <thead>
                    <tr>
                        <th CLASS="blueHeaderTD backgroundTable"style="width: 1%; border-width: 0px ;text-align: center">م</th>
                        <th CLASS="blueHeaderTD backgroundTable"style="width: 1%; border-width: 0px ;text-align: center"></th>
                        <th CLASS="blueHeaderTD backgroundTable"style="width: 15%; border-width: 0px ;text-align: center">اسم العميل</th>
                        <th CLASS="blueHeaderTD backgroundTable"style="width: 11%; border-width: 0px ;text-align: center">تاريخ المكالمة</th>
                        <th CLASS="blueHeaderTD backgroundTable"style="width: 10%; border-width: 0px ;text-align: center">نتيجة المكالمة</th>
                        <th CLASS="blueHeaderTD backgroundTable"style="width: 3%; border-width: 0px ;text-align: center">م. ح.</th>
                        <th CLASS="blueHeaderTD backgroundTable"style="width: 37%; border-width: 0px ;text-align: center">التعليق</th>
                    </tr>
                </thead> 

                <tbody  id="planetData2">  
                    <%
                        for (WebBusinessObject wbo : callResult) {
                            iTotal++;
                    %>
                    <tr style="padding: 1px;">
                        <td style="border-width: 1px ; text-align: center">
                            <%=iTotal%>
                        </td>
                        <td style="border-width: 1px ; text-align: center">
                            <a target="_blank" href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("CLIENT_ID")%>">
                                <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"/>
                            </a>
                        </td>
                        <td style="border-width: 1px ; text-align: center">
                            <%=wbo.getAttribute("Client_NAME")%>
                        </td>
                        <td style="border-width: 1px ; text-align: center">
                            <%=wbo.getAttribute("AppointmentDate")%>
                        </td>
                        <td style="border-width: 1px ; text-align: center">
                            <%=wbo.getAttribute("callRes")%>
                        </td>
                        <td style="border-width: 1px ; text-align: center">
                            <%=wbo.getAttribute("callDuration")%>
                        </td>
                        <td style="border-width: 1px ; text-align: center; background-color: #EBB462;">
                            <%=wbo.getAttribute("comment")%>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
        <%}%>
        <br/><br/>
    </body>
</html>