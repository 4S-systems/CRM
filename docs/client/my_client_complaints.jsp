<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.silkworm.common.UserMgr"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld"%> 
<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/tr/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Client.client" />
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<WebBusinessObject> complaintsList = (ArrayList<WebBusinessObject>) request.getAttribute("complaintsList");

        String stat = (String) request.getSession().getAttribute("currentMode");
        String sat, sun, mon, tue, wed, thu, fri, noResponse;
        if (stat.equals("En")) {
            sat = "Sat";
            sun = "Sun";
            mon = "Mon";
            tue = "Tue";
            wed = "Wed";
            thu = "Thu";
            fri = "Fri";
            noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
        } else {
            sat = "&#1575;&#1604;&#1587;&#1576;&#1578;";
            sun = "&#1575;&#1604;&#1575;&#1581;&#1583;";
            mon = "&#1575;&#1604;&#1575;&#1579;&#1606;&#1610;&#1606;";
            tue = "&#1575;&#1604;&#1579;&#1604;&#1575;&#1579;&#1575;&#1569;";
            wed = "&#1575;&#1604;&#1575;&#1585;&#1576;&#1593;&#1575;&#1569;";
            thu = "&#1575;&#1604;&#1582;&#1605;&#1610;&#1587;";
            fri = "&#1575;&#1604;&#1580;&#1605;&#1593;&#1577;";
            noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
        }
	
	String clientId = request.getAttribute("clientId") != null ? (String) request.getAttribute("clientId") : "";
    %>
    <head>
        <script type="text/javascript">
            function submitForm() {
                $("#COMPLAINTS_FORM").submit();
            }
            function selectAll(obj) {
                $("input[name='clientComplaintID']").prop('checked', $(obj).is(':checked'));
            }
        </script>
    </head>
    <body>
        <form id="COMPLAINTS_FORM" name="COMPLAINTS_FORM" method="POST" action="<%=context%>/ClientServlet?op=withdrawFromDetails">
	    <input type="hidden" id="clientId" name="clientId" value="<%=clientId%>">
	    
            <!--center>
                <button class="button" style="width: 15%;"><a href="#" onclick="JavaScript: submitForm();"><font size="5"> سحب </font></a></button>
            </center>

            <br/-->

            <table id="clientCampaignsPopup" align="center" dir="rtl" width="100%" cellpadding="0" cellspacing="0">
                <thead>
                    <tr>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:14px; font-weight: bold; height: 30px" nowrap>
                            <input type="checkbox" id="selectAllChk" onclick="JavaScript: selectAll(this);"/>
                        </th>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:14px; font-weight: bold; height: 30px" nowrap><b>#</b></th>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:14px; font-weight: bold; height: 30px" nowrap><b> رقم المتابعة</b></th>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:14px; font-weight: bold; height: 30px" nowrap><b>النوع</b></th>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:14px; font-weight: bold; height: 30px" nowrap><b>الطلب</b></th>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:14px; font-weight: bold; height: 30px" nowrap><b> كود الطلب</b></th>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:14px; font-weight: bold; height: 30px" nowrap><b>المصدر</b></th>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:14px; font-weight: bold; height: 30px" nowrap><b>المسؤول</b></th>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:14px; font-weight: bold; height: 30px" nowrap><b>الحاله</b></th>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:14px; font-weight: bold; height: 30px" nowrap><b>تاريخ الحاله</b></th>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:14px; font-weight: bold; height: 30px" nowrap><b>ع.ط  ( يوم)</b></th>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:14px; font-weight: bold; height: 30px" nowrap><b>&nbsp;</b></th>
                    </tr>
                </thead>
                <tbody>

                    <%
                        if (complaintsList.size() > 0 && complaintsList != null) {
                            String complStatus;
                            String sDate, sTime;
                            int iTotal = 0;
                            for (WebBusinessObject wbo : complaintsList) {
                                iTotal++;
                    %>
                    <tr style="padding: 1px;">
                        <td>
                            <input type="checkbox" name="clientComplaintID" value="<%=wbo.getAttribute("clientComId")%>"/>
                        </td>
                        <td>
                            <%=iTotal%>
                        </td>
                        <td style="cursor: pointer">
                            <%
                                if (wbo.getAttribute("issue_id") != null) {
                            %>
                            <a href="JavaScript: openInNewWindow('<%=context%>/IssueServlet?op=getCompl3&issueId=<%=wbo.getAttribute("issue_id")%>&compId=<%=wbo.getAttribute("clientComId")%>&statusCode=<%=wbo.getAttribute("statusCode")%>&receipId=<%=wbo.getAttribute("receipId")%>&senderID=<%=wbo.getAttribute("senderId")%>');"> <font color="red"><%=wbo.getAttribute("businessID")%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate")%></font></a>
                                    <%
                                        }
                                    %>
                        </td>
                        <td>
                            <b><%=wbo.getAttribute("typeName") != null ? wbo.getAttribute("typeName") : "---"%></b>
                        </td>
                        <% String sCompl = " ";
                            if (wbo.getAttribute("compSubject") != null && !wbo.getAttribute("compSubject").equals("")) {
                                sCompl = (String) wbo.getAttribute("compSubject");
                                if (sCompl.length() > 10) {
                        %>
                        <td><b><%=sCompl%></b></td>
                        <%
                        } else {
                        %>
                        <td><b><%=sCompl%></b></td>
                        <%
                            }
                        %>
                        <%
                        } else {
                        %>
                        <td><b><%=sCompl%></b></td>
                        <%
                            }
                        %>
                        <td nowrap><b><%=wbo.getAttribute("businessCompId")%></b></td>
                        <td>
                            <%
                                if (wbo.getAttribute("createdByName") != null) {
                            %>
                            <b><%=wbo.getAttribute("createdByName")%></b>
                            <%
                                }
                            %>
                        </td>
                        <td>
                            <%
                                if (wbo.getAttribute("currentOwner") != null) {
                            %>
                            <b><%=wbo.getAttribute("currentOwner")%></b>
                            <%
                                }
                            %>
                        </td>

                        <%
                            if (stat.equals("En")) {
                                complStatus = (String) wbo.getAttribute("statusEnName");
                            } else {
                                complStatus = (String) wbo.getAttribute("statusArName");
                            }
                        %>
                        <td><b><%=complStatus%></b></td>

                        <%  Calendar c = Calendar.getInstance();
                            SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
                            String[] arrDate = ((String) wbo.getAttribute("entryDate")).split(" ");
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
                            if (currentDate.equals(sDate)) {
                        %>
                        <td nowrap><font color="red">Today - </font><b><%=sTime%></b></td>
                                <%
                                } else {
                                %>

                        <td nowrap><font color="red"><%=sDay%> - </font><b><%=sDate + " " + sTime%></b></td>
                                <%
                                    }
                                %>
                        <td>
                            <%
                                try {
                                    out.write("<b>" + DateAndTimeControl.getDelayTime((String) wbo.getAttribute("entryDate"), "Ar") + "</b>");
                                } catch (Exception E) {
                                    out.write("<b>" + noResponse + "</b>");
                                }
                            %>
                        </td>
                        <td>
                            <a target="blank_" href="<%=context%>/DatabaseControllerServlet?op=dragClientForm&searchBy=unitNo&searchByValue=<%=wbo.getAttribute("businessID")%>">ســـــحــــب</a>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
            <br/><br/>
        </form>
    </body>
</html>