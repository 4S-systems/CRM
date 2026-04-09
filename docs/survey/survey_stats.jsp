<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    String fromDate = (String) request.getAttribute("fromDate");
    String toDate = (String) request.getAttribute("toDate");

    ArrayList<LiteWebBusinessObject> graphResult = (ArrayList<LiteWebBusinessObject>) request.getAttribute("graphResult");
    String questionsNameList = (String) request.getAttribute("questionsNameList");
    String resultsJson = (String) request.getAttribute("resultsJson");

    String surveyStatNamesJSON = (String) request.getAttribute("surveyStatNamesJSON");
    String second_resultsJson = (String) request.getAttribute("second_resultsJson");

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
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">

        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts-4.2.4.js"></script>
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
            var chart1;
            var chart2;
            
            $(document).ready(function () {
                oTable = $('#questionsStats').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
                
                chart1 = new Highcharts.Chart({
                    chart: {
                        renderTo: 'container1',
                        type: 'column'
                    },
                    title: {
                        text: 'تحليل استقصاءات العملاء'
                    },
                    xAxis: {
                        categories: <%=questionsNameList%>
                    },
                    yAxis: {
                        min: 1,
                        title: {
                            text: 'مستويات قبول العملاء'
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
                    series: <%=resultsJson%>
                });
                
                chart2 = new Highcharts.Chart({
                    chart: {
                        renderTo: 'container2',
                        type: 'column'
                    },
                    title: {
                        text: 'تحليل استقصاءات العملاء'
                    },
                    xAxis: {
                        categories: <%=surveyStatNamesJSON%>
                    },
                    yAxis: {
                        min: 1,
                        title: {
                            text: 'مستويات قبول الاستقصاءات'
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
                    series: <%=second_resultsJson%>
                });
            });

            function getResults() {
                var beginDate = $("#fromDate").val();
                var endDate = $("#toDate").val();

                document.stat_form.action = "<%=context%>/CommentsServlet?op=viewSurveyStats&beginDate=" + beginDate + "&endDate=" + endDate;
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
        <FORM NAME="stat_form" METHOD="POST">
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="50%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4">
                <TR>
                    <TD width="8%" STYLE="text-align: center; color: blue; font-size: 16px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <DIV> 
                            عرض خلال 
                        </DIV>
                    </TD>
                    <TD width="3%" STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        من تاريخ :
                    </TD>
                    <TD width="9%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <input id="fromDate" name="fromDate" type="text" value="<%=fromDate%>" style="margin: 5px;" title="تاريخ توزيع العميل" />
                    </TD>
                    <TD width="3%" STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        الى تاريخ :
                    </TD>
                    <TD width="15%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <input id="toDate" name="toDate" type="text" value="<%=toDate%>" style="margin: 5px;" title="تاريخ توزيع العميل" />
                    </TD>  
                    <TD width="9%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <button style="width: 100px" type="button" onclick="javascript:getResults();"><b style="font-weight: bold; font-size: 14px; vertical-align: middle">عرض</b>&ensp;<img src="images/icons/refresh.png" width="20" height="20" style="vertical-align: middle"/></button>
                    </TD>
                </TR>
            </TABLE>
        </FORM>
        <br>

        <%if (graphResult != null && graphResult.size() > 0) {%>
        <div id="container1" style="height: 300px; width: 90%;"></div>
        <div style="height: 50px;"></div>
        <div id="container2" style="height: 300px; width: 90%;"></div>
        <br>
        <br>

        <div style="width: 90%;margin-right: auto;margin-left: auto;">
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" id="questionsStats" style="">
                <thead>
                    <tr>
                        <th style="color: #005599 !important;font-weight: bold; font-size: 14px;">سؤال الاستقصاء</th>
                        <th style="color: #005599 !important;font-weight: bold; font-size: 14px;">Satisfyed/راض<img src="images/icons/three_stars.png" width="45" height="20" style="vertical-align: middle"/></th>
                        <th style="color: #005599 !important;font-weight: bold; font-size: 14px;">Some Satisfyed/راض بعض الشئ<img src="images/icons/two_stars.png" width="45" height="20" style="vertical-align: middle"/></th>
                        <th style="color: #005599 !important;font-weight: bold; font-size: 14px;">Dis Satisfyed/غير راض<img src="images/icons/star.png" width="45" height="20" style="vertical-align: middle"/></th>
                    </tr>
                <thead>
                <tbody >  
                    <%
                        int satsCount = 0;
                        int someSatsCount = 0;
                        int disSatsCount = 0;

                        for (LiteWebBusinessObject wbo : graphResult) {
                    %>
                    <tr>
                        <TD>
                            <%=wbo.getAttribute("question")%>
                        </TD>

                        <TD>
                            <%satsCount += Integer.parseInt(wbo.getAttribute("sats").toString());%>
                            <%=wbo.getAttribute("sats")%>
                        </TD>

                        <TD>
                            <%someSatsCount += Integer.parseInt(wbo.getAttribute("someSats").toString());%>
                            <%=wbo.getAttribute("someSats")%>
                        </TD>

                        <TD>
                            <%disSatsCount += Integer.parseInt(wbo.getAttribute("disSats").toString());%>
                            <%=wbo.getAttribute("disSats")%>
                        </TD> 
                    </tr>
                    <%
                        }
                    %>

                    <tr style="background-color: #FFBAAB;">
                        <td> Total </td>
                        <td> <%=satsCount%> </td>
                        <td> <%=someSatsCount%> </td>
                        <td> <%=disSatsCount%> </td>
                    </tr>
                </tbody>
            </TABLE>
        </div>
        <%}%>
    </body>
</html>