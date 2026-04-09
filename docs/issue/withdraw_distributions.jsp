<%@page import="java.util.List"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<!DOCTYPE html>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
//    ArrayList<WebBusinessObject> usersList = (ArrayList<WebBusinessObject>) request.getAttribute("usersList");

    ArrayList<WebBusinessObject> departments = (ArrayList<WebBusinessObject>) request.getAttribute("departments");
    ArrayList<WebBusinessObject> employeeList = (ArrayList<WebBusinessObject>) request.getAttribute("employeeList");
    String departmentID = (String) request.getAttribute("selectedDepartment");
    String beginDate = "";
    if (request.getAttribute("beginDate") != null) {
        beginDate = (String) request.getAttribute("beginDate");
    }
    String endDate = "";
    if (request.getAttribute("endDate") != null) {
        endDate = (String) request.getAttribute("endDate");
    }
    String currentOwnerID = "";
    if (request.getAttribute("currentOwnerID") != null) {
        currentOwnerID = (String) request.getAttribute("currentOwnerID");
    }

    String sourceID = "";
    if (request.getAttribute("sourceID") != null) {
        sourceID = (String) request.getAttribute("sourceID");
    }

    String issueStatus = "";
    if (request.getAttribute("issueStatus") != null) {
        issueStatus = (String) request.getAttribute("issueStatus");
    }
    String status = (String) request.getAttribute("status");
    String statusWithdraw = (String) request.getAttribute("statusWithdraw");

    ArrayList<WebBusinessObject> requestTypes = (ArrayList<WebBusinessObject>) request.getAttribute("requestTypes") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("requestTypes") : null;
    List<WebBusinessObject> employees = (List<WebBusinessObject>) request.getAttribute("employees") != null ? (List<WebBusinessObject>) request.getAttribute("employees") : null;
    String noAppCmnt = (String) request.getAttribute("noAppCmnt") != null ? (String) request.getAttribute("noAppCmnt") : "off";
    String stat = (String) request.getSession().getAttribute("currentMode");
    String all;
    if (stat.equals("En")) {
        all = "All";
    } else {
        all = "الكل";
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <!-- <link rel="stylesheet" href="css/CSS.css"/>
         <script src='ChangeLang.js' type='text/javascript'></script>
          <script type="text/javascript" src="/jquery-ui/jquery-1.7.1.js"></script>
         <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
         <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
         <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
         <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
         <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script> 
          <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        -->

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet">

        <style type="text/css">
            .titlebar {
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
        </style>
        <script type="text/javascript">
            $(document).ready(function () {

                $("#currentOwnerID").select2();

                $("#sourceID").select2();
                $("#departmentID").select2();
                //issueStatus
                $("#issueStatus").select2();
                $('#issueList').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[0, "asc"]]
                });

                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });

                var noAppCmntValue = "<%=noAppCmnt%>";
                if (noAppCmntValue == "on") {
                    $('#noAppCmnt').prop('checked', true);
                } else {
                    $('#noAppCmnt').prop('checked', false)
                }
            });
            function selectAll(obj) {
                $("input[name='selectedIssue']").prop('checked', $(obj).is(':checked'));
            }

            function checkNum() {
                var checkLn = $("input[name='selectedIssue']:checked").length;

                if (checkLn < 1) {
                    alert("Choose Client");
                } else if (checkLn > 25) {
                    alert("Max 25 Clients");
                } else {
                    $('#redirectClient').show();
                    $('#redirectClient').bPopup({
                        easing: 'easeInOutSine', //uses jQuery easing plugin
                        speed: 400,
                        transition: 'slideDown'
                    });
                }
            }

            function closePopup(obj) {
                $(obj).parent().parent().bPopup().close();
                $(obj).parent().parent().hide();
            }

            function deleteRedirectTask() {
                if ($("#requestType").val() === '') {
                    alert("You must select a request type to create new request");
                    return;
                }
                if ($("#employeeID").val() === '') {
                    alert("You must select an employee to distrubite new request to it");
                    return;
                }

                document.withDrawForm.action = "<%=context%>/DatabaseControllerServlet?op=dragClient&requestType=" + $("#requestType").val() + "&employeeID=" + $("#employeeID").val();
                document.withDrawForm.submit();
            }

            function noAppCmntVal() {
                var noAppCmnt = $("#noAppCmnt").val();

                if (noAppCmnt == "off") {
                    $("#noAppCmnt").val("on");
                } else if (noAppCmnt == "on") {
                    $("#noAppCmnt").val("off");
                }
            }
            function checkSelection() {
                var len = $("input[name='selectedIssue']:checked").length;
                if (len < 1) {
                    alert(" إختر عميل ");
                    return false;
                } else if (len > 25) {
                    alert(" إختر 25 عملاء كحد اقصى ");
                    return false;
                }
                $("#withDrawForm").attr('action', "<%=context%>/DatabaseControllerServlet?op=withdrawDistributions&searchType=delete");
                $("#withDrawForm").submit();
            }

            function getEmployees(obj) {
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
                            var createdBy = $("#currentOwnerID");
                            $(createdBy).html("");
                            output.push('<option value=""><%=all%></option>');
                            var info = $.parseJSON(jsonString);
                            for (i = 0; i < info.length; i++) {
                                var item = info[i];
                                output.push('<option value="' + item.userId + '">' + item.fullName + '</option>');
                            }
                            createdBy.html(output.join(''));
                        } catch (err) {
                        }
                    }
                });
            }

            function exportToExcel() {
                document.withDrawForm.action = "<%=context%>/DatabaseControllerServlet?op=withDrawFormExcel";
                document.withDrawForm.submit();
            }
        </script>
    </head>
    <body>
        <form name="withDrawForm" id="withDrawForm" method="POST">
            <fieldset class="set" style="border-color: #006699; width: 90%;margin-top: 10px;border-radius: 5px;">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4">Clients withdrawal and distribution</font>
                        </td>
                    </tr>
                </table>
                <br/>
                <%
                    if (status != null) {
                %>
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <%
                                if (status.equals("ok")) {
                            %>
                            <font color="green" size="3">Delete Success</font>
                            <%
                            } else if (status.equals("fail")) {
                            %>
                            <font color="red" size="3">Not Deleted</font>
                            <%
                                }
                            %>
                        </td>
                    </tr>
                </table>
                <%
                    }
                %>

                <%
                    if (statusWithdraw != null) {
                %>
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <%
                                if (statusWithdraw.equals("ok")) {
                            %>
                            <font color="green" size="3"> Withdraw Success</font>
                            <%
                            } else if (statusWithdraw.equals("fail")) {
                            %>
                            <font color="red" size="3"> Not Withdraw</font>
                            <%
                                }
                            %>
                        </td>
                    </tr>
                </table>
                <%
                    }
                %>

                <table ALIGN="center" DIR="LTR" WIDTH="85%" CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="40%" colspan="2">
                            <b><font size=3 color="white">From Date</b>
                        </td>
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="40%">
                            <b> <font size=3 color="white">To Date</b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" colspan="2">
                            <input id="beginDate" name="beginDate" type="text" value="<%=beginDate%>" title="تاريخ أنشاء الطلب"/>
                            <br/><br/>
                        </td>
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <input id="endDate" name="endDate" type="text" value="<%=endDate%>" title="تاريخ أنشاء الطلب"/>
                            <br/><br/>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                            <b><font size=3 color="white">Department</b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white">Owner</b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle" colspan="2">
                            <select id="departmentID" name="departmentID" style="font-size: 14px; font-weight: bold; width: 200px;"
                                    onchange="getEmployees(this);">
                                <option value="all"><%=all%></option>
                                <% if (departments != null) {%>
                                <sw:WBOOptionList wboList="<%=departments%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=departmentID%>" />
                                <% }%>
                            </select>
                        </td>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 200px;" id="currentOwnerID" name="currentOwnerID" >
                                <option value=""><%=all%></option>
                                <sw:WBOOptionList wboList='<%=employeeList%>' displayAttribute="fullName" valueAttribute="userId" scrollToValue="<%=currentOwnerID%>"/>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td STYLE="text-align:center" bgcolor="#dedede" colspan="4" WIDTH="20%">  
                            <button type="submit" name="searchType" value="search" style="color: #000;font-size:15px;margin-top: 20px;font-weight:bold; width: 10%;">Search<IMG HEIGHT="15" SRC="images/search.gif" ></button>
                            <button style="width: 100px; margin-top: 20px;" type="button" onclick="javascript: exportToExcel();"><b style="font-weight: bold; font-size: 14px; vertical-align: middle">Excel</b>&ensp;<img src="images/icons/excel.png" width="20" height="20" style="vertical-align: middle"/></button>
                        </td>

                    </tr>
                </table>
                <br/>
                <%
                    if (data != null) {
                %>
                <button type="button" class="button" onclick="JavaScript: checkSelection();" name="searchType" value="delete" style="color: #000;font-size:15px;margin-top: 20px;font-weight:bold; width: 100px;">Withdrawal</button>
                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <button type="button" class="button" name="searchType" value="withdraw" style="color: #000;font-size:15px;margin-top: 20px;font-weight:bold; width: 220px;" onclick="checkNum();">withdrawal and distribution</button>
                <br/>
                <br/>
                <table id="issueList" dir="ltr" align="center" width="100%" cellpadding="0" cellspaceing="0">
                    <thead>
                        <tr>
                            <th>
                                <span style="">
                                    <input type="checkbox" onclick="JavaScript: selectAll(this);"/>
                                </span>
                            </th>
                            <th>
                                <span>
                                    <img src="images/icons/Numbers.png" width="20" height="20" />
                                    <b>Number</b>
                                </span>
                            </th>
                            <th>
                                <span>
                                    <img src="images/icons/client.png" width="20" height="20" />
                                    <b>Client Name</b>
                                </span>
                            </th>
                            <th>
                                <span>
                                    <b>Type</b>
                                </span>
                            </th>
                            <th>
                                <span>
                                    <b>Mobile</b>
                                </span>
                            </th>
                            <th>
                                <span>
                                    <b>National No.</b>
                                </span>
                            </th>
                            <th>
                                <span>
                                    <b>Owner</b>
                                </span>
                            </th>
                            <th>
                                <span>
                                    <b>Distribute</b>
                                </span>
                            </th>
                            <th>
                                <span>
                                    <b>Date</b>
                                </span>
                            </th>
                            <th>
                                <span>
                                    <b>Source</b>
                                </span>
                            </th>
                            <th>
                                <span>
                                    <img src="images/icons/key.png" width="20" height="20" />
                                    <b>Code</b>
                                </span>
                            </th>
                            <th>
                                <span>
                                    <b>Status</b>
                                </span>
                            </th>
                        </tr>
                        
                    </thead>
                    <tbody  >  
                        <%
                            for (WebBusinessObject wbo : data) {
                                String compStyle = "";
                        %>
                        <tr id="xx">
                            <%
                                if (wbo.getAttribute("ticketType").equals(CRMConstants.CLIENT_COMPLAINT_TYPE_COMPLAINT)) {
                                    compStyle = "comp";
                                } else if (wbo.getAttribute("ticketType").equals(CRMConstants.CLIENT_COMPLAINT_TYPE_ORDER)) {
                                    compStyle = "order";
                                } else if (wbo.getAttribute("ticketType").equals(CRMConstants.CLIENT_COMPLAINT_TYPE_QUERY)) {
                                    compStyle = "query";
                                } else if (wbo.getAttribute("ticketType").equals(CRMConstants.CLIENT_COMPLAINT_TYPE_EXTRACT)) {
                                    compStyle = "order";
                                } else if (wbo.getAttribute("ticketType").equals(CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_EXTRADITION)) {
                                    compStyle = "order";
                                } else if (wbo.getAttribute("ticketType").equals(CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_FINANCIAL)) {
                                    compStyle = "order";
                                } else if (wbo.getAttribute("ticketType").equals(CRMConstants.CLIENT_COMPLAINT_TYPE_CLIENT_VISIT)) {
                                    compStyle = "order";
                                } else if (wbo.getAttribute("ticketType").equals(CRMConstants.CLIENT_COMPLAINT_TYPE_DELIVERY_OF_QUALITY)) {
                                    compStyle = "order";
                                }
                            %>
                            <td style="background-color: transparent;">
                                <span style="display: inline-block;height: 20px;background: transparent;">
                                    <input type="checkbox" id="compId" class="case" value="<%=wbo.getAttribute("issue_id")%>" name="selectedIssue"/>
                                    <input type="hidden" name="clientComplaintID<%=wbo.getAttribute("issue_id")%>" value="<%=wbo.getAttribute("compId")%>"/>
                                    <input type="hidden" name="clientID<%=wbo.getAttribute("issue_id")%>" value="<%=wbo.getAttribute("customerId")%>"/>
                                </span>
                            </td>
                            <td style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                                <a href="#" >
                                    <font color="red"><%=wbo.getAttribute("businessID").toString()%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate").toString()%></font>
                                </a>
                            </td>
                            <td>
                                <b><%=wbo.getAttribute("customerName").toString()%></b>
                                <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("customerId")%>">
                                    <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"
                                         onmouseover="JavaScript: changeCommentCounts('<%=wbo.getAttribute("customerId")%>', this);"/>
                                </a>
                            </td>
                            <td>
                                <b><%=wbo.getAttribute("typeTag") != null ? wbo.getAttribute("typeTag") : ""%></b>
                            </td>
                            <td style="text-align:center;padding: 5px; font-size: 12px;">
                                <b><%=wbo.getAttribute("clientMobile") != null ? wbo.getAttribute("clientMobile") : ""%></b>
                            </td>
                            <td style="text-align:center;padding: 5px; font-size: 12px;">
                                <b><%=wbo.getAttribute("interPhone") != null && !"UL".equals(wbo.getAttribute("interPhone")) ? wbo.getAttribute("interPhone") : ""%></b>
                            </td>
                            <td nowrap>
                                <b><%=wbo.getAttribute("currentOwner")%></b>
                            </td>
                            <td nowrap>
                                <b><%=wbo.getAttribute("senderName")%></b>
                            </td>
                            <td nowrap>
                                <b><%=wbo.getAttribute("entryDate") != null ? ((String) wbo.getAttribute("entryDate")).substring(0, 10) : "---"%></b>
                            </td>
                            <td nowrap>
                                <b><%=wbo.getAttribute("createdByName") != null ? wbo.getAttribute("createdByName") : "---"%></b>
                            </td>
                            <td>
                                <b><%=wbo.getAttribute("businessCompId")%></b>
                            </td>
                            <td>
                                <b><%=wbo.getAttribute("current_status")%></b>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
                <br/>
                <br/>
                <%
                    }
                %>
            </fieldset>

            <div id="redirectClient" style="width: 30% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 500px;">
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
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">Type</td>
                            <td style="width: 70%;">
                                <select name="requestType" id="requestType" style="width: 200px;">
                                    <option value="">Choose</option>
                                    <sw:WBOOptionList wboList="<%=requestTypes%>" displayAttribute="projectName" valueAttribute="projectName" />
                                </select>
                            </td>
                        </tr> 
                        <tr>
                            <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">Staff</td>
                            <td style="width: 70%;">
                                <select name="employeeID" id="employeeID" style="width: 200px;">
                                    <option value="">Choose</option>
                                    <sw:WBOOptionList wboList="<%=employees%>" displayAttribute="fullName" valueAttribute="userId" />
                                </select>
                                <input type="hidden" name="issueId" id="issueId" />
                            </td>
                        </tr> 
                    </table>
                    <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" > <input type="button" value="Save" onclick="JavaScript: deleteRedirectTask();" id="redirectClient" class="login-submit"/></div>
                </div>
            </div> 
        </form>                      
    </body>
</html>
