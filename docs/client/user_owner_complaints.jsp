<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
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
        String sat, sun, mon, tue, wed, thu, fri;
        if (stat.equals("En")) {
            sat = "Sat";
            sun = "Sun";
            mon = "Mon";
            tue = "Tue";
            wed = "Wed";
            thu = "Thu";
            fri = "Fri";
        } else {
            sat = "&#1575;&#1604;&#1587;&#1576;&#1578;";
            sun = "&#1575;&#1604;&#1575;&#1581;&#1583;";
            mon = "&#1575;&#1604;&#1575;&#1579;&#1606;&#1610;&#1606;";
            tue = "&#1575;&#1604;&#1579;&#1604;&#1575;&#1579;&#1575;&#1569;";
            wed = "&#1575;&#1604;&#1575;&#1585;&#1576;&#1593;&#1575;&#1569;";
            thu = "&#1575;&#1604;&#1582;&#1605;&#1610;&#1587;";
            fri = "&#1575;&#1604;&#1580;&#1605;&#1593;&#1577;";
        }

    %>
    <head>
    </head>
    <body>
        <br/>
        <table id="clientCampaignsPopup" align="center" dir="rtl" width="100%" cellpadding="0" cellspacing="0">
            <thead>
                <tr>
                    <th class="blueBorder backgroundTable" style="text-align: center; font-size: 14px; font-weight: bold; height: 30px;" nowrap><b>#</b></th>
                    <th class="blueBorder backgroundTable" style="text-align: center; font-size: 14px; font-weight: bold; height: 30px;" nowrap><b> رقم المتابعة</b></th>
                    <th class="blueBorder backgroundTable" style="text-align: center; font-size: 14px; font-weight: bold; height: 30px;" nowrap><b>العميل </b></th>
                    <th class="blueBorder backgroundTable" style="text-align: center; font-size: 14px; font-weight: bold; height: 30px;" nowrap><b> كود الطلب</b></th>
                    <th class="blueBorder backgroundTable" style="text-align: center; font-size: 14px; font-weight: bold; height: 30px;" nowrap><b>الحاله</b></th>
                    <th class="blueBorder backgroundTable" style="text-align: center; font-size: 14px; font-weight: bold; height: 30px;" nowrap><b>تاريخ الحاله</b></th>
                    <th class="blueBorder backgroundTable" style="text-align: center; font-size: 14px; font-weight: bold; height: 30px;" nowrap><b>المصدر</b></th>
                </tr>
            </thead>
            <tbody>
                <%                    if (complaintsList.size() > 0 && complaintsList != null) {
                        String sDate, sTime;
                        int iTotal = 0;
                        for (WebBusinessObject wbo : complaintsList) {
                            iTotal++;
                %>
                <tr style="padding: 1px;">
                    <td>
                        <%=iTotal%>
                    </td>
                    <td style="cursor: pointer">
                        <a href="JavaScript: openInNewWindow('<%=context%>/IssueServlet?op=getCompl3&issueId=<%=wbo.getAttribute("issueId")%>&compId=<%=wbo.getAttribute("id")%>&statusCode=<%=wbo.getAttribute("currentStatus")%>&receipId=<%=wbo.getAttribute("currentOwnerId")%>&senderID=<%=wbo.getAttribute("createdBy")%>');">
                            <font color="red"><%=wbo.getAttribute("businessID")%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate")%></font>
                        </a>
                    </td>
                    <td nowrap>
                        <b><%=wbo.getAttribute("clientName")%></b>
                        <a target="_blanck" href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("clientID")%>">
                            <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"/>
                        </a>
                    </td>
                    <td nowrap><b><%=wbo.getAttribute("businessCompID")%></b></td>
                    <td><b><%=wbo.getAttribute("statusName" + stat)%></b></td>
                    <%  Calendar c = Calendar.getInstance();
                        SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
                        String[] arrDate = ((String) wbo.getAttribute("creationTime")).split(" ");
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
                    <td nowrap><b><%=wbo.getAttribute("createdByName")%></b></td>
                </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>
        <br/><br/>
    </body>
</html>