<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@ page import= "java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>

<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        ArrayList<WebBusinessObject> campaignsList = (ArrayList<WebBusinessObject>) request.getAttribute("campaignsList");
        ArrayList<WebBusinessObject> ratesList = (ArrayList<WebBusinessObject>) request.getAttribute("ratesList");

        ArrayList<String> WeeksList = (ArrayList<String>) request.getAttribute("WeeksList");
        ArrayList<WebBusinessObject> campsDgrdtionList = (ArrayList<WebBusinessObject>) request.getAttribute("campsDgrdtionList");

        String campaignID = request.getAttribute("campaignID") != null ? (String) request.getAttribute("campaignID") : "";
        String rateID = request.getAttribute("rateID") != null ? (String) request.getAttribute("rateID") : "";
        String rangeString = request.getAttribute("rangeString") != null ? (String) request.getAttribute("rangeString") : "";
        String startingPoint = request.getAttribute("startingPoint") != null ? (String) request.getAttribute("startingPoint") : "";
        String jsonResultText = request.getAttribute("jsonResultText") != null ? (String) request.getAttribute("jsonResultText") : "";
        String jsonWeeksList = request.getAttribute("jsonWeeksList") != null ? (String) request.getAttribute("jsonWeeksList") : "";
        
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null, xAlign, fromDate, toDate, dir, display, campaign, rate, campTitle;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";

            fromDate = "From Date";
            toDate = "To Date";
            display = "Display Report";
            campaign = "Campaign";
            rate = "Classification";
            campTitle = "Campaign";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";

            fromDate = "من تاريخ";
            toDate = "إلي تاريخ";
            display = "أعرض التقرير";
            campaign = "الحملة";
            rate = "التصنيف";
            campTitle = "الحملة";
        }
    %>
    <head>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>
        <link rel="stylesheet" href="jquery-multiSelect/jquery.multiselect.css"/>

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
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>

        <script type="text/javascript">
            var oTable;
            $(document).ready(function () {
                $("#fromDate,#toDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });

                oTable = $('#campsDeg').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[20, 50, 100, -1], [20, 50, 100, "All"]],
                    iDisplayStart: 0,
                    iDisplayLength: 20,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[1, "asc"]],
                    "columnDefs": [{
                            "targets": 0,
                            "orderable": false
                        }],

                }).fadeIn(2000);
            });

            function getProjects(obj) {
                var campaignID = $("#campaignID").val();

                $.ajax({
                    type: "post",
                    url: '<%=context%>/CampaignServlet?op=getProjectsAjax',
                    data: {
                        campaignID: campaignID
                    },
                    success: function (dataStr) {
                        console.log("dataStr " + dataStr);
                        var result = $.parseJSON(dataStr);
                        var options = [];
                        //options.push("<option value=''>", "الكل", "</option>");
                        try {
                            $.each(result, function () {
                                if (this.projectName) {
                                    options.push('<option value="', this.projectID, '">', this.projectName, '</option>');
                                }
                            });
                        } catch (err) {
                        }
                        $("#projectID").html(options.join(''));
                    }
                });
            }
        </script>

        <style type="text/css">
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
            .bookmark_button{
                width:135px;
                height:40px;
                float: right;
                margin: 0px;
                /*margin-right: 90px;*/
                border: none;
                background-repeat: no-repeat;
                cursor: pointer;
                margin-top: 3px;
                background-position: right top ;
                /*display: inline-block;*/
                background-color: transparent;
                background-image:url(images/buttons/bookmarked.png);
            }
            .highcharts-figure, .highcharts-data-table table {
                min-width: 360px; 
                max-width: 800px;
                margin: 1em auto;
            }

            .highcharts-data-table table {
                font-family: Verdana, sans-serif;
                border-collapse: collapse;
                border: 1px solid #EBEBEB;
                margin: 10px auto;
                text-align: center;
                width: 100%;
                max-width: 500px;
            }
            .highcharts-data-table caption {
                padding: 1em 0;
                font-size: 1.2em;
                color: #555;
            }
            .highcharts-data-table th {
                font-weight: 600;
                padding: 0.5em;
            }
            .highcharts-data-table td, .highcharts-data-table th, .highcharts-data-table caption {
                padding: 0.5em;
            }
            .highcharts-data-table thead tr, .highcharts-data-table tr:nth-child(even) {
                background: #f8f8f8;
            }
            .highcharts-data-table tr:hover {
                background: #f1f7ff;
            }
        </style>
    </head>
    <body>
        <fieldset align=center class="set" style="width: 95%">
            <legend align="center">
                <table dir="rtl" align="center">
                    <tr>
                        <td class="td">
                            <font color="blue" size="6">General Campaign Statistics - GCS</font>
                        </td>
                    </tr>
                </table>
            </legend>
            <form name="CampDegradation_FORM" action="<%=context%>/ReportsServletThree?op=getCampaignStat" method="POST">
                <br/>
                <table class="blueBorder" align="center" dir="<%=dir%>" id="code" cellpadding="0" cellspacing="0" width="650" style="border-width: 1px; border-color: white; display: block;" >
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
                            <input type="text" style="width:190px;cursor:hand;" id="fromDate" name="fromDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("fromDate") == null ? "" : request.getAttribute("fromDate")%>"/>
                        </td>
                        <td bgcolor="#dedede" valign="middle">
                            <input type="text" style="width:190px;cursor:hand;" id="toDate" name="toDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("toDate") == null ? "" : request.getAttribute("toDate")%>"/>
                        </td>
                    </tr>

                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px">
                            <b><font size=3 color="white"><%=campaign%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px">
                            <b><font size=3 color="white"><%=rate%></b>
                        </td>
                    </tr>

                    <tr>
                        <td bgcolor="#dedede" valign="middle">
                            <select name="campaignID" id="campaignID" style="width: 300px;" class="chosen-select-campaign" multiple onchange="JavaScript: getProjects(this);">
                                <%
                                    for (WebBusinessObject campaignWbo : campaignsList) {
                                %>
                                <option value="<%=campaignWbo.getAttribute("id")%>" <%=campaignID.contains((String) campaignWbo.getAttribute("id")) ? "selected" : ""%> ><%=campaignWbo.getAttribute("campaignTitle")%></option>
                                <%
                                    }
                                %>
                            </select>
                        </td>
                        <td bgcolor="#dedede" valign="middle" id="clssTrSlc">
                            <select name="rateID" id="rateID" style="width: 300px;" class="chosen-select-rate">
                                <%
                                    for (WebBusinessObject rateWbo : ratesList) {
                                %>
                                <option value="<%=rateWbo.getAttribute("projectID")%>" <%=rateID.contains((String) rateWbo.getAttribute("projectID")) ? "selected" : ""%> ><%=rateWbo.getAttribute("projectName")%></option>
                                <%
                                    }
                                %>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <td bgcolor="#dedede" valign="middle" colspan="2" style="width: 50%;">
                            <input type="submit" value="<%=display%>" class="button" style="margin: 10px; width: 50%;"/>
                        </td>
                    </tr>
                </table>

                </br>

                <%if (campsDgrdtionList != null) {
                        if (campsDgrdtionList.size() > 0) {%>
                <table align="<%=align%>" dir="<%=dir%>" id="campsDeg" style="width:100%;">
                    <thead>
                        <tr>
                            <th>
                                <%=campTitle%>
                            </th>

                            <%for (String th : WeeksList) {%>
                            <th>
                                Week_<%=th%>
                            </th>
                            <%}%>
                        </tr>
                    </thead>

                    <tbody>
                        <%for (WebBusinessObject wbo : campsDgrdtionList) {%>
                        <tr>
                            <td>
                                <%=wbo.getAttribute("CAMPAIGN_TITLE")%>
                            </td>

                            <%for (String th : WeeksList) {%>
                            <td>
                                <%=wbo.getAttribute(th)%>
                            </td>
                            <%}%>
                        </tr>
                        <%}%>
                    </tbody>
                </table>

                <br>

                <figure class="highcharts-figure">
                <div id="container" style="width: 100%; height: 500px; margin: 0 auto"></div>
                <script language="JavaScript">
                    var chart;
                    $(document).ready(function () {
                        chart = new Highcharts.Chart({
                            chart: {
                                renderTo: 'container',
                                plotBackgroundColor: null,
                                plotBorderWidth: null,
                                plotShadow: false
                            },
                            title: {
                                text: ''
                            },

                            subtitle: {
                                text: 'Source: thesolarfoundation.com'
                            },

                            yAxis: {
                                title: {
                                    text: 'Number of Leads / Campaign'
                                }
                            },

                            xAxis: {
                                categories: <%=jsonWeeksList%>
                            },

                            legend: {
                                layout: 'vertical',
                                align: 'right',
                                verticalAlign: 'middle'
                            },

                            plotOptions: {
                                series: {
                                    label: {
                                        connectorAllowed: false
                                    }
                                }
                            },

                            series: <%=jsonResultText%>,

                            responsive: {
                                rules: [{
                                        condition: {
                                            maxWidth: 500
                                        },
                                        chartOptions: {
                                            legend: {
                                                layout: 'horizontal',
                                                align: 'center',
                                                verticalAlign: 'bottom'
                                            }
                                        }
                                    }]
                            }
                        });
                    });
                </script>
                </figure>
                <%}
                } else {%>
                <Font color="red" size="5">No Data</Font>
                <%}%>
            </form>
        </fieldset>

        <script>
                    var config = {
                    '.chosen-select-campaign': {no_results_text: 'No campaign found with this name!'},
                            '.chosen-select-rate': {no_results_text: 'No classification found with this name!'}
                    };
                    for (var selector in config) {
            $(selector).chosen(config[selector]);
            }
        </script>
    </body>
</html>
