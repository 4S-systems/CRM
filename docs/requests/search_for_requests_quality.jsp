<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.maintenance.db_access.IssueDocumentMgr"%>
<%@page import="com.maintenance.db_access.ProjectsByGroupMgr"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@page import="com.maintenance.db_access.IssueByComplaintAllCaseMgr"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page pageEncoding="UTF-8"%>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    List<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
    String beDate = (String) request.getAttribute("beginDate");
    String eDate = (String) request.getAttribute("endDate");
    SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
    Calendar calendar = Calendar.getInstance();
    String jDateFormat = "yyyy/MM/dd";
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String today = sdf.format(calendar.getTime());
    if (beDate == null || eDate == null) {
        eDate = sdf.format(calendar.getTime());
        calendar = Calendar.getInstance();
        calendar.add(Calendar.MONTH, -1);
        int yaer = calendar.get(Calendar.YEAR);
        int month = (calendar.get(Calendar.MONTH)) + 1;
        int day = calendar.get(Calendar.DATE);
        beDate = yaer + "/" + month + "/" + day;
    }

    String stat = "Ar";
    String dir = null;
    String title, beginDate, endDate;
    String complaintNo, customerName;
    String complaintCode;
    String fullName = null;
    if (stat.equals("En")) {
        dir = "LTR";
        title = "Complaints Reprot";
        beginDate = "From Date";
        endDate = "To Date";
        complaintNo = "Order No.";
        customerName = "Contractor name";
        complaintCode = "Complaint code";
    } else {
        dir = "RTL";
        title = "البحث عن تسليمات جودة";
        beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
        endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        complaintNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1578;&#1575;&#1576;&#1593;&#1577;";
        customerName = "اسم المقاول";
        complaintCode = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1591;&#1604;&#1576;";
    }
