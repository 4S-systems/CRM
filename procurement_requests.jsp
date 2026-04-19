<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.maintenance.db_access.IssueByComplaintMgr"%>
<%@page import="java.util.Date"%>
<%@page import="com.maintenance.common.DateParser"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page pageEncoding="UTF-8"%>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    String itemID = "";
    if (request.getParameter("itemID") != null && !request.getParameter("itemID").equals("all")) {
        itemID = request.getParameter("itemID");
    }
    String beDate = request.getParameter("beginDate");
    String eDate = request.getParameter("endDate");
    Calendar calendar = Calendar.getInstance();
    String jDateFormat = "yyyy/MM/dd";
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String today = sdf.format(calendar.getTime());
    if (beDate == null || eDate == null) {
        eDate = sdf.format(calendar.getTime());
        calendar = Calendar.getInstance();
        calendar.add(Calendar.WEEK_OF_MONTH, -1);
        int yaer = calendar.get(Calendar.YEAR);
        int month = (calendar.get(Calendar.MONTH)) + 1;
        int day = calendar.get(Calendar.DATE);
        beDate = yaer + "/" + month + "/" + day;
    }
    DateParser dateParser = new DateParser();
    Date beg = dateParser.formatSqlDate(beDate);
    Date en = dateParser.formatSqlDate(eDate);
    java.sql.Date beginD = new java.sql.Date(beg.getTime());
    java.sql.Date endD = new java.sql.Date(en.getTime());
    IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();
    ArrayList<WebBusinessObject> itemsList = new ArrayList<>(projectMgr.getOnArbitraryKey(CRMConstants.PROJECT_LOCATION_TYPE_SPARE_ITEM, "key4"));
    List<WebBusinessObject> data = issueByComplaintMgr.getAllProcurementRequests(beginD, endD,
            CRMConstants.CLIENT_COMPLAINT_TYPE_PROCUREMENT, itemID);

    Map<String, String> typesMap = new HashMap<>();
    typesMap.put("1", "عام");
    typesMap.put("2", "أمر تشغيل");
    typesMap.put("3", "أمر شغل صيانة");
    typesMap.put("3", "مشروع");

    String stat = "Ar";
    String dir = null;
    String title, beginDate, endDate;
    String complaintNo;
    String complaintCode;
    String fullName = null;
    if (stat.equals("En")) {
        dir = "LTR";
        title = "Procurement Requests";
        beginDate = "From Date";
        endDate = "To Date";
        complaintNo = "Order No.";
        complaintCode = "Complaint code";
    } else {
        dir = "RTL";
        title = "البحث عن طلبات الشراء";
        beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
        endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        complaintNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1578;&#1575;&#1576;&#1593;&#1577;";
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
            $(function () {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: new Date('<%=today%>'),
                    dateFormat: "yy/mm/dd"
                });
            });
            $(document).ready(function () {
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
                if ((beginDate === null || beginDate === "")) {
                    alert("من فضلك أدخل تاريخ البداية");
                } else if ((endDate === null || endDate === "")) {
                    alert("من فضلك أدخل تاريخ النهاية");
                } else {
                    var itemID = $("#itemID").val();
                    document.COMP_FORM.action = "<%=context%>/main.jsp?op=getRequestsQForAll&beginDate=" + beginDate + "&endDate=" + endDate + "&itemID=" + itemID;
                    document.COMP_FORM.submit();
                }
            }

            function openWindow(url) {
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=700, height=600");
            }

            var divAttachmentTag;
            function openAttachmentDialog(issueId, objectType) {
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
            }

            var divGallaryTag;
            function openGallaryDialog(issueId, objectType) {
                divGallaryTag = $("div[name='divGallaryTag']");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/FileUploadServlet?op=getGallaryDialog',
                    data: {
                        businessObjectId: issueId,
                        objectType: objectType
                    },
                    success: function (data) {
                        divGallaryTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: "عرض الأسعار",
                                    show: "fade",
                                    hide: "explode",
                                    width: 950,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Cancel: function () {
                                            divGallaryTag.dialog('close');
                                        },
                                        Done: function () {
                                            divGallaryTag.dialog('close');
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
                    success: function (data) {
                        var jsonString = $.parseJSON(data);
                        $(obj).attr("title", "Documents No. : " + jsonString.documentsNo);
                    }
                });
            }
            function getRequestedItemsList(issueID) {
                var url = '<%=context%>/SpareItemServlet?op=getUpdateItemsPopup&issueID=' + issueID;
                document.location.href = url;
            }
            function closePopup() {
                divAttachmentTag.dialog('close');
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
                background-color: #C2F0C2;
                color: black;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .accepted {
                background-color: #3ED737;
                color: black;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .notCompleted {
                background-color: #F17600;
                color: black;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .rejected{
                background-color: #CE3700;
                color: black;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .new {
                background-color: #F5ED96;
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
                background-color: #D3E3BB !important;
            }
            button.btnSave
            {
                width: 22%;
                margin: 5px;
                height: 15%;
                font-size: large;
                font-family: serif;
                background: #6699FF;
            }
            select.workItemsSelect
            {
                width: 85px;
                height: inherit;
                font-size: 15px;
            }
            .myTitleClass .ui-dialog-titlebar {
                background:#6699FF;
                text-align: center;
            }
        </style>
        <script>

            function save(issueID, divID)
            {
                var childsLength = document.getElementById("requestedItems" + issueID).getElementsByTagName("tr").length - 1;
                var data = [];
                var workItemId;
                var qualityRatio;
                var acceptedStatus;
                var note;
                var temp;
                for (var i = 0; i < childsLength; i++)
                {
                    workItemId = document.getElementById("id" + i + "_" + issueID).value;
                    //alert(workItemId);
                    qualityRatio = document.getElementById("qualityRatio" + i + "_" + issueID).value;
                    //alert(quntity);
                    acceptedStatus = document.getElementById("accepted" + i + "_" + issueID).value;
                    note = document.getElementById("note" + i + "_" + issueID).value;
                    temp = workItemId + ";" + qualityRatio + ";" + acceptedStatus + ";" + note;
                    data.push(temp);
                }
                var strData = JSON.stringify(data, replaceToUpper);
                $.ajax({
                    type: "post",
                    url: '<%=context%>/IssueServlet?op=saveQuantityWorkItems',
                    data: {
                        issueWorkList: strData
                    },
                    success: function ()
                    {
                        $("#" + divID).dialog('close');
                        $('#' + divID).load('');
                        alert("عمليــة تحديــث ناجـحـه");
                    },
                    error: function ()
                    {
                        alert("عملية تحديث غير ناجـحـه");
                    }
                });
            }
            function replaceToUpper(key, value)
            {
                return value.toString();
            }
            
            function getProPDFUrl(issueID){
                var url = "<%=context%>/ProjectServlet?op=getProcPDF&issueID="+issueID;
                $('#briefPDF').attr("href", url);
            }
        </script>
    </head>
    <body>
        <div name="divGallaryTag"></div>
        <div name="divAttachmentTag"></div>
        <div name="divAttachmentTag1"></div>
        <form name="COMP_FORM" method="post">
            <table align="center" width="98%">
                <tr>
                    <td class="td">
                        <FIELDSET class="set" style="width:98%;border-color: #006699">
                            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                                <tr>
                                    <td class="titlebar" style="text-align: center">
                                        <img width="40" height="40" src="images/icons/procurement.png" style="vertical-align: middle;"/> &nbsp;<font color="#005599" size="4"><%=title%></font>
                                    </td>
                                </tr>
                            </table>
                            <br/>
                            <table align="center" style="margin-left: 20%; margin-right: 20%;" dir="rtl" width="60%" cellspacing="3" cellpadding="10">
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                                        <b><font size=3 color="white"> <%=beginDate%></b>
                                    </td>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="50%">
                                        <b> <font size=3 color="white"> <%=endDate%> </b>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                                        <input id="beginDate" readonly name="beginDate" type="text" value="<%=beDate%>" /><img src="images/showcalendar.gif" >                 
                                    </td>
                                    <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                                        <input id="endDate" readonly name="endDate" type="text" value="<%=eDate%>" ><img src="images/showcalendar.gif" > 
                                    </td>
                                </tr>
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                                        <b><font size=3 color="white"> الصنف</b>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" class="excelentCell" valign="MIDDLE" colspan="2">
                                        <select style="font-size: 14px;font-weight: bold; width: 250px;" id="itemID" >
                                            <option value="all">الكل</option>
                                            <sw:WBOOptionList wboList='<%=itemsList%>' displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=itemID%>"/>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center;" bgcolor="#dedede" colspan="2">
                                        <button type="button" onclick="JavaScript: getComplaints();" style="color: #27272A;font-size:15px;margin-top: 2px;margin-bottom: 2px;font-weight:bold; width: 150px">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                                    </td>
                                </tr>
                            </table>
                            <br/>
                            <% if (data != null && !data.isEmpty()) {%>
                            <center>
                                <div style="width: 97%">
                                    <table class="display" id="requests" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0">
                                        <thead>
                                            <tr>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="10%" colspan="6"><img src="images/icons/operation.png" width="24" height="24"/></TH>  
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="9%" rowspan="2"><img src="images/icons/Numbers.png" width="20" height="20" /><b> <%=complaintNo%></b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="21%" rowspan="2"><b>نوع الطلب</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="21%" rowspan="2"><b>الرقم</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="10%" rowspan="2"><img src="images/icons/key.png" width="20" height="20" /><b> <%=complaintCode%></b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="10%" rowspan="2"><b>تاريخ التسجيل</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="8%" rowspan="2"><b>المرحلة</b></TH>
                                            </tr>
                                            <tr>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">&ensp;</TH>
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
                                                for (WebBusinessObject wbo : data) {
                                                    formatted = DateAndTimeControl.getFormattedDateTime((String) wbo.getAttribute("entryDate"), stat);
                                                    fullName = (String) wbo.getAttribute("currentOwner");
                                                    if (fullName == null) {
                                                        fullName = "---";
                                                    }
                                            %>
                                            <tr id="row">
                                                <td width="2.5%">
                                                    <a id="briefPDF" href="JavaScript: getProPDFUrl('<%=wbo.getAttribute("issue_id")%>');">
                                                        <img style="margin: 3px" src="images/customer-service.jpg" width="24" height="24"/>
                                                    </a>
                                                </td>
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
                                                    <a href="JavaScript: getRequestedItemsList('<%=wbo.getAttribute("issue_id")%>')">
                                                        <img style="margin: 3px" src="images/editeIcon2.jpg" width="28" height="28" title="تعديل"/>
                                                    </a>
                                                </td>
                                                <td width="2.5%">
                                                    <a href="<%=context%>/IssueServlet?op=getCompl3&issueId=<%=wbo.getAttribute("issue_id")%>&compId=<%=wbo.getAttribute("compId")%>&statusCode=<%=wbo.getAttribute("statusCode")%>&receipId=<%=wbo.getAttribute("receipId")%>&senderID=<%=wbo.getAttribute("senderId")%>&clientType=100&currentOwnerId=<%=wbo.getAttribute("currentOwnerId")%>">
                                                        <img style="margin: 3px" src="images/icons/control.png" width="28" height="28" title="Control"/>
                                                    </a>
                                                </td>
                                                <td>
                                                    <font color="red"><%=wbo.getAttribute("businessID")%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate")%></font>
                                                </td>
                                                <td>
                                                    <b><%=wbo.getAttribute("requestType") != null && typesMap.containsKey((String) wbo.getAttribute("requestType")) ? typesMap.get((String) wbo.getAttribute("requestType")) : ""%></b>
                                                </td>
                                                <td>
                                                    <b><%=wbo.getAttribute("requestCode") != null ? wbo.getAttribute("requestCode") : ""%></b>
                                                </td>
                                                <td>
                                                    <b><%=wbo.getAttribute("businessCompId")%></b>
                                                </td>                                     
                                                <td nowrap><font color="red"><%=formatted.getAttribute("day")%> - </font><b><%=formatted.getAttribute("time")%></b></td>
                                                <td><b><%=wbo.getAttribute("statusArName")%></b></td>
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