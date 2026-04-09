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
          
        %>
        <script>
            var oTable;
            $(document).ready(function () {
                oTable = $('#tools').dataTable({
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
               String attname= (String)pageContext.getAttribute("attname"); 
              String attValue = (String) channelWbo.getAttribute(attname)+" "; 
                %>
                        <b><%=channelWbo != null ? attValue : ""%></b>
                        <input type="hidden" id="code" name="code" value="<%=channelWbo != null ? channelWbo.getAttribute("type_code") : ""%>"/>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: <fmt:message key="textalign" />" class='td'>
                        <b>
                        <fmt:message key="name" />
                        </b>
                    </td>
                    <td style="text-align: <fmt:message key="textalign" />" class='td'>
                        <input type="text" style="width:200px" name="arabic_name" id="arabicName" size="33" value="" maxlength="255"/>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: <fmt:message key="textalign" />" class='td'>
                        <b>
                         <fmt:message key="permenant" />
                        </b>
                    </td>
                    <td style="text-align: <fmt:message key="textalign" />"class='td'>
                        <input type="checkbox" id="forever" name="forever" value="1"/>
                    </td>
                </tr>
            </table>
        </div>
    </body>
</html>
