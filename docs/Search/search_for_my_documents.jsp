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
    ArrayList<WebBusinessObject> contractorsList = (ArrayList<WebBusinessObject>) request.getAttribute("contractorsList");
    ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
    List<WebBusinessObject> projects = projectMgr.getProjectWithUserCreated(securityUser.getUserId());
    String contractorID = "";
    if (request.getAttribute("contractorID") != null) {
        contractorID = (String) request.getAttribute("contractorID");
    }
    String beDate = (String) request.getAttribute("beginDate");
    String eDate = (String) request.getAttribute("endDate");
    if (beDate == null || eDate == null) {
        Calendar calendar = Calendar.getInstance();
        String jDateFormat = "yyyy/MM/dd";
        SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
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
    String complaintCode, PN, ageComp;
    String fullName = null;
    if (stat.equals("En")) {
        dir = "LTR";
        title = "Complaints Reprot";
        beginDate = "From Date";
        endDate = "To Date";
        complaintNo = "Order No.";
        customerName = "Contractor name";
        complaintCode = "Complaint code";
        ageComp = "A.C(day)";
        PN = "Requests No.";
    } else {
        dir = "RTL";
        title = "البحث عن مستخلصات";
        PN = "عدد المستخلصات";
        beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
        endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        complaintNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1578;&#1575;&#1576;&#1593;&#1577;";
        customerName = "اسم المقاول";
        complaintCode = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1591;&#1604;&#1576;";
        ageComp = "&#1593;.&#1591; (&#1610;&#1608;&#1605;)";
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
                    dateFormat: "yy/mm/dd",
                    showOn: "button",
                    buttonImage: "images/icons/calendar-icon.png",
                    buttonImageOnly: true,
                    buttonText: "Select date"
                });
            });

            $(document).ready(function() {
                $("#indextable").dataTable({
                    "language": {
                        "url": "js/datatable/Arabic.json"
                    },
                    "destroy": true
                });
            });

            function getComplaints() {
                var beginDate = $("#beginDate").val();
                var endDate = $("#endDate").val();
                if ((beginDate === null || beginDate === "")) {
                    alert("من فضلك أدخل تاريخ البداية");
                }
                else if ((endDate === null || endDate === "")) {
                    alert("من فضلك أدخل تاريخ النهاية");
                } else {
                    beginDate = $("#beginDate").val();
                    endDate = $("#endDate").val();
                    var contractorID = $("#contractorID").val();
                    document.COMP_FORM.action = "<%=context%>/SearchServlet?op=searchForMyDocuments&beginDate=" + beginDate + "&endDate=" + endDate + "&engineerID=" + "&contractorID=" + contractorID;
                    document.COMP_FORM.submit();
                }
            }
            function assignClientComplaintToProject() {
                var projectId = $("#toFolder").val();
                var clientComplaintIds = $("#moveTo:checked").map(function() {
                    return $(this).val();
                }).get();
                if (clientComplaintIds === '') {
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
            function addRequestedInDocs(issueID, customerID) {
                var divTag = $('<div></div>');
                $.ajax({
                    type: "post",
                    url: "<%=context%>/SearchServlet?op=getAllValidRequests&issueID=" + issueID + "&customerID=" + customerID,
                    success: function(data) {
                        divTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: "اضافة طلب تسليم",
                                    show: "fade",
                                    hide: "explode",
                                    width: 1100,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Cancel: function() {
                                            $(this).dialog('close');
                                        },
                                        Done: function() {
                                            loading("block");
                                            var ids = "";
                                            $('input[name="selectForMapping"]:checked').each(function() {
                                                ids += this.value + ",";
                                            });
                                            $.ajax({
                                                type: "post",
                                                url: "<%=context%>/SearchServlet?op=saveDocRequests",
                                                data: {
                                                    docCode: issueID,
                                                    ids: ids
                                                },
                                                success: function(data) {
                                                    if (data === 'OK') {
                                                        $("#MsgText").html("تم الحفظ بنجاح");
                                                    } else if (data === 'NO') {
                                                        $("#MsgText").html("لم يتم الحفظ");
                                                    }
                                                }
                                            });
                                            loading("none");
                                            $(this).dialog('close');
                                        }
                                    }
                                }).dialog("open");
                    }
                });
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

            function showRequestedInDocs(issueID) {
                var divTag = $('<div></div>');
                $.ajax({
                    type: "post",
                    url: "<%=context%>/SearchServlet?op=getDocsRequests&issueID=" + issueID,
                    success: function(data) {
                        divTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: "عرض طلبات التسليم",
                                    show: "fade",
                                    hide: "explode",
                                    width: 800,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Cancel: function() {
                                            $(this).dialog('close');
                                        }
                                    }
                                }).dialog("open");
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
                background-color: #D3E3EB !important;
            }
        </style>
    </head>
    <body>
        <form name="COMP_FORM" method="post">
            <div></div>
            <table align="center" width="95%">
                <tr>
                    <td class="td">
                        <FIELDSET class="set" style="width:98%;border-color: #006699">
                            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                                <tr>
                                    <td class="titlebar" style="text-align: center">
                                        <img width="24" height="24" src="images/icons/excel.png" style="vertical-align: middle;" /> &nbsp;<font color="#005599" size="4"><%=title%></font>
                                    </td>
                                </tr>
                            </table>
                            <br />
                            <table align="center" style="margin-left: 20%; margin-right: 20%;" dir="rtl" width="60%" cellspacing="3" cellpadding="10">
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                                        <b><font size=3 color="white"> <%=beginDate%></b>
                                    </td>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                                        <b> <font size=3 color="white"> <%=endDate%> </b>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" class="excelentCell"  valign="MIDDLE" >
                                        <input id="beginDate" readonly name="beginDate" type="text" value="<%=beDate%>"/>
                                    </td>
                                    <td  class="excelentCell"  style="text-align:center" valign="middle">
                                        <input id="endDate" readonly name="endDate" type="text" value="<%=eDate%>"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%" colspan="2">
                                        <b><font size=3 color="white"> اسم المقاول </b>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" class="excelentCell"  valign="MIDDLE" colspan="2">
                                        <select style="font-size: 14px;font-weight: bold; width: 40%" id="contractorID" >
                                            <option value="all">الكل</option>
                                            <sw:WBOOptionList wboList='<%=contractorsList%>' displayAttribute="name" valueAttribute="id" scrollToValue="<%=contractorID%>"/>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="excelentCell" STYLE="text-align:center" colspan="2"> 
                                        <button type="button" onclick="JavaScript: getComplaints();" style="color: #000; font-size:15px; font-weight:bold; width: 150px">بحث&ensp;<IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                                    </td>
                                </tr>
                                <% if (data != null && !data.isEmpty()) {%>
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                                        <b> <font size=3 color="white"> حفظ فى ملف </b>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" class="excelentCell"  valign="MIDDLE">
                                        <select style="font-size: 12px; font-weight: bold; width: 80%" id="toFolder" name="toFolder">
                                            <sw:WBOOptionList wboList='<%=projects%>' displayAttribute="projectName" valueAttribute="projectID"/>
                                        </select>
                                    </td>
                                    <td class="excelentCell" STYLE="text-align:center">
                                        <button type="button" onclick="assignClientComplaintToProject()" value="Save into Folder" style="color: #000; font-size:15px; font-weight:bold; width: 150px">Save into <IMG HEIGHT="15" SRC="images/icons/folder_closed.png" /></button>
                                        <label id="saveToFileMsg"></label>
                                    </td>
                                </tr>
                                <%}%>
                            </table>
                            <br/>
                            <% if (data != null && !data.isEmpty()) {%>
                            <div style="width: 98%; margin-left: 1%; margin-right: 1%">
                                <table class="display"  id="indextable" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0">
                                    <thead>
                                        <tr>
                                            <TH STYLE="text-align:center; font-size: 16px; font-weight: bold; height: 25px" width="2.5%"><INPUT type="checkbox" id="toggleAll" name="toggleAll" /></TH>
                                            <TH STYLE="text-align:center; font-size: 16px; font-weight: bold; height: 25px" width="10%"><b><%=complaintNo%></b></TH>
                                            <TH STYLE="text-align:center; font-size: 16px; font-weight: bold; height: 25px" width="20%"><img src="images/icons/client.png" width="20" height="20" /><b> <%=customerName%></b></TH>
                                            <TH STYLE="text-align:center; font-size: 16px; font-weight: bold; height: 25px" width="10%"><b> <%=complaintCode%></b></TH>
                                            <TH STYLE="text-align:center; font-size: 16px; font-weight: bold; height: 25px" width="13.5%"><b>إضافة طلبات تسليم</b></TH>
                                            <TH STYLE="text-align:center; font-size: 16px; font-weight: bold; height: 25px" width="14%"><b>عرض طلبات تسليم</b></TH>
                                            <TH STYLE="text-align:center; font-size: 16px; font-weight: bold; height: 25px" width="10%"><b>تاريخ التسجيل</b></TH>
                                            <TH STYLE="text-align:center; font-size: 16px; font-weight: bold; height: 25px" width="12%"><b>المسئول</b></TH>
                                            <TH STYLE="text-align:center; font-size: 16px; font-weight: bold; height: 25px" width="8%"><b><%=ageComp%></b></TH>
                                        </tr>
                                    </thead> 
                                    <tbody>
                                        <%
                                            WebBusinessObject formatted;
                                            for (WebBusinessObject wbo : data) {
                                                formatted = DateAndTimeControl.getFormattedDateTime((String) wbo.getAttribute("entryDate"), stat);
                                                String complaintId = (String) wbo.getAttribute("compId");
                                                IssueDocumentMgr documentMgr = IssueDocumentMgr.getInstance();
                                                String documentID = documentMgr.getDocument(complaintId, "client_complaint");
                                                if (wbo.getAttribute("currentOwner") != null && !wbo.getAttribute("currentOwner").equals("")) {
                                                    fullName = (String) wbo.getAttribute("currentOwner");
                                                } else {
                                                    fullName = "";
                                                }
                                        %>
                                        <tr id="row">
                                            <td>
                                                <input type="checkbox" id="moveTo" name="moveTo" value="<%=wbo.getAttribute("clientComId")%>">
                                            </td>
                                            <td>
                                                <%if (wbo.getAttribute("issue_id") != null) {%>
                                                <a href="<%=context%>/IssueServlet?op=getCompl&issueId=<%=wbo.getAttribute("issue_id")%>&compId=<%=wbo.getAttribute("clientComId")%>&receipId=<%=wbo.getAttribute("receipId")%>&senderID=<%=wbo.getAttribute("senderId")%>&clientType=100&statusCode=2"> <font color="red"><%=wbo.getAttribute("businessID")%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate")%></font></a>
                                                    <% } %>
                                            </td>
                                            <td>
                                                <%if (wbo.getAttribute("customerName") != null) {%>
                                                <b><%=wbo.getAttribute("customerName")%></b>
                                                <% } %>
                                                <% if (documentID != null) {%>
                                                <a style="float: left; padding-left: 4px" href="<%=context%>/DocumentServlet?op=downloadDocument&documentId=<%=documentID%>">
                                                    <img value="" onclick="" width="20" height="20" src="images/icons/download.png" style="margin-left: 0px; vertical-align: middle"/>
                                                </a>
                                                <% }%>
                                            </td>
                                            <td><b><%=wbo.getAttribute("businessCompId")%></b></td>
                                            <td><b><a style="color: grey;cursor: pointer" onclick="addRequestedInDocs(<%=wbo.getAttribute("issue_id")%>,<%=wbo.getAttribute("customerId")%>)">اضافة طلب تسليم</a></b><img value="" onclick="" width="20" height="20" src="images/icons/add-request.png" style="float: left; margin-left: 4px; vertical-align: middle"/></td>
                                            <td><b><a style="color: grey;cursor: pointer" onclick="showRequestedInDocs(<%=wbo.getAttribute("issue_id")%>)">عرض طلبات التسليم</a>&nbsp;<font color="blue">(<%=wbo.getAttribute("count")%>)</font></b><img value="" onclick="" width="20" height="20" src="images/icons/view-request.png" style="float: left; margin-left: 4px; vertical-align: middle"/></td>
                                            <td nowrap><font color="red"><%=formatted.getAttribute("day")%> - </font><b><%=formatted.getAttribute("time")%></b></td>
                                            <td><b><%=fullName%></b></td>
                                            <td><b><%=DateAndTimeControl.getDelayTime(wbo.getAttribute("entryDate").toString(), "Ar")%></b></td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
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
