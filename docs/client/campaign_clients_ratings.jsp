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

    ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
    String jsonData = (String) request.getAttribute("jsonData");
    String campaignID = (String) request.getAttribute("campaignID");
    WebBusinessObject campaignWbo = CampaignMgr.getInstance().getOnSingleKey(campaignID);
    String campTitle = (String) campaignWbo.getAttribute("campaignTitle");
    String stat = "Ar";
    int total = 0;

    String align = null;
    String dir = null;
    String style = null;
    String lang, langCode;
    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
        langCode = "Ar";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
    }
%>
<html>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <META HTTP-EQUIV="Expires" CONTENT="0"/>   

        <link rel="stylesheet" href="js/amcharts/plugins/export/export.css" type="text/css" media="all" />

        <script src="js/amcharts/amcharts.js"></script>
        <script src="js/amcharts/serial.js"></script>
        <script src="js/amcharts/plugins/export/export.min.js"></script>    
        <script src="js/amcharts/themes/light.js"></script>

        <style>
            #chartdiv {
                width: 100%;
                height: 500px;
            }

            .amcharts-export-menu-top-right {
                top: 10px;
                right: 0;
            }
        </style>

        <script>
            var chart = AmCharts.makeChart("chartdiv", {
                "type": "serial",
                "theme": "light",
                "marginRight": 70,
                "dataProvider": <%=jsonData%>,
                "valueAxes": [{
                        "axisAlpha": 0,
                        "position": "left",
                        "title": "Client Rating"
                    }],
                "startDuration": 1,
                "graphs": [{
                        "balloonText": "<b>[[category]]: [[value]]</b>",
                        "fillColorsField": "RateColor",
                        "fillAlphas": 0.9,
                        "lineAlpha": 0.2,
                        "type": "column",
                        "valueField": "ClientCount"
                    }],
                "chartCursor": {
                    "categoryBalloonEnabled": false,
                    "cursorAlpha": 0,
                    "zoomable": false
                },
                "categoryField": "RateName",
                "categoryAxis": {
                    "gridPosition": "start",
                    "labelRotation": 45
                },
                "export": {
                    "enabled": true
                }

            });
        </script>
    </head>

    <body>
        <div align="left" STYLE="color:blue; margin-left: 50px;">
            <input type="button"  value="عودة"  onclick="history.go(-1);" class="button"/>
        </div>

        <% if (data != null && !data.isEmpty()) {%>      
        <br>
        <div id="chartdiv" style="width: 100%; height: 400px;"></div>
        <br>
        <br>
        <div style="width: 80%">
            <center><font size="3"><b>الحملة</b> </font>: <font size="3" color="red"><b><%=campTitle%></b> </font></center>
            <br>

            <table align="center" width="100%" ALIGN="<%=align%> " DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0">
                <thead>
                    <tr bgcolor="#C8D8F8">
                        <%for (WebBusinessObject wbo : data) {%>
                        <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="4%"><b><%=wbo.getAttribute("RateName")%></b></th>
                                <%}%>
                        <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="4%"><b>المجموع الكلي</b></th>
                    </tr>
                </thead> 
                <tbody>
                    <%for (WebBusinessObject wbo : data) {
                            total += new Integer(wbo.getAttribute("ClientCount").toString()).intValue();
                    %>
                <td>
                    <%=wbo.getAttribute("ClientCount")%>
                </td>
                <%}%>
                <td>
                    <font size="3" color="red"><b><%=total%></b> </font>                   
                </td>
                </tbody>
            </table>
        </div>
        <br>
        <%} else {%>
        <b style="color: red; font-size: x-large;">لا يوجد نتائج للبحث</b>
        <%}%>
    </body>
</html>