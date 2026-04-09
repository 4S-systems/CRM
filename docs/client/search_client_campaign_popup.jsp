<%@page import="java.util.ArrayList"%>
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
        WebBusinessObject campaignWbo = (WebBusinessObject) request.getAttribute("campaignWbo");
        ArrayList<WebBusinessObject> clientsList = (ArrayList<WebBusinessObject>) request.getAttribute("clientsList");

        String stat = (String) request.getSession().getAttribute("currentMode");
        String dir;
        if (stat.equals("En")) {
            dir = "LTR";
        } else {
            dir = "RTL";
        }
    %>
    <head>
        <script type="text/javascript">
            var oTable;
            $(document).ready(function () {
                oTable = $('#clientsPopup').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    iDisplayLength: 10,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);

                $("#searchFrom,#searchTo").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
            });
            function selectAll(obj) {
                $("input[name='popupClientID']").prop('checked', $(obj).is(':checked'));
            }
        </script>
        <style>

        </style>
    </head>
    <body>
        <table class="blueBorder" align="center" dir="rtl" id="code" cellpadding="0" cellspacing="0" width="450" style="border-width: 1px; border-color: white; display: block;" >
            <tr>
                <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px">
                    <b><font size=3 color="white"><fmt:message key="fromDate"/></b>
                </td>
                <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px">
                    <b><font size=3 color="white"><fmt:message key="toDate"/></b>
                </td>
            </tr>
            <tr>
                <td bgcolor="#dedede" valign="middle">
                    <input type="text" style="width:190px" id="searchFrom" name="searchFrom" size="20" maxlength="100" readonly="true"
                           value="<%=request.getAttribute("fromDate") == null ? "" : request.getAttribute("fromDate")%>"/>
                </td>
                <td bgcolor="#dedede" valign="middle">
                    <input type="text" style="width:190px" id="searchTo" name="searchTo" size="20" maxlength="100" readonly="true"
                           value="<%=request.getAttribute("toDate") == null ? "" : request.getAttribute("toDate")%>"/>
                </td>
            </tr>
        </table>
        <br/>
        <div style="width: 95%;margin-right: auto;margin-left: auto;" id="showClients">
            <table align="center" dir="<fmt:message key="direction"/>" width="100%" id="clientsPopup" style="">
                <thead>
                    <tr>
                        <th style="color: #005599 !important;font-size: 14px; font-weight: bold;"><input type="checkbox" onclick="JavaScript: selectAll(this);" /> </th>
                        <th style="color: #005599 !important;font-size: 14px; font-weight: bold;"><fmt:message key="clientNo"/>  </th>
                        <th style="color: #005599 !important;font-size: 14px; font-weight: bold;"><fmt:message key="clientname"/>  </th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (WebBusinessObject wbo : clientsList) {
                    %>
                    <tr style="cursor: pointer" id="row">
                        <td>
                            <input type="checkbox" name="popupClientID" value="<%=wbo.getAttribute("id")%>" />
                        </td>
                        <TD>
                            <%=wbo.getAttribute("clientNO")%>
                        </TD>
                        <TD>
                            <%=wbo.getAttribute("name")%>
                        </TD>
                    </tr>
                    <%}%>
                </tbody>
            </TABLE>
        </div>
        <br/>
        <script type="text/javascript">
        </script>
    </body>
</html>