<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.maintenance.db_access.ProjectsByGroupMgr"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@page import="com.maintenance.db_access.IssueByComplaintAllCaseMgr"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@page import="com.silkworm.international.TouristGuide"%>
<%@page import="com.silkworm.util.DateAndTimeConstants"%>
<%@page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    Hashtable logos = new Hashtable();
    logos = (Hashtable) session.getAttribute("logos");
    int iTotal = 0;
    Vector data = (Vector) request.getAttribute("data");
    String beDate = (String) request.getAttribute("beginDate");
    String eDate = (String) request.getAttribute("endDate");
    String compStatusVal = (String) request.getAttribute("compStatus");
    String ticketStatus = request.getAttribute("ticketStatus") != null ? (String) request.getAttribute("ticketStatus") : "";
    IssueByComplaintAllCaseMgr issueByComplaintAllCaseMgr = IssueByComplaintAllCaseMgr.getInstance();
    String statusName = issueByComplaintAllCaseMgr.getStatusName(compStatusVal);
    Calendar cal = Calendar.getInstance();
    String jDateFormat = "yyyy/MM/dd";
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowTime = sdf.format(cal.getTime());
    cal = Calendar.getInstance();
    cal.add(Calendar.MONTH, -1);
    int a = cal.get(Calendar.YEAR);
    int b = (cal.get(Calendar.MONTH)) + 1;
    int d = cal.get(Calendar.DATE);
    String prev = a + "/" + b + "/" + d;
    String age = "";
    int diffDays = 0;
    int diffMonths = 0;
    int diffYears = 0;
    SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");

    // to get user department
    UserMgr userMgr = UserMgr.getInstance();
    WebBusinessObject managerWbo = userMgr.getManagerByEmployeeID(securityUser.getUserId());
    String departmentID = "";
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    if (managerWbo != null) {
        departmentID = (String) managerWbo.getAttribute("fullName");
        ArrayList<WebBusinessObject> departmentList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle((String) managerWbo.getAttribute("userId"), "key5"));
        if (departmentList.size() > 0) {
            departmentID = (String) departmentList.get(0).getAttribute("projectID");
        }
    } else {
        ArrayList<WebBusinessObject> departmentList = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle(securityUser.getUserId(), "key5"));
        if (departmentList.size() > 0) {
            departmentID = (String) departmentList.get(0).getAttribute("projectID");
        }
    }
    String selectedDepartmentID = request.getAttribute("departmentID") != null ? (String) request.getAttribute("departmentID") : "";

    ArrayList statusTypes = issueByComplaintAllCaseMgr.getStatusTypes();
    ArrayList ticketTypes = issueByComplaintAllCaseMgr.getStatusTypesByDepart(departmentID);

    ArrayList<WebBusinessObject> departmentsList = (ArrayList<WebBusinessObject>) request.getAttribute("departments");

    String stat = "Ar";
    String align = "center";
    String dir = null;
    String style = null, lang, langCode, cancel, title, beginDate, endDate, print;
    String complaintNo, customerName, complaintDate, complaint;
    String sat, sun, mon, tue, wed, thu, fri, view, complaintCode, PN, type, compStatus, compSender, noResponse, ageComp;
    String complStatus, senderName = null, fullName = null, sendEmail, successMsg, failMsg, mobile, interPhone, distributionDate;
    if (stat.equals("En")) {
        align = "left";
        dir = "LTR";
        style = "text-align:right";
        lang = "&#1593;&#1585;&#1576;&#1610;";
        langCode = "Ar";
        cancel = "Cancel";
        title = "Complaints Reprot";
        beginDate = "From Date";
        endDate = "To Date";
        print = "Print";
        complaintNo = "Order No.";
        customerName = "Customer name";
        complaintDate = "Calling date";
        complaint = "Complaint";
        sat = "Sat";
        sun = "Sun";
        mon = "Mon";
        tue = "Tue";
        wed = "Wed";
        thu = "Thu";
        fri = "Fri";
        view = "View";
        complaintCode = "Complaint code";
        type = "Type";
        compStatus = "Staus";
        compSender = "Sender";
        noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
        ageComp = "A.C(day)";
        PN = "Requests No.";
        sendEmail = "Send Email";
        successMsg = "Message Sent Successfully";
        failMsg = "Fail to Send Message";
        mobile = "Mobile";
        interPhone = "Inter. Phone";
        distributionDate = "Distribution Date";
    } else {
        dir = "RTL";
        align = "right";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        cancel = "&#1573;&#1606;&#1607;&#1575;&#1569;";
        title = "البحث عن طلب";
        PN = "عدد الطلبات";
        beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
        endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        print = "&#1591;&#1576;&#1575;&#1593;&#1577; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
        complaintNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1578;&#1575;&#1576;&#1593;&#1577;";
        customerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";
        complaintDate = "&#1608;&#1602;&#1578; &#1575;&#1604;&#1575;&#1578;&#1589;&#1575;&#1604;";
        complaint = "&#1575;&#1604;&#1591;&#1604;&#1576;";
        sat = "&#1575;&#1604;&#1587;&#1576;&#1578;";
        sun = "&#1575;&#1604;&#1575;&#1581;&#1583;";
        mon = "&#1575;&#1604;&#1575;&#1579;&#1606;&#1610;&#1606;";
        tue = "&#1575;&#1604;&#1579;&#1604;&#1575;&#1579;&#1575;&#1569;";
        wed = "&#1575;&#1604;&#1575;&#1585;&#1576;&#1593;&#1575;&#1569;";
        thu = "&#1575;&#1604;&#1582;&#1605;&#1610;&#1587;";
        fri = "&#1575;&#1604;&#1580;&#1605;&#1593;&#1577;";
        view = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577;";
        complaintCode = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1591;&#1604;&#1576;";
        type = "النوع";
        compStatus = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
        compSender = "&#1575;&#1604;&#1605;&#1587;&#1574;&#1608;&#1604;";
        noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
        ageComp = "&#1593;.&#1591; (&#1610;&#1608;&#1605;)";
        sendEmail = "أرسال رسالة ألكترونية";
        successMsg = "تم أرسال الرسالة";
        failMsg = "لم يتم أرسال الرسالة";
        mobile = "المحمول";
        interPhone = "الدولي";
        distributionDate = "تاريخ التوزيع";

    }
    String sDate, sTime = null;
