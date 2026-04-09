<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Sales_Market.Sales_Market"  />
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<WebBusinessObject> clientsList = (ArrayList<WebBusinessObject>) request.getAttribute("clientsList");
        WebBusinessObject groupWbo = (WebBusinessObject) request.getAttribute("groupWbo");
        String fromDate = (String) request.getAttribute("fromDate");
        String toDate = (String) request.getAttribute("toDate");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align, dir, style = null;
        String sTitle, subTitle;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            sTitle = "Clients of Group " + (groupWbo != null ? groupWbo.getAttribute("groupName") : "");
            subTitle = "from " + fromDate + " To " + toDate;
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            sTitle = "عملاء المجموعة " + (groupWbo != null ? groupWbo.getAttribute("groupName") : "");
            subTitle = "من " + fromDate + " إلي " + toDate;
        }
    %>
    <head>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript">
            $(document).ready(function () {
                $('#clients').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
            });
            function openInNewWindow(url) {
                var win = window.open(url, '_blank');
                win.focus();
            }
        </script>
    </head>
    <body>
        <form name="CLIENT_FORM" method="post">
            <fieldset class="set" align="center" width="100%" style="width: 70%;margin-bottom: 10px;">
                <legend align="center">
                    <table dir="<%=dir%>" align="center">
                        <tr>
                            <td class="td" style="text-align: center;">
                                <font color="blue" size="6">
                                <%=sTitle%>
                                </font>
                                <br/>
                                <font color="red" size="3">
                                <%=subTitle%>
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend>
                <div style="width: 87%;margin-right: auto;margin-left: auto;" id="showClients">
                    <table align="<%=align%>" dir='<fmt:message key="direction"/>' width="100%" id="clients" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;"><fmt:message key="number"/></th>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;"> <fmt:message key="name"/></th>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;"><fmt:message key="clientSource"/></th>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;"> <fmt:message key="mobile"/></th>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;"> <fmt:message key="intnumber"/></th>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;"><fmt:message key="mail"/> </th>
                            </tr>
                        <thead>
                        <tbody>
                            <%for (WebBusinessObject clientWbo : clientsList) {%>
                            <tr onclick="createComplaints(<%=clientWbo.getAttribute("id")%>,<%=clientWbo.getAttribute("age")%>);" style="cursor: pointer" id="row">
                                <td>
                                    <b><%=clientWbo.getAttribute("clientNO") != null ? clientWbo.getAttribute("clientNO") : ""%></b>
                                </td>
                                <td>
                                    <b><%=clientWbo.getAttribute("name")%></b>
                                    <a href="JavaScript: openInNewWindow('<%=context%>/ClientServlet?op=clientDetails&clientId=<%=clientWbo.getAttribute("id")%>&issueID=<%=clientWbo.getAttribute("issueID")%>');">
                                        <img src="images/client_details.jpg" width="30" style="float: left;" title=<fmt:message key="details"/>
                                    </a>
                                </td>
                                <td>
                                    <b><%=clientWbo.getAttribute("sourceName") != null ? clientWbo.getAttribute("sourceName") : ""%></b>
                                </td>
                                <td>
                                    <b><%=clientWbo.getAttribute("mobile") != null ? clientWbo.getAttribute("mobile") : ""%></b>
                                </td>
                                <td>
                                    <b><%=clientWbo.getAttribute("interPhone") != null ? clientWbo.getAttribute("interPhone") : ""%></b>
                                </td>
                                <td>
                                    <b><%=clientWbo.getAttribute("email") != null ? clientWbo.getAttribute("email") : ""%></b>
                                </td>
                            </tr>
                            <%}%>
                        </tbody>
                    </table>
                </div>
                <br/><br/>
            </fieldset>
        </form>
    </body>
</html>     