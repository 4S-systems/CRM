<%@page import="java.sql.Timestamp"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<html>
    <head>
        <title></title>
    </head>
    <%
        ArrayList<WebBusinessObject> commentsList = (ArrayList<WebBusinessObject>) request.getAttribute("commentsList");
    %>
    <body>
        <table style="width:100%;text-align: right;border: none;margin-bottom: 20px;" class="table" dir="rtl" cellspacing="0">
            <thead>
                <tr>
                    <td rowspan="2" class="blueHeaderTD" style="background-repeat: repeat;">#</td>
                    <td rowspan="2" class="blueHeaderTD" style="background-repeat: repeat;">التعليقات</td>
                    <td rowspan="2" class="blueBorder blueHeaderTD" style="background-repeat: repeat;">تاريخ الأستلام</td>
                    <td colspan="3" class="blueBorder blueHeaderTD">المدة المنصرمة</td>
                    <td rowspan="2" class="blueBorder blueHeaderTD" style="background-repeat: repeat;">بواسطة</td>
                </tr>
                <tr>
                    <td style="width: 5%;" class="blueBorder blueHeaderTD">يوم</td>
                    <td style="width: 5%;" class="blueBorder blueHeaderTD">ساعة</td>
                    <td style="width: 5%;" class="blueBorder blueHeaderTD">دقيقة</td>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td colspan="7" class="td">
                        <hr style="width: 100%;">
                    </td>
                </tr>
                <%
                    DateAndTimeControl.CustomDate custom;
                    long duration, totalDuration = 0;
                    int count = 0;
                    for (WebBusinessObject commentWbo : commentsList) {
                        count++;
                        duration = commentWbo.getAttribute("duration") != null ? (Long) commentWbo.getAttribute("duration") : 0;
                        totalDuration += duration;
                        custom = DateAndTimeControl.getDelayTime(Long.valueOf(duration).intValue());
                %>
                <tr>
                    <td style="text-align: right; padding-right: 25px; color: #0055cc;" class="td"><%=count%></td>
                    <td style="text-align: right; padding-right: 25px; color: #0055cc;" class="td"> <label style="width: 100px;"><%=commentWbo.getAttribute("comment")%></label></td>
                    <td style="text-align: center; color: #0055cc;" class="td">
                        <label id="requestDate">
                            <%=DateAndTimeControl.getArabicDateTimeFormatted((String) commentWbo.getAttribute("creationTime"))%>
                        </label>
                    </td>
                    <td style="text-align: center; color: #0055cc;" class="td"><label id=""><%=DateAndTimeControl.CustomDate.getAsString(custom.getDays())%></label></td>
                    <td style="text-align: center; color: #0055cc;" class="td"><label id=""><%=DateAndTimeControl.CustomDate.getAsString(custom.getHours())%></label></td>
                    <td style="text-align: center; color: #0055cc;" class="td"><label id=""><%=DateAndTimeControl.CustomDate.getAsString(custom.getMinutes())%></label></td>
                    <td style="text-align: right; padding-right: 25px; color: #0055cc;" nowrap class="td"><label id="" ><%=commentWbo.getAttribute("createdByName") != null ? commentWbo.getAttribute("createdByName") : "---"%> </label></td>
                </tr>
                <% }%>
                <tr>
                    <td colspan="7" class="td">
                        <hr style="width: 100%;">
                    </td>
                </tr>
                <tr id="total">
                    <%
                        custom = DateAndTimeControl.getDelayTime(Long.valueOf(totalDuration).intValue());
                    %>
                    <td class="blueBorder blueHeaderTD"></td>
                    <td class="blueBorder blueHeaderTD">الوقت الكلى </td>
                    <td class="blueBorder blueHeaderTD"></td>
                    <td style="text-decoration:underline" class="blueBorder blueHeaderTD"><%=DateAndTimeControl.CustomDate.getAsString(custom.getDays())%></td>
                    <td style="text-decoration:underline" class="blueBorder blueHeaderTD"><%=DateAndTimeControl.CustomDate.getAsString(custom.getHours())%></td>
                    <td style="text-decoration:underline" class="blueBorder blueHeaderTD"><%=DateAndTimeControl.CustomDate.getAsString(custom.getMinutes())%></td>
                    <td class="blueBorder blueHeaderTD"></td>
                </tr>
            </tbody>
        </table>
    </body>
</html>