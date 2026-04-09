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
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
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
            <table class="blueBorder" id="tools" align="center" dir=<fmt:message key="direction" /> width="100%" cellpadding="0" cellspacing="0">
                <thead>
                    <tr>
                        <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; color:white; font-size:14px"><b><fmt:message key="arabic_name" /></b></th>
                        <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; color:white; font-size:14px"><b><fmt:message key="english_name" /></b></th>
                        <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; color:white; font-size:14px"><b><fmt:message key="permenant" /> ?</b></th>
                    </tr>
                </thead>  
                <tbody  id="planetData2">
                    <%
                        if (data != null && data.size() > 0) {
                            for (WebBusinessObject wbo : data) {
                    %>
                    <tr style="padding: 1px;" id="row<%=wbo.getAttribute("id")%>">
                        <td>
                            <%=wbo.getAttribute("arabicName")%>
                        </td>
                        <td>
                            <%=wbo.getAttribute("englishName")%>
                        </td>
                        <td>
                                <%if("1".equals(wbo.getAttribute("isForever")) ) {%>
                                  <fmt:message key="yes" />
                            <% } else {%>
                            <fmt:message key="no" />
                        </td>
                    </tr>
                    <%}
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </body>
</html>
