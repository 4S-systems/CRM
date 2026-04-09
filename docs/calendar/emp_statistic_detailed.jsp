<%@page import="java.text.DecimalFormat"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<!DOCTYPE html>

<html>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">    

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        ArrayList<WebBusinessObject> departments = (ArrayList<WebBusinessObject>) request.getAttribute("departments");
        String departmentID = request.getAttribute("departmentID") != null ? (String) request.getAttribute("departmentID") : "";
        String beginDate = (String) request.getAttribute("beginDate");
        String endDate = (String) request.getAttribute("endDate");

        ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        String nowDate = sdf.format(cal.getTime());
        DecimalFormat df = new DecimalFormat("0.00");

        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null, title, employeeNo, callsNo, totalCallsTime, meetingNo,meetings, totalMeetingTime, totalClientsNo,
                inter, from, to, department, noDepartment, display, visitClients, tsMeetingNo, slsMeetingNo, total, bkrMeetingNo;
        String salesPercent,teleSPercent,saleInfo,teleInfo;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            title = "Detailed Employees Statistics";
            employeeNo = "Employee Name";
            callsNo = "Answered Call";
            totalCallsTime = "Total Calls Time";
            meetingNo = "Follow-up Visits";
            meetings="Completed Visits";
            totalMeetingTime = "Total Visits Time";
            totalClientsNo = "Total Clients No";
            inter = "Interval:";
            from = "From :";
            to = "To :";
            department = "Department :";
            noDepartment = "No Department";
            display = "Display";
            visitClients = "Visits Clients";
            tsMeetingNo = "TS Visits";
            slsMeetingNo = "SLS Visits";
            total = "Total";
            bkrMeetingNo = "BKR Visits";
            salesPercent="Sls/Bkr visits percentage";
            teleSPercent="Tls visits percentage";
            teleInfo="telesales visits over number of answered calls";
            saleInfo="sales and broker visits over number of answered calls";
        } else {
            align = "center";
            dir = "RTL";
            title = "احصائيات العاملين المفصل";
            employeeNo = "اسم الموظف";
            callsNo = "المكالمات المجابة";
            totalCallsTime = "اجمالى وقت المكالمات";
            meetingNo = "زيارات متكررة";
            meetings="عدد الزيارات ";
            totalMeetingTime = "اجمالى وقت الزيارات";
            totalClientsNo = "اجمالى عدد العملاء";
            inter = "خلال:";
            from = "من :";
            to = "الى :";
            department = "الاداره :";
            noDepartment = "لا توجد اداره";
            display = "عرض";
            visitClients = "عملاء الزيارات";
            tsMeetingNo = "زيارات TS";
            slsMeetingNo = "زيارات SLS";
            total = "أجمالي";
            bkrMeetingNo = "زيارات BKR";
            salesPercent="نسبة الزيارات لSLS/BKR";
            teleSPercent=" نسبة الزيارات لTS";
            teleInfo="نسبة زيارات TS على عدد المكالمات المجابة ";
            saleInfo="نسبة ريارات ال SLS و ال BKR على عدد المكالمات المجابة ";
        }
    %>
    <head>
        <TITLE>System Users List</TITLE>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <link href="js/select2.min.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" language="javascript" src="js/select2.min.js"></script>
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

        <script type="text/javascript">
            $(function () {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });

            var oTable;
            $(document).ready(function () {
                $("#Employee").css("display", "none");
                oTable = $('#Employee').dataTable({
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
                $("#Emplyee").css("display", "");
                $("#showResults").val("show");

                var depratmentID = $("#departmentID").val();
                var beginDate = $("#beginDate").val();
                var endDate = $("#endDate").val();

                document.stat_form.action = "<%=context%>/AppointmentServlet?op=getCallCenterStatisticsDetail&depratmentID=" + depratmentID + "&beginDate=" + beginDate + "&endDate=" + endDate;
                document.stat_form.submit();
            }

            function exportToExcel() {
                document.stat_form.action = "<%=context%>/AppointmentServlet?op=getEmployeeStatisticsDetailExcel&depratmentID=" + $("#departmentID").val()
                        + "&beginDate=" + $("#beginDate").val() + "&endDate=" + $("#endDate").val();
                document.stat_form.submit();
            }
        </script>
    </head>
    <body>
        <fieldset class="set">
            <legend>
                <font style="font-weight: bold; color: blue;" size="5"><%=title%>
            </legend>
            <form name="stat_form" method="POST">
                <table align="<%=align%>" dir="<%=dir%>" width="70%" cellpadding="0" cellspacing="0" style="border: 2px solid #d3d5d4">
                    <tr>
                        <td width="8%" style="text-align: center; color: blue; font-size: 16px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <div> 
                                <%=inter%>
                            </div>
                        </td>
                        <td width="3%" style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <%=from%>
                        </td>
                        <td width="9%" style="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <input id="beginDate" name="beginDate" type="text" value="<%=beginDate != null ? beginDate : nowDate%>" style="margin: 5px;" />
                        </td>
                        <td width="3%" style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <%=to%>
                        </td>
                        <td width="15%" style="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <input id="endDate" name="endDate" type="text" value="<%=endDate != null ? endDate : nowDate%>" style="margin: 5px;" />
                        </td>
                        <td width="3%" style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <%=department%>
                        </td>
                        <td style="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <select id="departmentID" name="departmentID" style="font-size: 14px; width: 100%">
                                <%if (departments != null && !departments.isEmpty()){%>
                                    <sw:WBOOptionList wboList="<%=departments%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=departmentID%>" />
                                <%} else {%>
                                    <option><%=noDepartment%></option>
                                <%}%>
                            </select>
                        </td>
                        <td width="9%" style="text-align: right; color: blue; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <button style="width: 100px" type="button" onclick="javascript:getResults();"><b style="font-weight: bold; font-size: 14px; vertical-align: middle"><%=display%></b>&ensp;<img src="images/icons/refresh.png" width="20" height="20" style="vertical-align: middle"/></button>
                            <button style="width: 100px" type="button" onclick="javascript: exportToExcel();"><b style="font-weight: bold; font-size: 14px; vertical-align: middle">Excel</b>&ensp;<img src="images/icons/excel.png" width="20" height="20" style="vertical-align: middle"/></button>
                        </td>
                    </tr>
                </table>
            </form>
            <br/>
            <%if (data != null && data.size() > 0) {%>
            <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showResults">
                <table align="<%=align%>" dir="<%=dir%>" width="100%" id="Employee" style="">
                    <thead>
                        <tr>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;"><%=employeeNo%></th>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;"><%=callsNo%> </th>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;"> <%=totalCallsTime%> </th>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;"><%=meetings%> </th>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;"><%=meetingNo%> </th>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;"><%=tsMeetingNo%> </th>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;"><%=slsMeetingNo%> </th>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;"><%=bkrMeetingNo%> </th>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;"> <%=totalMeetingTime%> </th>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;"> <%=totalClientsNo%></th>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;"> <%=visitClients%></th>
                            <th title="<%=saleInfo%>" style="color: #005599 !important;font-size: 15px; font-weight: bold;"> <%=salesPercent%></th>
                            <th title='<%=teleInfo%>' style="color: #005599 !important;font-size: 15px; font-weight: bold;"> <%=teleSPercent%></th>
                        </tr>
                    <thead>
                    <tbody >  
                        <%
                            for (WebBusinessObject wbo : data) {
                                double sls=Double.parseDouble(wbo.getAttribute("slsMeeting").toString());
                                double bkr=Double.parseDouble(wbo.getAttribute("bkrMeeting").toString());
                                double ts=Double.parseDouble(wbo.getAttribute("tsMeeting").toString());
                                double call=Double.parseDouble(wbo.getAttribute("call").toString());
                                double salesPerc=0.0; double telesalesPerc=0.0;
                                if (call!=0.0){
                                 salesPerc=(sls+bkr)*100/call;
                                 telesalesPerc=ts*100/call;
                                }
                                
                        %>
                        <tr>
                            <td>
                                <%=wbo.getAttribute("userName")%>
                            </td>
                            <td>
                                <a target="blank" href="<%=context%>/AppointmentServlet?op=getEmpClientsDetails&type=call&departmentID=<%=departmentID%>&beginDate=<%=beginDate%>&endDate=<%=endDate%>&userID=<%=wbo.getAttribute("userID")%>&userName=<%=wbo.getAttribute("userName")%>">
                                     <%=wbo.getAttribute("call")%> 
                                </a>
                            </td>
                            <td>
                                <%=df.format(Double.parseDouble(wbo.getAttribute("call_duration").toString()) / 60.0)%>
                            </td>
                            <td>
                                <a target="blank" href="<%=context%>/AppointmentServlet?op=getEmpClientsDetails&type=meeting&departmentID=<%=departmentID%>&beginDate=<%=beginDate%>&endDate=<%=endDate%>&userID=<%=wbo.getAttribute("userID")%>&userName=<%=wbo.getAttribute("userName")%>">
                                     <%=wbo.getAttribute("meeting")%> 
                                </a>
                            </td>
                            <td>
                                <%= new Integer(wbo.getAttribute("meeting").toString()) - new Integer(wbo.getAttribute("visitClientsCount").toString())%>                                
                            </td>
                            <td>
                                <a target="blank" href="<%=context%>/AppointmentServlet?op=getEmpClientsDetails&type=meeting&departmentID=<%=departmentID%>&beginDate=<%=beginDate%>&endDate=<%=endDate%>&userID=<%=wbo.getAttribute("userID")%>&userName=<%=wbo.getAttribute("userName")%>">
                                     <%=wbo.getAttribute("tsMeeting")%> 
                                </a>
                            </td>
                            <td>
                                <a target="blank" href="<%=context%>/AppointmentServlet?op=getEmpClientsDetails&type=meeting&departmentID=<%=departmentID%>&beginDate=<%=beginDate%>&endDate=<%=endDate%>&userID=<%=wbo.getAttribute("userID")%>&userName=<%=wbo.getAttribute("userName")%>">
                                     <%=wbo.getAttribute("slsMeeting")%> 
                                </a>
                            </td>
                            <td>
                                <a target="blank" href="<%=context%>/AppointmentServlet?op=getEmpClientsDetails&type=meeting&departmentID=<%=departmentID%>&beginDate=<%=beginDate%>&endDate=<%=endDate%>&userID=<%=wbo.getAttribute("userID")%>&userName=<%=wbo.getAttribute("userName")%>">
                                     <%=wbo.getAttribute("bkrMeeting")%> 
                                </a>
                            </td>
                            <td>
                                <%=df.format(Double.parseDouble(wbo.getAttribute("meeting_duration").toString()) / 60.0)%>
                            </td>
                            <td>
                                <%=wbo.getAttribute("total_clients")%>
                            </td>
                            <td>
                                <%=wbo.getAttribute("visitClientsCount")%>
                            </td>
                            <td>
                               % <%=df.format(salesPerc)%> 
                            </td>
                            <td>
                                % <%=df.format(telesalesPerc)%> 
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>  
                    <tfoot>
                        <tr>
                            <td style="font-size: 22px;">
                                <%=total%>
                            </td>
                            <td style="font-size: 22px;">
                                <b><%=request.getAttribute("callSum")%></b>
                            </td>
                            <td style="font-size: 22px;">
                                <b><%=df.format(Double.parseDouble((String) request.getAttribute("callDurationSum")) / 60.0)%></b>
                            </td>
                            <td style="font-size: 22px;">
                                <b><%=request.getAttribute("meetingSum")%></b>
                            </td>
                            <td style="font-size: 22px;">
                                <b><%=request.getAttribute("tsMeetingSum")%></b>
                            </td>
                            <td style="font-size: 22px;">
                                <b><%=request.getAttribute("slsMeetingSum")%></b>
                            </td>
                            <td style="font-size: 22px;">
                                <b><%=request.getAttribute("bkrMeetingSum")%></b>
                            </td>
                            <td style="font-size: 22px;">
                                <b><%=df.format(Double.parseDouble((String) request.getAttribute("meetingDurationSum")) / 60.0)%></b>
                            </td>
                            <td style="font-size: 22px;">
                                <b><%=request.getAttribute("totalClientsSum")%></b>
                            </td>
                            <td style="font-size: 22px;">
                                <b><%=request.getAttribute("visitClientsSum")%></b>
                            </td>
                        </tr>
                    </tfoot>
                </table>
                <br/>
            </div>
            <%}%>
        </fieldset>    
    </body>
</html>
