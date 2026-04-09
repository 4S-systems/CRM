<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %> 
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
     <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Sales_Market.Sales_Market"  />
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

        ProjectMgr projectMgr = ProjectMgr.getInstance();
        WebBusinessObject userObj = (WebBusinessObject) session.getAttribute("loggedUser");
        String groupId = (String) userObj.getAttribute("groupID");
        ProjectsByGroupMgr projectsByGroupMgr = ProjectsByGroupMgr.getInstance();
        ArrayList<String> projectByGroupList = projectsByGroupMgr.getProjectByGroupList(groupId);
        ArrayList<String> projectNames = projectMgr.getProjectsIdByIds(projectByGroupList);

        String context = metaMgr.getContext();

        beginWeekCalendar = (Calendar) weekCalendar.clone();
        endWeekCalendar = (Calendar) weekCalendar.clone();

        beginWeekCalendar.add(beginWeekCalendar.DATE, -dayOfWeekValue);
        endWeekCalendar.add(endWeekCalendar.DATE, 6 - dayOfWeekValue);

        java.sql.Date beginInterval = new java.sql.Date(beginWeekCalendar.getTimeInMillis());
        java.sql.Date endInterval = new java.sql.Date(endWeekCalendar.getTimeInMillis());
        IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();
        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        String[] key = new String[1];
        String[] value = new String[1];
        key[0] = "key8";
        value[0] = "7";

        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        Map<String, String> withinIntervals = securityUser.getWithinIntervals();
        Calendar cal = Calendar.getInstance();
        String timeFormat = "yyyy/MM/dd";
        SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
        String nowTime = sdf.format(cal.getTime());
        String toDateVal = nowTime;
        if(request.getParameter("toDate") != null) {
            toDateVal = request.getParameter("toDate");
            withinIntervals.put("toDate", "" + toDateVal);
        } else if (withinIntervals.containsKey("toDate")) {
            toDateVal = withinIntervals.get("toDate");
        }
        cal.add(Calendar.DAY_OF_MONTH, -1);
        nowTime = sdf.format(cal.getTime());
        String fromDateVal = nowTime;
        if(request.getParameter("fromDate") != null) {
            fromDateVal = request.getParameter("fromDate");
            withinIntervals.put("fromDate", "" + fromDateVal);
        } else if (withinIntervals.containsKey("fromDate")) {
            fromDateVal = withinIntervals.get("fromDate");
        }
        List<WebBusinessObject> issues = issueByComplaintMgr.getComplaintByOlder((String) userWbo.getAttribute("userId"), fromDateVal, toDateVal);

        String stat = (String) request.getSession().getAttribute("currentMode");
        
         
        String sat, sun, mon, tue, wed, thu, fri, noResponse, ageComp;
        String complStatus, senderName = null, fullName = null;
        if (stat.equals("En")) {
             sat = "Sat";
            sun = "Sun";
            mon = "Mon";
            tue = "Tue";
            wed = "Wed";
            thu = "Thu";
            fri = "Fri";
            noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
            ageComp = "A.C(day)";
             } else {
            sat = "السبت";
            sun = "الاحد";
            mon = "الاثنين";
            tue = "الثلاثاء";
            wed = "الاربعاء";
            thu = "الخميس";
            fri = "الجمعة";
              noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
            ageComp = "&#1593;.&#1591; (&#1610;&#1608;&#1605;)";
           }

        String sDate, sTime = null;
    %>


    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        $(function () {
            $("#fromDate,#toDate").datepicker({
                maxDate: "+d",
                changeMonth: true,
                changeYear: true,
                dateFormat: 'yy/mm/dd'
            });
        });
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
        function assignClientComplaintToProject() {
            var projectId = $("#toFolder").val();
            var clientComplaintIds = $("#moveTo:checked").map(function() {
                return $(this).val();
            }).get();
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
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
    <CENTER>
        <FIELDSET class="set" style="width:96%;" >
                 <DIV align="<fmt:message key="align"/>">
            </DIV><br />
            <form name="within_form" style="direction:<fmt:message key="direction"/>">
                <table class="blueBorder" id="code2" align="center" dir="<fmt:message key="direction"/>" width="650" cellspacing="2" cellpadding="1"
                       style="border-width:1px;border-color:white;display: block;">
                    <tr class="head">
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white"><fmt:message key="fromDate"/></font></b>
                        </td>
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white"><fmt:message key="toDate"/></font></b>
                        </td>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 250px;" bgcolor="#EEEEEE" valign="middle" rowspan="2">
                            <button type="submit" class="button" style="width: 170px;"><fmt:message key="search"/><img height="15" src="images/search.gif"/></button>
                            <br/>
                            <br/>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" valign="middle">
                            <input id="fromDate" name="fromDate" type="text" value="<%=fromDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" style="text-align:right" valign="middle">
                            <input id="toDate" name="toDate" type="text" value="<%=toDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                    </tr>
                </table>
            </form>
            <TABLE class="blueBorder"  id="closed" align="center" DIR=<fmt:message key="direction"/> WIDTH="100%" CELLPADDING="0" cellspacing="0" style="display: none;">
                <thead><TR>
                        <!--    <TH  width="7%"><SPAN ></SPAN></TH>-->
                        <TH  ><SPAN ><input type="checkbox" id="ToggleTo" name="ToggleTo"></SPAN></TH>
                        <TH  ><SPAN ><img src="images/icons/Numbers.png" width="20" height="20" /><b> <fmt:message key="requestno"/></b></SPAN></TH>
                        <TH ><SPAN><b><fmt:message key="type"/></b></SPAN></TH>
                        <TH  ><SPAN><img src="images/icons/client.png" width="20" height="20" /><b> <fmt:message key="clientname"/></b></SPAN></TH>
                        <TH  ><SPAN><img src="images/icons/key.png" width="20" height="20" /><b> <fmt:message key="mobile"/></b></SPAN></TH>
                        <TH  ><SPAN><b> <fmt:message key="reqtype"/></b></SPAN></TH>
                        <TH ><SPAN><img src="images/icons/list_.png" width="20" height="20" /><b><fmt:message key="request"/></b></SPAN></TH>
                        <TH  ><b><fmt:message key="requeststatus"/></b></TH>
                        <TH  ><b> <fmt:message key="reqdate"/></b></TH>
                        <TH  ><b> <fmt:message key="resp"/></b></TH>
                        <TH  ><b><%=ageComp%></b></TH>
                    </TR></thead>
                <tbody>  
                    <%
                        for (WebBusinessObject wbo : issues) {
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


                        <TD>
                            <input type="checkbox" id="moveTo" name="moveTo" value="<%=wbo.getAttribute("clientComId")%>">

                            <b>
                                <img src="images/urgent.jpg" width="17" height="17" 
                                     style="display: <%=("2").equalsIgnoreCase((String) wbo.getAttribute("urgency")) ? "block" : "none"%>;" />
                            </b>
                        </TD>
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
                            if (wbo.getAttribute("clientMobile") == null || wbo.getAttribute("clientMobile").equals(" ") || wbo.getAttribute("clientMobile").equals("")) {
                                mobile = "--------";
                            } else {
                                mobile = (String) wbo.getAttribute("clientMobile");
                            }%><b><%=mobile%></b>
                        </TD>
                        <TD ><b><%=compType%></b></TD>
                                <% String sCompl = " ";
                                    if (wbo.getAttribute("compSubject") != null && !wbo.getAttribute("compSubject").equals("")) {
                                        sCompl = (String) wbo.getAttribute("compSubject");
                                        if (sCompl.length() > 10) {
                                            //sCompl = sCompl.substring(0,23) + "....";
%>
                        <TD ><b><%=sCompl%></b></TD>
                                <% } else {%>
                        <TD ><b><%=sCompl%></b></TD>
                                <% }%>
                                <% } else {%>
                        <TD ><b><%=sCompl%></b></TD>
                                <%}%>


<!--       <TD style="width: 15%" ><b><%=wbo.getAttribute("departmentName")%></b></TD>
<TD ><b><%=wbo.getAttribute("userName")%></b></TD>-->


                        <% if (stat.equals("En")) {
                                complStatus = (String) wbo.getAttribute("statusEnName");
                            } else {
                                complStatus = (String) wbo.getAttribute("statusArName");
                            }
                        %>
                        <TD  ><b><%=complStatus%></b></TD>
                                <% Calendar c = Calendar.getInstance();
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
                        <TD nowrap  ><font color="red"><fmt:message key="today"/> - </font><b><%=sTime%></b></TD>
                                <%} else {%>

                        <TD nowrap  ><font color="red"><%=sDay%> - </font><b><%=sDate + " " + sTime%></b></TD>
                                <%}%>
                                <% if (wbo.getAttribute("currentOwner") != null && !wbo.getAttribute("currentOwner").equals("")) {
                                        fullName = (String) wbo.getAttribute("currentOwner");
                                    } else {
                                        fullName = "";
                                    }
                                %>

                        <TD style="width: 10%;"  ><b><%=fullName%></b>&nbsp;&nbsp;
                        </TD>
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