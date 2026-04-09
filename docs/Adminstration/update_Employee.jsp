<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.persistence.relational.UniqueIDGen"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.tracker.db_access.DepartmentMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.maintenance.db_access.EmployeeTypeMgr"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@page pageEncoding="UTF-8" %>

<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Sales_Market.Sales_Market"  />
    <fmt:setBundle basename="Languages.Client.client"  />

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        LiteWebBusinessObject empWbo = (LiteWebBusinessObject) request.getAttribute("empWBO");

        String status = (String) request.getAttribute("Status");

        String birthDate = "";
        String contractDate = "";
        String workingDate = "";

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = "center";

        String style = null;
        String dir = null;
        String title, lang;
        String fStatus;
        String sStatus;
        String emp_number, emp_name, emp_address, emp_education, emp_job, emp_work_tel, emp_internal, emp_home_phone, emp_mobile, emp_fax;
        String emp_mail, emp_dept, emp_hour_salary, emp_birthDate, emp_StartDate, emp_workingDate, emp_gender, emp_Marital_Status, emp_notes;
        String emp_working_checkBox;
        String automated;
        String add_photo_checlBox;

        if (stat.equals("En")) {
            align = "center";
            dir = "Ltr";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            title = "add job";
            fStatus = "Fail To Update This Employee";
            sStatus = "Employee Updated Successfully";
            automated = "automated";
            emp_number = "Employee Number";
            emp_name = "Employee Name";
            emp_address = "Emplyee Address";
            emp_education = "Employee Education";
            emp_job = "Employee Position";
            emp_work_tel = "Work Telephone";
            emp_internal = "Work Extension";
            emp_home_phone = "Home phone";
            emp_mobile = "Mobile";
            emp_fax = "Fax";
            emp_mail = "Email";
            emp_dept = "Department";
            emp_hour_salary = "Salary";
            emp_birthDate = "Birth Date";
            emp_StartDate = "Contract Date";
            emp_workingDate = "Work Starting Date";
            emp_gender = "Employee Gender";
            emp_Marital_Status = "Marital Status";
            emp_notes = "Notes";
            emp_working_checkBox = "Working Type";
            add_photo_checlBox = "Attach Image";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            title = "تسجيل موظف جديد";
            fStatus = "لم يتم التعديل";
            sStatus = "تم التعديل بنجاح";
            emp_number = "رقم الموظف";
            emp_name = "اسم الموظف";
            emp_address = "عنوان الموظف";
            emp_education = "المؤهل العلمي";
            emp_job = "المهنة";
            emp_work_tel = "تليفون العمل";
            emp_internal = "داخلي";
            automated = "تلقائي";
            emp_home_phone = "تليفون المنزل";
            emp_mobile = "المحمول";
            emp_fax = "فاكس";
            emp_mail = "البريد الالكتروني";
            emp_dept = "القسم";
            emp_hour_salary = "المرتب";
            emp_birthDate = "تاريخ الميلاد";
            emp_StartDate = "تاريخ التعاقد";
            emp_workingDate = "تاريخ استلام العمل";
            emp_gender = "النوع";
            emp_Marital_Status = "الحالة الاجتماعية";
            emp_notes = "ملاحظات";
            emp_working_checkBox = "طبيعة العمل";
            add_photo_checlBox = "ارفع صورة";
        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>New Employee</TITLE>

        <link rel="StyleSheet" href="treemenu/css/dtree.css" type="text/css" />
        <link rel="stylesheet" type="text/css" href="treemenu/page_style.css" />
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link rel="stylesheet" type="text/css" href="js/w2ui/w2ui-1.5.rc1.min.css" />
        <link href="js/select2.min.css" rel="stylesheet">

        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
        <script src="js/select2.min.js"></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/common.js"></script>
        <script type="text/javascript" src="treemenu/script/contextmenu.js"></script>
        <script type="text/javascript" src="treemenu/script/dtree.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type='text/javascript' src='silkworm_validate.js'></script>
        <script type="text/javascript" src="js/w2ui/w2ui-1.5.rc1.min.js"></script>
        <script src='ChangeLang.js' type='text/javascript'></script>
        <SCRIPT  TYPE="text/javascript">
            $(function () {
                $("#contractDate, #workingDate, #birthDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });

                $("#submitBtn").css("display", "inline-block");
            });

            function submitForm()
            {
                document.ITEM_FORM.action = "<%=context%>/EmployeeServlet?op=Update";
                document.ITEM_FORM.submit();
            }

            function cancelForm()
            {
                try {
                    opener.getClientInfo('');
                } catch (err) {
                }
                self.close();
            }

            function disableEmpNO(checkBox) {
                if (!checkBox.checked) {
                    document.getElementById("empNO").disabled = false
                } else {
                    document.getElementById("empNO").value = ""
                    document.getElementById("empNO").disabled = true
                }
            }

            function checkNumber(obj) {
                var empNumber = $(".empNumber").val();

                if (clientNumber.length > 0) {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/EmployeeServlet?op=getEmployeeNumber",
                        data: {
                            empNumber: empNumber
                        },
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);

                            if (info.status == 'No') {
                                $("#MSG").css("color", "green");
                                $("#MSG").css(" text-align", "left");
                                $("#MSG").text(" متاح")
                                $("#MSG").removeClass("error");
                                $("#warning").css("display", "none");
                                $("#ok").css("display", "inline")

                            } else if (info.status == 'Ok') {
                                $("#MSG").css("color", "red");
                                $("#MSG").text(" محجوز");
                                $("#MSG").addClass("error");
                                $("#warning").css("display", "inline")
                                $("#ok").css("display", "none");
                            }
                        }
                    });
                } else {
                    $("#MSG").text("");
                    $("#warning").css("display", "none");
                    $("#ok").css("display", "none");
                }
            }

            function isNumber2(evt) {
                var iKeyCode = (evt.which) ? evt.which : evt.keyCode;
                if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57)) {

                    $("#numberMsg").show();
                    $("#numberMsg").text("أرقام فقط");
                    return false;
                } else {
                    $("#numberMsg").hide();
                }
            }

            function isHomePhoneNumber(evt) {

                var iKeyCode = (evt.which) ? evt.which : evt.keyCode;
                if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57)) {
                    $("#homeMsg").show();
                    $("#homeMsg").text("أرقام فقط");
                    return false;
                } else {
                    $("#homeMsg").hide();
                }
            }

            function isMobileNumber(evt) {
                var iKeyCode = (evt.which) ? evt.which : evt.keyCode;
                if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57)) {

                    $("#mobileMsg").show();
                    $("#mobileMsg").text("أرقام فقط");
                    return false;
                } else {
                    $("#mobileMsg").hide();
                }
            }

            function isWorkNumber(evt) {

                var iKeyCode = (evt.which) ? evt.which : evt.keyCode;
                if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57)) {
                    $("#workMsg").show();
                    $("#workMsg").text("أرقام فقط");
                    return false;
                } else {
                    $("#workMsg").hide();
                }
            }

            function isWorkExtNumber(evt) {

                var iKeyCode = (evt.which) ? evt.which : evt.keyCode;
                if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57)) {
                    $("#workExtMsg").show();
                    $("#workExtMsg").text("أرقام فقط");
                    return false;
                } else {
                    $("#workExtMsg").hide();
                }
            }

            function isFaxNumber(evt) {

                var iKeyCode = (evt.which) ? evt.which : evt.keyCode;
                if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57)) {
                    $("#faxMsg").show();
                    $("#faxMsg").text("أرقام فقط");
                    return false;
                } else {
                    $("#faxMsg").hide();
                }
            }

            function checkMail(obj) {
                if (!validateData2("email", this.ITEM_FORM.Email)) {
                    $("#mailMsg").show();
                    $("#mailMsg").html("بريد إلكترونى غير صحيح <br><font style='color:#005599;font-size:10px;'>For Example: youmail@yahoo.com</font>");
                } else {
                    $("#mailMsg").hide();
                    $("#mailMsg").html("");
                }

            }

            function changeImageState(checkBox) {
                if (checkBox.checked) {
                    document.getElementById("file1").disabled = false;
                    document.getElementById("imageName").value = "";
                } else {
                    document.getElementById("file1").disabled = true;
                }
            }

            function changePic() {
                var fileName = document.getElementById("file1").value;
                if (fileName.length > 0) {
                    if (fileName.indexOf("jpg") > -1 || fileName.indexOf("JPG") > -1) {
                        document.getElementById("itemImage").src = fileName;
                        document.getElementById("imageName").value = fileName;
                        document.getElementById("file1").value = '';
                    } else {
                        alert("Invalid Image type, required JPG Image.");
                        document.getElementById("itemImage").src = 'images/no_image.jpg';
                        document.getElementById("imageName").value = "";
                        document.getElementById("file1").select();
                    }
                } else {
                    document.getElementById("itemImage").src = 'images/no_image.jpg';
                    document.getElementById("imageName").value = "";
                }
            }
        </SCRIPT>
        <STYLE>
            #products_table{
                width: 100%;
                margin-top: 20px;
            }
            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                height:20px;
                border: none;
            }
            .login {
                /*display: none;*/
                direction: rtl;
                margin: 20px auto;
                padding: 10px 10px;
                /*        width:30%;*/
                background: #3f65b7;
                background-clip: padding-box;
                border: 1px solid #ffffff;
                border-bottom-color: #ffffff;
                border-radius: 5px;
                color: #ffffff;
                background: #7abcff; /* Old browsers */
                /* IE9 SVG, needs conditional override of 'filter' to 'none' */
                /*background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iIzdhYmNmZiIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiM0MDk2ZWUiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);*/
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
            }
            #products_table th{
                padding: 5px;
                font-size: 16px;
                background:#f1f1f1;
                font-family: arial;


            }
            #products_table td{
                font-size: 12px;
                border: none;
            }
            #season_table{
                width: 100%;
                margin-top: 20px;
            }
            #season_table th{
                padding: 5px;
                font-size: 16px;
                background:#f1f1f1;
                font-family: arial;
            }
            #season_table td{
                font-size: 12px;
                border: none;
            }
            .save {
                width:40px;
                height:32px;
                background-image:url(images/icons/check.png);
                background-position: bottom;
                background-repeat: no-repeat;
                cursor: pointer;
            }
            .save__ {
                width:20px;
                height:20px;
                background-image:url(images/icons/icon-32-publish.png);
                background-repeat: no-repeat;
                background-position: bottom;
                cursor: pointer;
                margin-right: auto;
                margin-left: auto;
            }
            .distribution{

                width:32px;
                height:32px;
                background-image:url(images/icons/status.png);
                background-position: bottom;
                background-repeat: no-repeat;
                cursor: pointer;
            }
            .remove {
                width:40px;
                height:32px;
                background-image:url(images/icons/remove.png);
                background-position: bottom;
                background-repeat: no-repeat;
                cursor: pointer;
            }

            .remove__{
                width:20px;
                height:20px;
                background-image:url(images/icons/remove1.png);
                background-position: bottom;
                background-repeat: no-repeat;
                cursor: pointer;
                margin-right: auto;
                margin-left: auto;
            }
            .businessNumTitle{
                background-color: #0088cc;
                color:white;
                font-size: 16px;
            }
            .businessNum{

                color: green;
                font-size: 16px;
            }
            .button_record{
                width:145px;
                height:31px;
                /*            margin: 4px;*/
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/Number.png);
            }
            .button_products{
                width:145px;
                height:31px;
                /*            margin: 4px;*/
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/products.png);
            }

            .seasonsBtn{
                width:145px;
                height:31px;
                /*            margin: 4px;*/
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/vote.png);
            }
            .degreeBtn{
                width:145px;
                height:31px;
                /*            margin: 4px;*/
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/grade.png);
            }
            .closeBtn{
                width:145px;
                height:31px;
                /*            margin: 4px;*/
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/close2.png);
            }
            .submitBtn{
                width:145px;
                height:31px;
                /*            margin: 4px;*/
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/submit.png);
            }
            #workMsg,#workExtMsg, #faxMsg,#telMsg,#mobileMsg,#salaryMsg,#mailMsg,#homeMsg,#numberMsg,#address_Msg{
                font-size: 14px;
                display: none;
                color: red;
                margin: 0px;
            }
            lable{
                text-align: center !important;
            }
        </style>
    </HEAD>

    <BODY>
        <FORM action=""  NAME="ITEM_FORM" METHOD="POST" enctype="multipart/form-data">
            <DIV style="color:blue;margin-bottom: 30px; width: 100%;">
                <div style="margin-left: auto; margin-right: auto;">
                    <button onclick="JavaScript:cancelForm();" class="closeBtn" style="margin-right: 2px;"></button>
                    <input  type="button" onclick="submitForm()" id='submitBtn' class="submitBtn" value="" style="display: inline-block;"/>
                </div>
            </DIV> 

            <fieldset class="set" style="border-color: #006699; width: 90%;margin-top: 20px;border-radius: 5px;">
                <table dir="<%=dir%>" align="<%=align%>" class="blueBorder" width="100%">
                    <tr>
                        <td style="text-align:center;border-color: #006699; width:100%;" class="blueBorder blueHeaderTD">
                            <FONT color='white' SIZE="+1"><%=title%></font>
                        </td>
                    </tr>
                </table>

                <%if (null != status) {%>
                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        <td class="td">
                            <% if (status.equalsIgnoreCase("ok")) {%>
                            <font size="4" color="green"> <%=sStatus%> </font>
                            <% } else {%>
                            <font size="4" color="red"> <%=fStatus%> </font>
                            <% }%>
                        </td>
                    </tr>
                </table>
                <%}%>

                <br>

                <table style="margin-bottom: 20px;background: #f9f9f9;display: block;" ALIGN="center"  dir="<%=dir%>" border="0" width="100%" id="saveEmp">
                    <TR>
                        <td style="width: 35%;border: 0px;margin-top: 0px;padding: 0px; vertical-align: top">
                            <table style=" margin: 0px;">
                                <tr id="numberRow" class="numberRow">
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="supplierNO2">
                                            <p><b style="color: #0000FF;"><%=emp_number%><font color="#FF0000">*</font></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td  style="<%=style%>"  class='TD' >
                                        <input  type="TEXT" style="width:40%;" name="empNO" ID="empNO" size="33" value="<%=empWbo.getAttribute("empNO")%>" disabled="true"  maxlength="10" class="empNumber" onkeyup="checkNumber(this)"autocomplete="off"  onkeypress="javascript:return isNumber2(event)" > 
                                    </td>
                                </tr>

                                <tr>
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="empName" >
                                            <p><b style=""><%=emp_name%><font color="#FF0000">*</font></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>"class='td'>
                                        <input type="TEXT" style="width:230px;background-color: #FFFF66;" name="empName" ID="empName" size="33" maxlength="255" value="<%=empWbo.getAttribute("empName")%>">
                                    </td>
                                </tr>

                                <tr>
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="mobile">
                                            <p><b style=""><%=emp_mobile%><font color="#FF0000">*</font></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>" class='td'>
                                        <input type="TEXT" style="width:230px;background-color: #FFFF66;" name="mobile" ID="mobile" size="11" maxlength="255" onkeypress="javascript:return isMobileNumber(event)" autocomplete="off" value="<%=empWbo.getAttribute("homePhone")%>">                                     
                                        <p id="mobileMsg"></p>
                                    </td>
                                </tr>

                                <tr >
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="gender" >
                                            <p><b><%=emp_gender%></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>" class='td'>
                                        <span><input type="radio" name="gender" value="ذكر" id="gender" <%if (empWbo.getAttribute("gender").equals("ذكر")) {%>checked="true"<%}%>/>  <font size="3" color="#005599"><b>ذكر</b></font></span>
                                        <span><input type="radio" name="gender" value="أنثى" id="gender" <%if (empWbo.getAttribute("gender").equals("أنثى")) {%>checked="true"<%}%>/>  <font size="3" color="#005599"><b>أنثى</b></font></span>
                                    </td>
                                </tr>

                                <tr >
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="matiralStatus" >
                                            <p><b><%=emp_Marital_Status%></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>" class='td'>
                                        <span><input type="radio" name="matiralStatus" value="أعزب" id="Marital_Status" <%if (empWbo.getAttribute("maritalStatus").equals("أعزب")) {%>checked="true"<%}%>/>  <font size="3" color="#005599"><b>أعزب</b></font></span>
                                        <span><input type="radio" name="matiralStatus" value="متزوج" id="Marital_Status" <%if (empWbo.getAttribute("maritalStatus").equals("متزوج")) {%>checked="true"<%}%> />  <font size="3" color="#005599"><b>متزوج</b></font></span>
                                        <span><input type="radio" name="matiralStatus" value="مطلق" id="Marital_Status" <%if (empWbo.getAttribute("maritalStatus").equals("مطلق")) {%>checked="true"<%}%> />  <font size="3" color="#005599"><b>مطلق</b></font></span>
                                    </td>
                                </tr>

                                <tr>
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="noes" >
                                            <p><b><%=emp_working_checkBox%></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>" class='td'>
                                        <span><input type="radio" name="workingType" value=" كل الوقت" id="workingType" <%if (empWbo.getAttribute("option1").equals("كل الوقت")) {%>checked="true"<%}%>/>  <font size="3" color="#005599"><b>كل الوقت</b></font></span>
                                        <span><input type="radio" name="workingType" value="جزء من الوقت" id="workingType" <%if (empWbo.getAttribute("option1").equals("جزء من الوقت")) {%>checked="true"<%}%> />  <font size="3" color="#005599"><b>جزء من الوقت</b></font></span>
                                        <span><input type="radio" name="workingType" value="بالساعة" id="workingType" <%if (empWbo.getAttribute("option1").equals("بالساعة")) {%>checked="true"<%}%> />  <font size="3" color="#005599"><b>بالساعة</b></font></span>
                                    </td>
                                </tr>
                            </TABLE>
                        </td>

                        <td style="width: 35%;border: 0px;margin-top: 0px;padding: 0px; vertical-align: top">
                            <table style=" margin: 0px;">
                                <tr>
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="email">
                                            <p><b><%=emp_mail%></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>" class='td'>
                                        <input type="TEXT" style="width:230px" name="Email" ID="Email" size="33" maxlength="100" onkeyup="checkMail(this.value)" value="<%=empWbo.getAttribute("email")%>">
                                        <p id="mailMsg" ></p>
                                    </td>
                                </tr>

                                <tr>
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="Address" >
                                            <p><b style=""><%=emp_address%><font color="#FF0000">*</font></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>"class='td'>
                                        <TEXTAREA  style="width:230px"  rows="3" name="Address" dir="<%=dir%>" ID="Address" cols="25"><%=empWbo.getAttribute("address")%></TEXTAREA>
                                    </td>
                                </tr>

                                <tr>
                                    <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                        <LABEL FOR="noes" >
                                            <p><b><%=emp_notes%></b>&nbsp;
                                        </LABEL>
                                    </td>
                                    <td style="<%=style%>" class='td'>
                                        <TEXTAREA  style="width:230px"  rows="5" name="Note" dir="<%=dir%>" ID="Note" cols="25"><%=empWbo.getAttribute("note")%></TEXTAREA>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                                    
                <input type="hidden" name="empID" value="<%=empWbo.getAttribute("empId")%>">
            </FIELDSET>
        </Form>
    </Body>
</HTML>