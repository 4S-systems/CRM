<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Campaigns.Campaigns"  />
    <head>
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            ArrayList<LiteWebBusinessObject> data = (ArrayList<LiteWebBusinessObject>) request.getAttribute("data");
        %>
        <script>
            var oTable;
            $(document).ready(function () {
                oTable = $('#expensesList').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).fadeIn(2000);
            });
        </script>
        <style>
            .ui-dialog-titlebar-close{
                display: none;
            }
        </style>
    </head>
    <body>
        <div style="width: 90%;margin-left: auto;margin-right: auto;">
            <br/>
            <table class="blueBorder" id="expensesList" align="center" dir=<fmt:message key="direction" /> width="100%" cellpadding="0" cellspacing="0">
                <thead>
                    <tr>
                        <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; color:white; font-size:14px"><b><fmt:message key="company" /></b></th>
                        <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; color:white; font-size:14px"><b><fmt:message key="expenseDate" /></b></th>
                        <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; color:white; font-size:14px"><b><fmt:message key="amount" /></b></th>
                        <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; color:white; font-size:14px"><b><fmt:message key="currency" /></b></th>
                        <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; color:white; font-size:14px"><b><fmt:message key="exchangeRate" /></b></th>
                        <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; color:white; font-size:14px"><b><fmt:message key="paidAmount" /></b></th>
                        <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; color:white; font-size:14px"><b>&nbsp;</b></th>
                    </tr>
                </thead>  
                <tbody  id="planetData2">
                    <%
                        if (data != null && data.size() > 0) {
                            for (LiteWebBusinessObject wbo : data) {
                    %>
                    <tr style="padding: 1px;" id="row<%=wbo.getAttribute("id")%>">
                        <td>
                            <%=wbo.getAttribute("companyName")%>
                        </td>
                        <td>
                            <%=((String) wbo.getAttribute("expenseDate")).substring(0, 10)%>
                        </td>
                        <td>
                            <%=wbo.getAttribute("amount")%>
                        </td>
                        <td>
                            <%=wbo.getAttribute("currencyType")%>
                        </td>
                        <td>
                            <%="UL".equals(wbo.getAttribute("option1")) ? "---" : wbo.getAttribute("option1")%>
                        </td>
                        <td>
                            <%="UL".equals(wbo.getAttribute("option2")) ? "---" : wbo.getAttribute("option2")%>
                        </td>
                        <td>
                            <a href="#" onclick="JavaScript: deleteExpense('<%=wbo.getAttribute("id")%>');"><fmt:message key="deleteExpense"/></a>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </body>
</html>
