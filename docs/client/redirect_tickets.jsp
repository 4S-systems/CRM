<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.clients.db_access.ClientMgr"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %> 
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    String employeeId = request.getParameter("employeeId");
    String status = (String) request.getAttribute("status");
    int within = 24;
    List<WebBusinessObject> issues = (List<WebBusinessObject>) request.getAttribute("issues");
    List<WebBusinessObject> users = (ArrayList<WebBusinessObject>) request.getAttribute("users");
    if (request.getParameter("within") != null) {
        within = new Integer(request.getParameter("within"));
    }
    if (employeeId == null) {
        employeeId = "";
    }

    String stat = (String) request.getSession().getAttribute("currentMode");
    String title;
    String complaintNo, complaintDate, complaint, customerPhone;
    String complaintCode, type, compStatus, compSender, ageComp;
    if (stat.equals("En")) {
        title = "(Current Manager Agenda (Weekly";
        complaintNo = "Order No.";
        complaintDate = "Calling date";
        complaint = "Complaint";
        customerPhone = "Phone";
        complaintCode = "Complaint code";
        type = "Type";
        compStatus = "Staus";
        compSender = "Sender";
        ageComp = "A.C(day)";
    } else {
        title = "الـــــــــــــــــــــوارد";
        complaintNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1578;&#1575;&#1576;&#1593;&#1577;";
        complaintDate = "&#1608;&#1602;&#1578; &#1575;&#1604;&#1575;&#1578;&#1589;&#1575;&#1604;";
        complaint = "&#1575;&#1604;&#1591;&#1604;&#1576;";
        complaintCode = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1591;&#1604;&#1576;";
        type = "النوع";
        customerPhone = "التليفون";
        compStatus = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
        compSender = "&#1575;&#1604;&#1605;&#1585;&#1587;&#1604;";
        ageComp = "&#1593;.&#1591; (&#1610;&#1608;&#1605;)";
    }
%>

