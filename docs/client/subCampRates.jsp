<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    String ratingCategories = (String) request.getAttribute("ratingCategories");
    String resultsJson = (String) request.getAttribute("resultsJson");
    ArrayList<WebBusinessObject> graphResult = (ArrayList<WebBusinessObject>) request.getAttribute("graphResult");
    ArrayList<String> ratesList = (ArrayList<String>) request.getAttribute("RatesList");

    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;
    String align = null;
    String dir = null;

    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
    } else {
        align = "center";
        dir = "RTL";
    }
%>

<html>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <head>
        <link rel="stylesheet" href="css/chosen.css"/>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/media/css/jquery.dataTables.css">
        <link rel="stylesheet" type="text/css" href="css/buttons.dataTables.min.css">

        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" src="js/jquery-1.12.4.js"></script>
        <script type="text/javascript" src="js/jquery-migrate-1.2.1.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/minified/jquery.ui.datepicker.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.min.js"></script>
        <script type="text/javascript" src="js/dataTables.buttons.min.js"></script>
        <script type="text/javascript" src="js/buttons.flash.min.js"></script>
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
        <%if (graphResult != null && graphResult.size() > 0) {%>
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

        <div style="width: 90%;margin-right: auto;margin-left: auto;">
            <TABLE class="display" ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" style="">
                <thead CLASS="thead">
                    <tr>
                        <th CLASS="thead" style="color: #005599 !important;font-weight: bold; font-size: 14px; height: 20px; word-wrap: break-word">الحملة</th>
                            <%for (String TypeTagName : ratesList) {%>
                        <th style="color: #005599 !important;font-weight: bold; font-size: 14px; width: 5%; height: 20px; word-wrap: break-word">
                            <%=TypeTagName%>
                        </th>
                        <%}%>

                        <th style="color: #005599 !important; font-weight: bold; font-size: 14px; height: 20px; word-wrap: break-word"> الاجمالي</th>
                    </tr>
                <thead>

                <tbody>
                    <%
                        int[] totalsArray = new int[ratesList.size()];
                        int counter = 0;
                        int totalForUsr = 0;

                        for (WebBusinessObject wbo : graphResult) {
                    %>
                    <tr>
                        <TD>
                            <%=wbo.getAttribute("CAMPAIGN_TITLE")%>
                        </TD>

                        <%for (String TypeTagName : ratesList) {
                                totalForUsr += Integer.parseInt(wbo.getAttribute(TypeTagName.toString().replaceAll("\\s", "")).toString());
                        %>
                        <TD>
                            <%=wbo.getAttribute(TypeTagName.toString().replaceAll("\\s", ""))%>
                        </TD>
                        <%
                                totalsArray[counter] += Integer.parseInt(wbo.getAttribute(TypeTagName.toString().replaceAll("\\s", "")).toString());
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
                    
                    <tr style="background-color: #FFBAAB;">
                        <td> ZTotal </td>
                        <%
                            int totalForUsrs = 0;
                            for (int i = 0; i < ratesList.size(); i++) {
                                totalForUsrs += totalsArray[i];
                        %>
                        <td> 
                            <%=totalsArray[i]%>            
                        </td>
                        <%}%>  
                        <td> <%=totalForUsrs%> </td>
                    </tr>
                </tbody>
            </TABLE>
        </div>

        <br>
        <%}%>
    </body>
</html>