<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %> 
<%@ page contentType="text/HTML; charset=UTF-8" %>
<HTML>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        
        <title>Weekly Manager Agenda</title>
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

            var TableIDvalue = "indextable";

            //
            //////////////////////////////////////
            var TableLastSortedColumn = -1;
            function SortTable() {
                var sortColumn = parseInt(arguments[0]);
                var type = arguments.length > 1 ? arguments[1] : 'T';
                var dateformat = arguments.length > 2 ? arguments[2] : '';
                var table = document.getElementById(TableIDvalue);
                var tbody = table.getElementsByTagName("tbody")[0];
                var rows = tbody.getElementsByTagName("tr");
                var arrayOfRows = new Array();
                type = type.toUpperCase();
                dateformat = dateformat.toLowerCase();
                for (var i = 0, len = rows.length; i < len; i++) {
                    arrayOfRows[i] = new Object;
                    arrayOfRows[i].oldIndex = i;
                    var celltext = rows[i].getElementsByTagName("td")[sortColumn].innerHTML.replace(/<[^>]*>/g, "");
                    if (type == 'D') {
                        arrayOfRows[i].value = GetDateSortingKey(dateformat, celltext);
                    }
                    else {
                        var re = type == "N" ? /[^\.\-\+\d]/g : /[^a-zA-Z0-9]/g;
                        arrayOfRows[i].value = celltext.replace(re, "").substr(0, 25).toLowerCase();
                    }
                }
                if (sortColumn == TableLastSortedColumn) {
                    arrayOfRows.reverse();
                }
                else {
                    TableLastSortedColumn = sortColumn;
                    switch (type) {
                        case "N" :
                            arrayOfRows.sort(CompareRowOfNumbers);
                            break;
                        case "D" :
                            arrayOfRows.sort(CompareRowOfNumbers);
                            break;
                        default  :
                            arrayOfRows.sort(CompareRowOfText);
                    }
                }
                var newTableBody = document.createElement("tbody");
                for (var i = 0, len = arrayOfRows.length; i < len; i++) {
                    newTableBody.appendChild(rows[arrayOfRows[i].oldIndex].cloneNode(true));
                }
                table.replaceChild(newTableBody, tbody);
            } // function SortTable()

            function CompareRowOfText(a, b) {
                var aval = a.value;
                var bval = b.value;
                return(aval == bval ? 0 : (aval > bval ? 1 : -1));
            } // function CompareRowOfText()

            function CompareRowOfNumbers(a, b) {
                var aval = /\d/.test(a.value) ? parseFloat(a.value) : 0;
                var bval = /\d/.test(b.value) ? parseFloat(b.value) : 0;
                return(aval == bval ? 0 : (aval > bval ? 1 : -1));
            } // function CompareRowOfNumbers()

            function GetDateSortingKey(format, text) {
                if (format.length < 1) {
                    return "";
                }
                format = format.toLowerCase();
                text = text.toLowerCase();
                text = text.replace(/^[^a-z0-9]*/, "", text);
                text = text.replace(/[^a-z0-9]*$/, "", text);
                if (text.length < 1) {
                    return "";
                }
                text = text.replace(/[^a-z0-9]+/g, ",", text);
                var date = text.split(",");
                if (date.length < 3) {
                    return "";
                }
                var d = 0, m = 0, y = 0;
                for (var i = 0; i < 3; i++) {
                    var ts = format.substr(i, 1);
                    if (ts == "d") {
                        d = date[i];
                    }
                    else if (ts == "m") {
                        m = date[i];
                    }
                    else if (ts == "y") {
                        y = date[i];
                    }
                }
                if (d < 10) {
                    d = "0" + d;
                }
                if (/[a-z]/.test(m)) {
                    m = m.substr(0, 3);
                    switch (m) {
                        case "jan" :
                            m = 1;
                            break;
                        case "feb" :
                            m = 2;
                            break;
                        case "mar" :
                            m = 3;
                            break;
                        case "apr" :
                            m = 4;
                            break;
                        case "may" :
                            m = 5;
                            break;
                        case "jun" :
                            m = 6;
                            break;
                        case "jul" :
                            m = 7;
                            break;
                        case "aug" :
                            m = 8;
                            break;
                        case "sep" :
                            m = 9;
                            break;
                        case "oct" :
                            m = 10;
                            break;
                        case "nov" :
                            m = 11;
                            break;
                        case "dec" :
                            m = 12;
                            break;
                        default    :
                            m = 0;
                    }
                }
                if (m < 10) {
                    m = "0" + m;
                }
                y = parseInt(y);
                if (y < 100) {
                    y = parseInt(y) + 2000;
                }
                return "" + String(y) + "" + String(m) + "" + String(d) + "";
            } // function GetDateSortingKey()
        </script>
    </head>
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
        UserMgr userMgr = UserMgr.getInstance();
        ArrayList<WebBusinessObject> usersList = userMgr.getUserList();
        String userId = request.getParameter("userId") != null ? request.getParameter("userId") : "";
        WebBusinessObject loggedUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
