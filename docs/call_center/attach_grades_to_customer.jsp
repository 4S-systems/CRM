<%@page import="com.clients.db_access.CustomerGradesMgr"%>
<%@page import="com.clients.db_access.CustomerGradesMgr"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@ page import="com.maintenance.common.ConfigFileMgr" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page pageEncoding="UTF-8"%>
<HTML>
    <%
                TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
                MetaDataMgr metaMgr = MetaDataMgr.getInstance();
                String context = metaMgr.getContext();
                CustomerGradesMgr customerGradesMgr=CustomerGradesMgr.getInstance();
                Vector employeeList = (Vector) request.getAttribute("employeeList");
                ArrayList allGrades=customerGradesMgr.getGrades();
                String empIdStr = null, empNameStr = null;

                WebBusinessObject empWbo = null;

                Calendar cal = Calendar.getInstance();
                String jDateFormat = "yyyy/MM/dd";
                SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
                String nowTime = sdf.format(cal.getTime());
                String type = (String) request.getAttribute("type");
                String cMode = (String) request.getSession().getAttribute("currentMode");
                String stat = cMode;

                String search, cancel, fromDate, save, dir, style, selectStr, lang, langCode,
                        title, back, employeeStr,gradeName, supervisorStr, driverStr, assistantStr, employeeTypeStr,
                        currentStatus, newStatus, carStr, dir1;

                int flipper = 0;
                String bgColor = null;
                String bgColorm = null;

                String textAlign;

                if (stat.equals("En")) {
                    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                    style = "text-align:left";
                    langCode = "Ar";
                    dir = "LTR";
                    dir1 = "left";
                    cancel = "Cancel";
                    title = "Attach Grades to a Customer";
                    search = "Search";
                    back = "Back";
                    save = "Save";
                    fromDate = "As of";
                    selectStr = "Select";
                    employeeStr = "Employee";

                    supervisorStr = "Normal";
                    assistantStr = "Assistant";
                    driverStr = "Driver";
                    employeeTypeStr = "Employee Name";
                    currentStatus = "Current Degree";
                    newStatus = "New Degree";
                    carStr = "Customer";
                    gradeName="en_desc";

                } else {
                    lang = "   English    ";
                    style = "text-align: right";
                    langCode = "En";
                    dir = "RTL";
                    dir1 = "right";
                    back = "العودة";
                    save = "حفظ";
                    cancel = tGuide.getMessage("cancel");
                    title = "درجة العميل";
                    search = "بحث";
                    fromDate = "إعتبارا من";
                    selectStr = "إختر";
                    employeeStr = "العامل";

                    supervisorStr = "عادي";
                    assistantStr = "تباع";
                    driverStr = "سائق";

                    employeeTypeStr = "الوضع الحالي";
                    currentStatus = "الوضع الحالى";
                    newStatus = "الوضع الجديد";
                    carStr = "العميل";
                    gradeName="ar_desc";
                }

                String[] employeeTypeArr = new String[]{supervisorStr};
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">

        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <link rel="stylesheet" href="jquery-ui/demos/demos.css">

        <script src='ChangeLang.js' type='text/javascript'></script>
        <script type="text/javascript" src="js/common.js"></script>
        <script type="text/javascript" src="js/silkworm_validate.js"></script>

        <script type="text/javascript">

            var form = null;

            $(document).ready(function(){
                
                $( ".datepick" ).datepicker({
                    maxDate    : "+d",
                    minDate    : new Date(),
                    changeMonth: true,
                    changeYear : true,
                    dateFormat : 'yy/mm/dd',
                    beforeShow: function (textbox, instance) {
                        instance.dpDiv.css({
                            marginTop: '-197px',
                            marginLeft: (-textbox.offsetWidth + 60) + 'px'
                        });
                    }
                });
              
            });
            /*
            function getEquipmentInPopup(){
                getDataInPopup('ReportsServletThree?op=ListEquipments' + '&fieldName=UNIT_NAME&fieldValue=' + getASSCIChar(document.getElementById('unitName').value) + '&formName=ATTACH_EMPLOYEES_TO_CAR_FORM');
            }*/

            function toggleItem(itemIndex) {

                if($("#empType" + itemIndex).is(":checked")) {
                    $("#empName" + itemIndex).attr("disabled", false);
                    $("#fromDate" + itemIndex).attr("disabled", false);

                } else {

                    $("#empName" + itemIndex).val($("#empName" + itemIndex).find("option:first").val());
                    $("#empName" + itemIndex).attr("disabled", true);
                    $("#fromDate" + itemIndex).val("");
                    $("#fromDate" + itemIndex).attr("disabled", true);

                }

            }

            function cancelForm(url)
            {
                window.navigate(url);
            }

            function submitForm(){
                document.ATTACH_EMPLOYEES_TO_CAR_FORM.action = "<%=context%>/EmployeeServlet?op=saveRelationBtwEqAndEmp&backTo=prima&type=<%=type%>";
                document.ATTACH_EMPLOYEES_TO_CAR_FORM.submit();
            }

            function clearEmpId(index) {
                $("#empId" + index).val('');
                
            }

            function clearUnitId() {
                $("#unitId").val('');

            }

            function updateEqpEmpData(c, x) {

                var unitId = $("#clientId").val();
                var empId = document.getElementById("degreeId").value;
                //alert('degree----='+empId);
                var fromDate = $("#fromDate" + x).val();
                var empType;
                var curFromDate;

                switch(x) {
                    case 0:
                        empType = "Normal";
                        break;
                    
                    default:
                        empType = "Normal";

                }

                 
                    $("#save" + x).html("<img src='images/icons/spinner.gif'/>");
                    $("#curEmpName" + x).html("<img src='images/icons/spinner.gif'/>");

                    $.ajax({
                        type: "post",
                        url: "<%=context%>/ClientServlet?op=updateCustomerGrade",
                        data: {clientId: unitId,
                               degreeId: empId,
                               fromDate: fromDate
                               },
                        success: function(jsonString) {
                            var eqpEmpInfo = $.parseJSON(jsonString);

                            if(eqpEmpInfo.status == 'Ok') {
                                
                                // set min date of datepicker to current date
                                curFromDate = $("#fromDate" + x).datepicker('getDate');
                                $("#fromDate" + x).datepicker("option",
                                                    "minDate",
                                                    new Date(curFromDate.getTime()));
                                
                                $("#curEmpName" + x).html("");
                                $("#curEmpName" + x).html(eqpEmpInfo.empName);
                                $("#save" + x).html("");
                                $("#save" + x).css("background-position", "top");

                            }
                        }
                    });
                }
            

            function getUnattachedEmployees(formIndex) {

                form = document.getElementById("form" + formIndex);
                alert(form)
                alert(form.empName)
//                alert( $("#form1 input[name=empName]").val() );
//                var empName = form["empName"].value;
//                return getDataInPopup('EmployeeServlet?op=listUnattachedEmployees&fieldName=EMP_NAME&itemNo=' + formIndex + '&fieldValue=' + getASSCIChar(empName));

            }

            function updateUnitInfo() {

                for(var i = 0; i < 3; i++) {
                    $("#empName" + i).val("");
                    $("#empId" + i).val("");
                    $("#save" + i).css("background-position", "bottom");

                }
                
                $.ajax({
                    dataType: "text",
                    type: "GET",
                    data: {unitId: $("#unitId").val()},
                    success: setUnitInfo,
                    url: "<%=context%>/EquipmentServlet?op=getUnitEmployees",
                    cache: false
                });
            }

            function setUnitInfo(jsonString) {

                var unitInfoArr = $.parseJSON(jsonString);

                if(unitInfoArr != null) {
                    jQuery.each(unitInfoArr, function(index, unitInfo) {
                        $("#curEmpName" + index).html(unitInfo.empName);
                        $("#fromDate" + index).val(unitInfo.fromDate);
                        $("#fromDate" + index).datepicker("option",
                                                "minDate",
                                                new Date(unitInfo.fromDate));
                     
                    });
                }
            }

        </script>


        <style type="text/css">
            #showHide{
                /*background: #0066cc;*/
                border: none;
                padding: 10px;
                font-size: 16px;
                font-weight: bold;
                color: #0066cc;
                cursor: pointer;
                padding: 5px;
            }
            #dropDown{
                position: relative;
            }
            .backStyle{
                border-bottom-width:0px;
                border-left-width:0px;
                border-right-width:0px;
                border-top-width:0px
            }

            .datepick {}

            .save {
                width:20px;
                height:20px;
                background-image:url(images/icons/icon-32-publish.png);
                background-repeat: no-repeat;
                cursor: pointer;
            }

        </style>
    </HEAD>

    <BODY STYLE="background-color:#ffffb9">
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <FORM NAME="ATTACH_GRADES_TO_CUSTOMERS_FORM" METHOD="POST">
        <DIV align="left" STYLE="color:blue; padding-left: 5%; padding-bottom: 10px; padding-top: 10px">
            <button  onclick="JavaScript: cancelForm('<%=context%>/main.jsp');" class="button"><%=back%></button>
            <%--
            <button  onclick="JavaScript: submitForm();" class="button"><%=save%></button>
            --%>
        </DIV>
        <CENTER>
            <FIELDSET class="set" style="width:90%;border-color: #006699;" >
                <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <TR>
                        <TD dir="<%=dir%>" style="text-align:center;border-color: #006699" width="100%" class="blueBorder blueHeaderTD"><font color="#006699" size="4"><%=title%></font></TD>
                    </TR>
                </TABLE>

                <br><br>
                <TABLE id="MaintNum" ALIGN="center" DIR="<%=dir%>" WIDTH="90%" CELLSPACING=0 CELLPADDING=0 BORDER="0" style="display: block;">

                    <TR>

