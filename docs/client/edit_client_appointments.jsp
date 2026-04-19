<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            String stat = (String) request.getSession().getAttribute("currentMode");

            int iTotal = 0;
            ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
            ArrayList<WebBusinessObject> usersList = (ArrayList<WebBusinessObject>) request.getAttribute("usersList");
            ArrayList<WebBusinessObject> ratesList = (ArrayList<WebBusinessObject>) request.getAttribute("ratesList");
            Map<String, ArrayList<WebBusinessObject>> dataResult = (HashMap<String, ArrayList<WebBusinessObject>>) request.getAttribute("dataResult");
            ArrayList<WebBusinessObject> campaignsList = (ArrayList<WebBusinessObject>) request.getAttribute("campaignsList");
            String campaignID = request.getAttribute("campaignID") != null ? (String) request.getAttribute("campaignID") : "";

            String fromDate = "";
            if (request.getAttribute("fromDate") != null) {
                fromDate = (String) request.getAttribute("fromDate");
            }
            String toDate = "";
            if (request.getAttribute("toDate") != null) {
                toDate = (String) request.getAttribute("toDate");
            }
            String createdBy = "";
            if (request.getAttribute("createdBy") != null) {
                createdBy = (String) request.getAttribute("createdBy");
            }
            String rateID = "";
            if (request.getAttribute("rateID") != null) {
                rateID = (String) request.getAttribute("rateID");
            }
            String appointmentType = "";
            if (request.getAttribute("appointmentType") != null) {
                appointmentType = (String) request.getAttribute("appointmentType");
            }
            String result = "all";
            if (request.getAttribute("result") != null) {
                result = (String) request.getAttribute("result");
            }
            //Privileges
            ArrayList<String> privilegesList = GroupPrevMgr.getInstance().getGroupPrivilegeCodes((String) ((WebBusinessObject) request.getSession().getAttribute("loggedUser")).getAttribute("groupID"));

            String reportType = (String) request.getAttribute("reportType");

            String align = "center";
            String dir = null;
            String style = null, lang, langCode, title, fromD, toD, dep, emp, classification,
                    typ, all, code, name, calls, meeting, srch, tel, mail,
                    notes, regDate, secDate, appDate, app, status, call, met,
                    reslt, sysDur, actDur, noCom, dirApp, metDate, answered, notAnswered,
                    attended, notAttended, appointDate, registrationDate, campaign, sDur,aDur,
                    mobile, updated, notUpdated, meetingType;

            if (stat.equals("En")) {
                align = "left";
                dir = "LTR";
                style = "text-align:right";
                title = "Update Clients Calls/Meetings";
                fromD = "From Date";
                toD = "To Date";
                dep = "Department";
                emp = "Employee";
                classification = "Classification";
                all = "All";
                typ = "Type";
                code = "Client Code";
                name = "Client Name";
                calls = "Calls";
                meeting = "Meetings";
                srch = "Search";
                tel = "International No.";
                mail = "Email";
                notes = "Notes";
                regDate = "Registration Date";
                secDate = "Scheduling Date";
                appDate = "Appointment Date";
                app = "Appointment";
                status = "Status";
                call = "Call";
                met = "Meeting";
                reslt = "Result";
                sysDur = "S.D";
                actDur = "A.D";
                noCom = "No Comment";
                dirApp = "Direct Appointment";
                metDate = "Determine Meeting With Date";
                answered = "Answered";
                notAnswered = "Not Answered";
                attended = "Attended";
                notAttended = "Not Attended";
                appointDate = "Appointment Date";
                registrationDate = "Client Registration Date";
                campaign = "Campaign";
                sDur = "System Duration";
                aDur = "Actual Duration";
                mobile = "Mobile No.";
                updated = "Appointment Updated Successfully";
                notUpdated = "Appointment Not Updated";
                meetingType = "Meeting Type";
            } else {
                dir = "RTL";
                align = "right";
                style = "text-align:Right";
                title = "تعديل مكالمات / مقابلات العملاء";
                fromD = "من تاريخ";
                toD = "إلي تاريخ";
                dep = "الإدارة";
                emp = "الموظف";
                classification = "التصنيف";
                typ = "النوع";
                all = "الكل";
                code = "كود العميل";
                name = "اسم العميل";
                calls = "مكالمات";
                meeting = "مقابلات";
                srch = "بحث";
                tel = "الرقم الدولى";
                mail = "البريد الاكتروني";
                notes = "ملاحظات";
                regDate = "تاريخ التسجيل";
                secDate = "تاريخ الجدولة";
                appDate = "تاريخ المتابعة";
                app = "المتابعة";
                status = "حالة";
                call = "المكالمه";
                met = "المقابله";
                reslt = "النتيجة";
                sysDur = "م.ن";
                actDur = "م.ف";
                noCom = "لا يوجد";
                dirApp = "متابعة مباشرة";
                metDate = "تحديد مقابلة بتاريخ";
                answered = "تم الرد";
                notAnswered = "لم يتم الرد";
                attended = "تم الحضور";
                notAttended = "لم يتم الحضور";
                appointDate = "تاريخ المتابعة";
                registrationDate = "تاريخ تسجيل العميل";
                campaign = "الحملة";
                sDur = "مدة النظام";
                aDur = "المدة الفعلية";
                mobile = "رقم الموبايل";
                updated = "تم التعديل بنجاح";
                notUpdated = "لم يتم التعديل";
                meetingType = "نوع المقابلة";
            }

            ArrayList<WebBusinessObject> departments = (ArrayList<WebBusinessObject>) request.getAttribute("departments");
            String departmentID = request.getAttribute("departmentID") != null ? (String) request.getAttribute("departmentID") : "";
            String dateType = request.getAttribute("dateType") != null ? (String) request.getAttribute("dateType") : "app";
        %>
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
    </HEAD>
    <script type="text/javascript">
        $(document).ready(function () {
//            $("#slectEmp").select2();

            $("#fromDate, #toDate").datepicker({
                changeMonth: true,
                changeYear: true,
                maxDate: 0,
                dateFormat: "yy/mm/dd"
            });
        });
        function openInNewWindow(url) {
            var win = window.open(url, '_blank');
            win.focus();
        }
        ;
        function getEmployees(obj, afterLoad) {
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
                        output.push('<option value="all">' + "الكل" + '</option>');
                        var createdBy = $("#createdBy");
                        $(createdBy).html("");
                        var info = $.parseJSON(jsonString);
                        for (i = 0; i < info.length; i++) {
                            var item = info[i];
                            output.push('<option value="' + item.userId + '">' + item.fullName + '</option>');
                        }
                        createdBy.html(output.join(''));
                        if (afterLoad) {
                            selectedUser();
                        }
                    } catch (err) {
                        var output = [];
                        output.push('<option value="all">' + "الكل" + '</option>');
                        createdBy.html(output.join(''));
                    }
                }
            });
        }
        function selectedUser() {
        <%
            if (!createdBy.isEmpty()) {
        %>
            $("#createdBy").val('<%=createdBy%>');
        <%
            }
        %>
        }
        function changeType() {
            if ($("#appointmentType").val() === 'call') {
                $("#answeredTD").show();
                $("#notAnsweredTD").show();
                $("#attendedTD").hide();
                $("#notAttendedTD").hide();
            } else {
                $("#answeredTD").hide();
                $("#notAnsweredTD").hide();
                $("#attendedTD").show();
                $("#notAttendedTD").show();
            }
        }
        function selectAll() {
            $('#allResult').prop("checked", true);
        }

        function updateAppResult (appointmentID, index){
            var newResult = $("#appTyp" + index + " option:selected").val();
            alert(newResult);
            $.ajax({
                type: "post",
                url: "<%=context%>/AppointmentServlet?op=updateApp",
                data: {
                    appointmentID: appointmentID,
                    newResult: newResult
                },
                success: function (jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'ok') {
                        alert("<%=updated%>");
                        location.reload();
                    } else {
                        alert("<%=notUpdated%>");
                    }
                }
            });
        }

        function updateMeetingType (appointmentID, index){
            var newType = $("#meetingType" + index + " option:selected").val();
            $.ajax({
                type: "post",
                url: "<%=context%>/AppointmentServlet?op=updateMeetingType",
                data: {
                    appointmentID: appointmentID,
                    newType: newType
                },
                success: function (jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status === 'ok') {
                        alert("<%=updated%>");
                        location.reload();
                    } else {
                        alert("<%=notUpdated%>");
                    }
                }
            });
        }
        function deleteAppointment(id) {
            var r = confirm('حذف متابعة! لا يمكن التراجع متأكد؟');
            if (r) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/AppointmentServlet?op=deleteAppointment",
                    data: {
                        rowId: id
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'Ok') {
                            alert("Appointment Has Been Deleted");
                            location.reload();
                        }
                    }
                });
            }
        }

    </script>
    <style>
        .odd_main {
            height: 100;
            border-right:.5px solid #D9E6EC;
            border-bottom:0px solid #D9E6EC;
            padding: 3px;
            border-top:0px solid #D9E6EC;
            font-size: 12px;
            word-wrap: break-word;
            background-color: #e3e3e3;
        }
        .even_main {
            height: 100;
            border-right:.5px solid #D9E6EC;
            border-bottom:0px solid #D9E6EC;
            padding: 3px;
            border-top:0px solid #D9E6EC;
            font-size: 12px;
            word-wrap: break-word;
            background-color: #f3f3f3;
        }

        textarea {width: 100%;   height: 100%; text-align: center; border: none; padding: 10px;}

        #hideANDseek{ display: none;}
    </style>

    <body>
        <fieldset class="set" style="border-color: #006699; width: 90%;margin-top: 10px;border-radius: 5px;">
            <form name="SEARCH_CLIENT_FORM" action="<%=context%>/AppointmentServlet?op=updateClientAppointments" method="POST">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="red" size="4"><%=title%></font>
                        </td>
                    </tr>
                </table>
                <br/>
                <table ALIGN="center" DIR="RTL" WIDTH="50%" CELLSPACING=2 CELLPADDING=1>
                    <%
                        if (reportType == null) {
                    %>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="5%">
                            <input type="radio" name="dateType" value="app" <%="app".equals(dateType) ? "checked" : ""%>/>
                        </td>
                        <td bgcolor="#dedede" valign="middle" width="38%">
                            <font style="font-size: 15px;">
                            <%=appointDate%>
                            </font>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="5%">
                            <input type="radio" name="dateType" value="registration" <%="registration".equals(dateType) ? "checked" : ""%>/>
                        </td>
                        <td bgcolor="#dedede" valign="middle" width="38%">
                            <font style="font-size: 15px;">
                            <%=registrationDate%>
                            </font>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 50%;" colspan="2">
                            <b><font size=3 color="white"><%=fromD%></b>
                        </td>
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px; width: 50%;"colspan="2">
                            <b> <font size=3 color="white"><%=toD%></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" colspan="2">
                            <input id="fromDate" name="fromDate" type="text" value="<%=fromDate%>" style="margin: 10px;"/>
                        </td>
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle" colspan="2">
                            <input id="toDate" name="toDate" type="text" value="<%=toDate%>" />
                        </td>
                    </tr>
                    <%
                        if (reportType == null) {
                    %>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                            <b><font size=3 color="white"> <%=dep%> </b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2"> 
                            <b><font size=3 color="white"> <%=emp%> </b>
                        </td>
                    </tr>
                    <tr>
                        <TD bgcolor="#dedede"  style="text-align:center" valign="middle" colspan="2">
                            <div id="mydiv">
                                <select id="departmentID" name="departmentID" style="font-size: 14px; width: 140px" onchange="JavaScript: getEmployees(this, false);">
                                    <option value="all"><%=all%></option>
                                    <sw:WBOOptionList wboList="<%=departments%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=departmentID%>" />
                                </select>
                            </DIV>
                        </TD>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE" colspan="2">
                            <select style="font-size: 14px;font-weight: bold; width: 170px;" name="createdBy" id="createdBy">
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                            <b><font size=3 color="white"><%=classification%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                            <b><font size=3 color="white"> <%=typ%> </b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede"  style="text-align:center" valign="middle" colspan="2">
                            <div id="mydiv">
                                <select style="font-size: 14px;font-weight: bold; width: 170px;" id="rateID" name="rateID">
                                    <option value=""><%=all%></option>
                                    <sw:WBOOptionList wboList='<%=ratesList%>' displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=rateID%>"/>
                                </select>
                                <br/>
                                <br/>
                                <br/>
                            </div>
                        </td>
                        <td bgcolor="#dedede"  style="text-align:center" valign="middle" colspan="2">
                            <div id="mydiv">
                                <select style="font-size: 14px;font-weight: bold; width: 170px;" id="appointmentType" name="appointmentType"
                                        onchange="JavaScript: changeType(); selectAll();">
                                    <option value="call" <%=appointmentType.equals("call") ? "selected" : ""%>><%=calls%></option>
                                    <option value="meeting" <%=appointmentType.equals("meeting") ? "selected" : ""%>><%=meeting%></option>
                                </select>
                                <br/>
                                <table cellpadding="4" style="margin-left: auto; margin-right: auto;">
                                    <tr>
                                        <td class="td" style="font-size: 15px;">
                                            <input type="radio" name="result" id="allResult" value="all" <%=result.equals("all") ? "checked" : ""%>/><%=all%>
                                        </td>
                                        <td class="td" style="font-size: 15px;" id="answeredTD">
                                            <input type="radio" name="result" id="answered" value="answered" <%=result.equals("answered") ? "checked" : ""%>/><%=answered%>
                                        </td>
                                        <td class="td" style="font-size: 15px;" id="notAnsweredTD">
                                            <input type="radio" name="result" id="notAnswered" value="not answered" <%=result.equals("not answered") ? "checked" : ""%>/><%=notAnswered%>
                                        </td>
                                        <td class="td" style="font-size: 15px;" id="attendedTD">
                                            <input type="radio" name="result" id="attended" value="attended" <%=result.equals("attended") ? "checked" : ""%>/><%=attended%>
                                        </td>
                                        <td class="td" style="font-size: 15px;" id="notAttendedTD">
                                            <input type="radio" name="result" id="notAttended" value="not attended" <%=result.equals("not attended") ? "checked" : ""%>/><%=notAttended%>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="4">
                            <b><font size=3 color="white"><%=campaign%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle" colspan="4">
                            <select name="campaignID" id="campaignID" style="width: 300px;" class="chosen-select-campaign"
                                    onchange="JavaScript: getProjects(this);">
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
                    </TR>
                    <tr>
                        <td STYLE="text-align:center" bgcolor="#dedede" colspan="4">
                            <table ALIGN="center"  border="none">
                                <tr>
                                    <td>
                                        <button type="submit" onclick="JavaScript: search();"  STYLE="color: #27272A;font-size:15px;margin: 10px;font-weight:bold; width: 120px; "><%=srch%><IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                                    </td>

                                    <td>
                                        <a id="pdf" href="<%=context%>/AppointmentServlet?op=clientAppointmentPDF&userID=<%=createdBy%>&departmentID=<%=departmentID%>&appointmentType=<%=request.getAttribute("appointmentType")%>&fromDate=<%=fromDate%>&toDate=<%=toDate%>&rateID=<%=rateID%>&result=<%=result%>&campaignID=<%=campaignID%>&dateType=<%=dateType%>">
                                            <img style="margin: 3px" src="images/icons/pdf.png" width="24" height="24"/>
                                        </a>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <%
                    } else {
                    %>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="4">
                            <b><font size=3 color="white"> <%=typ%> </b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede"  style="text-align:center" valign="middle" colspan="4">
                            <div id="mydiv">
                                <select style="font-size: 14px;font-weight: bold; width: 170px;" id="appointmentType" name="appointmentType"
                                        onchange="JavaScript: changeType(); selectAll();">
                                    <option value="call" <%=appointmentType.equals("call") ? "selected" : ""%>><%=calls%></option>
                                    <option value="meeting" <%=appointmentType.equals("meeting") ? "selected" : ""%>><%=meeting%></option>
                                </select>
                                <br/>
                                <table cellpadding="4" style="margin-left: auto; margin-right: auto;">
                                    <tr>
                                        <td class="td" style="font-size: 15px;">
                                            <input type="radio" name="result" id="allResult" value="all" <%=result.equals("all") ? "checked" : ""%>/><%=all%>
                                        </td>
                                        <td class="td" style="font-size: 15px;" id="answeredTD">
                                            <input type="radio" name="result" id="answered" value="answered" <%=result.equals("answered") ? "checked" : ""%>/><%=answered%>
                                        </td>
                                        <td class="td" style="font-size: 15px;" id="notAnsweredTD">
                                            <input type="radio" name="result" id="notAnswered" value="not answered" <%=result.equals("not answered") ? "checked" : ""%>/><%=notAnswered%>
                                        </td>
                                        <td class="td" style="font-size: 15px;" id="attendedTD">
                                            <input type="radio" name="result" id="attended" value="attended" <%=result.equals("attended") ? "checked" : ""%>/><%=attended%>
                                        </td>
                                        <td class="td" style="font-size: 15px;" id="notAttendedTD">
                                            <input type="radio" name="result" id="notAttended" value="not attended" <%=result.equals("not attended") ? "checked" : ""%>/><%=notAttended%>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td STYLE="text-align:center" bgcolor="#dedede" colspan="4">
                            <input type="hidden" name="reportType" value="<%=reportType%>"/>
                            <input type="hidden" name="appointmentType" value="<%=appointmentType%>"/>
                            <button type="submit" onclick="JavaScript: search();"  STYLE="color: #27272A;font-size:15px;margin: 10px;font-weight:bold; width: 120px; "><%=srch%><IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </table>
                <br/><br/>
                <div style="width: 95%;margin-left: auto;margin-right: auto;">
                    <TABLE class="blueBorder" id="clients" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0">
                        <thead>
                            <TR>
                                <TH class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" width="4%"><b>#</b></TH>
                                <TH class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" width="10%"><b><%=code%></b></TH>
                                <TH class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" width="35%"><b><%=name%></b></TH>
                                <TH class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" width="12%"><b><%=mobile%></b></TH>
                                <TH class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" width="12%"><b><%=tel%></b></TH>
                                <TH class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" width="17%"><b><%=mail%></b></TH>
                                <TH class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" width="15%"><b><%=classification%></b></TH>
                            </TR>
                        </thead>  

                        <tbody  id="planetData2">
                            <%
                                if (data != null && data.size() > 0) {
                                    ArrayList<WebBusinessObject> appointmentsList;
                                    int index = 0;
                                    for (WebBusinessObject wbo : data) {
                                        iTotal++;
                                        appointmentsList = dataResult.get((String) wbo.getAttribute("clientID"));
                            %>
                            <TR style="padding: 1px;">
                                <TD>
                                    <%=iTotal%>
                                </td>

                                <TD>
                                    <%=wbo.getAttribute("clientNo")%>
                                </td>

                                <TD>
                                    <%=wbo.getAttribute("clientName")%>
                                    <a href="JavaScript: openInNewWindow('<%=context%>/ClientServlet?op=clientDetails&clientId='+<%=wbo.getAttribute("clientID")%>);"><img src="images/client_details.jpg" width="30" style="float: left;"></a>
                                </td>

                                <TD>
                                    <%=wbo.getAttribute("clientMobile")%>
                                </td>

                                <TD>
                                    <%=wbo.getAttribute("interPhone")%>
                                </td>

                                <TD>
                                    <%=wbo.getAttribute("clientEmail")%>
                                </td>
                                <td>
                                    <%=wbo.getAttribute("rateName")%>
                                </td>
                            </TR>
                            <TR style="padding: 1px;">
                                <TD class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px; background-repeat: repeat; display: none;" colspan="2">
                                    <%="meeting".equals(appointmentType) ? meeting : calls%>
                                </TD>
                                <TD colspan="7">
                                    <table style="width: 98%; margin: auto;" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" style="text-align: right;">
                                                <%=notes%>
                                            </td>
                                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px">
                                                <%=regDate%>
                                            </td>
                                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px">
                                                <%=secDate%>
                                            </td>
                                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px">
                                                <%=appDate%>
                                            </td>
                                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px">
                                                <%=emp%>
                                            </td>
                                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px">
                                                <%=app%>
                                            </td>
                                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px">
                                                <%
                                                    if (stat.equals("En")) {
                                                %>
                                                <%="meeting".equals(appointmentType) ? met : call%> <%=status%>
                                                <%} else {%>
                                                <%=status%> <%="meeting".equals(appointmentType) ? met : call%>
                                                <%}%>    
                                            </td>
                                            <%if (appointmentType.equals("meeting")) {%>
                                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px">
                                                <%=meetingType%>
                                            </td>
                                            <%}%>
                                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px">
                                                <%=reslt%>
                                            </td>
                                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" title="<%=sDur%>">
                                                <%=sysDur%>
                                            </td>
                                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px" title="<%=aDur%>">
                                                <%=actDur%>
                                            </td>
                                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="display:<%=appointmentType.equals("call") || "not attended".equals(result) ? "none" : ""%>;text-align:center; color:white; font-size:14px">
                                            </td>
                                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="display:<%=appointmentType.equals("call") || "not attended".equals(result) ? "none" : ""%>;text-align:center; color:white; font-size:14px">
                                            </td>
                                            <%
                                                if (privilegesList.contains("DELETE_APPOINTMENT")) {
                                            %>
                                            <td class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px">
                                            </td>
                                            <%
                                                }
                                            %>
                                        </tr>
                                        <%
                                            int counter = 0;
                                            String clazz, note, appointmentDate, currentStatusDate;
                                            for (WebBusinessObject appointmentWbo : appointmentsList) {
                                                String creationTime = (String) appointmentWbo.getAttribute("creationTime");
                                                if (creationTime != null && creationTime.length() > 16) {
                                                    creationTime = creationTime.substring(0, creationTime.lastIndexOf(":"));
                                                }
                                                if ((counter % 2) == 1) {
                                                    clazz = "odd_main";
                                                } else {
                                                    clazz = "even_main";
                                                }
                                                counter++;
                                                note = (appointmentWbo.getAttribute("comment") != null && !appointmentWbo.getAttribute("comment").toString().equalsIgnoreCase("UL")) ? (String) appointmentWbo.getAttribute("comment") : noCom;
                                                appointmentDate = appointmentWbo.getAttribute("appointmentDate") != null ? (String) appointmentWbo.getAttribute("appointmentDate") : "";
                                                if (appointmentDate.length() > 10) {
                                                    appointmentDate = appointmentDate.substring(0, appointmentDate.indexOf(" "));
                                                }
                                                currentStatusDate = appointmentWbo.getAttribute("currentStatusSince") != null ? (String) appointmentWbo.getAttribute("currentStatusSince") : "";
                                                if (currentStatusDate.length() > 10) {
                                                    currentStatusDate = currentStatusDate.substring(0, currentStatusDate.indexOf(" "));
                                                }
                                                switch (note) {
                                                    case "INSTANCE-FOLLOW-UP":
                                                        note = dirApp;
                                                        break;
                                                    case "meeting":
                                                        note = metDate + appointmentDate;
                                                        break;
                                                }
                                        %>
                                        <tr>
                                            <td class="<%=clazz%>">
                                                <TEXTAREA style="background-color: #ffd11a;font-weight: bold;"  readonly > <%=note%> </TEXTAREA>
                                                
                                            </td>
                                            <td class="<%=clazz%>">
                                                <%=creationTime%>
                                            </td>
                                            <td class="<%=clazz%>">
                                                <%=appointmentDate%>
                                            </td>
                                            <td class="<%=clazz%>">
                                                <%=currentStatusDate%>
                                            </td>
                                            <td class="<%=clazz%>">
                                                <%=appointmentWbo.getAttribute("createdByName")%>
                                            </td>
                                            <td class="<%=clazz%>">
                                                <%
                                                    if (stat.equals("En")) {
                                                %>
                                                <%=appointmentWbo.getAttribute("statusNameEn")%>
                                                <%} else {%>
                                                <%=appointmentWbo.getAttribute("statusNameAr")%>
                                                <%}%>
                                            </td>
                                            <td class="<%=clazz%>">
                                                <%if(appointmentType.equals("call")){%>
                                                    <select id="appTyp<%=index%>" name="appType">
                                                        <OPTION value="answered" <%=appointmentWbo.getAttribute("option9")!= null && appointmentWbo.getAttribute("option9").toString().equals("answered") ? "selected" : ""%>>answered</OPTION>
                                                        <OPTION value="not answered" <%=appointmentWbo.getAttribute("option9")!= null && appointmentWbo.getAttribute("option9").toString().equals("not answered") ? "selected" : ""%>>not answered</OPTION>
                                                    </select>
                                                <%} else if(appointmentType.equals("meeting")){%>
                                                    <select id="appTyp<%=index%>" name="appType">
                                                        <OPTION value="attended" <%=appointmentWbo.getAttribute("option9")!= null && appointmentWbo.getAttribute("option9").toString().equals("attended") ? "selected" : ""%>>attended</OPTION>
                                                        <OPTION value="not attended" <%=appointmentWbo.getAttribute("option9")!= null && appointmentWbo.getAttribute("option9").toString().equals("not attended") ? "selected" : ""%>>not attended</OPTION>
                                                    </select>
                                                <%}%> 
                                                <INPUT type="button" value="Update" onclick="updateAppResult('<%=appointmentWbo.getAttribute("id")%>', '<%=index%>')">
                                                <!--<%=appointmentWbo.getAttribute("option9") != null && !"UL".equals(appointmentWbo.getAttribute("option9")) ? appointmentWbo.getAttribute("option9") : ""%>-->
                                            </td>
                                            <%if (appointmentType.equals("meeting")) {%>
                                            <td class="<%=clazz%>">
                                                <select id="meetingType<%=index%>" name="meetingType">
                                                    <option value="meeting" <%="meeting".equals(appointmentWbo.getAttribute("option2")) ? "selected" : ""%>>Meeting</option>
                                                    <option value="ts-meeting" <%="ts-meeting".equals(appointmentWbo.getAttribute("option2")) ? "selected" : ""%>>TS Meeting</option>
                                                    <option value="sls-meeting" <%="sls-meeting".equals(appointmentWbo.getAttribute("option2")) ? "selected" : ""%>>SLS Meeting</option>
                                                </select>
                                                <input type="button" value="Update" onclick="updateMeetingType('<%=appointmentWbo.getAttribute("id")%>', '<%=index%>')">
                                            </td>
                                            <%}%> 
                                            <td class="<%=clazz%>">
                                                <%=appointmentWbo.getAttribute("note") != null && !"UL".equals(appointmentWbo.getAttribute("note")) ? appointmentWbo.getAttribute("note") : ""%>
                                            </td>
                                            <td class="<%=clazz%>">
                                                <%=appointmentWbo.getAttribute("option8") != null && !"UL".equals(appointmentWbo.getAttribute("option8")) ? appointmentWbo.getAttribute("option8") : ""%>
                                            </td>
                                            <td class="<%=clazz%>">
                                                <%=appointmentWbo.getAttribute("callDuration") != null && !"UL".equals(appointmentWbo.getAttribute("callDuration")) ? appointmentWbo.getAttribute("callDuration") : ""%>
                                            </td>
                                            <td style="display:<%=appointmentType.equals("call") || "not attended".equals(appointmentWbo.getAttribute("option9")) ? "none" : ""%>;" class="<%=clazz%>">
                                                <a target="blank" href="<%=context%>/AppointmentServlet?op=getClientsViewsInSpecificDay&clientId=<%=wbo.getAttribute("clientID")%>&date=<%=currentStatusDate%>">
                                                    <img src="images/icons/cart.png" width="30" style="float: left;" title="إظهار معاينات العميل">
                                                </a>
                                            </td>
                                            <td style="display:<%=appointmentType.equals("call") || "not attended".equals(appointmentWbo.getAttribute("option9")) ? "none" : ""%>;" class="<%=clazz%>">
                                                <a target="blank" href="<%=context%>/AppointmentServlet?op=getClientsPaymentPlansInSpecificDay&clientId=<%=wbo.getAttribute("clientID")%>&date=<%=currentStatusDate%>">
                                                    <img src="images/icons/paymentPlans.png" width="30" style="float: left;" title="إظهار خطط دفع العميل">
                                                </a>
                                            </TD>
                                            <%
                                                if (privilegesList.contains("DELETE_APPOINTMENT")) {
                                            %>
                                            <td class="<%=clazz%>">
                                                <a target="blank" href="JavaScript: deleteAppointment('<%=appointmentWbo.getAttribute("id")%>');">
                                                    <img src="images/icons/delete_ready.png" width="25" style="float: left;" title="حذف المتابعة">
                                                </a>
                                            </td>
                                            <%
                                                }
                                            %>
                                        </tr>
                                        <%
                                                index++;
                                            }
                                        %>
                                    </table>
                                </TD>
                            </TR>
                            <tr>
                                <td colspan="10" class="blueBorder blueHeaderTD" bgcolor="#669900" STYLE="text-align:center; color:white; font-size:14px"><b>&nbsp;</b></td>
                            </tr>
                            <%
                                    }
                                }%>
                        </tbody>
                    </TABLE>
                </div>
            </form>
        </fieldset>
        <script language="JavaScript" type="text/javascript">
            getEmployees($("#departmentID"), true);
            changeType();
        </script>
    </body>
</html>
