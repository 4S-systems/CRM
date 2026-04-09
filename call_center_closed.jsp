<%@page import="com.clients.db_access.ClientMgr"%>
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
        String context = metaMgr.getContext();

        session = request.getSession();

        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        Map<String, String> withinIntervals = securityUser.getWithinIntervals();
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        String toDateVal = sdf.format(cal.getTime());
        if(request.getParameter("toDateClosed") != null) {
            toDateVal = request.getParameter("toDateClosed");
            withinIntervals.put("toDateClosed", "" + toDateVal);
        } else if (withinIntervals.containsKey("toDateClosed")) {
            toDateVal = withinIntervals.get("toDateClosed");
        }
        cal.add(Calendar.DAY_OF_MONTH, -1);
        String fromDateVal = sdf.format(cal.getTime());
        if(request.getParameter("fromDateClosed") != null) {
            fromDateVal = request.getParameter("fromDateClosed");
            withinIntervals.put("fromDateClosed", "" + fromDateVal);
        } else if (withinIntervals.containsKey("fromDateClosed")) {
            fromDateVal = withinIntervals.get("fromDateClosed");
        }
        IssueByComplaintUniqueMgr issueByComplaintUniqueMgr = IssueByComplaintUniqueMgr.getInstance();
        List<WebBusinessObject> issuesVector = issueByComplaintUniqueMgr.getComplaintByCreatedBy((String) userWbo.getAttribute("userId"),
                new java.sql.Date(sdf.parse(fromDateVal).getTime()), new java.sql.Date(sdf.parse(toDateVal).getTime()));
        
        String stat = (String) request.getSession().getAttribute("currentMode");
        String dir;
        String complaintNo, customerName, complaint, today;;
        String sat, sun, mon, tue, wed, thu, fri, type, noResponse, ageComp;
        String complStatus, fullName = null;
        if (stat.equals("En")) {
            dir = "LTR";
            complaintNo = "Order No.";
            customerName = "Customer name";
            complaint = "Complaint";
            sat = "Sat";
            sun = "Sun";
            mon = "Mon";
            tue = "Tue";
            wed = "Wed";
            thu = "Thu";
            fri = "Fri";
            type = "Type";
            noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
            ageComp = "A.C(day)";
            today = "Today";
        } else {
            dir = "RTL";
            complaintNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1578;&#1575;&#1576;&#1593;&#1577;";
            customerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";
            complaint = "&#1575;&#1604;&#1591;&#1604;&#1576;";
            sat = "&#1575;&#1604;&#1587;&#1576;&#1578;";
            sun = "&#1575;&#1604;&#1575;&#1581;&#1583;";
            mon = "&#1575;&#1604;&#1575;&#1579;&#1606;&#1610;&#1606;";
            tue = "&#1575;&#1604;&#1579;&#1604;&#1575;&#1579;&#1575;&#1569;";
            wed = "&#1575;&#1604;&#1575;&#1585;&#1576;&#1593;&#1575;&#1569;";
            thu = "&#1575;&#1604;&#1582;&#1605;&#1610;&#1587;";
            fri = "&#1575;&#1604;&#1580;&#1605;&#1593;&#1577;";
            type = "النوع";
            noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
            ageComp = "&#1593;.&#1591; (&#1610;&#1608;&#1605;)";
            today = "اليوم";
        }

        String sDate, sTime = null;
    %>


    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

