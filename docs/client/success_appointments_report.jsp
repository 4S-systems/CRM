<%@page import="org.json.simple.JSONValue"%>
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
        String[] attributes = {"clientName", "mobile", "interPhone", "appointmentPlace", "userName", "appointmentDate", "currentStatusSince", "statusName", "createdByName", "comChannel"};
        String[] titles = new String[11];
        int s = attributes.length;
        int t = s + 1;
        String attName = null;
        String attValue = null;
        ArrayList<WebBusinessObject> appointmentsList = (ArrayList<WebBusinessObject>) request.getAttribute("appointmentsList");
        ArrayList<WebBusinessObject> campaignsList = (ArrayList<WebBusinessObject>) request.getAttribute("campaignsList");
        ArrayList<WebBusinessObject> campaignClientTotalList = (ArrayList<WebBusinessObject>) request.getAttribute("campaignClientTotalList");
        String campaignID = request.getAttribute("campaignID") != null ? (String) request.getAttribute("campaignID") : "";
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null, xAlign, fromDate, toDate, display, early, campaign, allCampaigns;
        String dir = null;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
            titles[0] = "Client Name";
            titles[1] = "Client Mobile";
            titles[2] = "International";
            titles[3] = "Place";
            titles[4] = "Employee Who Manage the Meeting";
            titles[5] = "Appointment Date";
            titles[6] = "Attendance Date";
            titles[7] = "Status";
            titles[8] = "Source";
            titles[9] = "Communication Channel";
            titles[10] = "Difference";
            fromDate = "From Date";
            toDate = "To Date";
            display = "Display Report";
            early = "Early";
            campaign = "Campaign";
            allCampaigns = "All Campaigns";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
            titles[0] = "اسم العميل";
            titles[1] = "الموبايل";
            titles[2] = "الدولي";
            titles[3] = "المكان";
            titles[4] = "الموظف القائم بالزيارة";
            titles[5] = "تاريخ الزيارة";
            titles[6] = "تاريخ الحضور";
            titles[7] = "حالة العميل";
            titles[8] = "المصدر";
            titles[9] = "عرفتنا عن طريق";
            titles[10] = "فرق الوصول";
            fromDate = "من تاريخ";
            toDate = "ألي تاريخ";
            display = "أعرض التقرير";
            early = "مبكر";
            campaign = "الحملة";
            allCampaigns = "كل الحملات";
        }
        Map<String, Integer> clientSources = new HashMap<>();
        Map<String, Integer> appointmentSources = new HashMap<>();
        Map<String, Integer> channels = new HashMap<>();
    %>
    <HEAD>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>

        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" src="js/highcharts-4.2.4.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
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
                            "targets": [1, 2, 3, 4, 5, 6, 7, 8],
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
                                        + group + '</td><td class="blueBorder blueBodyTD" colspan="3"></td></tr>'
                                        );
                                last = group;
                            }
                        });
                    }
                }).fadeIn(2000);
                $('#clientSources,#appointmentSources,#channels').dataTable({
                    "bJQueryUI": true,
                    "destroy": true,
                    searching: false,
                    paging: false,
                    info: false
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
        <b style="float: <%=xAlign%>; font-size: 16px;color: #005599; font-style: oblique; margin-<%=xAlign%>: 80px;">Successful Appointments Report تقرير الزيارات الناجحة</b>
        <fieldset align=center class="set" style="width: 95%">
            <form name="CLASSIFICATION_FORM" action="<%=context%>/ReportsServletThree?op=successAppointmentsReport" method="POST">
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
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                            <b><font size="3" color="white"><%=campaign%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle" colspan="2">
                            <select name="campaignID" id="campaignID" style="width: 300px;" class="chosen-select-campaign" multiple>
                                <%
                                    for (WebBusinessObject campaignWbo : campaignsList) {
                                %>
                                <option value="<%=campaignWbo.getAttribute("id")%>" <%=campaignID.contains((String) campaignWbo.getAttribute("id")) ? "selected" : ""%>><%=campaignWbo.getAttribute("campaignTitle")%></option>
                                <%
                                    }
                                %>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle" colspan="2">
                            <input type="submit" value="<%=display%>" class="button" style="margin: 10px;"/>
                        </td>
                    </tr>
                </table>
                <br/>
                <%
                    if (appointmentsList != null) {
                        for (WebBusinessObject clientWbo : appointmentsList) {
                            if (clientWbo.getAttribute("createdByName") != null) {
                                if (clientSources.containsKey((String) clientWbo.getAttribute("createdByName"))) {
                                    clientSources.put((String) clientWbo.getAttribute("createdByName"), clientSources.get((String) clientWbo.getAttribute("createdByName")) + 1);
                                } else {
                                    clientSources.put((String) clientWbo.getAttribute("createdByName"), 1);
                                }
                            }
                            if (clientWbo.getAttribute("userName") != null) {
                                if (appointmentSources.containsKey((String) clientWbo.getAttribute("userName"))) {
                                    appointmentSources.put((String) clientWbo.getAttribute("userName"), appointmentSources.get((String) clientWbo.getAttribute("userName")) + 1);
                                } else {
                                    appointmentSources.put((String) clientWbo.getAttribute("userName"), 1);
                                }
                            }
                            if (clientWbo.getAttribute("comChannel") != null) {
                                if (channels.containsKey((String) clientWbo.getAttribute("comChannel"))) {
                                    channels.put((String) clientWbo.getAttribute("comChannel"), channels.get((String) clientWbo.getAttribute("comChannel")) + 1);
                                } else {
                                    channels.put((String) clientWbo.getAttribute("comChannel"), 1);
                                }
                            }
                        }

                        ArrayList clientsource_graphResultList = new ArrayList();
                        ArrayList empNames = new ArrayList();

                        for (String key : clientSources.keySet()) {
                            Map<String, Object> clientsource_graphDataMap = new HashMap<String, Object>();
                            empNames.add(key);
                            clientsource_graphDataMap.put("name", key);
                            clientsource_graphDataMap.put("y", clientSources.get(key));

                            clientsource_graphResultList.add(clientsource_graphDataMap);
                        }

                        String empNamesList = JSONValue.toJSONString(empNames);
                        String resultsJson = JSONValue.toJSONString(clientsource_graphResultList);

                        ArrayList appointmentSources_graphResultList = new ArrayList();
                        ArrayList empAppNames = new ArrayList();

                        for (String key : appointmentSources.keySet()) {
                            Map<String, Object> appointmentSources_graphDataMap = new HashMap<String, Object>();
                            empAppNames.add(key);
                            appointmentSources_graphDataMap.put("name", key);
                            appointmentSources_graphDataMap.put("y", appointmentSources.get(key));

                            appointmentSources_graphResultList.add(appointmentSources_graphDataMap);
                        }

                        String appointmentSourcesResultsJson = JSONValue.toJSONString(appointmentSources_graphResultList);
                        String empAppNamesList = JSONValue.toJSONString(empAppNames);

                        ArrayList channels_graphResultList = new ArrayList();
                        ArrayList channelsList = new ArrayList();

                        for (String key : channels.keySet()) {
                            Map<String, Object> channels_graphDataMap = new HashMap<String, Object>();
                            channelsList.add(key);
                            channels_graphDataMap.put("name", key);
                            channels_graphDataMap.put("y", channels.get(key));

                            channels_graphResultList.add(channels_graphDataMap);
                        }

                        String channelsJsonList = JSONValue.toJSONString(channelsList);
                        String channelsResultsJson = JSONValue.toJSONString(channels_graphResultList);
                %>
                <table cellpadding="5" cellspacing="10" style="width: 90%; margin-left: auto; margin-right: auto;">
                    <tr>
                        <td class="blueBorder blueHeaderTD" colspan="3">
                            <b><font size=3 color="white">Summary (Total Visits in Period <%=appointmentsList.size()%>)</font></b>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD">
                            <b><font size=3 color="white">Client Source</font></b>
                        </td>
                        <td class="blueBorder blueHeaderTD">
                            <b><font size=3 color="white">Appointment Source</font></b>
                        </td>
                        <td class="blueBorder blueHeaderTD">
                            <b><font size=3 color="white">Channel</font></b>
                        </td>
                        <!--td class="blueBorder blueHeaderTD">
                            <b><font size=3 color="white">Campaign Statistics</font></b>
                        </td-->
                    </tr>
                    <tr>
                        <td class="td" style="width: 450px; vertical-align: top;">
                            <table id="clientSources">
                                <thead>
                                    <tr>
                                        <th>Client Source</th>
                                        <th>Count</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        for (String key : clientSources.keySet()) {
                                    %>
                                    <tr>
                                        <td><%=key%></td>
                                        <td><%=clientSources.get(key)%></td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                        </td>
                        <td class="td" style="width: 450px; vertical-align: top;">
                            <table id="appointmentSources">
                                <thead>
                                    <tr>
                                        <th>Appointment Source</th>
                                        <th>Count</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        for (String key : appointmentSources.keySet()) {
                                    %>
                                    <tr>
                                        <td><%=key%></td>
                                        <td><%=appointmentSources.get(key)%></td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                        </td>
                        <td class="td" style="width: 450px; vertical-align: top;">
                            <table id="channels">
                                <thead>
                                    <tr>
                                        <th>Channels</th>
                                        <th>Count</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        for (String key : channels.keySet()) {
                                    %>
                                    <tr>
                                        <td><%=key.isEmpty() ? "No Channel" : key%></td>
                                        <td><%=channels.get(key)%></td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                        </td>
                        <!--td class="td" style="width: 450px; vertical-align: top;">
                            <table id="channels">
                                <thead>
                                    <tr>
                                        <th>Campaign</th>
                                        <th>Count</th>
                                    </tr>
                                </thead>
                                <tbody>
                        <%
                            if (campaignClientTotalList != null && campaignClientTotalList.size() > 0) {
                                for (WebBusinessObject campaignWbo : campaignClientTotalList) {
                        %>
                        <tr>
                            <td><%=campaignWbo.getAttribute("campaignTitle")%></td>
                            <td><%=campaignWbo.getAttribute("totalClient")%></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
            </td-->
                    </tr>

                    <tr>
                        <td class="td" style="width: 450px; vertical-align: top;">
                            <div id="container1">
                                <script>
                                    var chart1 = new Highcharts.Chart({
                                        chart: {
                                            renderTo: 'container1',
                                            type: 'column'
                                        },
                                        title: {
                                            text: 'Client Source'
                                        },
                                        xAxis: {
                                            categories: <%=empNamesList%>,
                                            labels: {
                                                rotation: -45}
                                        },
                                        yAxis: {
                                            min: 1,
                                            title: {
                                                text: 'عدد العملاء'
                                            }
                                        },
                                        tooltip: {
                                            headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                                            pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                                                    '<td style="padding:0"><b>{point.y:.1f}</b></td></tr>',
                                            footerFormat: '</table>',
                                            shared: true,
                                            useHTML: true
                                        },
                                        plotOptions: {
                                            column: {
                                                pointPadding: 0.2,
                                                borderWidth: 0
                                            }
                                        },
                                        series: [{"name": "Employees",
                                                "colorByPoint": true,
                                                "data": <%=resultsJson%>}]
                                    });
                                </script>
                            </div>
                        </td>
                        <td class="td" style="width: 450px; vertical-align: top;">
                            <div id="container2">
                                <script>
                                    var chart2 = new Highcharts.Chart({
                                        chart: {
                                            renderTo: 'container2',
                                            type: 'column'
                                        },
                                        title: {
                                            text: 'Appointment Source'
                                        },
                                        xAxis: {
                                            categories: <%=empAppNamesList%>,
                                            labels: {
                                                rotation: -45}
                                        },
                                        yAxis: {
                                            min: 1,
                                            title: {
                                                text: 'عدد العملاء'
                                            }
                                        },
                                        tooltip: {
                                            headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                                            pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                                                    '<td style="padding:0"><b>{point.y:.1f}</b></td></tr>',
                                            footerFormat: '</table>',
                                            shared: true,
                                            useHTML: true
                                        },
                                        plotOptions: {
                                            column: {
                                                pointPadding: 0.2,
                                                borderWidth: 0
                                            }
                                        },
                                        series: [{"name": "Employees",
                                                "colorByPoint": true,
                                                "data": <%=appointmentSourcesResultsJson%>}]
                                    });
                                </script>
                            </div>
                        </td>
                        <td class="td" style="width: 450px; vertical-align: top;">
                            <div id="container3">
                                <script>
                                    var chart3 = new Highcharts.Chart({
                                        chart: {
                                            renderTo: 'container3',
                                            type: 'column'
                                        },
                                        title: {
                                            text: 'Channel'
                                        },
                                        xAxis: {
                                            categories: <%=channelsJsonList%>,
                                            labels: {
                                                rotation: -45}
                                        },
                                        yAxis: {
                                            min: 1,
                                            title: {
                                                text: 'عدد العملاء'
                                            }
                                        },
                                        tooltip: {
                                            headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                                            pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                                                    '<td style="padding:0"><b>{point.y:.1f}</b></td></tr>',
                                            footerFormat: '</table>',
                                            shared: true,
                                            useHTML: true
                                        },
                                        plotOptions: {
                                            column: {
                                                pointPadding: 0.2,
                                                borderWidth: 0
                                            }
                                        },
                                        series: [{"name": "Channels",
                                                "colorByPoint": true,
                                                "data": <%=channelsResultsJson%>}]
                                    });
                                </script>
                            </div>
                        </td>
                    </tr>
                </table>
                <%
                    }
                %>
                <br/>
                <%
//                    if (campaignClientTotalList != null && campaignClientTotalList.size() > 0) {
                %>
                <!--                <TABLE ALIGN="center" dir="left" WIDTH="80%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4">
                                    <tr>
                                        <td style="width:60%">
                                            <div id="container" style="width: 80%; height: 400px; margin: 0 auto"></div>
                                            <script language="JavaScript">
                                                $(document).ready(function () {
                                                    chart = new Highcharts.Chart({
                                                        chart: {
                                                            renderTo: 'container',
                                                            plotBackgroundColor: null,
                                                            plotBorderWidth: null,
                                                            plotShadow: false
                                                        },
                                                        title: {
                                                            text: 'Campaign Statistics'
                                                        },
                                                        xAxis: {
                                                            categories: ['Campaign']
                                                        },
                                                        yAxis: {
                                                            categories: ['Clients']
                                                        },
                                                        labels: {
                                                            items: [{
                                                                    style: {
                                                                        left: '0px',
                                                                        top: '0px',
                                                                        color: (Highcharts.theme && Highcharts.theme.textColor) || 'black'
                                                                    }}]
                                                        },
                                                        series: [
                <!--%
                    for (WebBusinessObject campaignWbo : campaignClientTotalList) {

                %>
                            {type: 'column',
                                name: '<!%=campaignWbo.getAttribute("campaignTitle")%>',
                                data: [<!%=campaignWbo.getAttribute("totalClient")%>]
                            }<!%=campaignClientTotalList.indexOf(campaignWbo) < campaignClientTotalList.size() - 1 ? "," : ""%>
                <!%
                    }
                %>
                        ]
                    });
                });
            </script>
        </td>
    </tr>
</table>-->
                <%//                    }
                %>
                <br/>
                <%                    if (appointmentsList != null) {
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
                                <th>
                                    &nbsp;
                                </th>
                                <th>
                                    &nbsp;
                                </th>
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
                                <td>
                                    <a target="blank" href="<%=context%>/AppointmentServlet?op=getClientsViewsInSpecificDay&clientId=<%=clientWbo.getAttribute("clientId")%>&date=<%=((String) clientWbo.getAttribute("currentStatusSince")).substring(0, 10)%>">
                                        <img src="images/icons/cart.png" width="30" style="float: left;" title="إظهار معاينات العميل">
                                    </a>
                                </td>
                                <td>
                                    <a target="blank" href="<%=context%>/AppointmentServlet?op=getClientsPaymentPlansInSpecificDay&clientId=<%=clientWbo.getAttribute("clientId")%>&date=<%=((String) clientWbo.getAttribute("currentStatusSince")).substring(0, 10)%>">
                                        <img src="images/icons/paymentPlans.png" width="30" style="float: left;" title="إظهار خطط دفع العميل">
                                    </a>
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
        <script>
            var config = {
                '.chosen-select-campaign': {no_results_text: 'No campaign found with this name!'},
            };
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        </script>
    </body>
</html>