%>
<HTML>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <META HTTP-EQUIV="Expires" CONTENT="0"/>   

        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>

        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            $(function() {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: new Date('<%=today%>'),
                    dateFormat: "yy/mm/dd"
                });
            });

            $(document).ready(function() {
                $("#requests").dataTable({
                    "language": {
                        "url": "js/datatable/Arabic.json"
                    },
                    "iDisplayLength": 10,
                    "aLengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                    "destroy": true
                }).fadeIn(2000);
            });

            function getComplaints() {
                var beginDate = $("#beginDate").val();
                var endDate = $("#endDate").val();
                if ((beginDate == null || beginDate == "")) {
                    alert("من فضلك أدخل تاريخ البداية");
                } else if ((endDate == null || endDate == "")) {
                    alert("من فضلك أدخل تاريخ النهاية");
                } else {
            <%if (request.getAttribute("display") == null) {%>
                    document.COMP_FORM.action = "<%=context%>/SearchServlet?op=getRequestsQuality&beginDate=" + beginDate + "&endDate=" + endDate;
                    document.COMP_FORM.submit();
            <%} else {%>
                    document.COMP_FORM.action = "<%=context%>/SearchServlet?op=getAllRequests&beginDate=" + beginDate + "&endDate=" + endDate;
                    document.COMP_FORM.submit();
            <%}%>
                }
            }

            function assignClientComplaintToProject() {
                var projectId = $("#toFolder").val();
                var clientComplaintIds = $("#moveTo:checked").map(function() {
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
                    success: function(data) {
                        var jsonString = $.parseJSON(data);
                        if (jsonString.status === 'ok') {
                            $('#saveToFileMsg').html('Save To Folder Done');
                        } else if (jsonString.status === 'failed') {
                            $('#saveToFileMsg').html('Problem at Saving To Folder , Please Contact Administrator');
                        }
                    }
                });
            }

            function getRequestExtraditionReport(issueId) {
                var url = "<%=context%>/IssueServlet?op=getRequestExtraditionReport&issueId=" + issueId;
                openWindow(url);
            }

            function openWindow(url) {
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=700, height=600");
            }

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
                    success: function(data) {
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
                                        Cancel: function() {
                                            divAttachmentTag.dialog('close');
                                        },
                                        Done: function() {
                                            divAttachmentTag.dialog('close');
                                        }
                                    }
                                })
                                .dialog('open');
                    },
                    error: function(data) {
                        alert(data);
                    }
                });
                loading("none");
            }

            var divGallaryTag;
            function openGallaryDialog(issueId, objectType) {
                loading("block");
                divGallaryTag = $("div[name='divGallaryTag']");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/FileUploadServlet?op=getGallaryDialog',
                    data: {
                        businessObjectId: issueId,
                        objectType: objectType
                    },
                    success: function(data) {
                        divGallaryTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: "غرض الرسومات الهندسية",
                                    show: "fade",
                                    hide: "explode",
                                    width: 950,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Cancel: function() {
                                            divGallaryTag.dialog('close');
                                        },
                                        Done: function() {
                                            divGallaryTag.dialog('close');
                                        }
                                    }
                                })
                                .dialog('open');
                    },
                    error: function(data) {
                        alert(data);
                    }
                });
                loading("none");
            }

            function loading(val) {
                if (val === "none") {
                    $('#loading').fadeOut(2000, function() {
                        $('#loading').css("display", val);
                    });
                } else {
                    $('#loading').fadeIn("fast", function() {
                        $('#loading').css("display", val);
                    });
                }
            }
            function viewDocuments(issueId) {
                var url = '<%=context%>/IssueDocServlet?op=ListAttachedDocs&issueId=' + issueId + '';
                var wind = window.open(url, "عرض المستندات", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
                wind.focus();
            }
            function getDocumentCount(obj, issueID) {
                $.ajax({
                    type: 'POST',
                    url: "<%=context%>/IssueDocServlet?op=getDocumentsCount",
                    data: {
                        issueID: issueID
                    },
                    success: function(data) {
                        var jsonString = $.parseJSON(data);
                        $(obj).attr("title", "Documents No. : " + jsonString.documentsNo);
                    }
                });
            }
            function viewRequest(issueId, clientComplaintId) {
                var url = '<%=context%>/IssueServlet?op=requestComments&issueId=' + issueId + '&clientComplaintId=' + clientComplaintId + '&showPopup=true';
                var wind = window.open(url, "", "toolbar=no,height=" + screen.height + ",width=" + screen.width + ", location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no,navigationbar=no");
                wind.focus();
            }
        </script>

        <style type="text/css">
            .canceled {
                background-color: rgba(255, 0, 0, 0.5);
                color: #004276;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .confirmed {
                background-color: #459E00;
                color: black;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .not-completed {
                background-color: lightgray;
                color: black;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .titlebar {
                height: 30px;
                background-image: url(images/title_bar.png);
                background-position-x: 50%;
                background-position-y: 50%;
                background-size: initial;
                background-repeat-x: repeat;
                background-repeat-y: no-repeat;
                background-attachment: initial;
                background-origin: initial;
                background-clip: initial;
                background-color: rgb(204, 204, 204);
            }
            #row:hover{
                cursor: pointer;
                background-color: #D3E3EB !important;
            }
            /* loading progress bar*/
            .container {width: 100px; margin: 0 auto; overflow: hidden;}
            .contentBar {width:100px; margin:0 auto; padding-top:0px; padding-bottom:0px;}
            .barlittle {
                background-color:#2187e7;  
                background-image: -moz-linear-gradient(45deg, #2187e7 25%, #a0eaff); 
                background-image: -webkit-linear-gradient(45deg, #2187e7 25%, #a0eaff);
                border-left:1px solid #111; border-top:1px solid #111; border-right:1px solid #333; border-bottom:1px solid #333; 
                width:10px;
                height:10px;
                float:left;
                margin-left:5px;
                opacity:0.1;
                -moz-transform:scale(0.7);
                -webkit-transform:scale(0.7);
                -moz-animation:move 1s infinite linear;
                -webkit-animation:move 1s infinite linear;
            }
            #block_1{
                -moz-animation-delay: .4s;
                -webkit-animation-delay: .4s;
            }
            #block_2{
                -moz-animation-delay: .3s;
                -webkit-animation-delay: .3s;
            }
            #block_3{
                -moz-animation-delay: .2s;
                -webkit-animation-delay: .2s;
            }
            #block_4{
                -moz-animation-delay: .3s;
                -webkit-animation-delay: .3s;
            }
            #block_5{
                -moz-animation-delay: .4s;
                -webkit-animation-delay: .4s;
            }
            @-moz-keyframes move{
                0%{-moz-transform: scale(1.2);opacity:1;}
                100%{-moz-transform: scale(0.7);opacity:0.1;}
            }
            @-webkit-keyframes move{
                0%{-webkit-transform: scale(1.2);opacity:1;}
                100%{-webkit-transform: scale(0.7);opacity:0.1;}
            }
        </style>
    </head>
    <body>
        <div name="divGallaryTag"></div>
        <div name="divAttachmentTag"></div>
        <form name="COMP_FORM" method="post">
            <table align="center" width="98%">
                <tr>
                    <td class="td">
                        <FIELDSET class="set" style="width:98%;border-color: #006699">
                            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                                <tr>
                                    <td class="titlebar" style="text-align: center">
                                        <img width="40" height="40" src="images/icons/request.png" style="vertical-align: middle;"/> &nbsp;<font color="#005599" size="4"><%=title%></font>
                                    </td>
                                </tr>
                            </table>
                            <br/>
                            <table align="center" dir="rtl" width="97%" cellspacing="2" cellpadding="1">
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="40%">
                                        <b><font size=3 color="white"> <%=beginDate%></b>
                                    </td>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="40%">
                                        <b> <font size=3 color="white"> <%=endDate%> </b>
                                    </td>
                                    <td style="text-align:center; margin-bottom: 5px; margin-top: 5px" bgcolor="#dedede" rowspan="2">
                                        <button type="button" onclick="JavaScript: getComplaints();" style="color: #27272A;font-size:15px;margin-top: 8px;margin-bottom: 8px;font-weight:bold; width: 150px">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                                        <input id="beginDate" readonly name="beginDate" type="text" value="<%=beDate%>" /><img src="images/showcalendar.gif" >                 
                                        <br><br>
                                    </td>
                                    <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                                        <input id="endDate" readonly name="endDate" type="text" value="<%=eDate%>" ><img src="images/showcalendar.gif" > 
                                        <br><br>
                                    </td>
                                </tr>
                            </table>
                            <br/>
                            <div id="loading" class="container" style="display: none">
                                <div class="contentBar">
                                    <div id="block_1" class="barlittle"></div>
                                    <div id="block_2" class="barlittle"></div>
                                    <div id="block_3" class="barlittle"></div>
                                    <div id="block_4" class="barlittle"></div>
                                    <div id="block_5" class="barlittle"></div>
                                </div>
                            </div>
                            <br>
                            <% if (data != null && !data.isEmpty()) {%>
                            <center>
                                <div style="width: 97%">
                                    <table class="display" id="requests" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0">
                                        <thead>
                                            <tr>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="10%" colspan="5"><img src="images/icons/operation.png" width="24" height="24"/></TH>  
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="9%" rowspan="2"><img src="images/icons/Numbers.png" width="20" height="20" /><b> <%=complaintNo%></b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="21%" rowspan="2"><img src="images/icons/client.png" width="20" height="20" /><b> <%=customerName%></b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="10%" rowspan="2"><img src="images/icons/key.png" width="20" height="20" /><b> <%=complaintCode%></b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="10%" rowspan="2"><b>تاريخ التسجيل</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="8%" rowspan="2"><b>المرحلة</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="10%" rowspan="2"><b>الحالة</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="15%" rowspan="2"><b>المسئول</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="7%" rowspan="2"><b>عدد المراجعات</b></TH>
                                            </tr>
                                            <tr>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">&ensp;</TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">&ensp;</TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">&ensp;</TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">&ensp;</TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">&ensp;</TH>
                                            </tr>
                                        </thead> 
                                        <tbody>
                                            <%
                                                WebBusinessObject formatted;
                                                String className = "", issueStatusName;
                                                for (WebBusinessObject wbo : data) {
                                                    formatted = DateAndTimeControl.getFormattedDateTime((String) wbo.getAttribute("entryDate"), stat);
                                                    fullName = (String) wbo.getAttribute("currentOwner");
                                                    if (fullName == null) {
                                                        fullName = "---";
                                                    }
                                                    className = "confirmed";
                                                    issueStatusName = (String) wbo.getAttribute("issueStatusName");
                                                    if ((issueStatusName == null) || CRMConstants.CLIENT_COMPLAINT_STATUS_RECEIVED.equalsIgnoreCase((String) wbo.getAttribute("issueStatusCode")) || CRMConstants.ISSUE_STATUS_REJECTED.equalsIgnoreCase((String) wbo.getAttribute("issueStatusCode"))) {
                                                        issueStatusName = "مرفوض";
                                                        className = "canceled";
                                                    } else if(!wbo.getAttribute("statusCode").equals(CRMConstants.CLIENT_COMPLAINT_STATUS_CLOSED)) {
                                                        issueStatusName = "لم يكتمل";
                                                        className = "not-completed";
                                                    }
                                            %>
                                            <tr id="row">
                                                <td width="2.5%">
                                                    <a href="JavaScript: openAttachmentDialog('<%=wbo.getAttribute("issue_id")%>', '<%=CRMConstants.OBJECT_TYPE_ISSUE%>');">
                                                        <img style="margin: 3px" src="images/icons/attachment.png" width="24" height="24"/>
                                                    </a>
                                                </td>
                                                <td width="2.5%">
                                                    <a href="JavaScript: openGallaryDialog('<%=wbo.getAttribute("issue_id")%>', '<%=CRMConstants.OBJECT_TYPE_ISSUE%>')">
                                                        <img style="margin: 3px" src="images/icons/view-request.png" width="24" height="24"/>
                                                    </a>
                                                </td>
                                                <td width="2.5%">
                                                    <a href="JavaScript: viewDocuments('<%=wbo.getAttribute("issue_id")%>')"
                                                       onmouseover="JavaScript: getDocumentCount(this, '<%=wbo.getAttribute("issue_id")%>')">
                                                        <img style="margin: 3px" src="images/Foldericon.png" width="24" height="24"/>
                                                    </a>
                                                </td>
                                                <td width="2.5%">
                                                    <a href="JavaScript: getRequestExtraditionReport('<%=wbo.getAttribute("issue_id")%>');">
                                                        <img style="margin: 3px" src="images/icons/pdf.png" width="24" height="24"/>
                                                    </a>
                                                </td>
                                                <td width="2.5%">
                                                    <a href="<%=context%>/IssueServlet?op=getCompl3&issueId=<%=wbo.getAttribute("issue_id")%>&compId=<%=wbo.getAttribute("compId")%>&statusCode=<%=wbo.getAttribute("statusCode")%>&receipId=<%=wbo.getAttribute("receipId")%>&senderID=<%=wbo.getAttribute("senderId")%>&clientType=100&currentOwnerId=<%=wbo.getAttribute("currentOwnerId")%>">
                                                        <img style="margin: 3px" src="images/icons/control.png" width="28" height="28" title="Control"/>
                                                    </a>
                                                </td>
                                                <td  style="cursor: pointer" onmouseover="this.className = '<%=className%>'" onmouseout="this.className = ''">
                                                    <font color="red"><%=wbo.getAttribute("businessID")%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate")%></font>
                                                </td>
                                                <td>
                                                    <b><%=wbo.getAttribute("customerName")%></b>
                                                    <a href="#" onclick="JavaScript: viewRequest('<%=wbo.getAttribute("issue_id")%>','<%=wbo.getAttribute("clientComId")%>');">
                                                        <img value="" onclick="" height="25px" src="images/icons/checklist-icon.png" style="margin: 0px 0; float: left;"/>
                                                    </a>
                                                </td>
                                                <td>
                                                    <b><%=wbo.getAttribute("businessCompId")%></b>
                                                </td>                                     
                                                <td nowrap><font color="red"><%=formatted.getAttribute("day")%> - </font><b><%=formatted.getAttribute("time")%></b></td>
                                                <td><b><%=wbo.getAttribute("statusArName")%></b></td>
                                                <td class="<%=className%>"><b><%=issueStatusName%></b></td>
                                                <td><b><%=fullName%></b></td>
                                                <td>
                                                    <b><%=wbo.getAttribute("comments")%></b>
                                                </td>
                                            </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            </center>
                            <br/>
                            <br/>
                            <% }%>
                        </fieldset>
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>     
