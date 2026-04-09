<%@page import="com.clients.db_access.ClientMgr"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="com.maintenance.common.UserDepartmentConfigMgr"%>
<%@page import="com.tracker.db_access.ProjectMgr"%>
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
        //fahd           
        ProjectMgr projectMgr = ProjectMgr.getInstance();

        String selectedDepartment = request.getParameter("departmentID");

        try {
            UserDepartmentConfigMgr userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
            ArrayList<WebBusinessObject> userDepartments;
            WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
            userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
            ArrayList<WebBusinessObject> departments = new ArrayList<>();
            departments = new ArrayList<>();

            for (WebBusinessObject userDepartmentWbo : userDepartments) {
                departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
            }

            if (departments.isEmpty()) {
                WebBusinessObject wboTemp = new WebBusinessObject();
                wboTemp.setAttribute("projectName", "لا يوجد");
                wboTemp.setAttribute("projectID", "none");
                departments.add(wboTemp);
            } else {
                if (selectedDepartment == null) {
                    selectedDepartment = (String) departments.get(0).getAttribute("projectID");
                }
            }

            request.setAttribute("departments", departments);
        } catch (Exception ex) {
            Logger.getLogger("Error");
        }

        request.setAttribute("departmentID", selectedDepartment);
        ArrayList<WebBusinessObject> departmentss = (ArrayList<WebBusinessObject>) request.getAttribute("departments");
        String departmentID = request.getAttribute("departmentID") != null ? (String) request.getAttribute("departmentID") : "";
        String beginDate = (String) request.getAttribute("beginDate");
        String endDate = (String) request.getAttribute("endDate");

        ArrayList<WebBusinessObject> data = ClientMgr.getInstance().getClientCustom();
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        String nowDate = sdf.format(cal.getTime());
        DecimalFormat df = new DecimalFormat("0.00");

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null, tit, empNm, callsNo, totalCalsTim, meetingNo, meetings, totalmeetTim, totalClntsNo,
                inter, from, to, dep, noDep, disp, visitClients, total, callClients, clientsPresent, callsNon, totalCalls, totalNewCalls;

        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            tit = "Clients Statistics";
            empNm = "Projects Name";
            callsNo = "Total Block";
            totalCalsTim = "Total Calls Time";
            meetingNo = "Repeated Visits";
            meetings = "Completed Visits";
            totalmeetTim = "Total Visits Time";
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
            callsNon = "Not Answered Call";
            totalCalls = "Total Calls";
            totalNewCalls = "Total Clients";
        } else {
            align = "center";
            dir = "RTL";
            tit = "احصائيات العملاء";
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
            totalNewCalls = "اجمالي العملاء الجدد";
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
                // Calculate the date 5 months ago
                var minDate = new Date();
                minDate.setMonth(minDate.getMonth() - 12);

                // Set the beginDate to sysdate - 5 months
                var beginDate = new Date();
                beginDate.setMonth(beginDate.getMonth() - 12);

                // Set the endDate to sysdate
                var endDate = new Date();

                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: endDate, // Set maxDate to sysdate
                    dateFormat: "yy/mm/dd"
                });

                // Set the initial values for the datepicker inputs
                $("#beginDate").datepicker("setDate", beginDate);
                $("#endDate").datepicker("setDate", endDate);

                // Allow users to select dates in the future for beginDate
                $("#beginDate").datepicker("option", "maxDate", "+0");
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


            <%if (data != null && data.size() > 0) {%>
            <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showResults">
                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" id="Employee" style="">
                    <thead>
                        <tr>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;"><%=empNm%></th>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;"><%=totalNewCalls%></th>
                            <th style="color: #005599 !important;font-size: 15px; font-weight: bold;"><%=callsNo%> </th>
                        </tr>
                    <thead>
                    <tbody >  
                        <%
                            for (WebBusinessObject wbo : data) {
                        %>
                        <tr>
                            <TD>
                                <%=wbo.getAttribute("project_name")%> 
                            </TD>

                            <TD bgcolor="#ffeb99">
                                <a target="blank" href="<%=context%>/AppointmentServlet?op=clientCustom&projectID=<%=wbo.getAttribute("project_id")%>">
                                    <%=wbo.getAttribute("cust")%> 
                                </a>
                            </TD>

                            <TD bgcolor="#fff2e6">
                                <a target="blank" href="<%=context%>/AppointmentServlet?op=clientCustom&type=call&departmentID=<%=departmentID%>&beginDate=<%=beginDate%>&endDate=<%=endDate%>&userID=<%=wbo.getAttribute("userID")%>&userName=<%=wbo.getAttribute("userName")%>">
                                    <%=wbo.getAttribute("block")%> 
                                </a>
                            </TD>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>  
                </TABLE>
                <br/>
            </div>
            <%}%>
        </fieldset>    
    </body>
</html>
