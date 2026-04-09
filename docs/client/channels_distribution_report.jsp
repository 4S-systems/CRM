<%@page import="java.util.ArrayList"%>
<%@page import="com.maintenance.common.Tools"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<html>
    <head>
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            WebBusinessObject wbo = (WebBusinessObject) request.getAttribute("wbo");
            ArrayList<WebBusinessObject> channelsList = (ArrayList<WebBusinessObject>) request.getAttribute("channelsList");
            ArrayList<WebBusinessObject> campaignClientsCounts = (ArrayList<WebBusinessObject>) request.getAttribute("campaignClientsCounts");

            String campsTotal = (String) request.getAttribute("campsTotal");
            String channelTotal = (String) request.getAttribute("channelTotal");

            String campsResultJson = (String) request.getAttribute("campsResultJson");

            Calendar c = Calendar.getInstance();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
            String toDate = sdf.format(c.getTime());
            if (request.getAttribute("toDate") != null) {
                toDate = (String) request.getAttribute("toDate");
            }
            c.add(Calendar.MONTH, -1);
            String fromDate = sdf.format(c.getTime());
            if (request.getAttribute("fromDate") != null) {
                fromDate = (String) request.getAttribute("fromDate");
            }
            String categories = (String) request.getAttribute("categories");
            String resultsJson = (String) request.getAttribute("resultsJson");
            String categoriesCampaign = (String) request.getAttribute("categoriesCampaign");
            String resultsCampaignJson = (String) request.getAttribute("resultsCampaignJson");
            String stat = (String) request.getSession().getAttribute("currentMode");
            String align = "center";
            String dir = null;
            String style = null, lang, langCode, title, fromDateStr, toDateStr, total;

            if (stat.equals("En")) {
                align = "left";
                dir = "LTR";
                style = "text-align:right";
                lang = "&#1593;&#1585;&#1576;&#1610;";
                langCode = "Ar";
                title = " Communication Channel Distribution Over Campaign ";
                fromDateStr = " From Date ";
                toDateStr = " To Date ";
                total = " Total ";
            } else {
                dir = "RTL";
                align = "right";
                style = "text-align:Right";
                lang = "English";
                langCode = "En";
                title = " توزيع قنوات الإتصال على الحملة ";
                fromDateStr = " من تاريخ ";
                toDateStr = " إلى تاريخ ";
                total = " المجموع الكلى ";
            }
            
            String jsonText = (String) request.getAttribute("jsonText");
        %>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" href="js/rateit/rateit.css"/>
        
        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.rowsGroup.js"></script>
        <script type="text/javascript" language="javascript" src="js/rateit/jquery.rateit.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        
        <script type="text/javascript">
            var oTable;
            var dTable;

            $(document).ready(function () {
                $("#fromDate, #toDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });

                oTable = $('#camps').dataTable({
                    "aLengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                    iDisplayLength: 10,
                    columns: [
                        {
                            title: 'Campaign',
                            name: 'Campaign'
                        },
                        {
                            title: 'Channel',
                            name: 'Channel'
                        },
                        {
                            title: 'No. of Client',
                            name: 'Clients'
                        }
                    ],
                    data: <%=campsResultJson%>,
                    rowsGroup: [
                        'Campaign:name'
                    ]
                }).fadeIn(2000);

                dTable = $('#channels').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 10,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
                
                chart = new Highcharts.Chart({
                    chart: {
                        renderTo: 'container',
                        plotBackgroundColor: null,
                        plotBorderWidth: null,
                        plotShadow: false
                    }, title: {
                        text: null
                    }, tooltip: {
                        formatter: function () {
                            return '<b>' + this.point.englishName + '</b>: ' + '%' + Highcharts.numberFormat(this.percentage, 2);
                        }
                    }, plotOptions: {
                        pie: {
                            allowPointSelect: true,
                            cursor: 'pointer',
                            dataLabels: {
                                enabled: true,
                                color: '#000000',
                                connectorColor: '#000000',
                                formatter: function () {
                                    return '<b>' + this.point.englishName + '</b>: ' + '%' + Highcharts.numberFormat(this.percentage, 2);
                                }
                            }
                        }
                    }, series: [{
                        type: 'pie',
                        data: <%=jsonText%>
                    }]
                });
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
        <fieldset class="set" style="border-color: #006699; width: 90%;margin-top: 10px;border-radius: 5px;">
            <form name="SEARCH_CLIENT_FORM" action="<%=context%>/ClientServlet?op=channelsDistribution" method="POST">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4"> <%=title%> </font>
                        </td>
                    </tr>
                </table>
                <br/>
                <table ALIGN="center" DIR="<%=dir%>" WIDTH="50%" CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="40%">
                            <b><font size=3 color="white"> <%=fromDateStr%> </b>
                        </td>
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="40%">
                            <b> <font size=3 color="white"> <%=toDateStr%> </b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                            <input id="fromDate" name="fromDate" type="text" value="<%=fromDate%>" readonly />
                        </td>
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <input id="toDate" name="toDate" type="text" value="<%=toDate%>" readonly />
                        </td>
                    </tr>
                    <tr>
                        <td STYLE="text-align:center" bgcolor="#dedede" colspan="2">
                            <button type="submit" onclick="JavaScript: search();"  STYLE="color: #000;font-size:15px;margin: 10px;font-weight:bold; width: 180px; "> Generate Report <IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                        </td>
                    </tr>
                </table>
                <br/><br/>
            </form>

            <%
                if (channelsList != null) {
            %>
            <div id="container" style="width: 600px; height: 300px; margin: 0 auto; border: none;"></div>
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%">
                <tr>
                    <td style=" width: 70%; vertical-align: top">
                        <font color="red" size="4"> Outbound - Campaign </font>
                        <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" id="camps">
                        </table>
                        <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%">
                            <tr style="background-color: #FFBAAB;">
                                <td style="color: #005599 !important;font: 14px; font-weight: bold;" valign="middle" colspan="2">
                                     <%=total%>
                                </td>
                                <td style="text-align: center; font-size: 14px; font-weight: bold;" valign="middle">
                                    <%=campsTotal%>
                                </td>
                            </tr>
                        </table>
                    </td>

                    <td style=" width: 30%; vertical-align: top">
                        <font color="red" size="4"> Inbound - Know Us Throw </font>
                        <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" id="channels">
                            <thead>
                                <tr>
                                    <th style="color: #005599 !important;font: 14px; font-weight: bold;">Channel</th>
                                    <th style="color: #005599 !important;font: 14px; font-weight: bold;">No. of Client</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    for (WebBusinessObject channelWbo : channelsList) {
                                        if (channelWbo.getAttribute("englishName") != null) {
                                %>
                                <tr>
                                    <td style="text-align: center; font-size: 14px; font-weight: bold;" valign="middle">
                                        <%=channelWbo.getAttribute("englishName")%>
                                    </td>
                                    <td style="text-align: center; font-size: 14px; font-weight: bold;" valign="middle">
                                        <%=channelWbo.getAttribute("total")%>
                                    </td>
                                </tr>
                                <%
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                        <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" >
                            <tr style="background-color: #FFBAAB;">
                                <td style="color: #005599 !important;font: 14px; font-weight: bold;" valign="middle">
                                     <%=total%> 
                                </td>
                                <td style="text-align: center; font-size: 14px; font-weight: bold;" valign="middle">
                                    <%=channelTotal%>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <%}%>
        </fieldset>
    </body>
</html>