//        int withinMyOrder = 24;
        Map<String, String> withinIntervals = securityUser.getWithinIntervals();
//        if (request.getParameter("withinMyOrder") != null) {
//            withinMyOrder = new Integer(request.getParameter("withinMyOrder"));
//            withinIntervals.put("withinMyOrder", "" + withinMyOrder);
//        } else if (withinIntervals.containsKey("withinMyOrder")) {
//            withinMyOrder = (new Integer(withinIntervals.get("withinMyOrder")));
//        }
        
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
        String projectCode = projectMgr.getByKeyColumnValue("key5", loggedUser.getAttribute("userId").toString(), "key3");
        if (projectCode != null && !projectCode.isEmpty()) {
            issuesVector = issueByComplaintMgr.getAllCaseWithinTimeAndCompliantCode(fromDate, toDate, projectCode, searchType, userId);
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
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function changePage(url) {
            window.navigate(url);
        }

        function changeMode(name) {
            if (document.getElementById(name).style.display == 'none') {
                document.getElementById(name).style.display = 'block';
            } else {
                document.getElementById(name).style.display = 'none';
            }
        }

        function showLaterOrders() {
            var beginDate = document.getElementById("beginDate").value;
            var endDate = document.getElementById("endDate").value;
            var projectName = document.getElementById("projectName").value;
            var statusName = 'Schedule';

            window.navigate('<%=context%>/SearchServlet?op=StatusProjectList&beginDate=' + beginDate + '&endDate=' + endDate + '&projectName=' + projectName + '&statusName=' + statusName);
        }

        function showLaterClosedOrders() {
            var beginDate = document.getElementById("beginDate").value;
            var endDate = document.getElementById("endDate").value;
            var projectName = document.getElementById("projectName").value;
            var statusName = 'Finished';

            window.navigate('<%=context%>/SearchServlet?op=getJobOrdersByLateClosed&beginDate=' + beginDate + '&endDate=' + endDate + '&projectName=' + projectName + '&statusName=' + statusName);
        }

        function getComplaint(issueId, compId) {
            window.navigate('<%=context%>/IssueServlet?op=getCompl3&issueId=' + issueId + '&compId=' + compId);
        }
        function closeComp(issueId, compId) {
            window.navigate('<%=context%>/IssueServlet?op=closeComp&issueId=' + issueId + '&compId=' + compId);
        }
        function removeComp(issueId, compId) {
            window.navigate('<%=context%>/IssueServlet?op=removeComp&issueId=' + issueId + '&compId=' + compId);
        }
        function submitform()
        {
            document.within_form.submit();
        }
        var dp_cal1,dp_cal2;      
        window.onload = function () {
           dp_cal1 = new Epoch('epoch_popup','popup',document.getElementById('fromDate'));
           dp_cal2 = new Epoch('epoch_popup','popup',document.getElementById('toDate'));
           $("#fromDate").attr('readonly', true);
           $("#toDate").attr('readonly', true);
         };
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
    <CENTER>
        <FIELDSET class="set" style="width:96%;height: auto" >
            <form name="within_form">
<!--                <b style="font-size: medium;">عرض منذ :</b>
                <SELECT name="withinMyOrder" STYLE="width:125px; font-size: medium; font-weight: bold;" onchange="JavaScript: submitform();">
                    <OPTION value="1" <!%=withinMyOrder == 1 ? "selected" : ""%>>ساعة</OPTION>
                    <OPTION value="2" <!%=withinMyOrder == 2 ? "selected" : ""%>>ساعتان</OPTION>
                    <OPTION value="3" <!%=withinMyOrder == 3 ? "selected" : ""%>>3 ساعات</OPTION>
                    <OPTION value="24" <!%=withinMyOrder == 24 ? "selected" : ""%>>يوم</OPTION>
                    <OPTION value="48" <!%=withinMyOrder == 48 ? "selected" : ""%>>يومان</OPTION>
                    <OPTION value="72" <!%=withinMyOrder == 72 ? "selected" : ""%>>3 أيام</OPTION>
                    <OPTION value="168" <!%=withinMyOrder == 168 ? "selected" : ""%>>أسبوع</OPTION>
                    <OPTION value="1000" <!%=withinMyOrder == 1000 ? "selected" : ""%>>غير محدد</OPTION>
                </SELECT>-->
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
                            <select name="userId" id="userId" style="font-size: 14px; font-weight: bold; width: 150px;">
                                <option value="all" <%=searchType.equalsIgnoreCase("all") ? "selected" : ""%>>الكل</option>
                                <sw:WBOOptionList wboList="<%=usersList%>" displayAttribute="fullName" valueAttribute="userId" scrollToValue="<%=userId%>"/>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" colspan="2">
                            <button type="submit" STYLE="color: #000;font-size:15px; margin: 2px;font-weight:bold; ">Search<IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                        </td>
                    </tr>
                </table>
                <br/>
            </form>
            <TABLE class="blueBorder"  id="closed" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0" style="display: none;">
                <thead><TR>
                        <TH  ><SPAN ><img src="images/icons/Numbers.png" width="20" height="20" /><b> <%=complaintNo%></b></SPAN></TH>
                        <TH ><SPAN><b>نوع العميل</b></SPAN></TH>
                        <TH  ><SPAN><img src="images/icons/client.png" width="20" height="20" /><b> <%=customerName%></b></SPAN></TH>
                        <TH  ><SPAN><img src="images/icons/key.png" width="20" height="20" /><b>رقم الموبايل</b></SPAN></TH>
                        <TH  ><SPAN><b><%=type%></b></SPAN></TH>
                        <TH ><SPAN><img src="images/icons/list_.png" width="20" height="20" /><b> <%=complaint%></b></SPAN></TH>
                        <TH><SPAN><b>المصدر</b></SPAN></TH>
                        <TH  ><b>الحالة</b></TH>
                        <TH  ><b>تاريخ الحالة</b></TH>
                        <TH  ><b>المسئول</b></TH>
                        <TH  ><b><%=ageComp%></b></TH>
                    </TR></thead>
                <tbody>  
                    <%
                        for (WebBusinessObject wbo : issuesVector) {
                            String compStyle = "";
                    %>
                    <TR>
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
                        <TD    style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                            <a href="<%=context%>/IssueServlet?op=getCompl3&issueId=<%=wbo.getAttribute("issue_id")%>&compId=<%=wbo.getAttribute("clientComId")%>&statusCode=<%=wbo.getAttribute("statusCode")%>&receipId=<%=wbo.getAttribute("receipId")%>&senderID=<%=wbo.getAttribute("senderId")%>&clientType=<%=wbo.getAttribute("age")%>&currentOwnerId=<%=wbo.getAttribute("currentOwnerId")%>"> <font color="red"><%=wbo.getAttribute("businessID").toString()%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate").toString()%></font>
                            </a>
                            <input type="hidden" id="issue_id" value="<%=wbo.getAttribute("issue_id")%>" />
                            <input type="hidden" id="comp_Id" value="<%=wbo.getAttribute("clientComId")%>" />
                            <input type="hidden" id="receip_id" value="<%=wbo.getAttribute("receipId")%>" />
                            <input type="hidden" id="sender_id" value="<%=wbo.getAttribute("senderId")%>" />
                        </TD>
                        <%    String age = (String) wbo.getAttribute("age");
                            if (age.equals("100")) {
                        %>
                        <TD style="" ><b>شركة</b></TD>
                            <% } else {%>
                        <TD style="" ><b>فرد</b></TD>
                            <%  }%>
                        <TD  ><b><%=wbo.getAttribute("customerName").toString()%></b>
                            <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("customerId")%>">
                                <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"
                                     onmouseover="JavaScript: changeCommentCounts('<%=wbo.getAttribute("customerId")%>', this);"/>
                            </a>
                        </TD>
                        <TD ><% String mobile = null;
                            if (wbo.getAttribute("mobile") == null || wbo.getAttribute("mobile").equals(" ") || wbo.getAttribute("mobile").equals("")) {
                                mobile = "--------";
                            } else {
                                mobile = (String) wbo.getAttribute("mobile");
                            }%><b><%=mobile%></b>
                        </TD>
                        <TD ><b><%=compType%></b></TD>
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
                        <TD nowrap><b><%=wbo.getAttribute("senderName")%></b></TD>
                                <% if (stat.equals("En")) {
                                        complStatus = (String) wbo.getAttribute("statusEnName");
                                    } else {
                                        complStatus = (String) wbo.getAttribute("statusArName");
                                    }
                                %>
                        <TD  ><b><%=complStatus%></b></TD>
                                <%
                                    WebBusinessObject fomatted = DateAndTimeControl.getFormattedDateTime(wbo.getAttribute("entryDate").toString(), stat);
                                %>
                        <TD nowrap  ><font color="red"><%=fomatted.getAttribute("day")%> - </font><b><%=fomatted.getAttribute("time")%></b></TD>
                                <% if (wbo.getAttribute("currentOwner") != null && !wbo.getAttribute("currentOwner").equals("")) {
                                        fullName = (String) wbo.getAttribute("currentOwner");
                                    } else {
                                        fullName = "";
                                    }
                                %>

                        <TD style="width: 10%;"  ><b><%=fullName%></b></TD>
                        <td style="border-left:0px; border-right:0px; border-bottom: 1px black; ">
                            <%
                                try {
                                    out.write(DateAndTimeControl.getDelayTime(wbo.getAttribute("entryDate").toString(), "Ar"));
                                } catch (Exception E) {
                                    out.write(noResponse);
                                }
                            %>
                        </td>
                    </TR>
                    <% }%>
                </tbody>

            </TABLE>
            <input type="hidden" name="beginDate" id="beginDate" value="<%=beginDate%>">
            <input type="hidden" name="endDate" id="endDate" value="<%=endDate%>">
            <input type="hidden" name="projectName" id="projectName" value="All">
            <input type="hidden" name="statusName" id="statusName" value="Schedule">
            <BR>
        </FIELDSET>
    </CENTER>
</BODY>
</HTML>