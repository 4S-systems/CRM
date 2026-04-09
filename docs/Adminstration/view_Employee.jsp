<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.SecurityUser"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@ page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/tr/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Client.client"  />

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();

        String context = metaMgr.getContext();
        SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");

        LiteWebBusinessObject employeeWbo = (LiteWebBusinessObject) request.getAttribute("employeeWbo");

        String stat = (String) request.getSession().getAttribute("currentMode");
        String align, dir, xAlign, style;
        String empDetails, noEmplExistMsg, empNo, empEmail, empName, empAddress, empGender, maritalStatus, workType, sendEmail;
        if (stat.equals("En")) {
            align = "left";
            xAlign = "left";
            dir = "LTR";
            style = "text-align:left";
            empDetails = "Employee Details";
            noEmplExistMsg = "No Employee Exist by this Number";
            empNo = "Employee Number";
            empEmail = "Employee Email";
            empName = "Employee Name";
            empAddress = "Address";
            empGender = "Gender";
            maritalStatus = "Marital Status";
            workType = "Work Type";
            sendEmail = "Send Email";
        } else {
            align = "right";
            xAlign = "left";
            dir = "RTL";
            style = "text-align:Right";
            empDetails = "تفاصيل الموظف";
            noEmplExistMsg = "لا يوجد موظف بهذا الرقم";
            empNo = "رقم الموظف";
            empEmail = "البريد الاكتروني للموظف";
            empName = "اسم الموظف";
            empAddress = "العنوان";
            empGender = "النوع";
            maritalStatus = "الحالة الاجتماعية";
            workType = "طبيعة العمل";
            sendEmail = "أرسال رسالة ألكترونية";
        }
    %>

    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>

        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" type="text/css" href="css/msdropdown/dd.css" />
        <link rel="stylesheet" type="text/css" href="js/w2ui/w2ui-1.5.rc1.min.css" />

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" src="js/w2ui/w2ui-1.5.rc1.min.js"></script>

        <script type="text/javascript">
            function viewEmpCommunications() {
                var url = "<%=context%>/EmployeeServlet?op=viewEmployeeCommunications&empId=" + $("#empId").val();
                openWindow(url);
            }

            function viewEmpEducation() {
                var url = "<%=context%>/EmployeeServlet?op=viewEmployeeEducation&empId=" + $("#empId").val();
                openWindow(url);
            }

            function viewEmpDates() {
                var url = "<%=context%>/EmployeeServlet?op=viewEmployeeDates&empId=" + $("#empId").val();
                openWindow(url);
            }

            function updateEmpInformation() {
                var url = "<%=context%>/EmployeeServlet?op=UpdateEmployee&empId=" + $("#empId").val();
                openWindow(url);
            }

            function viewEmpProfile() {
                var url = "<%=context%>/EmployeeServlet?op=viewEmployeeProfile&empId=" + $("#empId").val();
                openWindow(url);
            }

            var divEmpProfileTag;
            function openEmpProfileDialog(businessObjectId) {
                divEmpProfileTag = $("div[name='divEmpProfileTag']");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/EmployeeServlet?op=getEmpProfile',
                    data: {
                        businessObjectId: businessObjectId
                    },
                    success: function (data) {
                        divEmpProfileTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: "ملف الموظف",
                                    show: "fade",
                                    hide: "explode",
                                    width: 480,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Done: function () {
                                            divEmpProfileTag.dialog('destroy').hide();
                                        }
                                    }
                                })
                                .dialog('open');
                    },
                    error: function (data) {
                        alert(data);
                    }
                });
            }

            var divAttachmentTag;
            function openAttachmentDialog(businessObjectId, objectType) {
                divAttachmentTag = $("div[name='divAttachmentTag']");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/FileUploadServlet?op=getUploadDialog',
                    data: {
                        businessObjectId: businessObjectId,
                        objectType: objectType
                    },
                    success: function (data) {
                        divAttachmentTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: "ارفاق مستندات",
                                    show: "fade",
                                    hide: "explode",
                                    width: 480,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Done: function () {
                                            divAttachmentTag.dialog('destroy').hide();
                                        }
                                    }
                                })
                                .dialog('open');
                    },
                    error: function (data) {
                        alert(data);
                    }
                });
            }

            function showAttachedFiles(businessObjectId) {
                divAttachmentTag = $("div[name='divAttachmentTag']");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/FileUploadServlet?op=viewDocuments',
                    data: {
                        businessObjectId: businessObjectId
                    },
                    success: function (data) {
                        divAttachmentTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: "مشاهدة المستندات",
                                    show: "fade",
                                    hide: "explode",
                                    width: 700,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Done: function () {
                                            divAttachmentTag.dialog('destroy').hide();
                                        }
                                    }
                                })
                                .dialog('open');
                    },
                    error: function (data) {
                        alert(data);
                    }
                });
            }

            function openWindow(url) {
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=700, height=600");
            }

            function openEmailDialog(clientName, clientEmail, title) {

                loading("block");
                divCommentsTag = $("div[name='divCommentsTag']");
                count = 1
                $.ajax({
                    type: "post",
                    url: '<%=context%>/EmailServlet?op=getEmailPopupClient',
                    data: {
                        clientName: clientName,
                        clientEmail: clientEmail,
                        title: title,
                    }, success: function (data) {
                        divCommentsTag.html(data).dialog({
                            modal: true,
                            title: "<%=sendEmail%>",
                            show: "fade",
                            hide: "explode",
                            width: 650,
                            height: 620,
                            position: {
                                my: 'center',
                                at: 'center'
                            }, buttons: {
                                Close: function () {
                                    divCommentsTag.dialog('destroy').hide();
                                }, Send: function () {
                                    sendMailByAjax2();
                                }
                            }
                        }).dialog('open');
                    }, error: function (data) {
                        alert('Data Error = ' + data);
                    }
                });
                loading("none");
            }

            function loading(val) {
                if (val === "none") {
                    $('#loading').fadeOut(2000, function () {
                        $('#loading').css("display", val);
                    });
                } else {
                    $('#loading').fadeIn("fast", function () {
                        $('#loading').css("display", val);
                    });
                }
            }

            function openGalleryDialog(issueId, objectType) {
                var divTag = $("<div></div>");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/FileUploadServlet?op=getGalleryDialog',
                    data: {
                        businessObjectId: issueId,
                        objectType: objectType
                    },
                    success: function (data) {
                        divTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: "عرض الصور",
                                    show: "fade",
                                    hide: "explode",
                                    width: 950,
                                    dialogClass: 'no-close',
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Cancel: function () {
                                            divTag.dialog('destroy').hide();
                                        },
                                        Done: function () {
                                            divTag.dialog('destroy').hide();
                                        }
                                    }
                                })
                                .dialog('open');
                    },
                    error: function (data) {
                        alert(data);
                    }
                });
            }

            var divSalaryConfigTag;
            function salaryConfig(empID) {
                divSalaryConfigTag = $("div[name='divSalaryConfigTag']");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/EmployeeServlet?op=getEmpSalaryConfig',
                    data: {
                        empID: empID
                    },
                    success: function (data) {
                        divSalaryConfigTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: "تعيين مفردات المرتب",
                                    show: "fade",
                                    hide: "explode",
                                    width: 600,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Done: function () {
                                            divSalaryConfigTag.dialog('destroy').hide();
                                        }
                                    }
                                })
                                .dialog('open');
                    },
                    error: function (data) {
                        alert(data);
                    }
                });
            }
        </script>

        <style>
            table label {
                float: right;
            }

            td {
                border: none;
                padding-bottom: 10px;
            }

            .toolBox {
                width:45px;
                height: 40px;
                float:right;
                margin: 0px;
                padding: 0px;
                border: 1px solid black;
            }

            .toolBox a img {
                width: 40px important;
                height: 40px important;
                float: right;
                margin: 0px;
                padding: 0px;
                text-align: right;
            }

            .titleTD {
                text-align:center;
                font-weight: bold;
                font-size: 16px;
                color: black;
                background-color:#b9d2ef;
            }

            .dataTD {
                text-align:right;
                border: none;
                font-weight: bold;
                font-size: 16px;
                color: black;
            }

            tr:nth-child(even) td.dataTD {
                background: #FFF
            }

            tr:nth-child(odd) td.dataTD {
                background: #f1f1f1
            }

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

            .titleRow {
                background-color: orange;
            }

            .detailTD {
                text-align:center;
                font-weight: bold;
                font-size: 16px;
                color: black;
                background-color: #FCC90D;
            }

            .dataDetailTD {
                text-align:right;
                border: none;
                font-weight: bold;
                font-size: 16px;
                color: black;
            }

            tr:nth-child(even) td.dataDetailTD {
                background: #FFF19F
            }

            tr:nth-child(odd) td.dataDetailTD {
                background: #FFF19F
            }

            .login  h1 {
                font-size: 16px;
                font-weight: bold;

                padding-top: 10px;
                padding-bottom: 10px;
                text-shadow: 0 -1px rgba(0, 0, 0, 0.4);
                text-align: center;
                width: 96%;

                margin-left: auto;
                margin-right: auto;
                text-height: 30px;

                color: black;

                text-shadow: 0 1px rgba(255, 255, 255, 0.3);
                background: #FFBB00;
                /*background: #cc0000;*/
                background-clip: padding-box;
                border: 1px solid #284473;
                border-bottom-color: #223b66;
                border-radius: 4px;
                cursor: pointer;
            }

            .ddlabel {
                float: left;
            }

            .fnone {
                margin-right: 5px;
            }

            .edit-icon {
                content:url('images/user_red_edit.png');
            }

            .print-icon {
                content:url('images/pdf_icon.gif');
            }

            .unbookmark-icon {
                content:url('images/star1.jpg');
            }

            .bookmark-icon {
                content:url('images/star2.jpg');
            }

            .finical-icon {
                content:url('images/finical-rebort.png');
            }
            
            .salary-icon {
                content:url('images/icons/finance.jpg');
            }
            
            .contract-icon {
                content:url('images/contract_icon.jpg');
            }

            .attach-icon {
                content:url('images/attach.png');
            }

            .view-file-icon {
                content:url('images/Foldericon.png');
            }

            .gallery-view-icon {
                content:url('images/gallery.png');
            }

            .recommend-icon {
                content:url('images/recommend_client.gif');
            }

            .view-client-icon {
                content:url('images/client_vip.png');
            }

            .delete-icon {
                content:url('images/icons/delete_ready.png');
            }

            .reserved-icon {
                content:url('images/reserved_house.JPG');
            }

            .details-icon {
                content:url('images/communication.png');
            }

            .followup-icon {
                content:url('images/icons/follow_up.png');
            }

            .comment-icon {
                content:url('images/dialogs/comment_public.ico');
            }

            .view-comment-icon {
                content:url('images/dialogs/comment_channel.png');
            }

            .appointment-icon {
                content:url('images/dialogs/planning.png');
            }

            .view-appointment-icon {
                content:url('images/icons/calendar-256.png');
            }

            .mailbox-icon {
                content:url('images/dialogs/mailbox.png');
            }

            .campaign-icon {
                content:url('images/icons/add_event2.png');
            }

            .view-request-icon {
                content:url('images/icons/listing.png');
            }

            .session-icon {
                content:url('images/session-icon.png');
            }

            .request-icon {
                content:url('images/icons/icon-claims.png');
            }

            .unit-icon {
                content:url('images/icons/units.png');
            }

            .email-icon {
                content:url('images/icons/email.png');
            }

            .education-icon{
                content:url('images/icons/department.png');
            }

            .dates-icon{
                content:url('images/icons/add_event2.png');
            }

            .profile-icon{
                content:url('images/icons/eHR.gif');
            }
            .reqs-icon{
                content:url('images/icons/holidayRequest.png');
            }
            .reqsRprt-icon{
                content:url('images/icons/reqRprt.png');
            }
            .w2ui-grid .w2ui-grid-toolbar {
                padding: 14px 5px;
                height: 150px;
            }

            .w2ui-grid .w2ui-grid-header {
                padding: 14px;
                font-size: 20px;
                height: 150px;
            }
        </style>
    </head>

    <BODY>
        <div name="divEmpProfileTag"></div>
        <div name="divAttachmentTag"></div> 
        <div name="divCommentsTag"></div>
        <div name="divSalaryConfigTag"></div>
        <div id="show_attached_files" style="width: 70% !important; display: none; position: fixed ;"></div>

        <fieldset align=center class="set" style="width: 90%">
            <legend align="center">
                <font color="blue" size="6">
                    <%=empDetails%> 
                </font>
            </legend>
            <%
                if (employeeWbo == null) {
            %>
            <b style="color: red">
                <%=noEmplExistMsg%> 
            </b>
            <%
            } else {
            %>

            <div id="attach_file" style="width: 30%; display: none; position: fixed; margin-left: auto; margin-right: auto;">
                <div style="clear: both; margin-left: 90%; margin-top: 0px; margin-bottom: -40px;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat; -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                         -moz-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                         box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                         -webkit-border-radius: 20px; -moz-border-radius: 20px;
                         border-radius: 20px;" onclick="closePopup(this)"/>
                </div>

                <div class="login" style="width: 90%;text-align: center">
                    <form id="attachForm" action="<%=context%>/EmailServlet?op=attachFile" method="post" enctype="multipart/form-data">
                        <table class="table " style="width:100%;">
                            <tr>
                                <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">
                                    <lable>
                                        إرفاق ملف 
                                    </lable>

                                    <input type="button" id="addFile" onclick="addFiles(this)" value="+" />

                                    <input id="counterFile" value="" type="hidden" name="counter"/>

                                    <input id="projectId" name="projectId" value="" type="hidden" />
                                </td>

                                <td style="text-align:right;width: 70%;" id="listAttachFile"> 
                                </td>
                            </tr>
                        </table>

                        <div style="width: 30%;text-align: center;margin-left: auto;margin-right: auto;" id="statusFile">

                        </div>

                        <div id="attachMessage" style="margin-left: auto;margin-right: auto;text-align: center">

                        </div>

                        <input type="submit" value="تحميل"  class="login-submit" style="margin-left: auto; margin-right: auto; text-align: center;" onclick="sendMailByAjax(this)" />
                    </form>
                    <div id="progressx2" style="display: none;">
                        <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                    </div>
                </div>
            </div>

            <div style="margin-left: auto; margin-right: auto; width: 1100px;">
                <div id="toolbar" dir="<fmt:message key="dir"/>" style="padding: 4px; border: 1px solid #dfdfdf; border-radius: 3px; width: 1100px;">
                </div>
            </div>

            <script type="text/javascript">
                $(function () {
                    $('#toolbar').w2toolbar({
                        name: 'toolbar',
                        items: [{
                                type: 'html',
                                id: 'editClient',
                                html: function (item) {
                                    var html = '<a href="#"><img style="height:35px;" class="edit-icon" title="Edit" onclick="JavaScript: updateEmpInformation();"/></a>';
                                    return html;
                                }
                            },
                            {
                                type: 'break'
                            }, {
                                type: 'html',
                                id: 'finical',
                                html: function (item) {
                                    var html = '<a href="#"><img style="height:35px;" class="finical-icon" title="Salary Config" onclick="JavaScript: salaryConfig(\x27<%=employeeWbo.getAttribute("empId")%>\x27);"/></a>';
                                    return html;
                                }
                            },
                            {
                                type: 'html',
                                id: 'View Employee Salary',
                                html: function (item) {
                                    var html = '<a href="<%=context%>/FinancialManagementServlet?op=getEmpMonthlySalary&empID=<%=employeeWbo.getAttribute("empId")%>"><img style="height:35px;" class="salary-icon" title="Monthly Salary" /></a>';
                                    return html;
                                }
                            },
                            {
                                type: 'break'
                            }, {
                                type: 'html',
                                id: 'attachFile',
                                html: function (item) {
                                    var html = '<a href="#"><img style="height:35px;" class="attach-icon" title="Attach File" onclick="JavaScript: openAttachmentDialog(\x27<%=employeeWbo.getAttribute("empId")%>\x27, \x27employee\x27);"/></a>';
                                    return html;
                                }
                            }, {
                                type: 'break'
                            },
                            {
                                type: 'html',
                                id: 'viewFiles',
                                html: function (item) {
                                    var html = '<a href="#"><img style="height:35px;" class="view-file-icon" title="View Files" onclick="JavaScript: showAttachedFiles(\x27<%=employeeWbo.getAttribute("empId")%>\x27);"/></a>';
                                    return html;
                                }
                            }, {
                                type: 'break'
                            },
                            {
                                type: 'html',
                                id: 'gallery',
                                html: function (item) {
                                    var html = '<a href="#"><img style="height:35px;" class="gallery-view-icon" title="عرض الصور" onclick="JavaScript: openGalleryDialog(\x27<%=employeeWbo.getAttribute("empId")%>\x27, \x27employee\x27);"/></a>';
                                    return html;
                                }
                            }, {
                                type: 'break'
                            },
                            {
                                type: 'html',
                                id: 'deleteClient',
                                html: function (item) {
                                    var html = '<a href="<%=context%>/ClientServlet?op=ConfirmDeleteClient&empID=<%=employeeWbo.getAttribute("id")%>&clientName=<%=employeeWbo.getAttribute("name")%>&clientNo=<%=employeeWbo.getAttribute("clientNO")%>&fromPage=customSearch"><img style="height:35px;" class="delete-icon" title="Delete"/></a>';
                                    return html;
                                }
                            }, {
                                type: 'break'
                            },
                            {
                                type: 'html', id: 'education',
                                html: function (item) {
                                    var html = '<a href="#"><img style="height:35px;" class="education-icon" title="Education" onclick="JavaScript: viewEmpEducation();"/></a>';
                                    return html;
                                }
                            }, {
                                type: 'break'
                            },
                            {
                                type: 'html', id: 'email',
                                html: function (item) {
                                    var html = '<a href="#"><img style="height:35px;" class="email-icon" title="Send Email" onclick="JavaScript: openEmailDialog(\x27<%=employeeWbo.getAttribute("empName")%>\x27,\x27<%=employeeWbo.getAttribute("email")%>\x27,\x27<%=sendEmail%>\x27);"/></a>';
                                    return html;
                                }
                            }, {
                                type: 'break'
                            }, {
                                type: 'html',
                                id: 'details',
                                html: function (item) {
                                    var html = '<a href="#"><img style="height:35px;" class="details-icon" title="Employee Details" onclick="JavaScript: viewEmpCommunications();"/></a>';
                                    return html;
                                }
                            }, {
                                type: 'break'
                            }, {
                                type: 'html',
                                id: 'dates',
                                html: function (item) {
                                    var html = '<a href="#"><img style="height:35px;" class="dates-icon" title="Employee Dates" onclick="JavaScript: viewEmpDates();"/></a>';
                                    return html;
                                }
                            }, {
                                type: 'break'
                            }, {
                                type: 'html',
                                id: 'profile',
                                html: function (item) {
                                    var html = '<a href="#"><img style="height:35px;" class="profile-icon" title="Employee Profile" onclick="JavaScript: openEmpProfileDialog(\x27<%=employeeWbo.getAttribute("empId")%>\x27);"/></a>';
                                    return html;
                                }
                            }, {
                                type: 'break'
                            }, {
                                type: 'html',
                                id: 'requests',
                                html: function (item) {
                                    var html = '<a href="<%=context%>/EmployeeServlet?op=holidayRequest&empID=<%=employeeWbo.getAttribute("empId")%>"><img style="height:35px;" class="reqs-icon" title="Create Requests"/></a>';
                                    return html;
                                }
                            }, {
                                type: 'break'
                            }, {
                                type: 'html',
                                id: 'requestsRprt',
                                html: function (item) {
                                    var html = '<a href="<%=context%>/ReportsServletThree?op=getAllEmployeesRequestsReport&typ=2&empID=<%=employeeWbo.getAttribute("empId")%>"><img style="height:35px;" class="reqsRprt-icon" title="Employee Requests"/></a>';
                                    return html;
                                }
                            }, {
                                type: 'break'
                            }]
                    });
                }
                );
            </script>
            <table  border="0px" dir="<%=dir%>" class="table" style="width:<fmt:message key="width"/>;text-align: right;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >
                <tr>
                    <td class="td">
                        <table style="width: 100%;">
                            <tr>
                                <td class="td titleTD">
                                    <%=empNo%> 
                                </td>

                                <td class="td dataTD">
                                    <%=employeeWbo.getAttribute("empNO")%> 
                                    <input type="hidden" id="empId" name="empId" value="<%=employeeWbo.getAttribute("empId")%>"/>
                                </td>

                                <td class="td dataTD" rowspan="8">
                                    <img src="<%=context%>/EmployeeServlet?op=viewPersonalPhoto&employeeID=<%=employeeWbo.getAttribute("empId")%>" width="180" height="220" style="border: #000 double thick; float: center;"/>
                                </td>
                            </tr>

                            <tr>
                                <td class="td titleTD">
                                    <%=empName%> 
                                </td>

                                <td class="td dataTD">
                                    <%=employeeWbo.getAttribute("empName")%> 
                                </td>
                            </tr>

                            <tr>
                                <td class="td titleTD">
                                    <%=empAddress%> 
                                </td>

                                <td class="td dataTD">
                                    <%=employeeWbo.getAttribute("address") != null ? employeeWbo.getAttribute("address") : ""%> 
                                </td>
                            </tr>

                            <tr>
                                <td class="td titleTD">
                                    <%=maritalStatus%> 
                                </td>

                                <td class="td dataTD">
                                    <%=employeeWbo.getAttribute("maritalStatus") != null ? employeeWbo.getAttribute("maritalStatus") : ""%> 
                                </td>
                            </tr>
                            <tr>
                                <td class="td titleTD">
                                    <%=empEmail%> 
                                </td>

                                <td class="td dataTD">
                                    <%=employeeWbo.getAttribute("email") != null ? employeeWbo.getAttribute("email") : ""%>
                                </td>
                            </tr>
                            <tr>
                                <td class="td titleTD">
                                    <fmt:message key="mobile"/> 
                                </td>

                                <td class="td dataTD">
                                    <%=employeeWbo.getAttribute("homePhone") != null ? employeeWbo.getAttribute("homePhone") : ""%>
                                </td>
                            </tr>
                            <tr>
                                <td class="td titleTD">
                                    <%=empGender%>
                                </td>

                                <td class="td dataTD">
                                    <%=employeeWbo.getAttribute("gender") != null ? employeeWbo.getAttribute("gender") : ""%>
                                </td>
                            </tr>
                            <tr>
                                <td class="td titleTD">
                                    <%=workType%>
                                </td>

                                <td class="td dataTD">
                                    <%=employeeWbo.getAttribute("option1") != null ? employeeWbo.getAttribute("option1") : ""%>
                                </td>
                            </tr>

                            <tr>
                                <td class="td titleTD" >
                                    <fmt:message key="notes" /> 
                                </td>

                                <td class="td dataTD" style="text-align: <fmt:message key="align" /> " colspan="2">
                                    <textarea readonly rows="8" cols="55"><%= employeeWbo.getAttribute("note") != null && !((String) employeeWbo.getAttribute("note")).equals("UL") ? employeeWbo.getAttribute("note") : "&nbsp;"%></textarea>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <%}%>
        </fieldset>
    </BODY>
</html>
