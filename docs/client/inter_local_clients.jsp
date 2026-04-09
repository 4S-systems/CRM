<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    
    ArrayList<WebBusinessObject> result = (ArrayList<WebBusinessObject>) request.getAttribute("interLocalClientsLst");
    String jsonCallResultText = (String) request.getAttribute("jsonCallResultText");
    WebBusinessObject wbo = new WebBusinessObject();
  
    
    String str = (String)request.getAttribute("calTyp");

        
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
    </head>
    <body>
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
                <TABLE ALIGN="center" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" width="50%">
                    <thead>
                        <tr style="width:50%;background-color:#C8D8F8; font-size: 20px; font-weight: bold;">
                            <td style="font-size: 20px; font-weight: bold;">Clients Type</td>
                            <td style="font-size: 20px; font-weight: bold;"> No Of Clients</td>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (int i=0; i< result.size(); i++){
                                wbo = result.get(i);
                        %>
                        <TR style="border: 1px solid black;" >
                            <TD style="font-size: 15px; color: blue;">
                                <%=wbo.getAttribute("clientTyp")%>
                            </TD>
                            <TD style="font-size: 20px;">
                                <%
                                    if(wbo.getAttribute("clientTyp").equals("International")){
                                %>
                                    <a href="<%=context%>/ClientServlet?op=InternationalClients" target="blank">
                                        <font style="font-size: 17px;"><%=wbo.getAttribute("Total_Clients")%></font>
                                    </a>
                                <%} else {%>
                                    <%=wbo.getAttribute("Total_Clients")%>
                                <%}%>
                            </TD>

                        </TR>

                        <%}%>
                    </tbody>
                </TABLE>
            </div>
        <%}%>                            
    </body>
</html>
