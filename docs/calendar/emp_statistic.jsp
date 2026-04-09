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

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null, tit, empNm, callsNo, totalCalsTim, meetingNo, meetings, totalmeetTim, totalClntsNo,
                inter, from, to, dep, noDep, disp, visitClients, total, callClients, clientsPresent, callsNon, totalCalls, totalNewUnCalls, totalNewCalls;

        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            tit = "Employees Statistics";
            empNm = "Employee Name";
            callsNo = "Hot Line";
            totalCalsTim = "Total Calls Time";
            meetingNo = "Repeated Visits";
            meetings = "Completed Visits";
            totalmeetTim = "Total";
            totalClntsNo = "Total Clients No";
            inter = "Interval:";
            from = "From :";
            to = "To :";
            dep = "Department :";
            noDep = "No Department";
            disp = "Display";
            visitClients = "Visits Clients";
            total = "Total";
            callClients = "Call Clients";
            clientsPresent = "Clients precentage";
            callsNon = "Walk In";
            totalCalls = "InDirect Lead";
            totalNewCalls = "Rated Calls";
            totalNewUnCalls = "UnRated Calls";
        } else {
            align = "center";
            dir = "RTL";
            tit = "احصائيات العاملين";
            empNm = "اسم الموظف";
            callsNo = "المكالمات المجابة";
            totalCalsTim = "اجمالى وقت المكالمات";
            meetingNo = "الزيارات المتكررة";
            meetings = "عدد الزيارات ";
            totalmeetTim = "اجمالى وقت الزيارات";
            totalClntsNo = "اجمالى عدد العملاء";
            inter = "خلال:";
            from = "من :";
            to = "الى :";
            dep = "الاداره :";
            noDep = "لا توجد اداره";
            disp = "عرض";
            visitClients = "عملاء الزيارات";
            total = "أجمالي";
            callClients = "العملاء الموزعين";
            clientsPresent = "نسبة التحويل";
            callsNon = "المكالمات الغير المجابة";
            totalCalls = "اجمالي المكالمات";
            totalNewCalls = "اجمالي المكالمات";
            totalNewUnCalls = "اجمالي عدم الرد ";
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

                document.stat_form.action = "<%=context%>/AppointmentServlet?op=viewCallCenterStatistics&depratmentID=" + depratmentID + "&beginDate=" + beginDate + "&endDate=" + endDate;
                document.stat_form.submit();
            }

            function exportToExcel() {
                document.stat_form.action = "<%=context%>/AppointmentServlet?op=getEmployeeStatisticsExcel&depratmentID=" + $("#departmentID").val()
                        + "&beginDate=" + $("#beginDate").val() + "&endDate=" + $("#endDate").val();
                document.stat_form.submit();
            }
        </script>
    </head>

    <body>
        <fieldset class="set">
            <legend>
                <font style="font-weight: bold; color: blue;" size="5"><%=tit%>
            </legend>
            <FORM NAME="stat_form" METHOD="POST">
                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="70%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4">
                    <TR>
                        <TD width="8%" STYLE="text-align: center; color: blue; font-size: 16px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <DIV> 
                                <%=inter%>
                            </DIV>
                        </TD>
                        <TD width="3%" STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <%=from%>
                        </TD>
                        <TD width="9%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <input id="beginDate" name="beginDate" type="text" value="<%=beginDate != null ? beginDate : nowDate%>" style="margin: 5px;" />
                        </TD>
                        <TD width="3%" STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <%=to%>
                        </TD>
                        <TD width="15%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <input id="endDate" name="endDate" type="text" value="<%=endDate != null ? endDate : nowDate%>" style="margin: 5px;" />
                        </TD>
                        <TD width="3%" STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <%=dep%>
                        </TD>
                        <TD STYLE="text-align: right; color: blue; font-size: 14px;width: 200px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <select id="departmentID" name="departmentID" style="font-size: 14px; width: 100%">
                                <%if (departments != null && !departments.isEmpty()) {%>
                                <sw:WBOOptionList wboList="<%=departments%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=departmentID%>" />
                                <%} else {%>
                                <option><%=noDep%></option>
                                <%}%>
                            </select>
                        </TD>
                        <TD width="9%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <button style="width: 100px" type="button" onclick="javascript:getResults();"><b style="font-weight: bold; font-size: 14px; vertical-align: middle"><%=disp%></b>&ensp;<img src="images/icons/refresh.png" width="20" height="20" style="vertical-align: middle"/></button>
                            <button style="width: 100px" type="button" onclick="javascript: exportToExcel();"><b style="font-weight: bold; font-size: 14px; vertical-align: middle">Excel</b>&ensp;<img src="images/icons/excel.png" width="20" height="20" style="vertical-align: middle"/></button>
                        </TD>
                    </tr>
                </table>
            </form>

            <br/>

            <%if (data != null && data.size() > 0) {%>
            <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showResults">
                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" id="Employee" style="">
                    <thead>
                        <tr>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;"><%=empNm%></th>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;">Title</th>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;">Total All Client</th>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;"><%=totalNewCalls%></th>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;"><%=totalNewUnCalls%></th>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;"><%=callsNo%> </th>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;"><%=callsNon%> </th>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;"><%=totalCalls%> </th>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;"> Reserved </th>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;"> Sold </th>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;"> Reflux </th>
                        </tr>
                    <thead>
                    <tbody >  
                        <%
                            for (WebBusinessObject wbo : data) {
                        %>
                        <tr>
                            <TD>
                                <%=wbo.getAttribute("userName")%>
                            </TD>
                            
                            <TD>
                                <%=wbo.getAttribute("group_name")%>
                            </TD>


                            <TD bgcolor="#ffeb99">
                                <a target="blank" href="<%=context%>/AppointmentServlet?op=getEmpUniqueAppntmnt&departmentID=<%=departmentID%>&userID=<%=wbo.getAttribute("userID")%>&userName=<%=wbo.getAttribute("userName")%>&total=All&beginDate=<%=beginDate%>&endDate=<%=endDate%>">

                                    <%=wbo.getAttribute("call")%> 
                                </a>
                            </TD>

                            <TD bgcolor="#ffeb99">
                                <a target="blank" href="<%=context%>/AppointmentServlet?op=getEmpUniqueAppntmnt&departmentID=<%=departmentID%>&userID=<%=wbo.getAttribute("userID")%>&userName=<%=wbo.getAttribute("userName")%>&total=Apoinment&beginDate=<%=beginDate%>&endDate=<%=endDate%>">
                                    <%=wbo.getAttribute("call_duration")%> 
                                </a>
                            </TD>

                            <TD bgcolor="#ffeb99">
                                <a target="blank" href="<%=context%>/AppointmentServlet?op=getEmpUniqueAppntmnt&departmentID=<%=departmentID%>&userID=<%=wbo.getAttribute("userID")%>&userName=<%=wbo.getAttribute("userName")%>&total=Un&beginDate=<%=beginDate%>&endDate=<%=endDate%>">
                                    <%=wbo.getAttribute("meeting")%> 
                                </a>
                            </TD>

                            <TD bgcolor="#fff2e6">
                                <a target="blank" href="<%=context%>/AppointmentServlet?op=getEmpUniqueAppntmnt&departmentID=<%=departmentID%>&userID=<%=wbo.getAttribute("userID")%>&userName=<%=wbo.getAttribute("userName")%>&total=1&beginDate=<%=beginDate%>&endDate=<%=endDate%>">
                                    <%=wbo.getAttribute("tsMeeting")%> 
                                </a>
                            </TD>

                            <TD bgcolor="#fff2e6">
                                <a target="blank" href="<%=context%>/AppointmentServlet?op=getEmpUniqueAppntmnt&departmentID=<%=departmentID%>&userID=<%=wbo.getAttribute("userID")%>&userName=<%=wbo.getAttribute("userName")%>&total=2&beginDate=<%=beginDate%>&endDate=<%=endDate%>">
                                    <%=wbo.getAttribute("slsMeeting")%>
                                </a>
                            </TD>

                            <TD bgcolor="#ffe5cc">
                                <a target="blank" href="<%=context%>/AppointmentServlet?op=getEmpUniqueAppntmnt&departmentID=<%=departmentID%>&userID=<%=wbo.getAttribute("userID")%>&userName=<%=wbo.getAttribute("userName")%>&total=3&beginDate=<%=beginDate%>&endDate=<%=endDate%>">
                                    <%=wbo.getAttribute("bkrMeeting")%>
                                </a>
                            </TD>

                            <TD bgcolor="#ffe6e6"> 
                                <%=wbo.getAttribute("not_answred")%> 
                            </TD>

                            <TD bgcolor="#ffe6e6">
                                <%=wbo.getAttribute("total_clients")%> 
                            </td>
                            <TD bgcolor="#fff2e6">
                                0
                            </TD>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>  
                    <tfoot>
                    </tfoot>
                </TABLE>
                <br/>
            </div>
            <%}%>
        </fieldset>    
    </body>
</html>
