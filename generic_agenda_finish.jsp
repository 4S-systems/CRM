<%@page import="com.crm.common.CRMConstants"%>
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
<fmt:setBundle basename="Languages.employee_agenda.employee_agenda"  />
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Weekly Manager Agenda</title>

        <script type="text/javascript">
            $(document).ready(function() {
                $('#generic_agenda_finish_table').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                    iDisplayLength: 10,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                });
            });
        </script>
    </head>

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        session = request.getSession();
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        int withinGenericAgendaFinish = 24;
        Map<String, String> withinIntervals = securityUser.getWithinIntervals();
        if (request.getParameter("withinGenericAgendaFinish") != null) {
            withinGenericAgendaFinish = new Integer(request.getParameter("withinGenericAgendaFinish"));
            withinIntervals.put("withinGenericAgendaFinish", "" + withinGenericAgendaFinish);
        } else if (withinIntervals.containsKey("withinGenericAgendaFinish")) {
            withinGenericAgendaFinish = (new Integer(withinIntervals.get("withinGenericAgendaFinish")));
        }
        
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
        if(request.getParameter("fromDateFinish") != null) {
            fromDateVal = request.getParameter("fromDateFinish");
            withinIntervals.put("fromDateFinish", "" + fromDateVal);
        } else if (withinIntervals.containsKey("fromDateFinish")) {
            fromDateVal = withinIntervals.get("fromDateFinish");
        }

        IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();
        List<WebBusinessObject> issuesVector = issueByComplaintMgr.getComplaintByOlderStatus(securityUser.getUserId(), withinGenericAgendaFinish , new java.sql.Date(sdf.parse(fromDateVal).getTime()), new java.sql.Date(sdf.parse(toDateVal).getTime()));

        String sat, sun, mon, tue, wed, thu, fri, sDate, sTime;
        
        String state = (String) request.getSession().getAttribute("currentMode");
           String   type, noResponse, ageComp, complStatus;
        if (state.equals("En")) {
            type = "Type";
            noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
            ageComp = "A.C(day)";
            sat = "Sat";
            sun = "Sun";
            mon = "Mon";
            tue = "Tue";
            wed = "Wed";
            thu = "Thu";
            fri = "Fri";
        } else {
                type = "النوع";
             noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
            ageComp = "&#1593;.&#1591; (&#1610;&#1608;&#1605;)";
            sat = "&#1575;&#1604;&#1587;&#1576;&#1578;";
            sun = "&#1575;&#1604;&#1575;&#1581;&#1583;";
            mon = "&#1575;&#1604;&#1575;&#1579;&#1606;&#1610;&#1606;";
            tue = "&#1575;&#1604;&#1579;&#1604;&#1575;&#1579;&#1575;&#1569;";
            wed = "&#1575;&#1604;&#1575;&#1585;&#1576;&#1593;&#1575;&#1569;";
            thu = "&#1575;&#1604;&#1582;&#1605;&#1610;&#1587;";
            fri = "&#1575;&#1604;&#1580;&#1605;&#1593;&#1577;";
        }
    %>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function submitformFinish()
        {
            document.within_form_generic_agenda_finish.submit();
        }
        function submitform()
        {
            document.within_form2.submit();
        }
    </SCRIPT>
    <BODY>
    <CENTER>
        <FIELDSET class="set" style="width:100%;" >
             <form name="within_form2" style="margin-left: auto; margin-right: auto;">
                <table class="blueBorder" id="code2" align="center" dir="<fmt:message key="direction"/>" width="650" cellspacing="2" cellpadding="1"
                       style="border-width:1px;border-color:white;display: block;">
                    <tr class="head">
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white" title="<fmt:message key="distdate"/>"><fmt:message key="fromDate"/></font></b>
                        </td>
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white" title="<fmt:message key="distdate"/>"><fmt:message key="toDate"/></font></b>
                        </td>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 250px;" bgcolor="#EEEEEE" valign="middle" rowspan="2">
                            <button type="submit" class="button" style="width: 170px;"><fmt:message key="search"/><img height="15" src="images/search.gif"/></button>
                            <br/>
                            <br/>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" valign="middle">
                            <input class="fromToDate" id="fromDateFinish" name="fromDateFinish" type="text" value="<%=fromDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" style="text-align:right" valign="middle">
                            <input class="fromToDate" id="toDateFinish" name="toDateFinish" type="text" value="<%=toDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                    </tr>
                </table>
            </form>
            <TABLE id="generic_agenda_finish_table" align="center" DIR=<fmt:message key="direction"/> WIDTH="100%" CELLPADDING="0" cellspacing="0">
                <thead><TR>
                        <!--TH  ><SPAN ></SPAN></TH-->
                        <TH ><SPAN ><img src="images/icons/Numbers.png" width="20" height="20" /><b> <fmt:message key="requestno"/></b></SPAN></TH>
                        <TH  ><SPAN><img src="images/icons/client.png" width="20" height="20" /><b><fmt:message key="clientname"/></b></SPAN></TH>
                        <TH ><SPAN><b><%=type%></b></SPAN></TH>
                        <TH ><SPAN><img src="images/icons/list_.png" width="20" height="20" /><b> <fmt:message key="request"/></b></SPAN></TH>
                        <TH><SPAN><img src="images/icons/key.png" width="20" height="20" /><b><fmt:message key="requestcode"/></b></SPAN></TH>
                        <TH  ><SPAN><img src="images/icons/status_.png" width="18" height="18" /><b><fmt:message key="status"/></b></SPAN></TH>
                        <TH  ><SPAN><img src="images/icons/manager.png" width="18" height="18" /><b><fmt:message key="source"/></b></SPAN></TH>
                        <TH  ><SPAN><img src="images/icons/manager.png" width="18" height="18" /><b><fmt:message key="reqdate"/></b></SPAN></TH>
                        <TH  width="10%"><b><%=ageComp%></b></TH>
                    </TR></thead>
                <tbody  >  
                    <%
                        String ticketType, compStyle, senderName, sCompl;
                        for (WebBusinessObject wbo : issuesVector) {
                            compStyle = "";
                            ticketType = (String) wbo.getAttribute("ticketType");
                            if (CRMConstants.CLIENT_COMPLAINT_TYPE_COMPLAINT.equalsIgnoreCase(ticketType)) {
                                compStyle = "comp";
                            } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_ORDER.equalsIgnoreCase(ticketType)) {
                                compStyle = "order";
                            } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_QUERY.equalsIgnoreCase(ticketType)) {
                                compStyle = "query";
                            } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_EXTRACT.equalsIgnoreCase(ticketType)) {
                                compStyle = "order";
                            } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_EXTRADITION.equalsIgnoreCase(ticketType)) {
                                compStyle = "order";
                            } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_FINANCIAL.equalsIgnoreCase(ticketType)) {
                                compStyle = "order";
                            } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_CLIENT_VISIT.equalsIgnoreCase(ticketType)) {
                                compStyle = "order";
                            }
                            senderName = (String) wbo.getAttribute("senderName");
                            if (senderName == null) {
                                senderName = "";
                            } else {
                            }
                            if (state.equals("En")) {
                                complStatus = (String) wbo.getAttribute("statusEnName");
                            } else {
                                complStatus = (String) wbo.getAttribute("statusArName");;
                            }
                            sCompl = " ";
                            if (wbo.getAttribute("compSubject") != null && !wbo.getAttribute("compSubject").equals("")) {
                                sCompl = wbo.getAttribute("compSubject").toString();
                            }
                            Calendar c = Calendar.getInstance();
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
                    <TR>
                        <!--TD style="background-color: transparent;">
                            <SPAN style="display: inline-block;height: 20px;">
                                <INPUT type="checkbox" id="compId" value="<%=wbo.getAttribute("clientComId")%>" name="selectedIssue" />
                            </SPAN>
                        </TD-->
                        <TD style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                            <a href="<%=context%>/IssueServlet?op=getCompl2&issueId=<%=wbo.getAttribute("issue_id")%>&compId=<%=wbo.getAttribute("clientComId")%>&statusCode=<%=wbo.getAttribute("statusCode")%>&receipId=<%=wbo.getAttribute("receipId")%>&senderID=<%=wbo.getAttribute("senderId")%>&clientType=<%=wbo.getAttribute("age")%>"> <font color="red"><%=wbo.getAttribute("businessID").toString()%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate").toString()%></font></a>
                        </TD>
                        <TD><b><%=wbo.getAttribute("customerName")%></b>
                            <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("customerId")%>">
                                <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"
                                     onmouseover="JavaScript: changeCommentCounts('<%=wbo.getAttribute("customerId")%>', this);"/>
                            </a>
                            <a href="#" onclick="JavaScript: printClientInformation('<%=wbo.getAttribute("customerId")%>')">
                                <img src="images/pdf_icon.gif" style="float: left; height: 20px;" title="Datasheet"/>
                            </a>
                        </TD>
                        <TD><b><%=wbo.getAttribute("typeName")%></b></TD>
                        <TD STYLE="text-align:center;padding-<fmt:message key="align"/>: 5px; font-size: 12px;" width="20%"><b><%=sCompl%></b>
                            <%
                                if(wbo.getAttribute("ticketType") != null && (((String) wbo.getAttribute("ticketType")).equals(CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_EXTRADITION)
                                        || ((String) wbo.getAttribute("ticketType")).equals(CRMConstants.CLIENT_COMPLAINT_TYPE_DELIVERY_OF_QUALITY))) {
                            %>
                                <a href="#" onclick="JavaScript: viewRequest('<%=wbo.getAttribute("issue_id")%>','<%=wbo.getAttribute("clientComId")%>');">
                                    <IMG value="" onclick="" height="25px" src="images/icons/checklist-icon.png" style="margin: 0px 0; float: left;" title="مشاهدة طلب تسليم"/>
                                </a>
                            <%
                                }
                            %>
                        </TD>
                        <TD><b><%=wbo.getAttribute("businessCompId")%></b></TD>
                        <TD><b><%=complStatus%></b></TD>
                        <TD><b><%=senderName%></b></TD>
                        <%
                            if (currentDate.equals(sDate)) {
                        %>
                            <TD nowrap  ><font color="red">Today - </font><b><%=sTime%></b></TD>
                        <%
                        } else {
                        %>
                            <TD nowrap  ><font color="red"><%=sDay%> - </font><b><%=sDate + " " + sTime%></b></TD>
                        <%
                            }
                        %>
                        <td style="border-left:0px; border-right:0px; border-bottom: 1px black; ">
                            <%
                                try {
                                    out.write(DateAndTimeControl.getDelayTime(wbo.getAttribute("entryDate").toString(), "Ar"));
                                } catch (Exception e) {
                                    out.write(noResponse);
                                }
                            %>
                        </td>
                    </TR>
                    <% }%>
                </tbody>
            </TABLE>
            <BR>
        </FIELDSET>
    </CENTER>
</BODY>
</HTML>