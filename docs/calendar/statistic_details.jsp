<%@page import="java.util.Vector"%>
<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.List"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>


<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String beginDate = request.getParameter("beginDate");
        String endDate = request.getParameter("endDate");
        String departmentID = request.getParameter("departmentID");
        String type = (String) request.getParameter("type");
        String campaignID = request.getParameter("campaignID");
        String projectID = request.getParameter("projectID");

        List<WebBusinessObject> appointments = (List) request.getAttribute("appointments");

        String jsonCallTypeText = (String) request.getAttribute("jsonCallTypeText");
        String jsonCallResultText = (String) request.getAttribute("jsonCallResultText");

        ArrayList<WebBusinessObject> callResult = (ArrayList) request.getAttribute("callResult") != null ? (ArrayList) request.getAttribute("callResult") : new ArrayList();
        ArrayList<WebBusinessObject> callType = (ArrayList) request.getAttribute("callType") != null ? (ArrayList) request.getAttribute("callType") : new ArrayList();

        String totalCallTypeCount = request.getAttribute("totalCallTypeCount") != null ? request.getAttribute("totalCallTypeCount").toString() : new String(); 
        String totalCallResultCount = request.getAttribute("totalCallResultCount") != null ? request.getAttribute("totalCallResultCount").toString() : new String(); 

        int iTotal = 0;

        String stat = "Ar";
        String dir = null;
        String PN, typeStr, ResultStr, CountStr;
        if (stat.equals("En")) {
            dir = "LTR";
            PN = "Calls No.";
            typeStr = "Call Type";
            CountStr = "Call Counts";
            ResultStr = "Result Type";
        } else {
            dir = "RTL";
            PN = "عدد المكالمات";
            typeStr = "نوع المكالمة";
            CountStr = "عدد المكالمات";
            ResultStr = "نوع النتيجة";
        }
        
        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        
        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
        
        ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wboPrev;
        for (int i = 0; i < groupPrev.size(); i++) {
            wboPrev = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wboPrev.getAttribute("prevCode"));
        }
    %>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <META HTTP-EQUIV="Expires" CONTENT="0"/>   

        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
        <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>

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
                    "aaSorting": [[2, "asc"]],                    
                            "columnDefs": [
                                {
                                    "targets": 2,
                                    "visible": false
                                }], "drawCallback": function (settings) {
                                var api = this.api();
                                var rows = api.rows({page: 'current'}).nodes();
                                var last = null;
                                var lastRow = null;
                                var index = 0;
                                var title;
                                api.column(2, {page: 'current'}).data().each(function (group, i) {
                                    if (last !== group) {
                                        title = group.split("/");
                                        lastRow = last;
                                        $(rows).eq(i).before(
                                            '<tr class="group"><td>'+(++index)+'</td><td class="blueBorder blueBodyTD" style="font-size: 16px; background-color: lightgray; color: #a41111; text-align: center" colspan="<%=type.equals("Answered") ? 3 : 2%>">اسم العميل </td> <td class="" style="font-size: 16px; text-align: right; padding-right: 10px;" colspan="2" > ' + title[0] + '</td></tr>'
                                        );
                                        last = group;
                                    }
                                    
                                });
                            }
                }).show();
                $(".dataTables_length, .dataTables_info").css("float", "left");
                $(".dataTables_filter, .dataTables_paginate").css("float", "right");
            });

            function exportToExcel() {
                var begin = $("#beginDate").val();
                var end = $("#endDate").val();
                var type = $("#type").val();
                var url = "<%=context%>/AppointmentServlet?op=getClientStatisticsExel&beginDate=" + begin + "&endDate=" + end + "&departmentID=" + <%=departmentID%> + "&campaignID=" + <%=campaignID%> + "&type=" + type + "&projectID=<%=projectID%>";
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=500, height=500");
            }
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
        <div style="width: 100%; text-align: center;"> <b> <font size="3" color="red"> <%=PN%> : <%=appointments.size()%> </font></b></div> 
        <br/>
        <div align="left" STYLE="color:blue; margin-left: 50px;display: none;">
            <input type="button"  value="عودة"  onclick="history.go(-1);" class="button"/>
        </div>

        <br/><br/>
    <CENTER>

        <input type="hidden" value="<%=beginDate%>" id="beginDate">
        <input type="hidden" value="<%=endDate%>" id="endDate">
        <input type="hidden" value="<%=type%>" id="type">
        <button type="button" STYLE="color: #000;font-size:15;margin-top: 20px;font-weight:bold; display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>;"
                onclick="exportToExcel()" title="Export to Excel">Excel<IMG HEIGHT="15" SRC="images/search.gif" />
        </button>
        <br/><br/>
        <div style="width: 90%">
            <table class="display" id="indextable" align="center" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0">
                <thead>
                    <tr>
                        <th></th>
                        <th>اسم الموظف</th>
                        <th>اسم العميل</th>
                        <th>تاريخ المكالمة</th>
                        <th>نوع المتابعة</th>
                            <%if (type.equals("Answered")) {%>
                        <th>نتيجة المكالمة</th>
                            <%}%>
                        <th>التعليق</th>
                    </tr>
                </thead> 

        <% if (appointments != null && !appointments.isEmpty()) {%>
                <tbody  id="planetData2">  
                    <%
                        for (WebBusinessObject wbo : appointments) {
                            iTotal++;

                    %>
                    <tr style="padding: 1px;">
                        <td style="border-width: 1px ; text-align: center">
                            <a target="_blank" href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("CLIENT_ID")%>">
                                <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"/>
                            </a>
                        </td>
                        <td style="border-width: 1px ; text-align: center">
                            <%=wbo.getAttribute("User_NAME")%>
                        </td>
                        <td style="border-width: 1px ; text-align: center">
                            <%=wbo.getAttribute("Client_NAME")%>/<%=wbo.getAttribute("CLIENT_ID")%>
                        </td>
                        <td style="border-width: 1px ; text-align: center" nowrap>
                            <%=wbo.getAttribute("AppointmentDate") != null && ((String) wbo.getAttribute("AppointmentDate")).length() > 16 ? ((String) wbo.getAttribute("AppointmentDate")).substring(0, 16) : wbo.getAttribute("AppointmentDate")%>
                        </td>
                        <td style="border-width: 1px ; text-align: center">
                            <%=wbo.getAttribute("appointmentType")%>
                        </td>
                        <%if (type.equals("Answered")) {%>
                        <td style="border-width: 1px ; text-align: center">
                            <%=wbo.getAttribute("callRes")%>
                        </td>
                        <%}%>
                        <td style="border-width: 1px ; text-align: center; background-color: #fff8b8;">
                            <%=wbo.getAttribute("comment")%>
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
        </div>
        <br/><br/>
    </body>
</html>
