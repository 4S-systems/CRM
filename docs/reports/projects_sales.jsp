<%@page import="java.text.DecimalFormat"%>
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
    <fmt:setBundle basename="Languages.Units.Units"  />
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<WebBusinessObject> projectsList = (ArrayList<WebBusinessObject>) request.getAttribute("projectsList");
        String fromDate = request.getAttribute("fromDate") != null ? (String) request.getAttribute("fromDate") : "";
        String toDate = request.getAttribute("toDate") != null ? (String) request.getAttribute("toDate") : "";
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align, dir, style = null;
        String sTitle;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            sTitle = "Projects' Sales";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            sTitle = "مبيعات المشروعات";
        }
    %>
    <head>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>

        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
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
//                $("#fromDate,#toDate").datepicker({
//                    maxDate: "+d",
//                    changeMonth: true,
//                    changeYear: true,
//                    dateFormat: 'yy-mm-dd'
//                });
            });
            function openInNewWindow(url) {
                var win = window.open(url, '_blank');
                win.focus();
            }
            function changeColor(status, obj) {
                if('on' === status) {
                    $(obj).css("background-color", "#f7f4b8");
                } else {
                    $(obj).css("background-color", "white");
                }
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
                            </td>
                        </tr>
                    </table>
                </legend>
                <!--form name="CLASSIFICATION_FORM" action="<%=context%>/ReportsServletThree?op=clientClassificationReport" method="POST">
                    <br/>
                    <table class="blueBorder" align="center" dir="rtl" id="code" cellpadding="0" cellspacing="0" width="650" style="border-width: 1px; border-color: white; display: block;" >
                        <tr>
                            <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px">
                                <b><font size=3 color="white"><fmt:message key="fromdate"/></b>
                            </td>
                            <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px">
                                <b><font size=3 color="white"><fmt:message key="todate"/></b>
                            </td>
                        </tr>
                        <tr>
                            <td bgcolor="#dedede" valign="middle">
                                <input type="text" style="width:190px" id="fromDate" name="fromDate" size="20" maxlength="100" readonly="true"
                                       value="<%=fromDate%>"/>
                            </td>
                            <td bgcolor="#dedede" valign="middle">
                                <input type="text" style="width:190px" id="toDate" name="toDate" size="20" maxlength="100" readonly="true"
                                       value="<%=toDate%>"/>
                            </td>
                        </tr>
                        <tr>
                            <td bgcolor="#dedede" valign="middle" colspan="2">
                                <input type="submit" value="<fmt:message key="search" />" class="button" style="margin: 10px;"/>
                            </td>
                        </tr>
                    </table>
                    <br/>
                </form-->
                <%
                    if (projectsList != null) {
                %>
                <div style="width: 87%;margin-right: auto;margin-left: auto;">
                    <table align="<%=align%>" dir='<fmt:message key="direction"/>' width="100%" id="clients" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;"><fmt:message key="project"/></th>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;"><fmt:message key="available"/></th>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;"><fmt:message key="sold"/></th>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;"><fmt:message key="reserved"/></th>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;"><fmt:message key="hidden"/></th>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;"><fmt:message key="total"/> </th>
                                <th style="color: #005599 !important; font-size: 14px; font-weight: bold;"><fmt:message key="percent"/> </th>
                            </tr>
                        <thead>
                        <tbody>
                            <%
                                double sold, total, available, reserved, hidden;
                                double avaTotal = 0, solTotal = 0, resTotal = 0, hidTotal = 0, grandTotal = 0;
                                DecimalFormat df = new DecimalFormat("#");
                                for (WebBusinessObject projectWbo : projectsList) {
                                    sold = projectWbo.getAttribute("sold") != null ? Double.parseDouble(projectWbo.getAttribute("sold") + "") : 0;
                                    total = projectWbo.getAttribute("total") != null ? Double.parseDouble(projectWbo.getAttribute("total") + "") : 0;
                                    available = projectWbo.getAttribute("available") != null ? Double.parseDouble(projectWbo.getAttribute("available") + "") : 0;
                                    reserved = projectWbo.getAttribute("reserved") != null ? Double.parseDouble(projectWbo.getAttribute("reserved") + "") : 0;
                                    hidden = projectWbo.getAttribute("hide") != null ? Double.parseDouble(projectWbo.getAttribute("hide") + "") : 0;
                                    avaTotal += available;
                                    solTotal += sold;
                                    resTotal += reserved;
                                    hidTotal += hidden;
                                    grandTotal += total;
                            %>
                            <tr style="cursor: pointer;" id="row" onmouseover="JavaScript: changeColor('on', this);"
                                onmouseout="JavaScript: changeColor('off', this);">
                                <td>
                                    <b><a target="searchTab" href="<%=context%>/SearchServlet?op=getUnitByProject&projects=<%=projectWbo.getAttribute("projectID")%>&search=unitNo"><%=projectWbo.getAttribute("projectName") != null ? projectWbo.getAttribute("projectName") : ""%></a></b>
                                </td>
                                <td>
                                    <b><%=df.format(available)%></b>
                                </td>
                                <td>
                                    <b><%=df.format(sold)%></b>
                                </td>
                                <td>
                                    <b><%=df.format(reserved)%></b>
                                </td>
                                <td>
                                    <b><%=df.format(hidden)%></b>
                                </td>
                                <td>
                                    <b><%=df.format(total)%></b>
                                </td>
                                <td style="background-color: #aefcfc;">
                                    <b><%=df.format((sold / total) * 100.0)%> %</b>
                                </td>
                            </tr>
                            <%}%>
                        </tbody>
                        <tfoot>
                            <tr>
                                <th>
                                    <b><fmt:message key="total"/></b>
                                </th>
                                <th>
                                    <b><%=df.format(avaTotal)%></b>
                                </th>
                                <th>
                                    <b><%=df.format(solTotal)%></b>
                                </th>
                                <th>
                                    <b><%=df.format(resTotal)%></b>
                                </th>
                                <th>
                                    <b><%=df.format(hidTotal)%></b>
                                </th>
                                <th>
                                    <b><%=df.format(grandTotal)%></b>
                                </th>
                                <th style="background-color: #aefcfc;">
                                    <b><%=df.format((solTotal / grandTotal) * 100.0)%> %</b>
                                </th>
                            </tr>
                        </tfoot>
                    </table>
                </div>
                <%
                    }
                %>
                <br/><br/>
            </fieldset>
        </form>
    </body>
</html>     