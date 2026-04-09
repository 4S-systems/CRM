<%@page import="com.crm.common.CRMConstants"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.maintenance.db_access.UnitDocMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String[] attributes = {"clientName", "mobile", "interPhone", "appointmentPlace", "userName", "appointmentDate", "currentStatusSince"};
        String[] titles = new String[8];
        int s = attributes.length;
        int t = s + 1;
        String attName = null;
        String attValue = null;
        ArrayList<WebBusinessObject> appointmentsList = (ArrayList<WebBusinessObject>) request.getAttribute("appointmentsList");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null, xAlign, fromDate, toDate, display, early;
        String dir = null;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
            titles[0] = "Client Name";
            titles[1] = "Client Mobile";
            titles[2] = "International";
            titles[3] = "Place";
            titles[4] = "Responsible";
            titles[5] = "Appointment Date";
            titles[6] = "Attendance Date";
            titles[7] = "Difference";
            fromDate = "From Date";
            toDate = "To Date";
            display = "Display Report";
            early = "Early";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
            titles[0] = "اسم العميل";
            titles[1] = "الموبايل";
            titles[2] = "الدولي";
            titles[3] = "المكان";
            titles[4] = "المسؤول";
            titles[5] = "تاريخ المقابلة";
            titles[6] = "تاريخ الحضور";
            titles[7] = "فرق الوصول";
            fromDate = "من تاريخ";
            toDate = "ألي تاريخ";
            display = "أعرض التقرير";
            early = "مبكر";
        }
    %>
    <HEAD>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>

        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript">
            var oTable;
            var users = new Array();
            var divID;
            $(document).ready(function () {
                oTable = $('#clients').dataTable({
                    "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    "order": [[0, "asc"]],
                    "columnDefs": [
                        {
                            "targets": 0,
                            "visible": false
                        }, {
                            "targets": [1, 2, 3, 4, 5, 6],
                            "orderable": false
                        }],
                    "drawCallback": function (settings) {
                        var api = this.api();
                        var rows = api.rows({page: 'current'}).nodes();
                        var last = null;
                        api.column(0, {page: 'current'}).data().each(function (group, i) {
                            if (last !== group) {
                                $(rows).eq(i).before(
                                        '<tr class="group"><td class="blueBorder blueBodyTD" style="font-size: 14px; background-color: lightgray;" colspan="2"><%=titles[0]%></td><td class="blueBorder blueBodyTD" style="font-size: 16px; color: #a41111;" colspan="3">'
                                        + group + '</td><td class="blueBorder blueBodyTD"></td></tr>'
                                        );
                                last = group;
                            }
                        });
                    }
                }).fadeIn(2000);
                $("#fromDate,#toDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
            });
        </script>
        <style type="text/css">

        </style>
    </HEAD>
    <body>
        <b style="float: <%=xAlign%>; font-size: 16px;color: #005599; font-style: oblique; margin-<%=xAlign%>: 80px;">My Successful Appointments Report تقرير مقابلاتي الناجحة</b>
        <fieldset align=center class="set" style="width: 95%">
            <form name="CLASSIFICATION_FORM" action="<%=context%>/ReportsServletThree?op=mySuccessAppointmentsReport" method="POST">
                <br/>
                <table class="blueBorder" align="center" dir="rtl" id="code" cellpadding="0" cellspacing="0" width="650" style="border-width: 1px; border-color: white; display: block;" >
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px">
                            <b><font size=3 color="white"> <%=fromDate%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px">
                            <b><font size=3 color="white"> <%=toDate%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle">
                            <input type="text" style="width:190px" id="fromDate" name="fromDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("fromDate") == null ? "" : request.getAttribute("fromDate")%>"/>
                        </td>
                        <td bgcolor="#dedede" valign="middle">
                            <input type="text" style="width:190px" id="toDate" name="toDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("toDate") == null ? "" : request.getAttribute("toDate")%>"/>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle" colspan="2">
                            <input type="submit" value="<%=display%>" class="button" style="margin: 10px;"/>
                        </td>
                    </tr>
                </table>
                <br/>
                <br/>
                <%
                    if (appointmentsList != null) {
                %>
                <div style="width: 75%; margin-left: auto; margin-right: auto; margin-bottom: 7px;">
                    <table align="<%=align%>" dir="<%=dir%>" id="clients" style="width:100%;">
                        <thead>
                            <tr>
                                <%
                                    for (int i = 0; i < t; i++) {
                                %>                
                                <th>
                                    <b><%=titles[i]%></b>
                                </th>
                                <%
                                    }
                                %>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                                Date attendanceDate, appointmentDate;
                                for (WebBusinessObject clientWbo : appointmentsList) {
                                    attendanceDate = null;
                                    appointmentDate = null;
                            %>
                            <tr>
                                <%
                                    for (int i = 0; i < s; i++) {
                                        attName = attributes[i];
                                        attValue = clientWbo.getAttribute(attName) != null ? ((String) clientWbo.getAttribute(attName)).trim() : "";
                                        if ((i == 5 || i == 6) && !attValue.isEmpty()) {
                                            attValue = attValue.substring(0, 16);
                                            if (i == 6) {
                                                attendanceDate = sdf.parse(attValue);
                                            } else {
                                                appointmentDate = sdf.parse(attValue);
                                            }
                                        }
                                %>
                                <td>
                                    <div>
                                        <b><%=attValue.equalsIgnoreCase("UL") ? "" : attValue%></b>
                                        <%
                                            if (i == 0) {
                                        %>
                                        <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=clientWbo.getAttribute("clientId")%>">
                                            <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"
                                                 onmouseover=""/>
                                        </a>
                                        <%
                                            }
                                        %>
                                    </div>
                                </td>
                                <%
                                    }
                                %>
                                <td>
                                    <div>
                                        <%
                                            if (attendanceDate != null && appointmentDate != null) {
                                                if (attendanceDate.after(appointmentDate)) {
                                        %>
                                        <b><%=(attendanceDate.getTime() - appointmentDate.getTime()) / (1000 * 60)%></b>
                                        <%
                                        } else {
                                        %>
                                        <b style="color: green;"><%=(appointmentDate.getTime() - attendanceDate.getTime()) / (1000 * 60)%></b> - <b><%=early%></b>
                                            <%
                                                    }
                                                }
                                            %>
                                    </div>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                <%
                    }
                %>
                <br/><br/>
            </form>
        </fieldset>
    </body>
</html>
