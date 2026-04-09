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
    ArrayList<String> TypesTagNameList = (ArrayList<String>) request.getAttribute("TypesTagNameList");

    ArrayList<WebBusinessObject> EmpDetails = (ArrayList<WebBusinessObject>) request.getAttribute("EmpDetails");

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
                oTable = $('#EmployeeTypesTag').DataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    dom: 'Bfrtip',
                    buttons: [
                        'excel'
                    ]
                });

                dTable = $('#EmployeeDetails').DataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                });

            });

            function getResults() {
                var depratmentID = $("#departmentID").val();
                var beginDate = $("#fromDate").val();
                var endDate = $("#toDate").val();

                document.stat_form.action = "<%=context%>/ClientServlet?op=ViewClientsAppntmsPerEmployee&depratmentID=" + depratmentID + "&beginDate=" + beginDate + "&endDate=" + endDate + "&userID=";
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
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="98%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4">
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
                    <TD width="3%" STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        الأدارة :
                    </TD>
                    <TD width="23%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <select id="departmentID" name="departmentID" style="font-size: 14px; width: 100%">
                            <sw:WBOOptionList wboList="<%=departments%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=departmentID%>" />
                        </select>
                    </TD>
                    <TD width="9%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <button style="width: 100px" type="button" onclick="javascript:getResults();"><b style="font-weight: bold; font-size: 14px; vertical-align: middle">عرض</b>&ensp;<img src="images/icons/refresh.png" width="20" height="20" style="vertical-align: middle"/></button>
                    </TD>
                </TR>
            </TABLE>
        </FORM>
        <br>

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
                        text: 'معدلات التوزيع للموظفين'
                    },
                    xAxis: {
                        categories: <%=ratingCategories%>
                    },
                    yAxis: {
                        min: 0,
                        title: {
                            text: 'انواع التوزيع'
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
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" id="EmployeeTypesTag" style="">
                <thead>
                    <tr>
                        <th style="color: #005599 !important;font-weight: bold; font-size: 14px;">اسم الموظف</th>
                            <%for (String TypeTagName : TypesTagNameList) {%>
                        <th style="color: #005599 !important;font-weight: bold; font-size: 14px;">
                            <%=TypeTagName%>
                        </th>
                        <%}%>

                        <th style="color: #005599 !important; font-weight: bold; font-size: 14px;"> Total </th>

                    </tr>
                <thead>
                <tbody >  
                    <%
                        int[] totalsArray = new int[TypesTagNameList.size()];
                        int counter = 0;
                        int totalForUsr = 0;
                        
                        for (WebBusinessObject wbo : graphResult) {
                    %>
                    <tr>
                        <TD>
                            <a target="_blanck" href="<%=context%>/ClientServlet?op=ViewClientsAppntmsPerEmployee&departmentID=<%=departmentID%>&beginDate=<%=fromDate%>&endDate=<%=toDate%>&userID=<%=wbo.getAttribute("userID")%>"><%=wbo.getAttribute("userName")%></a>
                            <!--<a href='JavaScript:getDetails("<%=wbo.getAttribute("userID")%>")'><%=wbo.getAttribute("userName")%></a>-->
                        </TD>

                        <%for (String TypeTagName : TypesTagNameList) {  
                            totalForUsr += Integer.parseInt(wbo.getAttribute(TypeTagName.toString().replaceAll("\\s", "")).toString());
                        %>
                        <TD>
                            <a target="_blanck" href="<%=context%>/ClientServlet?op=ViewEmpClientAppntmnts&departmentID=<%=departmentID%>&beginDate=<%=fromDate%>&endDate=<%=toDate%>&userID=<%=wbo.getAttribute("userID")%>&userName=<%=wbo.getAttribute("userName")%>&distType=<%=TypeTagName%>"><%=wbo.getAttribute(TypeTagName.toString().replaceAll("\\s", ""))%></a>
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
                        for(int i=0; i<TypesTagNameList.size(); i++){
                            totalForUsrs += totalsArray[i];
                        %>
                        <td> <a target="blank" href="<%=context%>/ReportsServletThree?op=clientClassificationReport&clsUncls=cls&fromDate=<%=fromDate.replaceAll("/", "-")%>&toDate=<%=toDate.replaceAll("/", "-")%>&dateType=registration&smry=0&campaignID=&projectID=&rateID=&departmentID=<%=departmentID%>&type=<%=TypesTagNameList.get(i)%>&employeeID="
                                style="font-size: 20px; vertical-align: middle;"><%=totalsArray[i]%></a>
                        <a target="blank" href="<%=context%>/ReportsServletThree?op=communicationChannelsClientsAnalysis&clsUncls=cls&fromDate=<%=fromDate.replaceAll("/", "-")%>&toDate=<%=toDate.replaceAll("/", "-")%>&dateType=registration&smry=0&campaignID=&projectID=&rateID=&departmentID=<%=departmentID%>&type=<%=TypesTagNameList.get(i)%>&employeeID=">
                            <img src="images/icons/channel-icon.png" style="width: 25px; vertical-align: middle; float: left;"/>
                        </a>
                        </td>
                        <%}%>  
                        <td> <%=totalForUsrs%> </td>
                    </tr>
                </tbody>
            </TABLE>
        </div>

        <br>

        <%if (EmpDetails != null && EmpDetails.size() > 0) {%>
        <div style="width: 90%;margin-right: auto;margin-left: auto;" id="showResults">
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" id="EmployeeDetails">
                <thead>
                    <tr>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">اسم الموظف</th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">اجمالي عدد العملاء</th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">عدد المكالمات</th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">اجمالي وقت المكالمان</th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">عدد المقابلات</th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">اجمالي وقت المقابلات</th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">عدد المكالمات الغير مجابة</th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">نوع المكالمات</th>
                        <th></th>
                    </tr>
                <thead>
                <tbody >  
                    <%
                        for (WebBusinessObject wbo : EmpDetails) {
                    %>
                    <tr>
                        <TD>
                            <a target="_blanck" href="<%=context%>/ClientServlet?op=ViewEmpClientAppntmnts&departmentID=<%=departmentID%>&beginDate=<%=fromDate%>&endDate=<%=toDate%>&userID=<%=wbo.getAttribute("userID")%>&userName=<%=wbo.getAttribute("userName")%>&distType=<%=wbo.getAttribute("TYPE_TAG")%>"><%=wbo.getAttribute("userName")%></a>
                        </TD>

                        <TD>
                            <%=wbo.getAttribute("total_client")%>
                        </TD>

                        <TD>
                            <a target="_blanck" href="<%=context%>/ClientServlet?op=getEmpDistCalls&beginDate=<%=fromDate%>&endDate=<%=toDate%>&userID=<%=wbo.getAttribute("userID")%>&userName=<%=wbo.getAttribute("userName")%>&TypeTag=<%=wbo.getAttribute("TYPE_TAG")%>"><%=wbo.getAttribute("call")%></a>
                            <!--<%=wbo.getAttribute("call")%>-->
                        </TD>

                        <TD>
                            <%=wbo.getAttribute("call_duration")%>
                        </TD>

                        <TD>
                            <a target="_blanck" href="<%=context%>/ClientServlet?op=getEmpDistMeeting&beginDate=<%=fromDate%>&endDate=<%=toDate%>&userID=<%=wbo.getAttribute("userID")%>&userName=<%=wbo.getAttribute("userName")%>&TypeTag=<%=wbo.getAttribute("TYPE_TAG")%>"><%=wbo.getAttribute("meeting")%></a>
                            <!--<%=wbo.getAttribute("meeting")%>-->
                        </TD>

                        <TD>
                            <%=wbo.getAttribute("meeting_duration")%>
                        </TD>

                        <TD>
                            <%=wbo.getAttribute("not_answred")%>
                        </TD>

                        <TD>
                            <%=wbo.getAttribute("TYPE_TAG")%>
                        </TD>

                        <TD>
                            <img src="images/<%=wbo.getAttribute("Tag_Color")%>" style="width: 30px; height: 30px">
                        </TD>  
                    </tr>
                    <%
                        }
                    %>
                </tbody>  
            </TABLE>
        </div>
        <%}%>
        <%}%>
    </body>
</html>