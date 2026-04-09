<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.crm.db_access.EmployeesLoadsMgr"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Sales_Market.Sales_Market"  />
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String stat = (String) request.getSession().getAttribute("currentMode");
        ArrayList<WebBusinessObject> projectList = (ArrayList<WebBusinessObject>) request.getAttribute("projectList");
        String align, dir, style = null;
        String sTitle, num, projectTitle, phone, email,searchButton, businessNo;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            sTitle = "Search for a Specific Client";
            num = "Unit Number";
            phone = "Phone\\Mobile\\Dialed\\Client Number";
            projectTitle = "Project";
            email = "Email";
            searchButton="Search";
            businessNo = "Business No.";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            sTitle = "بحث عن عميل محدد";
            num = "رقم الوحدة";
            phone = "رقم التليفون/الموبايل/الطالب/العميل";
            projectTitle = "المشروع";
            email = "البريد اﻷلكتروني";
            searchButton="بحث";
            businessNo = "رقم المتابعة";
        }
        ArrayList<WebBusinessObject> clientCampaignsList = (ArrayList<WebBusinessObject>) request.getAttribute("clientCampaignsList");
        ArrayList<WebBusinessObject>  clientLst = (ArrayList<WebBusinessObject> ) request.getAttribute("clientLst") != null ? (ArrayList<WebBusinessObject> ) request.getAttribute("clientLst") : null;
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE></TITLE>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link rel="stylesheet" href="css/chosen.css"/>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
    </HEAD>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#clients').dataTable({
                bJQueryUI: true,
                sPaginationType: "full_numbers",
                "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                iDisplayLength: 25,
                iDisplayStart: 0,
                "bPaginate": true,
                "bProcessing": true

            }).fadeIn(2000);
        });
        
        var searchTypeSt;
        function getClientInfo(searchType) {
            var num = $("#num").val();
            if (searchType != '') {
                searchTypeSt = searchType;
            }
            if (searchTypeSt == 'searchByPhone') {
                num = $("#phone").val();
            }
            if (searchTypeSt == 'searchByEmail') {
                num = $("#email").val();
            }
            $("#info").html("");
            
            var projectID = $("#projectID").val();
            if (num.length > 0) {
                var url = "<%=context%>/ClientServlet?op=getClientByNum&num=" + num + "&projectID=" + projectID + "&searchType=" + searchTypeSt;
                window.location.href = url;
            }
        }
        function popupAddComment() {
            $(".submenu").hide();
            $(".button_commen").attr('id', '0');
            $("#commMsg").hide();
            $("#commentArea").val("");
            $('#add_comments').css("display", "block");
            $('#add_comments').bPopup({easing: 'easeInOutSine',
                speed: 400,
                transition: 'slideDown'});
        }
        function saveComment(obj) {
            var clientId = $("#clientId").val();
            var type = $(obj).parent().parent().parent().find($("#commentType")).val();
            var comment = $("#commentArea").val();
            var businessObjectType = $(obj).parent().parent().parent().find($("#businessObjectType")).val();
            $(obj).parent().parent().parent().parent().find("#progress").show();
            $.ajax({
                type: "post",
                url: "<%=context%>/CommentsServlet?op=saveComment",
                data: {
                    clientId: clientId,
                    type: type,
                    comment: comment,
                    businessObjectType: businessObjectType
                }
                ,
                success: function(jsonString) {
                    var eqpEmpInfo = $.parseJSON(jsonString);
                    if (eqpEmpInfo.status == 'ok') {
                        $(obj).parent().parent().parent().parent().find("#commMsg").show();
                        $(obj).parent().parent().parent().parent().find("#progress").hide();
                        $('#add_comments').css("display", "none");
                        $('#add_comments').bPopup().close();
                    } else if (eqpEmpInfo.status == 'no') {
                        $(obj).parent().parent().parent().parent().find("#progress").show();
                    }
                }
            });
        }
        function sendMailByAjax(obj) {
            $(obj).parent().find("#progressx").css("display", "block");
            $('#attachForm').submit(function(e) {
                $("#projectId").val($("#clientId").val());
                $.ajax({
                    url: '<%=context%>/EmailServlet?op=attachFile',
                    type: 'POST',
                    data: new FormData(this),
                    processData: false,
                    contentType: false,
                    beforeSend: function()
                    {
                        $("#progressx2").show();
                        $("#attachMessage").html("");
                        $("#progressx2").css("display", "block");
                    },
                    uploadProgress: function(event, position, total, percentComplete)
                    {
                        $("#bar").width(percentComplete + '%');
                        $("#percent").html(percentComplete + '%');
                    },
                    success: function()
                    {
                        $("#progressx2").html('');
                        $("#progressx2").css("display", "none");
                    },
                    complete: function(response)
                    {
                        $("#attachMessage").html("<font color='white'>تم رفع الملفات</font>");
                    },
                    error: function()
                    {
                        $("#attachMessage").html("<font color='red'>لم يتم رفع الملفات</font>");
                    }
                });
                e.preventDefault();
            });
        }
        function popupAttach() {
            $("#attachMessage").html("");
            count = 1;
            $("#addFile").removeAttr("disabled");
            $("#counterFile").val("0");
            $("#listAttachFile").html("");
            $('#attach_file').show();
            $('#attach_file').bPopup({easing: 'easeInOutSine',
                speed: 400,
                transition: 'slideDown'});
        }
        var count = 1;
        var validName = false;
        var validPhoneMobile = false;
        function addFiles(obj) {
            if ((count * 1) == 4) {
                $("#addFile").removeAttr("disabled");
            }
            if (count >= 1 & count <= 4) {
                $("#listAttachFile").append("<input type='file' style='float: right;text-align:right;font-size:12px;margin:1.5px;' name='file" + count + "' id='file" + count + "'  maxlength='60'/>");
                $("#counterFile").val(count);
                count = Number(count * 1 + 1);
            } else {
                $("#addFile").attr("disabled", true);
            }
        }
        function popupCreateClient() {
            $("#nameMSG").hide();
            $("#nameWarning").css("display", "none");
            $("#nameOk").css("display", "none");

            $("#telMSG").css("display", "none");
            $("#telWarning").css("display", "none");
            $("#telOk").css("display", "none");

            $("#mobMSG").hide();
            $("#mobWarning").css("display", "none");
            $("#mobOk").css("display", "none");

            $("#createClientMsg").hide();
            $("#saveClient").hide();
            $('#clientName').val("");
            $('#phone').val("");
            $('#clientMobile').val("");
            $('#createClient').css("display", "block");
            $('#createClient').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown'});
        }
        function createClient() {
            var clientName = $('#clientName').val();
            var phone = $('#phone').val();
            var clientMobile = $('#clientMobile').val();
            checkClientName();
            checkClientPhone();
            checkClientMobile();
            if (validPhoneMobile && validName) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=SaveClientByAjax",
                    data: {
                        oldClientID: $("#clientId").val(),
                        clientName: clientName,
                        phone: phone,
                        clientMobile: clientMobile,
                        gender: 'UL',
                        matiralStatus: 'UL',
                        automatedClientNo: 'true',
                        birthDate: '',
                        age: "30-40"
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok') {
                            $("#createClientMsg").show();
                            $("#createClientMsg").css("display", "block");
                            $("#saveClient").hide();
                            getClientInfo('');
                        }
                        else {
                            alert("لم يتم تسجيل العميل");
                        }
                    }
                });
            }
        }
        function checkClientPhone() {
            if (!validateData2("numeric", document.getElementById("phone"))) {
                $("#telMSG").show();
                $("#telMSG").text("ارقام فقط");
                $("#telMSG").css("color", "red");
                $("#telOk").css("display", "none");
                validPhoneMobile = false;
                $("#saveClient").hide();
                checkClientMobile();
                return false;
            } else if (document.getElementById("phone").value.length < 8 && (document.getElementById("clientMobile").value == '' || document.getElementById("clientMobile").value.length < 11)) {
                $("#telMSG").show();
                $("#telMSG").text("8 أرقام علي اﻷقل");
                $("#telMSG").css("color", "red");
                $("#telOk").css("display", "none");
                validPhoneMobile = false;
                $("#saveClient").hide();
                return false;
            }
            var phone = $("#phone").val();
            if (phone.length > 0) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=getClientPhone",
                    data: {
                        phone: phone
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'No') {
                            $("#telMSG").css("color", "green");
                            $("#telMSG").css("text-align", "left");
                            $("#telMSG").css("display", "inline");
                            $("#telMSG").text(" متاح");
                            $("#telMSG").removeClass("error");
                            $("#telWarning").css("display", "none");
                            $("#telOk").css("display", "inline");
                            validPhoneMobile = true;
                            if (validName && validPhoneMobile) {
                                $("#saveClient").show();
                            }
                            return true;
                        } else if (info.status == 'Ok') {
                            $("#telMSG").css("color", "red");
                            $("#telMSG").css("display", "inline");
                            $("#telMSG").css("font-size", "12px");
                            $("#telMSG").text(" محجوز");
                            $("#telMSG").addClass("error");
                            $("#telWarning").css("display", "inline");
                            $("#telOk").css("display", "none");
                            validPhoneMobile = false;
                            $("#saveClient").hide();
                            return false;
                        }
                    }
                });
            }
        }
        function checkClientMobile() {
            var phone = $("#clientMobile").val();
            if (!validateData2("numeric", document.getElementById("clientMobile"))) {
                $("#mobMSG").show();
                $("#mobMSG").text("ارقام فقط");
                $("#mobMSG").css("color", "red");
                $("#mobOk").css("display", "none");
                validPhoneMobile = false;
                $("#saveClient").hide();
                checkClientPhone();
                return false;
            } else if (document.getElementById("clientMobile").value.length < 11 && (document.getElementById("phone").value == '' || document.getElementById("phone").value.length < 8)) {
                $("#mobMSG").show();
                $("#mobMSG").text("11 أرقام علي اﻷقل");
                $("#mobMSG").css("color", "red");
                $("#mobMSG").css("display", "none");
                validPhoneMobile = false;
                $("#saveClient").hide();
                return false;
            }
            if (phone.length > 0) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=getClientMobile",
                    data: {
                        mobile: phone
                    },
                    success: function(jsonString) {
                        $("#mobMSG").show();
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'No') {
                            $("#mobMSG").css("color", "green");
                            $("#mobMSG").css(" text-align", "left");
                            $("#mobMSG").text(" متاح");
                            $("#mobMSG").removeClass("error");
                            $("#mobWarning").css("display", "none");
                            $("#mobOk").css("display", "inline");
                            validPhoneMobile = true;
                            if (validName && validPhoneMobile) {
                                $("#saveClient").show();
                            }
                            return true;
                        } else if (info.status == 'Ok') {
                            $("#mobMSG").css("color", "red");
                            $("#mobMSG").css("font-size", "12px");
                            $("#mobMSG").text(" محجوز");
                            $("#mobMSG").addClass("error");
                            $("#mobWarning").css("display", "inline");
                            $("#mobOk").css("display", "none");
                            validPhoneMobile = false;
                            $("#saveClient").hide();
                            return false;
                        }
                    }
                });
            }
        }
        function checkClientName() {
            var clientName = $("#clientName").val();
            if (clientName.length > 0) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=getClientName",
                    data: {
                        clientName: clientName
                    },
                    success: function(jsonString) {
                        $("#nameMSG").show();
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'No') {
                            $("#nameMSG").css("color", "green");
                            $("#nameMSG").css(" text-align", "left");
                            $("#nameMSG").text(" متاح")
                            $("#nameMSG").removeClass("error");
                            $("#nameWarning").css("display", "none");
                            $("#nameOk").css("display", "inline");
                            validName = true;
                            if (validName && validPhoneMobile) {
                                $("#saveClient").show();
                            }
                            return true;
                        } else if (info.status == 'Ok') {
                            $("#nameMSG").css("color", "red");
                            $("#nameMSG").css("font-size", "12px");
                            $("#nameMSG").text(" محجوز");
                            $("#nameMSG").addClass("error");
                            $("#nameWarning").css("display", "inline")
                            $("#nameOk").css("display", "none");
                            validName = false;
                            $("#saveClient").hide();
                            return false;
                        }
                    }
                });
            } else {
                $("#nameMSG").text("");
                $("#nameWarning").css("display", "none");
                $("#nameOk").css("display", "none");
            }
        }
        function popupFollowUp() {
            $("#appTitleMsg").css("color", "");
            $("#appTitleMsg").text("");
            $("#appTitle").val("");

            $("#appNote").val("");
            $("#appMsg").hide();
            $(".submenu1").hide();
            $("#appClientName").text($("#hideName").val());
            $(".button_pointment").attr('id', '0');
            $('#follow_up_content').css("display", "block");

            $('#follow_up_content').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown'});
        }

        function saveFollowUp(obj) {
            $("#appTitleMsg").css("color", "");
            $("#appTitleMsg").text("");

            var clientId = $("#clientId").val();
            var title = '';
            if ($(obj).parent().parent().parent().find($("#appTitle")).val() !== null) {
                title = $(obj).parent().parent().parent().find($("#appTitle")).val();
            }
            var callResult = $(obj).parent().parent().parent().find($("#callResult:checked")).val();
            var resultValue = "";
            var appCallResult = $(obj).parent().parent().parent().find($("#appCallResult")).val();
            var meetingDate = $(obj).parent().parent().parent().find($("#meetingDate")).val();
            if (callResult === '<%=CRMConstants.CALL_RESULT_CALL%>') {
                resultValue = appCallResult;
            } else if (callResult === '<%=CRMConstants.CALL_RESULT_MEETING%>') {
                resultValue = meetingDate;
            }

            var appType = '<%=CRMConstants.CALL_RESULT_FOLLOWUP%>';
            var appointmentPlace = $(obj).parent().parent().parent().find("#appointmentPlace").val();
            var comment = $(obj).parent().parent().parent().find("#comment").val();
            var note = '<%=CRMConstants.CALL_RESULT_FOLLOWUP.toUpperCase()%>';
            if (title.length > 0) {
                $(obj).parent().parent().parent().parent().find("#progress").show();

                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=saveFollowUpAppointment",
                    data: {
                        clientId: clientId,
                        title: title,
                        callResult: callResult,
                        resultValue: resultValue,
                        note: note,
                        appType: appType,
                        appointmentPlace: appointmentPlace,
                        comment: comment
                    },
                    success: function(jsonString) {
                        var eqpEmpInfo = $.parseJSON(jsonString);
                        if (eqpEmpInfo.status == 'ok') {
//                                $(obj).parent().parent().parent().parent().find("#appMsg").html("تم التسجيل بنجاح").show();
                            $(obj).parent().parent().parent().parent().find("#progress").hide();
                            $('#follow_up_content').css("display", "none");
                            $('#follow_up_content').bPopup().close();
                        } else if (eqpEmpInfo.status == 'no') {
                            $(obj).parent().parent().parent().parent().find("#progress").show();
                            $(obj).parent().parent().parent().parent().find("#appMsg").html("لم يتم التسجيل او هذا العميل غير موزع").show();
                        }
                    }
                });
            } else {
                $("#appTitleMsg").css("color", "white");
                $("#appTitleMsg").text("أدخل عنوان المقابلة");
            }
        }
        function popupAddPlanningAppointment() {
            $("#palnningTitleMsg").css("color", "");
            $("#palnningTitleMsg").text("");
            $("#palnningTitle").val("");
            $("#palnningComment").val("");
            $("#palnningMsg").hide();
            $('#appointment_content').css("display", "block");
            $('#appointment_content').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                speed: 400,
                transition: 'slideDown'});
        }
        function saveAppoientment(obj) {
            var clientId = $("#clientId").val();
            $("#palnningTitleMsg").css("color", "");
            $("#palnningTitleMsg").text("");
            var title = $(obj).parent().parent().parent().find($("#palnningTitle")).val();
            var date = $(obj).parent().parent().parent().find($("#palnningDate")).val();
            var appType = $(obj).parent().parent().parent().find("#note:checked").val();
            var appointmentPlace = $(obj).parent().parent().parent().find("#appointmentPlace").val();
            var comment = $(obj).parent().parent().parent().find("#palnningComment").val();
            var note = "UL";
            if (title.length > 0) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=saveAppointment",
                    data: {
                        clientId: clientId,
                        title: title,
                        date: date,
                        note: note,
                        appType: appType,
                        type: "1",
                        appointmentPlace: appointmentPlace,
                        comment: comment
                    },
                    success: function(jsonString) {
                        var eqpEmpInfo = $.parseJSON(jsonString);
                        if (eqpEmpInfo.status == 'ok') {
                            $('#overlay').hide();
                            $('#appointment_content').css("display", "none");
                            $('#appointment_content').bPopup().close();
                        } else if (eqpEmpInfo.status == 'no') {
                            $(obj).parent().parent().parent().parent().find("#progress").show();
                            $(obj).parent().parent().parent().parent().find("#palnningMsg").html("لم يتم التسجيل او هذا العميل غير موزع").show();
                        }
                    }
                });
            } else {
                $("#palnningTitleMsg").css("color", "white");
                $("#palnningTitleMsg").text("أدخل عنوان المقابلة");
            }
        }
        function getClientByBusiness() {
            var businessNo = $("#businessNo").val();
            if (businessNo.length > 0) {
                var url = "<%=context%>/ClientServlet?op=getClientByBusinessNo&businessNo=" + businessNo;
                window.location.href = url;
            }
        }
    </script>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <FORM NAME="CLIENT_FORM" METHOD="POST">
            <div style="margin-left: auto;margin-right: auto;width: 96%" class="set">
                <div style="width: 100%;">
                    <fieldset class="set" align="center" width="100%" style="width: 70%;margin-bottom: 10px;">
                        <legend align="center">
                            <table dir="<%=dir%>" align="center">
                                <tr>
                                    <td class="td">
                                        <font color="blue" size="6">
                                        <%=sTitle%>
                                        </font>
                                    </td>
                                </tr>
                            </table>
                        </legend>
                        <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%">
                            <tr>
                                <td class='td'>
                                    <TABLE ALIGN="center" DIR="<%=dir%>"  CELLPADDING="0" CELLSPACING="0" BORDER="0" style="margin-right: auto;margin-left: auto;">
                                        <tr>
                                            <td colspan="1" STYLE="<%=style%>" class='td'><%=projectTitle%></td>
                                            <td style="text-align:center" valign="middle" class="td">
                                                <select style="font-size: 14px;font-weight: bold; width: 280px;" id="projectID" name="projectID"
                                                        class="chosen-select-project">
                                                    <option value="">All</option>
                                                    <sw:WBOOptionList wboList='<%=projectList%>' displayAttribute = "projectName" valueAttribute="projectID"/>
                                                </select>
                                            </td>
                                            <td colspan="1" STYLE="<%=style%>" class='td'><%=num%></td>
                                            <td colspan="1" STYLE="<%=style%>;width: 250px;" class='td' nowrap>
                                                <div style="text-align: center;width: 100%;margin-left: auto;margin-right: auto;" id="te">
                                                    <input type="text" name="num" id="num" placeholder="<%=num%>" onblur="getClientInfo('searchByUnitNo')"/>
                                                    <input type="button"  id="searchBtn" onclick="getClientInfo('searchByUnitNo')" value='<%=searchButton%>'/>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" STYLE="<%=style%>" class='td'>
                                                &nbsp;
                                            </td>
                                            <td colspan="1" STYLE="<%=style%>" class='td'><%=phone%></td>
                                            <td colspan="1" STYLE="<%=style%>;width: 250px;" class='td' nowrap>
                                                <div style="text-align: center;width: 100%;margin-left: auto;margin-right: auto;" id="te">
                                                    <input type="text" name="phone" id="phone" placeholder="<%=phone%>" onblur="getClientInfo('searchByPhone')"/>
                                                    <input type="button"  id="searchBtn" onclick="getClientInfo('searchByPhone')" value='<%=searchButton%>'/>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" STYLE="<%=style%>" class='td'>
                                                &nbsp;
                                            </td>
                                            <td colspan="1" STYLE="<%=style%>" class='td'><%=email%></td>
                                            <td colspan="1" STYLE="<%=style%>;width: 250px;" class='td' nowrap>
                                                <div style="text-align: center;width: 100%;margin-left: auto;margin-right: auto;" id="te">
                                                    <input type="text" name="email" id="email" placeholder="<%=email%>" onblur="getClientInfo('searchByEmail')"/>
                                                    <input type="button"  id="searchBtn" onclick="getClientInfo('searchByEmail')" value='<%=searchButton%>'/>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" STYLE="<%=style%>" class='td'>
                                                &nbsp;
                                            </td>
                                            <td colspan="1" STYLE="<%=style%>" class='td'><%=businessNo%></td>
                                            <td colspan="1" STYLE="<%=style%>;width: 250px;" class='td' nowrap>
                                                <div style="text-align: center;width: 100%;margin-left: auto;margin-right: auto;" id="te">
                                                    <input type="text" name="businessNo" id="businessNo" placeholder="<%=businessNo%>" onblur="JavaScript: getClientByBusiness()"/>
                                                    <input type="button"  id="searchBtn" onclick="JavaScript: getClientByBusiness()" value='<%=searchButton%>'/>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" STYLE="<%=style%>" class='td'>
                                                &nbsp;
                                            </td>
                                            <td colspan="2" STYLE="<%=style%>" class='td'>
                                                <div style="text-align: center;width: 96%;margin-left: auto;margin-right: auto">
                                                    <LABEL id="info" style="color: green;"></LABEL>
                                                </div>
                                            </td>
                                        </tr>
                                    </TABLE>
                                </td>
                            </tr>
                        </table>
                       <!-- <div style="width: 85%;margin-right: auto;margin-left: auto;" id="clientDetails">
                        </div>  com-->
                        <br/>
            
            <%if (clientLst != null) {
                %>
                <div style="width: 87%;margin-right: auto;margin-left: auto;" id="showClients">
                    <TABLE ALIGN="<%=align%>" dir='<fmt:message key="direction"/>' WIDTH="100%" id="clients" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="number"/></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"> <fmt:message key="name"/></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="clientstatus"/></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"> <fmt:message key="mobile"/></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="mail"/> </th>
                            </tr>
                        <thead>
                        <tbody>
                            <%for(WebBusinessObject clientWbo : clientLst){%>
                                <tr onclick="createComplaints(<%=clientWbo.getAttribute("id")%>,<%=clientWbo.getAttribute("age")%>);" style="cursor: pointer" id="row">
                                    <TD>
                                        <%if (clientWbo.getAttribute("clientNO") != null) {%>
                                        <b><%=clientWbo.getAttribute("clientNO")%></b>
                                        <%}
                                        %>
                                    </TD>
                                    <TD>
                                        <%if (clientWbo.getAttribute("name") != null) {%>
                                        <b><%=clientWbo.getAttribute("name")%></b>
                                        <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=clientWbo.getAttribute("id")%>">
                                            <img src="images/client_details.jpg" width="30" style="float: left;" title=<fmt:message key="details"/>
                                        </a>
                                        <a target="_blanck" href="<%=context%>/IssueServlet?op=newComplaint&type=call&clientId=<%=clientWbo.getAttribute("id")%>&clientType=30-40">
                                            <img src="images/icons/eHR.gif" width="30" style="float: left;" title="تفاصيل"
                                                onmouseover="JavaScript: changeCommentCounts('<%=clientWbo.getAttribute("id")%>', this);"/>
                                        </a>
                                        <%}%>
                                    </TD>
                                    <TD>
                                        <%if (clientWbo.getAttribute("currentStatusNameEn") != null) {%>
                                        <b><%=clientWbo.getAttribute("currentStatusNameEn")%></b>
                                        <%}%>
                                    </TD>
                                    <TD>
                                        <%if (clientWbo.getAttribute("mobile") != null) {%>
                                        <b><%=clientWbo.getAttribute("mobile")%></b>
                                        <%}%>
                                    </TD>
                                    <TD>
                                        <%if (clientWbo.getAttribute("email") != null) {%>
                                        <b><%=clientWbo.getAttribute("email")%></b>
                                        <%}%>
                                    </TD>
                                </tr>
                            <%}%>
                        </tbody>  

                    </TABLE>
                    <br/>
                    <br/>
                </div>
                <%        }
                %>
                    </FIELDSET>
                </div>
            </div>
        </FORM>
        <div id="attach_file"  style="width: 30%;display: none;position: fixed;margin-left: auto;margin-right: auto">
            <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 20px;
                     -moz-border-radius: 20px;
                     border-radius: 20px;" onclick="closePopup(this)"/>
            </div>
            <div class="login" style="width: 90%;text-align: center">
                <form id="attachForm" action="<%=context%>/EmailServlet?op=attachFile" method="post" enctype="multipart/form-data">
                    <table class="table " style="width:100%;">
                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;"><lable>إرفاق ملف</lable>
                        <input type="button" id="addFile" onclick="addFiles(this)" value="+" />
                        <input id="counterFile" value="" type="hidden" name="counter"/>
                        <input name="projectId" value="" type="hidden" />
                        </td>
                        <td style="text-align:right;width: 70%;" id="listAttachFile"> 
                        </td>
                        </tr>
                    </table>
                    <div style="width: 30%;text-align: center;margin-left: auto;margin-right: auto;" id="statusFile"></div>
                    <div id="attachMessage" style="margin-left: auto;margin-right: auto;text-align: center"></div>
                    <input type="submit" value="تحميل"  class="login-submit" style="margin-left: auto;margin-right: auto;text-align: center" onclick="sendMailByAjax(this)" />
                </form>
                <div id="progressx2" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
            </div>
        </div>
        <div id="createClient"  style="width: 40% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 0%;">
            <div style="clear: both;margin-left: 88%;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopup(this)"/>
            </div>
            <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <table  border="0px"  style="width:100%;"  class="table">
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 40%;">اسم العميل</td>
                        <td style="width: 40%; text-align: left;" >
                            <input type="text" name="clientName" id="clientName" value=""
                                   onblur="checkClientName()" onkeypress="checkClientName()"/>
                        </td>
                        <td nowrap style="width: 20%;">
                            <div id="nameWarning"style="display: none;width: 20px;height: 20px; border: none;">
                                <img src="url(images/warning.png)" width="16px" height="16px;" style="background-color: transparent;border: none;background-image: url(images/warning.png);background-repeat: no-repeat;" />
                            </div>
                            <div id="nameOk"style="display: none;width: 20px;height: 20px;border: none;">
                                <img src="url(images/warning.png)" width="16px" height="16px;" style="background-color: transparent;border: none;background-image: url(images/ok2.png);background-repeat: no-repeat;" />
                            </div>
                            <label id="nameMSG" ></label>
                        </td>
                    </tr>
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;">تليفون</td>
                        <td style="text-align: left;" >
                            <input type="text" name="phone" id="phone" value=""
                                   onblur="checkClientPhone()" onkeypress="checkClientPhone()"/>
                        </td>
                        <td nowrap>
                            <div id="telWarning"style="display: none;width: 20px;height: 20px; border: none;">
                                <img src="url(images/warning.png)" width="16px" height="16px;" style="background-color: transparent;border: none;background-image: url(images/warning.png);background-repeat: no-repeat;" />
                            </div>
                            <div id="telOk"style="display: none;width: 20px;height: 20px;border: none;">
                                <img src="url(images/warning.png)" width="16px" height="16px;" style="background-color: transparent;border: none;background-image: url(images/ok2.png);background-repeat: no-repeat;" />
                            </div>
                            <label id="telMSG" ></label>
                        </td>
                    </tr>
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;">مويايل</td>
                        <td style="text-align: left;" >
                            <input type="text" name="clientMobile" id="clientMobile" value=""
                                   onblur="checkClientMobile()" onkeypress="checkClientMobile()"/>
                        </td>
                        <td nowrap>
                            <div id="mobWarning"style="display: none;width: 20px;height: 20px; border: none;">
                                <img src="url(images/warning.png)" width="16px" height="16px;" style="background-color: transparent;border: none;background-image: url(images/warning.png);background-repeat: no-repeat;" />
                            </div>
                            <div id="mobOk"style="display: none;width: 20px;height: 20px;border: none;">
                                <img src="url(images/warning.png)" width="16px" height="16px;" style="background-color: transparent;border: none;background-image: url(images/ok2.png);background-repeat: no-repeat;" />
                            </div>
                            <label id="mobMSG" ></label>
                        </td>
                    </tr>
                </table>
                <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" > <input type="button" value="حفظ"   onclick="JavaScript:createClient();" id="saveClient"class="login-submit"/></div>                             </form>
                <div id="progressClient" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
                <div style="margin: 0 auto;width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold;" id="createClientMsg">
                    تم إضافة العميل
                </div>
            </div>
            
            
        </div>
        <script>
            var config = {
                '.chosen-select-project': {no_results_text: 'No project found with this name!'}
            };
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        </script>
        
        
    </BODY>
</HTML>     