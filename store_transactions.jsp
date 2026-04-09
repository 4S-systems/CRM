<%@page import="com.tracker.db_access.StoreTransactionMgr"%>
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
    WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
    String loggedUserId = "";
    if (loggedUser != null) {
        loggedUserId = (String) loggedUser.getAttribute("userId");
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
    StoreTransactionMgr storeTransactionMgr = StoreTransactionMgr.getInstance();
    ArrayList<WebBusinessObject> itemsList = new ArrayList<>(projectMgr.getOnArbitraryKey(CRMConstants.PROJECT_LOCATION_TYPE_SPARE_ITEM, "key4"));
    List<WebBusinessObject> data = storeTransactionMgr.getStoreTransactionsWithStatus(beginD, endD,
            "", itemID);

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
        title = "Store Transactions";
        beginDate = "From Date";
        endDate = "To Date";
        complaintNo = "Order No.";
        complaintCode = "Transaction No.";
    } else {
        dir = "RTL";
        title = "البحث عن الحركات المخزنية";
        beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
        endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        complaintNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1578;&#1575;&#1576;&#1593;&#1577;";
        complaintCode = "رقم الحركة";
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
            function getTransactionDetails(transactionID) {
                var url = '<%=context%>/SpareItemServlet?op=getUpdateTransDetails&transactionID=' + transactionID;
                document.location.href = url;
            }
            function closePopup() {
                divAttachmentTag.dialog('close');
            }
            function cancelTransaction(transactionID) {
                $.ajax({
                    type: 'POST',
                    url: "<%=context%>/SpareItemServlet?op=cancelTransactionAjax",
                    data: {
                        transactionID: transactionID
                    },
                    success: function (jsonString) {
                        var data = $.parseJSON(jsonString);
                        if (data.status === 'ok') {
                            alert('تم الألغاء');
                            location.reload();
                        } else {
                            alert('حدث خطأ لم يتم الألغاء');
                        }
                    }
                });
            }
        </script>

        <style type="text/css">
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
            .myTitleClass .ui-dialog-titlebar {
                background:#6699FF;
                text-align: center;
            }
        </style>
        <script>

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
                        <fieldset class="set" style="width:98%;border-color: #006699">
                            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                                <tr>
                                    <td class="titlebar" style="text-align: center">
                                        <img width="40" height="40" src="images/icons/warehouse.png" style="vertical-align: middle;"/> &nbsp;<font color="#005599" size="4"><%=title%></font>
                                    </td>
                                </tr>
                            </table>
                            <br/>
                            <table align="center" style="margin-left: 20%; margin-right: 20%;" dir="rtl" width="60%" cellspacing="3" cellpadding="10">
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="50%">
                                        <b><font size=3 color="white"> <%=beginDate%></b>
                                    </td>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;"width="50%">
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
                                        <button type="button" onclick="JavaScript: getComplaints();" style="color: #000;font-size:15px;margin-top: 2px;margin-bottom: 2px;font-weight:bold; width: 150px">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                                    </td>
                                </tr>
                            </table>
                            <br/>
                            <% if (data != null && !data.isEmpty()) {%>
                            <center>
                                <div style="width: 67%">
                                    <table class="display" id="requests" align="center" DIR="<%=dir%>" width="100%" cellpadding="0" cellspacing="0">
                                        <thead>
                                            <tr>
                                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="10%" colspan="4"><img src="images/icons/operation.png" width="24" height="24"/></th>  
                                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="9%" rowspan="2"><img src="images/icons/Numbers.png" width="20" height="20" /><b> <%=complaintNo%></b></th>
                                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="10%" rowspan="2"><img src="images/icons/key.png" width="20" height="20" /><b> <%=complaintCode%></b></th>
                                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="10%" rowspan="2"><b>تاريخ التسجيل</b></th>
                                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="10%" rowspan="2"><b>الحالة</b></th>
                                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2%" rowspan="2"><b>&nbsp;</b></th>
                                            </tr>
                                            <tr>
                                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">&ensp;</th>
                                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">&ensp;</th>
                                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">&ensp;</th>
                                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">&ensp;</th>
                                            </tr>
                                        </thead> 
                                        <tbody>
                                            <%
                                                WebBusinessObject formatted;
                                                for (WebBusinessObject wbo : data) {
                                                    formatted = DateAndTimeControl.getFormattedDateTime((String) wbo.getAttribute("creationTime"), stat);
                                                    fullName = (String) wbo.getAttribute("currentOwner");
                                                    if (fullName == null) {
                                                        fullName = "---";
                                                    }
                                            %>
                                            <tr id="row">
                                                <td width="2.5%">
                                                    <a href="JavaScript: openAttachmentDialog('<%=wbo.getAttribute("dependOnIssueID")%>', '<%=CRMConstants.OBJECT_TYPE_ISSUE%>');">
                                                        <img style="margin: 3px" src="images/icons/attachment.png" width="24" height="24"/>
                                                    </a>
                                                </td>
                                                <td width="2.5%">
                                                    <a href="JavaScript: openGallaryDialog('<%=wbo.getAttribute("dependOnIssueID")%>', '<%=CRMConstants.OBJECT_TYPE_ISSUE%>')">
                                                        <img style="margin: 3px" src="images/icons/view-request.png" width="24" height="24"/>
                                                    </a>
                                                </td>
                                                <td width="2.5%">
                                                    <a href="JavaScript: viewDocuments('<%=wbo.getAttribute("dependOnIssueID")%>')"
                                                       onmouseover="JavaScript: getDocumentCount(this, '<%=wbo.getAttribute("dependOnIssueID")%>')">
                                                        <img style="margin: 3px" src="images/Foldericon.png" width="24" height="24"/>
                                                    </a>
                                                </td>
                                                <td width="2.5%">
                                                    <a href="JavaScript: getTransactionDetails('<%=wbo.getAttribute("id")%>')">
                                                        <img style="margin: 3px" src="images/editeIcon2.jpg" width="28" height="28" title="تعديل"/>
                                                    </a>
                                                </td>
                                                <td>
                                                    <font color="red"><%=wbo.getAttribute("businessID")%></font><font color="blue">/<%=wbo.getAttribute("businessIDByDate")%></font>
                                                </td>
                                                <td>
                                                    <b><%=wbo.getAttribute("transactionNo")%></b>
                                                </td>                                     
                                                <td nowrap><font color="red"><%=formatted.getAttribute("day")%> - </font><b><%=formatted.getAttribute("time")%></b></td>
                                                <td nowrap>
                                                    <b><%=wbo.getAttribute("statusNameAr")%></b>
                                                </td>
                                                <td nowrap>
                                                    <img src="images/icons/stop.png" style="height: 25px; cursor: hand; display: <%=CRMConstants.STORE_TRANSACTION_PENDING.equals(wbo.getAttribute("currentStatus")) ? "" : "none"%>;"
                                                         onclick="JavaScript: cancelTransaction('<%=wbo.getAttribute("id")%>');" title="ألغاء"/>&nbsp;
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