
<%@page import="com.silkworm.common.SecurityUser"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>

<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String[] commentsListTitles = new String[4];
        int t = commentsListTitles.length;
        ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
        ArrayList<WebBusinessObject> employeeList = (ArrayList<WebBusinessObject>) request.getAttribute("employeeList");
        ArrayList<WebBusinessObject> departments = (ArrayList<WebBusinessObject>) request.getAttribute("departments");
        String departmentID = request.getAttribute("departmentID") != null ? (String) request.getAttribute("departmentID") : "";
        String commentTypeVal = request.getAttribute("commentType") != null ? (String) request.getAttribute("commentType") : "";

//        SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");
//        ArrayList<WebBusinessObject> prvType = new ArrayList();
//        prvType = securityUser.getComplaintMenuBtn();
//        ArrayList<String> privilegesList = new ArrayList<>();
//        for (WebBusinessObject wboTemp : prvType) {
//            if (wboTemp != null && wboTemp.getAttribute("prevCode") != null) {
//                privilegesList.add((String) wboTemp.getAttribute("prevCode"));
//            }
//        }
        String employeeID = request.getAttribute("employeeID") != null ? (String) request.getAttribute("employeeID") : "";

        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null, xAlign, fromDate, toDate, display, employeeName, dir, department, commentType;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
            commentsListTitles[0] = "Comment";
            commentsListTitles[1] = "Comment Date";
            commentsListTitles[2] = "Comment by";
            commentsListTitles[3] = "Client Name";
            fromDate = "From Date";
            toDate = "To Date";
            display = "Display Report";
            employeeName = "Employee";
            department = "Last Rating Time";
            commentType = "Comment Type";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
            commentsListTitles[0] = "التعليق";
            commentsListTitles[1] = "تاريخ التعليق";
            commentsListTitles[2] = "بواسطة";
            commentsListTitles[3] = "اسم العميل";
            fromDate = "من تاريخ";
            toDate = "إلي تاريخ";
            display = "أعرض التقرير";
            employeeName = "الموظف";
            department = "الأدارة";
            commentType = "نوع التعليق";
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
                oTable = $('#comments').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[20, 50, 100, -1], [20, 50, 100, "All"]],
                    iDisplayStart: 0,
                    iDisplayLength: 20,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[1, "desc"]],
                    "columnDefs": [{
                            "targets": 0,
                            "orderable": false
                        }]
                }).fadeIn(2000);

                $("#fromDate,#toDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
            });
            function getEmployees(obj, isReload) {
                var departmentID = $(obj).val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/CommentsServlet?op=getEmployeesList",
                    data: {
                        departmentID: departmentID
                    },
                    success: function (jsonString) {
                        try {
                            var output = [];
                            var createdBy = $("#employeeID");
                            $(createdBy).html("");
                            var info = $.parseJSON(jsonString);
                            for (i = 0; i < info.length; i++) {
                                var item = info[i];
                                output.push('<option value="' + item.userId + '">' + item.fullName + '</option>');
                            }
                            createdBy.html(output.join(''));
                            if (isReload) {
                                $("#employeeID").val('<%=employeeID%>');
                            }
                        } catch (err) {
                        }
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
        </style>
    </HEAD>
    <body>
        <b style="float: <%=xAlign%>; font-size: 16px;color: #005599; font-style: oblique; margin-<%=xAlign%>: 80px;">Comments on Sales Reps Report تعليقات علي مندوبي المبيعات</b>
        <fieldset align=center class="set" style="width: 95%">
            <form name="COMMENTS_FORM" action="<%=context%>/ReportsServletThree?op=getCommentsOnEmployee" method="POST">
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
                            <input type="text" style="width:190px" id="fromDate" name="fromDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("fromDate") == null ? "" : request.getAttribute("fromDate")%>"/>
                        </td>
                        <td bgcolor="#dedede" valign="middle">
                            <input type="text" style="width:190px" id="toDate" name="toDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("toDate") == null ? "" : request.getAttribute("toDate")%>"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white"><%=department%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white"><%=employeeName%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle">
                            <select id="departmentID" name="departmentID" style="font-size: 14px; font-weight: bold; width: 250px;"
                                    onchange="getEmployees(this, false);">
                                <% if (departments != null) {%>
                                <sw:WBOOptionList wboList="<%=departments%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=departmentID%>" />
                                <% }%>
                            </select>
                        </td>
                        <td bgcolor="#dedede" valign="middle">
                            <select name="employeeID" id="employeeID" style="width: 250px; font-size: 18px;">
                                <sw:WBOOptionList wboList="<%=employeeList%>" displayAttribute="fullName" valueAttribute="userId" scrollToValue="<%=employeeID%>"/>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                            <b><font size=3 color="white"><%=commentType%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle" colspan="2">
                            <select name="commentType" id="commentType" style="width: 250px;">
                                <option value=""></option>
                                <option value="Hot Client" <%="Hot Client".equals(commentTypeVal) ? "selected" : ""%>>
                                    Hot Client
                                </option>
                                <option value="Unit & Project data missing" <%="Unit & Project data missing".equals(commentTypeVal) ? "selected" : ""%>>
                                    Unit & Project data missing
                                </option>
                                <option value="No Payment Plan" <%="No Payment Plan".equals(commentTypeVal) ? "selected" : ""%>>
                                    No Payment Plan
                                </option>
                                <option value="Poor Client Communication" <%="Poor Client Communication".equals(commentTypeVal) ? "selected" : ""%>>
                                    Poor Client Communication
                                </option>
                                <option value="Visit Support" <%="Visit Support".equals(commentTypeVal) ? "selected" : ""%>>
                                    Visit Support
                                </option>
                                <option value="Other" <%="Other".equals(commentTypeVal) ? "selected" : ""%>>
                                    Other
                                </option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle" colspan="2">
                            <input type="submit" value="<%=display%>" class="button" style="margin: 10px; width: 150px;"/>
                        </td>
                    </tr>
                </table>
                <br/>
                <br/>
                <%
                    if (data != null) {
                %>
                <div style="width: 65%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                    <br/>
                    <table align="<%=align%>" dir="<%=dir%>" id="comments" style="width:100%;">
                        <thead>
                            <tr>
                                <%
                                    for (int i = 0; i < t; i++) {
                                %>                
                                <th>
                                    <b><%=commentsListTitles[i]%></b>
                                </th>
                                <%
                                    }
                                %>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (WebBusinessObject wbo : data) {
                            %>
                            <tr>
                                <td>
                                    <%=wbo.getAttribute("comment")%>
                                </td>
                                <td>
                                    <%=wbo.getAttribute("creationTime") != null ? ((String) wbo.getAttribute("creationTime")).substring(0, 16) : ""%>
                                </td>
                                <td>
                                    <%=wbo.getAttribute("fromUserName")%>
                                </td>
                                <td>
                                    <%=wbo.getAttribute("clientName")%>
                                    <a target="blanck" href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("clientId")%>">
                                        <img src="images/client_details.jpg" width="30" style="float: left;">
                                    </a>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                    <%
                        }
                    %>
                </div>
                <br/><br/>
            </form>
        </fieldset>
        <script>
            getEmployees($("#departmentID"), true);
        </script>
    </body>
</html>