<!--                        <TD style="<%=style%>; padding-<%=dir1%>: 5px;" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                            <p><b> <%=carStr%> <font color="#FF0000">*</font></b>
                        </TD>-->
                        <TD style="border: none; padding-<%=dir1%>: 5px;">
                            <!--<input type="TEXT" dir="left" name="name" ID="name" size="20" style="width:200px;" maxlength="255" onchange="JavaScript: clearUnitId();">-->
                            <input type="hidden" name="clientId" id="clientId" value="<%=request.getAttribute("clientId").toString()%>"/>
                            <!--<input type="button" class="button" name="search" id="search" value="<%=selectStr%>" onclick="getDataInPopup('ClientServlet?op=getCustomers&formName=ATTACH_GRADES_TO_CUSTOMERS_FORM&fieldName=Name&fieldValue='+getASSCIChar(document.getElementById('name').value));" STYLE="height: 25px;font-size:15px;color:black;font-weight:bold;width:60px">-->
                        </TD>

                    </TR>
                </TABLE>
                <br><br>

                <DIV id="tblDataDiv" style="display: block;">
                    <TABLE id="tblData" class="blueBorder" ALIGN="center" dir="<%=dir%>" width="90%" cellpadding="0" cellspacing="0">
                        <TR>
                            <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b>#</b></TD>
                            <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b><%=employeeTypeStr%></b></TD>
                            <!--<TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="30%"><b><%=currentStatus%></b></TD>-->
                            <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="35%"><b><%=newStatus%></b></TD>
                            <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="15%"><b><%=fromDate%></b></TD>
                            <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b><%=save%></b></TD>

                        </TR>
                        <%
                                    int iTotal = 0;
                                    for (int i = 0; i < 1; i++) {

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
                                <TD CLASS="<%=bgColorm%>" nowrap style="text-align: center;"><%=iTotal%></TD>

                                <TD CLASS="<%=bgColor%>" nowrap style="text-align: center;">
                                    <%=employeeTypeArr[i]%>
                                </TD>

                                <TD CLASS="<%=bgColor%>" nowrap style="text-align: center;">
                                    <!--<input type="text" name="empName<%=i%>" id="empName<%=i%>" onchange="JavaScript: clearEmpId(<%=i%>)" style="width:200px;text-align:center" />-->
<!--                                    <input type="button" name="search" id="search" class="button" value="<%=selectStr%>" onclick="return getDataInPopup('EmployeeServlet?op=listUnattachedEmployees&fieldName=EMP_NAME&itemNo=<%=i%>&fieldValue=' + getASSCIChar(document.getElementById('empName<%=i%>').value));" STYLE="height: 25px;font-size:15px;color:black;font-weight:bold;width:60px" />-->
                                    <SELECT name="degreeId" ID="degreeId" STYLE="width:233px;text-align:center;font-size:14px;font-weight: bold" ONCHANGE="JavaScript:getItemForm(this.value);">
                                        <sw:WBOOptionList wboList="<%=allGrades%>" displayAttribute = "<%=gradeName%>" valueAttribute="id"/>
                                    </SELECT>
                                </TD>

                                <TD CLASS="<%=bgColor%>" nowrap style="text-align: center;">
                                    <input readonly id="fromDate<%=i%>" name="fromDate<%=i%>" type="text" value="<%=nowTime%>" class="datepick" style="width: 100px;"/>
                                </TD>

                                <TD CLASS="<%=bgColor%>" nowrap style="text-align: center;">
                                    <%--<input type="checkbox" name="empType<%=i%>" id="empType<%=i%>" value="<%=i%>" onClick="toggleItem(<%=i%>);" />--%>
                                    <div id="save<%=i%>" class="save" style="background-position: bottom;" onclick="updateEqpEmpData('NotApproved', <%=i%>);" ></div>
                                </TD>
                            </TR>
                        <%}%>

                    </TABLE>
                </DIV>

                <br><br>

            </FIELDSET>
        </CENTER>
        </FORM>
    </BODY>
</HTML>