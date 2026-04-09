<%@page import="com.silkworm.common.UserGroupMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<!DOCTYPE html>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    ArrayList<WebBusinessObject> groupsList = (ArrayList<WebBusinessObject>) request.getAttribute("groupsList");
    String fromDate = "";
    if (request.getAttribute("fromDate") != null) {
        fromDate = (String) request.getAttribute("fromDate");
    }
    String createdBy = "";
    if (request.getAttribute("createdBy") != null) {
        createdBy = (String) request.getAttribute("createdBy");
    }
    String groupId = "";
    if (request.getAttribute("groupId") != null) {
        groupId = (String) request.getAttribute("groupId");
    }
    String jsonText = (String) request.getAttribute("jsonText");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
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
        <style type="text/css">
            .titlebar {
                background-image: url(images/title_bar.png);
                background-position-x: 50%;
                background-position-y: 50%;
                background-size: initial;
                background-repeat-x: repeat;
                background-repeat-y: no-repeat;
                background-attachment: initial;
                background-origin: initial;
                background-clip: initial;
                background-color: rgb(204, 204, 204);
            }
        </style>
        <script  type="text/javascript">
            $(function () {
                $("#fromDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });

                getGrpEmp();
            });

            function openInNewWindow(url) {
                var win = window.open(url, '_blank');
                win.focus();
            }

            function getGrpEmp() {
                var grpId = $("#groupId option:selected").val();

                var options = [];
                options.push(' <option value=""> إختر موظف </option>');

                $.ajax({
                    type: "post",
                    url: "<%=context%>/ReportsServletThree?op=consolidatedActivitiesReport",
                    data: {
                        grpId: grpId,
                        getGrpEmp: "1"
                    }, success: function (jsonString) {
                        var grpEmpInfo = $.parseJSON(jsonString);
                        var createdBy = '<%=createdBy%>';

                        $.each(grpEmpInfo, function () {
                            if (createdBy == this.userId) {
                                options.push('<option value="', this.userId, '" selected>', this.userName, '</option>');
                            } else {
                                options.push('<option value="', this.userId, '">', this.userName, '</option>');
                            }
                        });

                        $("#createdBy").html(options.join(''));
                    }
                });
            }
        </script>
    </head>
    <body>
        <fieldset class="set" style="border-color: #006699; width: 90%;margin-top: 10px;border-radius: 5px;">
            <form name="SEARCH_FORM" action="<%=context%>/ReportsServletThree?op=getEmployeeCallStatistics" method="POST">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4">معدلات مكالمات موظف</font>
                        </td>
                    </tr>
                </table>
                <br/>
                <table align="center" dir="rtl" width="60%" cellspacing="2" cellpadding="1">
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="40%">
                            <b><font size=3 color="white">في تاريخ</b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="40%">
                            <b><font size=3 color="white"> المجموعة </b>
                        </td>
                        <td STYLE="text-align:center" bgcolor="#dedede" width="20%" rowspan="3"> 
                            <button type="submit" onclick="JavaScript: search();" style="color: #000;font-size:15px;margin-top: 20px;font-weight:bold; width: 70%; ">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <input id="fromDate" name="fromDate" type="text" value="<%=fromDate%>">
                            <br/><br/>
                        </td>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 250px;" name="groupId" id="groupId" onchange="getGrpEmp();" >
                                <option value="" selected> إختر مجموعة </option>
                                <sw:WBOOptionList wboList='<%=groupsList%>' displayAttribute="groupName" valueAttribute="groupID" scrollToValue="<%=groupId%>"/>
                            </select>
                            <br/><br/>
                        </td>
                    </tr>

                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="40%">
                            <b><font size=3 color="white"> الموظف </b>
                        </td>

                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 250px;" name="createdBy" id="createdBy">

                            </select>
                        </td>
                    </tr>

                </table>
            </form>
            <br/>
            <%
                if (request.getAttribute("createdBy") != null) {
            %>
            <div id="container" style="height: 300px; width: 70%; margin-left: auto; margin-right: auto;"></div>
            <script language="JavaScript">
                var chart;
                $(document).ready(function () {
                    Highcharts.Chart({
                        chart: {
                            renderTo: 'container',
                            type: 'line'
                        },
                        title: {
                            text: "Employee's Call Rates"
                        },
                        yAxis: {
                            title: {
                                text: 'Number of Calls'
                            }
                        },
                        xAxis: {
                            title: {
                                text: 'Hours of Day'
                            },
                            categories: ["13h", "16h", "19h", "22h"]
                        },
                        legend: {
                            layout: 'vertical',
                            align: 'right',
                            verticalAlign: 'middle'
                        },
                        series: <%=jsonText.replaceAll("\"", "")%>,
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
            <%
                }
            %>
        </fieldset>
    </body>
</html>
