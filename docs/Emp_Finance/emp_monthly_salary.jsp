<%@page import="java.util.ArrayList"%>
<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@page pageEncoding="UTF-8" %>

<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String stat = (String) request.getSession().getAttribute("currentMode");

        String empNumber = (String) request.getAttribute("empNumber");
        String status = (String) request.getAttribute("status");
        String turn = (String) request.getAttribute("turn");
        LiteWebBusinessObject empWbo = (LiteWebBusinessObject) request.getAttribute("empWbo");
        ArrayList<LiteWebBusinessObject> salaryItems = (ArrayList<LiteWebBusinessObject>) request.getAttribute("salaryItems");

        java.util.Date date = new Date();
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        int currentMonth = cal.get(Calendar.MONTH);
        int currentYear = cal.get(Calendar.YEAR);
        String currentMonthString = cal.getDisplayName(Calendar.MONTH, Calendar.LONG, Locale.getDefault());

        String align = null, xAlign, bgColor, bgColorm, searchEmployee, empCode, empName, month, year;
        String dir = null;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
            searchEmployee = "Search For Employee";
            empCode = "Employee Code";
            empName = "EmployeeName";
            month = "Month";
            year = "Year";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
            searchEmployee = "البحث عن موظف";
            empCode = "كود الموظف";
            empName = "اسم الموظف";
            month = "الشهر";
            year = "السنة";
        }

        int flipper = 0;
    %>

    <HEAD>
        <TITLE>New Employee</TITLE>

        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" href="js/rateit/rateit.css"/>

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.rowsGroup.js"></script>
        <script type="text/javascript" language="javascript" src="js/rateit/jquery.rateit.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script type='text/javascript' src='silkworm_validate.js'></script>
        <script type="text/javascript" src="js/w2ui/w2ui-1.5.rc1.min.js"></script>
        <script src='ChangeLang.js' type='text/javascript'></script>
        <script type="text/javascript">
            $(document).ready(function () {
                $("#tblData").dataTable({
                    "destroy": true,
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    "columnDefs": [{
                            "targets": 0,
                            "orderable": false
                        }],
                    "order": [[1, "asc"]]
                }).fadeIn(2000);
            });

            function getEmployee() {
                if ($("#empNumber").val() === "") {
                    alert('يجب ادخال كود الموظف');
                    return;
                }
                document.Employee_FORM.action = "<%=context%>/EmployeeServlet?op=getEmployee&empNumber=" + $("#empNumber").val();
                document.Employee_FORM.submit();
            }

            function saveSalary() {
                if ($("#empNumber").val() === "") {
                    alert('يجب ادخال كود الموظف');
                    return;
                }
                
                document.Employee_FORM.action = "<%=context%>/FinancialManagementServlet?op=saveEmployeeSalary";
                document.Employee_FORM.submit();
            }

            var total = 0;
            function calculateSalary(object, sign) {
                if (sign === 'positive') {
                    total += parseFloat($("#" + object).val());
                } else {
                    total -= parseInt($("#" + object).val());
                }

                $("#netSalary").val(total);
            }
        </script>
    </HEAD>

    <body>
        <fieldset align=center class="set" style="width: 90%">
            <form name="Employee_FORM" action="" method="POST">
                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="25%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4">
                    <TD  STYLE="text-align: center; color: blue; font-size: 16px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <DIV> 
                            <%=searchEmployee%>
                        </DIV>
                    </TD>

                    <TD  STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <%if (empNumber == null) {%>
                        <input id="empNumber" name="empNumber" type="text" value="" style="margin: 5px;" />
                        <%} else {%>
                        <input id="empNumber" name="empNumber" type="text" value="<%=empNumber%>" style="margin: 5px;" />
                        <%}%>
                    </TD>

                    <TD STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <button style="width: 100px" type="button" onclick="javascript: getEmployee();"><b style="font-weight: bold; font-size: 14px; vertical-align: middle">عرض</b>&ensp;<img src="images/icons/refresh.png" width="20" height="20" style="vertical-align: middle"/></button>
                    </TD>

                    <TD STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <button style="width: 100px" type="button" onclick="javascript: saveSalary();"><b style="font-weight: bold; font-size: 14px; vertical-align: middle">حفظ</b>&ensp;<img src="images/icons/refresh.png" width="20" height="20" style="vertical-align: middle"/></button>
                    </TD>
                </TABLE>  

                <%if (null != status) {%>
                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        <td class="td">
                            <% if (status.equalsIgnoreCase("ok")) {%>
                            <font size="4" color="green"> تم التسجيل بنجاح </font>
                            <% } else {%>
                            <font size="4" color="red"> لم يتم التسجيل </font>
                            <% }%>
                        </td>
                    </tr>
                </table>
                <%}%>

                <%if (empWbo != null) {%>
                <br>
                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="65%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4">
                    <TD  STYLE="text-align: center; color: blue; font-size: 16px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <DIV> 
                            <%=empCode%>
                        </DIV>
                    </TD>

                    <TD  STYLE="text-align: right; color: red; font-size: 16px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <LABEL id="empCode"><%=empWbo.getAttribute("empNO").toString()%></LABEL>
                    </TD>

                    <TD  STYLE="text-align: center; color: blue; font-size: 16px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <DIV> 
                            <%=empName%>
                            <input type="hidden" name="empID" id="empID" value="<%=empWbo.getAttribute("empId").toString()%>"/>
                        </DIV>
                    </TD>

                    <TD  STYLE="text-align: right; color: red; font-size: 16px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <LABEL id="empName"><%=empWbo.getAttribute("empName").toString()%></LABEL>
                    </TD>

                    <TD  STYLE="text-align: center; color: blue; font-size: 16px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <DIV> 
                            <%=month%>
                        </DIV>
                    </TD>

                    <TD  STYLE="text-align: right; color: red; font-size: 16px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <LABEL id="month"><%=currentMonthString%></LABEL>
                        <input type="hidden" name="month" id="month" value="<%=currentMonth%>"/>
                    </TD>

                    <TD  STYLE="text-align: center; color: blue; font-size: 16px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <DIV> 
                            <%=year%>
                        </DIV>
                    </TD>

                    <TD  STYLE="text-align: right; color: red; font-size: 16px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <LABEL id="year"><%=currentYear%></LABEL>
                        <input type="hidden" name="year" id="year" value="<%=currentYear%>">
                    </TD>
                </TABLE> 

                <br>    

                <TABLE id="tblData" class="blueBorder" ALIGN="center" dir="<%=dir%>" width="50%" cellpadding="0" cellspacing="0">
                    <thead>
                        <TR>
                            <TD CLASS="silver_header" STYLE="text-align: center; color: black; font-size: 14px; font-weight: bold;" nowrap width="5%">
                                <b>
                                    # 
                                </b>
                            </TD>

                            <TD CLASS="silver_header" STYLE="text-align: center; color: black; font-size: 14px; font-weight: bold;" nowrap width="25%">
                                <b>
                                    كود المرتب
                                </b>
                            </TD>

                            <TD CLASS="silver_header" STYLE="text-align: center; color: black; font-size: 14px; font-weight: bold;" nowrap width="25%">
                                <b>
                                    مفرد المرتب
                                </b>
                            </TD>

                            <TD CLASS="silver_header" STYLE="text-align: center; color: black; font-size: 14px; font-weight: bold;" nowrap width="45%">
                                <b>
                                    القيمة
                                </b>
                            </TD>
                        </TR>
                    </thead>

                    <tbody>
                        <%
                            int iTotal = 0;
                            for (int i = 0; i < salaryItems.size(); i++) {
                                LiteWebBusinessObject salayWbo = (LiteWebBusinessObject) salaryItems.get(i);

                                iTotal++;
                                flipper++;

                                if ((flipper % 2) == 1) {
                                    bgColor = "silver_odd";
                                    bgColorm = "silver_odd_main";
                                } else {
                                    bgColor = "silver_even";
                                    bgColorm = "silver_even_main";
                                }
                        %>
                        <TR>
                            <TD nowrap style="text-align: center;">
                                <%=salayWbo.getAttribute("code")%> 
                            </TD>

                            <TD nowrap style="text-align: center;">
                                <%=salayWbo.getAttribute("code")%> 
                            </TD>

                            <TD nowrap style="text-align: center;">
                                <%=salayWbo.getAttribute("arName")%> 
                            </TD>

                            <TD nowrap style="text-align: center;">
                                <input id="<%=salayWbo.getAttribute("enName")%>"  name="<%=salayWbo.getAttribute("enName")%>" type="number" step="any" value="0" style="margin: 5px;<%if (salayWbo.getAttribute("enName").equals("netSalary")) {%>color: red;<%}%>" onblur="Javascript: calculateSalary('<%=salayWbo.getAttribute("enName")%>', '<%=salayWbo.getAttribute("calcType")%>');" />
                            </TD>
                        </TR>
                        <%
                            }
                        %>
                    </tbody>
                </TABLE>
                <%} else if (turn != null && turn.equals("second")){%>
                <br>
                <Font color="red"><B>لا يوجد بيانات لهذا الموظف </B></font> 
                    <%}%>
            </form>
        </FIELDSET>
    </body>
</HTML>