<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.common.UserMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
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
        WebBusinessObject clientWbo = (WebBusinessObject) request.getAttribute("clientWbo");
        WebBusinessObject ownerUserWbo = (WebBusinessObject) request.getAttribute("ownerUserWbo");
        WebBusinessObject loggerWbo = (WebBusinessObject) request.getAttribute("loggerWbo");
        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

        String stat = (String) request.getSession().getAttribute("currentMode");
        String dir, client, possible, chance, oncontact, notfound;
        if (stat.equals("En")) {
            dir = "LTR";
            client = "Client";
            possible = "Possible";
            chance = "Chance";
            oncontact = "On Contact";
            notfound = "Not Found";
        } else {
            dir = "RTL";
            client = "عميل";
            possible = "محتمل";
            chance = "فرصة";
            oncontact = "على اتصال";
            notfound = "لا يوجد";
        }
        
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
    %>
    <head>
        
        <script>
            function sendEmail(email, clientNo, clientName, clientMob) {
                var email = email;
                var subject = ' Client Alert ';
                
                $.ajax({
                    type: "post",
                    url: "<%=context%>/EmailServlet?op=sentClientAlertEmail",
                    data: {
                        email: email,
                        subject: subject,
                        clientNo: clientNo,
                        clientName: clientName,
                        clientMob: clientMob
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'ok') {
                            alert(" تم إرسال الرسالة ");
                            closePopup("email_content");
                        } else {
                            alert(" خطأ فى إرسال الرسالة ");
                        }
                    }
                });
                return false;
            }
            
            function alertComplaint(clientID, employeeID) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=redirectClientComplaint2",
                    data: {
                        clientID: clientID,
                        employeeId: employeeID,
                        ticketType: '2',
                        comment: 'This Client Registered Again',
                        subject: 'VIC',
                        notes: 'VIC'
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'ok') {
                            alert("Done");
                        }
                    }, error: function (jsonString) {
                        alert(jsonString);
                    }
                });
            }
        </script>
        
        <style>
            table label {float: right;}
            td {border: none; padding-bottom: 10px;}
            tr:nth-child(even) td.dataTD {background: #FFF}
            tr:nth-child(odd) td.dataTD {background: #f1f1f1}
            .titleRow {
                background-color: orange;
            }
            .titleTD {
                text-align:center;
                font-weight: bold;
                font-size: 16px;
                color: black;
                background-color:#b9d2ef;
            }
            .dataTD {
                text-align:right;
                border: none;
                font-weight: bold;
                font-size: 16px;
                color: black;
            }
            .detailTD {
                text-align:center;
                font-weight: bold;
                font-size: 16px;
                color: black;
                background-color: #FCC90D;
            }
            .dataDetailTD {
                text-align:right;
                border: none;
                font-weight: bold;
                font-size: 16px;
                color: black;
            }
            tr:nth-child(even) td.dataDetailTD {background: #FFF19F}
            tr:nth-child(odd) td.dataDetailTD {background: #FFF19F}

        </style>
    </head>
    <BODY>
        <table  border="0px" dir="<%=dir%>" class="table" style="width:<fmt:message key="width"/>;text-align: right;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >
            <tr>
                <td class="td">
                    <table style="width: 100%;">
                        <tr>
                            <td class="td titleTD">
                                <fmt:message key="clientid" />

                            </td>
                            <td class="td dataTD" colspan="3">
                                <label ><%=clientWbo.getAttribute("clientNO")%></label>
                            </td>
                        </tr>
                        <tr>
                            <td class="td titleTD">
                                <fmt:message key="clientname" />
                            </td>
                            <td class="td dataTD" colspan="3">
                                <label><%=clientWbo.getAttribute("name")%></label>
                                <input type="hidden" id="hideName" value="<%=clientWbo.getAttribute("name")%>" />
                                <% String mail = "";
                                    if (clientWbo.getAttribute("email") != null) {
                                        mail = (String) clientWbo.getAttribute("email");
                                    }
                                %>
                                <input type="hidden" id="hideEmail" value="<%=mail%>" />
                                <input type="hidden" id="clientId" name="clientId" value="<%=clientWbo.getAttribute("id")%>"/>
                            </td>
                        </tr>
                        <tr class="titleRow">
                            <td class="td" colspan="2" style="text-align: right;">
                                <fmt:message key="Custmmov" />
                            </td>
                        </tr>
                        <%
                            UserMgr userMgr = UserMgr.getInstance();
                            if (clientWbo != null) {
                                if (clientWbo.getAttribute("currentStatus") != null) {
                                    String currentStatus = (String) clientWbo.getAttribute("currentStatus");
                                    if (currentStatus.equals("11")) {
                                        currentStatus = client;
                                    } else if (currentStatus.equals("12")) {
                                        currentStatus = possible;
                                    } else if (currentStatus.equals("13")) {
                                        currentStatus = chance;
                                    } else if (currentStatus.equals("14")) {
                                        currentStatus = oncontact;
                                    }
                        %>
                        <tr>
                            <td class="td detailTD">
                                <fmt:message key="status" />
                            </td>
                            <td class="td dataDetailTD"><%=currentStatus%></td>
                            <td class="td dataDetailTD" colspan="2">&nbsp;</td>
                        </tr>
                        <%
                            }
                            userWbo = userMgr.getOnSingleKey((String) clientWbo.getAttribute("createdBy"));
                            String createdBy = userWbo != null ? (String) userWbo.getAttribute("fullName") : "";
                        %>
                        <tr>
                            <td class="td detailTD">
                                <fmt:message key="source" />
                            </td>
                            <td class="td dataDetailTD"><%=createdBy%></td>
                            <td class="td detailTD"> <fmt:message key="signindate" /></td>
                            <td class="td dataDetailTD"><%=clientWbo.getAttribute("creationTime")%></td>
                        </tr>
                        <% } %>
                        <% if (ownerUserWbo != null) {%>
                        <tr>
                            <td class="td detailTD"> <fmt:message key="employee" /> </td>
                            <td class="td dataDetailTD"><%=ownerUserWbo.getAttribute("fullName")%></td>
                            <td class="td dataDetailTD"> 
                                <button class="button" style="width: 150px; text-align: center;" onclick="alertComplaint('<%=clientWbo.getAttribute("id")%>', '<%=ownerUserWbo != null ? ownerUserWbo.getAttribute("userId") : ""%>');"> Alert Owner</button>
                            </td>
                            <td class="td dataDetailTD"> 
                                <button class="button" style="width: 150px; text-align: center;" onclick="sendEmail('<%=ownerUserWbo.getAttribute("email")%>', '<%=clientWbo.getAttribute("clientNO")%>', '<%=clientWbo.getAttribute("name")%>', '<%=clientWbo.getAttribute("mobile")%>');"> Email Alert </button>
                            </td>
                        </tr>
                        <%
                            }
                            String lastUpdate = notfound;
                            String createdBy = notfound;
                            if (loggerWbo != null) {
                                lastUpdate = (String) loggerWbo.getAttribute("eventTime");
                                userWbo = userMgr.getOnSingleKey((String) loggerWbo.getAttribute("userId"));
                                createdBy = userWbo != null ? (String) userWbo.getAttribute("fullName") : "";
                            }
                        %>
                        <tr>
                            <td class="td detailTD"> <fmt:message key="lastedit" /></td>
                            <td class="td dataDetailTD"><%=createdBy%></td>
                            <td class="td detailTD"> <fmt:message key="editdate" /></td>
                            <td class="td dataDetailTD"><%=lastUpdate%></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <br/>
    </BODY>
</html>