//        function getPhoneAndOtherMobile(obj) {
//            var mobile = $(obj).parent().find("#mobile").val();
//            var phone = $(obj).parent().find("#phone").val();
//            var other = $(obj).parent().find("#other").val();
//            $("#clientPhoneDiv").find("#mobile").val(mobile);
//            $("#clientPhoneDiv").find("#phone").val(phone);
//            $("#clientPhoneDiv").find("#other").val(other);
//
//            alert(mobile + " - " + phone + " - " + other);
////            $('#clientPhoneDiv').bPopup();
//            $('#clientPhoneDiv').css("display", "block");
//        }

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
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
    <CENTER>

        <FIELDSET class="set" style="width:96%;" >
            <form name="within_form">
                <table class="blueBorder" id="code2" align="center" dir="<%=dir%>" width="650" cellspacing="2" cellpadding="1"
                   style="border-width:1px;border-color:white;display: block;">
                    <tr class="head">
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white" title="تاريخ التوزيع">من تاريخ</font></b>
                        </td>
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white" title="تاريخ التوزيع">إلي تاريخ</font></b>
                        </td>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 250px;" bgcolor="#EEEEEE" valign="middle" rowspan="2">
                            <button type="submit" class="button" style="width: 170px;">بحث<img height="15" src="images/search.gif"/></button>
                            <br/>
                            <br/>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" valign="middle">
                            <input class="fromToDate" id="fromDateClosed" name="fromDateClosed" type="text" title="تاريخ التوزيع" value="<%=fromDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" style="text-align:right" valign="middle">
                            <input class="fromToDate" id="toDateClosed" name="toDateClosed" type="text" title="تاريخ التوزيع" value="<%=toDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                    </tr>
                </table>
            </form>
            <TABLE class="blueBorder"  id="closed" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0" style="display: none;">
                <thead><TR>
                        <TH>&nbsp;</TH>
                        <TH><img src="images/icons/Numbers.png" width="20" height="20" /><b> <%=complaintNo%></b></TH>
                        <TH><b>نوع العميل</b></TH>
                        <TH><img src="images/icons/client.png" width="20" height="20" /><b> <%=customerName%></b></TH>
                        <TH><img src="images/icons/key.png" width="20" height="20" /><b>رقم الموبايل</b></TH>
                        <TH><b><%=type%></b></TH>
                        <TH><img src="images/icons/list_.png" width="20" height="20" /><b> <%=complaint%></b></TH>
                        <TH><b>الحالة</b></TH>
                        <TH><b>تاريخ الحالة</b></TH>
                        <TH><b>المسئول</b></TH>
                        <TH><b><%=ageComp%></b></TH>
                    </TR></thead>
                <tbody>  
                    <%
                        for (WebBusinessObject wbo : issuesVector) {
                            String compStyle = "";
                            ClientMgr clientMgr = ClientMgr.getInstance();
                            WebBusinessObject object = clientMgr.getOnSingleKey((String) wbo.getAttribute("customerId"));
                            wbo.setAttribute("phone", object.getAttribute("phone"));
                            if (object.getAttribute("option3") != null) {
                                wbo.setAttribute("other", object.getAttribute("option3"));
                            }
                    %>
                    <TR>
                        <% WebBusinessObject clientCompWbo = null;
                            ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                            clientCompWbo = clientComplaintsMgr.getOnSingleKey(wbo.getAttribute("clientComId").toString());
                            if (clientCompWbo.getAttribute("ticketType").toString().equals("1")) {
                                compStyle = "comp";
                            } else if (clientCompWbo.getAttribute("ticketType").toString().equals("2")) {
                                compStyle = "order";
                            } else if (clientCompWbo.getAttribute("ticketType").toString().equals("3")) {
                                compStyle = "query";
                            } else if (clientCompWbo.getAttribute("ticketType").toString().equals("5")) {
                                compStyle = "order";
                            } else if (clientCompWbo.getAttribute("ticketType").toString().equals("6")) {
                                compStyle = "order";
                            } else if (clientCompWbo.getAttribute("ticketType").toString().equals("7")) {
                                compStyle = "order";
                            } else if (clientCompWbo.getAttribute("ticketType").toString().equals("10")) {
                                compStyle = "order";
                            }
                        %>


                        <TD ><b><img src="images/urgent.jpg" width="17" height="17" 
                                     style="display: <%=("2").equalsIgnoreCase((String) wbo.getAttribute("urgency")) ? "block" : "none"%>;" /></b></TD>
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
                            <a target="_blanck" href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("customerId")%>">
                                <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"
                                     onmouseover="JavaScript: changeCommentCounts('<%=wbo.getAttribute("customerId")%>', this);"/>
                            </a>
                        </TD>
                        <td style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''" onclick="getPhoneAndOtherMobile(this)">
                            <b ><%=wbo.getAttribute("clientMobile")%></b>
                            <input type="hidden" id="phone" name="phone" value="<%=wbo.getAttribute("phone") != null && !wbo.getAttribute("phone").equals("null") && !wbo.getAttribute("phone").equals("UL") ? wbo.getAttribute("phone") : ""%>" />
                            <input type="hidden" id="other" name="other" value="<%=wbo.getAttribute("other") != null && !wbo.getAttribute("other").equals("other") && !wbo.getAttribute("other").equals("UL") ? wbo.getAttribute("other") : ""%>" />
                            <input type="hidden" id="mobile" name="mobile" value="<%=wbo.getAttribute("clientMobile") != null && !wbo.getAttribute("clientMobile").equals("null") && !wbo.getAttribute("clientMobile").equals("UL") ? wbo.getAttribute("clientMobile") : ""%>" />
                        </td>
                        <%--
                        <TD ><% String mobile = null;
                            if (wbo.getAttribute("mobile") == null || wbo.getAttribute("mobile").equals(" ") || wbo.getAttribute("mobile").equals("")) {
                                mobile = "--------";
                            } else {
                                mobile = (String) wbo.getAttribute("mobile");
                            }%><b><%=mobile%></b>
                        </TD>
                        --%>
                        <TD ><b><%=wbo.getAttribute("typeName")%></b></TD>
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
                        <TD nowrap  ><font color="red"><%=today%> - </font><b><%=sTime%></b></TD>
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
            <input type="hidden" name="projectName" id="projectName" value="All">
            <input type="hidden" name="statusName" id="statusName" value="Schedule">
            <BR>
        </FIELDSET>
    </CENTER>
</BODY>
</HTML>