<HTML>
    <head>
        <title>Redirect Tickets</title>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache" />
        <meta HTTP-EQUIV="Expires" CONTENT="0" />

        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css" />
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>

        <script type="text/javascript">
            $(document).ready(function() {
                $("#issues").dataTable({
                    "language": {
                        "url": "js/datatable/Arabic.json"
                    },
                    "destroy": true,
                    "bSort": false
                }).fadeIn(2000);
            });

            function submitform() {
                document.INBOX_FORM.action = "<%=context%>/ComplaintEmployeeServlet?op=inbox";
                document.INBOX_FORM.submit();
            }

            function redirect() {
                var counter = 0;
                $("input:checkbox[name='complaintSelected']:checked").each(function() {
                    counter++;
                });
                if (counter === 0) {
                    alert("من فضلك أختر بعض الشكاوى");
                } else {
                    document.INBOX_FORM.action = "<%=context%>/ComplaintEmployeeServlet?op=redirectSomeInbox";
                    document.INBOX_FORM.submit();
                }
            }

            function checkAll(obj) {
                if ($(obj).is(':checked')) {
                    $("input:checkbox[name='complaintSelected']").each(function() {
                        $(this).attr('checked', true);
                    });
                } else {
                    $("input:checkbox[name='complaintSelected']").each(function() {
                        $(this).attr('checked', false);
                    });
                }
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
    <BODY>
        <FORM name="INBOX_FORM" method="POST">
            <FIELDSET  class="set" style="width:99%;">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td class="titlebar" style="text-align: center">
                            <div style="float: right; padding-right: 10px">
                                <img width="24" height="24" src="images/icons/in.png" style="vertical-align: middle;"/> &nbsp;<font color="#005599" size="4"><%=title%></font>
                            </div>
                            <div style="float: left; padding-left: 10px">
                                <SELECT name="within" STYLE="text-align: center; width:125px; font-size: medium; font-weight: bold;" onchange="JavaScript: submitform(this);">
                                    <OPTION STYLE="text-align: center" value="1" <%=within == 1 ? "selected" : ""%>>ساعة</OPTION>
                                    <OPTION STYLE="text-align: center" value="2" <%=within == 2 ? "selected" : ""%>>ساعتان</OPTION>
                                    <OPTION STYLE="text-align: center" value="3" <%=within == 3 ? "selected" : ""%>>3 ساعات</OPTION>
                                    <OPTION STYLE="text-align: center" value="24" <%=within == 24 ? "selected" : ""%>>يوم</OPTION>
                                    <OPTION STYLE="text-align: center" value="48" <%=within == 48 ? "selected" : ""%>>يومان</OPTION>
                                    <OPTION STYLE="text-align: center" value="72" <%=within == 72 ? "selected" : ""%>>3 أيام</OPTION>
                                    <OPTION STYLE="text-align: center" value="168" <%=within == 168 ? "selected" : ""%>>أسبوع</OPTION>
                                    <OPTION STYLE="text-align: center" value="100000" <%=within > 10000 ? "selected" : ""%>>غير محدد</OPTION>
                                </SELECT>
                                <b dir="rtl" style="font-size: 16px; color: #005599">عرض منذ : </b>
                            </div>
                        </td>
                    </tr>
                </table>
                <br/>
                <table align="right" dir="rtl" width="40%" bgcolor="#dedede" style="margin-right: 0.5%; margin-bottom: 10px" cellspacing="0" cellpadding="0">
                    <tr>
                        <td style="text-align:right; padding-right: 10px; height: 50px">
                            <font color="#005599" size="4">توزيع لـــ : </font>
                            &ensp;
                            <select id="createdBy" name="employeeId" style="font-size: 14px;font-weight: bold; width: 180px; height: 30px" >
                                <sw:WBOOptionList wboList='<%=users%>' displayAttribute="fullName" valueAttribute="userId" scrollToValue="<%=employeeId%>"/>
                            </select>
                            &ensp;
                            <button type="button" onclick="redirect()" style="color: #27272A; font-size:16px; font-weight:bold; width: 150px">توزيـــــــــع&ensp;<img height="22" width="22" SRC="images/icons/distribute.png" /></button>
                        </td>
                    </tr>
                </table>
                <%if (status != null) {%>
                <table align="left" width="40%" bgcolor="#dedede" style="margin-left: 0.5%; margin-bottom: 10px" cellspacing="0" cellpadding="0">
                    <tr>
                        <td style="text-align: center; padding-left: 10px; height: 50px; font-weight: bold; font-size: 16px;">
                            <%if ("ok".equalsIgnoreCase(status)) {%>
                            <font color="blue">تم التوزيع بنحاج</font>
                            <%} else { %>
                            <font color="red">لم يتم التوزيع</font>
                            <%}%>
                        </td>
                    </tr>
                </table>
                <%}%>
                <br/>
                <div style="width: 99%">
                    <TABLE id="issues" class="display" align="center" WIDTH="100%" CELLPADDING="0" cellspacing="0" dir="rtl">
                        <thead>
                            <TR>
                                <TH STYLE="text-align:center;font-size: 16px; font-weight: bold"><input type="checkbox" class="case" onchange="checkAll(this);"/></TH>
                                <TH STYLE="text-align:center;font-size: 16px; font-weight: bold"><img src="images/icons/Numbers.png" width="20" height="20" />&ensp;<b><%=complaintNo%></b></TH>
                                <TH STYLE="text-align:center;font-size: 16px; font-weight: bold"><img src="images/icons/client.png" width="20" height="20" />&ensp;<b>العميل</b></TH>
                                <TH STYLE="text-align:center;font-size: 16px; font-weight: bold"><b><%=customerPhone%></b></TH>
                                <TH STYLE="text-align:center;font-size: 16px; font-weight: bold"><b><%=type%></b></TH>
                                <TH STYLE="text-align:center;font-size: 16px; font-weight: bold"><img src="images/icons/list_.png" width="20" height="20" />&ensp;<b><%=complaint%></b></TH>
                                <TH STYLE="text-align:center;font-size: 16px; font-weight: bold"><b>المصدر</b></TH>
                                <TH STYLE="text-align:center;font-size: 16px; font-weight: bold"><img src="images/icons/key.png" width="20" height="20" /><b>&ensp;<%=complaintCode%></b></TH>
                                <TH STYLE="text-align:center;font-size: 16px; font-weight: bold"><img src="images/icons/status_.png" width="18" height="18" />&ensp;<b><%=compStatus%></b></TH>
                                <TH STYLE="text-align:center;font-size: 16px; font-weight: bold"><img src="images/icons/manager.png" width="18" height="18" />&ensp;<b><%=compSender%></b></TH>
                                <TH STYLE="text-align:center;font-size: 16px; font-weight: bold"><img src="images/icons/Time.png" width="20" height="20" />&ensp;<b><%=complaintDate%></b></TH>
                                <TH STYLE="text-align:center;font-size: 16px; font-weight: bold"><b><%=ageComp%></b></TH>
                            </TR>
                        </thead>
                        <tbody>  
                            <%
                                WebBusinessObject formatted;
                                String complaintSubject, complaintStatus, complaintComment, senderName, customerName, mobile;
                                int counter = 0;
                                for (WebBusinessObject issue : issues) {
                                    complaintStatus = (String) issue.getAttribute("statusArName");
                                    formatted = DateAndTimeControl.getFormattedDateTime((String) issue.getAttribute("entryDate"), "Ar");
                                    String compStyle = "";
                                    if (CRMConstants.CLIENT_COMPLAINT_TYPE_COMPLAINT.equalsIgnoreCase(issue.getAttribute("ticketType").toString())) {
                                        compStyle = "comp";
                                    } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_ORDER.equalsIgnoreCase(issue.getAttribute("ticketType").toString())) {
                                        compStyle = "order";
                                    } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_QUERY.equalsIgnoreCase(issue.getAttribute("ticketType").toString())) {
                                        compStyle = "query";
                                    } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_EXTRACT.equalsIgnoreCase(issue.getAttribute("ticketType").toString())) {
                                        compStyle = "order";
                                    } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_EXTRADITION.equalsIgnoreCase(issue.getAttribute("ticketType").toString())) {
                                        compStyle = "order";
                                    } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_FINANCIAL.equalsIgnoreCase(issue.getAttribute("ticketType").toString())) {
                                        compStyle = "order";
                                    } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_CLIENT_VISIT.equalsIgnoreCase(issue.getAttribute("ticketType").toString())) {
                                        compStyle = "order";
                                    }

                                    complaintComment = "";
                                    if (issue.getAttribute("comments") != null && !issue.getAttribute("comments").equals("")) {
                                        complaintComment = (String) issue.getAttribute("complaintComment");
                                    }

                                    complaintSubject = "";
                                    if (issue.getAttribute("compSubject") != null && !issue.getAttribute("compSubject").equals("")) {
                                        complaintSubject = (String) issue.getAttribute("compSubject");
                                    }

                                    senderName = "";
                                    if (issue.getAttribute("senderName") != null && !issue.getAttribute("senderName").equals("")) {
                                        senderName = (String) issue.getAttribute("senderName");
                                    }

                                    customerName = "";
                                    if (issue.getAttribute("customerName") != null) {
                                        customerName = (String) issue.getAttribute("customerName");
                                        if (customerName.length() > 20) {
                                            customerName = customerName.substring(0, 20) + "...";
                                        }
                                    }

                                    mobile = "";
                                    if (issue.getAttribute("mobile") != null) {
                                        if (mobile.length() > 20) {
                                            mobile = mobile.substring(0, 20) + "...";
                                        }
                                    }
                                    counter++;
                            %>
                            <TR id="row">
                                <TD style="background-color: transparent;">
                                    <SPAN style="display: inline-block;height: 20px;background: transparent;">
                                        <INPUT type="checkbox" name="complaintSelected" class="case" value="<%=counter - 1%>" name="selectedIssue"  onchange="showSubMenu(this)"/>
                                        <input type="hidden" id="complaintId" name="complaintId" value="<%=issue.getAttribute("clientComId")%>" />
                                    </SPAN>
                                </TD>
                                <TD style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                                    <a href="<%=context%>/IssueServlet?op=getCompl&issueId=<%=issue.getAttribute("issue_id")%>&compId=<%=issue.getAttribute("clientComId")%>&statusCode=<%=issue.getAttribute("statusCode")%>&receipId=<%=issue.getAttribute("receipId")%>&senderID=<%=issue.getAttribute("senderId")%>&clientType=<%=issue.getAttribute("age")%>" >
                                        <font color="red"><%=issue.getAttribute("businessID").toString()%></font><font color="blue">/<%=issue.getAttribute("businessIDbyDate").toString()%></font>
                                    </a>
                                    <input type="hidden" id="issue_id" value="<%=issue.getAttribute("issue_id")%>" />
                                    <input type="hidden" id="comp_Id" value="<%=issue.getAttribute("clientComId")%>" />
                                    <input type="hidden" id="receip_id" value="<%=issue.getAttribute("receipId")%>" />
                                    <input type="hidden" id="sender_id" value="<%=issue.getAttribute("senderId")%>" />
                                </TD>
                                <TD><b><%=customerName%></b>
                                    <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=issue.getAttribute("customerId")%>">
                                        <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"/>
                                    </a>
                                </TD>
                                <td style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''" onclick="getPhoneAndOtherMobile(this)">
                                    <b onclick="getPhoneAndOtherMobile(this)"><%=mobile%></b>
                                    <input type="hidden" id="complaintSubject" name="complaintSubject" value="<%=complaintSubject%>" />
                                    <input type="hidden" id="complaintComment" name="complaintComment" value="<%=complaintComment%>" />
                                    <input type="hidden" id="phone" name="phone" value="<%=issue.getAttribute("phone")%>" />
                                    <input type="hidden" id="other" name="other" value="<%=issue.getAttribute("other") != null ? issue.getAttribute("other") : ""%>" />
                                    <input type="hidden" id="mobile" name="mobile" value="<%=issue.getAttribute("mobile")%>" />
                                </td>
                                <TD><b><%=issue.getAttribute("typeName")%></b></TD>
                                <TD><b><%=complaintSubject%></b></TD>
                                <TD><b><%=issue.getAttribute("senderName")%></b></TD>
                                <TD><b><%=issue.getAttribute("businessCompId")%></b></TD>
                                <TD><b><%=complaintStatus%></b></TD>
                                <TD><b><%=senderName%></b></TD>
                                <TD><font color="red"><%=formatted.getAttribute("day")%> - </font><b><%=formatted.getAttribute("time")%></b></TD>
                                <td style="border-left:0px; border-right:0px; border-bottom: 1px black;"><%=DateAndTimeControl.getDelayTime(issue.getAttribute("entryDate").toString(), "Ar")%></td>
                            </TR>
                            <% }%>
                        </tbody>
                    </TABLE>
                    <br>
                    <br>
                </div>
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>