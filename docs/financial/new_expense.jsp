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
<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Campaigns.Campaigns"  />
    <head>
        <%
            WebBusinessObject channelWbo = (WebBusinessObject) request.getAttribute("channelWbo");
            ArrayList<WebBusinessObject> companiesList = (ArrayList<WebBusinessObject>) request.getAttribute("companiesList");
        %>
        <script>
            $("#expenseDate").datepicker({
                changeMonth: true,
                changeYear: true,
                maxDate: 0,
                dateFormat: "yy/mm/dd"
            });
            function changeCurrency() {
                if ($("#currencyType").val() === 'pound') {
                    $("#exchangeRate").val("1");
                    $("#exchangeRate").attr("readonly", "readonly");
                } else {
                    $("#exchangeRate").val("");
                    $("#exchangeRate").removeAttr("readonly");
                }
                calculateAmount();
            }
            function calculateAmount() {
                try {
                    $("#amount").val(parseFloat($("#paidAmount").val()) * parseFloat($("#exchangeRate").val()));
                } catch (err) {
                    $("#amount").val("0.00");
                }
            }
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
            <form id="expense_form">
                <table align="center" dir=<fmt:message key="direction" /> cellpadding="0" cellspacing="0" border="0" id="MainTable">
                    <tr>
                        <td style="text-align: <fmt:message key="textalign" />" class='td'>
                            <b>
                                <fmt:message key="channel" />
                            </b>
                        </td>
                        <td style="text-align: <fmt:message key="textalign" />" class='td'>
                            <fmt:message var="attname" key="comm_channel_attribute_name" />
                            <%
                                String attname = (String) pageContext.getAttribute("attname");
                                String attValue = (String) channelWbo.getAttribute(attname) + " ";
                            %>
                            <b><%=channelWbo != null ? attValue : ""%></b>
                            <input type="hidden" id="channelID" name="channelID" value="<%=channelWbo != null ? channelWbo.getAttribute("id") : ""%>"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: <fmt:message key="textalign" />" class='td'>
                            <b>
                                <fmt:message key="company" />
                            </b>
                        </td>
                        <td style="text-align: <fmt:message key="textalign" />" class='td'>
                            <select id="companyID" name="companyID" style="width: 150px;" required>
                                <option value=""><fmt:message key="select"/></option>
                                <sw:WBOOptionList wboList="<%=companiesList%>" displayAttribute="name" valueAttribute="id"/>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: <fmt:message key="textalign" />" class='td'>
                            <b>
                                <fmt:message key="expenseDate" />
                            </b>
                        </td>
                        <td style="text-align: <fmt:message key="textalign" />" class='td'>
                            <input id="expenseDate" name="expenseDate" type="text" style="width: 100px;" readonly/>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: <fmt:message key="textalign" />" class='td'>
                            <b>
                                <fmt:message key="currency" />
                            </b>
                        </td>
                        <td style="text-align: <fmt:message key="textalign" />" class='td'>
                            <select id="currencyType" name="currencyType" style="width: 150px;"
                                    onchange="JavaScript: changeCurrency();">
                                <option value=""><fmt:message key="select"/></option>
                                <option value="dollar"><fmt:message key="dollar"/></option>
                                <option value="pound"><fmt:message key="pound"/></option>
                                <option value="euro"><fmt:message key="euro"/></option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: <fmt:message key="textalign" />" class='td'>
                            <b>
                                <fmt:message key="paidAmount" />
                            </b>
                        </td>
                        <td style="text-align: <fmt:message key="textalign" />" class='td'>
                            <input id="paidAmount" name="paidAmount" type="number" style="width: 100px;" step="0.1"
                                   onchange="JavaScript: calculateAmount();"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: <fmt:message key="textalign" />" class='td'>
                            <b>
                                <fmt:message key="exchangeRate" />
                            </b>
                        </td>
                        <td style="text-align: <fmt:message key="textalign" />" class='td'>
                            <input id="exchangeRate" name="exchangeRate" type="number" style="width: 100px;" step="0.01"
                                   onchange="JavaScript: calculateAmount();"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: <fmt:message key="textalign" />" class='td'>
                            <b>
                                <fmt:message key="amount" />
                            </b>
                        </td>
                        <td style="text-align: <fmt:message key="textalign" />" class='td'>
                            <input id="amount" name="amount" type="number" style="width: 100px;" readonly/>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
    </body>
</html>
