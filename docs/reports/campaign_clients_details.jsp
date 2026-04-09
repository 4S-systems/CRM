<%@page import="java.util.HashMap"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Map"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<!DOCTYPE html>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        Map<String, Map<String, String>> data = (Map<String, Map<String, String>>) request.getAttribute("data");
        Set<String> ratesNames = (Set<String>) request.getAttribute("ratesNames");
        Map<String, Integer> ratesTotal = new HashMap<>();
        WebBusinessObject campaignWbo = (WebBusinessObject) request.getAttribute("campaignWbo");

        String ratingCategories = (String) request.getAttribute("ratingCategories");
        String resultsJson = (String) request.getAttribute("resultsJson");

        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null, title, campaignName, total, message, totalAll;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            title = "Campaign Details (" + campaignWbo.getAttribute("campaignTitle") + ")";
            campaignName = "Campaign Name";
            total = "Total";
            message = "Clients are on Main Campaign";
            totalAll = "Total Clients";
        } else {
            align = "center";
            dir = "RTL";
            title = "تفاصيل الحملة (" + campaignWbo.getAttribute("campaignTitle") + ")";
            campaignName = "اسم الحملة";
            total = "أجمالي";
            message = "العملاء علي الحملة الرئيسية";
            totalAll = "أجمالي العملاء";
        }
    %>
    <head>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link href="js/select2.min.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="css/chosen.css"/>

        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery-1.12.4.js"></script>
        <script type="text/javascript" src="js/jquery-migrate-1.2.1.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/select2.min.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
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

        <script type="text/javascript">
            var oTable;
            $(document).ready(function () {
                $("#clients").css("display", "none");
                oTable = $('#clients').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
            });
        </script>
    </head>

    <body>
        <fieldset class="set">
            <legend>
                <font style="font-weight: bold; color: blue;" size="5"><%=title%>
            </legend>
            <br/><br/>

            <%
                if (data != null && !data.isEmpty()) {
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
                            text: 'معدلات الحملات'
                        },
                        xAxis: {
                            categories: <%=ratingCategories%>
                        },
                        yAxis: {
                            min: 0,
                            title: {
                                text: 'الانواع'
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
            <br>
            <br>

            <div style="width: 95%;margin-right: auto;margin-left: auto;" id="showResults">
                <table align="<%=align%>" dir="<%=dir%>" width="100%" id="clients" style="">
                    <thead>
                        <tr>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;"><%=campaignName%></th>
                                <%
                                    for (String rateName : ratesNames) {
                                %>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;"><%=rateName%></th>
                                <%
                                    }
                                %>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;"><%=total%></th>
                        </tr>
                    <thead>
                    <tbody >  
                        <%
                            Map<String, String> tempMap;
                            int totalClients = 0, campaignTotal = 0;
                            for (String campaingTitle : data.keySet()) {
                                tempMap = data.get(campaingTitle);
                                campaignTotal = 0;
                        %>
                        <tr>
                            <td>
                                <%=campaingTitle%>
                            </td>
                            <%
                                for (String rateName : ratesNames) {
                                    if(tempMap.containsKey(rateName)) {
                                        totalClients += Integer.valueOf(tempMap.get(rateName));
                                        campaignTotal += Integer.valueOf(tempMap.get(rateName));
                                        if(ratesTotal.containsKey(rateName)) {
                                            ratesTotal.put(rateName, ratesTotal.get(rateName) + Integer.valueOf(tempMap.get(rateName)));
                                        } else {
                                            ratesTotal.put(rateName, Integer.valueOf(tempMap.get(rateName)));
                                        }
                                    }
                            %>
                            <td>
                                <%=tempMap.containsKey(rateName) ? tempMap.get(rateName) : "0"%>
                            </td>
                            <%
                                }
                            %>
                            <td>
                                <%=campaignTotal%>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>  
                    <tfoot>
                        <tr>
                            <td style="font-size: 22px;">
                                <%=total%>
                            </td>
                            <%
                                for (String rateName : ratesNames) {
                            %>
                            <td style="font-size: 22px;">
                                <b><%=ratesTotal.containsKey(rateName) ? ratesTotal.get(rateName)  :"0"%></b>
                            </td>
                            <%
                                }
                            %>
                            <td style="font-size: 22px;">
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="font-size: 22px;" colspan="<%=ratesNames.size() + 1%>">
                                <%=totalAll%>
                            </td>
                            <td style="font-size: 22px;">
                                <b><%=totalClients%></b>
                            </td>
                        </tr>
                    </tfoot>
                </table>
                <br/>
            </div>
            <%
                } else {
            %>
            <h3 style="color: red;"><%=message%></h3>
            <%
                }
            %>
            <br/><br/>
        </fieldset>    
    </body>
</html>
