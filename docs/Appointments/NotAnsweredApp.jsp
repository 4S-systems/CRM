<%-- 
    Document   : NotAnsweredApp
    Created on : Jan 24, 2018, 8:43:18 AM
    Author     : walid
--%>

<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    String beDate = (String) request.getAttribute("beginDate");
    String eDate = (String) request.getAttribute("endDate");
    
    ArrayList<WebBusinessObject> result = (ArrayList<WebBusinessObject>) request.getAttribute("result");
    String jsonCallResultText = (String) request.getAttribute("jsonCallResultText");
    
    Calendar cal = Calendar.getInstance();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    String nowDate = sdf.format(cal.getTime());
    
    String str = (String)request.getAttribute("calTyp");
            
    String fromD = (String) request.getAttribute("beginDate");
    String toDate = (String) request.getAttribute("endDate");
        
    String stat = (String) request.getSession().getAttribute("currentMode");
    String title,  beginDate, endDate, searchButton, dir, cltNm, appDate, note, empNm, mob,
            calTyp;
    
    if (stat.equals("En")) {
        title = " My Appointments Report";
        beginDate = "From Date";
        endDate = "To Date";
        searchButton = "Search";
        dir = "LTR";
        cltNm = "Client Name";
        appDate = "Appointment Date";
        note = "Notes";
        empNm = "Employee Name";
        mob = "Mobile";
        calTyp = "Appointment Result";
    } else {
        title = " متابعاتى";
        beginDate = "من تاريخ";
        endDate = "الى تاريخ";
        searchButton = "بحث";
        dir = "RTL";
        cltNm = "اسم العميل";
        appDate = "وقت المتابعه";
        note = "ملاحظات";
        empNm = "اسم الموظف";
        mob = "الموبايل";
        calTyp = "نتيجه المتابعه";
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Not Answered Appointments</title>
        <%--<link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">--%>
        
        
        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet">
        
        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <link href="js/select2.min.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" language="javascript" src="js/select2.min.js"></script>
        
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        
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
        <SCRIPT LANGUAGE="JavaScript" type="text/javascript">
            $(document).ready(function() {
                $('#Employee').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[20, 40, 70, 100, -1], [20, 40, 70, 100, "All"]],
                    iDisplayLength: 20,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[0, "asc"]]
                }).show();
                $(".dataTables_length, .dataTables_info").css("float", "left");
                $(".dataTables_filter, .dataTables_paginate").css("float", "right");
                
                var str = '<%=str%>';
                
                console.log(" str = " + str);
                if(str === "WN"){
                    $("#calTyp option[value='WN']").prop("selected", true);   
                } else if(str === "AN"){
                    $("#calTyp option[value='AN']").prop("selected", true);
                } else {
                    $("#calTyp option[value='NA']").prop("selected", true);  
                }
                
                $("#calTyp").select2();
                
                <%--chart = new Highcharts.Chart({
                    chart: {
                        renderTo: 'containerPie',
                        plotBackgroundColor: null,
                        plotBorderWidth: null,
                        plotShadow: false
                    },
                    title: {
                        text: null
                    },
                    tooltip: {
                        formatter: function () {
                            return '<b>' + this.point.name + '</b>: ' + '%' + Highcharts.numberFormat(this.percentage, 3);
                        }
                    },
                    plotOptions: {
                        pie: {
                            allowPointSelect: true,
                            cursor: 'pointer',
                            dataLabels: {
                                enabled: true,
                                color: '#000000',
                                connectorColor: '#000000',
                                formatter: function () {
                                    return '<b>' + this.point.name + '</b>: ' + '%' + Highcharts.numberFormat(this.percentage, 3);
                                }
                            }
                        }
                    },
                    series: [{
                            type: 'pie',
                            data: <%=jsonCallResultText%>
                        }]
                });--%>
                
            });
            
            $(function () {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: "d",
                    dateFormat: "yy/mm/dd"
                });
            });
                
            function getNotAnsweredApp() {
                var beginDate = $("#beginDate").val();
                var endDate = $("#endDate").val();
                var str = $("#calTyp option:selected").val();
                document.COMP_FORM.action = "<%=context%>/AppointmentServlet?op=getAllNotAnsweredAppointments&beginDate=" + beginDate + "&endDate=" + endDate + "&calTyp" + str;
                document.COMP_FORM.submit();
            }
        </script>
    </head>
    <body>
        <form NAME="COMP_FORM" METHOD="POST">
            <table align="center" width="80%">
                <tr>
                    <td class="td">
                        <fieldset >
                            <legend align="center">
                                <table dir="rtl" align="center">
                                    <tr>
                                        <td class="td">
                                            <font color="blue" size="6"> <%=title%>
                                            </font>
                                        </td>
                                    </tr>
                                </table>
                            </legend>
                            <table align="center" dir="rtl" width="570" cellspacing="2" cellpadding="1">
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="50%">
                                        <b><font size=3 color="white"> <%=beginDate%></b>
                                    </td>
                                    <td   class="blueBorder blueHeaderTD" style="font-size:18px;"width="50%">
                                        <b> <font size=3 color="white"> <%=endDate%> </b>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                                        <%
                                            Calendar c = Calendar.getInstance();
                                        %>
                                        <input id="beginDate" name="beginDate" type="text" value="<%=fromD != null ? fromD : nowDate%>" style="margin: 5px;" readonly/>
                                        <br><br>
                                    </td>
                                    <td bgcolor="#dedede" style="text-align:center" valign="middle">
                                        <input id="endDate" name="endDate" type="text" value="<%=toDate != null ? toDate : nowDate%>" style="margin: 5px;" readonly/>
                                        <br><br>
                                    </td>
                                </tr>
                                <tr class="blueBorder blueHeaderTD" style="font-size:18px;" width="100%">
                                    <td colspan="2">
                                        <b><font size=3 color="white"> <%=calTyp%></b>
                                    </td>
                                </tr>
                                <tr class="blueBorder blueHeaderTD" style="font-size:18px;" width="100%">
                                    <td colspan="2">
                                        <select id="calTyp" name="calTyp" style="font-size: 14px; width: 50%; text-align: center;">
                                            <option id="notAnsewered" value="NA"> Not Answered </option>
                                            <option id="Wnumber" value="WN"> Wrong Number </option>
                                            <option id="ANnumber" value="AN"> Answered </option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" class="td" colspan="3">
                                        <br/><br/>
                                        <button  onclick="JavaScript: getNotAnsweredApp();" style="color: #000;font-size:15;margin-top: 20px;font-weight:bold; "><%=searchButton%><IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                    </td>
                </tr>
            </table>
        </form>
        <div id="containerPie" style="width: 80%; height: 50%; margin: 0 auto"></div>
        <script language="JavaScript">
            $(document).ready(function () {
                chart = new Highcharts.Chart({
                    chart: {
                        renderTo: 'containerPie',
                        plotBackgroundColor: null,
                        plotBorderWidth: null,
                        plotShadow: false
                    },
                    title: {
                        text: null
                    },
                    tooltip: {
                        formatter: function () {
                            return '<b>' + this.point.name + '</b>: ' + '%' + Highcharts.numberFormat(this.percentage, 3);
                        }
                    },
                    plotOptions: {
                        pie: {
                            allowPointSelect: true,
                            cursor: 'pointer',
                            dataLabels: {
                                enabled: true,
                                color: '#000000',
                                connectorColor: '#000000',
                                formatter: function () {
                                    return '<b>' + this.point.name + '</b>: ' + '%' + Highcharts.numberFormat(this.percentage, 3);
                                }
                            }
                        }
                    },
                    series: [{
                            type: 'pie',
                            data: <%=jsonCallResultText%>
                        }]
                });
            });
        </script>
        <%if (result != null && result.size() > 0) {%>
            <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showResults">
                <TABLE ALIGN="center" dir="<%=dir%>" WIDTH="100%" id="Employee" style="">
                    <thead>
                        <tr>
                            <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=cltNm%></th>
                            <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=mob%></th>
                            <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=appDate%></th>
                            <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=note%></th>
                            <th style="color: #005599 !important;font: 14px; font-weight: bold;"><%=empNm%></th>
                        </tr>
                    <thead>
                    <tbody >  
                        <%
                            for (WebBusinessObject wbo : result) {
                        %>
                        <tr>
                            <TD>
                                <%=wbo.getAttribute("clientName")%>
                                <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("clientId")%>" target="blank">
                                    <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"/>
                                </a>
                            </TD>
                            
                            <TD>
                                <%=wbo.getAttribute("mobile")%>
                            </TD>

                            <TD>
                                <%=wbo.getAttribute("appDate").toString().split(" ")[0]%>
                            </TD>

                            <TD>
                                <%=wbo.getAttribute("comment")%>
                            </TD>
                            
                            <TD>
                                <%=wbo.getAttribute("empName")%>
                            </TD>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>  
                </TABLE>
            </div>
        <%}%>                            
    </body>
</html>
