<%@page import="com.clients.db_access.ClientComplaintsSLAMgr"%>
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
    IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
    String context = metaMgr.getContext();

    Hashtable logos = new Hashtable();
    logos = (Hashtable) session.getAttribute("logos");
    int iTotal = 0;
    DateAndTimeControl.CustomDate custom;
    Vector data = (Vector) request.getAttribute("data");
    String beDate = (String) request.getAttribute("beginDate");
    String eDate = (String) request.getAttribute("endDate");
    String compStatusVal = (String) request.getAttribute("compStatus");
    String ticketStatus = request.getAttribute("ticketStatus") != null ? (String) request.getAttribute("ticketStatus") : "";
    IssueByComplaintAllCaseMgr issueByComplaintAllCaseMgr = IssueByComplaintAllCaseMgr.getInstance();
    if (compStatusVal == null) {
        compStatusVal = "2";
    }
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

    ArrayList statusTypes = issueByComplaintAllCaseMgr.getStatusTypes();
    ArrayList ticketTypes = issueByComplaintAllCaseMgr.getStatusTypesByDepart(departmentID);

    ArrayList<WebBusinessObject> arrayOfProjects = projectMgr.getProjectWithUserCreated(securityUser.getUserId());

    ClientComplaintsSLAMgr clientComplaintsSLAMgr = ClientComplaintsSLAMgr.getInstance();

    String stat = "Ar";
    String align = "center";
    String dir = null;
    String style = null, lang, langCode, cancel, title, beginDate, endDate, print;
    String complaintNo, requestTitle, complaintDate, complaint;
    String sat, sun, mon, tue, wed, thu, fri, view, complaintCode, PN, type, compStatus, compSender, noResponse, ageComp;
    String complStatus, senderName = null, fullName = null;
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
        requestTitle = "Customer name";
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
    } else {
        dir = "RTL";
        align = "right";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        cancel = "&#1573;&#1606;&#1607;&#1575;&#1569;";
        title = "الوقت المستغرق في العمليات";
        PN = "عدد الطلبات";
        beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
        endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        print = "&#1591;&#1576;&#1575;&#1593;&#1577; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
        complaintNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1578;&#1575;&#1576;&#1593;&#1577;";
        requestTitle = "طلب - الوحدة";
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

    }
    String sDate, sTime = null;
    String statusStartDate, statusEndDate, flag, slaCreationTime;
