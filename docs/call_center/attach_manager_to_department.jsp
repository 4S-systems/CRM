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
        
        String type = (String) request.getAttribute("type");
        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;

        String fromDate, save, dir, selectStr, title, alignX, name, assistantStr, employeeTypeStr, currentStatus, newStatus, code;

        int flipper = 0;
        String bgColor = null;
        String bgColorm = null;

        if (stat.equals("En")) {
            dir = "LTR";
            title = "Directing Managements";
            save = "Save";
            fromDate = "As of";
            selectStr = "Select";
            alignX = "right";
            assistantStr = "Support";
            name = "Department Name";
            employeeTypeStr = "Employee Type";
            currentStatus = "Current Status";
            newStatus = "New Status";
            code = "code";

        } else {
            dir = "RTL";
            save = "حفظ";
            title = "توجيه الإدارات";
            fromDate = "إعتبارا من";
            selectStr = "إختر";
            alignX = "left";
            assistantStr = "خدمة عملاء";
            name = "اسم الأدارة";
            code = "كود الإدارة";
            employeeTypeStr = "الإدارات";
            currentStatus = "المدير الحالى";
            newStatus = "المدير الجديد";
        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>قائمة المديرين</TITLE>
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
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <link rel="stylesheet" href="jquery-ui/demos/demos.css">

        <script src='ChangeLang.js' type='text/javascript'></script>
        <script type="text/javascript" src="js/common.js"></script>
        <script type="text/javascript" src="js/silkworm_validate.js"></script>

        <script type="text/javascript">

            var form = null;

            $(document).ready(function() {

                $(".datepick").datepicker({
                    maxDate: "+d",
                    minDate: new Date(),
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy/mm/dd',
                    beforeShow: function(textbox, instance) {
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

                if ($("#empType" + itemIndex).is(":checked")) {
                    $("#userName" + itemIndex).attr("disabled", false);
                    $("#fromDate" + itemIndex).attr("disabled", false);

                } else {

                    $("#userName" + itemIndex).val($("#userName" + itemIndex).find("option:first").val());
                    $("#userName" + itemIndex).attr("disabled", true);
                    $("#fromDate" + itemIndex).val("");
                    $("#fromDate" + itemIndex).attr("disabled", true);

                }

            }

            function cancelForm(url)
            {
                window.navigate(url);
            }

            function submitForm() {
                document.ATTACH_EMPLOYEES_TO_CAR_FORM.action = "<%=context%>/EmployeeServlet?op=saveRelationBtwEqAndEmp&backTo=prima&type=<%=type%>";
                document.ATTACH_EMPLOYEES_TO_CAR_FORM.submit();
            }

            function clearEmpId(index) {
                $("#userId" + index).val('');

            }

            function clearUnitId() {
                $("#unitId").val('');

            }

            function updateEqpEmpData(c, x) {

                var unitId = $("#id").val();
                var managerId = $("#userId" + x).val();
                var fromDate = $("#fromDate" + x).val();
                var departmentId = $("#departmentId" + x).val();

                var empType;
                var curFromDate;

                if (managerId == null || managerId == '') {
                    alert("Please choose a valid new employee!");

                } else {
                    $("#save" + x).html("<img src='images/icons/spinner.gif'/>");
//                    $("#curEmpName" + x).html("<img src='images/icons/spinner.gif'/>");

                    $.ajax({
                        type: "post",
                        url: "<%=context%>/ProjectServlet?op=updateDepartmentManager",
                        data: {
                            managerId: managerId,
                            departmentId: departmentId
                        },
                        success: function(jsonString) {
                            var eqpEmpInfo = $.parseJSON(jsonString);

                            if (eqpEmpInfo.status == 'ok') {

                                // set min date of datepicker to current date

                                $("#curEmpName" + x).html("");
                                $("#curEmpName" + x).html(eqpEmpInfo.managerName);
                                $("#save" + x).html("");
                                $("#save" + x).css("background-position", "top");

                            } else if (eqpEmpInfo.status === 'exist') {
                                $("#save" + x).html("");
                                $("#save" + x).css("background-position", "bottom");
                                alert("هذا المدير مدير لأحدي الأدارات بالفعل");
                            }
                        }
                    });
                }
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

                for (var i = 0; i < 3; i++) {
                    $("#userName" + i).val("");
                    $("#userId" + i).val("");
                    $("#save" + i).css("background-position", "bottom");

                }

                $.ajax({
                    dataType: "text",
                    type: "GET",
                    data: {clientId: $("#id").val()},
                    success: setUnitInfo,
                    url: "<%=context%>/ClientServlet?op=getClientEmployees",
                    cache: false
                });
            }

            function setUnitInfo(jsonString) {

                var unitInfoArr = $.parseJSON(jsonString);

                if (unitInfoArr != null) {
                    jQuery.each(unitInfoArr, function(index, unitInfo) {
                        $("#curEmpName" + index).html(unitInfo.userName);
                        $("#fromDate" + index).val(unitInfo.fromDate);
                        $("#fromDate" + index).datepicker("option",
                        "minDate",
                        new Date(unitInfo.fromDate));

                    });
                }
            }
            
            function showEditPopup (departmentID, name, code) {
                $('#editDialog').css("display", "block");
                $("#departmentID").val(departmentID);
                $("#name").val(name);
                $("#code").val(code);
                $('#editDialog').bPopup({});
            }
            function update () {
                var departmentID = $("#departmentID").val();
                var name = $("#name").val();
                var code = $("#code").val();
                if (name === '' || code === '') {
                    alert("All data is required");
                } else {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/UsersServlet?op=updateDepartmentByAjax",
                        data: {
                            departmentID: departmentID,
                            name: name,
                            code: code
                        }, success: function(jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'ok'){
                                location.reload();
                            } else {
                                alert('Fail to update');
                            }
                        }
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
            .login {
                /*display: none;*/
                direction: rtl;
                margin: 20px auto;
                padding: 10px 5px;
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

                -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 0.67);
                -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 0.67);
                box-shadow:         0px 0px 17px rgba(255, 255, 255, 0.67);
                -webkit-border-radius: 20px;
                -moz-border-radius: 20px;
                border-radius: 20px;
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

    <BODY STYLE="background-color:#ffffb9">
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <FORM NAME="ATTACH_EMPLOYEES_TO_CLIENTS_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue; padding-left: 5%; padding-bottom: 10px; padding-top: 10px;">

                <%--
                <button  onclick="JavaScript: submitForm();" class="button"><%=save%></button>
                --%>
            </DIV>
            <CENTER>
                <FIELDSET class="set" style="width:90%;border-color: #006699;" >

                    <div style="width:20%;float: right;text-align: right;margin-bottom: 7px;margin-right: 10px;">
                        <b style="color: red;font-size: 18px;"><%=title%></b>
                        <hr>
                           
                        </hr>
                    </div>
                    <DIV id="tblDataDiv" style="display: block;">
                        <TABLE id="tblData" class="blueBorder" ALIGN="center" dir="<%=dir%>" width="90%" cellpadding="0" cellspacing="0">
                            <TR>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b>#</b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="15%"><b><%=employeeTypeStr%></b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="15%"><b><%=code%></b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="25%"><b><%=currentStatus%></b></TD>
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="35%"><b><%=newStatus%></b></TD>
                                <!--<TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="15%"><b><%=fromDate%></b></TD>-->
                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b><%=save%></b></TD>

                            </TR>


                            <%
                                int i = 0;
                                int x = 1;
                                flipper++;

                                if ((flipper % 2) == 1) {
                                    bgColor = "silver_odd";
                                    bgColorm = "silver_odd_main";

                                } else {
                                    bgColor = "silver_even";
                                    bgColorm = "silver_even_main";

                                }

                                Vector<WebBusinessObject> data = new Vector();
                                data = (Vector) request.getAttribute("departments");
                                String managerName;
                                if (data != null) {
                                    for (WebBusinessObject wbo : data) {
                                        String projectName = (String) wbo.getAttribute("projectName");
                                        String departmentId = (String) wbo.getAttribute("projectID");
                                        String option_one = (String) wbo.getAttribute("optionOne");
                                        String codeDep = (String) wbo.getAttribute("eqNO");
                                        WebBusinessObject wbo2 = new WebBusinessObject();
                                        UserMgr userMgr = UserMgr.getInstance();
                                        managerName = "-----";
                                        wbo2 = userMgr.getOnSingleKey(option_one);
                                        if (wbo2 != null) {
                                            managerName = (String) wbo2.getAttribute("userName");
                                        }
                            %>


                            <TR>
                                <TD CLASS="<%=bgColorm%>" nowrap style="text-align: center;"><%=x%></TD>

                                <TD CLASS="<%=bgColor%>" nowrap style="text-align: center;" title="<%=departmentId%>">
                                    <%=projectName%>
                                    <img src="images/edit.png" width="50" align="center" onclick="JavaScript: showEditPopup('<%=departmentId%>', '<%=projectName%>', '<%=codeDep%>');"
                                         style="float: <%=alignX%>; cursor: hand;"/>
                                </TD>
                                <TD CLASS="<%=bgColor%>" nowrap style="text-align: center;">
                                    <%=codeDep%>
                                </TD>
                                <TD CLASS="<%=bgColor%>" nowrap style="text-align: center;">
                                    <div id="curEmpName<%=i%>"><%=managerName%></div>
                                </TD>

                                <TD CLASS="<%=bgColor%>" nowrap style="text-align: center;">
                                    <input type="text" name="userName<%=i%>" id="userName<%=i%>" onchange="JavaScript: clearEmpId(<%=i%>)" style="width:200px;text-align:center" onclick="return getDataInPopup('UsersServlet?op=listManager&fieldName=USER_NAME&departmentId=<%=departmentId%>&itemNo=<%=i%>&fieldValue=' + getASSCIChar(document.getElementById('userName<%=i%>').value));" />
                                    <input type="button" name="search" id="search" class="button" value="<%=selectStr%>" onclick="return getDataInPopup('UsersServlet?op=listManager&fieldName=USER_NAME&departmentId=<%=departmentId%>&itemNo=<%=i%>&fieldValue=' + getASSCIChar(document.getElementById('userName<%=i%>').value));" STYLE="height: 25px;font-size:15px;color:black;font-weight:bold;width:60px" />
                                    <input type="hidden" name="userId" id="userId<%=i%>" />
                                </TD>

                                <TD CLASS="<%=bgColor%>" nowrap style="text-align: center;">
                                    <%--<input type="checkbox" name="empType<%=i%>" id="empType<%=i%>" value="<%=i%>" onClick="toggleItem(<%=i%>);" />--%>
                                    <input type="hidden" value="<%=departmentId%>" id="departmentId<%=i%>" />
                                    <div id="save<%=i%>" class="save" style="background-position: bottom;" onclick="updateEqpEmpData('NotApproved', <%=i%>);" ></div>
                                </TD>
                            </TR>
                            <%    i++;
                                            x++;
                                    }
                                }
                            %>


                        </TABLE>
                    </DIV>

                    <br><br>

                </FIELDSET>
            </CENTER>
        </FORM>
        <div id="editDialog" style="width: 35%;display: none;position: fixed;margin-left: auto;margin-right: auto" >
            <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                    -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                    box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                    -webkit-border-radius: 20px;
                    -moz-border-radius: 20px;
                    border-radius: 20px;" onclick="closePopup(this)"/>
            </div>
            <div class="login" style="width: 90%;text-align: center">
                <table class="table " style="width:100%;">
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;"><%=name%></td>
                        <td width="70%"style="text-align:right;">
                            <input type="text" id="name" name="name"/>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" style="color:#f1f1f1; font-size: 16px;font-weight: bold;"><%=code%></td>
                        <td width="70%"style="text-align:right;">
                            <input type="text" id="code" name="code"/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="color:#f1f1f1; font-size: 16px;font-weight: bold;"> 
                            <input type="hidden" id="departmentID" name="departmentID"/>
                            <input class="button" type="button" onclick="update();" style="width: 120px; color: #000; font-size:15px; font-weight:bold;" value="<%=save%>">
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </BODY>
</HTML>