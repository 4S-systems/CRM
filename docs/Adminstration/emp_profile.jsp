<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld"%>
<%@ page pageEncoding="UTF-8"%>

<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String stat = (String) request.getSession().getAttribute("currentMode");
        WebBusinessObject empProfileWbo = new WebBusinessObject();
        empProfileWbo = (WebBusinessObject) request.getAttribute("empProfileWbo");
        
        ArrayList deptsList = (ArrayList) request.getAttribute("deptsList");
        String empID = (String) request.getAttribute("empID");

        String dir, sStatus, sTitle, fStatus;
        if (stat.equals("En")) {
            dir = "LTR";
            sTitle = "Employee's Details";
            sStatus = "Successfuly saved";
            fStatus = "Failed in saving";
        } else {
            dir = "RTL";
            sTitle = "تفاصيل موظف";
            sStatus = "تم الحفظ بنجاح";
            fStatus = "لم يتم الحفظ بنجاح";
        }
    %>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Employee Profile</title>
        <script type="text/javascript">
            function saveProfile() {
                $.ajax({
                    type: "post",
                    url: '<%=context%>/EmployeeServlet?op=savePofile',
                    data: {
                        empID: $("#empID").val(),
                        profID: $("#profID").val(),
                        depts: $("#depts option:selected").val(),
                        vacationsNo: $("#vacationsNo").val(),
                        tempVacationsNo: $("#tempVacationsNo").val(),
                        tempLeaveNo: $("#tempLeaveNo").val(),
                        workingHours: $("#workingHours").val(),
                        empStatus: $("#empStatus option:selected").val(),
                        salary: $("#salary").val()
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'OK') {
                            alert("تم الحفظ بنجاح");
                        } else {
                            alert("لم يتم الحفظ");
                        }
                    },
                    error: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'OK') {
                            alert("تم الحفظ بنجاح");
                        } else {
                            alert("لم يتم الحفظ");
                        }
                    }
                });
            }
        </script>
    </head>
    <body>
        <form id="EmpProfile">
            <%if(empProfileWbo != null && empProfileWbo.getAttribute("depID") != null){
                String c = empProfileWbo.getAttribute("depID").toString();
                String profID = empProfileWbo.getAttribute("profileId").toString();
            %>
                <table  border="0px"  style="width:100%;" dir="<%=dir%>">
                    <tr>
                        <td style="font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                            القسم
                        </td>
                        <td style="width: 80%; text-align: right;" colspan="3">
                            <input type="hidden" value="<%=empID%>" name="empID" id="empID"/>
                            <input type="hidden" value="<%=profID%>" name="profID" id="profID"/>
                            <SELECT name="depts" ID="depts" style="width:230px">
                                <sw:WBOOptionList wboList="<%=deptsList%>" displayAttribute="departmentName" valueAttribute="departmentID" scrollToValue="<%=c%>"/>
                            </SELECT>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                            الاجازات السنوية
                        </td>
                        <td style="width: 80%; text-align: right;" colspan="3">
                            <input  type="number" style="width:40%;" name="vacationsNo" ID="vacationsNo" size="33"  maxlength="10" class="empNumber" min="1" value="<%=empProfileWbo.getAttribute("yearlyH") != null ? empProfileWbo.getAttribute("yearlyH") : ""%>"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                            الاجازات العارضة
                        </td>
                        <td style="width: 80%; text-align: right;" colspan="3">
                            <input  type="number" style="width:40%;" name="tempVacationsNo" ID="tempVacationsNo" size="33"  maxlength="10" class="empNumber" min="1" value="<%=empProfileWbo.getAttribute("otherH") != null ? empProfileWbo.getAttribute("otherH") : ""%>"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                            (بالساعة)الاذونات الشهرية
                        </td>
                        <td style="width: 80%; text-align: right;" colspan="3">
                            <input  type="number" style="width:40%;" name="tempLeaveNo" ID="tempLeaveNo" size="33"  maxlength="10" class="empNumber" min="1" value="<%=empProfileWbo.getAttribute("permissions") != null ? empProfileWbo.getAttribute("permissions") : ""%>" />
                        </td>
                    </tr>
                    <tr>
                        <td style="font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                            ساعات العمل
                        </td>
                        <td style="width: 80%; text-align: right;" colspan="3">
                            <input  type="number" style="width:40%;" name="workingHours" ID="workingHours" size="33"  maxlength="10" class="empNumber" min="1" value="<%=empProfileWbo.getAttribute("workHours") != null ? empProfileWbo.getAttribute("workHours") : ""%>" />
                        </td>
                    </tr>
                    <tr>
                        <td style="font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                            أساسى المرتب
                        </td>
                        <td style="width: 80%; text-align: right;" colspan="3">
                            <input  type="number" style="width:40%;" name="salary" ID="salary" size="33"  maxlength="10" class="empNumber" min="1" step="any" value="<%=empProfileWbo.getAttribute("salary") != null ? empProfileWbo.getAttribute("salary") : ""%>" />
                        </td>
                    </tr>
                    <tr>
                        <td style="font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                            حالة الموظف
                        </td>
                        <td style="width: 80%; text-align: right;">
                            <SELECT name="empStatus" ID="empStatus" style="width:125px">
                                <option value="يعمل" <%=empProfileWbo.getAttribute("workTyp").equals("يعمل") ? "selected" : ""%>>يعمل </option>
                                <option value="جزء من الوقت" <%=empProfileWbo.getAttribute("workTyp").equals("جزء من الوقت") ? "selected" : ""%>>جزء من الوقت </option>
                                <option value="أجازة" <%=empProfileWbo.getAttribute("workTyp").equals("أجازة") ? "selected" : ""%>>أجازة </option>
                            </SELECT>
                        </td>
                    </tr>
                </table>
            <%} else {%>
                <table  border="0px"  style="width:100%;" dir="<%=dir%>">
                    <tr>
                        <td style="font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                            القسم
                        </td>
                        <td style="width: 80%; text-align: right;" colspan="3">
                            <input type="hidden" value="<%=empID%>" name="empID" id="empID"/>
                            <SELECT name="depts" ID="depts" style="width:230px">
                                <sw:WBOOptionList wboList="<%=deptsList%>" displayAttribute="departmentName" valueAttribute="departmentID"/>
                            </SELECT>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                            الاجازات السنوية
                        </td>
                        <td style="width: 80%; text-align: right;" colspan="3">
                            <input  type="number" style="width:40%;" name="vacationsNo" ID="vacationsNo" size="33"  maxlength="10" class="empNumber" min="1" />
                        </td>
                    </tr>
                    <tr>
                        <td style="font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                            الاجازات العارضة
                        </td>
                        <td style="width: 80%; text-align: right;" colspan="3">
                            <input  type="number" style="width:40%;" name="tempVacationsNo" ID="tempVacationsNo" size="33"  maxlength="10" class="empNumber" min="1"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                            (بالساعة)الاذونات الشهرية
                        </td>
                        <td style="width: 80%; text-align: right;" colspan="3">
                            <input  type="number" style="width:40%;" name="tempLeaveNo" ID="tempLeaveNo" size="33"  maxlength="10" class="empNumber" min="1" />
                        </td>
                    </tr>
                    <tr>
                        <td style="font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                            ساعات العمل
                        </td>
                        <td style="width: 80%; text-align: right;" colspan="3">
                            <input  type="number" style="width:40%;" name="workingHours" ID="workingHours" size="33"  maxlength="10" class="empNumber" min="1"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                            أساسى المرتب
                        </td>
                        <td style="width: 80%; text-align: right;" colspan="3">
                            <input  type="number" style="width:40%;" name="salary" ID="salary" size="33"  maxlength="10" class="empNumber" min="1" step="any"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-size: 16px;font-weight: bold;width: 30%;" nowrap>
                            حالة الموظف
                        </td>
                        <td style="width: 80%; text-align: right;">
                            <SELECT name="empStatus" ID="empStatus" style="width:125px">
                                <option value="يعمل">يعمل </option>
                                <option value="جزء من الوقت">جزء من الوقت </option>
                                <option value="أجازة">أجازة </option>
                            </SELECT>
                        </td>
                    </tr>
                </table>
            <%}%>
                        <div style="text-align: center;margin-left: auto;margin-right: auto;" > <input type="button" value="حفظ" onclick="saveProfile()" id="save" class="login-submit"/>
            </div>                           
        </form>
    </body>
</html>