%>

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
            document.COMP_FORM.action = "<%=context%>/SearchServlet?op=searctForRequestLife&beginDate=" + beginDate + "&endDate=" + endDate + "&ticketStatus=" + ticketStatus + "&compStatus=" + compStatus;
            document.COMP_FORM.submit();
        }
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
            "aaSorting": [[13, "asc"]]
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
                                    divCommentsTag.dialog('close');
                                },
                                Done: function () {
                                    divCommentsTag.dialog('close');
                                }
                            }
                        })
                        .dialog('open');
            },
            error: function (data) {
                alert('Data Error = ' + data);
            }
        });
        loading("none");
    }
    
    function getPDF() {
        var beginDate = $("#beginDate").val();
        var endDate = $("#endDate").val();

        if ((beginDate = null || beginDate == "")) {
            alert("من فضلك أدخل تاريخ البداية");
        }
        else if ((endDate = null || endDate == "")) {
            alert("من فضلك أدخل تاريخ النهاية");

        } else {
            $("#pdf").attr("href","<%=context%>/SearchServlet?op=searctForRequestLifePDF&beginDate="+$("#beginDate").val()+"&endDate="+$("#endDate").val()+"&ticketStatus="+$("#ticketStatus").val()+"&compStatus="+$("#compStatus").val());
        }
    
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
                                        <b><font size=3 color="white"> <%=beginDate%></b>
                                    </TD>
                                    <TD  class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="50%">
                                        <b> <font size=3 color="white"> <%=endDate%> </b>
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
                                        <input id="beginDate" name="beginDate" type="text" value="<%=beDate%>" /><img src="images/showcalendar.gif" > 
                                        <%} else {%>
                                        <input id="beginDate" name="beginDate" type="text" value="<%=prev%>" ><img src="images/showcalendar.gif" > 
                                        <%}%>
                                        <br><br>
                                    </TD>

                                    <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                                        <% if (eDate != null && !eDate.isEmpty()) {%>
                                        <input id="endDate" name="endDate" type="text" value="<%=eDate%>" ><img src="images/showcalendar.gif" > 
                                        <%} else {%>
                                        <input id="endDate" name="endDate" type="text" value="<%=nowTime%>" ><img src="images/showcalendar.gif" > 
                                        <%}%>
                                        <br><br>
                                    </td>
                                </TR>

                                <tr>
                                    <td>
                                        <label style="font-size: 16px;color: red;" >الحالة</label>
                                        <select style="font-size: 14px;font-weight: bold;"id="compStatus" >
                                            <option value="all">الكل</option>
                                            <sw:WBOOptionList wboList='<%=statusTypes%>' displayAttribute = "arDesc" valueAttribute="id" scrollToValue="<%=compStatusVal%>"/>
                                        </select>
                                    </td>
                                    <td>
                                        <label style="font-size: 16px;color: red;" >نوع الطلب</label>
                                        <select style="font-size: 14px;font-weight: bold;"id="ticketStatus" >
                                            <sw:WBOOptionList wboList='<%=ticketTypes%>' displayAttribute = "type_name" valueAttribute="type_id" scrollToValue="<%=ticketStatus%>" />
                                        </select>
                                    </td>
                                </tr>

                                <tr>
                                    <TD STYLE="text-align:center" CLASS="td">  
                                        <button  onclick="JavaScript: getComplaints();"   STYLE="color: #27272A;font-size:15;margin-top: 20px;font-weight:bold; ">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                                    </TD>
                                    <TD STYLE="text-align:center" CLASS="td">  
                                        <a id="pdf" onclick="javaScript: getPDF()">
                                            <img style="margin: 3px" src="images/icons/pdf.png" width="24" height="24"/>
                                        </a>
                                    </TD>
                                </tr>
                            </table>
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
            <table class="blueBorder"  id="indextable" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0" style="display: none; text-align: center">
                <thead>
                    <TR>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" rowspan="2"><b>#</b></TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="15%" colspan="3"><img src="images/icons/operation.png" width="24" height="24"/></TH>  
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" rowspan="2"><img src="images/icons/Numbers.png" width="20" height="20" /><b> <%=complaintNo%></b></TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%" rowspan="2"><img src="images/icons/client.png" width="20" height="20" /><b> <%=requestTitle%></b></TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" rowspan="2"><img src="images/icons/key.png" width="20" height="20" /><b> <%=complaintCode%></b></TH>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%" rowspan="2"><b>المصدر</b></th>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" rowspan="2"><b>الحاله</b></TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" rowspan="2"><b>تاريخ الإرسال</b></TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" rowspan="2"><b>SLA</b></TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" colspan="2"><b>تخطيط بعد</b></TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" rowspan="2"><b>تاريخ الإغلاق</b></TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" colspan="2"><b>الوقت المستغرق</b></TH>
                    </TR>

                    <TR>
                        <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">&ensp;</TH>
                        <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">&ensp;</TH>
                        <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">&ensp;</TH>

                        <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">يوم</TH>
                        <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">ساعة</th>

                        <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">يوم</TH>
                        <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">ساعة</th>
                    </TR>
                </thead>

                <tbody  id="planetData2">
                    <%
                        Enumeration e = data.elements();
                        String compStyle = "";
                        WebBusinessObject wbo = new WebBusinessObject();
                        String slaValue, slaDay, slaHour;
                        WebBusinessObject slaWboTemp;
                        while (e.hasMoreElements()) {
                            iTotal++;
                            wbo = (WebBusinessObject) e.nextElement();
                            slaValue = "0";

                            WebBusinessObject senderInf = null;

                            senderInf = userMgr.getOnSingleKey(wbo.getAttribute("senderId").toString());
                            WebBusinessObject clientCompWbo = null;
                            String compType = "";
                            ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                            clientCompWbo = clientComplaintsMgr.getOnSingleKey(wbo.getAttribute("clientComId").toString());

                            //get client complaint - issue status
                            Vector<WebBusinessObject> complaintStatusVec = issueStatusMgr.getAllStatusForObject(clientCompWbo.getAttribute("id").toString());
                            WebBusinessObject firstStatus = new WebBusinessObject();
                            WebBusinessObject lastStatus = new WebBusinessObject();

                            firstStatus = (WebBusinessObject) complaintStatusVec.get(0);
                            statusStartDate = firstStatus.getAttribute("beginDate").toString();

                            if (complaintStatusVec.size() > 1) {
                                lastStatus = (WebBusinessObject) complaintStatusVec.get(complaintStatusVec.size() - 1);

                                String statusType = lastStatus.getAttribute("statusName").toString();

                                if (statusType.equals("7")) {
                                    flag = "old";
                                    statusEndDate = lastStatus.getAttribute("beginDate").toString();
                                } else {
                                    flag = "today";
                                    DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                    cal = Calendar.getInstance();
                                    statusEndDate = dateFormat.format(cal.getTime());
                                }
                            } else {
                                flag = "today";
                                DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                cal = Calendar.getInstance();
                                statusEndDate = dateFormat.format(cal.getTime());
                            }

                            //get the diffrenence between end and start date
                            DateAndTimeControl dtControl = new DateAndTimeControl();
                            Vector duration = dtControl.calculateDateDiff(statusStartDate, statusEndDate);
                            slaWboTemp = clientComplaintsSLAMgr.getOnSingleKey((String) wbo.getAttribute("clientComId"));
                            if (slaWboTemp != null) {
                                slaValue = (String) slaWboTemp.getAttribute("executionPeriod");
                                slaCreationTime = (String) slaWboTemp.getAttribute("creationTime");
                                Vector slaDuration = dtControl.calculateDateDiff(statusStartDate, slaCreationTime);
                                slaDay = slaDuration.get(0).toString();
                                slaHour = slaDuration.get(1).toString();
                            } else {
                                slaDay = "--";
                                slaHour = "--";
                            }

                            if (clientCompWbo.getAttribute("ticketType").toString().equals("1")) {
                                compType = "شكوى";
                                compStyle = "comp";
                            } else if (clientCompWbo.getAttribute("ticketType").toString().equals("2")) {
                                compType = "طلب";
                                compStyle = "order";
                            } else if (clientCompWbo.getAttribute("ticketType").toString().equals("3")) {
                                compType = "استعلام";
                                compStyle = "query";
                            }
                    %>
                    <TR style="padding: 1px;">
                        <TD>
                            <%=iTotal%>
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
                        <TD  style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                            <%if (wbo.getAttribute("issue_id") != null) {%>
                            <a href="<%=context%>/IssueServlet?op=getCompl3&issueId=<%=wbo.getAttribute("issue_id")%>&compId=<%=wbo.getAttribute("clientComId")%>&statusCode=<%=wbo.getAttribute("statusCode")%>&receipId=<%=wbo.getAttribute("receipId")%>&senderID=<%=wbo.getAttribute("senderId")%>"
                               onmouseover="JavaScript: getRequestsCount('<%=wbo.getAttribute("issue_id")%>', this);"> <font color="red"><%=wbo.getAttribute("businessID").toString()%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate").toString()%></font></a>
                                <%}%>
                        </TD>
                        <TD>
                            <%if (wbo.getAttribute("compSubject") != null) {%><b><%=wbo.getAttribute("compSubject"
                                )%></b><%}%>
                        </TD>


                        <TD ><b><%=wbo.getAttribute("businessCompId")%></b></TD>
                        <td>
                            <%if (wbo.getAttribute("createdByName") != null) {%><b><%=wbo.getAttribute("createdByName"
                                )%></b><%}%>
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
                            String[] arrDate = statusStartDate.split(" ");
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
                        <TD nowrap style=" background-color: #FFDDED"><font color="red"><%=sDay%> - </font><b><%=sDate + " " + sTime%></b></TD>
                        <TD style="background-color: #FFFFCC;"><b><%=slaValue%></b></TD>
                        <TD style=" background-color: "><b><%=slaDay%></b></TD>
                        <TD style=" background-color: "><b><%=slaHour%></b></TD>
                                <%  c = Calendar.getInstance();
                                    formatter = new SimpleDateFormat("dd/MM/yyyy");
                                    String[] arrEndDate = statusEndDate.split(" ");
                                    date = new Date();
                                    sDate = arrEndDate[0];
                                    sTime = arrEndDate[1];
                                    String[] arrEndTime = sTime.split(":");
                                    sTime = arrEndTime[0] + ":" + arrEndTime[1];
                                    sDate = sDate.replace("-", "/");
                                    arrEndDate = sDate.split("/");
                                    sDate = arrEndDate[2] + "/" + arrEndDate[1] + "/" + arrEndDate[0];
                                    c.setTime((Date) formatter.parse(sDate));
                                    dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
                                    currentDate = formatter.format(date);
                                    sDay = null;
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
                        <TD nowrap style=" background-color: #b9d2ef"  ><font color="red"><%=sDay%> - </font><b><%=sDate + " " + sTime%></b></TD>

                        <%
                            String bgcDay;
                            String bgcHours;

                            if (flag.equals("today")) {
                                bgcDay = "#ff1e00";
                                bgcHours = "#ff7e00";
                            } else {
                                bgcDay = "#CEF6CE";
                                bgcHours = "#81F7BE";
                            }
                        %>

                        <TD style=" background-color: <%=bgcDay%>"><b><%=duration.get(0).toString()%></b></TD>
                        <TD style=" background-color: <%=bgcHours%>"><b><%=duration.get(1).toString()%></b></TD>

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
        </form>
    </body>
</html>