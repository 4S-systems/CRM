<%-- 
    Document   : clients_classification_per_comChann
    Created on : Aug 29, 2018, 1:21:22 PM
    Author     : walid
tawzee3 el 3omla2 -> el tawzee3 el nesby lel 3omla2
--%>

<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<!DOCTYPE html>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    String fromDate = (String) request.getAttribute("fromDate");
    String toDate = (String) request.getAttribute("toDate");
    String rateID = request.getAttribute("rateID") != null ? (String) request.getAttribute("rateID") : "";

    String ratingCategories = (String) request.getAttribute("ratingCategories");
    String resultsJson = (String) request.getAttribute("resultsJson");
    ArrayList<WebBusinessObject> graphResult = (ArrayList<WebBusinessObject>) request.getAttribute("graphResult");
    ArrayList<String> rateNameList = (ArrayList<String>) request.getAttribute("rateNameList");
    ArrayList<WebBusinessObject> rates = (ArrayList<WebBusinessObject>) request.getAttribute("rates");

    ArrayList<WebBusinessObject> groups = (ArrayList<WebBusinessObject>) request.getAttribute("groups");
    String groupID = request.getAttribute("groupID") != null ? (String) request.getAttribute("groupID") : "";

    String stat = (String) request.getSession().getAttribute("currentMode");
    String align, dir, fDate, tDate, title, clientsCount, rate, noGroup, group;
    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        fDate = "From Date";
        tDate = "To Date";
        title = "Clients Classification Per Communication Channel";
        clientsCount = "Clients Count";
        rate = "Rate";
        noGroup = "No Groups";
        group = "Group";
    } else {
        align = "center";
        dir = "RTL";
        fDate = "من تاريخ";
        tDate = "إلى تاريخ";
        title = "معدلات تصنيف عملاء قنوات الإتصال";
        clientsCount = "عدد العملاء";
        rate = "التصنيف";
        noGroup = "لا يوجد مجموعات";
        group = "المجموعة";
    }
