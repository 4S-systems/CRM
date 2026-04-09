<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="java.util.Vector"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String stat = (String) request.getSession().getAttribute("currentMode");

        ArrayList<WebBusinessObject> campaignsList = (ArrayList<WebBusinessObject>) request.getAttribute("campaignsList");
        ArrayList<WebBusinessObject> employees = (ArrayList<WebBusinessObject>) request.getAttribute("employees");
        if (employees == null) {
            employees = new ArrayList<>();
        }
        ArrayList<WebBusinessObject> clientsList = (ArrayList<WebBusinessObject>) request.getAttribute("clientsList");

        String campaignID = request.getAttribute("campaignID") != null ? (String) request.getAttribute("campaignID") : "";
        String employeeID = request.getAttribute("employeeID") != null ? (String) request.getAttribute("employeeID") : "";
        
        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        Vector groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
        ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wbo;
        for (int i = 0; i < groupPrev.size(); i++) {
            wbo = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wbo.getAttribute("prevCode"));
        }

        String[] clientsAttributes = {"clientName", "mobile", "clientCreationTime", "appointmentDate", "appointmentPlace", "appointmentComment","attended"};
        String[] clientsListTitles = new String[7];

        String fromDate, toDate, ratedDate, campaign, employeeName, all, display;
        String align = null, xAlign;
        String dir = null;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
            fromDate = "From Date";
            toDate = "To Date";
            ratedDate = "Meeting Date";
            campaign = "Campaign";
            employeeName = "Employee";
            all = "All";
            display = "Display Report";

            clientsListTitles[0] = "Client Name";
            clientsListTitles[1] = "Client Mobile";
            clientsListTitles[2] = "Creation Time";
            clientsListTitles[3] = "Appointment Date";
            clientsListTitles[4] = "Appointment Place";
            clientsListTitles[5] = "Appintment Comment";
            clientsListTitles[6] = "Appintment Attendance";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
            fromDate = "من تاريخ";
            toDate = "ألي تاريخ";
            ratedDate = "تاريخ المقابلة";
            campaign = "الحملة";
            employeeName = "الموظف";
            all = "الكل";
            display = "أعرض التقرير";

            clientsListTitles[0] = "اسم العميل";
            clientsListTitles[1] = "الموبايل";
            clientsListTitles[2] = "تاريخ التسجيل";
            clientsListTitles[3] = "تاريخ المقابله";
            clientsListTitles[4] = "مكان المقابلة";
            clientsListTitles[5] = "التعليق";
            clientsListTitles[6] = "حضور المقابلة";
        }
    %>
    <HEAD>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>

        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
        <script type="text/javascript">
            var oTable;

            $(document).ready(function () {
                oTable = $('#clients').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[3, "asc"]]
                }).fadeIn(2000);

                $("#fromDate,#toDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
            });
            
            function printPDF(){
                document.ATTENDING_FORM.action = "<%=context%>/ReportsServletThree?op=attendedClientsReportPDF";
                document.ATTENDING_FORM.submit();
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
        </style>
    </HEAD>
    <body>
        <fieldset align=center class="set" style="width: 95%">
            <form name="ATTENDING_FORM" action="<%=context%>/ReportsServletThree?op=attendedClientsReport" method="POST">
                <br/>
                <table class="blueBorder" align="center" dir="<%=dir%>" id="code" cellpadding="0" cellspacing="0" width="650" style="border-width: 1px; border-color: white; display: block;" >
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px" colspan="2">
                            <b><font size=3 color="white"> <%=fromDate%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px" colspan="2">
                            <b><font size=3 color="white"> <%=toDate%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle" colspan="2">
                            <input type="text" style="width:190px" id="fromDate" name="fromDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("fromDate") == null ? "" : request.getAttribute("fromDate")%>" title="<%=ratedDate%>"/>
                        </td>
                        <td bgcolor="#dedede" valign="middle" colspan="2">
                            <input type="text" style="width:190px" id="toDate" name="toDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("toDate") == null ? "" : request.getAttribute("toDate")%>" title="<%=ratedDate%>"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="4">
                            <b><font size=3 color="white"><%=campaign%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle" colspan="4">
                            <select name="campaignID" id="campaignID" style="width: 600px;" class="chosen-select-campaign">
                                <option value="" > All Campaign </option>
                                <%
                                    for (WebBusinessObject campaignWbo : campaignsList) {
                                %>
                                <option value="<%=campaignWbo.getAttribute("id")%>" <%=campaignID.contains((String) campaignWbo.getAttribute("id")) ? "selected" : ""%> ><%=campaignWbo.getAttribute("campaignTitle")%></option>
                                <%
                                    }
                                %>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="4">
                            <b><font size=3 color="white"><%=employeeName%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle" colspan="4">
                            <select name="employeeID" id="employeeID" style="width: 600px; font-size: 18px;">
                                <option value=""><%=all%></option>
                                <sw:WBOOptionList wboList="<%=employees%>" displayAttribute="fullName" valueAttribute="userId" scrollToValue="<%=employeeID%>"/>
                            </select>
                        </td>
                    </TR>
                    <tr>
                        <td bgcolor="#dedede" valign="middle" colspan="2">
                            <input type="submit" value="<%=display%>" class="button" style="margin: 10px;"/>
                        </td>
                        <td bgcolor="#dedede" valign="middle" colspan="2">
                            <%if (userPrevList.contains("View_PDF")) {%>
                            <a href="JavaScript: printPDF();">
                                <img style="margin: 3px" src="images/icons/pdf.png" width="30" height="30"/>
                            </a>
                            <%}%>
                        </td>
                    </tr>
                </table>
                </br>
                </br>

                <%
                    if (clientsList != null) {
                %>
                <table align="<%=align%>" dir="<%=dir%>" id="clients" style="width:100%;">
                    <thead>
                        <tr>
                            <%
                                for (int i = 0; i < clientsListTitles.length; i++) {
                            %>                
                            <th>
                                <b><%=clientsListTitles[i]%></b>
                            </th>
                            <%}%>
                        </TR>
                    </THEAD>

                    <TBODY>
                        <%
                            for (WebBusinessObject clientWbo : clientsList) {
                        %>
                        <tr>
                            <%for (int i = 0; i < clientsAttributes.length; i++) {
                                    String attName = clientsAttributes[i];
                                    String attValue = clientWbo.getAttribute(attName) != null ? ((String) clientWbo.getAttribute(attName)).trim() : "";%>
                            <td>
                                <%=attValue%>
                            </td>
                            <%}%>
                        </tr>
                        <%}%>
                    </TBODY>
                </table>
                </br>
                </br>
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
    </BODY>
</HTML>