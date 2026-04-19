<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %> 
<%@ page contentType="text/HTML; charset=UTF-8" %>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        Calendar weekCalendar = Calendar.getInstance();
        Calendar beginWeekCalendar = Calendar.getInstance();
        Calendar endWeekCalendar = Calendar.getInstance();
        String context = metaMgr.getContext();
        metaMgr.setMetaData("xfile.jar");
        ParseSideMenu parseSideMenu = new ParseSideMenu();
        Hashtable logos = new Hashtable();
        logos = parseSideMenu.getCompanyLogo("configration" + metaMgr.getCompanyName() + ".xml");
        String weeksNo = logos.get("weeksNo").toString();

        int dayOfBack = new Integer(weeksNo).intValue() * 7;

        int dayOfWeekValue = weekCalendar.getTime().getDay();
        Calendar beginSecondWeekCalendar = Calendar.getInstance();
        Calendar endSecondWeekCalendar = Calendar.getInstance();
        beginSecondWeekCalendar = (Calendar) weekCalendar.clone();
        endSecondWeekCalendar = (Calendar) weekCalendar.clone();

        beginSecondWeekCalendar.add(beginWeekCalendar.DATE, -dayOfWeekValue - dayOfBack);
        endSecondWeekCalendar.add(endWeekCalendar.DATE, -dayOfWeekValue);

        java.sql.Date beginSecondInterval = new java.sql.Date(beginSecondWeekCalendar.getTimeInMillis());
        java.sql.Date endSecondInterval = new java.sql.Date(endSecondWeekCalendar.getTimeInMillis());
        String beginDate = null;
        String endDate = null;

        DateFormat sqlDateParser = new SimpleDateFormat("yyyy/MM/dd");
        beginDate = sqlDateParser.format(beginSecondInterval);
        endDate = sqlDateParser.format(endSecondInterval);

        session = request.getSession();

        ArrayList<WebBusinessObject> issuesVector = new ArrayList<WebBusinessObject>();

        beginWeekCalendar = (Calendar) weekCalendar.clone();
        endWeekCalendar = (Calendar) weekCalendar.clone();

        beginWeekCalendar.add(beginWeekCalendar.DATE, -dayOfWeekValue);
        endWeekCalendar.add(endWeekCalendar.DATE, 6 - dayOfWeekValue);

        IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();
        WebBusinessObject loggedUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        Map<String, String> withinIntervals = securityUser.getWithinIntervals();
        weekCalendar = Calendar.getInstance();
        sqlDateParser = new SimpleDateFormat("yyyy/MM/dd");
        String fromDate = sqlDateParser.format(weekCalendar.getTime());
        String toDate = sqlDateParser.format(weekCalendar.getTime());
        String searchType = "all";
        if (request.getParameter("fromDate") != null) {
            fromDate = request.getParameter("fromDate");
            withinIntervals.put("fromDate", "" + fromDate);
        } else if (withinIntervals.containsKey("fromDate")) {
            fromDate = withinIntervals.get("fromDate");
        }
        if (request.getParameter("toDate") != null) {
            toDate = request.getParameter("toDate");
            withinIntervals.put("toDate", "" + toDate);
        } else if (withinIntervals.containsKey("toDate")) {
            toDate = withinIntervals.get("toDate");
        }
        if (request.getParameter("searchType") != null) {
            searchType = request.getParameter("searchType");
            withinIntervals.put("searchType", "" + searchType);
        } else if (withinIntervals.containsKey("searchType")) {
            searchType = withinIntervals.get("searchType");
        }

        ProjectMgr projectMgr = ProjectMgr.getInstance();
        EmpRelationMgr empRelationMgr = EmpRelationMgr.getInstance();
        WebBusinessObject managerWbo = empRelationMgr.getOnSingleKey("key2", (String) loggedUser.getAttribute("userId"));
        WebBusinessObject departmentWbo;
        if (managerWbo != null) {
            departmentWbo = projectMgr.getOnSingleKey("key5", (String) managerWbo.getAttribute("mgrId"));
        } else {
            departmentWbo = projectMgr.getOnSingleKey("key5", (String) loggedUser.getAttribute("userId"));
        }
        if (departmentWbo != null) {
            issuesVector = issueByComplaintMgr.getAllCaseWithinTimeAndCompliantCodeSubDiv(fromDate, toDate, (String) departmentWbo.getAttribute("projectID"), searchType);
        }

        String stat = (String) request.getSession().getAttribute("currentMode");
        String dir, complaintNo, customerName, complaint, type, noResponse, ageComp;
        String complStatus, fullName = null;
        if (stat.equals("En")) {
            dir = "LTR";
            complaintNo = "Order No.";
            customerName = "Customer name";
            complaint = "Complaint";
            type = "Type";
            noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
            ageComp = "A.C(day)";
        } else {
            dir = "RTL";
            complaintNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1578;&#1575;&#1576;&#1593;&#1577;";
            customerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";
            complaint = "&#1575;&#1604;&#1591;&#1604;&#1576;";
            type = "النوع";
            noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
            ageComp = "&#1593;.&#1591; (&#1610;&#1608;&#1605;)";
        }
    %>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
    <meta HTTP-EQUIV="Expires" CONTENT="0"/>
    <head>
        <title>Weekly Manager Agenda</title>
        <link REL="stylesheet" TYPE="text/css" HREF="CSS.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript">
            $(document).ready(function() {
                $('#closed').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[20, 40, 70, 100, -1], [20, 40, 70, 100, "All"]],
                    iDisplayLength: 20,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[10, "asc"]]
                }).show();
            });
            function submitform()
            {
                document.within_form.submit();
            }
            var dp_cal1, dp_cal2;
            window.onload = function() {
                dp_cal1 = new Epoch('epoch_popup', 'popup', document.getElementById('fromDate'));
                dp_cal2 = new Epoch('epoch_popup', 'popup', document.getElementById('toDate'));
                $("#fromDate").attr('readonly', true);
                $("#toDate").attr('readonly', true);
            };
        </script>
    </head>
    <body>
        <div style="width: 100%; text-align: center;">
            <fieldset class="set" style="width:96%;height: auto" >
                <form name="within_form">
                    <table align="center" dir="rtl" width="570" cellspacing="2" cellpadding="1">
                        <tr>
                            <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="50%">
                                <b><font size=3 color="white">من تاريخ</b>
                            </td>
                            <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="50%">
                                <b> <font size=3 color="white">ألي تاريخ</b>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                                <input id="fromDate" name="fromDate" type="text" value="<%=fromDate%>"><img src="images/showcalendar.gif" readonly /> 
                            </td>
                            <td bgcolor="#dedede" style="text-align:center" valign="middle">
                                <input id="toDate" name="toDate" type="text" value="<%=toDate%>"><img src="images/showcalendar.gif" readonly /> 
                            </td>
                        </tr>
                        <tr>
                            <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                                <b><font size=3 color="white">النوع</b>
                            </td>
                            <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                                <select name="searchType" id="searchType" style="font-size: 14px; font-weight: bold; width: 150px;">
                                    <option value="all" <%=searchType.equalsIgnoreCase("all") ? "selected" : ""%>>الكل</option>
                                    <option value="sender" <%=searchType.equalsIgnoreCase("sender") ? "selected" : ""%>>المصدر</option>
                                    <option value="owner" <%=searchType.equalsIgnoreCase("owner") ? "selected" : ""%>>المسؤول</option>
                                </select>
                            </td>
                            <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                                <button type="submit" STYLE="color: #27272A;font-size:15px; margin: 2px;font-weight:bold; ">Search<IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                            </td>
                        </tr>
                    </table>
                    <br/>
                </form>
                <table class="blueBorder"  id="closed" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0" style="display: none;">
                    <thead><tr>
                            <th><span ><img src="images/icons/Numbers.png" width="20" height="20" /><b> <%=complaintNo%></b></span></th>
                            <th><span><b>نوع العميل</b></span></th>
                            <th><span><img src="images/icons/client.png" width="20" height="20" /><b> <%=customerName%></b></span></th>
                            <th><span><img src="images/icons/key.png" width="20" height="20" /><b>رقم الموبايل</b></span></th>
                            <th><span><b><%=type%></b></span></th>
                            <th><span><img src="images/icons/list_.png" width="20" height="20" /><b> <%=complaint%></b></span></th>
                            <th><span><b>المصدر</b></span></th>
                            <th><b>الحالة</b></th>
                            <th><b>تاريخ الحالة</b></th>
                            <th><b>المسئول</b></th>
                            <th><b><%=ageComp%></b></th>
                        </tr></thead>
                    <tbody>  
                        <%
                            for (WebBusinessObject wbo : issuesVector) {
                                String compStyle = "";
                        %>
                        <tr>
                            <% WebBusinessObject clientCompWbo = null;
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
                            <td    style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                                <a href="<%=context%>/IssueServlet?op=getCompl3&issueId=<%=wbo.getAttribute("issue_id")%>&compId=<%=wbo.getAttribute("clientComId")%>&statusCode=<%=wbo.getAttribute("statusCode")%>&receipId=<%=wbo.getAttribute("receipId")%>&senderID=<%=wbo.getAttribute("senderId")%>&clientType=<%=wbo.getAttribute("age")%>&currentOwnerId=<%=wbo.getAttribute("currentOwnerId")%>"> <font color="red"><%=wbo.getAttribute("businessID").toString()%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate").toString()%></font>
                                </a>
                                <input type="hidden" id="issue_id" value="<%=wbo.getAttribute("issue_id")%>" />
                                <input type="hidden" id="comp_Id" value="<%=wbo.getAttribute("clientComId")%>" />
                                <input type="hidden" id="receip_id" value="<%=wbo.getAttribute("receipId")%>" />
                                <input type="hidden" id="sender_id" value="<%=wbo.getAttribute("senderId")%>" />
                            </td>
                            <%    String age = (String) wbo.getAttribute("age");
                                if (age.equals("100")) {
                            %>
                            <td style="" ><b>شركة</b></td>
                            <% } else {%>
                            <td style="" ><b>فرد</b></td>
                            <%  }%>
                            <td  ><b><%=wbo.getAttribute("customerName").toString()%></b>
                                <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("customerId")%>">
                                    <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"
                                         onmouseover="JavaScript: changeCommentCounts('<%=wbo.getAttribute("customerId")%>', this);"/>
                                </a>
                            </td>
                            <td ><% String mobile = null;
                                if (wbo.getAttribute("mobile") == null || wbo.getAttribute("mobile").equals(" ") || wbo.getAttribute("mobile").equals("")) {
                                    mobile = "--------";
                                } else {
                                    mobile = (String) wbo.getAttribute("mobile");
                                }%><b><%=mobile%></b>
                            </td>
                            <td ><b><%=compType%></b></td>
                                    <% String sCompl = " ";
                                        if (wbo.getAttribute("compSubject") != null && !wbo.getAttribute("compSubject").equals("")) {
                                            sCompl = (String) wbo.getAttribute("compSubject");
                                            if (sCompl.length() > 10) {
                                    %>
                            <td ><b><%=sCompl%></b></td>
                                    <% } else {%>
                            <td ><b><%=sCompl%></b></td>
                                    <% }%>
                                    <% } else {%>
                            <td ><b><%=sCompl%></b></td>
                                    <%}%>
                            <td nowrap><b><%=wbo.getAttribute("senderName")%></b></td>
                                    <% if (stat.equals("En")) {
                                            complStatus = (String) wbo.getAttribute("statusEnName");
                                        } else {
                                            complStatus = (String) wbo.getAttribute("statusArName");
                                        }
                                    %>
                            <td  ><b><%=complStatus%></b></td>
                                    <%
                                        WebBusinessObject fomatted = DateAndTimeControl.getFormattedDateTime(wbo.getAttribute("entryDate").toString(), stat);
                                    %>
                            <td nowrap  ><font color="red"><%=fomatted.getAttribute("day")%> - </font><b><%=fomatted.getAttribute("time")%></b></td>
                                    <% if (wbo.getAttribute("currentOwner") != null && !wbo.getAttribute("currentOwner").equals("")) {
                                            fullName = (String) wbo.getAttribute("currentOwner");
                                        } else {
                                            fullName = "";
                                        }
                                    %>
                            <td style="width: 10%;"  ><b><%=fullName%></b></td>
                            <td style="border-left:0px; border-right:0px; border-bottom: 1px black; ">
                                <%
                                    try {
                                        out.write(DateAndTimeControl.getDelayTime(wbo.getAttribute("entryDate").toString(), "Ar"));
                                    } catch (Exception E) {
                                        out.write(noResponse);
                                    }
                                %>
                            </td>
                        </tr>
                        <% }%>
                    </tbody>
                </table>
                <input type="hidden" name="beginDate" id="beginDate" value="<%=beginDate%>"/>
                <input type="hidden" name="endDate" id="endDate" value="<%=endDate%>"/>
                <input type="hidden" name="projectName" id="projectName" value="All"/>
                <input type="hidden" name="statusName" id="statusName" value="Schedule"/>
                <BR/>
            </fieldset>
        </div>
    </body>
</html>