%>

<link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
<link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
<link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
<link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
<link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
<link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
<link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
<link rel="stylesheet" href="css/chosen.css"/>

<script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
<script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
<script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
<script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
<script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
<script src="js/chosen.jquery.js" type="text/javascript"></script>
<script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    $(function () {
        $("#beginDate, #endDate").datepicker({
            changeMonth: true,
            changeYear: true,
            maxDate: 0,
            dateFormat: "yy/mm/dd"
        });
    });

    function getComplaints() {
        var beginDate = $("#beginDate").val();
        var endDate = $("#endDate").val();
        if ((beginDate = null || beginDate == "")) {
            alert("من فضلك أدخل تاريخ البداية");
        }
        else if ((endDate = null || endDate == "")) {
            alert("من فضلك أدخل تاريخ النهاية");

        } else {
            beginDate = $("#beginDate").val();
            endDate = $("#endDate").val();
            var compStatus = $("#compStatus").val();
            var ticketStatus = $("#ticketStatus").val();
            var departmentID = $("#departmentID").val();
            document.COMP_FORM.action = "<%=context%>/SearchServlet?op=searchForClosedCallCenter&beginDate=" + beginDate + "&endDate=" + endDate
                    + "&ticketStatus=" + ticketStatus + "&compStatus=" + compStatus + "&departmentID=" + departmentID;
            document.COMP_FORM.submit();
        }
    }

    function assignClientComplaintToProject() {
        var projectId = $("#toFolder").val();
        var clientComplaintIds = $("#moveTo:checked").map(function () {
            return $(this).val();
        }).get();
        if (clientComplaintIds == '') {
            $('#saveToFileMsg').html('Please select at least one request.');
            return;
        }
        $.ajax({
            type: 'POST',
            url: "<%=context%>/ProjectServlet?op=addClientComplaintIntoProject",
            data: {clientComplaintIds: clientComplaintIds.join(","), projectId: projectId},
            success: function (data) {
                var jsonString = $.parseJSON(data);
                if (jsonString.status === 'ok') {
                    $('#saveToFileMsg').html('Save To Folder Done');
                } else if (jsonString.status === 'failed') {
                    $('#saveToFileMsg').html('Problem at Saving To Folder , Please Contact Administrator');
                }
            }
        });
    }

    $(document).ready(function () {
        $('#indextable').dataTable({
            bJQueryUI: true,
            sPaginationType: "full_numbers",
            "aLengthMenu": [[20, 40, 70, 100, -1], [20, 40, 70, 100, "All"]],
            iDisplayLength: 20,
            iDisplayStart: 0,
            "bPaginate": true,
            "bProcessing": true,
            "aaSorting": [[10, "asc"]]
        }).show();
        $(".dataTables_length, .dataTables_info").css("float", "left");
        $(".dataTables_filter, .dataTables_paginate").css("float", "right");
    });

    var divAttachmentTag;
    function openAttachmentDialog(issueId, objectType) {
        loading("block");
        divAttachmentTag = $("div[name='divAttachmentTag']");
        $.ajax({
            type: "post",
            url: '<%=context%>/FileUploadServlet?op=getUploadDialog',
            data: {
                businessObjectId: issueId,
                objectType: objectType
            },
            success: function (data) {
                divAttachmentTag.html(data)
                        .dialog({
                            modal: true,
                            title: "ارفاق مستندات",
                            show: "fade",
                            hide: "explode",
                            width: 800,
                            position: {
                                my: 'center',
                                at: 'center'
                            },
                            buttons: {
                                Cancel: function () {
                                    divAttachmentTag.dialog('close');
                                },
                                Done: function () {
                                    divAttachmentTag.dialog('close');
                                }
                            }
                        })
                        .dialog('open');
            },
            error: function (data) {
                alert(data);
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

    function viewDocuments(issueId) {
        var url = '<%=context%>/IssueDocServlet?op=ListAttachedDocs&issueId=' + issueId + '';
        var wind = window.open(url, "عرض المستندات", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
        wind.focus();
    }

    var divCommentsTag;
    function openCommentsDialog(complaintId) {
        loading("block");
        divCommentsTag = $("div[name='divCommentsTag']");
        $.ajax({
            type: "post",
            url: '<%=context%>/CommentsServlet?op=showCommentsPopup',
            data: {
                clientComplaintId: complaintId
            },
            success: function (data) {
                divCommentsTag.html(data)
                        .dialog({
                            modal: true,
                            title: "عرض التعليقات",
                            show: "fade",
                            hide: "explode",
                            width: 1000,
                            position: {
                                my: 'center',
                                at: 'center'
                            },
                            buttons: {
                                Cancel: function () {
                                    divCommentsTag.dialog('destroy').hide();
                                },
                                Done: function () {
                                    divCommentsTag.dialog('destroy').hide();
                                }
                            }
                        })
                        .dialog('open');
            },
            error: function (data) {
                alert('Data Error = '+data);
            }
        });
        loading("none");
    }
    function openEmailDialog(clientComplaintID, issueID, typeName) {
        loading("block");
        divCommentsTag = $("div[name='divCommentsTag']");
        count = 1
        $.ajax({
            type: "post",
            url: '<%=context%>/EmailServlet?op=getEmailPopup',
            data: {
                clientComplaintID: clientComplaintID,
                issueID: issueID,
                typeName: typeName
            },
            success: function (data) {
                divCommentsTag.html(data)
                        .dialog({
                            modal: true,
                            title: "<%=sendEmail%>",
                            show: "fade",
                            hide: "explode",
                            width: 650,
                            height: 620,
                            position: {
                                my: 'center',
                                at: 'center'
                            },
                            buttons: {
                                Close: function () {
                                    divCommentsTag.dialog('destroy').hide();
                                },
                                Send: function () {
                                    sendMailByAjax();
                                }
                            }
                        })
                        .dialog('open');
            },
            error: function (data) {
                alert('Data Error = '+data);
            }
        });
        loading("none");
    }
    function sendMailByAjax() {
        $("#progressx").css("display", "block");
        $("#progressx").show();
        $("#emailStatus").html("");
        $("#progressx").css("display", "block");
        var formData = new FormData($("#emailForm")[0]);
        var obj = $("#listFile");
        $.each($(obj).find("input[type='file']"), function (i, tag) {
            $.each($(tag)[0].files, function (i, file) {
                formData.append(tag.name, file);
            });
        });
        formData.append("to", $("#to").val());
        formData.append("subject", $("#subject").val());
        formData.append("counter", $("#emailCounter").val());
        formData.append("message", $("#message").val());
        $.ajax({
            url: '<%=context%>/EmailServlet?op=sendByAjax',
            type: 'POST',
            data: formData,
            async: false,
            success: function (data) {
                var result = $.parseJSON(data);
                $("#progressx").html('');
                $("#progressx").css("display", "none");
                if (result.status == 'ok') {
                    $("#emailStatus").html("<font color='green'><%=successMsg%></font>");
                } else if (result.status == 'error') {
                    $("#emailStatus").html("<font color='red'><%=failMsg%></font>");
                }
            },
            error: function ()
            {
                $("#emailStatus").html("<font color='red'><%=failMsg%></font>");
            },
            cache: false,
            contentType: false,
            processData: false
        });
        return false;
    }
    var count = 1;
    function addEmailFiles(obj) {
        if ((count * 1) == 4) {
            $("#addEmailFile").removeAttr("disabled");
        }

        if (count >= 1 & count <= 4) {
            $("#listFile").append("<input type='file' style='text-align:right;font-size:12px;margin:1.5px;' name='file" + count + "' id='file2'  maxlength='60'/>");
            $("#emailCounter").val(count);
            count = Number(count * 1 + 1)

        } else {
            $("#addEmailFile").attr("disabled", true);
        }
    }
    function getRequestsCount(issueId, obj) {
        $.ajax({
            type: "post",
            url: "<%=context%>/IssueServlet?op=getRequestsCountAjax",
            data: {
                issueId: issueId
            }
            ,
            success: function(jsonString) {
                var info = $.parseJSON(jsonString);
                $(obj).attr("title", "عدد المعتمدات: " + info.count);
            }
        });
    }
</SCRIPT>

<HTML>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
        <META HTTP-EQUIV="Expires" CONTENT="0">   
    </head>

    <body>
        <div name="divAttachmentTag"></div>
        <div name="divCommentsTag"></div>

        <FORM NAME="COMP_FORM" METHOD="POST">
            <table align="center" width="80%">
                <tr>
                    <td class="td">
                        <fieldset>
                            <legend align="center">
                                <table dir="rtl" align="center">
                                    <tr>
                                        <td class="td">
                                            <font color="blue" size="6"> <%=title%></font>
                                        </td>
                                    </tr>
                                </table>
                            </legend>

                            <TABLE ALIGN="center" DIR="RTL" WIDTH=570 CELLSPACING=2 CELLPADDING=1>
                                <TR>
                                    <TD class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                                        <b><font size=3 color="white" title="<%=distributionDate%>"> <%=beginDate%></b>
                                    </TD>
                                    <TD  class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="50%">
                                        <b> <font size=3 color="white" title="<%=distributionDate%>"> <%=endDate%> </b>
                                    </TD>
                                </TR>

                                <TR>
                                    <TD style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                                        <%
                                            String url = request.getRequestURL().toString();
                                            String subURL = url.substring(0, url.indexOf(metaMgr.getContext()));
                                            Calendar c = Calendar.getInstance();
                                        %>
                                        <% if (beDate != null && !beDate.isEmpty()) {%>
                                        <input id="beginDate" name="beginDate" type="text" value="<%=beDate%>" title="<%=distributionDate%>" /><img src="images/showcalendar.gif" > 
                                        <%} else {%>
                                        <input id="beginDate" name="beginDate" type="text" value="<%=prev%>" title="<%=distributionDate%>" /><img src="images/showcalendar.gif" > 
                                        <%}%>
                                        <br><br>
                                    </TD>

                                    <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                                        <% if (eDate != null && !eDate.isEmpty()) {%>
                                        <input id="endDate" name="endDate" type="text" value="<%=eDate%>" title="<%=distributionDate%>" /><img src="images/showcalendar.gif" > 
                                        <%} else {%>
                                        <input id="endDate" name="endDate" type="text" value="<%=nowTime%>" title="<%=distributionDate%>" /><img src="images/showcalendar.gif" > 
                                        <%}%>
                                        <br><br>
                                    </td>
                                </TR>

                                <tr>
                                    <td class="blueBorder blueHeaderTD">
                                        <b><font size=3 color="white">الحالة</font></b>
                                    </td>
                                    <td class="blueBorder blueHeaderTD">
                                        <b><font size=3 color="white">نوع الطلب</font></b>
                                    </td>
                                </tr>
                                
                                <tr>
                                    <td style="text-align:center" bgcolor="#dedede" valign="middle">
                                        <select style="font-size: 14px;font-weight: bold; width: 180px;" id="compStatus" class="chosen-select">
                                            <option value="all">الكل</option>
                                            <sw:WBOOptionList wboList='<%=statusTypes%>' displayAttribute = "arDesc" valueAttribute="id" scrollTo="<%=statusName%>"/>
                                        </select>
                                    </td>
                                    <td bgcolor="#dedede"  style="text-align:center" valign="middle">
                                        <select style="font-size: 14px;font-weight: bold; width: 180px;"id="ticketStatus" class="chosen-select">
                                            <sw:WBOOptionList wboList='<%=ticketTypes%>' displayAttribute = "type_name" valueAttribute="type_id" scrollToValue="<%=ticketStatus%>" />
                                        </select>
                                    </td>
                                </tr>
                                
                                <tr>
                                    <td class="blueBorder blueHeaderTD" colspan="2">
                                        <b><font size=3 color="white">الأدارة</font></b>
                                    </td>
                                </tr>
                                
                                <tr>
                                    <td style="text-align:center" bgcolor="#dedede" valign="middle" colspan="2">
                                        <select style="font-size: 14px;font-weight: bold; width: 180px;" id="departmentID" class="chosen-select">
                                            <sw:WBOOptionList wboList='<%=departmentsList%>' displayAttribute = "projectName" valueAttribute="projectID" scrollToValue="<%=selectedDepartmentID%>"/>
                                        </select>
                                    </td>
                                </tr>

                                <tr>
                                    <TD STYLE="text-align:center" CLASS="td" colspan="3">  
                                        <button  onclick="JavaScript: getComplaints();"   STYLE="color: #27272A;font-size:15;margin-top: 20px;font-weight:bold; ">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                                    </TD>
                                </tr>
                            </TABLE>
                        </fieldset>
                    </td>
                </tr>
            </table>

            <div id="loading" class="container" style="display: none">
                <div class="contentBar">
                    <div id="block_1" class="barlittle"></div>
                    <div id="block_2" class="barlittle"></div>
                    <div id="block_3" class="barlittle"></div>
                    <div id="block_4" class="barlittle"></div>
                    <div id="block_5" class="barlittle"></div>
                </div>
            </div>

            <% if (data != null && !data.isEmpty()) {%>

            <br>

            <table class="blueBorder"  id="indextable" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0" style="display: none; text-align: center">
                <thead>
                    <TR>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" rowspan="2"><b>#</b></TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" rowspan="2"><input type="checkbox" id="ToggleTo" name="ToggleTo"></TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="15%" colspan="4"><img src="images/icons/operation.png" width="24" height="24"/></TH>  
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" rowspan="2"><img src="images/icons/Numbers.png" width="20" height="20" /><b> <%=complaintNo%></b></TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%" rowspan="2"><img src="images/icons/client.png" width="20" height="20" /><b> <%=customerName%></b></TH>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%" rowspan="2"><b> <%=mobile%></b></th>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%" rowspan="2"><b> <%=interPhone%></b></th>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" rowspan="2"><b>النوع</b></TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%" rowspan="2"><img src="images/icons/list_.png" width="20" height="20" /><b> <%=complaint%></b></TH>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%" rowspan="2"><b>المصدر</b></th>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" rowspan="2"><b>الحاله</b></TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" rowspan="2"><b>تاريخ الحاله</b></TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%" rowspan="2"><b>المسئول</b></TH>
                    </TR>

                    <TR>
                        <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">&ensp;</TH>
                        <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">&ensp;</TH>
                        <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">&ensp;</TH>
                        <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">&ensp;</TH>
                    </TR>
                </thead>

                <tbody  id="planetData2">
                    <%
                        Enumeration e = data.elements();
                        String compStyle = "";
                        WebBusinessObject wbo = new WebBusinessObject();
                        while (e.hasMoreElements()) {
                            iTotal++;
                            wbo = (WebBusinessObject) e.nextElement();
                            WebBusinessObject senderInf = null;

                            senderInf = userMgr.getOnSingleKey(wbo.getAttribute("senderId").toString());
                            WebBusinessObject clientCompWbo = null;
                            String compType = "";
                            ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                            clientCompWbo = clientComplaintsMgr.getOnSingleKey(wbo.getAttribute("clientComId").toString());
                            if (clientCompWbo.getAttribute("ticketType").toString().equals("1")) {
                                compType = "شكوى";
                                compStyle = "comp";
                            } else if (clientCompWbo.getAttribute("ticketType").toString().equals("2")) {
                                compType = "طلب";
                                compStyle = "order";
                            } else if (clientCompWbo.getAttribute("ticketType").toString().equals("3")) {
                                compType = "استعلام";
                                compStyle = "query";
                            } else if (clientCompWbo.getAttribute("ticketType").toString().equals("5")) {
                                compType = "مستخلص";
                                compStyle = "order";
                            } else if (clientCompWbo.getAttribute("ticketType").toString().equals("6")) {
                                compType = "ط. تسليم";
                                compStyle = "order";
                            } else if (clientCompWbo.getAttribute("ticketType").toString().equals("7")) {
                                compType = "م. مالية";
                                compStyle = "order";
                            } else if (clientCompWbo.getAttribute("ticketType").toString().equals("25")) {
                                compType = "طلب عميل";
                                compStyle = "order";
                            }
                    %>
                    <TR style="padding: 1px;">
                        <TD>
                            <%=iTotal%>
                        </td>
                        <td>
                            <input type="checkbox" id="moveTo" name="moveTo" value="<%=wbo.getAttribute("clientComId")%>">
                        </td>
                        <td width="2.5%">
                            <a href="JavaScript: openAttachmentDialog('<%=wbo.getAttribute("issue_id")%>', '<%=CRMConstants.OBJECT_TYPE_ISSUE%>');">
                                <img style="margin: 3px" src="images/icons/attachment.png" width="24" height="24"/>
                            </a>
                        </td>
                        <td width="2.5%">
                            <a href="JavaScript: viewDocuments('<%=wbo.getAttribute("issue_id")%>')"
                               onmouseover="JavaScript: getDocumentCount(this, '<%=wbo.getAttribute("issue_id")%>')">
                                <img style="margin: 3px" src="images/Foldericon.png" width="24" height="24"/>
                            </a>
                        </td>
                        <td width="2.5%">
                            <a href="JavaScript: openCommentsDialog('<%=wbo.getAttribute("clientComId")%>');">
                                <img style="margin: 3px" src="images/icons/accept-with-note.png" width="24" height="24"/>
                            </a>
                        </td>
                        <td width="2.5%">
                            <a href="JavaScript: openEmailDialog('<%=wbo.getAttribute("clientComId")%>', '<%=wbo.getAttribute("issue_id")%>', '<%=compType%>');" title="<%=sendEmail%>">
                                <img style="margin: 3px" src="images/icons/email.png" width="35" height="35"/>
                            </a>
                        </td>
                        <TD  style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                            <%if (wbo.getAttribute("issue_id") != null) {%>
                            <a href="<%=context%>/IssueServlet?op=getCompl3&issueId=<%=wbo.getAttribute("issue_id")%>&compId=<%=wbo.getAttribute("clientComId")%>&statusCode=<%=wbo.getAttribute("statusCode")%>&receipId=<%=wbo.getAttribute("receipId")%>&senderID=<%=wbo.getAttribute("senderId")%>"
                               onmouseover="JavaScript: getRequestsCount('<%=wbo.getAttribute("issue_id")%>', this);"> <font color="red"><%=wbo.getAttribute("businessID").toString()%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate").toString()%></font></a>
                                <%}%>
                        </TD>
                        <TD nowrap>
                            <%if (wbo.getAttribute("customerName") != null) {%>
                                <b><%=wbo.getAttribute("customerName")%></b>
                                <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("customerId")%>">
                                    <img src="images/client_details.jpg" width="30" style="float: left;"/>
                                </a>
                            <%}%>
                        </TD>
                        <td>
                            <b><%=wbo.getAttribute("clientMobile") != null && !"UL".equals(wbo.getAttribute("clientMobile")) ? wbo.getAttribute("clientMobile") : ""%></b>
                        </td>
                        <td>
                            <b><%=wbo.getAttribute("interPhone") != null && !"UL".equals(wbo.getAttribute("interPhone")) ? wbo.getAttribute("interPhone") : ""%></b>
                        </td>
                        <TD>
                            <%if (compType != null) {%><b><%=compType%></b><%}%>
                        </TD>
                        <% String sCompl = " ";
                            if (wbo.getAttribute("compSubject") != null && !wbo.getAttribute("compSubject").equals("")) {
                                sCompl = (String) wbo.getAttribute("compSubject");
                                if (sCompl.length() > 10) {
                        %>
                        <TD ><b><%=sCompl%></b></TD>
                                <% } else {%>
                        <TD ><b><%=sCompl%></b></TD>
                                <% }%>
                                <% } else {%>
                        <TD ><b><%=sCompl%></b></TD>
                                <%}%>
                        <td>
                            <%if (wbo.getAttribute("createdByName") != null) {%><b><%=wbo.getAttribute("createdByName")%></b><%}%>
                        </td>

                        <% if (stat.equals("En")) {
                                complStatus = (String) wbo.getAttribute("statusEnName");
                            } else {
                                complStatus = (String) wbo.getAttribute("statusArName");
                            }
                        %>
                        <TD><b><%=complStatus%></b></TD>

                        <%  c = Calendar.getInstance();
                            DateFormat formatter;
                            formatter = new SimpleDateFormat("dd/MM/yyyy");
                            String[] arrDate = wbo.getAttribute("entryDate").toString().split(" ");
                            Date date = new Date();
                            sDate = arrDate[0];
                            sTime = arrDate[1];
                            String[] arrTime = sTime.split(":");
                            sTime = arrTime[0] + ":" + arrTime[1];
                            sDate = sDate.replace("-", "/");
                            arrDate = sDate.split("/");
                            sDate = arrDate[2] + "/" + arrDate[1] + "/" + arrDate[0];
                            c.setTime((Date) formatter.parse(sDate));
                            int dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
                            String currentDate = formatter.format(date);
                            String sDay = null;
                            if (dayOfWeek == 7) {
                                sDay = sat;
                            } else if (dayOfWeek == 1) {
                                sDay = sun;
                            } else if (dayOfWeek == 2) {
                                sDay = mon;
                            } else if (dayOfWeek == 3) {
                                sDay = tue;
                            } else if (dayOfWeek == 4) {
                                sDay = wed;
                            } else if (dayOfWeek == 5) {
                                sDay = thu;
                            } else if (dayOfWeek == 6) {
                                sDay = fri;
                            }
                        %>
                        <%if (currentDate.equals(sDate)) {%>
                        <TD nowrap><font color="red">Today - </font><b><%=sTime%></b></TD>
                                <%} else {%>

                        <TD nowrap  ><font color="red"><%=sDay%> - </font><b><%=sDate + " " + sTime%></b></TD>
                                <%}%>

                        <% if (wbo.getAttribute("recipientFullName") != null && !wbo.getAttribute("recipientFullName").equals("")) {
                                fullName = (String) wbo.getAttribute("recipientFullName");
                            } else {
                                fullName = "";
                            }
                        %>
                        <TD style="width: 10%;"  ><b><%=fullName%></b></TD>
                    </tr>
                    <%}%>
                </tbody>
            </table>
            <% } else if (data != null && data.isEmpty()) {%>
            <table align="center" width="80%">
                <tr>
                    <td class="td">
                        <fieldset>
                            <center><b style="color: red; font-size: x-large;">لا يوجد نتائج للبحث</b></center>
                        </fieldset>
                    </td>
                </tr>
            </table>
            <%
                }
            %>
        </FORM>
        <script>
            var config = {
                '.chosen-select': {no_results_text: 'No data found with this name!'}
            };
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        </script>
    </body>
</html>