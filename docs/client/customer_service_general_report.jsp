<%@page import="java.util.Map"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    ArrayList<WebBusinessObject> departments = (ArrayList<WebBusinessObject>) request.getAttribute("departments");
    String departmentID = request.getAttribute("departmentID") != null ? (String) request.getAttribute("departmentID") : "";
    String fromDate = (String) request.getAttribute("fromDate");
    String toDate = (String) request.getAttribute("toDate");

    String ratingCategories = (String) request.getAttribute("ratingCategories");
    String resultsJson = (String) request.getAttribute("resultsJson");
    ArrayList<WebBusinessObject> graphResult = (ArrayList<WebBusinessObject>) request.getAttribute("graphResult");
    String[] ticketTypeIDs = (String[]) request.getAttribute("ticketTypeIDs");
    Map<String, String> ticketTypeMap = (Map<String, String>) request.getAttribute("ticketTypeMap");
    
    String stat = (String) request.getSession().getAttribute("currentMode");
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
    <head>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">

        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>  
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>   
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.dialog.js"></script>   
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.position.js"></script>  
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/msdropdown/jquery.dd.min.js"></script>

        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
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

                dTable = $('#EmployeeDetails').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);

            });

            function getResults() {
                var depratmentID = $("#departmentID").val();
                var beginDate = $("#fromDate").val();
                var endDate = $("#toDate").val();

                document.stat_form.action = "<%=context%>/ClientServlet?op=getCustomerServiceReport&depratmentID=" + depratmentID + "&beginDate=" + beginDate + "&endDate=" + endDate + "&userID=";
                document.stat_form.submit();
            }
            var divTag;
            function popupViewComplaints(userID, type, typeName, clientName) {
                divTag = $("#clientComplaints");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/ClientServlet?op=getRequestsByUserInPeriod',
                    data: {
                        userID: userID,
                        type: type,
                        fromDate: '<%=fromDate%>',
                        toDate: '<%=toDate%>'
                    },
                    success: function (data) {
                        divTag.html(data).dialog({
                            modal: true,
                            title: "طلبات الموظف " + clientName + " (" + typeName + ")",
                            show: "fade",
                            hide: "explode",
                            width: 950,
                            position: {
                                my: 'center',
                                at: 'center'
                            },
                            buttons: {
                                'Close': function () {
                                    $(this).dialog('close');
                                }
                            }
                        }).dialog('open');
                        $('#clientCampaignsPopup').dataTable({
                            bJQueryUI: true,
                            "bPaginate": false,
                            "bProcessing": true,
                            "bFilter": false
                        }).fadeIn(2000);
                        },
                    error: function (data) {
                        alert(data);
                    }
                });
            }
            function openInNewWindow(url) {
                var win = window.open(url, '_blank');
                win.focus();
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
        <form name="stat_form" method="POST">
            <div id="clientComplaints"></div>
            <div style="margin-left: auto; margin-right: auto;"><h1 style="color: #0000ff;">التقرير العام لخدمة العملاء</h1></div>
            <table align="<%=align%>" dir="<%=dir%>" width="98%" cellpadding="0" cellspacing="0" style="border: 2px solid #d3d5d4">
                <tr>
                    <td width="8%" style="text-align: center; color: blue; font-size: 16px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                        <DIV> 
                            عرض خلال 
                        </DIV>
                    </td>
                    <td width="3%" style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                        من تاريخ :
                    </td>
                    <td width="9%" style="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                        <input id="fromDate" name="fromDate" type="text" value="<%=fromDate%>" style="margin: 5px;" />
                    </td>
                    <td width="3%" style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                        الى تاريخ :
                    </td>
                    <td width="15%" style="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                        <input id="toDate" name="toDate" type="text" value="<%=toDate%>" style="margin: 5px;" />
                    </td>
                    <td width="3%" style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                        الأدارة :
                    </td>
                    <td width="23%" style="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                        <select id="departmentID" name="departmentID" style="font-size: 14px; width: 100%">
                            <sw:WBOOptionList wboList="<%=departments%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=departmentID%>" />
                        </select>
                    </td>
                    <td width="9%" style="text-align: right; color: blue; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap class="silver_even_main" >
                        <button style="width: 100px" type="button" onclick="javascript:getResults();"><b style="font-weight: bold; font-size: 14px; vertical-align: middle">عرض</b>&ensp;<img src="images/icons/refresh.png" width="20" height="20" style="vertical-align: middle"/></button>
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
                    text: ''
                    },
                        xAxis: {
                        categories: <%=ratingCategories%>
                                    },
                                        yAxis: {
                                        min: 0,
                                            title: {
                                        text: 'انواع الطلبات'
                                    }
                                    },
                                        tooltip: {
                                        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                                                pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                                        '<td style="padding:0"><b>{point.y}</b></td></tr>',
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
            <table align="<%=align%>" dir="<%=dir%>" width="100%" id="EmployeeTypesTag">
                <thead>
                    <tr>
                        <th style="color: #005599 !important;font-weight: bold; font-size: 14px;">اسم الموظف</th>
                            <%
                                for (String ticketTypeID : ticketTypeIDs) {
                            %>
                        <th style="color: #005599 !important;font-weight: bold; font-size: 14px;">
                            <%=ticketTypeMap.get(ticketTypeID)%>
                        </th>
                        <%
                            }
                        %>
                        <th style="color: #005599 !important; font-weight: bold; font-size: 14px;"> Total </th>
                    </tr>
                <thead>
                <tbody >  
                    <%
                        int[] total = new int[ticketTypeIDs.length];
                        int totalForUsr, totalOfAll = 0, temp, index;
                        for (WebBusinessObject wbo : graphResult) {
                    %>
                    <tr>
                        <td>
                            <%=wbo.getAttribute("userName")%>
                        </td>
                        <%
                            totalForUsr = 0;
                            index = 0;
                            for (String ticketTypeID : ticketTypeIDs) {
                                temp = Integer.parseInt(wbo.getAttribute("total" + ticketTypeID) + "");
                                totalForUsr += temp;
                                total[index] += temp;
                                index++;
                        %>
                        <td>
                            <a href="#" onclick="JavaScript: popupViewComplaints('<%=wbo.getAttribute("userID")%>', '<%=ticketTypeID%>', '<%=ticketTypeMap.get(ticketTypeID)%>', '<%=wbo.getAttribute("userName")%>');"><%=temp%></a>
                        </td>
                        <%
                            }
                            totalOfAll += totalForUsr;
                        %>
                        <td style="background-color: #FFBAAB;"> <%=totalForUsr%> </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
                <tfoot>
                    <tr style="background-color: #FFBAAB;">
                        <th style="color: #005599 !important; font-weight: bold; font-size: 14px;"> Total </th>
                            <%
                                for (int t : total) {
                            %>
                        <th style="color: #005599 !important; font-weight: bold; font-size: 14px;"> <%=t%> </th>
                            <%
                                }
                            %>
                        <th style="color: #005599 !important; font-weight: bold; font-size: 14px;"> <%=totalOfAll%> </th>
                    </tr>
                </tfoot>
            </table>
        </div>
        <%
        }
        %>
    </body>
</html>