%>
<html>
    <head>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link href="js/select2.min.css" rel="stylesheet" type="text/css" />

        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/select2.min.js"></script>

        <script type="text/javascript">
            $(function () {
                $("#fromDate, #toDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });

            var oTable;
            var dTable;
            $(document).ready(function () {
                oTable = $('#EmployeeTypesTag').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);

                $("#rateID").select2();
            });
            function getResults() {
                document.stat_form.action = "<%=context%>/ProjectServlet?op=getClientClassOfComChan";
                document.stat_form.submit();
            }
            function exportToExcel() {
                document.stat_form.action = "<%=context%>/ProjectServlet?op=getClientClassOfComChanExcel";
                document.stat_form.submit();
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
            .remove{
                width:20px;
                height:20px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                background-image:url(images/icons/icon-32-remove.png);
            }
            .overlayClass {
                width: 100%;
                height: 100%;
                display: none;
                background-color: rgb(0, 85, 153);
                opacity: 0.4;
                z-index: 500;
                top: 0px;
                left: 0px;
                position: fixed;
            }
            .img:hover{
                cursor: pointer ;
            }

            #mydiv {
                text-align:center;
            }
        </style>
    </head>
    <body>
        <fieldset class="set" style="width:95%; border-color: #006699;">
            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                <tr>
                    <td width="100%" class="titlebar">
                        <font color="#005599" size="4"><%=title%></font>
                    </td>
                </tr>
            </table>
            <br/>
            <form name="stat_form" method="POST">
                <table align="<%=align%>" dir="<%=dir%>" width="50%" cellpadding="0" cellspacing="0" style="border: 2px solid #d3d5d4">
                    <tr>
                        <td width="3%" style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <%=fDate%>
                        </td>
                        <td width="9%" style="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <input id="fromDate" name="fromDate" type="text" value="<%=fromDate%>" style="margin: 5px;" />
                        </td>
                        <td width="3%" style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <%=tDate%>
                        </td>
                        <td width="15%" style="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <input id="toDate" name="toDate" type="text" value="<%=toDate%>" style="margin: 5px;" />
                        </td>
                        <td width="3%" style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <%=rate%>
                        </td>
                        <td style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                            <select name="rateID" id="rateID" style="width: 200px;" multiple>
                                <%
                                    for (WebBusinessObject rateWbo : rates) {
                                %>
                                <option value="<%=rateWbo.getAttribute("projectName")%>" <%=rateID.contains((String) rateWbo.getAttribute("projectName")) ? "selected" : ""%>>
                                    <%=rateWbo.getAttribute("projectName")%>
                                </option>
                                <%
                                    }
                                %>
                            </select>
                        </td>
                        <td width="3%" style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <%=group%>
                        </td>
                        <td style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                            <select id="groupID" name="groupID" style="font-size: 14px; width: 200px;">
                                <%if (groups != null && !groups.isEmpty()){%>
                                    <sw:WBOOptionList wboList="<%=groups%>" displayAttribute="groupName" valueAttribute="group_id" scrollToValue="<%=groupID%>" />
                                <%} else {%>
                                    <option><%=noGroup%></option>
                                <%}%>
                            </select>
                        </td>
                        <td width="9%" style="text-align: right; color: blue; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <button style="width: 100px" type="button" onclick="javascript:getResults();"><b style="font-weight: bold; font-size: 14px; vertical-align: middle">عرض</b>&ensp;<img src="images/icons/refresh.png" width="20" height="20" style="vertical-align: middle"/></button>
                            <button style="width: 100px" type="button" onclick="javascript: exportToExcel();"><b style="font-weight: bold; font-size: 14px; vertical-align: middle">Excel</b>&ensp;<img src="images/icons/excel.png" width="20" height="20" style="vertical-align: middle"/></button>
                        </td>
                    </tr>
                </table>
            </form>
            <br/>
            <%
                if (graphResult != null && graphResult.size() > 0) {
            %>
            <div id="container" style="height: 300px; width: 90%;"></div>
            <script language="JavaScript">
                var chart;
                $(document).ready(function () {
                    chart = new Highcharts.Chart({
                        chart: {
                            renderTo: 'container',
                            type: 'column'
                        },
                        title: {
                            text: '<%=title%>'
                        },
                        xAxis: {
                            categories: <%=ratingCategories%>
                        },
                        yAxis: {
                            min: 0,
                            title: {
                                text: '<%=clientsCount%>'
                            }
                        },
                        tooltip: {
                            headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                            pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                                    '<td style="padding:0"><b>{point.y:.1f} mm</b></td></tr>',
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
                        series: <%=resultsJson%>
                    });
                });
            </script>
            <br/>
            <br/>
            <div style="width: 90%;margin-right: auto;margin-left: auto;">
                <table align="<%=align%>" dir="<%=dir%>" width="100%" id="EmployeeTypesTag" style="">
                    <thead>
                        <tr>
                            <th style="color: #005599 !important;font-weight: bold; font-size: 14px;">قناة الأتصال</th>
                                <%
                                    for (String rateName : rateNameList) {
                                %>
                            <th style="color: #005599 !important;font-weight: bold; font-size: 14px;">
                                <%=rateName%>
                            </th>
                            <%
                                }
                            %>
                            <th style="color: #005599 !important; font-weight: bold; font-size: 14px;"> Total </th>
                        </tr>
                    <thead>
                    <tbody >
                        <%
                            int[] totalsArray = new int[rateNameList.size()];
                            int counter = 0;
                            int totalForUsr = 0;

                            for (WebBusinessObject wbo : graphResult) {
                        %>
                        <tr>
                            <td>
                                <%=wbo.getAttribute("channelName")%>
                            </td>
                            <%for (int i = 0; i < rateNameList.size(); i++) {
                                    totalForUsr += Integer.parseInt(wbo.getAttribute("rate" + i).toString());
                            %>
                            <td>
                                <%=wbo.getAttribute("rate" + i)%>
                            </td>
                            <%
                                    totalsArray[counter] += Integer.parseInt(wbo.getAttribute("rate" + i).toString());
                                    counter++;
                                }
                            %>
                            <td style="background-color: #FFBAAB;"> <%=totalForUsr%> </td>
                            <%
                                counter = 0;
                                totalForUsr = 0;
                            %>
                        </tr>
                        <%
                            }
                        %>
                    <tfoot>
                        <tr style="background-color: #FFBAAB;">
                            <th> ZTotal </th>
                                <%
                                    int totalForUsrs = 0;
                                    for (int i = 0; i < rateNameList.size(); i++) {
                                        totalForUsrs += totalsArray[i];
                                %>
                            <th> <%=totalsArray[i]%> </th>
                                <%
                                    }
                                %>
                            <th> <%=totalForUsrs%> </th>
                        </tr>
                    </tfoot>
                    </tbody>
                </table>
            </div>
            <%
                }
            %>
            <br/>
        </fieldset>
    </body>
</html>
